Class {
	#name : 'RedRemoteDebuggerActionModelTest',
	#superclass : 'RedDebuggerTestCase',
	#instVars : [
		'client',
		'actionModel'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'factory method' }
RedRemoteDebuggerActionModelTest >> instantiateRemoteActionModelForDebugger [

	self assert: client registeredDebuggers size equals: 1.
	self assert:
		(client registeredDebuggers includesKey: debugger debugSessionHash).

	actionModel := RedRemoteDebuggerActionModel basicNew
		               client: client;
		               session:
			               (client registeredDebuggers at:
					                debugger debugSessionHash);
		               initialize
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> setUp [

	super setUp.
	debugSession
		stepInto;
		stepInto.
	client := RedDebuggerClient new.
	debuggerServer registerAndNotifyNewDebugger: debugger
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> tearDown [

	client stop.
	debuggerServer removeDebugger: debugger debugSessionHash.
	super tearDown
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testProceed [

	| process result dummyActionModel |
	process := [ result := 1 ] newProcess.

	debuggerServer removeAndNotifyDebugger: debugger debugSessionHash.
	debugSession terminate.
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     process suspendedContext) debuggerActionModel.
	debugSession := dummyActionModel session.
	dummyActionModel clear.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            basicServer: debuggerServer;
		            yourself.

	debuggerServer registerAndNotifyNewDebugger: debugger.
	self instantiateRemoteActionModelForDebugger.

	self assertCollection: actionModel stack equals: debugger stack.

	actionModel proceedDebugSession.

	self assert: result equals: 1.
	self assert: debugSession interruptedContext isNil
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testRemoteDebuggerActionModelInstantiation [

	self instantiateRemoteActionModelForDebugger.

	self
		assert: actionModel session
		identicalTo:
		(client registeredDebuggers at: debugger debugSessionHash).

	self assertCollection: actionModel stack equals: debugger stack
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testRestartContextKeepsSameStackAsLocalDebugger [

	| topContext topPC topModelContext context |
	self instantiateRemoteActionModelForDebugger.

	topPC := actionModel topContext pc.
	topContext := debugger interruptedContext.

	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
	self assertCollection: actionModel stack equals: debugger stack.

	actionModel
		stepInto: actionModel topContext;
		stepInto: actionModel topContext.

	topModelContext := actionModel topContext.
	context := debugger interruptedContext.
	[ topContext == context ] whileFalse: [
		topModelContext := topModelContext sender.
		context := context sender ].

	self
		assert: debugger interruptedContext method
		identicalTo:
		StTestDebuggerProvider >> #intermediateRecursiveMethodCall.
	self assertCollection: actionModel stack equals: debugger stack.
	self deny: topModelContext pc equals: topPC.

	actionModel restartContext: topModelContext.

	self assert: debugger interruptedContext identicalTo: topContext.
	self assert: debugger interruptedContext pc equals: topPC.
	self assertCollection: actionModel stack equals: debugger stack
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testStepIntoKeepsSameStackAsLocalDebugger [

	self instantiateRemoteActionModelForDebugger.

	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
	self assertCollection: actionModel stack equals: debugger stack.

	actionModel stepInto: actionModel topContext.

	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
	self assertCollection: actionModel stack equals: debugger stack.

	actionModel stepInto: actionModel topContext.

	self
		assert: debugger interruptedContext method
		identicalTo:
		StTestDebuggerProvider >> #intermediateRecursiveMethodCall.
	self assertCollection: actionModel stack equals: debugger stack
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testStepOverKeepsSameStackAsLocalDebugger [

	| statements method |
	self instantiateRemoteActionModelForDebugger.

	method := StTestDebuggerProvider >> #recursiveMethodCall.
	statements := method ast statements.

	self
		assert: (method sourceNodeForPC: debugger interruptedContext pc)
		identicalTo: statements first.
	self assertCollection: actionModel stack equals: debugger stack.

	actionModel stepOver: actionModel topContext.

	self
		assert: (method sourceNodeForPC: debugger interruptedContext pc)
		identicalTo: statements last value.
	self assertCollection: actionModel stack equals: debugger stack
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testStepThroughKeepsSameStackAsLocalDebugger [

	| ast |
	debugSession terminate.
	debugSession := StTestDebuggerProvider new sessionForDebuggerTests.

	debugger clear.
	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            server: debuggerServer;
		            yourself.
	
	self instantiateRemoteActionModelForDebugger.

	self assertCollection: actionModel stack equals: debugger stack.

	actionModel stepThrough: actionModel topContext.

	ast := debugger interruptedContext method sourceNodeForPC:
		       debugger interruptedContext pc.
	self assert: ast isMessage.
	self assert: ast selector equals: #squared.
	self assert: ast receiver value equals: 1.
	self assertCollection: actionModel stack equals: debugger stack.

	actionModel stepThrough: actionModel topContext.

	self
		assert: debugger interruptedContext method
		equals: Number >> #squared.
	self assertCollection: actionModel stack equals: debugger stack
]

{ #category : 'running' }
RedRemoteDebuggerActionModelTest >> testTopContext [

	self instantiateRemoteActionModelForDebugger.

	self assert: actionModel topContext equals: debugger stack first
]
