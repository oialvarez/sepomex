#!/bin/sh

curl 'http://www.sepomex.gob.mx/lservicios/servicios/CodigoPostal_Exportar.aspx' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://www.sepomex.gob.mx' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: http://www.sepomex.gob.mx/lservicios/servicios/CodigoPostal_Exportar.aspx' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.9,es;q=0.8,ca;q=0.7' -H 'Cookie: ASP.NET_SessionId=gdcizt55qxryerf04sfq5445' --data '__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=%2FwEPDwUKMTIxMDU0NDIwMA9kFgICAQ9kFgICAQ9kFgYCAw8PFgIeBFRleHQFPMOabHRpbWEgQWN0dWFsaXphY2nDs24gZGUgSW5mb3JtYWNpw7NuOiBTZXB0aWVtYnJlIDYgZGUgMjAxOGRkAgcPEA8WBh4NRGF0YVRleHRGaWVsZAUDRWRvHg5EYXRhVmFsdWVGaWVsZAUFSWRFZG8eC18hRGF0YUJvdW5kZ2QQFSEjLS0tLS0tLS0tLSBUICBvICBkICBvICBzIC0tLS0tLS0tLS0OQWd1YXNjYWxpZW50ZXMPQmFqYSBDYWxpZm9ybmlhE0JhamEgQ2FsaWZvcm5pYSBTdXIIQ2FtcGVjaGUUQ29haHVpbGEgZGUgWmFyYWdvemEGQ29saW1hB0NoaWFwYXMJQ2hpaHVhaHVhEUNpdWRhZCBkZSBNw6l4aWNvB0R1cmFuZ28KR3VhbmFqdWF0bwhHdWVycmVybwdIaWRhbGdvB0phbGlzY28HTcOpeGljbxRNaWNob2Fjw6FuIGRlIE9jYW1wbwdNb3JlbG9zB05heWFyaXQLTnVldm8gTGXDs24GT2F4YWNhBlB1ZWJsYQpRdWVyw6l0YXJvDFF1aW50YW5hIFJvbxBTYW4gTHVpcyBQb3Rvc8OtB1NpbmFsb2EGU29ub3JhB1RhYmFzY28KVGFtYXVsaXBhcwhUbGF4Y2FsYR9WZXJhY3J1eiBkZSBJZ25hY2lvIGRlIGxhIExsYXZlCFl1Y2F0w6FuCVphY2F0ZWNhcxUhAjAwAjAxAjAyAjAzAjA0AjA1AjA2AjA3AjA4AjA5AjEwAjExAjEyAjEzAjE0AjE1AjE2AjE3AjE4AjE5AjIwAjIxAjIyAjIzAjI0AjI1AjI2AjI3AjI4AjI5AjMwAjMxAjMyFCsDIWdnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2RkAh0PPCsACwBkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBQtidG5EZXNjYXJnYUCqbUIdBCHm1wrUVhNkyfosGWxb&__EVENTVALIDATION=%2FwEWKAKgwo7zCgLG%2FOLvBgLWk4iCCgLWk4SCCgLWk4CCCgLWk7yCCgLWk7iCCgLWk7SCCgLWk7CCCgLWk6yCCgLWk%2BiBCgLWk%2BSBCgLJk4iCCgLJk4SCCgLJk4CCCgLJk7yCCgLJk7iCCgLJk7SCCgLJk7CCCgLJk6yCCgLJk%2BiBCgLJk%2BSBCgLIk4iCCgLIk4SCCgLIk4CCCgLIk7yCCgLIk7iCCgLIk7SCCgLIk7CCCgLIk6yCCgLIk%2BiBCgLIk%2BSBCgLLk4iCCgLLk4SCCgLLk4CCCgLL%2BuTWBALa4Za4AgK%2BqOyRAQLI56b6CwL1%2FKjtBf7z3qL%2Bbz2MW2SVsZJxvdKNrDWX&cboEdo=00&rblTipo=txt&btnDescarga.x=34&btnDescarga.y=15' --compressed -o etl/CPdescargatxt.zip

sudo apt-get install p7zip-full p7zip-rar -y

cd etl 

7z x CPdescargatxt.zip -y

echo 'delete first line'
sed '1d' CPdescarga.txt > tmpfile

echo 'replace file without first line'
mv tmpfile CPdescarga.txt

iconv -f ISO-8859-15 -t UTF-8//TRANSLIT CPdescarga.txt -o out.file
mv out.file CPdescarga.txt

cd ..

./node_modules/csvtojson/bin/csvtojson --delimiter='["|"]' etl/CPdescarga.txt > etl/CPdescarga.txt.json

node etl/index
