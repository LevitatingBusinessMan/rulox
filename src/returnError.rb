class ReturnError < StandardError
	attr_reader :value

	def initialize value
		@value = value
		super
	end
end
