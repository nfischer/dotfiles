#!/usr/bin/env node
var shell = require('shelljs');

try {
  var prNum = shell.pwd().match(/PR_(\d+)/)[1];
} catch(e) {
  console.error("Can't find PR number. Are you reviewing a pull request?");
  shell.exit(1);
}

// Change to the right directory
if (shell.test('-d', 'node_modules'))
  shell.cd('node_modules');
if (shell.test('-d', 'shelljs'))
  shell.cd('shelljs');

var result = shell.exec('git remote -v', {silent: true});
if (result.code !== 0) {
  shell.exit(result.code);
}

var regex = (result.stdout.indexOf('upstream') > 0)
    ? /upstream\s+([^\s]+)\.git/
    : /origin\s+([^\s]+)\.git/;

var url = result.stdout.match(regex)[1] + '/pull/' + prNum;

shell.echo('Launching', url);
shell.exec('x-www-browser ' + url + ' &', {silent: true});
