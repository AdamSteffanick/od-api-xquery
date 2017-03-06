# Oxford Dictionaries API XQuery
Make requests to the Oxford Dictionaries API and return XML with XQuery.

## Documentation
- Fork or download this repository if you prefer to use your own copy of the function library (*i.e.*, *od-api-basex.xquery*)
- Use *od-api.xquery* as a template to help you get started
 - Replace *myId* and *myKey* with your own API credentials in your XQuery processor (**do not upload your API credentials to GitHub**)
- Tutorials
 - [Retrieve Oxford Dictionaries API Dictionary Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-dictionary-data-as-xml-with-xquery/)
 - [Retrieve Oxford Dictionaries API Lemma Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-lemma-data-as-xml-with-xquery/)
 - [Retrieve Oxford Dictionaries API Translation Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-translation-data-as-xml-with-xquery/)
 - [Retrieve Oxford Dictionaries API Thesaurus Data as XML with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-oxford-dictionaries-api-thesaurus-data-as-xml-with-xquery/)

## Versions
### 0.4.1
- Fixed complex logical expressions in `od-api:option` (*od-api-basex.xquery*)

### 0.4.0
- Added API 1.5.0 translation functions (*od-api-basex.xquery*)
- Added translation template (*od-api.xquery*)

### 0.3.0
- Added API 1.5.0 dictionary functions (*od-api-basex.xquery*)
- Added dictionary template (*od-api.xquery*)

### 0.2.0
- Added API 1.5.0 lemmatron functions (*od-api-basex.xquery*)
- Added lemmatron template (*od-api.xquery*)

### 0.1.0
- Added od-api-basex.xquery
- Added od-api.xquery
- Added API 1.5.0 thesaurus functions (*od-api-basex.xquery*)
- Added thesaurus template (*od-api.xquery*)