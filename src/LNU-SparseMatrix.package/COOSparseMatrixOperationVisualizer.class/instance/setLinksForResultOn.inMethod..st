initialization
setLinksForResultOn: matrixInstance inMethod: methodName
|resultMatrixLink|
resultMatrixLink := MetaLink new.
	resultMatrixLink
		metaObject: [ :value | 
			| resultMatrixUpdateLinkFirst resultMatrixUpdateLinkLast |
			resultMatrix := value.
			"initialize the view for the updates not to fail"
			self initializeMultiplicationView.
			self setPositionsForMultiplication.
			resultMatrixUpdateLinkFirst := MetaLink new.
			resultMatrixUpdateLinkFirst
				metaObject: [ self updateResultWith: value.
					Transcript
						show: 'updated first in result -> 2nd rec link';
						cr ].
			resultMatrixUpdateLinkFirst selector: #value.
			resultMatrixUpdateLinkFirst control: #after.
			value
				link: resultMatrixUpdateLinkFirst
				toSlotNamed: #first
				option: #write.
			resultMatrixUpdateLinkLast := MetaLink new.
			resultMatrixUpdateLinkLast
				metaObject: [ | newResultUpdateLastLink |
					self updateResultWith: value.
					Transcript
						show: 'updated last in result -> 2nd rec link';
						cr.
					resultMatrixUpdateLinkLast uninstall.
					newResultUpdateLastLink := MetaLink new.
					newResultUpdateLastLink
						metaObject: [ self updateResultWith: value.
							Transcript
								show: 'updated last in result -> new 2nd rec link';
								cr ].
					newResultUpdateLastLink selector: #value.
					newResultUpdateLastLink control: #after.
					value
						link: newResultUpdateLastLink
						toSlotNamed: #last
						option: #write.
					semaphore signal.
					process suspend ].
			resultMatrixUpdateLinkLast selector: #value.
			resultMatrixUpdateLinkLast control: #after.
			value
				link: resultMatrixUpdateLinkLast
				toSlotNamed: #last
				option: #write ].
	resultMatrixLink selector: #value:.
	resultMatrixLink arguments: #(value).
	resultMatrixLink control: #after.
	matrixInstance
		link: resultMatrixLink
		toTemporaryNamed: #result
		inMethod: methodName
		option: #write.