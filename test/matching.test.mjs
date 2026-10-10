import test from 'node:test';
import assert from 'node:assert/strict';
import { findExactSelectOption } from '../fvai/matching.mjs';

const options = [
  { value: '', text: 'Choose one' },
  { value: 'np', text: 'Nepal' },
  { value: 'us', text: 'United States' },
  { value: 'bsc', text: 'Bachelor of Science' },
];

test('matches option text without case or whitespace sensitivity', () => {
  assert.equal(findExactSelectOption(options, '  nePAL  '), options[1]);
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
