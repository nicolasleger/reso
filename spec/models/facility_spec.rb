# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facility, type: :model do
  describe 'validations' do
    it do
      is_expected.to belong_to :company
      is_expected.to validate_presence_of :company
      is_expected.to validate_presence_of :siret
      is_expected.to validate_presence_of :city_code
    end
  end

  describe 'scopes' do
    describe 'in_territory' do
      subject { Facility.in_territory territory }

      let(:territory) { create :territory }
      let!(:facility) { create :facility, city_code: 59_001 }

      context 'with territory cities' do
        before { create :territory_city, territory: territory, city_code: 59_001 }

        it { is_expected.to eq [facility] }
      end

      context 'without territory city' do
        it { is_expected.to eq [] }
      end
    end
  end

  describe 'to_s' do
    subject { facility.to_s }

    let(:facility) { create :facility, city_code: 59_001, company: company }
    let(:company) { create :company, name: 'Mc Donalds' }

    it { is_expected.to eq 'Mc Donalds (59001)' }
  end
end
