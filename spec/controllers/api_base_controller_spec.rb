require 'rails_helper'

# TODO: Add this tests when uncomment api_base_controller file

# describe Api::ApiBaseController, type: :controller do
#   include_context 'with anonymous controller'
#   include_context 'with random utility'

#   context 'with a user token' do
#     include_context 'with authenticated user'
#     include_context 'with token auth verification' do
#       let(:expiration) { utility.token_expiration_days.to_i.days }
#     end

#     context 'with utility mismatch' do
#       let(:other_utility) do
#         create((utilities.map { |e| e.to_s.underscore.to_sym } - [utility]).sample)
#       end

#       before do
#         request.headers['Utility-ID'] = other_utility.code
#         get :index
#       end

#       it 'responds with 422 unprocessable entity' do
#         expect(response).to have_http_status(:unprocessable_entity)
#       end

#       it 'responds with the correct error body' do
#         expect(response_body)
#           .to eq(ErrorResponseBuilder.new(:unprocessable_entity, utility)
#                                      .add_error('invalid_current_client')
#                                      .to_h.as_json)
#       end
#     end

#     context 'with inactive utility' do
#       before do
#         utility.update(active: false)
#         get :index
#       end

#       it 'responds with 500 internal_server_error' do
#         expect(response).to have_http_status(:internal_server_error)
#       end

#       it 'responds with the correct error body' do
#         expect(response_body)
#           .to eq(ErrorResponseBuilder.new(:internal_server_error, utility)
#                                      .add_error(:utility_unavailable)
#                                      .to_h.as_json)
#       end
#     end
#   end
# end
