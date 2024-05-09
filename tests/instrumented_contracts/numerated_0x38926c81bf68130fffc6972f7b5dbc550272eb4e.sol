1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         require(c / a == b, "SafeMath mul failed");
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b <= a, "SafeMath sub failed");
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         require(c >= a, "SafeMath add failed");
25         return c;
26     }
27 }
28 
29 library NameFilter {
30     function nameFilter(string _input) internal pure returns(bytes32) {
31         bytes memory _temp = bytes(_input);
32         uint256 _length = _temp.length;
33 
34         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
35         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
36         if (_temp[0] == 0x30) {
37             require(_temp[1] != 0x78, "string cannot start with 0x");
38             require(_temp[1] != 0x58, "string cannot start with 0X");
39         }
40 
41         bool _hasNonNumber;
42 
43         for (uint256 i = 0; i < _length; i++) {
44             if (_temp[i] > 0x40 && _temp[i] < 0x5b) {
45                 _temp[i] = byte(uint(_temp[i]) + 32);
46 
47                 if (_hasNonNumber == false) {
48                     _hasNonNumber = true;
49                 }
50             } else {
51                 require(_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
52                 if (_temp[i] == 0x20) {
53                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
54                 }
55 
56                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39)) {
57                     _hasNonNumber = true;
58                 }
59             }
60         }
61 
62         require(_hasNonNumber == true, "string cannot be only numbers");
63 
64         bytes32 _ret;
65         assembly {
66             _ret := mload(add(_temp, 32))
67         }
68 
69         return (_ret);
70     }
71 }
72 
73 interface PartnershipInterface {
74     function deposit() external payable returns(bool);
75 }
76 
77 interface PlayerBookReceiverInterface {
78     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
79     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
80 }
81 
82 contract Ownable {
83     address public owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     modifier onlyOwner() {
92         require(msg.sender == owner, "You are not owner.");
93         _;
94     }
95 
96     function transferOwnership(address _newOwner) public onlyOwner {
97         require(_newOwner != address(0), "Invalid address.");
98 
99         owner = _newOwner;
100 
101         emit OwnershipTransferred(owner, _newOwner);
102     }
103 }
104 
105 contract PlayerBook is Ownable {
106     using SafeMath for uint256;
107     using NameFilter for string;
108 
109     PartnershipInterface constant private partnership = PartnershipInterface(0x59Ff25C4E2550bc9E2115dbcD28b949d7670d134);
110 
111     uint256 public registrationFee_ = 10 finney;
112     mapping(uint256 => PlayerBookReceiverInterface) public games_;
113     mapping(address => bytes32) public gameNames_;
114     mapping(address => uint256) public gameIDs_;
115 
116     uint256 public gID_;
117     uint256 public pID_;
118     mapping (address => uint256) public pIDxAddr_;
119     mapping (bytes32 => uint256) public pIDxName_;
120 
121     struct Player {
122         address addr;
123         bytes32 name;
124         uint256 laff;
125         uint256 names;
126     }
127 
128     mapping (uint256 => Player) public plyr_;
129     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
130     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_;
131 
132     event onNewName(
133         uint256 indexed playerID,
134         address indexed playerAddress,
135         bytes32 indexed playerName,
136         bool isNewPlayer,
137         uint256 affiliateID,
138         address affiliateAddress,
139         bytes32 affiliateName,
140         uint256 amountPaid,
141         uint256 timeStamp
142     );
143 
144     constructor() public {
145         plyr_[1].addr = 0x98EF158e8EA887AF8F2F4fecfEd25857b0A699c6;
146         plyr_[1].name = "asia";
147         plyr_[1].names = 1;
148         pIDxAddr_[0x98EF158e8EA887AF8F2F4fecfEd25857b0A699c6] = 1;
149         pIDxName_["asia"] = 1;
150         plyrNames_[1]["asia"] = true;
151         plyrNameList_[1][1] = "asia";
152 
153         pID_ = 1;
154     }
155 
156     modifier isHuman() {
157         address _addr = msg.sender;
158         uint256 _codeLength;
159 
160         assembly {
161             _codeLength := extcodesize(_addr)
162         }
163 
164         require(_codeLength == 0, "sorry humans only");
165         _;
166     }
167 
168     modifier isRegisteredGame() {
169         require(gameIDs_[msg.sender] != 0);
170         _;
171     }
172 
173     function checkIfNameValid(string _nameStr) public view returns(bool) {
174         bytes32 _name = _nameStr.nameFilter();
175         if (pIDxName_[_name] == 0) {
176             return true;
177         }
178         return false;
179     }
180 
181     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable isHuman {
182         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
183 
184         bytes32 _name = NameFilter.nameFilter(_nameString);
185 
186         address _addr = msg.sender;
187         bool _isNewPlayer = determinePID(_addr);
188 
189         uint256 _pID = pIDxAddr_[_addr];
190         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) {
191             plyr_[_pID].laff = _affCode;
192         } else if (_affCode == _pID) {
193             _affCode = 0;
194         }
195 
196         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
197     }
198 
199     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable isHuman {
200         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
201 
202         bytes32 _name = NameFilter.nameFilter(_nameString);
203 
204         address _addr = msg.sender;
205         bool _isNewPlayer = determinePID(_addr);
206 
207         uint256 _pID = pIDxAddr_[_addr];
208         uint256 _affID;
209         if (_affCode != address(0) && _affCode != _addr) {
210             _affID = pIDxAddr_[_affCode];
211             if (_affID != plyr_[_pID].laff) {
212                 plyr_[_pID].laff = _affID;
213             }
214         }
215 
216         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
217     }
218 
219     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable isHuman {
220         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
221 
222         bytes32 _name = NameFilter.nameFilter(_nameString);
223 
224         address _addr = msg.sender;
225         bool _isNewPlayer = determinePID(_addr);
226 
227         uint256 _pID = pIDxAddr_[_addr];
228         uint256 _affID;
229         if (_affCode != "" && _affCode != _name) {
230             _affID = pIDxName_[_affCode];
231             if (_affID != plyr_[_pID].laff) {
232                 plyr_[_pID].laff = _affID;
233             }
234         }
235 
236         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
237     }
238 
239     function addMeToGame(uint256 _gameID) public isHuman {
240         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
241 
242         address _addr = msg.sender;
243         uint256 _pID = pIDxAddr_[_addr];
244         require(_pID != 0, "hey there buddy, you dont even have an account");
245 
246         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
247 
248         uint256 _totalNames = plyr_[_pID].names;
249         if (_totalNames > 1) {
250             for (uint256 ii = 1; ii <= _totalNames; ii++) {
251                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
252             }
253         }
254     }
255 
256     function addMeToAllGames() public isHuman {
257         address _addr = msg.sender;
258         uint256 _pID = pIDxAddr_[_addr];
259         require(_pID != 0, "hey there buddy, you dont even have an account");
260 
261         uint256 _laff = plyr_[_pID].laff;
262         uint256 _totalNames = plyr_[_pID].names;
263         bytes32 _name = plyr_[_pID].name;
264 
265         for (uint256 i = 1; i <= gID_; i++) {
266             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
267             if (_totalNames > 1) {
268                 for (uint256 ii = 1; ii <= _totalNames; ii++) {
269                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
270                 }
271             }
272         }
273     }
274 
275     function useMyOldName(string _nameString) isHuman public {
276         bytes32 _name = _nameString.nameFilter();
277         uint256 _pID = pIDxAddr_[msg.sender];
278 
279         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
280 
281         plyr_[_pID].name = _name;
282     }
283 
284     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all) private {
285         if (pIDxName_[_name] != 0) {
286             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
287         }
288 
289         plyr_[_pID].name = _name;
290         pIDxName_[_name] = _pID;
291         if (plyrNames_[_pID][_name] == false) {
292             plyrNames_[_pID][_name] = true;
293             plyr_[_pID].names++;
294             plyrNameList_[_pID][plyr_[_pID].names] = _name;
295         }
296 
297         partnership.deposit.value(address(this).balance)();
298 
299         if (_all == true) {
300             for (uint256 i = 1; i <= gID_; i++) {
301                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
302             }
303         }
304 
305         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
306     }
307 
308     function determinePID(address _addr) private returns (bool) {
309         if (pIDxAddr_[_addr] == 0) {
310             pID_++;
311             pIDxAddr_[_addr] = pID_;
312             plyr_[pID_].addr = _addr;
313             return true;
314         }
315 
316         return false;
317     }
318 
319     function getPlayerID(address _addr) external isRegisteredGame returns (uint256) {
320         determinePID(_addr);
321         return (pIDxAddr_[_addr]);
322     }
323 
324     function getPlayerName(uint256 _pID) external view returns (bytes32) {
325         return (plyr_[_pID].name);
326     }
327 
328     function getPlayerLAff(uint256 _pID) external view returns (uint256) {
329         return (plyr_[_pID].laff);
330     }
331 
332     function getPlayerAddr(uint256 _pID) external view returns (address) {
333         return (plyr_[_pID].addr);
334     }
335 
336     function getNameFee() external view returns (uint256) {
337         return(registrationFee_);
338     }
339 
340     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
341         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
342 
343         bool _isNewPlayer = determinePID(_addr);
344 
345         uint256 _pID = pIDxAddr_[_addr];
346 
347         uint256 _affID = _affCode;
348         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) {
349             plyr_[_pID].laff = _affID;
350         } else if (_affID == _pID) {
351             _affID = 0;
352         }
353 
354         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
355 
356         return(_isNewPlayer, _affID);
357     }
358 
359     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
360         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
361 
362         bool _isNewPlayer = determinePID(_addr);
363 
364         uint256 _pID = pIDxAddr_[_addr];
365 
366         uint256 _affID;
367         if (_affCode != address(0) && _affCode != _addr) {
368             _affID = pIDxAddr_[_affCode];
369 
370             if (_affID != plyr_[_pID].laff) {
371                 plyr_[_pID].laff = _affID;
372             }
373         }
374 
375         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
376 
377         return(_isNewPlayer, _affID);
378     }
379 
380     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
381         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
382 
383         bool _isNewPlayer = determinePID(_addr);
384 
385         uint256 _pID = pIDxAddr_[_addr];
386 
387         uint256 _affID;
388         if (_affCode != "" && _affCode != _name) {
389             _affID = pIDxName_[_affCode];
390 
391             if (_affID != plyr_[_pID].laff) {
392                 plyr_[_pID].laff = _affID;
393             }
394         }
395 
396         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
397 
398         return(_isNewPlayer, _affID);
399     }
400 
401     function addGame(address _gameAddress, string _gameNameStr) public onlyOwner {
402         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
403 
404         gID_++;
405         bytes32 _name = _gameNameStr.nameFilter();
406         gameIDs_[_gameAddress] = gID_;
407         gameNames_[_gameAddress] = _name;
408         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
409 
410         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
411     }
412 
413     function setRegistrationFee(uint256 _fee) public onlyOwner {
414         registrationFee_ = _fee;
415     }
416 }