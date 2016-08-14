require 'yt'

module Wildhorn
  # Handle interaction with podcast videos hosted on YouTube
  module YouTube
    module_function

    def make_public!(youtube_id)
      video = Yt::Video.new id: youtube_id, auth: Wildhorn::Config.yt_user
      video.update privacy_status: 'public'
    end
  end
end
