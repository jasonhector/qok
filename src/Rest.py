
import requests
import base64
import logging
import Logga
from LongPollRequester import *
import argparse

class Rest():

	def __init__(self,host='192.168.0.11', port=8080, username='', password=''):
		self.log = logging.getLogger('ohrest.rest')
		self.openhab_host = host    
		self.openhab_port = port
		self.username = username
		self.password = password
		self.pollingHeaderId=0
		self.timeout = 60 #60 sec
		self.threads={}

	## SEND COMMAND TO ITEM
	def setItemCommand(self, key, value):
		""" Post a command to OpenHAB - key is item, value is command """
		url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
								  self.openhab_port, key)
		req = requests.post(url, data=value,
							  headers=self.basic_header())
		if req.status_code != requests.codes.ok:
			req.raise_for_status()
		else:
			self.log.debug("Setting Item Command: item=%s \t value=%s \n url=%s"% (key, value, url))

	## SET STATE OF AN ITEM
	def setItemState(self, key, value):
		""" Put a status update to OpenHAB  key is item, value is state """
		url = 'http://%s:%s/rest/items/%s/state'%(self.openhab_host,
								  self.openhab_port, key)
		req = requests.put(url, data=value, headers=self.basic_header())
		if req.status_code != requests.codes.ok:
			req.raise_for_status()  
		else:
			self.log.debug("Setting Item State: item=%s \t value=%s \n url=%s"% (key, value, url))

	#GET ITEM STATE
	def getItemState(self, name, callback, restType='json', isLongPoll=False):
		url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
									  self.openhab_port, name)
		if not isLongPoll:
			item =self.restRequest(url,restType)
			itemState= item['state']
			self.log.debug("Getting Item State: item=%s \t value=%s"% (name, itemState))
			callback(name, itemState)
		else:
			item =self.restRequest(url,restType, isLongPoll, callback)

	#getItem with a return type
	def getItemState(self, name, restType='json'):
		url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
									  self.openhab_port, name)
		item =self.restRequest(url,restType)
		itemState= item['state']
		self.log.debug("Getting Item State: item=%s \t value=%s"% (name, itemState))
		return itemState


	## GET AN ITEM (ALL OF IT)
	def getItem(self, name, restType='json',isLongPoll=False):
		""" Request updates for any item in group NAME from OpenHAB.
		Long-polling will not respond until item updates.
		"""
		# When an item in Group NAME changes we will get all items in the group 
		# and need to determine which has changed
		url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
									  self.openhab_port, name)
		item =self.restRequest(url,restType, isLongPoll)
		self.log.debug("Getting Item (entire item): item=%s \n value=%s"% (name, self.getpprint(item)))
		return item

	def getItems(self,restType='json'):
		'''return all the items'''
		url = 'http://%s:%s/rest/items'%(self.openhab_host,
									  self.openhab_port)
		items= self.restRequest(url,restType)
		self.log.debug("Getting Items (ALL): items=%s \n url=%s"% (self.getpprint(items), url))
		return items

	def getSitemap(self, name,restType='json', absolute=False):
		'''return all sitemaps'''
		if not absolute:
			url = 'http://%s:%s/rest/sitemaps/%s'%(self.openhab_host,
									  self.openhab_port, name)
		else:
			url = '%s'%(name)
		sitemap=self.restRequest(url,restType)
		self.log.debug("Sitemaps=%s \n url=%s"% (self.getpprint(sitemap), url))
		return sitemap

	def getSitemaps(self, restType='json'):
		'''return all sitemaps'''
		url = 'http://%s:%s/rest/sitemaps'%(self.openhab_host,
									  self.openhab_port)
		sitemaps=self.restRequest(url,restType)['sitemap']
		self.log.debug("Getting Sitemaps (ALL): Sitemaps=%s \n url=%s"% (self.getpprint(sitemaps), url))
		return sitemaps

	def getNumOfSitemaps(self, restType='json'):
		url = 'http://%s:%s/rest/sitemaps'%(self.openhab_host,self.openhab_port)
		sitemaps=self.restRequest(url,restType)
		numSitemaps=len(sitemaps['sitemap'])
		self.log.debug("Number of Sitemaps: #Sitemaps=%s \n url=%s"% (numSitemaps, url))
		return numSitemaps

	#standard request and return of replay
	def restRequest(self,url,restType,longPoll = False, callback=None):
		""" Request updates from OpenHAB.
		Long-polling will not respond until item updates.
		"""
		payload = {'type': restType}
		try:
			req=''
			if longPoll:
				lpr=LongPollRequester(self, url, payload, self.polling_header, callback)#, self.timeout)#.start()
				lpr.daemon=True		#so that threads terminate when main program not running
				self.threads[url.split('/')[-1]]=lpr
				lpr.start()

				#longPolllRequester wil handle the re
				return None
			else:
				req = requests.get(url, params=payload,
							  #headers={ 'Content-Type': 'text/plain' })
							  headers = self.basic_header())
							  #timeout = self.timeout)
							  #headers=self.polling_header())

				#print("req=%s"%req.content)
				if req.status_code != requests.codes.ok:
					req.raise_for_status()
				# Try to parse JSON response
				# At top level, there is type, name, state, link and members array
				jason = req.json()
				return jason
			#members = jason["members"]
			#for member in members:
			#	# Each member has a type, name, state and link
			#	name = member["name"]
			#	state = member["state"]
			#	do_publish = True
			#	# Pub unless we had key before and it hasn't changed
			#	if name in self.prev_state_dict:
			#		if self.prev_state_dict[name] == state:
			#			do_publish = False
			#	self.prev_state_dict[name] = state
			#	if do_publish:
			#		self.publish(name, state)
		except Exception, ex:
			print('url: '+url)
			print ('ex: '+str(ex.args))
			print(ex)	

	def longPollDefered(self, jason):
		pass

	## HTTP HEADER DEFINITION
	def polling_header(self):
		""" Header for OpenHAB REST request - polling """
		self.auth = base64.encodestring('%s:%s'
						 %(self.username, self.password)
						 ).replace('\n', '')

		#print ('self.auth: '+str(self.auth))
		if self.pollingHeaderId==255: self.pollingHeaderId=0
		self.pollingHeaderId = self.pollingHeaderId+1
		return {
			"Authorization" : "Basic %s" % self.auth,#self.cmd.auth,
			"X-Atmosphere-Transport" : "long-polling",
			"X-Atmosphere-tracking-id" : self.pollingHeaderId,#"1",#self.atmos_id,
			"X-Atmosphere-Framework" : "1.0",
			"Accept" : "application/json"}

	def basic_header(self):
		""" Header for OpenHAB REST request - standard """
		self.auth = base64.encodestring('%s:%s'
						 %(self.username, self.password)
						 ).replace('\n', '')
		return {
			  "Authorization" : "Basic %s" %self.auth,
			  "Content-type": "text/plain"}

	def pprint(self, dic, indnt=4):
		print self.getpprint(dic)

	def getpprint(self,dic, indnt=4):
		import json
		return json.dumps(dic, sort_keys=True, indent=indnt, separators=(' , ',' : '))

import time
if __name__ == '__main__':
	#orest = Rest("192.168.0.11",8080)
	#orest = Rest("192.168.2.11",8080)
	#orest.setItemState('_almStatus','1')
	#orest.get_status('_almStatus')
	#orest.pprint(orest.getSitemaps())
	#sm=orest.getSitemap('rest')
	#orest.getItem('xlights')
	#orr=orest.getSitemaps()
	#orest.getNumOfSitemaps()
	#orest.getItem('ct1_realPower',isLongPoll=True)
	#orest.getItem('ct1_realPower')
	#while True:
	#time.sleep(1)
	#print orest.getItemState('ten1')
	#	#print orest.getItemState('ct2_realPower')
	#	#orest.getItem('ct3_realPower')
	#	#orest.getItem('ct4_realPower')
	#	#orest.getItem('ct5_realPower')

	#ipaddress = "192.168.0.11"
	ipaddress = "192.168.2.11"
	ipaddress = "127.0.0.1"
	port = 8080
	parser = argparse.ArgumentParser(description='Python Rest API to Openhab')
	parser.add_argument('-ip','--ipaddress', type=str,default=ipaddress, help='IP address of the Openhab server')
	parser.add_argument('-p','--port',type=int, default=port,help='listening port of the Openhab server')
	parser.add_argument('-i','--interactive', action='store_true',help='run in interactive mode;\n can get item-> "state light"\n can set item-> "state light ON" \n can set command -> "cmd light TOGGLE"')
	parser.add_argument('-ss','--setState', type=str,help='set item state eg: light=ON')
	parser.add_argument('-sc','--setCommand', type=str,help='send Command to item eg: light=ON')
	parser.add_argument('-gs','--getState', type=str,help='get item state eg: light')

	args = parser.parse_args()
	#print args.interactive
	if args.interactive:
		print 'Interactive mode: "state" "state <item>" ; "state <item> <value>" ; "cmd <item> <value>"\n'
		while True:
			inp = raw_input('>>')
			r=Rest(args.ipaddress,args.port)
			#print '[rest connected > ',
			spl =inp.split()
			if inp=='':
				print 'nothing provided. Try again...'
			elif spl[0]=='cmd':
				r.setItemCommand(spl[1], spl[2])
				print '[ %s=%s ]'%(spl[1],spl[2])
			elif spl[0]=='state':
				if len(spl)==2:
					#get state
					st=r.getItemState(spl[1])
					print '[ %s=%s ]'%(spl[1],st)
				elif len(spl)==1:
					#get names of all items
					items = r.getItems()
					#print items
					for item in items['item']:
						#print item
						print '[ %s=%s ]'%(item['name'],item['state'])
				else:
					#set state
					r.setItemState(spl[1], spl[2])
					print '[ %s=%s ]'%(spl[1],spl[2])

	def cb(item, jason):
		print('--> callback item=%s'%item)
		print('--> callback jason=%s'%jason)


	r=Rest(ipaddress,port)
	r.getItemState('ct2_realPower',cb, isLongPoll=True)
	r.getItemState('ct1_realPower',cb, isLongPoll=True)
	#print r.getItem('ct1_realPower')