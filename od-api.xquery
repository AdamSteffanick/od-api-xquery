xquery version "3.1" encoding "UTF-8";

(: # Modules :)
(: ## BaseX :)
import module namespace od-api="od-api-basex" at "https://raw.githubusercontent.com/AdamSteffanick/od-api-xquery/master/od-api-basex.xquery";

(: # API credentials :)
let $id := "myId"
let $key := "myKey"

(: # Options :)
let $source-lang := "en"
(: ## Dictionary :)
let $dictionary-filters := "" (: "regions=gb", "lexicalCategory=noun", "definitions", "examples", or "pronunciations" :)
(: ## Lemmatron :)
let $lemmatron-filters := "" (: "lexicalCategory=noun" :)
(: ## Thesaurus :)
let $thesaurus-operation := "synonyms;antonyms" (: "synonyms", "antonyms", or "synonyms;antonyms" :)

(: # Partial function applications :)
let $dictionary := od-api:dictionary($source-lang, ?, $dictionary-filters, $id, $key)
let $lemmatron := od-api:lemmatron($source-lang, ?, $lemmatron-filters, $id, $key)
let $thesaurus := od-api:thesaurus($source-lang, ?, $thesaurus-operation, $id, $key)

(: # Example queries
return $dictionary("ace")
return $lemmatron("change")
return $thesaurus("ace")
:)

return $dictionary("ace")