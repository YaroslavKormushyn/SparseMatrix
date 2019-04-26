as yet unclassified
replaceElementsInGroup: group with: model on: composer
	MatrixVisualizer on: model withView: composer view.
	composer replaceExistingGroup: group.
	composer view signalUpdate