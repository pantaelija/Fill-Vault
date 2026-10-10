const HOSTS = ['http://localhost:11434', 'http://127.0.0.1:11434'];
export const norm = s => String(s ?? '').toLowerCase().replace(/\s+/g, ' ').trim();

export async function getSettings() {
  const { settings } = await chrome.storage.local.get('settings');
  return { model: 'qwen2.5:7b', ...settings };
}
export const setSettings = async s => {
  const { settings } = await chrome.storage.local.get('settings');
  await chrome.storage.local.set({ settings: { ...settings, ...s } });
};
export const getData = () => chrome.storage.local.get({ docs: [], facts: [] });
export const save = obj => chrome.storage.local.set(obj);

async function call(path, body) {
  let r;
  for (const h of HOSTS) {
    try {
      r = await fetch(h + path, body ? {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body)
      } : undefined);
      break;
    } catch { }
  }
  if (!r) throw new Error('Cannot reach Ollama on port 11434. Is it running? (Safari: allow the extension on localhost in Safari Settings > Extensions.)');
  if (r.status === 403) throw new Error('Ollama blocked the extension. Set OLLAMA_ORIGINS (see the rebuild guide) and restart Ollama.');
  if (r.status === 404) throw new Error('Ollama does not have that model. Run: ollama pull <model name>');
  if (!r.ok) throw new Error(`Ollama error ${r.status}: ${(await r.text()).slice(0, 200)}`);
  return r.json();
}

export async function listModels() {
  return (await call('/api/tags')).models.map(m => m.name);
}

export async function ollamaChat(system, user, schema) {
  const { model } = await getSettings();
  const j = await call('/api/chat', {
    model, stream: false, format: schema,
    options: { temperature: 0, num_ctx: 8192 },
    messages: [{ role: 'system', content: system }, { role: 'user', content: user }]
  });
  return JSON.parse(j.message.content);
}
