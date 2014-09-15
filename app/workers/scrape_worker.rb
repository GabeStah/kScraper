class ScrapeWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: :priority

  recurrence do
    secondly(120)
  end

  def perform
    Post.populate_posts(page_count: 1)
  end
end