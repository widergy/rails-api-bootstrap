require 'rails_helper'

describe RailsApiBootstrap::Application do
  subject(:version) { described_class::VERSION }

  it 'has a version number' do
    expect(version).not_to be nil
  end

  it 'has the correct version number' do
    expect(version).to eq('1.0.0')
  end
end
