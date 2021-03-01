#!/bin/bash

set -euo pipefail

docker pull mwotton/liza-dependencies:latest || true

docker build --target dependencies \
       --cache-from=mwotton/liza-dependencies:latest \
       --tag mwotton/liza-dependencies .

docker push mwotton/liza-dependencies:latest

# Build the runtime stage, using cached compile stage:
docker build --target server \
       --cache-from=mwotton/liza-dependencies:latest \
       --tag mwotton/liza-server .
docker push mwotton/liza-server:latest
