Class {
	#name : 'RedDebuggerClientTest',
	#superclass : 'RedDebuggerTestCase',
	#instVars : [
		'client',
		'newDebuggerNotification'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'running' }
RedDebuggerClientTest >> setUp [

	super setUp.

	client := RedDebuggerClient new.
	newDebuggerNotification := RedNewRemoteDebugger new
		                           sessionHash: 1;
		                           sessionDescription: 2;
		                           remoteUrl: 3
]

{ #category : 'running' }
RedDebuggerClientTest >> tearDown [

	client stop.
	super tearDown
]

{ #category : 'tests' }
RedDebuggerClientTest >> testAnnouncer [
	self assert: client announcer notNil
]

{ #category : 'tests' }
RedDebuggerClientTest >> testClosedRemoteDebugger [

	| presenter notification |
	presenter := RedDebuggerClientPresenterMock new.
	client registerForNewDebuggerAnnouncements: presenter.

	self assert: client registeredDebuggers isEmpty.

	client newRemoteDebugger: newDebuggerNotification.
	notification := client registeredDebuggers at: 1.

	self assert: notification identicalTo: newDebuggerNotification.
	self
		assert: presenter notification
		identicalTo: newDebuggerNotification.

	notification := RedRemoteDebuggerClosed new
		                sessionHash:
			                newDebuggerNotification sessionHash;
		                remoteUrl: debuggerServer url;
		                yourself.

	client newClosedDebugger: notification.

	self assertEmpty: client registeredDebuggers.
	self assert: presenter notification identicalTo: notification
]

{ #category : 'tests' }
RedDebuggerClientTest >> testExecuteRemoteCommandForContextInSession [

	| remoteContext receivedCommand |
	RedDebuggerServer reset.
	remoteContext := RedRemoteContextModel new.
	remoteContext contextHash: 2.
	newDebuggerNotification remoteUrl: RedDebuggerServer url.

	masterServer
		withServerDo: [ :server | 
			client
				executeRemoteCommand: RedDebuggerTestCommand new
				forContext: remoteContext
				inSession: newDebuggerNotification ]
		route: RedDebuggerTestCommand route
		port: RedDebuggerServer url port.
		
	receivedCommand := masterServer masterNotification.
	self assert: receivedCommand class identicalTo: RedDebuggerTestCommand.
	self assert: receivedCommand contextHash equals: remoteContext contextHash.
	self assert: receivedCommand debugSessionHash equals: newDebuggerNotification sessionHash
]

{ #category : 'tests' }
RedDebuggerClientTest >> testNewRemoteDebugger [

	|presenter notification|
	
	presenter := RedDebuggerClientPresenterMock new.
	client registerForNewDebuggerAnnouncements: presenter.
	
	self assert: client registeredDebuggers isEmpty.
	
	client newRemoteDebugger: newDebuggerNotification.	
	notification := client registeredDebuggers at: 1.
	
	self assert: notification identicalTo: newDebuggerNotification.
	self assert: presenter notification identicalTo: newDebuggerNotification
	
	
]

{ #category : 'tests' }
RedDebuggerClientTest >> testRegisterForNewDebuggerAnnouncements [

	|presenter|
	
	presenter := RedDebuggerClientPresenterMock new.
	client registerForNewDebuggerAnnouncements: presenter.
	client announcer announce: newDebuggerNotification.
	
	self assert: presenter notification identicalTo: newDebuggerNotification
	
	
]

{ #category : 'tests' }
RedDebuggerClientTest >> testRegisteredDebuggers [
	self assert: client registeredDebuggers isEmpty
]

{ #category : 'tests' }
RedDebuggerClientTest >> testServer [

	| server answer notification |
	server := client server.
	self assert: server isRunning.
	self assert: client registeredDebuggers isEmpty.
	
	answer := ZnEasy
		          put: RedDebuggerServer newRemoteDebuggerNotificationURL
		          data:
		          (ZnEntity text: (STON toString: newDebuggerNotification)).
		
	self assert: answer statusLine equals: ZnStatusLine ok.
	self assert: client registeredDebuggers size equals: 1.
		
	notification := client registeredDebuggers at: 1.
	self assert: notification sessionHash equals: newDebuggerNotification sessionHash.
	self assert: notification sessionDescription equals: newDebuggerNotification sessionDescription.
	self assert: notification remoteUrl equals: newDebuggerNotification remoteUrl
]

{ #category : 'tests' }
RedDebuggerClientTest >> testStop [

	self assert: client server isRunning.
	client server stop.
	self deny: client server isRunning
]
