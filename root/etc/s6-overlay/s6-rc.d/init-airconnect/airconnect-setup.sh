#!/usr/bin/with-contenv bash

# Check for VAR - exit if none, edit if present, remove service file if "kill"
if [ -z "$AIRUPNP_VAR" ]; then
  echo "No AIRUPNP_VAR present, continuing with standard airupnp launch variables"
  exit 0
elif [ "$AIRUPNP_VAR" != "kill" ]; then
  sed -i 's;exec /bin/airupnp-linux-x86_64 -l 1000:2000;exec /bin/airupnp-linux-x86_64 '"$AIRUPNP_VAR"';' /etc/s6-overlay/s6-rc.d/svc/airupnp/run
  echo "AIRUPNP_VAR present, updating airupnp launch variables"
  exit 0
elif [ "$AIRUPNP_VAR" = "kill" ]; then
  rm /etc/s6-overlay/s6-rc.d/user/contents.d/svc-airupnp
  echo "AIRUPNP_VAR set to kill, removing airupnp service launch"
  exit 0
fi

# Check for VAR - exit if none, edit if present, remove service file if "kill"
if [ -z "$AIRCAST_VAR" ]; then
  echo "No AIRCAST_VAR present, continuing with standard aircast launch variables"
  exit 0
elif [ "$AIRCAST_VAR" != "kill" ]; then
  sed -i 's;exec /bin/aircast-linux-x86_64;exec /bin/aircast-linux-x86_64 '"$AIRCAST_VAR"';' /etc/s6-overlay/s6-rc.d/svc/aircast/run
  echo "AIRCAST_VAR present, updating aircast launch variables"
  exit 0
elif [ "$AIRCAST_VAR" = "kill" ]; then
  rm /etc/s6-overlay/s6-rc.d/user/contents.d/svc-aircast
  echo "AIRCAST_VAR set to kill, removing aircast service launch"
  exit 0
fi