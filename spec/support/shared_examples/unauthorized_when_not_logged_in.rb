shared_examples 'unauthorized when not logged in' do
  context 'when there is not a logged in user' do
    it 'returns status code unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message for a not authorized request' do
      expect(response_body['errors'].first['message'])
        .to eq I18n.t('errors.messages.not_authorized')
    end
  end
end
