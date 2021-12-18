BEGIN{
r="Redes"
s="Sistemas"
e="Engenharia"
rs=0
ss=0
es=0
rp="Nome do professor"
sp="Nome do professor"
ep="Nome do professor"
}
{
if (($2 == r) && ($3 > rs)){
        rs = $3
        rp = $1
}
else if (($2 == s) && ($3 > ss)){
        ss = $3
        sp = $1
}
else if (($2 == e) && ($3 > es)){
        es = $3
        ep = $1
}
}
END{
printf e":      "ep",      "es "\n"
printf r":   "rp",   "rs "\n"
printf s":        "sp",        "ss "\n"
}
