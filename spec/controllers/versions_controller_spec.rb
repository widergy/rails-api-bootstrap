require 'rails_helper'

describe VersionsController, type: :controller do
  describe 'GET #show' do
    context 'when asking for the API version' do
      let!(:version) { RailsApiBootstrap::Application::VERSION }

      before { get :show }

      it 'succeeds' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the API version number' do
        expect(response_body['version']).to eq(version)
      end
    end
  end
end
