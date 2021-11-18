"
I order the debugger holding the debug session represented by the debugSession hash I hold to step through the context that has the same context hash I hold
"
Class {
	#name : #RedDebuggerThroughCommand,
	#superclass : #RedDebuggerCommand,
	#category : #Red
}

{ #category : #executing }
RedDebuggerThroughCommand >> execute [
	debugger stepThrough: context
			
]
