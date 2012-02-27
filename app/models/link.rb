class Link < ActiveRecord::Base
  belongs_to :note
  belongs_to :tag

  validates :note, :presence => true
  validates :tag, :presence => true

  after_initialize do
    if new_record?
      self.value ||= ""
    end
  end
end
