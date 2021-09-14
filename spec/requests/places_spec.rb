require 'rails_helper'

RSpec.describe 'Places', type: :request do
  describe 'POST /create' do
    context 'with valid attributes' do
      let!(:user) { create(:user) }
      let!(:place) { create(:place) }

      let(:valid_attributes) do
        {
          title: 'Interesting place',
          description: 'Place for spending time',
          latitude: 60,
          longitude: 30,
          user_id: user.id
        }
      end

      it 'adds place successfully' do
        sign_in user
        expect { user.places.create(valid_attributes) }
          .to change(Place, :count).by(1)
      end

      it 'response contains the right data', aggregate_failures: true do
        sign_in user
        post user_places_path(user_id: user.id),
             params: { place: valid_attributes }
        expect(response).to be_successful
        expect(response.body).to match(/Interesting/)
      end
    end

    context 'with not valid attributes' do
      let!(:user) { create(:user) }
      let!(:place) { create(:place) }

      let(:invalid_attributes) do
        {
          title: '',
          description: '@##$',
          latitude: 60,
          longitude: 30,
          user_id: user.id
        }
      end

      it 'does not add place' do
        sign_in user
        expect { user.places.create(invalid_attributes) }
          .not_to change(Place, :count)
      end

      it 'response contains errors data', aggregate_failures: true do
        sign_in user
        post user_places_path(user_id: user.id),
             params: { place: invalid_attributes }
        expect(response).to be_successful
        expect(response.body).to match(/error/)
      end
    end
  end

  describe 'PUT /update' do
    context 'with valid attributes' do
      let!(:user) { create(:user) }
      let!(:place) { user.places.create(attributes) }

      let(:attributes) do
        {
          title: 'Interesting place',
          description: 'Place for spending time',
          latitude: 60,
          longitude: 30,
          user_id: user.id
        }
      end

      let(:valid_edited_attributes) do
        {
          title: 'New place',
          description: 'Place for spending time',
          latitude: 60,
          longitude: 30,
          user_id: user.id
        }
      end

      it 'does not change places amount' do
        sign_in user
        expect do
          put user_place_path(user_id: user.id, id: place.id),
              params: { place: valid_edited_attributes }
        end.not_to change(Place, :count)
      end

      it 'response contains the right data', aggregate_failures: true do
        sign_in user
        put user_place_path(user_id: user.id, id: place.id),
            params: { place: valid_edited_attributes }
        expect(response).to be_successful
        expect(response.body).to match(/New/)
      end
    end

    context 'with not valid attributes' do
      let!(:user) { create(:user) }
      let!(:place) { user.places.create(attributes) }

      let(:attributes) do
        {
          title: 'Interesting place',
          description: 'Place for spending time',
          latitude: 60,
          longitude: 30,
          user_id: user.id
        }
      end

      let(:invalid_edited_attributes) do
        {
          title: '',
          description: '@##$',
          latitude: 60,
          longitude: 30,
          user_id: user.id
        }
      end

      it 'does not change places amount' do
        sign_in user
        expect do
          put user_place_path(user_id: user.id, id: place.id),
              params: { place: invalid_edited_attributes }
        end.not_to change(Place, :count)
      end

      it 'response contains errors data', aggregate_failures: true do
        sign_in user
        put user_place_path(user_id: user.id, id: place.id),
            params: { place: invalid_edited_attributes }
        expect(response).to be_successful
        expect(response.body).to match(/error/)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { create(:user) }
    let!(:place) { user.places.create(attributes) }

    let(:attributes) do
      {
        title: 'Interesting place',
        description: 'Place for spending time',
        latitude: 60,
        longitude: 30,
        user_id: user.id
      }
    end

    it 'deletes the place' do
      sign_in user
      expect do
        delete user_place_path(user_id: user.id, id: place.id)
      end.to change(Place, :count).by(-1)
    end

    it 'renders a successful response' do
      sign_in user
      delete user_place_path(user_id: user.id, id: place.id)
      expect(response).to be_successful
    end
  end
end
