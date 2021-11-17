"
I build debug sessions for test purposes.
"
Class {
	#name : #RedDebugSessionBuilder,
	#superclass : #Object,
	#category : #'Red-Tests'
}

{ #category : #tests }
RedDebugSessionBuilder >> testDebugSession [

	^ DebugSession basicNew
		  updateContextTo: Object new;
		  yourself
]
