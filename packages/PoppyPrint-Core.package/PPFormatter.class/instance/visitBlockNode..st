visiting
visitBlockNode: aNode

	| isMethodBlock startWithNewLine |
	isMethodBlock := (self parentFor: aNode) isKindOf: MethodNode.
	startWithNewLine := isMethodBlock not and: [
		aNode statements size > 0 and: [
			aNode statements size > 1 or: [(self willBeMultiLine: aNode statements first) or: [aNode statements first comment notNil]]]].
	
	isMethodBlock ifFalse: [self printBlockStart: aNode startWithNewLine: startWithNewLine].
	
	self formatTemporariesOf: aNode isMethod: isMethodBlock.
	
	self indent: (startWithNewLine ifTrue: [1] ifFalse: [0]) around: [ | statements |
		statements := aNode statements.
		startWithNewLine ifTrue: [self newLine].
		
		self popCurrentComments: true.
		statements do: [:statement |
			(statement isLiteralNode and: [statement key = #ppEmptyLine])
				ifTrue: [
					self addCommentsOf: statement.
					self newLine]
				ifFalse: [
					self visitNode: statement.
					(statement ~= statements last or: [comments notEmpty]) ifTrue: [
						stream nextPut: $..
						self newLine]].
			self popCurrentComments: statement ~= statements last]].
	
	isMethodBlock ifFalse: [stream nextPut: $]]