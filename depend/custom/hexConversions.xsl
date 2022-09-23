<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
    
    <!-- <xsl:param name="offset">0x04f34</xsl:param>  --> 
    
    <!--
    
    <xsl:template match="/">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="value">
        <xsl:call-template name="caculateAddress">
            <xsl:with-param name="address" select="."></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    -->
    
  <xsl:template name="caculateAddress" >
        <xsl:param name="address"></xsl:param>  
        <xsl:param name="offset"></xsl:param>   
        <xsl:variable name="code">
            <xsl:call-template name="hex2dec">
                <xsl:with-param name="num" select="$address" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dec_offset">
            <xsl:call-template name="hex2dec">
                <xsl:with-param name="num" select="$offset" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:text>0x</xsl:text>
        <xsl:call-template name="dec2hex">
            <xsl:with-param name="dec" select="number($code) + number($dec_offset)" />
        </xsl:call-template>
    </xsl:template>
     
    <xsl:template name="hex2dec">
        <xsl:param name="num" />
        <xsl:param name="hex" select="translate($num,'abcdef','ABCDEF')"/>
        <xsl:param name="acc" select="0" />
        <xsl:choose>
            <xsl:when test="string-length($hex)">
                <xsl:call-template name="hex2dec">
                    <xsl:with-param name="hex" select="substring($hex,2,string-length($hex))" />
                    <xsl:with-param name="acc" select="$acc * 16 + string-length(substring-before('0123456789ABCDEF',substring($hex,1,1)))" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$acc" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="dec2hex">
        <xsl:param name="dec" select="10"/>
        <xsl:variable name="dec2" select="number($dec)"/>
       <xsl:if test="$dec2 >= 16">
            <xsl:call-template name="dec2hex">
                <xsl:with-param name="dec" select="floor($dec2 div 16)" />
            </xsl:call-template>
        </xsl:if>
        <xsl:value-of select="substring('0123456789ABCDEF', ($dec2 mod 16) + 1, 1)" />
    </xsl:template>
    
    
    
</xsl:stylesheet> 