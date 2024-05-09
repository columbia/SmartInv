1 pragma solidity ^0.4.24;
2 
3 
4 contract OneEther {
5 
6     event onOpenNewBet(
7         uint256 indexed bID,
8         address owner,
9         uint256 check,
10         uint256 unit,
11         uint256 recordTime
12     );
13 
14     event onEditBet(
15         uint256 indexed bID,
16         address owner,
17         uint256 check,
18         uint256 unit,
19         uint256 recordTime
20     );
21 
22     event onOpenNewRound(
23         uint256 indexed bID,
24         uint256 indexed rID,
25         uint256 total,
26         uint256 current,
27         uint256 ethAmount,
28         uint256 recordTime
29     );
30 
31     event RoundMask(
32         uint256 rID,
33         bytes32 hashmask
34     );
35 
36     event onReveal(
37         uint256 indexed rID,
38         address winner,
39         uint256 reward,
40         uint256 teamFee,
41         uint256 scretNumber,
42         uint256 randomNumber,
43         uint256 recordTime
44     );
45 
46     event onBuyBet(
47         uint256 indexed bID,
48         uint256 indexed rID,
49         address playerAddress,
50         uint256 amount,
51         uint256 key,
52         uint256 playerCode,
53         uint256 invator,
54         uint256 recordTime
55     );
56 
57     event onRoundUpdate(
58         uint256 indexed bID,
59         uint256 indexed rID,
60         uint256 totalKey,
61         uint256 currentKey,
62         uint256 lastUpdate
63     );
64 
65     event onRoundEnd(
66         uint256 indexed bID,
67         uint256 indexed rID,
68         uint256 lastUpdate
69     );
70 
71     event onWithdraw
72     (
73         uint256 indexed playerID,
74         address indexed playerAddress,
75         uint256 ethOut,
76         uint256 recordTime
77     );
78 
79     event onBuyFailed
80     (
81         uint256 indexed playerID,
82         uint256 indexed rID,
83         uint256 ethIn,
84         uint256 recordTime
85     );
86 
87     using SafeMath for *;
88 
89     address private owner = msg.sender;
90     address private admin = msg.sender;
91     bytes32 constant public NAME = "OneEther";
92     bytes32 constant public SYMBOL = "OneEther";
93     uint256 constant  MIN_BUY = 0.001 ether;
94     uint256 constant  MAX_BUY = 30000 ether;
95     uint256 public linkPrice_ = 0.01 ether;
96     bool public activated_ = false;
97     uint256 private teamFee_ = 0; //team Fee Pot
98 
99     uint256 public bID = 10;
100     uint256 public pID = 100;
101     uint256 public rID = 1000;
102 
103     mapping(address => uint256) public pIDAddr_;//(addr => pID) returns player id by address
104     mapping(uint256 => OneEtherDatasets.BetInfo) public bIDBet_;
105     mapping(uint256 => OneEtherDatasets.Stake[]) public betList_;
106     mapping(uint256 => OneEtherDatasets.BetState) public rIDBet_;
107     mapping(uint256 => OneEtherDatasets.Player) public pIDPlayer_;
108     mapping(uint256 => uint256) public bIDrID_;
109     mapping(uint256 => address) public pIDAgent_;
110     uint256[] public bIDList_;
111 
112 //===============================================================
113 //   construct
114 //==============================================================
115     constructor() public {}
116 //===============================================================
117 //   The following are safety checks
118 //==============================================================
119     //isActivated
120 
121     modifier isAdmin() {require(msg.sender == admin, "its can only be call by admin");_;}
122 
123     modifier isbetActivated(uint256 _bID) {
124         require(bIDBet_[_bID].bID != 0 && bIDBet_[_bID].isActivated == true, "cant find this bet");
125         _;
126     }
127 
128     modifier isActivated() {require(activated_ == true, "its not ready yet. ");_;}
129     //isAdmin
130 
131     modifier isWithinLimits(uint256 _eth) {
132         require(_eth >= MIN_BUY, "too small");
133         require(_eth <= MAX_BUY, "too big");
134         _;
135     }
136 
137     //activate game
138     function activate() public isAdmin() {require(activated_ == false, "the game is running");activated_ = true;}
139 
140     //close game  dangerous!
141     function close() public isAdmin() isActivated() {activated_ = false;}
142 
143 //===============================================================
144 //   Functions call by admin
145 //==============================================================
146     //set new admin
147     function setNewAdmin(address _addr)
148     public
149     {
150         require(msg.sender == owner);
151         admin = _addr;
152     }
153 
154     function openNewBet(address _owner, uint256 _check, uint256 _unit)
155     public
156     isAdmin()
157     isActivated()
158     {
159         require((_check >= MIN_BUY) && (_check <= MAX_BUY), "out of range");
160         require((_unit * 2) <= _check, "unit of payment dennied");
161         bID++;
162         bIDBet_[bID].bID = bID;
163         uint256 _now = now;
164         if (_owner == address(0)) {
165             bIDBet_[bID].owner = admin;
166         } else {
167             bIDBet_[bID].owner = _owner;
168         }
169         bIDBet_[bID].check = _check;
170         bIDBet_[bID].unit = _unit;
171         bIDBet_[bID].isActivated = true;
172         bIDList_.push(bID);
173         //emit
174         emit onOpenNewBet(bID, bIDBet_[bID].owner, _check, _unit, _now);
175     }
176 
177     function openFirstRound(uint256 _bID, bytes32 _maskHash)
178     public
179     isbetActivated(_bID)
180     {
181         address addr = msg.sender;
182         require(bIDBet_[bID].bID != 0, "cant find this bet");
183         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin, "Permission denied");
184         require(bIDrID_[_bID] == 0, "One Bet can only open one round");
185         newRound(_bID, _maskHash);
186     }
187 
188     function closeBet(uint256 _bID)
189     public
190     {
191         address addr = msg.sender;
192         require(bIDBet_[bID].bID != 0, "cant find this bet");
193         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin, "Permission denied");
194         // this means it cant be generated next round. current round would continue to end.
195         bIDBet_[_bID].isActivated = false;
196         //emit
197     }
198 
199     function openBet(uint256 _bID)
200     public
201     {
202         address addr = msg.sender;
203         require(bIDBet_[bID].bID != 0, "cant find this bet");
204         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin, "Permission denied");
205         require(bIDBet_[_bID].isActivated = false, "This bet is opening");
206         bIDBet_[_bID].isActivated = true;
207     }
208 
209     function editBet(uint256 _bID, uint256 _check, uint256 _unit)
210     public
211     {
212         require((_check >= MIN_BUY) && (_check <= MAX_BUY), "out of range");
213         address addr = msg.sender;
214         require(bIDBet_[_bID].bID != 0, "cant find this bet");
215         require(bIDBet_[bID].owner == addr || bIDBet_[bID].owner == admin, "Permission denied");
216 
217         bIDBet_[_bID].check = _check;
218         bIDBet_[_bID].unit = _unit;
219         emit onEditBet(bID, bIDBet_[bID].owner, _check, _unit, now);
220     }
221 
222     function withdrawFee()
223     public
224     isAdmin()
225     {
226         uint256 temp = teamFee_;
227         teamFee_ = 0;
228         msg.sender.transfer(temp);
229     }
230 
231     function registAgent(address _addr)
232     public
233     isAdmin()
234     {
235         uint256 _pID = pIDAddr_[_addr];
236         if (_pID == 0) {
237             // regist a new player
238             pID++;
239             pIDAddr_[_addr] = pID;
240             // set new player struct
241             pIDPlayer_[pID].addr = _addr;
242             pIDPlayer_[pID].balance = 0;
243             pIDPlayer_[pID].agent = 0;
244 
245             pIDAgent_[pID] = _addr;
246         } else {
247             pIDAgent_[_pID] = _addr;
248         }
249 
250     }
251 
252     function resetAgent(address _addr)
253     public
254     isAdmin() {
255         uint256 _pID = pIDAddr_[_addr];
256         if (_pID != 0) {
257             pIDAgent_[_pID] = address(0);
258         }
259     }
260 
261 //===============================================================
262 //   functions call by gameplayer
263 //==============================================================
264     function buySome(uint256 _rID, uint256 _key, uint256 _playerCode, uint256 _linkPID, uint256 _agent)
265     public
266     payable
267     {
268         require(rIDBet_[_rID].rID != 0, "cant find this round");
269         uint256 _bID = rIDBet_[_rID].bID;
270         require(bIDBet_[_bID].bID != 0, "cant find this bet");
271         require(_key <= rIDBet_[_rID].total, "key must not beyond limit");
272         require(msg.value >= bIDBet_[_bID].unit, "too small for this bet");
273         require(bIDBet_[_bID].unit * _key == msg.value, "not enough payment");
274         require(_playerCode < 100000000000000, "your random number is too big");
275         uint256 _pID = managePID(_linkPID, _agent);
276 
277         if (rIDBet_[_rID].current + _key <= rIDBet_[_rID].total) {
278             uint256 _value = manageLink(_pID, msg.value);
279             manageKey(_pID, _rID, _key);
280             rIDBet_[_rID].current = rIDBet_[_rID].current.add(_key);
281             rIDBet_[_rID].ethAmount = rIDBet_[_rID].ethAmount.add(_value);
282             rIDBet_[_rID].playerCode = rIDBet_[_rID].playerCode.add(_playerCode);
283             emit onBuyBet(_bID, _rID, pIDPlayer_[_pID].addr, _value, _key, _playerCode, pIDPlayer_[_pID].invator, now);
284 
285             if (rIDBet_[_rID].current >= rIDBet_[_rID].total) {
286                 emit onRoundEnd(_bID, _rID, now);
287             }
288         } else {
289             // failed to pay a bet,the value will be stored in player's balance
290             pIDPlayer_[_pID].balance = pIDPlayer_[_pID].balance.add(msg.value);
291             emit onBuyFailed(_pID, _rID, msg.value, now);
292         }
293 
294 
295     }
296 
297     function buyWithBalance(uint256 _rID, uint256 _key, uint256 _playerCode)
298     public
299     payable
300     {
301         uint256 _pID = pIDAddr_[msg.sender];
302         require(_pID != 0, "player not founded in contract ");
303         require(rIDBet_[_rID].rID != 0, "cant find this round");
304         uint256 _bID = rIDBet_[_rID].bID;
305         require(bIDBet_[_bID].bID != 0, "cant find this bet");
306 
307         uint256 _balance = pIDPlayer_[_pID].balance;
308         require(_key <= rIDBet_[_rID].total, "key must not beyond limit");
309         require(_balance >= bIDBet_[_bID].unit, "too small for this bet");
310         require(bIDBet_[_bID].unit * _key <= _balance, "not enough balance");
311         require(_playerCode < 100000000000000, "your random number is too big");
312 
313         require(rIDBet_[_rID].current + _key <= rIDBet_[_rID].total, "you beyond key");
314         pIDPlayer_[_pID].balance = pIDPlayer_[_pID].balance.sub(bIDBet_[_bID].unit * _key);
315         uint256 _value = manageLink(_pID, bIDBet_[_bID].unit * _key);
316         manageKey(_pID, _rID, _key);
317         rIDBet_[_rID].current = rIDBet_[_rID].current.add(_key);
318         rIDBet_[_rID].ethAmount = rIDBet_[_rID].ethAmount.add(_value);
319         rIDBet_[_rID].playerCode = rIDBet_[_rID].playerCode.add(_playerCode);
320 
321         emit onBuyBet(_bID, _rID, pIDPlayer_[_pID].addr, _value, _key, _playerCode, pIDPlayer_[_pID].invator, now);
322 
323         if (rIDBet_[_rID].current == rIDBet_[_rID].total) {
324             emit onRoundEnd(_bID, _rID, now);
325         }
326     }
327 
328     function reveal(uint256 _rID, uint256 _scretKey, bytes32 _maskHash)
329     public
330     {
331         require(rIDBet_[_rID].rID != 0, "cant find this round");
332         uint256 _bID = rIDBet_[_rID].bID;
333         require(bIDBet_[_bID].bID != 0, "cant find this bet");
334         require((bIDBet_[_bID].owner == msg.sender) || admin == msg.sender, "can only be revealed by admin or owner");
335         bytes32 check = keccak256(abi.encodePacked(_scretKey));
336         require(check == rIDBet_[_rID].maskHash, "scretKey is not match maskHash");
337 
338         uint256 modulo = rIDBet_[_rID].total;
339 
340          //get random , use secretnumber,playerCode,blockinfo
341         bytes32 random = keccak256(abi.encodePacked(check, rIDBet_[_rID].playerCode, (block.number + now)));
342         uint result = (uint(random) % modulo) + 1;
343         uint256 _winPID = 0;
344 
345         for (uint i = 0; i < betList_[_rID].length; i++) {
346             if (result >= betList_[_rID][i].start && result <= betList_[_rID][i].end) {
347                 _winPID = betList_[_rID][i].pID;
348                 break;
349             }
350         }
351         // pay the reward
352         uint256 reward = rIDBet_[_rID].ethAmount;
353         uint256 teamFee = (bIDBet_[_bID].check.mul(3))/100;
354         pIDPlayer_[_winPID].balance = pIDPlayer_[_winPID].balance.add(reward);
355         //emit
356         emit onReveal(_rID, pIDPlayer_[_winPID].addr, reward, teamFee, _scretKey, result, now);
357 
358         // delete thie round;
359         delete rIDBet_[_rID];
360         delete betList_[_rID];
361         bIDrID_[_bID] = 0;
362 
363         // start to reset round
364         newRound(_bID, _maskHash);
365     }
366 
367     function getPlayerByAddr(address _addr)
368     public
369     view
370     returns(uint256, uint256)
371     {
372         uint256 _pID = pIDAddr_[_addr];
373         return (_pID, pIDPlayer_[_pID].balance);
374     }
375 
376     function getRoundInfoByID(uint256 _rID)
377     public
378     view
379     returns(uint256, uint256, uint256, uint256, uint256, bytes32, uint256)
380     {
381         return
382         (
383             rIDBet_[_rID].rID,               //0
384             rIDBet_[_rID].bID,               //1
385             rIDBet_[_rID].total,             //2
386             rIDBet_[_rID].current,           //3
387             rIDBet_[_rID].ethAmount,         //4
388             rIDBet_[_rID].maskHash,          //5
389             rIDBet_[_rID].playerCode     //6
390             );
391     }
392 
393     function getBetInfoByID(uint256 _bID)
394     public
395     view
396     returns(uint256, uint256, address, uint256, uint256, bool)
397     {
398         return
399         (
400             bIDrID_[_bID], //get current rID
401             bIDBet_[_bID].bID,
402             bIDBet_[_bID].owner,
403             bIDBet_[_bID].check,
404             bIDBet_[_bID].unit,
405             bIDBet_[_bID].isActivated
406             );
407     }
408 
409     function getBIDList()
410     public
411     view
412     returns(uint256[])
413     {return(bIDList_);}
414 
415     function getAgent(address _addr)
416     public
417     view
418     returns(uint256)
419     {
420         uint256 _pID = pIDAddr_[_addr];
421         return pIDAgent_[_pID] == address(0) ? 0 : _pID;
422     }
423 
424     function withdraw()
425     public
426     isActivated()
427     {
428         uint256 _now = now;
429         uint256 _pID = pIDAddr_[msg.sender];
430         uint256 _eth;
431 
432         if (_pID != 0) {
433             _eth = withdrawEarnings(_pID);
434             require(_eth > 0, "no any balance left");
435             pIDPlayer_[_pID].addr.transfer(_eth);
436 
437             emit onWithdraw(_pID, msg.sender, _eth, _now);
438         }
439     }
440 //===============================================================
441 //   internal call
442 //==============================================================
443 
444     function manageKey(uint256 _pID, uint256 _rID, uint256 _key)
445     private
446     {
447         uint256 _current = rIDBet_[_rID].current;
448 
449         OneEtherDatasets.Stake memory _playerstake = OneEtherDatasets.Stake(0, 0, 0);
450         _playerstake.start = _current + 1;
451         _playerstake.end = _current + _key;
452         _playerstake.pID = _pID;
453 
454         betList_[_rID].push(_playerstake);
455     }
456 
457     function manageLink(uint256 _pID, uint256 _value)
458     private
459     returns(uint256)
460     {
461         uint256 cut = (_value.mul(3))/100;//3% for teamFee
462         uint256 _value2 = _value.sub(cut);
463 
464         uint256 _invator = pIDPlayer_[_pID].invator;
465         if (_invator != 0) {
466             uint256 cut2 = (cut.mul(60))/100; //2% for the invator
467             cut = cut.sub(cut2);
468             pIDPlayer_[_invator].balance = pIDPlayer_[_invator].balance.add(cut2);
469         }
470         //agent Fee
471         uint256 _agent = pIDPlayer_[_pID].agent;
472         if (_agent != 0 && pIDAgent_[_agent] != address(0)) {
473             uint256 cut3 = (cut.mul(50))/100; //50% for the agent
474             cut = cut.sub(cut3);
475             pIDPlayer_[_agent].balance = pIDPlayer_[_agent].balance.add(cut3);
476         }
477         teamFee_ = teamFee_.add(cut);
478         return _value2;
479     }
480 
481     function managePID(uint256 _linkPID, uint256 _agent)
482     private
483     returns (uint256)
484     {
485         uint256 _pID = pIDAddr_[msg.sender];
486 
487         if (_pID == 0) {
488             // regist a new player
489             pID++;
490             pIDAddr_[msg.sender] = pID;
491 
492 
493             // set new player struct
494             pIDPlayer_[pID].addr = msg.sender;
495             pIDPlayer_[pID].balance = 0;
496             pIDPlayer_[pID].agent = 0;
497 
498             if (pIDPlayer_[_linkPID].addr != address(0)) {
499                 pIDPlayer_[pID].invator = _linkPID;
500                 pIDPlayer_[pID].agent = pIDPlayer_[_linkPID].agent;
501             } else {
502                 if (pIDAgent_[_agent] != address(0)) {
503                     pIDPlayer_[pID].agent = _agent;
504                 }
505             }
506             return (pID);
507         } else {
508             return (_pID);
509         }
510 
511     }
512 
513     function newRound(uint256 _bID, bytes32 _maskHash)
514     private
515     {
516         uint256 _total = bIDBet_[_bID].check / bIDBet_[_bID].unit;
517         if (bIDBet_[_bID].isActivated == true) {
518             rID++;
519             rIDBet_[rID].rID = rID;
520             rIDBet_[rID].bID = _bID;
521             rIDBet_[rID].total = _total;
522             rIDBet_[rID].current = 0;
523             rIDBet_[rID].ethAmount = 0;
524             rIDBet_[rID].maskHash = _maskHash;
525             rIDBet_[rID].playerCode = 0;
526 
527             bIDrID_[_bID] = rID;
528             emit onOpenNewRound(_bID, rID, rIDBet_[rID].total, rIDBet_[rID].current, rIDBet_[rID].ethAmount, now);
529             emit RoundMask(rID, _maskHash);
530         } else {
531             bIDrID_[_bID] = 0;
532         }
533 
534     }
535 
536     function withdrawEarnings(uint256 _pID)
537         private
538         returns(uint256)
539     {
540         uint256 _earnings = pIDPlayer_[_pID].balance;
541         if (_earnings > 0) {
542             pIDPlayer_[_pID].balance = 0;
543         }
544 
545         return(_earnings);
546     }
547 }
548 
549 
550 library OneEtherDatasets {
551 
552     struct BetInfo {
553         uint256 bID;
554         address owner;
555         uint256 check;
556         uint256 unit;
557         bool isActivated;
558     }
559 
560     struct BetState {
561         uint256 rID;
562         uint256 bID;
563         uint256 total;
564         uint256 current;
565         uint256 ethAmount;
566         bytes32 maskHash;
567         uint256 playerCode;
568     }
569 
570     struct Player {
571         address addr;
572         uint256 balance;
573         uint256 invator;
574         uint256 agent;
575     }
576 
577     struct Stake {
578         uint256 start;
579         uint256 end;
580         uint256 pID;
581     }
582 }
583 
584 
585 library SafeMath {
586 
587     /**
588     * @dev Multiplies two numbers, throws on overflow.
589     */
590     function mul(uint256 a, uint256 b)
591         internal
592         pure
593         returns (uint256 c)
594     {
595         if (a == 0) {
596             return 0;
597         }
598         c = a * b;
599         require(c / a == b, "SafeMath mul failed");
600         return c;
601     }
602 
603     /**
604     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
605     */
606     function sub(uint256 a, uint256 b)
607         internal
608         pure
609         returns (uint256)
610     {
611         require(b <= a, "SafeMath sub failed");
612         return a - b;
613     }
614 
615     /**
616     * @dev Adds two numbers, throws on overflow.
617     */
618     function add(uint256 a, uint256 b)
619         internal
620         pure
621         returns (uint256 c)
622     {
623         c = a + b;
624         require(c >= a, "SafeMath add failed");
625         return c;
626     }
627 
628     /**
629      * @dev gives square root of given x.
630      */
631     function sqrt(uint256 x)
632         internal
633         pure
634         returns (uint256 y)
635     {
636         uint256 z = ((add(x, 1)) / 2);
637         y = x;
638         while (z < y) {
639             y = z;
640             z = ((add((x / z), z)) / 2);
641         }
642     }
643 
644     /**
645      * @dev gives square. multiplies x by x
646      */
647     function sq(uint256 x)
648         internal
649         pure
650         returns (uint256)
651     {
652         return (mul(x, x));
653     }
654 
655     /**
656      * @dev x to the power of y
657      */
658     function pwr(uint256 x, uint256 y)
659         internal
660         pure
661         returns (uint256)
662     {
663         if (x == 0)
664             return (0);
665         else if (y == 0)
666                 return (1);
667         else {
668             uint256 z = x;
669             for (uint256 i = 1; i < y; i++)
670                 z = mul(z, x);
671             return (z);
672         }
673     }
674 }