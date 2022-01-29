/// Unicode to Krutidev
/// @jujuadams  2022-01-29
/// 
/// Krutidev is an old font format that allows for Devanagari ("Hindi") to be rendered without relying
/// on GSUB and GPOS tables found in modern .ttf font files. GameMaker doesn't allow us to access GPOS
/// and GSUB tables so this is the best we have until someone puts together a .ttf file reader.
/// 
/// Krutidev works by inserting Devanagari glyphs into a font by overwriting Latin character slots.
/// For example, "k" is replaced by "ा". Devanagari glyphs can get quite complicated, for example "ह्न"
/// is made up of three Unicode characters but is represented in Krutidev using "à".
/// 
/// This function converts Unicode-formatted Devanagari into the necessary Latin characters so that
/// when the outputted string is rendered using a Krutidev font the Devanagari glyphs are comfortably
/// readable to the player.
/// 
/// There are, of course, more Devanagari glyph variants than there are Latin characters. This means
/// that Krutidev fonts need to be set up with an expanded range of glyphs. Judging by the sample font
/// I found (Krutidev 010), the glyph ranges required are:
///   32 ->  126        0x0020 -> 0x007E
///  144                0x0090
///  160 ->  249        0x00A0 -> 0x00F9
///  338                0x0152
///  352                0x0160
///  376                0x0178
///  402                0x0192
///  710                0x02C6
///  732                0x02DC
/// 8208                0x2010
/// 8211 -> 8212        0x2013 -> 0x2014
/// 8216 -> 8218        0x2018 -> 0x201A
/// 8220 -> 8225        0x201C -> 0x2021
/// 8230                0x2026
/// 8240                0x2030
/// 8249 -> 8250        0x2039 -> 0x203A
/// 8482                0x2122
/// This list may not be exhaustive. I highly recommend grabbing FontForge to help determined what
/// glyphs are available in your font of choice.
/// 
/// Using Krutidev to render Devanagari has drawbacks:
/// 1) Only Krutidev fonts can be used with Krutidev-formatted text. There seem to be a *lot* of
///    Krutidev fonts out there but that may dry up over time. I found a website that seems to
///    host a bazillion Krutidev fonts: https://www.wfonts.com/search?kwd=Kruti+Dev
/// 2) Krutidev doesn't have a lot of the fancier Devanagari glyphs. I am unsure exactly what is
///    missing - I'm not a native Hindi speaker - so don't be surprised if some text doesn't look
///    quite right to people familiar with the language.
/// 3) Since Krutidev fonts replace Western characters with Devanagari glyphs, this means it is
///    not possible to draw Latin script and Devanagari script from the same font. This is a bit
///    of a pain but can be worked around if you're desperate.
/// 4) Setting Krutidev font glyph ranges is a faff. Not the worst thing in the world, but worth
///    bearing in mind.
/// 
/// @param unicodeString

function UnicodeToKrutidev(_inString)
{
    static _unicodeArray = [
        "‘",   "’",   "“",   "”",   "(",    ")",   "{",    "}",   "=", "।",  "?",  "-",  "µ", "॰", ",", ".", "् ", 
		"०",  "१",  "२",  "३",     "४",   "५",  "६",   "७",   "८",   "९", "x", 

		"फ़्",  "क़",  "ख़",  "ग़", "ज़्", "ज़",  "ड़",  "ढ़",   "फ़",  "य़",  "ऱ",  "ऩ",  
		"त्त्",   "त्त",     "क्त",  "दृ",  "कृ",

		"ह्न",  "ह्य",  "हृ",  "ह्म",  "ह्र",  "ह्",   "द्द",  "क्ष्", "क्ष", "त्र्", "त्र","ज्ञ",
		"छ्य",  "ट्य",  "ठ्य",  "ड्य",  "ढ्य", "द्य","द्व",
		"श्र",  "ट्र",    "ड्र",    "ढ्र",    "छ्र",   "क्र",  "फ्र",  "द्र",   "प्र",   "ग्र", "रु",  "रू",
		"्र",

		"ओ",  "औ",  "आ",   "अ",   "ई",   "इ",  "उ",   "ऊ",  "ऐ",  "ए", "ऋ",

		"क्",  "क",  "क्क",  "ख्",   "ख",    "ग्",   "ग",  "घ्",  "घ",    "ङ",
		"चै",   "च्",   "च",   "छ",  "ज्", "ज",   "झ्",  "झ",   "ञ",

		"ट्ट",   "ट्ठ",   "ट",   "ठ",   "ड्ड",   "ड्ढ",  "ड",   "ढ",  "ण्", "ण",  
		"त्",  "त",  "थ्", "थ",  "द्ध",  "द", "ध्", "ध",  "न्",  "न",  

		"प्",  "प",  "फ्", "फ",  "ब्",  "ब", "भ्",  "भ",  "म्",  "म",
		"य्",  "य",  "र",  "ल्", "ल",  "ळ",  "व्",  "व", 
		"श्", "श",  "ष्", "ष",  "स्",   "स",   "ह",     

		"ऑ",   "ॉ",  "ो",   "ौ",   "ा",   "ी",   "ु",   "ू",   "ृ",   "े",   "ै",
		"ं",   "ँ",   "ः",   "ॅ",    "ऽ",  "् ", "्",
    ];
    
    static _krutidevArray = [
        "^", "*",  "Þ", "ß", "¼", "½", "¿", "À", "¾", "A", "\\", "&", "&", "Œ", "]","-","~ ", 
		"å",  "ƒ",  "„",   "…",   "†",   "‡",   "ˆ",   "‰",   "Š",   "‹","Û",

		"¶",   "d",    "[k",  "x",  "T",  "t",   "M+", "<+", "Q",  ";",    "j",   "u",
		"Ù",   "Ùk",   "Dr",    "–",   "—",       

		"à",   "á",    "â",   "ã",   "ºz",  "º",   "í", "{", "{k",  "«", "=","K", 
		"Nî",   "Vî",    "Bî",   "Mî",   "<î", "|","}",
		"J",   "Vª",   "Mª",  "<ªª",  "Nª",   "Ø",  "Ý",   "æ", "ç", "xz", "#", ":",
		"z",

		"vks",  "vkS",  "vk",    "v",   "bZ",  "b",  "m",  "Å",  ",s",  ",",   "_",

		"D",  "d",    "ô",     "[",     "[k",    "X",   "x",  "?",    "?k",   "³", 
		"pkS",  "P",    "p",  "N",   "T",    "t",   "÷",  ">",   "¥",

		"ê",      "ë",      "V",  "B",   "ì",       "ï",     "M",  "<",  ".", ".k",   
		"R",  "r",   "F", "Fk",  ")",    "n", "/",  "/k",  "U", "u",   

		"I",  "i",   "¶", "Q",   "C",  "c",  "H",  "Hk", "E",   "e",
		"¸",   ";",    "j",  "Y",   "y",  "G",  "O",  "o",
		"'", "'k",  "\"", "\"k", "L",   "l",   "g",      

		"v‚",    "‚",    "ks",   "kS",   "k",     "h",    "q",   "w",   "`",    "s",    "S",
		"a",    "¡",    "%",     "W",   "·",   "~ ", "~",
    ];
    
    var _outString = _inString;
    
    var _pos = string_pos("'", _outString);
    while(_pos >= 1)
    {
        _outString = string_replace(_outString, "'", "^");
        _outString = string_replace(_outString, "'", "*");
        _pos = string_pos("'", _outString);
    }
    
    var _pos = string_pos("\"", _outString);
    while(_pos >= 1)
    {
        _outString = string_replace(_outString, "'", "ß");
        _outString = string_replace(_outString, "'", "Þ");
        _pos = string_pos("\"", _outString);
    }
    
    _outString = string_replace_all(_outString, "क़", "क़"); 
    _outString = string_replace_all(_outString, "ख़", "ख़");
    _outString = string_replace_all(_outString, "ग़", "ग़");
    _outString = string_replace_all(_outString, "ज़", "ज़");
    _outString = string_replace_all(_outString, "ड़", "ड़");
    _outString = string_replace_all(_outString, "ढ़", "ढ़");
    _outString = string_replace_all(_outString, "ऩ", "ऩ");
    _outString = string_replace_all(_outString, "फ़", "फ़");
    _outString = string_replace_all(_outString, "य़", "य़");
    _outString = string_replace_all(_outString, "ऱ", "ऱ");   
    
    var _position_f = string_pos("ि", _outString);
    while(_position_f >= 1)
    {
        var _stringReplace = string_char_at(_outString, _position_f - 1);
        _outString = string_replace(_outString, _stringReplace + "ि", "f" + _stringReplace);
        
        _position_f--;
        while((_position_f > 0) && (string_char_at(_outString, _position_f - 1) == chr(0x094D))) //DEVANAGARI SIGN VIRAMA
        {
            var _stringReplace = string_char_at(_outString, _position_f - 2) + chr(0x094D);
            _outString = string_replace(_outString, _stringReplace + "ि", "f" + _stringReplace);
            
            _position_f -= 2;
        }
        
        _position_f = string_pos_ext("ि", _outString, _position_f + 1);
    }
    
    static _matraString = "ािीुूृेैोौं:ँॅ";
    _outString += "  ";
    
    var _positionHalfR = string_pos("र्", _outString);
    while(_positionHalfR >= 1)
    {
        var _probablePosition = _positionHalfR + 2;
        var _charRight = string_char_at(_outString, _probablePosition + 1);
        
        while(string_pos(_charRight, _matraString) >= 1)
        {
            _probablePosition++;
            _charRight = string_char_at(_outString, _probablePosition + 1);
        }
        
        var _targetString = string_copy(_outString, _positionHalfR + 2, _probablePosition - _positionHalfR - 1);
        _outString = string_replace(_outString, "र्" + _targetString, _targetString + "Z");
        _positionHalfR = string_pos_ext("र्", _outString, _probablePosition);
    }
    
    _outString = string_copy(_outString, 1, string_length(_outString) - 2);
    
    var _i = 0;
    repeat(array_length(_unicodeArray))
    {
        if (string_pos(_unicodeArray[_i], _outString) > 0) && keyboard_check_pressed(ord("J"))
        {
            show_debug_message("\"" + _unicodeArray[_i] + "\"    ->    \"" + _krutidevArray[_i] + "\"");
        }
        
        _outString = string_replace_all(_outString, _unicodeArray[_i], _krutidevArray[_i]);
        ++_i;
    }
    
    return _outString;
}