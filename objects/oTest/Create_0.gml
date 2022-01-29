

testVectorArray = [
    { unicode: "गया", expected: "x;k" },
    { unicode: "बोधगया", expected: "cks/kx;k" },
    { unicode: "बारा", expected: "ckjk" },
    { unicode: "अतिया", expected: "vfr;k" },
    { unicode: "मोचारीम", expected: "ekspkjhe" },
    { unicode: "बकरौर", expected: "cdjkSj" },
    { unicode: "बसाढ़ी", expected: "clk<+h" },
    { unicode: "मोराटाल", expected: "eksjkVky" },
    { unicode: "कन्हौल", expected: "dUgkSy" },
    { unicode: "गंफाखुर्द", expected: "xaQk[kqnZ" },
    { unicode: "नवां", expected: "uoka" },
    { unicode: "कुरमावां", expected: "dqjekoka" },
    { unicode: "इटरा", expected: "bVjk" },
    { unicode: "झिकटिया", expected: "f>dfV;k" },
    { unicode: "मोरामर्दाना", expected: "eksjkenkZuk" },
    { unicode: "ईलरा", expected: "bZyjk" },
    { unicode: "पड़रिया", expected: "iM+fj;k" },
    { unicode: " शेखवारा", expected: " 'ks[kokjk" },
    { unicode: "बारा", expected: "ckjk" },
    { unicode: "अतिया", expected: "vfr;k" },
    { unicode: "मोचारीम", expected: "ekspkjhe" },
    { unicode: "मोेचारिम", expected: "eksspkfje" },
    { unicode: "वकरौर", expected: "odjkSj" },
    { unicode: "बसाढ़ी", expected: "clk<+h" },
    { unicode: "कन्हौल", expected: "dUgkSy" },
    { unicode: "गफा खूर्द", expected: "xQk [kwnZ" },
    { unicode: "नवाँ", expected: "uok¡" },
    { unicode: "कुरमावां", expected: "dqjekoka" },
    { unicode: "ईटरा", expected: "bZVjk" },
    { unicode: "झिकटिया", expected: "f>dfV;k" },
    { unicode: "ईलरा", expected: "bZyjk" },
    { unicode: "धनावाँ", expected: "/kukok¡" },
    { unicode: "पड़रिया", expected: "iM+fj;k" },
    { unicode: " शेखवारा", expected: " 'ks[kokjk" },
    { unicode: "न0 पंचायत", expected: "u0 iapk;r" },
    { unicode: "रिक्त", expected: "fjDr" },
];

vectorIndex = 0;

var _i = 0;
repeat(array_length(testVectorArray))
{
    var _unicode  = testVectorArray[_i].unicode;
    var _expected = testVectorArray[_i].expected;
    var _actual   = UnicodeToKrutidev(_unicode);
    
    if (_expected != _actual) show_debug_message(string(_i) + " failed          " + _unicode + "          " + _expected);
    
    ++_i;
}