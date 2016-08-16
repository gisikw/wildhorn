# frozen_string_literal: true
require 'redcarpet'
require 'redcarpet/render_strip'
module Wildhorn
  # Handle interaction with podcast videos hosted on YouTube
  module YouTube
    module_function

    def update!(episode)
      video(episode).update(
        tags: ['Code Monkey Podcast', 'Podcast'],
        title: "Code Monkey Podcast - #{episode.title}",
        description: sanitized_description(episode)
      )
    end

    def publish!(episode)
      video(episode).update privacy_status: 'public'
    end

    private

    module_function

    def sanitized_description(episode)
      md = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      "#{episode.description}\n\n#{md.render(episode.body)}"
    end

    def video(episode)
      Yt::Video.new id: episode.youtube_id, auth: Wildhorn::Config.yt_user
    end
  end
end
