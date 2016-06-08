module AdminHelper

  require 'csv'

  def render_admin_guest_csv
    CSV.generate(:col_sep=>',', :quote_char => '"') do |csv| 
      columns = [:name, :meal, :invitation, :accessed, :completed, :accommodations, :ceremony, :first_name, :last_name, :id, :is_manual, :is_plus_one]
      csv << columns.collect { |c| c.to_s }
      Guest.find(:all).sort_by{ |x| [(x.accessed ? 0 : 1),x.invitation.key, x.last_name, x.first_name]}.each do |guest|
          csv << columns.collect { |c|  c.to_s.match(/accessed|completed|ceremony|reception|is_/) ? humanize(guest.send(c)) : guest.send(c) }
      end
    end.html_safe
  end

  def render_admin_invitation_csv
    CSV.generate(:col_sep=>',', :quote_char => '"') do |csv| 
      columns = [:id, :key, :name, :guest_names, :completed]
      csv << columns.collect { |c| c.to_s }
      Invitation.find(:all).sort_by{ |x| x.id }.each do |guest|
          csv << columns.collect { |c|  c.to_s.match(/completed/) ? humanize(guest.send(c)) : guest.send(c) }
      end
    end.html_safe
  end

end
