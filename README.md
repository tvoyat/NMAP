# NMAP

Image Docker pour Nmap v7.92 basée sur Alpine latest (v3.15)
[![](https://images.microbadger.com/badges/image/voyat/nmap.svg)](https://microbadger.com/images/voyat/nmap "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/voyat/nmap.svg)](https://microbadger.com/images/voyat/nmap "Get your own version badge on microbadger.com")

## Utilisation :

Pour un serveur précis :
```
docker run --rm voyat/nmap -p445 --open --script smb-vuln-ms17-010.nse nas2.in.ac-amiens.fr
```

Pour un réseau complet avec log dans/tmp/fichier_log.txt :
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

Exemple ajout MS17-010

```
wget -O FILES/smb-vuln-ms17-010.nse https://svn.nmap.org/nmap/scripts/smb-vuln-ms17-010.nse
```



## Rapport simple 
N'affiche que le nom et l'ip des serveurs vulnérables détectés
```
sed -e '/^$/{N;/Host/D;}' /tmp/fichier_log.txt \
   | sed -e '/./{H;$!d;}' -e 'x;/smb-vuln-ms17-010/!d' \
   | tr -d '()' \
   | awk '/^Nmap scan/ { if (NF<6) { $6=$5; $5="???"}; print $5";" $6}' \
   | tee /tmp/ms17_fqdn_ip.txt
```

## Informations de workgroup :
```
docker run --rm voyat/nmap  --script smb-os-discovery.nse -p445 \
   $(awk -F";" '{ print $2}' /tmp/ms17_fqdn_ip.txt ) \
   | tee /tmp/netbios_log.txt
```
