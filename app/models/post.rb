class Post < ApplicationRecord
    validates_presence_of :title
    has_rich_text :content

    has_many :comments
end
