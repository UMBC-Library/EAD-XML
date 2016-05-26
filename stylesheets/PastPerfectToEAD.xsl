<?xml version="1.0"?>
<!-- ************************************************************************** -->
<!-- XSLT stylesheet to transform PastPerfect exported XML files to EAD3-XML	-->
<!-- Revision: 1.0																-->
<!-- Created By: Emily Somach and Dmitri Rudnitsky 								-->
<!-- 											 								-->
<!-- 2016.04.01 - Fixed error with ampersands in creator/subject fields			-->
<!-- 2016.04.29 - Updated language handling to match "Language (code)" format   -->
<!-- **************************************************************************	-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- ******************************************************************************************	-->
	<!-- Function Name: string-ninja													 	 		-->
	<!-- Parameters:																		 		-->
	<!-- 	list: receives a string of names/subjects										 		-->
	<!-- 	delimiter: receives the character/punctuation mark that splits the list 		 		-->
	<!--	selector: receives a string used to determine the output of the function		 		-->
	<!-- Output:																			 		-->
	<!-- 	1. For selectors "authorx" & "creator": creates block of <persname>/<corpname> tags		--> 
	<!--	with optional <part> tags inside. May require manual edits post-processing.			 	-->
	<!--	2. For selector "subjects": creates a block of nested <subject> tags with optional		--> 
	<!--	<part> tags inside. May require manual edits post-processing.							-->
	<!-- ******************************************************************************************	-->
	<xsl:template name="string-ninja">
		<xsl:param name="list"/>
		<xsl:param name="delimiter"/>
		<xsl:param name="selector"/>
		<xsl:choose>
			<!-- If 'list' is empty -->
			<!-- ================== -->
			<xsl:when test="$list = ''">
				<!-- Do nothing -->
			</xsl:when>	
			<!-- If 'list' is not empty -->
			<!-- ====================== -->
			<xsl:otherwise>
				<!-- create variable (newlist) to store modified list -->
				<!-- ================================================ -->
				<xsl:variable name="newlist">
					<xsl:choose>
						<!-- If 'list' contains 'delimiter' (contains multiple elements OR 1 element ending in delimiter), remove white space -->
						<!-- ================================================================================================================ -->
						<xsl:when test="contains($list, $delimiter)">
							<xsl:value-of select="normalize-space($list)"/>
						</xsl:when>
						<!-- If 'list' doesn't contain 'delimiter' (contains 1 element), remove white space and add delimiter to end -->
						<!-- ======================================================================================================= -->
						<xsl:otherwise>
							<xsl:value-of select="concat(normalize-space($list), $delimiter)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="first" select="substring-before($newlist, $delimiter)"/>
				<xsl:variable name="remaining" select="substring-after($newlist, $delimiter)"/>
				<xsl:choose>
					<!-- ==========================================================================================	-->
					<!-- 							Start: If selector is 'creator'									-->
					<!-- ==========================================================================================	-->
					<xsl:when test="contains($selector, 'creator')">
						<xsl:choose>
							<xsl:when test="contains($first, ', ')">
							<!-- If string contains a comma, treat it as a persname -->
							<!-- ================================================== -->
								<xsl:variable name="firstmod" select="replace($first, '&amp;', '&amp;amp;')"/>
								<!-- Double-escape ampersands to avoid error from 'disable-output-escaping' below -->
								<!-- ============================================================================ -->
								<persname relator="creator" encodinganalog="100" source="lc">
									<part>
										<xsl:value-of select="replace($firstmod, ', ', '&lt;/part&gt;&lt;part&gt;')" disable-output-escaping="yes"/>
									</part>
								</persname>
							</xsl:when>
							<xsl:otherwise>
							<!-- If string does not contain a comma, treat as a corpname -->
							<!-- ======================================================= -->
								<corpname relator="creator" encodinganalog="110" source="lc">
									<part><xsl:value-of select="$first"/></part>
								</corpname>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- ==========================================================================================	-->
					<!-- 							Start: If selector is 'authorx'									-->
					<!-- ==========================================================================================	-->
					<xsl:when test="contains($selector, 'authorx')">
						<xsl:choose>
							<xsl:when test="contains($first, ', ')">
							<!-- If string contains a comma, treat it as a persname -->
							<!-- ================================================== -->
								<xsl:variable name="firstmod" select="replace($first, '&amp;', '&amp;amp;')"/>
								<!-- Double-escape ampersands to avoid error from 'disable-output-escaping' below -->
								<!-- ============================================================================ -->
								<persname relator="creator" encodinganalog="700" source="lc">
									<part>
										<xsl:value-of select="replace($firstmod, ', ', '&lt;/part&gt;&lt;part&gt;')" disable-output-escaping="yes"/>
									</part>
								</persname>
							</xsl:when>
							<xsl:otherwise>
							<!-- If string does not contain a comma, treat as a corpname -->
							<!-- ======================================================= -->
								<corpname relator="creator" encodinganalog="710" source="lc">
									<part><xsl:value-of select="$first"/></part>
								</corpname>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- ==========================================================================================	-->
					<!-- 								Start: If selector is 'subjects' 							-->
					<!-- ==========================================================================================	-->
					<xsl:when test="contains($selector, 'subjects')">
						<xsl:choose>
							<!-- Test if subdivisions exist -->
							<!-- ========================== -->
							<xsl:when test="contains($first, '--')">
								<!-- Double-escape ampersands to avoid error from 'disable-output-escaping' below -->
								<!-- ============================================================================ -->
								<xsl:variable name="firstmod" select="replace($first, '&amp;', '&amp;amp;')"/>
								<subject encodinganalog="650" source="lc">
									<part>
										<xsl:value-of select="replace($firstmod, ' -- ', '&lt;/part&gt;&lt;part&gt;')" disable-output-escaping="yes"/>
									</part>
								</subject>
							</xsl:when>						
							<!-- Test if NO subdivisions -->
							<!-- ======================= -->
							<xsl:otherwise>
								<subject encodinganalog="650" source="lc">
										<part><xsl:value-of select="$first"/></part>
								</subject>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- ==========================================================================================	-->
					<!-- 								Start: If selector is 'language' 							-->
					<!-- ==========================================================================================	-->
					<xsl:when test="contains($selector, 'lang')">
						<language>
							<xsl:attribute name="langcode" select="substring-before(substring-after($first, '('), ')')"/>
							<xsl:value-of select="substring-before($first, ' ')"/>
						</language>
					</xsl:when>
				</xsl:choose>
				<!-- A recursive call to process additional sub-strings -->
				<!-- ================================================== -->
				<xsl:if test="$remaining">
					<xsl:call-template name="string-ninja">
						<xsl:with-param name="list" select="$remaining"/>
						<xsl:with-param name="delimiter" select="$delimiter"/>
						<xsl:with-param name="selector" select="$selector"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>						
		</xsl:choose>
	</xsl:template>			
	<!-- *********************************************************************************** -->
	<!-- 						Main template starts here									 -->
	<!-- *********************************************************************************** -->
	<xsl:template match="/">
	<!-- Nest multiple ead elements inside a batch tag; aids batch processing -->
		<batch>
			<xsl:apply-templates/>
		</batch>
	</xsl:template>
	<xsl:template match="ppdata">
		<ead audience="external" relatedencoding="MARC21">
			<control countryencoding="iso3166-1" dateencoding="iso8601" langencoding="iso639-2b" repositoryencoding="iso15511" scriptencoding="iso15924">
				<recordid>
					<xsl:value-of select="objectid"/>
				</recordid>
				<!-- Checks if there is a link to a finding aid, digital collection, or email address -->
				<xsl:choose>
					<!-- If a record only has a finding aid -->
					<xsl:when test="contains(udf21, 'Finding')">
						<representation encodinganalog="856">
							<xsl:attribute name="href" select="normalize-space(substring-before(substring-after(udf21, '&gt;'), '&lt;'))"/>
							<xsl:attribute name="localtype" select="'PHP'"/>
							<xsl:text>Finding Aid</xsl:text>
						</representation>
						<!-- If a record has both -->
						<xsl:if test="contains(udf21, 'Digital')">
							<representation encodinganalog="856">
								<xsl:attribute name="href" select="normalize-space(substring-before(substring-after(substring-after(udf21, 'ion: '), '&gt;'), '&lt;'))"/>
								<xsl:attribute name="localtype" select="'PHP'"/>
								<xsl:text>Digital Collection</xsl:text>
							</representation>
						</xsl:if>
					</xsl:when>
					<!-- If a record only has a digital collection -->
					<xsl:when test="contains(udf21, 'Digital')">
						<representation encodinganalog="856">
							<xsl:attribute name="href" select="normalize-space(substring-before(substring-after(udf21, '&gt;'), '&lt;'))"/>
							<xsl:attribute name="localtype" select="'PHP'"/>					
							<xsl:text>Digital Collection</xsl:text>
						</representation>
					</xsl:when>
					<!-- If a record has neither or provides an email address -->
					<xsl:otherwise>
						<!-- Do nothing for now. -->
					</xsl:otherwise>
				</xsl:choose>
				<filedesc>
					<titlestmt>
						<titleproper encodinganalog="245$a">
							<xsl:value-of select="title"/>
						</titleproper>
						<author>
							<xsl:value-of select="normalize-space(archivist)"/>
						</author>
					</titlestmt>
				</filedesc>
				<maintenancestatus value="new"/>
				<maintenanceagency countrycode="US">
					<agencycode><xsl:text>mdubc</xsl:text></agencycode>
					<agencyname><xsl:text>University of Maryland, Baltimore County (UMBC)</xsl:text></agencyname>
				</maintenanceagency>
				<conventiondeclaration>
					<abbr><xsl:text>DACS</xsl:text></abbr>
					<citation href="http://www2.archivists.org/standards/DACS" lastdatetimeverified="2015-02-24">
						<xsl:text>Describing Archives: a Content Standard</xsl:text>
					</citation>
				</conventiondeclaration>
				<localtypedeclaration>
					<citation href="https://wiki.umbc.edu/download/attachments/11437110/Processing_v2_2015.pdf" lastdatetimeverified="2015-12-10"><xsl:text>Archives Processing Manual: Description (2015)</xsl:text></citation>
					<descriptivenote>
						<p><xsl:text>The processing manual used in Special Collections for all descriptive platforms, including PastPerfect.</xsl:text></p>
					</descriptivenote>
				</localtypedeclaration>
				<maintenancehistory>
					<maintenanceevent>
						<eventtype value="derived"/>
						<eventdatetime>
							<xsl:attribute name="standarddatetime" select="current-dateTime()"/>
						</eventdatetime>
						<agenttype value="machine"/>
						<agent>Computer</agent>
						<eventdescription>Conversion from PastPerfect.</eventdescription>
					</maintenanceevent>
					<!-- Create empty maintenanceevent for manual post-processing -->
					<maintenanceevent>
						<eventtype value="revised" />
						<eventdatetime>
							<xsl:attribute name="standarddatetime" select="'UPDATE TIME'"/>
						</eventdatetime>
						<agenttype value="human" />
						<agent><xsl:text>INSERT NAME</xsl:text></agent>
						<eventdescription><xsl:text>Manual updates including: subjects, other creators, and people as subjects.</xsl:text></eventdescription>
					</maintenanceevent>
				</maintenancehistory>
			</control>
			<archdesc level="collection">
				<did>
					<unittitle encodinganalog="245$a">
						<xsl:value-of select="title"/>
					</unittitle>
					<unitid countrycode="US" repositorycode="mdubc">
						<xsl:value-of select="objectid"/>
					</unitid>
					<!-- Only print if not-empty -->
					<xsl:if test="normalize-space(creator)">
						<origination>
							<xsl:call-template name="string-ninja">
								<xsl:with-param name="list" select="creator"/>
								<xsl:with-param name="delimiter" select="'&#59;'"/>
								<xsl:with-param name="selector" select="'creator'"/>
							</xsl:call-template>
						</origination>
					</xsl:if>
					<!-- Separation of Bulk and Inclusive Dates -->
					<xsl:choose>
						<!-- If bulk date delimiter (;) exists -->
						<xsl:when test="contains(date,';')">
							<unitdate unitdatetype="inclusive" encodinganalog="245$f">
								<xsl:value-of select="normalize-space(substring-before(date, ';'))"/>
							</unitdate>
							<unitdate unitdatetype="bulk" encodinganalog="245$g">
								<xsl:value-of select="normalize-space(substring-after(date, ';'))"/>
							</unitdate>
						</xsl:when>
						<!-- If only inclusive dates exist -->
						<xsl:otherwise>
							<unitdate unitdatetype="inclusive" encodinganalog="245$f">
								<xsl:value-of select="date"/>
							</unitdate>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Separation of Beginning and End Dates -->
					<unitdatestructured unitdatetype="inclusive">
						<daterange>
							<fromdate>
								<xsl:value-of select="earlydate"/>
							</fromdate>
							<todate>
								<xsl:value-of select="latedate"/>
							</todate>
						</daterange>
					</unitdatestructured>
					<!-- Include both physdesc & physdescset -->
					<!-- *********************************** -->
					<physdesc encodinganalog="300$a$f">
						<xsl:value-of select="extent"/>
					</physdesc>
					<!-- Separation of carrier (boxes) and spaceoccupied (linear ft.) -->
					<physdescset>
						<physdescstructured coverage="whole" physdescstructuredtype="carrier">
							<quantity>
							<!-- box quantity -->
								<xsl:value-of select="normalize-space(substring-before(extent, ' '))"/>
							</quantity>
							<unittype>
							<!-- the word boxes -->
								<xsl:value-of select="normalize-space(substring-after(substring-before(extent, '('), ' '))"/>
							</unittype>
						</physdescstructured>
						<physdescstructured coverage="whole" physdescstructuredtype="spaceoccupied">
							<quantity>
							<!-- linear feet quantity -->
								<xsl:value-of select="normalize-space(substring-before(substring-after(extent, '('), ' '))"/>
							</quantity>
							<unittype>
							<!-- the word linear feet-->
								<xsl:value-of select="normalize-space(substring-after(substring-before(substring-after(extent, '('), ')'), ' '))"/>
							</unittype>
						</physdescstructured>
					</physdescset>
					<abstract encodinganalog="520$a">
						<xsl:value-of select="normalize-space(descrip)"/>
					</abstract>
					<!-- Create tag-sets for one or multiple languages -->
					<langmaterial>
						<xsl:call-template name="string-ninja">
							<xsl:with-param name="list" select="language"/>
							<xsl:with-param name="delimiter" select="'&#44;'"/>
							<xsl:with-param name="selector" select="'lang'"/>
						</xsl:call-template>
					</langmaterial>
					<repository>
						<corpname><part><xsl:text>University of Maryland, Baltimore County</xsl:text></part></corpname>
						<address>
							<addressline><xsl:text>Albin O. Kuhn Library and Gallery</xsl:text></addressline>
							<addressline><xsl:text>UMBC</xsl:text></addressline>
							<addressline><xsl:text>1000 Hilltop Circle</xsl:text></addressline>
							<addressline><xsl:text>Baltimore, MD 21250</xsl:text></addressline>
							<addressline><xsl:text>410-455-2353</xsl:text></addressline>
							<addressline><xsl:text>speccoll@umbc.edu</xsl:text></addressline>
						</address>
					</repository>
				</did>
				<bioghist encodinganalog="545">
					<p><xsl:value-of select="normalize-space(admin)"/></p>
				</bioghist>
				<arrangement encodinganalog="351">
					<p><xsl:value-of select="normalize-space(system)"/></p>
				</arrangement>
				<accessrestrict encodinganalog="506">
					<p><xsl:value-of select="normalize-space(access)"/></p>
				</accessrestrict>
				<userestrict encodinganalog="540">
					<p><xsl:value-of select="normalize-space(rights)"/></p>
				</userestrict>
				<prefercite encodinganalog="524">
					<p><xsl:value-of select="normalize-space(udf22)"/></p>
				</prefercite>
				<!-- Only print if not-empty -->
				<xsl:if test="normalize-space(findaid)">
					<otherfindaid encodinganalog="555">
						<p><xsl:value-of select="normalize-space(findaid)"/></p>
					</otherfindaid>
				</xsl:if>
				<acqinfo>
					<p><xsl:value-of select="normalize-space(accruals)"/></p>
				</acqinfo>
				<processinfo>
					<p><xsl:value-of select="normalize-space(custodial)"/></p>	
				</processinfo>
				<!-- Only print if not-empty -->
				<xsl:if test="normalize-space(associate)">
					<separatedmaterial encodinganalog="544">
							<p><xsl:value-of select="normalize-space(associate)"/></p>
					</separatedmaterial>
				</xsl:if>
				<controlaccess>
					<!-- Other Creators: Exported from PastPerfect as one string -->
					<!-- ======================================================= -->
					<xsl:call-template name="string-ninja">
						<xsl:with-param name="list" select="authorx"/>
						<xsl:with-param name="delimiter" select="'&#59;'"/>
						<xsl:with-param name="selector" select="'authorx'"/>
					</xsl:call-template>
					<!-- Subjects: Exported as one string from the PastPerfect subject field   -->
					<!-- Subjects also include related people who are not creators			   -->
					<!-- ===================================================================== -->				
					<xsl:call-template name="string-ninja">
						<xsl:with-param name="list" select="subjects"/>
						<xsl:with-param name="delimiter" select="'&#59;'"/>
						<xsl:with-param name="selector" select="'subjects'"/>
					</xsl:call-template>
				</controlaccess>
			</archdesc>
		</ead>
	</xsl:template>
</xsl:stylesheet>
