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
330 
331 // Getters ====================
332     
333     function getPrice()
334         public
335         view
336         returns(uint256)
337     {   
338         uint256 keys = keysRec(round_[rID_].eth, 1e18);
339         return (1e36 / keys);
340     }
341     
342     function getTimeLeft()
343         public
344         view
345         returns(uint256)
346     {
347         // setup local rID
348         uint256 _rID = rID_;
349         
350         // grab time
351         uint256 _now = now;
352         
353         if (_now < round_[_rID].end)
354             if (_now > round_[_rID].strt)
355                 return( (round_[_rID].end).sub(_now) );
356             else
357                 return( (round_[_rID].strt).sub(_now) );
358         else
359             return(0);
360     }
361     
362     function getPlayerVaults(uint256 _pID)
363         public
364         view
365         returns(uint256 ,uint256, uint256, uint256, uint256)
366     {
367         // setup local rID
368         uint256 _rID = rID_;
369         
370         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
371         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
372         {
373             // if player is winner 
374             if (round_[_rID].plyr == _pID)
375             {
376                 return
377                 (
378                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
379                     (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)),
380                     (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
381                     plyr_[_pID].aff,
382                     plyr_[_pID].refund
383                 );
384             // if player is not the winner
385             } else {
386                 return
387                 (
388                     plyr_[_pID].win,
389                     (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)),
390                     (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
391                     plyr_[_pID].aff,
392                     plyr_[_pID].refund
393                 );
394             }
395             
396         // if round is still going on, or round has ended and round end has been ran
397         } else {
398             return
399             (
400                 plyr_[_pID].win,
401                 (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)),
402                 (plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)),
403                 plyr_[_pID].aff,
404                 plyr_[_pID].refund
405             );
406         }
407     }
408     
409     function getCurrentRoundInfo()
410         public
411         view
412         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
413     {
414         // setup local rID
415         uint256 _rID = rID_;
416         
417         return
418         (
419             _rID,                           //0
420             round_[_rID].allkeys,           //1
421             round_[_rID].keys,              //2
422             allGuGiven_,                    //3
423             round_[_rID].end,               //4
424             round_[_rID].strt,              //5
425             round_[_rID].pot,               //6
426             plyr_[round_[_rID].plyr].addr,  //7
427             round_[_rID].eth,               //8
428             airDropTracker_ + (airDropPot_ * 1000)   //9
429         );
430     }
431 
432     function getCurrentPhraseInfo()
433         public
434         view
435         returns(uint256, uint256, uint256, uint256, uint256)
436     {
437         // setup local phID
438         uint256 _phID = phID_;
439         
440         return
441         (
442             _phID,                            //0
443             phrase_[_phID].eth,               //1
444             phrase_[_phID].guGiven,           //2
445             phrase_[_phID].minEthRequired,    //3
446             phrase_[_phID].guPoolAllocation   //4
447         );
448     }
449 
450     function getPlayerInfoByAddress(address _addr)
451         public 
452         view 
453         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
454     {
455         // setup local rID, phID
456         uint256 _rID = rID_;
457         uint256 _phID = phID_;
458         
459         if (_addr == address(0))
460         {
461             _addr == msg.sender;
462         }
463         uint256 _pID = pIDxAddr_[_addr];
464         
465         return
466         (
467             _pID,      // 0
468             plyrRnds_[_pID][_rID].keys,         //1
469             plyr_[_pID].gu,                     //2
470             plyr_[_pID].laff,                    //3
471             (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd)).add(plyr_[_pID].genGu).add(calcUnMaskedGuEarnings(_pID)), //4
472             plyr_[_pID].aff,                    //5
473             plyrRnds_[_pID][_rID].eth,           //6      totalIn for the round
474             plyrPhas_[_pID][_phID].eth,          //7      curr phrase referral eth
475             plyr_[_pID].referEth,               // 8      total referral eth
476             plyr_[_pID].withdraw                // 9      totalOut
477         );
478     }
479 
480     function buyCore(uint256 _pID, uint256 _affID)
481         whenNotPaused
482         private
483     {
484         // setup local rID
485         uint256 _rID = rID_;
486         
487         // grab time
488         uint256 _now = now;
489 
490         // whitelist checking
491         if (_now < round_[rID_].strt + whitelistRange_) {
492             require(whitelisted_Prebuy[plyr_[_pID].addr] || whitelisted_Prebuy[plyr_[_affID].addr]);
493         }
494         
495         // if round is active
496         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
497         {
498             // call core 
499             core(_rID, _pID, msg.value, _affID);
500         
501         // if round is not active     
502         } else {
503             // check to see if end round needs to be ran
504             if (_now > round_[_rID].end && round_[_rID].ended == false) 
505             {
506                 // end the round (distributes pot) & start new round
507 			    round_[_rID].ended = true;
508                 endRound();
509             }
510             
511             // put eth in players vault 
512             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
513         }
514     }
515     
516     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
517         private
518     {
519         // if player is new to current round
520         if (plyrRnds_[_pID][_rID].keys == 0)
521         {
522             // if player has played a previous round, move their unmasked earnings
523             // from that round to gen vault.
524             if (plyr_[_pID].lrnd != 0)
525                 updateGenVault(_pID, plyr_[_pID].lrnd);
526             
527             plyr_[_pID].lrnd = rID_; // update player's last round played
528         }
529         
530         // early round eth limiter (0-100 eth)
531         uint256 _availableLimit;
532         uint256 _refund;
533         if (round_[_rID].eth < ethLimiterRange1_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter1_)
534         {
535             _availableLimit = (ethLimiter1_).sub(plyrRnds_[_pID][_rID].eth);
536             _refund = _eth.sub(_availableLimit);
537             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
538             _eth = _availableLimit;
539         } else if (round_[_rID].eth < ethLimiterRange2_ && plyrRnds_[_pID][_rID].eth.add(_eth) > ethLimiter2_)
540         {
541             _availableLimit = (ethLimiter2_).sub(plyrRnds_[_pID][_rID].eth);
542             _refund = _eth.sub(_availableLimit);
543             plyr_[_pID].refund = plyr_[_pID].refund.add(_refund);
544             _eth = _availableLimit;
545         }
546         
547         // if eth left is greater than min eth allowed (sorry no pocket lint)
548         if (_eth > 1e9) 
549         {
550             // mint the new keys
551             uint256 _keys = keysRec(round_[_rID].eth, _eth);
552             
553             // if they bought at least 1 whole key
554             if (_keys >= 1e18)
555             {
556                 updateTimer(_keys, _rID);
557 
558                 // set new leaders
559                 if (round_[_rID].plyr != _pID)
560                     round_[_rID].plyr = _pID;
561 
562                 emit KeyPurchase(plyr_[round_[_rID].plyr].addr, _eth, _keys);
563             }
564             
565             // manage airdrops
566             if (_eth >= 1e17)
567             {
568                 airDropTracker_++;
569                 if (airdrop() == true)
570                 {
571                     // gib muni
572                     uint256 _prize;
573                     if (_eth >= 1e19)
574                     {
575                         // calculate prize and give it to winner
576                         _prize = ((airDropPot_).mul(75)) / 100;
577                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
578                         
579                         // adjust airDropPot 
580                         airDropPot_ = (airDropPot_).sub(_prize);
581                         
582                         // let event know a tier 3 prize was won 
583                     } else if (_eth >= 1e18 && _eth < 1e19) {
584                         // calculate prize and give it to winner
585                         _prize = ((airDropPot_).mul(50)) / 100;
586                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
587                         
588                         // adjust airDropPot 
589                         airDropPot_ = (airDropPot_).sub(_prize);
590                         
591                         // let event know a tier 2 prize was won 
592                     } else if (_eth >= 1e17 && _eth < 1e18) {
593                         // calculate prize and give it to winner
594                         _prize = ((airDropPot_).mul(25)) / 100;
595                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
596                         
597                         // adjust airDropPot 
598                         airDropPot_ = (airDropPot_).sub(_prize);
599                         
600                         // let event know a tier 3 prize was won 
601                     }
602 
603                     // reset air drop tracker
604                     airDropTracker_ = 0;
605                 }
606             }   
607             
608             leekStealGo();
609 
610             // update player 
611             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
612             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
613             round_[_rID].playCtr++;
614             playOrders_[round_[_rID].playCtr] = pID_; // for recording the 500 winners
615             
616             // update round
617             round_[_rID].allkeys = _keys.add(round_[_rID].allkeys);
618             round_[_rID].keys = _keys.add(round_[_rID].keys);
619             round_[_rID].eth = _eth.add(round_[_rID].eth);
620     
621             // distribute eth
622             distributeExternal(_rID, _pID, _eth, _affID);
623             distributeInternal(_rID, _pID, _eth, _keys);
624 
625             // manage gu-referral
626             updateGuReferral(_pID, _affID, _eth);
627 
628             checkDoubledProfit(_pID, _rID);
629             checkDoubledProfit(_affID, _rID);
630         }
631     }
632 
633     function checkDoubledProfit(uint256 _pID, uint256 _rID)
634         private
635     {   
636         // if pID has no keys, skip this
637         uint256 _keys = plyrRnds_[_pID][_rID].keys;
638         if (_keys > 0) {
639 
640             // zero out keys if the accumulated profit doubled
641             uint256 _balance = (plyr_[_pID].gen).add(calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd));
642             if (_balance.add(plyrRnds_[_pID][_rID].genWithdraw) >= (plyrRnds_[_pID][_rID].eth))
643             {
644                 updateGenVault(_pID, plyr_[_pID].lrnd);
645 
646                 round_[_rID].keys = round_[_rID].keys.sub(_keys);
647                 plyrRnds_[_pID][_rID].keys = plyrRnds_[_pID][_rID].keys.sub(_keys);
648             }   
649         }
650     }
651 
652     function keysRec(uint256 _curEth, uint256 _newEth)
653         private
654         returns (uint256)
655     {
656         uint256 _startEth;
657         uint256 _incrRate;
658         uint256 _initPrice;
659 
660         if (_curEth < priceStage1_) {
661             _startEth = 0;
662             _initPrice = 33333; //3e-5;
663             _incrRate = 50000000; //2e-8;
664         }
665         else if (_curEth < priceStage2_) {
666             _startEth = priceStage1_;
667             _initPrice =  25000; // 4e-5;
668             _incrRate = 50000000; //2e-8;
669         }
670         else if (_curEth < priceStage3_) {
671             _startEth = priceStage2_;
672             _initPrice = 20000; //5e-5;
673             _incrRate = 50000000; //2e-8;;
674         }
675         else if (_curEth < priceStage4_) {
676             _startEth = priceStage3_;
677             _initPrice = 12500; //8e-5;
678             _incrRate = 26666666; //3.75e-8;
679         }
680         else if (_curEth < priceStage5_) {
681             _startEth = priceStage4_;
682             _initPrice = 5000; //2e-4;
683             _incrRate = 17777777; //5.625e-8;
684         }
685         else if (_curEth < priceStage6_) {
686             _startEth = priceStage5_;
687             _initPrice = 2500; // 4e-4;
688             _incrRate = 10666666; //9.375e-8;
689         }
690         else if (_curEth < priceStage7_) {
691             _startEth = priceStage6_;
692             _initPrice = 1000; //0.001;
693             _incrRate = 5688282; //1.758e-7;
694         }
695         else if (_curEth < priceStage8_) {
696             _startEth = priceStage7_;
697             _initPrice = 250; //0.004;
698             _incrRate = 2709292; //3.691e-7;
699         }
700         else if (_curEth < priceStage9_) {
701             _startEth = priceStage8_;
702             _initPrice = 62; //0.016;
703             _incrRate = 1161035; //8.613e-7;
704         }
705         else if (_curEth < priceStage10_) {
706             _startEth = priceStage9_;
707             _initPrice = 14; //0.071;
708             _incrRate = 451467; //2.215e-6;
709         }
710         else if (_curEth < priceStage11_) {
711             _startEth = priceStage10_;
712             _initPrice = 2; //0.354;
713             _incrRate = 144487; //6.921e-6;
714         }
715         else if (_curEth < priceStage12_) {
716             _startEth = priceStage11_;
717             _initPrice = 0; //2.126;
718             _incrRate = 40128; //2.492e-5;
719         }
720         else {
721             _startEth = priceStage12_;
722             _initPrice = 0;
723             _incrRate = 40128; //2.492e-5;
724         }
725 
726         return _newEth.mul(((_incrRate.mul(_initPrice)) / (_incrRate.add(_initPrice.mul((_curEth.sub(_startEth))/1e18)))));
727     }
728 
729     function updateGuReferral(uint256 _pID, uint256 _affID, uint256 _eth) private {
730         uint256 _newPhID = updateGuPhrase();
731 
732         // update phrase, and distribute remaining gu for the last phrase
733         if (phID_ < _newPhID) {
734             updateReferralMasks(phID_);
735             plyr_[1].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[1].gu); // give 20% gu to community first, at the beginning of the phrase start
736             plyr_[2].gu = (phrase_[_newPhID].guPoolAllocation / 10).add(plyr_[2].gu); // give 20% gu to community first, at the beginning of the phrase start
737             phrase_[_newPhID].guGiven = (phrase_[_newPhID].guPoolAllocation / 5).add(phrase_[_newPhID].guGiven);
738             allGuGiven_ = (phrase_[_newPhID].guPoolAllocation / 5).add(allGuGiven_);
739             phID_ = _newPhID; // update the phrase ID
740         }
741 
742         // update referral eth on affiliate
743         if (_affID != 0 && _affID != _pID) {
744             plyrPhas_[_affID][_newPhID].eth = _eth.add(plyrPhas_[_affID][_newPhID].eth);
745             plyr_[_affID].referEth = _eth.add(plyr_[_affID].referEth);
746             phrase_[_newPhID].eth = _eth.add(phrase_[_newPhID].eth);
747         }
748             
749         uint256 _remainGuReward = phrase_[_newPhID].guPoolAllocation.sub(phrase_[_newPhID].guGiven);
750         // if 1) one has referral amt larger than requirement, 2) has remaining => then distribute certain amt of Gu, i.e. update gu instead of adding gu
751         if (plyrPhas_[_affID][_newPhID].eth >= phrase_[_newPhID].minEthRequired && _remainGuReward >= 1e18) {
752             // check if need to reward more gu
753             uint256 _totalReward = plyrPhas_[_affID][_newPhID].eth / phrase_[_newPhID].minEthRequired;
754             _totalReward = _totalReward.mul(1e18);
755             uint256 _rewarded = plyrPhas_[_affID][_newPhID].guRewarded;
756             uint256 _toReward = _totalReward.sub(_rewarded);
757             if (_remainGuReward < _toReward) _toReward =  _remainGuReward;
758 
759             // give out gu reward
760             if (_toReward > 0) {
761                 plyr_[_affID].gu = _toReward.add(plyr_[_affID].gu); // give gu to player
762                 plyrPhas_[_affID][_newPhID].guRewarded = _toReward.add(plyrPhas_[_affID][_newPhID].guRewarded);
763                 phrase_[_newPhID].guGiven = 1e18.add(phrase_[_newPhID].guGiven);
764                 allGuGiven_ = 1e18.add(allGuGiven_);
765             }
766         }
767     }
768 
769     function updateReferralMasks(uint256 _phID) private {
770         uint256 _remainGu = phrase_[phID_].guPoolAllocation.sub(phrase_[phID_].guGiven);
771         if (_remainGu > 0 && phrase_[_phID].eth > 0) {
772             // remaining gu per total ethIn in the phrase
773             uint256 _gpe = (_remainGu.mul(1e18)) / phrase_[_phID].eth;
774             phrase_[_phID].mask = _gpe.add(phrase_[_phID].mask); // should only added once
775         }
776     }
777 
778     function transferGu(address _to, uint256 _guAmt) 
779         public
780         whenNotPaused
781         returns (bool) 
782     {
783         uint256 _pIDFrom = pIDxAddr_[msg.sender];
784 
785         // check if the sender (_pIDFrom) is not found or admin player
786         require(plyr_[_pIDFrom].addr == msg.sender);
787 
788         uint256 _pIDTo = pIDxAddr_[_to];
789 
790         plyr_[_pIDFrom].gu = plyr_[_pIDFrom].gu.sub(_guAmt);
791         plyr_[_pIDTo].gu = plyr_[_pIDTo].gu.add(_guAmt);
792         return true;
793     }
794     
795     function updateGuPhrase() 
796         private
797         returns (uint256) // return phraseNum
798     {
799         if (now <= contractStartDate_ + guPhrase1_) {
800             phrase_[1].minEthRequired = 5e18;
801             phrase_[1].guPoolAllocation = 100e18;
802             return 1; 
803         }
804         if (now <= contractStartDate_ + guPhrase2_) {
805             phrase_[2].minEthRequired = 4e18;
806             phrase_[2].guPoolAllocation = 200e18;
807             return 2; 
808         }
809         if (now <= contractStartDate_ + guPhrase3_) {
810             phrase_[3].minEthRequired = 3e18;
811             phrase_[3].guPoolAllocation = 400e18;
812             return 3; 
813         }
814         if (now <= contractStartDate_ + guPhrase4_) {
815             phrase_[4].minEthRequired = 2e18;
816             phrase_[4].guPoolAllocation = 800e18;
817             return 4; 
818         }
819         if (now <= contractStartDate_ + guPhrase5_) {
820             phrase_[5].minEthRequired = 1e18;
821             phrase_[5].guPoolAllocation = 1600e18;
822             return 5; 
823         }
824         if (now <= contractStartDate_ + guPhrase6_) {
825             phrase_[6].minEthRequired = 1e18;
826             phrase_[6].guPoolAllocation = 3200e18;
827             return 6; 
828         }
829         if (now <= contractStartDate_ + guPhrase7_) {
830             phrase_[7].minEthRequired = 1e18;
831             phrase_[7].guPoolAllocation = 6400e18;
832             return 7; 
833         }
834         if (now <= contractStartDate_ + guPhrase8_) {
835             phrase_[8].minEthRequired = 1e18;
836             phrase_[8].guPoolAllocation = 12800e18;
837             return 8; 
838         }
839         if (now <= contractStartDate_ + guPhrase9_) {
840             phrase_[9].minEthRequired = 1e18;
841             phrase_[9].guPoolAllocation = 25600e18;
842             return 9; 
843         }
844         if (now <= contractStartDate_ + guPhrase10_) {
845             phrase_[10].minEthRequired = 1e18;
846             phrase_[10].guPoolAllocation = 51200e18;
847             return 10; 
848         }
849         phrase_[11].minEthRequired = 0;
850         phrase_[11].guPoolAllocation = 0;
851         return 11;
852     }
853 
854     function leekStealGo() private {
855         // get a number for today dayNum 
856         uint leekStealToday_ = (now.sub(round_[rID_].strt) / 1 days); 
857         if (dayStealTime_[leekStealToday_] == 0) // if there hasn't a winner today, proceed
858         {
859             leekStealTracker_++;
860             if (randomNum(leekStealTracker_) == true)
861             {
862                 dayStealTime_[leekStealToday_] = now;
863                 leekStealOn_ = true;
864             }
865         }
866     }
867 
868     function stealTheLeek() public {
869         if (leekStealOn_)
870         {   
871             if (now.sub(dayStealTime_[leekStealToday_]) > 300) // if time passed 5min, turn off and exit
872             {
873                 leekStealOn_ = false;
874             } else {   
875                 // if yes then assign the 1eth, if the pool has 1eth
876                 if (leekStealPot_ > 1e18) {
877                     uint256 _pID = pIDxAddr_[msg.sender]; // fetch player ID
878                     plyr_[_pID].win = plyr_[_pID].win.add(1e18);
879                     leekStealPot_ = leekStealPot_.sub(1e18);
880                 }
881             }
882         }
883     }
884 
885     function calcUnMaskedKeyEarnings(uint256 _pID, uint256 _rIDlast)
886         private
887         view
888         returns(uint256)
889     {
890         if (    (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18))  >    (plyrRnds_[_pID][_rIDlast].maskKey)       )
891             return(  (((round_[_rIDlast].maskKey).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18)).sub(plyrRnds_[_pID][_rIDlast].maskKey)  );
892         else
893             return 0;
894     }
895 
896     function calcUnMaskedGuEarnings(uint256 _pID)
897         private
898         view
899         returns(uint256)
900     {
901         if (    ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18))  >    (plyr_[_pID].maskGu)      )
902             return(  ((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18)).sub(plyr_[_pID].maskGu)   );
903         else
904             return 0;
905     }
906     
907     function endRound()
908         private
909     {
910         // setup local rID
911         uint256 _rID = rID_;
912         
913         // grab our winning player id
914         uint256 _winPID = round_[_rID].plyr;
915         
916         // grab our pot amount
917         uint256 _pot = round_[_rID].pot;
918         
919         // calculate our winner share, community rewards, gen share, 
920         // jcg share, and amount reserved for next pot 
921         uint256 _win = (_pot.mul(40)) / 100;
922         uint256 _res = (_pot.mul(10)) / 100;
923 
924         
925         // pay our winner
926         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
927 
928         // pay the rest of the 500 winners
929         pay500Winners(_pot);
930         
931         // start next round
932         rID_++;
933         _rID++;
934         round_[_rID].strt = now;
935         round_[_rID].end = now.add(rndInit_);
936         round_[_rID].pot = _res;
937     }
938 
939     function pay500Winners(uint256 _pot) private {
940         uint256 _rID = rID_;
941         uint256 _plyCtr = round_[_rID].playCtr;
942 
943         // pay the 2-10th
944         uint256 _win2 = _pot.mul(25).div(100).div(9);
945         for (uint256 i = _plyCtr.sub(9); i <= _plyCtr.sub(1); i++) {
946             plyr_[playOrders_[i]].win = _win2.add(plyr_[playOrders_[i]].win);
947         }
948 
949         // pay the 11-100th
950         uint256 _win3 = _pot.mul(15).div(100).div(90);
951         for (uint256 j = _plyCtr.sub(99); j <= _plyCtr.sub(10); j++) {
952             plyr_[playOrders_[j]].win = _win3.add(plyr_[playOrders_[j]].win);
953         }
954 
955         // pay the 101-500th
956         uint256 _win4 = _pot.mul(10).div(100).div(400);
957         for (uint256 k = _plyCtr.sub(499); k <= _plyCtr.sub(100); k++) {
958             plyr_[playOrders_[k]].win = _win4.add(plyr_[playOrders_[k]].win);
959         }
960     }
961     
962     function updateGenVault(uint256 _pID, uint256 _rIDlast)
963         private 
964     {
965         uint256 _earnings = calcUnMaskedKeyEarnings(_pID, _rIDlast);
966         if (_earnings > 0)
967         {
968             // put in gen vault
969             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
970             // zero out their earnings by updating mask
971             plyrRnds_[_pID][_rIDlast].maskKey = _earnings.add(plyrRnds_[_pID][_rIDlast].maskKey);
972         }
973     }
974 
975     function updateGenGuVault(uint256 _pID)
976         private 
977     {
978         uint256 _earnings = calcUnMaskedGuEarnings(_pID);
979         if (_earnings > 0)
980         {
981             // put in genGu vault
982             plyr_[_pID].genGu = _earnings.add(plyr_[_pID].genGu);
983             // zero out their earnings by updating mask
984             plyr_[_pID].maskGu = _earnings.add(plyr_[_pID].maskGu);
985         }
986     }
987 
988     function updateReferralGu(uint256 _pID)
989         private 
990     {
991         // get current phID
992         uint256 _phID = phID_;
993 
994         // get last claimed phID till
995         uint256 _lastClaimedPhID = plyr_[_pID].lastClaimedPhID;
996 
997         // calculate the gu Shares using these two input
998         uint256 _guShares;
999         for (uint i = (_lastClaimedPhID + 1); i < _phID; i++) {
1000             _guShares = (((phrase_[i].mask).mul(plyrPhas_[_pID][i].eth))/1e18).add(_guShares);
1001            
1002             // update record
1003             plyr_[_pID].lastClaimedPhID = i;
1004             phrase_[i].guGiven = _guShares.add(phrase_[i].guGiven);
1005             plyrPhas_[_pID][i].guRewarded = _guShares.add(plyrPhas_[_pID][i].guRewarded);
1006         }
1007 
1008         // put gu in player
1009         plyr_[_pID].gu = _guShares.add(plyr_[_pID].gu);
1010 
1011         // zero out their earnings by updating mask
1012         plyr_[_pID].maskGu = ((allMaskGu_.mul(_guShares)) / 1e18).add(plyr_[_pID].maskGu);
1013 
1014         allGuGiven_ = _guShares.add(allGuGiven_);
1015     }
1016     
1017     function updateTimer(uint256 _keys, uint256 _rID)
1018         private
1019     {
1020         // grab time
1021         uint256 _now = now;
1022         
1023         // calculate time based on number of keys bought
1024         uint256 _newTime;
1025         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1026             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1027         else
1028             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1029         
1030         // compare to max and set new end time
1031         if (_newTime < (rndMax_).add(_now))
1032             round_[_rID].end = _newTime;
1033         else
1034             round_[_rID].end = rndMax_.add(_now);
1035     }
1036     
1037     function airdrop()
1038         private 
1039         view 
1040         returns(bool)
1041     {
1042         uint256 seed = uint256(keccak256(abi.encodePacked(
1043             
1044             (block.timestamp).add
1045             (block.difficulty).add
1046             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1047             (block.gaslimit).add
1048             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1049             (block.number)
1050             
1051         )));
1052         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1053             return(true);
1054         else
1055             return(false);
1056     }
1057 
1058     function randomNum(uint256 _tracker)
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
1073         if((seed - ((seed / 1000) * 1000)) < _tracker)
1074             return(true);
1075         else
1076             return(false);
1077     }
1078 
1079     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
1080         private
1081     {
1082         // pay 2% out to community rewards
1083         uint256 _com = _eth / 100;
1084         address(WALLET_ETH_COM1).transfer(_com); // 1%
1085         address(WALLET_ETH_COM2).transfer(_com); // 1%
1086         
1087         // distribute 10% share to affiliate (8% + 2%)
1088         uint256 _aff = _eth / 10;
1089         
1090         // check: affiliate must not be self, and must have an ID
1091         if (_affID != _pID && _affID != 0) {
1092             plyr_[_affID].aff = (_aff.mul(8)/10).add(plyr_[_affID].aff); // distribute 8% to 1st aff
1093 
1094             uint256 _affID2 =  plyr_[_affID].laff; // get 2nd aff
1095             if (_affID2 != _pID && _affID2 != 0) {
1096                 plyr_[_affID2].aff = (_aff.mul(2)/10).add(plyr_[_affID2].aff); // distribute 2% to 2nd aff
1097             }
1098         } else {
1099             plyr_[1].aff = _aff.add(plyr_[_affID].aff);
1100         }
1101     }
1102     
1103     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys)
1104         private
1105     {
1106         // calculate gen share
1107         uint256 _gen = (_eth.mul(40)) / 100; // 40%
1108 
1109         // calculate jcg share
1110         uint256 _jcg = (_eth.mul(20)) / 100; // 20%
1111         
1112         // toss 3% into airdrop pot 
1113         uint256 _air = (_eth.mul(3)) / 100;
1114         airDropPot_ = airDropPot_.add(_air);
1115 
1116         // toss 5% into leeksteal pot 
1117         uint256 _steal = (_eth / 20);
1118         leekStealPot_ = leekStealPot_.add(_steal);
1119         
1120         // update eth balance (eth = eth - (2% com share + 3% airdrop + 5% leekSteal + 10% aff share))
1121         _eth = _eth.sub(((_eth.mul(20)) / 100)); 
1122         
1123         // calculate pot 
1124         uint256 _pot = _eth.sub(_gen).sub(_jcg);
1125         
1126         // distribute gen n jcg share (thats what updateMasks() does) and adjust
1127         // balances for dust.
1128         uint256 _dustKey = updateKeyMasks(_rID, _pID, _gen, _keys);
1129         uint256 _dustGu = updateGuMasks(_pID, _jcg);
1130         
1131         // add eth to pot
1132         round_[_rID].pot = _pot.add(_dustKey).add(_dustGu).add(round_[_rID].pot);
1133     }
1134 
1135     function updateKeyMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1136         private
1137         returns(uint256)
1138     {
1139         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1140         uint256 _ppt = (_gen.mul(1e18)) / (round_[_rID].keys);
1141         round_[_rID].maskKey = _ppt.add(round_[_rID].maskKey);
1142             
1143         // calculate player earning from their own buy (only based on the keys
1144         // they just bought).  & update player earnings mask
1145         uint256 _pearn = (_ppt.mul(_keys)) / (1e18);
1146         plyrRnds_[_pID][_rID].maskKey = (((round_[_rID].maskKey.mul(_keys)) / (1e18)).sub(_pearn)).add(plyrRnds_[_pID][_rID].maskKey);
1147         
1148         // calculate & return dust
1149         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1e18)));
1150     }
1151 
1152     function updateGuMasks(uint256 _pID, uint256 _jcg)
1153         private
1154         returns(uint256)
1155     {   
1156         if (allGuGiven_ > 0) {
1157             // calc profit per gu & round mask based on this buy:  (dust goes to pot)
1158             uint256 _ppg = (_jcg.mul(1e18)) / allGuGiven_;
1159             allMaskGu_ = _ppg.add(allMaskGu_);
1160 
1161             // calculate player earning from their own buy
1162             // & update player earnings mask
1163             uint256 _pearn = (_ppg.mul(plyr_[_pID].gu)) / (1e18);
1164             plyr_[_pID].maskGu = (((allMaskGu_.mul(plyr_[_pID].gu)) / (1e18)).sub(_pearn)).add(plyr_[_pID].maskGu);
1165             
1166             // calculate & return dust
1167             return (_jcg.sub((_ppg.mul(allGuGiven_)) / (1e18)));
1168         } else {
1169             return _jcg;
1170         }
1171     }
1172     
1173     function withdrawEarnings(uint256 _pID, bool isWithdraw)
1174         whenNotPaused
1175         private
1176         returns(uint256)
1177     {
1178         updateGenGuVault(_pID);
1179 
1180         updateReferralGu(_pID);
1181 
1182         updateGenVault(_pID, plyr_[_pID].lrnd);
1183         if (isWithdraw) plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw = plyr_[_pID].gen.add(plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw); // for doubled profit
1184 
1185         // from all vaults 
1186         uint256 _earnings = plyr_[_pID].gen.add(plyr_[_pID].win).add(plyr_[_pID].genGu).add(plyr_[_pID].aff).add(plyr_[_pID].refund);
1187         if (_earnings > 0)
1188         {
1189             plyr_[_pID].win = 0;
1190             plyr_[_pID].gen = 0;
1191             plyr_[_pID].genGu = 0;
1192             plyr_[_pID].aff = 0;
1193             plyr_[_pID].refund = 0;
1194             if (isWithdraw) plyr_[_pID].withdraw = _earnings.add(plyr_[_pID].withdraw);
1195         }
1196 
1197         return(_earnings);
1198     }
1199 
1200     bool public activated_ = false;
1201     function activate()
1202         onlyOwner
1203         public
1204     {
1205         // can only be ran once
1206         require(activated_ == false);
1207         
1208         // activate the contract 
1209         activated_ = true;
1210         contractStartDate_ = now;
1211         
1212         // lets start first round
1213         rID_ = 1;
1214         round_[1].strt = now;
1215         round_[1].end = now + rndInit_;
1216     }
1217 }
1218 
1219 library Datasets {
1220     struct Player {
1221         address addr;   // player address
1222         uint256 win;    // winnings vault
1223         uint256 gen;    // general vault
1224         uint256 genGu;  // general gu vault
1225         uint256 aff;    // affiliate vault
1226         uint256 refund;  // refund vault
1227         uint256 lrnd;   // last round played
1228         uint256 laff;   // last affiliate id used
1229         uint256 withdraw; // sum of withdraw
1230         uint256 maskGu; // player mask gu: for sharing eth-profit by holding gu
1231         uint256 gu;     
1232         uint256 referEth; // total referral 
1233         uint256 lastClaimedPhID; // at which phID player has claimed the remaining gu
1234     }
1235     struct PlayerRounds {
1236         uint256 eth;    // eth player has added to round
1237         uint256 keys;   // keys
1238         uint256 maskKey;   // player mask key: for sharing eth-profit by holding keys
1239         uint256 genWithdraw;  // eth withdraw from gen vault
1240     }
1241     struct Round {
1242         uint256 plyr;   // pID of player in lead
1243         uint256 end;    // time ends/ended
1244         bool ended;     // has round end function been ran
1245         uint256 strt;   // time round started
1246         uint256 allkeys; // all keys
1247         uint256 keys;   // active keys
1248         uint256 eth;    // total eth in
1249         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1250         uint256 maskKey;   // global mask on key shares: for sharing eth-profit by holding keys
1251         uint256 playCtr;   // play counter for playOrders
1252     }
1253     struct PlayerPhrases {
1254         uint256 eth;   // amount of eth in of the referral
1255         uint256 guRewarded;  // if have taken the gu through referral
1256     }
1257     struct Phrase {
1258         uint256 eth;   // amount of total eth in of the referral
1259         uint256 guGiven; // amount of gu distributed 
1260         uint256 mask;  // a rate of remainGu per ethIn shares: for sharing gu-reward by referral eth
1261         uint256 minEthRequired;  // min refer.eth to get 1 gu
1262         uint256 guPoolAllocation; // total number of gu
1263     }
1264 }
1265 
1266 library SafeMath {
1267     
1268     /**
1269     * @dev Multiplies two numbers, throws on overflow.
1270     */
1271     function mul(uint256 a, uint256 b) 
1272         internal 
1273         pure 
1274         returns (uint256 c) 
1275     {
1276         if (a == 0) {
1277             return 0;
1278         }
1279         c = a * b;
1280         require(c / a == b, "SafeMath mul failed");
1281         return c;
1282     }
1283 
1284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1285         uint256 c = a / b;
1286         return c;
1287     }
1288 
1289     /**
1290     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1291     */
1292     function sub(uint256 a, uint256 b)
1293         internal
1294         pure
1295         returns (uint256) 
1296     {
1297         require(b <= a, "SafeMath sub failed");
1298         return a - b;
1299     }
1300 
1301     /**
1302     * @dev Adds two numbers, throws on overflow.
1303     */
1304     function add(uint256 a, uint256 b)
1305         internal
1306         pure
1307         returns (uint256 c) 
1308     {
1309         c = a + b;
1310         require(c >= a, "SafeMath add failed");
1311         return c;
1312     }
1313     
1314     /**
1315      * @dev gives square root of given x.
1316      */
1317     function sqrt(uint256 x)
1318         internal
1319         pure
1320         returns (uint256 y) 
1321     {
1322         uint256 z = ((add(x,1)) / 2);
1323         y = x;
1324         while (z < y) 
1325         {
1326             y = z;
1327             z = ((add((x / z),z)) / 2);
1328         }
1329     }
1330     
1331     /**
1332      * @dev gives square. multiplies x by x
1333      */
1334     function sq(uint256 x)
1335         internal
1336         pure
1337         returns (uint256)
1338     {
1339         return (mul(x,x));
1340     }
1341     
1342     /**
1343      * @dev x to the power of y 
1344      */
1345     function pwr(uint256 x, uint256 y)
1346         internal 
1347         pure 
1348         returns (uint256)
1349     {
1350         if (x==0)
1351             return (0);
1352         else if (y==0)
1353             return (1);
1354         else 
1355         {
1356             uint256 z = x;
1357             for (uint256 i=1; i < y; i++)
1358                 z = mul(z,x);
1359             return (z);
1360         }
1361     }
1362 }