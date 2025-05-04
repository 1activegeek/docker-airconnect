#!/usr/bin/with-contenv bash

echo "[init] Reading environment variables..."
if [ "$AIRCAST_VAR" = "kill" ]; then
  echo "[init] Setting svc-aircast to oneshot"
  echo "oneshot" > /etc/s6-overlay/s6-rc.d/svc-aircast/type
elif [ "$AIRUPNP_VAR" = "kill" ]; then
  echo "[init] Setting svc-airupnp to oneshot"
  echo "oneshot" > /etc/s6-overlay/s6-rc.d/svc-airupnp/type
fi
echo "[init] Finished reading environment variables"
