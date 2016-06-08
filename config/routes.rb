AmandaAdamRails::Application.routes.draw do

  resources :admin do
    collection do 
      get :invitations
      get :guests
      get :meals
      get :summary
      get :deadline
    end
  end
  
  resources :meals

  resources :invitations do
    resources :guests do
      member do
        get :reset
      end
    end
  end

  %w(about contact help home index information pictures registries rsvp wedding-party).each do |action|
    get "/#{action}" => "static##{action}"
  end

  redirects = {
    "/story" => "/home",
    "/email" => "/contact",
    "/about" => "/information",
    "/registry" => "/registries",
    "/gift" => "/registries",
    "/party" => "/wedding-party",
    "/wedding_party" => "/wedding-party",
    "/weddingparty" => "/wedding-party",
  }

  redirects.each do |pattern, url|
    match pattern => redirect(url)
  end

  # manual rsvp
  get "/RSVP" => "static#rsvp"
  get "/rsvp/manual" => "guests#new"

  # home page
  get "/home" => "static#index"
  root :to => "static#index"

  # redirect rsvp/ID to invitations controller
  match "/rsvp/:id" => redirect("/invitations/%{id}")

  # error
  match '*a', :to => 'errors#routing'
  
end
