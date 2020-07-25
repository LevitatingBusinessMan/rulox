require_relative "./runtimeError"

class Function
    attr_reader :name, :arity
    attr_writer :to_s

    def initialize name, arguments, body
        @name = name
        @arity = arguments.length

        @native = body if body.class == Proc

    end

    def to_s
        "<Function #{@name}" + @native ? " (native)>" : ">"
    end

    def call interpreter, arguments
        @native.call
    end
end
