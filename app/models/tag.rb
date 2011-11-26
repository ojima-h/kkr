class Tag < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  has_many :links, :dependent => :destroy
  has_many :notes, :through => :links

  def Tag.default_color
    "#87CEEB" #skyblue
  end

  def color
    c = read_attribute(:color)
    if c
      c
    else
      Tag.default_color
    end
  end
end
