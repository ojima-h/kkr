class Filter < ActiveRecord::Base
  require 'validate'

  validates :cond, :presence => true
  has_many :manipulations, :dependent => :destroy

  validate :cond_should_be_right_syntax

  @@parser = ValidateParser.new

  # after_save do
  #   @syntree = @@parser.parse(cond)
  # end

  def cond_should_be_right_syntax
    @syntree = @@parser.parse(cond)
    if not @syntree
      errors.add(:cond, @@parser.failure_reason)
    end
  end

  def validate note_param
    @syntree.validate note_param
  end

  def update_manipulations params
    if params
      params.inject(true) {|result, p|
        if p[:id] and p[:id].to_i != 0
          manipulation = manipulations.find(p[:id])
          if manipulation
            manipulation.filter_id = id
            manipulation.sort = p[:sort]
            manipulation.object = p[:object]
            manipulation.value = p[:value]
            manipulation.save and result
          else
            false
          end
        else
          manipulation = Manipulation.new(:filter_id => id,
                                          :sort => p[:sort],
                                          :object => p[:object],
                                          :value => p[:value])
          manipulation.save and result
        end
      }
    else
      true
    end
  end
end
