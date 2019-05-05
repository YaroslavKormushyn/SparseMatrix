arithmetic
addAnimated: aLILSparseMatrix delay: delay
	| result arr list operationProcess vis leftMatrixRow rightMatrixRow |
	rowNumber = aLILSparseMatrix rowNumber
		& (columnNumber = aLILSparseMatrix columnNumber)
		ifFalse: [ Error signal: 'Matrices must be of the same size.' ].
	result := self class rows: rowNumber columns: columnNumber.
	vis := MatrixOperationVisualizer new.
	vis delay: delay.
	vis getComposedViewOf: self with: aLILSparseMatrix result: result.
	operationProcess := [ | unionLabel nowProcLabel |
	unionLabel := (RTLabel text: 'U') element.
	vis add: unionLabel.
	vis group: #unionLabel.
	leftMatrixRow := LILSparseMatrixVisualizer
		onRow: 1
		in: self
		withView: vis view.
	vis group: #leftRow.
	rightMatrixRow := LILSparseMatrixVisualizer
		onRow: 1
		in: aLILSparseMatrix
		withView: vis view.
	vis group: #rightRow.
	nowProcLabel := (RTLabel
		text: [ :col | 'Processing column ' , col asString ]) elementOn: 0.
	vis add: nowProcLabel.
	vis group: #nowProc.
	vis composer move: #leftRow below: #left.
	vis composer move: #rightRow below: #right.
	vis composer move: #nowProc below: #rightRow.
	vis composer move: #unionLabel between: #leftRow and: #rightRow.
	vis composer nameGroup: #leftRow as: 'leftRow'.
	vis composer nameGroup: #rightRow as: 'rightRow'.
	vis composer groupToExisting: 'labels'.
	vis namedGroups: #(#left #result #right #leftRow #rightRow).
	vis backgroundGroups: #(#left #result #right #leftRow #rightRow).
	vis composer redrawNamesAndBackgroundsFor: vis namedGroups.
	vis update.
	vis delay wait.
	arr := (1 to: result rowNumber)
		collect: [ :row | 
			arr := (rows at: row) union: (aLILSparseMatrix rows at: row).
			arr := (1 to: columnNumber)
				collect: [ :columnIndex | 
					nowProcLabel model: columnIndex.
					nowProcLabel update.
					vis composer
						deselectUsing: [ :model | model column = (columnIndex - 1) ]
						inGroup: #leftRow.
					vis composer
						deselectUsing: [ :model | model column = (columnIndex - 1) ]
						inGroup: #rightRow.
					vis composer
						selectUsing: [ :model | model column = columnIndex ]
						inGroup: #leftRow.
					vis composer
						selectUsing: [ :model | model column = columnIndex ]
						inGroup: #rightRow.
					vis delay wait.
					LILSparseMatrixNode
						column: columnIndex
						value:
							((arr select: [ :node | node column = columnIndex ])
								inject: 0
								into: [ :sum :element | sum + element value ]) ]
				thenReject: [ :node | node value = 0 ].
			"last column was not deselected"
			vis composer
				deselectUsing: [ :model | model column = columnNumber ]
				inGroup: #leftRow.
			vis composer
				deselectUsing: [ :model | model column = columnNumber ]
				inGroup: #rightRow.
			nowProcLabel model: 'none'.
			nowProcLabel update.
			vis delay wait.
			list := LinkedList new.
			LILSparseMatrixVisualizer onLinkedList: list withView: vis view.
			vis group: #newRow.
			vis composer move: #newRow below: #rightRow.
			arr
				do: [ :node | 
					list addLast: node.
					vis composer removeGroup: #newRow.
					LILSparseMatrixVisualizer
						onLinkedList: list
						inRow: row
						withView: vis view.
					vis group: #newRow.
					vis composer move: #newRow onTheRightOf: #rightRow.
					self halt.
					vis composer redrawNamesFor: vis namedGroups.
					vis composer redrawBackgroundsFor: vis backgroundGroups.
					vis delay wait ].
			list ].
	1 to: result rowNumber do: [ :rowIndex | 
		result rows at: rowIndex put: (arr at: rowIndex).
		vis updateResultWith: result.
		vis delay wait ] ] newProcess.
	vis setUpMenuWithProcess: operationProcess.
	^ vis view