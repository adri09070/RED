"
I order the debugger holding the debug session represented by the debugSession hash I hold to recompile with a new source the context that has the same context hash I hold
"
Class {
	#name : #RedDebuggerRecompileSourceCommand,
	#superclass : #RedDebuggerCommand,
	#instVars : [
		'source'
	],
	#category : #Red
}

{ #category : #options }
RedDebuggerRecompileSourceCommand class >> route [
	^'recompile'
]

{ #category : #executing }
RedDebuggerRecompileSourceCommand >> execute [

	debugger recompileContext: context with: source
]

{ #category : #accessing }
RedDebuggerRecompileSourceCommand >> source: anObject [

	source := anObject
]
