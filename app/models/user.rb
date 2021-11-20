class User < ApplicationRecord
  has_secure_password
  has_one_attached :picture, dependent: :destroy
  has_many :comments
  before_save :set_filename

  enum tier: { trial: 0, silver: 1, gold: 2, platinum: 3}

  scope :with_picture, -> {
    left_joins(:picture_attachment).where.not(active_storage_attachments: {id: nil})
  }

  validates :picture, size: { less_than: 1.megabytes, message: '檔案大小建議1MB以內，不然來賓會載太久看不到圖' },
            content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/webp']
  validates :bride, presence: true, length: { in: 1..10, message: '長度為1-10位'}
  validates :bridegroom, presence: true, length: { in: 1..10, message: '長度為1-10位'}
  validates :username, presence: true, uniqueness: { case_sensitive: true, message: '該帳號已有人使用' },
                       length: { in: 4..20, message: '長度為4-20位' },
                       format: { with: /\w+/, message: '僅可輸入英文、數字及下底線' }
  validates :password, presence: true, on: :create

  private

  def set_filename
    return unless self.picture.attached?
    original_filename = self.picture.filename
    original_key = self.picture.key
    self.picture.update(
      filename: "#{self.username}/pictures/#{original_filename}",
      key: "#{self.username}/pictures/#{original_key}")
  end
end
