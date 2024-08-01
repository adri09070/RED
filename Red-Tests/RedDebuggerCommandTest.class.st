Class {
	#name : 'RedDebuggerCommandTest',
	#superclass : 'RedDebuggerTestCase',
	#instVars : [
		'command',
		'result'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'running' }
RedDebuggerCommandTest >> setUp [

	super setUp.

	debuggerServer registerNewDebugger: debugger
]

{ #category : 'tests' }
RedDebuggerCommandTest >> testProceedCommand [

	| process res resultContents |
	process := [ res := 1 ] newProcess.

	debugSession terminate.
	debugSession := (StTestDebuggerProvider new debuggerWithContext:
		                 process suspendedContext) session.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            basicServer: debuggerServer;
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

{ #category : 'tests' }
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

{ #category : 'tests' }
RedDebuggerCommandTest >> testStackCommand [
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

{ #category : 'tests' }
RedDebuggerCommandTest >> testStepIntoCommand [
	|resultContents|
	debugSession stepInto.
	debugSession stepInto.
	debugSession stepInto.
	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #recursiveMethodCall.
		
	command := RedDebuggerIntoCommand new 
		contextHash: debugger interruptedContext hash;
		debugSessionHash: debugSession hash;
		yourself.
	result := command sendTo: debuggerServer url.
	resultContents := STON fromString: result contents.
	
	self
		assert: debugger interruptedContext method
		identicalTo: StTestDebuggerProvider >> #intermediateRecursiveMethodCall.
	self assertStackModel: resultContents modelsContextStacks: debugSession stack
]

{ #category : 'tests' }
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

{ #category : 'tests' }
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
