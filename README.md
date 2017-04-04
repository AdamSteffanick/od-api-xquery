# Oxford Dictionaries API XQuery [![version](https://img.shields.io/badge/od--api--xquery-v0.5.0-0038e2.svg?style=flat-square)][CHANGELOG]
Make requests to the [Oxford Dictionaries API] and return XML with XQuery.

## Download
* [**Latest release**](https://github.com/AdamSteffanick/od-api-xquery/releases/latest)

## Documentation
For BaseX and [Oxford Dictionaries API] v1.6.0, import the function library [od-api-basex.xquery] v0.5.0:

`import module namespace od-api="od-api-basex" at "https://raw.githubusercontent.com/AdamSteffanick/od-api-xquery/v0.5.0/od-api-basex.xquery";`

* Fork or download this repository if you prefer to use your own copy of the function library (*i.e.*, [od-api-basex.xquery])
* Use [od-api.xquery] as a template to help you get started
  * Replace *myId* and *myKey* with your own API credentials in your XQuery processor (**do not upload your API credentials to GitHub**)
* Tutorials
  * [Retrieve Oxford Dictionaries API Dictionary Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-dictionary-data-as-xml-with-xquery/)
  * [Retrieve Oxford Dictionaries API Lemma Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-lemma-data-as-xml-with-xquery/)
  * [Retrieve Oxford Dictionaries API Translation Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-translation-data-as-xml-with-xquery/)
  * [Retrieve Oxford Dictionaries API Thesaurus Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-thesaurus-data-as-xml-with-xquery/)

## Features
* [Oxford Dictionaries API] v1.6.0 compatible

[CHANGELOG]: ./CHANGELOG.md
[od-api.xquery]: ./od-api.xquery
[od-api-basex.xquery]: ./od-api-basex.xquery

[Oxford Dictionaries API]: https://developer.oxforddictionaries.com/