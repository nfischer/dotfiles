#!/usr/bin/env node

'use strict';

// var shell = require('shelljs');
var jsdom = require('jsdom');
var jquery = require('jquery');
var googleSheets = require('google-spreadsheet');

var URL = process.argv[2] || 'https://github.com/shelljs/shelljs';
var TSV_FILE = process.argv[3] || process.env.HOME + '/.shelljs_starcount';

// Pull the web page
console.log('Fetching ' + URL);

jsdom.env({
url: URL,
  scripts: [],
  done: function(err, window) {
    console.log('Page is downloaded');
    var $ = jquery(window);
    var starCount = parseInt($('a.social-count.js-social-count').
        first().
        text().
        replace(',', ''));

    var doc = new googleSheets('1pOtUDHc5kHs0D5T7BPA3yIiwOidZ0eqaMPZ4n61Po5g');
    var cred = require('./starcount-cred.json');
    doc.useServiceAccountAuth(cred, function(err) {
      if (err) process.exit(1);
      var newRow = {
        date: (new Date()).toLocaleDateString(),
        stars: starCount.toString(),
      };
      console.log(newRow);
      doc.addRow(1, newRow, function (err) {
        if (err) process.exit(2);
        console.log('Successfully uploaded data');
      });
    });
  }
});
