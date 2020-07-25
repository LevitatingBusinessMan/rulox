require_relative "./callable"

def addNatives environment

    clock = NativeFunction.new "clock", [], Proc.new { Time.now.to_i }
    @environment.define "clock", clock

end
