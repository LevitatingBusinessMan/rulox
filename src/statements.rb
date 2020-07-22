class ExpressionStmt
	attr_reader :expression

	def initialize expression
		@expression = expression
	end

	def accept visitor
		visitor.visitExpressionStmt self
	end

end

class Print
	attr_reader :expression

	def initialize expression
		@expression = expression
	end

	def accept visitor
		visitor.visitPrintStmt self
	end

end

class VarDecl
	attr_reader :name, :initializer

	def initialize name, initializer
		@name = name
		@initializer = initializer
	end

	def accept visitor
		visitor.visitVarDeclStmt self
	end

end

