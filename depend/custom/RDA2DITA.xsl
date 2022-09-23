<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:dbx="http://sourceforge.net/projects/docbook/defguide/schema/extra-markup"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl db xlink svg mml dbx xi html">

    <xsl:import href="hexConversions.xsl"/>

    <xsl:param name="title">Dox 2 DITA Transformed Project</xsl:param>

    <!-- This stylesheet takes a Doxygen XML file flips it into a DITA bookmap. The next stylesheet will take the content of the Doxygen XML file and generate topics that connect to the bookmap -->


    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>

    <xsl:output method="xml" media-type="text/xml" indent="yes" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Remove processing instructions -->

    <xsl:template match="processing-instruction()"/>



    <xsl:template match="reg_doc">
        <xsl:variable name="introduction" select="//introduction"/>
        <xsl:variable name="blocks" select="//block"/>
        <xsl:variable name="registers" select="//register"/>
        <xsl:for-each select="$introduction">
            <xsl:call-template name="process_introduction"/>
        </xsl:for-each>
        <xsl:call-template name="process_address_map"/>
        <xsl:for-each select="$blocks">
            <xsl:call-template name="process_blocks"/>
        </xsl:for-each>
        <xsl:for-each select="$registers">
            <xsl:call-template name="process_registers"/>
        </xsl:for-each>
    </xsl:template>

    <!-- Eliminate the info element that is already being processed inside the article element -->

    <xsl:template name="process_introduction">
        <xsl:result-document href="Introduction.xml">
            <topic>
                <xsl:attribute name="id">Introduction</xsl:attribute>
                <xsl:element name="title"> Introduction </xsl:element>
                <xsl:element name="body">
                    <xsl:apply-templates select="self::*"/>
                </xsl:element>
            </topic>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="process_address_map">
        <xsl:result-document href="Address_Map.xml">
            <topic>
                <xsl:attribute name="id">Address_Map</xsl:attribute>
                <xsl:element name="title"> Address Map </xsl:element>
                <xsl:element name="body">
                    <xsl:element name="table">
                        <xsl:element name="tgroup">
                            <xsl:attribute name="cols">2</xsl:attribute>
                            <xsl:element name="colspec">
                                <xsl:attribute name="colwidth">34*</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="colspec">
                                <xsl:attribute name="colwidth">66*</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="thead">
                                <xsl:element name="row">
                                    <xsl:element name="entry">Address</xsl:element>
                                    <xsl:element name="entry">Register</xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="tbody">
                                <xsl:call-template name="address-rows"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </topic>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="address-rows">   
        <xsl:for-each select="//register">
            <xsl:sort select="reg_address"/>
            <xsl:element name="row">
                <xsl:element name="entry">
                    <xsl:variable name="blocks" select="ancestor::block"/>
                   <xsl:call-template
                        name="calculate-addresses">
                        <xsl:with-param name="blocks" select="ancestor::block"/>
                        <xsl:with-param name="block-count" select="count(ancestor::block)"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:element name="xref">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat(@id, '.xml')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>            
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="process_blocks">
        <xsl:variable name="sectionNumber">
            <xsl:value-of select="@id"/>
        </xsl:variable>
        <xsl:result-document href="{$sectionNumber}.xml">
            <topic id="{$sectionNumber}">
                <xsl:element name="title">
                    <xsl:value-of select="block_info/block_name"/>
                </xsl:element>
                <xsl:element name="body">
                    <xsl:call-template name="block_info"/>
                </xsl:element>
            </topic>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="block_info">
        <xsl:element name="table">
            <xsl:element name="tgroup">
                <xsl:attribute name="cols">2</xsl:attribute>
                <xsl:element name="colspec">
                    <xsl:attribute name="colwidth">34*</xsl:attribute>
                </xsl:element>
                <xsl:element name="colspec">
                    <xsl:attribute name="colwidth">66*</xsl:attribute>
                </xsl:element>
                <xsl:element name="tbody">
                    <xsl:element name="row">
                        <xsl:element name="entry">Part Number</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/block_part_number"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Mnemonic</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/block_mnemonic"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Base Address</xsl:element>
                        <xsl:element name="entry">
                            <xsl:call-template name="calculate-offsets"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Block Type</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/@type"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Instance</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/block_instance"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Bus Data Width</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/bus_data_width"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Bus Addressing Method</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/bus_data_width/@addressing_method"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="row">
                        <xsl:element name="entry">Bus Address Width</xsl:element>
                        <xsl:element name="entry">
                            <xsl:value-of select="block_info/bus_addr_width"/>
                        </xsl:element>
                    </xsl:element>

                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process_registers">
        <xsl:if test="@status = 'show'">
        <xsl:variable name="sectionNumber">
            <xsl:value-of select="@id"/>
        </xsl:variable>
        <xsl:result-document href="{$sectionNumber}.xml">
            <topic id="{$sectionNumber}">
                <xsl:element name="title">
                    <xsl:value-of select="reg_name"/>
                </xsl:element>
                <xsl:element name="body">
                    <xsl:call-template name="create_reg_table"/>
                </xsl:element>
            </topic>
        </xsl:result-document>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create_reg_table">
        <xsl:apply-templates select="reg_description/*"/>
        <table>
            <title>
                <xsl:variable name="blocks" select="ancestor::block"/>
                <xsl:call-template
                    name="calculate-addresses">
                    <xsl:with-param name="blocks" select="ancestor::block"/>
                    <xsl:with-param name="block-count" select="count(ancestor::block)"/>
                </xsl:call-template> - <xsl:value-of select="reg_mnemonic"/>
            </title>
            <tgroup cols="5">
                <colspec colname="A" colwidth="10*"/>
                <colspec colname="B" colwidth="30*"/>
                <colspec colname="C" colwidth="10*"/>
                <colspec colname="D" colwidth="10*"/>
                <colspec colname="D" colwidth="60*"/>
                <thead>
                    <row>
                        <entry>
                            <p>Position</p>
                        </entry>
                        <entry>
                            <p>Name</p>
                        </entry>
                        <entry>
                            <p>Type</p>
                        </entry>
                        <entry>
                            <p>Default</p>
                        </entry>
                        <entry>
                            <p>Description</p>
                        </entry>
                    </row>
                </thead>
                <reg-def>
                    <xsl:for-each select="reg_bits/reg_bit">
                        <field>
                            <field-bits>
                                <xsl:call-template name="reg_position"/>
                            </field-bits>
                            <field-name>
                                <xsl:value-of select="bit_name"/>
                            </field-name>
                            <field-type>
                                <xsl:value-of select="bit_type"/>
                            </field-type>
                            <field-default>
                                <xsl:value-of select="bit_default"/>
                            </field-default>
                            <field-desc>
                                <xsl:apply-templates select="bit_description/*"/>
                            </field-desc>
                        </field>
                    </xsl:for-each>
                </reg-def>
            </tgroup>
        </table>

    </xsl:template>

    <xsl:template match="paragraph">
        <xsl:element name="p">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="reg_position">
        <xsl:choose>
            <xsl:when test="contains(bit_position, ':')">
                <xsl:element name="double">
                    <xsl:element name="msb">
                        <xsl:value-of select="substring-before(bit_position, ':')"/>
                    </xsl:element>
                    <xsl:element name="lsb">
                        <xsl:value-of select="substring-after(bit_position, ':')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="single">
                    <xsl:value-of select="bit_position"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
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

    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- TABLES -->

    <xsl:template match="table_info">
        <!-- This template now tests to make sure that there is actually a table inside of the table_info element -->
        <xsl:choose>
            <xsl:when test="table">
                <xsl:element name="table">
                    <xsl:call-template name="attribute_manager"/>
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:if test="table_note/paragraph">
                    <xsl:for-each select="ancestor::table_info/table_note/paragraph">
                        <xsl:element name="para">
                            <xsl:call-template name="attribute_manager"/>
                            <xsl:copy-of select="@*"/>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="table_name">
        <xsl:element name="title">
            <xsl:call-template name="attribute_manager"/>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Table notes are handled within the global table template  -->
    <xsl:template match="table_note"/>

    <xsl:template
        match="two_col_table | three_col_table | four_col_table | five_col_table | six_col_table | seven_col_table | eight_col_table | nine_col_table">
        <xsl:element name="tgroup">
            <xsl:call-template name="attribute_manager"/>
            <xsl:choose>
                <xsl:when test="self::two_col_table">
                    <xsl:attribute name="cols">1</xsl:attribute>
                    <xsl:attribute name="cols">2</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::three_col_table">
                    <xsl:attribute name="cols">3</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::four_col_table">
                    <xsl:attribute name="cols">4</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::five_col_table">
                    <xsl:attribute name="cols">5</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::six_col_table">
                    <xsl:attribute name="cols">6</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::seven_col_table">
                    <xsl:attribute name="cols">7</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::eight_col_table">
                    <xsl:attribute name="cols">8</xsl:attribute>
                </xsl:when>
                <xsl:when test="self::nine_col_table">
                    <xsl:attribute name="cols">9</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="self::two_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::three_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::four_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_4</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::five_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_4</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_5</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::six_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_4</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_5</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_6</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::seven_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_4</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_5</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_6</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_7</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::eight_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_4</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_5</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_6</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_7</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_8</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::nine_col_table">
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_2</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_3</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_4</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_5</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_6</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_7</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_8</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="colspec">
                        <xsl:attribute name="colname">_9</xsl:attribute>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <xsl:if
                test="two_col_head | three_col_head | four_col_head | five_col_head | six_col_head | seven_col_head | eight_col_head | nine_col_head">
                <xsl:element name="thead">
                    <xsl:for-each
                        select="two_col_head | three_col_head | four_col_head | five_col_head | six_col_head | seven_col_head | eight_col_head | nine_col_head">
                        <xsl:element name="row">
                            <xsl:for-each select="td">
                                <xsl:element name="entry">
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:if test="ancestor::table_info/table_note/paragraph"/>
            <xsl:element name="tbody">
                <xsl:for-each
                    select="two_col_row | three_col_row | four_col_row | five_col_row | six_col_row | seven_col_row | eight_col_row | nine_col_row">
                    <xsl:if test="td">
                        <xsl:element name="row">
                            <xsl:for-each select="td">
                                <xsl:element name="entry">
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template
        match="two_col_head | three_col_head | four_col_head | five_col_head | six_col_head | seven_col_head | eight_col_head | nine_col_head">
        <xsl:element name="thead">
            <xsl:call-template name="attribute_manager"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="calculate-offsets">
        <xsl:param name="offset">0x0</xsl:param>
        <xsl:param name="running-count" select="1"/>
        <xsl:param name="count" select="count(ancestor::block)"/>
        <xsl:variable name="blocks" select="ancestor::block"/>
        <xsl:choose>
            <xsl:when test="$running-count &lt;= $count">
                <xsl:call-template name="calculate-offsets">
                    <xsl:with-param name="offset">
                        <xsl:call-template name="caculateAddress">
                            <xsl:with-param name="offset">
                                <xsl:value-of select="substring-after($offset, '0x')"/>
                            </xsl:with-param>
                            <xsl:with-param name="address"
                                select="substring-after($blocks[$running-count]/block_info/block_base_address, '0x')"
                            />
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="running-count" select="$running-count + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="caculateAddress">
                    <xsl:with-param name="offset">
                        <xsl:value-of select="substring-after($offset, '0x')"/>
                    </xsl:with-param>
                    <xsl:with-param name="address">
                        <xsl:value-of
                            select="substring-after(ancestor-or-self::block[1]/block_info/block_base_address, '0x')"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calculate-addresses">
        <xsl:param name="blocks"/>
        <xsl:param name="block-count"/>
        <xsl:param name="offset">0x0</xsl:param>
        <xsl:param name="running-count" select="1"/>
        <xsl:choose>
            <xsl:when test="$running-count &lt;= $block-count">
                <xsl:variable name="offset-temp">
                    <xsl:call-template name="caculateAddress">
                        <xsl:with-param name="offset">
                            <xsl:value-of select="substring-after($offset, '0x')"/>
                        </xsl:with-param>
                        <xsl:with-param name="address"
                            select="substring-after($blocks[$running-count]/block_info/block_base_address, '0x')"
                        />                       
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="calculate-addresses">
                    <xsl:with-param name="blocks" select="$blocks"/>
                    <xsl:with-param name="block-count" select="$block-count"/>
                    <xsl:with-param name="offset" ><xsl:value-of select="$offset-temp"/></xsl:with-param> 
                    <xsl:with-param name="running-count" select="$running-count + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>               
               <xsl:call-template name="caculateAddress">
                    <xsl:with-param name="offset">
                        <xsl:value-of select="substring-after($offset, '0x')"/>
                    </xsl:with-param>
                    <xsl:with-param name="address">
                        <xsl:value-of select="substring-after(reg_address, '0x')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="notes">
        <xsl:element name="note">
            <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="note">
        <xsl:element name="p">
            <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="introduction">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
