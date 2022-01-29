var _expected = testVectorArray[vectorIndex].expected;
var _actual   = UnicodeToKrutidev(testVectorArray[vectorIndex].unicode);

draw_set_font(-1);
draw_text(10, 10, string(vectorIndex) + " of " + string(array_length(testVectorArray)));
draw_text(10, 30, (_actual == _expected)? "match" : "DIFFERENT");
draw_text(10, 50, "Expected = \"" + _expected + "\"");
draw_text(10, 70, "Actual = \"" + _actual + "\"");
draw_set_font(fntKrutidev010);
draw_text(10, 200, _expected);
draw_text(10, 250, _actual);