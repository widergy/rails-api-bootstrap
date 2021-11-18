require 'rails_helper'

# class UtilityDummyClass < ApplicationRecord

#   self.table_name = 'utility_dummy_class_table'
# end

# describe HealthCheckController, type: :controller do
#   def create_table
#     ActiveRecord::Base.connection.create_table :utility_dummy_class_table do |t|
#       t.string :name
#       t.boolean :active
#       t.string :display_downtime_message
#     end
#   end

#   def drop_table
#     ActiveRecord::Base.connection.drop_table :utility_dummy_class_table
#   end

#   before do
#     create_table
#     UtilityDummyClass.reset_column_information
#   end

#   describe 'GET #index' do
#     subject do
#         get :index, params: { checks: 'all' }
#     end

#     before do
#       request.headers['Accept'] = 'application/json'
#     end

#     context 'when the Utility-ID header is sent' do
#       let(:utility) { UtilityDummyClass.new(active: true, name: 'Name', display_downtime_message: 'Message') }
#       let(:utility_service_type_name) {'utility'}
#       let(:utility_service_type) { instance_double(utility_service_type_name) }
#       let(:utility_service_class) { utility.utility_service_type::Base }
#       let(:utility_service_instance) { instance_double(utility_service_class) }
#       let(:utility_service_response_class) { "#{utility_service_class}::Response".safe_constantize }

#       context 'when the utility is active' do
#         let(:health_check_response) do
#           {
#             "version": "1.0",
#             "date": "2018-12-13T19:44:51.669Z",
#             "exist_account": true
#           }
#         end

#         before do
#           utility.save
#           allow_any_instance_of(utility_service_class).to receive(:health_check)
#             .and_return(instance_double("#{utility_service_class}::Response",
#                                             code: 200,
#                                             body: health_check_response))
#           allow_any_instance_of(utility).to receive(:utility_service_type)
#           .and_return(utility_service_type)
#         end

#         context 'when the utility has the health check url set' do
#           let(:health_check_url) do
#             'https://private-dde10-edenordigitalapi.apiary-mock.com/status'
#           end

#           before do
#             allow(utility).to receive(:health_check_url).and_return(health_check_url)
#           end

#           context 'when the utility\'s service succeeds' do
#             let(:expected_response_body) do
#               { healthy: true, message: 'success', display_message: nil }.as_json
#             end

#             it 'succeeds' do
#               subject
#               expect(response).to have_http_status(:ok)
#             end

#             it 'calls the utility service\'s method' do
#               expect_any_instance_of(utility_service_class)
#                 .to receive(:health_check).and_call_original
#               subject
#             end

#             it 'responds with the correct body' do
#               subject
#               expect(response_body).to eq(expected_response_body)
#             end
#           end

#           context 'when the utility\'s service fails' do
#             let(:expected_response_body) do
#               { healthy: false, message: msg, display_message: display_message }.as_json
#             end

#             let(:msg) { "health_check failed: #{utility.name} API is down." }
#             let(:display_message) { 'Utility unavailable' }

#             before do
#               utility.update(display_downtime_message: display_message)
#               allow_any_instance_of(utility_service_class).to receive(:health_check)
#                 .and_return(instance_double(utility_service_response_class,
#                                             code: 500, body: ''))
#             end

#             it 'fails' do
#               subject
#               expect(response).to have_http_status(:internal_server_error)
#             end

#             it 'responds with the correct body' do
#               subject
#               expect(response_body).to eq(expected_response_body)
#             end
#           end
#         end

#         context 'when the utility does not have the health check url set' do
#           let(:expected_response_body) do
#             { healthy: true, message: 'success', display_message: nil }.as_json
#           end

#           before do
#             utility.update(health_check_url: nil)
#           end

#           it 'succeeds' do
#             subject
#             expect(response).to have_http_status(:ok)
#           end

#           it 'does not call the utility service\'s method' do
#             expect_any_instance_of(utility_service_class)
#               .not_to receive(:health_check)
#             subject
#           end

#           it 'responds with the correct body' do
#             subject
#             expect(response_body).to eq(expected_response_body)
#           end
#         end
#       end

#       context 'when the utility is not active' do
#         let(:expected_response_body) do
#           { healthy: false, message: msg, display_message: display_message }.as_json
#         end

#         let(:msg) { "health_check failed: #{utility.name} API is down." }
#         let(:display_message) { 'Utility unavailable' }

#         before do
#           utility.update(active: false, display_downtime_message: display_message)
#         end

#         it 'fails' do
#           subject
#           expect(response).to have_http_status(HealthCheck.http_status_for_error_object)
#         end

#         it 'responds with the correct body' do
#           subject
#           expect(response_body).to eq(expected_response_body)
#         end
#       end
#     end

#     context 'when the Utility-ID header is not sent' do
#       let(:expected_response_body) do
#         { healthy: true, message: 'success', display_message: nil }.as_json
#       end

#       it 'succeeds' do
#         subject
#         expect(response).to have_http_status(:ok)
#       end

#       it 'responds with the correct body' do
#         subject
#         expect(response_body).to eq(expected_response_body)
#       end
#     end
#   end
# end
