#!/usr/bin/env node

var shell = require('shelljs');
var clipboard = import('clipboardy');

function main(fileName) {
  if (!fileName) {
    console.error('Please specify the javascript file to read in.');
    shell.exit(1);
  }
  shell.echo(`reading in file ${fileName}`);
  var output = shell.cat(fileName)
                    .replace(/\/\/.*\n/g, '')
                    .replace(/^\n+/, '')
                    .replace(/\n+/g, '\n')
                    .replace(/;\n/g, ';')
                    .replace(/\n/g, ';');
  output += 'null;'; // 'null' ensures we don't wipe out the current document.
  output = encodeURI(output);

  output = 'javascript:' + output;
  clipboard.then(clip => {
    shell.echo(output);
    clip.default.writeSync(output);
    shell.echo('\nCopied to clipboard!');
  });
}

if (require.main === module) {
  main(process.argv[2])
}
