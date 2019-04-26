*LNU-SparseMatrix
"protocol: attach point"
withHorizontalRightAttachPoint
	| ap |
	ap := RTHorizontalRightAttachPoint new.
	self attachPoint: ap.
	^ ap