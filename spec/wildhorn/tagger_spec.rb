# frozen_string_literal: true
require 'spec_helper'

describe Wildhorn::Tagger do
  describe '.tag_mp3_file' do
    let(:tag) { OpenStruct.new }
    let(:episode) do
      double('Episode', mp3_path: double, title: double, artist: double, album:
             double, description: double, year: double, artwork: double)
    end
    let(:mp3) { double('MP3', id3v2_tag: tag) }
    let(:art) { OpenStruct.new }

    before do
      allow(tag).to receive(:add_frame)
      allow(mp3).to receive(:save)
      allow(TagLib::ID3v2::AttachedPictureFrame).to receive(:new) { art }
      allow(TagLib::MPEG::File)
        .to receive(:open)
        .with(episode.mp3_path)
        .and_yield(mp3)
    end

    it 'applies tags to the source media' do
      Wildhorn::Tagger.tag_mp3_file(episode)
      expect(tag).to have_attributes(
        title: episode.title,
        artist: episode.artist,
        album: episode.album,
        genre: 'Podcast',
        comment: episode.description,
        year: episode.year
      )
    end

    it 'adds artwork to the source media' do
      expect(tag).to receive(:add_frame).with(art)
      Wildhorn::Tagger.tag_mp3_file(episode)
      expect(art).to have_attributes(
        mime_type: 'image/jpeg',
        description: 'Media',
        type: TagLib::ID3v2::AttachedPictureFrame::Media,
        picture: episode.artwork
      )
    end

    it 'calls save on the mp3' do
      expect(mp3).to receive(:save)
      Wildhorn::Tagger.tag_mp3_file(episode)
    end
  end
end
