# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /show' do
    let!(:user) { FactoryBot.create(:user) }

    it 'renders a successful response' do
      sign_in user
      get user_path(user)
      expect(response).to be_successful
    end

    it 'renders a user main page' do
      sign_in user
      get user_path(user)
      expect(response).to render_template(:show)
    end
  end
end
