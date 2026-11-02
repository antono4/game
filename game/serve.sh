#!/usr/bin/env bash
# Keep the tinyworldformer browser demo up on port 12000.
cd "$(dirname "$0")"
while true; do
  python3 -m http.server 12000 --bind 0.0.0.0 >/tmp/http-game.log 2>&1
  echo "$(date -Is) server exited, restarting in 2s" >> /tmp/http-game.log
  sleep 2
done
