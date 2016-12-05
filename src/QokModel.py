#coding: utf-8
from PySide import QtCore
from Rest import *
from datetime import datetime, timedelta
#import logging
#import Logga

class QokModel(QtCore.QObject):

	callbackSignal = QtCore.Signal(str,str)#item,itemState)

	def __init__(self, view):
		QtCore.QObject.__init__(self)
		#self.log = logging.getLogger('qok.qokmodel')
		self.view = view
		#print type(view)
		#self.root = view.rootObject()
		#print type(self.root)
		self.rest= Rest()
		#self.rest= Rest('127.0.0.1',8080)
		self.rest= Rest('192.168.1.11',8080)
		#self.rest= Rest('jasonhector.no-ip.biz',8080)
		self.outstandingCbs=0
		
		#QtCore.QObject.connect(button, QtCore.SIGNAL ('clicked()'), someFunc)
		#self.callbackSignal.emit()


	@QtCore.Slot(str,str)
	def setItemValue(self, item,value):
 		#set rest item value
 		# value received as true and false - convert to oh type of string ON OFF
 		if value=='true':
 			#print('calling rest.setItemState - ON')
 			self.rest.setItemCommand(item, "ON")
 			self.rest.setItemState(item, "ON")
 		elif value=='false':
 			#print('calling rest.setItemState - OFF')
 			self.rest.setItemCommand(item, "OFF")
 			self.rest.setItemState(item, "OFF")
 		else:
 			self.rest.setItemCommand(item, value)

 	@QtCore.Slot(str,str,result=str)
 	def getItemValue(self,item,lPoll):
 		if lPoll== 'true': 
 			longPoll=True
 		else:
 			longPoll=False
 		#get rest item value
 		try:
 			self.rest.getItemState(item, self.callback, isLongPoll=longPoll)
 			self.outstandingCbs = self.outstandingCbs +1
 			#print('itemState=%s'%itemState)
 			#return self.postProcess(item, itemState)
 		except Exception, ex:
			#print ('ex: '+str(ex.args))
			print ex
			return ''

	@QtCore.Slot(str,result=str)
 	def getItemValue(self,item):
 		#get rest item value
 		try:
 			itemState=self.rest.getItemState(item)
 			self.outstandingCbs = self.outstandingCbs +1
 			#print('itemState=%s'%itemState)
 			return self.postProcess(item, itemState)
 		except Exception, ex:
			#print ('ex: '+str(ex.args))
			print ex
			return ''

 	@QtCore.Slot(str,str,result=str)
 	def getItemValueForToggle(self,item, lPoll):
 		if lPoll== 'true': 
 			longPoll=True
 		else:
 			longPoll=False
 		#get rest item value
 		try:
 			self.rest.getItemState(item, self.callback, isLongPoll=longPoll)
 			self.outstandingCbs = self.outstandingCbs +1
 			#print('itemState=%s'%itemState)
 			
 		except Exception, ex:
			#print ('ex: '+str(ex.args))
			print ex
			return ''
 	
	def callback(self, item, itemState):
		#postprocess data returned from callback
		self.outstandingCbs = self.outstandingCbs -1
		print('outstanding Cbs: %s'%self.outstandingCbs)
		postProcessed=self.postProcess(item, itemState)
		#fire a qml signal to a slot in qml
		#self.log(' callback>>> %s : %s'%(item, postProcessed))
		self.callbackSignal.emit(str(item),str(postProcessed))

 	def postProcess(self,item, itemState):
		#check each of the items and see if a mapping or unit apply or 
		#other should be applied to the itemState
		#print('item=%s'%item)
		#print('itemState=%s'%itemState)
		#if item=='tempMin0': print('item=%s'%item[:-1])

		if itemState=='Uninitialized' or itemState=='Undefined': itemState='.'


		if item=='m201_rly1' or item=='m201_rly2':
			if itemState=="ON" or itemState=="1" or itemState==1:
 				return 'true'
 			else:
 				return 'false'
		elif item=='almArmed':
			#map from int to text
			map={0:'disarmed',1:'armed',2:'arming..'}
			if type(itemState)==int: 
				return map[int(itemState)]
			else:
				return '.'
		elif item=='ct1_realPower' or item=='ct2_realPower' or item=='ct4_realPower' or item=='ct5_realPower':
			#strip decimal and apply W units
			return itemState.split('.')[0]+'W'
		elif item=='tempCurrent':
			#apply C units
			return itemState.split('.')[0]#+u"\u00B0"+'C'
		elif item=='wPrecipitation':
			#apply % units
			return itemState.split('.')[0]+'%'
		elif item[:-1]=='tempMin' or item[:-1]=='tempMax':
			#strip decimal
			return itemState.split('.')[0]
		elif item=='wWindSpeed' or item=='wWindgust':
			#strip decimal
			return itemState.split('.')[0]
		elif item=='unitsNow':
			#strip decimal
			return itemState.split('.')[0]
		elif item=='sunriseTime' or item=='sunsetTime':
			#strip off the date
			parts=itemState.split('T')
			if len(parts) >1: return parts[1][:-3]
			else:	return '.' 
		else:	
			#default for those iem not done yet
			return itemState

	@QtCore.Slot(str,result=str)
	def getWeatherIcon(self, condition):
		path='../assets/weather/'
		if condition=="Partly Cloudy": return path+'daytime/partlycloudy.gif'
		elif condition=="Clear": return path+'daytime/clear.gif'
		elif condition=="Rain": return path+'daytime/chancerain.gif'
		elif condition=="Chance of Rain": return path+'daytime/chancerain.gif'
		elif condition=="Overcast": return path+'daytime/fog.gif'
		elif condition=="Scattered Clouds": return path+'daytime/cloudy.gif'
		elif condition=="Mostly Cloudy": return path+'daytime/fog.gif'
		else: self.log('image not found for %s'%condition)

	@QtCore.Slot(int,result=str)
	def getDaysAhead(self, ahead):
		#get date
		dt=datetime.now()
		#get + date
		ndt=dt+timedelta(days=ahead)
		#return format with only the day
		return ndt.strftime('%a')
	
	@QtCore.Slot(str)
	def log(self, txt):
		print(txt)

if __name__ == '__main__':
	qm=QokModel()
	print qm.getItemValue('almArmed')
