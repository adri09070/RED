"
I am the local RED server.
I am in charge of registering local debuggers available for remote access, to notify potential master server that I have available debuggers waiting, and to receive remote instructions that I transmit to those debuggers.

There is only one of me in the system, but there could be many.
I am just a prototype for now.
"
Class {
	#name : #RedDebuggerServer,
	#superclass : #Object,
	#instVars : [
		'debuggers',
		'server',
		'semaphores'
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

	^ ZnUrl fromString:
		  'http://localhost:' , self remoteDebuggerMasterPort printString
]

{ #category : #initialization }
RedDebuggerServer class >> reset [
	<script>
	self current reset.
	current := nil
]

{ #category : #'API - remotes' }
RedDebuggerServer class >> url [
	^ZnUrl fromString: 'http://localhost:8008'
]

{ #category : #debuggers }
RedDebuggerServer >> debuggerAt: anInteger [

	^ self debuggers at: anInteger
]

{ #category : #accessing }
RedDebuggerServer >> debuggers [

	^ debuggers ifNil: [ debuggers := Dictionary new ]
]

{ #category : #accessing }
RedDebuggerServer >> debuggers: anObject [

	debuggers := anObject
]

{ #category : #options }
RedDebuggerServer >> delegate: aZnDelegate [
	server delegate: aZnDelegate
]

{ #category : #initialization }
RedDebuggerServer >> initialize [
	server := ZnServer on: 8008.
	RedDebuggerServerDelegate on: self.
	semaphores := Dictionary new.
	server start
]

{ #category : #debuggers }
RedDebuggerServer >> newRemoteDebuggerNotificationFor: aDebugger [

	^ RedNewRemoteDebugger new
		  sessionHash: aDebugger debugSessionHash;
		  sessionDescription: aDebugger interruptedContext printString;
		  remoteUrl: self url;
		  yourself
]

{ #category : #debuggers }
RedDebuggerServer >> notifyMasterForNewOpenedDebugger: aDebugger [

	ZnEasy
		put: self class newRemoteDebuggerNotificationURL
		data: (ZnEntity text: (STON toString: (self newRemoteDebuggerNotificationFor: aDebugger)))
]

{ #category : #debuggers }
RedDebuggerServer >> registerAndNotifyNewDebugger: aRedDebugger [

	self registerNewDebugger: aRedDebugger.
	self notifyMasterForNewOpenedDebugger: aRedDebugger 
]

{ #category : #debuggers }
RedDebuggerServer >> registerNewDebugger: aRedDebugger [

	self debuggers at: aRedDebugger debugSessionHash put: aRedDebugger.
	aRedDebugger server: self
]

{ #category : #update }
RedDebuggerServer >> releaseSemaphoreAt: sessionHash [

	(self semaphores at: sessionHash) signal
]

{ #category : #debuggers }
RedDebuggerServer >> removeDebugger: aDebugSessionHash [

	self debuggers removeKey: aDebugSessionHash ifAbsent: [  ]
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

{ #category : #accessing }
RedDebuggerServer >> url [
	^self class url
]

{ #category : #accessing }
RedDebuggerServer >> waitOnSemaphoreAt: debugSessionHash [

	(self semaphores at: debugSessionHash) wait
]
