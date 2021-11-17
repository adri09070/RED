Class {
	#name : #RedDebuggerTest,
	#superclass : #TestCase,
	#instVars : [
		'debugSession',
		'debugger',
		'debuggerServer',
		'masterServer'
	],
	#category : #'Red-Tests'
}

{ #category : #running }
RedDebuggerTest >> setUp [

	super setUp.

	RedDebuggerServer reset.
	debuggerServer := RedDebuggerServer current.

	debugSession := StTestDebuggerProvider new
		                debuggerWithRecursiveContext session.
	debugSession stepInto.
	debugSession stepInto.
		
	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.
	
	masterServer := RedMasterTestServer new
]

{ #category : #running }
RedDebuggerTest >> tearDown [

	debugger debugSession terminate.

	super tearDown
]

{ #category : #tests }
RedDebuggerTest >> testDebuggerRegistration [

	masterServer withServerDo: [ debugger initialize ].

	self
		assert: (debuggerServer debuggerAt: debugger debugSessionHashString)
		identicalTo: debugger.

	self
		assert: masterServer masterNotification first
		equals: debugger debugSessionHashString.
	self
		assert: masterServer masterNotification second
		equals: debugger interruptedContext printString
]

{ #category : #tests }
RedDebuggerTest >> testDefaultDebuggerRank [
	self assert: RedDebugger defaultDebuggerRank equals: 10
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
RedDebuggerTest >> testRestart [
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
