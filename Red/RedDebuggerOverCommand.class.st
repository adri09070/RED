"
I order the debugger holding the debug session represented by the debugSession hash I hold to step over the context that has the same context hash I hold
"
Class {
	#name : 'RedDebuggerOverCommand',
	#superclass : 'RedDebuggerCommand',
	#category : 'Red',
	#package : 'Red'
}

{ #category : 'options' }
RedDebuggerOverCommand class >> route [
	^'over'
]

{ #category : 'executing' }
RedDebuggerOverCommand >> execute [
	debugger stepOver: context
			
]
