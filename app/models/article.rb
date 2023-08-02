class Article < ApplicationRecord
    belongs_to :author
    has_and_belongs_to_many :categories
  # Add validations as needed
    validates :title, presence: true
    validates :content, presence: true
    validates :author, presence: true
end
