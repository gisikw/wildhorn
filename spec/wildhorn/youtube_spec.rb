# frozen_string_literal: true
require 'spec_helper'

describe Wildhorn::YouTube do
  let(:youtube_id) { double }
  let(:fake_user) { double }
  let(:video) { double }
  let(:episode) do
    double('Episode', title: 'test title', description: 'test description',
                      youtube_id: youtube_id)
  end

  before do
    allow(Wildhorn::Config).to receive(:yt_user) { fake_user }
    allow(Yt::Video).to receive(:new) { video }
  end

  describe '.update!(episode)' do
    it 'adds the appropriate metadata to the video' do
      body = <<~END
        ## Show Notes

        * [Google](http://google.com)
      END
      allow(episode).to receive(:body) { body }
      expect(video).to receive(:update).with(
        tags: ['Code Monkey Podcast', 'Podcast'],
        title: 'Code Monkey Podcast - test title',
        description: <<~END
          test description

          Show Notes
          Google (http://google.com)
        END
      )
      subject.update!(episode)
    end
  end

  describe '.publish!(episode)' do
    it 'makes the episode video public' do
      episode = double('Episode', youtube_id: youtube_id)
      expect(video).to receive(:update).with(privacy_status: 'public')
      subject.publish!(episode)
    end
  end
end
