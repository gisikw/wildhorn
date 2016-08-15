# frozen_string_literal: true
require 'spec_helper'

describe Wildhorn::Episode do
  let(:mp3_name) { 'TestMP3Episode.mp3' }
  let(:post_path) { '_posts/2012-12-12-test-mp3-episode.md' }
  let(:subject) do
    allow_any_instance_of(described_class).to receive(:parse)
    described_class.new(post_path).tap do |episode|
      episode.instance_variable_set(:@metadata,
                                    'media' => mp3_name, 'date' => '2012-12-12')
      episode.instance_variable_set(:@body, 'TODO')
      episode.instance_variable_set(:@path, post_path)
    end
  end

  describe '#save' do
    it 'saves the front matter and body to the post' do
      subject.instance_variable_set(:@metadata, 'meta_field' => 'meta_val')
      expect(File).to receive(:write).with(
        post_path,
        <<~END
          ---
          meta_field: meta_val
          ---

          TODO
        END
      )
      subject.save
    end
  end

  describe '#album' do
    it 'returns "Code Monkey Podcast"' do
      expect(subject.album).to eql('Code Monkey Podcast')
    end
  end

  describe '#artist' do
    it 'returns "Kevin Gisi and Alex Bragdon"' do
      expect(subject.artist).to eql('Kevin Gisi and Alex Bragdon')
    end
  end

  describe '#artwork' do
    it 'returns the artwork file in binary format' do
      artwork_path = double
      binary_artwork = double
      allow(Wildhorn::Config).to receive(:artwork_path) { artwork_path }
      allow(File)
        .to receive(:read)
          .with(artwork_path, mode: 'rb') { binary_artwork }
      expect(subject.artwork).to eql(binary_artwork)
    end
  end

  describe '#genre' do
    it 'returns "Technology"' do
      expect(subject.genre).to eql('Technology')
    end
  end

  describe '#mp3_path' do
    it 'returns the mp3 path' do
      expect(subject.mp3_path).to eql("_episodes/#{mp3_name}")
    end
  end

  describe '#mp3' do
    it 'returns the mp3 file in binary format' do
      binary_mp3 = double
      allow(File)
        .to receive(:read)
          .with("_episodes/#{mp3_name}", mode: 'rb') { binary_mp3 }
      expect(subject.mp3).to eql(binary_mp3)
    end
  end

  describe '#publish' do
    it 'calls SoundCloud.publish!' do
      expect(Wildhorn::SoundCloud).to receive(:publish!)
      subject.publish
    end
  end

  describe '#upload' do
    it 'uploads to SoundCloud and saves the track id' do
      allow(Wildhorn::SoundCloud).to receive(:upload!) { '123' }
      expect(subject).to receive(:save)
      subject.upload
      expect(subject.soundcloud_track).to eql('123')
    end
  end

  describe '#year' do
    it 'returns the year component of the date metadata' do
      expect(subject.year).to eql('2012')
    end
  end
end
