class Expression < Treetop::Runtime::SyntaxNode
  class Meet < Treetop::Runtime::SyntaxNode
    def val(note_param,base)
      base and elements.all? {|m|
        m.term.validate(note_param)
      }
    end
  end
  class Join < Treetop::Runtime::SyntaxNode
    def val(note_param, base)
      base or elements.any? {|m|
        m.term.validate(note_param)
      }
    end
  end

  def validate(note_param)
    ops.elements.inject(base.validate(note_param)) {|acc,e|
      e.val(note_param, acc)
    }
  end
end


class Parethesis < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    expression.validate(note_param)
  end
end

class Negation < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    not term.validate(note_param)
  end
end

class Content < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    case cond.text_value
    when '~'
      note_param["content"].match value.text_value
    when '='
      note_param["content"] == value.text_value
    when '>'
      note_param["content"].include? value.text_value
    else
      false
    end
  end
end

class Stat < Treetop::Runtime::SyntaxNode
  def validate(params)
    tag = Tag.where(:name => name.text_value).first
    if tag
      link_data = (params["links"] or []).find {|ld| ld["tag_name"] == tag.name}
      if link_data and link_data["value"]
        case cond.text_value
        when '<'
          Integer(link_data["value"]) < Integer(value.text_value)
        when '='
          link_data["value"] == value.text_value
        when '>'
          Integer(link_data["value"]) > Integer(value.text_value)
        when '~'
          link_data["value"].match (value.text_value)
        else
          false
        end
      else
        false
      end
    else
      false
    end
  end
end

class Atom < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    tag = Tag.where(:name => name.text_value).first
    tag and note_param[:links].find {|ld| ld[:tag_id] == tag.id}
  end
end

