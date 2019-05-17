shared_examples 'bad request with message' do
  it 'returns status code bad request' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns the appropiate error message' do
    expect(response_body['errors'].first['message'])
      .to eq(message)
  end
end
