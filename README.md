# memoeb_v2


![](https://secure.meetupstatic.com/photos/event/8/2/d/b/highres_485253499.jpeg)
### Hackathon HackSmith v3.0 'Honorable Tool' award 2019

### features

* Listener hook on heap
* Reading heap memory
* String searchin in memory
* Pattern searching in memory
* Grepable log file


### usage


	$ ruby app.rb 'Dropbox'

verbose mode

	$ ruby app.rb 'Dropbox' verbose

# requirements

### ruby gems
* `gem install json`
* `gem install tty-prompt`

### frida
* `pip install frida-tools`

### to-do

* Android support 
* Direct writing in the heap
* Log filtration (incl. regexp)
* Tracing / stalking function calls in runtime*
* Looking for function calling address*

*need deeper research, but might be done 

### tested in env:

* iPhone 7 iOS 13.2.2 ([Jailbreak](https://checkra.in/))
* macOS Catalania 10.15.x 
* ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]
* frida 12.7.20

### say hi & licence

"THE BEER-WARE LICENSE" (Revision 0x00):
As long as you retain this notice you can do whatever you want with this stuff.
If we meet some day, and you think this stuff is worth it, you can buy us a beer in return.

Twitter: [@ansjdnakjdnajkd](https://twitter.com/ansjdnakjdnajkd) [@hd_421](https://twitter.com/hd_421)