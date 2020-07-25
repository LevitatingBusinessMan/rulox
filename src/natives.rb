require_relative "./function"

def addNatives environment

    clock = Function.new "clock", [], Proc.new { Time.now.to_i }
    @environment.define "clock", clock

end
