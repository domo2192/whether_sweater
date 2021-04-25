class BackgroundFacade

  def self.get_background(location)
    background = PixelService.get_image(location)
    objectify_background(background, location)
  end

  def self.objectify_background(background, location)
    OpenStruct.new({        location: location,
                            image_url: background[:photos][0][:src][:original],
                            credit: credit_hash(background[:photos][0])
                     })
  end

  def self.credit_hash(background)
    {  source: "https://www.pexels.com",
       author: background[:photographer],
       author_url: background[:photographer_url]
    }
  end
end
