<?xml version="1.0" encoding="UTF-8" ?>
<!-- ************************************************************************** -->
<!-- XSLT to Split a Batch EAD3-XML File into Multiple Files					-->
<!-- Created By: Emily Somach					 								-->
<!-- **************************************************************************	-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:for-each select="batch/ead">
			<xsl:variable name="fname" select="./control/recordid"/>
			<xsl:result-document method="xml" href="{lower-case($fname)}.xml">
				<xsl:copy-of select="."/>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
