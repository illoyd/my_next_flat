module Zoopla

  class API
    include APISmith::Client
    base_uri "http://api.zoopla.co.uk/"
    endpoint "api/v1/"
    # debug_output $stdout

    def initialize(key = Rails.application.secrets.zoopla_api_key)
      add_query_options!( api_key: key )
    end
    
    def base_request_options
      { headers: { 'Accept' => 'application/json' } }
    end
  
    ##
    # Verify that the response is valid and can be parsed.
    def check_response_errors(response)
      case response.code
        when 400 then raise BadRequestError.new("Not enough parameters to produce a valid response.", response)
        when 401 then raise UnauthorizedRequestError.new("The API key could not be recognised and the request is not authorized.", response)
        when 403 then raise ForbiddenError.new("The requested method is not available for the API key specified (the API key is invalid?).", response)
        when 404 then raise NotFoundError.new("A method was requested that is not available in the API version specified.", response)
        when 405 then raise MethodNotAllowedError.new("The HTTP request that was made requested an API method that can not process the HTTP method used.", response)
        when 500 then raise InternalServerError.new("Internal Server Error", response)
        else
          check_response_body_errors(response)
      end
    end
    
    def check_response_body_errors(response)
      return unless response && response['error_code']
      case response['error_code'].to_i
        when -1 then raise DisambiguationError.new("#{ response['error_string'] } Did you mean #{ response['disambiguation'].to_sentence( two_words_connector: ' or ', last_word_connector: ', or ') }?", response)
        when  1 then raise InsufficientArgumentsError.new(response['error_string'], response)
        when  5 then raise InvalidRequestedDataError.new(response['error_string'], response)
        when  7 then raise UnknownLocationError.new(response['suggestion'] || response['error_string'], response)
      end
    end
    
  end # API
end # Zoopla
