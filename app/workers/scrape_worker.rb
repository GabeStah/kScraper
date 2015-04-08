class ScrapeWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: :priority

  recurrence do
    secondly(30)
  end

  def perform(page_count, thread_limit)
    page_count = 1 if !page_count || (page_count && (page_count.to_i > 50 || page_count.to_i < 0))
    thread_limit = 7 if !thread_limit || (thread_limit && (thread_limit.to_i > 100 || thread_limit.to_i < 0))
    Post.populate_posts(page_count, thread_limit)
  end
end
