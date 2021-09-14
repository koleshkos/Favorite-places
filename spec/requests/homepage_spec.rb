require 'rails_helper'

RSpec.describe 'Homepages', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'returns text' do
      get '/'
      expect(response.body.include?('FavoritePlaces')).to eq(true)
    end

    it 'renders landing page' do
      get '/'
      expect(response).to render_template(:index)
    end
  end
end
