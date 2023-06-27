"
I am the local instance of a remote, gui-less debugger.
When an exception occurs, I catch it and register myself to the local server.
I then await for remote debugging instructions.
"
Class {
	#name : #RedDebugger,
	#superclass : #Object,
	#traits : 'TDebugger',
	#classTraits : 'TDebugger classTrait',
	#instVars : [
		'debugSession',
		'debuggerActionModel'
	],
	#category : #Red
}

{ #category : #'instance creation' }
RedDebugger class >> debugSession: aDebugSession [

	^ self basicNew
		  debugSession: aDebugSession;
		  initialize
]

{ #category : #accessing }
RedDebugger class >> defaultDebuggerRank [

	^ 10
]

{ #category : #api }
RedDebugger >> clear [

	self flag: 'todo'.
	self debuggerActionModel clear.
	debuggerActionModel := nil
]

{ #category : #accessing }
RedDebugger >> debugSession [

	^ self debuggerActionModel
		  ifNotNil: [ debuggerActionModel session ]
		  ifNil: [ nil ]
]

{ #category : #accessing }
RedDebugger >> debugSession: aDebugSession [

	self debuggerActionModel
		ifNotNil: [ debuggerActionModel session: aDebugSession ]
		ifNil: [
		debuggerActionModel := StDebuggerActionModel on: aDebugSession ]
]

{ #category : #accessing }
RedDebugger >> debugSessionHash [
	^self debugSession hash
]

{ #category : #accessing }
RedDebugger >> debugSessionHashString [
	^self debugSessionHash printString
]

{ #category : #accessing }
RedDebugger >> debuggerActionModel [

	^ debuggerActionModel
]

{ #category : #accessing }
RedDebugger >> debuggerActionModel: anObject [

	debuggerActionModel := anObject
]

{ #category : #api }
RedDebugger >> findContextFromhash: anInteger [

	^ self debuggerActionModel session stack
		  detect: [ :c | c hash = anInteger ]
		  ifNone: [ 
			  RedContextHashNotFound new
				  contextHash: anInteger;
				  signal ]
]

{ #category : #initialization }
RedDebugger >> initialize [
	self localServer registerAndNotifyNewDebugger: self
]

{ #category : #api }
RedDebugger >> interruptedContext [
	^self debuggerActionModel interruptedContext 
]

{ #category : #accessing }
RedDebugger >> localServer [

	^ RedDebuggerServer current
]

{ #category : #api }
RedDebugger >> proceed [
	self localServer removeDebugger: self debugSessionHash. 
	self debuggerActionModel proceedDebugSession
]

{ #category : #api }
RedDebugger >> recompileContext: context with: source [
	self flag: 'untested'.
	self debuggerActionModel recompileMethodTo: source inContext: context notifying: nil
]

{ #category : #api }
RedDebugger >> restartContext: aContext [ 
	self debuggerActionModel restartContext: aContext
]

{ #category : #api }
RedDebugger >> stack [

	| stackModel stack |
	stackModel := RedRemoteContextModel new visitContext:
		              self debuggerActionModel interruptedContext.

	stack := OrderedCollection new.
	stack addLast: stackModel.
	[ 
	(stackModel := stackModel sender) notNil and: [ stack size < 1000 ] ] 
		whileTrue: [ stack addLast: stackModel ].
	^ stack
]

{ #category : #api }
RedDebugger >> stepInto: aContext [
	self debuggerActionModel stepInto: aContext
]

{ #category : #api }
RedDebugger >> stepOver: aContext [ 
	self debuggerActionModel stepOver: aContext
]

{ #category : #api }
RedDebugger >> stepThrough: aContext [ 
	self debuggerActionModel stepThrough: aContext
]
