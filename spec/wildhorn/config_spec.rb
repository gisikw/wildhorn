require 'spec_helper'

describe Wildhorn::Config do
  let(:subject) { Wildhorn::Config }

  describe '.yt_user' do
    let(:username) { double }
    let(:refresh_token) { double }
    let(:client_id) { double }
    let(:client_secret) { double }

    before :each do
      subject.credentials[:youtube] = {
        username: username,
        refresh_token: refresh_token,
        client_id: client_id,
        client_secret: client_secret
      }
    end

    it 'sets YouTube auth params' do
      config = double
      expect(config).to receive(:client_id=).with(client_id)
      expect(config).to receive(:client_secret=).with(client_secret)
      expect(Yt).to receive(:configure).and_yield(config)
      subject.yt_user
    end

    it 'returns a YouTube user' do
      fake_user = double
      allow(Yt::ContentOwner)
        .to receive(:new)
          .with(
            owner_name: username,
            refresh_token: refresh_token
          ) { fake_user }

      expect(subject.yt_user).to eql(fake_user)
    end
  end
end
