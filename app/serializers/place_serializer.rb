class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :longitude, :latitude

  belongs_to :user
end
