require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'associations' do
    subject(:place) { described_class.new(params) }

    let(:params) do
      {}
    end

    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject(:place) { described_class.new(params) }

    let(:params) do
      {}
    end

    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }

    it 'validates :title length' do
      expect(place).to validate_length_of(:title)
        .is_at_least(2)
        .is_at_most(50)
    end

    it 'validates :description length' do
      expect(place).to validate_length_of(:description)
        .is_at_least(2)
        .is_at_most(140)
    end
  end

  describe '#title_format' do
    subject { -> { place.send(:title_format) } }

    let(:place) { create(:place) }

    context 'when :title is not valid' do
      let(:expected_error_message) do
        'Please use alphabetical letters ' \
          'or/with digits and punctuation'
      end

      before do
        place.title = '$$@$$@33'
      end

      it { is_expected.to change { place.errors.count }.by(1) }

      it 'adds custom error message to errors' do
        expect { place.send(:title_format) }
          .to change { place.errors.messages[:title] }
          .by([expected_error_message])
      end
    end

    context 'when :title is valid' do
      before do
        place.title = 'Interesting place?!'
      end

      it { is_expected.not_to change { place.errors.count } }
    end

    context 'when :title is blank' do
      before do
        place.title = ''
      end

      it { is_expected.not_to change { place.errors.count } }
    end
  end

  describe '#description_format' do
    subject { -> { place.send(:description_format) } }

    let(:place) { create(:place) }

    context 'when :description is not valid' do
      let(:expected_error_message) do
        'Please use alphabetical letters ' \
          'or/with digits and punctuation'
      end

      before do
        place.description = '$$@$$@33'
      end

      it { is_expected.to change { place.errors.count }.by(1) }

      it 'adds custom error message to errors' do
        expect { place.send(:description_format) }
          .to change { place.errors.messages[:description] }
          .by([expected_error_message])
      end
    end

    context 'when :description is valid' do
      before do
        place.description = 'Place where I like spend time.'
      end

      it { is_expected.not_to change { place.errors.count } }
    end

    context 'when :description is blank' do
      before do
        place.description = ''
      end

      it { is_expected.not_to change { place.errors.count } }
    end
  end
end
