class Restriction < ActiveRecord::Base
  require 'restriction'
  require 'set'

  def self.validate_restriction(note, links_data)
    parser = RestrictionGrammarParser.new
    condition = self.all.map {|r| "(" + r.cond + ")" }.join ("&")

    if condition.empty?
      true
    else
      syntree = parser.parse(condition)
      if syntree
        begin
          syntree.validate links_data
        rescue ArgumentError
          false
        end
      else
        false
      end
    end
  end

  def self.completion_list links_data
    parser = RestrictionGrammarParser.new
    condition = self.all.map {|r| "(" + r.cond + ")" }.join ("&")

    if condition.empty?
      []
    else
      syntree = parser.parse(condition)
      if not syntree
        p parser.failure_reason
        nil
      else
        comp = syntree.complete

        p "DEBUG"
        comp.each do |c|
          printf "  :t =>\n"
          c[:t].each do |s|
            printf "        %s\n", s.to_s
          end
          printf "  :f =>\n"
          c[:f].each do |s|
            printf "        %s\n", s.to_s
          end
        end
        ret = comp.map {|c|
          result = {}
          (c[:t].each{|v| v[:bool] = true} + c[:f].each{|v| v[:bool] = false}).classify {|o|
            o[:tag].id
          }.each {|k,v|
            data = v.classify {|o| o[:type]}
            [:tag, :exp].each {|t| if not data[t] then data[t] = Set[] end}
            if not data[:tag].empty?
              if data[:tag].any? {|o| o[:bool]} and data[:tag].any? {|o| not o[:bool]}
                result = nil
                break
              else
                base_data = data[:tag].first
                if data[:exp].empty?
                  if base_data[:bool]
                    result[k] = {
                      :type => :add,
                      :pred => base_data[:pred],
                      :tag => base_data[:tag],
                      :value => base_data[:value]
                    }
                  else
                    result[k] = {
                      :type => :delete,
                      :pred => Proc.new {|links_data| not base_data[:pred].call links_data},
                      :tag => base_data[:tag],
                      :value => base_data[:value]
                    }
                  end
                else
                  exp_data = data[:exp].classify {|o| o[:bool]}
                  [true, false].each {|b| if not exp_data[b] then exp_data[b] = Set[] end}
                  if base_data[:bool]
                    result[k] = {
                      :type => :edit,
                      :pred => Proc.new {|links_data|
                        begin
                          exp_data[true].all? {|ed| ed[:pred].call(links_data)} and
                            exp_data[false].all? {|ed| not ed[:pred].call(links_data)}
                        rescue ArgumentError
                          false
                        end
                      },
                      :tag => base_data[:tag],
                      :value => exp_data[true].inject("") {|acc, ed|
                        acc + ed[:value] + " and"
                      } + exp_data[false].inject("") {|acc,ed|
                        acc + " not" + ed[:value] + " and"
                      }
                    }
                  else
                    if exp_data[false].empty?
                      next
                    else
                      result = nil
                      break
                    end
                  end
                end
              end
            else
              exp_data = data[:exp].classify {|o| o[:bool]}
              [true, false].each {|b| if not exp_data[b] then exp_data[b] = [] end}
              if exp_data[false].empty?
                result[k] = {
                  :type => :cond,
                  :pred => Proc.new {|links_data|
                    begin
                      exp_data[true].all? {|ed| ed[:pred].call(links_data)} and
                        exp_data[false].all? {|ed| not ed[:pred].call(links_data)}
                    rescue ArgumentError
                      false
                    end
                  },
                  :tag => Tag.find(k),
                  :value => exp_data[true].inject("") {|acc, ed|
                    acc + ed[:value] + " and"
                  } + exp_data[false].inject("") {|acc,ed|
                    acc + " not" + ed[:value] + " and"
                  }
                }
              else
                result[k] = {
                  :type => :edit,
                  :pred => Proc.new {|links_data|
                    begin
                      exp_data[true].all? {|ed| ed[:pred].call(links_data)} and
                        exp_data[false].all? {|ed| not ed[:pred].call(links_data)}
                    rescue ArgumentError
                      false
                    end
                  },
                  :tag => Tag.find(k),
                  :value => exp_data[true].inject("") {|acc, ed|
                    acc + ed[:value] + " and"
                  } + exp_data[false].inject("") {|acc,ed|
                    acc + " not" + ed[:value] + " and"
                  }
                }
              end
            end
          }

          if result
            data = {:add => [], :delete => [], :edit => [], :keep => []}
            p result
            p links_data
            result.each {|tag_id, operation|
              case operation[:type]
              when :add
                ld = links_data.find {|ld| ld[:tag_id].to_i == tag_id}
                if not ld
                  data[:add] << operation
                else
                  data[:keep] << ld
                end
              when :delete
                ld = links_data.find {|ld| ld[:tag_id].to_i == tag_id}
                if ld
                  data[:delete] << operation
                end
              when :edit
                ld = links_data.find {|ld| ld[:tag_id].to_i == tag_id}
                if not (ld and operation[:pred].call([ld]))
                  data[:edit] << operation
                else
                  data[:keep] << ld
                end
              when :cond
                ld = links_data.find {|ld| ld[:tag_id].to_i == tag_id}
                if ld and not operation[:pred].call([ld])
                  data[:edit] << operation
                else
                  data[:keep] << ld
                end
              end
            }
            links_data.each {|ld|
              if not result[ld[:tag_id].to_i]
                data[:keep] << ld
              end
            }
            data
          else
            nil
          end
        }.compact
        p ret
        ret
      end
    end
  end
end
