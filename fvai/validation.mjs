// Validate model output before any result is used to prepare a form fill.
// The model may only refer to scanned fields and facts already in local storage.
export function validateModelMatches(output, fields, facts) {
  if (!output || typeof output !== 'object' || !Array.isArray(output.matches) ||
      !Array.isArray(fields) || !Array.isArray(facts)) return [];

  const validFieldIds = new Set(fields
    .filter(field => field && Number.isSafeInteger(field.id) && field.id >= 0)
    .map(field => field.id));
  const seenFields = new Set();
  const validated = [];

  for (const match of output.matches) {
    if (!match || typeof match !== 'object') continue;
    const { field_id, fact_index } = match;
    if (!Number.isSafeInteger(field_id) || field_id < 0 || !validFieldIds.has(field_id)) continue;
    if (!Number.isSafeInteger(fact_index) || fact_index < 0 || fact_index >= facts.length) continue;
    if (!facts[fact_index] || seenFields.has(field_id)) continue;

    seenFields.add(field_id);
    validated.push({ field_id, fact_index });
  }
  return validated;
}
