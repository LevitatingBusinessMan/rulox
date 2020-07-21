require_relative "../src/scanner"
require_relative "../src/parser"
require_relative "../src/astPrinter"

source = "!(23+35 / -2 * (42-23))"

tokens = Scanner.scan(source)

failed = tokens.include? nil

ast = Parser.parse tokens

failed = failed || ast == nil

output = AstPrinter.print ast

p output

if output == "(! (group (+ 23 (* (/ 35 (- 2)) (group (- 42 23))))))"
	puts "Success"
else
	raise "Failed"
end
