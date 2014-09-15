class RefreshWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    minutely(5)
    #daily(1).hour_of_day(2)
  end

  def perform
    posts = Post.newer_than(4.week.ago).where(responded: false, ignored: false)
    posts.each do |post|
      # Update response data
      post.find_response
    end
  end
end