module Stuart
  class Request
    attr_reader :headers, :body, :host, :path, :method
    def initialize(headers:, body:, host:, path:, method:)
      @headers, @body, @host, @path, @method = headers, body, host, path, method
    end

    def signed?
      @headers.keys.include?('Authorization') && /^Signature/.match(@headers['Authorization']) != nil
    end

    def signature
      throw "No signed" unless signed?
      authorization_header[:signature]
    end

    def payload
      authorization_header[:headers].collect do |part|
        send(part.gsub("-", "_"))
      end.join(authorization_header[:delimiter])
    end

    private
    def cleaned_authorization_header
      @headers['Authorization'].gsub(/^Signature /, '')
    end

    def content_type
      @headers['Content-Type']
    end

    def host
      @headers['Host'].gsub(/\:.{1,}/, '')
    end

    def date
      @headers['Date']
    end

    def url
      path
    end

    def authorization_header
      Hash[cleaned_authorization_header.split(",").map do |part|
      	key,value = part.split("=", 2)

      	value.gsub!("\"", "")
      	if key == 'headers'
      		value = value.split(' ')
      	end
      	[key.to_sym, value]
      end]
    end
  end
end
