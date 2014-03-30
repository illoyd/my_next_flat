require 'my_next_flat/error'

module Zoopla
  class Error < MyNextFlat::ServiceError; end
  class DisambiguationError < Zoopla::Error; end
  class SuggestionError < Zoopla::Error; end
  class UnknownLocationError < Zoopla::Error; end
end
