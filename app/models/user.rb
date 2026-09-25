class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  attr_accessor :avatar_file

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true,
            format: { with: /\A\w+\z/ }, length: { in: 3..20 }
  validates :display_name, :bio, length: { maximum: 500 }, allow_blank: true
  validate  :avatar_size

  before_save :encode_avatar, if: -> { avatar_file.present? }

  # Rails magic: URLs use username instead of id
  def to_param = username

  def name = display_name.presence || username
  def initial = name.first.upcase

  private

  def encode_avatar
    file = avatar_file
    self.avatar_data = "data:#{file.content_type};base64,#{Base64.strict_encode64(file.read)}"
  end

  def avatar_size
    errors.add(:avatar_file, "must be < 500KB") if avatar_file&.size.to_i > 500.kilobytes
  end

end
