xquery version "3.1" encoding "UTF-8";

(: # Modules :)
(: ## BaseX :)
import module namespace od-api="od-api-basex" at "https://raw.githubusercontent.com/AdamSteffanick/od-api-xquery/master/od-api-basex.xquery";

(: # API credentials :)
let $id := "myId"
let $key := "myKey"

(: # Options :)
let $source-lang := "en"
(: ## Thesaurus :)
let $thesaurus-operation := "synonyms;antonyms" (: "synonyms", "antonyms", or "synonyms;antonyms" :)

(: # Partial function applications :)
let $thesaurus := od-api:thesaurus($source-lang, ?, $thesaurus-operation, $id, $key)

(: # Example queries
return $thesaurus("ace")
:)

return $thesaurus("ace")