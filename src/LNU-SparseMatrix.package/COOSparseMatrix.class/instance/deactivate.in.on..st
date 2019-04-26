as yet unclassified
deactivate: model in: group on: composer
	[((composer getGroup: group) elementFromModel: model)
		color: Color blue]on: Error
		do: [ :exception | nil ].
	composer view signalUpdate