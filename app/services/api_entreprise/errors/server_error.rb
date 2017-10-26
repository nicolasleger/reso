# frozen_string_literal: true

module ApiEntreprise
  module Errors
    # More info: https://api.apientreprise.fr/documentation#codes-erreur

    # ApiEntreprise-side problem: Server or gateway unavailable
    class ServerError < StandardError; end
  end
end
