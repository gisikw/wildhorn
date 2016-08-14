require 'spec_helper'

describe Wildhorn::YouTube do
  describe '.make_public!(id)' do
    it 'makes a video public' do
      youtube_id = double
      fake_user = double
      video = double

      allow(Wildhorn::Config).to receive(:yt_user) { fake_user }
      allow(Yt::Video)
        .to receive(:new)
          .with(id: youtube_id, auth: fake_user) { video }

      expect(video).to receive(:update).with(privacy_status: 'public')

      subject.make_public!(youtube_id)
    end
  end
end
