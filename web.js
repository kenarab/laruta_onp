var express = require('express');
var http = require('http');
var gzippo = require('gzippo');
var app = express();
app.use(express.logger());
app.use(gzippo.staticGzip('' + __dirname));
var server = http.createServer(app);
server.listen(process.env.PORT || 5000);