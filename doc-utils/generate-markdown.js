#!/usr/bin/env node

const fs = require('fs')

const vars = Object.entries(process.env)
  .filter(([ k, v ]) => k.startsWith('PGP_') || k.endsWith('_VERSION'))
  .reduce((o, [k, v]) => ({ ...o, [k]: v }), {})

const includeFile = path =>
  fs.readFileSync(path).toString()
    .replace(/^#!.*/, '').trim()
    .replace(/\$(\w+)/g, (m, key) => key in vars ? vars[key] : m)
    .trim()

const generated = fs.readFileSync('/dev/stdin').toString()
  .replace(/\{\{include ([^}]+)\}\}/g, (_, path) => includeFile(path))
  .replace(/\$(\w+)/g, (m, key) => key in vars ? vars[key] : m)

console.log('<!-- Auto generated from the .tmpl.md file; DO NOT EDIT -->\n\n')
process.stdout.write(generated)
