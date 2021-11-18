Class {
	#name : #RedDebuggerServerTest,
	#superclass : #TestCase,
	#instVars : [
		'debuggerServer',
		'debugSession',
		'debugger',
		'masterNotification',
		'masterServer'
	],
	#category : #'Red-Tests'
}

{ #category : #running }
RedDebuggerServerTest >> setUp [

	super setUp.

	RedDebuggerServer reset.
	debuggerServer := RedDebuggerServer current.

	debugSession := StTestDebuggerProvider new
		                debuggerWithRecursiveContext session.
	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.

	masterServer := RedMasterTestServer new
]

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
	
	masterServer withServerDo: [ :server | 
		debuggerServer notifyMasterForNewOpenedDebugger: debugger.
		self
			assert: masterServer masterNotification first
			equals: debugger debugSessionHash.
		self
			assert: masterServer masterNotification second
			equals: debugger interruptedContext printString ]
]

{ #category : #tests }
RedDebuggerServerTest >> testRegisterAndNotifyNewDebugger [
	
	masterServer withServerDo: [ debuggerServer registerAndNotifyNewDebugger: debugger].

	self
		assert: (debuggerServer debuggerAt: debugger debugSessionHash)
		identicalTo: debugger.

	self
		assert: masterServer masterNotification first
		equals: debugger debugSessionHash.
	self
		assert: masterServer masterNotification second
		equals: debugger interruptedContext printString
]

{ #category : #tests }
RedDebuggerServerTest >> testRunningServer [
		
	self assert: debuggerServer server isRunning.
	self assert: debuggerServer server isListening.
	
	RedDebuggerServer reset.
	self deny: debuggerServer server isRunning.
]
