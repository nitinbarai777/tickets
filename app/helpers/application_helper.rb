module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    if direction == "asc"
      title = image_tag("down_arrow.gif") + " " + title.to_s
    else  
      title = image_tag("up_arrow.gif") + " " + title.to_s
    end  
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), :class => direction, :remote => true
  end  
  
  def get_model_data(m, cemetery=false)
    if cemetery
      [["Select", ""]] + m.constantize.active.where(:cemetery_id => @cemetery.id).collect {|r| [r.name, r.id]}
    else
      [["Select", ""]] + m.constantize.active.collect {|r| [r.name, r.id]}
    end    
  end
  
  def get_all_pages
    FooterPage.footer 
  end
  
  def get_ticket_status
    [["Select", ""]] + [["Open", "1"]] + [["Close", "2"]] 
  end
  
  def get_ticket_priority
    [["Normal", "1"]] + [["High", "2"]] 
  end
  
  def get_pager_numbers
    [["10", 10]] + [["20", 20]] + [["30", 30]] + [["40", 40]] + [["50", 50]]
  end
  
  def get_user_roles
    Role.all.collect {|r| [r.role_type, r.id]} 
  end      
    
end
