*LNU-SparseMatrix
"protocol: attach point"
withVerticalBottomAttachPoint
	| ap |
	ap := RTVerticalBottomAttachPoint new.
	self attachPoint: ap.
	^ ap