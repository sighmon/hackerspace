json.array!(@memberships) do |membership|
  json.extract! membership, :user_id, :valid_from, :duration
  json.url membership_url(membership, format: :json)
end
