# frozen_string_literal: true

module ApiEntreprise
  module Errors
    # More info: https://api.apientreprise.fr/documentation#codes-erreur

    # User-side problem: SIRET or SIREN was not found
    class NotFoundError < StandardError; end
  end
end
