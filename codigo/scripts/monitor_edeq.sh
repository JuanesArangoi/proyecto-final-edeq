#!/bin/bash
# Monitoreo de edeq-srv: servicios, API+BD y disco. Alerta por ntfy solo cuando cambia el estado.
TOPIC="edeq-uq-860e0834"
FALLAS=""
for s in docker ntpsec nfs-server ypserv smbd cups; do
  systemctl is-active --quiet "$s" || FALLAS="$FALLAS $s"
done
curl -sk -m 10 --resolve www.edeq.local:443:127.0.0.1 https://www.edeq.local/api/health | grep -q '"base_de_datos":"ok"' || FALLAS="$FALLAS api/bd"
USO=$(df --output=pcent / | tail -1 | tr -dc 0-9)
[ "$USO" -ge 85 ] && FALLAS="$FALLAS disco-${USO}%"
ARCH=/var/tmp/edeq_monitor.estado
ANT=$(cat "$ARCH" 2>/dev/null)
if [ "$FALLAS" != "$ANT" ]; then
  echo "$FALLAS" > "$ARCH"
  if [ -n "$FALLAS" ]; then
    curl -s -m 10 -H "Title: EDEQ ALERTA" -H "Priority: high" -d "Fallas en edeq-srv:$FALLAS" "ntfy.sh/$TOPIC" >/dev/null
  else
    curl -s -m 10 -H "Title: EDEQ OK" -d "Servicios restablecidos" "ntfy.sh/$TOPIC" >/dev/null
  fi
fi
echo "$(date -Is) fallas:[${FALLAS}]"
