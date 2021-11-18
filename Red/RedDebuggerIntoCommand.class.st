"
I order the debugger holding the debug session represented by the debugSession hash I hold to step into the context that has the same context hash I hold
"
Class {
	#name : #RedDebuggerIntoCommand,
	#superclass : #RedDebuggerCommand,
	#category : #Red
}

{ #category : #executing }
RedDebuggerIntoCommand >> execute [
	debugger stepInto: context
	
]
