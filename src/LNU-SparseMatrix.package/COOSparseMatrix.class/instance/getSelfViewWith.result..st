as yet unclassified
getSelfViewWith: rightMatrix result: result
	| composer |
	composer := self getComposer.
	MatrixVisualizer on: self withView: composer view.
	composer group: #left.
	result
		first:
			((COOSparseMatrixNode new row: 0 column: 0 value: 0)
				rightNeighbour: nil).
	result last: result first.
	"add result and new right matrices to the view and update the view"
	MatrixVisualizer on: rightMatrix withView: composer view.
	composer group: #right.
	MatrixVisualizer on: result withView: composer view.
	composer group: #result.
	composer move: #left onTheLeftOf: #right.
	composer move: #result onTheRightOf: #right.
	composer setBackgroundColor: (Color gray alpha: 0.2) forGroup: #right.
	composer setBackgroundColor: (Color gray alpha: 0.2) forGroup: #left.
	"composer setBackgroundColor: (Color gray alpha: 0.2) forGroup: #result."
	composer nameGroup: #left as: 'left'.
	composer nameGroup: #right as: 'right'.
	composer nameGroup: #result as: 'result'.
	composer group: #labels.
	^ composer