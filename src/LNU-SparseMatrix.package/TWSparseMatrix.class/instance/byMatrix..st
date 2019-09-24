private
byMatrix: aMatrix
	| result rowNumbers columnNumbers lastInRowMarkers lastInColumnMarkers leftMarker rightMarker sum newNode |
	self columnsNumber ~= aMatrix rowsNumber
		ifTrue: [ Error signal: 'Size mismatch. Left: ' , self columnsNumber , ' Right: ' , aMatrix rowsNumber ].
	result := self class new rows: self rowsNumber columns: aMatrix columnsNumber.
	(self isEmpty or: aMatrix isEmpty)
		ifTrue: [ ^ result ].
	lastInRowMarkers := result rows copy.
	lastInColumnMarkers := result columns copy.
	rowNumbers := self rows reject: [ :rowHead | rowHead rightNeighbour = rowHead ] thenCollect: [ :rowHead | rowHead row ].
	columnNumbers := aMatrix rows reject: [ :colHead | colHead belowNeighbour = colHead ] thenCollect: [ :colHead | colHead row ].
	rowNumbers
		do: [ :rowIndex | 
			columnNumbers
				do: [ :columnIndex | 
					leftMarker := (self rows at: rowIndex) rightNeighbour.
					rightMarker := (aMatrix columns at: columnIndex) belowNeighbour.
					sum := 0.
					[ leftMarker column ~= 0 and: [ rightMarker row ~= 0 ] ]
						whileTrue: [ leftMarker column < rightMarker row
								ifTrue: [ leftMarker := leftMarker rightNeighbour ]
								ifFalse: [ leftMarker column > rightMarker row
										ifTrue: [ rightMarker := rightMarker belowNeighbour ]
										ifFalse: [ sum := sum + (leftMarker value * rightMarker value).
											rightMarker := rightMarker belowNeighbour.
											leftMarker := leftMarker rightNeighbour. ] ] ].
					sum ~= 0
						ifTrue: [ newNode := TWSparseMatrixNode new value: sum row: rowIndex column: columnIndex.
							(lastInRowMarkers at: rowIndex) rightNeighbour: newNode.
							(lastInColumnMarkers at: columnIndex) belowNeighbour: newNode.
							lastInRowMarkers at: rowIndex put: newNode.
							lastInColumnMarkers at: columnIndex put: newNode ] ] ].
				result rows withIndexDo: [ :rowHead :rowIndex | (lastInRowMarkers at: rowIndex) rightNeighbour: rowHead ].
				result columns withIndexDo: [ :colHead :colIndex | (lastInColumnMarkers at: colIndex ) belowNeighbour: colHead ].
	^ result