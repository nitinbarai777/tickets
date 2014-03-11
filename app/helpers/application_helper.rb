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
    [["Open", "1"]] + [["On Hold", "2"]] + [["Close", "3"]] 
  end
  
  def ticket_status_hash
    {"1" => "Open", "2" => "On Hold", "3" => "Close"}
  end
  
  def ticket_priority_hash
    {"1" => "Low", "2" => "Medium", "3" => "High", "4" => "Urgent", "5" => "Emergency", "6" => "Critical"}
  end  
  
  def get_ticket_priority
    [["Low", "1"]] + [["Medium", "2"]] + [["High", "3"]] + [["Urgent", "4"]] + [["Emergency", "5"]] + [["Critical", "6"]] 
  end
  
  def get_pager_numbers
    [["10", 10]] + [["20", 20]] + [["30", 30]] + [["40", 40]] + [["50", 50]]
  end
  
  def get_user_roles
    Role.all.collect {|r| [r.role_type, r.id]} 
  end      
    
end
