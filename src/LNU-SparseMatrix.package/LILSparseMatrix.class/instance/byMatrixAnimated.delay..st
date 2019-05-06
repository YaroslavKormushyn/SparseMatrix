private
byMatrixAnimated: aLILSparseMatrix delay: delay
	| result other index sum list arr cachedLeftRow cachedRightColumn vis operationProcess leftMarkerElement rightMarkerElement nowProcessingElementIndex newElementValue|
	columnNumber = aLILSparseMatrix rowNumber
		ifFalse: [ Error signal: 'Invalid matrix sizes' ].
	(aLILSparseMatrix isEmpty or: [ self isEmpty ])
		ifTrue:
			[ ^ self class rows: rowNumber columns: aLILSparseMatrix columnNumber ].
	other := aLILSparseMatrix transpose.
	result := self class
		rows: rowNumber
		columns: aLILSparseMatrix columnNumber.
	vis := MatrixOperationVisualizer new.
	vis delay: delay.
	vis getComposedViewOf: self with: other result: result.
	vis namedGroups: #(#left #result #right #leftMarker #rightMarker).
	vis backgroundGroups: #(#left #result #right).
	leftMarkerElement := (LILSparseMatrixVisualizer new
		getElementShapeScaled: 5) elementOn: LILSparseMatrixNode new.
	vis add: leftMarkerElement.
	vis group: #leftMarker.
	rightMarkerElement := (LILSparseMatrixVisualizer new
		getElementShapeScaled: 5) elementOn: LILSparseMatrixNode new.
	vis add: rightMarkerElement.
	vis group: #rightMarker.
	nowProcessingElementIndex := (RTLabel
		text:
			[ :indices | 'Now processing ' , (indices first @ indices last) asString ])
		elementOn: {0 . 0}.
	vis add: nowProcessingElementIndex.
	vis group: #nowProcessing.
	newElementValue := (RTLabel text: [:value | 'New element value: ', value asString]) elementOn: 0.
	vis add: newElementValue.
	vis group: #newElementValue.
	vis composer move: #leftMarker below: #left.
	vis composer move: #rightMarker below: #right.
	vis composer move: #nowProcessing above: #right.
	vis composer move: #newElementValue onTheRightOf: #nowProcessing.
	vis redrawNamesAndBackgrounds.
	vis groupToExisting: #labels.
	vis update.
	operationProcess := [ arr := (1 to: result rowNumber)
		collect: [ :rowIndex | 
			list := LinkedList with: LILSparseMatrixNode new.
			(vis composer hasGroup: #newRowList)
				ifTrue: [ vis composer removeGroup: #newRowList ].
			LILSparseMatrixVisualizer
				onLinkedList: list
				inRow: rowIndex
				withView: vis view.
			vis group: #newRowList.
			vis move: #newRowList above: #nowProcessing.
			cachedLeftRow := rows at: rowIndex.
			1 to: result columnNumber do: [ :columnIndex | 
				nowProcessingElementIndex
					model:
						{rowIndex.
						columnIndex}.
				nowProcessingElementIndex update.
				cachedRightColumn := other rows at: columnIndex.
				sum := (cachedLeftRow
					collect: [ :leftNode | 
						index := cachedRightColumn
							findFirst: [ :rightNode | rightNode column = leftNode column ].
						leftMarkerElement updateModelAndRedraw: leftNode.
						vis selectModel: leftNode inGroup: #left.
						index = 0
						ifTrue: [ vis deselectModel: leftNode inGroup: #left. nil ]
							ifFalse: [ rightMarkerElement
									updateModelAndRedraw: (cachedRightColumn at: index).
								vis selectModel: (cachedRightColumn at: index) inGroup: #right.
								vis delay wait.
								vis deselectModel: leftNode inGroup: #left.
								vis
									deselectModel: (cachedRightColumn at: index)
									inGroup: #right.
									newElementValue model: newElementValue model + (leftNode value * (cachedRightColumn at: index) value).
									newElementValue update.
								leftNode value * (cachedRightColumn at: index) value ] ]
					thenReject: [ :el | el isNil ]) detectSum: [ :each | each ].
				sum = 0
					ifFalse: [ list addLast: (LILSparseMatrixNode column: columnIndex value: sum).
						sum := 0.
						vis composer removeGroup: #newRowList.
						LILSparseMatrixVisualizer
							onLinkedList: list
							inRow: rowIndex
							withView: vis view.
						vis group: #newRowList.
						vis move: #newRowList above: #nowProcessing.
						newElementValue model: 0.
						newElementValue update.
						vis redrawNamesAndBackgrounds.
						vis composer view canvas focusOnCenterScaled.
						vis delay wait ] ].
			list ].
	arr keysAndValuesDo: [ :i :li | result rows at: i put: li.
		(vis composer hasGroup: #newRowList) ifTrue: [ vis composer removeGroup: #newRowList ].
		vis updateResultWith: result.
		vis composer view canvas focusOnCenterScaled.
		vis delay wait ] ]
		newProcess.
	vis setUpMenuWithProcess: operationProcess.
	^ vis view