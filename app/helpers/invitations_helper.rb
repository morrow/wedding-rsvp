module InvitationsHelper

  def guests_attending(invitation, event)
    count = 0
    invitation.guests.each do |guest|
      if event == :unresponded
        count += ((guest.ceremony == nil and guest.reception == nil) ? 1 : 0)
      else
        count += (guest.send(event.to_sym) ? 1 : 0)
      end
    end
    return count
  end

end
