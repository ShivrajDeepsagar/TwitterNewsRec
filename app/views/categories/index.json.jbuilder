json.array!(@categories) do |category|
  json.extract! category, :id, :name, :google_url
  json.url category_url(category, format: :json)
end
