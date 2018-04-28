as yet unclassified
elementsAsCollection
	| marker result |
	self isEmpty
		ifTrue: [ ^ Collection new ].
	marker := self first.
	result := OrderedCollection new.
	[ marker isNotNil ] whileTrue: [ result add: marker. marker := marker rightNeighbour ].
	^ result