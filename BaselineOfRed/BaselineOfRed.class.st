Class {
	#name : #BaselineOfRed,
	#superclass : #BaselineOf,
	#category : #BaselineOfRed
}

{ #category : #baselines }
BaselineOfRed >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'Red';
			package: 'Red-Tests' ]
]
