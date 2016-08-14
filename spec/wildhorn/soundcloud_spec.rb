require 'spec_helper'

describe Wildhorn::SoundCloud do
  let(:episode) do
    double('Episode',
           title: double, description: double, genre: double,
           mp3: double, artwork: double, soundcloud_track: '123')
  end

  describe '.upload!(episode)' do
    it 'uploads the episode to SoundCloud and returns the track id' do
      soundcloud = double
      track_id = double
      track_details = double
      post_response = double('Response', id: track_id)

      expect(subject).to receive(:track_details).with(episode) { track_details }
      expect(Wildhorn::Config).to receive(:soundcloud) { soundcloud }
      expect(soundcloud)
        .to receive(:post)
          .with('/tracks', track_details) { post_response }

      expect(subject.upload!(episode)).to eql(track_id)
    end
  end

  describe '.track_details(episode)' do
    it 'returns the relevant information for SoundCloud' do
      expect(subject.track_details(episode)).to eql(
        track: {
          title: episode.title,
          description: episode.description,
          genre: episode.genre,
          track_type: 'podcast',
          asset_data: episode.mp3,
          artwork_data: episode.artwork,
          sharing: 'private'
        }
      )
    end
  end

  describe '.publish!(episode)' do
    it 'sets the episode track to public' do
      soundcloud = double
      expect(Wildhorn::Config).to receive(:soundcloud) { soundcloud }
      expect(soundcloud)
        .to receive(:put)
        .with(
          "/tracks/#{episode.soundcloud_track}",
          track: { sharing: 'public' }
        )

      subject.publish!(episode)
    end
  end
end
