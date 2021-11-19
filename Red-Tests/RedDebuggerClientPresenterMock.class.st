"
I am a mock to test registration to announcements from RedDebuggerClient instances.
"
Class {
	#name : #RedDebuggerClientPresenterMock,
	#superclass : #Object,
	#instVars : [
		'notification'
	],
	#category : #'Red-Tests'
}

{ #category : #accessing }
RedDebuggerClientPresenterMock >> newRemoteDebugger: anObject [

	notification := anObject
]

{ #category : #accessing }
RedDebuggerClientPresenterMock >> notification [

	^ notification
]
