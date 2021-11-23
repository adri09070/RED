Extension { #name : #StDebuggerActionModel }

{ #category : #'*Red' }
StDebuggerActionModel >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

	self session
		recompileMethodTo: aString
		inContext: aContext
		notifying: aNotifyer
]
