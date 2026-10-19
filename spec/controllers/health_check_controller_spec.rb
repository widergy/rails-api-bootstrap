require 'rails_helper'

describe HealthCheckController do
  describe 'GET #index' do
    subject do
      get :index, params: { checks: 'all' }
    end

    # El chequeo sidekiq-redis abre el pool de Redis de Sidekiq, y Sidekiq loguea esa
    # conexion en INFO contra $stdout, que es su default y no pasa por Rails.logger.
    # Se captura en vez de dejarla imprimir: el log se sigue emitiendo y se afirma
    # abajo, sin ensuciar la salida de la suite.
    let(:sidekiq_logs) { [] }

    before do
      request.headers['Accept'] = 'application/json'
      allow(Sidekiq.logger).to receive(:info) do |*args, &message|
        sidekiq_logs << (message ? message.call : args.first)
      end
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

      it 'opens the Sidekiq Redis connection that the sidekiq-redis check needs' do
        # El pool se memoiza por proceso, asi que sin esto la conexion -- y su log --
        # ocurren en el primer ejemplo que toque Sidekiq segun el seed, no en este.
        # Sidekiq no expone forma de reiniciarlo.
        Sidekiq.default_configuration.instance_variable_set(:@redis, nil)
        subject
        expect(sidekiq_logs).to include(a_string_including('connecting to Redis'))
      end
    end
  end
end
