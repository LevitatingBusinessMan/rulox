require_relative "./scanner"

def run(source)

	tokens = Scanner.scan(source)

	failed = tokens.include? nil

end
