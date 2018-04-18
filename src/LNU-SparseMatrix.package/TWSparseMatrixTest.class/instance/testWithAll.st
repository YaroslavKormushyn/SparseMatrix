tests-instance creation
testWithAll
	| matrix |
	matrix := TWSparseMatrix
		withAll:
			{{0 . 0}.
			{1 . 2}}.
	self assert: matrix rowsNumber equals: 2.
	self assert: matrix columnsNumber equals: 2.
	self assert: (matrix at: 1 at: 1) equals: 0.
	self assert: (matrix at: 2 at: 1) equals: 1