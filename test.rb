require 'net/http'
require 'socket'

page = '/'


a =  Net::HTTP.start('spys.ru').get(page).body
h = Hash.new
a.scan(/(?:(?:2[0-4]\d|25[0-5]|[1]?\d?\d)\.){3}(?:2[0-4]\d|25[0-5]|[1]?\d?\d):\d{2,}/){|r|
	h[r] = 0
}

all = h.size
i = 0

h.each {|key, value|
	i +=1
	puts (i.to_f/all*100).floor.to_s + "%"
	host = key.split ":"
	host = host[0]
	output = `ping #{host}`
	h[key] =  output.lines[-1].scan(/\d+/)[-1]
}
File.open("proxy.txt", "w").puts h.sort{|a,b| a[1]<=>b[1]}
puts h.sort{|a,b| a[1]<=>b[1]}