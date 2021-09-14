require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject(:user) { described_class.new(params) }

    let(:params) do
      {}
    end

    it { is_expected.to have_many(:places) }
  end

  describe 'validations' do
    subject(:user) { described_class.new(params) }

    let(:params) do
      {}
    end

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:sex) }
    it { is_expected.to validate_presence_of(:date_of_birth) }

    it 'validates :username length' do
      expect(user).to validate_length_of(:username)
        .is_at_least(2)
        .is_at_most(25)
    end

    it 'validates :name length' do
      expect(user).to validate_length_of(:name)
        .is_at_least(2)
        .is_at_most(25)
    end

    it { is_expected.to validate_length_of(:email).is_at_most(105) }
  end

  describe 'model index in db' do
    subject(:user) { described_class.new(params) }

    let(:params) do
      {}
    end

    it { is_expected.to have_db_index(:email).unique }
  end

  describe '#username_format' do
    subject { -> { user.send(:username_format) } }

    let(:params) do
      {}
    end

    let(:user) { described_class.new(params) }

    context 'when :username is not valid' do
      let(:expected_error_message) do
        'Please use alphabetical letters ' \
          'or/with digits'
      end

      before do
        user.username = '$$@$$@33'
      end

      it { is_expected.to change { user.errors.count }.by(1) }

      it 'adds custom error message to errors' do
        expect { user.send(:username_format) }
          .to change { user.errors.messages[:username] }
          .by([expected_error_message])
      end
    end

    context 'when :username is valid' do
      before do
        user.username = 'Username'
      end

      it { is_expected.not_to change { user.errors.count } }
    end

    context 'when :username is blank' do
      before do
        user.username = ''
      end

      it { is_expected.not_to change { user.errors.count } }
    end
  end

  describe '#downcase_sex_fields' do
    subject { user.send(:downcase_sex_fields) }

    let(:params) do
      {}
    end

    let(:user) { described_class.new(params) }

    context 'when :sex field is "Male"' do
      before do
        user.sex = 'Male'
      end

      it { is_expected.to eq('male') }
    end
  end

  describe '#name_format' do
    subject { -> { user.send(:name_format) } }

    let(:params) do
      {}
    end

    let(:user) { described_class.new(params) }

    context 'when :name is not valid' do
      let(:expected_error_message) do
        'Please use alphabetical letters ' \
          'or/with digits'
      end

      before do
        user.name = '$$@$$@33'
      end

      it { is_expected.to change { user.errors.count }.by(1) }

      it 'adds custom error message to errors' do
        expect { user.send(:name_format) }
          .to change { user.errors.messages[:name] }
          .by([expected_error_message])
      end
    end

    context 'when :name is valid' do
      before do
        user.name = 'Name'
      end

      it { is_expected.not_to change { user.errors.count } }
    end

    context 'when :name is blank' do
      before do
        user.name = ''
      end

      it { is_expected.not_to change { user.errors.count } }
    end
  end

  describe '#sex_format' do
    subject { -> { user.send(:sex_format) } }

    let(:params) do
      {}
    end

    let(:user) { described_class.new(params) }

    context 'when :sex is not valid' do
      let(:expected_error_message) do
        'Please select "male" or "female"'
      end

      before do
        user.sex = '$$@$$@33'
      end

      it { is_expected.to change { user.errors.count }.by(1) }

      it 'adds custom error message to errors' do
        expect { user.send(:sex_format) }
          .to change { user.errors.messages[:sex] }
          .by([expected_error_message])
      end
    end

    context 'when :sex is valid and in lower case' do
      before do
        user.sex = 'female'
      end

      it { is_expected.not_to change { user.errors.count } }
    end

    context 'when :sex is valid and in upper case' do
      before do
        user.sex = 'Female'
      end

      it { is_expected.not_to change { user.errors.count } }
    end

    context 'when :sex is blank' do
      before do
        user.sex = ''
      end

      it { is_expected.not_to change { user.errors.count } }
    end
  end

  describe '#password_complexity' do
    subject { -> { user.send(:password_complexity) } }

    let(:params) do
      {}
    end

    let(:user) { described_class.new(params) }

    context 'when :password is valid' do
      before do
        user.password = '$$RRrr33'
      end

      it { is_expected.not_to change { user.errors.count } }
    end

    context 'when :password is blank' do
      before do
        user.password = ''
      end

      it { is_expected.not_to change { user.errors.count } }
    end

    context 'when :password is not valid' do
      let(:expected_error_message) do
        'Complexity requirement not met. ' \
          'Please use: 1 uppercase, 1 lowercase, ' \
          '1 digit and 1 special character'
      end

      before do
        user.password = '$$RR3'
      end

      it { is_expected.to change { user.errors.count }.by(1) }

      it 'adds custom error message to errors' do
        expect { user.send(:password_complexity) }
          .to change { user.errors.messages[:password] }
          .by([expected_error_message])
      end
    end
  end
end
