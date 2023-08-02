class Author < ApplicationRecord
    has_secure_password
    has_many :articles
    # Add validations as needed
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
end
