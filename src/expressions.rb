class Binary
	attr_reader :left, :operator, :right

	def initialize left, operator, right
		@left = left
		@operator = operator
		@right = right
	end

	def accept visitor
		visitor.visitBinaryExpr self
	end

end

class Grouping
	attr_reader :expression

	def initialize expression
		@expression = expression
	end

	def accept visitor
		visitor.visitGroupingExpr self
	end

end

class Literal
	attr_reader :value

	def initialize value
		@value = value
	end

	def accept visitor
		visitor.visitLiteralExpr self
	end

end

class Unary
	attr_reader :operator, :right

	def initialize operator, right
		@operator = operator
		@right = right
	end

	def accept visitor
		visitor.visitUnaryExpr self
	end

end

