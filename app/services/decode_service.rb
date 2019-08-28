module DecodeService
  def self.attach_pdf(file, target)    
    pdf = split_base64(file)
    decoded_data = Base64.decode64(pdf[:data])
    io = StringIO.new
    io.puts(decoded_data)
    io.rewind
    target.attach(io: io, filename: "base.#{pdf[:extension]}")
  end

  private 

  def self.split_base64(uri_str)
    if uri_str =~ /^data:(.*?);(.*?),(.*)$/
      uri = {}
      uri[:type] = Regexp.last_match(1) # "image/gif"
      uri[:encoder] = Regexp.last_match(2) # "base64"
      uri[:data] = Regexp.last_match(3) # data string
      uri[:extension] = Regexp.last_match(1).split('/')[1] # "gif"
      uri
    end
  end
end  
