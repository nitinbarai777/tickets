module SearchHandler
  extend ActiveSupport::Concern

  included do
    
    def self.search(search)
      if search
        search_keys = ''
        search.each do |k, v|
          unless v.blank?
            search_keys = "#{search_keys} #{k} LIKE '%#{v}%' OR"
          end  
        end
        
        search_keys.strip!
        3.times do search_keys.chop! end
       
        if search_keys
          where(search_keys)
        end
      else
        scoped
      end
    end
  end  
  
end