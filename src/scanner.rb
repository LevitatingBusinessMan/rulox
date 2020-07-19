require_relative "./token"

def scan(source)
	chars = source.split
	tokens = []

	start = 0
	current = 0
	line = 0

	chars.each { |c|
		tokens.push
			case c
				when '('
					Token.new(:LEFT_PAREN)
				when ')'
					Token.new(:RIGHT_PAREN)
				when '{'
					Token.new(:LEFT_BRACE)
				when '}'
					Token.new(:RIGHT_BRACE)
				when ','
					Token.new(:COMMA)
				when '.'
					Token.new(:DOT)
				
			end
	}

end