Class {
	#name : #RedDebuggerServer,
	#superclass : #Object,
	#instVars : [
		'debuggers',
		'server'
	],
	#classInstVars : [
		'rank',
		'availableAutomatically',
		'current'
	],
	#category : #Red
}

{ #category : #'instance creation' }
RedDebuggerServer class >> current [
	^current ifNil:[current := self new]
]

{ #category : #'API - remotes' }
RedDebuggerServer class >> newRemoteDebuggerNotificationURL [
	^ZnUrl fromString: 'http://localhost:8000/newDebugger'
]

{ #category : #'API - remotes' }
RedDebuggerServer class >> remoteDebuggerMasterPort [
	^8000
]

{ #category : #'API - remotes' }
RedDebuggerServer class >> remoteDebuggerMasterURL [
	^'http://localhost:8000'
]

{ #category : #initialization }
RedDebuggerServer class >> reset [
	self current reset.
	current := nil
]

{ #category : #debuggers }
RedDebuggerServer >> debuggerAt: anInteger [

	^self debuggers at: anInteger
]

{ #category : #accessing }
RedDebuggerServer >> debuggers [

	^ debuggers ifNil: [ debuggers := Dictionary new ]
]

{ #category : #accessing }
RedDebuggerServer >> debuggers: anObject [

	debuggers := anObject
]

{ #category : #initialize }
RedDebuggerServer >> initialize [
	server := ZnServer on: 8008.
	server delegate: RedDebuggerServerDelegate new.
	server start
]

{ #category : #debuggers }
RedDebuggerServer >> notifyMasterForNewOpenedDebugger: aDebugger [

	ZnEasy
		put: self class newRemoteDebuggerNotificationURL
		data: (ZnEntity text: (STON toString: { 
						  aDebugger debugSessionHashString.
						  aDebugger interruptedContext printString }))
]

{ #category : #debuggers }
RedDebuggerServer >> registerAndNotifyNewDebugger: aRedDebugger [

	self registerNewDebugger: aRedDebugger.
	self notifyMasterForNewOpenedDebugger: aRedDebugger 
]

{ #category : #debuggers }
RedDebuggerServer >> registerNewDebugger: aRedDebugger [

	self debuggers at: aRedDebugger debugSessionHashString put: aRedDebugger
]

{ #category : #initialize }
RedDebuggerServer >> reset [
	server stop.
	self debuggers do:[:d| d clear].
	debuggers removeAll
]

{ #category : #accessing }
RedDebuggerServer >> server [
	^ server
]
