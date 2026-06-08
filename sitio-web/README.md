Sitio estático de Carlos Rubino

Contenido:
- `index.html`
- `styles.css`
- `images/` (portadas y foto del autor)

Opciones de publicación (elige una):

1) Netlify (recomendado, deploy rápido)
- Crear cuenta en https://app.netlify.com/
- Conectar un repositorio Git (GitHub/GitLab/Bitbucket) o usar despliegue manual.
- Para usar la CLI (opcional):

  npm install -g netlify-cli
  cd sitio-web
  netlify login
  netlify init   # conecta o crea un sitio
  netlify deploy --dir=.   # deploy de prueba (draft)
  netlify deploy --prod --dir=.  # deploy de producción

2) GitHub Pages (gratis, requiere un repo en GitHub)
- Crear un repositorio en GitHub y subir los archivos de `sitio-web`.
- Comandos (local):

  cd sitio-web
  git remote add origin git@github.com:TU_USUARIO/TU_REPO.git
  git branch -M main
  git push -u origin main

- En GitHub: Settings > Pages > seleccionar rama `main` y carpeta `/` (root) o `/docs` según cómo subas los archivos.

3) S3 + CloudFront (opción profesional)
- Crear un bucket S3 público o con hosting estático y usar CloudFront para CDN.

Notas:
- Asegurate de reemplazar `TU_USUARIO/TU_REPO.git` por tu repo real.
- Para Netlify y GitHub Pages las actualizaciones se publican automáticamente tras push si conectás el repo.

Si querés, puedo:
- crear el commit inicial localmente (listo) y dejar los comandos listos para push.
- ayudarte a crear el repositorio en GitHub (necesitaré que pegues el `git remote` que quieras usar o que me confirmes el nombre del repo).
