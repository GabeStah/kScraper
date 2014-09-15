class PostDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def_delegators :@view, :l, :link_to, :toggle_ignored_post_path, :fa_icon, :time_ago_in_words

  def sortable_columns
    @sortable_columns ||= ['posts.response_by', 'posts.title', 'posts.date_created', 'posts.date_modified']
  end

  def searchable_columns
    @searchable_columns ||= ['posts.response_by', 'posts.title']
  end

  private

  def data
    records.map do |post|
      ignored_icon = link_to(post.ignored ? nil : fa_icon('close lg'), toggle_ignored_post_path(post), remote: true, method: :post, id: "ignored_link_#{post.id}")
      post_icon = post.responded ? fa_icon('check-square-o lg', data: { responder: post.response_by }) : nil
      [
        "#{ignored_icon} #{post_icon}",
        link_to(post.title, post.url),
        time_ago_in_words(post.date_created, include_seconds: true),
        time_ago_in_words(post.date_modified, include_seconds: true)
      ]
    end
  end

  def get_raw_records
    Post.where(ignored: false)
    #Post.eager_load(:zone)
  end
end