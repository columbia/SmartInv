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
25     event Pause();
26     event Unpause();
27 
28     bool public paused = false;
29 
30     modifier whenNotPaused() {
31         require(!paused);
32         _;
33     }
34 
35     modifier whenPaused() {
36         require(paused);
37         _;
38     }
39 
40     function pause() onlyOwner whenNotPaused public {
41         paused = true;
42         emit Pause();
43     }
44 
45     function unpause() onlyOwner whenPaused public {
46         paused = false;
47         emit Unpause();
48     }
49 }
50 
51 contract JCLYLong is Pausable  {
52     using SafeMath for *;
53 	
54     event KeyPurchase(address indexed purchaser, uint256 eth, uint256 amount);
55     event LeekStealOn();
56 
57     address private constant WALLET_ETH_COM1   = 0x2509CF8921b95bef38DEb80fBc420Ef2bbc53ce3; 
58     address private constant WALLET_ETH_COM2   = 0x18d9fc8e3b65124744553d642989e3ba9e41a95a; 
59 
60     // Configurables  ====================
61     uint256 constant private rndInit_ = 1 hours;      
62     uint256 constant private rndInc_ = 30 seconds;   
63     uint256 constant private rndMax_ = 24 hours;    
64 
65     // eth limiter
66     uint256 constant private ethLimiterRange1_ = 1e20;
67     uint256 constant private ethLimiterRange2_ = 5e20;
68     uint256 constant private ethLimiter1_ = 2e18;
69     uint256 constant private ethLimiter2_ = 7e18;
70 
71     // whitelist range
72     uint256 constant private whitelistRange_ = 3 days;
73 
74     // for price 
75     uint256 constant private priceStage1_ = 500e18;
76     uint256 constant private priceStage2_ = 1000e18;
77     uint256 constant private priceStage3_ = 2000e18;
78     uint256 constant private priceStage4_ = 4000e18;
79     uint256 constant private priceStage5_ = 8000e18;
80     uint256 constant private priceStage6_ = 16000e18;
81     uint256 constant private priceStage7_ = 32000e18;
82     uint256 constant private priceStage8_ = 64000e18;
83     uint256 constant private priceStage9_ = 128000e18;
84     uint256 constant private priceStage10_ = 256000e18;
85     uint256 constant private priceStage11_ = 512000e18;
86     uint256 constant private priceStage12_ = 1024000e18;
87 
88     // for gu phrase
89     uint256 constant private guPhrase1_ = 5 days;
90     uint256 constant private guPhrase2_ = 7 days;
91     uint256 constant private guPhrase3_ = 9 days;
92     uint256 constant private guPhrase4_ = 11 days;
93     uint256 constant private guPhrase5_ = 13 days;
94     uint256 constant private guPhrase6_ = 15 days;
95     uint256 constant private guPhrase7_ = 17 days;
96     uint256 constant private guPhrase8_ = 19 days;
97     uint256 constant private guPhrase9_ = 21 days;
98     uint256 constant private guPhrase10_ = 23 days;
99 
100 
101 // Data setup ====================
102     uint256 public contractStartDate_;    // contract creation time
103     uint256 public allMaskGu_; // for sharing eth-profit by holding gu
104     uint256 public allGuGiven_; // for sharing eth-profit by holding gu
105     mapping (uint256 => uint256) public playOrders_; // playCounter => pID
106 // AIRDROP DATA 
107     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
108     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
109 // LEEKSTEAL DATA 
110     uint256 public leekStealPot_;             // person who gets the first leeksteal wins part of this pot
111     uint256 public leekStealTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning leek steal
112     uint256 public leekStealToday_;
113     bool public leekStealOn_;
114     mapping (uint256 => uint256) public dayStealTime_; // dayNum => time that makes leekSteal available
115 // PLAYER DATA 
116     uint256 public pID_;        // total number of players
117     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
118     // mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
119     mapping (uint256 => Datasets.Player) public plyr_;   // (pID => data) player data
120     mapping (uint256 => mapping (uint256 => Datasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
121     mapping (uint256 => mapping (uint256 => Datasets.PlayerPhrases)) public plyrPhas_;    // (pID => phraseID => data) player round data by player id & round id
122 // ROUND DATA 
123     uint256 public rID_;    // round id number / total rounds that have happened
124     mapping (uint256 => Datasets.Round) public round_;   // (rID => data) round data
125 // PHRASE DATA 
126     uint256 public phID_; // gu phrase ID
127     mapping (uint256 => Datasets.Phrase) public phrase_;   // (phID_ => data) round data
128 // WHITELIST
129     mapping(address => bool) public whitelisted_Prebuy; // pID => isWhitelisted
130 
131 // Constructor ====================
132     constructor()
133         public
134     {
135         // set genesis player
136         pIDxAddr_[WALLET_ETH_COM1] = 1; 
137         plyr_[1].addr = WALLET_ETH_COM1; 
138         pIDxAddr_[WALLET_ETH_COM2] = 2; 
139         plyr_[2].addr = WALLET_ETH_COM2; 
140         pID_ = 2;
141     }
142 
143 // Modifiers ====================
144 
145     modifier isActivated() {
146         require(activated_ == true); 
147         _;
148     }
149     
150     modifier isHuman() {
151         address _addr = msg.sender;
152         uint256 _codeLength;
153         
154         assembly {_codeLength := extcodesize(_addr)}
155         require(_codeLength == 0, "sorry humans only");
156         _;
157     }
158 
159     modifier isWithinLimits(uint256 _eth) {
160         require(_eth >= 1000000000, "pocket lint: not a valid currency");
161         require(_eth <= 100000000000000000000000, "no vitalik, no");
162         _;    
163     }
164     
165 // Public functions ====================
166     /**
167      * @dev emergency buy uses last stored affiliate ID
168      */
169     function()
170         isActivated()
171         isHuman()
172         isWithinLimits(msg.value)
173         public
174         payable
175     {
176         // determine if player is new or not
177         uint256 _pID = pIDxAddr_[msg.sender];
178         if (_pID == 0)
179         {
180             pID_++; // grab their player ID and last aff ID, from player names contract 
181             pIDxAddr_[msg.sender] = pID_; // set up player account 
182             plyr_[pID_].addr = msg.sender; // set up player account 
183             _pID = pID_;
184         } 
185         
186         // buy core 
187         buyCore(_pID, plyr_[_pID].laff);
188     }
189  
190     function buyXid(uint256 _affID)
191         isActivated()
192         isHuman()
193         isWithinLimits(msg.value)
194         public
195         payable
196     {
197         // determine if player is new or not
198         uint256 _pID = pIDxAddr_[msg.sender]; // fetch player id
199         if (_pID == 0)
200         {
201             pID_++; // grab their player ID and last aff ID, from player names contract 
202             pIDxAddr_[msg.sender] = pID_; // set up player account 
203             plyr_[pID_].addr = msg.sender; // set up player account 
204             _pID = pID_;
205         } 
206         
207         // manage affiliate residuals
208         // if no affiliate code was given or player tried to use their own
209         if (_affID == 0 || _affID == _pID || _affID > pID_)
210         {
211             _affID = plyr_[_pID].laff; // use last stored affiliate code 
212 
213         // if affiliate code was given & its not the same as previously stored 
214         } 
215         else if (_affID != plyr_[_pID].laff) 
216         {
217             if (plyr_[_pID].laff == 0)
218                 plyr_[_pID].laff = _affID; // update last affiliate 
219             else 
220                 _affID = plyr_[_pID].laff;
221         } 
222 
223         // buy core 
224         buyCore(_pID, _affID);
225     }
226 
227     function reLoadXid()
228         isActivated()
229         isHuman()
230         public
231     {
232         uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
233         require(_pID > 0);
234 
235         reLoadCore(_pID, plyr_[_pID].laff);
236     }
237 
238     function reLoadCore(uint256 _pID, uint256 _affID)
239         private
240     {
241         // setup local rID
242         uint256 _rID = rID_;
243         
244         // grab time
245         uint256 _now = now;
246 
247         // whitelist checking
248         if (_now < round_[rID_].strt + whitelistRange_) {
249             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
250         }
251         
252         // if round is active
253         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
254         {
255             uint256 _eth = withdrawEarnings(_pID, false);
256             plyr_[_pID].gen = 0;
257             
258             // call core 
259             core(_rID, _pID, _eth, _affID);
260         
261         // if round is not active and end round needs to be ran   
262         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
263             // end the round (distributes pot) & start new round
264             round_[_rID].ended = true;
265             endRound();
266         }
267     }
268     
269     function withdraw()
270         isActivated()
271         isHuman()
272         public
273     {
274         // setup local rID 
275         uint256 _rID = rID_;
276         
277         // grab time
278         uint256 _now = now;
279         
280         // fetch player ID
281         uint256 _pID = pIDxAddr_[msg.sender];
282         
283         // setup temp var for player eth
284         uint256 _eth;
285         
286         // check to see if round has ended and no one has run round end yet
287         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
288         {   
289             // end the round (distributes pot)
290 			round_[_rID].ended = true;
291             endRound();
292             
293 			// get their earnings
294             _eth = withdrawEarnings(_pID, true);
295             
296             // gib moni
297             if (_eth > 0)
298                 plyr_[_pID].addr.transfer(_eth);    
299             
300             
301         // in any other situation
302         } else {
303             // get their earnings
304             _eth = withdrawEarnings(_pID, true);
305             
306             // gib moni
307             if (_eth > 0)
308                 plyr_[_pID].addr.transfer(_eth);
309         }
310     }
311 
312     function updateWhitelist(address[] _addrs, bool _isWhitelisted)
313         public
314         onlyOwner
315     {
316         for (uint i = 0; i < _addrs.length; i++) {
317             whitelisted_Prebuy[_addrs[i]] = _isWhitelisted;
318 
319             // determine if player is new or not
320             uint256 _pID = pIDxAddr_[msg.sender];
321             if (_pID == 0)
322             {
323                 pID_++; 
324                 pIDxAddr_[_addrs[i]] = pID_;
325                 plyr_[pID_].addr = _addrs[i];
326             } 
327         }
328     }
329 
330     function safeDrain() 
331         public
332         onlyOwner
333     {
334         owner.transfer(this.balance);
335     }
336     
337 
338 // Getters ====================
339     
340     function getPrice()
341         public
342         view
343         returns(uint256)
344     {   
345         uint256 keys = keysRec(round_[rID_].eth, 1e18);
346         return (1e36 / keys);
347     }
348     
349     function getTimeLeft()
350         public
351         view
352         returns(uint256)
353     {
354         // setup local rID
355         uint256 _rID = rID_;
356         
357         // grab time
358         uint256 _now = now;
359         
360         if (_now < round_[_rID].end)
361             if (_now > round_[_rID].strt)
362                 return( (round_[_rID].end).sub(_now) );
363             else
364                 return( (round_[_rID].strt).sub(_now) );
365         else
366             return(0);
367     }
368     
369     function getPlayerVaults(uint256 _pID)
370         public
371         view
372         returns(uint256 ,uint256, uint256, uint256, uint256)
373     {
374         // setup local rID
375         uint256 _rID = rID_;
376         
377         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
378         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
379         {
380             // if player is winner 
381             if (round_[_rID].plyr == _pID)
382             {
383                 return
384                 (
385                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
386                     (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)),
387                     (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
388                     plyr_[_pID].aff,
389                     plyr_[_pID].refund
390                 );
391             // if player is not the winner
392             } else {
393                 return
394                 (
395                     plyr_[_pID].win,
396                     (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)),
397                     (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
398                     plyr_[_pID].aff,
399                     plyr_[_pID].refund
400                 );
401             }
402             
403         // if round is still going on, or round has ended and round end has been ran
404         } else {
405             return
406             (
407                 plyr_[_pID].win,
408                 (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)),
409                 (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
410                 plyr_[_pID].aff,
411                 plyr_[_pID].refund
412             );
413         }
414     }
415     
416     function getCurrentRoundInfo()
417         public
418         view
419         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
420     {
421         // setup local rID
422         uint256 _rID = rID_;
423         
424         return
425         (
426             _rID,                           //0
427             round_[_rID].allkeys,           //1
428             round_[_rID].keys,              //2
429             allGuGiven_,                    //3
430             round_[_rID].end,               //4
431             round_[_rID].strt,              //5
432             round_[_rID].pot,               //6
433             plyr_[round_[_rID].plyr].addr,  //7
434             round_[_rID].eth,               //8
435             airDropTracker_ + (airDropPot_ * 1000)   //9
436         );
437     }
438 
439     function getCurrentPhraseInfo()
440         public
441         view
442         returns(uint256, uint256, uint256, uint256, uint256)
443     {
444         // setup local phID
445         uint256 _phID = phID_;
446         
447         return
448         (
449             _phID,                            //0
450             phrase_[_phID].eth,               //1
451             phrase_[_phID].guGiven,           //2
452             phrase_[_phID].minEthRequired,    //3
453             phrase_[_phID].guPoolAllocation   //4
454         );
455     }
456 
457     function getPlayerInfoByAddress(address _addr)
458         public 
459         view 
460         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
461     {
462         // setup local rID, phID
463         uint256 _rID = rID_;
464         uint256 _phID = phID_;
465         
466         if (_addr == address(0))
467         {
468             _addr == msg.sender;
469         }
470         uint256 _pID = pIDxAddr_[_addr];
471         
472         return
473         (
474             _pID,      // 0
475             plyrRnds_[_pID][_rID].keys,         //1
476             plyr_[_pID].gu,                     //2
477             plyr_[_pID].laff,                    //3
478             (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)).add(plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)), //4
479             plyr_[_pID].aff,                    //5
480             plyrRnds_[_pID][_rID].eth,           //6      totalIn for the round
481             plyrPhas_[_pID][_phID].eth,          //7      curr phrase referral eth
482             plyr_[_pID].referEth,               // 8      total referral eth
483             plyr_[_pID].withdraw                // 9      totalOut
484         );
485     }
486 
487     function buyCore(uint256 _pID, uint256 _affID)
488         whenNotPaused
489         private
490     {
491         // setup local rID
492         uint256 _rID = rID_;
493         
494         // grab time
495         uint256 _now = now;
496 
497         // whitelist checking
498         if (_now < round_[rID_].strt + whitelistRange_) {
499             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
500         }
501         
502         // if round is active
503         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
504         {
505             // call core 
506             core(_rID, _pID, msg.value, _affID);
507         
508         // if round is not active     
509         } else {
510             // check to see if end round needs to be ran
511             if (_now > round_[_rID].end && round_[_rID].ended == false) 
512             {
513                 // end the round (distributes pot) & start new round
514 			    round_[_rID].ended = true;
515                 endRound();
516             }
517             
518             // put eth in players vault 
519             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
520         }
521     }
522     
523     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
524         private
525     {
526         // if player is new to current round
527         if (plyrRnds_[_pID][_rID].keys == 0)
528         {
529             // if player has played a previous round, move their unmasked earnings
530             // from that round to gen vault.
531             if (plyr_[_pID].lrnd != 0)
532                 updateGenVault(_pID, plyr_[_pID].lrnd);
533             
534             plyr_[_pID].lrnd = rID_; // update player's last round played
535         }
536         
537         // early round eth limiter (0-100 eth)
538         uint256 _availableLimit;
539         uint256 _refund;
540         if (round_[_rID].eth < ethLimiterRange1_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter1_)
541         {
542             _availableLimit = (ethLimiter1_).sub(plyrRnds_[_pID][_rID].eth);
543             _refund = _eth.sub(_availableLimit);
544             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
545             _eth = _availableLimit;
546         } else if (round_[_rID].eth < ethLimiterRange2_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter2_)
547         {
548             _availableLimit = (ethLimiter2_).sub(plyrRnds_[_pID][_rID].eth);
549             _refund = _eth.sub(_availableLimit);
550             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
551             _eth = _availableLimit;
552         }
553         
554         // if eth left is greater than min eth allowed (sorry no pocket lint)
555         if (_eth > 1e9) 
556         {
557             // mint the new keys
558             uint256 _keys = keysRec(round_[_rID].eth, _eth);
559             
560             // if they bought at least 1 whole key
561             if (_keys >= 1e18)
562             {
563                 updateTimer(_keys, _rID);
564 
565                 // set new leaders
566                 if (round_[_rID].plyr != _pID)
567                     round_[_rID].plyr = _pID;
568 
569                 emit KeyPurchase(plyr_[round_[_rID].plyr].addr, _eth, _keys);
570             }
571             
572             // manage airdrops
573             if (_eth >= 1e17)
574             {
575                 airDropTracker_++;
576                 if (airdrop() == true)
577                 {
578                     // gib muni
579                     uint256 _prize;
580                     if (_eth >= 1e19)
581                     {
582                         // calculate prize and give it to winner
583                         _prize = ((airDropPot_).mul(75)) / 100;
584                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
585                         
586                         // adjust airDropPot 
587                         airDropPot_ = (airDropPot_).sub(_prize);
588                         
589                         // let event know a tier 3 prize was won 
590                     } else if (_eth >= 1e18 && _eth < 1e19) {
591                         // calculate prize and give it to winner
592                         _prize = ((airDropPot_).mul(50)) / 100;
593                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
594                         
595                         // adjust airDropPot 
596                         airDropPot_ = (airDropPot_).sub(_prize);
597                         
598                         // let event know a tier 2 prize was won 
599                     } else if (_eth >= 1e17 && _eth < 1e18) {
600                         // calculate prize and give it to winner
601                         _prize = ((airDropPot_).mul(25)) / 100;
602                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
603                         
604                         // adjust airDropPot 
605                         airDropPot_ = (airDropPot_).sub(_prize);
606                         
607                         // let event know a tier 3 prize was won 
608                     }
609 
610                     // reset air drop tracker
611                     airDropTracker_ = 0;
612                 }
613             }   
614             
615             leekStealGo();
616 
617             // update player 
618             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
619             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
620             round_[_rID].playCtr++;
621             playOrders_[round_[_rID].playCtr] = pID_; // for recording the 500 winners
622             
623             // update round
624             round_[_rID].allkeys = _keys.add(round_[_rID].allkeys);
625             round_[_rID].keys = _keys.add(round_[_rID].keys);
626             round_[_rID].eth = _eth.add(round_[_rID].eth);
627     
628             // distribute eth
629             distributeExternal(_rID, _pID, _eth, _affID);
630             distributeInternal(_rID, _pID, _eth, _keys);
631 
632             // manage gu-referral
633             updateGuReferral(_pID, _affID, _eth);
634 
635             checkDoubledProfit(_pID, _rID);
636             checkDoubledProfit(_affID, _rID);
637         }
638     }
639 
640     function checkDoubledProfit(uint256 _pID, uint256 _rID)
641         private
642     {   
643         // if pID has no keys, skip this
644         uint256 _keys = plyrRnds_[_pID][_rID].keys;
645         if (_keys > 0) {
646 
647             // zero out keys if the accumulated profit doubled
648             uint256 _balance = (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd));
649             if (_balance.add(plyrRnds_[_pID][_rID].genWithdraw) >= (plyrRnds_[_pID][_rID].eth))
650             {
651                 updateGenVault(_pID, plyr_[_pID].lrnd);
652 
653                 round_[_rID].keys = round_[_rID].keys.sub(_keys);
654                 plyrRnds_[_pID][_rID].keys = plyrRnds_[_pID][_rID].keys.sub(_keys);
655             }   
656         }
657     }
658 
659     function keysRec(uint256 _curEth, uint256 _newEth)
660         private
661         returns (uint256)
662     {
663         uint256 _startEth;
664         uint256 _incrRate;
665         uint256 _initPrice;
666 
667         if (_curEth < priceStage1_) {
668             _startEth = 0;
669             _initPrice = 33333; //3e-5;
670             _incrRate = 50000000; //2e-8;
671         }
672         else if (_curEth < priceStage2_) {
673             _startEth = priceStage1_;
674             _initPrice =  25000; // 4e-5;
675             _incrRate = 50000000; //2e-8;
676         }
677         else if (_curEth < priceStage3_) {
678             _startEth = priceStage2_;
679             _initPrice = 20000; //5e-5;
680             _incrRate = 50000000; //2e-8;;
681         }
682         else if (_curEth < priceStage4_) {
683             _startEth = priceStage3_;
684             _initPrice = 12500; //8e-5;
685             _incrRate = 26666666; //3.75e-8;
686         }
687         else if (_curEth < priceStage5_) {
688             _startEth = priceStage4_;
689             _initPrice = 5000; //2e-4;
690             _incrRate = 17777777; //5.625e-8;
691         }
692         else if (_curEth < priceStage6_) {
693             _startEth = priceStage5_;
694             _initPrice = 2500; // 4e-4;
695             _incrRate = 10666666; //9.375e-8;
696         }
697         else if (_curEth < priceStage7_) {
698             _startEth = priceStage6_;
699             _initPrice = 1000; //0.001;
700             _incrRate = 5688282; //1.758e-7;
701         }
702         else if (_curEth < priceStage8_) {
703             _startEth = priceStage7_;
704             _initPrice = 250; //0.004;
705             _incrRate = 2709292; //3.691e-7;
706         }
707         else if (_curEth < priceStage9_) {
708             _startEth = priceStage8_;
709             _initPrice = 62; //0.016;
710             _incrRate = 1161035; //8.613e-7;
711         }
712         else if (_curEth < priceStage10_) {
713             _startEth = priceStage9_;
714             _initPrice = 14; //0.071;
715             _incrRate = 451467; //2.215e-6;
716         }
717         else if (_curEth < priceStage11_) {
718             _startEth = priceStage10_;
719             _initPrice = 2; //0.354;
720             _incrRate = 144487; //6.921e-6;
721         }
722         else if (_curEth < priceStage12_) {
723             _startEth = priceStage11_;
724             _initPrice = 0; //2.126;
725             _incrRate = 40128; //2.492e-5;
726         }
727         else {
728             _startEth = priceStage12_;
729             _initPrice = 0;
730             _incrRate = 40128; //2.492e-5;
731         }
732 
733         return _newEth.mul(((_incrRate.mul(_initPrice)) / (_incrRate.add(_initPrice.mul((_curEth.sub(_startEth))/1e18)))));
734     }
735 
736     function updateGuReferral(uint256 _pID, uint256 _affID, uint256 _eth) private {
737         uint256 _newPhID = updateGuPhrase();
738 
739         // update phrase, and distribute remaining gu for the last phrase
740         if (phID_ < _newPhID) {
741             updateReferralMasks(phID_);
742             plyr_[1].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[1].gu); // give 20% gu to community first, at the beginning of the phrase start
743             plyr_[2].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[2].gu); // give 20% gu to community first, at the beginning of the phrase start
744             phrase_[_newPhID].guGiven = (phrase_[_newPhID].guPoolAllocation / 5).add(phrase_[_newPhID].guGiven);
745             allGuGiven_ = (phrase_[_newPhID].guPoolAllocation / 5).add(allGuGiven_);
746             phID_ = _newPhID; // update the phrase ID
747         }
748 
749         // update referral eth on affiliate
750         if (_affID != 0 && _affID != _pID) {
751             plyrPhas_[_affID][_newPhID].eth = _eth.add(plyrPhas_[_affID][_newPhID].eth);
752             plyr_[_affID].referEth = _eth.add(plyr_[_affID].referEth);
753             phrase_[_newPhID].eth = _eth.add(phrase_[_newPhID].eth);
754         }
755             
756         uint256 _remainGuReward = phrase_[_newPhID].guPoolAllocation.sub(phrase_[_newPhID].guGiven);
757         // if 1) one has referral amt larger than requirement, 2) has remaining => then distribute certain amt of Gu, i.e. update gu instead of adding gu
758         if (plyrPhas_[_affID][_newPhID].eth >= phrase_[_newPhID].minEthRequired && _remainGuReward >= 1e18) {
759             // check if need to reward more gu
760             uint256 _totalReward = plyrPhas_[_affID][_newPhID].eth / phrase_[_newPhID].minEthRequired;
761             _totalReward = _totalReward.mul(1e18);
762             uint256 _rewarded = plyrPhas_[_affID][_newPhID].guRewarded;
763             uint256 _toReward = _totalReward.sub(_rewarded);
764             if (_remainGuReward < _toReward) _toReward =  _remainGuReward;
765 
766             // give out gu reward
767             if (_toReward > 0) {
768                 plyr_[_affID].gu = _toReward.add(plyr_[_affID].gu); // give gu to player
769                 plyrPhas_[_affID][_newPhID].guRewarded = _toReward.add(plyrPhas_[_affID][_newPhID].guRewarded);
770                 phrase_[_newPhID].guGiven = 1e18.add(phrase_[_newPhID].guGiven);
771                 allGuGiven_ = 1e18.add(allGuGiven_);
772             }
773         }
774     }
775 
776     function updateReferralMasks(uint256 _phID) private {
777         uint256 _remainGu = phrase_[phID_].guPoolAllocation.sub(phrase_[phID_].guGiven);
778         if (_remainGu > 0 && phrase_[_phID].eth > 0) {
779             // remaining gu per total ethIn in the phrase
780             uint256 _gpe = (_remainGu.mul(1e18)) / phrase_[_phID].eth;
781             phrase_[_phID].mask = _gpe.add(phrase_[_phID].mask); // should only added once
782         }
783     }
784 
785     function transferGu(address _to, uint256 _guAmt) 
786         public
787         whenNotPaused
788         returns (bool) 
789     {
790         uint256 _pIDFrom = pIDxAddr_[msg.sender];
791 
792         // check if the sender (_pIDFrom) is not found or admin player
793         require(plyr_[_pIDFrom].addr == msg.sender);
794 
795         uint256 _pIDTo = pIDxAddr_[_to];
796 
797         plyr_[_pIDFrom].gu = plyr_[_pIDFrom].gu.sub(_guAmt);
798         plyr_[_pIDTo].gu = plyr_[_pIDTo].gu.add(_guAmt);
799         return true;
800     }
801     
802     function updateGuPhrase() 
803         private
804         returns (uint256) // return phraseNum
805     {
806         if (now <= contractStartDate_ + guPhrase1_) {
807             phrase_[1].minEthRequired = 5e18;
808             phrase_[1].guPoolAllocation = 100e18;
809             return 1; 
810         }
811         if (now <= contractStartDate_ + guPhrase2_) {
812             phrase_[2].minEthRequired = 4e18;
813             phrase_[2].guPoolAllocation = 200e18;
814             return 2; 
815         }
816         if (now <= contractStartDate_ + guPhrase3_) {
817             phrase_[3].minEthRequired = 3e18;
818             phrase_[3].guPoolAllocation = 400e18;
819             return 3; 
820         }
821         if (now <= contractStartDate_ + guPhrase4_) {
822             phrase_[4].minEthRequired = 2e18;
823             phrase_[4].guPoolAllocation = 800e18;
824             return 4; 
825         }
826         if (now <= contractStartDate_ + guPhrase5_) {
827             phrase_[5].minEthRequired = 1e18;
828             phrase_[5].guPoolAllocation = 1600e18;
829             return 5; 
830         }
831         if (now <= contractStartDate_ + guPhrase6_) {
832             phrase_[6].minEthRequired = 1e18;
833             phrase_[6].guPoolAllocation = 3200e18;
834             return 6; 
835         }
836         if (now <= contractStartDate_ + guPhrase7_) {
837             phrase_[7].minEthRequired = 1e18;
838             phrase_[7].guPoolAllocation = 6400e18;
839             return 7; 
840         }
841         if (now <= contractStartDate_ + guPhrase8_) {
842             phrase_[8].minEthRequired = 1e18;
843             phrase_[8].guPoolAllocation = 12800e18;
844             return 8; 
845         }
846         if (now <= contractStartDate_ + guPhrase9_) {
847             phrase_[9].minEthRequired = 1e18;
848             phrase_[9].guPoolAllocation = 25600e18;
849             return 9; 
850         }
851         if (now <= contractStartDate_ + guPhrase10_) {
852             phrase_[10].minEthRequired = 1e18;
853             phrase_[10].guPoolAllocation = 51200e18;
854             return 10; 
855         }
856         phrase_[11].minEthRequired = 0;
857         phrase_[11].guPoolAllocation = 0;
858         return 11;
859     }
860 
861     function leekStealGo() private {
862         // get a number for today dayNum 
863         uint leekStealToday_ = (now.sub(round_[rID_].strt) / 1 days); 
864         if (dayStealTime_[leekStealToday_] == 0) // if there hasn't a winner today, proceed
865         {
866             leekStealTracker_++;
867             if (randomNum(leekStealTracker_) == true)
868             {
869                 dayStealTime_[leekStealToday_] = now;
870                 leekStealOn_ = true;
871             }
872         }
873     }
874 
875     function stealTheLeek() public {
876         if (leekStealOn_)
877         {   
878             if (now.sub(dayStealTime_[leekStealToday_]) > 300) // if time passed 5min, turn off and exit
879             {
880                 leekStealOn_ = false;
881             } else {   
882                 // if yes then assign the 1eth, if the pool has 1eth
883                 if (leekStealPot_ > 1e18) {
884                     uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
885                     plyr_[_pID].win = plyr_[_pID].win.add(1e18);
886                     leekStealPot_ = leekStealPot_.sub(1e18);
887                 }
888             }
889         }
890     }
891 
892     function calcUnMaskedKeyEarnings(uint256 _pID, uint256 _rIDlast)
893         private
894         view
895         returns(uint256)
896     {
897         if (    (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18))  >    (plyrRnds_[_pID][_rIDlast].maskKey)       )
898             return(  (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18)).sub(plyrRnds_[_pID][_rIDlast].maskKey)  );
899         else
900             return 0;
901     }
902 
903     function calcUnMaskedGuEarnings(uint256 _pID)
904         private
905         view
906         returns(uint256)
907     {
908         if (    ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18))  >    (plyr_[_pID].maskGu)      )
909             return(  ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18)).sub(plyr_[_pID].maskGu)   );
910         else
911             return 0;
912     }
913     
914     function endRound()
915         private
916     {
917         // setup local rID
918         uint256 _rID = rID_;
919         
920         // grab our winning player id
921         uint256 _winPID = round_[_rID].plyr;
922         
923         // grab our pot amount
924         uint256 _pot = round_[_rID].pot;
925         
926         // calculate our winner share, community rewards, gen share, 
927         // jcg share, and amount reserved for next pot 
928         uint256 _win = (_pot.mul(40)) / 100;
929         uint256 _res = (_pot.mul(10)) / 100;
930 
931         
932         // pay our winner
933         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
934 
935         // pay the rest of the 500 winners
936         pay500Winners(_pot);
937         
938         // start next round
939         rID_++;
940         _rID++;
941         round_[_rID].strt = now;
942         round_[_rID].end = now.add(rndInit_);
943         round_[_rID].pot = _res;
944     }
945 
946     function pay500Winners(uint256 _pot) private {
947         uint256 _rID = rID_;
948         uint256 _plyCtr = round_[_rID].playCtr;
949 
950         // pay the 2-10th
951         uint256 _win2 = _pot.mul(25).div(100).div(9);
952         for (uint256 i = _plyCtr.sub(9); i <= _plyCtr.sub(1); i++) {
953             plyr_[playOrders_[i]].win = _win2.add(plyr_[playOrders_[i]].win);
954         }
955 
956         // pay the 11-100th
957         uint256 _win3 = _pot.mul(15).div(100).div(90);
958         for (uint256 j = _plyCtr.sub(99); j <= _plyCtr.sub(10); j++) {
959             plyr_[playOrders_[j]].win = _win3.add(plyr_[playOrders_[j]].win);
960         }
961 
962         // pay the 101-500th
963         uint256 _win4 = _pot.mul(10).div(100).div(400);
964         for (uint256 k = _plyCtr.sub(499); k <= _plyCtr.sub(100); k++) {
965             plyr_[playOrders_[k]].win = _win4.add(plyr_[playOrders_[k]].win);
966         }
967     }
968     
969     function updateGenVault(uint256 _pID, uint256 _rIDlast)
970         private 
971     {
972         uint256 _earnings = calcUnMaskedKeyEarnings(_pID, _rIDlast);
973         if (_earnings > 0)
974         {
975             // put in gen vault
976             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
977             // zero out their earnings by updating mask
978             plyrRnds_[_pID][_rIDlast].maskKey = _earnings.add(plyrRnds_[_pID][_rIDlast].maskKey);
979         }
980     }
981 
982     function updateGenGuVault(uint256 _pID)
983         private 
984     {
985         uint256 _earnings = calcUnMaskedGuEarnings(_pID);
986         if (_earnings > 0)
987         {
988             // put in genGu vault
989             plyr_[_pID].genGu = _earnings.add(plyr_[_pID].genGu);
990             // zero out their earnings by updating mask
991             plyr_[_pID].maskGu = _earnings.add(plyr_[_pID].maskGu);
992         }
993     }
994 
995     function updateReferralGu(uint256 _pID)
996         private 
997     {
998         // get current phID
999         uint256 _phID = phID_;
1000 
1001         // get last claimed phID till
1002         uint256 _lastClaimedPhID = plyr_[_pID].lastClaimedPhID;
1003 
1004         // calculate the gu Shares using these two input
1005         uint256 _guShares;
1006         for (uint i = (_lastClaimedPhID + 1); i < _phID; i++) {
1007             _guShares = (((phrase_[i].mask).mul(plyrPhas_[_pID][i].eth))/1e18).add(_guShares);
1008            
1009             // update record
1010             plyr_[_pID].lastClaimedPhID = i;
1011             phrase_[i].guGiven = _guShares.add(phrase_[i].guGiven);
1012             plyrPhas_[_pID][i].guRewarded = _guShares.add(plyrPhas_[_pID][i].guRewarded);
1013         }
1014 
1015         // put gu in player
1016         plyr_[_pID].gu = _guShares.add(plyr_[_pID].gu);
1017 
1018         // zero out their earnings by updating mask
1019         plyr_[_pID].maskGu = ((allMaskGu_.mul(_guShares)) / 1e18).add(plyr_[_pID].maskGu);
1020 
1021         allGuGiven_ = _guShares.add(allGuGiven_);
1022     }
1023     
1024     function updateTimer(uint256 _keys, uint256 _rID)
1025         private
1026     {
1027         // grab time
1028         uint256 _now = now;
1029         
1030         // calculate time based on number of keys bought
1031         uint256 _newTime;
1032         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1033             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1034         else
1035             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1036         
1037         // compare to max and set new end time
1038         if (_newTime < (rndMax_).add(_now))
1039             round_[_rID].end = _newTime;
1040         else
1041             round_[_rID].end = rndMax_.add(_now);
1042     }
1043     
1044     function airdrop()
1045         private 
1046         view 
1047         returns(bool)
1048     {
1049         uint256 seed = uint256(keccak256(abi.encodePacked(
1050             
1051             (block.timestamp).add
1052             (block.difficulty).add
1053             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1054             (block.gaslimit).add
1055             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1056             (block.number)
1057             
1058         )));
1059         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1060             return(true);
1061         else
1062             return(false);
1063     }
1064 
1065     function randomNum(uint256 _tracker)
1066         private 
1067         view 
1068         returns(bool)
1069     {
1070         uint256 seed = uint256(keccak256(abi.encodePacked(
1071             
1072             (block.timestamp).add
1073             (block.difficulty).add
1074             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1075             (block.gaslimit).add
1076             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1077             (block.number)
1078             
1079         )));
1080         if((seed - ((seed / 1000) * 1000)) < _tracker)
1081             return(true);
1082         else
1083             return(false);
1084     }
1085 
1086     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1087         private
1088     {
1089         // pay 2% out to community rewards
1090         uint256 _com = _eth / 100;
1091         address(WALLET_ETH_COM1).transfer(_com); // 1%
1092         address(WALLET_ETH_COM2).transfer(_com); // 1%
1093         
1094         // distribute 10% share to affiliate (8% + 2%)
1095         uint256 _aff = _eth / 10;
1096         
1097         // check: affiliate must not be self, and must have an ID
1098         if (_affID != _pID && _affID != 0) {
1099             plyr_[_affID].aff = (_aff.mul(8)/10).add(plyr_[_affID].aff); // distribute 8% to 1st aff
1100 
1101             uint256 _affID2 =  plyr_[_affID].laff; // get 2nd aff
1102             if (_affID2 != _pID && _affID2 != 0) {
1103                 plyr_[_affID2].aff = (_aff.mul(2)/10).add(plyr_[_affID2].aff); // distribute 2% to 2nd aff
1104             }
1105         } else {
1106             plyr_[1].aff = _aff.add(plyr_[_affID].aff);
1107         }
1108     }
1109     
1110     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys)
1111         private
1112     {
1113         // calculate gen share
1114         uint256 _gen = (_eth.mul(40)) / 100; // 40%
1115 
1116         // calculate jcg share
1117         uint256 _jcg = (_eth.mul(20)) / 100; // 20%
1118         
1119         // toss 3% into airdrop pot 
1120         uint256 _air = (_eth.mul(3)) / 100;
1121         airDropPot_ = airDropPot_.add(_air);
1122 
1123         // toss 5% into leeksteal pot 
1124         uint256 _steal = (_eth / 20);
1125         leekStealPot_ = leekStealPot_.add(_steal);
1126         
1127         // update eth balance (eth = eth - (2% com share + 3% airdrop + 5% leekSteal + 10% aff share))
1128         _eth = _eth.sub(((_eth.mul(20)) / 100)); 
1129         
1130         // calculate pot 
1131         uint256 _pot = _eth.sub(_gen).sub(_jcg);
1132         
1133         // distribute gen n jcg share (thats what updateMasks() does) and adjust
1134         // balances for dust.
1135         uint256 _dustKey = updateKeyMasks(_rID, _pID, _gen, _keys);
1136         uint256 _dustGu = updateGuMasks(_pID, _jcg);
1137         
1138         // add eth to pot
1139         round_[_rID].pot = _pot.add(_dustKey).add(_dustGu).add(round_[_rID].pot);
1140     }
1141 
1142     function updateKeyMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1143         private
1144         returns(uint256)
1145     {
1146         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1147         uint256 _ppt = (_gen.mul(1e18)) / (round_[_rID].keys);
1148         round_[_rID].maskKey = _ppt.add(round_[_rID].maskKey);
1149             
1150         // calculate player earning from their own buy (only based on the keys
1151         // they just bought).  & update player earnings mask
1152         uint256 _pearn = (_ppt.mul(_keys)) / (1e18);
1153         plyrRnds_[_pID][_rID].maskKey = (((round_[_rID].maskKey.mul(_keys)) / (1e18)).sub(_pearn)).add(plyrRnds_[_pID][_rID].maskKey);
1154         
1155         // calculate & return dust
1156         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1e18)));
1157     }
1158 
1159     function updateGuMasks(uint256 _pID, uint256 _jcg)
1160         private
1161         returns(uint256)
1162     {   
1163         if (allGuGiven_ > 0) {
1164             // calc profit per gu & round mask based on this buy:  (dust goes to pot)
1165             uint256 _ppg = (_jcg.mul(1e18)) / allGuGiven_;
1166             allMaskGu_ = _ppg.add(allMaskGu_);
1167 
1168             // calculate player earning from their own buy
1169             // & update player earnings mask
1170             uint256 _pearn = (_ppg.mul(plyr_[_pID].gu)) / (1e18);
1171             plyr_[_pID].maskGu = (((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18)).sub(_pearn)).add(plyr_[_pID].maskGu);
1172             
1173             // calculate & return dust
1174             return (_jcg.sub((_ppg.mul(allGuGiven_)) / (1e18)));
1175         } else {
1176             return _jcg;
1177         }
1178     }
1179     
1180     function withdrawEarnings(uint256 _pID, bool isWithdraw)
1181         whenNotPaused
1182         private
1183         returns(uint256)
1184     {
1185         updateGenGuVault(_pID);
1186 
1187         updateReferralGu(_pID);
1188 
1189         updateGenVault(_pID, plyr_[_pID].lrnd);
1190         if (isWithdraw) plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw = plyr_[_pID].gen.add(plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw); // for doubled profit
1191 
1192         // from all vaults 
1193         uint256 _earnings = plyr_[_pID].gen.add(plyr_[_pID].win).add(plyr_[_pID].genGu).add(plyr_[_pID].aff).add(plyr_[_pID].refund);
1194         if (_earnings > 0)
1195         {
1196             plyr_[_pID].win = 0;
1197             plyr_[_pID].gen = 0;
1198             plyr_[_pID].genGu = 0;
1199             plyr_[_pID].aff = 0;
1200             plyr_[_pID].refund = 0;
1201             if (isWithdraw) plyr_[_pID].withdraw = _earnings.add(plyr_[_pID].withdraw);
1202         }
1203 
1204         return(_earnings);
1205     }
1206 
1207     bool public activated_ = false;
1208     function activate()
1209         onlyOwner
1210         public
1211     {
1212         // can only be ran once
1213         require(activated_ == false);
1214         
1215         // activate the contract 
1216         activated_ = true;
1217         contractStartDate_ = now;
1218         
1219         // lets start first round
1220         rID_ = 1;
1221         round_[1].strt = now;
1222         round_[1].end = now + rndInit_;
1223     }
1224 }
1225 
1226 library Datasets {
1227     struct Player {
1228         address addr;   // player address
1229         uint256 win;    // winnings vault
1230         uint256 gen;    // general vault
1231         uint256 genGu;  // general gu vault
1232         uint256 aff;    // affiliate vault
1233         uint256 refund;  // refund vault
1234         uint256 lrnd;   // last round played
1235         uint256 laff;   // last affiliate id used
1236         uint256 withdraw; // sum of withdraw
1237         uint256 maskGu; // player mask gu: for sharing eth-profit by holding gu
1238         uint256 gu;     
1239         uint256 referEth; // total referral 
1240         uint256 lastClaimedPhID; // at which phID player has claimed the remaining gu
1241     }
1242     struct PlayerRounds {
1243         uint256 eth;    // eth player has added to round
1244         uint256 keys;   // keys
1245         uint256 maskKey;   // player mask key: for sharing eth-profit by holding keys
1246         uint256 genWithdraw;  // eth withdraw from gen vault
1247     }
1248     struct Round {
1249         uint256 plyr;   // pID of player in lead
1250         uint256 end;    // time ends/ended
1251         bool ended;     // has round end function been ran
1252         uint256 strt;   // time round started
1253         uint256 allkeys; // all keys
1254         uint256 keys;   // active keys
1255         uint256 eth;    // total eth in
1256         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1257         uint256 maskKey;   // global mask on key shares: for sharing eth-profit by holding keys
1258         uint256 playCtr;   // play counter for playOrders
1259     }
1260     struct PlayerPhrases {
1261         uint256 eth;   // amount of eth in of the referral
1262         uint256 guRewarded;  // if have taken the gu through referral
1263     }
1264     struct Phrase {
1265         uint256 eth;   // amount of total eth in of the referral
1266         uint256 guGiven; // amount of gu distributed 
1267         uint256 mask;  // a rate of remainGu per ethIn shares: for sharing gu-reward by referral eth
1268         uint256 minEthRequired;  // min refer.eth to get 1 gu
1269         uint256 guPoolAllocation; // total number of gu
1270     }
1271 }
1272 
1273 library SafeMath {
1274     
1275     /**
1276     * @dev Multiplies two numbers, throws on overflow.
1277     */
1278     function mul(uint256 a, uint256 b) 
1279         internal 
1280         pure 
1281         returns (uint256 c) 
1282     {
1283         if (a == 0) {
1284             return 0;
1285         }
1286         c = a * b;
1287         require(c / a == b, "SafeMath mul failed");
1288         return c;
1289     }
1290 
1291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1292         uint256 c = a / b;
1293         return c;
1294     }
1295 
1296     /**
1297     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1298     */
1299     function sub(uint256 a, uint256 b)
1300         internal
1301         pure
1302         returns (uint256) 
1303     {
1304         require(b <= a, "SafeMath sub failed");
1305         return a - b;
1306     }
1307 
1308     /**
1309     * @dev Adds two numbers, throws on overflow.
1310     */
1311     function add(uint256 a, uint256 b)
1312         internal
1313         pure
1314         returns (uint256 c) 
1315     {
1316         c = a + b;
1317         require(c >= a, "SafeMath add failed");
1318         return c;
1319     }
1320     
1321     /**
1322      * @dev gives square root of given x.
1323      */
1324     function sqrt(uint256 x)
1325         internal
1326         pure
1327         returns (uint256 y) 
1328     {
1329         uint256 z = ((add(x,1)) / 2);
1330         y = x;
1331         while (z < y) 
1332         {
1333             y = z;
1334             z = ((add((x / z),z)) / 2);
1335         }
1336     }
1337     
1338     /**
1339      * @dev gives square. multiplies x by x
1340      */
1341     function sq(uint256 x)
1342         internal
1343         pure
1344         returns (uint256)
1345     {
1346         return (mul(x,x));
1347     }
1348     
1349     /**
1350      * @dev x to the power of y 
1351      */
1352     function pwr(uint256 x, uint256 y)
1353         internal 
1354         pure 
1355         returns (uint256)
1356     {
1357         if (x==0)
1358             return (0);
1359         else if (y==0)
1360             return (1);
1361         else 
1362         {
1363             uint256 z = x;
1364             for (uint256 i=1; i < y; i++)
1365                 z = mul(z,x);
1366             return (z);
1367         }
1368     }
1369 }