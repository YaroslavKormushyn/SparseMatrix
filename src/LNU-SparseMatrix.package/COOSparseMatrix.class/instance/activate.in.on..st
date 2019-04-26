as yet unclassified
activate: model in: group on: composer
	[((composer getGroup: group) elementFromModel: model) color: Color red]
on: Error do: [ :exception | nil ].
	composer view signalUpdate