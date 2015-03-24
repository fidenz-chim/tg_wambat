class Errors
  
  def self.tg_error(error_msg)
    input_string = error_msg
    str1_markerstring = "@messages={:"
    str2_markerstring = "]}>"
    error_msg = input_string[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]
    error_msg = error_msg.gsub! '=>[' , ' '
    error_msg2 = error_msg.gsub! ']' , ''
    if !error_msg2.nil?
      error_msg2 = error_msg2.gsub! ':' , ''
      error_msg2 = error_msg2.gsub! '"', ''
      return error_msg2
    end
    return error_msg.gsub! '"', ''
  end
  
  
  
end