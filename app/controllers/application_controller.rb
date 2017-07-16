class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #gives us the Sessions class helper across all of our controllers
  include SessionsHelper
  def hello
    render html: "hello, world!"
  end
end
