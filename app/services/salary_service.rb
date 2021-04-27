class SalaryService

  @hold = Faraday.new url:  "https://api.teleport.org"

  def self.get_cities(destination)
    resp = Faraday.get( "https://api.teleport.org/api/cities/?") do |req|
    req.params[:search] = destination
  end
  search = JSON.parse(resp.body, symbolize_names: true)
  id = search[:_embedded][:"city:search-results"][0][:_links][:"city:item"][:href] # passes api call for specific id
     SalaryService.find_by_id(id)
  end

  def self.find_by_id(id)
    resp = Faraday.get(id)
    urban_link = JSON.parse(resp.body, symbolize_names: true)
    ua_id = urban_link[:_links][:'city:urban_area'][:href]
    SalaryService.find_salaries(ua_id)
  end

  def self.find_salaries(ua_id)
    resp = Faraday.get("#{ua_id}salaries/")
    JSON.parse(resp.body, symbolize_names: true)
  end
end
