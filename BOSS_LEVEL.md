# 🟣 BOSS LEVEL — Backend con Supabase

Para los kids que ya tienen su juego funcionando, deployado y con high score local. El próximo paso es un **leaderboard global** que comparte scores entre todos los juegos del camp.

> **Reusamos el proyecto Supabase de DinoSave (Clemente).**
> Project ID: `pakyudrjcezmasapvwgv` · [Dashboard](https://supabase.com/dashboard/project/pakyudrjcezmasapvwgv)

---

## Setup (una sola vez, antes del camp)

1. Abrí [el SQL Editor del proyecto](https://supabase.com/dashboard/project/pakyudrjcezmasapvwgv/sql/new)
2. Pegá el contenido de [`migrations/leaderboard.sql`](./migrations/leaderboard.sql)
3. Apretá **Run** (Cmd+Enter)
4. Listo — la tabla `leaderboard` queda creada con RLS abierta para el rol `anon`.

> La `anon key` es pública por diseño (va en el código del browser). Lo que te protege es la RLS — esta tabla solo permite `SELECT` e `INSERT` de filas, nunca `UPDATE` ni `DELETE`.

---

## Credenciales (listas para usar en el browser)

```
SUPABASE_URL  = https://pakyudrjcezmasapvwgv.supabase.co
SUPABASE_ANON = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBha3l1ZHJqY2V6bWFzYXB2d2d2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyOTkzNDcsImV4cCI6MjA4OTg3NTM0N30.Da2rsp-CyruTpfa_7utYeKdGxTciI4eRpX3-g0CV0WY
```

---

## Snippet listo para pegar en Claude

Cuando un kid esté listo para Boss Level, dale este prompt completo para pegar en su sesión de Claude (reemplazá `MI-NOMBRE-DE-JUEGO` con el nombre del juego del kid, ej: `dinosave-v2`, `flo-runner`):

```
Quiero que mi juego guarde el score del jugador en un leaderboard global usando Supabase.

Configuración:
- SUPABASE_URL: https://pakyudrjcezmasapvwgv.supabase.co
- SUPABASE_ANON_KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBha3l1ZHJqY2V6bWFzYXB2d2d2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyOTkzNDcsImV4cCI6MjA4OTg3NTM0N30.Da2rsp-CyruTpfa_7utYeKdGxTciI4eRpX3-g0CV0WY
- Tabla: leaderboard
- Columnas: game (text), player (text), score (int)
- El game name de mi juego es: "MI-NOMBRE-DE-JUEGO"

Por favor:
1. Cuando el jugador haga game over, pídele su nombre y guarda { game, player, score } en la tabla.
2. Muestra los TOP 10 scores de TODOS los juegos del camp en una pantalla "🏆 LEADERBOARD".
3. Usa el cliente CDN de Supabase con import desde esm.sh, no instales nada.
4. Asegúrate de que funcione abriendo el HTML directo (sin servidor).
```

---

## Patrón mínimo de código (referencia)

Por si Claude se traba, este es el patrón base:

```html
<script type="module">
  import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

  const supabase = createClient(
    'https://pakyudrjcezmasapvwgv.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBha3l1ZHJqY2V6bWFzYXB2d2d2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyOTkzNDcsImV4cCI6MjA4OTg3NTM0N30.Da2rsp-CyruTpfa_7utYeKdGxTciI4eRpX3-g0CV0WY'
  )

  // GUARDAR un score
  async function saveScore(game, player, score) {
    await supabase.from('leaderboard').insert({ game, player, score })
  }

  // LEER top 10 global
  async function topScores() {
    const { data } = await supabase
      .from('leaderboard')
      .select('*')
      .order('score', { ascending: false })
      .limit(10)
    return data
  }
</script>
```

---

## Verificación rápida

Después de correr el SQL, abrí una terminal y pegá esto para confirmar que la tabla responde:

```bash
curl -s -H "apikey: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBha3l1ZHJqY2V6bWFzYXB2d2d2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyOTkzNDcsImV4cCI6MjA4OTg3NTM0N30.Da2rsp-CyruTpfa_7utYeKdGxTciI4eRpX3-g0CV0WY" \
  "https://pakyudrjcezmasapvwgv.supabase.co/rest/v1/leaderboard?select=*&limit=1"
```

Si responde `[]` (array vacío) → tabla creada y accesible. Si responde `{"code":"42P01"}` → la tabla aún no existe, falta correr el SQL.

---

## Por qué este enfoque funciona para 9-14 años

- **Cero setup**: el kid no instala nada, no crea cuenta de Supabase, no maneja env vars.
- **La URL+key del `anon` es pública por diseño** — Supabase RLS protege la tabla.
- **Resultado visible al instante**: en 5-10 minutos ven sus scores junto a los de sus amigos.
- **Competencia social brutal** entre los Senior kids 🔥
