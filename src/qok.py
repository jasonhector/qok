#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      Marek
#
# Created:     26-01-2013
# Copyright:   (c) Marek 2013
# Licence:     <your licence>
#-------------------------------------------------------------------------------

from PySide import QtCore
from PySide import QtGui
from PySide import QtDeclarative
from QokModel import *
def main():
	app = QtGui.QApplication([])

	viewer = QtDeclarative.QDeclarativeView()
	context = viewer.rootContext()
	qokModel = QokModel(viewer)
	context.setContextProperty("qokModel",qokModel)
	#con is now available in the qml as con.outputStr('data')
	viewer.setSource("qok.qml")
	viewer.setWindowTitle("Openhab on Kobo")
	viewer.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)

	#root=viewer.rootObject()
	#print ('type=%s'%type(root))
	#qokModel.callbackSignal.connect(root.updateFromCallback)#qokModel.log)

	viewer.show()

	app.exec_()

if __name__ == '__main__':
	#change directory to src code
	
	main()

