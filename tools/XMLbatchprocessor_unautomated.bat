@ECHO OFF
ECHO Welcome to the PastPerfect XML to EAD/MARC Batch Transformation Tool
ECHO *********************************************************************
ECHO.

ECHO ---------------------------------------------------------------------
ECHO Note: Please use this tool with error-free stylesheets ^(.xsl file ^)
ECHO ---------------------------------------------------------------------
:START
ECHO.

ECHO Enter the main directory of the Saxon processor ^(place in quotation marks, 
ECHO ex. "I:\SC_BMS\XML Project\Tool Files\SaxonHE9-6-0-5J"^):
SET /P saxon=

ECHO.

ECHO Choose one of the following options:
ECHO [1] Process batch XML file (with data for multiple records)
ECHO [2] Process single XML file (with data for one record)
ECHO [3] Process multiple XML files (each with data for one record)

ECHO.

ECHO Enter your choice:
SET /P userChoice=

ECHO.

IF "%userChoice%"=="1" (
	GOTO FIRST
)

IF "%userChoice%"=="2" (
	GOTO SECOND
)

IF "%userChoice%"=="3" (
	GOTO SECOND
)


:FIRST

	ECHO Enter the full address of the batch XML file ^(place in quotation marks, include the .xml^):
	SET /P ppxmlPath=

	ECHO.

	ECHO Enter the full address of the splitter template file ^(place in quotation marks, include the .xsl^):
	SET /P xsltPath1=

	ECHO.

	ECHO Enter the full address of the EAD template file ^(place in quotation marks, include the .xsl^):
	SET /P xsltPath2=

	ECHO.
	
	ECHO Enter the full address of the output folder for the split XML files (place in quotation marks,):
	SET /P outputPath=

	ECHO.

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath2% -o:%outputPath%\BatchEADXML.xml
	
	java -jar %saxon%\saxon9he.jar -s:%outputPath%\BatchEADXML.xml -xsl:%xsltPath1% -o:%outputPath%\output.xml

	cd /d %outputPath%
	del "BatchEADXML.xml" 		

	GOTO END

:SECOND

	ECHO Enter the full address of the source XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.
	
	ECHO Enter the full address of the template file ^(include the .xsl^):
	SET /P xsltPath=

	ECHO.

	ECHO Enter the full address for the output file. Include folder name, file name, and the extension .xml:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath% -o:%outputPath%


	GOTO END
:THIRD

	ECHO Enter the full address of the folder containing the source XML files:
	SET /P ppxmlPath=

	ECHO.
	
	ECHO Enter the full address of the template file ^(include the .xsl^):
	SET /P xsltPath=

	ECHO.

	ECHO Enter the full address of the folder that will contain the output files:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:"%xsltPath%" -o:%outputPath%


	GOTO END

ECHO Wrong Input. Please run the program again.
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
