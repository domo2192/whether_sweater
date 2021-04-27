class SalariesSerializer
  include FastJsonapi::ObjectSerializer
  attributes :destination, :forecast, :salaries
  set_id :id
end
