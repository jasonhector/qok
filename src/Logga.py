import logging
import logging.handlers


# create logger with 'twxm'
log = logging.getLogger('ohrest')
log.setLevel(logging.DEBUG)
# create rotating file handler which logs even debug messages
rfh_debug = logging.handlers.RotatingFileHandler('../logs/debug.log',maxBytes=20000, backupCount=5)
rfh_debug.setLevel(logging.DEBUG)
#creates rotating file handler with info logs
rfh_info = logging.handlers.RotatingFileHandler('../logs/info.log',maxBytes=20000, backupCount=2)
rfh_info.setLevel(logging.INFO)
# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
# create formatter and add it to the handlers
formatter = logging.Formatter('[%(asctime)s-%(name)s-%(levelname)s-%(lineno)s] %(message)s')
rfh_debug.setFormatter(formatter)
rfh_info.setFormatter(formatter)
ch.setFormatter(formatter)
# add the handlers to the logger
log.addHandler(rfh_debug)
log.addHandler(rfh_info)
log.addHandler(ch)
