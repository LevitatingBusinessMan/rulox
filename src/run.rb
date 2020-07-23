require_relative "./scanner"
require_relative "./parser"
require_relative "./astPrinter"
require_relative "./interpreter"

def run(source)

	tokens = Scanner.scan(source)
	return if tokens.include? nil

	statements = Parser.parse tokens
	return if statements.include? nil

	Interpreter.interpret(statements)

end

#For evaluating expressions
def evaluate tokens
	tokens = Scanner.scan(tokens)
	return if tokens.include? nil

	expression = Parser.parseExpression tokens
	return if !expression

	require_relative "./statements"
	Interpreter.interpret [Print.new(expression)]
end
