# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TerritoryUsersController, type: :controller do
  login_user

  describe 'GET #diagnoses' do
    let(:diagnosis) { create :diagnosis }

    before { get :diagnoses }

    context 'current user is not territory user' do
      it { expect(response).to have_http_status(:success) }
    end

    context 'current user is a territory user' do
      before { create :territory_user, user: current_user }

      it { expect(response).to have_http_status(:success) }
    end
  end

  describe 'GET #diagnosis' do
    subject(:request) { get :diagnosis, params: { diagnosis_id: diagnosis.id } }

    let(:diagnosis) { create :diagnosis, visit: visit }
    let(:visit) { create :visit, facility: facility }
    let(:facility) { create :facility }

    context 'current user is not territory user' do
      it('raises error') { expect { request }.to raise_error ActionController::RoutingError }
    end

    context 'current user is a territory user' do
      let!(:territory_user) { create :territory_user, user: current_user }

      context 'user is not responsible of diagnosis territory' do
        it('raises error') { expect { request }.to raise_error ActionController::RoutingError }
      end

      context 'user is responsible of diagnosis territory' do
        before do
          create :territory_city, territory: territory_user.territory, city_code: facility.city_code
          request
        end

        it('returns http success') { expect(response).to have_http_status(:success) }
      end

      context 'safe deleted diagnosis' do
        before do
          diagnosis.destroy

          create :territory_city, territory: territory_user.territory, city_code: facility.city_code
          request
        end

        it('returns http success') { expect(response).to have_http_status(:success) }
      end
    end
  end

  describe 'PATCH #update_status' do
    subject(:request) { patch :update_status, xhr: true, params: params }

    let(:params) { { selected_assistance_expert_id: selected_assistance_expert_id } }

    let(:selected_assistance_expert_id) { selected_assistance_expert.id }
    let(:selected_assistance_expert) do
      create :selected_assistance_expert, :with_territory_user, diagnosed_need: diagnosed_need
    end

    let(:diagnosed_need) { create :diagnosed_need, diagnosis: diagnosis }
    let(:diagnosis) { create :diagnosis, visit: visit }
    let(:visit) { create :visit, facility: facility }
    let(:facility) { create :facility }

    context 'current user is not territory user' do
      it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'current user is a territory user' do
      let!(:territory_user) { create :territory_user, user: current_user }

      context 'selected assistance expert does not exist' do
        let(:selected_assistance_expert_id) { nil }

        it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
      end

      context 'selected assistance expert is not available to expert' do
        it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
      end

      context 'with status quo' do
        before do
          selected_assistance_expert.update territory_user: territory_user
          create :territory_city, territory: territory_user.territory, city_code: facility.city_code
          params[:status] = :quo
          request
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
          expect(selected_assistance_expert.reload.status_quo?).to eq true
        end
      end

      context 'with status taking_care' do
        before do
          selected_assistance_expert.update territory_user: territory_user
          create :territory_city, territory: territory_user.territory, city_code: facility.city_code
          params[:status] = :taking_care
          request
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
          expect(selected_assistance_expert.reload.status_taking_care?).to eq true
        end
      end
    end
  end
end
