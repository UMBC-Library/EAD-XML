@ECHO OFF
ECHO Welcome to the PastPerfect XML to EAD/MARC Transformation Tool
ECHO *********************************************************************
ECHO.

ECHO ---------------------------------------------------------------------
ECHO Note: Please use this tool with an error-free stylesheet ^(.xsl file ^)
ECHO ---------------------------------------------------------------------
:START
ECHO.

ECHO.

ECHO Are you processing files locally (from the SC-BMS folder)?:

ECHO [1] Yes; automate the processing with hardcoded locations.
ECHO [2] No; allow me to manually enter locations.

ECHO.
SETLOCAL
ECHO Enter your choice:
SET /P userChoice=

ECHO.

IF "%userChoice%"=="1" (
	SET saxon="I:\SC_BMS\XML Project\Tool Files\SaxonHE9-6-0-5J"
	
	ECHO Choose one of the following options:
	
	ECHO [1] Process one PastPerfect XML file into EAD-XML ^(single or batch^)
	ECHO [2] Process multiple PastPerfect XML files into EAD-XML ^(single or batch^)
	ECHO [3] Process one XML file into MARC-XML ^(single or batch^)
	:TRYAGAIN1	
	ECHO.

	ECHO Enter your choice:
	SET /P userChoice2=
	ECHO.
	GOTO IF2
	
) ELSE IF "%userChoice%"=="2" (
	ECHO Enter the main directory of the Saxon processor ^(place in quotation marks, 
	ECHO ex. "I:\SC_BMS\XML Project\Tool Files\SaxonHE9-6-0-5J"^):
	SET /P saxon=
	
	ECHO.	

	ECHO Choose one of the following options:
	
	ECHO [1] Process one PastPerfect XML file into EAD-XML ^(single or batch^)
	ECHO [2] Process multiple PastPerfect XML files into EAD-XML ^(single or batch^)
	ECHO [3] Process one XML file into MARC-XML ^(single or batch^)
	:TRYAGAIN2	
	ECHO.

	ECHO Enter your choice:
	SET /P userChoice2=

	ECHO.
	GOTO IF3
	
) ELSE (
	ECHO Wrong Input. & GOTO START 
)

:IF2
	IF "%userChoice2%"=="1" (
		GOTO FIRST
	) ELSE IF "%userChoice2%"=="2" (
		GOTO SECOND
	) ELSE IF "%userChoice2%"=="3" (
		GOTO THIRD
	) ELSE ECHO Wrong Input. & GOTO TRYAGAIN1
	)

:IF3
	IF "%userChoice2%"=="1" (
		GOTO FOURTH
	) ELSE IF "%userChoice2%"=="2" (
		GOTO FIFTH
	) ELSE IF "%userChoice2%"=="3" (
		GOTO SIXTH
	) ELSE ECHO Wrong Input. & GOTO TRYAGAIN2
	)
	
:FIRST

	ECHO Enter the full address of the PastPerfect XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.

	SET xsltPath1="I:\SC_BMS\XML Project\XSLT Files\EAD\xmlsplitter.xsl"
	SET xsltPath2="I:\SC_BMS\XML Project\XSLT Files\EAD\PastPerfectToEAD.xsl"
	
	ECHO Enter the full address of the folder that will store resulting EAD-XML file(s):
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath2% -o:%outputPath%\BatchEADXML.xml

	java -jar %saxon%\saxon9he.jar -s:%outputPath%\BatchEADXML.xml -xsl:%xsltPath1% -o:%outputPath%\output.xml
	
	cd /d %outputPath%
	del "BatchEADXML.xml" 	

	GOTO END

:SECOND

	ECHO Enter the full address of the folder containing the PastPerfect XML files:
	SET /P ppxmlPath=

	ECHO.
	
	SET xsltPath1="I:\SC_BMS\XML Project\XSLT Files\EAD\xmlsplitter.xsl"
	SET xsltPath2="I:\SC_BMS\XML Project\XSLT Files\EAD\PastPerfectToEAD.xsl"

	ECHO Enter the full address of the folder that will store resulting EAD-XML files:
	SET /P outputPath=

	mkdir %outputPath%\split_files

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath2% -o:%outputPath%\split_files

	java -jar %saxon%\saxon9he.jar -s:%outputPath%\split_files -xsl:%xsltPath1% -o:%outputPath%
	
	cd /d %outputPath%
	rmdir /s /q "split_files" 

	GOTO END
	
:THIRD

	ECHO Enter the full address of the PastPerfect XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.

	SET xsltPath="I:\SC_BMS\XML Project\XSLT Files\MARC\PastPerfectToMARC.xsl"
		
	ECHO Enter an address for the resulting MARC-XML file.
	ECHO Include the desired file name and .xml extension:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath% -o:%outputPath%
	
	GOTO END

:FOURTH

	ECHO Enter the full address of the PastPerfect XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.

	ECHO Enter the full address of the splitter template file ^(place in quotation marks, include the .xsl^):
	SET /P xsltPath1=

	ECHO.

	ECHO Enter the full address of the EAD template file ^(place in quotation marks, include the .xsl^):
	SET /P xsltPath2=

	ECHO.
	
	ECHO Enter the full address of the folder that will store resulting EAD-XML file(s):
	SET /P outputPath=

	ECHO.

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath2% -o:%outputPath%\BatchEADXML.xml
	
	java -jar %saxon%\saxon9he.jar -s:%outputPath%\BatchEADXML.xml -xsl:%xsltPath1% -o:%outputPath%\output.xml

	cd /d %outputPath%
	del "BatchEADXML.xml" 		

	GOTO END

:FIFTH

	ECHO Enter the full address of the folder containing the PastPerfect XML files:
	SET /P ppxmlPath=


	ECHO.

	ECHO Enter the full address of the splitter template file ^(place in quotation marks, include the .xsl^):
	SET /P xsltPath1=

	ECHO.

	ECHO Enter the full address of the EAD template file ^(place in quotation marks, include the .xsl^):
	SET /P xsltPath2=

	ECHO.
	
	ECHO Enter the full address of the folder where you'd like to store the resulting EAD-XML files:
	SET /P outputPath=

	mkdir %outputPath%\split_files

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath2% -o:%outputPath%\split_files

	java -jar %saxon%\saxon9he.jar -s:%outputPath%\split_files -xsl:%xsltPath1% -o:%outputPath%
	
	cd /d %outputPath%
	rmdir /s /q "split_files" 

	GOTO END
	
:SIXTH

	ECHO Enter the full address of the PastPerfect XML file ^(include the .xml^):
	SET /P ppxmlPath=

	ECHO.

	ECHO Enter the full address of the template file ^(include the .xsl^):
	SET /P xsltPath=

	ECHO.
		
	ECHO Enter an address for the resulting MARC-XML file.
	ECHO Include the desired file name and .xml extension:
	SET /P outputPath=

	java -jar %saxon%\saxon9he.jar -s:%ppxmlPath% -xsl:%xsltPath% -o:%outputPath%
	
	GOTO END

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
