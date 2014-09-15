class ResponseWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find_by(id: post_id)
    if post && post.responded == false
      post.find_response
    end
  end
end