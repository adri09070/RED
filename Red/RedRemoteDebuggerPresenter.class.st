"
I am an erzats of the StDebugger, designed to prototype a remote debugger.
I am the main GUI tool to debug remote debug sessions.
"
Class {
	#name : #RedRemoteDebuggerPresenter,
	#superclass : #RedAbstractDebuggerPresenter,
	#instVars : [
		'remote',
		'stack',
		'code'
	],
	#category : #Red
}

{ #category : #specs }
RedRemoteDebuggerPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: #stack;
		  add: #toolbar expand: false;
		  add: #code;
		  yourself
]

{ #category : #'instance creation' }
RedRemoteDebuggerPresenter class >> openOn: aRemote [

	(self on: aRemote) openWithSpec
]

{ #category : #building }
RedRemoteDebuggerPresenter >> buildToolbar [

	| commandGroup |
	commandGroup := CmCommandGroup forSpec.
	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Into'
			 action: [ :context | context into ]
			 iconNamed: #glamorousInto).

	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Over'
			 action: [ :context | context over ]
			 iconNamed: #glamorousOver).
			
	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Through'
			 action: [ :context | context through ]
			 iconNamed: #glamorousThrough).
			
	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Restart'
			 action: [ :context | context restart ]
			 iconNamed: #glamorousRestart).
			
	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Proceed'
			 action: [ :context | context proceed ]
			 iconNamed: #glamorousGo).

	^ commandGroup asToolbarPresenter
]

{ #category : #initialization }
RedRemoteDebuggerPresenter >> initializePresenters [

	super initializePresenters.

	stack := self newTable.

	stack addColumn: ((SpStringTableColumn
			  title: 'Class'
			  evaluated: [ :remoteContext | 
				  self printReceiverClass: remoteContext ])
			 sortFunction: nil;
			 yourself).

	stack addColumn:
		((SpStringTableColumn
			  title: 'Method'
			  evaluated: [ :remoteContext | 
				  | method |
				  method := remoteContext findMethod.
				  method isCompiledBlock
					  ifTrue: [ method sourceNode sourceCode ]
					  ifFalse: [ method ifNil:[remoteContext methodSelector] ifNotNil:[:m| m selector] ] ])
			 sortFunction: nil;
			 yourself).

	stack addColumn: ((SpStringTableColumn
			  title: 'Package'
			  evaluated: [ :remoteContext | remoteContext packageName ])
			 sortFunction: nil;
			 yourself).

	stack items: (RedDebuggerClient current stackFor: remote).
	
	stack transmitDo: [ :context | 
		stack selection isEmpty ifFalse: [ 
			self updateCodeFromContext: context ] ].
	
	code := self newCode
]

{ #category : #private }
RedRemoteDebuggerPresenter >> printReceiverClass: aRemoteContext [

	| receiverClass method methodClass |
	receiverClass := aRemoteContext findSmalltalkClass.
	aRemoteContext isBlock ifTrue:[^ receiverClass name ].
	method := aRemoteContext findMethod ifNil:[^''].
	methodClass := method methodClass.
	receiverClass == methodClass ifTrue: [ ^ receiverClass name ].
	^ (WriteStream on: String new)
		  nextPutAll: receiverClass name;
		  space;
		  nextPut: $(;
		  nextPutAll: methodClass name;
		  nextPut: $);
		  contents
]

{ #category : #initialization }
RedRemoteDebuggerPresenter >> setModelBeforeInitialization: aRemote [

	remote := aRemote
]

{ #category : #accessing }
RedRemoteDebuggerPresenter >> title [
	^remote sessionDescription 
]

{ #category : #updating }
RedRemoteDebuggerPresenter >> updateCodeFromContext: aRemoteContext [

	| source selectionInterval |
	source := aRemoteContext isBlock
		          ifTrue: [ aRemoteContext methodSelector ]
		          ifFalse: [ aRemoteContext findMethod sourceCode ].
	code text: source.
	selectionInterval := aRemoteContext findMethod rangeForPC: aRemoteContext pc.
	code removeAllTextSegmentDecorations.
	code addTextSegmentDecoration:
		(SpTextPresenterDecorator forHighlight
			 interval: (selectionInterval first to: selectionInterval last + 1);
			 yourself).
	code beForMethod: aRemoteContext findMethod
]
