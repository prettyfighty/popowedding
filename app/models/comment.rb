class Comment < ApplicationRecord
  has_one_attached :picture, dependent: :destroy
  belongs_to :user
  after_create :set_filename

  scope :with_picture, -> {
    left_joins(:picture_attachment).where.not(active_storage_attachments: {id: nil})
  }
  scope :filter_by_phone_number, ->(phone_number) { where('phone_number LIKE ?', "%#{phone_number}%") }
  scope :filter_by_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  scope :filter_by_win, ->(win) { where(win: win) }
  scope :filter_by_created_at_start_at, lambda { |start_time|
    where("#{table_name}.created_at >= ?", Time.zone.parse(start_time))
  }
  scope :filter_by_created_at_end_at, lambda { |end_time|
    where("#{table_name}.created_at <= ?", Time.zone.parse(end_time))
  }

  validates :picture, attached: true, size: { less_than: 3.megabytes, message: '檔案大小不得超過3MB，上傳時請在手機上點選上傳檔案的大小(ios手機點擊\'實際大小\'的地方可以選擇檔案大小)' },
            content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/webp']
  validates :phone_number, format: { with: /\A09\d{8}\z/, message: '格式錯誤' }
  validates :name, presence: true, length: { maximum: 20, message: '長度過長'}
  validates :message, presence: true

  def mask(phone_number)
    masked = self.phone_number
    masked[4..6] = '***'
    masked
  end

  private

  def set_filename
    return unless self.picture.attached?
    original_filename = self.picture.filename
    original_key = self.picture.key
    self.picture.update(
      filename: "#{self.user.username}/blessings/#{self.phone_number}/#{original_filename}",
      key: "#{self.user.username}/blessings/#{self.phone_number}/#{original_key}")
  end
end
