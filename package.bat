del almost-nothing.exe
del almost-nothing.zip
del almost-nothing.love
mv ./.git ../ld26.git
7z a almost-nothing.love ./
cp C:\Users\Public\Applications\Love2d\love.exe ./love.exe
:: copy /b love.exe+almost-nothing.love almost-nothing.exe
:: 7z a almost-nothing.zip almost-nothing.exe
echo love.exe almost-nothing.love >> play.bat
mkdir almost-nothing
cp almost-nothing.love almost-nothing/almost-nothing.love
cp play.bat almost-nothing/play.bat
cp love.exe almost-nothing/love.exe
cp C:\Users\Public\Applications\Love2d\DevIL.dll almost-nothing/DevIL.dll
cp C:\Users\Public\Applications\Love2d\OpenAL32.dll almost-nothing/OpenAL32.dll
cp C:\Users\Public\Applications\Love2d\SDL.dll almost-nothing/SDL.dll
cp play.bat almost-nothing/play.bat
7z a almost-nothing.zip almost-nothing
del love.exe
del play.bat
mv ../ld26.git ./.git
