class VersionsController < ApplicationController
  def show
    render json: { version: api_version }, status: :ok
  end

  private

  def api_version
    RailsApiBootstrap::Application::VERSION
  end
end
