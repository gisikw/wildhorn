# frozen_string_literal: true
require 'spec_helper'

class EpisodeImpl
  extend Wildhorn::EpisodeCollection
  def initialize(arg)
  end
end

describe Wildhorn::EpisodeCollection do
  let(:subject) { EpisodeImpl }

  describe '.all' do
    it 'returns an episode for each post marked as a podcast' do
      allow(Dir).to receive(:glob)
        .with('_posts/*.md') { %w(episode1 episode2 post) }
      allow(YAML).to receive(:load_file) { { 'podcast' => true } }
      allow(YAML).to receive(:load_file).with('post') { { 'podcast' => nil } }
      allow(subject).to receive(:new).with('episode1') { 'episode1' }
      allow(subject).to receive(:new).with('episode2') { 'episode2' }
      expect(subject.all).to eql(%w(episode1 episode2))
    end
  end

  describe '.unuploaded' do
    it 'returns an episode for each post without a soundcloud_track' do
      old_episode = double('Episode', soundcloud_track: '123')
      new_episode = double('Episode', soundcloud_track: nil)
      allow(subject).to receive(:all) { [old_episode, new_episode] }
      expect(subject.unuploaded).to eql([new_episode])
    end
  end

  describe '.find_or_create_from_media' do
    let(:mp3_name) { 'TestMP3Episode.mp3' }
    let(:post_path) { '_posts/2012-12-12-test-mp3-episode.md' }
    let(:post_content) do
      Wildhorn::EpisodeCollection::TEMPLATE.gsub('_TITLE_', 'Test MP3 Episode')
                                           .gsub('_MP3_', mp3_name)
                                           .gsub('_DATE_', '2012-12-12')
    end

    before do
      allow(File).to receive(:read).with(post_path) { post_content }
      allow(Time).to receive(:new) { double('Time', strftime: '2012-12-12') }
    end

    it 'returns an episode with metadata from the post' do
      allow(Dir)
        .to receive(:glob).with('_posts/*test-mp3-episode.md') { [post_path] }
      expect(subject).to receive(:new).with(post_path)
      subject.find_or_create_from_media(mp3_name)
    end

    it 'creates a new post with default information if none exists' do
      allow(Dir)
        .to receive(:glob).with('_posts/*test-mp3-episode.md') { [] }
      expect(File)
        .to receive(:write)
        .with(post_path, post_content)
      subject.find_or_create_from_media(mp3_name)
    end
  end
end
