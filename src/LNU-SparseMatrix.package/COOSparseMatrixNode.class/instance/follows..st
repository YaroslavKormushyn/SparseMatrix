as yet unclassified
follows: aCOOMatrixNode
	^ (row > aCOOMatrixNode row) | ((row = aCOOMatrixNode row) & (column > aCOOMatrixNode column))