const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const extensionDir = path.join(root, 'fvai');
const manifest = JSON.parse(
  fs.readFileSync(path.join(extensionDir, 'manifest.json'), 'utf8')
);

test('extension manifest uses Manifest V3', () => {
  assert.equal(manifest.manifest_version, 3);
  assert.ok(manifest.name);
  assert.ok(manifest.version);
});

test('manifest popup points to an existing file', () => {
  assert.ok(manifest.action && manifest.action.default_popup);
  assert.ok(
    fs.existsSync(path.join(extensionDir, manifest.action.default_popup)),
    `Missing popup: ${manifest.action.default_popup}`
  );
});

test('Ollama access is restricted to localhost', () => {
  assert.ok(Array.isArray(manifest.host_permissions));
  assert.ok(manifest.host_permissions.length > 0);
  for (const host of manifest.host_permissions) {
    assert.match(
      host,
      /^http:\/\/(localhost|127\.0\.0\.1):11434\/\*$/,
      `Unexpected host permission: ${host}`
    );
  }

  const csp = manifest.content_security_policy?.extension_pages ?? '';
  assert.match(csp, /connect-src/);
  assert.match(csp, /http:\/\/localhost:11434/);
  assert.match(csp, /http:\/\/127\.0\.0\.1:11434/);
});

test('core extension and local demo files exist', () => {
  for (const file of [
    'common.js',
    'content.js',
    'popup.js',
    manifest.action.default_popup
  ]) {
    assert.ok(
      fs.existsSync(path.join(extensionDir, file)),
      `Missing extension file: fvai/${file}`
    );
  }

  assert.ok(fs.existsSync(path.join(root, 'test', 'form.html')));
});
