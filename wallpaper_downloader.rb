require 'mechanize'
require 'uri'
require 'snooby'

# Set some common things
FileUtils.mkdir_p 'images'

# Using Mechanize
def get_r_wallpaper(url)
	link_strings = []
	agent = Mechanize.new
	page = agent.get(url)
	page.links_with(:href => /jpg/).each do |link|
		link_string = link.href.to_s
		(link_strings ||= []) << link_string
	end
	return link_strings
end

# Using Snoo
def get_wallpaper(subreddit, count)
	link_strings = []
	reddit = Snooby::Client.new
	r = reddit.r(subreddit)
	r.posts(count).each do |id|
		url_string = id.url.to_s
		if url_string.include? "jpg"
			(link_strings ||= []) << url_string
		end
	end
	return link_strings
end

# Do the Actual Download
def download_wallpaper(links)
	links.uniq.each do |url|
		agent = Mechanize.new
		agent.pluggable_parser.default = Mechanize::FileSaver
		uri = URI.parse(url)
		agent.get(url).save("images/#{File.basename(uri.path)}")
	end
end

# Using get_wallpaper
links = get_wallpaper("wallpapers", 500)

# Using get_r_wallpaper
#wallpaper_url = "www.reddit.com/r/wallpapers/?limit=100"
#links = get_r_wallpaper(wallpaper_url)

# Download
download_wallpaper(links)