Class {
	#name : #RedDebuggerTestCase,
	#superclass : #TestCase,
	#instVars : [
		'debugSession',
		'debugger',
		'debuggerServer',
		'masterServer'
	],
	#category : #'Red-Tests'
}

{ #category : #asserting }
RedDebuggerTestCase >> assertModel: aModel modelsContext: aContext [

	self assert: aModel contextHash equals: aContext hash.
	self
		assert: aModel methodSelector
		equals: (aContext method isCompiledBlock
				 ifTrue: [ aContext method sourceNode sourceCode ]
				 ifFalse: [ aContext method selector ]).
	self
		assert: aModel receiverClassName
		equals: aContext receiver class name.
	self assert: aModel packageName equals: aContext method package name
]

{ #category : #tests }
RedDebuggerTestCase >> assertNewRemoteDebuggerAnnouncement: ann [

	self assert: ann sessionHash equals: debugger debugSessionHash.
	self
		assert: ann sessionDescription
		equals: debugger interruptedContext printString.

	self assert: ann remoteUrl equals: debuggerServer url
]

{ #category : #tests }
RedDebuggerTestCase >> assertStackModel: aStackModel modelsContextStacks: aStackOfContexts [

	self assert: aStackModel size equals: aStackOfContexts size.
	1 to: aStackModel size do: [ :i | 
		self
			assertModel: (aStackModel at: i)
			modelsContext: (debugSession stack at: i) ]
]

{ #category : #running }
RedDebuggerTestCase >> setUp [
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

{ #category : #running }
RedDebuggerTestCase >> tearDown [

	debugSession ifNotNil: [ :d | d terminate ].
	debuggerServer ifNotNil: [ debuggerServer reset ].
	super tearDown
]
