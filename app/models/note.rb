class Note < ActiveRecord::Base
  validates :content, :presence => true, :length => {:maximum => 200}
  has_many :links, :dependent => :destroy
  has_many :tags, :through => :links, :uniq => true
end
