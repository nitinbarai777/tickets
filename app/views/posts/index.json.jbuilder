json.array!(@posts) do |post|
  json.extract! post, :id, :name, :body, :rating, :published
  json.url post_url(post, format: :json)
end
