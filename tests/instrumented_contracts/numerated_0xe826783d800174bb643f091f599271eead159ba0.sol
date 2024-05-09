1 pragma solidity ^0.4.18;
2 
3 contract EthTxt {
4 
5   event NewText(string text, string code, address indexed submitter, uint timestamp);
6 
7   struct StoredText {
8       string text;
9       address submitter;
10       uint timestamp;
11   }
12 
13   uint storedTextCount = 0;
14 
15   // change this to 0 for testnet / ropsten
16   uint blockoffset = 4000000;
17 
18   mapping (string => StoredText) texts;
19 
20   function archiveText(string _text) public {
21     // make sure _text is not an empty string
22     require(bytes(_text).length != 0);
23 
24     var code = _generateShortLink();
25     // make sure code doesnt exist in map
26     require(bytes(getText(code)).length == 0);
27 
28     // add text to map
29     texts[code] = StoredText(_text, msg.sender, now);
30     NewText(_text, code, msg.sender, now);
31     storedTextCount = storedTextCount + 1;
32   }
33 
34   function getText(string _code) public view returns (string) {
35     return texts[_code].text;
36   }
37 
38   function getTextCount() public view returns (uint) {
39     return storedTextCount;
40   }
41 
42   // Generates a shortlink code
43   function _generateShortLink() private view returns (string) {
44       var s1 = strUtils.toBase58(uint256(msg.sender), 2);
45       var s2 = strUtils.toBase58(block.number - blockoffset, 11);
46 
47       var s = strUtils.concat(s1, s2);
48       return s;
49   }
50 
51 }
52 
53 library strUtils {
54     /* Converts given number to base58, limited by _maxLength symbols */
55     function toBase58(uint256 _value, uint8 _maxLength) internal pure returns (string) {
56         string memory letters = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
57         bytes memory alphabet = bytes(letters);
58         uint8 base = 58;
59         uint8 len = 0;
60         uint256 remainder = 0;
61         bool needBreak = false;
62         bytes memory bytesReversed = bytes(new string(_maxLength));
63 
64         for (uint8 i = 0; i < _maxLength; i++) {
65             if(_value < base){
66                 needBreak = true;
67             }
68             remainder = _value % base;
69             _value = uint256(_value / base);
70             bytesReversed[i] = alphabet[remainder];
71             len++;
72             if(needBreak){
73                 break;
74             }
75         }
76 
77         // Reverse
78         bytes memory result = bytes(new string(len));
79         for (i = 0; i < len; i++) {
80             result[i] = bytesReversed[len - i - 1];
81         }
82         return string(result);
83     }
84 
85     /* Concatenates two strings */
86     function concat(string _s1, string _s2) internal pure returns (string) {
87         bytes memory bs1 = bytes(_s1);
88         bytes memory bs2 = bytes(_s2);
89         string memory s3 = new string(bs1.length + bs2.length);
90         bytes memory bs3 = bytes(s3);
91 
92         uint256 j = 0;
93         for (uint256 i = 0; i < bs1.length; i++) {
94             bs3[j++] = bs1[i];
95         }
96         for (i = 0; i < bs2.length; i++) {
97             bs3[j++] = bs2[i];
98         }
99 
100         return string(bs3);
101     }
102 
103 }