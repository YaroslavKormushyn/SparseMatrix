as yet unclassified
getElementShape
	|comp|
	comp := RTCompositeShape new.
	comp add: (RTBox new color: Color blue trans).
	comp add: (RTLabel new text: [ :node | node value ]).
	comp allOfSameSizeWithPadding.
	^ comp