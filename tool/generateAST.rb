#rb tool/generateAST.rb > src/expressions.rb

expressions = {
	"Binary" => ["left", "operator", "right"],
	"Grouping" => ["expression"],
	"Literal" => ["value"],
	"Unary" => ["operator", "right"]
}

expressions.each do |name, variables|
	class_string =
"class #{name}
	attr_reader #{variables.map {|var| ":" + var}.join ", "}

	def initialize #{variables.join ", "}
		#{variables.map {|var| "@#{var} = #{var}"}.join "\n\t\t"}
	end

	def accept visitor
		visitor.visit#{name}Expr self
	end

end
"

	puts class_string

end
