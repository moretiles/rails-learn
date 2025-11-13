class Comment < ApplicationRecord
  belongs_to :product
  has_rich_text :body

  validates :body, presence: true
end
