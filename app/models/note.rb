class Note < ActiveRecord::Base
  validates :content, :presence => true, :length => {:maximum => 200}
  has_many :links, :dependent => :destroy, :autosave => true
  has_many :tags, :through => :links, :uniq => true

  def update_links links_param
    result = true
    if links_param
      links.each do |l|
        if not links_param.find {|lp| l.tag.name == lp[:tag_name]}
          result &= l.destroy
        end
      end

      links_param.each do |lp|
        if lp[:tag_name] and not lp[:tag_name].blank?
          tag = (Tag.where(:name => lp[:tag_name]).first or
                 Tag.create(:name => lp[:tag_name]))
          
          link = links.where(:tag_id => tag.id).first
          if link
            link.update_attributes(:value => lp[:value])
          else
            links << Link.create(:tag => tag, :value => lp[:value])
          end
        end
      end
    end
    result
  end

  def execute manipulation
    case manipulation.sort
    when "append"
      tag = (Tag.where(:name => manipulation.object).first or
             Tag.create(:name => manipulation.object))
      
      if not links.joins(:tag).exists?(:tags => {:name => manipulation.object})
        links << Link.create(:tag => tag,
                          :value => manipulation.value)
      end
    when "delete"
      link = links.joins(:tag).where(:tags => {:name => manipulation.object}).first
      if link
        link.destroy
      end
    when "modify"
      link = links.includes(:tag).where(:tags => {:name => manipulation.object}).first
      if link
        link.update_attributes(:value => manipulation.value)
      end
    when "subst"
      c = content.gsub(Regexp.new(manipulation.object)) {|match|
        manipulation.value.gsub('&', match)
      }
      update_attributes(:content => c)
    when "attach"
      content.gsub!(Regexp.new(manipulation.object)) {|m|
        if not links.joins(:tag).exists?(:value => m, :tags => {:name => manipulation.value})
          tag = (Tag.where(:name => manipulation.value).first or
                 Tag.create(:name => manipulation.value))
          
          links << Link.create(:value => m, :tag => tag)
        end
        m
      }
    else
      nil
    end
  end
end
