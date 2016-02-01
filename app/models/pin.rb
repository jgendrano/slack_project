class Pin < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true, length: { maximum: 30 }
  # acts_as_taggable
end
