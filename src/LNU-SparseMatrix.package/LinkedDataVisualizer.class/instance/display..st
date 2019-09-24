accessing
display: linkedStructure
	| nodes elements |
	(linkedStructure respondsTo: #viewElements)
		ifFalse: [ ^ Error
				signal: 'Container should expose ' , #viewElements asByteString ].
	nodes := linkedStructure viewElements.
	elements := (shapes at: #data) elementsOn: nodes.
	elements @ RTDraggable @ RTPopup.
	composer view addAll: elements.
	RTGridLayout on: elements.
	self drawEdgesWith: elements.
	self setPositionsFor: elements