require_relative "./token"
require_relative "./logger"

# A collection of functions that rely on global variables, because I still dislike classes

class Scanner
	def self.scan(source)
		@chars = source.split ""
		@tokens = []
		@start = @current = 0
		@line = 1
	
		startScan
	
		@tokens.push Token.new(:EOF, nil, nil, @line)

		@tokens
		
	end

	def self.addToken(tokenType, literal=nil)
		@tokens.push Token.new(tokenType, @chars[@start..@current].join, literal, @line)
		@currentLexeme = ""
	end

	# Compare next char/string, and skip it if matches
	def self.match(string)
		if @chars[@current+1..].join.start_with? string
			string.length.times do advance() end
			return true
		else
			return false
		end
	end

	# Check next char
	def self.peek(where=1)
		@chars[@current+where]
	end

	def self.advance
		@current+=1
	end

	def self.startScan
		while @current < @chars.length
			c = @chars[@current]
	
			@start = @current
	
			case c
				when '('; addToken(:LEFT_PAREN)
				when ')'; addToken(:RIGHT_PAREN)
				when '{'; addToken(:LEFT_BRACE)
				when '}'; addToken(:RIGHT_BRACE)
				when ','; addToken(:COMMA)
				when '.'; addToken(:DOT)
				when '-'; addToken(:MINUS)
				when '+'; addToken(:PLUS)
				when ';'; addToken(:SEMICOLON)
				when ':'; addToken(:COLON)
				when '*'; addToken(:ASTERISk)
				when '?'; addToken(:QUESTION)
				when '!'; addToken(match("=") ? :BANG_EQUAL : :BANG)
				when '='; addToken(match("=") ? :EQUAL_EQUAL : :EQUAL)
				when '<'; addToken(match("=") ? :LESS_EQUAL : :LESS)
				when '>'; addToken(match("=") ? :GREATER_EQUAL : :GREATER)
				when '/'
					
					# comment
					if match('/')
						advance while peek() != "\n" && peek() != nil
					
					#multiline comment
					elsif match('*')
						while peek() != nil && !match("*/")
							@line+=1 if peek() == "\n"
							advance
						end
					else
						addToken(:SLASH)
					end
				
				when '"'
					while peek() != '"' && peek() != nil
						@line+=1 if peek() == "\n"
						advance()
					end
	
					# EOF
					if peek() == nil
						Logger.errorl(@line, "Unterminated string")
						@tokens.push nil
					end
	
					# Cover closing "
					advance()
	
					string = @chars[@start+1..@current-1].join
	
					addToken(:STRING, string)
	
				when "0".."9"
					advance while peek() != nil && peek().is_int?
					
					# fractions
					if peek() == "." && peek(2) != nil && peek(2).is_int?
						
						#cover .
						advance
	
						advance while peek() != nil && peek().is_int?
					end
					
					addToken(:NUMBER, @chars[@start..@current].join.to_i)
	
				#Identifiers (or keywords)
				when /[A-Za-z_]+/
					advance while /[A-Za-z_]/.match?(peek())
	
					lexeme = @chars[@start..@current].join
					if @keywords[lexeme]
						addToken(@keywords[lexeme])
					else 
						addToken(:IDENTIFIER)
					end
	
				when "\s", "\t", "\r"
				when "\n"
					@line+=1
				else
					Logger.errorl(@line, "Unexpected character #{c.inspect}")
					nil
				end
	
			advance()
	
		end
	end

	@keywords = {
		"and"	=>	:AND,
		"class" =>	:CLASS,
		"else"	=>	:ELSE,
		"false" =>	:FALSE,
		"for"	=>	:FOR,
		"fun"	=>	:FUN,
		"if"	=>	:IF,
		"nil"	=>	:NIL,
		"or"	=>	:OR,
		"print"	=>  :PRINT,
		"return"=> 	:RETURN,
		"super"	=> 	:SUPER,
		"this"	=> 	:THIS,
		"true"	=> 	:TRUE,
		"var"	=> 	:VAR,
		"while"	=>  :WHILE
	}

end

class String
	def is_int?
		self.to_i.to_s == self
	end
end

