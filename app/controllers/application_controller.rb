class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, :with => :id_not_found

  def authenticate_user
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "changeme"
    end
  end

  layout proc{ |c| c.request.xhr? ? false : "application" }

  def email subject, body
    Pony.mail(:to=>'recipient-email@example.com', 
              :from => 'sender-email@example.com', 
              :subject=> subject,
              :headers => { 'Content-Type' => 'text/html' },
              :body => body,
              :via => :smtp, :via_options => {
                :address        => 'smtp.gmail.com',
                :port           => '587',
                :user_name      => 'gmail-username',
                :password       => 'gmail-password',
                :authentication => :plain,
                :domain         => "domain-name"
              }
            )
    "Email Delivered"
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

  def deadline_is_passed(time=Time.now)
    admin = Admin.first
    time = time.to_i
    deadline = admin.global_lock_date.to_i
    begin
      return time > deadline
    rescue
      false
    end
  end
  def check_lock
    if rsvp_is_locked
      unless request.referrer and request.referrer.match(/admin/i) and authenticate_user
        redirect_to "/rsvp"
      end
    end
  end


  rescue_from ActionController::RoutingError, :with => :render_404

  private
  def render_404(exception = nil, layout=true)
    if exception
        logger.info "Rendering 404: #{exception.message}"
    end
    render :file => "#{Rails.root}/app/views/errors/404.html.slim", :status => 404, :layout => layout
  end

end
