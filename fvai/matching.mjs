// Match select options conservatively. Partial matches can silently choose a
// different answer, so callers should leave unmatched fields for manual review.
const normalize = value => String(value ?? '').toLowerCase().replace(/\s+/g, ' ').trim();

export function findExactSelectOption(options, value) {
  const wanted = normalize(value);
  if (!wanted || !Array.isArray(options)) return null;
  return options.find(option =>
    normalize(option.text) === wanted || normalize(option.value) === wanted
  ) ?? null;
}
