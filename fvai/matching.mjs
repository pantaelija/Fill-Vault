// Match select options conservatively. Partial matches can silently choose a
// different answer, so callers should leave unmatched fields for manual review.
const normalize = value => String(value ?? '').toLowerCase().replace(/\s+/g, ' ').trim();

// Normalize extracted labels such as mobile_number, contact-number, and mobileNumber.
export const normalizeLabel = value => String(value ?? '')
  .replace(/([a-z])([A-Z])/g, '$1 $2')
  .replace(/[_-]+/g, ' ')
  .toLowerCase()
  .replace(/[^a-z0-9]+/g, ' ')
  .replace(/\s+/g, ' ')
  .trim();

// Search saved facts by normalized label, not by their raw spelling.
export function findFactIndexByLabel(facts, pattern) {
  if (!Array.isArray(facts) || !(pattern instanceof RegExp)) return -1;
  return facts.findIndex(fact => pattern.test(normalizeLabel(fact?.label)));
}

export function findExactSelectOption(options, value) {
  const wanted = normalize(value);
  if (!wanted || !Array.isArray(options)) return null;
  return options.find(option =>
    normalize(option.text) === wanted || normalize(option.value) === wanted
  ) ?? null;
}

// Validate model output against fields and saved facts that actually exist.
// Accepted results refer only to saved facts; model-generated values are never used.
export function validateMatches(output, fields, facts) {
  if (!output || typeof output !== 'object' || !Array.isArray(output.matches) ||
      !Array.isArray(fields) || !Array.isArray(facts)) return [];
  const validFieldIds = new Set(fields.map(field => field?.id).filter(Number.isInteger));
  const usedFields = new Set();
  const accepted = [];
  for (const match of output.matches) {
    if (!match || typeof match !== 'object' ||
        !Number.isInteger(match.field_id) || !Number.isInteger(match.fact_index) ||
        match.fact_index < 0 || match.fact_index >= facts.length ||
        !validFieldIds.has(match.field_id) || usedFields.has(match.field_id)) continue;
    usedFields.add(match.field_id);
    accepted.push({ field_id: match.field_id, fact_index: match.fact_index });
  }
  return accepted;
}
