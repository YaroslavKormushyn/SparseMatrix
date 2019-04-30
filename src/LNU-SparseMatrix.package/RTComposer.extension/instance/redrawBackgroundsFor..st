*LNU-SparseMatrix
redrawBackgroundsFor: groupNames
	self removeAllBackgrounds.
	groupNames
		do:
			[ :name | self setBackgroundColor: (Color gray alpha: 0.2) forGroup: name ].
		self groupToExisting: #labels.