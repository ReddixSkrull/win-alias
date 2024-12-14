@echo off
set currentpath=%cd%
echo Die Aliase liegen unter %currentpath%
echo %currentpath% wird jetzt zu PATH hinzugefuegt
set /p "Zustimmung=Sind sie einverstanden? [Y/N]: "
IF "%Zustimmung%" == "Y"  (
    set PATH=%PATH%;%currentpath%
    echo PATH gesetzt
) ELSE (
    echo PATH nicht gesetzt
)