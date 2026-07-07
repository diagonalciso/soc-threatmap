# soc-Threatmap — Live Attack Map

> Real-time attack map driven by live SOC data.

**Port:** `8100` &nbsp;|&nbsp; **Repo:** `diagonalciso/soc-threatmap` &nbsp;|&nbsp; **Service:** `soc-threatmap.service` &nbsp;|&nbsp; **Stack:** stdlib Python (no external deps)

Part of the **CD / Wazuh Full SOC** suite. Open the in-app **`?` Help button** (top-right of the dashboard) to read this manual, or view it here.

---

## 1. Overview

soc-Threatmap renders a real-time attack map — animated arcs from source to target — driven by live SOC feeds over Server-Sent Events, with an offline GeoIP lookup and a vendored world map so it works fully self-hosted with no external calls.

## 2. Key features

- Live SSE arc animation of attacks on a canvas world map
- Offline GeoIP resolution (no external geo calls)
- Zoom / pan controls
- Fed by real alert source IPs (e.g. from soc-nids / Wazuh)

## 3. Running the service

The service is a single self-contained `app.py` using only the Python standard library.

```bash
# systemd (fleet / suite install)
sudo systemctl status soc-threatmap
sudo systemctl restart soc-threatmap
sudo journalctl -u soc-threatmap -f

# manual run (from the repo directory)
cp .env.example .env      # then edit as needed
env $(grep -v '^#' .env | xargs) python3 app.py
```

Then open **http://<host>:8100/**.

## 4. Configuration (environment variables)

Set these in `.env` (see `.env.example` for defaults):

| Variable | Notes |
|---|---|
| `DNS_CAP` |  |
| `EMIT_RATE` |  |
| `FIRST_BURST` |  |
| `HOME_LAT` |  |
| `HOME_LON` |  |
| `HOST` |  |
| `POOL_MAX` |  |
| `PORT` | Listen port (default 8100). |
| `REPLAY_RATE` |  |
| `RING` |  |
| `SEEN_MAX` |  |

## 5. HTTP endpoints

| Path | |
|---|---|
| `/` | Main dashboard (HTML) |
| `/api/socmap/recent` | API endpoint (JSON) |
| `/api/socmap/stats` | API endpoint (JSON) |
| `/api/socmap/stream` | API endpoint (JSON) |
| `/api/socmap/world` | API endpoint (JSON) |
| `/manual` | This manual (opened by the top-right **?** Help button) |

## 6. Integration

Consumes source IPs from the SOC pipeline (soc-nids, Wazuh alerts).

## 7. Security & operational notes

ip-api.com is intentionally NOT used (LAN DNS-hijack risk); GeoIP is local.

## 8. Troubleshooting

| Symptom | Check |
|---|---|
| Page will not load | `systemctl status soc-threatmap`; confirm the port `8100` is listening (`lsof -i:8100`). |
| Help button shows "MANUAL.md not found" | Ensure `MANUAL.md` sits next to `app.py` in the service directory. |
| Service keeps restarting | `journalctl -u soc-threatmap -e` for the traceback; usually a missing `.env` value. |
| Empty / stale data | Confirm upstream sources and any API keys in `.env` are reachable. |

---

*Manual for soc-threatmap. Part of the CD / Wazuh Full SOC suite. Private © CisoDiagonal.*
