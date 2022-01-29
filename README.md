<h1 align="center">Unicode to Krutidev Converter</h1>

Krutidev is an old font format that allows for Devanagari ("Hindi") to be rendered without relying on GSUB and GPOS tables found in modern .ttf font files. GameMaker doesn't allow us to access GPOS and GSUB tables so this is the best we have until someone puts together a .ttf file reader.

Krutidev works by inserting Devanagari glyphs into a font by overwriting Latin character slots. For example, "k" is replaced by "ा". Devanagari glyphs can get quite complicated, for example "ह्न" is made up of three Unicode characters but is represented in Krutidev using "à".

This function converts Unicode-formatted Devanagari into the necessary Latin characters so that when the outputted string is rendered using a Krutidev font the Devanagari glyphs are comfortably readable to the player.

There are, of course, more Devanagari glyph variants than there are Latin characters. This means that Krutidev fonts need to be set up with an expanded range of glyphs. Judging by the sample font I found ([Krutidev 010](https://github.com/JujuAdams/KrutidevDevanagari/tree/main/datafiles)), the glyph ranges required are:

```
  32 ->  126        0x0020 -> 0x007E
 144                0x0090
 160 ->  249        0x00A0 -> 0x00F9
 338                0x0152
 352                0x0160
 376                0x0178
 402                0x0192
 710                0x02C6
 732                0x02DC
8208                0x2010
8211 -> 8212        0x2013 -> 0x2014
8216 -> 8218        0x2018 -> 0x201A
8220 -> 8225        0x201C -> 0x2021
8230                0x2026
8240                0x2030
8249 -> 8250        0x2039 -> 0x203A
8482                0x2122
```

This list may not be exhaustive. I highly recommend grabbing [FontForge](https://fontforge.org/) to help determined what glyphs are available in your font of choice.

Using Krutidev to render Devanagari has drawbacks:
1) Only Krutidev fonts can be used with Krutidev-formatted text. There seem to be a *lot* of Krutidev fonts out there but that may dry up over time. I found a website that seems to host a bazillion Krutidev fonts: https://www.wfonts.com/search?kwd=Kruti+Dev
2) Krutidev doesn't have a lot of the fancier Devanagari glyphs. I am unsure exactly what is missing - I'm not a native Hindi speaker - so don't be surprised if some text doesn't look quite right to people familiar with the language.
3) Since Krutidev fonts replace Western characters with Devanagari glyphs, this means it is not possible to draw Latin script and Devanagari script from the same font. This is a bit of a pain but can be worked around if you're desperate.
4) Setting Krutidev font glyph ranges is a faff. Not the worst thing in the world, but worth bearing in mind.
