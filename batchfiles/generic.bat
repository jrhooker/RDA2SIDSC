# set PATHTOPROJECT=\Source -- set this to the directory location of the starting input file (the RDA pub file). Leading backslash, no trailing backslash.
set PATHTOPROJECT=%1
# set OUTPUTPATH=\out -- set this to the final output directory desired. Leading backslash, no trailing backslash. 
set OUTPUTPATH=%2
# set INPUTFILENAME=pm20_82_510_int_pub.xml -- set this to the name of the RDA file to be created.
set INPUTFILENAME=%3
# set FILENAME=TEST.ditamap -- set this to the name of the output ditamap you want.
set FILENAME=%4

cd ..\

set WORKINGDIR=%CD%

cd %WORKINGDIR%\batchfiles

rd /s /q %WORKINGDIR%\fout\

mkdir %WORKINGDIR%\fout\

rd /s /q %WORKINGDIR%\out\

mkdir %WORKINGDIR%\out\

rd /s /q %WORKINGDIR%\in\

mkdir %WORKINGDIR%\in\


java -jar %WORKINGDIR%\depend\tools\saxon\saxon9.jar  -o:%WORKINGDIR%\in\index1.xml %WORKINGDIR%%PATHTOPROJECT%\%INPUTFILENAME% %WORKINGDIR%\depend\custom\normalize-space.xsl

java -jar %WORKINGDIR%\depend\tools\saxon\saxon9.jar  -o:%WORKINGDIR%\in\index2.xml %WORKINGDIR%\in\index1.xml %WORKINGDIR%\depend\custom\generate_rda_ids.xsl

java -jar %WORKINGDIR%\depend\tools\saxon\saxon9.jar  -o:%WORKINGDIR%\in\index3.xml %WORKINGDIR%\in\index2.xml %WORKINGDIR%\depend\custom\rda_remove_dup_ids.xsl

java -jar %WORKINGDIR%\depend\tools\saxon\saxon9.jar  -o:%WORKINGDIR%\fout\%FILENAME% %WORKINGDIR%\in\index3.xml %WORKINGDIR%\depend\custom\generate_bookmap.xsl

java -jar %WORKINGDIR%\depend\tools\saxon\saxon9.jar  -o:%WORKINGDIR%\fout\discard.xml %WORKINGDIR%\in\index3.xml %WORKINGDIR%\depend\custom\RDA2DITA.xsl

copy %WORKINGDIR%\fout\%FILENAME% %WORKINGDIR%\out\%FILENAME%

xcopy %WORKINGDIR%\fout\* %WORKINGDIR%\in /S /Y

java -cp %WORKINGDIR%/depend/tools/saxon9/saxon9he.jar;%WORKINGDIR%\depend\tools\Saxon9\xml-commons-resolver-1.2\resolver.jar ^
-Dxml.catalog.files=..\depend\tools\Saxon9\RWS-DTD\catalog.xml ^
net.sf.saxon.Transform ^
-r:org.apache.xml.resolver.tools.CatalogResolver ^
-x:org.apache.xml.resolver.tools.ResolvingXMLReader ^
-y:org.apache.xml.resolver.tools.ResolvingXMLReader ^
-o:%WORKINGDIR%\in\test.xml ^
-s:%WORKINGDIR%\in\%FILENAME% ^
-xsl:%WORKINGDIR%\depend\custom\generate_register_topics.xsl ^
STARTING-DIR="%WORKINGDIR%/in/" OUTPUT-DIR="%WORKINGDIR%%OUTPUTPATH%/" FILENAME="%FILENAME%" 

java -cp %WORKINGDIR%/depend/tools/saxon9/saxon9he.jar;%WORKINGDIR%\depend\tools\Saxon9\xml-commons-resolver-1.2\resolver.jar ^
-Dxml.catalog.files=..\depend\tools\Saxon9\RWS-DTD\catalog.xml ^
net.sf.saxon.Transform ^
-r:org.apache.xml.resolver.tools.CatalogResolver ^
-x:org.apache.xml.resolver.tools.ResolvingXMLReader ^
-y:org.apache.xml.resolver.tools.ResolvingXMLReader ^
-o:%WORKINGDIR%\in\test.xml ^
-s:%WORKINGDIR%\in\%FILENAME% ^
-xsl:%WORKINGDIR%\depend\custom\copy_topics.xsl ^
STARTING-DIR="%WORKINGDIR%/in/" OUTPUT-DIR="%WORKINGDIR%%OUTPUTPATH%/" FILENAME="%FILENAME%" 

cd %WORKINGDIR%\batchfiles
