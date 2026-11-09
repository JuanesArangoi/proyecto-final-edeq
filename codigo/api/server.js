const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function init() {
  await pool.query(`CREATE TABLE IF NOT EXISTS reportes (
    id SERIAL PRIMARY KEY,
    municipio TEXT NOT NULL,
    direccion TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    estado TEXT NOT NULL DEFAULT 'recibido',
    creado TIMESTAMPTZ NOT NULL DEFAULT now()
  )`);
}

app.get('/api/health', async (req, res) => {
  try {
    const r = await pool.query('SELECT now() AS hora');
    res.json({ api: 'ok', base_de_datos: 'ok', hora: r.rows[0].hora });
  } catch (e) {
    res.status(500).json({ api: 'ok', base_de_datos: 'error', detalle: e.message });
  }
});

app.get('/api/reportes', async (req, res) => {
  const r = await pool.query('SELECT * FROM reportes ORDER BY id DESC LIMIT 20');
  res.json(r.rows);
});

app.post('/api/reportes', async (req, res) => {
  const { municipio, direccion, descripcion } = req.body || {};
  if (!municipio || !direccion || !descripcion) {
    return res.status(400).json({ error: 'Faltan campos: municipio, direccion, descripcion' });
  }
  const r = await pool.query(
    'INSERT INTO reportes (municipio, direccion, descripcion) VALUES ($1, $2, $3) RETURNING *',
    [municipio, direccion, descripcion]
  );
  res.status(201).json(r.rows[0]);
});

const port = process.env.PORT || 3000;
(async function start() {
  for (let i = 0; i < 20; i++) {
    try { await init(); break; }
    catch (e) { console.log('Esperando base de datos...', e.message); await new Promise(r => setTimeout(r, 3000)); }
  }
  app.listen(port, () => console.log('API escuchando en ' + port));
})();
