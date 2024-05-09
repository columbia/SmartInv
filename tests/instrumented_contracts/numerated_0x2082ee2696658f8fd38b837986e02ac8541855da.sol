1 pragma solidity ^0.4.24;
2 
3 interface FoundationInterface {
4     function deposit() external payable;
5 }
6 
7 interface PlayerBookReceiverInterface {
8     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
9     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
10 }
11 
12 contract Ownable {
13     address public owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     modifier onlyOwner() {
22         require(msg.sender == owner, "You are not owner.");
23         _;
24     }
25 
26     function transferOwnership(address _newOwner) public onlyOwner {
27         require(_newOwner != address(0), "Invalid address.");
28 
29         owner = _newOwner;
30 
31         emit OwnershipTransferred(owner, _newOwner);
32     }
33 }
34 
35 contract PlayerBook is Ownable {
36     using SafeMath for uint256;
37     using NameFilter for string;
38 
39     FoundationInterface private foundation = FoundationInterface(0x2Ad0EbB0FFa7A9c698Ae7F1d23BD7d86FF0ae386);
40 
41     uint256 public registrationFee_ = 10 finney;
42     mapping(uint256 => PlayerBookReceiverInterface) public games_;
43     mapping(address => bytes32) public gameNames_;
44     mapping(address => uint256) public gameIDs_;
45 
46     uint256 public gID_;
47     uint256 public pID_;
48     mapping (address => uint256) public pIDxAddr_;
49     mapping (bytes32 => uint256) public pIDxName_;
50 
51     struct Player {
52         address addr;
53         bytes32 name;
54         uint256 laff;
55         uint256 names;
56     }
57 
58     mapping (uint256 => Player) public plyr_;
59     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
60     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_;
61 
62     event onNewName(
63         uint256 indexed playerID,
64         address indexed playerAddress,
65         bytes32 indexed playerName,
66         bool isNewPlayer,
67         uint256 affiliateID,
68         address affiliateAddress,
69         bytes32 affiliateName,
70         uint256 amountPaid,
71         uint256 timeStamp
72     );
73 
74     modifier isHuman() {
75         address _addr = msg.sender;
76         uint256 _codeLength;
77 
78         assembly {
79             _codeLength := extcodesize(_addr)
80         }
81 
82         require(_codeLength == 0, "sorry humans only");
83         _;
84     }
85 
86     modifier isRegisteredGame() {
87         require(gameIDs_[msg.sender] != 0);
88         _;
89     }
90 
91     constructor() public {
92         plyr_[1].addr = 0xC464F4001C76558AD802bBA405A9E0658dcb1F75;
93         plyr_[1].name = "asia";
94         plyr_[1].names = 1;
95         pIDxAddr_[0xC464F4001C76558AD802bBA405A9E0658dcb1F75] = 1;
96         pIDxName_["asia"] = 1;
97         plyrNames_[1]["asia"] = true;
98         plyrNameList_[1][1] = "asia";
99 
100         pID_ = 1;
101     }
102 
103     function setFoundationInterface(address _who) public onlyOwner {
104         foundation = FoundationInterface(_who);
105     }
106 
107     function checkIfNameValid(string _nameStr) public view returns(bool) {
108         bytes32 _name = _nameStr.nameFilter();
109         if (pIDxName_[_name] == 0) {
110             return (true);
111         } else {
112             return (false);
113         }
114     }
115 
116     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable isHuman {
117         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
118 
119         bytes32 _name = NameFilter.nameFilter(_nameString);
120         address _addr = msg.sender;
121 
122         bool _isNewPlayer = determinePID(_addr);
123 
124         uint256 _pID = pIDxAddr_[_addr];
125 
126         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) {
127             plyr_[_pID].laff = _affCode;
128         } else if (_affCode == _pID) {
129             _affCode = 0;
130         }
131 
132         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
133     }
134 
135     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable isHuman {
136         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
137 
138         bytes32 _name = NameFilter.nameFilter(_nameString);
139         address _addr = msg.sender;
140 
141         bool _isNewPlayer = determinePID(_addr);
142 
143         uint256 _pID = pIDxAddr_[_addr];
144 
145         uint256 _affID;
146         if (_affCode != address(0) && _affCode != _addr) {
147             _affID = pIDxAddr_[_affCode];
148             if (_affID != plyr_[_pID].laff) {
149                 plyr_[_pID].laff = _affID;
150             }
151         }
152 
153         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
154     }
155 
156     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable isHuman {
157         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
158 
159         bytes32 _name = NameFilter.nameFilter(_nameString);
160         address _addr = msg.sender;
161 
162         bool _isNewPlayer = determinePID(_addr);
163 
164         uint256 _pID = pIDxAddr_[_addr];
165 
166         uint256 _affID;
167         if (_affCode != "" && _affCode != _name) {
168             _affID = pIDxName_[_affCode];
169             if (_affID != plyr_[_pID].laff) {
170                 plyr_[_pID].laff = _affID;
171             }
172         }
173 
174         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
175     }
176 
177     function addMeToGame(uint256 _gameID) public isHuman {
178         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
179 
180         address _addr = msg.sender;
181 
182         uint256 _pID = pIDxAddr_[_addr];
183         require(_pID != 0, "hey there buddy, you dont even have an account");
184 
185         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
186 
187         uint256 _totalNames = plyr_[_pID].names;
188         if (_totalNames > 1) {
189             for (uint256 ii = 1; ii <= _totalNames; ii++) {
190                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
191             }
192         }
193     }
194 
195     function addMeToAllGames() public isHuman {
196         address _addr = msg.sender;
197 
198         uint256 _pID = pIDxAddr_[_addr];
199         require(_pID != 0, "hey there buddy, you dont even have an account");
200 
201         uint256 _laff = plyr_[_pID].laff;
202         uint256 _totalNames = plyr_[_pID].names;
203         bytes32 _name = plyr_[_pID].name;
204 
205         for (uint256 i = 1; i <= gID_; i++) {
206             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
207             if (_totalNames > 1) {
208                 for (uint256 ii = 1; ii <= _totalNames; ii++) {
209                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
210                 }
211             }
212         }
213     }
214 
215     function useMyOldName(string _nameString) public isHuman {
216         bytes32 _name = _nameString.nameFilter();
217         uint256 _pID = pIDxAddr_[msg.sender];
218 
219         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
220 
221         plyr_[_pID].name = _name;
222     }
223 
224     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all) private {
225         if (pIDxName_[_name] != 0) {
226             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
227         }
228 
229         plyr_[_pID].name = _name;
230         pIDxName_[_name] = _pID;
231         if (plyrNames_[_pID][_name] == false) {
232             plyrNames_[_pID][_name] = true;
233             plyr_[_pID].names++;
234             plyrNameList_[_pID][plyr_[_pID].names] = _name;
235         }
236 
237         foundation.deposit.value(address(this).balance)();
238 
239         if (_all == true) {
240             for (uint256 i = 1; i <= gID_; i++) {
241                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
242             }
243         }
244 
245         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
246     }
247 
248     function determinePID(address _addr) private returns (bool) {
249         if (pIDxAddr_[_addr] == 0) {
250             pID_++;
251             pIDxAddr_[_addr] = pID_;
252             plyr_[pID_].addr = _addr;
253 
254             return (true);
255         } else {
256             return (false);
257         }
258     }
259 
260     function getPlayerID(address _addr) external isRegisteredGame returns (uint256) {
261         determinePID(_addr);
262 
263         return (pIDxAddr_[_addr]);
264     }
265 
266     function getPlayerName(uint256 _pID) external view returns (bytes32) {
267         return (plyr_[_pID].name);
268     }
269 
270     function getPlayerLAff(uint256 _pID) external view returns (uint256) {
271         return (plyr_[_pID].laff);
272     }
273 
274     function getPlayerAddr(uint256 _pID) external view returns (address) {
275         return (plyr_[_pID].addr);
276     }
277 
278     function getNameFee() external view returns (uint256) {
279         return(registrationFee_);
280     }
281 
282     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
283         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
284 
285         bool _isNewPlayer = determinePID(_addr);
286 
287         uint256 _pID = pIDxAddr_[_addr];
288 
289         uint256 _affID = _affCode;
290         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) {
291             plyr_[_pID].laff = _affID;
292         } else if (_affID == _pID) {
293             _affID = 0;
294         }
295 
296         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
297 
298         return(_isNewPlayer, _affID);
299     }
300 
301     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
302         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
303 
304         bool _isNewPlayer = determinePID(_addr);
305 
306         uint256 _pID = pIDxAddr_[_addr];
307 
308         uint256 _affID;
309         if (_affCode != address(0) && _affCode != _addr) {
310             _affID = pIDxAddr_[_affCode];
311             if (_affID != plyr_[_pID].laff) {
312                 plyr_[_pID].laff = _affID;
313             }
314         }
315 
316         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
317 
318         return(_isNewPlayer, _affID);
319     }
320 
321     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
322         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
323 
324         bool _isNewPlayer = determinePID(_addr);
325 
326         uint256 _pID = pIDxAddr_[_addr];
327 
328         uint256 _affID;
329         if (_affCode != "" && _affCode != _name) {
330             _affID = pIDxName_[_affCode];
331             if (_affID != plyr_[_pID].laff) {
332                 plyr_[_pID].laff = _affID;
333             }
334         }
335 
336         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
337 
338         return(_isNewPlayer, _affID);
339     }
340 
341     function addGame(address _gameAddress, string _gameNameStr) public onlyOwner {
342         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
343 
344         gID_++;
345         bytes32 _name = _gameNameStr.nameFilter();
346         gameIDs_[_gameAddress] = gID_;
347         gameNames_[_gameAddress] = _name;
348         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
349 
350         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
351     }
352 
353     function setRegistrationFee(uint256 _fee) public onlyOwner {
354         registrationFee_ = _fee;
355     }
356 }
357 
358 library NameFilter {
359     function nameFilter(string _input) internal pure returns(bytes32) {
360         bytes memory _temp = bytes(_input);
361         uint256 _length = _temp.length;
362 
363         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
364 
365         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
366         if (_temp[0] == 0x30) {
367             require(_temp[1] != 0x78, "string cannot start with 0x");
368             require(_temp[1] != 0x58, "string cannot start with 0X");
369         }
370 
371         bool _hasNonNumber;
372 
373         for (uint256 i = 0; i < _length; i++) {
374             if (_temp[i] > 0x40 && _temp[i] < 0x5b) {
375                 _temp[i] = byte(uint(_temp[i]) + 32);
376                 if (_hasNonNumber == false) {
377                     _hasNonNumber = true;
378                 }
379             } else {
380                 require(_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
381                 if (_temp[i] == 0x20) {
382                     require( _temp[i + 1] != 0x20, "string cannot contain consecutive spaces");
383                 }
384                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39)) {
385                     _hasNonNumber = true;
386                 }
387             }
388         }
389 
390         require(_hasNonNumber == true, "string cannot be only numbers");
391 
392         bytes32 _ret;
393         assembly {
394             _ret := mload(add(_temp, 32))
395         }
396         return (_ret);
397     }
398 }
399 
400 library SafeMath {
401     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
402         c = a + b;
403         require(c >= a, "SafeMath add failed");
404         return c;
405     }
406 }