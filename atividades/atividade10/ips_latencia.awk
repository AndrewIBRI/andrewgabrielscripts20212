{printf $1 " "
comando = "ping -c 5 "$1" | grep rtt"
comando | getline pingado
split(pingado, v , "/"); print v[5]" ms"}
