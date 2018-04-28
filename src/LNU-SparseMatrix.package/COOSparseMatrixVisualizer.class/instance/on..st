instance creation
on: aCOOSparseMatrix
	| comp nodes edgeBuilder elements offset |
	comp := self getElementShape.
	nodes := aCOOSparseMatrix elementsAsCollection.
	elements := comp elementsOn: nodes.
	elements @ RTDraggable.
	elements @ RTPopup.
	view addAll: elements.
	edgeBuilder := RTEdgeBuilder new.
	edgeBuilder view: view.
	edgeBuilder elements: elements.
	edgeBuilder
		shape:
			(RTStyledMultiLine new
				arrowHead;
				orthoHorizontal).
	edgeBuilder shape horizontalAttachPoint.
	edgeBuilder
		connectTo: [ :el | 
			(el rightNeighbour isNotNil and: [ el rightNeighbour row = el row ])
				ifTrue: [ el rightNeighbour ] ].
	edgeBuilder
		shape:
			(RTStyledMultiLine new
				arrowHead;
				orthoVertical).
	edgeBuilder shape verticalAttachPoint.
	edgeBuilder
		connectTo: [ :el | 
			(el rightNeighbour isNotNil and: [ el rightNeighbour row > el row ])
				ifTrue: [ el rightNeighbour ] ].
	RTGridLayout on: elements.
	offset := 10.
	elements
		do: [ :e | 
			| aNode rowOffset colOffset |
			aNode := e model.
			aNode column = 1
				ifTrue: [ colOffset := 0 ]
				ifFalse: [ colOffset := offset ].
			aNode row = 1
				ifTrue: [ rowOffset := 0 ]
				ifFalse: [ rowOffset := offset ].
			e translateTo: (aNode column * e width + ((aNode column - 1) * colOffset)) @ (aNode row * e height + ((aNode row - 1) * rowOffset)) ]