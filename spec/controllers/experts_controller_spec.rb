# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpertsController, type: :controller do
  describe 'GET #diagnosis' do
    subject(:request) { get :diagnosis, params: { diagnosis_id: diagnosis.id, access_token: access_token } }

    let(:diagnosis) { create :diagnosis }

    context 'access token is empty' do
      let(:access_token) { nil }

      it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'access token exists' do
      let(:access_token) { expert.access_token }
      let(:expert) { create :expert }

      let(:assistance_expert) { create :assistance_expert, expert: expert }
      let(:diagnosed_need) { create :diagnosed_need, diagnosis: diagnosis }

      before do
        allow(UseCases::UpdateExpertViewedPageAt).to receive(:perform).with(
          diagnosis_id: diagnosis.id,
          expert_id: expert.id
        )
      end

      context 'expert has access to diagnosis' do
        before do
          create :selected_assistance_expert, assistance_expert: assistance_expert, diagnosed_need: diagnosed_need
          request
        end

        it('returns http success') { expect(response).to have_http_status(:success) }
      end

      context 'safe deleted diagnosis' do
        before do
          diagnosis.destroy

          create :selected_assistance_expert, assistance_expert: assistance_expert, diagnosed_need: diagnosed_need
          request
        end

        it('returns http success') { expect(response).to have_http_status(:success) }
      end

      context 'expert does not have access to diagnosis' do
        it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
      end
    end
  end

  describe 'PATCH #update_status' do
    subject(:request) { patch :update_status, xhr: true, params: params }

    let(:params) { { selected_assistance_expert_id: selected_assistance_expert_id, access_token: access_token } }

    let(:access_token) { expert.access_token }
    let(:expert) { create :expert }

    let(:selected_assistance_expert_id) { selected_assistance_expert.id }
    let(:selected_assistance_expert) { create :selected_assistance_expert, :with_assistance_expert }

    context 'access token is empty' do
      let(:access_token) { nil }

      it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'selected assistance expert does not exist' do
      let(:selected_assistance_expert_id) { nil }

      it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'selected assistance expert is not available to expert' do
      it('raises error') { expect { request }.to raise_error ActiveRecord::RecordNotFound }
    end

    context 'selected assistance expert exists' do
      let(:assistance_expert) { create :assistance_expert, expert: expert }

      before { selected_assistance_expert.update assistance_expert: assistance_expert }

      context 'with status quo' do
        it 'returns http success' do
          params[:status] = :quo
          request

          expect(response).to have_http_status(:success)
          expect(selected_assistance_expert.reload.status_quo?).to eq true
        end
      end

      context 'with status taking_care' do
        it 'returns http success' do
          params[:status] = :taking_care
          request

          expect(response).to have_http_status(:success)
          expect(selected_assistance_expert.reload.status_taking_care?).to eq true
        end
      end
    end
  end
end
