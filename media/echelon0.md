# Toepassingsprofiel

![](echelon0-nl.svg "logisch model tekstueel echelon")

![](echelon0.svg "gebruikte vocabulaires voor het tekstueel echelon")

## Klassen

### eli:Expression {#TExpression}

|URI|http://data.europa.eu/eli/ontology#Expression|
|-|-|
|Specialisatie van|[http://iflastandards.info/ns/fr/frbr/frbroo/F22_Self-Contained_Expression](http://iflastandards.info/ns/fr/frbr/frbroo/F22_Self-Contained_Expression)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|dct:title|0..1|[string](http://www.w3.org/2001/XMLSchema#string)|
|eli:cites|0..n|[eli:Expression](#TExpression)|
|eli:number|0..1|[string](http://www.w3.org/2001/XMLSchema#string)|
|schema:position|0..1|[integer](http://www.w3.org/2001/XMLSchema#integer)|
|eli:realizes|1..1|[eli:Work](#TWork)|
|cnt:chars|0..1|[string](http://www.w3.org/2001/XMLSchema#string)|

### eli:WorkSubdivision {#TWorkSubdivision}

|URI|http://data.europa.eu/eli/ontology#WorkSubdivision|
|-|-|
|Definitie|A component of a work, at an arbitrary level of precision. A subdivision can be linked with its parent and children subdivision using eli:has_part / eli:is_part_of.|
|Specialisatie van|[eli:Work](#TWork)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|eli:type_subdivision|0..1|[eli:SubdivisionType](#TSubdivisionType)|
|eli:is_part_of|1..1|[eli:Work](#TWork)|

### eli:Work {#TWork}

|URI|http://data.europa.eu/eli/ontology#Work|
|-|-|
|Definitie|Any distinct intellectual creation (i.e., the intellectual content), in the context of ELI.

The substance of Work is ideas.|
|Specialisatie van|[http://iflastandards.info/ns/fr/frbr/frbroo/F1_Work](http://iflastandards.info/ns/fr/frbr/frbroo/F1_Work)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|

### oa:Annotation {#TAnnotation}

|URI|http://www.w3.org/ns/oa#Annotation|
|-|-|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|oa:motivation|1..1||
|oa:body|1..1|[skos:Concept](#TAnnotation.Body)|
|oa:target|1..1|[Target](#TAnnotation.Target)|

### oa:TextPositionSelector {#TTextPositionSelector}

|URI|http://www.w3.org/ns/oa#TextPositionSelector|
|-|-|
|Specialisatie van|[Selector](http://www.w3.org/ns/oa#Selector)|

|Eigenschap|Kardinaliteit|Datatype/klasse|
|----------|-------------|---------------|
|oa:start|1..1|[integer](http://www.w3.org/2001/XMLSchema#integer)|
|oa:end|1..1|[integer](http://www.w3.org/2001/XMLSchema#integer)|
