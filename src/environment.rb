require_relative "./runtimeError"

#Pretty much just a normal hash, but it can error
class Environment
	def initialize
		@values = {}
	end

	def define identifierToken, value
		@values[identifierToken.lexeme] = value
	end

	#redefining
	def assign identifierToken, value
		name = identifierToken.lexeme
		if @values.key? name
			@values[name] = value
		else
			raise LoxRuntimeError.new identifierToken, "Assignment to undefined variable #{name}"
		end
	end

	def get identifierToken
		name = identifierToken.lexeme
		return @values[name] if @values.key? name

		raise LoxRuntimeError.new identifierToken, "Undefined variable #{name}"
	end

end
