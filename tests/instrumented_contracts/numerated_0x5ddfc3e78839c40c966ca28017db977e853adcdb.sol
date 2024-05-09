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
27 
28     function sqrt(uint256 x) internal pure returns (uint256 y) {
29         uint256 z = add(x, 1) / 2;
30         y = x;
31         while (z < y) {
32             y = z;
33             z = add((x / z), z) / 2;
34         }
35     }
36 
37     function sq(uint256 x) internal pure returns (uint256) {
38         return mul(x, x);
39     }
40 
41     function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
42         if (x == 0) {
43             return 0;
44         }
45         if (y == 0) {
46             return 1;
47         }
48         uint256 z = x;
49         for (uint256 i=1; i < y; i++) {
50             z = mul(z,x);
51         }
52         return (z);
53     }
54 }
55 
56 library NameFilter {
57     function nameFilter(string _input) internal pure returns(bytes32) {
58         bytes memory _temp = bytes(_input);
59         uint256 _length = _temp.length;
60 
61         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
62         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
63         if (_temp[0] == 0x30) {
64             require(_temp[1] != 0x78, "string cannot start with 0x");
65             require(_temp[1] != 0x58, "string cannot start with 0X");
66         }
67 
68         bool _hasNonNumber;
69 
70         for (uint256 i = 0; i < _length; i++) {
71             if (_temp[i] > 0x40 && _temp[i] < 0x5b) {
72                 _temp[i] = byte(uint(_temp[i]) + 32);
73 
74                 if (_hasNonNumber == false) {
75                     _hasNonNumber = true;
76                 }
77             } else {
78                 require(_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
79                 if (_temp[i] == 0x20) {
80                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
81                 }
82 
83                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39)) {
84                     _hasNonNumber = true;
85                 }
86             }
87         }
88 
89         require(_hasNonNumber == true, "string cannot be only numbers");
90 
91         bytes32 _ret;
92         assembly {
93             _ret := mload(add(_temp, 32))
94         }
95 
96         return (_ret);
97     }
98 }
99 
100 library F3Ddatasets {
101     // compressedData key
102     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
103     // 0 - new player (bool)
104     // 1 - joined round (bool)
105     // 2 - new  leader (bool)
106     // 3-5 - air drop tracker (uint 0-999)
107     // 6-16 - round end time
108     // 17 - winnerTeam
109     // 18 - 28 timestamp
110     // 29 - team
111     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
112     // 31 - airdrop happened bool
113     // 32 - airdrop tier
114     // 33 - airdrop amount won
115     // compressedIDs key
116     // [77-52][51-26][25-0]
117     // 0-25 - pID
118     // 26-51 - winPID
119     // 52-77 - rID
120     struct EventReturns {
121         uint256 compressedData;
122         uint256 compressedIDs;
123         address winnerAddr;         // winner address
124         bytes32 winnerName;         // winner name
125         uint256 amountWon;          // amount won
126         uint256 newPot;             // amount in new pot
127         uint256 genAmount;          // amount distributed to gen
128         uint256 potAmount;          // amount added to pot
129     }
130 
131     struct Player {
132         address addr;   // player address
133         bytes32 name;   // player name
134         uint256 win;    // winnings vault
135         uint256 gen;    // general vault
136         uint256 aff;    // affiliate vault
137         uint256 lrnd;   // last round played
138         uint256 laff;   // last affiliate id used
139     }
140 
141     struct PlayerRounds {
142         uint256 eth;    // eth player has added to round (used for eth limiter)
143         uint256 keys;   // keys
144         uint256 mask;   // player mask
145         uint256 ico;    // ICO phase investment
146     }
147 
148     struct Round {
149         uint256 plyr;   // pID of player in lead
150         uint256 team;   // tID of team in lead
151         uint256 end;    // time ends/ended
152         bool ended;     // has round end function been ran
153         uint256 strt;   // time round started
154         uint256 keys;   // keys
155         uint256 eth;    // total eth in
156         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
157         uint256 mask;   // global mask
158         uint256 ico;    // total eth sent in during ICO phase
159         uint256 icoGen; // total eth for gen during ICO phase
160         uint256 icoAvg; // average key price for ICO phase
161     }
162 }
163 
164 library F3DKeysCalcLong {
165     using SafeMath for *;
166 
167     function keysRec(uint256 _curEth, uint256 _newEth) internal pure returns (uint256) {
168         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
169     }
170 
171     function ethRec(uint256 _curKeys, uint256 _sellKeys) internal pure returns (uint256) {
172         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
173     }
174 
175     function keys(uint256 _eth) internal pure returns(uint256) {
176         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
177     }
178 
179     function eth(uint256 _keys) internal pure returns(uint256) {
180         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
181     }
182 }
183 
184 interface PartnershipInterface {
185     function deposit() external payable returns(bool);
186 }
187 
188 interface PlayerBookInterface {
189     function getPlayerID(address _addr) external returns (uint256);
190     function getPlayerName(uint256 _pID) external view returns (bytes32);
191     function getPlayerLAff(uint256 _pID) external view returns (uint256);
192     function getPlayerAddr(uint256 _pID) external view returns (address);
193     function getNameFee() external view returns (uint256);
194     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
195     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
196     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
197 }
198 
199 interface ExternalSettingsInterface {
200     function getLongGap() external returns(uint256);
201     function getLongExtra() external returns(uint256);
202     function updateLongExtra(uint256 _pID) external;
203 }
204 
205 contract F3Devents {
206     event onNewName(
207         uint256 indexed playerID,
208         address indexed playerAddress,
209         bytes32 indexed playerName,
210         bool isNewPlayer,
211         uint256 affiliateID,
212         address affiliateAddress,
213         bytes32 affiliateName,
214         uint256 amountPaid,
215         uint256 timeStamp
216     );
217 
218     event onEndTx(
219         uint256 compressedData,
220         uint256 compressedIDs,
221         bytes32 playerName,
222         address playerAddress,
223         uint256 ethIn,
224         uint256 keysBought,
225         address winnerAddr,
226         bytes32 winnerName,
227         uint256 amountWon,
228         uint256 newPot,
229         uint256 genAmount,
230         uint256 potAmount,
231         uint256 airDropPot
232     );
233 
234     event onWithdraw(
235         uint256 indexed playerID,
236         address playerAddress,
237         bytes32 playerName,
238         uint256 ethOut,
239         uint256 timeStamp
240     );
241 
242     event onWithdrawAndDistribute(
243         address playerAddress,
244         bytes32 playerName,
245         uint256 ethOut,
246         uint256 compressedData,
247         uint256 compressedIDs,
248         address winnerAddr,
249         bytes32 winnerName,
250         uint256 amountWon,
251         uint256 newPot,
252         uint256 genAmount
253     );
254 
255     event onBuyAndDistribute(
256         address playerAddress,
257         bytes32 playerName,
258         uint256 ethIn,
259         uint256 compressedData,
260         uint256 compressedIDs,
261         address winnerAddr,
262         bytes32 winnerName,
263         uint256 amountWon,
264         uint256 newPot,
265         uint256 genAmount
266     );
267 
268     event onReLoadAndDistribute(
269         address playerAddress,
270         bytes32 playerName,
271         uint256 compressedData,
272         uint256 compressedIDs,
273         address winnerAddr,
274         bytes32 winnerName,
275         uint256 amountWon,
276         uint256 newPot,
277         uint256 genAmount
278     );
279 
280     event onAffiliatePayout(
281         uint256 indexed affiliateID,
282         address affiliateAddress,
283         bytes32 affiliateName,
284         uint256 indexed roundID,
285         uint256 indexed buyerID,
286         uint256 amount,
287         uint256 timeStamp
288     );
289 
290     event onPotSwapDeposit(
291         uint256 roundID,
292         uint256 amountAddedToPot
293     );
294 }
295 
296 contract Ownable {
297     address public owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     constructor() public {
302         owner = msg.sender;
303     }
304 
305     modifier onlyOwner() {
306         require(msg.sender == owner, "You are not owner.");
307         _;
308     }
309 
310     function transferOwnership(address _newOwner) public onlyOwner {
311         require(_newOwner != address(0), "Invalid address.");
312 
313         owner = _newOwner;
314 
315         emit OwnershipTransferred(owner, _newOwner);
316     }
317 }
318 
319 contract Fomo3DQuick is F3Devents, Ownable {
320     using SafeMath for *;
321     using NameFilter for string;
322     using F3DKeysCalcLong for uint256;
323 
324     ExternalSettingsInterface constant private externalSettings = ExternalSettingsInterface(0xC77c0EF6B077D2F251C19B2DBA3ad8e0DF26aF31);
325     PartnershipInterface constant private partnership = PartnershipInterface(0x59Ff25C4E2550bc9E2115dbcD28b949d7670d134);
326 	PlayerBookInterface constant private playerBook = PlayerBookInterface(0x38926C81Bf68130fFfc6972F7b5DBc550272EB4e);
327 
328     string constant public name = "Fomo3D Quick (Released)";
329     string constant public symbol = "F3DQ";
330 
331     uint256 private rndGap_ = externalSettings.getLongGap();
332 	uint256 private rndExtra_ = externalSettings.getLongExtra();
333     uint256 constant private rndInit_ = 1 minutes;
334     uint256 constant private rndInc_ = 30 seconds;
335     uint256 constant private rndMax_ = 24 minutes;
336 
337 	uint256 public airDropPot_;
338     uint256 public airDropTracker_ = 0;
339 
340     uint256 public rID_;
341 
342     bool public activated_ = false;
343 
344     mapping (address => uint256) public pIDxAddr_;
345     mapping (bytes32 => uint256) public pIDxName_;
346     mapping (uint256 => F3Ddatasets.Player) public plyr_;
347     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
348     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
349 
350     mapping (uint256 => F3Ddatasets.Round) public round_;
351     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
352 
353     mapping (uint256 => uint256) public fees_;
354     mapping (uint256 => uint256) public potSplit_;
355 
356     constructor() public {
357 		// 团队分配比例（0 = 鲸队; 1 = 熊队; 2 = 蛇队; 3 = 牛队）
358 
359         fees_[0] = 30;   //50% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
360         fees_[1] = 35;   //45% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
361         fees_[2] = 50;   //30% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
362         fees_[3] = 45;   //35% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
363 
364         potSplit_[0] = 30;  //58% 中奖者, 10% 下一轮奖池, 2% 社区基金
365         potSplit_[1] = 25;  //58% 中奖者, 15% 下一轮奖池, 2% 社区基金
366         potSplit_[2] = 10;  //58% 中奖者, 30% 下一轮奖池, 2% 社区基金
367         potSplit_[3] = 15;  //58% 中奖者, 25% 下一轮奖池, 2% 社区基金
368 	}
369 
370     modifier isActivated() {
371         require(activated_ == true, "its not ready yet. check ?eta in discord");
372         _;
373     }
374 
375     modifier isHuman() {
376         address _addr = msg.sender;
377         uint256 _codeLength;
378 
379         assembly {
380             _codeLength := extcodesize(_addr)
381         }
382 
383         require(_codeLength == 0, "sorry humans only");
384         _;
385     }
386 
387     modifier isWithinLimits(uint256 _eth) {
388         require(_eth >= 1000000000, "pocket lint: not a valid currency");
389         require(_eth <= 100000000000000000000000, "no vitalik, no");
390         _;
391     }
392 
393     function() public payable isActivated isHuman isWithinLimits(msg.value) {
394         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
395 
396         uint256 _pID = pIDxAddr_[msg.sender];
397 
398         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
399     }
400 
401     function buyXid(uint256 _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
402         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
403 
404         uint256 _pID = pIDxAddr_[msg.sender];
405         if (_affCode == 0 || _affCode == _pID) {
406             _affCode = plyr_[_pID].laff;
407         } else if (_affCode != plyr_[_pID].laff) {
408             plyr_[_pID].laff = _affCode;
409         }
410 
411         _team = verifyTeam(_team);
412 
413         buyCore(_pID, _affCode, _team, _eventData_);
414     }
415 
416     function buyXaddr(address _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
417         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
418 
419         uint256 _pID = pIDxAddr_[msg.sender];
420 
421         uint256 _affID;
422         if (_affCode == address(0) || _affCode == msg.sender) {
423             _affID = plyr_[_pID].laff;
424         } else {
425             _affID = pIDxAddr_[_affCode];
426             if (_affID != plyr_[_pID].laff) {
427                 plyr_[_pID].laff = _affID;
428             }
429         }
430 
431         _team = verifyTeam(_team);
432 
433         buyCore(_pID, _affID, _team, _eventData_);
434     }
435 
436     function buyXname(bytes32 _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
437         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
438 
439         uint256 _pID = pIDxAddr_[msg.sender];
440 
441         uint256 _affID;
442         if (_affCode == "" || _affCode == plyr_[_pID].name) {
443             _affID = plyr_[_pID].laff;
444         } else {
445             _affID = pIDxName_[_affCode];
446             if (_affID != plyr_[_pID].laff) {
447                 plyr_[_pID].laff = _affID;
448             }
449         }
450 
451         _team = verifyTeam(_team);
452 
453         buyCore(_pID, _affID, _team, _eventData_);
454     }
455 
456     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth) public isActivated isHuman isWithinLimits(_eth) {
457         F3Ddatasets.EventReturns memory _eventData_;
458 
459         uint256 _pID = pIDxAddr_[msg.sender];
460         if (_affCode == 0 || _affCode == _pID) {
461             _affCode = plyr_[_pID].laff;
462         } else if (_affCode != plyr_[_pID].laff) {
463             plyr_[_pID].laff = _affCode;
464         }
465 
466         _team = verifyTeam(_team);
467 
468         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
469     }
470 
471     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth) public isActivated isHuman isWithinLimits(_eth) {
472         F3Ddatasets.EventReturns memory _eventData_;
473 
474         uint256 _pID = pIDxAddr_[msg.sender];
475 
476         uint256 _affID;
477         if (_affCode == address(0) || _affCode == msg.sender) {
478             _affID = plyr_[_pID].laff;
479         } else {
480             _affID = pIDxAddr_[_affCode];
481             if (_affID != plyr_[_pID].laff) {
482                 plyr_[_pID].laff = _affID;
483             }
484         }
485 
486         _team = verifyTeam(_team);
487 
488         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
489     }
490 
491     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth) public isActivated isHuman isWithinLimits(_eth) {
492         F3Ddatasets.EventReturns memory _eventData_;
493 
494         uint256 _pID = pIDxAddr_[msg.sender];
495 
496         uint256 _affID;
497         if (_affCode == "" || _affCode == plyr_[_pID].name) {
498             _affID = plyr_[_pID].laff;
499         } else {
500             _affID = pIDxName_[_affCode];
501             if (_affID != plyr_[_pID].laff) {
502                 plyr_[_pID].laff = _affID;
503             }
504         }
505 
506         _team = verifyTeam(_team);
507 
508         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
509     }
510 
511     function withdraw() public isActivated isHuman {
512         uint256 _now = block.timestamp;
513         uint256 _eth;
514         uint256 _pID = pIDxAddr_[msg.sender];
515         uint256 _rID = rID_;
516         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) {
517             F3Ddatasets.EventReturns memory _eventData_;
518 
519 			round_[_rID].ended = true;
520             _eventData_ = endRound(_eventData_);
521 
522             _eth = withdrawEarnings(_pID);
523             if (_eth > 0) {
524                 plyr_[_pID].addr.transfer(_eth);
525             }
526 
527             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
528             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
529 
530             emit F3Devents.onWithdrawAndDistribute(
531                 msg.sender,
532                 plyr_[_pID].name,
533                 _eth,
534                 _eventData_.compressedData,
535                 _eventData_.compressedIDs,
536                 _eventData_.winnerAddr,
537                 _eventData_.winnerName,
538                 _eventData_.amountWon,
539                 _eventData_.newPot,
540                 _eventData_.genAmount
541             );
542         } else {
543             _eth = withdrawEarnings(_pID);
544             if (_eth > 0) {
545                 plyr_[_pID].addr.transfer(_eth);
546             }
547 
548             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
549         }
550     }
551 
552     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable isHuman {
553         bytes32 _name = _nameString.nameFilter();
554         address _addr = msg.sender;
555         uint256 _paid = msg.value;
556         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
557 
558         uint256 _pID = pIDxAddr_[_addr];
559 
560         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, block.timestamp);
561     }
562 
563     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable isHuman {
564         bytes32 _name = _nameString.nameFilter();
565         address _addr = msg.sender;
566         uint256 _paid = msg.value;
567         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
568 
569         uint256 _pID = pIDxAddr_[_addr];
570 
571         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, block.timestamp);
572     }
573 
574     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable isHuman {
575         bytes32 _name = _nameString.nameFilter();
576         address _addr = msg.sender;
577         uint256 _paid = msg.value;
578         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
579 
580         uint256 _pID = pIDxAddr_[_addr];
581 
582         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, block.timestamp);
583     }
584 
585     function getBuyPrice() public view returns(uint256) {
586         uint256 _now = block.timestamp;
587         uint256 _rID = rID_;
588         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
589             return (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000);
590         }
591         return 75000000000000;
592     }
593 
594     function getTimeLeft() public view returns(uint256) {
595         uint256 _now = block.timestamp;
596         uint256 _rID = rID_;
597         if (_now < round_[_rID].end) {
598             if (_now > round_[_rID].strt + rndGap_) {
599                 return (round_[_rID].end).sub(_now);
600             }
601             return (round_[_rID].strt + rndGap_).sub(_now);
602         }
603         return 0;
604     }
605 
606     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256) {
607         uint256 _rID = rID_;
608         if (block.timestamp > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) {
609             if (round_[_rID].plyr == _pID) {
610                 return (
611                     (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
612                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
613                     plyr_[_pID].aff
614                 );
615             }
616             return (
617                 plyr_[_pID].win,
618                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
619                 plyr_[_pID].aff
620             );
621         }
622         return (
623             plyr_[_pID].win,
624             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
625             plyr_[_pID].aff
626         );
627     }
628 
629     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256) {
630         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team])) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
631     }
632 
633     function getCurrentRoundInfo() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256) {
634         uint256 _rID = rID_;
635 
636         return (
637             round_[_rID].ico,                               // 0
638             _rID,                                           // 1
639             round_[_rID].keys,                              // 2
640             round_[_rID].end,                               // 3
641             round_[_rID].strt,                              // 4
642             round_[_rID].pot,                               // 5
643             (round_[_rID].team + (round_[_rID].plyr * 10)), // 6
644             plyr_[round_[_rID].plyr].addr,                  // 7
645             plyr_[round_[_rID].plyr].name,                  // 8
646             rndTmEth_[_rID][0],                             // 9
647             rndTmEth_[_rID][1],                             // 10
648             rndTmEth_[_rID][2],                             // 11
649             rndTmEth_[_rID][3],                             // 12
650             airDropTracker_ + (airDropPot_ * 1000)          // 13
651         );
652     }
653 
654     function getPlayerInfoByAddress(address _addr) public view returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256) {
655         if (_addr == address(0)) {
656             _addr == msg.sender;
657         }
658 
659         uint256 _rID = rID_;
660         uint256 _pID = pIDxAddr_[_addr];
661 
662         return (
663             _pID,                                                                // 0
664             plyr_[_pID].name,                                                    // 1
665             plyrRnds_[_pID][_rID].keys,                                          // 2
666             plyr_[_pID].win,                                                     // 3
667             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), // 4
668             plyr_[_pID].aff,                                                     // 5
669             plyrRnds_[_pID][_rID].eth                                            // 6
670         );
671     }
672 
673     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_) private {
674         uint256 _now = block.timestamp;
675         uint256 _rID = rID_;
676         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
677             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
678         } else {
679             if (_now > round_[_rID].end && round_[_rID].ended == false) {
680 			    round_[_rID].ended = true;
681                 _eventData_ = endRound(_eventData_);
682 
683                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
684                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
685 
686                 emit F3Devents.onBuyAndDistribute (
687                     msg.sender,
688                     plyr_[_pID].name,
689                     msg.value,
690                     _eventData_.compressedData,
691                     _eventData_.compressedIDs,
692                     _eventData_.winnerAddr,
693                     _eventData_.winnerName,
694                     _eventData_.amountWon,
695                     _eventData_.newPot,
696                     _eventData_.genAmount
697                 );
698             }
699 
700             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
701         }
702     }
703 
704     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_) private {
705         uint256 _now = block.timestamp;
706         uint256 _rID = rID_;
707         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
708             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
709 
710             core(_rID, _pID, _eth, _affID, _team, _eventData_);
711         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
712             round_[_rID].ended = true;
713             _eventData_ = endRound(_eventData_);
714 
715             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
716             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
717 
718             emit F3Devents.onReLoadAndDistribute (
719                 msg.sender,
720                 plyr_[_pID].name,
721                 _eventData_.compressedData,
722                 _eventData_.compressedIDs,
723                 _eventData_.winnerAddr,
724                 _eventData_.winnerName,
725                 _eventData_.amountWon,
726                 _eventData_.newPot,
727                 _eventData_.genAmount
728             );
729         }
730     }
731 
732     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_) private {
733         externalSettings.updateLongExtra(_pID);
734 
735         if (plyrRnds_[_pID][_rID].keys == 0) {
736             _eventData_ = managePlayer(_pID, _eventData_);
737         }
738 
739         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000) {
740             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
741             uint256 _refund = _eth.sub(_availableLimit);
742             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
743             _eth = _availableLimit;
744         }
745 
746         if (_eth > 1000000000) {
747             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
748             if (_keys >= 1000000000000000000) {
749                 updateTimer(_keys, _rID);
750 
751                 if (round_[_rID].plyr != _pID) {
752                     round_[_rID].plyr = _pID;
753                 }
754                 if (round_[_rID].team != _team) {
755                     round_[_rID].team = _team;
756                 }
757 
758                 _eventData_.compressedData = _eventData_.compressedData + 100;
759             }
760 
761             if (_eth >= 100000000000000000) {
762                 airDropTracker_++;
763                 if (airdrop() == true) {
764                     uint256 _prize;
765                     if (_eth >= 10000000000000000000) {
766                         _prize = ((airDropPot_).mul(75)) / 100;
767                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
768 
769                         airDropPot_ = (airDropPot_).sub(_prize);
770 
771                         _eventData_.compressedData += 300000000000000000000000000000000;
772                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
773                         _prize = ((airDropPot_).mul(50)) / 100;
774                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
775 
776                         airDropPot_ = (airDropPot_).sub(_prize);
777 
778                         _eventData_.compressedData += 200000000000000000000000000000000;
779                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
780                         _prize = ((airDropPot_).mul(25)) / 100;
781                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
782 
783                         airDropPot_ = (airDropPot_).sub(_prize);
784 
785                         _eventData_.compressedData += 300000000000000000000000000000000;
786                     }
787 
788                     _eventData_.compressedData += 10000000000000000000000000000000;
789                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
790 
791                     airDropTracker_ = 0;
792                 }
793             }
794 
795             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
796 
797             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
798             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
799 
800             round_[_rID].keys = _keys.add(round_[_rID].keys);
801             round_[_rID].eth = _eth.add(round_[_rID].eth);
802             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
803 
804             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
805             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
806 
807 		    endTx(_pID, _team, _eth, _keys, _eventData_);
808         }
809     }
810 
811     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256) {
812         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
813     }
814 
815     function calcKeysReceived(uint256 _rID, uint256 _eth) public view returns(uint256) {
816         uint256 _now = block.timestamp;
817         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
818             return (round_[_rID].eth).keysRec(_eth);
819         }
820         return (_eth).keys();
821     }
822 
823     function iWantXKeys(uint256 _keys) public view returns(uint256) {
824         uint256 _now = block.timestamp;
825         uint256 _rID = rID_;
826         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
827             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
828         }
829         return ( (_keys).eth() );
830     }
831 
832     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external {
833         require (msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
834         if (pIDxAddr_[_addr] != _pID) {
835             pIDxAddr_[_addr] = _pID;
836         }
837         if (pIDxName_[_name] != _pID) {
838             pIDxName_[_name] = _pID;
839         }
840         if (plyr_[_pID].addr != _addr) {
841             plyr_[_pID].addr = _addr;
842         }
843         if (plyr_[_pID].name != _name) {
844             plyr_[_pID].name = _name;
845         }
846         if (plyr_[_pID].laff != _laff) {
847             plyr_[_pID].laff = _laff;
848         }
849         if (plyrNames_[_pID][_name] == false) {
850             plyrNames_[_pID][_name] = true;
851         }
852     }
853 
854     function receivePlayerNameList(uint256 _pID, bytes32 _name) external {
855         require (msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
856         if(plyrNames_[_pID][_name] == false) {
857             plyrNames_[_pID][_name] = true;
858         }
859     }
860 
861     function determinePID(F3Ddatasets.EventReturns memory _eventData_) private returns (F3Ddatasets.EventReturns) {
862         uint256 _pID = pIDxAddr_[msg.sender];
863         if (_pID == 0) {
864             _pID = playerBook.getPlayerID(msg.sender);
865             bytes32 _name = playerBook.getPlayerName(_pID);
866             uint256 _laff = playerBook.getPlayerLAff(_pID);
867 
868             pIDxAddr_[msg.sender] = _pID;
869             plyr_[_pID].addr = msg.sender;
870 
871             if (_name != "") {
872                 pIDxName_[_name] = _pID;
873                 plyr_[_pID].name = _name;
874                 plyrNames_[_pID][_name] = true;
875             }
876 
877             if (_laff != 0 && _laff != _pID) {
878                 plyr_[_pID].laff = _laff;
879             }
880 
881             _eventData_.compressedData = _eventData_.compressedData + 1;
882         }
883 
884         return (_eventData_);
885     }
886 
887     function verifyTeam(uint256 _team) private pure returns (uint256) {
888         if (_team < 0 || _team > 3) {
889             return 2;
890         }
891         return _team;
892     }
893 
894     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_) private returns (F3Ddatasets.EventReturns) {
895         if (plyr_[_pID].lrnd != 0) {
896             updateGenVault(_pID, plyr_[_pID].lrnd);
897         }
898         plyr_[_pID].lrnd = rID_;
899 
900         _eventData_.compressedData = _eventData_.compressedData + 10;
901 
902         return _eventData_;
903     }
904 
905     function endRound(F3Ddatasets.EventReturns memory _eventData_) private returns (F3Ddatasets.EventReturns) {
906         uint256 _rID = rID_;
907 
908         uint256 _winPID = round_[_rID].plyr;
909         uint256 _winTID = round_[_rID].team;
910 
911         uint256 _pot = round_[_rID].pot;
912 
913         // 中奖者拿走 58%
914         uint256 _win = (_pot.mul(58)) / 100;
915 
916         // 提取社区基金 2%
917         uint256 _com = (_pot / 50);
918 
919         // 所在团队分红
920         uint256 _gen = (_pot.mul(potSplit_[_winTID])) / 100;
921 
922         // 进入下一轮奖池
923         uint256 _res = _pot.sub(_win).sub(_com).sub(_gen);
924 
925         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
926         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
927         if (_dust > 0) {
928             _gen = _gen.sub(_dust);
929             _res = _res.add(_dust);
930         }
931 
932         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
933 
934         partnership.deposit.value(_com)();
935 
936         round_[_rID].mask = _ppt.add(round_[_rID].mask);
937 
938         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
939         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
940         _eventData_.winnerAddr = plyr_[_winPID].addr;
941         _eventData_.winnerName = plyr_[_winPID].name;
942         _eventData_.amountWon = _win;
943         _eventData_.genAmount = _gen;
944         _eventData_.newPot = _res;
945 
946         rID_++;
947         _rID++;
948         round_[_rID].strt = block.timestamp;
949         round_[_rID].end = block.timestamp.add(rndInit_).add(rndGap_);
950         round_[_rID].pot = _res;
951 
952         return(_eventData_);
953     }
954 
955     function updateGenVault(uint256 _pID, uint256 _rIDlast) private {
956         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
957         if (_earnings > 0) {
958             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
959             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
960         }
961     }
962 
963     function updateTimer(uint256 _keys, uint256 _rID) private {
964         uint256 _now = block.timestamp;
965 
966         uint256 _newTime;
967         if (_now > round_[_rID].end && round_[_rID].plyr == 0) {
968             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
969         } else {
970             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
971         }
972 
973         if (_newTime < (rndMax_).add(_now)) {
974             round_[_rID].end = _newTime;
975         } else {
976             round_[_rID].end = rndMax_.add(_now);
977         }
978     }
979 
980     function airdrop() private view returns(bool) {
981         uint256 seed = uint256(keccak256(abi.encodePacked(
982             (block.timestamp).add(
983                 block.difficulty
984             ).add(
985                 uint256(keccak256(abi.encodePacked(block.coinbase))) / block.timestamp
986             ).add(
987                 block.gaslimit
988             ).add(
989                 (uint256(keccak256(abi.encodePacked(msg.sender)))) / block.timestamp
990             ).add(
991                 block.number
992             )
993         )));
994 
995         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_) {
996             return true;
997         }
998 
999         return false;
1000     }
1001 
1002     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_) private returns(F3Ddatasets.EventReturns) {
1003         // 社区基金 4%
1004         uint256 _com = _eth / 25;
1005         partnership.deposit.value(_com)();
1006 
1007         // 直接推荐人 5%
1008         uint256 _firstAff = _eth / 20;
1009 
1010         if (_affID == _pID || plyr_[_affID].name == "") {
1011             _affID = 1;
1012         }
1013         plyr_[_affID].aff = _firstAff.add(plyr_[_affID].aff);
1014         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _firstAff, block.timestamp);
1015 
1016         // 二级推荐人 10%
1017         uint256 _secondAff = _eth / 10;
1018 
1019         uint256 _secondAffID = plyr_[_affID].laff;
1020         if (_secondAffID == plyr_[_secondAffID].laff && plyr_[_secondAffID].name == "") {
1021             _secondAffID = 1;
1022         }
1023         plyr_[_secondAffID].aff = _secondAff.add(plyr_[_secondAffID].aff);
1024         emit F3Devents.onAffiliatePayout(_secondAffID, plyr_[_secondAffID].addr, plyr_[_secondAffID].name, _rID, _affID, _secondAff, block.timestamp);
1025 
1026         return _eventData_;
1027     }
1028 
1029     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_) private returns(F3Ddatasets.EventReturns) {
1030         // 团队分红
1031         uint256 _gen = (_eth.mul(fees_[_team])) / 100;
1032 
1033         // 空投奖池 1%
1034         uint256 _air = _eth / 100;
1035         airDropPot_ = airDropPot_.add(_air);
1036 
1037         // 奖池
1038         uint256 _pot = _eth.sub(_gen.add(_eth / 5));
1039 
1040         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1041         if (_dust > 0) {
1042             _gen = _gen.sub(_dust);
1043         }
1044 
1045         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1046 
1047         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1048         _eventData_.potAmount = _pot;
1049 
1050         return(_eventData_);
1051     }
1052 
1053     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256) {
1054         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1055         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1056 
1057         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1058         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1059 
1060         return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1061     }
1062 
1063     function withdrawEarnings(uint256 _pID) private returns(uint256) {
1064         updateGenVault(_pID, plyr_[_pID].lrnd);
1065 
1066         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1067         if (_earnings > 0) {
1068             plyr_[_pID].win = 0;
1069             plyr_[_pID].gen = 0;
1070             plyr_[_pID].aff = 0;
1071         }
1072 
1073         return(_earnings);
1074     }
1075 
1076     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_) private {
1077         _eventData_.compressedData = _eventData_.compressedData + (block.timestamp * 1000000000000000000) + (_team * 100000000000000000000000000000);
1078         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1079 
1080         emit F3Devents.onEndTx(
1081             _eventData_.compressedData,
1082             _eventData_.compressedIDs,
1083             plyr_[_pID].name,
1084             msg.sender,
1085             _eth,
1086             _keys,
1087             _eventData_.winnerAddr,
1088             _eventData_.winnerName,
1089             _eventData_.amountWon,
1090             _eventData_.newPot,
1091             _eventData_.genAmount,
1092             _eventData_.potAmount,
1093             airDropPot_
1094         );
1095     }
1096 
1097     function activate() public onlyOwner {
1098         require(activated_ == false, "fomo3d already activated");
1099 
1100         activated_ = true;
1101 
1102 		rID_ = 1;
1103         round_[1].strt = block.timestamp + rndExtra_ - rndGap_;
1104         round_[1].end = block.timestamp + rndInit_ + rndExtra_;
1105     }
1106 }