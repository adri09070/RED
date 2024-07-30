"
I just hold information to notify a RedDebuggerClient that a new debugger just opened:
- the hash of the debug session object
- the string description of the interrupted context of that session
- a remote ZnUrl to join the remote debugger server who created me
"
Class {
	#name : 'RedNewRemoteDebugger',
	#superclass : 'Announcement',
	#instVars : [
		'sessionHash',
		'sessionDescription',
		'remoteUrl'
	],
	#category : 'Red',
	#package : 'Red'
}

{ #category : 'accessing' }
RedNewRemoteDebugger >> remoteUrl [

	^ remoteUrl
]

{ #category : 'accessing' }
RedNewRemoteDebugger >> remoteUrl: anObject [

	remoteUrl := anObject
]

{ #category : 'accessing' }
RedNewRemoteDebugger >> sessionDescription [

	^ sessionDescription
]

{ #category : 'accessing' }
RedNewRemoteDebugger >> sessionDescription: anObject [

	sessionDescription := anObject
]

{ #category : 'accessing' }
RedNewRemoteDebugger >> sessionHash [

	^ sessionHash
]

{ #category : 'accessing' }
RedNewRemoteDebugger >> sessionHash: anObject [

	sessionHash := anObject
]
