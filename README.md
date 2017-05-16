# NMAP

Image Docker pour Nmap 


## Utilisation
```
docker run --rm tvoyat/nmap /usr/bin/nmap -sC -p445 --open --max-hostgroup 3 --script smb-vuln-ms17-010.nse nas2.in.ac-amiens.fr
```

### Pour un  réseau complet :
```
docker run --rm tvoyat/nmap /usr/bin/nmap -sC -p445 --open --max-hostgroup 3 --script smb-vuln-ms17-010.nse 172.30.176.0/20 | tee /tmp/fichier_log.txt
```

## Installation

```
if [ -v http_proxy ]; then
  export BUILD_ARG="--build-arg=http_proxy=$http_proxy --build-arg=https_proxy=$http_proxy" 
fi
docker build $BUILD_ARG -t tvoyat/nmap .
```

## Modifications :

### Ajout MS17-010

```
wget -O FILES/smb-vuln-ms17-010.nse https://github.com/cldrn/nmap-nse-scripts/blob/master/scripts/smb-vuln-ms17-010.nse?raw=true
```



## Rapport simple 
grep -Pazo "(?s)Nmap scan report for ([^\n]*)\n.{10,150}VULNERABLE" fic.log| tr -d '()' | awk '/^Nmap scan/ { if (NF<6) { $6=$5; $5="???"}; print $5";" $6}'
