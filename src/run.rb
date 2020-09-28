require_relative "./scanner"
require_relative "./parser"
require_relative "./interpreter"
require_relative "./resolver"

def run(source)

	tokens = Scanner.scan(source)
	return if !tokens

	statements = Parser.parse tokens
	return if !statements

	Resolver.start Interpreter, statements
	Interpreter.interpret(statements)

end

#For evaluating expressions
def evaluate tokens
	tokens = Scanner.scan(tokens)
	return if !tokens

	expression = Parser.parseExpression tokens
	return if !expression

	require_relative "./generated/statements"
	Interpreter.interpret [PrintStmt.new(expression)]
end
