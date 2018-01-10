const socket = io('wss://streamer.cryptocompare.com');

    socket.emit('SubAdd', { subs: ['5~CCCAGG~BTC~USD'] } );
    socket.on("m", function(message) {
		console.log(message);
	});