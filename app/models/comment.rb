class Comment < ApplicationRecord
  belongs_to :user

  scope :filter_by_phone_number, ->(phone_number) { where('phone_number LIKE ?', "%#{phone_number}%") }
  scope :filter_by_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  scope :filter_by_win, ->(win) { where(win: win) }
  scope :filter_by_created_at_start_at, lambda { |start_time|
    where("#{table_name}.created_at >= ?", Time.zone.parse(start_time))
  }
  scope :filter_by_created_at_end_at, lambda { |end_time|
    where("#{table_name}.created_at <= ?", Time.zone.parse(end_time))
  }

  validates :phone_number, format: { with: /\A09\d{8}\z/, message: '手機號碼格式錯誤' }
  validates :name, presence: true, length: { maximum: 20, message: '姓名長度過長'}
  validates :message, presence: true
end
