#!/bin/bash 

apt install apache2 -y
rm /var/www/html/index.html

cat << EOF >  /var/www/html/index.html

<!DOCTYPE html>
<head>
  <title>Andrew 404757</title>
</head>

EOF

cat << EOF > /usr/local/bin/monitor.sh
#!/bin/bash

while true
do
   dataexec=\$(date +%H:%M:%S-%D)
   tempo=\$(uptime | awk '{print \$3, \$4}')
   uso=\$(uptime | awk '{print \$NF}')
   memoria=\$(free | grep Mem | awk '{print "Usada: "\$3, "Livre: "\$4}')
   rede=\$(cat /proc/net/dev | grep eth0 | awk '{ printf "Recebidos: %d, Transmitidos: %d\n", \$2, \$10 }')
   echo "<p>""Hora Da execucao: "\$dataexec " Tempo ligado: "\$tempo" Uso: "\$uso" Memoria: "\$memoria" Bytes: "\$rede"</p>"  >> /var/www/html/index.html
   sleep 5
done
EOF

cat << EOF > /etc/systemd/system/monitoramento.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/local/bin/monitor.sh

[Install]
WantedBy=default.target
EOF

chmod 744 /usr/local/bin/monitor.sh
chmod 664 /etc/systemd/system/monitoramento.service
systemctl daemon-reload
systemctl start apache2
systemctl enable monitoramento.service
systemctl start monitoramento.service
