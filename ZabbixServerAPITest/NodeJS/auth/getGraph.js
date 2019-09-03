// グラフ出力
var authResult = require( './authResult.json' );
console.log(authResult.result);

var request = require('request');
var jar = request.jar();
console.log(jar);

////リクエスト生成
var request = require('request');
var options = {
    url: 'http://192.168.1.116/chart2.php?graphid=524',
    method: 'GET',
    headers: {'Content-Type':'application/json'},
    jar: jar
}
    console.log(options);

//// httpリクエスト
request(options, function (error, response, body) {
    console.log(error);
    //console.log(response);
    console.log(body);
    console.log(jar);
    var fs = require('fs');
    fs.writeFileSync('./graph.png',body);
})
