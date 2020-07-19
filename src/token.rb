class Token
	attr_reader :tokentype, :lexeme, :literal, :line
	
	def initialize(tokentype, lexeme, literal, line)
		@tokentype = tokentype
		@lexeme = lexeme
		@literal = literal
		@line = line
	end

	def toString
		"#{@tokentype} #{@lexeme} #{@literal}"
	end

end

=begin
newToken(tokentype, lexeme, literal, line) {
	{
		:tokentype: tokentype,
		:lexeme: lexeme,
		:literal: literal,
		:line: line
	}
}
=end
