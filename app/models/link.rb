class Link < ActiveRecord::Base
  belongs_to :note
  belongs_to :tag

  def self.add_link_to_note note, tag_ids
    if note.id and tag_ids
      tag_ids.inject(true) {|result, t|
        if not Link.find(:first, :conditions => ["note_id = ? and tag_id = ?", note.id, t])
          l = Link.new(:note_id => note.id, :tag_id => t.to_i)
          l.save and result
        else
          result
        end
      }
    else
      true
    end
  end
  
  def self.sync note, tag_ids
    result = true
    note.links.each do |l|
      if not tag_ids.find {|t| l.tag.id == t.to_i}
        result &= l.destroy
      end
    end
    tag_ids.each do |t|
      if not note.links.exists?(['tag_id = ?', t.to_i])
        l = Link.new(:note_id => note.id, :tag_id => t.to_i)
        result &= l.save
      end
    end
  end
end
