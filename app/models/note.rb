class Note < ActiveRecord::Base
  validates :content, :presence => true, :length => {:maximum => 200}
  has_many :links, :dependent => :destroy
  has_many :tags, :through => :links

  # def tags
  #   Link.find(:all, :conditions => ["note_id = ?", self.id], :order => "tag_id").map {|l|
  #     Tag.find(l.tag_id)
  #   }
  # end
end
