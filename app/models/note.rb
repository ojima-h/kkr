class Note < ActiveRecord::Base
  validates :content, :presence => true, :length => {:maximum => 200}
  has_many :links, :dependent => :destroy
  has_many :tags, :through => :links, :uniq => true

  def update_links links_param
    result = true
    links.each do |l|
      if not links_param.find {|lp| l.tag.name == lp[:tag_name]}
        result &= l.destroy
      end
    end
    if links_param
      links_param.each do |lp|
        if lp[:tag_name] and not lp[:tag_name].blank?
          tag = Tag.where(:name => lp[:tag_name]).first
          if not tag
            tag = Tag.new(:name => lp[:tag_name])
            tag.save
          end
          
          link = links.first(:conditions => {:tag_id => tag.id})
          if link
            link.value = lp[:value]
            link.save & result
          else
            links << Link.new(:tag_id => tag.id, :value => lp[:value])
            result
          end
        end
      end
    end
    result
  end

  def execute_manipulations filters
    links_data = []
    filters.each {|filter|
      filter.manipulations.inject(true) {|result, manipulation|
        case manipulation.sort
        when "append"
          tag = Tag.where(:name => manipulation.object).first
          if not tag
            tag = Tag.new(:name => manipulation.object)
            tag.save
          end
          if not links.joins(:tag).exists?(:tags => {:name => manipulation.object})
            links << Link.new(:note_id => id,
                              :tag_id => tag.id,
                              :value => manipulation.value)
            links and result
          else
            result
          end
        when "delete"
          link = links.joins(:tag).where(:tags => {:name => manipulation.object}).first
          if link
            link.destroy and result
          else
            result
          end
        when "modify"
          link = links.includes(:tag).where(:tags => {:name => manipulation.object}).first
          if link
            link.value = manipulation.value
            link.save and result
          else
            result
          end
        when "subst"
          update_attributes(:content => content.gsub(Regexp.new(manipulation.object)) {|match|
                              manipulation.value.gsub('&', match)
                            }) and result
        when "attach"
          content.gsub!(Regexp.new(manipulation.object)) {|m|
            if not Tag.exists?(:name => manipulation.value)
              tag = Tag.new(:name => manipulation.value)
              result &= tag.save
            end
            if not links.joins(:tag).exists?(:value => m, :tags => {:name => manipulation.value})
              new_link = Link.new(:value => m)
              new_link.tag = Tag.where(:name => manipulation.value).first
              links << new_link
            end
            m
          }
        else
          result
        end
      }
    }
  end
end
