Class {
	#name : 'BaselineOfRed',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRed',
	#package : 'BaselineOfRed'
}

{ #category : 'baselines' }
BaselineOfRed >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec baseline: 'PyBridge' with: [ 
		spec
			repository: 'github://adri09070/pybridge:pharo-bridge/src' ;
			loads: 'default' ].
		
		spec
			package: 'Red' with: [ spec requires: #( 'PyBridge' ) ];
			package: 'Red-Tests' ]
]
