# tableau-ssl設定
## 参考
 - [SSLについて](https://help.tableau.com/current/server/ja-jp/ssl.htm

 ## 環境変数

set OPENSSL_CONF=c:\Program Files\Tableau\Tableau Server\packages\apache.apache.20201.20.0326.1623\conf\openssl.cnf

## フォルダ移動
cd "C:\Program Files\Tableau\Tableau Server\packages\apache.20201.20.0326.1623\bin"

## 鍵生成
.\openssl.exe genrsa -out TableauSLL-Key.key 4096
.\openssl.exe req -new -key TableauSLL-Key.key -out TableauSLL-CSR.csr -subj "/C=JP/ST=Kanagawa/L=Kawasaki/O=WankoAP/OU=WankoAP/CN=tableau-s"
.\openssl x509 -req -days 825 -in TableauSLL-CSR.csr -signkey TableauSLL-Key.key -out TableauSLL-CRT.crt

## 内容表示
.\openssl x509 -in TableauSLL-CRT.crt -text | sls Version
.\openssl x509 -in TableauSLL-CRT.crt -text | sls DNS
.\openssl req -text -noout -in TableauSLL-CSR.csr | sls Version
.\openssl req -text -noout -in TableauSLL-CSR.csr | sls DNS


.\openssl.exe req -new -key TableauSLL-Key.key -out TableauSLL-CSR.csr -subj "/C=JP/ST=Kanagawa/L=Kawasaki/O=WankoAP/OU=WankoAP/CN=tableau-s" -extensions v3_req
.\openssl x509 -req -days 825 -in TableauSLL-CSR.csr -signkey TableauSLL-Key.key -out TableauSLL-CRT.crt -extensions v3_req