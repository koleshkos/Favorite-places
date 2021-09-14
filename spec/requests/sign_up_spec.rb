# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'GET /new' do
    it 'renders user registration form' do
      get new_user_registration_path
      expect(response).to be_successful
    end

    it 'renders registration page' do
      get new_user_registration_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          username: 'user',
          name: 'User',
          email: 'user@example.com',
          sex: 'female',
          date_of_birth: DateTime.now,
          password: '$$RRrr33',
          password_confirmation: '$$RRrr33',
          confirmed_at: DateTime.now,
          confirmation_token: 'fjklLSyLDldwlwl#{rand(999)'
        }
      end

      it 'creates a new User' do
        expect do
          post user_registration_path, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the login page before email confirmation' do
        post user_registration_path, params: { user: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          username: '@#@$$',
          name: '@$@$@$',
          email: 'user@example.com',
          sex: '',
          date_of_birth: DateTime.now,
          password: '$$RR',
          password_confirmation: '$$',
          confirmed_at: DateTime.now,
          confirmation_token: 'fjklLSyLDldwlwl#{rand(999)'
        }
      end

      it 'does not create a new User' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it 'renders a successful response' do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response).to be_successful
      end

      it 'renders registration page' do
        get new_user_registration_path
        expect(response).to render_template(:new)
      end
    end
  end
end
