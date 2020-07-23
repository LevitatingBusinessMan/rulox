require 'pathname'

exit puts "Please specify src directory" if ARGV.length < 1
@dir = Pathname.new ARGV[0]

expressions = {
	"Binary" 		=> ["left", "operator", "right"],
	"Grouping" 		=> ["expression"],
	"Literal" 		=> ["value"],
	"Unary" 		=> ["operator", "right"],
	"Variable"		=> ["name"],
	"Assignment" 	=> ["name", "expression"],
	"Ternary"		=> ["condition", "first", "second"]
}

statements = {
	"ExpressionStmt"	=> ["expression"],
	"PrintStmt"				=> ["expression"],
	"VarDecl"			=> ["name", "initializer"],
	"Block"				=> ["statements"],
	"IfStmt"			=> ["condition", "thenBranch", "elseBranch"]
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
		visitor.visit#{name}#{name.end_with?("Stmt") || name.end_with?("Expr") ? "" : type} self
	end

end

"
		File.write path, class_string, mode: "a"
	end

end

write "Expr", expressions
write "Stmt", statements
