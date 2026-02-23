# Despliegue de DocuSeal en NAS

Esta guía detalla cómo desplegar DocuSeal en un NAS utilizando Docker Compose. La pila (stack) consiste en:
- **App**: La aplicación DocuSeal (Rails + Puma).
- **Postgres**: Base de datos backend.
- **Caddy**: Proxy inverso que gestiona SSL automático y enrutamiento de dominios.

## Prerrequisitos

- Docker y Docker Compose instalados en tu NAS (ej. Synology Container Manager, QNAP Container Station, o Docker estándar en Linux).
- Un nombre de dominio apuntando a la IP de tu NAS (público o privado). Si usas `localhost` para pruebas, Caddy generará certificados auto-firmados (aceptar advertencia en navegador).
- Puertos 80 y 443 redirigidos al NAS/Contenedor si se requiere acceso público SSL (Let's Encrypt).

## 1. Configurar Directorio del Proyecto

Crea un directorio para tu proyecto en el sistema de archivos del NAS.

```bash
mkdir docuseal_stack
cd docuseal_stack
```

## 2. Crear `docker-compose.yml`

Crea un archivo llamado `docker-compose.yml` con el siguiente contenido.

**Nota sobre la Versión de Postgres**: El repositorio oficial hace referencia a `postgres:18`, lo cual parece ser incorrecto o inestable (la versión estable actual es 16). Recomendamos usar `postgres:16-alpine` por estabilidad y tamaño. También usamos la ruta estándar de datos de PostgreSQL `/var/lib/postgresql/data`.

```yaml
services:
  app:
    depends_on:
      postgres:
        condition: service_healthy
    image: docuseal/docuseal:latest
    restart: unless-stopped
    volumes:
      - ./docuseal:/data/docuseal
    environment:
      - FORCE_SSL=${HOST}
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/docuseal
    healthcheck:
      test: ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    volumes:
      - ./pg_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: docuseal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  caddy:
    image: caddy:latest
    restart: unless-stopped
    command: caddy reverse-proxy --from $HOST --to app:3000
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./caddy_data:/data
      - ./caddy_config:/config
    environment:
      - HOST=${HOST}
```

### Cambios Clave respecto al Compose Oficial:
- **Versión Postgres**: Cambiada a `16-alpine`.
- **Volumen Postgres**: Cambiado al estándar `/var/lib/postgresql/data`.
- **Volúmenes Caddy**: Añadidos montajes específicos para persistencia de datos y configuración (`./caddy_data` y `./caddy_config`).
- **Política de Reinicio**: Añadido `restart: unless-stopped` para resiliencia ante reinicios del NAS.
- **Healthcheck (App)**: Añadido un healthcheck para el servicio app usando `wget` (compatible con Alpine).

## 3. Configuración y Variables de Entorno

La pila requiere una configuración mínima mediante variables de entorno.

### Variable Requerida: `HOST`
Esta variable define el nombre de dominio para tu instancia de DocuSeal. Es utilizada por:
- **App**: Para forzar SSL y generar URLs correctas.
- **Caddy**: Para configurar el proxy inverso y obtener certificados SSL.

### Configurar la Variable
Puedes establecer `HOST` en un archivo `.env` en el mismo directorio:

**Archivo: `.env`**
```env
HOST=docuseal.tudominio.com
```

O pasarla directamente al ejecutar:
```bash
HOST=docuseal.tudominio.com docker compose up -d
```

### Variables Adicionales (Opcional)
- `DATABASE_URL`: Actualmente configurada para usar el servicio `postgres`. Modificar si se usa una base de datos externa.
- `SECRET_KEY_BASE`: La aplicación genera una si falta, pero para seguridad en producción, puedes establecer una específica.
- `RAILS_ENV`: Por defecto es `production` en la imagen.

## 4. Dependencias y Assets

- **Fuentes (Fonts)**: La imagen Docker `docuseal/docuseal` incluye todas las fuentes necesarias (ej. Google Noto, Dancing Script). **No** necesitas instalarlas manualmente.
- **Modelos ONNX**: La imagen incluye los modelos ONNX requeridos para detección de campos. **No** necesitas descargarlos manualmente.
- **Certificados SSL**: Caddy gestiona automáticamente la generación y renovación de certificados SSL (vía Let's Encrypt) para el dominio especificado en `HOST`.
  - Asegúrate de que los puertos 80 y 443 estén abiertos y redirigidos al NAS para que esto funcione.
  - Si ejecutas localmente (ej. `HOST=localhost` o IP interna), Caddy usará certificados auto-firmados.

## 5. Pasos de Despliegue

1.  Navega a tu directorio de proyecto:
    ```bash
    cd /ruta/a/docuseal_stack
    ```
2.  Inicia la pila:
    ```bash
    docker compose up -d
    ```
3.  Monitoriza los logs si es necesario:
    ```bash
    docker compose logs -f
    ```
4.  Accede a DocuSeal en `https://<tu-dominio>` (o `https://localhost` si pruebas localmente, aceptando la advertencia de certificado auto-firmado).

## Solución de Problemas

- **Conexión a Base de Datos**: Si la app falla al conectar a Postgres, asegura que el contenedor `postgres` esté saludable (`docker compose ps`) y las credenciales en `DATABASE_URL` coincidan con `POSTGRES_USER`/`PASSWORD`.
- **Problemas SSL**: Revisa los logs de Caddy (`docker compose logs caddy`). Asegura que tu dominio apunta a la IP del NAS y los puertos 80/443 son accesibles.
