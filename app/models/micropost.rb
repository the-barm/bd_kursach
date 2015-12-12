class Micropost
  require 'carrierwave/orm/mongomapper'
  include MongoMapper::Document
  key :user_id, Integer, required: true
  key :content, String
  timestamps!
  #default_scope -> { order(created_at: :desc) }
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  def user
    User.find(user_id)
  end

 
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end