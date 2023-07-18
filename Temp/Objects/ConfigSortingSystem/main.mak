SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files (x86)\Common Files\Oracle\Java\javapath;C:\Program Files\Common Files\Oracle\Java\javapath;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files\Azure Data Studio\bin;C:\Program Files\Polyspace\R2019b\runtime\win64;C:\Program Files\Polyspace\R2019b\bin;C:\Program Files\Microsoft SQL Server\120\Tools\Binn\;C:\Program Files (x86)\IVI Foundation\IVI\bin;C:\Program Files\IVI Foundation\IVI\bin;C:\Program Files (x86)\IVI Foundation\VISA\WinNT\Bin\;C:\Program Files\IVI Foundation\VISA\Win64\Bin\;C:\Program Files (x86)\IVI Foundation\VISA\WinNT\Bin;C:\Program Files (x86)\dotnet\;C:\Program Files\dotnet\;C:\Program Files\Git\cmd;C:\Users\ninab\AppData\Local\Programs\Python\Python310\Scripts\;C:\Users\ninab\AppData\Local\Programs\Python\Python310\;C:\Users\ninab\AppData\Local\Microsoft\WindowsApps;C:\Program Files\Azure Data Studio\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\ninab\AppData\Local\Programs\Python\Python310\Scripts\;C:\Users\ninab\AppData\Local\Programs\Python\Python310\;C:\Users\ninab\AppData\Local\Microsoft\WindowsApps;C:\Program Files\Azure Data Studio\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\BRAutomation\AS412\bin-en\4.12;C:\BRAutomation\AS412\bin-en\4.11;C:\BRAutomation\AS412\bin-en\4.10;C:\BRAutomation\AS412\bin-en\4.9;C:\BRAutomation\AS412\bin-en\4.8;C:\BRAutomation\AS412\bin-en\4.7;C:\BRAutomation\AS412\bin-en\4.6;C:\BRAutomation\AS412\bin-en\4.5;C:\BRAutomation\AS412\bin-en\4.4;C:\BRAutomation\AS412\bin-en\4.3;C:\BRAutomation\AS412\bin-en\4.2;C:\BRAutomation\AS412\bin-en\4.1;C:\BRAutomation\AS412\bin-en\4.0;C:\BRAutomation\AS412\bin-en
export AS_BUILD_MODE := BuildAndTransfer
export AS_VERSION := 4.12.4.107 SP
export AS_WORKINGVERSION := 4.12
export AS_COMPANY_NAME :=  
export AS_USER_NAME := ninab
export AS_PATH := C:/BRAutomation/AS412
export AS_BIN_PATH := C:/BRAutomation/AS412/bin-en
export AS_PROJECT_PATH := C:/Users/ninab/Desktop/automation\ studio/SorterBR_backup
export AS_PROJECT_NAME := GroupProjectBR
export AS_SYSTEM_PATH := C:/BRAutomation/AS/System
export AS_VC_PATH := C:/BRAutomation/AS412/AS/VC
export AS_TEMP_PATH := C:/Users/ninab/Desktop/automation\ studio/SorterBR_backup/Temp
export AS_CONFIGURATION := ConfigSortingSystem
export AS_BINARIES_PATH := C:/Users/ninab/Desktop/automation\ studio/SorterBR_backup/Binaries
export AS_GNU_INST_PATH := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/BRAutomation/AS412
export WIN32_AS_PATH := "C:\BRAutomation\AS412"
export WIN32_AS_BIN_PATH := "C:\BRAutomation\AS412\bin-en"
export WIN32_AS_PROJECT_PATH := "C:\Users\ninab\Desktop\automation studio\SorterBR_backup"
export WIN32_AS_SYSTEM_PATH := "C:\BRAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\BRAutomation\AS412\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\Users\ninab\Desktop\automation studio\SorterBR_backup\Temp"
export WIN32_AS_BINARIES_PATH := "C:\Users\ninab\Desktop\automation studio\SorterBR_backup\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\BRAutomation\AS412\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "C:\BRAutomation\AS412\AS\GnuInst\V4.1.2\bin"
export WIN32_AS_INSTALL_PATH := "C:\BRAutomation\AS412"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/GroupProjectBR.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndTransfer'   

