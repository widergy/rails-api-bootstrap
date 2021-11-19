require 'rails_helper'

describe HealthCheckController, type: :controller do
  describe 'GET #index' do
    subject do
      get :index, params: { checks: 'all' }
    end

    before do
      request.headers['Accept'] = 'application/json'
    end

    context 'when the Utility-ID header is not sent' do
      let(:expected_response_body) do
        { healthy: true, message: 'success', display_message: nil }.as_json
      end

      it 'succeeds' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'responds with the correct body' do
        subject
        expect(response_body).to eq(expected_response_body)
      end
    end
  end
end
