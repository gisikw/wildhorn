# frozen_string_literal: true
require 'taglib'
module Wildhorn
  # Handle ID3 tagging of podcast episodes
  module Tagger
    module_function

    def tag_mp3_file(episode)
      TagLib::MPEG::File.open(episode.mp3_path) do |mp3|
        tag = mp3.id3v2_tag
        apply_standard_tags(tag, episode)
        apply_artwork(tag, episode)
        mp3.save
      end
    end

    private

    module_function

    def apply_artwork(tag, episode)
      art = TagLib::ID3v2::AttachedPictureFrame.new
      art.mime_type = 'image/jpeg'
      art.description = 'Media'
      art.type = TagLib::ID3v2::AttachedPictureFrame::Media
      art.picture = episode.artwork
      tag.add_frame(art)
    end

    def apply_standard_tags(tag, episode)
      tag.title = episode.title
      tag.artist = episode.artist
      tag.album = episode.album
      tag.genre = 'Podcast'
      tag.comment = episode.description
      tag.year = episode.year
    end
  end
end
