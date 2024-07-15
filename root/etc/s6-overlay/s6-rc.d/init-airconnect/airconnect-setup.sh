#!/usr/bin/with-contenv bash
if [ -z "$AIRUPNP_VAR" ]; then
  exit 0
elif [ "$AIRUPNP_VAR" != "kill" ]; then
  sed -i 's;exec /bin/airupnp-linux-x86_64 -l 1000:2000;exec /bin/airupnp-linux-x86_64 '"$AIRUPNP_VAR"';' /etc/s6-overlay/s6-rc.d/svc/airupnp/run
  exit 0
elif [ "$AIRUPNP_VAR" = "kill" ]; then
  rm /etc/s6-overlay/s6-rc.d/user/contents.d/svc-airupnp
  exit 0
fi

# Check if VAR is empty, and assign arch / if not empty, run with command and assign arch / if kill, and hasn't run (=0) then comment out
if [ -z "$AIRCAST_VAR" ]; then
  exit 0
elif [ "$AIRCAST_VAR" != "kill" ]; then
  sed -i 's;exec /bin/aircast-linux-x86_64;exec /bin/aircast-linux-x86_64 '"$AIRCAST_VAR"';' /etc/s6-overlay/s6-rc.d/svc/aircast/run
  exit 0
elif [ "$AIRCAST_VAR" = "kill" ]; then
  rm /etc/s6-overlay/s6-rc.d/user/contents.d/svc-aircast
  exit 0
fi