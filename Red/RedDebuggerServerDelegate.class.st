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

{ #category : #initialization }
RedDebuggerServerDelegate >> initialize [

	self
		map: 'into' to: #stepInto:;
		map: 'over' to: #stepOver:;
		map: 'through' to: #stepThrough:;
		map: 'proceed' to: #proceed:;
		map: 'restart' to: #restart:;
		map: 'stack' to: #stack:;
		map: 'modifySource' to: #modifySource:
]

{ #category : #accessing }
RedDebuggerServerDelegate >> server: aRedDebuggerServer [

	server := aRedDebuggerServer.
	aRedDebuggerServer delegate: self
]

{ #category : #responses }
RedDebuggerServerDelegate >> stepInto: request [

	| command responseData |
	command := STON fromString: request contents.
	responseData := command executeWith: server.
	^ ZnResponse ok: (ZnEntity text: (STON toString: responseData))
]
