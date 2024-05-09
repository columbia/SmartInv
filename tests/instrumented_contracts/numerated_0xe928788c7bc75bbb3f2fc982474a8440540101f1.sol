1 pragma solidity ^0.4.18;
2 
3 /* String utility library */
4 library strUtils {
5     /* Converts given number to base58, limited by _maxLength symbols */
6     function toBase58(uint256 _value, uint8 _maxLength) internal pure returns (string) {
7         string memory letters = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
8         bytes memory alphabet = bytes(letters);
9         uint8 base = 58;
10         uint8 len = 0;
11         uint256 remainder = 0;
12         bool needBreak = false;
13         bytes memory bytesReversed = bytes(new string(_maxLength));
14 
15         for (uint8 i = 0; i < _maxLength; i++) {
16             if(_value < base){
17                 needBreak = true;
18             }
19             remainder = _value % base;
20             _value = uint256(_value / base);
21             bytesReversed[i] = alphabet[remainder];
22             len++;
23             if(needBreak){
24                 break;
25             }
26         }
27 
28         // Reverse
29         bytes memory result = bytes(new string(len));
30         for (i = 0; i < len; i++) {
31             result[i] = bytesReversed[len - i - 1];
32         }
33         return string(result);
34     }
35 
36     /* Concatenates two strings */
37     function concat(string _s1, string _s2) internal pure returns (string) {
38         bytes memory bs1 = bytes(_s1);
39         bytes memory bs2 = bytes(_s2);
40         string memory s3 = new string(bs1.length + bs2.length);
41         bytes memory bs3 = bytes(s3);
42 
43         uint256 j = 0;
44         for (uint256 i = 0; i < bs1.length; i++) {
45             bs3[j++] = bs1[i];
46         }
47         for (i = 0; i < bs2.length; i++) {
48             bs3[j++] = bs2[i];
49         }
50 
51         return string(bs3);
52     }
53 
54 }
55 
56 contract EthTxt {
57 
58   event NewText(string text, string code, address indexed submitter, uint timestamp);
59 
60   struct StoredText {
61       string text;
62       address submitter;
63       uint timestamp;
64   }
65 
66   uint storedTextCount = 0;
67 
68   // change this to 0 for testnet / ropsten
69   uint blockoffset = 5000000;
70 
71   mapping (string => StoredText) texts;
72 
73   function archiveText(string _text) public {
74     // make sure _text is not an empty string
75     require(bytes(_text).length != 0);
76 
77     var code = _generateShortLink();
78     // make sure code doesnt exist in map
79     require(bytes(getText(code)).length == 0);
80 
81     // add text to map
82     texts[code] = StoredText(_text, msg.sender, now);
83     NewText(_text, code, msg.sender, now);
84     storedTextCount = storedTextCount + 1;
85   }
86 
87   function getText(string _code) public view returns (string) {
88     return texts[_code].text;
89   }
90 
91   function getDataFromCode(string _code) public view returns (string, address, uint) {
92     return (texts[_code].text, texts[_code].submitter, texts[_code].timestamp);
93   }
94 
95   function getTextCount() public view returns (uint) {
96     return storedTextCount;
97   }
98 
99   // Generates a shortlink code
100   function _generateShortLink() private view returns (string) {
101       var s1 = strUtils.toBase58(uint256(msg.sender), 2);
102       var s2 = strUtils.toBase58(block.number - blockoffset, 11);
103 
104       var s = strUtils.concat(s1, s2);
105       return s;
106   }
107 
108 }