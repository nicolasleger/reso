# frozen_string_literal: true

module ApiEntreprise
  class EtablissementWrapper
    attr_accessor :etablissement

    def initialize(data)
      @etablissement = Etablissement.new(data.fetch('etablissement'))
    end

    def headquarters_location
      @etablissement.location
    end
  end
end
