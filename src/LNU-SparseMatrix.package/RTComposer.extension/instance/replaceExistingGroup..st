*LNU-SparseMatrix
replaceExistingGroup: aName
	"Add to existing group any new elements added to the view"

	| newGroup existingGroup |
	newGroup := self newElementsAsGroup.
	existingGroup := [ mapping at: aName ]
		on: KeyNotFound
		do: [ KeyNotFound signal: 'No group with ' , aName , ' was found' ].
	existingGroup remove; removeAll.
	existingGroup addAll: newGroup elements