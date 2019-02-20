#!/usr/bin/env node

const fs = require('fs')

const includeFile = path =>
  fs.readFileSync(path).toString()
    .replace(/^#!.*/, '').trim()
    .trim()

const tmplText = fs.readFileSync('/dev/stdin').toString()
    , generated = tmplText.replace(/\{\{include ([^}]+)\}\}/g, (_, path, opt) => includeFile(path, opt))

console.log('<!-- Auto generated from the .tmpl.md file; DO NOT EDIT -->\n\n')
process.stdout.write(generated)
