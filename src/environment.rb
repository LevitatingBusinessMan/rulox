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

		raise LoxRuntimeError.new identifierToken, "Undefined variable #{name}"
	end

	# Methods below replace get and assign when using the resolver
	def get_at distance, identifierToken
		get_ancestor(distance).values[identifierToken.lexeme]
	end

	def assigng_at distance, identifierToken, value
		get_ancestor(distance).values[identifierToken.lexeme] = value
	end

	def get_ancestor distance
		environment = self
		distance.times do environment = environment.parent end
		return environment
	end

	def values
		@values
	end

end
