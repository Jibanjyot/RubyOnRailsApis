class Article < ApplicationRecord
    belongs_to :author

  # Add validations as needed
    validates :title, presence: true
    validates :content, presence: true
    validates :author, presence: true
end
