# frozen_string_literal: true

module ApiEntreprise
  class Entreprises
    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def fetch(siren)
      Rails.cache.fetch("entreprise-#{siren}", expires_in: 12.hours) do
        fetch_from_api(siren)
      end
    end

    def fetch_from_api(siren)
      connection = HTTP

      entreprise_response = EntrepriseRequest.new(token, siren, connection).response
      entreprise_response.check_status!
      entreprise_response.entreprise_wrapper
    end
  end
end
