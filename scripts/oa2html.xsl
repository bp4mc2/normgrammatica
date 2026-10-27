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

<xsl:key name="part" match="/ROOT/rdf:RDF/rdf:Description" use="dct:isPartOf/@rdf:resource"/>
<xsl:key name="expression" match="/ROOT/rdf:RDF/rdf:Description" use="eli:realizes/@rdf:resource"/>
<xsl:key name="item" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="target" match="/ROOT/rdf:RDF/rdf:Description" use="oa:source/@rdf:resource"/>
<xsl:key name="seltarget" match="/ROOT/rdf:RDF/rdf:Description" use="oa:selector/@rdf:nodeID"/>
<xsl:key name="annotation" match="/ROOT/rdf:RDF/rdf:Description" use="oa:target/@rdf:nodeID"/>

<xsl:variable name="eli">http://data.europa.eu/eli/ontology#</xsl:variable>
<xsl:variable name="eli-Work"><xsl:value-of select="$eli"/>Work</xsl:variable>

<xsl:template match="rdf:Description" mode="chars">
  <xsl:param name="target"/>
  <xsl:param name="index"/>

  <xsl:variable name="chars"><xsl:value-of select="cnt:chars"/></xsl:variable>
  <xsl:variable name="anno">
    <xsl:for-each select="key('item',key('target',$target)/oa:selector/@rdf:nodeID)"><xsl:sort select="oa:start" data-type="number"/>
      <xsl:variable name="class"><xsl:value-of select="key('annotation',key('seltarget',@rdf:nodeID)/@rdf:nodeID)/oa:body/@rdf:resource"/></xsl:variable>
      <xsl:if test="oa:start >= $index">
        <part start="{oa:start - $index}" end="{oa:end - $index}" class="{lower-case(substring-after($class,'legalgrammar/'))}"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="count($anno/part)=0"><xsl:value-of select="$chars"/></xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="$anno/part">
        <xsl:choose>
          <xsl:when test="position()=1">
            <xsl:if test="@start>1"><xsl:value-of select="substring($chars,1,@start - 1)"/></xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="pos" select="position() - 1"/>
            <xsl:variable name="pend" select="$anno/part[$pos]/@end"/>
            <xsl:if test="(@start - $pend) > 1"><xsl:value-of select="substring($chars,1+$pend,@start - $pend - 1)"/></xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <span class="{@class}"><xsl:value-of select="substring($chars,@start,1 + @end - @start)"/></span>
      </xsl:for-each>
      <xsl:variable name="pend" select="$anno/part[last()]/@end"/>
      <xsl:if test="(string-length($chars) - $pend) > 0">
        <xsl:value-of select="substring($chars,1 + $pend,string-length($chars) - $pend)"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="title">
  <xsl:choose>
    <xsl:when test="exists(dct:title)"><xsl:value-of select="dct:title"/></xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="key('expression',key('item',eli:realizes/@rdf:resource)/dct:isPartOf/@rdf:resource)" mode="title"/>
      <xsl:variable name="sdt"><xsl:value-of select="lower-case(substring-after(key('item',eli:realizes/@rdf:resource)/eli:type_subdivision/@rdf:resource,'subdivisiontype/'))"/></xsl:variable>
      <xsl:if test="$sdt!=''"><xsl:text>, </xsl:text><xsl:value-of select="$sdt"/><xsl:text> </xsl:text><xsl:value-of select="eli:number"/></xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="expression">
  <xsl:param name="target"/>
  <xsl:param name="index" select="0"/>

  <h3><xsl:apply-templates select="." mode="title"/></h3>
  <xsl:if test="exists(cnt:chars)">
    <p><xsl:apply-templates select="." mode="chars"><xsl:with-param name="target" select="$target"/><xsl:with-param name="index" select="$index"/></xsl:apply-templates></p>
  </xsl:if>
  <xsl:variable name="nextindex" select="$index + string-length(cnt:chars) + 1"/>
  <xsl:variable name="workuri" select="key('item',eli:realizes/@rdf:resource)/@rdf:about"/>
  <xsl:for-each select="key('expression',key('part',$workuri)/@rdf:about)"><xsl:sort select="schema:position" data-type="number"/>
    <!-- Calculating offset (DOESNT WORK WITH SUBITEMS)-->
    <xsl:variable name="position" select="schema:position"/>
    <xsl:variable name="siblings">
      <xsl:for-each select="key('expression',key('part',$workuri)/@rdf:about)[$position > schema:position]">
        <offset><xsl:value-of select="string-length(cnt:chars) + 1"/></offset>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="offset" select="sum($siblings/offset)"/>
    <!-- Until -->
    <xsl:choose>
      <xsl:when test="exists(eli:number)">
        <ul>
          <xsl:apply-templates select="." mode="listitem">
            <xsl:with-param name="target" select="$target"/>
            <xsl:with-param name="index" select="$nextindex + $offset"/>
          </xsl:apply-templates>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="expression">
          <xsl:with-param name="target" select="$target"/>
          <xsl:with-param name="index" select="$nextindex + $offset"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="listitem">
  <xsl:param name="target"/>
  <xsl:param name="index" select="0"/>

  <li>
    <p><span><xsl:value-of select="eli:number"/></span><xsl:apply-templates select="." mode="chars"><xsl:with-param name="target" select="$target"/><xsl:with-param name="index" select="$index"/></xsl:apply-templates></p>
    <xsl:variable name="nextindex" select="$index + string-length(cnt:chars)"/>
    <xsl:for-each select="key('expression',key('part',key('item',eli:realizes/@rdf:resource)/@rdf:about)/@rdf:about)"><xsl:sort select="schema:position[1]" data-type="number"/>
      <xsl:choose>
        <xsl:when test="exists(eli:number)">
          <ul>
            <xsl:apply-templates select="." mode="listitem">
              <xsl:with-param name="target" select="$target"/>
              <xsl:with-param name="index" select="$nextindex"/>
            </xsl:apply-templates>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="expression">
            <xsl:with-param name="target" select="$target"/>
            <xsl:with-param name="index" select="$nextindex"/>
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
      <table class='legend'>
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
        <xsl:apply-templates select="." mode="expression">
          <xsl:with-param name="target" select="@rdf:about"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
