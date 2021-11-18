Class {
	#name : #RedDebuggerCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'debugSession',
		'debugger',
		'debuggerServer',
		'command',
		'result'
	],
	#category : #'Red-Tests'
}

{ #category : #asserting }
RedDebuggerCommandTest >> assertModel: aModel modelsContext: aContext [

	self flag: 'duplicated from RedRemoteContextModelTest'.

	self assert: aModel contextHash equals: aContext hash.
	self
		assert: aModel methodSelector
		equals: (aContext method isCompiledBlock
				 ifTrue: [ aContext method sourceNode sourceCode ]
				 ifFalse: [ aContext method selector ]).
	self
		assert: aModel receiverClassName
		equals: (RedRemoteContextModel basicNew printReceiverClassInContext: aContext).
	self assert: aModel packageName equals: aContext method package name
]

{ #category : #tests }
RedDebuggerCommandTest >> assertStackModel: aStackModel modelsContextStacks: aStackOfContexts [

	self assert: aStackModel size equals: aStackOfContexts size.
	1 to: aStackModel size do: [ :i | 
		self
			assertModel: (aStackModel at: i)
			modelsContext: (debugSession stack at: i) ]
]

{ #category : #running }
RedDebuggerCommandTest >> setUp [

	super setUp.

	RedDebuggerServer reset.
	debuggerServer := RedDebuggerServer current.

	debugSession := StTestDebuggerProvider new
		                debuggerWithRecursiveContext session.
	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.
	debuggerServer registerNewDebugger: debugger
]

{ #category : #running }
RedDebuggerCommandTest >> tearDown [

	debugger debugSession terminate.

	super tearDown
]

{ #category : #tests }
RedDebuggerCommandTest >> testProceedCommand [
	|process res resultContents |			
	process := [res := 1] newProcess.
	
	debugSession terminate.	
	debugSession := 
		(StTestDebuggerProvider new debuggerWithContext: process suspendedContext) session.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.
	debuggerServer registerNewDebugger: debugger.
	
	command := RedDebuggerProceedCommand new 
		contextHash: debugger interruptedContext hash;
		debugSessionHash: debugSession hash;
		yourself.
	result := command sendTo: debuggerServer url.
	resultContents := STON fromString: result contents.

	self assert: res equals: 1.
	self assert: debugSession interruptedContext isNil.
	self assert: resultContents isEmpty
]

{ #category : #tests }
RedDebuggerCommandTest >> testRestartCommand [
	|topContext topPC resultContents|	
	debugSession stepInto.
	debugSession stepInto.
		
	topContext := debugger interruptedContext.
	topPC := topContext pc.	

	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.	

	debugSession stepInto.
	debugSession stepInto.
	
	self
		assert: debugger interruptedContext method
		identicalTo:
		StTestDebuggerProvider >> #intermediateRecursiveMethodCall.
	self deny: debugger interruptedContext identicalTo: topContext.
	self deny: topContext pc equals: topPC.
	
	command := RedDebuggerRestartCommand new 
		contextHash: topContext hash;
		debugSessionHash: debugSession hash;
		yourself.
	result := command sendTo: debuggerServer url.
	resultContents := STON fromString: result contents.
	
	self assert: debugger interruptedContext identicalTo: topContext.
	self assert: debugger interruptedContext pc equals: topPC
	
]

{ #category : #tests }
RedDebuggerCommandTest >> testStepIntoCommand [
	|resultContents|
	debugSession stepInto.
	debugSession stepInto.
	debugSession stepInto.
	debugSession stepInto.
	debugSession stepInto.
	debugSession stepInto.
	debugSession stepInto.
			
	command := RedDebuggerStackCommand new 
		contextHash: debugger interruptedContext hash;
		debugSessionHash: debugSession hash;
		yourself.
	result := command sendTo: debuggerServer url.
	resultContents := STON fromString: result contents.	

	self assertStackModel: resultContents modelsContextStacks: debugSession stack
]

{ #category : #tests }
RedDebuggerCommandTest >> testStepOverCommand [
	|resultContents statements method|
	method := StTestDebuggerProvider >> #recursiveMethodCall.
	statements := method ast statements.
	debugSession stepInto.
	debugSession stepInto.
	self
		assert: (method sourceNodeForPC: debugger interruptedContext pc)
		identicalTo: statements first.

	command := RedDebuggerOverCommand new 
		contextHash: debugger interruptedContext hash;
		debugSessionHash: debugSession hash;
		yourself.
	result := command sendTo: debuggerServer url.
	resultContents := STON fromString: result contents.
	
	self
		assert: (method sourceNodeForPC: debugger interruptedContext pc)
		identicalTo: statements last value.
	
	self assertStackModel: resultContents modelsContextStacks: debugSession stack
]

{ #category : #tests }
RedDebuggerCommandTest >> testStepThroughCommand [
	|ast resultContents |	
	debugSession terminate.	
	debugSession := StTestDebuggerProvider new sessionForDebuggerTests.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            yourself.
	debuggerServer registerNewDebugger: debugger.
		
	debugger stepThrough: debugger interruptedContext.
	ast := debugger interruptedContext method sourceNodeForPC: debugger interruptedContext pc.
	self assert: ast isMessage.
	self assert: ast selector equals: #squared.
	self assert: ast receiver value equals: 1.
	
	command := RedDebuggerThroughCommand new 
		contextHash: debugger interruptedContext hash;
		debugSessionHash: debugSession hash;
		yourself.
	result := command sendTo: debuggerServer url.
	resultContents := STON fromString: result contents.

	ast := debugger interruptedContext method sourceNodeForPC: debugger interruptedContext pc.
	self assert: debugger interruptedContext method equals: (Number>>#squared).
	self assertStackModel: resultContents modelsContextStacks: debugSession stack
]
