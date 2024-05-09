1 pragma solidity ^0.4.24;
2 
3 interface ExtSettingInterface {
4     function getLongGap() external returns(uint256);
5     function setLongGap(uint256 _gap) external;
6     function getLongExtra() external returns(uint256);
7     function setLongExtra(uint256 _extra) external;
8 }
9 
10 interface FoundationInterface {
11     function deposit() external payable;
12 }
13 
14 interface PlayerBookInterface {
15     function getPlayerID(address _addr) external returns (uint256);
16     function getPlayerName(uint256 _pID) external view returns (bytes32);
17     function getPlayerLAff(uint256 _pID) external view returns (uint256);
18     function getPlayerAddr(uint256 _pID) external view returns (address);
19     function getNameFee() external view returns (uint256);
20     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
21     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
22     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
23 }
24 
25 contract Events {
26     event onNewName(
27         uint256 indexed playerID,
28         address indexed playerAddress,
29         bytes32 indexed playerName,
30         bool isNewPlayer,
31         uint256 affiliateID,
32         address affiliateAddress,
33         bytes32 affiliateName,
34         uint256 amountPaid,
35         uint256 timeStamp
36     );
37 
38     event onEndTx(
39         uint256 compressedData,
40         uint256 compressedIDs,
41         bytes32 playerName,
42         address playerAddress,
43         uint256 ethIn,
44         uint256 keysBought,
45         address winnerAddr,
46         bytes32 winnerName,
47         uint256 amountWon,
48         uint256 newPot,
49         uint256 genAmount,
50         uint256 potAmount,
51         uint256 airDropPot
52     );
53 
54     event onWithdraw(
55         uint256 indexed playerID,
56         address playerAddress,
57         bytes32 playerName,
58         uint256 ethOut,
59         uint256 timeStamp
60     );
61 
62     event onWithdrawAndDistribute(
63         address playerAddress,
64         bytes32 playerName,
65         uint256 ethOut,
66         uint256 compressedData,
67         uint256 compressedIDs,
68         address winnerAddr,
69         bytes32 winnerName,
70         uint256 amountWon,
71         uint256 newPot,
72         uint256 genAmount
73     );
74 
75     event onBuyAndDistribute(
76         address playerAddress,
77         bytes32 playerName,
78         uint256 ethIn,
79         uint256 compressedData,
80         uint256 compressedIDs,
81         address winnerAddr,
82         bytes32 winnerName,
83         uint256 amountWon,
84         uint256 newPot,
85         uint256 genAmount
86     );
87 
88     event onReLoadAndDistribute(
89         address playerAddress,
90         bytes32 playerName,
91         uint256 compressedData,
92         uint256 compressedIDs,
93         address winnerAddr,
94         bytes32 winnerName,
95         uint256 amountWon,
96         uint256 newPot,
97         uint256 genAmount
98     );
99 
100     event onAffiliatePayout(
101         uint256 indexed affiliateID,
102         address affiliateAddress,
103         bytes32 affiliateName,
104         uint256 indexed roundID,
105         uint256 indexed buyerID,
106         uint256 amount,
107         uint256 timeStamp
108     );
109 }
110 
111 contract Ownable {
112     address public owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     constructor() public {
117         owner = msg.sender;
118     }
119 
120     modifier onlyOwner() {
121         require(msg.sender == owner, "You are not owner.");
122         _;
123     }
124 
125     function transferOwnership(address _newOwner) public onlyOwner {
126         require(_newOwner != address(0), "Invalid address.");
127 
128         owner = _newOwner;
129 
130         emit OwnershipTransferred(owner, _newOwner);
131     }
132 }
133 
134 contract Fomo3D is Ownable, Events {
135     using SafeMath for *;
136     using NameFilter for string;
137     using KeysCalcLong for uint256;
138 
139     ExtSettingInterface private extSetting = ExtSettingInterface(0xb62aB70d1418c3Dfad706C0FdEA6499d2F380cE9);
140     FoundationInterface private foundation = FoundationInterface(0xC00C9ed7f35Ca2373462FD46d672084a6a128E2B);
141 	PlayerBookInterface private playerBook = PlayerBookInterface(0x6384FE27b7b6cC999Aa750689c6B04acaeaB78D7);
142 
143     string constant public name = "Fomo3D Asia (Official)";
144     string constant public symbol = "F3DA";
145 
146     uint256 constant private rndInit_ = 1 hours;
147     uint256 constant private rndInc_ = 30 seconds;
148     uint256 constant private rndMax_ = 24 hours;
149 
150 	uint256 private rndExtra_ = extSetting.getLongExtra();
151     uint256 private rndGap_ = extSetting.getLongGap();
152 
153 	uint256 public airDropPot_;
154     uint256 public airDropTracker_ = 0;
155     uint256 public rID_;
156 
157     bool public activated_ = false;
158 
159     mapping (address => uint256) public pIDxAddr_;
160     mapping (bytes32 => uint256) public pIDxName_;
161     mapping (uint256 => Datasets.Player) public plyr_;
162     mapping (uint256 => mapping (uint256 => Datasets.PlayerRounds)) public plyrRnds_;
163     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
164 
165     mapping (uint256 => Datasets.Round) public round_;
166     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
167 
168     mapping (uint256 => uint256) public fees_;
169     mapping (uint256 => uint256) public potSplit_;
170 
171     modifier isActivated() {
172         require(activated_ == true, "its not ready yet.  check ?eta in discord");
173         _;
174     }
175 
176     modifier isHuman() {
177         address _addr = msg.sender;
178         uint256 _codeLength;
179 
180         assembly {
181             _codeLength := extcodesize(_addr)
182         }
183 
184         require(_codeLength == 0, "sorry humans only");
185         _;
186     }
187 
188     modifier isWithinLimits(uint256 _eth) {
189         require(_eth >= 1000000000, "pocket lint: not a valid currency");
190         require(_eth <= 100000000000000000000000, "no vitalik, no");
191         _;
192     }
193 
194     constructor() public {
195 		// 团队分配比例（0 = 鲸队; 1 = 熊队; 2 = 蛇队; 3 = 牛队）
196 
197         fees_[0] = 30;   //50% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
198         fees_[1] = 35;   //45% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
199         fees_[2] = 50;   //30% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
200         fees_[3] = 45;   //35% 奖池, 15% 推荐人, 4% 社区基金, 1% 空投奖池
201 
202         potSplit_[0] = 30;  //58% 中奖者, 10% 下一轮奖池, 2% 社区基金
203         potSplit_[1] = 25;  //58% 中奖者, 15% 下一轮奖池, 2% 社区基金
204         potSplit_[2] = 10;  //58% 中奖者, 30% 下一轮奖池, 2% 社区基金
205         potSplit_[3] = 15;  //58% 中奖者, 25% 下一轮奖池, 2% 社区基金
206 	}
207 
208     function() public payable isActivated isHuman isWithinLimits(msg.value) {
209         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
210 
211         uint256 _pID = pIDxAddr_[msg.sender];
212         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
213     }
214 
215     function setExtSettingInterface(address _extSetting) public onlyOwner {
216         extSetting = ExtSettingInterface(_extSetting);
217     }
218 
219     function setFoundationInterface(address _foundation) public onlyOwner {
220         foundation = FoundationInterface(_foundation);
221     }
222 
223     function setPlayerBookInterface(address _playerBook) public onlyOwner {
224         playerBook = PlayerBookInterface(_playerBook);
225     }
226 
227     function buyXid(uint256 _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
228         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
229 
230         uint256 _pID = pIDxAddr_[msg.sender];
231 
232         if (_affCode == 0 || _affCode == _pID) {
233             _affCode = plyr_[_pID].laff;
234         } else if (_affCode != plyr_[_pID].laff) {
235             plyr_[_pID].laff = _affCode;
236         }
237 
238         _team = verifyTeam(_team);
239 
240         buyCore(_pID, _affCode, _team, _eventData_);
241     }
242 
243     function buyXaddr(address _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
244         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
245 
246         uint256 _pID = pIDxAddr_[msg.sender];
247 
248         uint256 _affID;
249         if (_affCode == address(0) || _affCode == msg.sender) {
250             _affID = plyr_[_pID].laff;
251         } else {
252             _affID = pIDxAddr_[_affCode];
253             if (_affID != plyr_[_pID].laff) {
254                 plyr_[_pID].laff = _affID;
255             }
256         }
257 
258         _team = verifyTeam(_team);
259 
260         buyCore(_pID, _affID, _team, _eventData_);
261     }
262 
263     function buyXname(bytes32 _affCode, uint256 _team) public payable isActivated isHuman isWithinLimits(msg.value) {
264         Datasets.EventData memory _eventData_ = determinePID(_eventData_);
265 
266         uint256 _pID = pIDxAddr_[msg.sender];
267 
268         uint256 _affID;
269         if (_affCode == "" || _affCode == plyr_[_pID].name) {
270             _affID = plyr_[_pID].laff;
271         } else {
272             _affID = pIDxName_[_affCode];
273             if (_affID != plyr_[_pID].laff) {
274                 plyr_[_pID].laff = _affID;
275             }
276         }
277 
278         _team = verifyTeam(_team);
279 
280         buyCore(_pID, _affID, _team, _eventData_);
281     }
282 
283     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth) public payable isActivated isHuman isWithinLimits(msg.value) {
284         Datasets.EventData memory _eventData_;
285 
286         uint256 _pID = pIDxAddr_[msg.sender];
287 
288         if (_affCode == 0 || _affCode == _pID) {
289             _affCode = plyr_[_pID].laff;
290         } else if (_affCode != plyr_[_pID].laff) {
291             plyr_[_pID].laff = _affCode;
292         }
293 
294         _team = verifyTeam(_team);
295 
296         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
297     }
298 
299     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth) public payable isActivated isHuman isWithinLimits(msg.value) {
300         Datasets.EventData memory _eventData_;
301 
302         uint256 _pID = pIDxAddr_[msg.sender];
303 
304         uint256 _affID;
305         if (_affCode == address(0) || _affCode == msg.sender) {
306             _affID = plyr_[_pID].laff;
307         } else {
308             _affID = pIDxAddr_[_affCode];
309             if (_affID != plyr_[_pID].laff) {
310                 plyr_[_pID].laff = _affID;
311             }
312         }
313 
314         _team = verifyTeam(_team);
315 
316         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
317     }
318 
319     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth) public payable isActivated isHuman isWithinLimits(msg.value) {
320         Datasets.EventData memory _eventData_;
321 
322         uint256 _pID = pIDxAddr_[msg.sender];
323 
324         uint256 _affID;
325         if (_affCode == "" || _affCode == plyr_[_pID].name) {
326             _affID = plyr_[_pID].laff;
327         } else {
328             _affID = pIDxName_[_affCode];
329             if (_affID != plyr_[_pID].laff) {
330                 plyr_[_pID].laff = _affID;
331             }
332         }
333 
334         _team = verifyTeam(_team);
335 
336         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
337     }
338 
339     function withdraw() public isActivated isHuman {
340         uint256 _now = now;
341         uint256 _eth;
342         uint256 _pID = pIDxAddr_[msg.sender];
343         uint256 _rID = rID_;
344 
345         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) {
346             Datasets.EventData memory _eventData_;
347 
348 			round_[_rID].ended = true;
349             _eventData_ = endRound(_eventData_);
350 
351             _eth = withdrawEarnings(_pID);
352             if (_eth > 0) {
353                 plyr_[_pID].addr.transfer(_eth);
354             }
355 
356             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
357             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
358 
359             emit Events.onWithdrawAndDistribute(
360                 msg.sender,
361                 plyr_[_pID].name,
362                 _eth,
363                 _eventData_.compressedData,
364                 _eventData_.compressedIDs,
365                 _eventData_.winnerAddr,
366                 _eventData_.winnerName,
367                 _eventData_.amountWon,
368                 _eventData_.newPot,
369                 _eventData_.genAmount
370             );
371         } else {
372             _eth = withdrawEarnings(_pID);
373             if (_eth > 0) {
374                 plyr_[_pID].addr.transfer(_eth);
375             }
376 
377             emit Events.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
378         }
379     }
380 
381     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable isHuman {
382         bytes32 _name = _nameString.nameFilter();
383         address _addr = msg.sender;
384         uint256 _paid = msg.value;
385         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
386 
387         uint256 _pID = pIDxAddr_[_addr];
388 
389         emit Events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
390     }
391 
392     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable isHuman {
393         bytes32 _name = _nameString.nameFilter();
394         address _addr = msg.sender;
395         uint256 _paid = msg.value;
396         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
397 
398         uint256 _pID = pIDxAddr_[_addr];
399 
400         emit Events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
401     }
402 
403     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable isHuman {
404         bytes32 _name = _nameString.nameFilter();
405         address _addr = msg.sender;
406         uint256 _paid = msg.value;
407         (bool _isNewPlayer, uint256 _affID) = playerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
408 
409         uint256 _pID = pIDxAddr_[_addr];
410 
411         emit Events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
412     }
413 
414     function getBuyPrice() public view returns(uint256) {
415         uint256 _rID = rID_;
416         uint256 _now = now;
417         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
418             return ((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000));
419         } else {
420             return (75000000000000);
421         }
422     }
423 
424     function getTimeLeft() public view returns(uint256) {
425         uint256 _rID = rID_;
426         uint256 _now = now;
427         if (_now < round_[_rID].end) {
428             if (_now > round_[_rID].strt + rndGap_) {
429                 return ((round_[_rID].end).sub(_now));
430             } else {
431                 return ((round_[_rID].strt + rndGap_).sub(_now));
432             }
433         } else {
434             return(0);
435         }
436     }
437 
438     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256) {
439         uint256 _rID = rID_;
440         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) {
441             if (round_[_rID].plyr == _pID) {
442                 return (
443                     (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
444                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
445                     plyr_[_pID].aff
446                 );
447             } else {
448                 return (
449                     plyr_[_pID].win,
450                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
451                     plyr_[_pID].aff
452                 );
453             }
454         } else {
455             return (
456                 plyr_[_pID].win,
457                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
458                 plyr_[_pID].aff
459             );
460         }
461     }
462 
463     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256) {
464         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team])) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
465     }
466 
467     function getCurrentRoundInfo() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256) {
468         uint256 _rID = rID_;
469         return (
470             round_[_rID].ico,                               // 0
471             _rID,                                           // 1
472             round_[_rID].keys,                              // 2
473             round_[_rID].end,                               // 3
474             round_[_rID].strt,                              // 4
475             round_[_rID].pot,                               // 5
476             (round_[_rID].team + (round_[_rID].plyr * 10)), // 6
477             plyr_[round_[_rID].plyr].addr,                  // 7
478             plyr_[round_[_rID].plyr].name,                  // 8
479             rndTmEth_[_rID][0],                             // 9
480             rndTmEth_[_rID][1],                             // 10
481             rndTmEth_[_rID][2],                             // 11
482             rndTmEth_[_rID][3],                             // 12
483             airDropTracker_ + (airDropPot_ * 1000)          // 13
484         );
485     }
486 
487     function getPlayerInfoByAddress(address _addr) public view returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256) {
488         uint256 _rID = rID_;
489 
490         if (_addr == address(0)) {
491             _addr == msg.sender;
492         }
493 
494         uint256 _pID = pIDxAddr_[_addr];
495 
496         return (
497             _pID,                                                                   // 0
498             plyr_[_pID].name,                                                       // 1
499             plyrRnds_[_pID][_rID].keys,                                             // 2
500             plyr_[_pID].win,                                                        // 3
501             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),    // 4
502             plyr_[_pID].aff,                                                        // 5
503             plyrRnds_[_pID][_rID].eth                                               // 6
504         );
505     }
506 
507     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Datasets.EventData memory _eventData_) private {
508         uint256 _rID = rID_;
509 
510         uint256 _now = now;
511         if (_now > (round_[_rID].strt + rndGap_) && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
512             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
513         } else {
514             if (_now > round_[_rID].end && round_[_rID].ended == false) {
515 			    round_[_rID].ended = true;
516                 _eventData_ = endRound(_eventData_);
517 
518                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
519                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
520 
521                 emit Events.onBuyAndDistribute(
522                     msg.sender,
523                     plyr_[_pID].name,
524                     msg.value,
525                     _eventData_.compressedData,
526                     _eventData_.compressedIDs,
527                     _eventData_.winnerAddr,
528                     _eventData_.winnerName,
529                     _eventData_.amountWon,
530                     _eventData_.newPot,
531                     _eventData_.genAmount
532                 );
533             }
534 
535             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
536         }
537     }
538 
539     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Datasets.EventData memory _eventData_) private {
540         uint256 _rID = rID_;
541 
542         uint256 _now = now;
543         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
544             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
545 
546             core(_rID, _pID, _eth, _affID, _team, _eventData_);
547         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
548             round_[_rID].ended = true;
549             _eventData_ = endRound(_eventData_);
550 
551             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
552             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
553 
554             emit Events.onReLoadAndDistribute(
555                 msg.sender,
556                 plyr_[_pID].name,
557                 _eventData_.compressedData,
558                 _eventData_.compressedIDs,
559                 _eventData_.winnerAddr,
560                 _eventData_.winnerName,
561                 _eventData_.amountWon,
562                 _eventData_.newPot,
563                 _eventData_.genAmount
564             );
565         }
566     }
567 
568     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Datasets.EventData memory _eventData_) private {
569         extSetting.setLongExtra(_pID);
570 
571         if (plyrRnds_[_pID][_rID].keys == 0) {
572             _eventData_ = managePlayer(_pID, _eventData_);
573         }
574 
575         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000) {
576             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
577             uint256 _refund = _eth.sub(_availableLimit);
578             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
579             _eth = _availableLimit;
580         }
581 
582         if (_eth > 1000000000) {
583             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
584             if (_keys >= 1000000000000000000) {
585                 updateTimer(_keys, _rID);
586 
587                 if (round_[_rID].plyr != _pID) {
588                     round_[_rID].plyr = _pID;
589                 }
590                 if (round_[_rID].team != _team) {
591                     round_[_rID].team = _team;
592                 }
593 
594                 _eventData_.compressedData = _eventData_.compressedData + 100;
595             }
596 
597             if (_eth >= 100000000000000000) {
598                 airDropTracker_++;
599                 if (airdrop() == true) {
600                     uint256 _prize;
601                     if (_eth >= 10000000000000000000) {
602                         _prize = ((airDropPot_).mul(75)) / 100;
603                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
604 
605                         airDropPot_ = (airDropPot_).sub(_prize);
606 
607                         _eventData_.compressedData += 300000000000000000000000000000000;
608                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
609                         _prize = ((airDropPot_).mul(50)) / 100;
610                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
611 
612                         airDropPot_ = (airDropPot_).sub(_prize);
613 
614                         _eventData_.compressedData += 200000000000000000000000000000000;
615                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
616                         _prize = ((airDropPot_).mul(25)) / 100;
617                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
618 
619                         airDropPot_ = (airDropPot_).sub(_prize);
620 
621                         _eventData_.compressedData += 300000000000000000000000000000000;
622                     }
623 
624                     _eventData_.compressedData += 10000000000000000000000000000000;
625                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
626 
627                     airDropTracker_ = 0;
628                 }
629             }
630 
631             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
632 
633             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
634             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
635 
636             round_[_rID].keys = _keys.add(round_[_rID].keys);
637             round_[_rID].eth = _eth.add(round_[_rID].eth);
638             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
639 
640             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
641             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
642 
643 		    endTx(_pID, _team, _eth, _keys, _eventData_);
644         }
645     }
646 
647     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256) {
648         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
649     }
650 
651     function calcKeysReceived(uint256 _rID, uint256 _eth) public view returns(uint256) {
652         uint256 _now = now;
653         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
654             return ((round_[_rID].eth).keysRec(_eth));
655         } else {
656             return ((_eth).keys());
657         }
658     }
659 
660     function iWantXKeys(uint256 _keys) public view returns(uint256) {
661         uint256 _rID = rID_;
662 
663         uint256 _now = now;
664         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
665             return ((round_[_rID].keys.add(_keys)).ethRec(_keys));
666         } else {
667             return ((_keys).eth());
668         }
669     }
670 
671     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external {
672         require (msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
673         if (pIDxAddr_[_addr] != _pID) {
674             pIDxAddr_[_addr] = _pID;
675         }
676         if (pIDxName_[_name] != _pID) {
677             pIDxName_[_name] = _pID;
678         }
679         if (plyr_[_pID].addr != _addr) {
680             plyr_[_pID].addr = _addr;
681         }
682         if (plyr_[_pID].name != _name) {
683             plyr_[_pID].name = _name;
684         }
685         if (plyr_[_pID].laff != _laff) {
686             plyr_[_pID].laff = _laff;
687         }
688         if (plyrNames_[_pID][_name] == false) {
689             plyrNames_[_pID][_name] = true;
690         }
691     }
692 
693     function receivePlayerNameList(uint256 _pID, bytes32 _name) external {
694         require (msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
695         if (plyrNames_[_pID][_name] == false) {
696             plyrNames_[_pID][_name] = true;
697         }
698     }
699 
700     function determinePID(Datasets.EventData memory _eventData_) private returns (Datasets.EventData) {
701         uint256 _pID = pIDxAddr_[msg.sender];
702         if (_pID == 0) {
703             _pID = playerBook.getPlayerID(msg.sender);
704             bytes32 _name = playerBook.getPlayerName(_pID);
705             uint256 _laff = playerBook.getPlayerLAff(_pID);
706 
707             pIDxAddr_[msg.sender] = _pID;
708             plyr_[_pID].addr = msg.sender;
709 
710             if (_name != "") {
711                 pIDxName_[_name] = _pID;
712                 plyr_[_pID].name = _name;
713                 plyrNames_[_pID][_name] = true;
714             }
715 
716             if (_laff != 0 && _laff != _pID) {
717                 plyr_[_pID].laff = _laff;
718             }
719 
720             _eventData_.compressedData = _eventData_.compressedData + 1;
721         }
722         return (_eventData_);
723     }
724 
725     function verifyTeam(uint256 _team) private pure returns (uint256) {
726         if (_team < 0 || _team > 3) {
727             return (2);
728         } else {
729             return (_team);
730         }
731     }
732 
733     function managePlayer(uint256 _pID, Datasets.EventData memory _eventData_) private returns (Datasets.EventData) {
734         if (plyr_[_pID].lrnd != 0) {
735             updateGenVault(_pID, plyr_[_pID].lrnd);
736         }
737         plyr_[_pID].lrnd = rID_;
738 
739         _eventData_.compressedData = _eventData_.compressedData + 10;
740 
741         return(_eventData_);
742     }
743 
744     function endRound(Datasets.EventData memory _eventData_) private returns (Datasets.EventData) {
745         uint256 _rID = rID_;
746 
747         uint256 _winPID = round_[_rID].plyr;
748         uint256 _winTID = round_[_rID].team;
749 
750         uint256 _pot = round_[_rID].pot;
751 
752         // 中奖者拿走 58%
753         uint256 _win = (_pot.mul(58)) / 100;
754 
755         // 提取社区基金 2%
756         uint256 _com = (_pot / 50);
757 
758         // 所在团队分红
759         uint256 _gen = (_pot.mul(potSplit_[_winTID])) / 100;
760 
761         // 进入下一轮奖池
762         uint256 _res = ((_pot.sub(_win)).sub(_com)).sub(_gen);
763 
764         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
765         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
766         if (_dust > 0) {
767             _gen = _gen.sub(_dust);
768             _res = _res.add(_dust);
769         }
770 
771         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
772 
773         foundation.deposit.value(_com)();
774 
775         round_[_rID].mask = _ppt.add(round_[_rID].mask);
776 
777         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
778         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
779         _eventData_.winnerAddr = plyr_[_winPID].addr;
780         _eventData_.winnerName = plyr_[_winPID].name;
781         _eventData_.amountWon = _win;
782         _eventData_.genAmount = _gen;
783         _eventData_.newPot = _res;
784 
785         rID_++;
786         _rID++;
787         round_[_rID].strt = now;
788         round_[_rID].end = now.add(rndInit_).add(rndGap_);
789         round_[_rID].pot = _res;
790 
791         return (_eventData_);
792     }
793 
794     function updateGenVault(uint256 _pID, uint256 _rIDlast) private {
795         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
796         if (_earnings > 0) {
797             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
798             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
799         }
800     }
801 
802     function updateTimer(uint256 _keys, uint256 _rID) private {
803         uint256 _now = now;
804         uint256 _newTime;
805         if (_now > round_[_rID].end && round_[_rID].plyr == 0) {
806             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
807         } else {
808             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
809         }
810         if (_newTime < (rndMax_).add(_now)) {
811             round_[_rID].end = _newTime;
812         } else {
813             round_[_rID].end = rndMax_.add(_now);
814         }
815     }
816 
817     function airdrop() private view returns(bool) {
818         uint256 seed = uint256(keccak256(abi.encodePacked(
819             (now).add(block.difficulty).add(
820                 (uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)
821             ).add(block.gaslimit).add(
822                 (uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)
823             ).add(block.number)
824         )));
825         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_) {
826             return true;
827         } else {
828             return false;
829         }
830     }
831 
832     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, Datasets.EventData memory _eventData_) private returns(Datasets.EventData) {
833         // 社区基金 4%
834         uint256 _com = _eth / 25;
835         foundation.deposit.value(_com)();
836 
837         // 直接推荐人 5%
838         uint256 _firstAff = _eth / 20;
839 
840         if (_affID == _pID || plyr_[_affID].name == "") {
841             _affID = 1;
842         }
843         plyr_[_affID].aff = _firstAff.add(plyr_[_affID].aff);
844 
845         emit Events.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _firstAff, now);
846 
847         // 二级推荐人 10%
848         uint256 _secondAff = _eth / 10;
849 
850         uint256 _secondAffID = plyr_[_affID].laff;
851         if (_secondAffID == plyr_[_secondAffID].laff && plyr_[_secondAffID].name == "") {
852             _secondAffID = 1;
853         }
854         plyr_[_secondAffID].aff = _secondAff.add(plyr_[_secondAffID].aff);
855 
856         emit Events.onAffiliatePayout(_secondAffID, plyr_[_secondAffID].addr, plyr_[_secondAffID].name, _rID, _affID, _secondAff, now);
857 
858         return (_eventData_);
859     }
860 
861     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Datasets.EventData memory _eventData_) private returns(Datasets.EventData) {
862         // 团队分红
863         uint256 _gen = (_eth.mul(fees_[_team])) / 100;
864 
865         // 空投奖池 1%
866         uint256 _air = (_eth / 100);
867         airDropPot_ = airDropPot_.add(_air);
868 
869         // 奖池
870         uint256 _pot = _eth.sub((_eth / 5).add(_gen));
871 
872         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
873         if (_dust > 0) {
874             _gen = _gen.sub(_dust);
875         }
876 
877         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
878 
879         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
880         _eventData_.potAmount = _pot;
881 
882         return (_eventData_);
883     }
884 
885     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256) {
886         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
887         round_[_rID].mask = _ppt.add(round_[_rID].mask);
888 
889         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
890         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
891 
892         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
893     }
894 
895     function withdrawEarnings(uint256 _pID) private returns(uint256) {
896         updateGenVault(_pID, plyr_[_pID].lrnd);
897 
898         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
899         if (_earnings > 0) {
900             plyr_[_pID].win = 0;
901             plyr_[_pID].gen = 0;
902             plyr_[_pID].aff = 0;
903         }
904 
905         return(_earnings);
906     }
907 
908     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Datasets.EventData memory _eventData_) private {
909         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
910         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
911 
912         emit Events.onEndTx(
913             _eventData_.compressedData,
914             _eventData_.compressedIDs,
915             plyr_[_pID].name,
916             msg.sender,
917             _eth,
918             _keys,
919             _eventData_.winnerAddr,
920             _eventData_.winnerName,
921             _eventData_.amountWon,
922             _eventData_.newPot,
923             _eventData_.genAmount,
924             _eventData_.potAmount,
925             airDropPot_
926         );
927     }
928 
929     function activate() public onlyOwner {
930         require(activated_ == false, "fomo3d already activated");
931 
932         activated_ = true;
933 
934 		rID_ = 1;
935         round_[1].strt = now + rndExtra_ - rndGap_;
936         round_[1].end = now + rndInit_ + rndExtra_;
937     }
938 }
939 
940 library Datasets {
941     struct EventData {
942         uint256 compressedData;
943         uint256 compressedIDs;
944         address winnerAddr;
945         bytes32 winnerName;
946         uint256 amountWon;
947         uint256 newPot;
948         uint256 genAmount;
949         uint256 potAmount;
950     }
951 
952     struct Player {
953         address addr;
954         bytes32 name;
955         uint256 win;
956         uint256 gen;
957         uint256 aff;
958         uint256 lrnd;
959         uint256 laff;
960     }
961 
962     struct PlayerRounds {
963         uint256 eth;
964         uint256 keys;
965         uint256 mask;
966         uint256 ico;
967     }
968 
969     struct Round {
970         uint256 plyr;
971         uint256 team;
972         uint256 end;
973         bool ended;
974         uint256 strt;
975         uint256 keys;
976         uint256 eth;
977         uint256 pot;
978         uint256 mask;
979         uint256 ico;
980         uint256 icoGen;
981         uint256 icoAvg;
982     }
983 }
984 
985 library KeysCalcLong {
986     using SafeMath for *;
987 
988     function keysRec(uint256 _curEth, uint256 _newEth) internal pure returns (uint256) {
989         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
990     }
991 
992     function ethRec(uint256 _curKeys, uint256 _sellKeys) internal pure returns (uint256) {
993         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
994     }
995 
996     function keys(uint256 _eth) internal pure returns(uint256) {
997         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
998     }
999 
1000     function eth(uint256 _keys) internal pure returns(uint256) {
1001         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1002     }
1003 }
1004 
1005 library NameFilter {
1006     function nameFilter(string _input) internal pure returns(bytes32) {
1007         bytes memory _temp = bytes(_input);
1008         uint256 _length = _temp.length;
1009 
1010         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1011         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1012         if (_temp[0] == 0x30) {
1013             require(_temp[1] != 0x78, "string cannot start with 0x");
1014             require(_temp[1] != 0x58, "string cannot start with 0X");
1015         }
1016 
1017         bool _hasNonNumber;
1018 
1019         for (uint256 i = 0; i < _length; i++) {
1020             if (_temp[i] > 0x40 && _temp[i] < 0x5b) {
1021                 _temp[i] = byte(uint(_temp[i]) + 32);
1022 
1023                 if (_hasNonNumber == false) {
1024                     _hasNonNumber = true;
1025                 }
1026             } else {
1027                 require(_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
1028 
1029                 if (_temp[i] == 0x20) {
1030                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1031                 }
1032 
1033                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39)) {
1034                     _hasNonNumber = true;
1035                 }
1036             }
1037         }
1038 
1039         require(_hasNonNumber == true, "string cannot be only numbers");
1040 
1041         bytes32 _ret;
1042         assembly {
1043             _ret := mload(add(_temp, 32))
1044         }
1045 
1046         return (_ret);
1047     }
1048 }
1049 
1050 library SafeMath {
1051     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1052         if (a == 0) {
1053             return 0;
1054         }
1055         c = a * b;
1056         require(c / a == b, "SafeMath mul failed");
1057         return c;
1058     }
1059 
1060     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1061         require(b <= a, "SafeMath sub failed");
1062         return a - b;
1063     }
1064 
1065     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1066         c = a + b;
1067         require(c >= a, "SafeMath add failed");
1068         return c;
1069     }
1070 
1071     function sqrt(uint256 x) internal pure returns (uint256 y) {
1072         uint256 z = ((add(x,1)) / 2);
1073         y = x;
1074         while (z < y) {
1075             y = z;
1076             z = ((add((x / z), z)) / 2);
1077         }
1078     }
1079 
1080     function sq(uint256 x) internal pure returns (uint256) {
1081         return (mul(x, x));
1082     }
1083 
1084     function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
1085         if (x == 0) {
1086             return (0);
1087         } else if (y == 0) {
1088             return (1);
1089         } else {
1090             uint256 z = x;
1091             for (uint256 i = 1; i < y; i++) {
1092                 z = mul(z, x);
1093             }
1094             return (z);
1095         }
1096     }
1097 }