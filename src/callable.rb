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
            interpreter.executeBlock @body.statements, environment
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
