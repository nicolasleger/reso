# frozen_string_literal: true

module ApiEntreprise
  class EtablissementResponse < Response
    DEFAULT_ERROR_MESSAGE = 'There was an error retrieving etablissement details.'

    def etablissement_wrapper
      EtablissementWrapper.new(data)
    end
  end
end
