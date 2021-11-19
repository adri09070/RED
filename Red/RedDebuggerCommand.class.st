"
I am an abstract remote debugger command.
When I am received by a RedDebuggerServerDelegate, I use the local server to find the debugger I was meant for from the debug hash I hold, then my concrete subclasses execute their debug command and return the result.
"
Class {
	#name : #RedDebuggerCommand,
	#superclass : #Object,
	#instVars : [
		'debugSessionHash',
		'debugger',
		'contextHash',
		'context'
	],
	#category : #Red
}

{ #category : #options }
RedDebuggerCommand class >> route [
	^self subclassResponsibility 
]

{ #category : #executing }
RedDebuggerCommand >> answer [

	^ debugger stack
]

{ #category : #accessing }
RedDebuggerCommand >> contextHash [

	^ contextHash
]

{ #category : #accessing }
RedDebuggerCommand >> contextHash: anObject [

	contextHash := anObject
]

{ #category : #accessing }
RedDebuggerCommand >> debugSessionHash [

	^ debugSessionHash
]

{ #category : #accessing }
RedDebuggerCommand >> debugSessionHash: anObject [

	debugSessionHash := anObject
]

{ #category : #accessing }
RedDebuggerCommand >> debugger [

	^ debugger
]

{ #category : #accessing }
RedDebuggerCommand >> debugger: anObject [

	debugger := anObject
]

{ #category : #executing }
RedDebuggerCommand >> execute [
	^self subclassResponsibility 
]

{ #category : #executing }
RedDebuggerCommand >> executeWith: server [

	debugger := server debuggerAt: debugSessionHash.
	self findContext.
	self execute.
	^ self answer
]

{ #category : #executing }
RedDebuggerCommand >> findContext [

	context := debugger findContextFromhash: contextHash
]

{ #category : #sending }
RedDebuggerCommand >> sendTo: aZnURL [
	aZnURL addPathSegment: self class route.
	^ZnEasy put: aZnURL data: (ZnEntity text: (STON toString: self))
]
