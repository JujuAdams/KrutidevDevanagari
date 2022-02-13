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



#region Build find-replace lookup table

var _unicodeSourceArray = [
    "‘",   "’",   "“",   "”",   "(",    ")",   "{",    "}",   "=", "।",  "?",  "-",  "µ", "॰", ",", ".",
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
	"ं",   "ँ",   "ः",   "ॅ",    "ऽ",
];
    
var _krutidevSourceArray = [
    "^", "*",  "Þ", "ß", "¼", "½", "¿", "À", "¾", "A", "\\", "&", "&", "Œ", "]","-", 
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
	"a",    "¡",    "%",     "W",   "·",
];

//Use a ds_map rather than a struct since our keys will be integers
global.__krutidevLookupMap = ds_map_create();
    
var _i = 0;
repeat(array_length(_unicodeSourceArray))
{
    var _string = _unicodeSourceArray[_i];
        
    var _searchInteger = 0;
    var _j = string_length(_string);
    repeat(_j)
    {
        _searchInteger = (_searchInteger << 16) | ord(string_char_at(_string, _j));
        --_j;
    }
        
    var _string = _krutidevSourceArray[_i];
    var _writeArray = [];
    var _j = 1;
    repeat(string_length(_string))
    {
        array_push(_writeArray, ord(string_char_at(_string, _j)));
        ++_j;
    }
        
    global.__krutidevLookupMap[? _searchInteger] = _writeArray;
        
    ++_i;
}
    
#endregion



function UnicodeToKrutidev(_inString)
{
    //Convert the string into an array
    var _stringLength = string_length(_inString);
    var _charArray = array_create(_stringLength + 4, 0xFFFF); //Pad the end because we'll need to read beyond the end of the string during the final find-replace
    var _i = 0;
    repeat(_stringLength)
    {
        _charArray[@ _i] = ord(string_char_at(_inString, _i+1));
        ++_i;
    }
    
    
    
    #region Transform quotes and split up nukta ligatures
    
    var _inSingleQuote = false;
    var _inDoubleQuote = false;
    var _i = 0;
    repeat(_stringLength)
    {
        switch(_charArray[_i])
        {
            //Set up alternating single quote marks
            case ord("'"):
                _inSingleQuote = !_inSingleQuote;
                _charArray[@ _i] = _inSingleQuote? ord("^") : ord("*");
            break;
            
            //Set up alternating double quote marks
            case ord("\""):
                _inDoubleQuote = !_inDoubleQuote;
                _charArray[@ _i] = _inDoubleQuote? ord("ß") : ord("Þ");
            break;
            
            //Split up nukta ligatures into their componant parts
            case ord("ऩ"):
                _charArray[@ _i] = ord("न");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ऱ"):
                _charArray[@ _i] = ord("र");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("क़"):
                _charArray[@ _i] = ord("क");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ख़"):
                _charArray[@ _i] = ord("ख");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ग़"):
                _charArray[@ _i] = ord("ग");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ज़"):
                _charArray[@ _i] = ord("ज");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ड़"):
                _charArray[@ _i] = ord("ड");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ढ़"):
                _charArray[@ _i] = ord("ढ");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("फ़"):
                _charArray[@ _i] = ord("फ");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("य़"):
                _charArray[@ _i] = ord("य");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Reposition ि  to the front of the word and replace it with an "f"
    
    var _i = 1; //Start at the second char because we don't care if the string starts with 0x093F (Vowel Sign I)
    repeat(_stringLength-1)
    {
        var _char = _charArray[_i];
        if (_char == ord("ि"))
        {
            var _fPosition = _i;
            
            //If we find a virama behind us keep tracking backwards
            var _j = _i - 1;
            while((_j >= 0) && (_charArray[_i] == 0x094D)) _j -= 2;
            
            array_delete(_charArray, _fPosition, 1);
            array_insert(_charArray, _j, ord("f"));
            
            _i = _fPosition;
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Move र् (ra + virama) after matras
    
    var _matraMap = ds_map_create();
    _matraMap[?   58] = true;
    _matraMap[? 2305] = true;
    _matraMap[? 2306] = true;
    _matraMap[? 2366] = true;
    _matraMap[? 2367] = true;
    _matraMap[? 2368] = true;
    _matraMap[? 2369] = true;
    _matraMap[? 2370] = true;
    _matraMap[? 2371] = true;
    _matraMap[? 2373] = true;
    _matraMap[? 2375] = true;
    _matraMap[? 2376] = true;
    _matraMap[? 2379] = true;
    _matraMap[? 2380] = true;
    
    for(var _i = 0; _i < _stringLength; ++_i)
    {
        if ((_charArray[_i] == ord("र")) && (_charArray[_i+1] == 0x094D)) //Ra followed by virama
        {
            var _probablePosition = _i + 3;
            
            var _charRight = _charArray[_probablePosition];
            while(ds_map_exists(_matraMap, _charRight))
            {
                _probablePosition++;
                _charRight = _charArray[_probablePosition];
            }
            
            array_insert(_charArray, _probablePosition, ord("Z"));
            array_delete(_charArray, _i, 2);
            
            --_stringLength;
        }
    }
    
    ds_map_destroy(_matraMap);
    
    #endregion
    
    
    
    #region Perform bulk find-replace
    
    var _viramaPositionArray = [];
    var _lookupMap = global.__krutidevLookupMap;
    
    var _oneChar   =                                0x0000;
    var _twoChar   =              ((_charArray[0] & 0xFFFF) << 16);
    var _threeChar = _twoChar   | ((_charArray[1] & 0xFFFF) << 32);
    var _fourChar  = _threeChar | ((_charArray[2] & 0xFFFF) << 48);
    
    for(var _i = 0; _i < _stringLength; ++_i;)
    {
        _oneChar   = _twoChar   >> 16;
        _twoChar   = _threeChar >> 16;
        _threeChar = _fourChar  >> 16;
        _fourChar  = _threeChar | ((_charArray[_i + 3] & 0xFFFF) << 48);
        
        //Try to find a matching substring
        var _foundLength = 4;
        var _replacementArray = _lookupMap[? _fourChar];
        
        if (_replacementArray == undefined)
        {
            _foundLength = 3;
            _replacementArray = _lookupMap[? _threeChar];
            
            if (_replacementArray == undefined)
            {
                _foundLength = 2;
                _replacementArray = _lookupMap[? _twoChar];
                
                if (_replacementArray == undefined)
                {
                    _foundLength = 1;
                    _replacementArray = _lookupMap[? _oneChar];
                }
            }
        }
        
        if (_replacementArray == undefined)
        {
            if (_oneChar == 0x94D) //Virama
            {
                array_push(_viramaPositionArray, _i);
            }
        }
        else
        {
            var _replacementLength = array_length(_replacementArray);
            
            if ((_foundLength == 1) && (_replacementLength == 1))
            {
                _charArray[@ _i] = _replacementArray[0];
            }
            else
            {
                array_delete(_charArray, _i, _foundLength);
                
                var _j = 0;
                repeat(_replacementLength)
                {
                    array_insert(_charArray, _i + _j, _replacementArray[_j]);
                    ++_j;
                }
            }
            
            _i            += _replacementLength - 1;
            _stringLength += _replacementLength - _foundLength;
            
            //Recalculate our minibuffer since we've messed around with the array a lot
            _twoChar   =              ((_charArray[_i+1] & 0xFFFF) << 16);
            _threeChar = _twoChar   | ((_charArray[_i+2] & 0xFFFF) << 32);
            _fourChar  = _threeChar | ((_charArray[_i+3] & 0xFFFF) << 48);
        }
    }
    
    #endregion
    
    
    
    #region Convert any lone viramas we found
    
    var _i = 0;
    repeat(array_length(_viramaPositionArray))
    {
        _charArray[@ _viramaPositionArray[_i]] = ord("~");
        ++_i;
    }
    
    #endregion
    
    
    
    var _outString = "";
    var _i = 0;
    repeat(_stringLength)
    {
        _outString += chr(_charArray[_i]);
        ++_i;
    }
    
    return _outString;
}