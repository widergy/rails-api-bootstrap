shared_examples 'basic show endpoint' do
  it 'returns status code ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'returns the desired record' do
    expect(record.class.find(response_body['id'])).to eq(record)
  end
end
