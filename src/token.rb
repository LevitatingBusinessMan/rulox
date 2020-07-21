class Token
	attr_reader :type, :lexeme, :literal, :line
	
	def initialize(type, lexeme, literal, line)
		@type = type
		@lexeme = lexeme
		@literal = literal
		@line = line
	end

	def to_s
		"#{@type} #{@literal}"
	end

end

