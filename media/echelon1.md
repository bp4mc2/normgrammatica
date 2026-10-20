# Toepassingsprofiel

![](echelon1-nl.svg "logisch model tekstueel echelon")

![](echelon1.svg "gebruikte vocabulaires voor het tekstueel echelon")

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
|lg:operator|1..1|[Operator](#TCompountCondition.Operator)|

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
