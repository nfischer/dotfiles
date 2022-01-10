#!/usr/bin/env node

var assert = require('assert');
var path = require('path');

var chalk = require('chalk');
var shell = require('shelljs');
var yaml = require('js-yaml');

function checkReadme(minNodeVersion) {
  var start = '<!-- start minVersion -->';
  var stop = '<!-- stop minVersion -->';
  var expectedReadmeRegex = new RegExp(
      start + '\\s*`?v?(\[^`< ]+)`?\\s*' + stop, '');
  if (!shell.test('-f', 'README.md')) {
    console.warn(chalk.yellow.bold(
        'Cannot find README.md'));
    return;
  }

  var match = shell.cat('README.md').match(expectedReadmeRegex);
  if (!match) {
    console.warn(chalk.yellow.bold(
        'There is no minVersion specified in README.md'));
    return;
  }
  var actualMin = match[1];
  if (minNodeVersion !== actualMin) {
    throw new Error('README has wrong minVersion (v' + actualMin + ')');
  }
  console.log(chalk.green.bold('README specifies the correct minVersion'));
}

function parsePackageEngines(minNodeVersion) {
  var package = require(path.resolve('package.json'));
  if (!package.engines || !package.engines.node) {
    throw new Error('Missing package.engines');
  }
  var match = package.engines.node.match(/>=\s*(\d+)(\..*)?/);
  if (match[2]) {
    console.log(chalk.yellow.bold(
        'Warn: non-standard format for package.engines: ' +
        package.engines.node));
  }
  return match[1];
}

function assertDeepEquals(arr1, arr2, msg) {
  try {
    assert.deepStrictEqual(arr1, arr2);
  } catch (e) {
    throw new Error(msg + '\n' + e);
  }
}

function range(start, stop, stepSize) {
  var ret = [];
  for (var i = start; i <= stop; i+=stepSize) {
    ret.push(i);
  }
  return ret;
}

function deepEquals(arr1, arr2) {
  if (arr1.length != arr2.length) {
    return false;
  }
  for (var i = 0; i < arr1.length; i++) {
    if (arr1[i] !== arr2[i]) {
      return false;
    }
  }
  return true;
}

function sortedArray(arr, cmp) {
  return arr.map(function (x) { return x; }).sort(cmp);
}

function toNumericArray(arr) {
  return arr.map(function (x) { return parseInt(x); });
}

function compareNumbers(a, b) {
  return a - b;
}

function checkGithubActions(minNodeVersion) {
  if (typeof minNodeVersion === 'string') {
    minNodeVersion = parseInt(minNodeVersion);
  }
  var githubActionsFileName = path.join('.github', 'workflows', 'main.yml');
  if (!shell.test('-f', githubActionsFileName)) {
    console.warn(chalk.yellow.bold('Cannot find githubActionsYaml'));
    return;
  }
  var githubActionsYaml = yaml.load(shell.cat(githubActionsFileName));
  var actualVersions = toNumericArray(
      githubActionsYaml.jobs.test.strategy.matrix['node-version']);
  var sortedActualVersions = sortedArray(actualVersions, compareNumbers);
  assertDeepEquals(actualVersions, sortedActualVersions,
      'githubActionsYaml is not sorted correctly');

  var actualMin = Math.min.apply(null, actualVersions);
  assertDeepEquals(minNodeVersion, actualMin,
      'githubActionsYaml only goes down to ' + actualMin);

  var actualMax = Math.max.apply(null, actualVersions);
  var allVersions = range(actualMin, actualMax, 1);
  var ltsVersions = allVersions.filter(function (ver) {
    return ver % 2 === 0;
  });
  if (deepEquals(actualVersions, allVersions)) {
    console.log(chalk.white.bold(
        'githubActionsYaml tests ALL versions from ' + actualMin +
        ' to '+ actualMax));
  } else if (deepEquals(actualVersions, ltsVersions)) {
    console.log(chalk.green.bold(
        'githubActionsYaml tests ONLY LTS versions from ' + actualMin +
        ' to '+ actualMax));
  } else {
    throw new Error('Unexpected node version range: ' +
        JSON.stringify(actualVersions))
  }
}

function changeToPackageRoot() {
  var lastDir;
  while (!shell.test('-f', 'package.json')) {
    if (shell.pwd().toString() === lastDir) {
      throw new Error('Unable to find a package.json file');
    }
    lastDir = shell.pwd().toString();
    shell.cd('..');
  }
}

try {
  changeToPackageRoot();

  var minVersion = parsePackageEngines();
  console.log('minVersion is v' + minVersion + ' per package.engines');

  checkReadme(minVersion);

  checkGithubActions(minVersion);
} catch (e) {
  console.error(chalk.red.bold(e));
  shell.exit(1);
}
