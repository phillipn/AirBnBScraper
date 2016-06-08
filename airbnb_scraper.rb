require 'nokogiri'
require 'open-uri'

url = "https://www.airbnb.com/s/Brooklyn--NY--United-States"
 
page = Nokogiri::HTML(open(url))

page_numbers = []
page.css("div.pagination ul li a[target]").each do |line|
 page_numbers << line.text
end

max_page = page_numbers.max.to_i

name = []
price = []
details = []

max_page.times do |i|
  url = "https://www.airbnb.com/s/Brooklyn--NY--United-States?page=#{i+1}"
  
  page.css('div.h5.listing-name').each do |line|
    name << line.text
  end

  page.css('span.h3.price-amount').each do |line|
    price << line.text
  end

  page.css('div.text-muted.listing-location.text-truncate').each do |line|
    subarray = line.text.strip.split(/ · /)

    if subarray.length == 3
      details << subarray
    else
      details << [subarray[0], "0 reviews", subarray[1]]
    end
  end
end

CSV.open("airbnb_listings.csv", "w") do |file|
  file << ["Listing Name", "Price", "Room Type", "Reviews", "Location"]

  name.length.times do |i|
    file << [name[i], price[i], details[i][0], details[i][1], details[i][2]]
  end
end