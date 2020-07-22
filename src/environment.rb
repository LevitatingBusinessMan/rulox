require_relative "./runtimeError"

#Pretty much just a normal hash
class Environment
	def initialize
		@values = {}
	end

	def define identifierToken, value
		@values[identifierToken.lexeme] = value
	end

	def get identifierToken
		name = identifierToken.lexeme
		return @values[name] if @values.key? name

		raise LoxRuntimeError identifierToken, "Undefined variable #{name}"
	end

end
