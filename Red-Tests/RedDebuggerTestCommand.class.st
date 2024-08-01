"
I am a remote test command, just there for test purposes.
"
Class {
	#name : 'RedDebuggerTestCommand',
	#superclass : 'RedDebuggerCommand',
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'options' }
RedDebuggerTestCommand class >> route [
	^'redTestCommand'
]

{ #category : 'executing' }
RedDebuggerTestCommand >> execute [
	"I am a test command, I do nothing"
]
