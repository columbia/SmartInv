1 pragma solidity 0.5.8;
2 contract PasswordEncrypter {
3     //Current version:0.5.8+commit.23d335f2.Emscripten.clang
4 
5     struct KeyMakers {
6         address payable maker;
7         uint256 LockPrice;
8     }
9 
10     mapping (address => KeyMakers) getKM;
11     address[] private listofkeymakers;
12     mapping (address => bool) private CheckKM;
13 
14     struct encryptedMessages {
15         uint time;
16         address saver;
17         string encryptedMessage;
18         string primaryKey;
19     }
20 
21     struct getIndex {
22         string primaryKey;
23     }
24 
25     mapping (string => encryptedMessages) NewEncryptedMessage;
26     mapping (string => bool) private Wlist;
27     mapping (address => getIndex) OurlastIndex;
28 
29     function WallettoString(address x) internal pure returns(string memory) {
30         bytes memory b = new bytes(20);
31         for (uint i = 0; i < 20; i++)
32             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
33         return string(b);
34     }
35 
36     function appendString(string memory a, string memory b) internal pure returns (string memory) {
37         return string(abi.encodePacked(a, b));
38     }
39 
40     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
41         if (_i == 0) {
42             return "0";
43         }
44         uint j = _i;
45         uint len;
46         while (j != 0) {
47             len++;
48             j /= 10;
49         }
50         bytes memory bstr = new bytes(len);
51         uint k = len - 1;
52         while (_i != 0) {
53             bstr[k--] = byte(uint8(48 + _i % 10));
54             _i /= 10;
55         }
56         return string(bstr);
57     }
58 
59     function cexist(string memory _walletandid) view private returns (bool){
60         return Wlist[_walletandid];
61     }
62 
63     function checkIndex(address _address, string memory _primaryKey) view public returns (bool) {
64         string memory sid = appendString(WallettoString(_address),_primaryKey);
65         bool cwallet = cexist(sid);
66         return cwallet;
67     }
68 
69     function savenewEM(address payable keyMaker, address payable keyHelper, string memory _encryptedMessage, string memory _primaryKey) public payable {
70         string memory sid = appendString(WallettoString(msg.sender),_primaryKey);
71         require(ckmexist(keyMaker),"406");
72         require(!cexist(sid),"407");
73 
74         if(keyMaker == keyHelper) {
75             require(msg.value >= getKM[keyMaker].LockPrice, "402");
76             keyMaker.transfer(msg.value);
77             NewEncryptedMessage[sid].time = now;
78             NewEncryptedMessage[sid].saver = msg.sender;
79             NewEncryptedMessage[sid].encryptedMessage = _encryptedMessage;
80             NewEncryptedMessage[sid].primaryKey = _primaryKey;
81             OurlastIndex[msg.sender].primaryKey = _primaryKey;
82             Wlist[sid]=true;
83         } else {
84             require(msg.value >= getKM[keyMaker].LockPrice, "402");
85             keyMaker.transfer(msg.value/2);
86             keyHelper.transfer(msg.value/2);
87             NewEncryptedMessage[sid].time = now;
88             NewEncryptedMessage[sid].saver = msg.sender;
89             NewEncryptedMessage[sid].encryptedMessage = _encryptedMessage;
90             NewEncryptedMessage[sid].primaryKey = _primaryKey;
91             OurlastIndex[msg.sender].primaryKey = _primaryKey;
92             Wlist[sid]=true;
93         }
94     }
95 
96     function ckmexist(address payable _keymakerAddress) view private returns (bool){
97         return CheckKM[_keymakerAddress];
98     }
99 
100     function becomeAKeyMaker(uint256 price) public {
101         getKM[msg.sender].maker = msg.sender;
102         getKM[msg.sender].LockPrice = price;
103         CheckKM[msg.sender] = true;
104         listofkeymakers.push(msg.sender) -1;
105     }
106 
107     function getKeyMakerList() view public returns(address[] memory) {
108       return listofkeymakers;
109     }
110 
111     function numberOfKeyMakers() view public returns (uint) {
112       return listofkeymakers.length;
113     }
114 
115     function getLastIndex(address _address) view public returns (string memory) {
116         if(bytes(OurlastIndex[_address].primaryKey).length > 0) {
117            return OurlastIndex[_address].primaryKey;
118         } else {
119             return "40000004";
120         }
121     }
122 
123     function GetDetailsWithID(address _address, string memory _emID) view public returns (string memory, string memory,string memory) {
124         string memory sid = appendString(WallettoString(_address),_emID);
125         bool cwallet = cexist(sid);
126         if(cwallet){
127                return (uint2str(NewEncryptedMessage[sid].time), NewEncryptedMessage[sid].encryptedMessage, "200");
128         } else {
129               return ("0","0","404");
130         }
131     }
132 }