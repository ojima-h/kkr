class Link < ActiveRecord::Base
  belongs_to :note
  belongs_to :tag

  def self.add_link_to_note note, links_param
    if note.id and tag_ids
      links_param.each {|lp|
        if not Link.find(:first, :conditions => ["note_id = ? and tag_id = ?", note.id, lp[:tag_id]])
          note.links << Link.new(:note_id => note.id, :tag_id => lp[:tag_id], :value => lp[:value])
        end
      }
      true
    else
      true
    end
  end
  
  def self.sync note, links_param
    result = true
    note.links.each do |l|
      if not links_param.find {|lp| l.tag.id == lp[:tag_id]}
        result &= l.destroy
      end
    end
    links_param.each do |lp|
      link = note.links.first(:conditions => {:tag_id => lp[:tag_id]})
      if link
        link.value = lp[:value]
        result & link.save
      else
        note.links << Link.new(:note_id => note.id, :tag_id => lp[:tag_id], :value => lp[:value])
        result
      end
    end
  end
end
