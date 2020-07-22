require_relative "./expressions"
require_relative "./statements"
require_relative "./logger"
require_relative "./parseError"

class Parser

	def self.parse(tokens)
		@tokens = tokens
		@index = 0
		statements = []

		begin
			statements.push statement() while current.type != :EOF
			return statements	
		rescue ParseError => error
			return nil
		end
	end

	def self.statement
		return printStmt() if match :PRINT

		return exprStmt()
	end

	#printStmt → "print" expression ";" ;
	def self.printStmt
		value = expression
		assume :SEMICOLON, "Expected ';' after expression"
		Print.new value
	end

	#exprStmt  → expression ";" ;
	def self.exprStmt
		expr = expression
		assume :SEMICOLON, "Expected ';' after expression"
		ExpressionStmt.new expr
	end

	#expression → equality ;
	def self.expression
		return equality
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

	#primary → NUMBER | STRING | "false" | "true" | "nil" | "(" expression ")"
	def self.primary
		return Literal.new false			if match :FALSE
		return Literal.new true				if match :TRUE
		return Literal.new nil				if match :NIL
		return Literal.new previous.literal if match :NUMBER, :STRING

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
	end

	def self.error token, msg
		Logger.errort token, msg
		return ParseError.new
	end

	def self.synchronize

		advance

		while current != nil
			
			return if previous.type == :SEMICOLON

			if [:CLASS, :FUN, :VAR, :FOR, :IF, :WHILE, :PRINT, :RETURN].include? current.type
				return
			end

			advance
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
