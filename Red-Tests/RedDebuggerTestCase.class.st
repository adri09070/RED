Class {
	#name : 'RedDebuggerTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'debugSession',
		'debugger',
		'debuggerServer',
		'masterServer'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'asserting' }
RedDebuggerTestCase >> assertModel: aCompiledCodeModel modelsCompiledCode: aCompiledCode [

	self
		assertCollection: aCompiledCodeModel bytecodes
		equals: aCompiledCode bytecodes.
	self
		assert: aCompiledCodeModel startPc
		equals: aCompiledCode initialPC.
	self assert: aCompiledCodeModel endPc equals: aCompiledCode endPC.
	self
		assert: aCompiledCodeModel sourceCode
		equals: aCompiledCode sourceCode.
	self
		assert: aCompiledCodeModel methodClassName
		equals: aCompiledCode methodClass name.
	self
		assert: aCompiledCodeModel methodSelector
		equals: aCompiledCode selector.
	self
		assert: aCompiledCodeModel packageName
		equals: aCompiledCode package name.
	self
		assert: aCompiledCodeModel isBlock
		identicalTo: aCompiledCode isCompiledBlock.
	self
		assert: aCompiledCodeModel isDoIt
		identicalTo: aCompiledCode isDoIt
]

{ #category : 'asserting' }
RedDebuggerTestCase >> assertModel: aModel modelsContext: aContext [

	self assert: aModel contextHash equals: aContext hash.
	self assert: aModel methodSelector equals: aContext method selector.
	self
		assert: aModel receiverClassName
		equals: aContext receiver class name.
	self
		assertModel: aModel compiledCode
		modelsCompiledCode: aContext compiledCode.
	self assert: aModel packageName equals: aContext method package name.

	self assert: aModel pc equals: aContext pc
]

{ #category : 'tests' }
RedDebuggerTestCase >> assertNewRemoteDebuggerAnnouncement: ann [

	self assert: ann sessionHash equals: debugger debugSessionHash.
	self
		assert: ann sessionDescription
		equals: debugger interruptedContext printString.

	self assert: ann remoteUrl equals: debuggerServer url
]

{ #category : 'tests' }
RedDebuggerTestCase >> assertStackModel: aStackModel modelsContextStacks: aStackOfContexts [

	self assert: aStackModel size equals: aStackOfContexts size.
	1 to: aStackModel size do: [ :i | 
		self
			assertModel: (aStackModel at: i)
			modelsContext: (debugSession stack at: i) ]
]

{ #category : 'running' }
RedDebuggerTestCase >> setUp [

	| dummyDebuggerActionModel |
	super setUp.

	RedDebuggerServer reset.
	debuggerServer := RedDebuggerServer current.

	dummyDebuggerActionModel := StTestDebuggerProvider new
		                            debuggerWithRecursiveContext
		                            debuggerActionModel.
	debugSession := dummyDebuggerActionModel session.
	dummyDebuggerActionModel clear.

	debugger := RedDebugger basicNew
		            debugSession: debugSession;
		            basicServer: debuggerServer;
		            yourself.

	masterServer := RedMasterTestServer new
]

{ #category : 'running' }
RedDebuggerTestCase >> tearDown [

	debugSession ifNotNil: [ :d | d terminate ].
	debuggerServer ifNotNil: [ debuggerServer reset ].
	super tearDown
]
