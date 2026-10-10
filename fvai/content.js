window.__ffai = (() => {
  let els = [];
  const SKIP = new Set(['password', 'hidden', 'submit', 'button', 'reset', 'image', 'file', 'search', 'checkbox', 'radio', 'color', 'range']);
  const visible = el => { const r = el.getBoundingClientRect(), s = getComputedStyle(el); return r.width > 0 && r.height > 0 && s.visibility !== 'hidden'; };
  const clean = s => (s || '').replace(/\s+/g, ' ').trim().slice(0, 200);

  function labelOf(el) {
    let t = '';
    if (el.labels && el.labels.length) t = [...el.labels].map(l => l.innerText).join(' ');
    if (!t) t = el.getAttribute('aria-label') || '';
    if (!t && el.getAttribute('aria-labelledby'))
      t = el.getAttribute('aria-labelledby').split(' ').map(i => document.getElementById(i)?.innerText || '').join(' ');
    if (!t) { const p = el.closest('label'); if (p) t = p.innerText; }
    if (!t) { const c = el.closest('div,li,td,fieldset'); t = c?.querySelector('label,legend')?.innerText || ''; }
    return clean(t);
  }

  function scan() {
    els = [...document.querySelectorAll('input,textarea,select')].filter(el =>
      !el.disabled && !el.readOnly && visible(el) && !SKIP.has(el.type) && !el.value &&
      !/cc-|one-time-code|password/.test(el.autocomplete || ''));
    return els.map((el, id) => ({
      id, tag: el.tagName.toLowerCase(), type: el.type, name: el.name || el.id || '',
      label: labelOf(el), placeholder: clean(el.placeholder),
      options: el.tagName === 'SELECT'
        ? [...el.options].filter(o => o.value !== '').slice(0, 100).map(o => ({ value: o.value, text: clean(o.text) })) : null
    }));
  }

  function setVal(el, v) {
    const proto = el.tagName === 'SELECT' ? HTMLSelectElement.prototype : el.tagName === 'TEXTAREA' ? HTMLTextAreaElement.prototype :
      HTMLInputElement.prototype;
    Object.getOwnPropertyDescriptor(proto, 'value').set.call(el, v);
    for (const t of ['input', 'change', 'blur']) el.dispatchEvent(new Event(t, { bubbles: true }));
  }

  function fill(items) {
    return items.map(({ id, value }) => {
      const el = els[id];
      if (!el || !document.contains(el)) return { id, ok: false };
      let v = value;
      if (el.tagName === 'SELECT') {
        const o = [...el.options].find(o => o.text.trim() === v || o.value === v);
        if (!o) return { id, ok: false };
        v = o.value;
      }
      setVal(el, v);
      const ok = el.value === v;
      if (ok) el.style.outline = '2px solid #4f46e5';
      return { id, ok };
    });
  }
  return { scan, fill };
})();
