// 認証トークン取得
var test = require( "./auth.json" );
console.log(test.id);

var request = require('request');
var options = {
    url: 'http://centos7ks/api_jsonrpc.php',
    method: 'POST',
    headers: "Content-Type: application/json-rpc",
    json: true,
    form: test
}
    console.log(options);
request(options, function (error, response, body) {
    console.log(body);
})
