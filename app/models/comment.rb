class Comment < ApplicationRecord
  belongs_to :user
  validates :name, :message, presence: true
end
