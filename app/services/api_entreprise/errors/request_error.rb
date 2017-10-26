# frozen_string_literal: true

module ApiEntreprise
  module Errors
    # More info: https://api.apientreprise.fr/documentation#codes-erreur

    # Reso-side problem: Wrong ApiEntreprise configuration (wrong token or URL)
    class RequestError < StandardError; end
  end
end
