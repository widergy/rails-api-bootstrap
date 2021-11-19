require 'rails_helper'

describe UtilityService::Base do
  let(:user) { nil }
  let!(:utility) { double('utility') }

  describe '.build_url' do
    subject(:build_url) do
      # "send" is used since the method is private
      described_class.new(utility, user).send(:build_url, url)
    end

    let(:expected_url) { 'http://www.some-base.com/some/path' }
    let(:utility) { double('utility') }

    before do
      allow(utility).to receive(:base_url).and_return('http://www.some-base.com')
      allow(utility).to receive(:external_api_access_token?).and_return(false)
      allow_any_instance_of(described_class).to receive(:build_utility_service_methods).and_return(described_class)
    end

    context 'when the url starts with http' do
      let(:url) { expected_url }

      it 'returns the expected url' do
        expect(subject).to eq(expected_url)
      end
    end

    context 'when the url is just a path' do
      let(:utility) { double('utility') }

      context 'when the utility\'s base url ends with /' do
        before do
          allow(utility).to receive(:base_url).and_return('http://www.some-base.com/')
          allow(utility).to receive(:external_api_access_token?).and_return(false)
          allow_any_instance_of(described_class).to receive(:build_utility_service_methods).and_return(described_class)
        end

        context 'when the url starts with /' do
          let(:url) { '/some/path' }

          it 'returns the expected url' do
            expect(subject).to eq(expected_url)
          end
        end

        context 'when the url doesn\'t start with /' do
          let(:url) { 'some/path' }

          it 'returns the expected url' do
            expect(subject).to eq(expected_url)
          end
        end
      end

      context 'when the utility\'s base url doesn\'t end with /' do
        let(:utility) { double('utility') }

        before do
          allow(utility).to receive(:base_url).and_return('http://www.some-base.com')
          allow(utility).to receive(:external_api_access_token?).and_return(false)
          allow_any_instance_of(described_class).to receive(:build_utility_service_methods).and_return(described_class)
        end

        context 'when the url starts with /' do
          let(:url) { '/some/path' }

          it 'returns the expected url' do
            expect(subject).to eq(expected_url)
          end
        end

        context 'when the url doesn\'t start with /' do
          let(:url) { 'some/path' }

          it 'returns the expected url' do
            expect(subject).to eq(expected_url)
          end
        end
      end
    end
  end

  describe '.sanitize_args' do
    subject(:sanitize_args) do
      # "send" is used since the method is private
      described_class.new(utility, user).send(:sanitize_args, [params])
    end

    let!(:utility) { double('utility') }
    let(:random_key) { Faker::Name.name }
    let(:another_random_key) { Faker::Number.number(digits: 2) }

    before do
      allow(utility).to receive(:base_url).and_return('http://unaurl.api.com')
      allow(utility).to receive(:external_api_access_token?).and_return(false)
      allow_any_instance_of(described_class).to receive(:build_utility_service_methods).and_return(described_class)
    end

    context 'when sending a hash of params' do
      let(:params) do
        {
          random_key: random_key,
          another_random_key: another_random_key
        }
      end

      it 'returns a hash with indifferent access' do
        expect(subject.first.class).to eq(ActiveSupport::HashWithIndifferentAccess)
      end
    end

    context 'when sending ActionController::Parameter params' do
      let(:params) do
        ActionController::Parameters.new(random_key: random_key,
                                         another_random_key: another_random_key).permit!
      end

      it 'returns a hash with indifferent access' do
        expect(subject.first.class).to eq(ActiveSupport::HashWithIndifferentAccess)
      end
    end

    context 'when sending another kind of params' do
      let(:params) { random_key }

      it 'does not changes params' do
        expect(subject.class).not_to eq(ActiveSupport::HashWithIndifferentAccess)
      end
    end

    context 'when sending multiple args' do
      subject(:sanitize_args) do
        described_class.new(utility, user).send(:sanitize_args, [params, random_key])
      end

      let!(:utility) { double('utility') }

      let(:params) do
        {
          random_key: random_key,
          another_random_key: another_random_key
        }
      end

      it 'does not change the random key' do
        expect(subject.second.class).not_to eq(ActiveSupport::HashWithIndifferentAccess)
      end

      it 'does change the params' do
        expect(subject.first.class).to eq(ActiveSupport::HashWithIndifferentAccess)
      end
    end
  end
end
