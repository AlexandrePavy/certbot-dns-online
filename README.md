certbot-dns-online
==================

This project aims to facilitate the use of certbot with a dns on [console.online.net](https://console.online.net/).

This repository build a Docker image based on official [certbot/certbot](https://github.com/certbot/certbot) docker
image with [certbot-dns-online](https://pypi.org/project/certbot-dns-online/) plugin.

This image is available on Docker Hub [alexandrepavy/certbot-dns-online](https://hub.docker.com/r/alexandrepavy/certbot-dns-online)
and GitHub package [ghcr.io/alexandrepavy/certbot-dns-online](https://github.com/AlexandrePavy/certbot-dns-online/pkgs/container/certbot-dns-online).

You can learn more about using certbot with [official documentation](https://eff-certbot.readthedocs.io/en/stable/index.html) 

You can learn more about using [certbot-dns-online plugin here](https://pypi.org/project/certbot-dns-online/).

# Documentation

You can use Docker Hub registry:
```shell
docker pull alexandrepavy/certbot-dns-online:v2.4.0
```

or using GitHub Container registry (You will need to update the image name on all following commands):
```shell
docker pull ghcr.io/alexandrepavy/certbot-dns-online:v2.4.0
```

Grab your online api token on [console.online.net/en/api/access](https://console.online.net/en/api/access) and create
credential file.
```ini
# /root/online_credential.ini
dns_online_token = <api-secret-key>
```

Dry-run test (`--dry-run` option) with staging let's encrypt (`--test-cert` option).
```shell
docker run -it --rm \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/root/online_credential.ini:/root/online_credential.ini" \
    alexandrepavy/certbot-dns-online:v2.4.0 certonly --test-cert --dry-run --non-interactive --agree-tos \
        --authenticator dns-online \
        --dns-online-credentials /root/online_credential.ini \
        --dns-online-propagation-seconds 60 \
        --email email@domain.tld \
        --domain *.domain.tld \
        --domain domain.tld
```

Should result:
```text
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Simulating a certificate request for *.domain.tld and domain.tld
Waiting 60 seconds for DNS changes to propagate
The dry run was successful.
```

(Optional) To fetch let's encrypt logs you can add this new volume: `-v "/var/log/letsencrypt:/var/log/letsencrypt"`

Get a let's encrypt staging certificate by removing `--dry-run` option.
```shell
docker run -it --rm \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/root/online_credential.ini:/root/online_credential.ini" \
    alexandrepavy/certbot-dns-online:v2.4.0 certonly --test-cert --non-interactive --agree-tos \
        --authenticator dns-online \
        --dns-online-credentials /root/online_credential.ini \
        --dns-online-propagation-seconds 60 \
        --email email@domain.tld \
        --domain *.domain.tld \
        --domain domain.tld
```

You can set up your application or webserver with let's encrypt staging certificate files (browsers will not trust these
certificates because they are issued by let's encrypt staging):
```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for domain.tld

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/domain.tld/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/domain.tld/privkey.pem
This certificate expires on 2023-07-12.
These files will be updated when the certificate renews.

NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.
```

List your certificates:
```shell
docker run -it --rm \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/lib/letsencrypt:/var/lib/letsencrypt" \
    alexandrepavy/certbot-dns-online:v2.4.0 certificates
```

Renew certificates:
```shell
docker run -it --rm \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/root/online_credential.ini:/root/online_credential.ini" \
    alexandrepavy/certbot-dns-online:v2.4.0 renew --test-cert --dry-run
```

Delete a certificate:
```shell
docker run -it --rm \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/lib/letsencrypt:/var/lib/letsencrypt" \
    alexandrepavy/certbot-dns-online:v2.4.0 delete --non-interactive --cert-name domain.tld
```

Go to **production** by removing `--test-cert` option to use production let's encrypt.
```shell
docker run -it --rm \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/root/online_credential.ini:/root/online_credential.ini" \
    alexandrepavy/certbot-dns-online:v2.4.0 certonly --non-interactive --agree-tos \
        --authenticator dns-online \
        --dns-online-credentials /root/online_credential.ini \
        --dns-online-propagation-seconds 60 \
        --email email@domain.tld \
        --domain *.domain.tld \
        --domain domain.tld
```