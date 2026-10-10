import test from 'node:test';
import assert from 'node:assert/strict';
import { findExactSelectOption, normalizeLabel, findFactIndexByLabel } from '../fvai/matching.mjs';

const options = [
  { value: '', text: 'Choose one' },
  { value: 'np', text: 'Nepal' },
  { value: 'us', text: 'United States' },
  { value: 'bsc', text: 'Bachelor of Science' },
];

test('matches option text without case or whitespace sensitivity', () => {
  assert.equal(findExactSelectOption(options, '  nePAL  '), options[1]);
  assert.equal(findExactSelectOption(options, 'United   States'), options[2]);
});

test('matches an exact option value', () => {
  assert.equal(findExactSelectOption(options, 'us'), options[2]);
});

test('rejects partial matches instead of guessing', () => {
  assert.equal(findExactSelectOption(options, 'United'), null);
  assert.equal(findExactSelectOption(options, 'Nepalese'), null);
  assert.equal(findExactSelectOption(options, 'Bachelor'), null);
});

test('rejects empty values and invalid option lists', () => {
  assert.equal(findExactSelectOption(options, '   '), null);
  assert.equal(findExactSelectOption(null, 'Nepal'), null);
});

import { validateMatches } from '../fvai/matching.mjs';

const fields = [{ id: 0 }, { id: 1 }, { id: 2 }];
const facts = [{ label: 'Name', value: 'Asha' }, { label: 'Email', value: 'asha@example.com' }];

test('accepts only matches pointing to existing fields and saved facts', () => {
  assert.deepEqual(validateMatches({ matches: [
    { field_id: 0, fact_index: 0 }, { field_id: 1, fact_index: 1 }
  ] }, fields, facts), [
    { field_id: 0, fact_index: 0 }, { field_id: 1, fact_index: 1 }
  ]);
});

test('rejects unknown fields, out-of-range indexes, negative indexes, and non-integers', () => {
  assert.deepEqual(validateMatches({ matches: [
    { field_id: 99, fact_index: 0 }, { field_id: 0, fact_index: 8 },
    { field_id: 1, fact_index: -1 }, { field_id: 2, fact_index: 1.5 },
    { field_id: '0', fact_index: 0 }
  ] }, fields, facts), []);
});

test('keeps only the first valid match for a field', () => {
  assert.deepEqual(validateMatches({ matches: [
    { field_id: 0, fact_index: 0 }, { field_id: 0, fact_index: 1 }
  ] }, fields, facts), [{ field_id: 0, fact_index: 0 }]);
});

test('rejects malformed model responses safely', () => {
  assert.deepEqual(validateMatches(null, fields, facts), []);
  assert.deepEqual(validateMatches({ matches: 'not an array' }, fields, facts), []);
  assert.deepEqual(validateMatches({ matches: [null, {}, { field_id: 0 }] }, fields, facts), []);
});


test('normalizes common extracted label formats without changing values', () => {
  assert.equal(normalizeLabel('mobile_number'), 'mobile number');
  assert.equal(normalizeLabel('contact-number'), 'contact number');
  assert.equal(normalizeLabel('mobileNumber'), 'mobile number');
  assert.equal(normalizeLabel('Phone Number'), 'phone number');
});

test('finds phone facts across equivalent normalized labels', () => {
  const phoneFacts = [
    { label: 'mobile_number', value: '9800000000' },
    { label: 'contact_number', value: '9811111111' },
    { label: 'email', value: 'asha@example.com' }
  ];
  assert.equal(findFactIndexByLabel(phoneFacts, /phone|mobile|telephone|tel|contact number|cell number/), 0);
  assert.equal(findFactIndexByLabel([{ label: 'contact-number' }], /contact number/), 0);
  assert.equal(findFactIndexByLabel([{ label: 'mobileNumber' }], /mobile number/), 0);
  assert.equal(findFactIndexByLabel([{ label: 'email' }], /phone|mobile|contact number/), -1);
});
