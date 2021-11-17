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
		  debugNewSession: aDebugSession;
		  initialize
]

{ #category : #accessing }
RedDebugger class >> defaultDebuggerRank [

	^ 10
]

{ #category : #api }
RedDebugger >> clear [
	self flag: 'todo'
]

{ #category : #accessing }
RedDebugger >> debugSession [

	^debugSession
]

{ #category : #accessing }
RedDebugger >> debugSession: aDebugSession [

	debugSession := aDebugSession
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

	^ debuggerActionModel ifNil: [ 
		  debuggerActionModel := StDebuggerActionModel on: self debugSession ]
]

{ #category : #accessing }
RedDebugger >> debuggerActionModel: anObject [

	debuggerActionModel := anObject
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
	self debuggerActionModel proceedDebugSession
]

{ #category : #api }
RedDebugger >> restartContext: aContext [ 
	self debuggerActionModel restartContext: aContext
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
