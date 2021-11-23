"
I am the client who communicates with remote debugger servers.
I have:
- registeredDebuggers -> a dictionary which associates a debug session hash with an ip address and a description of the debug session
- server -> for convenience of a first demo, I also have an http that receives notifications of remote debugger openings
"
Class {
	#name : #RedDebuggerClient,
	#superclass : #Object,
	#instVars : [
		'server',
		'registeredDebuggers',
		'announcer'
	],
	#classInstVars : [
		'current'
	],
	#category : #Red
}

{ #category : #accessing }
RedDebuggerClient class >> current [
	^current ifNil:[current := self new]
]

{ #category : #accessing }
RedDebuggerClient class >> reset [
	<script>
	current ifNotNil: [ current stop ].
	current := nil
]

{ #category : #accessing }
RedDebuggerClient >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'remote commands' }
RedDebuggerClient >> executeRemoteCommand: aCommandClass forContext: remoteContextModel inSession: remote [

	| command response |
	command := aCommandClass new.
	command debugSessionHash: remote sessionHash.
	command contextHash: remoteContextModel contextHash.
	response := command sendTo: remote remoteUrl.
	^STON fromString: response contents
]

{ #category : #initialization }
RedDebuggerClient >> initialize [
	self server
]

{ #category : #'remote commands' }
RedDebuggerClient >> into: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerIntoCommand
		  forContext: remoteContextModel
		  inSession: remote
]

{ #category : #server }
RedDebuggerClient >> newRemoteDebugger: aNewRemoteDebuggerOpeningAnnouncement [

	self registeredDebuggers
		at: aNewRemoteDebuggerOpeningAnnouncement sessionHash
		put: aNewRemoteDebuggerOpeningAnnouncement.
	self announcer announce: aNewRemoteDebuggerOpeningAnnouncement
]

{ #category : #'remote commands' }
RedDebuggerClient >> over: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerOverCommand
		  forContext: remoteContextModel
		  inSession: remote
]

{ #category : #'remote commands' }
RedDebuggerClient >> proceed: remoteContextModel inSession: remote [

	self
		executeRemoteCommand: RedDebuggerProceedCommand
		forContext: remoteContextModel
		inSession: remote.
	self announcer announce: RedRemoteDebuggerClosed new
]

{ #category : #'remote commands' }
RedDebuggerClient >> proceedSession: remote [

	| stack |
	stack := self stackFor: remote.
	self proceed: stack first inSession: remote
]

{ #category : #announcements }
RedDebuggerClient >> registerForNewDebuggerAnnouncements: anObject [
	
	self announcer weak when: RedNewRemoteDebugger send: #newRemoteDebugger: to: anObject.
	self announcer weak when: RedRemoteDebuggerClosed send: #remoteDebuggerRemoved to: anObject
]

{ #category : #accessing }
RedDebuggerClient >> registeredDebuggers [

	^ registeredDebuggers ifNil:[registeredDebuggers := Dictionary new]
]

{ #category : #'remote commands' }
RedDebuggerClient >> restart: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerRestartCommand
		  forContext: remoteContextModel
		  inSession: remote
]

{ #category : #server }
RedDebuggerClient >> server [

	server ifNotNil: [ ^ server ].
	server := ZnServer on: RedDebuggerServer remoteDebuggerMasterPort.
	server delegate: (ZnDefaultServerDelegate empty
			 map: 'newDebugger' to: [ :request | 
				 self newRemoteDebugger: (STON fromString: request contents).
				 ZnResponse ok: (ZnEntity text: 'OK') ];
			 yourself).
	server start.
	^server
]

{ #category : #'remote commands' }
RedDebuggerClient >> stackFor: remote [

	^ self
		  executeRemoteCommand: RedDebuggerStackCommand
		  forContext: nil
		  inSession: remote
]

{ #category : #server }
RedDebuggerClient >> stop [

	server ifNotNil: [ :s | s stop ]
]

{ #category : #'remote commands' }
RedDebuggerClient >> through: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerThroughCommand
		  forContext: remoteContextModel
		  inSession: remote
]
