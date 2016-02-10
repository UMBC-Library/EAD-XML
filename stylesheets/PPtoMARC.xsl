<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim">
	<xsl:output method="xml" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- ******************************************************************************************	-->
	<!-- Function Name: namesplit (MARC edition)											 		-->
	<!-- Parameters:																		 		-->
	<!-- 	name: Receives a string	containing a person's name in various allowed formats			-->
	<!-- Output:																			 		-->
	<!-- 	A person's name split up by last name, first name/nickname, and DOB/DOD					-->	
	<!-- ******************************************************************************************	-->	
	<xsl:template name="namesplit">
		<xsl:param name="name"/>
		<xsl:choose>
			<!-- Test if parentheses AND date exist -->
			<xsl:when test="matches($name, '\(', 'i') and matches($name, '\d')">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(substring-before($name, '('))"/>
					<!-- Do we need to put a comma before the parentheses? Or just a period or nothing?
					<xsl:if test="not(ends-with(normalize-space(substring-before($name, '(')), '.'))">
						<xsl:text>,</xsl:text>
					</xsl:if>
					-->
					<xsl:text> </xsl:text>
				</marc:subfield>
				<marc:subfield code="q">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="substring-before(substring-after($name, '('), ')')"/>
					<xsl:text>), </xsl:text>
				</marc:subfield>
				<marc:subfield code="d">
					<xsl:value-of select="normalize-space(substring-after(replace($name, ';', ''), '), '))"/>
					<xsl:text>.</xsl:text>
				</marc:subfield>
			</xsl:when>	
			<!-- Test if parentheses AND NO date exist -->
			<xsl:when test="matches($name, '\(', 'i')">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(substring-before($name, '('))"/>
				</marc:subfield>
				<marc:subfield code="q">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="substring-before(substring-after($name, '('), ')')"/>
					<xsl:text>)</xsl:text>
				</marc:subfield>
			</xsl:when>
			<!-- Test if date AND NO parentheses exist -->
			<xsl:when test="matches($name, '\d', 'i')">
			<!-- Replaces numbers in string with !'s for later use of substring-before function -->
			<xsl:variable name="justname" select="replace($name, ', \d', '!')"/>
			<!-- Removes all non-digits for later printing of the date portion of the string -->
			<xsl:variable name="date" select="replace($name, '\D*, ', '')"/>							
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(substring-before($justname, '!'))"/>
					<xsl:if test="not(ends-with(normalize-space(substring-before($justname, '!')), '.'))">
						<xsl:text>,</xsl:text>
					</xsl:if>
				<xsl:text> </xsl:text>
				</marc:subfield>
				<marc:subfield code="d">
					<xsl:value-of select="normalize-space(replace($date, ';', ''))"/>
					<xsl:text>.</xsl:text>
				</marc:subfield>
			</xsl:when>								
			<!-- Test if NO parentheses AND NO date exist -->
			<xsl:otherwise>
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(replace($name, '[;|(.;)]', ''))"/>
					<xsl:text>.</xsl:text>
				</marc:subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ******************************************************************************************	-->
	<!-- Function Name: string-ninja (MARC edition)											 		-->
	<!-- Parameters:																		 		-->
	<!-- 	list: receives a string of names/subjects										 		-->
	<!-- 	delimiter: receives the character/punctuation mark that splits the list 		 		-->
	<!--	selector: receives a string used to determine the output of the function		 		-->
	<!-- Output:																			 		-->
	<!-- 	1. For selector "authorx": creates a block of <marc:datafield> tags using  up to 3		-->
	<!--	different subfield tags to represent information for each person in the list.			-->
	<!--	2. For selector "subjects": creates a block of <marc:datafield> tags, one for			-->
	<!--	 each subject in the list.																-->
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
				<!-- The following variable (newlist) stores 'list' with white spaces removed -->
				<xsl:variable name="newlist">
					<xsl:choose>
						<!-- If 'list' contains 'delimiter' -->
						<!-- ============================== -->
						<xsl:when test="contains($list, $delimiter)">
							<xsl:value-of select="normalize-space($list)"/>
						</xsl:when>
						<!-- If 'list' doesn't contain 'delimiter' -->
						<!-- ===================================== -->
						<xsl:otherwise>
							<!-- Add a single 'delimiter' to the end of the string -->
							<!-- Accommodates for strings with one element or strings with no delimiters. -->
							<xsl:value-of select="concat(normalize-space($list), $delimiter)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="first" select="substring-before($newlist, $delimiter)"/>
				<xsl:variable name="remaining" select="substring-after($newlist, $delimiter)"/>						
				<xsl:choose>
					<!-- ==========================================================================================	-->
					<!-- 						Start: If selector is 'authorx'				 						-->
					<!-- ==========================================================================================	-->
					<xsl:when test="contains($selector, 'authorx')">
						<!-- Create datafield tags and call namesplit function to create subfield tags -->				
							<marc:datafield tag="700" ind1="1" ind2=" ">						
								<xsl:call-template name="namesplit">
									<xsl:with-param name="name" select="$first"/>
								</xsl:call-template>
							</marc:datafield>
					</xsl:when>
					<!-- ==========================================================================================	-->
					<!-- 								Start: If selector is 'subjects' 							-->
					<!-- ==========================================================================================	-->
					<xsl:when test="contains($selector, 'subjects')">
					<!-- Create datafield tags and subfield tags -->
						<xsl:choose>
							<!-- Test if subdivisions exist -->
							<xsl:when test="contains($first, '--')">
								<marc:datafield tag="650" ind1=" " ind2="0">									
									<marc:subfield code="a">
										<xsl:value-of select="replace($first, '-- ', '&lt;/marc:subfield&gt;&lt;marc&#58;subfield code=&#34;x&#34;&gt;')" disable-output-escaping="yes"/>
										<xsl:text>.</xsl:text>	
									</marc:subfield>
								</marc:datafield>
							</xsl:when>
							<!-- Test if NO subdivisions, but a comma (and likely a name) -->
							<xsl:when test="matches($first, '\d', 'i')">
								<marc:datafield tag="600" ind1="1" ind2="0">						
									<xsl:call-template name="namesplit">
										<xsl:with-param name="name" select="$first"/>
									</xsl:call-template>
								</marc:datafield>
							</xsl:when>
							<xsl:otherwise>
								<marc:datafield tag="650" ind1=" " ind2="0">	
									<marc:subfield code="a">
										<xsl:value-of select="$first"/>
										<xsl:text>.</xsl:text>	
									</marc:subfield>
								</marc:datafield>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
				<!-- A recursive call to process additional sub-strings -->
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
	<!-- ******************************************************************************************	-->
	<!-- 								Main Template Begins										-->
	<!-- ******************************************************************************************	-->
	<xsl:template match="/">
		<marc:collection xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
			<xsl:apply-templates/>
		</marc:collection>
	</xsl:template>
	
	<xsl:template match="ppdata">
		<marc:record>
			<marc:leader>02211npc a2200289Ka 4500</marc:leader>
			
			<marc:controlfield tag="008">
				<xsl:text>151103i</xsl:text>
				<xsl:value-of select="normalize-space(earlydate)"/>
				<xsl:value-of select="normalize-space(latedate)"/>
				<xsl:text>xx                  eng d</xsl:text>
			</marc:controlfield>
			
			<marc:datafield tag="100" ind1="1" ind2=" ">
				<xsl:call-template name="namesplit">
					<xsl:with-param name="name" select="creator"/>
				</xsl:call-template>
			</marc:datafield>
			
			<marc:datafield tag="245" ind1="1" ind2="0">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(collection)"/>
					<xsl:text>.</xsl:text>
				</marc:subfield>
			</marc:datafield>
			
			<marc:datafield tag="300" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(substring-before(extent, ' '))"/>
				</marc:subfield>
				<marc:subfield code="f">
					<xsl:value-of select="normalize-space(substring-after(substring-before(extent, '('), ' '))"/>
				</marc:subfield>
				<marc:subfield code="a">
					<xsl:text>&#40;</xsl:text>	
					<xsl:value-of select="normalize-space(substring-before(substring-after(extent, '('), ' '))"/>
				</marc:subfield>
				<marc:subfield code="f">
					<xsl:value-of select="normalize-space(substring-after(substring-before(substring-after(extent, '('), ')'), ' '))"/>
					<xsl:text>&#41;</xsl:text>	
				</marc:subfield>
			</marc:datafield>
			
			<marc:datafield tag="351" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(system)"/>
				</marc:subfield>
			</marc:datafield>
			
			<marc:datafield tag="506" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(access)"/>
				</marc:subfield>
			</marc:datafield>
			
			<marc:datafield tag="520" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(descrip)"/>
				</marc:subfield>
			</marc:datafield>
			
			<marc:datafield tag="524" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(udf22)"/>
				</marc:subfield>
			</marc:datafield>
			
			<marc:datafield tag="540" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(rights)"/>
				</marc:subfield>
			</marc:datafield>
			
			<xsl:if test="normalize-space(associate)">
				<marc:datafield tag="544" ind1="0" ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="normalize-space(associate)"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:if>
			
			<marc:datafield tag="545" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(admin)"/>
				</marc:subfield>
			</marc:datafield>
			<marc:datafield tag="555" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="normalize-space(findaid)"/>
				</marc:subfield>
			</marc:datafield>
			
			<!-- Call string-ninja function to split up string of subjects/people as subjects -->
			<xsl:call-template name="string-ninja">
				<xsl:with-param name="list" select="subjects"/>
				<xsl:with-param name="delimiter" select="'&#59;'"/>
				<xsl:with-param name="selector" select="'subjects'"/>
			</xsl:call-template>

			<!-- Call string-ninja function to split up string of other creators -->
			<xsl:call-template name="string-ninja">
				<xsl:with-param name="list" select="authorx"/>
				<xsl:with-param name="delimiter" select="'&#59;'"/>
				<xsl:with-param name="selector" select="'authorx'"/>
			</xsl:call-template>

			<xsl:if test="normalize-space(udf21)">
				<marc:datafield tag="856" ind1=" " ind2=" ">
					<marc:subfield code="3">
						<xsl:value-of select="normalize-space(substring-before(udf21, ':'))"/>
						<xsl:text>: </xsl:text>	
					</marc:subfield>
					<marc:subfield code="u">
						<xsl:value-of select="normalize-space(substring-before(substring-after(udf21, '&gt;'), '&lt;'))"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:if>
		</marc:record>
	</xsl:template>
</xsl:stylesheet>
