require_relative "./expressions"
require_relative "./statements"
require_relative "./logger"
require_relative "./parseError"

class Parser

	def self.parse(tokens)
		@tokens = tokens
		@index = 0
		@failed = false
		statements = []

		statements.push decleration() while current.type != :EOF

		return @failed ? nil : statements
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

	#declaration → varDecl | funDecl | statement
	def self.decleration
		begin
			return varDecl if match :VAR
			return declareFunction "function" if match :FUN
			return statement
		rescue ParseError => error
			synchronize
			@failed = true
		end
	end

	#varDecl → "var" IDENTIFIER ( "=" expression )? ";"
	def self.varDecl
		name = assume :IDENTIFIER, "Expected variable name"
		
		#if value is set
		initializer = nil
		initializer = expression if match :EQUAL

		assume :SEMICOLON, "Expect ';' after variable decleration"

		VarDecl.new name, initializer
	end

	#funDecl -> "fun" function
	#function IDENTIFIER "(" parameters ")" block
	#parameters → IDENTIFIER ( "," IDENTIFIER )*
	def self.declareFunction kind
		name = assume :IDENTIFIER, "Expected #{kind} name"

		assume :LEFT_PAREN, "Expected '(' after #{kind} name"
		parameters = []
		if !check :RIGHT_PAREN
			parameters.push assume :IDENTIFIER, "Expected parameters name"
			while match :COMMA
				parameters.push assume :IDENTIFIER, "Expected parameters name"
			end
		end
		assume :RIGHT_PAREN, "Expected ')' after #{kind} parameters"
		
		assume :LEFT_BRACE, "Expected '{' before #{kind} body"

		body = block

		FunDecl.new name, parameters, body

	end

	#statement → printStmt | exprStmt | ifStmt | block | whileStmt | forStmt | returnStmt
	def self.statement
		return ifStmt if match :IF
		return printStmt if match :PRINT
		return block if match :LEFT_BRACE
		return whileStmt if match :WHILE
		return forStmt if match :FOR
		return returnStmt if match :RETURN
		return exprStmt
	end

	#returnStmt → "return" expression? ";"
	def self.returnStmt
		keyword = previous
		value = nil
		value = expression if !check :SEMICOLON

		assume :SEMICOLON, "Expected ';' after return statement"
		ReturnStmt.new keyword, value
	end

	#forStmt -> "for" "(" (varDecl | exprStmt | ";") expression? ";" expression? ")" statement;
	def self.forStmt
		assume :LEFT_PAREN, "Expected '(' after 'for' keyword"

		if match :SEMICOLON
			initializer = nil
		elsif match :VAR
			initializer = varDecl
		else
			initializer = exprStmt
		end 

		if match :SEMICOLON
			condition = nil
		elsif condition = expression
		end

		assume :SEMICOLON, "Expected ';' after loop condition"

		if match :SEMICOLON
			increment = nil
		elsif increment = expression
		end

		assume :RIGHT_PAREN, "Expected ')' after 'for' clauses"

		body = statement

		body = Block.new [body, ExpressionStmt.new(increment)]

		condition = Literal.new true if !condition
		body = While.new condition, body

		body = Block.new [initializer, body] if initializer
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

	#whileStmt -> "while" "(" expression ")" statement
	def self.whileStmt
		assume :LEFT_PAREN, "Expected '(' after 'while' keyword"
		condition = expression
		assume :RIGHT_PAREN, "Expected ') after 'while' condition"

		body = statement

		While.new condition, body
	end

	#expression → assignment
	def self.expression
		return assignment
	end

	#assignment → IDENTIFIER "=" assignment | ternary
	def self.assignment
		expr = ternary;

		if match :EQUAL or match :PLUS_EQUAL or match :MINUS_EQUAL
			operator = previous
			value = expression

			# Turn left hand into token (l-value)
			if expr.class == Variable
				name = expr.name

				if  operator.type == :EQUAL
					return Assignment.new(name, value) 
				else 
					return Assignment.new(name, Binary.new(expr, operator, value))
				end
			end

			error operator, "Invalid assignment target"
		end

		expr
	end

	#ternary -> logicOr "?" logicOr ":" ternary | logicOr
	def self.ternary
		expr = logicOr

		if match :QUESTION
			qm = previous
			first_option = logicOr

			error qm, "Expected ':' in ternary expression" if !match :COLON
			
			second_option = ternary

			expr = Ternary.new(expr, first_option, second_option)
		end

		expr
	end

	#logicOr -> logicAnd ( "or" logicAnd )*
	def self.logicOr
		expr = logicAnd

		while match :OR
			operator = previous
			right = logicAnd
			expr = Logical.new(expr, operator, right)
		end
	
		expr
	end

	#logicOr -> equality ( "and" equality )*
	def self.logicAnd
		expr = equality

		while match :AND
			operator = previous
			right = equality
			expr = Logical.new(expr, operator, right)
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
	
	#unary → ( "!" | "-" ) unary | ruby
	def self.unary
		if match(:BANG, :MINUS)
			operator = previous
			right = unary
			return Unary.new(operator, right)
		end

		ruby
	end

	#ruby -> "ruby" expression | call
	def self.ruby
		if match :RUBY
			code = expression
			return Ruby.new(code)
		end

		call
	end
	
	#call  → primary ( "(" arguments? ")" )*
	#arguments → expression ( "," expression )*
	def self.call
		expr = primary

		while match(:LEFT_PAREN)
			arguments = []
			if !check :RIGHT_PAREN
				arguments.push expression
				arguments.push expression while match :COMMA
			end
			
			close_paren = assume :RIGHT_PAREN, "Expected ')' after call arguments"

			expr = Call.new expr, arguments ,close_paren
		end

		expr
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
