Class {
	#name : #RedRemoteContextModelTest,
	#superclass : #TestCase,
	#instVars : [
		'context',
		'sender'
	],
	#category : #'Red-Tests'
}

{ #category : #tests }
RedRemoteContextModelTest >> assertModel: aModel modelsContext: aContext [

	self assert: aModel contextHash equals: aContext hash.
	self assert: aModel methodSelector equals: aContext selector.
	self assert: aModel receiverClassName equals: aContext receiver class name.	
	self assert: aModel packageName equals: aContext method package name
	











































]

{ #category : #running }
RedRemoteContextModelTest >> setUp [

	super setUp.

	sender := Context
		           sender: nil
		           receiver: 1 @ 1
		           method: Point >> #+
		           arguments: { 1 }.
	context := Context
		                  sender: sender
		                  receiver: 1 @ 1
		                  method: Point >> #+
		                  arguments: { 1 }
]

{ #category : #tests }
RedRemoteContextModelTest >> testVisitContext [
	|model|
	model := RedRemoteContextModel new.
	model visitContext: context.
	
	self assert: model sender contextHash equals: context sender hash.	
	self assertModel: model modelsContext: context.
	self assertModel: model sender modelsContext: sender

















































]
