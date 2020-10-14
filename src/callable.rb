require_relative "./runtimeError"
require_relative "./environment"
require_relative "./returnError"

class Callable
    attr_reader :name, :arity

    def initialize
    end

    def to_s
    end

    def call interpreter, arguments
    end
end

class Function < Callable
    def initialize funDecl, closure
        @name = funDecl.name.lexeme
        @arity = funDecl.parameters.length
        @parameters = funDecl.parameters
        @body = funDecl.body
        @closure = closure
    end

    def to_s
        "<Function #{@name}>"
    end

    def call interpreter, arguments
        environment = Environment.new @closure
        @parameters.each_with_index {|parameter, index|
            environment.define parameter.lexeme, arguments[index]
        }

        begin
            # The JLOX code runs the block with the environment made in the lines above.
            # This doesn't work for me because with my setup the resolver makes a scope for the function parameters
            # and then a new scope for the block. This is simply because jlox uses a list of statements as the function body
            # and I use a block statement class as a function body, which when gets resolved by the resolver creates an extra scope.
            # So to sync the resolver and interpreter correctly, I have to also make a new scope here.
            # Yes it took a while for me to debug this.
            interpreter.executeBlock @body.statements, Environment.new(environment)
        rescue ReturnError => error
            return error.value
        end

        return nil
    end

end

class NativeFunction < Callable
    def initialize name, arguments, body
        @name = name
        @arity = arguments.length

        @proc = body

    end

    def to_s
        "<Native Function #{@name}>"
    end

    def call interpreter, arguments
        @proc.call arguments
    end
end
