class HealthCheckController < HealthCheck::HealthCheckController
  # This overwrites the original HealthCheckController from the health_check gem, in order to add
  # a custom check agaist the utilty's API health check. Original controller:
  # https://github.com/ianheggie/health_check/blob/rails5/lib/health_check/health_check_controller.rb
  rescue_from ActiveRecord::RecordNotFound, with: :render_nothing_not_found

  def index
    return super if utility.blank?
    return render_failed_utility_inactive unless utility.active
    return super if utility.health_check_url.blank?

    @utility_response = utility.utility_service.health_check
    return super if @utility_response.code == 200

    render_failed_utility_health_check
  end

  private

  def utility
    utility_code_header = request.headers['Utility-ID']
    return if utility_code_header.nil?

    utility_code = sanitized_utility_code(utility_code_header)
    @utility ||= Utility.find_by!(code: utility_code)
  end

  def render_failed_utility_inactive
    @utility_disabled = true
    message = "health_check failed: #{utility.name} is disabled."
    process_response(message)
  end

  def render_failed_utility_health_check
    @utility_error = true
    message = "health_check failed: #{utility.name} API is down."
    process_response(message)
  end

  def process_response(message)
    # Log a single line as some uptime checkers only record that it failed, not the text returned
    logger&.info message
    send_response(
      message, HealthCheck.http_status_for_error_text, HealthCheck.http_status_for_error_object,
      display_message: utility.display_downtime_message
    )
  end

  def sanitized_utility_code(utility_code_header)
    Integer(utility_code_header)
  rescue ArgumentError
    nil
  end

  def render_nothing_not_found
    head :not_found
  end

  def send_response(msg, text_status, obj_status, display_message: nil)
    obj = build_obj(msg, display_message)
    msg ||= HealthCheck.success
    respond_to do |format|
      format.html { render plain_key => msg, status: text_status, content_type: 'text/plain' }
      format.json { render json: obj, status: obj_status }
      format.xml { render xml: obj, status: obj_status }
      format.any { render plain_key => msg, status: text_status, content_type: 'text/plain' }
    end
  end

  def build_obj(msg, display_message)
    healthy = !msg
    report_rollbar_error(msg) unless healthy
    msg ||= HealthCheck.success
    { healthy: healthy, message: msg, display_message: display_message }
  end

  def report_rollbar_error(message)
    Rollbar.error(
      item_error_name,
      utility: "Utility - ID: #{utility&.id}, NAME: #{utility&.name}",
      response_code: @utility_response&.code,
      response_body: @utility_response&.body,
      message: message
    )
  end

  def item_error_name
    return 'Health check failed: utility error' if @utility_error
    return 'Health check failed: utility disabled' if @utility_disabled

    'Health check failed: internal error'
  end
end
