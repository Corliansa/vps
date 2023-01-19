#!/bin/sh

traefik-certs-dumper file --version v2 --source ./letsencrypt/acme/acme.json --domain-subdir=true --dest ./letsencrypt/certs --watch