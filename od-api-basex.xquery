xquery version "3.1" encoding "UTF-8";

module namespace od-api = "od-api-basex";

(:~
 : A library module for the Oxford Dictionaries API.
 :
 : @author Adam Steffanick
 : https://www.steffanick.com/adam/
 : @version v0.6.0
 : https://github.com/AdamSteffanick/od-api-xquery
 : September 8, 2017
 :)

(:
MIT License

Copyright (c) 2017 Adam Steffanick

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
:)

(: # API v1.8.0 :)

(: # General functions :)
(: ## Add metadata :)
declare function od-api:metadata($response as item()*) as item()* {
  let $metadata := $response/json/metadata
  let $date := $response[1]/*[fn:name()="http:header"][@name="Date"]/@value/fn:string()
  let $version := "v0.6.0"
  return element {"metadata"} {
    $metadata/node(),
    element {"od_api_xquery"} {$version},
    element {"date"} {$date}
  }
};
(: ## Create elements for optional fragment arrays :)
declare function od-api:option($fragment as item()*, $function as xs:string) as item()* {
  (: ### General arrays :)
  if ($fragment and $function = "arrayofstrings") then
    od-api:arrayofstrings($fragment)
  else if ($fragment and $function = "CategorizedTextList") then
    element {"notes"} {
      for $note in $fragment/_
      return od-api:CategorizedTextList($note, "note")
    }
  (: ### Lemmatron arrays :)
  else if ($fragment and $function = "headwordLemmatron") then
    element {"results"} {
      for $result in $fragment/_
      return od-api:headwordLemmatron($result)
    }
  else if ($fragment/fn:name() = "grammaticalFeatures" and $function = "lemmatronGrammaticalFeaturesList") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:lemmatronGrammaticalFeaturesList($grammaticalFeature, "grammaticalFeature")
    }
  (: ### Dictionary :)
  else if ($fragment and $function = "dictionaryCategorizedTextList") then
    element {"notes"} {
      for $note in $fragment/_
      return od-api:dictionaryCategorizedTextList($note, "note")
    }
  (: ### Dictionary arrays :)
  else if ($fragment and $function = "headwordEntry") then
    element {"results"} {
      for $result in $fragment/_
      return od-api:headwordEntry($result)
    }
  else if ($fragment and $function = "ArrayOfRelatedEntries") then
    element {"relatedEntries"} {
      for $relatedEntry in $fragment/_
      return od-api:dictionaryArrayOfRelatedEntries($relatedEntry, "relatedEntry")
    }    
  else if ($fragment and $function = "entry") then
    element {"entries"} {
      for $entry in $fragment/_
      return od-api:entry($entry)
    }
  else if (($fragment/fn:name() = "senses" or "subsenses") and $function = "sense") then
    if ($fragment/fn:name() = "senses") then
      element {"senses"} {
        for $sense in $fragment/_
        return od-api:sense($sense, "sense")
      }
    else if ($fragment/fn:name() = "subsenses") then
      element {"subsenses"} {
        for $subsense in $fragment/_
        order by $subsense/domains, $subsense/regions, $subsense/registers
        return od-api:sense($subsense, "subsense")
      }
    else ()
  else if ($fragment/fn:name() = "pronunciations" and $function = "dictionaryPronunciationsList") then
    element {"pronunciations"} {
      for $pronunciation in $fragment/_
      return od-api:dictionaryPronunciationsList($pronunciation, "pronunciation")
    }
  else if ($fragment/fn:name() = "pronunciations" and $function = "dictionaryPronunciationsList") then
    element {"pronunciations"} {
      for $pronunciation in $fragment/_
      return od-api:dictionaryPronunciationsList($pronunciation, "pronunciation")
    }
  else if ($fragment/fn:name() = "grammaticalFeatures" and $function = "dictionaryGrammaticalFeaturesList") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:dictionaryGrammaticalFeaturesList($grammaticalFeature, "grammaticalFeature")
    }
  else if ($fragment/fn:name() = "variantForms" and $function = "dictionaryVariantFormsList") then
    element {"variantForms"} {
      for $variantForm in $fragment/_
      order by $variantForm/text
      return od-api:dictionaryVariantFormsList($variantForm, "variantForm")
    }
  else if ($fragment/fn:name() = "crossReferences" and $function = "dictionaryCrossReferencesList") then
    element {"crossReferences"} {
      for $crossReference in $fragment/_
      return od-api:dictionaryCrossReferencesList($crossReference, "crossReference")
    }
  else if ($fragment/fn:name() = "examples" and $function = "dictionaryExamplesList") then
    element {"examples"} {
      for $example in $fragment/_
      return od-api:dictionaryExamplesList($example, "example")
    }
  else if ($fragment/fn:name() = "translations" and $function = "dictionaryTranslationsList") then
    element {"translations"} {
      for $translation in $fragment/_
      return od-api:dictionaryTranslationsList($translation, "translation")
    }
  (: ### Thesaurus :)
  else if ($fragment and $function = "thesaurusCategorizedTextList") then
    element {"notes"} {
      for $note in $fragment/_
      return od-api:thesaurusCategorizedTextList($note, "note")
    }
  (: ### Thesaurus arrays :)
  else if ($fragment and $function = "headwordThesaurus") then
    element {"results"} {
      for $result in $fragment/_
      return od-api:headwordThesaurus($result)
    }
  else if ($fragment and $function = "thesaurusEntry") then
    element {"entries"} {
      for $entry in $fragment/_
      return od-api:thesaurusEntry($entry)
    }
  else if (($fragment/fn:name() = "senses" or "subsenses") and $function = "thesaurusSense") then
    if ($fragment/fn:name() = "senses") then
      element {"senses"} {
        for $sense in $fragment/_
        return od-api:thesaurusSense($sense, "sense")
      }
    else if ($fragment/fn:name() = "subsenses") then
      element {"subsenses"} {
        for $subsense in $fragment/_
        order by $subsense/domains, $subsense/regions, $subsense/registers
        return od-api:thesaurusSense($subsense, "subsense")
      }
    else ()
  else if ($fragment/fn:name() = "variantForms" and $function = "thesaurusVariantFormsList") then
    element {"variantForms"} {
      for $variantForm in $fragment/_
      order by $variantForm/text
      return od-api:thesaurusVariantFormsList($variantForm, "variantForm")
    }
  else if (($fragment/fn:name() = "synonyms" or "antonyms") and $function = "thesaurusSynonymsAntonyms") then
      if ($fragment/fn:name() = "synonyms") then
        element {"synonyms"} {
          for $synonym in $fragment/_
          order by $synonym/text
          return od-api:thesaurusSynonymsAntonyms($synonym, "synonym")
        }
      else if ($fragment/fn:name() = "antonyms") then
        element {"antonyms"} {
          for $antonym in $fragment/_
          return od-api:thesaurusSynonymsAntonyms($antonym, "antonym")
        }
      else ()
  else if ($fragment and $function = "thesaurusExamplesList") then
    element {"examples"} {
      for $example in $fragment/_
      return od-api:thesaurusExamplesList($example, "example")
    }
  else if ($fragment and $function = "thesaurusTranslationsList") then
    element {"translations"} {
      for $translation in $fragment/_
      return od-api:thesaurusTranslationsList($translation, "translation")
    }
  else if ($fragment and $function = "thesaurusGrammaticalFeaturesList") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:thesaurusGrammaticalFeaturesList($grammaticalFeature, "grammaticalFeature")
    }
  else ()
};
(: CategorizedTextList :) (: deprecated :)
declare function od-api:CategorizedTextList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/id, "arrayofstrings"),
    $fragment/text,
    $fragment/type
  }
};
(: ## Create elements for string arrays :)
declare function od-api:arrayofstrings($nodes as node()*) as item()* {
  for $node in $nodes
  return typeswitch($node)
  case text() return $node
  case element(crossReferenceMarkers) return element {fn:name($node)} {
    for $n in $node/_
    return element {"crossReferenceMarker"} {od-api:arrayofstrings($n/node())}
  }
  case element(definitions) return element {fn:name($node)} {
    for $n in $node/_
    return element {"definition"} {od-api:arrayofstrings($n/node())}
  }
  case element(dialects) return element {fn:name($node)} {
    for $n in $node/_
    return element {"dialect"} {od-api:arrayofstrings($n/node())}
  }
  case element(domains) return element {fn:name($node)} {
    for $n in $node/_
    return element {"domain"} {od-api:arrayofstrings($n/node())}
  }
  case element(etymologies) return element {fn:name($node)} {
    for $n in $node/_
    return element {"etymology"} {od-api:arrayofstrings($n/node())}
  }
  case element(regions) return element {fn:name($node)} {
    for $n in $node/_
    return element {"region"} {od-api:arrayofstrings($n/node())}
  }
  case element(registers) return element {fn:name($node)} {
    for $n in $node/_
    return element {"register"} {od-api:arrayofstrings($n/node())}
  }
  case element(senseIds) return element {fn:name($node)} {
    for $n in $node/_
    return element {"senseId"} {od-api:arrayofstrings($n/node())}
  }
  default return $node
};

(: # Lemmatron functions [API v1.8.0] :)
(: ## Lemmatron :)
declare function od-api:lemmatron($source_lang as xs:string, $word-id as xs:string, $filter as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $filters :=
    if ($filter) then
      fn:concat("/", $filter)
    else ()
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/inflections/{$source_lang}/{$word_id}{$filters}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"lemmatron"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordLemmatron")
  }
};
(: ## HeadwordLemmatron :)
declare function od-api:headwordLemmatron($result as node()*) as item()* {
  element {"result"} {
    $result/id,
    $result/language,
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:lemmatronLexicalEntry($lexicalEntry)
    },
    $result/type,
    $result/word
  }
};
(: ## LemmatronLexicalEntry :)
declare function od-api:lemmatronLexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    od-api:option($lexicalEntry/grammaticalFeatures, "lemmatronGrammaticalFeaturesList"),
    od-api:lemmatronInflectionsList($lexicalEntry/inflectionOf),
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    $lexicalEntry/text
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:lemmatronGrammaticalFeaturesList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};
(: ## InflectionsList :)
declare function od-api:lemmatronInflectionsList($inflectionOf as node()*) as item()* {
  element {"inflectionOf"} {
    for $wordform in $inflectionOf/_
    order by $wordform/text
    return element {"wordform"} {
      $wordform/id,
      $wordform/text
    }
  }
};

(: # Dictionary functions [API v1.8.0] :)
(: ## Dictionary :)
declare function od-api:dictionary($source_lang as xs:string, $word-id as xs:string, $filter as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $filters :=
    if ($filter) then
      fn:concat("/", $filter)
    else ()
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/entries/{$source_lang}/{$word_id}{$filters}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"dictionary"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordEntry")
  }
};
(: ## HeadwordEntry :)
declare function od-api:headwordEntry($result as node()*) as item()* {
  element {"result"} {
    $result/id,
    $result/language,
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:lexicalEntry($lexicalEntry)
    },
    od-api:option($result/pronunciations, "dictionaryPronunciationsList"),
    $result/type,
    $result/word
  }
};
(: ## lexicalEntry :)
declare function od-api:lexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    od-api:option($lexicalEntry/derivativeOf, "ArrayOfRelatedEntries"),
    od-api:option($lexicalEntry/entries, "entry"),
    od-api:option($lexicalEntry/grammaticalFeatures, "dictionaryGrammaticalFeaturesList"),
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    od-api:option($lexicalEntry/notes, "dictionaryCategorizedTextList"),
    od-api:option($lexicalEntry/pronunciations, "dictionaryPronunciationsList"),
    $lexicalEntry/text,
    od-api:option($lexicalEntry/variantForms, "dictionaryVariantFormsList")
  }
};
(: ## PronunciationsList :)
declare function od-api:dictionaryPronunciationsList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/audioFile,
    od-api:option($fragment/dialects, "arrayofstrings"),
    $fragment/phoneticNotation,
    $fragment/phoneticSpelling,
    od-api:option($fragment/regions, "arrayofstrings")
  }
};
(: ## ArrayOfRelatedEntries :)
declare function od-api:dictionaryArrayOfRelatedEntries($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    $fragment/id,
    $fragment/language,
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};
(: ## Entry :)
declare function od-api:entry($entry as node()*) as item()* {
  element {"entry"} {
    od-api:option($entry/etymologies, "arrayofstrings"),
    od-api:option($entry/grammaticalFeatures, "dictionaryGrammaticalFeaturesList"),
    $entry/homographNumber,
    od-api:option($entry/notes, "dictionaryCategorizedTextList"),
    od-api:option($entry/pronunciations, "dictionaryPronunciationsList"),
    od-api:option($entry/senses, "sense"),
    od-api:option($entry/variantForms, "dictionaryVariantFormsList")
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:dictionaryGrammaticalFeaturesList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};
(: CategorizedTextList :)
declare function od-api:dictionaryCategorizedTextList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/id,
    $fragment/text,
    $fragment/type
  }
};
(: ## VariantFormsList :)
declare function od-api:dictionaryVariantFormsList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/regions, "arrayofstrings"),
    $fragment/text
  }
};
(: ## Sense :)
declare function od-api:sense($sense as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($sense/crossReferenceMarkers, "arrayofstrings"),
    od-api:option($sense/crossReferences, "dictionaryCrossReferencesList"),
    od-api:option($sense/definitions, "arrayofstrings"),
    od-api:option($sense/domains, "arrayofstrings"),
    od-api:option($sense/examples, "dictionaryExamplesList"),
    $sense/id,
    od-api:option($sense/notes, "dictionaryCategorizedTextList"),
    od-api:option($sense/pronunciations, "dictionaryPronunciationsList"),
    od-api:option($sense/regions, "arrayofstrings"),
    od-api:option($sense/registers, "arrayofstrings"),
    od-api:option($sense/subsenses, "sense"),
    od-api:option($sense/translations, "dictionaryTranslationsList"),
    od-api:option($sense/variantForms, "dictionaryVariantFormsList")
  }
};
(: ## CrossReferencesList :)
declare function od-api:dictionaryCrossReferencesList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/id,
    $fragment/text,
    $fragment/type
  }
};
(: ## ExamplesList :)
declare function od-api:dictionaryExamplesList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/definitions, "arrayofstrings"),
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/notes, "dictionaryCategorizedTextList"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    od-api:option($fragment/senseIds, "arrayofstrings"),
    $fragment/text,
    od-api:option($fragment/translations, "dictionaryTranslationsList")
  }
};
(: ## TranslationsList :)
declare function od-api:dictionaryTranslationsList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/grammaticalFeatures, "dictionaryGrammaticalFeaturesList"),
    $fragment/language,
    od-api:option($fragment/notes, "dictionaryCategorizedTextList"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};

(: # Thesaurus functions [API v1.8.0] :)
(: ## Thesaurus :)
declare function od-api:thesaurus($source_lang as xs:string, $word-id as xs:string, $operation as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/entries/{$source_lang}/{$word_id}/{$operation}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"thesaurus"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordThesaurus")
  }
};
(: ## HeadwordThesaurus :)
declare function od-api:headwordThesaurus($result as node()*) as item()* {
  element {"result"} {
    $result/id,
    $result/language,
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:thesaurusLexicalEntry($lexicalEntry)
    },
    $result/type,
    $result/word
  }
};
(: ## ThesaurusLexicalEntry :)
declare function od-api:thesaurusLexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    od-api:option($lexicalEntry/entries, "thesaurusEntry"),
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    $lexicalEntry/text,
    od-api:option($lexicalEntry/variantForms, "thesaurusVariantFormsList")
  }
};
(: ## ThesaurusEntry :)
declare function od-api:thesaurusEntry($entry as node()*) as item()* {
  element {"entry"} {
    $entry/homographNumber,
    od-api:option($entry/senses, "thesaurusSense"),
    od-api:option($entry/variantForms, "thesaurusVariantFormsList")
  }
};
(: ## VariantFormsList :)
declare function od-api:thesaurusVariantFormsList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/regions, "arrayofstrings"),
    $fragment/text
  }
};
(: ## ThesaurusSense :)
declare function od-api:thesaurusSense($sense as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($sense/antonyms, "thesaurusSynonymsAntonyms"),
    od-api:option($sense/domains, "arrayofstrings"),
    od-api:option($sense/examples, "thesaurusExamplesList"),
    $sense/id,
    od-api:option($sense/regions, "arrayofstrings"),
    od-api:option($sense/registers, "arrayofstrings"),
    od-api:option($sense/subsenses, "thesaurusSense"),
    od-api:option($sense/synonyms, "thesaurusSynonymsAntonyms")
  }
};
(: ## SynonymsAntonyms :)
declare function od-api:thesaurusSynonymsAntonyms($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    $fragment/id,
    $fragment/language,
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};
(: ## ExamplesList :)
declare function od-api:thesaurusExamplesList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/definitions, "arrayofstrings"),
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/notes, "thesaurusCategorizedTextList"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    od-api:option($fragment/senseIds, "arrayofstrings"),
    $fragment/text,
    od-api:option($fragment/translations, "thesaurusTranslationsList")
  }
};
(: CategorizedTextList :)
declare function od-api:thesaurusCategorizedTextList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/id,
    $fragment/text,
    $fragment/type
  }
};
(: ## TranslationsList :)
declare function od-api:thesaurusTranslationsList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/grammaticalFeatures, "thesaurusGrammaticalFeaturesList"),
    $fragment/language,
    od-api:option($fragment/notes, "thesaurusCategorizedTextList"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:thesaurusGrammaticalFeaturesList($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};

(: # Translation functions [API v1.8.0] :)
(: ## Translation :)
declare function od-api:translation($source_lang as xs:string, $word-id as xs:string, $target_lang as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/entries/{$source_lang}/{$word_id}/translations={$target_lang}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"translation"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    attribute {"target-language"} {$target_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordEntry")
  }
};