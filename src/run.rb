require_relative "./scanner"
require_relative "./parser"
require_relative "./astPrinter"

def run(source)

	tokens = Scanner.scan(source)

	failed = tokens.include? nil

	ast = Parser.parse tokens

	failed = failed || ast == nil

	p AstPrinter.print ast

end
