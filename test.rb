class Test
	@foo = "bar"

	def initialize
		foo
	end

	def self.change
		@foo = "foo"
	end

	def self.foo
		p @foo
	end

	def self.public_c
		private_c
	end

	def private_c
		p "private"
	end

end

Test.foo
Test.change
Test.foo
