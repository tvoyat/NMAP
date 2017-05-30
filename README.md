# NMAP

Image Docker pour Nmap v7.40 basée sur Alpine v3.2

[![](https://badge.imagelayers.io/voyat/nmap:latest.svg)](https://imagelayers.io/?images=voyat/nmap:latest 'Get your own badge on imagelayers.io')

## Utilisation :

Pour un serveur précis :
```
docker run --rm voyat/nmap -p445 --open --script smb-vuln-ms17-010.nse nas2.in.ac-amiens.fr
```

Pour un réseau complet :
```
docker run --rm voyat/nmap -p445 --open --script smb-vuln-ms17-010.nse 172.30.176.0/20 | tee /tmp/fichier_log.txt
```

A titre d'information, ce scan dure moins de 10 minutes pour 4096 IPs dont 975 up


## Construction image en local (si pas accès au hub docker)

```
git clone https://github.com/tvoyat/NMAP.git

if [ -v http_proxy ]; then
  export BUILD_ARG="--build-arg=http_proxy=$http_proxy --build-arg=https_proxy=$http_proxy" 
fi
docker build $BUILD_ARG -t voyat/nmap .
```

## Modifications

Ajout MS17-010

```
wget -O FILES/smb-vuln-ms17-010.nse https://svn.nmap.org/nmap/scripts/smb-vuln-ms17-010.nse
```



## Rapport simple 
N'affiche que le nom et l'ip des serveurs vulnérables détectés
```
grep -Pazo "(?s)Nmap scan report for ([^\n]*)\n.{10,230}VULNERABLE" /tmp/fichier_log.txt| tr -d '()' | awk '/^Nmap scan/ { if (NF<6) { $6=$5; $5="???"}; print $5";" $6}'
```

## Informations de workgroup :
```
docker run --rm voyat/nmap  --script smb-os-discovery.nse -p445 \
    $(grep -Pazo "(?s)Nmap scan report for ([^\n]*)\n.{10,230}VULNERABLE" /tmp/fichier_log.txt| tr -d '()' | \
    awk '/^Nmap scan/ { print $NF}') | tee /tmp/netbios_log.txt
```
