# frozen_string_literal: true
require 'spec_helper'

describe Wildhorn::Config do
  let(:subject) { Wildhorn::Config }

  let(:youtube_creds) do
    { username: double, refresh_token: double,
      client_id: double, client_secret: double }
  end

  let(:soundcloud_creds) do
    { client_id: double, client_secret: double,
      username: double, password: double }
  end

  before :each do
    subject.credentials.merge!(youtube: youtube_creds,
                               soundcloud: soundcloud_creds)
  end

  describe '.yt_user' do
    it 'sets YouTube auth params' do
      config = double
      expect(config).to receive(:client_id=).with(youtube_creds[:client_id])
      expect(config)
        .to receive(:client_secret=)
        .with(youtube_creds[:client_secret])
      expect(Yt).to receive(:configure).and_yield(config)
      subject.yt_user
    end

    it 'returns a YouTube user' do
      fake_user = double
      allow(Yt::ContentOwner)
        .to receive(:new)
          .with(
            owner_name: youtube_creds[:username],
            refresh_token: youtube_creds[:refresh_token]
          ) { fake_user }
      expect(subject.yt_user).to eql(fake_user)
    end
  end

  describe '.soundcloud' do
    it 'returns a credentialed SoundCloud client' do
      soundcloud_client = double
      expect(SoundCloud)
        .to receive(:new)
          .with(hash_including(soundcloud_creds)) { soundcloud_client }
      expect(subject.soundcloud).to eql(soundcloud_client)
    end
  end
end
