"
I present the available remote debug sessions and allows for quick actions:
- debug
- proceed
- kill
"
Class {
	#name : #RedRemoteDebugSessionsPresenter,
	#superclass : #RedAbstractDebuggerPresenter,
	#instVars : [
		'sessions'
	],
	#category : #Red
}

{ #category : #all }
RedRemoteDebugSessionsPresenter class >> debugWorldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder group: #Red)
		parent: #Debug;
		order: 0;
		withSeparatorAfter.
	(aBuilder item: 'Remote Debugger Sessions')
		order: 1;
		icon: (self iconNamed: #remote);
		parent: #Red;
		help: 'Reset the counters on the executions counters.';
		action: [ self new open ]
]

{ #category : #layout }
RedRemoteDebugSessionsPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #toolbar expand: false;
		  add: #sessions;
		  yourself
]

{ #category : #building }
RedRemoteDebugSessionsPresenter >> buildToolbar [

	| commandGroup |
	commandGroup := CmCommandGroup forSpec.
	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Proceed'
			 action: [ :context | context proceedSelection ]
			 iconNamed: #glamorousGo).

	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Terminate'
			 action: [ :context | context terminateSelection ]
			 iconNamed: #changeRemove).

	commandGroup register: (self
			 buildToolbarButtonLabeled: 'Debug'
			 action: [ :context | context debugSelection ]
			 iconNamed: #glamorousBug).
	^ self newToolbar
		  fillWith: commandGroup;
		  yourself
]

{ #category : #actions }
RedRemoteDebugSessionsPresenter >> debugSelection [

	RedRemoteDebuggerPresenter openOn: sessions selectedItem
]

{ #category : #initialization }
RedRemoteDebugSessionsPresenter >> initialize [
	super initialize.
	RedDebuggerClient current registerForNewDebuggerAnnouncements: self
]

{ #category : #initialization }
RedRemoteDebugSessionsPresenter >> initializePresenters [

	super initializePresenters.

	sessions := self newTable.
	sessions addColumn: ((SpImageTableColumn title: '' evaluated: [ :context | self iconNamed: #remote])
			 width: 8;
			 sortFunction: nil;
			 yourself).
	sessions addColumn: ((SpStringTableColumn title: 'Session' evaluated: [ :item | item sessionDescription ])
			 sortFunction: nil;
			 yourself).
	sessions addColumn: ((SpStringTableColumn title: 'URL' evaluated: [ :item | item remoteUrl ])
			 sortFunction: nil;
			 yourself).
	sessions items: RedDebuggerClient current registeredDebuggers values
]

{ #category : #announcements }
RedRemoteDebugSessionsPresenter >> newRemoteDebugger: anObject [

	sessions items: RedDebuggerClient current registeredDebuggers values
]

{ #category : #actions }
RedRemoteDebugSessionsPresenter >> proceedSelection [
	RedDebuggerClient current proceedSession: sessions selectedItem
]

{ #category : #announcements }
RedRemoteDebugSessionsPresenter >> remoteDebuggerRemoved: aRedRemoteDebuggerClosedAnnouncement [

	RedDebuggerClient current removeKey:
		aRedRemoteDebuggerClosedAnnouncement debugSessionHash.
	sessions items: RedDebuggerClient current registeredDebuggers values
]

{ #category : #initialization }
RedRemoteDebugSessionsPresenter >> title [
	 ^'Red sessions'
]
