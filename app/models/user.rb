class User < ApplicationRecord
  has_many :places, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  validate :password_complexity, :username_format, :name_format, :sex_format
  before_save :downcase_sex_fields

  USERNAME_REGEX = /\A[a-zA-Z0-9а-яА-ЯўІі]+\z/.freeze
  PASSWORD_REGEX = /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
                   .freeze
  SEX_REGEX = /\A([mM]ale|[fF]emale)\z/.freeze

  validates :username, presence: true,
                       length: 2..25

  validates :name, presence: true,
                   length: 2..25

  validates :email, presence: true,
                    length: { maximum: 105 }

  validates :sex, presence: true

  validates :date_of_birth, presence: true

  private

    def username_format
      return if username.blank? || username =~ USERNAME_REGEX

      errors.add :username, 'Please use alphabetical letters ' \
                            'or/with digits'
    end

    def name_format
      return if name.blank? || name =~ USERNAME_REGEX

      errors.add :name, 'Please use alphabetical letters ' \
                        'or/with digits'
    end

    def sex_format
      return if sex.blank? || sex =~ SEX_REGEX

      errors.add :sex, 'Please select "male" or "female"'
    end

    def password_complexity
      return if password.blank? || password =~ PASSWORD_REGEX

      errors.add :password, 'Complexity requirement not met. ' \
                            'Please use: 1 uppercase, 1 lowercase, ' \
                            '1 digit and 1 special character'
    end

    def downcase_sex_fields
      sex.downcase!
    end
end
