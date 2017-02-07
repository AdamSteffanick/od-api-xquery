xquery version "3.1" encoding "UTF-8";

module namespace od-api = "od-api-basex";

(: # API 1.5.0 :)

(: # General functions :)
(: ## Create elements for optional fragment arrays :)
declare function od-api:option($fragment as item()*, $function as xs:string) as item()* {
  (: ### General arrays :)
  if ($fragment and $function = "arrayofstrings") then
    od-api:arrayofstrings($fragment)
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
  else if ($fragment/fn:name() = "senses" or "subsenses" and $function = "thesaurusSense") then
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
  else if ($fragment/fn:name() = "variantForms" and $function = "thesaurusInlineModel1") then
    element {"variantForms"} {
      for $variantForm in $fragment/_
      order by $variantForm/text
      return od-api:thesaurusInlineModel1($variantForm, "variantForm")
    }
  else if ($fragment/fn:name() = "synonyms" or "antonyms" and $function = "thesaurusInlineModel2") then
      if ($fragment/fn:name() = "synonyms") then
        element {"synonyms"} {
          for $synonym in $fragment/_
          order by $synonym/text
          return od-api:thesaurusInlineModel2($synonym, "synonym")
        }
      else if ($fragment/fn:name() = "antonyms") then
        element {"antonyms"} {
          for $antonym in $fragment/_
          return od-api:thesaurusInlineModel2($antonym, "antonym")
        }
      else ()
  else if ($fragment and $function = "thesaurusInlineModel3") then
    element {"examples"} {
      for $example in $fragment/_
      return od-api:thesaurusInlineModel3($example, "example")
    }
  else if ($fragment and $function = "thesaurusInlineModel4") then
    element {"translations"} {
      for $translation in $fragment/_
      return od-api:thesaurusInlineModel4($translation, "translation")
    }
  else if ($fragment and $function = "thesaurusInlineModel5") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:thesaurusInlineModel5($grammaticalFeature, "grammaticalFeature")
    }
  else ()
};
(: ## Add metadata :)
declare function od-api:metadata($response as item()*) as item()* {
  let $metadata := $response/json/metadata
  let $date := $response[1]/*[fn:name()="http:header"][@name="Date"]/@value/fn:string()
  return element {"metadata"} {
    $metadata/node(),
    element {"date"} {$date}
  }
};
(: ## Create elements for string arrays :)
declare function od-api:arrayofstrings($nodes as node()*) as item()* {
  for $node in $nodes
  return typeswitch($node)
  case text() return $node
  case element(definitions) return element {fn:name($node)} {
    for $n in $node/_
    return element {"definition"} {od-api:arrayofstrings($n/node())}
  }
  case element(domains) return element {fn:name($node)} {
    for $n in $node/_
    return element {"domain"} {od-api:arrayofstrings($n/node())}
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

(: # Thesaurus functions :)
(: ## Thesaurus :)
declare function od-api:thesaurus($source_lang as xs:string, $word_id as xs:string, $operation as xs:string, $id as xs:string, $key as xs:string) {
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
    $result/type,
    $result/word,
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:thesaurusLexicalEntry($lexicalEntry)
    }
  }
};
(: ## ThesaurusLexicalEntry :)
declare function od-api:thesaurusLexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    $lexicalEntry/text,
    od-api:option($lexicalEntry/variantForms, "thesaurusInlineModel1"),
    od-api:option($lexicalEntry/entries, "thesaurusEntry")
  }
};
(: ## ThesaurusEntry :)
declare function od-api:thesaurusEntry($entry as node()*) as item()* {
  element {"entry"} {
    $entry/homographNumber,
    od-api:option($entry/variantForms, "thesaurusInlineModel1"),
    od-api:option($entry/senses, "thesaurusSense")
  }
};
(: ## ThesaurusSense :)
declare function od-api:thesaurusSense($sense as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($sense/domains, "arrayofstrings"),
    od-api:option($sense/examples, "thesaurusInlineModel3"),
    $sense/id,
    od-api:option($sense/regions, "arrayofstrings"),
    od-api:option($sense/registers, "arrayofstrings"),
    od-api:option($sense/synonyms, "thesaurusInlineModel2"),
    od-api:option($sense/antonyms, "thesaurusInlineModel2"),
    od-api:option($sense/subsenses, "thesaurusSense")
  }
};
(: ## VariantFormsList :)
declare function od-api:thesaurusInlineModel1($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/regions, "arrayofstrings"),
    $fragment/text
  }
};
(: ## SynonymsAntonyms :)
declare function od-api:thesaurusInlineModel2($fragment as node()*, $element as xs:string) as item()* {
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
declare function od-api:thesaurusInlineModel3($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/definitions, "arrayofstrings"),
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    (: od-api:option($fragment/senseIds, "arrayofstrings"), *Provided in the sentences endpoint only :)
    $fragment/text,
    od-api:option($fragment/translations, "thesaurusInlineModel4")
  }
};
(: ## TranslationsList :)
declare function od-api:thesaurusInlineModel4($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/grammaticalFeatures, "thesaurusInlineModel5"),
    $fragment/language,
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:thesaurusInlineModel5($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};