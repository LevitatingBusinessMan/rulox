require_relative "./scanner"
require_relative "./parser"
require_relative "./astPrinter"
require_relative "./interpreter"

def run(source)

	tokens = Scanner.scan(source)

	failed = tokens.include? nil
	return if failed

	statements = Parser.parse tokens

	failed = statements == nil
	return if failed

	Interpreter.interpret(statements)

end
