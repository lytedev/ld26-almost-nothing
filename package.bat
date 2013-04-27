del almost-nothing.exe
del almost-nothing.zip
del almost-nothing.love
7z a almost-nothing.love ./
cp C:\Users\Public\Applications\Love2d\love.exe ./love.exe
:: copy /b love.exe+almost-nothing.love almost-nothing.exe
:: 7z a almost-nothing.zip almost-nothing.exe
echo love.exe almost-nothing.love >> play.bat
7z a almost-nothing.zip play.bat
7z a almost-nothing.zip love.exe
7z a almost-nothing.zip almost-nothing.love
7z a almost-nothing.zip C:\Users\Public\Applications\Love2d\DevIL.dll
7z a almost-nothing.zip C:\Users\Public\Applications\Love2d\OpenAL32.dll
7z a almost-nothing.zip C:\Users\Public\Applications\Love2d\SDL.dll
del love.exe
del play.bat
