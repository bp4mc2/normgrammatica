<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:eli="http://data.europa.eu/eli/ontology#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:cnt="http://www.w3.org/2011/content#"
  xmlns:schema="http://schema.org/"
>

<xsl:output indent="yes"/>

<xsl:variable name="global-exprid">
  <text>&amp;z=</text>
  <xsl:value-of select="/toestand/@inwerkingtreding"/>
  <text>&amp;g=</text>
  <xsl:value-of select="/toestand/@inwerkingtreding"/>
</xsl:variable>

<xsl:template match="citeertitel" mode="title">
  <dct:title><xsl:value-of select="text()"/></dct:title>
</xsl:template>

<xsl:template match="kop" mode="title">
  <dct:title>
    <xsl:if test="label!=''"><xsl:value-of select="label"/></xsl:if>
    <xsl:if test="nr!=''"><xsl:text> </xsl:text><xsl:value-of select="nr"/><xsl:text>.</xsl:text></xsl:if>
    <xsl:if test="titel!=''"><xsl:text> </xsl:text><xsl:value-of select="titel"/></xsl:if>
  </dct:title>
</xsl:template>

<xsl:template match="li.nr" mode="number">
  <eli:number><xsl:value-of select="."/></eli:number>
</xsl:template>

<xsl:template match="lidnr" mode="number">
  <eli:number><xsl:value-of select="."/>.</eli:number>
</xsl:template>

<xsl:template match="al" mode="text">
  <xsl:apply-templates select="*|text()" mode="text"/>
</xsl:template>

<xsl:template match="text()" mode="text">
  <xsl:if test="normalize-space(.)!=''"><xsl:value-of select="."/></xsl:if>
</xsl:template>

<xsl:template match="extref" mode="text">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="intref" mode="text">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="nadruk" mode="text">
  <xsl:value-of select="."/>
  <!-- Handig voor markdown, maar weer onhandig voor html... -->
  <!--<xsl:text>_</xsl:text><xsl:value-of select="."/><xsl:text>_</xsl:text>-->
</xsl:template>

<xsl:template match="redactie" mode="text"/>

<xsl:template match="*" mode="text">
  <xsl:text>TODO[</xsl:text><xsl:value-of select="local-name()"/><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="intref" mode="refs">
  <!-- Intref refers to an expression -->
  <eli:cites rdf:resource="{@doc}"/>
</xsl:template>

<xsl:template match="extref" mode="refs">
  <!-- Extref refers to a work -->
  <eli:cites rdf:resource="{@doc}"/>
</xsl:template>

<xsl:template match="*" mode="refs">
  <xsl:apply-templates select="*" mode="refs"/>
</xsl:template>

<xsl:template match="*" mode="sub">
  <xsl:param name="parentid"/>
  <xsl:param name="position"/>

  <xsl:variable name="expressionid">
    <xsl:choose>
      <xsl:when test="exists(meta-data/jcis/jci[@versie='1.3']/@verwijzing)">
        <xsl:value-of select="meta-data/jcis/jci[@versie='1.3']/@verwijzing"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Edge case: jci is missing -->
        <!-- Construct jci as best as possible, using unique position and parent jci -->
        <xsl:value-of select="$parentid"/>
        <xsl:text>&amp;o=_</xsl:text>
        <xsl:value-of select="$position"/>
        <xsl:value-of select="$global-exprid"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="workid" select="substring-before($expressionid,'&amp;z=')"/>
  <xsl:variable name="subdivisiontype">
    <xsl:choose>
      <xsl:when test="local-name()='hoofdstuk'">Hoofdstuk</xsl:when>
      <xsl:when test="local-name()='paragraaf'">Paragraaf</xsl:when>
      <xsl:when test="local-name()='artikel'">Artikel</xsl:when>
      <xsl:when test="local-name()='lid'">Lid</xsl:when>
      <xsl:when test="local-name()='li'">Onderdeel</xsl:when>
      <xsl:otherwise>unknown/<xsl:value-of select="local-name()"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <eli:WorkSubdivision rdf:about="{$workid}">
    <dct:isPartOf rdf:resource="{$parentid}"/>
    <eli:type_subdivision rdf:resource="http://bp4mc2.org/subdivisiontype/{$subdivisiontype}"/>
  </eli:WorkSubdivision>
  <eli:Expression rdf:about="{$expressionid}">
    <eli:realizes rdf:resource="{$workid}"/>
    <schema:position><xsl:value-of select="$position"/></schema:position> <!--HACK -->
    <xsl:apply-templates select="kop" mode="title"/>
    <xsl:if test="local-name()='lid' or local-name()='li'">
      <!-- lid and li should have a number. If it is ommit, it should still be known as a lid or li for styling -->
      <eli:number><xsl:value-of select="li.nr|lidnr"/></eli:number>
    </xsl:if>
    <xsl:variable name="plaintext"><xsl:apply-templates select="al" mode="text"/></xsl:variable>
    <xsl:if test="$plaintext!=''"><cnt:chars><xsl:value-of select="$plaintext"/></cnt:chars></xsl:if>
    <xsl:apply-templates select="al" mode="refs"/>
  </eli:Expression>
  <xsl:for-each select="afdeling|paragraaf|artikel|lid|lijst/li">
    <xsl:apply-templates select="." mode="sub">
      <xsl:with-param name="parentid" select="$workid"/>
      <xsl:with-param name="position" select="position()"/>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="/">
  <rdf:RDF>
    <xsl:for-each select="toestand">
      <xsl:variable name="workid"><xsl:text>jci1.3:c:</xsl:text><xsl:value-of select="@bwb-id"/></xsl:variable>
      <eli:Work rdf:about="{$workid}">
      </eli:Work>
      <eli:Expression rdf:about="{$workid}{$global-exprid}">
        <eli:realizes rdf:resource="{$workid}"/>
        <xsl:apply-templates select="wetgeving/citeertitel" mode="title"/>
      </eli:Expression>
      <xsl:for-each select="wetgeving/wet-besluit/wettekst">
        <xsl:for-each select="hoofdstuk">
          <xsl:apply-templates select="." mode="sub">
            <xsl:with-param name="parentid" select="$workid"/>
            <xsl:with-param name="position" select="position()"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </rdf:RDF>
</xsl:template>

</xsl:stylesheet>
