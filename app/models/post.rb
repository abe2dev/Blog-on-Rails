class Post < ApplicationRecord
    has_many :comments, dependent: :destroy
    
    validates :title, presence: true, uniqueness: true
    validates :body, presence: true, length: {minimum:50}
end 