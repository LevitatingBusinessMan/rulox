require_relative "./callable"

def addNatives environment

    clock = NativeFunction.new "clock", [], Proc.new { (Time.now.to_f * 1000).floor }
    @environment.define "clock", clock

end
