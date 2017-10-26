# frozen_string_literal: true

module Api
  class FacilitiesController < ApplicationController
    def search_by_siret
      facility = UseCases::SearchFacility.with_siret params[:siret]
      company = UseCases::SearchCompany.with_siret params[:siret]
      render json: { company_name: company.name, facility_location: facility.etablissement.location }
    rescue ApiEntreprise::Errors::NotFoundError
      render body: nil
    rescue ApiEntreprise::Errors::ServerError
      render json: { error: api_entreprise_error_hash }, status: :service_unavailable
    end

    def search_by_siren
      company = UseCases::SearchCompany.with_siren params[:siren]
      render json: {
        company_name: company.name,
        facility_location: company.etablissement_siege.location,
        siret: company.etablissement_siege.siret
      }
    rescue ApiEntreprise::Errors::NotFoundError
      render body: nil
    rescue ApiEntreprise::Errors::ServerError
      render json: { error: api_entreprise_error_hash }, status: :service_unavailable
    end

    private

    def api_entreprise_error_hash
      { key: :api_entreprise_fail, message: 'Problem with API Enterprise, please contact tech@apientreprise.fr.' }
    end
  end
end
