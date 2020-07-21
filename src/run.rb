require_relative "./scanner"

def run(source)

	tokens = scan(source)

	failed = tokens.include? nil

end
