class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin

  private

  def authenticate_admin
    authenticate_or_request_with_http_basic('Admin') do |username, password|
      username == ENV.fetch('ADMIN_USERNAME', 'admin') &&
        password == ENV.fetch('ADMIN_PASSWORD', 'royalnail')
    end
  end
end
