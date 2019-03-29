initialization
setPositions
	| gap |
	gap := 10.
	view elements
		do: [ :e | 
			| aNode |
			aNode := e model.
			e translateTo: (elementSize + gap) * (aNode column @ aNode row) ]