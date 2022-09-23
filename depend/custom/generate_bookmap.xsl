<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:import href="hexConversions.xsl"/>

    <xsl:param name="title">RDA2DITA Transformed Project</xsl:param>

    <!-- This stylesheet takes a Doxygen XML file flips it into a DITA bookmap. The next stylesheet will take the content of the Doxygen XML file and generate topics that connect to the bookmap -->

   
    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA BookMap//EN" doctype-system="bookmap.dtd"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>

    <!-- Turn the info element into pmc_iso elements -->
    <xsl:template name="pmc_iso_element">
       
    </xsl:template>


    <xsl:template match="reg_doc">
        <xsl:element name="bookmap">
            <xsl:attribute name="id">org.pmc.help.ThisIsTheID</xsl:attribute>
            <xsl:call-template name="convert-attributes"/>
            <xsl:call-template name="attribute_manager"/>
            <title>
                <xsl:value-of select="iso_data/title"/>
            </title>
            <xsl:call-template name="pmc_iso_element"/>
            <frontmatter>
                <booklists>
                    <toc></toc>
                </booklists>
            </frontmatter>
           <xsl:apply-templates></xsl:apply-templates>             
        </xsl:element>
    </xsl:template>

    <!-- Eliminate the info element that is already being processed inside the article element -->

   <xsl:template match="reg_doc/block"> 
                        <xsl:element name="chapter">
                            <xsl:call-template name="attribute_manager"/>
                            <xsl:call-template name="convert-attributes"/>
                            <xsl:attribute name="navtitle"><xsl:value-of select="block_info/block_name"></xsl:value-of></xsl:attribute>
                            <xsl:attribute name="href"><xsl:call-template name="id_processing"
                                        ><xsl:with-param name="link"><xsl:value-of select="@id"
                                        /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
                            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->
                          
                            <xsl:apply-templates/>                           
                        </xsl:element>
    </xsl:template>
    
    <xsl:template match="reg_doc/introduction"> 
        <xsl:element name="chapter">
            <xsl:call-template name="attribute_manager"/>
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="navtitle">Introduction</xsl:attribute>
            <xsl:attribute name="href">Introduction.xml</xsl:attribute>
            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->            
            <xsl:apply-templates/>                           
        </xsl:element>
        <xsl:element name="chapter">
            <xsl:call-template name="attribute_manager"/>
            <xsl:call-template name="convert-attributes"/>
            <xsl:attribute name="navtitle">Address Map</xsl:attribute>
            <xsl:attribute name="href">Address_Map.xml</xsl:attribute>
            <!-- Add attributes needed to connect the chapter to a file named after the section ID -->            
            <xsl:apply-templates/>                           
        </xsl:element>
    </xsl:template>

    <xsl:template match="block">
                <xsl:element name="topicref">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:call-template name="convert-attributes"/>
                    <xsl:attribute name="navtitle"><xsl:value-of select="block_info/block_name"></xsl:value-of></xsl:attribute>
                    <xsl:attribute name="href"><xsl:call-template name="id_processing"
                        ><xsl:with-param name="link"><xsl:value-of select="@id"
                        /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>
                    <!-- Add attributes needed to connect the chapter to a file named after the section ID -->                         
                    <xsl:apply-templates/>                           
                </xsl:element>       
    </xsl:template>
    
    <xsl:template match="registers"> 
        <xsl:for-each select="register">
            <xsl:sort select="reg_address"/>
                <xsl:if test="@status = 'show'">
                    <xsl:element name="topicref">
                        <xsl:call-template name="attribute_manager"/>
                        <xsl:call-template name="convert-attributes"/>
                        <xsl:attribute name="navtitle"><xsl:value-of select="reg_name"></xsl:value-of></xsl:attribute>
                        <xsl:attribute name="href"><xsl:call-template name="id_processing"
                            ><xsl:with-param name="link"><xsl:value-of select="@id"
                            /></xsl:with-param></xsl:call-template>.xml</xsl:attribute>                        
                    </xsl:element> 
                </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="convert-attributes">
        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:if test="db:title">
            <xsl:attribute name="navtitle">
                <xsl:value-of select="db:title/text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="deep-copy">
        <xsl:for-each select="child::node()">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="* | text()"/>

    <!-- Manage attributes -->

    <xsl:template name="attribute_manager">
        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name(.) = 'audience'">
                    <xsl:attribute name="audience">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'arch'">
                    <xsl:attribute name="product">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'document'">
                    <xsl:attribute name="props">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name(.) = 'role'">
                    <xsl:attribute name="otherprops">
                        <xsl:value-of select="translate(., ';', ' ')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
   
    <xsl:template name="process_id">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:variable name="sectionNumber">
                    <xsl:call-template name="id_processing"/>
                </xsl:variable>
                <xsl:value-of select="$sectionNumber"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sectionNumber">
                    <xsl:value-of select="generate-id()"/>
                </xsl:variable>
                <xsl:value-of select="$sectionNumber"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="id_processing">
        <xsl:param name="link">default</xsl:param>
        <xsl:choose>
            <xsl:when test="$link = 'default'">
                <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$link"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*"><xsl:apply-templates></xsl:apply-templates></xsl:template>

</xsl:stylesheet>
