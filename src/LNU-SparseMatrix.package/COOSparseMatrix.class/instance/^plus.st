arithmetic
+ aCOOMatrix
	| leftMatrixMarker rightMatrixMarker result head tail newNode continue |
	(aCOOMatrix isMemberOf: self class)
		ifFalse: [ Error signal: 'Convert matrix'].
	(rowNumber = aCOOMatrix rowNumber and: [ columnNumber = aCOOMatrix columnNumber ])
		ifFalse: [ Error signal: 'Matrices must be of same size' ].
	result := self class rows: rowNumber columns: columnNumber.
	leftMatrixMarker := first.
	rightMatrixMarker := aCOOMatrix first.
	(leftMatrixMarker preceeds: rightMatrixMarker)
		ifTrue: [ head := leftMatrixMarker copy.
			tail := head.
			leftMatrixMarker := leftMatrixMarker rightNeighbour ]
		ifFalse: [ (leftMatrixMarker follows: rightMatrixMarker)
				ifTrue: [ head := rightMatrixMarker copy.
					tail := head.
					rightMatrixMarker := rightMatrixMarker rightNeighbour ]
				ifFalse: [ rightMatrixMarker value + leftMatrixMarker value = 0
						ifTrue: [ tail := head := COOSparseMatrixNode row: 0 column: 0 value: 0 ]
						ifFalse: [ head := rightMatrixMarker copy value: rightMatrixMarker value + leftMatrixMarker value.
							tail := head ].
					rightMatrixMarker := rightMatrixMarker rightNeighbour.
					leftMatrixMarker := leftMatrixMarker rightNeighbour ] ].
	[ leftMatrixMarker isNotNil and: [ rightMatrixMarker isNotNil ] ]
		whileTrue: [ (leftMatrixMarker preceeds: rightMatrixMarker)
				ifTrue: [ newNode := COOSparseMatrixNode
						row: leftMatrixMarker row
						column: leftMatrixMarker column
						value: leftMatrixMarker value.
					leftMatrixMarker := leftMatrixMarker rightNeighbour ]
				ifFalse: [ (leftMatrixMarker follows: rightMatrixMarker)
						ifTrue: [ newNode := COOSparseMatrixNode
								row: rightMatrixMarker row
								column: rightMatrixMarker column
								value: rightMatrixMarker value.
							rightMatrixMarker := rightMatrixMarker rightNeighbour ]
						ifFalse: [ (leftMatrixMarker row = rightMatrixMarker row
								and: [ leftMatrixMarker column = rightMatrixMarker column ])
								ifTrue: [ leftMatrixMarker value + rightMatrixMarker value = 0
										ifTrue: [ continue := true ]
										ifFalse: [ newNode := COOSparseMatrixNode
												row: leftMatrixMarker row
												column: leftMatrixMarker column
												value: leftMatrixMarker value + rightMatrixMarker value ].
									rightMatrixMarker := rightMatrixMarker rightNeighbour.
									leftMatrixMarker := leftMatrixMarker rightNeighbour ] ] ].
			newNode isNil
				ifFalse: [ tail rightNeighbour: newNode.
					newNode leftNeighbour: tail.
					tail := newNode.
					newNode := nil ] ].
	[ leftMatrixMarker isNotNil ]
		whileTrue: [ newNode := COOSparseMatrixNode
				row: leftMatrixMarker row
				column: leftMatrixMarker column
				value: leftMatrixMarker value.
			leftMatrixMarker := leftMatrixMarker rightNeighbour.
			tail rightNeighbour: newNode.
			newNode leftNeighbour: tail.
			tail := newNode ].
	[ rightMatrixMarker isNotNil ]
		whileTrue: [ newNode := COOSparseMatrixNode
				row: rightMatrixMarker row
				column: rightMatrixMarker column
				value: rightMatrixMarker value.
			rightMatrixMarker := rightMatrixMarker rightNeighbour.
			tail rightNeighbour: newNode.
			newNode leftNeighbour: tail.
			tail := newNode ].

	"remove the dummy head if zero"
	head value = 0
		ifTrue: [ head := head rightNeighbour ].
	result
		first: head;
		last: tail.
	^ result