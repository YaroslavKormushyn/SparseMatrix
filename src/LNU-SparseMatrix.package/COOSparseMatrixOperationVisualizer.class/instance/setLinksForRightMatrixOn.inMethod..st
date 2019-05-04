initialization
setLinksForRightMatrixOn: matrixInstance inMethod: methodName
|transposedRightMatrixLink|
transposedRightMatrixLink := MetaLink new.
	transposedRightMatrixLink
		metaObject: [ :value | rightMatrix := value ].
	transposedRightMatrixLink selector: #value:.
	transposedRightMatrixLink arguments: #(value).
	transposedRightMatrixLink control: #after.
	matrixInstance
		link: transposedRightMatrixLink
		toTemporaryNamed: #transposed
		inMethod: methodName
		option: #write.