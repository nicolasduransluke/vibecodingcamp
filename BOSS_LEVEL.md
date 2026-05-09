# 🟣 BOSS LEVEL — Backend con Supabase

Para los kids que ya tienen su juego funcionando, deployado y con high score local. El próximo paso es un **leaderboard global** que comparte scores entre todos los juegos del camp.

---

## Setup (una sola vez)

Necesitamos una tabla `leaderboard` en Supabase con este schema:

```sql
CREATE TABLE leaderboard (
  id BIGSERIAL PRIMARY KEY,
  game TEXT NOT NULL,        -- 'dinosave-v2', 'flo-runner', etc.
  player TEXT NOT NULL,      -- nombre del jugador
  score INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Permitir lectura/escritura pública desde el browser
ALTER TABLE leaderboard ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anyone can read"  ON leaderboard FOR SELECT TO anon USING (true);
CREATE POLICY "anyone can write" ON leaderboard FOR INSERT TO anon WITH CHECK (true);
```

> Reusamos el proyecto Supabase de **DinoSave** (Clemente). Las credenciales están abajo — **NO las subas al repo**.

---

## Snippet listo para pegar en Claude

Cuando un kid esté listo para Boss Level, dale este prompt para pegar en su sesión de Claude:

```
Quiero que mi juego guarde el score del jugador en un leaderboard global usando Supabase.

Configuración:
- SUPABASE_URL: https://XXXXX.supabase.co
- SUPABASE_ANON_KEY: eyJhbGciOiJIUzI1...
- Tabla: leaderboard
- Columnas: game (text), player (text), score (int)
- El game name de mi juego es: "MI-NOMBRE-DE-JUEGO"

Por favor:
1. Cuando el jugador haga game over, pídele su nombre y guarda { game, player, score } en la tabla.
2. Muestra los TOP 10 scores de TODOS los juegos del camp en una pantalla "🏆 LEADERBOARD".
3. Usa el cliente CDN de Supabase con import desde unpkg, no instales nada.
4. Asegúrate de que funcione abriendo el HTML directo (sin servidor).
```

> Reemplazá `XXXXX` y `eyJhbGc...` con las credenciales reales antes de dárselo al kid.

---

## Patrón mínimo de código (referencia)

Por si Claude se traba, este es el patrón base:

```html
<script type="module">
  import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

  const supabase = createClient(
    'https://XXXXX.supabase.co',
    'eyJhbGciOiJIUzI1...'
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

## Por qué este enfoque funciona para 9-14 años

- **Cero setup**: el kid no instala nada, no crea cuenta de Supabase, no maneja env vars.
- **El URL+key del anon es público por diseño** — Supabase RLS protege la tabla.
- **Resultado visible al instante**: en 5-10 minutos ven sus scores junto a los de sus amigos.
- **Competencia social brutal** entre los Senior kids 🔥
