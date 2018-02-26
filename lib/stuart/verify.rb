module Stuart
  class Verify
    attr_reader :public_key, :request

    def initialize(request: , public_key:)
      @request = request
      @public_key = OpenSSL::PKey::RSA.new(public_key)
    end

    def verify
      public_key.verify(digest, Base64.decode64(request.signature), request.payload)
    end

    private

    def digest
      OpenSSL::Digest::SHA256.new()
    end
  end
end
