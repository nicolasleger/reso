# frozen_string_literal: true

module ApiEntreprise
  class Etablissements
    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def fetch(siret)
      Rails.cache.fetch("etablissement-#{siret}", expires_in: 12.hours) do
        fetch_from_api(siret)
      end
    end

    def fetch_from_api(siret)
      connection = HTTP

      etablissement_response = EtablissementRequest.new(token, siret, connection).response
      etablissement_response.check_status!
      etablissement_response.etablissement_wrapper
    end
  end
end
