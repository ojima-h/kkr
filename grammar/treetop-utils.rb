class Start < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    expression.validate note_param
  end
end

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
    note_param[:content] and 
      case cond.text_value
      when 'match'
        note_param[:content].match arg.value.text_value
      when 'equal'
        note_param[:content] == arg.value.text_value
      when 'include'
        note_param[:content].include? arg.value.text_value
      else
        false
      end
  end
end

class Stat < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    tag_name = name.text_value

    if note_param[:links]
      link_data = note_param[:links].find {|ld| ld[:tag_name] == tag_name}

      link_data and link_data[:value] and
        (case cond.text_value
         when '<'
           Integer(link_data[:value]) < Integer(arg.value.text_value)
         when '>'
           Integer(link_data[:value]) > Integer(arg.value.text_value)
         when '='
           link_data[:value] == arg.value.text_value
         when '~'
           link_data[:value].match (arg.value.text_value)
         else
           false
         end)
    else
      false
    end
  end
end

class Atom < Treetop::Runtime::SyntaxNode
  def validate(note_param)
    note_param[:links] and
      note_param[:links].find {|ld| ld[:tag_name] and ld[:tag_name] == name.text_value}
  end
end
