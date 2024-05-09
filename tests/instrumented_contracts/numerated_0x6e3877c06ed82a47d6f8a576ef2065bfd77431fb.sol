1 pragma solidity 0.5.8;
2 contract PasswordEncrypter {
3     //Current version:0.5.8+commit.23d335f2.Emscripten.clang
4 
5 
6     struct KeyMakers {
7         address payable maker;
8         uint256 LockPrice;
9     }
10 
11     mapping (address => KeyMakers) getKM;
12     address[] private listofkeymakers;
13     mapping (address => bool) private CheckKM;
14 
15     struct encryptedMessages {
16         uint time;
17         address saver;
18         string encryptedMessage;
19         string primaryKey;
20     }
21 
22 
23     struct getIndex {
24         string primaryKey;
25     }
26 
27     mapping (string => encryptedMessages) NewEncryptedMessage;
28     mapping (string => bool) private Wlist;
29     mapping (address => getIndex) OurlastIndex;
30 
31 
32 
33     function WallettoString(address x) internal pure returns(string memory) {
34         bytes memory b = new bytes(20);
35         for (uint i = 0; i < 20; i++)
36             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
37         return string(b);
38     }
39 
40 
41     function appendString(string memory a, string memory b) internal pure returns (string memory) {
42         return string(abi.encodePacked(a, b));
43     }
44 
45     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
46         if (_i == 0) {
47             return "0";
48         }
49         uint j = _i;
50         uint len;
51         while (j != 0) {
52             len++;
53             j /= 10;
54         }
55         bytes memory bstr = new bytes(len);
56         uint k = len - 1;
57         while (_i != 0) {
58             bstr[k--] = byte(uint8(48 + _i % 10));
59             _i /= 10;
60         }
61         return string(bstr);
62     }
63 
64 
65     function cexist(string memory _walletandid) view private returns (bool){
66         return Wlist[_walletandid];
67     }
68 
69 
70     function checkIndex(string memory _primaryKey) view public returns (bool) {
71         string memory sid = appendString(WallettoString(msg.sender),_primaryKey);
72         bool cwallet = cexist(sid);
73         return cwallet;
74     }
75 
76     function savenewEM(address payable keyMaker, address payable keyHelper, string memory _encryptedMessage, string memory _primaryKey) public payable {
77         string memory sid = appendString(WallettoString(msg.sender),_primaryKey);
78         require(ckmexist(keyMaker),"406");
79         require(!cexist(sid),"407");
80 
81         if(keyHelper == keyHelper) {
82             require(msg.value >= getKM[keyMaker].LockPrice, "402");
83             keyMaker.transfer(msg.value);
84             NewEncryptedMessage[sid].time = now;
85             NewEncryptedMessage[sid].saver = msg.sender;
86             NewEncryptedMessage[sid].encryptedMessage = _encryptedMessage;
87             NewEncryptedMessage[sid].primaryKey = _primaryKey;
88             OurlastIndex[msg.sender].primaryKey = _primaryKey;
89             Wlist[sid]=true;
90         } else {
91             require(msg.value >= getKM[keyMaker].LockPrice, "402");
92             keyMaker.transfer(msg.value/2);
93             keyHelper.transfer(msg.value/2);
94             NewEncryptedMessage[sid].time = now;
95             NewEncryptedMessage[sid].saver = msg.sender;
96             NewEncryptedMessage[sid].encryptedMessage = _encryptedMessage;
97             NewEncryptedMessage[sid].primaryKey = _primaryKey;
98             OurlastIndex[msg.sender].primaryKey = _primaryKey;
99             Wlist[sid]=true;
100         }
101 
102 
103     }
104 
105 
106 
107     function ckmexist(address payable _keymakerAddress) view private returns (bool){
108         return CheckKM[_keymakerAddress];
109     }
110 
111 
112     function becomeAKeyMaker(uint256 price) public {
113         getKM[msg.sender].maker = msg.sender;
114         getKM[msg.sender].LockPrice = price;
115         CheckKM[msg.sender] = true;
116         listofkeymakers.push(msg.sender) -1;
117     }
118 
119     function getKeyMakerList() view public returns(address[] memory) {
120       return listofkeymakers;
121     }
122 
123     function numberOfKeyMakers() view public returns (uint) {
124       return listofkeymakers.length;
125     }
126 
127 
128     function getLastIndex() view public returns (string memory) {
129         return OurlastIndex[msg.sender].primaryKey;
130     }
131 
132 
133      function GetDetailsWithID(string memory _emID) view public returns (string memory, string memory,string memory) {
134         string memory sid = appendString(WallettoString(msg.sender),_emID);
135         bool cwallet = cexist(sid);
136         if(cwallet){
137                return (uint2str(NewEncryptedMessage[sid].time), NewEncryptedMessage[sid].encryptedMessage, "200");
138           } else {
139               return ("0","0","404");
140           }
141      }
142 
143 
144 
145 }