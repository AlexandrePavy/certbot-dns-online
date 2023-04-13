ARG CERTBOT_TAG=latest
FROM certbot/certbot:${CERTBOT_TAG}

# Dependencies
RUN python tools/pip_install.py --no-cache-dir dns-lexicon zope.event zope.interface

# certbot-dns-online
RUN python tools/pip_install.py --no-cache-dir certbot-dns-online==0.0.7