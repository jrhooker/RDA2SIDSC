<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:db="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:date="http://exslt.org/dates-and-times">

  <xsl:import href="filtering-attribute-resolver.xsl"/>

  <xsl:import href="process-address-maps.xsl"/>

  <xsl:import href="conversionFunctions.xsl"/>

  <xsl:import href="calculateReset.xsl"/>

  <xsl:param name="STARTING-DIR"/>

  <xsl:variable name="STARTING-DIR-VAR">
    <xsl:choose>
      <xsl:when test="contains($STARTING-DIR, 'c:')">
        <xsl:value-of select="translate(substring-after($STARTING-DIR, 'c:'), '\', '/')"/>
      </xsl:when>
      <xsl:when test="contains($STARTING-DIR, 'C:')">
        <xsl:value-of select="translate(substring-after($STARTING-DIR, 'C:'), '\', '/')"/>
      </xsl:when>
      <xsl:when test="contains($STARTING-DIR, 'd:')">
        <xsl:value-of select="translate(substring-after($STARTING-DIR, 'd:'), '\', '/')"/>
      </xsl:when>
      <xsl:when test="contains($STARTING-DIR, 'D:')">
        <xsl:value-of select="translate(substring-after($STARTING-DIR, 'D:'), '\', '/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate($STARTING-DIR, '\', '/')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:param name="OUTPUT-DIR"/>

  <xsl:variable name="OUTPUT-DIR-VAR">
    <xsl:choose>
      <xsl:when test="contains($OUTPUT-DIR, 'c:')">
        <xsl:value-of select="translate(substring-after($OUTPUT-DIR, 'c:'), '\', '/')"/>
      </xsl:when>
      <xsl:when test="contains($OUTPUT-DIR, 'C:')">
        <xsl:value-of select="translate(substring-after($OUTPUT-DIR, 'C:'), '\', '/')"/>
      </xsl:when>
      <xsl:when test="contains($OUTPUT-DIR, 'd:')">
        <xsl:value-of select="translate(substring-after($OUTPUT-DIR, 'd:'), '\', '/')"/>
      </xsl:when>
      <xsl:when test="contains($OUTPUT-DIR, 'D:')">
        <xsl:value-of select="translate(substring-after($OUTPUT-DIR, 'D:'), '\', '/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate($OUTPUT-DIR, '\', '/')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:param name="FILENAME"/>

  <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
    doctype-public="-//Atmel//DTD DITA Mathml Topic//EN" doctype-system="AtmelTopic.dtd"/>  
  
  <!--  <xsl:output method="xml" media-type="text/xml" indent="no" encoding="UTF-8"
    doctype-public="-//OASIS//DTD DITA 1.2 Topic//EN" doctype-system="topic.dtd"/>  -->

  <xsl:template match="/">

    <!-- now process the current map itself -->

    <xsl:message>Path to project: <xsl:value-of select="$STARTING-DIR-VAR"/></xsl:message>
    <xsl:message>Path to output: <xsl:value-of select="$OUTPUT-DIR-VAR"/></xsl:message>
    <xsl:message>FILENAME: <xsl:value-of select="$FILENAME"/></xsl:message>
 
    <xsl:apply-templates/>

  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="chapter" name="chapter">
    <xsl:param name="href-prefix"/>
    <xsl:variable name="topicref-id" select="generate-id()"/>
    <xsl:element name="chapter">
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="document(@href)//reg-def">         
        </xsl:when>        
        <xsl:otherwise>
          <xsl:call-template name="copy-topic">
            <xsl:with-param name="href">
              <xsl:value-of select="@href"/>
            </xsl:with-param>           
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="topicref" name="topicref">
    <xsl:param name="href-prefix"/>
    <xsl:variable name="topicref-id" select="generate-id()"/>
    <xsl:element name="topicref">
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="document(@href)//reg-def">        
        </xsl:when>        
        <xsl:otherwise>
          <xsl:call-template name="copy-topic">
            <xsl:with-param name="href">
              <xsl:value-of select="@href"/>
            </xsl:with-param>           
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="copy-topic">
    <xsl:param name="href"/>   
    <xsl:variable name="input-directory" select="concat($STARTING-DIR-VAR, $href)"/>
    <xsl:variable name="document" select="document($input-directory)"/>
    <xsl:variable name="path-out">
      <xsl:choose>
        <xsl:when test="contains($href, '/')">
          <xsl:value-of
            select="translate(substring($href, 1, index-of(string-to-codepoints($href), string-to-codepoints('/'))[last()] - 1), '/', '')"
          />
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="topicref-id">
      <xsl:choose>
        <xsl:when test="contains($href, '/')">
          <xsl:variable name="href-values" select="tokenize($href, '/')"/>
          <xsl:value-of select="$href-values[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>   
      <xsl:variable name="ids" select="$document//@id"/>
      <xsl:variable name="reg-file-name" select="$topicref-id"/>
      <xsl:result-document href="{concat($OUTPUT-DIR-VAR, $path-out, $reg-file-name)}">
        <xsl:element name="topic">
          <xsl:attribute name="id" select="$topicref-id"/>        
          <xsl:element name="title">
            <xsl:apply-templates select="$document/*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]" mode="exclude-attributes"/>
          </xsl:element>         
          <xsl:element name="body">
            <xsl:apply-templates select="$document/*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/body ')]/*" mode="exclude-attributes"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
  </xsl:template>

  <xsl:template match="*" mode="exclude-attributes">
    <xsl:copy>     
      <xsl:call-template name="process-attributes"/>
      <xsl:apply-templates mode="exclude-attributes"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="process-attributes">
    <xsl:for-each select="@*">
      <xsl:if test="name() = 'href'"><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'id'"><xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'scope'"><xsl:attribute name="scope"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'cols'"><xsl:attribute name="cols"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'colwidth'"><xsl:attribute name="colwidth"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'colname'"><xsl:attribute name="colname"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'colnum'"><xsl:attribute name="colnum"><xsl:value-of select="."/></xsl:attribute></xsl:if>
      <xsl:if test="name() = 'xmlns:ditaarch'"><xsl:attribute name="ditaarch">TEST</xsl:attribute></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*" mode="copy">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="copy"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="process-ditamap">
    <xsl:param name="href"/>
    <xsl:param name="href-prefix"/>
    <xsl:variable name="reg-file-name" select="concat('/', @id, '.xml')"/>
    <xsl:variable name="input-directory" select="concat($STARTING-DIR-VAR, $href-prefix, $href)"/>
    <xsl:message>INPUT DIRECTORY: <xsl:value-of select="$input-directory"/></xsl:message>
    <xsl:variable name="document" select="document($input-directory)"/>
    <xsl:variable name="path-out">
      <xsl:variable name="path-out">
        <xsl:call-template name="process-path">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template>
      </xsl:variable>
    </xsl:variable>
    <xsl:message>TITLE2: <xsl:value-of select="@id"/>
    </xsl:message>
    <xsl:result-document href="{concat($OUTPUT-DIR-VAR, $path-out, $reg-file-name)}">
      <xsl:element name="topic">
        <xsl:attribute name="id">
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="generate-id()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:element name="title">
          <xsl:value-of select="title"/>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="process-path">
    <xsl:param name="href"/>
    <xsl:choose>
      <xsl:when test="contains($href, '/')">
        <xsl:value-of
          select="translate(substring($href, 1, index-of(string-to-codepoints($href), string-to-codepoints('/'))[last()] - 1), '/', '')"
        />
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

   <!-- RDA tables?? Really?? What the heck!! Ah, well, convert, convert, convert... -->

  <xsl:template match="table_info" mode="field-desc">
    <xsl:element name="table">
      <xsl:call-template name="filtering-attribute-management"/>
      <xsl:apply-templates mode="field-desc"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table_name" mode="field-desc">
    <xsl:element name="title">
      <xsl:apply-templates mode="field-desc"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table[parent::table_info]" mode="field-desc">
    <xsl:element name="tgroup">
      <xsl:attribute name="cols">
        <xsl:choose>
          <xsl:when test="child::two_col_table">2</xsl:when>
          <xsl:when test="child::three_col_table">3</xsl:when>
          <xsl:when test="child::four_col_table">4</xsl:when>
          <xsl:when test="child::five_col_table">5</xsl:when>
          <xsl:when test="child::six_col_table">6</xsl:when>
          <xsl:when test="child::seven_col_table">7</xsl:when>
          <xsl:when test="child::eight_col_table">8</xsl:when>
          <xsl:when test="child::nine_col_table">9</xsl:when>
          <xsl:when test="child::ten_col_table">10</xsl:when>
          <xsl:when test="child::eleven_col_table">11</xsl:when>
          <xsl:when test="child::twelve_col_table">12</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:element name="tbody">
        <xsl:apply-templates mode="field-desc"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="two_col_table | three_col_table | four_col_table | five_col_table | six_col_table | seven_col_table | eight_col_table | nine_col_table | ten_col_table | eleven_col_table | twelve_col_table " mode="field-desc">     
    <xsl:apply-templates mode="field-desc"/>    
  </xsl:template>

  <xsl:template match="two_col_row | three_col_row | four_col_row | five_col_row | six_col_row | seven_col_row | eight_col_row | nine_col_row | ten_col_row | eleven_col_row | twelve_col_row | two_col_head | three_col_head | four_col_head | five_col_head | six_col_head | seven_col_head | eight_col_head | nine_col_head | ten_col_head | eleven_col_head | twelve_col_head  " mode="field-desc">
    <xsl:element name="row">
      <xsl:call-template name="filtering-attribute-management"/>
      <xsl:apply-templates mode="field-desc"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="td" mode="field-desc">
    <xsl:element name="entry">
      <xsl:apply-templates mode="field-desc"/>
    </xsl:element>
  </xsl:template>
  

</xsl:stylesheet>
