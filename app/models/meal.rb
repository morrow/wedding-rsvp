class Meal < ActiveRecord::Base
  belongs_to :image

  extend FriendlyId
  friendly_id :short_name, use: :slugged

  def to_s
    self.short_name
  end

end
