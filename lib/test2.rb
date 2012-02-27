require 'validate'
parser = ValidateParser.new
filter = Filter.last
syntree = parser.parse(filter.cond)
note_param = {:content => "adfa 1/14", :links => []}
syntree.validate note_param
