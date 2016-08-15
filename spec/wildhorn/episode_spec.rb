# frozen_string_literal: true
require 'spec_helper'

describe Wildhorn::Episode do
  describe '#save' do
    it 'saves the front matter and body to the post' do
      post_path = double
      allow_any_instance_of(described_class).to receive(:parse)
      subject = described_class.new(post_path)
      subject.instance_variable_set(:@metadata, 'meta_field' => 'meta_val')
      subject.instance_variable_set(:@body, 'TODO')
      subject.instance_variable_set(:@path, post_path)
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

  # Are implied to exist...
  describe '#genre'
  describe '#mp3'
  describe '#artwork'
  describe '#mp3_path'
  describe '#artist'
  describe '#album'
  describe '#year'
end
