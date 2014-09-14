class Post < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'

  validates :title,
            presence: true
  validates :topic_id,
            presence: true,
            uniqueness: true

  # t.string :title
  # t.string :url
  # t.boolean :responded
  # t.boolean :ignored

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
        # TODO Create worker to update Post record based on found response.
        response_character = check_response(topic_id)
        if post
          post.update_attributes(response_by: response_character,
                                 responded: response_character ? true : false,
                                 ignored: false,
                                 date_created: date_created,
                                 date_modified: date_modified)
        else
          Post.create(topic_id: topic_id,
                      title: title,
                      response_by: response_character,
                      responded: response_character ? true : false,
                      ignored: false,
                      date_created: date_created,
                      date_modified: date_modified)
        end
      end
    end
    @posts
  end

  def self.update_response(id)
    # TODO Create worker to update Post record based on found response.
  end

  def self.check_response(id)
    vox_url = '/wow/en/guild/hyjal/Vox%20Immortalis/'
    doc = Nokogiri::HTML(open("http://us.battle.net/wow/en/forum/topic/#{id}"))
    doc.search('.topic-post').each do |item|
      guild = item.search('.guild a @href').to_s
      character = item.search('.bnet-username a span').text.to_s
      # Match
      return character if guild != "" && guild == vox_url
    end
    return nil
  end

  def url
    "http://us.battle.net/wow/en/forum/topic/#{topic_id}"
  end
end
