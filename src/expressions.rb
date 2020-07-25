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

class Variable
	attr_reader :name

	def initialize name
		@name = name
	end

	def accept visitor
		visitor.visitVariableExpr self
	end

end

class Assignment
	attr_reader :name, :expression

	def initialize name, expression
		@name = name
		@expression = expression
	end

	def accept visitor
		visitor.visitAssignmentExpr self
	end

end

class Ternary
	attr_reader :condition, :first, :second

	def initialize condition, first, second
		@condition = condition
		@first = first
		@second = second
	end

	def accept visitor
		visitor.visitTernaryExpr self
	end

end

class Logical
	attr_reader :left, :operator, :right

	def initialize left, operator, right
		@left = left
		@operator = operator
		@right = right
	end

	def accept visitor
		visitor.visitLogicalExpr self
	end

end

class Ruby
	attr_reader :code

	def initialize code
		@code = code
	end

	def accept visitor
		visitor.visitRubyExpr self
	end

end

class Call
	attr_reader :callee, :arguments, :close_paren

	def initialize callee, arguments, close_paren
		@callee = callee
		@arguments = arguments
		@close_paren = close_paren
	end

	def accept visitor
		visitor.visitCallExpr self
	end

end

