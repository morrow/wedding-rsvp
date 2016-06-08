module GuestsHelper

  def humanize(input, mode=:default)
    modes = {
      :default => ["yes", "no", ""],
      :attendance => ["Attending", "NOT Attending"],
    }
    index = if input.class == TrueClass then 0 elsif input.class == FalseClass then 1 else 2 end
    modes[mode][index] ? modes[mode][index] : modes[:default][index]
  end

  def plus_one_host_name guest
    if guest.class == Guest
      g = guest.invitation.guests.where(:is_plus_one => nil)[0]
    elsif guest.class == Invitation
      g= guest.guests.where(:is_plus_one => nil)[0]
    end
    g.name if g
  end

  def plus_one_name
    self.invitation.guests.where(:is_plus_one => true)[0].name
  end

end