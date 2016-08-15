# frozen_string_literal: true
require 'spec_helper'

describe Wildhorn::Episode do
  describe '.all' do
    it 'returns an episode for each post marked as a podcast' do
      allow(Dir).to receive(:glob)
        .with('_posts/*.md') { %w(episode1 episode2 post) }
      allow(YAML).to receive(:load_file) { { 'podcast' => true } }
      allow(YAML).to receive(:load_file).with('post') { { 'podcast' => nil } }
      allow(described_class).to receive(:new).with('episode1') { 'episode1' }
      allow(described_class).to receive(:new).with('episode2') { 'episode2' }
      expect(described_class.all).to eql(%w(episode1 episode2))
    end
  end

  describe '.find_or_create_from_media' do
    let(:mp3_name) { 'TestMP3Episode.mp3' }
    let(:post_path) { '_posts/2012-12-12-test-mp3-episode.md' }
    let(:post_content) do
      Wildhorn::Episode::TEMPLATE.gsub('TITLE', 'Test MP3 Episode')
    end

    before do
      allow(File).to receive(:read).with(post_path) { post_content }
      allow(Time).to receive(:new) { double('Time', strftime: '2012-12-12') }
    end

    it 'returns an episode with metadata from the post' do
      allow(Dir)
        .to receive(:glob).with('_posts/*test-mp3-episode.md') { [post_path] }
      expect(
        described_class.find_or_create_from_media(mp3_name).title
      ).to eq('Test MP3 Episode')
    end

    it 'creates a new post with default information if none exists' do
      allow(Dir)
        .to receive(:glob).with('_posts/*test-mp3-episode.md') { [] }
      expect(File)
        .to receive(:write)
        .with(post_path, post_content)
      described_class.find_or_create_from_media(mp3_name)
    end
  end
end
