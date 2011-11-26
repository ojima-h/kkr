module ApplicationHelper
  def formate text
    raw html_escape(text).gsub(/\t/,'    ').gsub(' ', '&nbsp;').gsub(/\r\n|\r|\n/,'<br />')
  end
  def clear
    raw '<div style="clear : both"></div>'
  end
end
