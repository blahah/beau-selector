fs = require 'fs'
path = require 'path'
log = require 'verbalize'
jsdom = require 'jsdom'
path = require 'path'

#  modified from cli-scrape
#
#  (c) 2012 Philip Thrasher & 2015 Richard Smith-Unna
#
#  cli-scrape may be freely distributed under the MIT license.
#  For all details and documentation:
#
#  http://pthrasher.github.com/cli-scrape/

# Usage
# -----
#
# `cat file.html | bo 'p:first-child'`
#
# `wget http://whatthecommit.com/ | bo '//p[0]'`

# use strict, yo!
'use strict'

absPath = (relPath) ->
 path.resolve __dirname, relPath

# These are the libraries used to do the parsing on the page. If the query is
# an xpath query, XPATH\_LIBS is used. If not, CSS\_LIBS is used instead.
XPATH_LIBS = [absPath('wgxpath.install.js')]
CSS_LIBS = [absPath('qwery.min.js', 'qwery-pseudos.min.js')]

# useXPath
# --------
#
# Determine whether or not the query passed in is an xpath query or a css query
useXPath = (query) ->
  query.indexOf('/') is 0

# fetchHTML
# ---------
#
# This is essentially a simple logging wrapper around request.get
fetchHTML = (url, cb) ->
  request.get url, (err, response, body) ->
    if err?
      return cb err, response, body

    cb err, response, body

# domParse
# --------
#
# This is essentially a simple logging wrapper around jsdom.env
domParse = (html, libs, cb) ->
  opts =
    html: html
    scripts: libs
    parsingMode: 'xml'
    done: (err, window) ->
      if err?
        return cb err, window

      cb err, window
  jsdom.env opts

# elToString
# ----------
#
# depending on the query given by the user, we will be getting an html element,
# or a plain old string. This should be handled elegantly.
elToString = (el, attribute, outer) ->
  ret = ''
  if attribute
    ret = el.getAttribute(attribute)
  else if outer && el.outerHTML?
    ret = el.outerHTML.trim()
  else if el.innerHTML?
    ret = el.innerHTML.trim()
  else if el.textContent?
    ret = el.textContent.trim()
  else if Object.prototype.toString.call(el) is '[object String]'
    ret = el.trim()
  # replace newlines with spaces so we get one result per line
  ret.replace(/\r?\n|\r/g, ' ')

# executeXPath
# ---------------
#
# Executes the given xpath query against the given window.document object using
# google's wicked fast xpath
executeXPath = (query, window) ->
  unless window.wgxpath?
    return []
  window.wgxpath.install()
  document = window.document
  els = []
  result = document.evaluate(query, document, null, 7, null)
  len = result.snapshotLength
  if len > 0
    els = (result.snapshotItem(i) for i in [0...len])
  els

# executeCSSQuery
# ---------------
#
# Executes the given css query against the given window.document object using
# window.qwery
executeCSSQuery = (query, window) ->
  unless window.qwery?
    return []
  els = window.qwery query
  els

module.exports = (xml, opts, cb) ->
  query = opts.query
  attribute = opts.attribute
  outer = opts.outer

  doc = xml

  xpath = useXPath query
  libs = CSS_LIBS
  if xpath
    libs = XPATH_LIBS

  domParse doc, libs, (err, window) ->
    if err?
      cb(err)

    if xpath
      results = executeXPath(query, window)
    else
      results = executeCSSQuery(query, window)

    if not results or results.length < 1
      cb(null, [])

    strings = []
    for result in results
      strings.push elToString(result, attribute, outer)

    cb(null, strings)
