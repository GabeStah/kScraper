class ScrapeWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    secondly(120)
    #daily(1).hour_of_day(2)
  end

  def perform
    Post.populate_posts(page_count: 1)
  end
end