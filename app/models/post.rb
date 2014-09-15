class Post < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'

  after_commit :schedule_response_scan

  validates :title,
            presence: true
  validates :topic_id,
            presence: true,
            uniqueness: true

  # t.string :title
  # t.string :url
  # t.boolean :responded
  # t.boolean :ignored

  def self.newer_than(date_time)
    where(date_created: date_time..Time.now)
  end

  def self.populate_posts(args = {})
    @posts = Array.new
    page_count = args[:page_count] ? args[:page_count] : 1
    page_count.times do |count|
      if count != 1
        page_suffix = "?page=#{count}"
      end
      doc = Nokogiri::HTML(open("http://us.battle.net/wow/en/forum/1011639/#{page_suffix}"))
      doc.xpath('//*[@id="forum-topics"]/tbody[@class="regular-topics sort-connect"]/tr').each do |item|
        topic_id = item.xpath('@data-topic-id').to_s.to_i
        title = item.xpath('td[@class="title-cell"]/a/span').text.to_s
        date_created = item.xpath('td[@class="title-cell"]/meta[@itemprop="dateCreated"]/@content').to_s.to_datetime
        date_modified = item.xpath('td[@class="title-cell"]/meta[@itemprop="dateModified"]/@content').to_s.to_datetime
        begin
          post = Post.find_by(topic_id: topic_id, title: title)
        rescue ActiveRecord::RecordNotUnique
          retry
        end
        # Responded
        if post
          # Update date modified if necessary
          post.update_attributes(date_modified: date_modified) if post.date_modified.to_datetime != date_modified
        else
          Post.create(topic_id: topic_id,
                      title: title,
                      ignored: false,
                      date_created: date_created,
                      date_modified: date_modified,
                      responded: false)
        end
      end
    end
    @posts
  end

  def find_response
    guild_url = '/wow/en/guild/hyjal/Vox%20Immortalis/'
    doc = Nokogiri::HTML(open("http://us.battle.net/wow/en/forum/topic/#{self.topic_id}"))
    pages = page_count(doc)
    doc.search('.topic-post').each do |item|
      guild = item.search('.guild a @href').to_s
      character = item.search('.bnet-username a span').text.to_s
      if guild != "" && guild == guild_url
        self.update_attributes(response_by: character, responded: true)
        return true
      end
    end
    # Loop extra pages if needed
    if pages
      pages.times do |count|
        if count > 0
          page_suffix = "?page=#{count+1}"
          doc = Nokogiri::HTML(open("http://us.battle.net/wow/en/forum/topic/#{self.topic_id}#{page_suffix}"))
          doc.search('.topic-post').each do |item|
            guild = item.search('.guild a @href').to_s
            character = item.search('.bnet-username a span').text.to_s
            if guild != "" && guild == guild_url
              self.update_attributes(response_by: character, responded: true)
              return true
            end
          end
        end
      end
    end
  end

  def page_count(doc)
    # NONE 14420052059
    # <div class="actions-right">
    # </div>
    # PAGINATION 14424152356
    # <div class="actions-right">
    # <ul class="ui-pagination">
    #   <li class="current">
    #     <a href="?page=1" data-pagenum="1">
    #       <span>1</span>
    #     </a>
    #   </li>
    #   <li>
    #     <a href="?page=2" data-pagenum="2"><span>2</span></a>
    #   </li>
    #   <li class="cap-item">
    #     <a class="page-next" href="?page=2" data-pagenum="2"><span>Next</span></a>
    #   </li>
    # </ul>
    # </div>
    #doc = Nokogiri::HTML(open("http://us.battle.net/wow/en/forum/topic/#{topic_id}"))
    max_page_num = 0
    doc.search('.actions-right ul[class=ui-pagination] li').each do |item|
      num = item.search('a @data-pagenum').to_s.to_i
      max_page_num = num if num && num > max_page_num
    end
    return max_page_num > 0 ? max_page_num : nil
  end

  def url
    "http://us.battle.net/wow/en/forum/topic/#{topic_id}"
  end

  private

  def schedule_response_scan
    ResponseWorker.perform_async(self.id)
  end
end
