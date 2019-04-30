*LNU-SparseMatrix
replaceElementsInGroup: groupName with: matrix
	self removeGroup: groupName.
	MatrixVisualizer on: matrix withView: view.
	self group: groupName.
	self view signalUpdate