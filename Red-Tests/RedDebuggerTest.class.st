Class {
	#name : #RedDebuggerTest,
	#superclass : #RedDebuggerTestCase,
	#category : #'Red-Tests'
}

{ #category : #running }
RedDebuggerTest >> setUp [

	super setUp.

	debugSession stepInto.
	debugSession stepInto
]

{ #category : #tests }
RedDebuggerTest >> testDebuggerRegistration [

	masterServer withServerDo: [ debugger initialize ].

	self
		assert: (debuggerServer debuggerAt: debugger debugSessionHash)
		identicalTo: debugger.
	self assertNewRemoteDebuggerAnnouncement:
		masterServer masterNotification
]

{ #category : #tests }
RedDebuggerTest >> testDefaultDebuggerRank [
	self assert: RedDebugger defaultDebuggerRank equals: 10
]

{ #category : #tests }
RedDebuggerTest >> testFindContextFromHash [

	| stack |
	stack := debugger stack.
	self
		assert: (debugger findContextFromhash: stack first contextHash)
		identicalTo: debugSession stack first.
	self
		assert: (debugger findContextFromhash: stack second contextHash)
		identicalTo: debugSession stack second.

	self
		should: [ debugger findContextFromhash: 1234 ]
		raise: RedContextHashNotFound
]

{ #category : #tests }
RedDebuggerTest >> testInterruptedContext [

	self
		assert: debugger interruptedContext
		identicalTo: debugSession interruptedContext
]

{ #category : #tests }
RedDebuggerTest >> testProceed [
	|process result|	
	process := [result := 1] newProcess.
	
	debugSession terminate.	
	debugSession := 
		(StTestDebuggerProvider new debuggerWithContext: process suspendedContext) session.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.

	debugger proceed.
	self assert: result equals: 1.
	self assert: debugSession interruptedContext isNil
]

{ #category : #tests }
RedDebuggerTest >> testRestartContext [
	|topContext topPC|
	topContext := debugger interruptedContext.
	topPC := topContext pc.
	
	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
	
	debugger stepInto: debugger interruptedContext.
	debugger stepInto: debugger interruptedContext.
	
	self
		assert: debugger interruptedContext method
		identicalTo:
		StTestDebuggerProvider >> #intermediateRecursiveMethodCall.
	self deny: debugger interruptedContext identicalTo: topContext.
	self deny: topContext pc equals: topPC.
	
	debugger restartContext: topContext.
	self assert: debugger interruptedContext identicalTo: topContext.
	self assert: debugger interruptedContext pc equals: topPC
]

{ #category : #tests }
RedDebuggerTest >> testStack [

	|stack|
	stack := debugger stack.
	self assert: stack size equals: 2.
	self assert: stack first class equals: RedRemoteContextModel.
	self assert: stack second class equals: RedRemoteContextModel.
	self assert: stack first sender equals: stack second.
	
	self assert: stack first contextHash equals: debugSession stack first hash.
	self assert: stack second contextHash equals: debugSession stack second hash
]

{ #category : #tests }
RedDebuggerTest >> testStepInto [

	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
	
	debugger stepInto: debugger interruptedContext.
	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
	
	debugger stepInto: debugger interruptedContext.
	self
		assert: debugger interruptedContext method
		identicalTo:
		StTestDebuggerProvider >> #intermediateRecursiveMethodCall
]

{ #category : #tests }
RedDebuggerTest >> testStepOver [

	| statements method |
	method := StTestDebuggerProvider >> #recursiveMethodCall.
	statements := method ast statements.

	self
		assert: (method sourceNodeForPC: debugger interruptedContext pc)
		identicalTo: statements first.

	debugger stepOver: debugger interruptedContext.
	self
		assert: (method sourceNodeForPC: debugger interruptedContext pc)
		identicalTo: statements last value
]

{ #category : #tests }
RedDebuggerTest >> testStepThrough [

	|ast|
	debugSession terminate.	
	debugSession := StTestDebuggerProvider new sessionForDebuggerTests.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.
		
	debugger stepThrough: debugger interruptedContext.
	ast := debugger interruptedContext method sourceNodeForPC: debugger interruptedContext pc.
	self assert: ast isMessage.
	self assert: ast selector equals: #squared.
	self assert: ast receiver value equals: 1.
	
	debugger stepThrough: debugger interruptedContext.
	ast := debugger interruptedContext method sourceNodeForPC: debugger interruptedContext pc.
	self assert: debugger interruptedContext method equals: (Number>>#squared).
	
]
