class BackgroundFacade

  def self.get_background(location)
    background = PixelService.get_image(location)
    objectify_background(background, location)
  end

  def self.objectify_background(background, location)
    OpenStruct.new({image: {location: location,
                            image_url: background[:photos][0][:src][:original],
                            credit: { source: "https://www.pexels.com",
                                      author: background[:photos][0][:photographer],
                                      author_url: background[:photos][0][:photographer_url]

                                    }
                            }
                    })
  end
end
