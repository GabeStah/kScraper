class PostDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def_delegators :@view, :l, :link_to, :toggle_ignored_post_path, :fa_icon, :time_ago_in_words

  def sortable_columns
    @sortable_columns ||= ['posts.response_by', 'posts.title', 'posts.author_name', 'posts.date_created', 'posts.date_modified', 'posts.response_by']
  end

  def searchable_columns
    @searchable_columns ||= ['posts.response_by', 'posts.title', 'posts.author_name', 'posts.response_by']
  end

  private

  def data
    records.map do |post|
      ignored_icon = link_to(post.ignored ? nil : fa_icon('close lg'), toggle_ignored_post_path(post), remote: true, method: :post, id: "ignored_link_#{post.id}")
      post_icon = post.responded ? fa_icon('check-square-o lg', data: { responder: post.response_by }) : nil
      if post.post_content?
        post_link = link_to(post.title, post.url, class: 'post-link', data: { tip: post.post_content })
      else
        post_link = link_to(post.title, post.url, class: 'post-link')
      end

      if post.response_content?
        response_link = link_to(post.response_by, post.response_url, class: 'response-link', data: { tip: post.response_content })
      elsif post.response_url
        response_link = link_to(post.response_by, post.response_url, class: 'response-link')
      else
        response_link = post.response_by
      end
      [
        "#{ignored_icon} #{post_icon}",
        post_link,
        post.author_armory ? link_to(post.author_name, post.author_armory) : post.author_name ? post.author_name : nil,
        time_ago_in_words(post.date_created, include_seconds: true),
        time_ago_in_words(post.date_modified, include_seconds: true),
        response_link
      ]
    end
  end

  def get_raw_records
    Post.where(ignored: false)
    #Post.eager_load(:zone)
  end
end