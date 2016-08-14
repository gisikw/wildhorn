require 'yt'
require 'soundcloud'

module Wildhorn
  # Manages project-level configuration details
  module Config
    module_function

    def credentials
      @credentials ||= {}
    end

    def yt_user
      Yt.configure do |config|
        config.client_id = credentials[:youtube][:client_id]
        config.client_secret = credentials[:youtube][:client_secret]
      end
      Yt::ContentOwner.new(
        owner_name: credentials[:youtube][:username],
        refresh_token: credentials[:youtube][:refresh_token]
      )
    end

    def soundcloud
      ::SoundCloud.new(credentials[:soundcloud])
    end
  end
end
