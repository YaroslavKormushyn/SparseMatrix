as yet unclassified
highlight: model in: group on: composer
	[ ((composer getGroup: group) elementFromModel: model)
		color: Color yellow ]
		on: Error
		do: [ :exception | nil ].
	composer view signalUpdate