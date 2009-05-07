class ViewProxy
  
  def initialize active_record
    @active_record = active_record
  end
  
  def method_missing(method_name, *args)
  
    if defined? @active_record.view
      if defined? @active_record[method_name]
        if block_given?
          yield @active_record.view method_name
        else
          @active_record.view method_name
        end
      end
    end
    
  end
  
end