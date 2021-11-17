#!/bin/bash

PASSWORD=${INPUT_PASSWORD};
KEY=${INPUT_KEY};

if [ -z "$KEY" ] && [ -z "$PASSWORD" ]; then
    echo "🔑 Please provide at least a key or a password...";
    exit 0;
fi

if [[ -n "$KEY" ]]; then
    echo "🔑 Usando clave privada...";
    source /with_key.sh;
else
    echo "🔑 Usando password...";
    source /with_pass.sh;
fi