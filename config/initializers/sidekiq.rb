if Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://192.168.149.153:6379/0' }
  end
end

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      [BackgroundJob, CacheRefreshJob, ScriptDeleteJob, ConsecutiveBadRatingsJob].each do |worker_class|
        worker_class.perform_later unless worker_class.enqueued?
      end
    end
  end
end
