"
I just announce locally that a remote debugger has terminated
"
Class {
	#name : 'RedRemoteDebuggerClosed',
	#superclass : 'Announcement',
	#instVars : [
		'sessionHash',
		'remoteUrl'
	],
	#category : 'Red',
	#package : 'Red'
}

{ #category : 'accessing' }
RedRemoteDebuggerClosed >> remoteUrl [

	^ remoteUrl
]

{ #category : 'accessing' }
RedRemoteDebuggerClosed >> remoteUrl: anObject [

	remoteUrl := anObject
]

{ #category : 'accessing' }
RedRemoteDebuggerClosed >> sessionHash [

	^ sessionHash
]

{ #category : 'accessing' }
RedRemoteDebuggerClosed >> sessionHash: anObject [

	sessionHash := anObject
]
