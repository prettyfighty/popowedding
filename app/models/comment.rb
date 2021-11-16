class Comment < ApplicationRecord
  belongs_to :user

  # ransacker :created_at , type: :date do
  #   Arel.sql('date(created_at)')
  # end

  validates :phone_number, format: { with: /\A09\d{8}\z/, message: '手機號碼格式錯誤' }
  validates :name, presence: true, length: { maximum: 20, message: '姓名長度過長'}
  validates :message, presence: true
end
