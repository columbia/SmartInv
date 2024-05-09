1 pragma solidity ^0.4.18;
2 
3 library strUtils {
4     /* Converts given number to base58, limited by _maxLength symbols */
5     function toBase58(uint256 _value, uint8 _maxLength) internal pure returns (string) {
6         string memory letters = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
7         bytes memory alphabet = bytes(letters);
8         uint8 base = 58;
9         uint8 len = 0;
10         uint256 remainder = 0;
11         bool needBreak = false;
12         bytes memory bytesReversed = bytes(new string(_maxLength));
13 
14         for (uint8 i = 0; i < _maxLength; i++) {
15             if(_value < base){
16                 needBreak = true;
17             }
18             remainder = _value % base;
19             _value = uint256(_value / base);
20             bytesReversed[i] = alphabet[remainder];
21             len++;
22             if(needBreak){
23                 break;
24             }
25         }
26 
27         // Reverse
28         bytes memory result = bytes(new string(len));
29         for (i = 0; i < len; i++) {
30             result[i] = bytesReversed[len - i - 1];
31         }
32         return string(result);
33     }
34 
35     /* Concatenates two strings */
36     function concat(string _s1, string _s2) internal pure returns (string) {
37         bytes memory bs1 = bytes(_s1);
38         bytes memory bs2 = bytes(_s2);
39         string memory s3 = new string(bs1.length + bs2.length);
40         bytes memory bs3 = bytes(s3);
41 
42         uint256 j = 0;
43         for (uint256 i = 0; i < bs1.length; i++) {
44             bs3[j++] = bs1[i];
45         }
46         for (i = 0; i < bs2.length; i++) {
47             bs3[j++] = bs2[i];
48         }
49 
50         return string(bs3);
51     }
52 
53 }
54 
55 contract EthTxt {
56 
57   event NewText(string text, string code, address submitter, uint timestamp);
58 
59   struct StoredText {
60       string text;
61       address submitter;
62       uint timestamp;
63   }
64 
65   uint storedTextCount = 0;
66 
67   // change this to 0 for testnet / ropsten
68   uint blockoffset = 4000000;
69 
70   mapping (string => StoredText) texts;
71 
72   // this is the constructor
73   function EthTxt() public {
74       // do nothing here
75   }
76 
77   function archiveText(string _text) public {
78     // make sure _text is not an empty string
79     require(bytes(_text).length != 0);
80 
81     var code = _generateShortLink();
82     // make sure code doesnt exist in map
83     require(bytes(getText(code)).length == 0);
84 
85     // add text to map
86     texts[code] = StoredText(_text, msg.sender, now);
87     NewText(_text, code, msg.sender, now);
88     storedTextCount = storedTextCount + 1;
89   }
90 
91   function getText(string _code) public view returns (string) {
92     return texts[_code].text;
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