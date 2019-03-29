instance creation
on: aMatrix withView: aView
	subclasses
		do: [ :subclass | 
			(''
				join:
					{aMatrix class.
					'Visualizer'}) = (subclass name substrings: '#') first
				ifTrue: [ ^ subclass on: aMatrix withView: aView] ]