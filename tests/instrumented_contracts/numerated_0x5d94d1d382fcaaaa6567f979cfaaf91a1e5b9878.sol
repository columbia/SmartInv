1 pragma solidity ^0.4.24;
2 
3 // Contract setup ====================
4 contract Ownable {
5     address public owner;
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function Ownable() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract Pausable is Ownable {
25     event Pause(uint256 _id);
26     event Unpause(uint256 _id);
27 
28     bool public paused_1 = false;
29     bool public paused_2 = false;
30     bool public paused_3 = false;
31     bool public paused_4 = false;
32 
33     modifier whenNotPaused_1() {
34         require(!paused_1);
35         _;
36     }
37     modifier whenNotPaused_2() {
38         require(!paused_2);
39         _;
40     }
41     modifier whenNotPaused_3() {
42         require(!paused_3);
43         _;
44     }
45     modifier whenNotPaused_4() {
46         require(!paused_4);
47         _;
48     }
49 
50     modifier whenPaused_1() {
51         require(paused_1);
52         _;
53     }
54     modifier whenPaused_2() {
55         require(paused_2);
56         _;
57     }
58     modifier whenPaused_3() {
59         require(paused_3);
60         _;
61     }
62     modifier whenPaused_4() {
63         require(paused_4);
64         _;
65     }
66 
67     function pause_1() onlyOwner whenNotPaused_1 public {
68         paused_1 = true;
69         emit Pause(1);
70     }
71     function pause_2() onlyOwner whenNotPaused_2 public {
72         paused_2 = true;
73         emit Pause(2);
74     }
75     function pause_3() onlyOwner whenNotPaused_3 public {
76         paused_3 = true;
77         emit Pause(3);
78     }
79     function pause_4() onlyOwner whenNotPaused_4 public {
80         paused_4 = true;
81         emit Pause(4);
82     }
83 
84     function unpause_1() onlyOwner whenPaused_1 public {
85         paused_1 = false;
86         emit Unpause(1);
87     }
88     function unpause_2() onlyOwner whenPaused_2 public {
89         paused_2 = false;
90         emit Unpause(2);
91     }
92     function unpause_3() onlyOwner whenPaused_3 public {
93         paused_3 = false;
94         emit Unpause(3);
95     }
96     function unpause_4() onlyOwner whenPaused_4 public {
97         paused_4 = false;
98         emit Unpause(4);
99     }
100 }
101 
102 contract JCLYLong is Pausable  {
103     using SafeMath for *;
104 	
105     event KeyPurchase(address indexed purchaser, uint256 eth, uint256 amount);
106     event LeekStealOn();
107 
108     address private constant WALLET_ETH_COM1   = 0x2509CF8921b95bef38DEb80fBc420Ef2bbc53ce3; 
109     address private constant WALLET_ETH_COM2   = 0x18d9fc8e3b65124744553d642989e3ba9e41a95a; 
110 
111     // Configurables  ====================
112     uint256 constant private rndInit_ = 10 hours;      
113     uint256 constant private rndInc_ = 30 seconds;   
114     uint256 constant private rndMax_ = 24 hours;    
115 
116     // eth limiter
117     uint256 constant private ethLimiterRange1_ = 1e20;
118     uint256 constant private ethLimiterRange2_ = 5e20;
119     uint256 constant private ethLimiter1_ = 2e18;
120     uint256 constant private ethLimiter2_ = 7e18;
121 
122     // whitelist range
123     uint256 constant private whitelistRange_ = 1 days;
124 
125     // for price 
126     uint256 constant private priceStage1_ = 500e18;
127     uint256 constant private priceStage2_ = 1000e18;
128     uint256 constant private priceStage3_ = 2000e18;
129     uint256 constant private priceStage4_ = 4000e18;
130     uint256 constant private priceStage5_ = 8000e18;
131     uint256 constant private priceStage6_ = 16000e18;
132     uint256 constant private priceStage7_ = 32000e18;
133     uint256 constant private priceStage8_ = 64000e18;
134     uint256 constant private priceStage9_ = 128000e18;
135     uint256 constant private priceStage10_ = 256000e18;
136     uint256 constant private priceStage11_ = 512000e18;
137     uint256 constant private priceStage12_ = 1024000e18;
138 
139     // for gu phrase
140     uint256 constant private guPhrase1_ = 5 days;
141     uint256 constant private guPhrase2_ = 7 days;
142     uint256 constant private guPhrase3_ = 9 days;
143     uint256 constant private guPhrase4_ = 11 days;
144     uint256 constant private guPhrase5_ = 13 days;
145     uint256 constant private guPhrase6_ = 15 days;
146     uint256 constant private guPhrase7_ = 17 days;
147     uint256 constant private guPhrase8_ = 19 days;
148     uint256 constant private guPhrase9_ = 21 days;
149     uint256 constant private guPhrase10_ = 23 days;
150 
151 
152 // Data setup ====================
153     uint256 public contractStartDate_;    // contract creation time
154     uint256 public allMaskGu_; // for sharing eth-profit by holding gu
155     uint256 public allGuGiven_; // for sharing eth-profit by holding gu
156     mapping (uint256 => uint256) public playOrders_; // playCounter => pID
157 // AIRDROP DATA 
158     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
159     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
160     mapping (uint256 => mapping (uint256 => uint256)) public airDropWinners_; // counter => pID => winAmt
161     uint256 public airDropCount_;
162 // LEEKSTEAL DATA 
163     uint256 public leekStealPot_;             // person who gets the first leeksteal wins part of this pot
164     uint256 public leekStealTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning leek steal
165     uint256 public leekStealToday_;
166     bool public leekStealOn_;
167     mapping (uint256 => uint256) public dayStealTime_; // dayNum => time that makes leekSteal available
168     mapping (uint256 => uint256) public leekStealWins_; // pID => winAmt
169 // PLAYER DATA 
170     uint256 public pID_;        // total number of players
171     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
172     // mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
173     mapping (uint256 => Datasets.Player) public plyr_;   // (pID => data) player data
174     mapping (uint256 => mapping (uint256 => Datasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
175     mapping (uint256 => mapping (uint256 => Datasets.PlayerPhrases)) public plyrPhas_;    // (pID => phraseID => data) player round data by player id & round id
176 // ROUND DATA 
177     uint256 public rID_;    // round id number / total rounds that have happened
178     mapping (uint256 => Datasets.Round) public round_;   // (rID => data) round data
179 // PHRASE DATA 
180     uint256 public phID_; // gu phrase ID
181     mapping (uint256 => Datasets.Phrase) public phrase_;   // (phID_ => data) round data
182 // WHITELIST
183     mapping(address => bool) public whitelisted_Prebuy; // pID => isWhitelisted
184 
185 // Constructor ====================
186     constructor()
187         public
188     {
189         // set genesis player
190         pIDxAddr_[owner] = 0; 
191         plyr_[0].addr = owner; 
192         pIDxAddr_[WALLET_ETH_COM1] = 1; 
193         plyr_[1].addr = WALLET_ETH_COM1; 
194         pIDxAddr_[WALLET_ETH_COM2] = 2; 
195         plyr_[2].addr = WALLET_ETH_COM2; 
196         pID_ = 2;
197     }
198 
199 // Modifiers ====================
200 
201     modifier isActivated() {
202         require(activated_ == true); 
203         _;
204     }
205     
206     modifier isHuman() {
207         address _addr = msg.sender;
208         uint256 _codeLength;
209         
210         assembly {_codeLength := extcodesize(_addr)}
211         require(_codeLength == 0, "sorry humans only");
212         _;
213     }
214 
215     modifier isWithinLimits(uint256 _eth) {
216         require(_eth >= 1000000000);
217         require(_eth <= 100000000000000000000000);
218         _;    
219     }
220 
221     modifier withinMigrationPeriod() {
222         require(now < 1535637600);
223         _;
224     }
225     
226 // Public functions ====================
227 
228     function deposit() 
229         isWithinLimits(msg.value)
230         onlyOwner
231         public
232         payable
233     {}
234 
235     function migrateBasicData(uint256 allMaskGu, uint256 allGuGiven,
236         uint256 airDropPot, uint256 airDropTracker, uint256 leekStealPot, uint256 leekStealTracker, uint256 leekStealToday, 
237         uint256 pID, uint256 rID)
238         withinMigrationPeriod
239         onlyOwner
240         public
241     {
242         allMaskGu_ = allMaskGu;
243         allGuGiven_ = allGuGiven;
244         airDropPot_ = airDropPot;
245         airDropTracker_ = airDropTracker;
246         leekStealPot_ = leekStealPot;
247         leekStealTracker_ = leekStealTracker;
248         leekStealToday_ = leekStealToday;
249         pID_ = pID;
250         rID_ = rID;
251     }
252 
253     function migratePlayerData1(uint256 _pID, address addr, uint256 win,
254         uint256 gen, uint256 genGu, uint256 aff, uint256 refund, uint256 lrnd, 
255         uint256 laff, uint256 withdraw)
256         withinMigrationPeriod
257         onlyOwner
258         public
259     {
260         pIDxAddr_[addr] = _pID;
261 
262         plyr_[_pID].addr = addr;
263         plyr_[_pID].win = win;
264         plyr_[_pID].gen = gen;
265         plyr_[_pID].genGu = genGu;
266         plyr_[_pID].aff = aff;
267         plyr_[_pID].refund = refund;
268         plyr_[_pID].lrnd = lrnd;
269         plyr_[_pID].laff = laff;
270         plyr_[_pID].withdraw = withdraw;
271     }
272 
273     function migratePlayerData2(uint256 _pID, address addr, uint256 maskGu, 
274     uint256 gu, uint256 referEth, uint256 lastClaimedPhID)
275         withinMigrationPeriod
276         onlyOwner
277         public
278     {
279         pIDxAddr_[addr] = _pID;
280         plyr_[_pID].addr = addr;
281 
282         plyr_[_pID].maskGu = maskGu;
283         plyr_[_pID].gu = gu;
284         plyr_[_pID].referEth = referEth;
285         plyr_[_pID].lastClaimedPhID = lastClaimedPhID;
286     }
287 
288     function migratePlayerRoundsData(uint256 _pID, uint256 eth, uint256 keys, uint256 maskKey, uint256 genWithdraw)
289         withinMigrationPeriod
290         onlyOwner
291         public
292     {
293         plyrRnds_[_pID][1].eth = eth;
294         plyrRnds_[_pID][1].keys = keys;
295         plyrRnds_[_pID][1].maskKey = maskKey;
296         plyrRnds_[_pID][1].genWithdraw = genWithdraw;
297     }
298 
299     function migratePlayerPhrasesData(uint256 _pID, uint256 eth, uint256 guRewarded)
300         withinMigrationPeriod
301         onlyOwner
302         public
303     {
304         // pIDxAddr_[addr] = _pID;
305         plyrPhas_[_pID][1].eth = eth;
306         plyrPhas_[_pID][1].guRewarded = guRewarded;
307     }
308 
309     function migrateRoundData(uint256 plyr, uint256 end, bool ended, uint256 strt,
310         uint256 allkeys, uint256 keys, uint256 eth, uint256 pot, uint256 maskKey, uint256 playCtr, uint256 withdraw)
311         withinMigrationPeriod
312         onlyOwner
313         public
314     {
315         round_[1].plyr = plyr;
316         round_[1].end = end;
317         round_[1].ended = ended;
318         round_[1].strt = strt;
319         round_[1].allkeys = allkeys;
320         round_[1].keys = keys;
321         round_[1].eth = eth;
322         round_[1].pot = pot;
323         round_[1].maskKey = maskKey;
324         round_[1].playCtr = playCtr;
325         round_[1].withdraw = withdraw;
326     }
327 
328     function migratePhraseData(uint256 eth, uint256 guGiven, uint256 mask, 
329         uint256 minEthRequired, uint256 guPoolAllocation)
330         withinMigrationPeriod
331         onlyOwner
332         public
333     {
334         phrase_[1].eth = eth;
335         phrase_[1].guGiven = guGiven;
336         phrase_[1].mask = mask;
337         phrase_[1].minEthRequired = minEthRequired;
338         phrase_[1].guPoolAllocation = guPoolAllocation;
339     }
340 
341 
342     function updateWhitelist(address[] _addrs, bool _isWhitelisted)
343         public
344         onlyOwner
345     {
346         for (uint i = 0; i < _addrs.length; i++) {
347             whitelisted_Prebuy[_addrs[i]] = _isWhitelisted;
348         }
349     }
350 
351     // buy using last stored affiliate ID
352     function()
353         isActivated()
354         isHuman()
355         isWithinLimits(msg.value)
356         public
357         payable
358     {
359         // determine if player is new or not
360         uint256 _pID = pIDxAddr_[msg.sender];
361         if (_pID == 0)
362         {
363             pID_++; // grab their player ID and last aff ID, from player names contract 
364             pIDxAddr_[msg.sender] = pID_; // set up player account 
365             plyr_[pID_].addr = msg.sender; // set up player account 
366             _pID = pID_;
367         } 
368         
369         // buy core 
370         buyCore(_pID, plyr_[_pID].laff);
371     }
372  
373     function buyXid(uint256 _affID)
374         isActivated()
375         isHuman()
376         isWithinLimits(msg.value)
377         public
378         payable
379     {
380         // determine if player is new or not
381         uint256 _pID = pIDxAddr_[msg.sender]; // fetch player id
382         if (_pID == 0)
383         {
384             pID_++; // grab their player ID and last aff ID, from player names contract 
385             pIDxAddr_[msg.sender] = pID_; // set up player account 
386             plyr_[pID_].addr = msg.sender; // set up player account 
387             _pID = pID_;
388         } 
389         
390         // manage affiliate residuals
391         // if no affiliate code was given or player tried to use their own
392         if (_affID == 0 || _affID == _pID || _affID > pID_)
393         {
394             _affID = plyr_[_pID].laff; // use last stored affiliate code 
395 
396         // if affiliate code was given & its not the same as previously stored 
397         } 
398         else if (_affID != plyr_[_pID].laff) 
399         {
400             if (plyr_[_pID].laff == 0)
401                 plyr_[_pID].laff = _affID; // update last affiliate 
402             else 
403                 _affID = plyr_[_pID].laff;
404         } 
405 
406         // buy core 
407         buyCore(_pID, _affID);
408     }
409 
410     function reLoadXid()
411         isActivated()
412         isHuman()
413         public
414     {
415         uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
416         require(_pID > 0);
417 
418         reLoadCore(_pID, plyr_[_pID].laff);
419     }
420 
421     function reLoadCore(uint256 _pID, uint256 _affID)
422         private
423     {
424         // setup local rID
425         uint256 _rID = rID_;
426         
427         // grab time
428         uint256 _now = now;
429 
430         // whitelist checking
431         if (_now < round_[rID_].strt + whitelistRange_) {
432             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
433         }
434         
435         // if round is active
436         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
437         {
438             uint256 _eth = withdrawEarnings(_pID, false);
439             
440             if (_eth > 0) {
441                 // call core 
442                 core(_rID, _pID, _eth, _affID);
443             }
444         
445         // if round is not active and end round needs to be ran   
446         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
447             // end the round (distributes pot) & start new round
448             round_[_rID].ended = true;
449             endRound();
450         }
451     }
452     
453     function withdraw()
454         isActivated()
455         isHuman()
456         public
457     {
458         // setup local rID 
459         uint256 _rID = rID_;
460         
461         // grab time
462         uint256 _now = now;
463         
464         // fetch player ID
465         uint256 _pID = pIDxAddr_[msg.sender];
466         
467         // setup temp var for player eth
468         uint256 _eth;
469         
470         // check to see if round has ended and no one has run round end yet
471         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
472         {   
473             // end the round (distributes pot)
474 			round_[_rID].ended = true;
475             endRound();
476             
477 			// get their earnings
478             _eth = withdrawEarnings(_pID, true);
479             
480             // gib moni
481             if (_eth > 0)
482                 plyr_[_pID].addr.transfer(_eth);    
483             
484             
485         // in any other situation
486         } else {
487             // get their earnings
488             _eth = withdrawEarnings(_pID, true);
489             
490             // gib moni
491             if (_eth > 0)
492                 plyr_[_pID].addr.transfer(_eth);
493         }
494     }
495 
496     function buyCore(uint256 _pID, uint256 _affID)
497         whenNotPaused_1
498         private
499     {
500         // setup local rID
501         uint256 _rID = rID_;
502         
503         // grab time
504         uint256 _now = now;
505 
506         // whitelist checking
507         if (_now < round_[rID_].strt + whitelistRange_) {
508             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
509         }
510         
511         // if round is active
512         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
513         {
514             // call core 
515             core(_rID, _pID, msg.value, _affID);
516         
517         // if round is not active     
518         } else {
519             // check to see if end round needs to be ran
520             if (_now > round_[_rID].end && round_[_rID].ended == false) 
521             {
522                 // end the round (distributes pot) & start new round
523 			    round_[_rID].ended = true;
524                 endRound();
525             }
526             
527             // put eth in players vault 
528             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
529         }
530     }
531     
532     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
533         private
534     {
535         // if player is new to current round
536         if (plyrRnds_[_pID][_rID].keys == 0)
537         {
538             // if player has played a previous round, move their unmasked earnings
539             // from that round to gen vault.
540             if (plyr_[_pID].lrnd != 0)
541                 updateGenVault(_pID, plyr_[_pID].lrnd);
542             
543             plyr_[_pID].lrnd = rID_; // update player's last round played
544         }
545         
546         // early round eth limiter (0-100 eth)
547         uint256 _availableLimit;
548         uint256 _refund;
549         if (round_[_rID].eth < ethLimiterRange1_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter1_)
550         {
551             _availableLimit = (ethLimiter1_).sub(plyrRnds_[_pID][_rID].eth);
552             _refund = _eth.sub(_availableLimit);
553             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
554             _eth = _availableLimit;
555         } else if (round_[_rID].eth < ethLimiterRange2_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter2_)
556         {
557             _availableLimit = (ethLimiter2_).sub(plyrRnds_[_pID][_rID].eth);
558             _refund = _eth.sub(_availableLimit);
559             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
560             _eth = _availableLimit;
561         }
562         
563         // if eth left is greater than min eth allowed (sorry no pocket lint)
564         if (_eth > 1e9) 
565         {
566             // mint the new keys
567             uint256 _keys = keysRec(round_[_rID].eth, _eth);
568             
569             // if they bought at least 1 whole key
570             if (_keys >= 1e18)
571             {
572                 updateTimer(_keys, _rID);
573 
574                 // set new leaders
575                 if (round_[_rID].plyr != _pID)
576                     round_[_rID].plyr = _pID;
577 
578                 emit KeyPurchase(plyr_[round_[_rID].plyr].addr, _eth, _keys);
579             }
580             
581             // manage airdrops
582             if (_eth >= 1e17)
583             {
584                 airDropTracker_++;
585                 if (airdrop() == true)
586                 {
587                     // gib muni
588                     uint256 _prize;
589                     if (_eth >= 1e19)
590                     {
591                         // calculate prize and give it to winner
592                         _prize = ((airDropPot_).mul(75)) / 100;
593                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
594                         
595                         // adjust airDropPot 
596                         airDropPot_ = (airDropPot_).sub(_prize);
597                         
598                         // let event know a tier 3 prize was won 
599                     } else if (_eth >= 1e18 && _eth < 1e19) {
600                         // calculate prize and give it to winner
601                         _prize = ((airDropPot_).mul(50)) / 100;
602                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
603                         
604                         // adjust airDropPot 
605                         airDropPot_ = (airDropPot_).sub(_prize);
606                         
607                         // let event know a tier 2 prize was won 
608                     } else if (_eth >= 1e17 && _eth < 1e18) {
609                         // calculate prize and give it to winner
610                         _prize = ((airDropPot_).mul(25)) / 100;
611                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
612                         
613                         // adjust airDropPot 
614                         airDropPot_ = (airDropPot_).sub(_prize);
615                         
616                         // let event know a tier 3 prize was won 
617                     }
618 
619                     // reset air drop tracker
620                     airDropTracker_ = 0;
621 
622                     // NEW
623                     airDropCount_++;
624                     airDropWinners_[airDropCount_][_pID] = _prize;
625                 }
626             }   
627             
628             leekStealGo();
629 
630             // update player 
631             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
632             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
633             round_[_rID].playCtr++;
634             playOrders_[round_[_rID].playCtr] = pID_; // for recording the 500 winners
635             
636             // update round
637             round_[_rID].allkeys = _keys.add(round_[_rID].allkeys);
638             round_[_rID].keys = _keys.add(round_[_rID].keys);
639             round_[_rID].eth = _eth.add(round_[_rID].eth);
640     
641             // distribute eth
642             distributeExternal(_rID, _pID, _eth, _affID);
643             distributeInternal(_rID, _pID, _eth, _keys);
644 
645             // manage gu-referral
646             updateGuReferral(_pID, _affID, _eth);
647 
648             checkDoubledProfit(_pID, _rID);
649             checkDoubledProfit(_affID, _rID);
650         }
651     }
652 
653     // zero out keys if the accumulated profit doubled
654     function checkDoubledProfit(uint256 _pID, uint256 _rID)
655         private
656     {   
657         // if pID has no keys, skip this
658         uint256 _keys = plyrRnds_[_pID][_rID].keys;
659         if (_keys > 0) {
660 
661             uint256 _genVault = plyr_[_pID].gen;
662             uint256 _genWithdraw = plyrRnds_[_pID][_rID].genWithdraw;
663             uint256 _genEarning = calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd);
664             uint256 _doubleProfit = (plyrRnds_[_pID][_rID].eth).mul(2);
665             if (_genVault.add(_genWithdraw).add(_genEarning) >= _doubleProfit)
666             {
667                 // put only calculated-remain-profit into gen vault
668                 uint256 _remainProfit = _doubleProfit.sub(_genVault).sub(_genWithdraw);
669                 plyr_[_pID].gen = _remainProfit.add(plyr_[_pID].gen); 
670                 plyrRnds_[_pID][_rID].keyProfit = _remainProfit.add(plyrRnds_[_pID][_rID].keyProfit); // follow maskKey
671 
672                 round_[_rID].keys = round_[_rID].keys.sub(_keys);
673                 plyrRnds_[_pID][_rID].keys = plyrRnds_[_pID][_rID].keys.sub(_keys);
674 
675                 plyrRnds_[_pID][_rID].maskKey = 0; // treat this player like a new player
676             }   
677         }
678     }
679 
680     function keysRec(uint256 _curEth, uint256 _newEth)
681         private
682         returns (uint256)
683     {
684         uint256 _startEth;
685         uint256 _incrRate;
686         uint256 _initPrice;
687 
688         if (_curEth < priceStage1_) {
689             _startEth = 0;
690             _initPrice = 33333; //3e-5;
691             _incrRate = 50000000; //2e-8;
692         }
693         else if (_curEth < priceStage2_) {
694             _startEth = priceStage1_;
695             _initPrice =  25000; // 4e-5;
696             _incrRate = 50000000; //2e-8;
697         }
698         else if (_curEth < priceStage3_) {
699             _startEth = priceStage2_;
700             _initPrice = 20000; //5e-5;
701             _incrRate = 50000000; //2e-8;;
702         }
703         else if (_curEth < priceStage4_) {
704             _startEth = priceStage3_;
705             _initPrice = 12500; //8e-5;
706             _incrRate = 26666666; //3.75e-8;
707         }
708         else if (_curEth < priceStage5_) {
709             _startEth = priceStage4_;
710             _initPrice = 5000; //2e-4;
711             _incrRate = 17777777; //5.625e-8;
712         }
713         else if (_curEth < priceStage6_) {
714             _startEth = priceStage5_;
715             _initPrice = 2500; // 4e-4;
716             _incrRate = 10666666; //9.375e-8;
717         }
718         else if (_curEth < priceStage7_) {
719             _startEth = priceStage6_;
720             _initPrice = 1000; //0.001;
721             _incrRate = 5688282; //1.758e-7;
722         }
723         else if (_curEth < priceStage8_) {
724             _startEth = priceStage7_;
725             _initPrice = 250; //0.004;
726             _incrRate = 2709292; //3.691e-7;
727         }
728         else if (_curEth < priceStage9_) {
729             _startEth = priceStage8_;
730             _initPrice = 62; //0.016;
731             _incrRate = 1161035; //8.613e-7;
732         }
733         else if (_curEth < priceStage10_) {
734             _startEth = priceStage9_;
735             _initPrice = 14; //0.071;
736             _incrRate = 451467; //2.215e-6;
737         }
738         else if (_curEth < priceStage11_) {
739             _startEth = priceStage10_;
740             _initPrice = 2; //0.354;
741             _incrRate = 144487; //6.921e-6;
742         }
743         else if (_curEth < priceStage12_) {
744             _startEth = priceStage11_;
745             _initPrice = 0; //2.126;
746             _incrRate = 40128; //2.492e-5;
747         }
748         else {
749             _startEth = priceStage12_;
750             _initPrice = 0;
751             _incrRate = 40128; //2.492e-5;
752         }
753 
754         return _newEth.mul(((_incrRate.mul(_initPrice)) / (_incrRate.add(_initPrice.mul((_curEth.sub(_startEth))/1e18)))));
755     }
756 
757     function updateGuReferral(uint256 _pID, uint256 _affID, uint256 _eth) private {
758         uint256 _newPhID = updateGuPhrase();
759 
760         // update phrase, and distribute remaining gu for the last phrase
761         if (phID_ < _newPhID) {
762             updateReferralMasks(phID_);
763             plyr_[1].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[1].gu); // give 20% gu to community first, at the beginning of the phrase start
764             plyr_[2].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[2].gu); // give 20% gu to community first, at the beginning of the phrase start
765             phrase_[_newPhID].guGiven = (phrase_[_newPhID].guPoolAllocation / 5).add(phrase_[_newPhID].guGiven);
766             allGuGiven_ = (phrase_[_newPhID].guPoolAllocation / 5).add(allGuGiven_);
767             phID_ = _newPhID; // update the phrase ID
768         }
769 
770         // update referral eth on affiliate
771         if (_affID != 0 && _affID != _pID) {
772             plyrPhas_[_affID][_newPhID].eth = _eth.add(plyrPhas_[_affID][_newPhID].eth);
773             plyr_[_affID].referEth = _eth.add(plyr_[_affID].referEth);
774             phrase_[_newPhID].eth = _eth.add(phrase_[_newPhID].eth);
775         }
776             
777         uint256 _remainGuReward = phrase_[_newPhID].guPoolAllocation.sub(phrase_[_newPhID].guGiven);
778         // if 1) one has referral amt larger than requirement, 2) has remaining => then distribute certain amt of Gu, i.e. update gu instead of adding gu
779         if (plyrPhas_[_affID][_newPhID].eth >= phrase_[_newPhID].minEthRequired && _remainGuReward >= 1e18) {
780             // check if need to reward more gu
781             uint256 _totalReward = plyrPhas_[_affID][_newPhID].eth / phrase_[_newPhID].minEthRequired;
782             _totalReward = _totalReward.mul(1e18);
783             uint256 _rewarded = plyrPhas_[_affID][_newPhID].guRewarded;
784             uint256 _toReward = _totalReward.sub(_rewarded);
785             if (_remainGuReward < _toReward) _toReward =  _remainGuReward;
786 
787             // give out gu reward
788             if (_toReward > 0) {
789                 plyr_[_affID].gu = _toReward.add(plyr_[_affID].gu); // give gu to player
790                 plyrPhas_[_affID][_newPhID].guRewarded = _toReward.add(plyrPhas_[_affID][_newPhID].guRewarded);
791                 phrase_[_newPhID].guGiven = 1e18.add(phrase_[_newPhID].guGiven);
792                 allGuGiven_ = 1e18.add(allGuGiven_);
793             }
794         }
795     }
796 
797     function updateReferralMasks(uint256 _phID) private {
798         uint256 _remainGu = phrase_[phID_].guPoolAllocation.sub(phrase_[phID_].guGiven);
799         if (_remainGu > 0 && phrase_[_phID].eth > 0) {
800             // remaining gu per total ethIn in the phrase
801             uint256 _gpe = (_remainGu.mul(1e18)) / phrase_[_phID].eth;
802             phrase_[_phID].mask = _gpe.add(phrase_[_phID].mask); // should only added once
803         }
804     }
805 
806     function transferGu(address _to, uint256 _guAmt) 
807         public
808         whenNotPaused_2
809         returns (bool) 
810     {
811        require(_to != address(0));
812 
813         if (_guAmt > 0) {
814             uint256 _pIDFrom = pIDxAddr_[msg.sender];
815             uint256 _pIDTo = pIDxAddr_[_to];
816 
817             require(plyr_[_pIDFrom].addr == msg.sender);
818             require(plyr_[_pIDTo].addr == _to);
819 
820             // update profit for playerFrom
821             uint256 _profit = (allMaskGu_.mul(_guAmt)/1e18).sub(  (plyr_[_pIDFrom].maskGu.mul(_guAmt) / plyr_[_pIDFrom].gu)   ); 
822             plyr_[_pIDFrom].genGu = _profit.add(plyr_[_pIDFrom].genGu); // put in genGu vault
823             plyr_[_pIDFrom].guProfit = _profit.add(plyr_[_pIDFrom].guProfit);
824 
825             // update mask for playerFrom
826             plyr_[_pIDFrom].maskGu = plyr_[_pIDFrom].maskGu.sub(  (allMaskGu_.mul(_guAmt)/1e18).sub(_profit)  );
827 
828             // for playerTo
829             plyr_[_pIDTo].maskGu = (allMaskGu_.mul(_guAmt)/1e18).add(plyr_[_pIDTo].maskGu);
830 
831             plyr_[_pIDFrom].gu = plyr_[_pIDFrom].gu.sub(_guAmt);
832             plyr_[_pIDTo].gu = plyr_[_pIDTo].gu.add(_guAmt);
833 
834             return true;
835         } 
836         else
837             return false;
838     }
839     
840     function updateGuPhrase() 
841         private
842         returns (uint256) // return phraseNum
843     {
844         if (now <= contractStartDate_ + guPhrase1_) {
845             phrase_[1].minEthRequired = 5e18;
846             phrase_[1].guPoolAllocation = 100e18;
847             return 1; 
848         }
849         if (now <= contractStartDate_ + guPhrase2_) {
850             phrase_[2].minEthRequired = 4e18;
851             phrase_[2].guPoolAllocation = 200e18;
852             return 2; 
853         }
854         if (now <= contractStartDate_ + guPhrase3_) {
855             phrase_[3].minEthRequired = 3e18;
856             phrase_[3].guPoolAllocation = 400e18;
857             return 3; 
858         }
859         if (now <= contractStartDate_ + guPhrase4_) {
860             phrase_[4].minEthRequired = 2e18;
861             phrase_[4].guPoolAllocation = 800e18;
862             return 4; 
863         }
864         if (now <= contractStartDate_ + guPhrase5_) {
865             phrase_[5].minEthRequired = 1e18;
866             phrase_[5].guPoolAllocation = 1600e18;
867             return 5; 
868         }
869         if (now <= contractStartDate_ + guPhrase6_) {
870             phrase_[6].minEthRequired = 1e18;
871             phrase_[6].guPoolAllocation = 3200e18;
872             return 6; 
873         }
874         if (now <= contractStartDate_ + guPhrase7_) {
875             phrase_[7].minEthRequired = 1e18;
876             phrase_[7].guPoolAllocation = 6400e18;
877             return 7; 
878         }
879         if (now <= contractStartDate_ + guPhrase8_) {
880             phrase_[8].minEthRequired = 1e18;
881             phrase_[8].guPoolAllocation = 12800e18;
882             return 8; 
883         }
884         if (now <= contractStartDate_ + guPhrase9_) {
885             phrase_[9].minEthRequired = 1e18;
886             phrase_[9].guPoolAllocation = 25600e18;
887             return 9; 
888         }
889         if (now <= contractStartDate_ + guPhrase10_) {
890             phrase_[10].minEthRequired = 1e18;
891             phrase_[10].guPoolAllocation = 51200e18;
892             return 10; 
893         }
894         phrase_[11].minEthRequired = 0;
895         phrase_[11].guPoolAllocation = 0;
896         return 11;
897     }
898 
899     function calcUnMaskedKeyEarnings(uint256 _pID, uint256 _rIDlast)
900         private
901         view
902         returns(uint256)
903     {
904         if (    (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18))  >    (plyrRnds_[_pID][_rIDlast].maskKey)       )
905             return(  (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18)).sub(plyrRnds_[_pID][_rIDlast].maskKey)  );
906         else
907             return 0;
908     }
909 
910     function calcUnMaskedGuEarnings(uint256 _pID)
911         private
912         view
913         returns(uint256)
914     {
915         if (    ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18))  >    (plyr_[_pID].maskGu)      )
916             return(  ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18)).sub(plyr_[_pID].maskGu)   );
917         else
918             return 0;
919     }
920     
921     function endRound()
922         private
923     {
924         // setup local rID
925         uint256 _rID = rID_;
926         
927         // grab our winning player id
928         uint256 _winPID = round_[_rID].plyr;
929         
930         // grab our pot amount
931         uint256 _pot = round_[_rID].pot;
932         
933         // calculate our winner share, community rewards, gen share, 
934         // jcg share, and amount reserved for next pot 
935         uint256 _win = (_pot.mul(40)) / 100;
936         uint256 _res = (_pot.mul(10)) / 100;
937 
938         
939         // pay our winner
940         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
941 
942         // pay the rest of the 500 winners
943         pay500Winners(_pot);
944         
945         // start next round
946         rID_++;
947         _rID++;
948         round_[_rID].strt = now;
949         round_[_rID].end = now.add(rndInit_);
950         round_[_rID].pot = _res;
951     }
952 
953     function pay500Winners(uint256 _pot) private {
954         uint256 _rID = rID_;
955         uint256 _plyCtr = round_[_rID].playCtr;
956 
957         // pay the 2-10th
958         uint256 _win2 = _pot.mul(25).div(100).div(9);
959         for (uint256 i = _plyCtr.sub(9); i <= _plyCtr.sub(1); i++) {
960             plyr_[playOrders_[i]].win = _win2.add(plyr_[playOrders_[i]].win);
961         }
962 
963         // pay the 11-100th
964         uint256 _win3 = _pot.mul(15).div(100).div(90);
965         for (uint256 j = _plyCtr.sub(99); j <= _plyCtr.sub(10); j++) {
966             plyr_[playOrders_[j]].win = _win3.add(plyr_[playOrders_[j]].win);
967         }
968 
969         // pay the 101-500th
970         uint256 _win4 = _pot.mul(10).div(100).div(400);
971         for (uint256 k = _plyCtr.sub(499); k <= _plyCtr.sub(100); k++) {
972             plyr_[playOrders_[k]].win = _win4.add(plyr_[playOrders_[k]].win);
973         }
974     }
975     
976     function updateGenVault(uint256 _pID, uint256 _rIDlast)
977         private 
978     {
979         uint256 _earnings = calcUnMaskedKeyEarnings(_pID, _rIDlast);
980         if (_earnings > 0)
981         {
982             // put in gen vault
983             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
984             // zero out their earnings by updating mask
985             plyrRnds_[_pID][_rIDlast].maskKey = _earnings.add(plyrRnds_[_pID][_rIDlast].maskKey);
986             plyrRnds_[_pID][_rIDlast].keyProfit = _earnings.add(plyrRnds_[_pID][_rIDlast].keyProfit); // NEW: follow maskKey
987         }
988     }
989 
990     function updateGenGuVault(uint256 _pID)
991         private 
992     {
993         uint256 _earnings = calcUnMaskedGuEarnings(_pID);
994         if (_earnings > 0)
995         {
996             // put in genGu vault
997             plyr_[_pID].genGu = _earnings.add(plyr_[_pID].genGu);
998             // zero out their earnings by updating mask
999             plyr_[_pID].maskGu = _earnings.add(plyr_[_pID].maskGu);
1000             plyr_[_pID].guProfit = _earnings.add(plyr_[_pID].guProfit);
1001         }
1002     }
1003 
1004     // update gu-reward for referrals
1005     function updateReferralGu(uint256 _pID)
1006         private 
1007     {
1008         // get current phID
1009         uint256 _phID = phID_;
1010 
1011         // get last claimed phID till
1012         uint256 _lastClaimedPhID = plyr_[_pID].lastClaimedPhID;
1013 
1014         if (_phID > _lastClaimedPhID)
1015         {
1016             // calculate the gu Shares using these two input
1017             uint256 _guShares;
1018             for (uint i = (_lastClaimedPhID + 1); i < _phID; i++) {
1019                 _guShares = (((phrase_[i].mask).mul(plyrPhas_[_pID][i].eth))/1e18).add(_guShares);
1020             
1021                 // update record
1022                 plyr_[_pID].lastClaimedPhID = i;
1023                 phrase_[i].guGiven = _guShares.add(phrase_[i].guGiven);
1024                 plyrPhas_[_pID][i].guRewarded = _guShares.add(plyrPhas_[_pID][i].guRewarded);
1025             }
1026 
1027             // put gu in player
1028             plyr_[_pID].gu = _guShares.add(plyr_[_pID].gu);
1029 
1030             // zero out their earnings by updating mask
1031             plyr_[_pID].maskGu = ((allMaskGu_.mul(_guShares)) / 1e18).add(plyr_[_pID].maskGu);
1032 
1033             allGuGiven_ = _guShares.add(allGuGiven_);
1034         }
1035     }
1036     
1037     function updateTimer(uint256 _keys, uint256 _rID)
1038         private
1039     {
1040         // grab time
1041         uint256 _now = now;
1042         
1043         // calculate time based on number of keys bought
1044         uint256 _newTime;
1045         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1046             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1047         else
1048             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1049         
1050         // compare to max and set new end time
1051         if (_newTime < (rndMax_).add(_now))
1052             round_[_rID].end = _newTime;
1053         else
1054             round_[_rID].end = rndMax_.add(_now);
1055     }
1056     
1057     function airdrop()
1058         private 
1059         view 
1060         returns(bool)
1061     {
1062         uint256 seed = uint256(keccak256(abi.encodePacked(
1063             
1064             (block.timestamp).add
1065             (block.difficulty).add
1066             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1067             (block.gaslimit).add
1068             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1069             (block.number)
1070             
1071         )));
1072         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1073             return(true);
1074         else
1075             return(false);
1076     }
1077 
1078     function randomNum(uint256 _tracker)
1079         private 
1080         view 
1081         returns(bool)
1082     {
1083         uint256 seed = uint256(keccak256(abi.encodePacked(
1084             
1085             (block.timestamp).add
1086             (block.difficulty).add
1087             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1088             (block.gaslimit).add
1089             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1090             (block.number)
1091             
1092         )));
1093         if((seed - ((seed / 1000) * 1000)) < _tracker)
1094             return(true);
1095         else
1096             return(false);
1097     }
1098 
1099     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1100         private
1101     {
1102         // pay 2% out to community rewards
1103         uint256 _com = _eth / 100;
1104         address(WALLET_ETH_COM1).transfer(_com); // 1%
1105         address(WALLET_ETH_COM2).transfer(_com); // 1%
1106         
1107         // distribute 10% share to affiliate (8% + 2%)
1108         uint256 _aff = _eth / 10;
1109         
1110         // check: affiliate must not be self, and must have an ID
1111         if (_affID != _pID && _affID != 0) {
1112             plyr_[_affID].aff = (_aff.mul(8)/10).add(plyr_[_affID].aff); // distribute 8% to 1st aff
1113 
1114             uint256 _affID2 =  plyr_[_affID].laff; // get 2nd aff
1115             if (_affID2 != _pID && _affID2 != 0) {
1116                 plyr_[_affID2].aff = (_aff.mul(2)/10).add(plyr_[_affID2].aff); // distribute 2% to 2nd aff
1117             }
1118         } else {
1119             plyr_[1].aff = _aff.add(plyr_[_affID].aff);
1120         }
1121     }
1122     
1123     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys)
1124         private
1125     {
1126         // calculate gen share
1127         uint256 _gen = (_eth.mul(40)) / 100; // 40%
1128 
1129         // calculate jcg share
1130         uint256 _jcg = (_eth.mul(20)) / 100; // 20%
1131         
1132         // toss 3% into airdrop pot 
1133         uint256 _air = (_eth.mul(3)) / 100;
1134         airDropPot_ = airDropPot_.add(_air);
1135 
1136         // toss 5% into leeksteal pot 
1137         uint256 _steal = (_eth / 20);
1138         leekStealPot_ = leekStealPot_.add(_steal);
1139         
1140         // update eth balance (eth = eth - (2% com share + 3% airdrop + 5% leekSteal + 10% aff share))
1141         _eth = _eth.sub(((_eth.mul(20)) / 100)); 
1142         
1143         // calculate pot 
1144         uint256 _pot = _eth.sub(_gen).sub(_jcg);
1145         
1146         // distribute gen n jcg share (thats what updateMasks() does) and adjust
1147         // balances for dust.
1148         uint256 _dustKey = updateKeyMasks(_rID, _pID, _gen, _keys);
1149         uint256 _dustGu = updateGuMasks(_pID, _jcg);
1150         
1151         // add eth to pot
1152         round_[_rID].pot = _pot.add(_dustKey).add(_dustGu).add(round_[_rID].pot);
1153     }
1154 
1155     // update profit to key-holders
1156     function updateKeyMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1157         private
1158         returns(uint256)
1159     {
1160         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1161         uint256 _ppt = (_gen.mul(1e18)) / (round_[_rID].keys);
1162         round_[_rID].maskKey = _ppt.add(round_[_rID].maskKey);
1163             
1164         // calculate player earning from their own buy (only based on the keys
1165         // they just bought).  & update player earnings mask
1166         uint256 _pearn = (_ppt.mul(_keys)) / (1e18);
1167         plyrRnds_[_pID][_rID].maskKey = (((round_[_rID].maskKey.mul(_keys)) / (1e18)).sub(_pearn)).add(plyrRnds_[_pID][_rID].maskKey);
1168         
1169         // calculate & return dust
1170         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1e18)));
1171     }
1172 
1173     // update profit to gu-holders
1174     function updateGuMasks(uint256 _pID, uint256 _jcg)
1175         private
1176         returns(uint256)
1177     {   
1178         if (allGuGiven_ > 0) {
1179             // calc profit per gu & round mask based on this buy:  (dust goes to pot)
1180             uint256 _ppg = (_jcg.mul(1e18)) / allGuGiven_;
1181             allMaskGu_ = _ppg.add(allMaskGu_);
1182             
1183             // calculate & return dust
1184             return (_jcg.sub((_ppg.mul(allGuGiven_)) / (1e18)));
1185         } else {
1186             return _jcg;
1187         }
1188     }
1189     
1190     function withdrawEarnings(uint256 _pID, bool isWithdraw)
1191         whenNotPaused_3
1192         private
1193         returns(uint256)
1194     {
1195         uint256 _rID = plyr_[_pID].lrnd;
1196 
1197         updateGenGuVault(_pID);
1198 
1199         updateReferralGu(_pID);
1200 
1201         checkDoubledProfit(_pID, _rID);
1202         updateGenVault(_pID, _rID);
1203         
1204 
1205         // from all vaults 
1206         uint256 _earnings = plyr_[_pID].gen.add(plyr_[_pID].win).add(plyr_[_pID].genGu).add(plyr_[_pID].aff).add(plyr_[_pID].refund);
1207         if (_earnings > 0)
1208         {
1209             if (isWithdraw) {
1210                 plyrRnds_[_pID][_rID].winWithdraw = plyr_[_pID].win.add(plyrRnds_[_pID][_rID].winWithdraw);
1211                 plyrRnds_[_pID][_rID].genWithdraw = plyr_[_pID].gen.add(plyrRnds_[_pID][_rID].genWithdraw); // for doubled profit
1212                 plyrRnds_[_pID][_rID].genGuWithdraw = plyr_[_pID].genGu.add(plyrRnds_[_pID][_rID].genGuWithdraw);
1213                 plyrRnds_[_pID][_rID].affWithdraw = plyr_[_pID].aff.add(plyrRnds_[_pID][_rID].affWithdraw);
1214                 plyrRnds_[_pID][_rID].refundWithdraw = plyr_[_pID].refund.add(plyrRnds_[_pID][_rID].refundWithdraw);
1215                 plyr_[_pID].withdraw = _earnings.add(plyr_[_pID].withdraw);
1216                 round_[_rID].withdraw = _earnings.add(round_[_rID].withdraw);
1217             }
1218 
1219             plyr_[_pID].win = 0;
1220             plyr_[_pID].gen = 0;
1221             plyr_[_pID].genGu = 0;
1222             plyr_[_pID].aff = 0;
1223             plyr_[_pID].refund = 0;
1224         }
1225 
1226         return(_earnings);
1227     }
1228 
1229     bool public activated_ = false;
1230     function activate()
1231         onlyOwner
1232         public
1233     {
1234         // can only be ran once
1235         require(activated_ == false);
1236         
1237         // activate the contract 
1238         activated_ = true;
1239         contractStartDate_ = now;
1240         
1241         // lets start first round
1242         rID_ = 1;
1243         round_[1].strt = now;
1244         round_[1].end = now + rndInit_;
1245     }
1246 
1247     function leekStealGo() 
1248         private 
1249     {
1250         // get a number for today dayNum 
1251         uint leekStealToday_ = (now.sub(round_[rID_].strt)) / 1 days; 
1252         if (dayStealTime_[leekStealToday_] == 0) // if there hasn't a winner today, proceed
1253         {
1254             leekStealTracker_++;
1255             if (randomNum(leekStealTracker_) == true)
1256             {
1257                 dayStealTime_[leekStealToday_] = now;
1258                 leekStealOn_ = true;
1259             }
1260         }
1261     }
1262 
1263     function stealTheLeek() 
1264         whenNotPaused_4
1265         public 
1266     {
1267         if (leekStealOn_)
1268         {   
1269             if (now.sub(dayStealTime_[leekStealToday_]) > 300) // if time passed 5min, turn off and exit
1270             {
1271                 leekStealOn_ = false;
1272             } else {   
1273                 // if yes then assign the 1eth, if the pool has 1eth
1274                 if (leekStealPot_ > 1e18) {
1275                     uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
1276                     plyr_[_pID].win = plyr_[_pID].win.add(1e18);
1277                     leekStealPot_ = leekStealPot_.sub(1e18);
1278                     leekStealWins_[_pID] = leekStealWins_[_pID].add(1e18);
1279                 }
1280             }
1281         }
1282     }
1283 
1284 // Getters ====================
1285     
1286     function getPrice()
1287         public
1288         view
1289         returns(uint256)
1290     {   
1291         uint256 keys = keysRec(round_[rID_].eth, 1e18);
1292         return (1e36 / keys);
1293     }
1294     
1295     function getTimeLeft()
1296         public
1297         view
1298         returns(uint256)
1299     {
1300         // setup local rID
1301         uint256 _rID = rID_;
1302         
1303         // grab time
1304         uint256 _now = now;
1305         
1306         if (_now < round_[_rID].end)
1307             if (_now > round_[_rID].strt)
1308                 return( (round_[_rID].end).sub(_now) );
1309             else
1310                 return( (round_[_rID].strt).sub(_now) );
1311         else
1312             return(0);
1313     }
1314     
1315     function getDisplayGenVault(uint256 _pID)
1316         private
1317         view
1318         returns(uint256)
1319     {
1320         uint256 _rID = rID_;
1321         uint256 _lrnd = plyr_[_pID].lrnd;
1322 
1323         uint256 _genVault = plyr_[_pID].gen;
1324         uint256 _genEarning = calcUnMaskedKeyEarnings(_pID, _lrnd);
1325         uint256 _doubleProfit = (plyrRnds_[_pID][_rID].eth).mul(2);
1326         
1327         uint256 _displayGenVault = _genVault.add(_genEarning);
1328         if (_genVault.add(_genEarning) > _doubleProfit)
1329             _displayGenVault = _doubleProfit;
1330 
1331         return _displayGenVault;
1332     }
1333 
1334     function getPlayerVaults(uint256 _pID)
1335         public
1336         view
1337         returns(uint256 ,uint256, uint256, uint256, uint256)
1338     {
1339         uint256 _rID = rID_;
1340         
1341         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1342         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1343         {   
1344             uint256 _winVault;
1345             if (round_[_rID].plyr == _pID) // if player is winner 
1346             {   
1347                 _winVault = (plyr_[_pID].win).add( ((round_[_rID].pot).mul(40)) / 100 );
1348             } else {
1349                 _winVault = plyr_[_pID].win;
1350             }
1351 
1352             return
1353             (
1354                 _winVault,
1355                 getDisplayGenVault(_pID),
1356                 (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
1357                 plyr_[_pID].aff,
1358                 plyr_[_pID].refund
1359             );
1360         // if round is still going on, or round has ended and round end has been ran
1361         } else {
1362             return
1363             (
1364                 plyr_[_pID].win,
1365                 getDisplayGenVault(_pID),
1366                 (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
1367                 plyr_[_pID].aff,
1368                 plyr_[_pID].refund
1369             );
1370         }
1371     }
1372     
1373     function getCurrentRoundInfo()
1374         public
1375         view
1376         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
1377     {
1378         // setup local rID
1379         uint256 _rID = rID_;
1380         
1381         return
1382         (
1383             _rID,                           //0
1384             round_[_rID].allkeys,           //1
1385             round_[_rID].keys,              //2
1386             allGuGiven_,                    //3
1387             round_[_rID].end,               //4
1388             round_[_rID].strt,              //5
1389             round_[_rID].pot,               //6
1390             plyr_[round_[_rID].plyr].addr,  //7
1391             round_[_rID].eth,               //8
1392             airDropTracker_ + (airDropPot_ * 1000)   //9
1393         );
1394     }
1395 
1396     function getCurrentPhraseInfo()
1397         public
1398         view
1399         returns(uint256, uint256, uint256, uint256, uint256)
1400     {
1401         // setup local phID
1402         uint256 _phID = phID_;
1403         
1404         return
1405         (
1406             _phID,                            //0
1407             phrase_[_phID].eth,               //1
1408             phrase_[_phID].guGiven,           //2
1409             phrase_[_phID].minEthRequired,    //3
1410             phrase_[_phID].guPoolAllocation   //4
1411         );
1412     }
1413 
1414     function getPlayerInfoByAddress(address _addr)
1415         public 
1416         view 
1417         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1418     {
1419         // setup local rID, phID
1420         uint256 _rID = rID_;
1421         uint256 _phID = phID_;
1422         
1423         if (_addr == address(0))
1424         {
1425             _addr == msg.sender;
1426         }
1427         uint256 _pID = pIDxAddr_[_addr];
1428         
1429         return
1430         (
1431             _pID,      // 0
1432             plyrRnds_[_pID][_rID].keys,         //1
1433             plyr_[_pID].gu,                     //2
1434             plyr_[_pID].laff,                    //3
1435             (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)).add(plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)), //4
1436             plyr_[_pID].aff,                    //5
1437             plyrRnds_[_pID][_rID].eth,           //6      totalIn for the round
1438             plyrPhas_[_pID][_phID].eth,          //7      curr phrase referral eth
1439             plyr_[_pID].referEth,               // 8      total referral eth
1440             plyr_[_pID].withdraw                // 9      totalOut
1441         );
1442     }
1443 
1444     function getPlayerWithdrawal(uint256 _pID, uint256 _rID)
1445         public 
1446         view 
1447         returns(uint256, uint256, uint256, uint256, uint256)
1448     {
1449         return
1450         (
1451             plyrRnds_[_pID][_rID].winWithdraw,     //0
1452             plyrRnds_[_pID][_rID].genWithdraw,     //1
1453             plyrRnds_[_pID][_rID].genGuWithdraw,   //2
1454             plyrRnds_[_pID][_rID].affWithdraw,     //3
1455             plyrRnds_[_pID][_rID].refundWithdraw   //4
1456         );
1457     }
1458 
1459 }
1460 
1461 library Datasets {
1462     struct Player {
1463         address addr;   // player address
1464         uint256 win;    // winnings vault
1465         uint256 gen;    // general vault
1466         uint256 genGu;  // general gu vault
1467         uint256 aff;    // affiliate vault
1468         uint256 refund;  // refund vault
1469         uint256 lrnd;   // last round played
1470         uint256 laff;   // last affiliate id used
1471         uint256 withdraw; // sum of withdraw
1472         uint256 maskGu; // player mask gu: for sharing eth-profit by holding gu
1473         uint256 gu;     
1474         uint256 guProfit; // record profit by gu
1475         uint256 referEth; // total referral eth
1476         uint256 lastClaimedPhID; // at which phID player has claimed the remaining gu
1477     }
1478     struct PlayerRounds {
1479         uint256 eth;    // eth player has added to round
1480         uint256 keys;   // keys
1481         uint256 keyProfit; // record key profit
1482         uint256 maskKey;   // player mask key: for sharing eth-profit by holding keys
1483         uint256 winWithdraw;  // eth withdraw from gen vault
1484         uint256 genWithdraw;  // eth withdraw from gen vault
1485         uint256 genGuWithdraw;  // eth withdraw from gen vault
1486         uint256 affWithdraw;  // eth withdraw from gen vault
1487         uint256 refundWithdraw;  // eth withdraw from gen vault
1488     }
1489     struct Round {
1490         uint256 plyr;   // pID of player in lead
1491         uint256 end;    // time ends/ended
1492         bool ended;     // has round end function been ran
1493         uint256 strt;   // time round started
1494         uint256 allkeys; // all keys
1495         uint256 keys;   // active keys
1496         uint256 eth;    // total eth in
1497         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1498         uint256 maskKey;   // global mask on key shares: for sharing eth-profit by holding keys
1499         uint256 playCtr;   // play counter for playOrders
1500         uint256 withdraw;
1501     }
1502     struct PlayerPhrases {
1503         uint256 eth;   // amount of eth in of the referral
1504         uint256 guRewarded;  // if have taken the gu through referral
1505     }
1506     struct Phrase {
1507         uint256 eth;   // amount of total eth in of the referral
1508         uint256 guGiven; // amount of gu distributed 
1509         uint256 mask;  // a rate of remainGu per ethIn shares: for sharing gu-reward by referral eth
1510         uint256 minEthRequired;  // min refer.eth to get 1 gu
1511         uint256 guPoolAllocation; // total number of gu
1512     }
1513 }
1514 
1515 library SafeMath {
1516     
1517     /**
1518     * @dev Multiplies two numbers, throws on overflow.
1519     */
1520     function mul(uint256 a, uint256 b) 
1521         internal 
1522         pure 
1523         returns (uint256 c) 
1524     {
1525         if (a == 0) {
1526             return 0;
1527         }
1528         c = a * b;
1529         require(c / a == b, "SafeMath mul failed");
1530         return c;
1531     }
1532 
1533     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1534         uint256 c = a / b;
1535         return c;
1536     }
1537 
1538     /**
1539     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1540     */
1541     function sub(uint256 a, uint256 b)
1542         internal
1543         pure
1544         returns (uint256) 
1545     {
1546         require(b <= a, "SafeMath sub failed");
1547         return a - b;
1548     }
1549 
1550     /**
1551     * @dev Adds two numbers, throws on overflow.
1552     */
1553     function add(uint256 a, uint256 b)
1554         internal
1555         pure
1556         returns (uint256 c) 
1557     {
1558         c = a + b;
1559         require(c >= a, "SafeMath add failed");
1560         return c;
1561     }
1562     
1563     /**
1564      * @dev gives square root of given x.
1565      */
1566     function sqrt(uint256 x)
1567         internal
1568         pure
1569         returns (uint256 y) 
1570     {
1571         uint256 z = ((add(x,1)) / 2);
1572         y = x;
1573         while (z < y) 
1574         {
1575             y = z;
1576             z = ((add((x / z),z)) / 2);
1577         }
1578     }
1579     
1580     /**
1581      * @dev gives square. multiplies x by x
1582      */
1583     function sq(uint256 x)
1584         internal
1585         pure
1586         returns (uint256)
1587     {
1588         return (mul(x,x));
1589     }
1590     
1591     /**
1592      * @dev x to the power of y 
1593      */
1594     function pwr(uint256 x, uint256 y)
1595         internal 
1596         pure 
1597         returns (uint256)
1598     {
1599         if (x==0)
1600             return (0);
1601         else if (y==0)
1602             return (1);
1603         else 
1604         {
1605             uint256 z = x;
1606             for (uint256 i=1; i < y; i++)
1607                 z = mul(z,x);
1608             return (z);
1609         }
1610     }
1611 }