import requests
import threading as thr
import logging
import Logga
#import betterthreads as bthr

class LongPollRequester(thr.Thread):

    def __init__(self,rest, url, restType, pollingHeaders, callback):#, timeout):
    	thr.Thread.__init__(self)
        self.log = logging.getLogger('ohrest.longpollrequester')
    	self.rest = rest
        self.url = url
    	self.restType = restType
    	self.cont = True
    	self.callback = callback
    	self.pollingHeaders = pollingHeaders
        self.name = self.url.split('/')[-1]
        #self.timeout = timeout


    def run(self):
        #LOOP SHOULD START HERE!!
        #while self.cont:
        #self.log.info("%s %s"%(thr.currentThread().getName(),'Starting'))
        #self.log.info('[%s-%s] pre- requests...'%(thr.currentThread().getName(),self.url.split('/')[-1]))
        #BLOCKING METHOD
        self.req = requests.get(self.url, params={'type':self.restType},headers=self.pollingHeaders())#, timeout=self.timeout)
        #req = requests.get(url, params=payload,headers=self.polling_header())
        if self.req.status_code != requests.codes.ok:
            self.req.raise_for_status()
        #delay for time
        #sleep(self.timeToSleep)
        #self.log.info('[%s-%s] post- requests...'%(thr.currentThread().getName(),self.url.split('/')[-1]))
        jason= self.req.json()
        self.log.info('[%s-%s] %s : %s'%(thr.currentThread().getName(),self.name, jason['name'], jason['state']))
        #self.log.info("%s"%(thr.currentThread().getName()+' Ending'))
        self.rest.threads.pop(self.name)
        self.callback(jason['name'],jason['state'])
        
        
    def shutdown(self):
        self.log.info('[%s-%s] shutting down..'%(bthr.currentThread().getName(),self.name))

if __name__=='__main__':
    #lpr=LongPollRequest().start()
    pass