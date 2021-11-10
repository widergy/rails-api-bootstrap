class VersionsController < ApplicationController
  def show
    return render json: { version: api_version }, status: :ok unless mobile_app_params?
    return render_error(:invalid_params) unless valid_params?

    render_mobile_app_response
  end

  private

  def api_version
    RailsApiBootstrap::Application::VERSION
  end

  def mobile_app_params?
    device_type_param.present? || app_version_param.present?
  end

  def device_type_param
    params[:device_type]
  end

  def app_version_param
    params[:app_version]
  end

  def valid_params?
    params.require(:device_type)
    params.require(:app_version)
    MobileApp.device_types.include?(device_type_param) && valid_version?
  end

  def valid_version?
    mobile_app_version
  rescue ArgumentError
    false
  else
    true
  end

  def mobile_app_version
    @mobile_app_version ||= Gem::Version.new(app_version_param)
  end

  def render_mobile_app_response
    return mobile_app_not_found_response if nearest_version.blank?

    mobile_app_success_response
  end

  def nearest_version
    @nearest_version ||= mobile_app_versions.select { |version| version <= mobile_app_version }.max
  end

  def mobile_app_versions
    mobile_apps.map { |app| Gem::Version.new(app.version) }
  end

  def mobile_apps
    @mobile_apps ||= utility.mobile_apps.where(device_type: device_type_param)
  end

  def mobile_app_not_found_response
    render_error(:app_version_not_found, status: :not_found)
  end

  def mobile_app_success_response
    app = nearest_version_mobile_app
    render json: { version: api_version, app_status: app.status,
                   app_version: app.version }, status: :ok
  end

  def nearest_version_mobile_app
    @nearest_version_mobile_app ||= mobile_apps.find_by(version: nearest_version.to_s)
  end
end
