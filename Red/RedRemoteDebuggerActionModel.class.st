Class {
	#name : 'RedRemoteDebuggerActionModel',
	#superclass : 'Object',
	#instVars : [
		'session',
		'contextPredicate',
		'stack',
		'client'
	],
	#category : 'Red',
	#package : 'Red'
}

{ #category : 'instance creation' }
RedRemoteDebuggerActionModel class >> on: aRemoteDebugSession [

	^ self basicNew
		  session: aRemoteDebugSession;
		  initialize;
		  yourself
]

{ #category : 'private' }
RedRemoteDebuggerActionModel >> client [

	^ client ifNil: [ client := RedDebuggerClient current ]
]

{ #category : 'accessing' }
RedRemoteDebuggerActionModel >> client: anObject [

	client := anObject
]

{ #category : 'initialization' }
RedRemoteDebuggerActionModel >> initialize [

	super initialize.
	self updateStack
]

{ #category : 'debugging actions' }
RedRemoteDebuggerActionModel >> proceedDebugSession [

	stack := self client proceedSession: session
]

{ #category : 'actions' }
RedRemoteDebuggerActionModel >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

	stack := self client
		         recompile: aContext
		         inSession: session
		         withSource: aString.

	self updateContextChanged
]

{ #category : 'debug - execution' }
RedRemoteDebuggerActionModel >> restartContext: aContext [

	stack := self client restart: aContext inSession: session.

	self updateRestart
]

{ #category : 'accessing' }
RedRemoteDebuggerActionModel >> session [

	^ session
]

{ #category : 'accessing' }
RedRemoteDebuggerActionModel >> session: anObject [

	session := anObject
]

{ #category : 'accessing' }
RedRemoteDebuggerActionModel >> stack [

	^ stack
]

{ #category : 'debugging actions' }
RedRemoteDebuggerActionModel >> stepInto: aContext [

	stack := self client into: aContext inSession: session.
	self updateStep 
]

{ #category : 'debugging actions' }
RedRemoteDebuggerActionModel >> stepOver: aContext [

	stack := self client over: aContext inSession: session.
	self updateStep
]

{ #category : 'debugging actions' }
RedRemoteDebuggerActionModel >> stepThrough: aContext [

	stack := self client through: aContext inSession: session.
	self updateStep
]

{ #category : 'accessing' }
RedRemoteDebuggerActionModel >> topContext [

	^ self stack at: 1 ifAbsent: [ nil ]
]

{ #category : 'updating - actions' }
RedRemoteDebuggerActionModel >> updateContextChanged [

	self updateStep 
]

{ #category : 'updating - actions' }
RedRemoteDebuggerActionModel >> updateRestart [

	self updateStep
]

{ #category : 'initialization' }
RedRemoteDebuggerActionModel >> updateStack [

	stack := self client stackFor: session
]

{ #category : 'updating - actions' }
RedRemoteDebuggerActionModel >> updateStep [

	
]
