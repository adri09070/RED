"
I order the debugger holding the debug session represented by the debugSession hash I hold to proceed
"
Class {
	#name : 'RedDebuggerProceedCommand',
	#superclass : 'RedDebuggerCommand',
	#category : 'Red',
	#package : 'Red'
}

{ #category : 'options' }
RedDebuggerProceedCommand class >> route [
	^'proceed'
]

{ #category : 'executing' }
RedDebuggerProceedCommand >> answer [
	^{}
			
]

{ #category : 'executing' }
RedDebuggerProceedCommand >> execute [
	debugger proceed
			
]

{ #category : 'executing' }
RedDebuggerProceedCommand >> findContext [
	"I don't need any context"
]
