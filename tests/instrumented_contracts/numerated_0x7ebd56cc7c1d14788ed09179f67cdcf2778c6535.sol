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
237         uint256 pID, uint256 rID, uint256 phID)
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
251         phID_ = phID;
252     }
253 
254     function migratePlayerData1(uint256 _pID, address addr, uint256 win,
255         uint256 gen, uint256 genGu, uint256 aff, uint256 refund, uint256 lrnd, 
256         uint256 laff, uint256 withdraw)
257         withinMigrationPeriod
258         onlyOwner
259         public
260     {
261         pIDxAddr_[addr] = _pID;
262 
263         plyr_[_pID].addr = addr;
264         plyr_[_pID].win = win;
265         plyr_[_pID].gen = gen;
266         plyr_[_pID].genGu = genGu;
267         plyr_[_pID].aff = aff;
268         plyr_[_pID].refund = refund;
269         plyr_[_pID].lrnd = lrnd;
270         plyr_[_pID].laff = laff;
271         plyr_[_pID].withdraw = withdraw;
272     }
273 
274     function migratePlayerData2(uint256 _pID, address addr, uint256 maskGu, 
275     uint256 gu, uint256 referEth, uint256 lastClaimedPhID)
276         withinMigrationPeriod
277         onlyOwner
278         public
279     {
280         pIDxAddr_[addr] = _pID;
281         plyr_[_pID].addr = addr;
282 
283         plyr_[_pID].maskGu = maskGu;
284         plyr_[_pID].gu = gu;
285         plyr_[_pID].referEth = referEth;
286         plyr_[_pID].lastClaimedPhID = lastClaimedPhID;
287     }
288 
289     function migratePlayerRoundsData(uint256 _pID, uint256 eth, uint256 keys, uint256 maskKey, uint256 genWithdraw)
290         withinMigrationPeriod
291         onlyOwner
292         public
293     {
294         plyrRnds_[_pID][1].eth = eth;
295         plyrRnds_[_pID][1].keys = keys;
296         plyrRnds_[_pID][1].maskKey = maskKey;
297         plyrRnds_[_pID][1].genWithdraw = genWithdraw;
298     }
299 
300     function migratePlayerPhrasesData(uint256 _pID, uint256 eth, uint256 guRewarded)
301         withinMigrationPeriod
302         onlyOwner
303         public
304     {
305         // pIDxAddr_[addr] = _pID;
306         plyrPhas_[_pID][1].eth = eth;
307         plyrPhas_[_pID][1].guRewarded = guRewarded;
308     }
309 
310     function migrateRoundData(uint256 plyr, uint256 end, bool ended, uint256 strt,
311         uint256 allkeys, uint256 keys, uint256 eth, uint256 pot, uint256 maskKey, uint256 playCtr, uint256 withdraw)
312         withinMigrationPeriod
313         onlyOwner
314         public
315     {
316         round_[1].plyr = plyr;
317         round_[1].end = end;
318         round_[1].ended = ended;
319         round_[1].strt = strt;
320         round_[1].allkeys = allkeys;
321         round_[1].keys = keys;
322         round_[1].eth = eth;
323         round_[1].pot = pot;
324         round_[1].maskKey = maskKey;
325         round_[1].playCtr = playCtr;
326         round_[1].withdraw = withdraw;
327     }
328 
329     function migratePhraseData(uint256 eth, uint256 guGiven, uint256 mask, 
330         uint256 minEthRequired, uint256 guPoolAllocation)
331         withinMigrationPeriod
332         onlyOwner
333         public
334     {
335         phrase_[1].eth = eth;
336         phrase_[1].guGiven = guGiven;
337         phrase_[1].mask = mask;
338         phrase_[1].minEthRequired = minEthRequired;
339         phrase_[1].guPoolAllocation = guPoolAllocation;
340     }
341 
342 
343     function updateWhitelist(address[] _addrs, bool _isWhitelisted)
344         public
345         onlyOwner
346     {
347         for (uint i = 0; i < _addrs.length; i++) {
348             whitelisted_Prebuy[_addrs[i]] = _isWhitelisted;
349         }
350     }
351 
352     // buy using last stored affiliate ID
353     function()
354         isActivated()
355         isHuman()
356         isWithinLimits(msg.value)
357         public
358         payable
359     {
360         // determine if player is new or not
361         uint256 _pID = pIDxAddr_[msg.sender];
362         if (_pID == 0)
363         {
364             pID_++; // grab their player ID and last aff ID, from player names contract 
365             pIDxAddr_[msg.sender] = pID_; // set up player account 
366             plyr_[pID_].addr = msg.sender; // set up player account 
367             _pID = pID_;
368         } 
369         
370         // buy core 
371         buyCore(_pID, plyr_[_pID].laff);
372     }
373  
374     function buyXid(uint256 _affID)
375         isActivated()
376         isHuman()
377         isWithinLimits(msg.value)
378         public
379         payable
380     {
381         // determine if player is new or not
382         uint256 _pID = pIDxAddr_[msg.sender]; // fetch player id
383         if (_pID == 0)
384         {
385             pID_++; // grab their player ID and last aff ID, from player names contract 
386             pIDxAddr_[msg.sender] = pID_; // set up player account 
387             plyr_[pID_].addr = msg.sender; // set up player account 
388             _pID = pID_;
389         } 
390         
391         // manage affiliate residuals
392         // if no affiliate code was given or player tried to use their own
393         if (_affID == 0 || _affID == _pID || _affID > pID_)
394         {
395             _affID = plyr_[_pID].laff; // use last stored affiliate code 
396 
397         // if affiliate code was given & its not the same as previously stored 
398         } 
399         else if (_affID != plyr_[_pID].laff) 
400         {
401             if (plyr_[_pID].laff == 0)
402                 plyr_[_pID].laff = _affID; // update last affiliate 
403             else 
404                 _affID = plyr_[_pID].laff;
405         } 
406 
407         // buy core 
408         buyCore(_pID, _affID);
409     }
410 
411     function reLoadXid()
412         isActivated()
413         isHuman()
414         public
415     {
416         uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
417         require(_pID > 0);
418 
419         reLoadCore(_pID, plyr_[_pID].laff);
420     }
421 
422     function reLoadCore(uint256 _pID, uint256 _affID)
423         private
424     {
425         // setup local rID
426         uint256 _rID = rID_;
427         
428         // grab time
429         uint256 _now = now;
430 
431         // whitelist checking
432         if (_now < round_[rID_].strt + whitelistRange_) {
433             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
434         }
435         
436         // if round is active
437         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
438         {
439             uint256 _eth = withdrawEarnings(_pID, false);
440             
441             if (_eth > 0) {
442                 // call core 
443                 core(_rID, _pID, _eth, _affID);
444             }
445         
446         // if round is not active and end round needs to be ran   
447         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
448             // end the round (distributes pot) & start new round
449             round_[_rID].ended = true;
450             endRound();
451         }
452     }
453     
454     function withdraw()
455         isActivated()
456         isHuman()
457         public
458     {
459         // setup local rID 
460         uint256 _rID = rID_;
461         
462         // grab time
463         uint256 _now = now;
464         
465         // fetch player ID
466         uint256 _pID = pIDxAddr_[msg.sender];
467         
468         // setup temp var for player eth
469         uint256 _eth;
470         
471         // check to see if round has ended and no one has run round end yet
472         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
473         {   
474             // end the round (distributes pot)
475 			round_[_rID].ended = true;
476             endRound();
477             
478 			// get their earnings
479             _eth = withdrawEarnings(_pID, true);
480             
481             // gib moni
482             if (_eth > 0)
483                 plyr_[_pID].addr.transfer(_eth);    
484             
485             
486         // in any other situation
487         } else {
488             // get their earnings
489             _eth = withdrawEarnings(_pID, true);
490             
491             // gib moni
492             if (_eth > 0)
493                 plyr_[_pID].addr.transfer(_eth);
494         }
495     }
496 
497     function buyCore(uint256 _pID, uint256 _affID)
498         whenNotPaused_1
499         private
500     {
501         // setup local rID
502         uint256 _rID = rID_;
503         
504         // grab time
505         uint256 _now = now;
506 
507         // whitelist checking
508         if (_now < round_[rID_].strt + whitelistRange_) {
509             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
510         }
511         
512         // if round is active
513         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
514         {
515             // call core 
516             core(_rID, _pID, msg.value, _affID);
517         
518         // if round is not active     
519         } else {
520             // check to see if end round needs to be ran
521             if (_now > round_[_rID].end && round_[_rID].ended == false) 
522             {
523                 // end the round (distributes pot) & start new round
524 			    round_[_rID].ended = true;
525                 endRound();
526             }
527             
528             // put eth in players vault 
529             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
530         }
531     }
532     
533     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
534         private
535     {
536         // if player is new to current round
537         if (plyrRnds_[_pID][_rID].keys == 0)
538         {
539             // if player has played a previous round, move their unmasked earnings
540             // from that round to gen vault.
541             if (plyr_[_pID].lrnd != 0)
542                 updateGenVault(_pID, plyr_[_pID].lrnd);
543             
544             plyr_[_pID].lrnd = rID_; // update player's last round played
545         }
546         
547         // early round eth limiter (0-100 eth)
548         uint256 _availableLimit;
549         uint256 _refund;
550         if (round_[_rID].eth < ethLimiterRange1_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter1_)
551         {
552             _availableLimit = (ethLimiter1_).sub(plyrRnds_[_pID][_rID].eth);
553             _refund = _eth.sub(_availableLimit);
554             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
555             _eth = _availableLimit;
556         } else if (round_[_rID].eth < ethLimiterRange2_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter2_)
557         {
558             _availableLimit = (ethLimiter2_).sub(plyrRnds_[_pID][_rID].eth);
559             _refund = _eth.sub(_availableLimit);
560             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
561             _eth = _availableLimit;
562         }
563         
564         // if eth left is greater than min eth allowed (sorry no pocket lint)
565         if (_eth > 1e9) 
566         {
567             // mint the new keys
568             uint256 _keys = keysRec(round_[_rID].eth, _eth);
569             
570             // if they bought at least 1 whole key
571             if (_keys >= 1e18)
572             {
573                 updateTimer(_keys, _rID);
574 
575                 // set new leaders
576                 if (round_[_rID].plyr != _pID)
577                     round_[_rID].plyr = _pID;
578 
579                 emit KeyPurchase(plyr_[round_[_rID].plyr].addr, _eth, _keys);
580             }
581             
582             // manage airdrops
583             if (_eth >= 1e17)
584             {
585                 airDropTracker_++;
586                 if (airdrop() == true)
587                 {
588                     // gib muni
589                     uint256 _prize;
590                     if (_eth >= 1e19)
591                     {
592                         // calculate prize and give it to winner
593                         _prize = ((airDropPot_).mul(75)) / 100;
594                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
595                         
596                         // adjust airDropPot 
597                         airDropPot_ = (airDropPot_).sub(_prize);
598                         
599                         // let event know a tier 3 prize was won 
600                     } else if (_eth >= 1e18 && _eth < 1e19) {
601                         // calculate prize and give it to winner
602                         _prize = ((airDropPot_).mul(50)) / 100;
603                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
604                         
605                         // adjust airDropPot 
606                         airDropPot_ = (airDropPot_).sub(_prize);
607                         
608                         // let event know a tier 2 prize was won 
609                     } else if (_eth >= 1e17 && _eth < 1e18) {
610                         // calculate prize and give it to winner
611                         _prize = ((airDropPot_).mul(25)) / 100;
612                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
613                         
614                         // adjust airDropPot 
615                         airDropPot_ = (airDropPot_).sub(_prize);
616                         
617                         // let event know a tier 3 prize was won 
618                     }
619 
620                     // reset air drop tracker
621                     airDropTracker_ = 0;
622 
623                     // NEW
624                     airDropCount_++;
625                     airDropWinners_[airDropCount_][_pID] = _prize;
626                 }
627             }   
628             
629             leekStealGo();
630 
631             // update player 
632             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
633             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
634             round_[_rID].playCtr++;
635             playOrders_[round_[_rID].playCtr] = pID_; // for recording the 500 winners
636             
637             // update round
638             round_[_rID].allkeys = _keys.add(round_[_rID].allkeys);
639             round_[_rID].keys = _keys.add(round_[_rID].keys);
640             round_[_rID].eth = _eth.add(round_[_rID].eth);
641     
642             // distribute eth
643             distributeExternal(_rID, _pID, _eth, _affID);
644             distributeInternal(_rID, _pID, _eth, _keys);
645 
646             // manage gu-referral
647             updateGuReferral(_pID, _affID, _eth);
648 
649             checkDoubledProfit(_pID, _rID);
650             checkDoubledProfit(_affID, _rID);
651         }
652     }
653 
654     // zero out keys if the accumulated profit doubled
655     function checkDoubledProfit(uint256 _pID, uint256 _rID)
656         private
657     {   
658         // if pID has no keys, skip this
659         uint256 _keys = plyrRnds_[_pID][_rID].keys;
660         if (_keys > 0) {
661 
662             uint256 _genVault = plyr_[_pID].gen;
663             uint256 _genWithdraw = plyrRnds_[_pID][_rID].genWithdraw;
664             uint256 _genEarning = calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd);
665             uint256 _doubleProfit = (plyrRnds_[_pID][_rID].eth).mul(2);
666             if (_genVault.add(_genWithdraw).add(_genEarning) >= _doubleProfit)
667             {
668                 // put only calculated-remain-profit into gen vault
669                 uint256 _remainProfit = _doubleProfit.sub(_genVault).sub(_genWithdraw);
670                 plyr_[_pID].gen = _remainProfit.add(plyr_[_pID].gen); 
671                 plyrRnds_[_pID][_rID].keyProfit = _remainProfit.add(plyrRnds_[_pID][_rID].keyProfit); // follow maskKey
672 
673                 round_[_rID].keys = round_[_rID].keys.sub(_keys);
674                 plyrRnds_[_pID][_rID].keys = plyrRnds_[_pID][_rID].keys.sub(_keys);
675 
676                 plyrRnds_[_pID][_rID].maskKey = 0; // treat this player like a new player
677             }   
678         }
679     }
680 
681     function keysRec(uint256 _curEth, uint256 _newEth)
682         private
683         returns (uint256)
684     {
685         uint256 _startEth;
686         uint256 _incrRate;
687         uint256 _initPrice;
688 
689         if (_curEth < priceStage1_) {
690             _startEth = 0;
691             _initPrice = 33333; //3e-5;
692             _incrRate = 50000000; //2e-8;
693         }
694         else if (_curEth < priceStage2_) {
695             _startEth = priceStage1_;
696             _initPrice =  25000; // 4e-5;
697             _incrRate = 50000000; //2e-8;
698         }
699         else if (_curEth < priceStage3_) {
700             _startEth = priceStage2_;
701             _initPrice = 20000; //5e-5;
702             _incrRate = 50000000; //2e-8;;
703         }
704         else if (_curEth < priceStage4_) {
705             _startEth = priceStage3_;
706             _initPrice = 12500; //8e-5;
707             _incrRate = 26666666; //3.75e-8;
708         }
709         else if (_curEth < priceStage5_) {
710             _startEth = priceStage4_;
711             _initPrice = 5000; //2e-4;
712             _incrRate = 17777777; //5.625e-8;
713         }
714         else if (_curEth < priceStage6_) {
715             _startEth = priceStage5_;
716             _initPrice = 2500; // 4e-4;
717             _incrRate = 10666666; //9.375e-8;
718         }
719         else if (_curEth < priceStage7_) {
720             _startEth = priceStage6_;
721             _initPrice = 1000; //0.001;
722             _incrRate = 5688282; //1.758e-7;
723         }
724         else if (_curEth < priceStage8_) {
725             _startEth = priceStage7_;
726             _initPrice = 250; //0.004;
727             _incrRate = 2709292; //3.691e-7;
728         }
729         else if (_curEth < priceStage9_) {
730             _startEth = priceStage8_;
731             _initPrice = 62; //0.016;
732             _incrRate = 1161035; //8.613e-7;
733         }
734         else if (_curEth < priceStage10_) {
735             _startEth = priceStage9_;
736             _initPrice = 14; //0.071;
737             _incrRate = 451467; //2.215e-6;
738         }
739         else if (_curEth < priceStage11_) {
740             _startEth = priceStage10_;
741             _initPrice = 2; //0.354;
742             _incrRate = 144487; //6.921e-6;
743         }
744         else if (_curEth < priceStage12_) {
745             _startEth = priceStage11_;
746             _initPrice = 0; //2.126;
747             _incrRate = 40128; //2.492e-5;
748         }
749         else {
750             _startEth = priceStage12_;
751             _initPrice = 0;
752             _incrRate = 40128; //2.492e-5;
753         }
754 
755         return _newEth.mul(((_incrRate.mul(_initPrice)) / (_incrRate.add(_initPrice.mul((_curEth.sub(_startEth))/1e18)))));
756     }
757 
758     function updateGuReferral(uint256 _pID, uint256 _affID, uint256 _eth) private {
759         uint256 _newPhID = updateGuPhrase();
760 
761         // update phrase, and distribute remaining gu for the last phrase
762         if (phID_ < _newPhID) {
763             updateReferralMasks(phID_);
764             plyr_[1].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[1].gu); // give 20% gu to community first, at the beginning of the phrase start
765             plyr_[2].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[2].gu); // give 20% gu to community first, at the beginning of the phrase start
766             phrase_[_newPhID].guGiven = (phrase_[_newPhID].guPoolAllocation / 5).add(phrase_[_newPhID].guGiven);
767             allGuGiven_ = (phrase_[_newPhID].guPoolAllocation / 5).add(allGuGiven_);
768             phID_ = _newPhID; // update the phrase ID
769         }
770 
771         // update referral eth on affiliate
772         if (_affID != 0 && _affID != _pID) {
773             plyrPhas_[_affID][_newPhID].eth = _eth.add(plyrPhas_[_affID][_newPhID].eth);
774             plyr_[_affID].referEth = _eth.add(plyr_[_affID].referEth);
775             phrase_[_newPhID].eth = _eth.add(phrase_[_newPhID].eth);
776         }
777             
778         uint256 _remainGuReward = phrase_[_newPhID].guPoolAllocation.sub(phrase_[_newPhID].guGiven);
779         // if 1) one has referral amt larger than requirement, 2) has remaining => then distribute certain amt of Gu, i.e. update gu instead of adding gu
780         if (plyrPhas_[_affID][_newPhID].eth >= phrase_[_newPhID].minEthRequired && _remainGuReward >= 1e18) {
781             // check if need to reward more gu
782             uint256 _totalReward = plyrPhas_[_affID][_newPhID].eth / phrase_[_newPhID].minEthRequired;
783             _totalReward = _totalReward.mul(1e18);
784             uint256 _rewarded = plyrPhas_[_affID][_newPhID].guRewarded;
785             uint256 _toReward = _totalReward.sub(_rewarded);
786             if (_remainGuReward < _toReward) _toReward =  _remainGuReward;
787 
788             // give out gu reward
789             if (_toReward > 0) {
790                 plyr_[_affID].gu = _toReward.add(plyr_[_affID].gu); // give gu to player
791                 plyrPhas_[_affID][_newPhID].guRewarded = _toReward.add(plyrPhas_[_affID][_newPhID].guRewarded);
792                 phrase_[_newPhID].guGiven = 1e18.add(phrase_[_newPhID].guGiven);
793                 allGuGiven_ = 1e18.add(allGuGiven_);
794             }
795         }
796     }
797 
798     function updateReferralMasks(uint256 _phID) private {
799         uint256 _remainGu = phrase_[phID_].guPoolAllocation.sub(phrase_[phID_].guGiven);
800         if (_remainGu > 0 && phrase_[_phID].eth > 0) {
801             // remaining gu per total ethIn in the phrase
802             uint256 _gpe = (_remainGu.mul(1e18)) / phrase_[_phID].eth;
803             phrase_[_phID].mask = _gpe.add(phrase_[_phID].mask); // should only added once
804         }
805     }
806 
807     function transferGu(address _to, uint256 _guAmt) 
808         public
809         whenNotPaused_2
810         returns (bool) 
811     {
812        require(_to != address(0));
813 
814         if (_guAmt > 0) {
815             uint256 _pIDFrom = pIDxAddr_[msg.sender];
816             uint256 _pIDTo = pIDxAddr_[_to];
817 
818             require(plyr_[_pIDFrom].addr == msg.sender);
819             require(plyr_[_pIDTo].addr == _to);
820 
821             // update profit for playerFrom
822             uint256 _profit = (allMaskGu_.mul(_guAmt)/1e18).sub(  (plyr_[_pIDFrom].maskGu.mul(_guAmt) / plyr_[_pIDFrom].gu)   ); 
823             plyr_[_pIDFrom].genGu = _profit.add(plyr_[_pIDFrom].genGu); // put in genGu vault
824             plyr_[_pIDFrom].guProfit = _profit.add(plyr_[_pIDFrom].guProfit);
825 
826             // update mask for playerFrom
827             plyr_[_pIDFrom].maskGu = plyr_[_pIDFrom].maskGu.sub(  (allMaskGu_.mul(_guAmt)/1e18).sub(_profit)  );
828 
829             // for playerTo
830             plyr_[_pIDTo].maskGu = (allMaskGu_.mul(_guAmt)/1e18).add(plyr_[_pIDTo].maskGu);
831 
832             plyr_[_pIDFrom].gu = plyr_[_pIDFrom].gu.sub(_guAmt);
833             plyr_[_pIDTo].gu = plyr_[_pIDTo].gu.add(_guAmt);
834 
835             return true;
836         } 
837         else
838             return false;
839     }
840     
841     function updateGuPhrase() 
842         private
843         returns (uint256) // return phraseNum
844     {
845         if (now <= contractStartDate_ + guPhrase1_) {
846             phrase_[1].minEthRequired = 5e18;
847             phrase_[1].guPoolAllocation = 100e18;
848             return 1; 
849         }
850         if (now <= contractStartDate_ + guPhrase2_) {
851             phrase_[2].minEthRequired = 4e18;
852             phrase_[2].guPoolAllocation = 200e18;
853             return 2; 
854         }
855         if (now <= contractStartDate_ + guPhrase3_) {
856             phrase_[3].minEthRequired = 3e18;
857             phrase_[3].guPoolAllocation = 400e18;
858             return 3; 
859         }
860         if (now <= contractStartDate_ + guPhrase4_) {
861             phrase_[4].minEthRequired = 2e18;
862             phrase_[4].guPoolAllocation = 800e18;
863             return 4; 
864         }
865         if (now <= contractStartDate_ + guPhrase5_) {
866             phrase_[5].minEthRequired = 1e18;
867             phrase_[5].guPoolAllocation = 1600e18;
868             return 5; 
869         }
870         if (now <= contractStartDate_ + guPhrase6_) {
871             phrase_[6].minEthRequired = 1e18;
872             phrase_[6].guPoolAllocation = 3200e18;
873             return 6; 
874         }
875         if (now <= contractStartDate_ + guPhrase7_) {
876             phrase_[7].minEthRequired = 1e18;
877             phrase_[7].guPoolAllocation = 6400e18;
878             return 7; 
879         }
880         if (now <= contractStartDate_ + guPhrase8_) {
881             phrase_[8].minEthRequired = 1e18;
882             phrase_[8].guPoolAllocation = 12800e18;
883             return 8; 
884         }
885         if (now <= contractStartDate_ + guPhrase9_) {
886             phrase_[9].minEthRequired = 1e18;
887             phrase_[9].guPoolAllocation = 25600e18;
888             return 9; 
889         }
890         if (now <= contractStartDate_ + guPhrase10_) {
891             phrase_[10].minEthRequired = 1e18;
892             phrase_[10].guPoolAllocation = 51200e18;
893             return 10; 
894         }
895         phrase_[11].minEthRequired = 0;
896         phrase_[11].guPoolAllocation = 0;
897         return 11;
898     }
899 
900     function calcUnMaskedKeyEarnings(uint256 _pID, uint256 _rIDlast)
901         private
902         view
903         returns(uint256)
904     {
905         if (    (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18))  >    (plyrRnds_[_pID][_rIDlast].maskKey)       )
906             return(  (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18)).sub(plyrRnds_[_pID][_rIDlast].maskKey)  );
907         else
908             return 0;
909     }
910 
911     function calcUnMaskedGuEarnings(uint256 _pID)
912         private
913         view
914         returns(uint256)
915     {
916         if (    ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18))  >    (plyr_[_pID].maskGu)      )
917             return(  ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18)).sub(plyr_[_pID].maskGu)   );
918         else
919             return 0;
920     }
921     
922     function endRound()
923         private
924     {
925         // setup local rID
926         uint256 _rID = rID_;
927         
928         // grab our winning player id
929         uint256 _winPID = round_[_rID].plyr;
930         
931         // grab our pot amount
932         uint256 _pot = round_[_rID].pot;
933         
934         // calculate our winner share, community rewards, gen share, 
935         // jcg share, and amount reserved for next pot 
936         uint256 _win = (_pot.mul(40)) / 100;
937         uint256 _res = (_pot.mul(10)) / 100;
938 
939         
940         // pay our winner
941         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
942 
943         // pay the rest of the 500 winners
944         pay500Winners(_pot);
945         
946         // start next round
947         rID_++;
948         _rID++;
949         round_[_rID].strt = now;
950         round_[_rID].end = now.add(rndInit_);
951         round_[_rID].pot = _res;
952     }
953 
954     function pay500Winners(uint256 _pot) private {
955         uint256 _rID = rID_;
956         uint256 _plyCtr = round_[_rID].playCtr;
957 
958         // pay the 2-10th
959         uint256 _win2 = _pot.mul(25).div(100).div(9);
960         for (uint256 i = _plyCtr.sub(9); i <= _plyCtr.sub(1); i++) {
961             plyr_[playOrders_[i]].win = _win2.add(plyr_[playOrders_[i]].win);
962         }
963 
964         // pay the 11-100th
965         uint256 _win3 = _pot.mul(15).div(100).div(90);
966         for (uint256 j = _plyCtr.sub(99); j <= _plyCtr.sub(10); j++) {
967             plyr_[playOrders_[j]].win = _win3.add(plyr_[playOrders_[j]].win);
968         }
969 
970         // pay the 101-500th
971         uint256 _win4 = _pot.mul(10).div(100).div(400);
972         for (uint256 k = _plyCtr.sub(499); k <= _plyCtr.sub(100); k++) {
973             plyr_[playOrders_[k]].win = _win4.add(plyr_[playOrders_[k]].win);
974         }
975     }
976     
977     function updateGenVault(uint256 _pID, uint256 _rIDlast)
978         private 
979     {
980         uint256 _earnings = calcUnMaskedKeyEarnings(_pID, _rIDlast);
981         if (_earnings > 0)
982         {
983             // put in gen vault
984             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
985             // zero out their earnings by updating mask
986             plyrRnds_[_pID][_rIDlast].maskKey = _earnings.add(plyrRnds_[_pID][_rIDlast].maskKey);
987             plyrRnds_[_pID][_rIDlast].keyProfit = _earnings.add(plyrRnds_[_pID][_rIDlast].keyProfit); // NEW: follow maskKey
988         }
989     }
990 
991     function updateGenGuVault(uint256 _pID)
992         private 
993     {
994         uint256 _earnings = calcUnMaskedGuEarnings(_pID);
995         if (_earnings > 0)
996         {
997             // put in genGu vault
998             plyr_[_pID].genGu = _earnings.add(plyr_[_pID].genGu);
999             // zero out their earnings by updating mask
1000             plyr_[_pID].maskGu = _earnings.add(plyr_[_pID].maskGu);
1001             plyr_[_pID].guProfit = _earnings.add(plyr_[_pID].guProfit);
1002         }
1003     }
1004 
1005     // update gu-reward for referrals
1006     function updateReferralGu(uint256 _pID)
1007         private 
1008     {
1009         // get current phID
1010         uint256 _phID = phID_;
1011 
1012         // get last claimed phID till
1013         uint256 _lastClaimedPhID = plyr_[_pID].lastClaimedPhID;
1014 
1015         if (_phID > _lastClaimedPhID)
1016         {
1017             // calculate the gu Shares using these two input
1018             uint256 _guShares;
1019             for (uint i = (_lastClaimedPhID + 1); i < _phID; i++) {
1020                 _guShares = (((phrase_[i].mask).mul(plyrPhas_[_pID][i].eth))/1e18).add(_guShares);
1021             
1022                 // update record
1023                 plyr_[_pID].lastClaimedPhID = i;
1024                 phrase_[i].guGiven = _guShares.add(phrase_[i].guGiven);
1025                 plyrPhas_[_pID][i].guRewarded = _guShares.add(plyrPhas_[_pID][i].guRewarded);
1026             }
1027 
1028             // put gu in player
1029             plyr_[_pID].gu = _guShares.add(plyr_[_pID].gu);
1030 
1031             // zero out their earnings by updating mask
1032             plyr_[_pID].maskGu = ((allMaskGu_.mul(_guShares)) / 1e18).add(plyr_[_pID].maskGu);
1033 
1034             allGuGiven_ = _guShares.add(allGuGiven_);
1035         }
1036     }
1037     
1038     function updateTimer(uint256 _keys, uint256 _rID)
1039         private
1040     {
1041         // grab time
1042         uint256 _now = now;
1043         
1044         // calculate time based on number of keys bought
1045         uint256 _newTime;
1046         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1047             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1048         else
1049             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1050         
1051         // compare to max and set new end time
1052         if (_newTime < (rndMax_).add(_now))
1053             round_[_rID].end = _newTime;
1054         else
1055             round_[_rID].end = rndMax_.add(_now);
1056     }
1057     
1058     function airdrop()
1059         private 
1060         view 
1061         returns(bool)
1062     {
1063         uint256 seed = uint256(keccak256(abi.encodePacked(
1064             
1065             (block.timestamp).add
1066             (block.difficulty).add
1067             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1068             (block.gaslimit).add
1069             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1070             (block.number)
1071             
1072         )));
1073         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1074             return(true);
1075         else
1076             return(false);
1077     }
1078 
1079     function randomNum(uint256 _tracker)
1080         private 
1081         view 
1082         returns(bool)
1083     {
1084         uint256 seed = uint256(keccak256(abi.encodePacked(
1085             
1086             (block.timestamp).add
1087             (block.difficulty).add
1088             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1089             (block.gaslimit).add
1090             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1091             (block.number)
1092             
1093         )));
1094         if((seed - ((seed / 1000) * 1000)) < _tracker)
1095             return(true);
1096         else
1097             return(false);
1098     }
1099 
1100     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1101         private
1102     {
1103         // pay 2% out to community rewards
1104         uint256 _com = _eth / 100;
1105         address(WALLET_ETH_COM1).transfer(_com); // 1%
1106         address(WALLET_ETH_COM2).transfer(_com); // 1%
1107         
1108         // distribute 10% share to affiliate (8% + 2%)
1109         uint256 _aff = _eth / 10;
1110         
1111         // check: affiliate must not be self, and must have an ID
1112         if (_affID != _pID && _affID != 0) {
1113             plyr_[_affID].aff = (_aff.mul(8)/10).add(plyr_[_affID].aff); // distribute 8% to 1st aff
1114 
1115             uint256 _affID2 =  plyr_[_affID].laff; // get 2nd aff
1116             if (_affID2 != _pID && _affID2 != 0) {
1117                 plyr_[_affID2].aff = (_aff.mul(2)/10).add(plyr_[_affID2].aff); // distribute 2% to 2nd aff
1118             }
1119         } else {
1120             plyr_[1].aff = _aff.add(plyr_[_affID].aff);
1121         }
1122     }
1123     
1124     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys)
1125         private
1126     {
1127         // calculate gen share
1128         uint256 _gen = (_eth.mul(40)) / 100; // 40%
1129 
1130         // calculate jcg share
1131         uint256 _jcg = (_eth.mul(20)) / 100; // 20%
1132         
1133         // toss 3% into airdrop pot 
1134         uint256 _air = (_eth.mul(3)) / 100;
1135         airDropPot_ = airDropPot_.add(_air);
1136 
1137         // toss 5% into leeksteal pot 
1138         uint256 _steal = (_eth / 20);
1139         leekStealPot_ = leekStealPot_.add(_steal);
1140         
1141         // update eth balance (eth = eth - (2% com share + 3% airdrop + 5% leekSteal + 10% aff share))
1142         _eth = _eth.sub(((_eth.mul(20)) / 100)); 
1143         
1144         // calculate pot 
1145         uint256 _pot = _eth.sub(_gen).sub(_jcg);
1146         
1147         // distribute gen n jcg share (thats what updateMasks() does) and adjust
1148         // balances for dust.
1149         uint256 _dustKey = updateKeyMasks(_rID, _pID, _gen, _keys);
1150         uint256 _dustGu = updateGuMasks(_pID, _jcg);
1151         
1152         // add eth to pot
1153         round_[_rID].pot = _pot.add(_dustKey).add(_dustGu).add(round_[_rID].pot);
1154     }
1155 
1156     // update profit to key-holders
1157     function updateKeyMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1158         private
1159         returns(uint256)
1160     {
1161         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1162         uint256 _ppt = (_gen.mul(1e18)) / (round_[_rID].keys);
1163         round_[_rID].maskKey = _ppt.add(round_[_rID].maskKey);
1164             
1165         // calculate player earning from their own buy (only based on the keys
1166         // they just bought).  & update player earnings mask
1167         uint256 _pearn = (_ppt.mul(_keys)) / (1e18);
1168         plyrRnds_[_pID][_rID].maskKey = (((round_[_rID].maskKey.mul(_keys)) / (1e18)).sub(_pearn)).add(plyrRnds_[_pID][_rID].maskKey);
1169         
1170         // calculate & return dust
1171         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1e18)));
1172     }
1173 
1174     // update profit to gu-holders
1175     function updateGuMasks(uint256 _pID, uint256 _jcg)
1176         private
1177         returns(uint256)
1178     {   
1179         if (allGuGiven_ > 0) {
1180             // calc profit per gu & round mask based on this buy:  (dust goes to pot)
1181             uint256 _ppg = (_jcg.mul(1e18)) / allGuGiven_;
1182             allMaskGu_ = _ppg.add(allMaskGu_);
1183             
1184             // calculate & return dust
1185             return (_jcg.sub((_ppg.mul(allGuGiven_)) / (1e18)));
1186         } else {
1187             return _jcg;
1188         }
1189     }
1190     
1191     function withdrawEarnings(uint256 _pID, bool isWithdraw)
1192         whenNotPaused_3
1193         private
1194         returns(uint256)
1195     {
1196         uint256 _rID = plyr_[_pID].lrnd;
1197 
1198         updateGenGuVault(_pID);
1199 
1200         updateReferralGu(_pID);
1201 
1202         checkDoubledProfit(_pID, _rID);
1203         updateGenVault(_pID, _rID);
1204         
1205 
1206         // from all vaults 
1207         uint256 _earnings = plyr_[_pID].gen.add(plyr_[_pID].win).add(plyr_[_pID].genGu).add(plyr_[_pID].aff).add(plyr_[_pID].refund);
1208         if (_earnings > 0)
1209         {
1210             if (isWithdraw) {
1211                 plyrRnds_[_pID][_rID].winWithdraw = plyr_[_pID].win.add(plyrRnds_[_pID][_rID].winWithdraw);
1212                 plyrRnds_[_pID][_rID].genWithdraw = plyr_[_pID].gen.add(plyrRnds_[_pID][_rID].genWithdraw); // for doubled profit
1213                 plyrRnds_[_pID][_rID].genGuWithdraw = plyr_[_pID].genGu.add(plyrRnds_[_pID][_rID].genGuWithdraw);
1214                 plyrRnds_[_pID][_rID].affWithdraw = plyr_[_pID].aff.add(plyrRnds_[_pID][_rID].affWithdraw);
1215                 plyrRnds_[_pID][_rID].refundWithdraw = plyr_[_pID].refund.add(plyrRnds_[_pID][_rID].refundWithdraw);
1216                 plyr_[_pID].withdraw = _earnings.add(plyr_[_pID].withdraw);
1217                 round_[_rID].withdraw = _earnings.add(round_[_rID].withdraw);
1218             }
1219 
1220             plyr_[_pID].win = 0;
1221             plyr_[_pID].gen = 0;
1222             plyr_[_pID].genGu = 0;
1223             plyr_[_pID].aff = 0;
1224             plyr_[_pID].refund = 0;
1225         }
1226 
1227         return(_earnings);
1228     }
1229 
1230     bool public activated_ = false;
1231     function activate()
1232         onlyOwner
1233         public
1234     {
1235         // can only be ran once
1236         require(activated_ == false);
1237         
1238         // activate the contract 
1239         activated_ = true;
1240         contractStartDate_ = now;
1241         
1242         // lets start first round
1243         rID_ = 1;
1244         round_[1].strt = now;
1245         round_[1].end = now + rndInit_;
1246     }
1247 
1248     function leekStealGo() 
1249         private 
1250     {
1251         // get a number for today dayNum 
1252         uint leekStealToday_ = (now.sub(round_[rID_].strt)) / 1 days; 
1253         if (dayStealTime_[leekStealToday_] == 0) // if there hasn't a winner today, proceed
1254         {
1255             leekStealTracker_++;
1256             if (randomNum(leekStealTracker_) == true)
1257             {
1258                 dayStealTime_[leekStealToday_] = now;
1259                 leekStealOn_ = true;
1260             }
1261         }
1262     }
1263 
1264     function stealTheLeek() 
1265         whenNotPaused_4
1266         public 
1267     {
1268         if (leekStealOn_)
1269         {   
1270             if (now.sub(dayStealTime_[leekStealToday_]) > 300) // if time passed 5min, turn off and exit
1271             {
1272                 leekStealOn_ = false;
1273             } else {   
1274                 // if yes then assign the 1eth, if the pool has 1eth
1275                 if (leekStealPot_ > 1e18) {
1276                     uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
1277                     plyr_[_pID].win = plyr_[_pID].win.add(1e18);
1278                     leekStealPot_ = leekStealPot_.sub(1e18);
1279                     leekStealWins_[_pID] = leekStealWins_[_pID].add(1e18);
1280                 }
1281             }
1282         }
1283     }
1284 
1285 // Getters ====================
1286     
1287     function getPrice()
1288         public
1289         view
1290         returns(uint256)
1291     {   
1292         uint256 keys = keysRec(round_[rID_].eth, 1e18);
1293         return (1e36 / keys);
1294     }
1295     
1296     function getTimeLeft()
1297         public
1298         view
1299         returns(uint256)
1300     {
1301         // setup local rID
1302         uint256 _rID = rID_;
1303         
1304         // grab time
1305         uint256 _now = now;
1306         
1307         if (_now < round_[_rID].end)
1308             if (_now > round_[_rID].strt)
1309                 return( (round_[_rID].end).sub(_now) );
1310             else
1311                 return( (round_[_rID].strt).sub(_now) );
1312         else
1313             return(0);
1314     }
1315     
1316     function getDisplayGenVault(uint256 _pID)
1317         private
1318         view
1319         returns(uint256)
1320     {
1321         uint256 _rID = rID_;
1322         uint256 _lrnd = plyr_[_pID].lrnd;
1323 
1324         uint256 _genVault = plyr_[_pID].gen;
1325         uint256 _genEarning = calcUnMaskedKeyEarnings(_pID, _lrnd);
1326         uint256 _doubleProfit = (plyrRnds_[_pID][_rID].eth).mul(2);
1327         
1328         uint256 _displayGenVault = _genVault.add(_genEarning);
1329         if (_genVault.add(_genEarning) > _doubleProfit)
1330             _displayGenVault = _doubleProfit;
1331 
1332         return _displayGenVault;
1333     }
1334 
1335     function getPlayerVaults(uint256 _pID)
1336         public
1337         view
1338         returns(uint256 ,uint256, uint256, uint256, uint256)
1339     {
1340         uint256 _rID = rID_;
1341         
1342         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1343         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1344         {   
1345             uint256 _winVault;
1346             if (round_[_rID].plyr == _pID) // if player is winner 
1347             {   
1348                 _winVault = (plyr_[_pID].win).add( ((round_[_rID].pot).mul(40)) / 100 );
1349             } else {
1350                 _winVault = plyr_[_pID].win;
1351             }
1352 
1353             return
1354             (
1355                 _winVault,
1356                 getDisplayGenVault(_pID),
1357                 (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
1358                 plyr_[_pID].aff,
1359                 plyr_[_pID].refund
1360             );
1361         // if round is still going on, or round has ended and round end has been ran
1362         } else {
1363             return
1364             (
1365                 plyr_[_pID].win,
1366                 getDisplayGenVault(_pID),
1367                 (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
1368                 plyr_[_pID].aff,
1369                 plyr_[_pID].refund
1370             );
1371         }
1372     }
1373     
1374     function getCurrentRoundInfo()
1375         public
1376         view
1377         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
1378     {
1379         // setup local rID
1380         uint256 _rID = rID_;
1381         
1382         return
1383         (
1384             _rID,                           //0
1385             round_[_rID].allkeys,           //1
1386             round_[_rID].keys,              //2
1387             allGuGiven_,                    //3
1388             round_[_rID].end,               //4
1389             round_[_rID].strt,              //5
1390             round_[_rID].pot,               //6
1391             plyr_[round_[_rID].plyr].addr,  //7
1392             round_[_rID].eth,               //8
1393             airDropTracker_ + (airDropPot_ * 1000)   //9
1394         );
1395     }
1396 
1397     function getCurrentPhraseInfo()
1398         public
1399         view
1400         returns(uint256, uint256, uint256, uint256, uint256)
1401     {
1402         // setup local phID
1403         uint256 _phID = phID_;
1404         
1405         return
1406         (
1407             _phID,                            //0
1408             phrase_[_phID].eth,               //1
1409             phrase_[_phID].guGiven,           //2
1410             phrase_[_phID].minEthRequired,    //3
1411             phrase_[_phID].guPoolAllocation   //4
1412         );
1413     }
1414 
1415     function getPlayerInfoByAddress(address _addr)
1416         public 
1417         view 
1418         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1419     {
1420         // setup local rID, phID
1421         uint256 _rID = rID_;
1422         uint256 _phID = phID_;
1423         
1424         if (_addr == address(0))
1425         {
1426             _addr == msg.sender;
1427         }
1428         uint256 _pID = pIDxAddr_[_addr];
1429         
1430         return
1431         (
1432             _pID,      // 0
1433             plyrRnds_[_pID][_rID].keys,         //1
1434             plyr_[_pID].gu,                     //2
1435             plyr_[_pID].laff,                    //3
1436             (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)).add(plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)), //4
1437             plyr_[_pID].aff,                    //5
1438             plyrRnds_[_pID][_rID].eth,           //6      totalIn for the round
1439             plyrPhas_[_pID][_phID].eth,          //7      curr phrase referral eth
1440             plyr_[_pID].referEth,               // 8      total referral eth
1441             plyr_[_pID].withdraw                // 9      totalOut
1442         );
1443     }
1444 
1445     function getPlayerWithdrawal(uint256 _pID, uint256 _rID)
1446         public 
1447         view 
1448         returns(uint256, uint256, uint256, uint256, uint256)
1449     {
1450         return
1451         (
1452             plyrRnds_[_pID][_rID].winWithdraw,     //0
1453             plyrRnds_[_pID][_rID].genWithdraw,     //1
1454             plyrRnds_[_pID][_rID].genGuWithdraw,   //2
1455             plyrRnds_[_pID][_rID].affWithdraw,     //3
1456             plyrRnds_[_pID][_rID].refundWithdraw   //4
1457         );
1458     }
1459 
1460 }
1461 
1462 library Datasets {
1463     struct Player {
1464         address addr;   // player address
1465         uint256 win;    // winnings vault
1466         uint256 gen;    // general vault
1467         uint256 genGu;  // general gu vault
1468         uint256 aff;    // affiliate vault
1469         uint256 refund;  // refund vault
1470         uint256 lrnd;   // last round played
1471         uint256 laff;   // last affiliate id used
1472         uint256 withdraw; // sum of withdraw
1473         uint256 maskGu; // player mask gu: for sharing eth-profit by holding gu
1474         uint256 gu;     
1475         uint256 guProfit; // record profit by gu
1476         uint256 referEth; // total referral eth
1477         uint256 lastClaimedPhID; // at which phID player has claimed the remaining gu
1478     }
1479     struct PlayerRounds {
1480         uint256 eth;    // eth player has added to round
1481         uint256 keys;   // keys
1482         uint256 keyProfit; // record key profit
1483         uint256 maskKey;   // player mask key: for sharing eth-profit by holding keys
1484         uint256 winWithdraw;  // eth withdraw from gen vault
1485         uint256 genWithdraw;  // eth withdraw from gen vault
1486         uint256 genGuWithdraw;  // eth withdraw from gen vault
1487         uint256 affWithdraw;  // eth withdraw from gen vault
1488         uint256 refundWithdraw;  // eth withdraw from gen vault
1489     }
1490     struct Round {
1491         uint256 plyr;   // pID of player in lead
1492         uint256 end;    // time ends/ended
1493         bool ended;     // has round end function been ran
1494         uint256 strt;   // time round started
1495         uint256 allkeys; // all keys
1496         uint256 keys;   // active keys
1497         uint256 eth;    // total eth in
1498         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1499         uint256 maskKey;   // global mask on key shares: for sharing eth-profit by holding keys
1500         uint256 playCtr;   // play counter for playOrders
1501         uint256 withdraw;
1502     }
1503     struct PlayerPhrases {
1504         uint256 eth;   // amount of eth in of the referral
1505         uint256 guRewarded;  // if have taken the gu through referral
1506     }
1507     struct Phrase {
1508         uint256 eth;   // amount of total eth in of the referral
1509         uint256 guGiven; // amount of gu distributed 
1510         uint256 mask;  // a rate of remainGu per ethIn shares: for sharing gu-reward by referral eth
1511         uint256 minEthRequired;  // min refer.eth to get 1 gu
1512         uint256 guPoolAllocation; // total number of gu
1513     }
1514 }
1515 
1516 library SafeMath {
1517     
1518     /**
1519     * @dev Multiplies two numbers, throws on overflow.
1520     */
1521     function mul(uint256 a, uint256 b) 
1522         internal 
1523         pure 
1524         returns (uint256 c) 
1525     {
1526         if (a == 0) {
1527             return 0;
1528         }
1529         c = a * b;
1530         require(c / a == b, "SafeMath mul failed");
1531         return c;
1532     }
1533 
1534     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1535         uint256 c = a / b;
1536         return c;
1537     }
1538 
1539     /**
1540     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1541     */
1542     function sub(uint256 a, uint256 b)
1543         internal
1544         pure
1545         returns (uint256) 
1546     {
1547         require(b <= a, "SafeMath sub failed");
1548         return a - b;
1549     }
1550 
1551     /**
1552     * @dev Adds two numbers, throws on overflow.
1553     */
1554     function add(uint256 a, uint256 b)
1555         internal
1556         pure
1557         returns (uint256 c) 
1558     {
1559         c = a + b;
1560         require(c >= a, "SafeMath add failed");
1561         return c;
1562     }
1563     
1564     /**
1565      * @dev gives square root of given x.
1566      */
1567     function sqrt(uint256 x)
1568         internal
1569         pure
1570         returns (uint256 y) 
1571     {
1572         uint256 z = ((add(x,1)) / 2);
1573         y = x;
1574         while (z < y) 
1575         {
1576             y = z;
1577             z = ((add((x / z),z)) / 2);
1578         }
1579     }
1580     
1581     /**
1582      * @dev gives square. multiplies x by x
1583      */
1584     function sq(uint256 x)
1585         internal
1586         pure
1587         returns (uint256)
1588     {
1589         return (mul(x,x));
1590     }
1591     
1592     /**
1593      * @dev x to the power of y 
1594      */
1595     function pwr(uint256 x, uint256 y)
1596         internal 
1597         pure 
1598         returns (uint256)
1599     {
1600         if (x==0)
1601             return (0);
1602         else if (y==0)
1603             return (1);
1604         else 
1605         {
1606             uint256 z = x;
1607             for (uint256 i=1; i < y; i++)
1608                 z = mul(z,x);
1609             return (z);
1610         }
1611     }
1612 }