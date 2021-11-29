require 'rails_helper'

shared_examples 'when returns failed response' do
  let(:title_key) { 'title' }
  let(:message_key) { 'message' }
  let(:expected) do
    {
      message: response_body[message_key],
      title: response_body[title_key]
    }
  end

  it 'maps the response correctly' do
    expect(subject).to eq(expected)
  end
end

describe UtilityService::FailedResponseMapper do
  let(:utility) { double('utility') }

  describe '.none' do
    subject(:mapper) { described_class.new(utility).none(response_code, response_body) }

    let(:response_code) { Faker::Number.number(digits: 3) }
    let(:response_body) do
      {
        code: Faker::Movies::BackToTheFuture.character,
        error_message: Faker::Books::Lovecraft.paragraph
      }
    end
    let!(:expected) { response_body }

    it 'maps the response correctly' do
      expect(subject).to eq(expected)
    end
  end

  describe '.default_response' do
    subject(:mapper) do
      described_class.new(utility).default_response(response_code, response_body)
    end

    let(:response_code) { Faker::Number.number(digits: 3) }

    context 'when the message in the hash has the key Message' do
      let(:response_body) do
        {
          code: Faker::Movies::BackToTheFuture.character,
          Message: Faker::Books::Lovecraft.paragraph
        }
      end

      it_behaves_like 'when returns failed response' do
        let(:message_key) { 'Message' }
      end
    end

    context 'when the message in the hash has the key Mensaje' do
      let(:response_body) do
        {
          code: Faker::Movies::BackToTheFuture.character,
          Mensaje: Faker::Books::Lovecraft.paragraph
        }
      end

      it_behaves_like 'when returns failed response' do
        let(:message_key) { 'Mensaje' }
      end
    end

    context 'when the message in the hash has the key message' do
      let(:response_body) do
        {
          code: Faker::Movies::BackToTheFuture.character,
          message: Faker::Books::Lovecraft.paragraph
        }
      end

      it_behaves_like 'when returns failed response'
    end

    context 'when the message in the hash has the key mensaje' do
      let(:response_body) do
        {
          code: Faker::Movies::BackToTheFuture.character,
          mensaje: Faker::Books::Lovecraft.paragraph
        }
      end

      it_behaves_like 'when returns failed response' do
        let(:message_key) { 'mensaje' }
      end
    end

    context 'when the message in the hash has the key title' do
      let(:response_body) do
        {
          title: Faker::TvShows::HowIMetYourMother.catch_phrase,
          mensaje: Faker::Books::Lovecraft.paragraph
        }
      end

      it_behaves_like 'when returns failed response'
    end

    context 'when the message in the hash has the key titulo' do
      let(:response_body) do
        {
          titulo: Faker::TvShows::HowIMetYourMother.catch_phrase,
          mensaje: Faker::Books::Lovecraft.paragraph
        }
      end

      it_behaves_like 'when returns failed response' do
        let(:title_key) { 'titulo' }
      end
    end

    context 'when the response_body is nil' do
      let(:response_body) { nil }
      let(:expected) do
        {
          message: nil,
          title: nil
        }
      end

      it 'maps the response correctly' do
        expect(subject).to eq(expected)
      end
    end
  end
end
