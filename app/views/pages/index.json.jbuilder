json.array!(@pages) do |page|
  json.extract! page, :title, :permalink, :body
  json.url page_url(page, format: :json)
end
