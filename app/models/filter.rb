class Filter < ActiveRecord::Base
  validates :cond, :presence => true

  has_many :manipulations, :dependent => :destroy
  
  def self.validate note_param
    require 'validate'
    parser = ValidateParser.new
    
    Filter.all.inject([]) {|acc, filter|
      syntree = parser.parse(filter.cond)
      if syntree
        begin
          if syntree.validate note_param
            acc << filter
          else
            acc
          end
        rescue
          acc
        end
      else
        acc
      end
    }
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
    end
  end
end
