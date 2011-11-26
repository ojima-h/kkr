class Restriction < ActiveRecord::Base
  require 'restriction'
  serialize :cond, RestrictionGrammarParser::Runtime::SyntaxNode
end
