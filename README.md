# comfyui-animagine

Worker ComfyUI con Animagine XL 3.1 para anime img2img stylization en RunPod serverless.

Basado en `runpod/worker-comfyui:5.8.5-sdxl` con Animagine XL 3.1 bakeado en la imagen.

---

## Setup — GitHub Actions + Docker Hub

### 1. Crear cuenta en Docker Hub

Ve a https://hub.docker.com y crea una cuenta gratuita.
Anota tu `DOCKERHUB_USERNAME`.

### 2. Crear token de acceso en Docker Hub

- Docker Hub → Account Settings → Security → New Access Token
- Nombre: `github-actions`
- Permisos: Read & Write
- Copia el token generado (`DOCKERHUB_TOKEN`)

### 3. Agregar secrets en GitHub

En tu repo de GitHub:
- Settings → Secrets and variables → Actions → New repository secret

Agregar los siguientes secrets:

| Secret | Valor |
|---|---|
| `DOCKERHUB_USERNAME` | Tu usuario de Docker Hub |
| `DOCKERHUB_TOKEN` | El token generado en el paso anterior |

### 4. Estructura del repo

```
├── Dockerfile                        ← imagen con Animagine bakeado
├── .github/
│   └── workflows/
│       └── docker-build.yml          ← GitHub Actions build/push
└── README.md
```

### 5. Trigger del build

El build se dispara automáticamente al hacer push a `main`.
También puedes correrlo manualmente desde:
GitHub → Actions → Build and Push ComfyUI Animagine Image → Run workflow

### 6. Tiempo estimado de build

- Descarga base image (~8GB): ~10 min
- Descarga Animagine XL 3.1 (~6.9GB): ~5-10 min
- Total: ~60-90 min en el primer build

### 7. Imagen resultante

```
DOCKERHUB_USERNAME/comfyui-animagine:latest
```

---

## Crear endpoint en RunPod

Una vez que la imagen esté en Docker Hub:

```python
import requests, os
from dotenv import load_dotenv
load_dotenv()

API_KEY  = os.getenv("RUNPOD_API_KEY")
HEADERS  = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}

payload = {
    "name":        "comfyui-animagine-v1",
    "dockerImage": "DOCKERHUB_USERNAME/comfyui-animagine:latest",
    "gpuTypeIds":  ["NVIDIA RTX A5000", "NVIDIA GeForce RTX 3090", "NVIDIA GeForce RTX 4090"],
    "workersMin":  0,
    "workersMax":  1,
    "idleTimeout": 5,
    "flashboot":   True,
}

r = requests.post("https://rest.runpod.io/v1/endpoints", json=payload, headers=HEADERS, timeout=10)
print(r.json())
```

---

## Modelo incluido

| Modelo | Ruta en worker |
|---|---|
| `sd_xl_base_1.0.safetensors` | `/comfyui/models/checkpoints/` |
| `animagine-xl-3.1.safetensors` | `/comfyui/models/checkpoints/` |

---

## Notas

- El endpoint SDXL original (`Phase 3`) no se toca — este es un endpoint separado
- El cold start de esta imagen será más lento (~3-5 min) por el tamaño de la imagen
- FlashBoot reduce el cold start en jobs subsecuentes
