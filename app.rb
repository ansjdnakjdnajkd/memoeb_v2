require 'json'

$app = ARGV[0]
$param = ARGV[1] #verbose
#remove log and create fresh
init = `touch ./log && rm ./log && touch ./log`
#read array from dict.json and close
$dict = File.readlines('./dict')
$dict.map! {|x| x.chomp }
$uniq = []

# proper exit from all inherit methods/programs after hitting Ctrl+C 
trap("SIGINT") { 
	puts "Shutting down."; 
	`killall -9 Python`
	Signal.trap("SIGTERM", "DEFAULT") # restore handler
	Process.kill("TERM", 0)           # kill this process with correct signal
	`sed '$s/,$//' ./log > ./log_mod1` # remove last comma

	# finalize json formatting 
	dict = File.readlines('./log_mod1')
	dict.map! {|x| x.chomp }

	f = File.open('log_mod', 'w')
	excl = ['[',']','"','\\','{','}']
	dict.each do |line|		
		if !excl.include? line[0]
			f.puts '"'+line.gsub('\\','\\\\\\\\').gsub('"','\"')+'",'
		else
			f.puts line
		end
	end
	f.close()
	# end finalizing	
        `cp template.html template_bak.html`
        `sed -i -e '/F4743CAD170C9488DEC39344E0CB25ED9CE357A5/r log_mod' template_bak.html` # modify template
        `sed '/F4743CAD170C9488DEC39344E0CB25ED9CE357A5/d' ./template_bak.html > output.html`
        `rm template_bak.html`
        `_now=$(date +"%H:%M_%d_%m_%Y") && mv ./log_mod ./log_$_now.json`
        `rm ./log_mod1 && rm ./log`
	exit
}

def scan
	while(true)
		$dict = File.readlines('./dict')
		$dict.map! {|x| x.chomp }
		$dict.each do |i|
			puts "Searching for [#{i}]\r\n"
			out = `frida -U -l mem.js -n '#{$app}' -e "run('#{i}')" -q `
			
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

# ARGV parse
if ARGV[1] != nil
	if ARGV[1].to_s == "-d"
		puts "[on] Dynamic mode"
		puts "Initial dictionary"
		p $dict
		puts "Output will be recorder inside log file"
		puts "Please hit Ctrl+C to finish the process"
		scan()
	elsif ARGV[1].to_s == "-s" 
		puts "[on] Static mode"
		`mkdir ./signsrch_result && mkdir ./dumpo_test` 
		`echo "Starting memory dump"`
        `frida-ps -Uai | grep '#{$app}'`
        `python3 ./fridump-master/fridump.py -U '#{$app}' -o ./dumpo_test`
        `strings ./dumpo_test/* >> ./dumpo_test/str_dump.txt`
    	`./signsrch_mac-master/signsrch ./dumpo_test >> ./result_static.txt` 
    	`rm -R ./signsrch_result && rm -R ./dumpo_test` 
	else
		puts "Error: Please refer to our help."
	end
else
	if ARGV[0] == '-h' or ARGV[0].to_s == '--help'
		puts "[Help]"
		puts "-h --help Help"
		puts "-d Dynamic mode"
		puts "-s Static mode"
		puts ""
		puts "[Example]"
		puts "$ ruby app.rb \"App Store\" -d"
		puts "$ ruby app.rb -h"
	else
		puts "Error: Please refer to our help."
	end
end
