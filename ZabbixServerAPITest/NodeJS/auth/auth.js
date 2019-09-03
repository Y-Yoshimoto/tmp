// 認証トークン取得
//// リクエスト用jsonファイル読み込み
var auth = require( './auth.json' );
console.log(auth.id);

////リクエスト生成
var request = require('request');
var jar = request.jar();
var options = {
    url: 'http://192.168.1.116/api_jsonrpc.php',
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    json: true,
    json: auth,
    jar: jar
}
    console.log(options);

//// httpリクエスト
request(options, function (error, response, body) {
    console.log(error);
    //console.log(response);
    console.log(body);
    console.log(body.result);
    console.log(jar);
    //レスポンスJSONファイル出力
    var fs = require('fs');
    fs.writeFileSync('./authResult.json', JSON.stringify(body, null, '    '));
})
