require_relative "./prompt"
require_relative "./run"

def runFile(path)
	run(File.read(path))
end

case ARGV.length
when 2..1.0/0.0 # 2 to infin
	puts("Usage: rulox [script]")
when 1
	runFile(ARGV[0])
when 0
	runPrompt()
end
