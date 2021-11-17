"
I am the Zinc delegate for RedDebuggerServer.
I basically receive remote debugging instructions and transmit them to my RedDebuggerServer owner.
"
Class {
	#name : #RedDebuggerServerDelegate,
	#superclass : #ZnDefaultServerDelegate,
	#category : #Red
}

{ #category : #initialization }
RedDebuggerServerDelegate >> initialize [

	self
		map: 'into' to: #stepInto;
		map: 'over' to: #stepOver:;
		map: 'through' to: #stepThrough;
		map: 'proceed' to: #proceed;
		map: 'restart' to: #restart:;
		map: 'stack' to: #stack;
		map: 'modifySource' to: #modifySource:
]
