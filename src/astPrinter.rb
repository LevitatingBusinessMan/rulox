class AstPrinter

	def self.print expr
		expr.accept self
	end

	def self.parenthesize(name, *exprs)
		"(#{name} #{exprs.map {|expr| expr.accept(self)}.join " "})"
	end

	def self.visitBinaryExpr expr
		parenthesize(expr.operator.lexeme, expr.left, expr.right)
	end

	def self.visitGroupingExpr expr
		parenthesize("group", expr.expression)
	end

	def self.visitLiteralExpr expr
		return "nil" if expr.value == nil
		expr.value.to_s
	end

	def self.visitUnaryExpr expr
		parenthesize(expr.operator.lexeme, expr.right)
	end


end
