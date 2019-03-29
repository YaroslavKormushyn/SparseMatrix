instance creation
on: aMatrix
	subclasses
		do: [ :subclass | 
			((''
				join:
					{aMatrix class .
					'Visualizer'}) = (subclass name substrings: '#') first )
				ifTrue: [ ^ subclass on: aMatrix ] ]