require_relative "./logger"

#Mainly checks if no variables get assigned to themselves like var a = a;
#I only add this because the book likes it
#I prefer the behavior without this
class Resolver
	@scopes = []

	def self.start interpreter, statements
		@interpreter = interpreter
		@failed = false
		statements.each {|stmt| resolve stmt}
	end

	def self.resolve node
		node.accept self
	end

	def self.begin_scope
		@scopes.push({})
	end

	def self.end_scope
		@scopes.pop
	end

	def self.declare name
		return if @scopes.empty?

		scope = @scopes.last

		if scope[name.lexeme]
			Logger.errort(name, "Cannot declare variable twice in the same scope")
			@failed = true
		end

		scope[name.lexeme] = false

	end

	def self.define name
		return if @scopes.empty?
		scope = @scopes.last
		scope[name.lexeme] = true
	end

	def self.visitBlockStmt stmt
		begin_scope
		for statement in stmt.statements
			resolve statement 
		end
		end_scope
	end

	def self.visitVarDeclStmt stmt
		declare stmt.name
		resolve stmt.initializer if stmt.initializer
		define stmt.name
	end

	#http://craftinginterpreters.com/resolving-and-binding.html#resolving-variable-expressions
	def self.visitVariableExpr expr
		if !@scopes.empty? and @scopes.last[expr.name.lexeme] == false
			Logger.errort(expr.name, "Cannot read local variable in its own initializer")
			@failed = true
		end

		resolveLocal expr, expr.name
	end

	#http://craftinginterpreters.com/resolving-and-binding.html#resolving-variable-expressions
	def self.resolveLocal expr, name
		scope_index = @scopes.find_index {|scope| scope.key?(name.lexeme)}
		@interpreter.resolve(expr, @scopes.length- 1 - scope_index) if scope_index

		# Must be global
	end

	#http://craftinginterpreters.com/resolving-and-binding.html#resolving-assignment-expressions
	def self.visitAssignExpr expr
		resolve expr.expression
		resolveLocal(expr, expr.name)
	end

	#http://craftinginterpreters.com/resolving-and-binding.html#resolving-function-declarations
	def self.visitFunDeclStmt stmt
		declare stmt.name
		define stmt.name
		resolveFunction stmt
	end

	#http://craftinginterpreters.com/resolving-and-binding.html#resolving-function-declarations
	def self.resolveFunction functionStmt
		begin_scope
		for param in functionStmt.parameters
			declare param
			define param
		end
		resolve functionStmt.body
		end_scope
	end

	def self.visitExpressionStmt stmt
		resolve stmt.expression
	end

	def self.visitIfStmt stmt
		resolve stmt.condition
		resolve stmt.thenBranch
		resolve stmt.elseBranch if stmt.elseBranch
	end

	def self.visitPrintStmt stmt
		resolve stmt.expression
	end

	def self.visitReturnStmt stmt
		resolve stmt.expression if stmt.expression
	end

	def self.visitWhileStmt stmt
		resolve stmt.condition
		resolve stmt.body
	end

	def self.visitBinaryExpr expr
		resolve expr.left
		resolve expr.right
	end

	def self.visitCallExpr expr
		resolve expr.callee
		expr.arguments.each &method(:resolve)
	end

	def self.visitGroupingExpr expr
		resolve expr.expression
	end

	def self.visitLiteralExpr expr
	end

	def self.visitLogicalExpr expr
		resolve expr.right
	end

	def self.failed
		return @failed
	end

end