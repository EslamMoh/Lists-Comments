class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  protected

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 25
  end
end
