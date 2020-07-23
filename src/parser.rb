require_relative "./expressions"
require_relative "./statements"
require_relative "./logger"
require_relative "./parseError"

class Parser

	def self.parse(tokens)
		@tokens = tokens
		@index = 0
		statements = []

		statements.push decleration() while current.type != :EOF

		statements	
	end

	# For the REPL, parse only expression
	def self.parseExpression(tokens)
		@tokens = tokens
		@index = 0

		begin
			expression
		rescue
		end
	end

	#declaration → varDecl | statement
	def self.decleration
		begin
			return varDecleration if match :VAR
			return statement
		rescue ParseError => error
			synchronize
			return nil
		end
	end

	#varDecl → "var" IDENTIFIER ( "=" expression )? ";"
	def self.varDecleration
		name = assume :IDENTIFIER, "Expected variable name"
		
		#if value is set
		initializer = nil
		initializer = expression if match :EQUAL

		assume :SEMICOLON, "Expect ';' after variable decleration"

		VarDecl.new name, initializer
	end

	#statement → printStmt | exprStmt | ifStmt | block
	def self.statement
		return ifStmt if match :IF
		return printStmt if match :PRINT
		return block if match :LEFT_BRACE
		return exprStmt
	end

	#ifStmt "if" "(" expression ")" statement ("else" statement)?
	def self.ifStmt
		assume :LEFT_PAREN, "Expected '(' after 'if' keyword"
		condition = expression
		assume :RIGHT_PAREN, "Expected ') after 'if' condition"

		thenBranch = statement
		elseBranch = (match :ELSE) ? statement : nil

		IfStmt.new(condition, thenBranch, elseBranch)
	end

	def self.block
		statements = []
		statements.push decleration while !check(:RIGHT_BRACE) && !check(:EOF)

		assume :RIGHT_BRACE, "Expected closing '}'"
		
		Block.new statements
	end

	#printStmt → "print" expression ";"
	def self.printStmt
		value = expression
		assume :SEMICOLON, "Expected ';' after expression"
		PrintStmt.new value
	end

	#exprStmt  → expression ";"
	def self.exprStmt
		expr = expression
		assume :SEMICOLON, "Expected ';' after expression"
		ExpressionStmt.new expr
	end

	#expression → assignment
	def self.expression
		return assignment
	end

	#assignment → IDENTIFIER "=" assignment | ternary
	def self.assignment
		expr = ternary;

		if match :EQUAL
			eq = previous
			value = expression

			# Turn left hand into token (l-value)
			if expr.class == Variable
				name = expr.name
				return Assignment.new(name, value)
			end

			error eq, "Invalid assignment target"
		end

		expr
	end

	#ternary -> expression "?" expression ":" expression | equality
	def self.ternary
		expr = equality

		if match :QUESTION
			qm = previous
			first_option = expression

			error qm, "Expected ':' in ternary expression" if !match :COLON
			
			second_option = expression

			expr = Ternary.new(expr, first_option, second_option)
		end

		expr
	end

	#equality → comparison ( ( "!=" | "==" ) comparison )*
	def self.equality
		expr = comparison

		while match(:BANG_EQUAL, :EQUAL_EQUAL)
			operator = previous
			right = comparison
			expr = Binary.new(expr, operator, right)
		end

		expr
	end

	#comparison → addition ( ( ">" | ">=" | "<" | "<=" ) addition )*
	def self.comparison
		expr = addition

		while match(:GREATER, :GREATER_EQUAL, :LESS, :LESS_EQUAL)
			operator = previous
			right = addition
			expr = Binary.new(expr, operator, right)
		end

		expr
	end

	#addition → multiplication ( ( "-" | "+" ) multiplication )*
	def self.addition
		expr = multiplication

		while match(:MINUS, :PLUS)
			operator = previous
			right = multiplication
			expr = Binary.new(expr, operator, right)
		end

		expr
	end
	#multiplication → unary ( ( "/" | "*" ) unary )*
	def self.multiplication
		expr = unary

		while match(:SLASH, :ASTERISk)
			operator = previous
			right = unary
			expr = Binary.new(expr, operator, right)
		end

		expr
	end
	
	#unary → ( "!" | "-" ) unary | primary
	def self.unary
		if match(:BANG, :MINUS)
			operator = previous
			right = unary
			return Unary.new(operator, right)
		end

		primary
	end

	#primary → NUMBER | STRING | "false" | "true" | "nil" | "(" expression ")" | IDENTIFIER
	def self.primary
		return Literal.new false			if match :FALSE
		return Literal.new true				if match :TRUE
		return Literal.new nil				if match :NIL
		return Literal.new previous.literal if match :NUMBER, :STRING
		return Variable.new previous		if match :IDENTIFIER


		if match :LEFT_PAREN
			expr = expression
			assume :RIGHT_PAREN, "Expected closing ')'"
			return Grouping.new(expr)
		end

		# Wrong token to start expression with
		raise error current(), "Expected expression"

	end

	#Match one of the following types and advance
	def self.match *tokenTypes
		tokenTypes.each do |type|
			if check type
				advance
				return true
			end
		end
		false
	end

	def self.assume type, msg
		if !match(type)
			raise error current(), msg
		end
		previous
	end

	def self.error token, msg
		Logger.errort token, msg
		return ParseError.new
	end

	def self.synchronize
		while current.type != :EOF
			advance

			return if previous.type == :SEMICOLON

			return if [:CLASS, :FUN, :VAR, :FOR, :IF, :WHILE, :PRINT, :RETURN].include? current.type
		end
	end

	def self.check type
		current.type == type
	end

	def self.current
		return @tokens[@index]
	end

	def self.previous
		return @tokens[@index-1]
	end

	def self.advance
		@index+=1
	end

end
