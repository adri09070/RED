"
I order the debugger holding the debug session represented by the debugSession hash I hold to return the current stack
"
Class {
	#name : #RedDebuggerStackCommand,
	#superclass : #RedDebuggerCommand,
	#category : #Red
}

{ #category : #options }
RedDebuggerStackCommand class >> route [
	^'stack'
]

{ #category : #executing }
RedDebuggerStackCommand >> execute [
	"I do nothin, the stack is returned by default (for now)"
			
]
