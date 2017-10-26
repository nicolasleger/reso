# frozen_string_literal: true

module ApiEntreprise
  class EntrepriseResponse < Response
    DEFAULT_ERROR_MESSAGE = 'There was an error retrieving entreprise details.'

    def entreprise_wrapper
      EntrepriseWrapper.new(data)
    end
  end
end
