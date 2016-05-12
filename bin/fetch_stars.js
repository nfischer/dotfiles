#!/usr/bin/env node

'use strict';

var shell = require('shelljs');
var xpath = require('xpath');
var dom = require('xmldom').DOMParser;

var TSV_FILE = '/home/nate/.shelljs_starcount';

var URL = process.argv[2] ? process.argv[2] : 'https://github.com/shelljs/shelljs';

// Pull the web page
shell.echo('Fetching ' + URL);
shell.config.silent = true;
var html = shell.exec('curl ' + URL).stdout;
shell.config.silent = false;

var parserArgs = {
    errorHandler:{} // silence error messages
};
var doc = new dom(parserArgs).parseFromString(html);
var nodes = xpath.select('//a[@class="social-count js-social-count"]', doc);

var starString = nodes[0].firstChild.data
var starCount = parseInt(starString.replace(',', ''));

shell.ShellString((new Date()).toLocaleDateString() + '\t' + starCount + '\n').toEnd(TSV_FILE);
shell.echo('Appended to ' + TSV_FILE);
