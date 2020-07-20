def error(line, message)
	report(line, "", message)
end

def report(line, where="", message)
	puts "[Line #{line}] Error#{where}: #{message.inspect}"
end
