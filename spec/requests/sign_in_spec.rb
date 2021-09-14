# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users/sign_in', type: :request do
  it 'renders a successful response for sign_in page' do
    get '/users/sign_in'
    expect(response).to be_successful
  end

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

    let!(:user) { User.create! valid_attributes }

    it 'logs in successfully' do
      post '/users/sign_in', params: { user: { email: 'user@example.com',
                                               password: '$$RRrr33' } }
      follow_redirect!
      expect(response.body).to include 'Signed in successfully'
    end

    it 'renders the user showpage' do
      post '/users/sign_in', params: { user: { email: 'user@example.com',
                                               password: '$$RRrr33' } }
      follow_redirect!
      expect(response).to render_template 'users/show'
    end
  end

  context 'with invalid parameters' do
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

    let!(:user) { User.create! valid_attributes }

    it 'remains on the sign in page' do
      post '/users/sign_in', params: { user: { email: 'user@example.com',
                                               password: '$$RRrr32' } }
      expect(response.body).to include 'Invalid Email or password.'
    end
  end
end
