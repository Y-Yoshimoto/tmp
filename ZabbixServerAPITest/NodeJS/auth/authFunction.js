var test = authZabbix();
console.log("main");
console.log(test);
console.log("end");

function authZabbix(){
    var auth = require( './auth.json' );
    console.log(auth.id);

    var request = require('request');
    var options = {
        url: 'http://192.168.1.116/api_jsonrpc.php',
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        json: true,
        json: auth
    }

    var result = "abc";
    request(options, function (error, response, body) {
        //console.log(error);
        //console.log(response);
        console.log(body);
        console.log(body.result);
        var fs = require('fs');
        fs.writeFileSync('./authResult.json', JSON.stringify(body, null, '    '));
        return body.result;
    })
}
