"
I am signaled when a RedDebugger instance attempted to find a context a hash in its debug session stack, but no match was found.

Hence, there is no context with that hash in the current stack.
"
Class {
	#name : #RedContextHashNotFound,
	#superclass : #Error,
	#instVars : [
		'contextHash'
	],
	#category : #Red
}

{ #category : #accessing }
RedContextHashNotFound >> contextHash [

	^ contextHash
]

{ #category : #accessing }
RedContextHashNotFound >> contextHash: anObject [

	contextHash := anObject
]

{ #category : #printing }
RedContextHashNotFound >> printOn: aStream [
	aStream << 'No context with the following hash was found:'.
	aStream space.
	aStream << contextHash printString
]
