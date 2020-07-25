require_relative "./runtimeError"

#Pretty much just a normal hash, but it can error
class Environment
	attr_reader :parent

	def initialize parent=nil
		@values = {}
		@parent = parent
	end

	def define name, value
		@values[name] = value
	end

	#redefining
	def assign identifierToken, value
		name = identifierToken.lexeme
		if @values.key? name
			@values[name] = value
		
		#Try parent block instead
		elsif @parent
			@parent.assign identifierToken, value
		else
			raise LoxRuntimeError.new identifierToken, "Assignment to undefined variable #{name}"
		end
	end

	def get identifierToken
		name = identifierToken.lexeme
		return @values[name] if @values.key? name

		# Try parent block instead
		return @parent.get identifierToken if @parent

		raise "ASFAF"
		raise LoxRuntimeError.new identifierToken, "Undefined variable #{name}"
	end

end
