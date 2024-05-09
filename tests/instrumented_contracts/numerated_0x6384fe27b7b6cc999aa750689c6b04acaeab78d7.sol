1 pragma solidity ^0.4.24;
2 
3 interface FoundationInterface {
4     function deposit() external payable returns(bool);
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
39     FoundationInterface private foundation;
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
92         foundation = FoundationInterface(0xC00C9ed7f35Ca2373462FD46d672084a6a128E2B);
93 
94         plyr_[1].addr = 0xC464F4001C76558AD802bBA405A9E0658dcb1F75;
95         plyr_[1].name = "asia";
96         plyr_[1].names = 1;
97         pIDxAddr_[0xC464F4001C76558AD802bBA405A9E0658dcb1F75] = 1;
98         pIDxName_["asia"] = 1;
99         plyrNames_[1]["asia"] = true;
100         plyrNameList_[1][1] = "asia";
101 
102         pID_ = 1;
103     }
104 
105     function setFoundationInterface(address _who) public onlyOwner {
106         foundation = FoundationInterface(_who);
107     }
108 
109     function checkIfNameValid(string _nameStr) public view returns(bool) {
110         bytes32 _name = _nameStr.nameFilter();
111         if (pIDxName_[_name] == 0) {
112             return (true);
113         } else {
114             return (false);
115         }
116     }
117 
118     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable isHuman {
119         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
120 
121         bytes32 _name = NameFilter.nameFilter(_nameString);
122         address _addr = msg.sender;
123 
124         bool _isNewPlayer = determinePID(_addr);
125 
126         uint256 _pID = pIDxAddr_[_addr];
127 
128         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) {
129             plyr_[_pID].laff = _affCode;
130         } else if (_affCode == _pID) {
131             _affCode = 0;
132         }
133 
134         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
135     }
136 
137     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable isHuman {
138         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
139 
140         bytes32 _name = NameFilter.nameFilter(_nameString);
141         address _addr = msg.sender;
142 
143         bool _isNewPlayer = determinePID(_addr);
144 
145         uint256 _pID = pIDxAddr_[_addr];
146 
147         uint256 _affID;
148         if (_affCode != address(0) && _affCode != _addr) {
149             _affID = pIDxAddr_[_affCode];
150             if (_affID != plyr_[_pID].laff) {
151                 plyr_[_pID].laff = _affID;
152             }
153         }
154 
155         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
156     }
157 
158     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable isHuman {
159         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
160 
161         bytes32 _name = NameFilter.nameFilter(_nameString);
162         address _addr = msg.sender;
163 
164         bool _isNewPlayer = determinePID(_addr);
165 
166         uint256 _pID = pIDxAddr_[_addr];
167 
168         uint256 _affID;
169         if (_affCode != "" && _affCode != _name) {
170             _affID = pIDxName_[_affCode];
171             if (_affID != plyr_[_pID].laff) {
172                 plyr_[_pID].laff = _affID;
173             }
174         }
175 
176         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
177     }
178 
179     function addMeToGame(uint256 _gameID) public isHuman {
180         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
181 
182         address _addr = msg.sender;
183 
184         uint256 _pID = pIDxAddr_[_addr];
185         require(_pID != 0, "hey there buddy, you dont even have an account");
186 
187         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
188 
189         uint256 _totalNames = plyr_[_pID].names;
190         if (_totalNames > 1) {
191             for (uint256 ii = 1; ii <= _totalNames; ii++) {
192                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
193             }
194         }
195     }
196 
197     function addMeToAllGames() public isHuman {
198         address _addr = msg.sender;
199 
200         uint256 _pID = pIDxAddr_[_addr];
201         require(_pID != 0, "hey there buddy, you dont even have an account");
202 
203         uint256 _laff = plyr_[_pID].laff;
204         uint256 _totalNames = plyr_[_pID].names;
205         bytes32 _name = plyr_[_pID].name;
206 
207         for (uint256 i = 1; i <= gID_; i++) {
208             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
209             if (_totalNames > 1) {
210                 for (uint256 ii = 1; ii <= _totalNames; ii++) {
211                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
212                 }
213             }
214         }
215 
216     }
217 
218     function useMyOldName(string _nameString) public isHuman {
219         bytes32 _name = _nameString.nameFilter();
220         uint256 _pID = pIDxAddr_[msg.sender];
221 
222         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
223 
224         plyr_[_pID].name = _name;
225     }
226 
227     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all) private {
228         if (pIDxName_[_name] != 0) {
229             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
230         }
231 
232         plyr_[_pID].name = _name;
233         pIDxName_[_name] = _pID;
234         if (plyrNames_[_pID][_name] == false) {
235             plyrNames_[_pID][_name] = true;
236             plyr_[_pID].names++;
237             plyrNameList_[_pID][plyr_[_pID].names] = _name;
238         }
239 
240         foundation.deposit.value(address(this).balance)();
241 
242         if (_all == true) {
243             for (uint256 i = 1; i <= gID_; i++) {
244                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
245             }
246         }
247 
248         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
249     }
250 
251     function determinePID(address _addr) private returns (bool) {
252         if (pIDxAddr_[_addr] == 0) {
253             pID_++;
254             pIDxAddr_[_addr] = pID_;
255             plyr_[pID_].addr = _addr;
256 
257             return (true);
258         } else {
259             return (false);
260         }
261     }
262 
263     function getPlayerID(address _addr) external isRegisteredGame returns (uint256) {
264         determinePID(_addr);
265 
266         return (pIDxAddr_[_addr]);
267     }
268 
269     function getPlayerName(uint256 _pID) external view returns (bytes32) {
270         return (plyr_[_pID].name);
271     }
272 
273     function getPlayerLAff(uint256 _pID) external view returns (uint256) {
274         return (plyr_[_pID].laff);
275     }
276 
277     function getPlayerAddr(uint256 _pID) external view returns (address) {
278         return (plyr_[_pID].addr);
279     }
280 
281     function getNameFee() external view returns (uint256) {
282         return(registrationFee_);
283     }
284 
285     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
286         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
287 
288         bool _isNewPlayer = determinePID(_addr);
289 
290         uint256 _pID = pIDxAddr_[_addr];
291 
292         uint256 _affID = _affCode;
293         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) {
294             plyr_[_pID].laff = _affID;
295         } else if (_affID == _pID) {
296             _affID = 0;
297         }
298 
299         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
300 
301         return(_isNewPlayer, _affID);
302     }
303 
304     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
305         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
306 
307         bool _isNewPlayer = determinePID(_addr);
308 
309         uint256 _pID = pIDxAddr_[_addr];
310 
311         uint256 _affID;
312         if (_affCode != address(0) && _affCode != _addr) {
313             _affID = pIDxAddr_[_affCode];
314             if (_affID != plyr_[_pID].laff) {
315                 plyr_[_pID].laff = _affID;
316             }
317         }
318 
319         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
320 
321         return(_isNewPlayer, _affID);
322     }
323 
324     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable isRegisteredGame returns(bool, uint256) {
325         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
326 
327         bool _isNewPlayer = determinePID(_addr);
328 
329         uint256 _pID = pIDxAddr_[_addr];
330 
331         uint256 _affID;
332         if (_affCode != "" && _affCode != _name) {
333             _affID = pIDxName_[_affCode];
334             if (_affID != plyr_[_pID].laff) {
335                 plyr_[_pID].laff = _affID;
336             }
337         }
338 
339         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
340 
341         return(_isNewPlayer, _affID);
342     }
343 
344     function addGame(address _gameAddress, string _gameNameStr) public onlyOwner {
345         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
346 
347         gID_++;
348         bytes32 _name = _gameNameStr.nameFilter();
349         gameIDs_[_gameAddress] = gID_;
350         gameNames_[_gameAddress] = _name;
351         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
352 
353         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
354     }
355 
356     function setRegistrationFee(uint256 _fee) public onlyOwner {
357         registrationFee_ = _fee;
358     }
359 }
360 
361 library NameFilter {
362     function nameFilter(string _input) internal pure returns(bytes32) {
363         bytes memory _temp = bytes(_input);
364         uint256 _length = _temp.length;
365 
366         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
367 
368         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
369         if (_temp[0] == 0x30) {
370             require(_temp[1] != 0x78, "string cannot start with 0x");
371             require(_temp[1] != 0x58, "string cannot start with 0X");
372         }
373 
374         bool _hasNonNumber;
375 
376         for (uint256 i = 0; i < _length; i++) {
377             if (_temp[i] > 0x40 && _temp[i] < 0x5b) {
378                 _temp[i] = byte(uint(_temp[i]) + 32);
379                 if (_hasNonNumber == false) {
380                     _hasNonNumber = true;
381                 }
382             } else {
383                 require(_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
384                 if (_temp[i] == 0x20) {
385                     require( _temp[i + 1] != 0x20, "string cannot contain consecutive spaces");
386                 }
387                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39)) {
388                     _hasNonNumber = true;
389                 }
390             }
391         }
392 
393         require(_hasNonNumber == true, "string cannot be only numbers");
394 
395         bytes32 _ret;
396         assembly {
397             _ret := mload(add(_temp, 32))
398         }
399         return (_ret);
400     }
401 }
402 
403 library SafeMath {
404     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
405         c = a + b;
406         require(c >= a, "SafeMath add failed");
407         return c;
408     }
409 }