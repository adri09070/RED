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
		'debuggerActionModel',
		'server'
	],
	#category : #Red
}

{ #category : #'instance creation' }
RedDebugger class >> debugSession: aDebugSession [

	^ self basicNew
		  debugSession: aDebugSession;
		  initialize
]

{ #category : #accessing }
RedDebugger class >> defaultDebuggerRank [

	^ 10
]

{ #category : #api }
RedDebugger >> clear [

	self flag: 'todo'.
	self removeActionsForActionModel.
	self debuggerActionModel clear.
	debuggerActionModel := nil
]

{ #category : #accessing }
RedDebugger >> debugSession [

	^ self debuggerActionModel
		  ifNotNil: [ debuggerActionModel session ]
		  ifNil: [ nil ]
]

{ #category : #accessing }
RedDebugger >> debugSession: aDebugSession [

	self debuggerActionModel
		ifNotNil: [ debuggerActionModel session: aDebugSession ]
		ifNil: [
			debuggerActionModel := StDebuggerActionModel on: aDebugSession.
			self registerActionsForActionModel ]
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

	^ debuggerActionModel
]

{ #category : #accessing }
RedDebugger >> debuggerActionModel: anObject [

	debuggerActionModel := anObject
]

{ #category : #api }
RedDebugger >> findContextFromhash: anInteger [

	^ self debuggerActionModel session stack
		  detect: [ :c | c hash = anInteger ]
		  ifNone: [ 
			  RedContextHashNotFound new
				  contextHash: anInteger;
				  signal ]
]

{ #category : #initialization }
RedDebugger >> initialize [

	super initialize.
	self server: RedDebuggerServer current
]

{ #category : #api }
RedDebugger >> interruptedContext [
	^self debuggerActionModel interruptedContext 
]

{ #category : #accessing }
RedDebugger >> localServer [

	^ self server
]

{ #category : #api }
RedDebugger >> proceed [

	self localServer removeAndNotifyDebugger: self debugSessionHash.
	self debuggerActionModel proceedDebugSession
]

{ #category : #api }
RedDebugger >> recompileContext: context with: source [
	self flag: 'untested'.
	self debuggerActionModel recompileMethodTo: source inContext: context notifying: nil
]

{ #category : #update }
RedDebugger >> registerActionsForActionModel [

	self debuggerActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #updateStep:
		to: self;
		when: StDebuggerActionModelRestartAnnouncement
		send: #updateRestart:
		to: self;
		when: StDebuggerActionModelResumeAnnouncement
		send: #updateResume:
		to: self;
		when: StDebuggerActionModelContextChangedAnnouncement
		send: #updateContextChanged:
		to: self;
		when: StDebuggerActionModelMethodAddedAnnouncement
		send: #updateMethodAdded:
		to: self
]

{ #category : #update }
RedDebugger >> removeActionsForActionModel [

	self debuggerActionModel unsubscribe: self
]

{ #category : #api }
RedDebugger >> restartContext: aContext [ 
	self debuggerActionModel restartContext: aContext
]

{ #category : #accessing }
RedDebugger >> server [

	^ server ifNil: [ server := RedDebuggerServer current ]
]

{ #category : #accessing }
RedDebugger >> server: anObject [

	server ifNotNil: [
		server removeAndNotifyDebugger: self debugSessionHash ].
	server := anObject.
	self localServer registerAndNotifyNewDebugger: self
]

{ #category : #api }
RedDebugger >> stack [

	| stackModel stack |
	stackModel := RedRemoteContextModel new visitContext:
		              self debuggerActionModel interruptedContext.

	stack := OrderedCollection new.
	stack addLast: stackModel.
	[ 
	(stackModel := stackModel sender) notNil and: [ stack size < 1000 ] ] 
		whileTrue: [ stack addLast: stackModel ].
	^ stack
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

{ #category : #update }
RedDebugger >> updateContextChanged: anActionModelContextChangedAnnouncement [

	self server updateContextChangedForSessionHash: self debugSessionHash
]

{ #category : #update }
RedDebugger >> updateMethodAdded: anActionModelMethodAddedAnnouncement [

	self server updateMethodAddedForSessionHash: self debugSessionHash
]

{ #category : #update }
RedDebugger >> updateRestart: anActionModelRestartAnnouncement [

	self server updateRestartForSessionHash: self debugSessionHash
]

{ #category : #update }
RedDebugger >> updateResume: anActionModelResumeAnnouncement [

	self server updateResumeForSessionHash: self debugSessionHash 
]

{ #category : #update }
RedDebugger >> updateStep: anActionModelStepAnnouncement [

	self server updateStepForSessionHash: self debugSessionHash
]
