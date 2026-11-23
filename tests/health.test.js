const test = require('node:test');
const assert = require('node:assert/strict');
const { handler } = require('../netlify/functions/health');

// Contrato mínimo de /api/health: HTTP 200, cuerpo {"status":"ok"} y content-type JSON.

test('health responde HTTP 200', async () => {
  const response = await handler();
  assert.equal(response.statusCode, 200);
});

test('health devuelve el cuerpo {"status":"ok"}', async () => {
  const response = await handler();
  assert.deepEqual(JSON.parse(response.body), { status: 'ok' });
});

test('health declara content-type JSON', async () => {
  const response = await handler();
  assert.match(response.headers['content-type'], /application\/json/);
});
