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
		'compiledCodeModel',
		'pc',
		'selectionInterval'
	],
	#category : #Red
}

{ #category : #accessing }
RedRemoteContextModel >> compiledCode [

	^ compiledCodeModel
]

{ #category : #accessing }
RedRemoteContextModel >> contextHash [

	^ contextHash
]

{ #category : #accessing }
RedRemoteContextModel >> contextHash: anObject [

	contextHash := anObject
]

{ #category : #searching }
RedRemoteContextModel >> findMethod [

	self flag: 'untested'.
	^ compiledCodeModel
]

{ #category : #searching }
RedRemoteContextModel >> findSmalltalkClass [
	|tokens class|
	self flag: 'untested'.
	tokens := receiverClassName splitOn: Character space.
	class := Smalltalk at: tokens first asSymbol.
	tokens last = 'class' ifTrue:[^class class].
	^class
]

{ #category : #testing }
RedRemoteContextModel >> isBlock [

	^ compiledCodeModel isBlock
]

{ #category : #testing }
RedRemoteContextModel >> isDoIt [

	^ self methodSelector = 'DoIt'
]

{ #category : #accessing }
RedRemoteContextModel >> methodSelector [

	^ compiledCodeModel methodSelector
]

{ #category : #accessing }
RedRemoteContextModel >> packageName [

	^ compiledCodeModel packageName
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
RedRemoteContextModel >> selectionInterval [

	^ selectionInterval
]

{ #category : #visiting }
RedRemoteContextModel >> selectionIntervalFor: aContext [

	| node |
	self flag: 'untested'.
	node := aContext method sourceNodeForPC: aContext pc.
	^ node start to: node stop + 1
]

{ #category : #accessing }
RedRemoteContextModel >> sender [

	^ sender
]

{ #category : #accessing }
RedRemoteContextModel >> sender: anObject [

	sender := anObject
]

{ #category : #accessing }
RedRemoteContextModel >> source [

	^ self compiledCode sourceCode
]

{ #category : #visiting }
RedRemoteContextModel >> visitContext: aContext [

	| str |
	self flag: 'not tested completely'.
	str := WriteStream on: String new.
	aContext printOn: str.
	contextHash := aContext hash.
	receiverClassName := aContext receiver class name.
	compiledCodeModel := RedRemoteCompiledCodeModel new
		                     visitCompiledCode: aContext compiledCode.
	pc := aContext pc.
	selectionInterval := aContext compiledCode rangeForPC: pc.
	aContext sender ifNotNil: [ :s |
		sender := self class new visitContext: s ]
]
