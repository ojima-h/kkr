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

  def self.join(a, b)
    a + b
  end
  def self.meet(a, b)
    product(a, b).inject([]) {|acc,e|
      acc << {:t => e[0][:t] + e[1][:t], :f => e[0][:f] + e[1][:f]}
    }
  end
  def self.negation(a)
    a.map {|e|
      e[:t].map {|f|
        {:t => Set.new([]), :f => Set.new([f])}
      } + e[:f].map {|f|
        {:t => Set.new([f]), :f => Set.new([])}
      }
    }.inject([{:t => Set.new([]), :f => Set.new([])}]) {|acc, e|
      meet(acc, e)
    }
  end
end      

class Implication < Compilation
  def validate note
    not base.validate(note) or
      (not ops.elements.empty? and
       (ops.elements[-1].c.validate(note) or
        ops.elements[0...-1].any? {|e|
          not e.c.validate(note)
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
    def val(note,base)
      base and elements.all? {|m|
        m.term.validate(note)
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
    def val(note, base)
      base or elements.any? {|m|
        m.term.validate(note)
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

  def validate(note)
    ops.elements.inject(base.validate(note)) {|acc,e|
      e.val(note, acc)
    }
  end
  
  def complete
    ops.elements.inject(base.complete) {|acc,e|
      e.comp(acc)
    }
  end
end


class Parethesis < Compilation
  def validate(note)
    expression.validate(note)
  end
  
  def complete
    expression.complete
  end
end

class Negation < Compilation
  def validate(note)
    not term.validate(note)
  end
  def complete
    Compilation.negation(term.complete)
  end
end

class Atom < Compilation
  def validate(note)
    note.tags.find_by_name(name.text_value)
  end
  
  def complete
    [{:t => Set.new([name.text_value]), :f => Set.new([])}]
  end
end


