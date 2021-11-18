"
I am the Zinc delegate for RedDebuggerServer.
I basically receive remote debugging instructions and transmit them to my RedDebuggerServer owner.
"
Class {
	#name : #RedDebuggerServerDelegate,
	#superclass : #ZnDefaultServerDelegate,
	#instVars : [
		'server'
	],
	#category : #Red
}

{ #category : #'instance creation' }
RedDebuggerServerDelegate class >> on: aRedDebuggerServer [
	^self new server: aRedDebuggerServer
]

{ #category : #responses }
RedDebuggerServerDelegate >> execute: request [

	| command responseData |
	command := STON fromString: request contents.
	responseData := command executeWith: server.
	^ ZnResponse ok: (ZnEntity text: (STON toString: responseData))
]

{ #category : #initialization }
RedDebuggerServerDelegate >> initialize [

	self
		map: 'into' to: #execute:;
		map: 'over' to: #execute:;
		map: 'through' to: #execute:;
		map: 'proceed' to: #execute:;
		map: 'restart' to: #execute:;
		map: 'stack' to: #execute:;
		map: 'modifySource' to: #execute:
]

{ #category : #accessing }
RedDebuggerServerDelegate >> server: aRedDebuggerServer [
	server := aRedDebuggerServer.
	aRedDebuggerServer delegate: self
]
