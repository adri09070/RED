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

{ #category : #layout }
RedRemoteDebuggerPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #stack;
		  add: #toolbar expand: false;
		  add: #code;
		  yourself
]

{ #category : #'instance creation' }
RedRemoteDebuggerPresenter class >> openOn: aRemote [

	(self on: aRemote) open
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

	^ self newToolbar
		  fillWith: commandGroup;
		  yourself
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

	stack transmitDo: [ :context | 
		stack selection isEmpty ifFalse: [ 
			self updateCodeFromContext: context ] ].
		
	code := self newCode.
	code whenSubmitDo: [:text| self recompileCurrentContextWithNewSource ].
	
	self updateStack
]

{ #category : #'remote actions' }
RedRemoteDebuggerPresenter >> into [

	self updateStack:
		(RedDebuggerClient current
			 into: stack selectedItem
			 inSession: remote)
]

{ #category : #'remote actions' }
RedRemoteDebuggerPresenter >> over [

	self updateStack:
		(RedDebuggerClient current
			 over: stack selectedItem
			 inSession: remote)
]

{ #category : #private }
RedRemoteDebuggerPresenter >> printReceiverClass: aRemoteContext [

	| receiverClassName method methodClassName |
	receiverClassName := aRemoteContext findSmalltalkClass.
	aRemoteContext isBlock ifTrue:[^ receiverClassName ].
	method := aRemoteContext findMethod ifNil:[^''].
	methodClassName := method methodClassName.
	receiverClassName = methodClassName ifTrue: [ ^ receiverClassName ].
	^ (WriteStream on: String new)
		  nextPutAll: receiverClassName;
		  space;
		  nextPut: $(;
		  nextPutAll: methodClassName;
		  nextPut: $);
		  contents
]

{ #category : #'remote actions' }
RedRemoteDebuggerPresenter >> proceed [

	RedDebuggerClient current proceedSession: remote.

	self withWindowDo: #close
]

{ #category : #'remote actions' }
RedRemoteDebuggerPresenter >> recompileCurrentContextWithNewSource [
	|remoteContext newSource|
	remoteContext := stack selectedItem.
	newSource := code text.
	self updateStack: (RedDebuggerClient current
			 recompile: remoteContext
			 inSession: remote
			 withSource: newSource).
	"remoteContext findSmalltalkClass compile: newSource."
	self updateCodeFromContext: stack selectedItem
]

{ #category : #'remote actions' }
RedRemoteDebuggerPresenter >> restart [

	self updateStack: (RedDebuggerClient current
			 restart: stack selectedItem
			 inSession: remote)
]

{ #category : #initialization }
RedRemoteDebuggerPresenter >> setModelBeforeInitialization: aRemote [

	remote := aRemote
]

{ #category : #'remote actions' }
RedRemoteDebuggerPresenter >> through [

	self updateStack: (RedDebuggerClient current
			 through: stack selectedItem
			 inSession: remote)
]

{ #category : #accessing }
RedRemoteDebuggerPresenter >> title [
	^remote sessionDescription 
]

{ #category : #updating }
RedRemoteDebuggerPresenter >> updateCodeFromContext: aRemoteContext [

	| source selectionInterval |
	source := aRemoteContext source.
	code text: source.
	code beForMethod: aRemoteContext findMethod.
	aRemoteContext isDoIt ifTrue: [ ^ self ].
	selectionInterval := aRemoteContext selectionInterval.
	code removeAllTextSegmentDecorations.
	code addTextSegmentDecoration:
		(SpTextPresenterDecorator forHighlight
			 interval: (selectionInterval first to: selectionInterval last + 1);
			 yourself)
]

{ #category : #updating }
RedRemoteDebuggerPresenter >> updateStack [

	self updateStack: (RedDebuggerClient current stackFor: remote)
]

{ #category : #updating }
RedRemoteDebuggerPresenter >> updateStack: remoteContexts [

	stack items: remoteContexts.
	stack selectIndex: 1
]
