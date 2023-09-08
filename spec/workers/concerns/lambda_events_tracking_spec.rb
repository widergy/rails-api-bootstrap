require 'rails_helper'

class LambdaTrackingDummyClass
  include LambdaEventsTracking

  def initialize(model, client_id)
    @model = model&.safe_constantize
    @client_id = client_id
  end
end

describe LambdaEventsTracking do
  let(:consumer) { double(:consumer) }
  let(:model) { 'Consumer' }
  let(:client_id) { 8 }
  let(:dummy_instance) { LambdaTrackingDummyClass.new(model, client_id) }
  let(:response_code) { [200, 202].sample }

  context 'when there is an unexpected exception' do
    let(:params) do
      {
        event: 'event',
        channel: 'web'
      }
    end
    let(:utility) { double('utility') }

    before do
      allow(dummy_instance).to receive(:utility_lambda).and_return(utility)
      allow(utility).to receive(:id).and_return(8)
      allow(utility).to receive(:code).and_return(8)
      allow(utility).to receive(:name).and_return('utility name')
      allow(dummy_instance).to receive(:track_event).and_raise(StandardError)
      allow_any_instance_of(WorkerHelpers).to receive(:user_or_client_or_nil).and_return(nil)
    end

    it 'calls lambda event tracking error method' do
      expect(dummy_instance).to receive(:lambda_event_tracking_error).once
                                                                     .and_call_original
      dummy_instance.track_entity_event(**params)
    end
  end

  describe '#track_entity_event' do
    let(:base_params) do
      {
        event: 'event',
        channel: 'web'
      }
    end
    let(:utility) { double('utility') }

    context 'when calling an event tracking with invalid params' do
      context 'when missing a required param' do
        let(:params) { base_params.except(:event) }

        it 'raises an argument error' do
          expect { dummy_instance.track_entity_event(params) }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when calling an event tracking with valid params' do
      before do
        allow(dummy_instance).to receive(:track_event)
          .and_return(OpenStruct.new(code: response_code))
        allow_any_instance_of(WorkerHelpers).to receive(:user_or_client_or_nil).and_return(nil)
        allow(utility).to receive(:id).and_return(8)
        allow(utility).to receive(:code).and_return(8)
        allow(utility).to receive(:name).and_return('utility name')
        allow(dummy_instance).to receive(:utility_lambda).and_return(utility)
      end

      context 'with client in context' do
        context 'when request is sucessful' do
          let(:expected_keys) do
            %i[event_type entity_id id_type utility_code entity_name event channel metadata app
               timestamp]
          end

          it 'doesn\'t call the log and report' do
            expect(dummy_instance).to receive(:log_and_report_invalid_response).exactly(0)
                                                                               .times
                                                                               .and_call_original
            dummy_instance.track_entity_event(**base_params)
          end

          it 'builds the proper body' do
            dummy_instance.track_entity_event(**base_params)
            expect(JSON.parse(dummy_instance.send(:track_entity_event_body, base_params[:event],
                                                  base_params[:channel]),
                              symbolize_names: true).keys).to contain_exactly(*expected_keys)
          end
        end

        context 'when request is not successful' do
          let(:response_code) { 500 }

          it 'does call the log and report' do
            expect(dummy_instance).to receive(:log_and_report_invalid_response).once
                                                                               .and_call_original
            dummy_instance.track_entity_event(**base_params)
          end
        end
      end

      context 'without client in context' do
        let(:model) { nil }
        let(:client_id) { nil }
        let(:params) { base_params.merge(utility: utility) }

        context 'when request is sucessful' do
          let(:expected_keys) do
            %i[event_type entity_id id_type utility_code entity_name event channel metadata app
               timestamp]
          end

          it 'doesn\'t call the log and report' do
            expect(dummy_instance).to receive(:log_and_report_invalid_response).exactly(0)
                                                                               .times
                                                                               .and_call_original
            dummy_instance.track_entity_event(**params)
          end

          it 'builds the proper body' do
            dummy_instance.track_entity_event(**params)
            expect(JSON.parse(dummy_instance.send(:track_entity_event_body, base_params[:event],
                                                  base_params[:channel]),
                              symbolize_names: true).keys).to contain_exactly(*expected_keys)
          end
        end

        context 'when request is not successful' do
          let(:response_code) { 500 }

          it 'does call the log and report' do
            expect(dummy_instance).to receive(:log_and_report_invalid_response).once
                                                                               .and_call_original
            dummy_instance.track_entity_event(**params)
          end
        end
      end

      context 'when sending a nil channel value' do
        let(:params) { base_params.merge(channel: nil) }

        let(:expected_keys) do
          %i[event_type entity_id id_type utility_code entity_name event channel metadata app
             timestamp]
        end

        it 'doesn\'t call the log and report' do
          expect(dummy_instance).to receive(:log_and_report_invalid_response).exactly(0)
                                                                             .times
                                                                             .and_call_original
          dummy_instance.track_entity_event(**base_params)
        end

        it 'builds the proper body' do
          dummy_instance.track_entity_event(**base_params)
          expect(JSON.parse(dummy_instance.send(:track_entity_event_body, base_params[:event],
                                                base_params[:channel]),
                            symbolize_names: true).keys).to contain_exactly(*expected_keys)
        end
      end
    end
  end

  describe '#track_request_event' do
    let(:base_params) do
      {
        url: 'url',
        http_method: %w[GET POST DELETE PUT PATCH].sample,
        failed: Faker::Boolean.boolean,
        response: {}
      }
    end

    context 'when calling an event tracking with invalid params' do
      let(:utility) { double('utility') }

      before do
        allow(dummy_instance).to receive(:track_event)
          .and_return(OpenStruct.new(code: response_code))
        allow_any_instance_of(WorkerHelpers).to receive(:user_or_client_or_nil).and_return(nil)
        allow(utility).to receive(:id).and_return(8)
        allow(utility).to receive(:code).and_return(8)
        allow(utility).to receive(:name).and_return('utility name')
        allow(dummy_instance).to receive(:utility_lambda).and_return(utility)
      end

      context 'when missing a required param' do
        let(:params) { base_params.except(%i[url response].sample) }

        it 'raises an argument error' do
          expect { dummy_instance.track_request_event(params) }.to raise_error(ArgumentError)
        end
      end

      context 'when sending an invalid http_method value' do
        let(:params) { base_params.merge(http_method: 'invalid http_method value') }

        it 'has the errors array present' do
          dummy_instance.track_request_event(**params)
          expect(dummy_instance.errors).to be_present
        end

        it 'doesn\'t call the track event method' do
          expect(dummy_instance).to receive(:track_event).exactly(0)
                                                         .times
                                                         .and_call_original
          dummy_instance.track_request_event(**params)
        end
      end

      context 'when sending an invalid failed value' do
        let(:params) { base_params.merge(failed: 'invalid failed value') }

        it 'has the errors array present' do
          dummy_instance.track_request_event(**params)
          expect(dummy_instance.errors).to be_present
        end

        it 'doesn\'t call the track event method' do
          expect(dummy_instance).to receive(:track_event).exactly(0)
                                                         .times
                                                         .and_call_original
          dummy_instance.track_request_event(**params)
        end
      end
    end

    context 'when calling an event tracking with valid params' do
      let(:utility) { double('utility') }
      let(:model) { nil }
      let(:client_id) { nil }
      let(:params) { base_params.merge(utility: utility) }

      before do
        allow_any_instance_of(WorkerHelpers).to receive(:user_or_client_or_nil).and_return(nil)
        allow(utility).to receive(:id).and_return(8)
        allow(utility).to receive(:code).and_return(8)
        allow(utility).to receive(:name).and_return('utility name')
        allow(dummy_instance).to receive(:track_event)
          .and_return(OpenStruct.new(code: response_code))
        allow(dummy_instance).to receive(:utility_lambda).and_return(utility)
      end

      context 'when request is sucessful' do
        let(:expected_keys) do
          %i[body event_type failed http_method params response timestamp url utility_code]
        end

        it 'doesn\'t call the log and report' do
          expect(dummy_instance).to receive(:log_and_report_invalid_response).exactly(0)
                                                                             .times
                                                                             .and_call_original
          dummy_instance.track_request_event(**params)
        end

        it 'builds the proper body' do
          dummy_instance.track_request_event(**params)
          expect(JSON.parse(dummy_instance.send(:track_request_event_body, base_params[:url],
                                                base_params[:http_method],
                                                base_params[:failed],
                                                base_params[:response]),
                            symbolize_names: true).keys).to contain_exactly(*expected_keys)
        end
      end

      context 'when request is not successful' do
        let(:response_code) { 500 }

        it 'does call the log and report' do
          expect(dummy_instance).to receive(:log_and_report_invalid_response).once
                                                                             .and_call_original
          dummy_instance.track_request_event(**params)
        end
      end
    end
  end
end
