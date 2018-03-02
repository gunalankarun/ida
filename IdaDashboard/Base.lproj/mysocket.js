var net = require('net');
var JsonSocket = require('json-socket');
var port1 = 4545;
var server = net.createServer();

server.listen(port1);
server.on('connection', function(socket) {
    liste=[];
    object={};
    liste.push(socket.remoteAddress);
    console.log(liste);
    socket = new JsonSocket(socket);
    var n;
    var isRunning = false;
    var streatTimeout;
    
    socket.on('data', function(data) {
        var str= data.toString();
        console.log("veri : "+data.toString());    
        var array = str.split(',');
        console.log(array);
        io.emit(array[0],array)
    });
});