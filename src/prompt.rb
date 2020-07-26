require "readline"
require_relative "./run"

def runPrompt()
	while source = Readline.readline("> ", true)
		# When no ";" assume to be expression
		if source.end_with? ';' or source.end_with? '}';
			run source
		else
			evaluate source
		end
	end
	puts
end
