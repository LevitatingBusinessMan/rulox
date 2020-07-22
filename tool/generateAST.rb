require 'pathname'

return puts "Please specify src directory" if ARGV.length < 1
@dir = Pathname.new ARGV[0]

expressions = {
	"Binary" 	=> ["left", "operator", "right"],
	"Grouping" 	=> ["expression"],
	"Literal" 	=> ["value"],
	"Unary" 	=> ["operator", "right"]
}

statements = {
	"ExpressionStmt"	=> ["expression"],
	"Print"				=> ["expression"]
}

def write type, list

	@file = "expressions.rb" if type == "Expr"
	@file = "statements.rb" if type == "Stmt"

	path = @dir.join @file
	File.delete path

	list.each do |name, variables|
		class_string =
"class #{name}
	attr_reader #{variables.map {|var| ":" + var}.join ", "}

	def initialize #{variables.join ", "}
		#{variables.map {|var| "@#{var} = #{var}"}.join "\n\t\t"}
	end

	def accept visitor
		visitor.visit#{name}#{name == "ExpressionStmt" ? "" : type} self
	end

end

"
		File.write path, class_string, mode: "a"
	end

end

write "Expr", expressions
write "Stmt", statements
