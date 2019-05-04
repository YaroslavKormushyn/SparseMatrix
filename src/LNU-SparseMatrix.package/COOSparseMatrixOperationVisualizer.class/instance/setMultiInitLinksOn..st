initialization
setMultiInitLinksOn: matrixInstance
	| leftRowIndexLink rightColumnIndexLink leftMarkerLinkBefore leftMarkerLinkAfter rightMarkerLinkBefore rightMarkerLinkAfter resultMatrixLink transposedRightMatrixLink method sumLink |
	method := #byMatrix:.
	self setLinksForProcessedElementIndexOn: matrixInstance inMethod: method.
	self setLinksForResultOn: matrixInstance inMethod: method.
		self setLinksForRightMatrixOn: matrixInstance inMethod: method.
			sumLink := MetaLink new.
	sumLink
		metaObject: [ :sumValue | 
			sumValue ~= 0
				ifTrue: [ self
						highlightModels:
							{leftMatrixMarker.
							rightMatrixMarker}.
					Transcript
						show:
							'highlight '
								, (leftMatrixMarker row @ leftMatrixMarker column) asString
								, '&'
								, (rightMatrixMarker row @ rightMatrixMarker column) asString;
						cr.
					delay wait ] ].
	sumLink selector: #value:.
	sumLink arguments: #(value).
	sumLink control: #after.
	matrixInstance
		link: sumLink
		toTemporaryNamed: #sum
		inMethod: method
		option: #write.
	leftMarkerLinkBefore := MetaLink new.
	leftMarkerLinkBefore
		metaObject: [ :value | 
			value isNotNil
				ifTrue: [ self deselectModel: value.
					Transcript
						show: 'deselect left ' , (value row @ value column) asString;
						cr ] ].
	leftMarkerLinkBefore selector: #value:.
	leftMarkerLinkBefore arguments: #(value).
	leftMarkerLinkBefore control: #before.
	matrixInstance
		link: leftMarkerLinkBefore
		toTemporaryNamed: #leftMatrixMarker
		inMethod: method
		option: #write.
	leftMarkerLinkAfter := MetaLink new.
	leftMarkerLinkAfter
		metaObject: [ :element | 
			leftMatrixMarker := element.
			"draw the marker element on the view if its the initialization"
			leftMarkerElement isNil
				ifTrue: [ leftMarkerElement := (COOSparseMatrixVisualizer new
						getElementShapeScaled: 5) elementOn: element ].
			"select the element and update the view"
			element isNotNil
				ifTrue: [ self selectModel: element.
					Transcript
						show: 'select left ' , (element row @ element column) asString;
						cr.
					leftMarkerElement updateModelAndRedraw: element.
					delay wait ] ].
	leftMarkerLinkAfter selector: #value:.
	leftMarkerLinkAfter arguments: #(value).
	leftMarkerLinkAfter control: #after.
	matrixInstance
		link: leftMarkerLinkAfter
		toTemporaryNamed: #leftMatrixMarker
		inMethod: method
		option: #write.
	rightMarkerLinkBefore := MetaLink new.
	rightMarkerLinkBefore
		metaObject: [ :value | 
			value isNotNil
				ifTrue: [ self deselectModel: value.
					Transcript
						show: 'deselect right ' , (value row @ value column) asString;
						cr ] ].
	rightMarkerLinkBefore selector: #value:.
	rightMarkerLinkBefore arguments: #(value).
	rightMarkerLinkBefore control: #before.
	matrixInstance
		link: rightMarkerLinkBefore
		toTemporaryNamed: #rightMatrixMarker
		inMethod: method
		option: #write.
	rightMarkerLinkAfter := MetaLink new.
	rightMarkerLinkAfter
		metaObject: [ :element | 
			rightMatrixMarker := element.
			rightMarkerElement isNil
				ifTrue: [ rightMarkerElement := (COOSparseMatrixVisualizer new
						getElementShapeScaled: 5) elementOn: element ].
			element isNotNil
				ifTrue: [ self selectModel: element.
					Transcript
						show: 'select right ' , (element row @ element column) asString;
						cr.
					rightMarkerElement updateModelAndRedraw: element.
					delay wait ] ].
	rightMarkerLinkAfter selector: #value:.
	rightMarkerLinkAfter arguments: #(value).
	rightMarkerLinkAfter control: #after.
	matrixInstance
		link: rightMarkerLinkAfter
		toTemporaryNamed: #rightMatrixMarker
		inMethod: method
		option: #write.
	metaLinks
		addAll:
			{leftRowIndexLink.
			rightColumnIndexLink.
			leftMarkerLinkBefore.
			leftMarkerLinkAfter.
			rightMarkerLinkBefore.
			rightMarkerLinkAfter.
			resultMatrixLink.
			transposedRightMatrixLink}