class Place < ApplicationRecord
  belongs_to :user

  validate :title_format, :description_format

  TEXT_REGEX = /\A[\wа-яА-ЯўІі,.:;?!()'\s"\[\]]+\z/.freeze

  validates :latitude, presence: true

  validates :longitude, presence: true

  validates :title, presence: true,
                    length: 2..50

  validates :description, presence: true,
                          length: 2..140

  private

    def title_format
      return if title.blank? || title =~ TEXT_REGEX

      errors.add :title, 'Please use alphabetical letters ' \
                         'or/with digits and punctuation'
    end

    def description_format
      return if description.blank? || description =~ TEXT_REGEX

      errors.add :description, 'Please use alphabetical letters ' \
                               'or/with digits and punctuation'
    end
end
