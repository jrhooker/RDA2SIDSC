<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:db="http://docbook.org/ns/docbook"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:date="http://exslt.org/dates-and-times">
    
    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:variable name="ID">ID-<xsl:value-of select="//document_id"/>v<xsl:value-of select="//doc_issue"/></xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>    
             <xsl:if test="self::register">              
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:copy-of select="@id" />
                    </xsl:when>
                    <xsl:otherwise>                        
                        <xsl:attribute name="id"><xsl:value-of select="$ID"/>-register-<xsl:for-each select="ancestor::block"><xsl:value-of select="block_info/block_mnemonic"/>-</xsl:for-each><xsl:value-of select="reg_mnemonic"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="self::block">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:copy-of select="@id" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="id"><xsl:value-of select="$ID"/>-block-<xsl:for-each select="ancestor::block"><xsl:value-of select="block_info/block_mnemonic"/>-</xsl:for-each><xsl:value-of select="block_info/block_mnemonic"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="self::block_info">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:copy-of select="@id" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="id"><xsl:value-of select="$ID"/>-block-info-<xsl:for-each select="ancestor::block"><xsl:value-of select="block_info/block_mnemonic"/>-</xsl:for-each><xsl:value-of select="block_mnemonic"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="self::reg_bit">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:copy-of select="@id" />
                    </xsl:when>
                    <xsl:otherwise><xsl:attribute name="id"><xsl:value-of select="$ID"/>-reg-bit-<xsl:for-each select="ancestor::block"><xsl:value-of select="block_info/block_mnemonic"/>-</xsl:for-each><xsl:value-of select="bit_name"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="self::bit_description">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:copy-of select="@id" />
                    </xsl:when>
                    <xsl:otherwise><xsl:attribute name="id"><xsl:value-of select="$ID"/>-bit_description-<xsl:for-each select="ancestor::block"><xsl:value-of select="block_info/block_mnemonic"/>-</xsl:for-each><xsl:value-of select="preceding-sibling::bit_name"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>                             
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
