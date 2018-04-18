instance creation
for: aCOOSparseMatrix
	(aCOOSparseMatrix isMemberOf: COOSparseMatrix)
		ifFalse: [ Error signal: 'Matrix must be of class ', COOSparseMatrix name ].
	graph := RTMondrian new.
	graph nodes: [ Array new add: [  ] ]