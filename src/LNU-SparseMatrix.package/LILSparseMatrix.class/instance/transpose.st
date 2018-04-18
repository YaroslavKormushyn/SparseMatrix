transformation
transpose
	| result tempList index |
	result := self class rows: columnNumber columns: rowNumber.
	1 to: columnNumber do: [ :columnIndex |
		tempList := LinkedList new.
		1 to: rowNumber do: [ :rowIndex | 
			(self rows at: rowIndex) isEmpty 
			ifFalse: [
			(self rows at: rowIndex) first 
				ifNotNil: [index := (self rows at: rowIndex) 
								   findFirst: [ :element | element column = columnIndex ].
						index = 0
							ifFalse: [ tempList addLast: (LILSparseMatrixNode 
															column: rowIndex 
															value: ((self rows at: rowIndex) at: index) value)]]]].
		result rows at: columnIndex put: tempList].
	^ result