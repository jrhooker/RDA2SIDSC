<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" >
    
    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template name="object.id">
        <xsl:param name="object" select="."/>
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="idref" select="@idref"/>
        <xsl:variable name="preceding.id" select="count(preceding::*[@id = $id])"/>
        <xsl:variable name="preceding.idref" select="count(preceding::*[@idref = $idref])"/>
        <xsl:choose>
            <xsl:when test="$object/@id and $preceding.id != 0">
                <xsl:value-of select="concat($object/@id, $preceding.id)"/>
            </xsl:when>
            <xsl:when test="$object/@id">
                <xsl:value-of select="$object/@id"/>
            </xsl:when>
            <xsl:when test="$object/@idref and $preceding.idref != 0">
                <xsl:value-of select="concat($object/@idref, $preceding.idref)"/>
            </xsl:when>
            <xsl:when test="$object/@idref">
                <xsl:value-of select="$object/@idref"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="generate-id($object)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                <xsl:call-template name="object.id"></xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
