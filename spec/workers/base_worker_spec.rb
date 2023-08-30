require 'rails_helper'

describe BaseWorker do
  describe '.execute' do
    subject(:execute_worker) { worker_class.new.execute(model, client.id, *args) }

    let(:utility_service_class) { double('utility_service_class') }
    let(:utility_service) { double('utility_service') }

    let(:worker_class) do
      Class.new(described_class) do
        def execute(model, client_id, *args)
          initialize_client(model, client_id)
          initialize_variables(*args)
          perform(*args)
        end

        def process_response; end

        def service; end

        def attempt; end
      end
    end

    let(:model) { double('model') }
    let(:client) { double('client') }
    let(:utility) { double('utility') }
    let(:service) { 'service' }
    let(:attempt) { 'some_attempt' }
    let(:process_response) { 'some_process' }
    let(:transform_response) { 'some_transform' }
    let(:method) { double('method') }
    let(:other_method) { double('other_method') }
    let(:response) { double('response') }

    let(:args) do
      Array.new(utility_service_class.instance_method(service).parameters.count) { rand(1...9) }
    end

    before do
      allow(utility_service_class).to receive(:instance_methods).and_return(method)
      allow(utility_service_class).to receive(:instance_method).and_return(method)
      allow_any_instance_of(worker_class).to receive(:service).and_return(service)
      allow_any_instance_of(worker_class).to receive(:attempt).and_return(attempt)
      allow_any_instance_of(worker_class).to receive(:process_response)
        .and_return(process_response)
      allow_any_instance_of(worker_class).to receive(:transform_response)
        .and_return(transform_response)
      allow(method).to receive(:parameters).and_return(%w[a b c])
      allow(client).to receive(:id).and_return(10)
      allow(model).to receive(:safe_constantize).and_return(model)
      allow(model).to receive(:id).and_return(10)
      allow(model).to receive(:find).and_return(model)
      allow(model).to receive(:utility).and_return(utility)
      allow(utility).to receive(:utility_service_class).and_return(utility_service_class)
      allow(utility).to receive(:utility_service).and_return(utility_service)
      allow(utility).to receive(:id).and_return(1)
      allow(utility).to receive(:name).and_return('name')
      allow(utility_service).to receive(:service).and_return(response)
    end

    context 'when the utility service succeeds' do
      let(:code) { 200 }
      let(:body) do
        {
          message: 'message'
        }
      end

      before do
        allow(response).to receive(:code).and_return(code)
        allow(response).to receive(:body).and_return(body)
      end

      it 'returns status code ok' do
        expect(execute_worker.first).to eq(code)
      end

      it 'returns expected body' do
        expect(execute_worker.second).to eq(body)
      end

      it 'calls process_response' do
        expect_any_instance_of(worker_class).to receive(:process_response).and_call_original
        execute_worker
      end
    end

    context 'when the utility service fails' do
      let(:utility_service_method) { service }
      let(:expected_status_code) { 500 }
      let(:expected_response_body) do
        {
          error: 'message'
        }
      end

      before do
        allow(response).to receive(:code).and_return(500)
        allow(response).to receive(:body).and_return(error: 'message')
      end

      it 'returns status code obtained from the utility service' do
        expect(execute_worker.first).to eq(expected_status_code)
      end

      it 'returns the body obtained from the utility service' do
        expect(execute_worker.second).to eq(expected_response_body)
      end

      it 'logs the invalid response' do
        expect_any_instance_of(worker_class).to receive(:log_invalid_response)
          .with(hash_including(attempt: attempt))
        execute_worker
      end
    end
  end
end
