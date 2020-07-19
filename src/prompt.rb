require "readline"
require_relative "./run"

def runPrompt()
	while source = Readline.readline("> ", true)
		run(source)
	end
	puts
end
