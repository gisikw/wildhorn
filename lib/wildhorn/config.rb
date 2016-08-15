# frozen_string_literal: true
#
require 'yt'
require 'soundcloud'

module Wildhorn
  # Manages project-level configuration details
  module Config
    module_function

    def opts
      @opts ||= {}
    end

    def artwork_path
      @opts[:artwork_path]
    end

    def yt_user
      Yt.configure do |config|
        config.client_id = opts[:youtube][:client_id]
        config.client_secret = opts[:youtube][:client_secret]
      end
      Yt::ContentOwner.new(
        owner_name: opts[:youtube][:username],
        refresh_token: opts[:youtube][:refresh_token]
      )
    end

    def soundcloud
      ::SoundCloud.new(opts[:soundcloud])
    end
  end
end
