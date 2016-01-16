## beau-selector

When I say `bo`, [you say 'selector'](https://youtu.be/vEtWdI9FByA?t=47s).

Run XPath or CSS selectors on arbitrary XML documents in the command-line.

## installation

```
npm install --global beau-selector
```

## usage

Just pipe a document to `bo` and provide a selector!


```
Usage: bo [xpath|css]

If no attribute is given, innerHTML, text or a plain string
will be returned (depending on what is matched)

Options:
  -o, --outer      get outer XML of the element
  -a, --attribute
  -l, --loglevel                                 [default: "silent"]
```


You can also optionally specify:

- `--outer` to return the full outer markup of selected elements
- `--attribute <string>` an attribute to extract from the selected element (which will only apply *if* what was selected is an element), e.g. `--attribute href`
- `--loglevel <string>` to be more shouty, e.g `--loglevel verbose`

## examples

css selectors

```
# get anchor elements from some_document.html
cat some_document.html | bo 'a'

# this time get the hrefs
cat some_document.html | bo `a` --atribute href
```

xpath selectors

```
# get inner HTML of divs from google.com
wget -O - http://google.com | bo '//div'

# get the outer XML of all figures from a paper in EuropePMC
curl -L --silent \
 http://www.ebi.ac.uk/europepmc/webservices/rest/PMC1318471/fullTextXML \
 | bo "//*[local-name()='fig']" --outer
```

## boring stuff

license: MIT

created by: Rik Smith-Unna

forked from: [cli-scrape](https://github.com/pthrasher/cli-scrape) and modded to take piped input rather than downloading directly, work on XML, and have some more powerful options
