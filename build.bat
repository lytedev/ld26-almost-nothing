del almost-nothing.exe
del almost-nothing.zip
del almost-nothing.love
rm -rf almost-nothing
mv ./.git ../ld26.git
7z a -tzip almost-nothing.love ./
cp C:\Users\Public\Applications\Love2d\love.exe ./love.exe
copy /b love.exe+almost-nothing.love almost-nothing.exe
:: 7z a almost-nothing.zip almost-nothing.exe
mkdir almost-nothing
cp almost-nothing.exe almost-nothing/almost-nothing.exe
cp C:\Users\Public\Applications\Love2d\DevIL.dll almost-nothing/DevIL.dll
cp C:\Users\Public\Applications\Love2d\OpenAL32.dll almost-nothing/OpenAL32.dll
cp C:\Users\Public\Applications\Love2d\SDL.dll almost-nothing/SDL.dll
7z a -tzip almost-nothing.zip almost-nothing
del love.exe
mv ../ld26.git ./.git
rm -rf almost-nothing

