t = Time.now

require 'open-uri'

max = nil
f = "proxy.txt"
s = ["spys.ru"]
ping = false
sort = false
threads = []
a = ""
verbose = false

def file(file)
	unless File.exist?(file) then
		puts file + " dont exist"
		help
	else
		IO.read(file)
	end
end

def get(host, verbose)
	host = "http://#{host}" unless host.include?("http")
	puts "get #{host}" if verbose
  rez = open(host).read
	puts "done #{host}" if verbose
	rescue
  	puts "Not Load #{host}" if verbose
  ensure 
  	return rez.to_s
end

def help
	puts IO.read("docs/help.txt")
	exit
end

ARGV.each_index{|i|
	case ARGV[i].chomp
		when "-l"
			s = file(ARGV[i+1].chomp).split
		when "-f"
			f = ARGV[i+1].chomp
		when "-vv"
			verbose = true
		when "-s"
			s = ARGV[i+1].chomp
		when "-s"
			sort = true
		when "-m"
			max = ARGV[i+1].chomp.to_i
		when "-h"
			help
	end
}

s.each{|host|
  threads << Thread.new{
    a += get(host, verbose)
  }
}
threads.each(&:join)

puts "Parsing" if verbose

ip = a.scan(/(?:(?:2[0-4]\d|25[0-5]|[1]?\d?\d)\.){3}(?:2[0-4]\d|25[0-5]|[1]?\d?\d):\d{2,}/)

puts "Find #{ip.size} proxys" if verbose

puts "Write to #{f}" if verbose

File.open(f, "w").puts ip

puts "Done #{Time.now-t}s" if verbose