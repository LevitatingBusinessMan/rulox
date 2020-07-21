class LoxRuntimeError < StandardError
	attr_reader :token

	def initialize token, msg
		@token = token
		super msg
	end
end
