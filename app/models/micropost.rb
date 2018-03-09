class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  scope :post_feed, ->(following_ids, id){where "user_id IN (?) OR user_id = ?", following_ids, id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_content}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.micropost.max_size.megabytes
      errors.add :picture, I18n.t("microposts.micropost.val_picture")
    end
  end
end
