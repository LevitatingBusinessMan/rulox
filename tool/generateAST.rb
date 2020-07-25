require 'pathname'

if ARGV.length < 1
	puts "Please specify src directory" 
	exit 1
end
@dir = Pathname.new ARGV[0]

expressions = {
	"Binary" 		=> ["left", "operator", "right"],
	"Grouping" 		=> ["expression"],
	"Literal" 		=> ["value"],
	"Unary" 		=> ["operator", "right"],
	"Variable"		=> ["name"],
	"Assignment" 	=> ["name", "expression"],
	"Ternary"		=> ["condition", "first", "second"],
	"Logical"		=> ["left", "operator", "right"],
	"Ruby"			=> ["code"],
	"Call"			=> ["callee", "arguments", "close_paren"]
}

statements = {
	"ExpressionStmt"	=> ["expression"],
	"PrintStmt"			=> ["expression"],
	"VarDecl"			=> ["name", "initializer"],
	"Block"				=> ["statements"],
	"IfStmt"			=> ["condition", "thenBranch", "elseBranch"],
	"While"				=> ["condition", "body"],
	"FunDecl"			=> ["name", "parameters", "body"],
	"ReturnStmt"		=> ["keyword", "expression"]
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
