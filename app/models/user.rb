class User < ApplicationRecord
  has_secure_password
  has_one_attached :picture, dependent: :destroy
  has_many :comments

  scope :with_picture, -> {
    left_joins(:picture_attachment).where.not(active_storage_attachments: {id: nil})
  }

  validates :bride, presence: true, length: { in: 1..10, message: '長度為1-10位'}
  validates :bridegroom, presence: true, length: { in: 1..10, message: '長度為1-10位'}
  validates :username, presence: true, uniqueness: { case_sensitive: true, message: '該帳號已有人使用' },
                       length: { in: 4..20, message: '長度為4-20位' },
                       format: { with: /\w+/, message: '僅可輸入英文、數字及下底線' }
  validates :password, presence: true, on: :create
end
