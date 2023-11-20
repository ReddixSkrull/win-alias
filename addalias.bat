@echo off
set /p "Name=Enter Name:"
set Pfad=C:\Users\janni\Documents\aliases\
set /p "Text=Enter Command:"
set e=@echo off

echo %e%> %Pfad%%Name%.bat 
echo %Text%>> %Pfad%%Name%.bat
