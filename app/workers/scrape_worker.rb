class ScrapeWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: :priority

  recurrence do
    minutely(1)
  end

  def perform(page_count)
    page_count = 1 if page_count && page_count.to_i > 50
    Post.populate_posts(page_count)
  end
end