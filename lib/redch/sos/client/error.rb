module Redch::SOS
  module Client
    class Error < StandardError; end

    class NotFound < Error; end

    class BadRequest < Error; end

    class ServerError < Error; end
  end
end