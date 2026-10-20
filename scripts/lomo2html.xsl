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
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:lg="http://bp4mc2.org/legalgrammar#"
>

<xsl:output method="html"/>

<xsl:key name="item" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>

<xsl:template match="rdf:Description" mode="label">
  <xsl:choose>
    <xsl:when test="skos:prefLabel!=''"><xsl:value-of select="skos:prefLabel"/></xsl:when>
    <xsl:when test="rdfs:label!=''"><xsl:value-of select="rdfs:label"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="@rdf:about"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource='http://data.europa.eu/leg/lomo#InstitutionalRule']" mode="parse">
  <h3><xsl:apply-templates select="." mode="label"/> (regel)</h3>
  <table>
    <tr>
      <th>Type</th>
      <td>
        <xsl:choose>
          <xsl:when test="exists(lg:empowers)">Bevoegdheidsregel</xsl:when>
          <xsl:when test="exists(lg:legalEffect)">Van-rechtwege-regel</xsl:when>
          <xsl:otherwise>Institutionele regel</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
    <xsl:if test="exists(key('item',lg:empowers/@rdf:resource))">
      <tr>
        <th>Bevoegdheid tot</th>
        <td><xsl:apply-templates select="key('item',lg:empowers/@rdf:resource)" mode="label"/></td>
      </tr>
    </xsl:if>
    <xsl:if test="exists(key('item',lg:primarySubject/@rdf:resource))">
      <tr>
        <th>Door</th>
        <td><xsl:apply-templates select="key('item',lg:primarySubject/@rdf:resource)" mode="label"/></td>
      </tr>
    </xsl:if>
    <xsl:if test="exists(key('item',lg:secondarySubject/@rdf:resource))">
      <tr>
        <th>Jegens</th>
        <td><xsl:apply-templates select="key('item',lg:secondarySubject/@rdf:resource)" mode="label"/></td>
      </tr>
    </xsl:if>
    <xsl:if test="exists(key('item',lg:object/@rdf:resource))">
      <tr>
        <th>Betreft</th>
        <td><xsl:apply-templates select="key('item',lg:object/@rdf:resource)" mode="label"/></td>
      </tr>
    </xsl:if>
  </table>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']" mode="parse">
  <h3><xsl:apply-templates select="." mode="label"/> (begrip)</h3>
</xsl:template>

<!-- Failsafe -->
<xsl:template match="rdf:Description" mode="parse">
  <!--<h6>TODO: <xsl:value-of select="@rdf:about"/> (<xsl:value-of select="rdf:type/@rdf:resource"/>)</h6>-->
</xsl:template>

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
      <xsl:for-each select="ROOT/rdf:RDF/rdf:Description[exists(rdf:type) and @rdf:about!='']"><xsl:sort select="@rdf:about"/>
        <xsl:apply-templates select="." mode="parse"/>
      </xsl:for-each>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
