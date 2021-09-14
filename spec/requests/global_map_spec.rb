# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GlobalMap', type: :request do
  describe 'GET /show' do
    let!(:user) { create(:user) }

    it 'renders a successful response' do
      sign_in user
      get global_map_path
      expect(response).to be_successful
    end

    it 'renders a global map page' do
      sign_in user
      get global_map_path
      expect(response).to render_template(:show)
    end
  end

  describe 'GET /users' do
    let!(:user) { create(:user) }

    it "includes user's id, name, username in JSON response",
       aggregate_failures: true do
      sign_in user
      get global_map_users_path, headers: { accept: 'application/json' }
      expect(JSON.parse(response.body).first).to have_key('id')
      expect(JSON.parse(response.body).first).to have_key('name')
      expect(JSON.parse(response.body).first).to have_key('username')
    end

    it "does not include user's email in JSON response" do
      sign_in user
      get global_map_users_path, headers: { accept: 'application/json' }
      expect(JSON.parse(response.body).first).not_to have_key('email')
    end
  end
end
