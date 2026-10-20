<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:eli="http://data.europa.eu/eli/ontology#"
  xmlns:schema="http://schema.org/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:cnt="http://www.w3.org/2011/content#"
  xmlns:oa="http://www.w3.org/ns/oa#"
>

<xsl:output method="html"/>

<xsl:template match="/">
  <html>
    <head>
      <meta charset="utf-8" />
      <style type="text/css">
        span.condition { background-color: #33ff33;}
        span.normexpression { background-color: #ff66ff;}
        span.primarysubject { background-color: #ffff00;}
        span.secondarysubject { background-color: #eeee33;}
        span.object { background-color: #ff6666;}
        span.legaleffect { background-color: #00ffff;}
        span.term { background-color: #c0c0c0}
        span.definition { background-color: #9090ff}
        ul {
            list-style: none;
            padding-left: 2em;
        }

        li > p {
            position: relative;
        }

        li > p > span:first-child {
            position: absolute;
            right: 100%;
            margin-right: 0.5em;
            font-weight: bold;
        }
      </style>
    </head>
    <body>
      <h2>Voorbeelden</h2>
      <table>
        <tr>
          <th>Normbepaling</th>
          <th>Begripsbepaling</th>
        </tr>
        <tr>
          <td><span class="primarysubject">Primair subject</span></td>
          <td><span class="term">Term</span></td>
        </tr>
        <tr>
          <td><span class="secondarysubject">Secundair subject</span></td>
          <td><span class="definition">Definitie</span></td>
        </tr>
        <tr>
          <td><span class="normexpression">Normuitdrukking</span></td>
          <td />
        </tr>
        <tr>
          <td><span class="object">Object</span></td>
          <td />
        </tr>
        <tr>
          <td><span class="condition">Conditie</span></td>
          <td />
        </tr>
        <tr>
          <td><span class="legaleffect">Juridisch effect</span></td>
          <td />
        </tr>
      </table>
      <xsl:for-each select="key('item',ROOT/rdf:RDF/rdf:Description/oa:source/@rdf:resource)"><xsl:sort select="@rdf:about"/>
        <xsl:apply-templates select="." mode="expression"/>
      </xsl:for-each>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
