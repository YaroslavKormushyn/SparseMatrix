as yet unclassified
preceeds: aCOOMatrixNode
	^ (row < aCOOMatrixNode row) | ((row = aCOOMatrixNode row) & (column < aCOOMatrixNode column))