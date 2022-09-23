<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:opentopic-i18n='http://www.idiominc.com/opentopic/i18n' xmlns:opentopic-index='http://www.idiominc.com/opentopic/index' xmlns:opentopic='http://www.idiominc.com/opentopic' xmlns:opentopic-func='http://www.idiominc.com/opentopic/exsl/function' >
    
<xsl:template match="text()">
  <xsl:value-of select="normalize-space()"/>
</xsl:template>

<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
