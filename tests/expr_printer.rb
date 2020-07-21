require_relative "../src/expressions.rb"
require_relative "../src/astPrinter.rb"
require_relative "../src/token.rb"

expression = Binary.new(
	Unary.new(
		Token.new(:MINUS, "-", nil, 1),
		Literal.new(123)
	),
	Token.new(:STAR, "*", nil, 1),
	Grouping.new(Literal.new(45.67))
)

output = AstPrinter.print expression

puts output

if output == "(* (- 123) (group 45.67))"
	puts "Success"
else 
	raise "Failed"
end
