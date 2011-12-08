class Compilation < Treetop::Runtime::SyntaxNode
  def self.product(a, b)
    Enumerator.new {|y|
      a.each {|e_a|
        b.each {|e_b|
          y << [e_a, e_b]
        }
      }
    }
  end

  # def self.sum(a, b)
  #   r = (a + b).classify {|o|
  #     o[:tag].id
  #   }.map {|k, v|
  #     if v.any? {|u| u[:type] == :exp}
  #       v.delete_if {|u| u[:type] == :tag}
  #     end
  #     v
  #   }.inject(Set[]) {|acc, o|
  #     acc.merge o
  #   }
  #   if not r then p a; p b end
  #   r
  # end

  def self.join(a, b)
    a + b
  end
  def self.meet(a, b)
    product(a, b).inject([]) {|acc,e|
      #t = self.sum(e[0][:t], e[1][:t])
      #f = self.sum(e[0][:f], e[1][:f])
      acc << {:t => e[0][:t] + e[1][:t], :f => e[0][:f] + e[1][:f]}
    }
  end
  def self.negation(a)
    a.map {|e|
      e[:t].map {|f|
        {:t => Set[], :f => Set[f]}
      } + 
      e[:f].map {|f|
        {:t => Set.new([f]), :f => Set.new([])}
      }
    }.inject([{:t => Set.new([]), :f => Set.new([])}]) {|acc, e|
      meet(acc, e)
    }
  end
end      

class Implication < Compilation
  def validate links_data
    not base.validate(links_data) or
      (not ops.elements.empty? and
       (ops.elements[-1].c.validate(links_data) or
        ops.elements[0...-1].any? {|e|
          not e.c.validate(links_data)
        }))
  end
  def complete
    elms = ops.elements.map {|e| e.c}.unshift(base)
    last = elms.pop
    elms.inject(last.complete) {|acc,e|
      Compilation.join(Compilation.negation(e.complete), acc)
    }
  end
end

class Conjunction < Compilation
  class Meet < Treetop::Runtime::SyntaxNode
    def val(links_data,base)
      base and elements.all? {|m|
        m.term.validate(links_data)
      }
    end
    
    def comp(base)
      elements.map {|m|
        m.term
      }.inject(base) {|acc, e|
        Compilation.meet(acc, e.complete)
      }
    end
  end
  class Join < Treetop::Runtime::SyntaxNode
    def val(links_data, base)
      base or elements.any? {|m|
        m.term.validate(links_data)
      }
    end
    
    def comp(base)
      elements.map {|m|
        m.term
      }.inject(base) {|acc,e|
        Compilation.join(acc, e.complete)
      }
    end
  end

  def validate(links_data)
    ops.elements.inject(base.validate(links_data)) {|acc,e|
      e.val(links_data, acc)
    }
  end
  
  def complete
    ops.elements.inject(base.complete) {|acc,e|
      e.comp(acc)
    }
  end
end


class Parethesis < Compilation
  def validate(links_data)
    expression.validate(links_data)
  end
  
  def complete
    expression.complete
  end
end

class Negation < Compilation
  def validate(links_data)
    not term.validate(links_data)
  end
  def complete
    Compilation.negation(term.complete)
  end
end

class Stat < Compilation
  def validate(links_data)
    tag = Tag.first(:conditions => {:name => name.text_value})
    if tag
      link_data = links_data.find {|ld|
        ld[:tag_id].to_i == tag.id
      }
      if link_data
        if link_data[:value]
          case cond.text_value
          when '<'
            Integer(link_data[:value]) < Integer(value.text_value)
          when '='
            link_data[:value] == value.text_value
          when '>'
            Integer(link_data[:value]) > Integer(value.text_value)
          when '~'
            link_data[:value].match (value.text_value)
          else
            false
          end
        else
          false
        end
      else
        true
      end
    else
      true
    end
  end
  
  def complete
    tag = Tag.first(:conditions => {:name => name.text_value})
    if tag
      pred = Proc.new {|links_data|
        link_data = links_data.find {|ld|
          ld[:tag_id].to_i == tag.id
        }
        if link_data
          case cond.text_value
          when '<'
            Integer(link_data[:value]) < Integer(value.text_value)
          when '='
            link_data[:value] == value.text_value
          when '>'
            Integer(link_data[:value]) > Integer(value.text_value)
          when '~'
            link_data[:value].match (value.text_value)
          else
            false
          end
        else
          true
        end
      }
      [{:t => Set.new([{:type => :exp,
                         :tag => tag,
                         :pred => pred,
                         :value => text_value}]),
         :f => Set.new([])}]
    else
      []
    end
  end
end

class Atom < Compilation
  def validate(links_data)
    tag = Tag.first(:conditions => {:name => name.text_value})
    if tag
      links_data.any? {|ld|
        ld[:tag_id].to_i == tag.id
      }
    else
      false
    end
  end
  
  def complete
    tag = Tag.first(:conditions => {:name => name.text_value})
    if tag
      pred = Proc.new {|links_data|
        links_data.any? {|ld|
          ld[:tag_id].to_i == tag.id
        }
      }
      [{:t => Set.new([{:type => :tag,
                         :tag => tag,
                         :pred => pred,
                         :value => tag.name}]),
         :f => Set.new([])}]
    else
      []
    end
  end
end

