"
I order the debugger holding the debug session represented by the debugSession hash I hold to proceed
"
Class {
	#name : #RedDebuggerProceedCommand,
	#superclass : #RedDebuggerCommand,
	#category : #Red
}

{ #category : #executing }
RedDebuggerProceedCommand >> execute [
	debugger proceed
			
]
