# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'mailers/admin_mailer/weekly_statistics.html.haml', type: :view do
  context 'hash with several information' do
    let(:user) { create :user }
    let(:visit) { create :visit }

    before do
      information_hash = {
        signed_up_users: { count: 1, items: [user] },
        visits: [{ user: user, visits_count: 1 }],
        diagnoses: [{ visit: visit, diagnoses_count: 1 }],
        mailto_logs: [{ visit: visit, logs_count: 1 }]
      }

      assign(:information_hash, information_hash)
      render
    end

    it 'displays a title and 4 list elements' do
      expect(rendered).to include 'Bonjour, chers administrateurs !'
      assert_select 'li', count: 4
    end
  end

  context 'hash with few information' do
    before do
      information_hash = {
        signed_up_users: { count: 0, items: [] },
        visits: [],
        diagnoses: [],
        mailto_logs: []
      }

      assign(:information_hash, information_hash)
      render
    end

    it 'displays a title and no list element' do
      expect(rendered).to include 'Bonjour, chers administrateurs !'
      assert_select 'li', count: 0
    end
  end
end