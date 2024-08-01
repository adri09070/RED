Class {
	#name : 'RedDebuggerServerTest',
	#superclass : 'RedDebuggerTestCase',
	#instVars : [
		'masterNotification'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'tests' }
RedDebuggerServerTest >> testDebuggerAt [

	debuggerServer registerNewDebugger: debugger.
	self
		assert: (debuggerServer debuggerAt: debugger debugSessionHash)
		identicalTo: debugger
]

{ #category : 'tests' }
RedDebuggerServerTest >> testNewRemoteDebuggerNotificationFor [

	| notification |
	notification := debuggerServer newRemoteDebuggerNotificationFor: debugger.
	self assert: notification class identicalTo: RedNewRemoteDebugger.
	self
		assert: notification sessionHash
		equals: debugger debugSessionHash.
	self
		assert: notification sessionDescription
		equals: debugger interruptedContext printString
]

{ #category : 'tests' }
RedDebuggerServerTest >> testNotifyMasterForNewOpenedDebugger [

	masterServer
		withServerDo: [ :server | 
			debuggerServer notifyMasterForNewOpenedDebugger: debugger.
			self assertNewRemoteDebuggerAnnouncement:
				masterServer masterNotification ]
		route: 'newDebugger'
		port: RedDebuggerServer remoteDebuggerMasterPort
]

{ #category : 'tests' }
RedDebuggerServerTest >> testRegisterAndNotifyNewDebugger [

	masterServer
		withServerDo: [ 
		debuggerServer registerAndNotifyNewDebugger: debugger ]
		route: 'newDebugger'
		port: RedDebuggerServer remoteDebuggerMasterPort.

	self
		assert: (debuggerServer debuggerAt: debugger debugSessionHash)
		identicalTo: debugger.

	self assertNewRemoteDebuggerAnnouncement:
		masterServer masterNotification
]

{ #category : 'tests' }
RedDebuggerServerTest >> testRegisterNewDebugger [

	self assertEmpty: debuggerServer debuggers.

	debuggerServer registerNewDebugger: debugger.
	self
		assert: (debuggerServer debuggers at: debugSession hash)
		identicalTo: debugger
]

{ #category : 'tests' }
RedDebuggerServerTest >> testRemoveAndNotifyDebugger [

	self assertEmpty: debuggerServer debuggers.

	debuggerServer registerNewDebugger: debugger.

	self
		assert: (debuggerServer debuggerAt: debugger debugSessionHash)
		identicalTo: debugger.

	masterServer
		withServerDo: [
		debuggerServer removeAndNotifyDebugger: debugger debugSessionHash ]
		route: 'closedDebugger'
		port: RedDebuggerServer remoteDebuggerMasterPort.

	self assertEmpty: debuggerServer debuggers.

	masterNotification := masterServer masterNotification.

	self
		assert: masterNotification class
		identicalTo: RedRemoteDebuggerClosed.
	self
		assert: masterNotification sessionHash
		identicalTo: debugger debugSessionHash.
	self assert: masterNotification remoteUrl equals: debuggerServer url
]

{ #category : 'tests' }
RedDebuggerServerTest >> testRemoveDebugger [

	self assertEmpty: debuggerServer debuggers.
	
	debuggerServer registerNewDebugger: debugger.
	self denyEmpty: debuggerServer debuggers.
	
	debuggerServer removeDebugger: debugger debugSessionHash.
	self assertEmpty: debuggerServer debuggers
]

{ #category : 'tests' }
RedDebuggerServerTest >> testRunningServer [
		
	self assert: debuggerServer server isRunning.
	self assert: debuggerServer server isListening.
	
	RedDebuggerServer reset.
	self deny: debuggerServer server isRunning.
]
