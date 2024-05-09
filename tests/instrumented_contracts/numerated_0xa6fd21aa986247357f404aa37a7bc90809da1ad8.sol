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
43         uint256 _codeLength;
44         
45         assembly {_codeLength := extcodesize(_addr)}
46         require(_codeLength == 0, "Not Human");
47         _;
48     }
49     
50     modifier isRegisteredGame()
51     {
52         require(gameIDs_[msg.sender] != 0);
53         _;
54     }
55 
56     event onNewName
57     (
58         uint256 indexed playerID,
59         address indexed playerAddress,
60         bytes32 indexed playerName,
61         bool isNewPlayer,
62         uint256 affiliateID,
63         address affiliateAddress,
64         bytes32 affiliateName,
65         uint256 amountPaid,
66         uint256 timeStamp
67     );
68 
69     function checkIfNameValid(string _nameStr)
70         public
71         view
72         returns(bool)
73     {
74         bytes32 _name = _nameStr.nameFilter();
75         if (pIDxName_[_name] == 0)
76             return (true);
77         else 
78             return (false);
79     }
80 
81     function modCEOAddress(address newCEO) 
82         isHuman() 
83         public
84     {
85         require(address(0) != newCEO, "CEO Can not be 0");
86         require(ceo == msg.sender, "only  ceo can modify ceo");
87         ceo = newCEO;
88     }
89 
90     function modCFOAddress(address newCFO) 
91         isHuman() 
92         public
93     {
94         require(address(0) != newCFO, "CFO Can not be 0");
95         require(cfo == msg.sender, "only cfo can modify cfo");
96         cfo = newCFO;
97     } 
98 
99     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
100         isHuman()
101         public
102         payable 
103     {
104         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
105         
106         bytes32 _name = NameFilter.nameFilter(_nameString);
107         address _addr = msg.sender;
108         bool _isNewPlayer = determinePID(_addr);
109         uint256 _pID = pIDxAddr_[_addr];
110         
111         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
112         {
113             plyr_[_pID].laff = _affCode;
114         } else if (_affCode == _pID) {
115             _affCode = 0;
116         }
117         
118         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
119     }
120     
121     function registerNameXaddr(string _nameString, address _affCode, bool _all)
122         isHuman()
123         public
124         payable 
125     {
126         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
127         bytes32 _name = NameFilter.nameFilter(_nameString);
128         address _addr = msg.sender;
129         bool _isNewPlayer = determinePID(_addr);
130         uint256 _pID = pIDxAddr_[_addr];
131         
132         uint256 _affID;
133         if (_affCode != address(0) && _affCode != _addr)
134         {
135             _affID = pIDxAddr_[_affCode];
136             if (_affID != plyr_[_pID].laff)
137             {
138                 plyr_[_pID].laff = _affID;
139             }
140         }
141 
142         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
143     }
144     
145     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
146         isHuman()
147         public
148         payable 
149     {
150         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
151         bytes32 _name = NameFilter.nameFilter(_nameString);
152         address _addr = msg.sender;
153         bool _isNewPlayer = determinePID(_addr);
154         uint256 _pID = pIDxAddr_[_addr];
155         
156         uint256 _affID;
157         if (_affCode != "" && _affCode != _name)
158         {
159             _affID = pIDxName_[_affCode];
160             if (_affID != plyr_[_pID].laff)
161             {
162                 plyr_[_pID].laff = _affID;
163             }
164         } 
165         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
166     }
167     
168     function addMeToGame(uint256 _gameID)
169         isHuman()
170         public
171     {
172         require(_gameID <= gID_, "Game Not Exist");
173         address _addr = msg.sender;
174         uint256 _pID = pIDxAddr_[_addr];
175         require(_pID != 0, "Player Not Found");
176         uint256 _totalNames = plyr_[_pID].names;
177         
178         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
179         
180         if (_totalNames > 1)
181             for (uint256 ii = 1; ii <= _totalNames; ii++)
182                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
183     }
184 
185     function addMeToAllGames()
186         isHuman()
187         public
188     {
189         address _addr = msg.sender;
190         uint256 _pID = pIDxAddr_[_addr];
191         require(_pID != 0, "Player Not Found");
192         uint256 _laff = plyr_[_pID].laff;
193         uint256 _totalNames = plyr_[_pID].names;
194         bytes32 _name = plyr_[_pID].name;
195         
196         for (uint256 i = 1; i <= gID_; i++)
197         {
198             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
199             if (_totalNames > 1)
200                 for (uint256 ii = 1; ii <= _totalNames; ii++)
201                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
202         }
203                 
204     }
205     
206     function useMyOldName(string _nameString)
207         isHuman()
208         public 
209     {
210         bytes32 _name = _nameString.nameFilter();
211         uint256 _pID = pIDxAddr_[msg.sender];
212         
213         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
214         
215         plyr_[_pID].name = _name;
216     }
217    
218     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
219         private
220     {
221         if (pIDxName_[_name] != 0)
222             require(plyrNames_[_pID][_name] == true, "Name Already Exist!");
223         
224         plyr_[_pID].name = _name;
225         pIDxName_[_name] = _pID;
226         if (plyrNames_[_pID][_name] == false)
227         {
228             plyrNames_[_pID][_name] = true;
229             plyr_[_pID].names++;
230             plyrNameList_[_pID][plyr_[_pID].names] = _name;
231         }
232         
233         cfo.transfer(address(this).balance);
234         
235         if (_all == true)
236             for (uint256 i = 1; i <= gID_; i++)
237                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
238         
239         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
240     }
241   
242     function determinePID(address _addr)
243         private
244         returns (bool)
245     {
246         if (pIDxAddr_[_addr] == 0)
247         {
248             pID_++;
249             pIDxAddr_[_addr] = pID_;
250             plyr_[pID_].addr = _addr;
251             return (true);
252         } else {
253             return (false);
254         }
255     }
256 
257     function getPlayerID(address _addr)
258         isRegisteredGame()
259         external
260         returns (uint256)
261     {
262         determinePID(_addr);
263         return (pIDxAddr_[_addr]);
264     }
265 
266     function getPlayerName(uint256 _pID)
267         external
268         view
269         returns (bytes32)
270     {
271         return (plyr_[_pID].name);
272     }
273 
274     function getPlayerLAff(uint256 _pID)
275         external
276         view
277         returns (uint256)
278     {
279         return (plyr_[_pID].laff);
280     }
281 
282     function getPlayerAddr(uint256 _pID)
283         external
284         view
285         returns (address)
286     {
287         return (plyr_[_pID].addr);
288     }
289 
290     function getNameFee()
291         external
292         view
293         returns (uint256)
294     {
295         return(registrationFee_);
296     }
297 
298     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
299         isRegisteredGame()
300         external
301         payable
302         returns(bool, uint256)
303     {
304         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
305         
306         bool _isNewPlayer = determinePID(_addr);
307         uint256 _pID = pIDxAddr_[_addr];
308         
309         uint256 _affID = _affCode;
310         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
311         {
312             plyr_[_pID].laff = _affID;
313         } 
314         else if (_affID == _pID) 
315         {
316             _affID = 0;
317         }
318 
319         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
320         
321         return(_isNewPlayer, _affID);
322     }
323     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
324         isRegisteredGame()
325         external
326         payable
327         returns(bool, uint256)
328     {
329         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
330         
331         bool _isNewPlayer = determinePID(_addr);
332         uint256 _pID = pIDxAddr_[_addr];
333         
334         uint256 _affID;
335         if (_affCode != address(0) && _affCode != _addr)
336         {
337             _affID = pIDxAddr_[_affCode];
338             if (_affID != plyr_[_pID].laff)
339             {
340                 plyr_[_pID].laff = _affID;
341             }
342         }
343         
344         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
345         
346         return(_isNewPlayer, _affID);
347     }
348     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
349         isRegisteredGame()
350         external
351         payable
352         returns(bool, uint256)
353     {
354         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
355         bool _isNewPlayer = determinePID(_addr);
356         uint256 _pID = pIDxAddr_[_addr];
357         
358         uint256 _affID;
359         if (_affCode != "" && _affCode != _name)
360         {
361             _affID = pIDxName_[_affCode];
362             if (_affID != plyr_[_pID].laff)
363             {
364                 plyr_[_pID].laff = _affID;
365             }
366         }
367         
368         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
369         
370         return(_isNewPlayer, _affID);
371     }
372     
373     function addGame(address _gameAddress, string _gameNameStr)
374         public
375     {
376         require(ceo == msg.sender, "ONLY ceo CAN add game");
377         require(gameIDs_[_gameAddress] == 0, "Game Already Registered!");
378         
379         gID_++;
380         bytes32 _name = _gameNameStr.nameFilter();
381         gameIDs_[_gameAddress] = gID_;
382         gameNames_[_gameAddress] = _name;
383         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
384     }
385     
386     function setRegistrationFee(uint256 _fee)
387         public
388     {
389         require(ceo == msg.sender, "ONLY ceo CAN add game");
390         registrationFee_ = _fee;
391     }
392         
393 } 
394 
395 library NameFilter {
396     function nameFilter(string _input)
397         internal
398         pure
399         returns(bytes32)
400     {
401         bytes memory _temp = bytes(_input);
402         uint256 _length = _temp.length;
403         
404         require (_length <= 32 && _length > 0, "Invalid Length");
405         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "Can NOT start with SPACE");
406         if (_temp[0] == 0x30)
407         {
408             require(_temp[1] != 0x78, "CAN NOT Start With 0x");
409             require(_temp[1] != 0x58, "CAN NOT Start With 0X");
410         }
411         
412         bool _hasNonNumber;
413         
414         for (uint256 i = 0; i < _length; i++)
415         {
416             // 小写转大写
417             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
418             {
419                 _temp[i] = byte(uint(_temp[i]) + 32);
420                 if (_hasNonNumber == false)
421                     _hasNonNumber = true;
422             } else {
423                 require
424                 (
425                     _temp[i] == 0x20 ||
426                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
427                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
428                     "Include Illegal characters"
429                 );
430                 
431                 if (_temp[i] == 0x20)
432                     require( _temp[i+1] != 0x20, "ONLY One Space Allowed");
433                 
434                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
435                     _hasNonNumber = true;    
436             }
437         }
438         
439         require(_hasNonNumber == true, "All Numbers Not Allowed");
440         
441         bytes32 _ret;
442         assembly {
443             _ret := mload(add(_temp, 32))
444         }
445         return (_ret);
446     }
447 }
448 
449 library SafeMath {
450     function add(uint256 a, uint256 b)
451         internal
452         pure
453         returns (uint256 c) 
454     {
455         c = a + b;
456         require(c >= a, "Add Failed");
457         return c;
458     }
459 }