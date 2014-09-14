class PostDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def_delegators :@view, :l, :link_to

  def sortable_columns
    @sortable_columns ||= ['posts.title', 'posts.responded', 'posts.ignored', 'posts.date_created', 'posts.date_modified']
  end

  def searchable_columns
    @searchable_columns ||= ['posts.title', 'posts.responded', 'posts.ignored', 'posts.date_created', 'posts.date_modified']
  end

  private

  def data
    records.map do |post|
      [
          link_to(post.title, post.url),
          post.responded,
          post.ignored,
          l(post.date_created),
          l(post.date_modified)
      ]
    end
  end

  def get_raw_records
    Post.all
    #Post.eager_load(:zone)
  end
end