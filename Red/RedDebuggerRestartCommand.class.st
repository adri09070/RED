"
I order the debugger holding the debug session represented by the debugSession hash I hold to restart the context that has the same context hash I hold
"
Class {
	#name : #RedDebuggerRestartCommand,
	#superclass : #RedDebuggerCommand,
	#category : #Red
}

{ #category : #options }
RedDebuggerRestartCommand class >> route [
	^'restart'
]

{ #category : #executing }
RedDebuggerRestartCommand >> execute [
	debugger restartContext: context
			
]
