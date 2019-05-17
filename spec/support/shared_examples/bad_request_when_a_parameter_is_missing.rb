shared_examples 'bad request when a parameter is missing' do
  it 'returns status code bad request' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns an error message' do
    expect(response_body['errors'].first['message'])
      .to eq I18n.t('errors.messages.internal_server_error')
  end

  it 'returns the correct error meta message' do
    expect(response_body['errors'].first['meta'])
      .to eq "param is missing or the value is empty: #{missing_parameter}"
  end
end
