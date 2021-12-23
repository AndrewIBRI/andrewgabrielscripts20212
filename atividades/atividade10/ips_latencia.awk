# Correção: 0,5. Está, mesmo copiada do semestre anterior, está ok.
{printf $1 " "
comando = "ping -c 5 "$1" | grep rtt"
comando | getline pingado
split(pingado, v , "/"); print v[5]" ms"}
