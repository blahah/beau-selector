## beau-selector

When I say `bo`, you say 'selector'.

Run XPath or CSS selectors on arbitrary XML documents in the command-line.

## installation

```
npm install --global beau-selector
```

## usage

just pipe a document to `bo` and provide a selector

## examples

```
cat some_document.html | bo 'a'
wget -O - http://google.com | bo '//div'

## other stuff

license: MIT
created by: Rik Smith-Unna
forked from: [cli-scrape](https://github.com/pthrasher/cli-scrape) and modded to take piped input rather than downloading directly
