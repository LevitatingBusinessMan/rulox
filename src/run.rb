require_relative "./scanner"
require_relative "./parser"
require_relative "./astPrinter"
require_relative "./interpreter"

def run(source)

	tokens = Scanner.scan(source)

	failed = tokens.include? nil
	return if failed

	ast = Parser.parse tokens

	failed = ast == nil
	return if failed

	value = Interpreter.interpret ast
	p value

end
