class BackgroundSerializer
  include FastJsonapi::ObjectSerializer
  set_id :id
  set_type :image
  attributes :location, :image_url, :credit
end
