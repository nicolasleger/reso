# frozen_string_literal: true

require 'rails_helper'

describe UserDailyChangeUpdateMailerService do
  before { ENV['APPLICATION_EMAIL'] = 'contact@mailrandom.fr' }

  describe 'send_daily_change_updates' do
    subject(:send_daily_change) { described_class.send_daily_change_updates }

    before do
      allow(UserMailer).to receive(:delay) { UserMailer }
      allow(UserMailer).to receive(:daily_change_update)
    end

    context 'one selected assistance modified during the last 24h' do
      let(:selected_assistance_expert1) { create :selected_assistance_expert }
      let(:selected_assistance_expert2) { create :selected_assistance_expert }
      let(:expected_array) do
        [
          {
            expert_name: selected_assistance_expert2.expert_full_name,
            expert_institution: selected_assistance_expert2.expert_institution_name,
            question_title: selected_assistance_expert2.diagnosed_need.question_label,
            company_name: selected_assistance_expert2.diagnosed_need.diagnosis.visit.facility.company.name_short,
            start_date: selected_assistance_expert2.created_at.to_date,
            old_status: 'quo',
            current_status: 'done'
          }
        ]
      end

      before do
        selected_assistance_expert1.update status: 'done'
        selected_assistance_expert1.update updated_at: 2.days.ago
        Audited::Audit.last.update created_at: 2.days.ago

        selected_assistance_expert2.update status: 'done'

        send_daily_change
      end

      it 'sends only one email' do
        user = selected_assistance_expert2.diagnosed_need.diagnosis.visit.advisor
        expect(UserMailer).to have_received(:daily_change_update).once.with(user, expected_array)
      end
    end

    context 'two selected assistances for the same user modified during the last 24h' do
      let(:visit) { create :visit }
      let(:diagnosis) { create :diagnosis, visit: visit }
      let(:diagnosed_need) { create :diagnosed_need, diagnosis: diagnosis }
      let(:selected_assistance_expert1) { create :selected_assistance_expert }
      let(:selected_assistance_expert2) { create :selected_assistance_expert, diagnosed_need: diagnosed_need }
      let(:selected_assistance_expert3) { create :selected_assistance_expert, diagnosed_need: diagnosed_need }
      let(:expected_array) do
        [
          {
            expert_name: selected_assistance_expert2.expert_full_name,
            expert_institution: selected_assistance_expert2.expert_institution_name,
            question_title: selected_assistance_expert2.diagnosed_need.question_label,
            company_name: selected_assistance_expert2.diagnosed_need.diagnosis.visit.facility.company.name_short,
            start_date: selected_assistance_expert2.created_at.to_date,
            old_status: 'quo',
            current_status: 'done'
          },
          {
            expert_name: selected_assistance_expert3.expert_full_name,
            expert_institution: selected_assistance_expert3.expert_institution_name,
            question_title: selected_assistance_expert2.diagnosed_need.question_label,
            company_name: selected_assistance_expert2.diagnosed_need.diagnosis.visit.facility.company.name_short,
            start_date: selected_assistance_expert3.created_at.to_date,
            old_status: 'quo',
            current_status: 'done'
          }
        ]
      end

      before do
        selected_assistance_expert1.update status: 'done'
        selected_assistance_expert1.update updated_at: 2.days.ago
        Audited::Audit.last.update created_at: 2.days.ago

        selected_assistance_expert2.update status: 'done'
        selected_assistance_expert3.update status: 'done'

        send_daily_change
      end

      it 'sends only one email' do
        user = selected_assistance_expert2.diagnosed_need.diagnosis.visit.advisor
        expect(UserMailer).to have_received(:daily_change_update).once.with(user, expected_array)
      end
    end

    context 'one selected assistance modified during the last 24h but no status update' do
      let(:selected_assistance_expert) { create :selected_assistance_expert }

      before do
        selected_assistance_expert.update status: 'done'
        selected_assistance_expert.update updated_at: 2.days.ago
        Audited::Audit.last.update created_at: 2.days.ago
        selected_assistance_expert.update status: 'quo'
        selected_assistance_expert.update status: 'done'

        send_daily_change
      end

      it 'sends no email' do
        expect(UserMailer).not_to have_received(:daily_change_update)
      end
    end
  end
end
