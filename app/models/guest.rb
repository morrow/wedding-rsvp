require 'ap'
class Guest < ActiveRecord::Base
 
  attr_accessible :accessed, 
                  :accommodations, 
                  :ceremony, 
                  :first_name, 
                  :id,      
                  :invitation,
                  :invitation_id, 
                  :is_plus_one, 
                  :last_name, 
                  :meal_id, 
                  :name, 
                  :reception

  belongs_to :invitation
  belongs_to :meal

  before_save :update_name
  after_save :update_meal_count

  extend FriendlyId
  friendly_id :name, use: :slugged

  def to_s
    self.name
  end

  def to_html
  end

  def normalize_friendly_id(string)
    self.name.gsub(/'|,|\./, '').gsub(" ", '-').downcase
  end

  def update_meal_count
    Meal.find_each do |meal|
      meal.count = Guest.where({:meal_id => meal.id}).length
      meal.save
    end
  end
  
  def update_name
    self.name = "#{self.first_name} #{self.last_name}"
  end

  def accessed 
    not (self.ceremony == self.reception and self.reception == self.meal and self.meal == nil)
  end

  def completed
    self.ceremony != nil and self.reception != nil and (self.reception and self.meal != nil or not self.reception)
  end

  def reset
    self.ceremony = nil
    self.reception = nil
    self.meal = nil
    self.accommodations = nil
  end

end
