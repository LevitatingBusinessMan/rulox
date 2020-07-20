require_relative "./token"
require_relative "./logger"

# A collection of functions that rely on global variables, because I still dislike classes

def scan(source)
	@chars = source.split ""
	@tokens = []
	@current = 0
	@line = 1
	@currentLexeme = ''
	@skip = false

	startScan

	@tokens.push Token.new(:EOF, nil, nil, @line)

	p @tokens

end

def addToken(tokenType)
	@tokens.push Token.new(tokenType, @currentLexeme, nil, @line)
	@currentLexeme = ""
end

# Compare next char, and skip it if matches
def match(char)
	if @chars[@current+1] == char
		@currentLexeme = @currentLexeme + @chars[@current+1]
		advance()
		return true
	else
		return false
	end
end

def peek
	@chars[@current+1]
end

def advance
	@current+=1
end

def startScan
	while @current < @chars.length
		c = @chars[@current]

		@currentLexeme = c

		p c

		case c
			when '('
				addToken(:LEFT_PAREN)
			when ')'
				addToken(:RIGHT_PAREN)
			when '{'
				addToken(:LEFT_BRACE)
			when '}'
				addToken(:RIGHT_BRACE)
			when ','
				addToken(:COMMA)
			when '.'
				addToken(:DOT)
			when '-'
				addToken(:MINUS)
			when '+'
				addToken(:PLUS)
			when ';'
				addToken(:SEMICOLON)
			when '*'
				addToken(:ASTERISk)
			when '!'
				addToken(match("=") ? :BANG_EQUAL : :BANG)
			when '='
				addToken(match("=") ? :EQUAL_EQUAL : :EQUAL)
			when '<'
				addToken(match("=") ? :LESS_EQUAL : :LESS)
			when '>'
				addToken(match("=") ? :GREATER_EQUAL : :GREATER)
			when '/'
				# comment
				if match('/')
					advance() while peek() != '\n' && peek() != nil
				end
			when ' ', "\n"

			else
				error(@line, "Unexpected character #{c}")
				nil
			end

		advance()

	end
end
