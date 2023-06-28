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
RedDebuggerClient >> executeRemoteCommand: command forContext: remoteContextModel inSession: remote [

	| response |
	command debugSessionHash: remote sessionHash.
	command contextHash: remoteContextModel contextHash.
	response := command sendTo: remote remoteUrl.
	^ STON fromString: response contents
]

{ #category : #initialization }
RedDebuggerClient >> initialize [
	self server
]

{ #category : #'remote commands' }
RedDebuggerClient >> into: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerIntoCommand new
		  forContext: remoteContextModel
		  inSession: remote
]

{ #category : #server }
RedDebuggerClient >> newClosedDebugger: aRemoteDebuggerClosedAnnouncement [

	self registeredDebuggers removeKey:
		aRemoteDebuggerClosedAnnouncement sessionHash.
	self announcer announce: aRemoteDebuggerClosedAnnouncement
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
		  executeRemoteCommand: RedDebuggerOverCommand new
		  forContext: remoteContextModel
		  inSession: remote
]

{ #category : #'remote commands' }
RedDebuggerClient >> proceed: remoteContextModel inSession: remote [

	self
		executeRemoteCommand: RedDebuggerProceedCommand new
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

{ #category : #'remote commands' }
RedDebuggerClient >> recompile: remoteContextModel inSession: remote withSource: aString [

	^ self
		  executeRemoteCommand: (RedDebuggerRecompileSourceCommand new source: aString)
		  forContext: remoteContextModel
		  inSession: remote
]

{ #category : #announcements }
RedDebuggerClient >> registerForNewDebuggerAnnouncements: anObject [
	
	self announcer weak when: RedNewRemoteDebugger send: #newRemoteDebugger: to: anObject.
	self announcer weak when: RedRemoteDebuggerClosed send: #remoteDebuggerRemoved: to: anObject
]

{ #category : #accessing }
RedDebuggerClient >> registeredDebuggers [

	^ registeredDebuggers ifNil:[registeredDebuggers := Dictionary new]
]

{ #category : #'remote commands' }
RedDebuggerClient >> restart: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerRestartCommand new
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
			 map: 'closedDebugger' to: [ :request |
				 self newClosedDebugger: (STON fromString: request contents).
				 ZnResponse ok: (ZnEntity text: 'OK') ];
			 yourself).
	server start.
	^ server
]

{ #category : #'remote commands' }
RedDebuggerClient >> stackFor: remote [

	^ self
		  executeRemoteCommand: RedDebuggerStackCommand new
		  forContext: RedRemoteContextModel new
		  inSession: remote
]

{ #category : #server }
RedDebuggerClient >> stop [

	server ifNotNil: [ :s | s stop ]
]

{ #category : #'remote commands' }
RedDebuggerClient >> through: remoteContextModel inSession: remote [

	^ self
		  executeRemoteCommand: RedDebuggerThroughCommand new
		  forContext: remoteContextModel
		  inSession: remote
]
