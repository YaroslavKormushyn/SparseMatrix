arithmetic
addAnimated: aCOOMatrix
	| leftMatrixMarker rightMatrixMarker result newNode composer resultView |
	(aCOOMatrix isMemberOf: self class)
		ifFalse: [ Error signal: 'Convert matrix' ].
	(rowNumber = aCOOMatrix rowNumber
		and: [ columnNumber = aCOOMatrix columnNumber ])
		ifFalse: [ Error signal: 'Matrices must be of same size' ].
	result := self class rows: rowNumber columns: columnNumber.
	composer := self getSelfViewWith: aCOOMatrix result: result.
	composer view openTitled: 'Addition'.
	resultView := (MatrixVisualizer on: result) view.
	resultView openTitled: 'Result'.
	[ leftMatrixMarker := first.
	rightMatrixMarker := aCOOMatrix first.
	self activate: leftMatrixMarker in: #left on: composer.
	self activate: rightMatrixMarker in: #right on: composer.
	(Delay forSeconds: 1) wait.
	(leftMatrixMarker preceeds: rightMatrixMarker)
		ifTrue: [ self highlight: leftMatrixMarker in: #left on: composer.
			result first: leftMatrixMarker copy.
			result last: result first.
			resultView clean.
			MatrixVisualizer on: result withView: resultView.
			resultView signalUpdate.
			(Delay forSeconds: 1) wait.
			self deactivate: leftMatrixMarker in: #left on: composer.
			leftMatrixMarker := leftMatrixMarker rightNeighbour.
			self activate: leftMatrixMarker in: #left on: composer.
			(Delay forSeconds: 1) wait ]
		ifFalse: [ (leftMatrixMarker follows: rightMatrixMarker)
				ifTrue: [ self highlight: rightMatrixMarker in: #right on: composer.
					result first: rightMatrixMarker copy.
					result last: result first.
					resultView clean.
					MatrixVisualizer on: result withView: resultView.
					resultView signalUpdate.
					(Delay forSeconds: 1) wait.
					self deactivate: rightMatrixMarker in: #right on: composer.
					rightMatrixMarker := rightMatrixMarker rightNeighbour.
					self activate: rightMatrixMarker in: #right on: composer.
					(Delay forSeconds: 1) wait ]
				ifFalse: [ rightMatrixMarker value + leftMatrixMarker value = 0
						ifTrue: [ result first: (COOSparseMatrixNode row: 0 column: 0 value: 0).
							result last: result first.
							resultView clean.
							MatrixVisualizer on: result withView: resultView.
							resultView signalUpdate.
							(Delay forSeconds: 1) wait ]
						ifFalse: [ self highlight: leftMatrixMarker in: #left on: composer.
							self highlight: rightMatrixMarker in: #right on: composer.
							result
								first:
									(rightMatrixMarker copy
										value: rightMatrixMarker value + leftMatrixMarker value).
							result last: result first.
							resultView clean.
							MatrixVisualizer on: result withView: resultView.
							resultView signalUpdate.
							(Delay forSeconds: 1) wait ].
					self deactivate: leftMatrixMarker in: #left on: composer.
					self deactivate: rightMatrixMarker in: #right on: composer.
					rightMatrixMarker := rightMatrixMarker rightNeighbour.
					leftMatrixMarker := leftMatrixMarker rightNeighbour.
					self activate: leftMatrixMarker in: #left on: composer.
					self activate: rightMatrixMarker in: #right on: composer.
					(Delay forSeconds: 1) wait ] ].
	[ leftMatrixMarker isNotNil and: [ rightMatrixMarker isNotNil ] ]
		whileTrue: [ (leftMatrixMarker preceeds: rightMatrixMarker)
				ifTrue: [ self highlight: leftMatrixMarker in: #left on: composer.
					newNode := leftMatrixMarker copy.
					self deactivate: leftMatrixMarker in: #left on: composer.
					leftMatrixMarker := leftMatrixMarker rightNeighbour.
					self activate: leftMatrixMarker in: #left on: composer.
					(Delay forSeconds: 1) wait ]
				ifFalse: [ (leftMatrixMarker follows: rightMatrixMarker)
						ifTrue: [ self highlight: rightMatrixMarker in: #right on: composer.
							newNode := rightMatrixMarker copy.
							self deactivate: rightMatrixMarker in: #right on: composer.
							rightMatrixMarker := rightMatrixMarker rightNeighbour.
							self activate: rightMatrixMarker in: #right on: composer.
							(Delay forSeconds: 1) wait ]
						ifFalse: [ (leftMatrixMarker row = rightMatrixMarker row
								and: [ leftMatrixMarker column = rightMatrixMarker column ])
								ifTrue: [ leftMatrixMarker value + rightMatrixMarker value = 0
										ifFalse: [ self highlight: leftMatrixMarker in: #left on: composer.
											self highlight: rightMatrixMarker in: #right on: composer.
											(Delay forSeconds: 1) wait.
											newNode := leftMatrixMarker copy
												value: leftMatrixMarker value + rightMatrixMarker value ].
									self deactivate: leftMatrixMarker in: #left on: composer.
									self deactivate: rightMatrixMarker in: #right on: composer.
									rightMatrixMarker := rightMatrixMarker rightNeighbour.
									leftMatrixMarker := leftMatrixMarker rightNeighbour.
									self activate: leftMatrixMarker in: #left on: composer.
									self activate: rightMatrixMarker in: #right on: composer.
									(Delay forSeconds: 1) wait ] ] ].
			newNode isNil
				ifFalse: [ result last rightNeighbour: newNode.
					newNode leftNeighbour: result last.
					result last: newNode.
					resultView clean.
					MatrixVisualizer on: result withView: resultView.
					resultView signalUpdate.
					(Delay forSeconds: 1) wait.
					newNode := nil ] ].
	[ leftMatrixMarker isNotNil ]
		whileTrue: [ self highlight: leftMatrixMarker in: #left on: composer.
			(Delay forSeconds: 1) wait.
			newNode := leftMatrixMarker copy.
			self deactivate: leftMatrixMarker in: #left on: composer.
			leftMatrixMarker := leftMatrixMarker rightNeighbour.
			self activate: leftMatrixMarker in: #left on: composer.
			result last rightNeighbour: newNode.
			newNode leftNeighbour: result last.
			result last: newNode.
			resultView clean.
			MatrixVisualizer on: result withView: resultView.
			resultView signalUpdate.
			(Delay forSeconds: 1) wait ].
	[ rightMatrixMarker isNotNil ]
		whileTrue: [ self highlight: rightMatrixMarker in: #right on: composer.
			(Delay forSeconds: 1) wait.
			newNode := rightMatrixMarker copy.
			self deactivate: rightMatrixMarker in: #right on: composer.
			rightMatrixMarker := rightMatrixMarker rightNeighbour.
			self activate: rightMatrixMarker in: #right on: composer.
			result last rightNeighbour: newNode.
			newNode leftNeighbour: result last.
			result last: newNode.
			resultView clean.
			MatrixVisualizer on: result withView: resultView.
			resultView signalUpdate.
			(Delay forSeconds: 1) wait ].

	"remove the dummy head if zero"
	result first value = 0
		ifTrue: [ result first: result first rightNeighbour.
			resultView clean.
			MatrixVisualizer on: result withView: resultView.
			resultView signalUpdate.
			(Delay forSeconds: 1) wait ].
	result ] fork