json.array!(@posts) do |post|
  json.extract! post, :id, :title, :url, :responded, :ignored
  json.url post_url(post, format: :json)
end
