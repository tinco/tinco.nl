# Repository Guidelines

## Project Structure & Module Organization
- Source CoffeeScript and SCSS live at the repo root: `tinco.coffee` drives the animated header; `tinco.scss` contains the site styling.
- Built artifacts go to `public/` (`tinco.js`, `tinco.css`, `index.html`, and static images). These are what the Docker image serves through nginx. Social icons live here (github, facebook, x.svg, linkedin.svg, phusion.png, aeroscan.png, bosun.png); backgrounds expect 40x40 images.
- Docker build assets are under `docker/`; main Dockerfile has a `dev` stage for live reload, a `builder` stage that runs `make build`, and a final nginx stage for static hosting.

## Build, Test, and Development Commands
- `make build` (default) compiles SCSS with `node-sass` and CoffeeScript with `coffee`, outputting to `public/`.
- `make docker` builds and pushes the nginx image defined in `Dockerfile` for `linux/amd64`; the builder stage runs `make build` inside the container so local node-sass/coffeescript are unnecessary.
- For local preview, run any static file server against `public/` (e.g., `python3 -m http.server 8080 -d public`).
- `make dev` builds the dev Docker stage and runs a live-reload server (`nodemon` + `live-server`) on port 8080 with the repo mounted; edit `tinco.coffee`/`tinco.scss` for hot rebuilds.

## Coding Style & Naming Conventions
- CoffeeScript: keep functions small, prefer arrow functions for callbacks, and use explicit names for color/animation helpers (see `cycleColors`, `buildColorsRun`). Avoid implicit globals—attach shared state intentionally.
- SCSS: two-space indentation; nest only for clear hierarchy (as in `.post` and `.social` blocks). Use hex colors to match existing palette and keep selectors flat to avoid specificity creep. Body uses a flex layout centered vertically; `#page` is nudged up by -40px—preserve offsets unless changing the layout.
- File outputs are hashed only by name; keep input filenames stable (`tinco.*`) unless updating references in `public/index.html`.

## Testing Guidelines
- No automated test suite exists. Validate changes by running `make build`, then manually checking `public/index.html` in a browser.
- When touching the animated header, confirm the color cycle timing and layout still match the intended pixel art grid.

## Commit & Pull Request Guidelines
- Follow the existing commit style: short, imperative subjects in lowercase (e.g., `slow logo down`).
- In pull requests, describe the visual or behavioral change, steps to verify locally (commands run and pages checked), and include before/after notes or screenshots when altering UI.
- Link related issues or TODOs if available, and mention whether Docker images need rebuilding (`make docker`).

## Security & Configuration Notes
- The runtime image serves only static files; keep `public/` free of secrets. Do not bake credentials into images or HTML.
- If adding external assets or fonts, prefer locally hosted copies placed in `public/` to avoid mixed-content or CORS surprises.
