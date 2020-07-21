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

end

Test.foo
Test.change
Test.foo
