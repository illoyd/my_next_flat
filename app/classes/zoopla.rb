module Zoopla

  class Error < StandardError
    attr_accessor :original, :response
    def initialize( msg = nil, response = nil, original = $! )
      super( msg || original.try(:message) )
      @response = response
      @original = original
    end
  end

  # Raised when Zoopla returns the HTTP status code 400
  class BadRequestError < Error; end
  
  # Raised when Zoopla returns the HTTP status code 401
  class UnauthorizedRequestError < Error; end
  
  # Raised when Zoopla returns the HTTP status code 403
  class ForbiddenError < Error; end
  
  # Raised when Zoopla returns the HTTP status code 404
  class NotFoundError < Error; end
  
  # Raised when Zoopla returns the HTTP status code 405
  class MethodNotAllowedError < Error; end
  
  # Raised when Zoopla returns the HTTP status code 500
  class InternalServerError < Error; end
  
  # Raised when there are insufficient arguments for the API to return a result
  class InsufficientArgumentsError < Error; end
  
  # Raised under mysterious circumstances 
  class InvalidRequestedDataError < Error; end
  
  # Raised when an invalid output type is specified
  class InvalidOutputTypeError < Error; end
  
  # Raised when an ambiguous area name is given, e.g. Whitechapel (is it in London? Devon? Lancashire?)
  class DisambiguationError < Error; end
  
  # Raised when an unknown location is searched for, e.g. Stok
  class UnknownLocationError < Error; end

end
