#!/usr/bin/env node

'use strict';

var shell = require('shelljs');
var jsdom = require('jsdom');
var jquery = require('jquery');

var URL = process.argv[2] || 'https://github.com/shelljs/shelljs';
var TSV_FILE = process.argv[3] || process.env.HOME + '/.shelljs_starcount';

// Pull the web page
shell.echo('Fetching ' + URL);

jsdom.env({
url: URL,
  scripts: [],
  done: function(err, window) {
    console.log('done');
    var $ = jquery(window);
    var starCount = parseInt($('a.social-count.js-social-count').
        first().
        text().
        replace(',', ''));

    shell.ShellString((new Date()).toLocaleDateString() + '\t' + starCount + '\n').toEnd(TSV_FILE);
    shell.echo('Appended to ' + TSV_FILE);
  }
});
