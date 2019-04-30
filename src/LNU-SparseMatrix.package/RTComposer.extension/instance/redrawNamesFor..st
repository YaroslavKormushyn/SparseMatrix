*LNU-SparseMatrix
redrawNamesFor: groupNames
	self removeAllNames.
	groupNames do: [ :name | self nameGroup: name as: name asString ].
	self groupToExisting: #labels.