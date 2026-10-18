<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:eli="http://data.europa.eu/eli/ontology#"
  xmlns:schema="http://schema.org/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:cnt="http://www.w3.org/2011/content#"
>

<xsl:output method="html"/>

<xsl:key name="part" match="/ROOT/rdf:RDF/rdf:Description" use="dct:isPartOf/@rdf:resource"/>
<xsl:key name="expression" match="/ROOT/rdf:RDF/rdf:Description" use="eli:realizes/@rdf:resource"/>
<xsl:key name="item" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about"/>

<xsl:variable name="eli">http://data.europa.eu/eli/ontology#</xsl:variable>
<xsl:variable name="eli-Work"><xsl:value-of select="$eli"/>Work</xsl:variable>

<xsl:template match="rdf:Description" mode="regulation">
  <h1><xsl:value-of select="key('expression',@rdf:about)/dct:title"/></h1>
  <xsl:for-each select="key('expression',key('part',@rdf:about)/@rdf:about)"><xsl:sort select="schema:position" data-type="number"/>
    <xsl:apply-templates select="." mode="subdivision">
      <xsl:with-param name="level">2</xsl:with-param>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="subdivision">
  <xsl:param name="level"/>

  <xsl:if test="exists(dct:title)"><xsl:element name="{concat('H',$level)}"><xsl:value-of select="dct:title"/></xsl:element></xsl:if>
  <xsl:if test="exists(cnt:chars)"><p><xsl:value-of select="cnt:chars"/></p></xsl:if>
  <xsl:for-each select="key('expression',key('part',key('item',eli:realizes/@rdf:resource)/@rdf:about)/@rdf:about)"><xsl:sort select="schema:position" data-type="number"/>
    <xsl:choose>
      <xsl:when test="exists(eli:number)">
        <ul>
          <xsl:apply-templates select="." mode="listitem"/>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="subdivision">
          <xsl:with-param name="level" select="1+$level"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="listitem">
  <li>
    <p><span><xsl:value-of select="eli:number"/></span><xsl:value-of select="cnt:chars"/></p>
    <xsl:for-each select="key('expression',key('part',key('item',eli:realizes/@rdf:resource)/@rdf:about)/@rdf:about)"><xsl:sort select="schema:position[1]" data-type="number"/>
      <xsl:choose>
        <xsl:when test="exists(eli:number)">
          <ul>
            <xsl:apply-templates select="." mode="listitem"/>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="subdivision">
            <xsl:with-param name="level" select="1"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </li>
</xsl:template>

<xsl:template match="/">
  <html>
    <head>
      <meta charset="utf-8" />
      <style type="text/css">
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
      <xsl:apply-templates select="ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource=$eli-Work]" mode="regulation"/>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
