Class {
	#name : #RedDebuggerServerTest,
	#superclass : #RedDebuggerTestCase,
	#instVars : [
		'masterNotification'
	],
	#category : #'Red-Tests'
}

{ #category : #tests }
RedDebuggerServerTest >> testDebuggers [

	self assertEmpty: debuggerServer debuggers.

	debuggerServer registerNewDebugger: debugger.
	self
		assert: (debuggerServer debuggerAt: debugSession hash)
		identicalTo: debugger
]

{ #category : #tests }
RedDebuggerServerTest >> testNotifyMasterForNewOpenedDebugger [

	masterServer
		withServerDo: [ :server | 
			debuggerServer notifyMasterForNewOpenedDebugger: debugger.
			self assertNewRemoteDebuggerAnnouncement:
				masterServer masterNotification ]
		route: 'newDebugger'
		port: RedDebuggerServer remoteDebuggerMasterPort
]

{ #category : #tests }
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

{ #category : #tests }
RedDebuggerServerTest >> testRunningServer [
		
	self assert: debuggerServer server isRunning.
	self assert: debuggerServer server isListening.
	
	RedDebuggerServer reset.
	self deny: debuggerServer server isRunning.
]
