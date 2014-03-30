module MyNextFlat

  class Error < StandardError
    attr_accessor :original
    def initialize( msg = nil, original = $! )
      super( msg || original.try(:message) )
      @original = original
    end
  end

  class ServiceError < Error
    attr_accessor :response
    def initialize( msg = nil, response = nil, original = $! )
      super( msg, original )
      @response = response
    end
  end

end
