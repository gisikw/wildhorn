# frozen_string_literal: true
require 'yaml'

module Wildhorn
  # Encapsulate Episode data stored in Jekyll posts
  class Episode
    TEMPLATE = <<~END
      ---
      podcast: true
      title: TITLE
      ---

      TODO
    END

    class << self
      def find_or_create_from_media(mp3_name)
        new(
          Dir.glob("_posts/*#{to_slug(mp3_name)}.md")[0] ||
          create_post(mp3_name)
        )
      end

      private

      def create_post(mp3_name)
        path = "_posts/#{Time.new.strftime('%F')}-#{to_slug(mp3_name)}.md"
        File.write(path, TEMPLATE.gsub('TITLE', to_title(mp3_name)))
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
      @metadata = parse(post)
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
      YAML.load(text).merge('body' => text.split('---')[2].lstrip)
    end
  end
end
