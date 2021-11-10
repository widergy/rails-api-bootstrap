# module Api
#   class ApiBaseController < ApplicationController
#     before_action :current_user, :validate_utility, :authenticate_request

#     def current_user
#       @current_user ||= authentication_manager.current_user
#     end

#     private

#     def validate_utility
#       return if current_user.nil?
#       raise Exceptions::InvalidCurrentClientError if current_user.utility != utility
#       check_utility_status!
#     end

#     def current_account
#       return non_authenticated_user_account if should_skip_authentication?
#       raise ActiveRecord::RecordNotFound if current_user.nil?
#       @current_account ||= current_user.accounts.find_by!(id: account_param)
#     end

#     def non_authenticated_user_account
#       utility.accounts.find_by!(id: account_param)
#     end

#     def current_account_or_nil
#       current_account
#     rescue StandardError
#       nil
#     end

#     def account_param
#       params.require(:account_id)
#     end

#     # If the authentication token is not valid, then super renders an unauthorized
#     # error (and returns false). If the token is valid, but it's not a user token,
#     # it renders a forbidden error.
#     def authenticate_request
#       raise Exceptions::ClientForbiddenError if super && current_user.blank?
#     end

#     def should_skip_authentication?
#       utility.should_skip_authentication_for?(current_endpoint_path)
#     end

#     def current_endpoint_path
#       params[:controller] + '#' + params[:action]
#     end

#     def retrieve_file_name(response)
#       response.headers['content-disposition'].split('=').second.delete('"')
#     end
#   end
# end
