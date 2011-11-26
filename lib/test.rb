# This is temporary Ruby script for testing

require 'treetop'
require 'restriction'

@parser = RestrictionParser.new

def parser
  @parser
end
def a x
  @parser.parse x
end
