# frozen_string_literal: true

class ApplicationController < ActionController::Base
  NOT_FOUND_ERROR_CLASSES = [
    ActionController::RoutingError,
    ActionController::UrlGenerationError,
    ActiveRecord::RecordNotFound,
    ActionView::MissingTemplate
  ].freeze

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  respond_to :html, :json, :js
  rescue_from Exception, with: :render_error

  def authenticate_admin!
    current_user.is_admin? || redirect_to(root_path, alert: t('admin_authentication_failure'))
  end

  # Devise parameter
  def after_sign_in_path_for(_resource)
    diagnoses_path
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def render_error(exception)
    raise exception if Rails.env.development? || (Rails.env.test? && !ENV['TEST_ERROR_RENDERING'].to_b)
    if NOT_FOUND_ERROR_CLASSES.include? exception.class
      respond_with_status(404)
    else
      send_error_notifications(exception)
      respond_with_status(500)
    end
  end

  def respond_with_status(status)
    respond_with do |format|
      format.html { render "errors/#{status}" }
      format.json { render body: nil, status: status }
      format.js { render body: nil, status: status }
    end
  end

  def send_error_notifications(exception)
    data = {
      message: '500',
      format: request&.format&.symbol,
      current_user_full_name: current_user&.full_name,
      current_user_email: current_user&.email,
      current_user_id: current_user&.id
    }
    ExceptionNotifier.notify_exception exception, env: request.env, data: data
  end

  def check_current_user_access_to(resource)
    not_found unless resource.send(:can_be_viewed_by?, current_user)
  end
end
