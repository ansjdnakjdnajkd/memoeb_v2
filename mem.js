function run(search) {

	var ranges = Process.enumerateRangesSync({
		protection: 'r--',
		coalesce: true
	});
	var range = 1;
	var str = search;
	var pattern = str.split('').map(function (l) {
		return l.charCodeAt(0).toString(16)
	}).join(' ');

	while (range) {
		range = ranges.pop()

		try {
			var res = Memory.scanSync(range.base, range.size, pattern);
			if (res.length > 0) {
				res.forEach(function (item) {
					var address = item.address
					var size = item.size
					// for json
					console.log("{")
					console.log('\"string\":\"' + str + '\",');
					console.log('\"addr\":\"' + address.toString() + '\",');
					if (typeof range.file !== 'undefined') {
						console.log('\"path\":\"' + range.file.path + '\",');
					} else {
						console.log('\"path\":\"\",');
					}
					console.log('\"pattern\":\"' + pattern + '\",');

					console.log('\"dump\":[');
					console.log(Memory.readByteArray(ptr(address).sub(0x32), 0x60));
					console.log(']');
					console.log("},")

				});
			}
		} catch (e) {
			// console.warn(e);
		}
	}

}