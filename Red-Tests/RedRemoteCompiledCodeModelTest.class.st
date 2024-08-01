Class {
	#name : 'RedRemoteCompiledCodeModelTest',
	#superclass : 'RedDebuggerTestCase',
	#instVars : [
		'compiledCode'
	],
	#category : 'Red-Tests',
	#package : 'Red-Tests'
}

{ #category : 'running' }
RedRemoteCompiledCodeModelTest >> setUp [

	super setUp.
	compiledCode := debugSession interruptedContext compiledCode
]

{ #category : 'tests' }
RedRemoteCompiledCodeModelTest >> testVisitCompiledCodeBlock [

	| model |
	model := RedRemoteCompiledCodeModel new visitCompiledCode:
		         compiledCode.
	self assertModel: model modelsCompiledCode: compiledCode
]

{ #category : 'tests' }
RedRemoteCompiledCodeModelTest >> testVisitCompiledCodeMethod [

	| model |
	compiledCode := Point >> #+.
	model := RedRemoteCompiledCodeModel new visitCompiledCode:
		         compiledCode.

	self assertModel: model modelsCompiledCode: compiledCode
]
