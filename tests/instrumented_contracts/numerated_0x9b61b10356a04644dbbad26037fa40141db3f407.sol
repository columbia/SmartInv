1 pragma solidity ^0.4.24;
2 
3 interface ExtSettingInterface {
4     function getExtra() external returns(uint256);
5     function getGap() external returns(uint256);
6     function setGap(uint256 _gap) external;
7 }
8 
9 interface FoundationInterface {
10     function deposit() external payable;
11 }
12 
13 interface PlayerBookInterface {
14     function getPlayerID(address _addr) external returns (uint256);
15     function getPlayerName(uint256 _pID) external view returns (bytes32);
16     function getPlayerLAff(uint256 _pID) external view returns (uint256);
17     function getPlayerAddr(uint256 _pID) external view returns (address);
18     function getNameFee() external view returns (uint256);
19     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
20     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
21     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
22 }
23 
24 contract Events {
25     event onNewName(
26         uint256 indexed playerID,
27         address indexed playerAddress,
28         bytes32 indexed playerName,
29         bool isNewPlayer,
30         uint256 affiliateID,
31         address affiliateAddress,
32         bytes32 affiliateName,
33         uint256 amountPaid,
34         uint256 timeStamp
35     );
36 
37     event onEndTx(
38         uint256 compressedData,
39         uint256 compressedIDs,
40         bytes32 playerName,
41         address playerAddress,
42         uint256 ethIn,
43         uint256 keysBought,
44         address winnerAddr,
45         bytes32 winnerName,
46         uint256 amountWon,
47         uint256 newPot,
48         uint256 genAmount,
49         uint256 potAmount,
50         uint256 airDropPot
51     );
52 
53     event onWithdraw(
54         uint256 indexed playerID,
55         address playerAddress,
56         bytes32 playerName,
57         uint256 ethOut,
58         uint256 timeStamp
59     );
60 
61     event onWithdrawAndDistribute(
62         address playerAddress,
63         bytes32 playerName,
64         uint256 ethOut,
65         uint256 compressedData,
66         uint256 compressedIDs,
67         address winnerAddr,
68         bytes32 winnerName,
69         uint256 amountWon,
70         uint256 newPot,
71         uint256 genAmount
72     );
73 
74     event onBuyAndDistribute(
75         address playerAddress,
76         bytes32 playerName,
77         uint256 ethIn,
78         uint256 compressedData,
79         uint256 compressedIDs,
80         address winnerAddr,
81         bytes32 winnerName,
82         uint256 amountWon,
83         uint256 newPot,
84         uint256 genAmount
85     );
86 
87     event onReLoadAndDistribute(
88         address playerAddress,
89         bytes32 playerName,
90         uint256 compressedData,
91         uint256 compressedIDs,
92         address winnerAddr,
93         bytes32 winnerName,
94         uint256 amountWon,
95         uint256 newPot,
96         uint256 genAmount
97     );
98 
99     event onAffiliatePayout(
100         uint256 indexed affiliateID,
101         address affiliateAddress,
102         bytes32 affiliateName,
103         uint256 indexed roundID,
104         uint256 indexed buyerID,
105         uint256 amount,
106         uint256 timeStamp
107     );
108 }
109 
110 contract Ownable {
111     address public owner;
112 
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     constructor() public {
116         owner = msg.sender;
117     }
118 
119     modifier onlyOwner() {
120         require(msg.sender == owner, "You are not owner.");
121         _;
122     }
123 
124     function transferOwnership(address _newOwner) public onlyOwner {
125         require(_newOwner != address(0), "Invalid address.");
126 
127         owner = _newOwner;
128 
129         emit OwnershipTransferred(owner, _newOwner);
130     }
131 }
132 
133 contract Fomo3D is Ownable, Events {
134     using SafeMath for *;
135     using NameFilter for string;
136     using KeysCalcLong for uint256;
137 
138     ExtSettingInterface private extSetting = ExtSettingInterface(0x6378B8016Fa6B47aCe731DB84aEaBd1abeA4f635);
139     FoundationInterface private foundation = FoundationInterface(0x2Ad0EbB0FFa7A9c698Ae7F1d23BD7d86FF0ae386);
140 	PlayerBookInterface private playerBook = PlayerBookInterface(0x2082ee2696658F8Fd38B837986E02AC8541855da);
141 
142     string constant public name = "Fomo3D Asia (Official)";
143     string constant public symbol = "F3DA";
144 
145     uint256 constant private rndInit_ = 1 hours;
146     uint256 constant private rndInc_ = 30 seconds;
147     uint256 constant private rndMax_ = 24 hours;
148 
149 	uint256 private rndExtra_ = extSetting.getExtra();
150     uint256 private rndGap_ = extSetting.getGap();
151 
152 	uint256 public airDropPot_;
153     uint256 public airDropTracker_ = 0;
154     uint256 public rID_;
155 
156     bool public activated_ = false;
157 
158     mapping (address => uint256) public pIDxAddr_;
159     mapping (bytes32 => uint256) public pIDxName_;
160     mapping (uint256 => Datasets.Player) public plyr_;
161     mapping (uint256 => mapping (uint256 => Datasets.PlayerRounds)) public plyrRnds_;
162     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
163 
164     mapping (uint256 => Datasets.Round) public round_;
165     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
166 
167     mapping (uint256 => uint256) public fees_;
168     mapping (uint256 => uint256) public potSplit_;
169 
170     modifier isActivated() {
171         require(activated_ == true, "its not ready yet.  check ?eta in discord");
172         _;
173     }
174 
175     modifier isHuman() {
176         address _addr = msg.sender;
177         uint256 _codeLength;
178 
179         assembly {
180             _codeLength := extcodesize(_addr)
181         }
182 
183         require(_codeLength == 0, "sorry humans only");
184         _;
185     }
186 
187     modifier isWithinLimits(uint256 _eth) {
188         require(_eth >= 1000000000, "pocket lint: not a valid currency");
189         require(_eth <= 100000000000000000000000, "no vitalik, no");
190         _;
191     }
192 
193     constructor() public {
194 		// 团队分配比例（0 = 鲸队; 1 = 熊队; 2 = 蛇队; 3 = 牛队）
195 
196         fees_[0] = 30;   //50% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
197         fees_[1] = 35;   //45% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
198         fees_[2] = 50;   //30% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
199         fees_[3] = 45;   //35% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
200 
201         potSplit_[0] = 30;  //58% 中奖者, 10% 下一轮奖池, 2% 社区基金
202         potSplit_[1] = 25;  //58% 中奖者, 15% 下一轮奖池, 2% 社区基金
203         potSplit_[2] = 10;  //58% 中奖者, 30% 下一轮奖池, 2% 社区基金
204         potSplit_[3] = 15;  //58% 中奖者, 25% 下一轮奖池, 2% 社区基金
205 	}
206 
207     function() public payable isActivated isHuman isWithinLimits(msg.value) {
208         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
209 
210         uint256 _pID = pIDxAddr_[msg.sender];
211         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
212     }
213 
214     function setExtSettingInterface(address _extSetting) public onlyOwner {
215         extSetting = ExtSettingInterface(_extSetting);
216     }
217 
218     function setFoundationInterface(address _foundation) public onlyOwner {
219         foundation = FoundationInterface(_foundation);
220     }
221 
222     function setPlayerBookInterface(address _playerBook) public onlyOwner {
223         playerBook = PlayerBookInterface(_playerBook);
224     }
225 
226     function buyXid(uint256 _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
227         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
228 
229         uint256 _pID = pIDxAddr_[msg.sender];
230 
231         if (_affCode == 0 || _affCode == _pID) {
232             _affCode = plyr_[_pID].laff;
233         } else if (_affCode != plyr_[_pID].laff) {
234             plyr_[_pID].laff = _affCode;
235         }
236 
237         _team = verifyTeam(_team);
238 
239         buyCore(_pID, _affCode, _team, _eventData_);
240     }
241 
242     function buyXaddr(address _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
243         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
244 
245         uint256 _pID = pIDxAddr_[msg.sender];
246 
247         uint256 _affID;
248         if (_affCode == address(0) || _affCode == msg.sender) {
249             _affID = plyr_[_pID].laff;
250         } else {
251             _affID = pIDxAddr_[_affCode];
252             if (_affID != plyr_[_pID].laff) {
253                 plyr_[_pID].laff = _affID;
254             }
255         }
256 
257         _team = verifyTeam(_team);
258 
259         buyCore(_pID, _affID, _team, _eventData_);
260     }
261 
262     function buyXname(bytes32 _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
263         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
264 
265         uint256 _pID = pIDxAddr_[msg.sender];
266 
267         uint256 _affID;
268         if (_affCode == "" || _affCode == plyr_[_pID].name) {
269             _affID = plyr_[_pID].laff;
270         } else {
271             _affID = pIDxName_[_affCode];
272             if (_affID != plyr_[_pID].laff) {
273                 plyr_[_pID].laff = _affID;
274             }
275         }
276 
277         _team = verifyTeam(_team);
278 
279         buyCore(_pID, _affID, _team, _eventData_);
280     }
281 
282     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth) public payable isActivated isHuman isWithinLimits(msg.value) {
283         Datasets.EventData memory _eventData_;
284 
285         uint256 _pID = pIDxAddr_[msg.sender];
286 
287         if (_affCode == 0 || _affCode == _pID) {
288             _affCode = plyr_[_pID].laff;
289         } else if (_affCode != plyr_[_pID].laff) {
290             plyr_[_pID].laff = _affCode;
291         }
292 
293         _team = verifyTeam(_team);
294 
295         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
296     }
297 
298     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth) public payable isActivated isHuman isWithinLimits(msg.value) {
299         Datasets.EventData memory _eventData_;
300 
301         uint256 _pID = pIDxAddr_[msg.sender];
302 
303         uint256 _affID;
304         if (_affCode == address(0) || _affCode == msg.sender) {
305             _affID = plyr_[_pID].laff;
306         } else {
307             _affID = pIDxAddr_[_affCode];
308             if (_affID != plyr_[_pID].laff) {
309                 plyr_[_pID].laff = _affID;
310             }
311         }
312 
313         _team = verifyTeam(_team);
314 
315         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
316     }
317 
318     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth) public payable isActivated isHuman isWithinLimits(msg.value) {
319         Datasets.EventData memory _eventData_;
320 
321         uint256 _pID = pIDxAddr_[msg.sender];
322 
323         uint256 _affID;
324         if (_affCode == "" || _affCode == plyr_[_pID].name) {
325             _affID = plyr_[_pID].laff;
326         } else {
327             _affID = pIDxName_[_affCode];
328             if (_affID != plyr_[_pID].laff) {
329                 plyr_[_pID].laff = _affID;
330             }
331         }
332 
333         _team = verifyTeam(_team);
334 
335         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
336     }
337 
338     function withdraw() public isActivated isHuman {
339         uint256 _now = now;
340         uint256 _eth;
341         uint256 _pID = pIDxAddr_[msg.sender];
342         uint256 _rID = rID_;
343 
344         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) {
345             Datasets.EventData memory _eventData_;
346 
347 			round_[_rID].ended = true;
348             _eventData_ = endRound(_eventData_);
349 
350             _eth = withdrawEarnings(_pID);
351             if (_eth > 0) {
352                 plyr_[_pID].addr.transfer(_eth);
353             }
354 
355             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
356             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
357 
358             emit Events.onWithdrawAndDistribute(
359                 msg.sender,
360                 plyr_[_pID].name,
361                 _eth,
362                 _eventData_.compressedData,
363                 _eventData_.compressedIDs,
364                 _eventData_.winnerAddr,
365                 _eventData_.winnerName,
366                 _eventData_.amountWon,
367                 _eventData_.newPot,
368                 _eventData_.genAmount
369             );
370         } else {
371             _eth = withdrawEarnings(_pID);
372             if (_eth > 0) {
373                 plyr_[_pID].addr.transfer(_eth);
374             }
375 
376             emit Events.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
377         }
378     }
379 
380     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable isHuman {
381         bytes32 _name = _nameString.nameFilter();
382         address _addr = msg.sender;
383         uint256 _paid = msg.value;
384         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
385 
386         uint256 _pID = pIDxAddr_[_addr];
387 
388         emit Events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
389     }
390 
391     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable isHuman {
392         bytes32 _name = _nameString.nameFilter();
393         address _addr = msg.sender;
394         uint256 _paid = msg.value;
395         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
396 
397         uint256 _pID = pIDxAddr_[_addr];
398 
399         emit Events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
400     }
401 
402     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable isHuman {
403         bytes32 _name = _nameString.nameFilter();
404         address _addr = msg.sender;
405         uint256 _paid = msg.value;
406         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
407 
408         uint256 _pID = pIDxAddr_[_addr];
409 
410         emit Events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
411     }
412 
413     function getBuyPrice() public view returns(uint256) {
414         uint256 _rID = rID_;
415         uint256 _now = now;
416         if (_now > (round_[_rID].strt + rndGap_) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
417             return ((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000));
418         } else {
419             return (75000000000000);
420         }
421     }
422 
423     function getTimeLeft() public view returns(uint256) {
424         uint256 _rID = rID_;
425         uint256 _now = now;
426         if (_now < round_[_rID].end) {
427             if (_now > round_[_rID].strt + rndGap_) {
428                 return ((round_[_rID].end).sub(_now));
429             } else {
430                 return ((round_[_rID].strt + rndGap_).sub(_now));
431             }
432         } else {
433             return(0);
434         }
435     }
436 
437     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256) {
438         uint256 _rID = rID_;
439         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) {
440             if (round_[_rID].plyr == _pID) {
441                 return (
442                     (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
443                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
444                     plyr_[_pID].aff
445                 );
446             } else {
447                 return (
448                     plyr_[_pID].win,
449                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
450                     plyr_[_pID].aff
451                 );
452             }
453         } else {
454             return (
455                 plyr_[_pID].win,
456                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
457                 plyr_[_pID].aff
458             );
459         }
460     }
461 
462     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256) {
463         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team])) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
464     }
465 
466     function getCurrentRoundInfo() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256) {
467         uint256 _rID = rID_;
468         return (
469             round_[_rID].ico,                               // 0
470             _rID,                                           // 1
471             round_[_rID].keys,                              // 2
472             round_[_rID].end,                               // 3
473             round_[_rID].strt,                              // 4
474             round_[_rID].pot,                               // 5
475             (round_[_rID].team + (round_[_rID].plyr * 10)), // 6
476             plyr_[round_[_rID].plyr].addr,                  // 7
477             plyr_[round_[_rID].plyr].name,                  // 8
478             rndTmEth_[_rID][0],                             // 9
479             rndTmEth_[_rID][1],                             // 10
480             rndTmEth_[_rID][2],                             // 11
481             rndTmEth_[_rID][3],                             // 12
482             airDropTracker_ + (airDropPot_ * 1000)          // 13
483         );
484     }
485 
486     function getPlayerInfoByAddress(address _addr) public view returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256) {
487         uint256 _rID = rID_;
488 
489         if (_addr == address(0)) {
490             _addr == msg.sender;
491         }
492 
493         uint256 _pID = pIDxAddr_[_addr];
494 
495         return (
496             _pID,                                                                   // 0
497             plyr_[_pID].name,                                                       // 1
498             plyrRnds_[_pID][_rID].keys,                                             // 2
499             plyr_[_pID].win,                                                        // 3
500             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),    // 4
501             plyr_[_pID].aff,                                                        // 5
502             plyrRnds_[_pID][_rID].eth                                               // 6
503         );
504     }
505 
506     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Datasets.EventData memory _eventData_) private {
507         uint256 _rID = rID_;
508 
509         uint256 _now = now;
510         if (_now > (round_[_rID].strt + rndGap_) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
511             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
512         } else {
513             if (_now > round_[_rID].end && round_[_rID].ended == false) {
514 			    round_[_rID].ended = true;
515                 _eventData_ = endRound(_eventData_);
516 
517                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
518                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
519 
520                 emit Events.onBuyAndDistribute(
521                     msg.sender,
522                     plyr_[_pID].name,
523                     msg.value,
524                     _eventData_.compressedData,
525                     _eventData_.compressedIDs,
526                     _eventData_.winnerAddr,
527                     _eventData_.winnerName,
528                     _eventData_.amountWon,
529                     _eventData_.newPot,
530                     _eventData_.genAmount
531                 );
532             }
533 
534             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
535         }
536     }
537 
538     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Datasets.EventData memory _eventData_) private {
539         uint256 _rID = rID_;
540 
541         uint256 _now = now;
542         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
543             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
544 
545             core(_rID, _pID, _eth, _affID, _team, _eventData_);
546         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
547             round_[_rID].ended = true;
548             _eventData_ = endRound(_eventData_);
549 
550             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
551             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
552 
553             emit Events.onReLoadAndDistribute(
554                 msg.sender,
555                 plyr_[_pID].name,
556                 _eventData_.compressedData,
557                 _eventData_.compressedIDs,
558                 _eventData_.winnerAddr,
559                 _eventData_.winnerName,
560                 _eventData_.amountWon,
561                 _eventData_.newPot,
562                 _eventData_.genAmount
563             );
564         }
565     }
566 
567     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Datasets.EventData memory _eventData_) private {
568         extSetting.setGap(_pID);
569 
570         if (plyrRnds_[_pID][_rID].keys == 0) {
571             _eventData_ = managePlayer(_pID, _eventData_);
572         }
573 
574         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000) {
575             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
576             uint256 _refund = _eth.sub(_availableLimit);
577             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
578             _eth = _availableLimit;
579         }
580 
581         if (_eth > 1000000000) {
582             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
583             if (_keys >= 1000000000000000000) {
584                 updateTimer(_keys, _rID);
585 
586                 if (round_[_rID].plyr != _pID) {
587                     round_[_rID].plyr = _pID;
588                 }
589                 if (round_[_rID].team != _team) {
590                     round_[_rID].team = _team;
591                 }
592 
593                 _eventData_.compressedData = _eventData_.compressedData + 100;
594             }
595 
596             if (_eth >= 100000000000000000) {
597                 airDropTracker_++;
598                 if (airdrop() == true) {
599                     uint256 _prize;
600                     if (_eth >= 10000000000000000000) {
601                         _prize = ((airDropPot_).mul(75)) / 100;
602                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
603 
604                         airDropPot_ = (airDropPot_).sub(_prize);
605 
606                         _eventData_.compressedData += 300000000000000000000000000000000;
607                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
608                         _prize = ((airDropPot_).mul(50)) / 100;
609                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
610 
611                         airDropPot_ = (airDropPot_).sub(_prize);
612 
613                         _eventData_.compressedData += 200000000000000000000000000000000;
614                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
615                         _prize = ((airDropPot_).mul(25)) / 100;
616                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
617 
618                         airDropPot_ = (airDropPot_).sub(_prize);
619 
620                         _eventData_.compressedData += 300000000000000000000000000000000;
621                     }
622 
623                     _eventData_.compressedData += 10000000000000000000000000000000;
624                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
625 
626                     airDropTracker_ = 0;
627                 }
628             }
629 
630             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
631 
632             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
633             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
634 
635             round_[_rID].keys = _keys.add(round_[_rID].keys);
636             round_[_rID].eth = _eth.add(round_[_rID].eth);
637             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
638 
639             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
640             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
641 
642 		    endTx(_pID, _team, _eth, _keys, _eventData_);
643         }
644     }
645 
646     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256) {
647         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
648     }
649 
650     function calcKeysReceived(uint256 _rID, uint256 _eth) public view returns(uint256) {
651         uint256 _now = now;
652         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
653             return ((round_[_rID].eth).keysRec(_eth));
654         } else {
655             return ((_eth).keys());
656         }
657     }
658 
659     function iWantXKeys(uint256 _keys) public view returns(uint256) {
660         uint256 _rID = rID_;
661 
662         uint256 _now = now;
663         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
664             return ((round_[_rID].keys.add(_keys)).ethRec(_keys));
665         } else {
666             return ((_keys).eth());
667         }
668     }
669 
670     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external {
671         require (msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
672         if (pIDxAddr_[_addr] != _pID) {
673             pIDxAddr_[_addr] = _pID;
674         }
675         if (pIDxName_[_name] != _pID) {
676             pIDxName_[_name] = _pID;
677         }
678         if (plyr_[_pID].addr != _addr) {
679             plyr_[_pID].addr = _addr;
680         }
681         if (plyr_[_pID].name != _name) {
682             plyr_[_pID].name = _name;
683         }
684         if (plyr_[_pID].laff != _laff) {
685             plyr_[_pID].laff = _laff;
686         }
687         if (plyrNames_[_pID][_name] == false) {
688             plyrNames_[_pID][_name] = true;
689         }
690     }
691 
692     function receivePlayerNameList(uint256 _pID, bytes32 _name) external {
693         require (msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
694         if (plyrNames_[_pID][_name] == false) {
695             plyrNames_[_pID][_name] = true;
696         }
697     }
698 
699     function determinePID(Datasets.EventData memory _eventData_) private returns (Datasets.EventData) {
700         uint256 _pID = pIDxAddr_[msg.sender];
701         if (_pID == 0) {
702             _pID = playerBook.getPlayerID(msg.sender);
703             bytes32 _name = playerBook.getPlayerName(_pID);
704             uint256 _laff = playerBook.getPlayerLAff(_pID);
705 
706             pIDxAddr_[msg.sender] = _pID;
707             plyr_[_pID].addr = msg.sender;
708 
709             if (_name != "") {
710                 pIDxName_[_name] = _pID;
711                 plyr_[_pID].name = _name;
712                 plyrNames_[_pID][_name] = true;
713             }
714 
715             if (_laff != 0 && _laff != _pID) {
716                 plyr_[_pID].laff = _laff;
717             }
718 
719             _eventData_.compressedData = _eventData_.compressedData + 1;
720         }
721         return (_eventData_);
722     }
723 
724     function verifyTeam(uint256 _team) private pure returns (uint256) {
725         if (_team < 0 || _team > 3) {
726             return (2);
727         } else {
728             return (_team);
729         }
730     }
731 
732     function managePlayer(uint256 _pID, Datasets.EventData memory _eventData_) private returns (Datasets.EventData) {
733         if (plyr_[_pID].lrnd != 0) {
734             updateGenVault(_pID, plyr_[_pID].lrnd);
735         }
736         plyr_[_pID].lrnd = rID_;
737 
738         _eventData_.compressedData = _eventData_.compressedData + 10;
739 
740         return(_eventData_);
741     }
742 
743     function endRound(Datasets.EventData memory _eventData_) private returns (Datasets.EventData) {
744         uint256 _rID = rID_;
745 
746         uint256 _winPID = round_[_rID].plyr;
747         uint256 _winTID = round_[_rID].team;
748 
749         uint256 _pot = round_[_rID].pot;
750 
751         // 中奖者拿走 58%
752         uint256 _win = (_pot.mul(58)) / 100;
753 
754         // 提取社区基金 2%
755         uint256 _com = (_pot / 50);
756 
757         // 所在团队分红
758         uint256 _gen = (_pot.mul(potSplit_[_winTID])) / 100;
759 
760         // 进入下一轮奖池
761         uint256 _res = ((_pot.sub(_win)).sub(_com)).sub(_gen);
762 
763         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
764         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
765         if (_dust > 0) {
766             _gen = _gen.sub(_dust);
767             _res = _res.add(_dust);
768         }
769 
770         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
771 
772         foundation.deposit.value(_com)();
773 
774         round_[_rID].mask = _ppt.add(round_[_rID].mask);
775 
776         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
777         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
778         _eventData_.winnerAddr = plyr_[_winPID].addr;
779         _eventData_.winnerName = plyr_[_winPID].name;
780         _eventData_.amountWon = _win;
781         _eventData_.genAmount = _gen;
782         _eventData_.newPot = _res;
783 
784         rID_++;
785         _rID++;
786         round_[_rID].strt = now;
787         round_[_rID].end = now.add(rndInit_).add(rndGap_);
788         round_[_rID].pot = _res;
789 
790         return (_eventData_);
791     }
792 
793     function updateGenVault(uint256 _pID, uint256 _rIDlast) private {
794         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
795         if (_earnings > 0) {
796             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
797             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
798         }
799     }
800 
801     function updateTimer(uint256 _keys, uint256 _rID) private {
802         uint256 _now = now;
803         uint256 _newTime;
804         if (_now > round_[_rID].end && round_[_rID].plyr == 0) {
805             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
806         } else {
807             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
808         }
809         if (_newTime < (rndMax_).add(_now)) {
810             round_[_rID].end = _newTime;
811         } else {
812             round_[_rID].end = rndMax_.add(_now);
813         }
814     }
815 
816     function airdrop() private view returns(bool) {
817         uint256 seed = uint256(keccak256(abi.encodePacked(
818             (now).add(block.difficulty).add(
819                 (uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)
820             ).add(block.gaslimit).add(
821                 (uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)
822             ).add(block.number)
823         )));
824         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_) {
825             return true;
826         } else {
827             return false;
828         }
829     }
830 
831     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, Datasets.EventData memory _eventData_) private returns(Datasets.EventData) {
832         // 社区基金 4%
833         uint256 _com = _eth / 25;
834         foundation.deposit.value(_com)();
835 
836         // 推荐人 15%
837         uint256 _aff = (_eth.mul(15)) / 100;
838         if (_affID == _pID || plyr_[_affID].name == "") {
839             _affID = 1;
840         }
841         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
842 
843         emit Events.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
844 
845         return (_eventData_);
846     }
847 
848     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Datasets.EventData memory _eventData_) private returns(Datasets.EventData) {
849         // 团队分红
850         uint256 _gen = (_eth.mul(fees_[_team])) / 100;
851 
852         // 空投奖池 1%
853         uint256 _air = (_eth / 100);
854         airDropPot_ = airDropPot_.add(_air);
855 
856         // 奖池
857         uint256 _pot = _eth.sub((_eth / 5).add(_gen));
858 
859         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
860         if (_dust > 0) {
861             _gen = _gen.sub(_dust);
862         }
863 
864         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
865 
866         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
867         _eventData_.potAmount = _pot;
868 
869         return (_eventData_);
870     }
871 
872     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256) {
873         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
874         round_[_rID].mask = _ppt.add(round_[_rID].mask);
875 
876         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
877         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
878 
879         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
880     }
881 
882     function withdrawEarnings(uint256 _pID) private returns(uint256) {
883         updateGenVault(_pID, plyr_[_pID].lrnd);
884 
885         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
886         if (_earnings > 0) {
887             plyr_[_pID].win = 0;
888             plyr_[_pID].gen = 0;
889             plyr_[_pID].aff = 0;
890         }
891 
892         return(_earnings);
893     }
894 
895     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Datasets.EventData memory _eventData_) private {
896         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
897         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
898 
899         emit Events.onEndTx(
900             _eventData_.compressedData,
901             _eventData_.compressedIDs,
902             plyr_[_pID].name,
903             msg.sender,
904             _eth,
905             _keys,
906             _eventData_.winnerAddr,
907             _eventData_.winnerName,
908             _eventData_.amountWon,
909             _eventData_.newPot,
910             _eventData_.genAmount,
911             _eventData_.potAmount,
912             airDropPot_
913         );
914     }
915 
916     function activate() public onlyOwner {
917         require(activated_ == false, "fomo3d already activated");
918 
919         activated_ = true;
920 
921 		rID_ = 1;
922         round_[1].strt = now + rndExtra_ - rndGap_;
923         round_[1].end = now + rndInit_ + rndExtra_;
924     }
925 }
926 
927 library Datasets {
928     struct EventData {
929         uint256 compressedData;
930         uint256 compressedIDs;
931         address winnerAddr;
932         bytes32 winnerName;
933         uint256 amountWon;
934         uint256 newPot;
935         uint256 genAmount;
936         uint256 potAmount;
937     }
938 
939     struct Player {
940         address addr;
941         bytes32 name;
942         uint256 win;
943         uint256 gen;
944         uint256 aff;
945         uint256 lrnd;
946         uint256 laff;
947     }
948 
949     struct PlayerRounds {
950         uint256 eth;
951         uint256 keys;
952         uint256 mask;
953         uint256 ico;
954     }
955 
956     struct Round {
957         uint256 plyr;
958         uint256 team;
959         uint256 end;
960         bool ended;
961         uint256 strt;
962         uint256 keys;
963         uint256 eth;
964         uint256 pot;
965         uint256 mask;
966         uint256 ico;
967         uint256 icoGen;
968         uint256 icoAvg;
969     }
970 }
971 
972 library KeysCalcLong {
973     using SafeMath for *;
974 
975     function keysRec(uint256 _curEth, uint256 _newEth) internal pure returns (uint256) {
976         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
977     }
978 
979     function ethRec(uint256 _curKeys, uint256 _sellKeys) internal pure returns (uint256) {
980         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
981     }
982 
983     function keys(uint256 _eth) internal pure returns(uint256) {
984         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
985     }
986 
987     function eth(uint256 _keys) internal pure returns(uint256) {
988         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
989     }
990 }
991 
992 library NameFilter {
993     function nameFilter(string _input) internal pure returns(bytes32) {
994         bytes memory _temp = bytes(_input);
995         uint256 _length = _temp.length;
996 
997         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
998         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
999         if (_temp[0] == 0x30) {
1000             require(_temp[1] != 0x78, "string cannot start with 0x");
1001             require(_temp[1] != 0x58, "string cannot start with 0X");
1002         }
1003 
1004         bool _hasNonNumber;
1005 
1006         for (uint256 i = 0; i < _length; i++) {
1007             if (_temp[i] > 0x40 && _temp[i] < 0x5b) {
1008                 _temp[i] = byte(uint(_temp[i]) + 32);
1009 
1010                 if (_hasNonNumber == false) {
1011                     _hasNonNumber = true;
1012                 }
1013             } else {
1014                 require(_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
1015 
1016                 if (_temp[i] == 0x20) {
1017                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1018                 }
1019 
1020                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39)) {
1021                     _hasNonNumber = true;
1022                 }
1023             }
1024         }
1025 
1026         require(_hasNonNumber == true, "string cannot be only numbers");
1027 
1028         bytes32 _ret;
1029         assembly {
1030             _ret := mload(add(_temp, 32))
1031         }
1032 
1033         return (_ret);
1034     }
1035 }
1036 
1037 library SafeMath {
1038     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1039         if (a == 0) {
1040             return 0;
1041         }
1042         c = a * b;
1043         require(c / a == b, "SafeMath mul failed");
1044         return c;
1045     }
1046 
1047     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1048         require(b <= a, "SafeMath sub failed");
1049         return a - b;
1050     }
1051 
1052     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1053         c = a + b;
1054         require(c >= a, "SafeMath add failed");
1055         return c;
1056     }
1057 
1058     function sqrt(uint256 x) internal pure returns (uint256 y) {
1059         uint256 z = ((add(x,1)) / 2);
1060         y = x;
1061         while (z < y) {
1062             y = z;
1063             z = ((add((x / z), z)) / 2);
1064         }
1065     }
1066 
1067     function sq(uint256 x) internal pure returns (uint256) {
1068         return (mul(x, x));
1069     }
1070 
1071     function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
1072         if (x == 0) {
1073             return (0);
1074         } else if (y == 0) {
1075             return (1);
1076         } else {
1077             uint256 z = x;
1078             for (uint256 i = 1; i < y; i++) {
1079                 z = mul(z, x);
1080             }
1081             return (z);
1082         }
1083     }
1084 }