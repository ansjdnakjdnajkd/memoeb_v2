require 'json'
require 'tty-prompt'

$app = ARGV[0]
$param = ARGV[1] #verbose
#remove log and create fresh
init = `touch ./log && rm ./log && touch ./log`
#read array from dict.json and close
$dict = File.readlines('./dict')
$dict.map! {|x| x.chomp }
p $dict
$uniq = []

def scan
	while(true)
		$dict = File.readlines('./dict')
		$dict.map! {|x| x.chomp }
		$dict.each do |i|
			puts "Searching for [#{i}]\r\n"
			out = `frida -U -l mem.js -n '#{$app}' -e "run('#{i}')" -q`
	
			# puts out	
			if($uniq.include?(out) == false)
				$uniq.push(out)
				open('log', 'a') { |f|
				  f.puts out
				}
				if ($param == "verbose")
					puts out
				end
			else
				puts "No new data in memory\r\n"
			end
		end
		sleep(5)
	end
end

def parse_input(inp)
	arr = inp.gsub(/\s+/m, ' ').strip.split(" ")
	case arr[0]
	when 'exit'
	  exit
	when 'add'
	  "The tank is almost empty. Quickly, find a gas station!"
	when 'rem'
	  "You should be ok for now."
	when 'out'
	  puts File.readlines('./log')
	else
	  "Error: capacity has an invalid value"
	end

end

def get_update
	while(true)
		# clear_terminal #should be removed
		prompt = TTY::Prompt.new
		move = prompt.ask("Your command?\r\n", convert: :string) 
		puts move
		# clear_terminal
		parse_input(move)

		# current_turn(move)
	end
end

t1 = Thread.new{scan()}
t2 = Thread.new{get_update()}
t1.join
t2.join