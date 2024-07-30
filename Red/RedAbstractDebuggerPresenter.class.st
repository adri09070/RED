"
Common behavior and state for all remote debuggers.
"
Class {
	#name : 'RedAbstractDebuggerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbar'
	],
	#category : 'Red',
	#package : 'Red'
}

{ #category : 'building' }
RedAbstractDebuggerPresenter >> buildToolbar [ 
	^self subclassResponsibility 
]

{ #category : 'building' }
RedAbstractDebuggerPresenter >> buildToolbarButtonLabeled: buttonLabel action: aBlock iconNamed: aSymbol [

	^ ((CmBlockCommand forContext: self)
		   name: buttonLabel;
		   block: aBlock;
		   yourself) asSpecCommandWithIconNamed: aSymbol
]

{ #category : 'initialization' }
RedAbstractDebuggerPresenter >> initializePresenters [
	super initializePresenters.
	toolbar := self buildToolbar.
]
