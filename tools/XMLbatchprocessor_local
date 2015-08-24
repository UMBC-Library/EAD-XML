@ECHO OFF
ECHO Welcome to the PastPerfect XML to EAD Batch Transformation Tool
ECHO This tool is automated using file locations specific to UMBC Special Collections.
ECHO **********************************************************************************
ECHO.

ECHO ---------------------------------------------------------------------
ECHO Note: Please use this tool with an error-free stylesheet ^(.xsl file ^)
ECHO ---------------------------------------------------------------------
:START
ECHO.

REM Saxon directory will be hardcoded for the time being, as this .BAT file is only being run from the I: drive
REM Enter the main directory of the Saxon processor ^(ex. I:\SC_BMS\XML Project\Tool Files\SaxonHE9-6-0-5J^):
REM SET /P saxon="I:\SC_BMS\XML Project\Tool Files\SaxonHE9-6-0-5J"

SET saxon="I:\SC_BMS\XML Project\Tool Files\SaxonHE9-6-0-5J"

ECHO.

ECHO Choose one of the following options:
ECHO [1] Process batch XML file (with data for multiple records)
ECHO [2] Process single XML file (with data for one record)
ECHO [3] Process multiple XML files (each with data for one record)

ECHO.

ECHO Enter your choice:
SET /P userChoice=

ECHO.

IF "%userChoice%"=="1" GOTO FIRST
IF "%userChoice%"=="2" GOTO SECOND
IF "%userChoice%"=="3" GOTO SECOND
ECHO Wrong Input. & GOTO START
:FIRST

	ECHO Enter the full address of the batch XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.

	SET xsltPath1="I:\SC_BMS\XML Project\XSLT Files\EAD\xmlsplitter.xsl"
	SET xsltPath2="I:\SC_BMS\XML Project\XSLT Files\EAD\PastPerfectToEAD_Batch.xsl"
	
	ECHO Enter the full address of the output folder for the split XML files:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath2% -o:%outputPath%\BatchEADXML.xml

	java -jar %saxon%\saxon9he.jar -s:%outputPath%\BatchEADXML.xml -xsl:%xsltPath1% -o:%outputPath%\output.xml
	
	cd /d %outputPath%
	del "BatchEADXML.xml" 	

	GOTO END

:SECOND

	ECHO Enter the full address of the source XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.
	
	SET xsltPath="I:\SC_BMS\XML Project\XSLT Files\EAD\PastPerfectToEAD.xsl"

	ECHO Enter the full address for the output file. Include folder name, file name, and the extension .xml:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath% -o:%outputPath%


	GOTO END
:THIRD

	ECHO Enter the full address of the folder containing the source XML files:
	SET /P ppxmlPath=

	ECHO.
	
	SET xsltPath="I:\SC_BMS\XML Project\XSLT Files\EAD\PastPerfectToEAD.xsl"

	ECHO Enter the full address of the folder that will contain the output files:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:"%xsltPath%" -o:%outputPath%


	GOTO END

:END

ECHO.
ECHO Enter "a" to run program again, or "q" to quit.
SET /P option=

IF "%option%"=="a" (
	GOTO START
)

IF "%option%"=="q" (
	QUIT
)
