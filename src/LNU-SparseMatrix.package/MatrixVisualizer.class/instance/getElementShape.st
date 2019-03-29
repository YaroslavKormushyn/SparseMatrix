private
getElementShape
	| comp box valueLabel indexLabel |
	comp := RTCompositeShape new.
	box := RTBox new
		color: Color blue;
		size: elementSize.
	valueLabel := RTLabel new
		text: [ :el | el value ];
		color: Color white.
	indexLabel := RTLabel new
		height: 5;
		text: [ :el | el row @ el column ];
		color: Color white.
	comp
		add: box;
		add: valueLabel;
		add: indexLabel translateBy: 0 @ 10.
	^ comp