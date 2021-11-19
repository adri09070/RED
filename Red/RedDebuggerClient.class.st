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
	#category : #Red
}

{ #category : #accessing }
RedDebuggerClient >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #server }
RedDebuggerClient >> newRemoteDebugger: aNewRemoteDebuggerOpeningAnnouncement [

	self registeredDebuggers
		at: aNewRemoteDebuggerOpeningAnnouncement sessionHash
		put: aNewRemoteDebuggerOpeningAnnouncement.
	self announcer announce: aNewRemoteDebuggerOpeningAnnouncement
]

{ #category : #accessing }
RedDebuggerClient >> registeredDebuggers [

	^ registeredDebuggers ifNil:[registeredDebuggers := Dictionary new]
]

{ #category : #server }
RedDebuggerClient >> server [

	server ifNotNil: [ ^ server ].
	server := ZnServer on: RedDebuggerServer remoteDebuggerMasterPort.
	server delegate: (ZnDefaultServerDelegate empty
			 map: 'newDebugger' to: [ :request | 
				 self newRemoteDebugger: (STON fromString: request contents).
				 ZnResponse ok: 'OK' ];
			 yourself).
	server start
]

{ #category : #server }
RedDebuggerClient >> stop [

	server ifNotNil: [ :s | s stop ]
]
