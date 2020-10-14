require_relative "./callable"
require_relative "./runtimeError"

def addNatives environment

    clock = NativeFunction.new "clock", Proc.new { (Time.now.to_f * 1000).floor }
    @environment.define "clock", clock

    openfd = NativeFunction.new "openfd", Proc.new { |filename, mode|
        IO.sysopen(filename, mode)
    }
    @environment.define "openfd", openfd

    writefd = NativeFunction.new "writefd", Proc.new { |filedescriptor, string|
        #syswrite to bypass buffering
        IO.new(filedescriptor).syswrite string
    }
    @environment.define "writefd", writefd

    readfd = NativeFunction.new "readfd", Proc.new { |filedescriptor|
        file = IO.new(filedescriptor).read
    }
    @environment.define "readfd", readfd

end
