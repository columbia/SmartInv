1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookReceiverInterface {
4     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
5     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
6 }
7 
8 contract PlayerBook {
9     using NameFilter for string;
10     using SafeMath for uint256;
11     
12     address public ceo;
13     address public cfo;
14     
15     uint256 public registrationFee_ = 10 finney;            // 0.01 ETH 注册一个帐号
16     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
17     mapping(address => bytes32) public gameNames_;          // lookup a games name
18     mapping(address => uint256) public gameIDs_;            // lokup a games ID
19     uint256 public gID_;        // total number of games
20     uint256 public pID_;        // total number of players
21     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
22     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
23     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
24     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
25     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
26     struct Player {
27         address addr;
28         bytes32 name;
29         uint256 laff;
30         uint256 names;
31     }
32 
33     constructor()
34         public
35     {
36         ceo = msg.sender;
37         cfo = msg.sender;
38         pID_ = 0;
39     }
40 
41     modifier isHuman() {
42         address _addr = msg.sender;
43         require (_addr == tx.origin);
44         uint256 _codeLength;
45         
46         assembly {_codeLength := extcodesize(_addr)}
47         require(_codeLength == 0, "Not Human");
48         _;
49     }
50     
51     modifier isRegisteredGame()
52     {
53         require(gameIDs_[msg.sender] != 0);
54         _;
55     }
56 
57     event onNewName
58     (
59         uint256 indexed playerID,
60         address indexed playerAddress,
61         bytes32 indexed playerName,
62         bool isNewPlayer,
63         uint256 affiliateID,
64         address affiliateAddress,
65         bytes32 affiliateName,
66         uint256 amountPaid,
67         uint256 timeStamp
68     );
69 
70     function checkIfNameValid(string _nameStr)
71         public
72         view
73         returns(bool)
74     {
75         bytes32 _name = _nameStr.nameFilter();
76         if (pIDxName_[_name] == 0)
77             return (true);
78         else 
79             return (false);
80     }
81 
82     function modCEOAddress(address newCEO) 
83         isHuman() 
84         public
85     {
86         require(address(0) != newCEO, "CEO Can not be 0");
87         require(ceo == msg.sender, "only  ceo can modify ceo");
88         ceo = newCEO;
89     }
90 
91     function modCFOAddress(address newCFO) 
92         isHuman() 
93         public
94     {
95         require(address(0) != newCFO, "CFO Can not be 0");
96         require(cfo == msg.sender, "only cfo can modify cfo");
97         cfo = newCFO;
98     } 
99 
100     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
101         isHuman()
102         public
103         payable 
104     {
105         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
106         
107         bytes32 _name = NameFilter.nameFilter(_nameString);
108         address _addr = msg.sender;
109         bool _isNewPlayer = determinePID(_addr);
110         uint256 _pID = pIDxAddr_[_addr];
111         
112         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
113         {
114             plyr_[_pID].laff = _affCode;
115         } else if (_affCode == _pID) {
116             _affCode = 0;
117         }
118         
119         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
120     }
121     
122     function registerNameXaddr(string _nameString, address _affCode, bool _all)
123         isHuman()
124         public
125         payable 
126     {
127         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
128         bytes32 _name = NameFilter.nameFilter(_nameString);
129         address _addr = msg.sender;
130         bool _isNewPlayer = determinePID(_addr);
131         uint256 _pID = pIDxAddr_[_addr];
132         
133         uint256 _affID;
134         if (_affCode != address(0) && _affCode != _addr)
135         {
136             _affID = pIDxAddr_[_affCode];
137             if (_affID != plyr_[_pID].laff)
138             {
139                 plyr_[_pID].laff = _affID;
140             }
141         }
142 
143         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
144     }
145     
146     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
147         isHuman()
148         public
149         payable 
150     {
151         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
152         bytes32 _name = NameFilter.nameFilter(_nameString);
153         address _addr = msg.sender;
154         bool _isNewPlayer = determinePID(_addr);
155         uint256 _pID = pIDxAddr_[_addr];
156         
157         uint256 _affID;
158         if (_affCode != "" && _affCode != _name)
159         {
160             _affID = pIDxName_[_affCode];
161             if (_affID != plyr_[_pID].laff)
162             {
163                 plyr_[_pID].laff = _affID;
164             }
165         } 
166         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
167     }
168     
169     function addMeToGame(uint256 _gameID)
170         isHuman()
171         public
172     {
173         require(_gameID <= gID_, "Game Not Exist");
174         address _addr = msg.sender;
175         uint256 _pID = pIDxAddr_[_addr];
176         require(_pID != 0, "Player Not Found");
177         uint256 _totalNames = plyr_[_pID].names;
178         
179         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
180         
181         if (_totalNames > 1)
182             for (uint256 ii = 1; ii <= _totalNames; ii++)
183                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
184     }
185 
186     function addMeToAllGames()
187         isHuman()
188         public
189     {
190         address _addr = msg.sender;
191         uint256 _pID = pIDxAddr_[_addr];
192         require(_pID != 0, "Player Not Found");
193         uint256 _laff = plyr_[_pID].laff;
194         uint256 _totalNames = plyr_[_pID].names;
195         bytes32 _name = plyr_[_pID].name;
196         
197         for (uint256 i = 1; i <= gID_; i++)
198         {
199             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
200             if (_totalNames > 1)
201                 for (uint256 ii = 1; ii <= _totalNames; ii++)
202                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
203         }
204                 
205     }
206     
207     function useMyOldName(string _nameString)
208         isHuman()
209         public 
210     {
211         bytes32 _name = _nameString.nameFilter();
212         uint256 _pID = pIDxAddr_[msg.sender];
213         
214         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
215         
216         plyr_[_pID].name = _name;
217     }
218    
219     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
220         private
221     {
222         if (pIDxName_[_name] != 0)
223             require(plyrNames_[_pID][_name] == true, "Name Already Exist!");
224         
225         plyr_[_pID].name = _name;
226         pIDxName_[_name] = _pID;
227         if (plyrNames_[_pID][_name] == false)
228         {
229             plyrNames_[_pID][_name] = true;
230             plyr_[_pID].names++;
231             plyrNameList_[_pID][plyr_[_pID].names] = _name;
232         }
233         
234         cfo.transfer(address(this).balance);
235         
236         if (_all == true)
237             for (uint256 i = 1; i <= gID_; i++)
238                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
239         
240         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
241     }
242   
243     function determinePID(address _addr)
244         private
245         returns (bool)
246     {
247         if (pIDxAddr_[_addr] == 0)
248         {
249             pID_++;
250             pIDxAddr_[_addr] = pID_;
251             plyr_[pID_].addr = _addr;
252             return (true);
253         } else {
254             return (false);
255         }
256     }
257 
258     function getPlayerID(address _addr)
259         isRegisteredGame()
260         external
261         returns (uint256)
262     {
263         determinePID(_addr);
264         return (pIDxAddr_[_addr]);
265     }
266 
267     function getPlayerName(uint256 _pID)
268         external
269         view
270         returns (bytes32)
271     {
272         return (plyr_[_pID].name);
273     }
274 
275     function getPlayerLAff(uint256 _pID)
276         external
277         view
278         returns (uint256)
279     {
280         return (plyr_[_pID].laff);
281     }
282 
283     function getPlayerAddr(uint256 _pID)
284         external
285         view
286         returns (address)
287     {
288         return (plyr_[_pID].addr);
289     }
290 
291     function getNameFee()
292         external
293         view
294         returns (uint256)
295     {
296         return(registrationFee_);
297     }
298 
299     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
300         isRegisteredGame()
301         external
302         payable
303         returns(bool, uint256)
304     {
305         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
306         
307         bool _isNewPlayer = determinePID(_addr);
308         uint256 _pID = pIDxAddr_[_addr];
309         
310         uint256 _affID = _affCode;
311         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
312         {
313             plyr_[_pID].laff = _affID;
314         } 
315         else if (_affID == _pID) 
316         {
317             _affID = 0;
318         }
319 
320         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
321         
322         return(_isNewPlayer, _affID);
323     }
324     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
325         isRegisteredGame()
326         external
327         payable
328         returns(bool, uint256)
329     {
330         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
331         
332         bool _isNewPlayer = determinePID(_addr);
333         uint256 _pID = pIDxAddr_[_addr];
334         
335         uint256 _affID;
336         if (_affCode != address(0) && _affCode != _addr)
337         {
338             _affID = pIDxAddr_[_affCode];
339             if (_affID != plyr_[_pID].laff)
340             {
341                 plyr_[_pID].laff = _affID;
342             }
343         }
344         
345         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
346         
347         return(_isNewPlayer, _affID);
348     }
349     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
350         isRegisteredGame()
351         external
352         payable
353         returns(bool, uint256)
354     {
355         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
356         bool _isNewPlayer = determinePID(_addr);
357         uint256 _pID = pIDxAddr_[_addr];
358         
359         uint256 _affID;
360         if (_affCode != "" && _affCode != _name)
361         {
362             _affID = pIDxName_[_affCode];
363             if (_affID != plyr_[_pID].laff)
364             {
365                 plyr_[_pID].laff = _affID;
366             }
367         }
368         
369         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
370         
371         return(_isNewPlayer, _affID);
372     }
373     
374     function addGame(address _gameAddress, string _gameNameStr)
375         public
376     {
377         require(ceo == msg.sender, "ONLY ceo CAN add game");
378         require(gameIDs_[_gameAddress] == 0, "Game Already Registered!");
379         
380         gID_++;
381         bytes32 _name = _gameNameStr.nameFilter();
382         gameIDs_[_gameAddress] = gID_;
383         gameNames_[_gameAddress] = _name;
384         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
385     }
386     
387     function setRegistrationFee(uint256 _fee)
388         public
389     {
390         require(ceo == msg.sender, "ONLY ceo CAN add game");
391         registrationFee_ = _fee;
392     }
393         
394 } 
395 
396 library NameFilter {
397     function nameFilter(string _input)
398         internal
399         pure
400         returns(bytes32)
401     {
402         bytes memory _temp = bytes(_input);
403         uint256 _length = _temp.length;
404         
405         require (_length <= 32 && _length > 0, "Invalid Length");
406         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "Can NOT start with SPACE");
407         if (_temp[0] == 0x30)
408         {
409             require(_temp[1] != 0x78, "CAN NOT Start With 0x");
410             require(_temp[1] != 0x58, "CAN NOT Start With 0X");
411         }
412         
413         bool _hasNonNumber;
414         
415         for (uint256 i = 0; i < _length; i++)
416         {
417             // 小写转大写
418             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
419             {
420                 _temp[i] = byte(uint(_temp[i]) + 32);
421                 if (_hasNonNumber == false)
422                     _hasNonNumber = true;
423             } else {
424                 require
425                 (
426                     _temp[i] == 0x20 ||
427                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
428                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
429                     "Include Illegal characters"
430                 );
431                 
432                 if (_temp[i] == 0x20)
433                     require( _temp[i+1] != 0x20, "ONLY One Space Allowed");
434                 
435                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
436                     _hasNonNumber = true;    
437             }
438         }
439         
440         require(_hasNonNumber == true, "All Numbers Not Allowed");
441         
442         bytes32 _ret;
443         assembly {
444             _ret := mload(add(_temp, 32))
445         }
446         return (_ret);
447     }
448 }
449 
450 library SafeMath {
451     function add(uint256 a, uint256 b)
452         internal
453         pure
454         returns (uint256 c) 
455     {
456         c = a + b;
457         require(c >= a, "Add Failed");
458         return c;
459     }
460 }