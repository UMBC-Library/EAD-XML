<?xml version="1.0" encoding="UTF-8"?>
<!-- ************************************************************************** -->
<!-- XSLT stylesheet to transform EAD-XML to HTML for Web Display				-->
<!-- Created By: Emily Somach													-->
<!-- **************************************************************************	-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl" xmlns="http://www.w3.org/TR/REC-html40">
    <!-- Main Template -->
	<xsl:template match="ead">
	<xsl:result-document href="{concat (lower-case(archdesc/did/unitid), '.php')}" method="html" encoding="utf-8" media-type="text/html" indent="yes">
	<html><head>
		<xsl:processing-instruction name="php">include "/afs/umbc.edu/public/web/sites/library/prod/htdocs/boiler_sc_xml_header.txt";?</xsl:processing-instruction>
                <title><xsl:value-of select="control/filedesc/titlestmt/titleproper"/></title>
				<link rel="stylesheet" type="text/css" href="http://library.umbc.edu/speccoll/speccoll.css" />
                <xsl:comment>Our CSS stylesheet</xsl:comment>
                <link rel="stylesheet" type="text/css" href="http://library.umbc.edu/speccoll/findingaids/EADstyle.css" />
                <xsl:comment>Our print/pdf stylesheet</xsl:comment>
                <link rel="stylesheet" href="http://library.umbc.edu/speccoll/findingaids/print.css" type="text/css" media="print" />
                <meta http-equiv="content-type" content="text/html;charset=utf-8" />
                <xsl:comment>Fancybox styling info
                <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js" />
                <link rel="stylesheet" href="../fancybox/source/jquery.fancybox.css" type="text/css" media="screen" />
                <script type="text/javascript" src="../fancybox/source/jquery.fancybox.pack.js" /></xsl:comment>

            </head>
            <body>
			   <xsl:processing-instruction name="php">include "/afs/umbc.edu/public/web/sites/library/prod/htdocs/boiler_header2.txt";?</xsl:processing-instruction>
			   <div id="container-content">
			   <nav class="deeperNav left">
					<ul>
						<li style=""><strong>Finding Aid</strong></li>
						<li><a href="#overview" title="skip to Overview">Overview</a></li>
						<xsl:if test="archdesc/bioghist/p !='' or archdesc/bioghist/chronlist/chronitem">
							<li><a href="#adminbiog" title="skip to Admin Bio Note">Admin/Bio Note</a></li>
						</xsl:if>
						<xsl:if test="archdesc/arrangement/p != '' or archdesc/arrangement/list !='' or archdesc/scopecontent/p !=''">
							<li><a href="#scope" title="skip to Scope &amp; Content">Scope &amp; Content</a></li>
                        </xsl:if>
						<li><a href="#provinfo" title="skip to Provenance">Provenance Information</a></li>
                        <li><a href="#access" title="skip to Access &amp; Use">Access &amp; Use</a></li>
                        <li><a href="#subjects" title="skip to Subjects">Subject Headings</a></li>
						<xsl:if test="archdesc/dsc">
							<li><a href="#series" title="skip to Series Description">Series Description &amp; Container List</a></li>
						</xsl:if>
                        <xsl:if test="archdesc/bibliography">
							<li><a href="#bib" title="skip to Bibliography">Bibliography</a></li>
						</xsl:if>
                        <li><a href="{concat (lower-case(archdesc/did/unitid), '.pdf')}" title="go to PDF" target="_blank">View PDF</a></li>
						<li><a href="index.php" title="back to Finding Aids">Return to Finding Aids</a></li>
						</ul>
				</nav>

				<section class="aokcolumn">
				<div id="content-wrapper">
                    <div id="firstbox">
                        <div class="section1">
                            <h1 id="overview">Overview</h1>
                            <div id="table-content">
                                <table id="overviewtable">
                                    <tr>
                                        <td>Title:</td>
                                        <td><xsl:value-of select="//titleproper"/></td>
                                    </tr>
                                    <tr>
                                        <td>Call Number:</td>
                                        <td><xsl:value-of select="//unitid"/></td> 
                                    </tr>
                                    <xsl:if test="//origination/*">
                                        <tr>
                                            <td>Creator:</td>
                                            <td>
                                                <xsl:apply-templates select="//origination/*/*"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <tr>
                                        <td>Dates:</td>
                                        <td>
                                            <xsl:value-of select="archdesc/did/unitdate[@unitdatetype|@type='inclusive']"/>
                                            <xsl:if test="archdesc/did/unitdate[@unitdatetype='bulk']">
                                                <xsl:text>; </xsl:text><xsl:value-of select="archdesc/did/unitdate[@unitdatetype='bulk']"/>
                                            </xsl:if>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Size:</td>
                                        <td><xsl:value-of select="archdesc/did/physdesc"/></td> 
                                    </tr>
                                    <tr>
                                        <td>Language:</td>
                                        <td>
                                            <xsl:apply-templates select="archdesc/did/langmaterial/language"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Abstract:</td>
                                        <td><xsl:value-of select="archdesc/did/abstract"/></td> 
                                    </tr>
                                    <tr>
                                        <td>Citation:</td>
                                        <td><xsl:value-of select="archdesc/prefercite"/></td> 
                                    </tr>
                                </table>
								<hr />
                            </div>
                        </div>
                    </div>
					<div id="secondbox">
                        <div class="section2">
							<xsl:if test="archdesc/bioghist/p !='' or archdesc/bioghist/chronlist/chronitem">
								<h1 id="adminbiog">Administrative/Biographical Note</h1>
								<xsl:apply-templates select="archdesc/bioghist/p"/>
								<xsl:if test="archdesc/bioghist/chronlist">
									<table id="timeline">
										<xsl:apply-templates select="archdesc/bioghist/chronlist/chronitem"/>
									</table>
								</xsl:if>
							<hr />	
							</xsl:if>
                            <xsl:if test="archdesc/arrangement/p != '' or archdesc/arrangement/list !='' or archdesc/scopecontent/p !=''">						
								<h1 id="scope">Scope &amp; Content</h1>
									<h2>Arrangement</h2>
									<xsl:apply-templates select="archdesc/arrangement/p"/>
									<xsl:apply-templates select="archdesc/arrangement/list"/>
								<xsl:if test="archdesc/scopecontent">	
									<h2>Note</h2>
									<xsl:apply-templates select="archdesc/scopecontent/p"/>
								</xsl:if>
							<hr />
							</xsl:if>
                        </div>
                        <div class="section3">
                            <h1 id="provinfo">Provenance Information</h1>
							<xsl:if test="archdesc/acqinfo/p !=''">
                            <h2>Provenance and Acquisition Information</h2>
                            <xsl:apply-templates select="archdesc/acqinfo/p"/>
							</xsl:if>
                            <xsl:if test="archdesc/separatedmaterial">
                                <h2>Related Collections</h2>
                                <p><xsl:apply-templates select="archdesc/separatedmaterial/archref"/></p>
                            </xsl:if>	
                            <h2>Processing Note</h2>
                            <xsl:apply-templates select="archdesc/processinfo/p"/>
                            <h2>Descriptive Rules Used</h2>
							<p><xsl:value-of select="control/conventiondeclaration/citation"/> (<xsl:value-of select="control/conventiondeclaration/abbr"/>)</p>
                            <xsl:apply-templates select="control/localtypedeclaration"/>
                        </div>
						<hr />
                        <div class="section4">
                            <h1 id="access">Access &amp; Use</h1>
                            <xsl:if test="archdesc/otherfindaid or control/representation">
                                <h2>Finding Aids</h2>
                            </xsl:if>
                            <xsl:apply-templates select="//otherfindaid/p"/>
                            <xsl:apply-templates select="control/representation"/>
                            <h2>Access Conditions</h2>
                            <xsl:apply-templates select="archdesc/accessrestrict/p"/>
                            <h2>Conditions Governing Reproductions and Use</h2>
                            <xsl:apply-templates select="archdesc/userestrict/p"/>
                        </div>
						<hr />
                        <div class="section5">						
                            <h1 id="subjects">Subject Headings</h1>		
                            <xsl:if test="archdesc/did/origination or archdesc/controlaccess/*[@relator]">
                                <h2>Creators</h2>
                                <xsl:apply-templates select="archdesc/did/origination/*"/>
								<xsl:apply-templates select="archdesc/controlaccess/*[@relator]"/>
                            </xsl:if>
                            <h2>Subjects</h2>
                            <xsl:apply-templates select="archdesc/controlaccess/persname[not(@relator)]"/>
							<xsl:apply-templates select="archdesc/controlaccess/*[name() != 'persname' and not(@relator)]"/>                           		
                        </div>
						<xsl:if test="archdesc/dsc">
							<hr />
							<div class="section6">
								<h1 id="series">Series Description &amp; Container List</h1>
								<xsl:choose> 
									<xsl:when test="archdesc/dsc/*[@level='series']">
										<ol class="bodylist"><xsl:apply-templates select="archdesc/dsc/*[@level='series']"/></ol>
									</xsl:when>
									<xsl:when test="archdesc/dsc/*[@level='file']">
										<ol class="bodylist"><li><table id="folder">
											<tr>
												<td>Folder Title/Description</td>
												<td>Date</td>
												<td>Box #</td>
												<td>Folder #</td>
												<td>Additional Info.</td>
											</tr>
											<xsl:apply-templates select="archdesc/dsc/*[@level='file']"/>
										</table></li></ol>
									</xsl:when>
									<xsl:when test="archdesc/dsc/*[@level='item']">
										<ol class="bodylist"><li><table id="folder">
											<tr>
												<td>Folder Title/Description</td>
												<td>Date</td>
												<td>Box #</td>
												<td>Folder #</td>
												<td>Additional Info.</td>
											</tr>
											<xsl:apply-templates select="archdesc/dsc/*[@level='item']"/>
										</table></li></ol>
									</xsl:when>
								</xsl:choose>
							</div>
						</xsl:if>
                        <xsl:if test="archdesc/bibliography">
							<hr />
							<div class="section7">					
								<h1 id="bib">Bibliography</h1>
								<xsl:apply-templates select="archdesc/bibliography"/>
							</div>
						</xsl:if>
                    </div>
                </div>
				</section>
				</div>
                <xsl:comment><script type="text/javascript">$(document).ready(function(){$('.fancybox').fancybox();});</script></xsl:comment>
<xsl:processing-instruction name="php">include "/afs/umbc.edu/public/web/sites/library/prod/htdocs/speccoll/sc_xml_footer.txt";?</xsl:processing-instruction>
</body></html>
</xsl:result-document>
    </xsl:template>
  
    <!-- ===================================================================================
	                                  Specific Templates 
	==================================================================================== -->
    <xsl:template match="archdesc/did/origination/*/* | archdesc/did/langmaterial/language">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
			<xsl:choose>
				<xsl:when test="..[name() = 'corpname']">
					<xsl:text>. </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>, </xsl:text>
				</xsl:otherwise>
			</xsl:choose></xsl:if>
    </xsl:template>
    
	<xsl:template match="control/representation">
		<p><xsl:value-of select="."/><xsl:text>: </xsl:text>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="./@href"/>
				</xsl:attribute>
				<xsl:value-of select="./@href"/>
			</xsl:element>
		</p>
	</xsl:template>
	
	<xsl:template match="control/localtypedeclaration">
		<p><xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="./citation/@href"/>
				</xsl:attribute>
				<xsl:value-of select="./citation"/>
			</xsl:element>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="./descriptivenote/p"/>
		</p>
	</xsl:template>
	
	<xsl:template match="archdesc/bibliography/*">
		<p>
			<xsl:choose>
			<xsl:when test="./ref">
				<xsl:value-of select="."/><xsl:text> </xsl:text>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="./ref/@href"/>
					</xsl:attribute>
					<xsl:value-of select="./ref/@href"/>
				</xsl:element><xsl:text>.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>
    
	<xsl:template match="archdesc/bioghist/chronlist/chronitem">
        <tr>
            <td>
                <xsl:apply-templates select=".//datesingle"/>
                <xsl:apply-templates select=".//daterange"/>
            </td>
            <td>
				<xsl:apply-templates select=".//event"/>
            </td>
        </tr>
    </xsl:template>
    
	<xsl:template match="chronitemset/* | datesingle">
        <xsl:value-of select="."/>
        <xsl:choose>
			<xsl:when test="position() != last() and not[ends-with(., '.')]">
				<xsl:text>; </xsl:text>
			</xsl:when>
			<xsl:when test="position() != last() and ends-with(., '.')">
				<xsl:text> </xsl:text>
			</xsl:when>
		</xsl:choose>
    </xsl:template>
	
	<xsl:template match="daterange">
		<xsl:value-of select="./fromdate"/><xsl:text>-</xsl:text><xsl:value-of select="./todate"/>
		<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
	</xsl:template>
   
	<xsl:template match="p">
        <p><xsl:value-of select="."/></p>
    </xsl:template>

	<xsl:template match="archdesc/arrangement/list">
		<p>
			<xsl:choose>
				<xsl:when test=".[@numeration='upper-alpha']">
					<strong><xsl:value-of select="./head"/></strong>
					<ol type="A" class="bodylist">
						<xsl:apply-templates select="./item"/>
					</ol>
				</xsl:when>
				<xsl:when test=".[@numeration='upper-roman']">
					<strong><xsl:text>Series</xsl:text></strong>
					<ol type="I" class="bodylist">
						<xsl:apply-templates select="./item"/>
					</ol>
				</xsl:when>
			</xsl:choose>
		</p>
    </xsl:template>
    
	<xsl:template match="item">
		<xsl:if test=". != ''">
			<li><xsl:value-of select="."/></li>
		</xsl:if>
    </xsl:template>
   
   <xsl:template match="archdesc/dsc//*[@level='series'] | archdesc/dsc//*[@level='subseries']">
        <li>
			<xsl:if test=".[@level='series']">
				<h2><xsl:value-of select="./did/unittitle"/></h2>
			</xsl:if>
			<xsl:if test=".[@level='subseries']">
				<h3><xsl:value-of select="./did/unittitle"/></h3>
			</xsl:if>
            <xsl:if test="./did/unitdate">
				<p><strong>Date: </strong><xsl:value-of select="./did/unitdate"/></p>
			</xsl:if>
			<xsl:if test="./did/physdesc">
				<p><strong>Extent: </strong><xsl:value-of select="./did/physdesc"/></p>
			</xsl:if>
			<xsl:if test="./scopecontent">
            <p><strong>Description: </strong><xsl:value-of select="./scopecontent"/></p>
			</xsl:if>
			<p>
				<a><xsl:attribute name="href" select="./did/dao/@href"/>
					<xsl:value-of select="./did/dao/descriptivenote/p"/>
				</a>
			</p>
            <xsl:apply-templates select="./did/container"/>
            <xsl:choose>
                <xsl:when test="./*[@level='subseries']">
                    <ol class="bodylist"><xsl:apply-templates select="./*[@level='subseries']"/></ol>
                </xsl:when>
                <xsl:when test="./*[@level='file']">
                    <ol class="bodylist"><li>
                        <table id="folder">
                            <tr>
                                <td>Folder Title/Description</td>
                                <td>Date</td>
								<td>Box #</td>
                                <td>Folder #</td>
								<td>Additional Info.</td>
                            </tr>
                            <xsl:apply-templates select="./*[@level='file']"/>
                        </table>
                    </li></ol>
                </xsl:when>
                <xsl:when test="./*[@level='item']">
                    <ol class="bodylist"><li>
                        <table id="folder">
                            <tr>
                                <td>Folder Title/Description</td>
                                <td>Date</td>
								<td>Box #</td>
                                <td>Folder #</td>
								<td>Additional Info.</td>
                            </tr>
                            <xsl:apply-templates select="./*[@level='item']"/>
                        </table>
                    </li></ol>
                </xsl:when>
            </xsl:choose>
        </li>
    </xsl:template>
    
	<xsl:template match="archdesc/dsc//*[@level='file']">
        <tr>
			<td><xsl:value-of select="./did/unittitle"/></td>
			<td><xsl:value-of select="./did/unitdate"/></td>
			<td><xsl:value-of select="./did/container[@localtype='box']"/></td>
			<td><xsl:value-of select="./did/container[@localtype='folder']"/></td>
			<td>
				<p>
				<a>
					<xsl:attribute name="href" select="./did/dao/@href"/>
					<xsl:value-of select="./did/dao/descriptivenote/p"/>
				</a>
				</p>
				<xsl:if test="./scopecontent">
					<xsl:variable name="num" select="concat(.//*[@localtype='box'], .//*[@localtype='folder'])"/>
					<a href="javascript:unhide('{$num}');">Description</a>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="./scopecontent">
			<tr>
				<td colspan="5">
				<xsl:variable name="num2" select="concat(.//*[@localtype='box'], .//*[@localtype='folder'])"/>
				<div id="{$num2}" class="hiddeninfo">
					<xsl:value-of select="./scopecontent"/>
				</div></td>
			</tr>
		</xsl:if>
    </xsl:template>
	
		<xsl:template match="archdesc/dsc//*[@level='item']">
        <tr>
			<td><xsl:value-of select="./did/unittitle"/></td>
			<td><xsl:value-of select="./did/unitdate"/></td>
			<td><xsl:value-of select="./did/container[@localtype='box']"/></td>
			<td><xsl:value-of select="./did/container[@localtype='folder']"/></td>
			<td>
				<p>
				<a>
					<xsl:attribute name="href" select="./did/dao/@href"/>
					<xsl:value-of select="./did/dao/descriptivenote/p"/>
				</a>
				</p>
				<xsl:if test="./scopecontent">
					<xsl:variable name="num" select="concat(.//*[@localtype='box'], .//*[@localtype='folder'])"/>
					<a href="javascript:unhide('{$num}');">Description</a>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="./scopecontent">
			<tr>
				<td colspan="5">
				<xsl:variable name="num2" select="concat(.//*[@localtype='box'], .//*[@localtype='folder'])"/>
				<div id="{$num2}" class="hiddeninfo">
					<xsl:value-of select="./scopecontent"/>
				</div></td>
			</tr>
		</xsl:if>
    </xsl:template>
   
   <xsl:template match="archdesc//container[@localtype='box']">
        <xsl:if test=". != ''">
            <p><xsl:text>Box: </xsl:text><xsl:value-of select="."/></p>
        </xsl:if>
    </xsl:template>
    
	<xsl:template match="archdesc//container[@localtype='folder']">
        <xsl:if test=". != ''">
            <p><xsl:text>Folder: </xsl:text><xsl:value-of select="."/></p>
        </xsl:if>
    </xsl:template>
	
	<xsl:template match="origination/* | controlaccess/*">
		<p><xsl:apply-templates select="./part"/></p>
	</xsl:template>
	
	<xsl:template match="part">
		<xsl:value-of select="."/>
		<xsl:if test="position() != last()">
			<xsl:choose>
				<xsl:when test="..[name() != 'persname' and not(@relator)]">
					<xsl:text> -- </xsl:text>
				</xsl:when>
				<xsl:when test="..[name() = 'corpname']">
					<xsl:text>. </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>, </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
	</xsl:template>
</xsl:stylesheet>
