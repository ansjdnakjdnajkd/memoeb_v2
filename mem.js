function run(search){

	var ranges = Process.enumerateRangesSync({protection: 'r--', coalesce: true});
	var range = 1;
	var str = search;
	var pattern = str.split('').map(function (l) { return l.charCodeAt(0).toString(16) }).join(' ');
	console.log('Looking for: ' + str);
	console.log(pattern + ' PATTERN');
	
	while(range){
		range = ranges.pop()
			   
		try {
			var res = Memory.scanSync(range.base, range.size, pattern);
			if (res.length > 0){				
				res.forEach(function (item) {
					var address = item.address
					var size = item.size
					console.log('[+] ' + str + ' | found at: ' + address.toString());
					console.log('PATTERN: ' + pattern);
					//ref: https://qbdi.readthedocs.io/en/stable/frida_usage.html#read-memory
					console.log(Memory.readByteArray(ptr(address.toString()-0x64),0x120));			    
				});
			}
		} catch (e) {
			// console.warn(e);
		}
	}

}

