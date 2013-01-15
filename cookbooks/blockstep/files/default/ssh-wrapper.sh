#!/usr/bin/env bash

/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/tmp/keyz/.ssh/id_deploy" "$@"
