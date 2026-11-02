# tinyworldformer — playable in the browser

Games from [SheepSeb/tinyworldformer](https://github.com/SheepSeb/tinyworldformer):
there is no game code here. Every frame is dreamed by the int8 looped transformer
that runs on a Raspberry Pi Pico 2 W, compiled to WebAssembly and run on your CPU.
A stream-x agent plays; press a game key to take over.

Five games: `breakout`, `doomlite`, `flappy`, `pacman`, `pong`.

Play: <https://antono4.github.io/game/>

## Run locally

```bash
cd game
./serve.sh                 # http://localhost:12000
```

Or with any static server: `python3 -m http.server 8000 -d game`.
Serving over HTTP is required (`fetch` of the `.wasm` files fails on `file://`).

## Controls

| key | action |
|---|---|
| `a` `d` | left / right (breakout, doom-lite turn) |
| `w` `s` | up / down, forward / wait |
| `space` | flap / fire / keep going |
| `g` | hand back to the agent |
| `l` | learn on the fly (stream-x, on your CPU) |
| `r` | learn from scratch |
| `1`–`4` | number of transformer loops (speed vs accuracy) |
| `f` | fast mode |

Arrow keys map to `w`/`a`/`s`/`d`. On-screen buttons work too.

## Layout

| path | contents |
|---|---|
| `game/index.html` | the page: canvas, controls, stats |
| `game/envs.json` | which games are available |
| `game/<game>.wasm` | one module per game, from `tinyworldformer-rs/web/build.sh` |
| `game/serve.sh` | restart-on-exit static server for port 12000 |
| `gh-pages` branch | the built site at its root; GitHub Pages serves it |

## Rendering

The engine emits one colour per grid cell (16×20 up to 48×48). The page does not just
upscale those cells: it reads the raw token grid (a `grid()` export added to
`web/src/lib.rs`) and redraws every frame at display resolution — gradients for the
pong court, flappy sky and doom-lite ceiling/floor, crisp structure for walls, pipes
and pellets, and real sprites for the ball, bird, Pac-Man and the ghosts. Colours come
from the frame itself, so the palette stays the one the model was trained on. A canvas
is sized to a whole number of device pixels per cell, so the browser never rescales it.

## Rebuilding

The `.wasm` files are build output from the upstream repo, plus the `grid()` export.
To reproduce them:

```bash
git clone https://github.com/SheepSeb/tinyworldformer
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
rustup target add wasm32-unknown-unknown
cd tinyworldformer/tinyworldformer-rs/web && ./build.sh
```

Pretrained weights are committed upstream under `tinyworldformer-rs/models/`, so no
training step is needed.

## Credits

All model, engine and page code is by [SheepSeb](https://github.com/SheepSeb). This
repository only hosts the built browser demo.
