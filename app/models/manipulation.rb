class Manipulation < ActiveRecord::Base
  SORTS = ["append", "delete", "modify", "subst", "attach"]

  belongs_to :filter
  validates :sort, :presence => true, :inclusion => SORTS
  validates :sort, :object, :presence => true

  after_initialize do
    if new_record?
      self.value ||= ""
    end
  end
end
