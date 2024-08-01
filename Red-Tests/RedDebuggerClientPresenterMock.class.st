"
I am a mock to test registration to announcements from RedDebuggerClient instances.
"
Class {
	#name : 'RedDebuggerClientPresenterMock',
	#superclass : 'Object',
	#instVars : [
		'notification'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'accessing' }
RedDebuggerClientPresenterMock >> newRemoteDebugger: anObject [

	notification := anObject
]

{ #category : 'accessing' }
RedDebuggerClientPresenterMock >> notification [

	^ notification
]

{ #category : 'accessing' }
RedDebuggerClientPresenterMock >> remoteDebuggerRemoved: anObject [

	notification := anObject
]
