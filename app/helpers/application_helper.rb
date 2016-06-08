module ApplicationHelper

  include Rails.application.routes.url_helpers

  def page_name
    return [params[:controller], params[:action]].join("_")
  end

  def cancel_link
    return link_to 'Cancel', request.env["HTTP_REFERER"], 
      :class => 'cancel'
  end

  def apostrophe
    return "<span class='apostrophe'>&#8217;</span>".html_safe
  end

  def rsvp_deadline
    begin
      admin = Admin.first
      return admin.global_lock_date.strftime("%B %e, 2012")
    rescue
      return "June 4th, 2012"
    end
  end

  def rsvp_is_close_to_lock
    return false if deadline_is_passed
    deadline_is_passed Time.now.to_i + 5 * 24 * 60 * 60
  end

  def rsvp_is_locked
    begin
      admin = Admin.first
      if admin.global_lock != nil
        return admin.global_lock
      elsif deadline_is_passed
        true
      else
        return false
      end
    rescue
      false
    end
  end

  def deadline_is_passed(time=nil)
    admin = Admin.first
    time ||= Time.now
    time = time.to_i
    deadline = admin.global_lock_date.to_i
    begin
      return time > deadline
    rescue
      false
    end
  end

  def time_until_deadline
    return 'Deadline passed.' if deadline_is_passed
    admin = Admin.first
    deadline = admin.global_lock_date
    return distance_of_time_in_words deadline.to_i, Time.now.to_i
  end

  def total column, mode=true
    if %w(chicken steak salmon ravioli).include?(column.to_s)
      return Meal.find(column.to_s).count
    elsif %w(ceremony reception).include?(column.to_s)
      return Guest.where({column => mode}).length
    elsif %w(accessed completed).include?(column.to_s)
      count = 0
      Guest.find_each do |guest|
        if not mode and not guest.send column.to_sym
          count += 1 
        elsif mode and guest.send column.to_sym
          count += 1
        end
      end
      return count
    else
      return nil
    end
  end

  require 'csv'

  def to_csv model
    model = model.to_s.classify.constantize
    CSV.generate do |csv| 
      csv << ["First Name", "Last Name"]
      model.send(:all).each do |row|
        csv << [row.first_name, row.last_name]
      end
    end
  end

end