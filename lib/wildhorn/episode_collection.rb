# frozen_string_literal: true
module Wildhorn
  # Finders and static logic for Episodes
  module EpisodeCollection
    TEMPLATE = <<~END
      ---
      podcast: true
      title: _TITLE_
      media: _MP3_
      date: _DATE_
      layout: post
      soundcloud_track:
      youtube_id:
      description:
      public: false
      ---

      TODO
    END

    def all
      Dir.glob('_posts/*.md')
         .select { |post| YAML.load_file(post)['podcast'] }
         .map { |post| new(post) }
    end

    def unuploaded
      all.reject(&:soundcloud_track)
    end

    def find_or_create_from_media(mp3_name)
      new(
        Dir.glob("_posts/*#{to_slug(mp3_name)}.md")[0] ||
        create_post(mp3_name)
      )
    end

    private

    def create_post(mp3_name)
      path = "_posts/#{Time.new.strftime('%F')}-#{to_slug(mp3_name)}.md"
      File.write(
        path,
        TEMPLATE.gsub('_TITLE_', to_title(mp3_name))
                .gsub('_MP3_', mp3_name)
                .gsub('_DATE_', Time.new.strftime('%F'))
      )
      path
    end

    def to_slug(filename)
      filename.split('.')[0].gsub(/([a-z\d])([A-Z])/, '\1-\2').downcase
    end

    def to_title(filename)
      filename.split('.')[0].gsub(/([a-z\d])([A-Z])/, '\1 \2')
    end
  end
end
