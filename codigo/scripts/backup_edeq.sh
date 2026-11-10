#!/bin/bash
# Copia de seguridad diaria de la base de datos edeq (PostgreSQL en Dokploy).
# Conserva 7 dias. Proyecto academico.
set -e
DEST=/srv/backups/edeq
mkdir -p "$DEST"
CID=$(docker ps -q -f name=edeqdb | head -n1)
[ -n "$CID" ] || { echo "$(date -Is) ERROR: contenedor de la base no encontrado"; exit 1; }
FILE="$DEST/edeq_$(date +%F_%H%M).sql.gz"
docker exec "$CID" pg_dump -U edeq -d edeq | gzip > "$FILE"
find "$DEST" -name 'edeq_*.sql.gz' -mtime +7 -delete
echo "$(date -Is) OK $FILE $(du -h "$FILE" | cut -f1)"
