*LNU-SparseMatrix
"protocol: as yet unclassified"
orthoVerticalLineRightmostWithOffset: offset
	^ self
		shape:
			(RTStyledMultiLine new
				withVerticallAttachPoint;
				orthoVerticalBalancedToRightWithOffset: offset)