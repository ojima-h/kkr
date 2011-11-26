# Autogenerated from a Treetop grammar. Edits may be lost.


require 'treetop-utils'

module RestrictionGrammar
  include Treetop::Runtime

  def root
    @root ||= :expression
  end

  module Expression0
    def c
      elements[2]
    end
  end

  module Expression1
    def base
      elements[0]
    end

    def ops
      elements[2]
    end
  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_conjunction
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        if has_terminal?(' ', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(' ')
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s1 << r3
      if r3
        s5, i5 = [], index
        loop do
          i6, s6 = index, []
          if has_terminal?('>', false, index)
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('>')
            r7 = nil
          end
          s6 << r7
          if r7
            s8, i8 = [], index
            loop do
              if has_terminal?(' ', false, index)
                r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(' ')
                r9 = nil
              end
              if r9
                s8 << r9
              else
                break
              end
            end
            r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
            s6 << r8
            if r8
              r10 = _nt_conjunction
              s6 << r10
            end
          end
          if s6.last
            r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
            r6.extend(Expression0)
          else
            @index = i6
            r6 = nil
          end
          if r6
            s5 << r6
          else
            break
          end
        end
        if s5.empty?
          @index = i5
          r5 = nil
        else
          r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        end
        s1 << r5
      end
    end
    if s1.last
      r1 = instantiate_node(Implication,input, i1...index, s1)
      r1.extend(Expression1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r11 = _nt_conjunction
      if r11
        r0 = r11
      else
        r12 = _nt_term
        if r12
          r0 = r12
        else
          r13 = _nt_atom
          if r13
            r0 = r13
          else
            @index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:expression][start_index] = r0

    r0
  end

  module Conjunction0
    def term
      elements[2]
    end
  end

  module Conjunction1
    def term
      elements[2]
    end
  end

  module Conjunction2
    def base
      elements[0]
    end

    def ops
      elements[2]
    end
  end

  def _nt_conjunction
    start_index = index
    if node_cache[:conjunction].has_key?(index)
      cached = node_cache[:conjunction][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_term
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        if has_terminal?(' ', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(' ')
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s1 << r3
      if r3
        s5, i5 = [], index
        loop do
          i6 = index
          s7, i7 = [], index
          loop do
            i8, s8 = index, []
            if has_terminal?('&', false, index)
              r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('&')
              r9 = nil
            end
            s8 << r9
            if r9
              s10, i10 = [], index
              loop do
                if has_terminal?(' ', false, index)
                  r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(' ')
                  r11 = nil
                end
                if r11
                  s10 << r11
                else
                  break
                end
              end
              r10 = instantiate_node(SyntaxNode,input, i10...index, s10)
              s8 << r10
              if r10
                r12 = _nt_term
                s8 << r12
              end
            end
            if s8.last
              r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
              r8.extend(Conjunction0)
            else
              @index = i8
              r8 = nil
            end
            if r8
              s7 << r8
            else
              break
            end
          end
          if s7.empty?
            @index = i7
            r7 = nil
          else
            r7 = instantiate_node(Conjunction::Meet,input, i7...index, s7)
          end
          if r7
            r6 = r7
          else
            s13, i13 = [], index
            loop do
              i14, s14 = index, []
              if has_terminal?('|', false, index)
                r15 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('|')
                r15 = nil
              end
              s14 << r15
              if r15
                s16, i16 = [], index
                loop do
                  if has_terminal?(' ', false, index)
                    r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(' ')
                    r17 = nil
                  end
                  if r17
                    s16 << r17
                  else
                    break
                  end
                end
                r16 = instantiate_node(SyntaxNode,input, i16...index, s16)
                s14 << r16
                if r16
                  r18 = _nt_term
                  s14 << r18
                end
              end
              if s14.last
                r14 = instantiate_node(SyntaxNode,input, i14...index, s14)
                r14.extend(Conjunction1)
              else
                @index = i14
                r14 = nil
              end
              if r14
                s13 << r14
              else
                break
              end
            end
            if s13.empty?
              @index = i13
              r13 = nil
            else
              r13 = instantiate_node(Conjunction::Join,input, i13...index, s13)
            end
            if r13
              r6 = r13
            else
              @index = i6
              r6 = nil
            end
          end
          if r6
            s5 << r6
          else
            break
          end
        end
        if s5.empty?
          @index = i5
          r5 = nil
        else
          r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        end
        s1 << r5
      end
    end
    if s1.last
      r1 = instantiate_node(Conjunction,input, i1...index, s1)
      r1.extend(Conjunction2)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r19 = _nt_term
      if r19
        r0 = r19
      else
        r20 = _nt_atom
        if r20
          r0 = r20
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:conjunction][start_index] = r0

    r0
  end

  module Term0
    def term
      elements[2]
    end
  end

  module Term1
    def expression
      elements[2]
    end

  end

  def _nt_term
    start_index = index
    if node_cache[:term].has_key?(index)
      cached = node_cache[:term][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?('!', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('!')
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        if has_terminal?(' ', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(' ')
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s1 << r3
      if r3
        r5 = _nt_term
        s1 << r5
      end
    end
    if s1.last
      r1 = instantiate_node(Negation,input, i1...index, s1)
      r1.extend(Term0)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i6, s6 = index, []
      if has_terminal?('(', false, index)
        r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('(')
        r7 = nil
      end
      s6 << r7
      if r7
        s8, i8 = [], index
        loop do
          if has_terminal?(' ', false, index)
            r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(' ')
            r9 = nil
          end
          if r9
            s8 << r9
          else
            break
          end
        end
        r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
        s6 << r8
        if r8
          r10 = _nt_expression
          s6 << r10
          if r10
            s11, i11 = [], index
            loop do
              if has_terminal?(' ', false, index)
                r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(' ')
                r12 = nil
              end
              if r12
                s11 << r12
              else
                break
              end
            end
            r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
            s6 << r11
            if r11
              if has_terminal?(')', false, index)
                r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r13 = nil
              end
              s6 << r13
              if r13
                s14, i14 = [], index
                loop do
                  if has_terminal?(' ', false, index)
                    r15 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(' ')
                    r15 = nil
                  end
                  if r15
                    s14 << r15
                  else
                    break
                  end
                end
                r14 = instantiate_node(SyntaxNode,input, i14...index, s14)
                s6 << r14
              end
            end
          end
        end
      end
      if s6.last
        r6 = instantiate_node(Parethesis,input, i6...index, s6)
        r6.extend(Term1)
      else
        @index = i6
        r6 = nil
      end
      if r6
        r0 = r6
      else
        r16 = _nt_atom
        if r16
          r0 = r16
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:term][start_index] = r0

    r0
  end

  module Atom0
    def name
      elements[1]
    end

  end

  def _nt_atom
    start_index = index
    if node_cache[:atom].has_key?(index)
      cached = node_cache[:atom][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?(':', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(':')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[^ !&|>]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        @index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
      if r2
        s4, i4 = [], index
        loop do
          if has_terminal?(' ', false, index)
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(' ')
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(Atom,input, i0...index, s0)
      r0.extend(Atom0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:atom][start_index] = r0

    r0
  end

end

class RestrictionGrammarParser < Treetop::Runtime::CompiledParser
  include RestrictionGrammar
end

