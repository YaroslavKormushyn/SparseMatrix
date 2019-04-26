private
byMatrixAnimated: aCOOSparseMatrix
	| composer result currentLeftRow currentRightColumn priorityColumn leftMatrixMarker leftSavedMatrixMarker rightMatrixMarker transposed newNode sum operationProcess operationBlock operationWindow resultView resultWindow leftMarkerElement rightMarkerElement |
	columnNumber = aCOOSparseMatrix rowNumber
		ifFalse: [ Error signal: 'Invalid matrix size' ].
	(aCOOSparseMatrix isEmpty or: [ self isEmpty ])
		ifTrue:
			[ ^ self class rows: rowNumber columns: aCOOSparseMatrix columnNumber ].
	result := self class
		rows: rowNumber
		columns: aCOOSparseMatrix columnNumber.
	transposed := aCOOSparseMatrix transpose.
	composer := self getSelfViewWith: transposed result: result.
	"resultView := (MatrixVisualizer on: result) view."
	operationBlock := [ leftSavedMatrixMarker := leftMatrixMarker := first.
	self activate: leftMatrixMarker in: #left on: composer.
	rightMatrixMarker := transposed first.
	self activate: rightMatrixMarker in: #right on: composer.
	currentLeftRow := leftMatrixMarker row.
	currentRightColumn := rightMatrixMarker row.
	leftMarkerElement := (COOSparseMatrixVisualizer new
		getElementShapeScaled: 5) elementOn: leftMatrixMarker.
	composer view add: leftMarkerElement.
	composer group: #leftMarker.
	rightMarkerElement := (COOSparseMatrixVisualizer new
		getElementShapeScaled: 5) elementOn: rightMatrixMarker.
	composer view add: rightMarkerElement.
	composer group: #rightMarker.
	composer move: #leftMarker below: #left.
	composer move: #rightMarker below: #right.
	composer nameGroup: #leftMarker as: 'left marker'.
	composer nameGroup: #rightMarker as: 'right marker'.
	composer groupToExisting: #labels.
	composer view signalUpdate.
	sum := 0.
	self
		withEscaper: [ :end | 
			[ rightMatrixMarker isNotNil or: [ leftMatrixMarker isNotNil ] ]
				whileTrue: [ self
						withEscaper: [ :outer | 
							"Switch to next row in left and reset right marker if right ended"
							rightMatrixMarker isNil
								ifTrue: [ rightMatrixMarker := transposed first.
									leftSavedMatrixMarker := leftMatrixMarker.
									self activate: leftMatrixMarker in: #left on: composer.
									self activate: rightMatrixMarker in: #right on: composer.
									leftMarkerElement updateModelAndRedraw: leftMatrixMarker.
									rightMarkerElement updateModelAndRedraw: rightMatrixMarker.
									(Delay forSeconds: 1) wait ].
							"reset left marker to row beginning"
							self deactivate: leftMatrixMarker in: #left on: composer.
							(Delay forSeconds: 1) wait.
							leftMatrixMarker := leftSavedMatrixMarker.
							self activate: leftMatrixMarker in: #left on: composer.
							leftMarkerElement updateModelAndRedraw: leftMatrixMarker.
							(Delay forSeconds: 1) wait.
							currentLeftRow := leftMatrixMarker row.
							currentRightColumn := rightMatrixMarker row.
							self
								withEscaper: [ :next | 
									[ leftMatrixMarker isNotNil
										and: [ rightMatrixMarker isNotNil
												and: [ leftMatrixMarker row = currentLeftRow
														and: [ rightMatrixMarker row = currentRightColumn ] ] ] ]
										whileTrue: [ priorityColumn := {leftMatrixMarker column.
											rightMatrixMarker column} max.
											"Find same column as prioritized or higher in left"
											[ leftMatrixMarker isNotNil
												and: [ leftMatrixMarker row = currentLeftRow
														and: [ leftMatrixMarker column < priorityColumn ] ] ]
												whileTrue: [ self deactivate: leftMatrixMarker in: #left on: composer.
													(Delay forSeconds: 1) wait.
													leftMatrixMarker := leftMatrixMarker rightNeighbour.
													self activate: leftMatrixMarker in: #left on: composer.
													leftMarkerElement updateModelAndRedraw: leftMatrixMarker.
													(Delay forSeconds: 1) wait ].
											leftMatrixMarker isNil
												ifTrue: [ [ rightMatrixMarker isNotNil
														and: [ rightMatrixMarker row = currentRightColumn ] ]
														whileTrue: [ self deactivate: rightMatrixMarker in: #right on: composer.
															(Delay forSeconds: 1) wait.
															rightMatrixMarker := rightMatrixMarker rightNeighbour.
															rightMatrixMarker isNotNil
																ifTrue: [ self activate: rightMatrixMarker in: #right on: composer.
																	rightMarkerElement
																		updateModelAndRedraw: rightMatrixMarker.
																	(Delay forSeconds: 1) wait ] ].

													"If no intersection - end"
													rightMatrixMarker isNil
														ifTrue: [ end value ].
													"Else - continue loop"
													next value ].
											leftMatrixMarker row ~= currentLeftRow
												ifTrue: [ [ rightMatrixMarker isNotNil
														and: [ rightMatrixMarker row = currentRightColumn ] ]
														whileTrue: [ self deactivate: rightMatrixMarker in: #right on: composer.
															(Delay forSeconds: 1) wait.
															rightMatrixMarker := rightMatrixMarker rightNeighbour.
															rightMatrixMarker isNotNil
																ifTrue: [ self activate: rightMatrixMarker in: #right on: composer.
																	rightMarkerElement
																		updateModelAndRedraw: rightMatrixMarker.
																	(Delay forSeconds: 1) wait ] ].
													next value ].
											priorityColumn := leftMatrixMarker column.

											"Find same column as prioritized or higher in right"
											[ rightMatrixMarker isNotNil
												and: [ rightMatrixMarker row = currentRightColumn
														and: [ rightMatrixMarker column < priorityColumn ] ] ]
												whileTrue: [ self deactivate: rightMatrixMarker in: #right on: composer.
													(Delay forSeconds: 1) wait.
													rightMatrixMarker := rightMatrixMarker rightNeighbour.
													rightMarkerElement
														updateModelAndRedraw: rightMatrixMarker.
													self activate: rightMatrixMarker in: #right on: composer.
													(Delay forSeconds: 1) wait ].
											rightMatrixMarker isNil
												ifTrue: [ [ leftMatrixMarker isNotNil
														and: [ leftMatrixMarker row = currentLeftRow ] ]
														whileTrue: [ self deactivate: leftMatrixMarker in: #left on: composer.
															(Delay forSeconds: 1) wait.
															leftMatrixMarker := leftMatrixMarker rightNeighbour.
															self activate: leftMatrixMarker in: #left on: composer.
															leftMarkerElement
																updateModelAndRedraw: leftMatrixMarker.
															(Delay forSeconds: 1) wait ].

													"If no intersections - end"
													leftMatrixMarker isNil
														ifTrue: [ end value ].
													"Else - continue loop"
													next value ].
											rightMatrixMarker row ~= currentRightColumn
												ifTrue: [ next value ].
											leftMatrixMarker column = rightMatrixMarker column
												ifTrue: [ self highlight: leftMatrixMarker in: #left on: composer.
													self highlight: rightMatrixMarker in: #right on: composer.
													(Delay forSeconds: 1) wait.
													sum := sum
														+ (leftMatrixMarker value * rightMatrixMarker value).
													self deactivate: leftMatrixMarker in: #left on: composer.
													self
														deactivate: rightMatrixMarker
														in: #right
														on: composer.
													(Delay forSeconds: 1) wait.
													leftMatrixMarker := leftMatrixMarker rightNeighbour.
													rightMatrixMarker := rightMatrixMarker rightNeighbour.
													leftMarkerElement updateModelAndRedraw: leftMatrixMarker.
													rightMarkerElement
														updateModelAndRedraw: rightMatrixMarker.
													self activate: leftMatrixMarker in: #left on: composer.
													self activate: rightMatrixMarker in: #right on: composer.
													(Delay forSeconds: 1) wait ]
												ifFalse: [ priorityColumn := rightMatrixMarker column ] ] ].
							sum = 0
								ifFalse: [ newNode := COOSparseMatrixNode
										row: currentLeftRow
										column: currentRightColumn
										value: sum.
									result last rightNeighbour: newNode.
									newNode leftNeighbour: result last.
									result last: newNode.
									sum := 0.
									self
										replaceElementsInGroup: #result
										with: result
										on: composer.
									composer move: #result onTheRightOf: #right ] ].
					sum = 0
						ifFalse: [ newNode := COOSparseMatrixNode
								row: currentLeftRow
								column: currentRightColumn
								value: sum.
							result last rightNeighbour: newNode.
							newNode leftNeighbour: result last.
							result last: newNode.
							sum := 0.
							self replaceElementsInGroup: #result with: result on: composer ] ] ].
	"nil the reference to dummy head"
	result first rightNeighbour leftNeighbour: nil.
	result first: result first rightNeighbour.
	self replaceElementsInGroup: #result with: result on: composer.
	composer move: #result onTheRightOf: #right ].
	operationProcess := operationBlock newProcess.
	composer view
		addMenu: 'Save'
		callback: [ (RTCanvasExporter canvas: composer view canvas)
				withoutFixedShapes;
				whole;
				scale: 5;
				oversizedBy: 20 @ 20;
				format: #png;
				fileName:
					((TRPlatform current
						dialogRequest: 'Please enter file name'
						initialAnswer: 'export.png') ifNil: [ ^ nil ]);
				export ].
	composer view addMenu: 'Pause' callback: [ operationProcess suspend ].
	composer view addMenu: 'Resume' callback: [ operationProcess resume ].
	composer view
		addMenu: 'Stop'
		callback: [ operationProcess terminate.
			operationProcess := operationBlock newProcess ].
	"operationWindow := composer view openTitled: 'Multiplication'.
	resultWindow := resultView openTitled: 'Result'.
	composer view
		addMenu: 'Close'
		callback: [ operationWindow createWindowGroup addWindow: resultWindow
			operationProcess terminate.
			operationWindow close
			resultWindow close ]."
	^ composer view