# frozen_string_literal: true
module Wildhorn
  # Handle interaction with podcast audio hosted on SoundCloud
  module SoundCloud
    module_function

    def upload!(episode)
      soundcloud = Wildhorn::Config.soundcloud
      soundcloud.post('/tracks', track_details(episode)).id
    end

    def track_details(episode)
      { track: {
        title: episode.title,
        description: episode.description,
        genre: episode.genre,
        track_type: 'podcast',
        asset_data: episode.mp3,
        artwork_data: episode.artwork,
        sharing: 'private',
        release_year: episode.year,
        release_month: episode.month,
        release_day: episode.day
      } }
    end

    def publish!(episode)
      Wildhorn::Config.soundcloud.put(
        "/tracks/#{episode.soundcloud_track}",
        track: { sharing: 'public' }
      )
    end
  end
end
