printing
needsParenthesisFor: aNode

	self example: 'simple' receiver: [PPFormatter new] args: [
		{
			(Parser new
				parse: '(self assert: 2) ifNotNil: 3'
				class: nil class
				noPattern: true
				notifying: nil
				ifFail: nil) body statements first expr receiver
		}].
	
	aNode isLeaf ifTrue: [^ false].
	(aNode isKindOf: ReturnNode) ifTrue: [^ false].
	aNode isBlockNode ifTrue: [^ false].
	((self parentFor: aNode) isBlockNode or: [(self parentFor: aNode) isBraceNode]) ifTrue: [^ false].
	(aNode isMessage and: [aNode originalSelector isUnary]) ifTrue: [^ false].
	(((self parentFor: aNode) isKindOf: CascadeNode) and: [
		aNode isMessage and: [aNode originalSelector isUnary not and: [(self parentFor: aNode) originalReceiver = aNode]]]) ifTrue: [^ true].
	(self precedenceOf: aNode) < (self precedenceOf: (self parentFor: aNode)) ifTrue: [^ false].
	^ true