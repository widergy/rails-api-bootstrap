shared_examples 'basic endpoint with polling' do
  it 'returns status code accepted' do
    expect(response).to have_http_status(:accepted)
  end

  it 'returns the response id and url to retrive the data later' do
    expect(response_body.keys).to contain_exactly('url', 'job_id')
  end

  it 'enqueues a job' do
    expect(AsyncRequest::JobProcessor.jobs.size).to eq(1)
  end

  it 'creates the right job' do
    expect(AsyncRequest::Job.last.worker).to eq(worker_name)
  end

  it 'creates a job with given parameters' do
    expect(AsyncRequest::Job.last.params).to eq(parameters)
  end
end
