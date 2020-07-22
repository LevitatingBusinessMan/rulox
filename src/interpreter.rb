require_relative "./runtimeError"
require_relative "./logger"

class Interpreter

	def self.interpret statements
		begin
			statements.each do |stmt|
				stmt.accept self
			end
		rescue LoxRuntimeError => error
			Logger.runtime_error error
		end
	end

	def self.visitExpressionStmt exprStmt
		evaluate exprStmt.expression
	end

	def self.visitPrintStmt printStmt
		puts evaluate printStmt.expression
	end

	def self.evaluate expr
		expr.accept self
	end

	def self.truthy? var
		var != nil && var.class != FalseClass
	end

	def self.equal? first, second
		#Simply inherit Ruby's system
		first.equal? second
	end

	def self.visitBinaryExpr expr
		left = evaluate expr.left
		right = evaluate expr.right

		case expr.operator.type
			when :MINUS
				Checker.number expr.operator, right
				left - right
			when :SLASH
				Checker.number expr.operator, right

				# Don't divide by zero
				if right == 0
					raise LoxRuntimeError.new expr.operator, "Dividing by zero is not allowed"
				end

				left / right
			when :ASTERISk
				Checker.number expr.operator, right
				left * right
			when :PLUS

				if left.class == String && right.class == String || left.class == Integer && right.class == Integer
					left + right
				else
					raise LoxRuntimeError.new expr.operator, "Operands must both be numbers or strings"
				end
				

			#comparison
			when :GREATER
				Checker.number expr.operator, right
				left > right
			when :GREATER_EQUAL
				Checker.number expr.operator, right
				left >= right
			when :LESS
				Checker.number expr.operator, right
				left < right
			when :LESS_EQUAL
				Checker.number expr.operator, right
				left <= right
			when :BANG_EQUAL
				equal? left, right
			when :EQUAL_EQUAL
				equal? left, right
		end

	end

	def self.visitGroupingExpr expr
		evaluate expr.expression
	end

	def self.visitLiteralExpr expr
		expr.value
	end

	def self.visitUnaryExpr expr
		right = evaluate expr.right

		case expr.operator.type
			when :MINUS
				Checker.number expr.operator, right
				-right
			when :BANG
				!truthy? right
		end

	end

end

class Checker

	def self.number operator, *operands
		raise LoxRuntimeError.new operator, "Operand must be a number" if !operands.all? {|op| op.class == Integer}
	end

end
