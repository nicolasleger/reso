# frozen_string_literal: true

module ApiEntreprise
  class EtablissementRequest
    attr_reader :token, :siret, :connection

    def initialize(token, siret, connection)
      @token = token
      @siret = siret
      @connection = connection
    end

    def response
      http_response = connection.get(url)
      EtablissementResponse.new(http_response)
    end

    def url
      "https://api.apientreprise.fr/v2/etablissements/#{siret}?token=#{token}"
    end
  end
end
