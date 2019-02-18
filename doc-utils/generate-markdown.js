#!/usr/bin/env node

const fs = require('fs')

const readFile = path =>
  fs.readFileSync(path).toString()
    .replace(/^#!.*/, '').trim()
    .trim()

const tmplFile = process.argv[2]
    , tmplText = fs.readFileSync(tmplFile).toString()
    , generated = tmplText.replace(/\{\{include ([^}]+)\}\}/g, (_, path, opt) => readFile(path, opt))

console.log('<!-- Auto generated from the .tmpl.md file; DO NOT EDIT -->\n\n')
process.stdout.write(generated)
