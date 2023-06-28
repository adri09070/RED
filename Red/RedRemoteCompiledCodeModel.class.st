Class {
	#name : #RedRemoteCompiledCodeModel,
	#superclass : #Object,
	#instVars : [
		'methodClassName',
		'methodSelector',
		'packageName',
		'isBlock',
		'sourceCode',
		'startPc',
		'endPc',
		'bytecodes'
	],
	#category : #Red
}

{ #category : #accessing }
RedRemoteCompiledCodeModel >> bytecodes [

	^ bytecodes
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> endPc [

	^ endPc
]

{ #category : #testing }
RedRemoteCompiledCodeModel >> isBlock [

	^ isBlock
]

{ #category : #testing }
RedRemoteCompiledCodeModel >> isDoIt [

	^ self methodSelector = 'DoIt'
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> methodClass [

	^ self class
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> methodClassName [

	^ methodClassName
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> methodSelector [

	^ methodSelector
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> packageName [

	^ packageName
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> selector [

	^ self methodSelector
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> startPc [

	^ startPc
]

{ #category : #accessing }
RedRemoteCompiledCodeModel >> visitCompiledCode: aCompiledCode [

	packageName := aCompiledCode package
		               ifNil: [ '-' ]
		               ifNotNil: [ :package | packageName ].
	methodClassName := aCompiledCode methodClass name.
	methodSelector := aCompiledCode selector.
	bytecodes := aCompiledCode bytecodes.
	startPc := aCompiledCode initialPC.
	endPc := aCompiledCode endPC.
	sourceCode := aCompiledCode sourceCode.
	isBlock := aCompiledCode isCompiledBlock
]
