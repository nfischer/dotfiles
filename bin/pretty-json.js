#!/usr/bin/env node

let stdin = '';
process.stdin.on('data', data => {
  stdin += data;
});
process.stdin.on('end', () => {
  const jsonInput = JSON.parse(stdin);
  const prettyJson = JSON.stringify(jsonInput, null, 2);
  process.stdout.write(prettyJson);
});
