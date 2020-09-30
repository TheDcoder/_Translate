# _Translate
Simple translation library/UDF for AutoIt

Inspired by [gettext](https://en.wikipedia.org/wiki/Gettext) and [AU3Text](https://www.autoitscript.com/forum/topic/144037-au3text-internationalization-udf).

## Usage

### Extractor

1. Place compiled [`eci.exe`](https://www.autoitscript.com/forum/files/file/510-_translate-eci-string-extractor) binary under `eci\build` folder
2. Run `Extract.au3` script to interactively extract all translatable strings from your script

### UDF

1. Include `_.au3` in your script
2. Call `_Translate_LoadTable` with path of your translation table
3. Use `_` to wrap all of your strings which need to be translated
