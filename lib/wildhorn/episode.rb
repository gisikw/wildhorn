# frozen_string_literal: true
require 'yaml'

module Wildhorn
  # Encapsulate Episode data stored in Jekyll posts
  class Episode
    TEMPLATE = <<~END
      ---
      podcast: true
      title: _TITLE_
      genre:
      soundcloud_track:
      description:
      media: _MP3_
      date: _DATE_
      ---

      TODO
    END

    class << self
      def all
        Dir.glob('_posts/*.md')
           .select { |post| YAML.load_file(post)['podcast'] }
           .map { |post| new(post) }
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

    def initialize(post)
      parse(post)
    end

    def save
      File.write(@path, "#{@metadata.to_yaml}---\n\n#{@body}\n")
    end

    private

    def method_missing(method_sym, *args, &block)
      @metadata.key?(method_sym.to_s) ? @metadata[method_sym.to_s] : super
    end

    def respond_to_missing?(method_sym, include_private = false)
      @metadata.key?(method_sym.to_s) || super
    end

    def parse(post)
      text = File.read(post)
      @metadata = YAML.load(text)
      @body = text.split('---')[2].lstrip
      @path = post
    end
  end
end
