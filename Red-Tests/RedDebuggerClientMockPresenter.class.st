"
I am a mock to test registration to announcements from RedDebuggerClient instances.
"
Class {
	#name : #RedDebuggerClientMockPresenter,
	#superclass : #Object,
	#instVars : [
		'notification'
	],
	#category : #'Red-Tests'
}

{ #category : #accessing }
RedDebuggerClientMockPresenter >> newRemoteDebugger: anObject [

	notification := anObject
]

{ #category : #accessing }
RedDebuggerClientMockPresenter >> notification [

	^ notification
]
