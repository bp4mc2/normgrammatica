# Toepassingsprofiel

Het semantisch echelon is sterk gerelateerd aan het tekstuele echelon. Het gaat in het semantisch echelon om het duiden van de betekenis van de tekstfragmenten zoals ze aanwezig zijn in het tekstuele echelon en zijn ontleedt met het juridisch grammatica. Conceptueel kan dit op de volgende manier worden weergeven.

![](echelon1-intro.svg "conceptueel model semantisch echelon")

De kleuren komen overeen met de grammaticale functies in de normgrammatica:

- Een normexpressie valt uiteen in een handeling en de norm zelf. Er zijn situaties dat er geen sprake is van een handeling, bijvoorbeeld als sprake is van een bepaalde situatie of een gebeurtenis zonder menselijk handelen (zoals tijdsverloop). In dat geval ontbreekt de handeling (en vaak ook het primair subject). Een handeling wordt (over het algemeen) uitgevoerd door het primair subject.
- Het primair en secundair subject, het object en het juridisch effect zijn op het semantisch echelon te herkennen als begrippen. Daarbij kan zo'n begrip in de tekst met verschillende termen worden aangeduid.
- De conditie komt terug als conditie van de norm terug op het semantisch niveau. Vaak zullen wel meerdere condities op het tekstuele niveau samen de (samengestelde) conditie zijn op het semantische niveau. Een conditie kan gebruik maken van begrippen om te duiden waar de conditie over gaat.
- Een definitiebepaling betreft een begrip. Dit kan (dus) zowel een primair subject, secundair subject, juridisch effect of object zijn. Ook is het mogelijk dat een begrip gedefinieerd wordt dat (slechts) in een conditie wordt gebruikt.

Onderstaand figuur geeft dit weer in een logisch model.

![](echelon1-nl.svg "logisch model semantisch echelon")

Dit logische model laat zich op de volgende wijze uitdrukken met gebruik van de ELI, SKOS en LOMO vocabulaires. Daarbij is nog enige aanvulling nodig voor condities en enkele relaties tussen de elementen.

![](echelon1.svg "gebruikte vocabulaires voor het semantisch echelon")

## Klassen

### eli:Expression {#TExpression}

|URI|http://data.europa.eu/eli/ontology#Expression|
|-|-|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|

### lg:CompoundCondition {#TCompoundCondition}

|URI|http://bp4mc2.org/legalgrammar/CompoundCondition|
|-|-|
|Specialisatie van|[lg:Condition](#TCondition)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|lg:conditionList|1..1||
|lg:operator|1..1|[Operator](#TCompountConditionOperator)|

### lg:Condition {#TCondition}

|URI|http://bp4mc2.org/legalgrammar/Condition|
|-|-|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|

### lg:ElementaryCondition {#TElementaryCondition}

|URI|http://bp4mc2.org/legalgrammar/ElementaryCondition|
|-|-|
|Specialisatie van|[lg:Condition](#TCondition)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|lg:references|0..n|[skos:Concept](#TConcept)|
|lg:condition|1..1|[langString](http://www.w3.org/1999/02/22-rdf-syntax-ns#langString)|

### lomo:Action {#TAction}

|URI|http://data.europa.eu/leg/lomo#Action|
|-|-|
|Specialisatie van|[http://www.w3.org/2002/07/owl#Thing](http://www.w3.org/2002/07/owl#Thing)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|

### lomo:ConstitutiveRule {#TConstitutiveRule}

|URI|http://data.europa.eu/leg/lomo#ConstitutiveRule|
|-|-|
|Specialisatie van|[lomo:LegalRule](#TLegalRule)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|

### lomo:Definition {#TDefinition}

|URI|http://data.europa.eu/leg/lomo#Definition|
|-|-|
|Specialisatie van|[lomo:ConstitutiveRule](#TConstitutiveRule)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|lomo:defines|1..1|[skos:Concept](#TConcept)|

### lomo:InstitutionalRule {#TInstitutionalRule}

|URI|http://data.europa.eu/leg/lomo#InstitutionalRule|
|-|-|
|Specialisatie van|[lomo:ConstitutiveRule](#TConstitutiveRule)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|lg:secondarySubject|1..1|[skos:Concept](#TConcept)|
|lg:legalEffect|0..n|[skos:Concept](#TConcept)|
|lg:object|0..n|[skos:Concept](#TConcept)|
|lg:empowers|0..n|[lomo:Action](#TAction)|
|lg:primarySubject|1..1|[skos:Concept](#TConcept)|

### lomo:LegalRule {#TLegalRule}

|URI|http://data.europa.eu/leg/lomo#LegalRule|
|-|-|
|Specialisatie van|[http://www.w3.org/2002/07/owl#Thing](http://www.w3.org/2002/07/owl#Thing)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|lomo:establishedIn|0..n|[eli:Expression](#TExpression)|
|lg:condition|0..1|[lg:Condition](#TCondition)|

### lomo:PrescriptiveRule {#TPrescriptiveRule}

|URI|http://data.europa.eu/leg/lomo#PrescriptiveRule|
|-|-|
|Specialisatie van|[lomo:LegalRule](#TLegalRule)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|lg:secondarySubject|1..1|[skos:Concept](#TConcept)|
|lg:legalEffect|0..n|[skos:Concept](#TConcept)|
|lomo:produces|0..n|[lomo:Action](#TAction)|
|lg:object|0..n|[skos:Concept](#TConcept)|
|lg:primarySubject|1..1|[skos:Concept](#TConcept)|

### skos:Concept {#TConcept}

|URI|http://www.w3.org/2004/02/skos/core#Concept|
|-|-|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|skos:prefLabel|1..1|[langString](http://www.w3.org/1999/02/22-rdf-syntax-ns#langString)|

## Datatypes

### Operator {#TCompountConditionOperator}

|Waarde|Omschrijving|
|------|------------|
|OF||
|EN||
