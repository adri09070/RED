"
I provide a test server to simulate a remote master debugger. 
"
Class {
	#name : 'RedMasterTestServer',
	#superclass : 'Object',
	#instVars : [
		'masterNotification'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'accessing' }
RedMasterTestServer >> masterNotification [

	^ masterNotification
]

{ #category : 'accessing' }
RedMasterTestServer >> url [

	^ RedDebuggerServer remoteDebuggerMasterURL
]

{ #category : 'enumerating' }
RedMasterTestServer >> withServerDo: block route: aString port: port [

	| server |
	server := ZnServer on: port.
	server delegate: (ZnDefaultServerDelegate empty
			 map: aString to: [ :request | 	
				 masterNotification := STON fromString: request contents.			
				 ZnResponse ok: (ZnEntity text: request contents) ];
			 yourself).

	[ 
	server start.
	self
		assert: server isRunning & server isListening
		description:
			('Failed to start server on port {1}. Is there one already?' 
				 format: { server port }).
	block cull: server ] ensure: [ server stop ]
]
