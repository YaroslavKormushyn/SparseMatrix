*LNU-SparseMatrix
"protocol: as yet unclassified"
orthoHorizontalLineBottommostWithOffset: offset
	^ self shape: (RTStyledMultiLine new withHorizontalAttachPoint; orthoHorizontalBalancedToBottomWithOffset: offset)