"
I provide a test server to simulate a remote master debugger. 
"
Class {
	#name : #RedMasterTestServer,
	#superclass : #Object,
	#instVars : [
		'masterNotification'
	],
	#category : #'Red-Tests'
}

{ #category : #accessing }
RedMasterTestServer >> masterNotification [

	^ masterNotification
]

{ #category : #enumerating }
RedMasterTestServer >> withServerDo: block [

	| server |
	server := ZnServer on: RedDebuggerServer remoteDebuggerMasterPort.
	server delegate: (ZnDefaultServerDelegate empty
			 map: 'newDebugger' to: [ :request | 
				 masterNotification := STON fromString: request contents.
				ZnResponse ok: request contents];
			 yourself).

	[ 
	server start.
	self
		assert: server isRunning & server isListening
		description:
			('Failed to start server on port {1}. Is there one already?' 
				 format: { server port }).
	self assert: server isRunning & server isListening.
	block cull: server ] ensure: [ server stop ]
]
