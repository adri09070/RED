"
I model a remote context.

I store all information of a context as displayed by a debugger under a string form to be transmitted and displayed remotely.

I know the hash of the context I model.
I do not know the map of hashs <-> contexts, see RedDebugger class for that.
"
Class {
	#name : #RedRemoteContextModel,
	#superclass : #Object,
	#instVars : [
		'contextHash',
		'sender',
		'receiverClassName',
		'methodSelector',
		'packageName',
		'isBlock',
		'pc',
		'doItSource',
		'blockSource'
	],
	#category : #Red
}

{ #category : #accessing }
RedRemoteContextModel >> blockSource [

	^ blockSource
]

{ #category : #accessing }
RedRemoteContextModel >> contextHash [

	^ contextHash
]

{ #category : #accessing }
RedRemoteContextModel >> contextHash: anObject [

	contextHash := anObject
]

{ #category : #accessing }
RedRemoteContextModel >> doItSource [

	^ doItSource
]

{ #category : #searching }
RedRemoteContextModel >> findMethod [

	^ self findSmalltalkClass lookupSelector: methodSelector
]

{ #category : #searching }
RedRemoteContextModel >> findSmalltalkClass [
	|tokens class|
	tokens := receiverClassName splitOn: Character space.
	class := Smalltalk at: tokens first asSymbol.
	tokens last = 'class' ifTrue:[^class class].
	^class
]

{ #category : #visiting }
RedRemoteContextModel >> isBlock [

	^isBlock
]

{ #category : #visiting }
RedRemoteContextModel >> isDoIt [

	^ methodSelector = 'doIt'
]

{ #category : #accessing }
RedRemoteContextModel >> methodSelector [

	^ methodSelector
]

{ #category : #accessing }
RedRemoteContextModel >> packageName [

	^ packageName
]

{ #category : #accessing }
RedRemoteContextModel >> pc [

	^ pc
]

{ #category : #accessing }
RedRemoteContextModel >> receiverClassName [

	^ receiverClassName
]

{ #category : #accessing }
RedRemoteContextModel >> sender [

	^ sender
]

{ #category : #accessing }
RedRemoteContextModel >> sender: anObject [

	sender := anObject
]

{ #category : #visiting }
RedRemoteContextModel >> visitContext: aContext [

	| str |
	str := WriteStream on: String new.
	aContext printOn: str.
	contextHash := aContext hash.
	receiverClassName := aContext receiver class name.
	isBlock := aContext method isCompiledBlock.
	methodSelector := aContext method selector.
	self isBlock ifTrue:[blockSource := aContext method sourceNode sourceCode].
	self isDoIt ifTrue:[doItSource := aContext method sourceNode sourceNode].
	pc := aContext pc.
	packageName := aContext method package
		               ifNil: [ '-' ]
		               ifNotNil: [ :p | p name asString ].
	aContext sender ifNotNil: [ :s | 
		sender := self class new visitContext: s ]
]
