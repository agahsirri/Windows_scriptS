@ECHO off
CLS
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
ECHO           ^|__________________________________________________________________________^|
ECHO .
ECHO [Press CTRL + C for an interrupt the process]
TimeOut 10
ECHO .
COLOR 0A

set PATH_PROGRAMS=\\172.2.2.4\Software\ProgramS\AGI
set PATH_LOGS=\\172.2.2.4\Software\ProgramS\_LogS
set PROCESS=\\172.2.2.4\Software\ProgramS\_ScriptS

REM pushd %_CUR_PATH%

:PROCESSSTART
IF NOT EXIST "%ProgramFiles(x86)%\Reference Assemblies\Microsoft\Framework\v3.5\Microsoft.Build.Framework.dll" "%PATH_PROGRAMS%\STK10.1.3_Download_Install\Prerequirements\Microsoft\Framework.net\v3.5.30729.1\dotnetfx35setup.exe" /qb /norestart && ECHO %ComputerName% ; AGI_dotnetfx35 ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_dotnetfx35 ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
IF NOT EXIST "%WinDir%\SysWOW64\msxml6.dll" "%PATH_PROGRAMS%\STK10.1.3_Download_Install\Prerequirements\Microsoft\msxml6\v6.0.0.0\msxml6_x64.msi" /passive && ECHO %ComputerName% ; AGI_msxml6 ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_msxml6 ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
"%PATH_PROGRAMS%\STK10.1.3_Download_Install\Prerequirements\Microsoft\Rootsupd\v6.0.2600.0\rootsupd.exe" /Q
IF NOT EXIST "%ProgramFiles%\Common Files\microsoft shared\VC\msdia90.dll" "%PATH_PROGRAMS%\STK10.1.3_Download_Install\Prerequirements\Microsoft\VCRedist\v2008\X64\vcredist_x64.exe" /q && ECHO %ComputerName% ; AGI_vcredist_x64 ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_vcredist_x64 ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
IF NOT EXIST "%ProgramFiles(x86)%\Common Files\microsoft shared\VC\msdia90.dll" "%PATH_PROGRAMS%\STK10.1.3_Download_Install\Prerequirements\Microsoft\VCRedist\v2008\vcredist_x86.exe" /q && ECHO %ComputerName% ; AGI_vcredist_x86 ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_vcredist_x86 ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
IF NOT EXIST "%ProgramFiles(x86)%\Microsoft.NET\Primary Interop Assemblies\msdatasrc.dll" "%PATH_PROGRAMS%\STK10.1.3_Download_Install\Prerequirements\Microsoft\VSRedist\PIA\9.0.21022\vs90_piaredist.exe" /q && ECHO %ComputerName% ; AGI_vs90piaredist ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_vs90piaredist ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
IF NOT EXIST "%ProgramFiles(x86)%\AGI\LicenseManager\bin\AgLicenseManager.exe" "%WinDir%\System32\msiexec.exe" /i "%PATH_PROGRAMS%\STK10.1.3_Download_Install\STK_License_Manager\v3.0.11\STK License Manager.msi" /qn
IF EXIST "%ProgramFiles(x86)%\AGI\LicenseManager\bin\AgLicenseManager.exe" (ECHO %ComputerName% ; AGI_LicenseManager ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log") ELSE (ECHO %ComputerName% ; AGI_LicenseManager ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log")
IF NOT EXIST "%ProgramFiles(x86)%\AGI\STK Parallel Computing 10\bin\AGI.Parallel.Host.exe" "%WinDir%\System32\msiexec.exe" /i "%PATH_PROGRAMS%\STK10.1.3_Download_Install\STK_Parallel_Computing\v10.0.2\STK Parallel Computing 10.msi"
IF EXIST "%ProgramFiles(x86)%\AGI\STK Parallel Computing 10\bin\AGI.Parallel.Host.exe" (ECHO %ComputerName% ; AGI_Parallel ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log") ELSE (ECHO %ComputerName% ; AGI_Parallel ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log")
IF NOT EXIST "%ProgramFiles(x86)%\AGI\STK 10\bin\AgUiApplication.exe" "%WinDir%\System32\msiexec.exe" /i "%PATH_PROGRAMS%\STK10.1.3_Download_Install\STK\STK 10.msi" /qn
IF EXIST "%ProgramFiles(x86)%\AGI\STK 10\bin\AgUiApplication.exe" (ECHO %ComputerName% ; AGI_STK ; install ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log") ELSE (ECHO %ComputerName% ; AGI_STK ; install ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log")
XCOPY /S /Y /I "%PATH_PROGRAMS%\client_B88584A300F6.lic" "%ProgramData%\AGI\LicenseData\" && ECHO %ComputerName% ; AGI_License ; Copied ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_License ; Copied ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
NETSH firewall add allowedprogram "%ProgramFiles(x86)%\AGI\STK 10\bin\AgUiApplication.exe" AGIuiApp ENABLE  && ECHO %ComputerName% ; AGI_Firewall ; Exception ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_Firewall ; Exception ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"
REM "%WinDir%\Regedit.exe" /s "%PROCESS%\_install_AGI.reg" && ECHO %ComputerName% ; AGI_STK_Reg ; Register ; OK ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log" || ECHO %ComputerName% ; AGI_STK_Reg ; Register ; FAIL ; %date% ; %time% >> "%PATH_LOGS%\%~n0.log"

REM popd
