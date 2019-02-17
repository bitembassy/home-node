#!/usr/bin/env node

const fs = require('fs')

function readFile(path, opt='') {
  let contents = fs.readFileSync(path).toString()
  contents = contents.replace(/^#!.*/, '').trim()
  if (opt.includes('no-cleanup')) {
    contents = contents.replace(/^# Cleanup previous source code.*\n.*/, '')
  }
  return contents.trim()
}

const tmplFile = process.argv[2]
    , tmplText = fs.readFileSync(tmplFile).toString()
    , generated = tmplText.replace(/\{\{include ([^} ]+)(?: ([^}]+))?\}\}/g, (_, path, opt) => readFile(path, opt))

process.stdout.write(generated)
