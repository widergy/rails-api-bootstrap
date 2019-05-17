shared_examples 'unprocessable entity with message' do
  it 'returns status code unprocessable entity' do
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'returns the appropiate error message' do
    expect(response_body['errors'].first['message'])
      .to eq(message)
  end
end
