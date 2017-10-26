# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::FacilitiesController, type: :controller do
  login_user

  describe 'POST #search_by_siret' do
    let(:siret) { '12345678901234' }

    context 'when facility is found' do
      before do
        company_json = JSON.parse(File.read(Rails.root.join('spec/fixtures/api_entreprise_get_entreprise.json')))
        entreprises_instance = ApiEntreprise::EntrepriseWrapper.new(company_json)
        allow(UseCases::SearchCompany).to receive(:with_siret).with(siret) { entreprises_instance }

        facility_json = JSON.parse(File.read(Rails.root.join('spec/fixtures/api_entreprise_get_etablissement.json')))
        facility_instance = ApiEntreprise::EtablissementWrapper.new(facility_json)
        allow(UseCases::SearchFacility).to receive(:with_siret).with(siret) { facility_instance }
      end

      it 'returns http success' do
        post :search_by_siret, params: { siret: siret }, format: :js

        expect(response).to have_http_status(:success)
        expect(response.body).to eq({ company_name: 'Octo Technology', facility_location: '75008 Paris 8' }.to_json)
      end
    end

    context 'when facility is not found' do
      before do
        allow(UseCases::SearchFacility).to receive(:with_siret).with(siret)
                                                               .and_raise ApiEntreprise::Errors::NotFoundError

        post :search_by_siret, params: { siret: siret }, format: :js
      end

      it 'returns empty body' do
        expect(response).to have_http_status(:success)
        expect(response.body).to be_blank
      end
    end

    context 'when API Entreprise server is down' do
      before do
        allow(UseCases::SearchFacility).to receive(:with_siret).with(siret)
                                                               .and_raise ApiEntreprise::Errors::ServerError

        post :search_by_siret, params: { siret: siret }, format: :js
      end

      it 'returns service unavailable' do
        expect(response).to have_http_status(:service_unavailable)
        expect(JSON.parse(response.body)['error']['key']).to eq 'api_entreprise_fail'
      end
    end
  end

  describe 'POST #search_by_siren' do
    let(:siren) { '418166096' }

    context 'when company is found' do
      before do
        company_json = JSON.parse(File.read(Rails.root.join('spec/fixtures/api_entreprise_get_entreprise.json')))
        entreprises_instance = ApiEntreprise::EntrepriseWrapper.new(company_json)
        allow(UseCases::SearchCompany).to receive(:with_siren).with(siren) { entreprises_instance }

        post :search_by_siren, params: { siren: siren }, format: :js
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(
          { company_name: 'Octo Technology', facility_location: '75108 Paris 8', siret: '41816609600051' }.to_json
        )
      end
    end

    context 'when company is not found' do
      before do
        allow(UseCases::SearchCompany).to receive(:with_siren).with(siren)
                                                              .and_raise ApiEntreprise::Errors::NotFoundError

        post :search_by_siren, params: { siren: siren }, format: :js
      end

      it 'returns empty body' do
        expect(response).to have_http_status(:success)
        expect(response.body).to be_blank
      end
    end

    context 'when API Entreprise server is down' do
      before do
        allow(UseCases::SearchCompany).to receive(:with_siren).with(siren).and_raise ApiEntreprise::Errors::ServerError

        post :search_by_siren, params: { siren: siren }, format: :js
      end

      it 'returns service unavailable' do
        expect(response).to have_http_status(:service_unavailable)
        expect(JSON.parse(response.body)['error']['key']).to eq 'api_entreprise_fail'
      end
    end
  end
end
