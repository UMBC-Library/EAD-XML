@ECHO OFF
ECHO Welcome to the EAD-XML to HTML Batch Transformation Tool
ECHO *********************************************************************
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
ECHO [1] Process single EAD-XML file (with data for one record)
ECHO [2] Process multiple EAD-XML files (each with data for one record)

ECHO.
SETLOCAL
ECHO Enter your choice:
SET /P userChoice=

ECHO.

IF "%userChoice%"=="1" (
	GOTO FIRST
)

IF "%userChoice%"=="2" (
	GOTO SECOND
)


:FIRST

	ECHO Enter the full address of the EAD-XML file ^(include the .xml^):
	SET /P eadPath=

	ECHO.

	SET xsltPath="I:\SC_BMS\XML Project\XSLT Files\EAD\XMLtoHTML.xsl"
	
	ECHO Enter the full address of the folder that will contain the output file:
	SET /P outputPath=

	CALL :setfile %eadPath%
	:setfile
	SET "file=%~n1"
	
	java -jar %saxon%\saxon9he.jar -s:%eadPath% -xsl:%xsltPath% -o:%outputPath%\%file%.html
	
	GOTO END

:SECOND

	ECHO Enter the full address of the folder containing the source EAD-XML files:
	SET /P eadPath=

	ECHO.
	
	SET xsltPath="I:\SC_BMS\XML Project\XSLT Files\EAD\XMLtoHTML.xsl"

	ECHO Enter the full address of the folder that will contain the output files:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%eadPath% -xsl:%xsltPath% -o:%outputPath%

	GOTO END

ECHO Wrong Input. Please run the program again.
:END
ENDLOCAL
ECHO.
ECHO Enter "a" to run program again, or "q" to quit.
SET /P option=

IF "%option%"=="a" (
	GOTO START
)

IF "%option%"=="q" (
	QUIT
)
