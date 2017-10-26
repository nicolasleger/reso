# frozen_string_literal: true

module ApiEntreprise
  class Response
    attr_reader :http_response

    DEFAULT_ERROR_MESSAGE = 'There was an error with the request.'
    REQUEST_ERROR_STATUSES = [400, 401, 403, 422].freeze
    SERVER_ERROR_STATUSES = [500, 502, 503].freeze

    def initialize(http_response)
      @http_response = http_response
    end

    def check_status!
      check_not_found_error!
      check_request_error!
      check_server_error!
      check_misc_error!
    end

    protected

    def data
      http_response.parse(:json)
    end

    private

    def error_message
      data&.fetch('message', DEFAULT_ERROR_MESSAGE)
    end

    def check_not_found_error!
      raise ApiEntreprise::Errors::NotFoundError, error_message if http_response.status == 404
    end

    def check_request_error!
      raise ApiEntreprise::Errors::RequestError, error_message if REQUEST_ERROR_STATUSES.include? http_response.status
    end

    def check_server_error!
      raise ApiEntreprise::Errors::ServerError, error_message if SERVER_ERROR_STATUSES.include? http_response.status
    end

    def check_misc_error!
      raise ApiEntreprise::Errors::MiscError, error_message if http_response.status != 200
    end
  end
end
