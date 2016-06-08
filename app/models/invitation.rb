class Invitation < ActiveRecord::Base

  attr_accessible :id, 
                  :key,                  
                  :name, 
                  :number_of_guests, 
                  :wedding_party

  belongs_to :category
  has_many :guests

  extend FriendlyId
  friendly_id :key, use: :slugged

  before_create :generateKey
  after_save :updateGuestNumber

  def normalize_friendly_id(string)
    super.upcase
  end

  def to_s
    self.key
  end

  def guest_names
    self.guests.collect { |x| x.name }.join ", "
  end

  def updateGuestNumber
    puts "current number of guests #{self.number_of_guests}"
    self.number_of_guests = Guest.where(:invitation_id => self.id).length
    puts "new number of guests #{self.number_of_guests}"
  end

  def generateKey
    # read profanity file from home directory
    profanity = File.open(File.expand_path("~/profanity-list.txt"), "r").read
    # split words into array by new line
    profanity = profanity.split("\r\n")
    # delete words that are longer than 6 characters, or contain non letters
    profanity.delete_if { |x| x.length > 6 or not x.upcase.match /[A-Z]/ or x.upcase.scan(/[A-Z]/).length != x.length }
    # capitalize words in array
    profanity = profanity.collect! { |x| x.upcase }
    # get existing Invitation keys
    keys = Invitation.select([:key]).collect {|x|x.key}
    # generate new key
    key = (0...6).map{65.+(rand(25)).chr}.join
    # generate new key if key exists in list of Invitation keys or contains profanity
    if keys.include?(key) or profanity.include?(key) or key.match(Regexp.new profanity.join("|"))
      key = generateKey
    else
      self.key = key
    end
  end

  def accessed 
    bool = false
    self.guests.each do |guest|
      if guest.accessed
        bool = true
      end
    end
    return bool
  end

  def completed
    bool = true
    self.guests.each do |guest|
      if not guest.completed
        bool = false
      end
    end
    return bool
  end

end
