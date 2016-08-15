# frozen_string_literal: true
module Wildhorn
  # Encapsulate Episode data stored in Jekyll posts
  class Episode
    extend EpisodeCollection

    def initialize(post)
      parse(post)
    end

    def save
      File.write(@path, "#{@metadata.to_yaml}---\n\n#{@body}\n")
    end

    def album
      'Code Monkey Podcast'
    end

    def artist
      'Kevin Gisi and Alex Bragdon'
    end

    def artwork
      File.read(Config.artwork_path, mode: 'rb')
    end

    def genre
      'Technology'
    end

    def mp3_path
      "_episodes/#{media}"
    end

    def mp3
      File.read(mp3_path, mode: 'rb')
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
