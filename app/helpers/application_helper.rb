module ApplicationHelper
  def format text
    raw text.gsub(/\r\n|\r|\n/,'<br />') #.gsub(' ', '&nbsp;').gsub(/\t/,'    ')
  end
  def clear
    raw '<div style="clear : both"></div>'
  end
end
