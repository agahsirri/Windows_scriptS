@ECHO off
REM CLS
COLOR 0C
ECHO            ________________________LEGAL DISCLAIMER AND NOTICES_______________________
ECHO           ^|                                                                          ^|
ECHO           ^|THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR^|
ECHO           ^| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, ^|
ECHO           ^| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  ^|
ECHO           ^|THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER^|
ECHO           ^| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  ^|
ECHO           ^|   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER    ^|
ECHO           ^|                     DEALINGS IN THE SOFTWARE.                            ^|
ECHO           ^|                                                                          ^|
ECHO           ^|               This code(s) is developed by Agah Sirri,                   ^|
ECHO           ^|         AgahSirri@hotmail.com / https://linkedin.com/in/agahsirri        ^|
ECHO           ^|                                 https://github.com/agahsirri             ^|
ECHO           ^|                                                                          ^|
ECHO           ^|     This script file contributes to being running multiple programs      ^|
ECHO           ^| on multiple computers bulkily via PsExec.exe. You can create a text file ^|
ECHO           ^| that the same file name as this script file and you input wish to run the^|
ECHO           ^| program(s) on to which computer(s). It should be entered each computer's ^|
ECHO           ^|   hostname in one row. You should download PsTools.exe at the below link ^|
ECHO           ^| and unzip the PsExec.exe file into the same folder with this script file;^|
ECHO           ^|      https://docs.microsoft.com/en-us/sysinternals/downloads/psexec      ^|
ECHO           ^|__________________________________________________________________________^|
ECHO .
ECHO [Press CTRL + C for an interrupt the process]
TimeOut 10
ECHO .
COLOR 0A

SET PATH_MAIN=%~dp0
IF NOT EXIST "%PATH_MAIN%\psexec.exe" (
	ECHO Process.exe not exist, and it is starting to download. Please wait...
	SET ExtractTo="%tmp%\PSTools"
	SET newzipfile="%tmp%\PSTools\PSTools.zip"
	SET PATH_CURRENT=%CD%
	ECHO "%ExtractTo%"
	ECHO "%newzipfile%"
	IF NOT EXIST "%ExtractTo%" MKDIR "%ExtractTo%"
	CD /D "%ExtractTo%"
	curl http://download.sysinternals.com/files/PSTools.zip -O PSTools.zip
	IF EXIST "%newzipfile%" ( 
		SET vbs="%tmp%\_.vbs"
		IF EXIST %vbs% DEL /F /Q %vbs%
		ECHO>%vbs% ^Set fso ^= CreateObject^("Scripting.FileSystemObject"^)
		ECHO>>%vbs% If NOT fso.FolderExists^(%ExtractTo%^) Then
		ECHO>>%vbs% fso.CreateFolder^(%ExtractTo%^)
		ECHO>>%vbs% End If
		ECHO>>%vbs% ^set objShell = CreateObject^("Shell.Application"^)
		ECHO>>%vbs% ^set FilesInZip = objShell.NameSpace^(%newzipfile%^).items
		ECHO>>%vbs% objShell.NameSpace^(%ExtractTo%^).CopyHere^(FilesInZip^)
		ECHO>>%vbs% ^Set fso = Nothing
		ECHO>>%vbs% ^Set objShell = Nothing
		cscript //nologo %vbs%
		IF EXIST %vbs% DEL /F /Q %vbs%
		IF EXIST "%ExtractTo%\PsExec.exe" COPY /Y "%ExtractTo%\PsExec.exe" "%PATH_MAIN%"
		If %errorlevel% NEQ 0 (
			ECHO "Copy Process occurs error while copy process: %newzipfile% -> %PATH_MAIN%; ErrorCode:%errorlevel%"
			ECHO "You can get the PsExec.exe file where extracted path: %newzipfile%, and copy to %PATH_MAIN%; ErrorCode:%errorlevel%"
		)
		If %errorlevel% EQU 0 (
			ECHO "Copy Process is complated: %newzipfile% -> %PATH_MAIN%; ErrorCode:%errorlevel%"
			IF EXIST %ExtractTo% RMDIR /S /Q %ExtractTo%
		)
REM		IF EXIST "%PATH_MAIN%\psexec.exe" MOVE /Y "%PATH_MAIN%\psexec.exe" "%PATH_MAIN%\Process.exe" && ECHO "Rename Process is complated" || ECHO "Rename Process occurs error"
		CD %PATH_CURRENT%
	)
)

:RestartMenu
MODE CON COLS=108
COLOR 0A
SET PATH_MAIN=%~dp0
SET "InputValue="
SET "FilenameColumn="
SET FillEmpty=
SET "filename="
SET /A mod=0
REM SET PATH_MAIN=\\172.2.5.1\Software\ProgramS\_ScriptS
REM SET PATH_MAIN=\\%~p0_
SET "USRNAME="
SET "PASSW="
SET /A IndexElement=0
SET /A IndexInput=0
SET /A ID=1

SETLOCAL enableDelayedExpansion

FOR /f "delims=" %%G in ('dir "%PATH_MAIN%\*.bat" /b') do (
	IF %%G NEQ %~nx0 (
		SET _result1=%%G
		SET _result2=
		SET _result3=
		FOR /L %%D IN (0,1,20) DO (
			SET _result2=!_result1:~%%D,1!
			SET _result3=!_result3!!_result2!
			IF NOT DEFINED _result2 (SET _result3=!_result3! )
		)
		IF NOT DEFINED _result2 (SET _result3=!_result3!  ) ELSE (SET _result3=!_result3!..)
REM		SET _result3=!_result3!..
		IF !ID! LSS 10 (
			SET FilenameColumn=!FilenameColumn!  !ID!:!_result3!
		) ELSE (
			IF !ID! LSS 100 (
				SET FilenameColumn=!FilenameColumn! !ID!:!_result3!
			) ELSE (
				SET FilenameColumn=!FilenameColumn!!ID!:!_result3!
			)
		)
		SET filename[!ID!]=%%~G
		SET /A ID+=1
	)
)

ECHO !FilenameColumn!

SET /P InputValue=__________________________________Please Enter your choice...? [0 FOR EXIT]_________________________________:
FOR %%A IN (%InputValue%) DO (
	SET /A IndexInput+=1
	FOR /L %%B IN (1,1,%ID%-1) DO (
		IF %%B==%%A (
			SET /A IndexElement+=1
			SET InputValueS[!IndexElement!].Prefix=!filename[%%B]!
			SET InputValueS[!IndexElement!].Suffix=""
		) ELSE (
			IF %%Bu==%%A (
				SET /A IndexElement+=1
				SET InputValueS[!IndexElement!].Prefix=!filename[%%B]!
				SET InputValueS[!IndexElement!].Suffix=u
			)
		)
	)
)

IF [!InputValue!] EQU [] GOTO :RestartMenu
IF !InputValue! EQU 0 GOTO :END
IF %IndexElement% LSS %IndexInput% ECHO You have entered invalid option(s). Please check and re-enter valid element^(s^) from the list...: & TimeOut 10 & GOTO :RestartMenu

SET /P USRNAME="Please enter an username who should member of Administrators Group on your domain (DOMAIN\USER): "

	:HInput
	@Echo Off  
	SetLocal DisableDelayedExpansion
	Echo Please enter password of %USRNAME% :
	Set "PASSW="
	For /F %%# In ('"Prompt;$H&For %%# in (1) Do Rem"') Do Set "BS=%%#"

	:HILoop
	Set "Key="
	For /F "delims=" %%# In ('Xcopy /W "%~f0" "%~f0" 2^>Nul') Do If Not Defined Key Set "Key=%%#"
	Set "Key=%Key:~-1%"
	SetLocal EnableDelayedExpansion
	If Not Defined Key Goto :HIEnd
	If %BS%==^%Key% (
		Set /P "=%BS% %BS%" <Nul
		Set "Key="
		If Defined PASSW Set "PASSW=!PASSW:~0,-1!"
		) Else Set /P "=*" <Nul
	If Not Defined PASSW (EndLocal &Set "PASSW=%Key%") Else For /F delims^=^ eol^= %%# In ("!PASSW!") Do EndLocal &Set "PASSW=%%#%Key%"
	Goto :HILoop
	:HIEnd

REM @ECHO ON
FOR /L %%C IN (1,1,%IndexElement%) DO (
	ECHO:
	ECHO Just a moment please; the process is starting on...:
	ECHO:
	IF NOT EXIST "%PATH_MAIN%%~n0.txt" ((ECHO There was no "" file for getting computer list, and it created for just %ComputerName%) & (ECHO %%ComputerName%% > "%PATH_MAIN%%~n0.txt"))
	"%PATH_MAIN%PsExec.exe" -nobanner -accepteula -h @"%PATH_MAIN%%~n0.txt" -u %USRNAME% -p "!PASSW!" /c /f "%PATH_MAIN%!InputValueS[%%C].Prefix!" u && ((ECHO The process completed successfully! & COLOR 0A) & (ECHO %ComputerName% ; %PATH_MAIN%!InputValueS[%%C].Prefix! !InputValueS[%%C].Suffix! ; %PATH_MAIN%%~n0.txt /u %USRNAME% ; OK ; %date% ; %time% >> "%PATH_MAIN%%~n0.log")) || ((ECHO It occured a problem...! & COLOR 0C) &  (ECHO %ComputerName% ; %PATH_MAIN%!InputValueS[%%C].Prefix! !InputValueS[%%C].Suffix!; %PATH_MAIN%%~n0.txt /u %USRNAME% ; FAIL ; %date% ; %time% >> "%PATH_MAIN%%~n0.log"))
REM	%PATH_MAIN%PsExec.exe -nobanner -accepteula -h @"%PATH_MAIN%%~n0.txt" -u %USRNAME% -p "!PASSW!" /c /f "%PATH_MAIN%!InputValueS[%%C].Prefix!" !InputValueS[%%C].Suffix! && ((ECHO The process completed successfully! & COLOR 0A) & (ECHO %ComputerName% ; %PATH_MAIN%!InputValueS[%%C].Prefix! !InputValueS[%%C].Suffix! ; %PATH_MAIN%%~n0.txt /u %USRNAME% ; OK ; %date% ; %time% >> "%PATH_MAIN%%~n0.log")) || ((ECHO It occured a problem...! & COLOR 0C) &  (ECHO %ComputerName% ; %PATH_MAIN%!InputValueS[%%C].Prefix! !InputValueS[%%C].Suffix!; %PATH_MAIN%%~n0.txt /u %USRNAME% ; FAIL ; %date% ; %time% >> "%PATH_MAIN%%~n0.log"))
)

ECHO It has complated %IndexElement% / %IndexInput% process successfully.
PAUSE
ENDLOCAL
GOTO :RestartMenu

:END
COLOR 07
ENDLOCAL
REM CLS
EXIT /B