class Logger

	def self.errorl(line, message)
		report(line, "", message)
	end

	def self.errort(token, message)
		if token.type == :EOF
			report(token.line, " at end", message) 
		else 
			report(token.line, " at '#{token.lexeme}'", message)
		end
	end

	def self.report(line, where="", message)
		STDERR.puts "[Line #{line}] Error#{where}: #{message}"
	end

	def self.runtime_error(error)
		STDERR.puts "[ERROR line #{error.token.line}]: #{error.message}"
	end

end
