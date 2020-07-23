require_relative "./runtimeError"
require_relative "./logger"
require_relative "./environment"

class Interpreter
	@environment = Environment.new

	def self.interpret statements
		begin
			statements.each do |stmt|
				execute stmt
			end
		rescue LoxRuntimeError => error
			Logger.runtime_error error
		end
	end

	def self.visitLogicalExpr expr
		left = evaluate expr.left

		if expr.operator.type == :OR
			return left if truthy? left
		
		# AND
		else
			return left if !truthy? left
		end

		return evaluate expr.right
	end

	def self.visitIfStmt stmt
		if truthy? evaluate stmt.condition
			execute stmt.thenBranch
		elsif stmt.elseBranch
			execute stmt.elseBranch
		end
	end

	def self.visitTernaryExpr expr
		if truthy? evaluate expr.condition
			return evaluate expr.first
		else
			return evaluate expr.second
		end
	end

	def self.visitBlockStmt stmt
		executeBlock stmt.statements
	end

	def self.visitAssignmentExpr expr
		value = evaluate expr.expression

		@environment.assign expr.name, value
	end

	def self.visitVariableExpr expr
		@environment.get expr.name
	end

	def self.visitVarDeclStmt stmt
		value = nil
		value = evaluate stmt.initializer if stmt.initializer

		@environment.define stmt.name, value
	end

	def self.visitExpressionStmt stmt
		evaluate stmt.expression
	end

	def self.visitPrintStmt stmt
		value = evaluate stmt.expression
		if value.class == NilClass
			puts "nil" 
		else
			puts evaluate stmt.expression
		end
	end

	def self.evaluate expr
		expr.accept self
	end

	def self.execute stmt
		stmt.accept self
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

	def self.executeBlock statements
		previous_environment = @environment
		@environment = Environment.new @environment

		statements.each do |stmt|
			stmt.accept self
		end

		# discard current env and use previous
		@environment = previous_environment

	end

end

class Checker

	def self.number operator, *operands
		raise LoxRuntimeError.new operator, "Operand must be a number" if !operands.all? {|op| op.class == Integer}
	end

end
