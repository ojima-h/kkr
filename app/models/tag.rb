class Tag < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  has_many :links, :dependent => :destroy
  has_many :notes, :through => :links

  after_initialize do
    if new_record? and (self.color == nil or self.color.blank?)
      self.color = "lightgray"
    end
  end
end
