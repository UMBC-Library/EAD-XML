<?xml version="1.0" encoding="UTF-8"?>
<!-- ************************************************************************** -->
<!-- XSLT stylesheet to transform EAD-XML to HTML for Web Display		-->
<!-- Created By: Emily Somach							-->
<!-- **************************************************************************	-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/REC-html40">
	<xsl:output method="html" media-type="text/html" indent="yes"/>
	<!-- Main Template -->
	<xsl:template match="ead">
		<html>
			<head>
				<title>
					<xsl:value-of select="control/filedesc/titlestmt/titleproper"/>
				</title>
				<!-- Our CSS stylesheet -->
				<link rel="stylesheet" type="text/css" href="../EADstyle.css"/>
				<!-- Our print/pdf stylesheet -->
				<link rel="stylesheet" href="../print.css" type="text/css" media="print"/>
				<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
				<!-- Fancybox styling info -->
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<link rel="stylesheet" href="../fancybox/source/jquery.fancybox.css" type="text/css" media="screen"/>
				<script type="text/javascript" src="../fancybox/source/jquery.fancybox.pack.js"/>
				<!-- Google fonts -->
				<link href="http://fonts.googleapis.com/css?family=Droid+Serif:400,400italic" rel="stylesheet" type="text/css"/>
				<link href="http://fonts.googleapis.com/css?family=Droid+Sans:400,700" rel="stylesheet" type="text/css"/>
			</head>
			<body>
				<div id="header">
					<img src="../logo.jpg" width="200px" align="left"/>
					<p>Albin O. Kuhn Library and Gallery</p>
					<p>UMBC</p>
					<p>1000 Hilltop Circle</p>
					<p>Baltimore, MD 21250</p>
					<p>410-455-2353</p>
					<p>speccoll@umbc.edu</p>
				</div>
				<div id="leftbar">
					<div id="fabox">
						<h1>Finding Aid</h1>
					</div>
					<div id="nav">
						<ul>
							<li>
								<a href="#overview" title="skip to Overview">Overview</a>
							</li>
							<li>
								<a href="#adminbiog" title="skip to Admin Bio Note">Administrative/Biographical Note</a>
							</li>
							<li>
								<a href="#scope" title="skip to Scope &amp; Content">Scope &amp; Content</a>
							</li>
							<li>
								<a href="#provinfo" title="skip to Provenance">Provenance Information</a>
							</li>
							<li>
								<a href="#access" title="skip to Access &amp; Use">Access &amp; Use</a>
							</li>
							<li>
								<a href="#subjects" title="skip to Subjects">Subject Headings</a>
							</li>
							<li>
								<a href="#series" title="skip to Series Description">Series Description &amp; Container List</a>
							</li>
							<xsl:if test="archdesc/bibliography">
								<li>
									<a href="#bib" title="skip to Bibliography">Bibliography</a>
								</li>
							</xsl:if>
							<li>
								<a href="{concat('../EAD PDFs/', archdesc/did/unitid, '.pdf')}" title="go to PDF" target="_blank">View PDF</a>
							</li>
						</ul>
					</div>
				</div>
				<div id="content-wrapper">
					<div id="firstbox">
						<div class="section1">
							<h1 id="overview">Overview</h1>
							<div id="table-content">
								<table id="overviewtable">
									<tr>
										<td>Title:</td>
										<td>
											<xsl:value-of select="//titleproper"/>
										</td>
									</tr>
									<tr>
										<td>Call Number:</td>
										<td>
											<xsl:value-of select="//unitid"/>
										</td>
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
												<xsl:text>; </xsl:text>
												<xsl:value-of select="archdesc/did/unitdate[@unitdatetype='bulk']"/>
											</xsl:if>
										</td>
									</tr>
									<tr>
										<td>Size:</td>
										<td>
											<xsl:value-of select="archdesc/did/physdesc"/>
										</td>
									</tr>
									<tr>
										<td>Language:</td>
										<td>
											<xsl:apply-templates select="archdesc/did/langmaterial/language"/>
										</td>
									</tr>
									<tr>
										<td>Abstract:</td>
										<td>
											<xsl:value-of select="archdesc/did/abstract"/>
										</td>
									</tr>
									<tr>
										<td>Citation:</td>
										<td>
											<xsl:value-of select="archdesc/prefercite"/>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div id="images">
							<a class="fancybox" href="../pha1.jpg">
								<img src="../pha1.jpg" alt="some_text" width="150"/>
							</a>
							<a class="fancybox" href="../pha2.jpg">
								<img src="../pha2.jpg" alt="some_text" width="150"/>
							</a>
							<a class="fancybox" href="https://upload.wikimedia.org/wikipedia/commons/6/66/UMBC_Seal.png">
								<img src="https://upload.wikimedia.org/wikipedia/commons/6/66/UMBC_Seal.png" alt="some_text" width="150"/>
							</a>
						</div>
					</div>
					<div id="secondbox">
						<div class="section2">
							<h1 id="adminbiog">Administrative/Biographical Note</h1>
							<xsl:apply-templates select="archdesc/bioghist/p"/>
							<xsl:if test="archdesc/bioghist/chronlist">
								<table id="timeline">
									<xsl:apply-templates select="archdesc/bioghist/chronlist/chronitem"/>
								</table>
							</xsl:if>
							<h1 id="scope">Scope &amp; Content</h1>
							<h2>Arrangement</h2>
							<xsl:apply-templates select="archdesc/arrangement/p"/>
							<xsl:apply-templates select="archdesc/arrangement/list"/>
							<h2>Note</h2>
							<xsl:apply-templates select="archdesc/scopecontent/p"/>
						</div>
						<div class="section3">
							<h1 id="provinfo">Provenance Information</h1>
							<h2>Provenance and Acquisition Information</h2>
							<xsl:apply-templates select="archdesc/acqinfo/p"/>
							<xsl:if test="archdesc/separatedmaterial">
								<h2>Related Collections</h2>
								<xsl:apply-templates select="archdesc/separatedmaterial/p"/>
							</xsl:if>
							<h2>Processing Note</h2>
							<xsl:apply-templates select="archdesc/processinfo/p"/>
							<h2>Descriptive Rules Used</h2>
							<p>
								<xsl:value-of select="control/localtypedeclaration/citation"/>
							</p>
							<xsl:apply-templates select="control/localtypedeclaration/descriptivenote/p"/>
						</div>
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
						<div class="section6">
							<h1 id="series">Series Description &amp; Container List</h1>
							<xsl:choose>
								<xsl:when test="archdesc/dsc/*[@level='series']">
									<ol>
										<xsl:apply-templates select="archdesc/dsc/*[@level='series']"/>
									</ol>
								</xsl:when>
								<xsl:when test="archdesc/dsc/*[@level='file']">
									<ol>
										<li>
											<table id="folder">
												<tr>
													<td>Folder Title</td>
													<td>Date</td>
													<td>Box #</td>
													<td>Folder #</td>
													<td>Digital Object</td>
												</tr>
												<xsl:apply-templates select="archdesc/dsc/*[@level='file']"/>
											</table>
										</li>
									</ol>
								</xsl:when>
							</xsl:choose>
						</div>
						<xsl:if test="archdesc/bibliography">
							<div class="section7">
								<h1 id="bib">Bibliography</h1>
								<xsl:apply-templates select="archdesc/bibliography/p"/>
							</div>
						</xsl:if>
					</div>
				</div>
				<script type="text/javascript">$(document).ready(function(){$('.fancybox').fancybox();});</script>
			</body>
			<footer>

			</footer>
		</html>
	</xsl:template>
	<!-- ===================================================================================
	                                  Specific Templates 
	==================================================================================== -->
	<xsl:template match="archdesc/did/origination/*/* | archdesc/did/langmaterial/language">
		<xsl:value-of select="."/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="control/representation">
		<p>
			<xsl:value-of select="."/>
			<xsl:text>: </xsl:text>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="./@href"/>
				</xsl:attribute>
				<xsl:value-of select="./@href"/>
			</xsl:element>
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
				<xsl:text/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="daterange">
		<xsl:value-of select="./fromdate"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="./todate"/>
		<xsl:if test="position() != last()">
			<xsl:text>; </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="p">
		<p>
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
	<xsl:template match="archdesc/arrangement/list">
		<p>
			<xsl:choose>
				<xsl:when test=".[@numeration='upperalpha']">
					<strong>
						<xsl:value-of select="./head"/>
					</strong>
					<ol type="A">
						<xsl:apply-templates select="./item"/>
					</ol>
				</xsl:when>
				<xsl:when test=".[@numeration='upperroman']">
					<strong>
						<xsl:text>Series</xsl:text>
					</strong>
					<ol type="I">
						<xsl:apply-templates select="./item"/>
					</ol>
				</xsl:when>
			</xsl:choose>
		</p>
	</xsl:template>
	<xsl:template match="item">
		<li>
			<xsl:value-of select="."/>
		</li>
	</xsl:template>
	<xsl:template match="archdesc/dsc//*[@level='series'] | archdesc/dsc//*[@level='subseries']">
		<li>
			<xsl:if test=".[@level='series']">
				<h2>
					<xsl:value-of select="./did/unittitle"/>
				</h2>
			</xsl:if>
			<xsl:if test=".[@level='subseries']">
				<h3>
					<xsl:value-of select="./did/unittitle"/>
				</h3>
			</xsl:if>
			<xsl:if test="./did/unitdate">
				<p>
					<strong>Date: </strong>
					<xsl:value-of select="./did/unitdate"/>
				</p>
			</xsl:if>
			<xsl:if test="./did/physdesc">
				<p>
					<strong>Extent: </strong>
					<xsl:value-of select="./did/physdesc"/>
				</p>
			</xsl:if>
			<xsl:if test="./scopecontent">
				<p>
					<strong>Description: </strong>
					<xsl:value-of select="./scopecontent"/>
				</p>
			</xsl:if>
			<p>
				<a>
					<xsl:attribute name="href" select="./did/dao/@href"/>
					<xsl:value-of select="./did/dao/descriptivenote"/>
				</a>
			</p>
			<xsl:apply-templates select="./did/container"/>
			<xsl:choose>
				<xsl:when test="./*[@level='subseries']">
					<ol>
						<xsl:apply-templates select="./*[@level='subseries']"/>
					</ol>
				</xsl:when>
				<xsl:when test="./*[@level='file']">
					<ol>
						<li>
							<table id="folder">
								<tr>
									<td>Folder Title</td>
									<td>Date</td>
									<td>Box #</td>
									<td>Folder #</td>
									<td>Digital Object</td>
								</tr>
								<xsl:apply-templates select="./*[@level='file']"/>
							</table>
						</li>
					</ol>
				</xsl:when>
			</xsl:choose>
		</li>
	</xsl:template>
	<xsl:template match="archdesc/dsc//*[@level='file']">
		<tr>
			<td>
				<xsl:value-of select="./did/unittitle"/>
			</td>
			<td>
				<xsl:value-of select="./did/unitdate"/>
			</td>
			<td>
				<xsl:value-of select="./did/container[@localtype='box']"/>
			</td>
			<td>
				<xsl:value-of select="./did/container[@localtype='folder']"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href" select="./did/dao/@href"/>
					<xsl:value-of select="./did/dao/descriptivenote"/>
				</a>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="archdesc//container[@localtype='box']">
		<xsl:if test=". != ''">
			<p>
				<xsl:text>Box: </xsl:text>
				<xsl:value-of select="."/>
			</p>
		</xsl:if>
	</xsl:template>
	<xsl:template match="archdesc//container[@localtype='folder']">
		<xsl:if test=". != ''">
			<p>
				<xsl:text>Folder: </xsl:text>
				<xsl:value-of select="."/>
			</p>
		</xsl:if>
	</xsl:template>
	<xsl:template match="origination/* | controlaccess/*">
		<p>
			<xsl:apply-templates select="./part"/>
		</p>
	</xsl:template>
	<xsl:template match="part">
		<xsl:value-of select="."/>
		<xsl:if test="position() != last()">
			<xsl:choose>
				<xsl:when test="..[name() != 'persname' and not(@relator)]">
					<xsl:text> -- </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>, </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
