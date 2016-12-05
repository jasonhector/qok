from PySide import QtCore

class Console(QtCore.QObject):
	@QtCore.Slot(str)
	def outputStr(self, s):
 		print s