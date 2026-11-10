# Guion de presentación (15 minutos) — Infraestructura de TI para EDEQ

| Min | Tema | Qué decir / mostrar |
|---|---|---|
| 0–2 | Empresa y problema | EDEQ distribuye energía en los 12 municipios del Quindío; necesita centralizar web, archivos, impresión, hora y usuarios. Proyecto académico, datos simulados. |
| 2–4 | Diseño | Diagrama (`diagrama.mmd`): un servidor con Dokploy y los servicios Linux, un cliente. Tabla de puertos. Decisiones: un solo servidor, NIS por requisito, PostgreSQL sin puerto público, certificado autofirmado, Multipass en lugar de VirtualBox. |
| 4–6 | Dokploy y HTTPS | Panel en `https://panel.edeq.local`; proyecto `edeq` con `web`, `api` y `edeq-db`. |
| 6–11 | Demostración en vivo | 1) `https://www.edeq.local`: enviar un reporte y verlo en la tabla; consultar en PostgreSQL. 2) NTP: `timedatectl timesync-status` en el cliente. 3) NFS: crear archivo en `/mnt/empresa` y verlo en el servidor. 4) NIS: `su - empleado1` en el cliente. 5) CUPS: imprimir en `PDF` y mostrar el archivo. 6) Samba: `dir Z:\` o Explorador en Windows. |
| 11–13 | Extras | UFW (`ufw status`), copia de seguridad y restauración, alerta de ntfy al detener CUPS. |
| 13–15 | Costo-beneficio y cierre | Software libre (sin licencias) vs. Windows Server + CAL; riesgos (servidor único, NIS sin cifrar, IP por DHCP) y mejoras (LDAP, segundo servidor, dominio público). Preguntas. |

Antes de empezar: ambas VM encendidas (`multipass list`), hosts de Windows con los tres nombres, `Z:` desmapeada, navegador con el certificado ya aceptado, una captura de respaldo de cada demo.
