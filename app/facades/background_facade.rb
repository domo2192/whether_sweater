class BackgroundFacade

  def self.get_background(location)
    background = PixelService.get_image(location)
    if background[:photos].empty?
      error_background(background,location)
    else
      objectify_background(background, location)
    end
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

  def self.error_background(background,location)
    OpenStruct.new({        location: location,
                            image_url: "No images match that location",
                            credit: "Nobody took no pictures of that!!!"
                     })
  end
end
