1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
9  * - added sqrt
10  * - added sq
11  * - added pwr
12  * - changed asserts to requires with error log outputs
13  * - removed div, its useless
14  */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b)
21     internal
22     pure
23     returns (uint256 c)
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b)
37     internal
38     pure
39     returns (uint256)
40     {
41         require(b <= a, "SafeMath sub failed");
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b)
49     internal
50     pure
51     returns (uint256 c)
52     {
53         c = a + b;
54         require(c >= a, "SafeMath add failed");
55         return c;
56     }
57 
58     /**
59      * @dev gives square root of given x.
60      */
61     function sqrt(uint256 x)
62     internal
63     pure
64     returns (uint256 y)
65     {
66         uint256 z = ((add(x,1)) / 2);
67         y = x;
68         while (z < y)
69         {
70             y = z;
71             z = ((add((x / z),z)) / 2);
72         }
73     }
74 
75     /**
76      * @dev gives square. multiplies x by x
77      */
78     function sq(uint256 x)
79     internal
80     pure
81     returns (uint256)
82     {
83         return (mul(x,x));
84     }
85 
86     /**
87      * @dev x to the power of y
88      */
89     function pwr(uint256 x, uint256 y)
90     internal
91     pure
92     returns (uint256)
93     {
94         if (x==0)
95             return (0);
96         else if (y==0)
97             return (1);
98         else
99         {
100             uint256 z = x;
101             for (uint256 i=1; i < y; i++)
102                 z = mul(z,x);
103             return (z);
104         }
105     }
106 }
107 
108 
109 
110 //==============================================================================
111 //   __|_ _    __|_ _  .
112 //  _\ | | |_|(_ | _\  .
113 //==============================================================================
114 library F3Ddatasets {
115     struct Referee {
116         uint256 pID;
117         uint256 offer;
118     }
119 
120     struct EventReturns {
121         address winnerBigPotAddr;         // winner address
122         uint256 amountWonBigPot;          // amount won
123 
124         address winnerSmallPotAddr;         // winner address
125         uint256 amountWonSmallPot;          // amount won
126 
127         uint256 newPot;             // amount in new pot
128         uint256 P3DAmount;          // amount distributed to p3d
129         uint256 genAmount;          // amount distributed to key money sharer
130         uint256 potAmount;          // amount added to pot
131     }
132 
133     struct PlayerVault {
134         address addr;   // player address
135         uint256 winBigPot;    // winnings vault
136         uint256 winSmallPot;    // winnings vault
137         uint256 gen;    // general vault
138         uint256 aff;    // affiliate vault
139         uint256 lrnd;
140     }
141 
142     struct PlayerRound {
143         uint256 eth;    // eth player has added to round (used for eth limiter)
144         uint256 auc;    // auction phase investment
145         uint256 keys;   // keys
146         uint256 affKeys;   // keys
147         uint256 mask;   // player mask
148         uint256 refID;  // referal right ID -- 推荐权利 ID
149     }
150 
151     struct SmallPot {
152         uint256 plyr;   // pID of player in lead for Small pot
153         uint256 end;    // time ends/ended
154         uint256 strt;   // time round started
155         uint256 pot;     // eth to pot (during round) / final amount paid to winner (after round ends)
156         uint256 keys;   // keys
157         uint256 eth;   // total eth
158         bool on;     // has round end function been ran
159     }
160 
161     struct BigPot {
162         uint256 plyr;   // pID of player in lead for Big pot
163         uint256 end;    // time ends/ended
164         uint256 strt;   // time round started
165         uint256 keys;   // keys
166         uint256 eth;    // total eth in
167         uint256 gen;
168         uint256 mask;
169         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
170         bool ended;     // has round end function been ran
171     }
172 
173 
174     struct Auction {
175         // auction phase
176         bool isAuction; // true: auction; false: bigPot
177         uint256 end;    // time ends/ended
178         uint256 strt;   // time round started
179         uint256 eth;    // total eth sent in during AUC phase
180         uint256 gen; // total eth for gen during AUC phase
181         uint256 keys;   // keys
182         // uint256 eth;    // total eth in
183         // uint256 mask;   // global mask
184     }
185 }
186 
187 //==============================================================================
188 //  |  _      _ _ | _  .
189 //  |<(/_\/  (_(_||(_  .
190 //=======/======================================================================
191 library F3DKeysCalcShort {
192     using SafeMath for *;
193     /**
194      * @dev calculates number of keys received given X eth
195      * @param _curEth current amount of eth in contract
196      * @param _newEth eth being spent
197      * @return amount of ticket purchased
198      */
199     function keysRec(uint256 _curEth, uint256 _newEth)
200     internal
201     pure
202     returns (uint256)
203     {
204         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
205     }
206 
207     /**
208      * @dev calculates amount of eth received if you sold X keys
209      * @param _curKeys current amount of keys that exist
210      * @param _sellKeys amount of keys you wish to sell
211      * @return amount of eth received
212      */
213     function ethRec(uint256 _curKeys, uint256 _sellKeys)
214     internal
215     pure
216     returns (uint256)
217     {
218         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
219     }
220 
221     /**
222      * @dev calculates how many keys would exist with given an amount of eth
223      * @param _eth eth "in contract"
224      * @return number of keys that would exist
225      */
226     function keys(uint256 _eth)
227     internal
228     pure
229     returns(uint256)
230     {
231         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
232     }
233 
234     /**
235      * @dev calculates how much eth would be in contract given a number of keys
236      * @param _keys number of keys "in contract"
237      * @return eth that would exists
238      */
239     function eth(uint256 _keys)
240     internal
241     pure
242     returns(uint256)
243     {
244         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
245     }
246 }
247 
248 //==============================================================================
249 //  . _ _|_ _  _ |` _  _ _  _  .
250 //  || | | (/_| ~|~(_|(_(/__\  .
251 //==============================================================================
252 
253 
254 
255 interface PlayerBookInterface {
256     function getPlayerID(address _addr) external returns (uint256);
257     function getPlayerName(uint256 _pID) external view returns (bytes32);
258     function getPlayerLAff(uint256 _pID) external view returns (uint256);
259     function getPlayerAddr(uint256 _pID) external view returns (address);
260     function getNameFee() external view returns (uint256);
261     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
262     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
263     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
264 }
265 
266 
267 
268 contract F3Devents {
269     event eventAuction(
270         string funName,
271         uint256 round,
272         uint256 plyr,
273         uint256 money,
274         uint256 keyPrice,
275         uint256 plyrEth,
276         uint256 plyrAuc,
277         uint256 plyrKeys,
278         uint256 aucEth,
279         uint256 aucKeys
280     );
281 
282     event onPot(
283         uint256 plyrBP, // pID of player in lead for Big pot
284         uint256 ethBP,
285         uint256 plyrSP, // pID of player in lead for Small pot
286         uint256 ethSP   // eth to pot (during round) / final amount paid to winner (after round ends)
287     );
288 
289 }
290 
291 
292 contract FoMo3DFast is F3Devents {
293     using SafeMath for *;
294     //    using F3DKeysCalcShort for uint256;
295     //
296     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xF2940f868fcD1Fbe8D1E1c02d2eaF68d8D7Db338);
297 
298     address private admin = msg.sender;
299     // uint256 constant private rndInit_ = 88 minutes;                // round timer starts at this
300     uint256 constant private rndInc_ = 60 seconds;              // every full key purchased adds this much to the timer
301     uint256 constant private smallTime_ = 5 minutes;              // small time
302     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
303     uint256 public rID_;    // round id number / total rounds that have happened
304     uint256 constant public keyPricePot_ = 10000000000000000; // 0.1eth
305     //****************
306     // PLAYER DATA
307     //****************
308     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
309     mapping(uint256 => F3Ddatasets.PlayerVault) public plyr_;   // (pID => data) player data
310     // (pID => rID => data) player round data by player id & round id
311     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRound)) public plyrRnds_;
312     //****************
313     // ROUND DATA
314     //****************
315     mapping(uint256 => F3Ddatasets.Auction) public auction_;   // (rID => data) round data
316     mapping(uint256 => F3Ddatasets.BigPot) public bigPot_;   // (rID => data) round data
317     F3Ddatasets.SmallPot public smallPot_;   // (rID => data) round data
318     mapping(uint256 => uint256) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
319     uint256 private keyMax_ = 0;
320     address private keyMaxAddress_ = address(0);
321     uint256 private affKeyMax_ = 0;
322     uint256 private affKeyMaxPlayId_ = 0;
323 
324     constructor()
325     public
326     {
327 
328     }
329     //==============================================================================
330     //     _ _  _  _|. |`. _  _ _  .
331     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
332     //==============================================================================
333     /**
334     * @dev used to make sure no one can interact with contract until it has
335     * been activated.
336     */
337     modifier isActivated() {
338         require(activated_ == true, "its not ready yet.  check ?eta in discord");
339         _;
340     }
341 
342     /**
343     * @dev prevents contracts from interacting with fomo3d
344     */
345     modifier isHuman() {
346         address _addr = msg.sender;
347         uint256 _codeLength;
348 
349         assembly {_codeLength := extcodesize(_addr)}
350         require(_codeLength == 0, "sorry humans only");
351         _;
352     }
353 
354     /**
355     * @dev sets boundaries for incoming tx
356     */
357     modifier isWithinLimits(uint256 _eth) {
358         require(_eth >= 1000000000, "pocket lint: not a valid currency");
359         _;
360     }
361 
362 
363     function determinePID(address senderAddr)
364     private
365     {
366         uint256 _pID = pIDxAddr_[senderAddr];
367         if (_pID == 0)
368         {
369             _pID = PlayerBook.getPlayerID(senderAddr);
370             pIDxAddr_[senderAddr] = _pID;
371             plyr_[_pID].addr = senderAddr;
372 
373         }
374     }
375 
376 
377     //==============================================================================
378     //     _    |_ |. _   |`    _  __|_. _  _  _  .
379     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
380     //====|=========================================================================
381     /**
382     * @dev emergency buy uses last stored affiliate ID and team snek
383     */
384     function()
385     isActivated()
386     isHuman()
387     isWithinLimits(msg.value)
388     external
389     payable
390     {
391         // get/set pID for current player
392         determinePID(msg.sender);
393 
394         // fetch player id
395         uint256 _pID = pIDxAddr_[msg.sender];
396         uint256 _now = now;
397         uint256 _rID = rID_;
398 
399         if (_now > bigPot_[_rID].strt && _now < bigPot_[_rID].end) {
400             // Round(big pot) phase
401             buy(_pID, 0);
402         } else {
403             // check to see if end round needs to be ran
404             if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false)
405             {
406                 // end the round (distributes pot) & start new round
407                 bigPot_[_rID].ended = true;
408                 endRound();
409             }
410 
411             // put eth in players vault
412             plyr_[_pID].gen = msg.value.add(plyr_[_pID].gen);
413         }
414     }
415 
416     function buyXQR(address senderAddr, uint256 _affID)
417     isActivated()
418     isWithinLimits(msg.value)
419     public
420     payable
421     {
422         // get/set pID for current player
423         determinePID(senderAddr);
424 
425         // fetch player id
426         uint256 _pID = pIDxAddr_[senderAddr];
427         uint256 _now = now;
428         uint256 _rID = rID_;
429 
430 
431         if (_affID == _pID)
432         {
433             _affID = 0;
434 
435         }
436 
437         if (_now > bigPot_[_rID].strt && _now < bigPot_[_rID].end) {
438             // Round(big pot) phase
439             buy(_pID, _affID);
440         } else {
441             // check to see if end round needs to be ran
442             if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false)
443             {
444                 // end the round (distributes pot) & start new round
445                 bigPot_[_rID].ended = true;
446                 endRound();
447             }
448 
449             // put eth in players vault
450             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
451         }
452     }
453 
454     function endRound()
455     private
456     {
457         // setup local rID
458         uint256 _rID = rID_;
459         address _winAddress = keyMaxAddress_;
460         // grab our winning player and team id's
461 
462         uint256 _winPID = pIDxAddr_[_winAddress];
463 
464         // grab our pot amount
465         uint256 _win = bigPot_[_rID].pot;
466         // 10000000000000000000 10个ether
467 
468         // pay our winner bigPot
469         plyr_[_winPID].winBigPot = _win.add(plyr_[_winPID].winBigPot);
470 
471         // pay smallPot
472         smallPot_.keys = 0;
473         smallPot_.eth = 0;
474         smallPot_.pot = 0;
475         smallPot_.plyr = 0;
476 
477         if (smallPot_.on == true) {
478             uint256 _currentPot = smallPot_.eth;
479             uint256 _winSmallPot = smallPot_.pot;
480             uint256 _surplus = _currentPot.sub(_winSmallPot);
481             smallPot_.on = false;
482             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
483             if (_surplus > 0) {
484                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
485             }
486         } else {
487             uint256 _currentPot1 = smallPot_.pot;
488             if (_currentPot1 > 0) {
489                 plyr_[1].winSmallPot = _currentPot1.add(plyr_[1].winSmallPot);
490             }
491         }
492 
493 
494         // start next round
495         rID_++;
496         _rID++;
497         uint256 _now = now;
498 
499         bigPot_[_rID].strt = _now;
500         bigPot_[_rID].end = _now + rndMax_;
501         keyMax_ = 0;
502         keyMaxAddress_ = address(0);
503         affKeyMax_ = 0;
504         affKeyMaxPlayId_ = 0;
505     }
506 
507 
508     function withdrawXQR(address _realSender)
509     isActivated()
510     public
511     {
512         // setup local rID
513         uint256 _rID = rID_;
514 
515         // grab time
516         uint256 _now = now;
517 
518         // fetch player ID
519         uint256 _pID = pIDxAddr_[_realSender];
520 
521         // setup temp var for player eth
522         uint256 _eth;
523 
524         // check to see if round has ended and no one has run round end yet
525         if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false && bigPot_[_rID].plyr != 0)
526         {
527             // end the round (distributes pot)
528             bigPot_[_rID].ended = true;
529             endRound();
530 
531             // get their earnings
532             _eth = withdrawEarnings(_pID);
533 
534             // gib moni
535             if (_eth > 0)
536                 plyr_[_pID].addr.transfer(_eth);
537 
538             // in any other situation
539         } else {
540             // get their earnings
541             _eth = withdrawEarnings(_pID);
542 
543             // gib moni
544             if (_eth > 0)
545                 plyr_[_pID].addr.transfer(_eth);
546 
547         }
548     }
549 
550     function withdrawEarnings(uint256 _pID)
551     private
552     returns (uint256)
553     {
554         updateGenVault(_pID, plyr_[_pID].lrnd);
555         // from vaults
556         uint256 _earnings = (plyr_[_pID].winBigPot).add(plyr_[_pID].winSmallPot).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
557         if (_earnings > 0)
558         {
559             plyr_[_pID].winBigPot = 0;
560             plyr_[_pID].winSmallPot = 0;
561             plyr_[_pID].gen = 0;
562             plyr_[_pID].aff = 0;
563         }
564         return (_earnings);
565     }
566 
567     function updateGenVault(uint256 _pID, uint256 _rIDlast)
568     private
569     {
570         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
571         if (_earnings > 0)
572         {
573             // put in gen vault
574             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
575             // zero out their earnings by updating mask
576             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
577         }
578     }
579 
580     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
581     private
582     view
583     returns (uint256)
584     {
585         return ((((bigPot_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
586     }
587 
588     function managePlayer(uint256 _pID)
589     private
590     {
591         // if player has played a previous round, move their unmasked earnings
592         // from that round to gen vault.
593         if (plyr_[_pID].lrnd != 0)
594             updateGenVault(_pID, plyr_[_pID].lrnd);
595 
596         // update player's last round played
597         plyr_[_pID].lrnd = rID_;
598     }
599 
600 
601     function buy(uint256 _pID, uint256 _affID)
602     private
603     {
604         // setup local rID
605         uint256 _rID = rID_;
606         uint256 _keyPrice = keyPricePot_;
607 
608         if (plyrRnds_[_pID][_rID].keys == 0)
609             managePlayer(_pID);
610 
611         uint256 _eth = msg.value;
612 
613         uint256 _keys = _eth / _keyPrice;
614 
615         if (_eth > 1000000000)
616         {
617             // if they bought at least 1 whole key
618             if (_keys >= 1)
619             {
620                 updateTimer(_keys, _rID);
621                 // set new leaders
622                 if (bigPot_[_rID].plyr != _pID)
623                     bigPot_[_rID].plyr = _pID;
624             }
625 
626 
627             // update round
628             bigPot_[_rID].keys = _keys.add(bigPot_[_rID].keys);
629             bigPot_[_rID].eth = _eth.add(bigPot_[_rID].eth);
630 
631             smallPot_.keys = _keys.add(smallPot_.keys);
632 
633             // update player
634             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
635             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
636 
637             if (_affID != 0) {
638                 plyrRnds_[_affID][_rID].affKeys = _keys.add(plyrRnds_[_affID][_rID].affKeys);
639             }
640 
641             // update key max address
642             if (plyrRnds_[_pID][_rID].keys > keyMax_) {
643                 keyMax_ = plyrRnds_[_pID][_rID].keys;
644                 keyMaxAddress_ = plyr_[_pID].addr;
645             }
646 
647             // update key max address
648             if (plyrRnds_[_affID][_rID].affKeys > affKeyMax_) {
649                 affKeyMax_ = plyrRnds_[_affID][_rID].affKeys;
650                 affKeyMaxPlayId_ = pIDxAddr_[plyr_[_affID].addr];
651             }
652 
653 
654             // key sharing earnings
655             uint256 _gen = _eth.mul(5) / 10;
656             updateMasks(_rID, _pID, _gen, _keys);
657 
658             distributeBuy(_rID, _eth, _affID);
659             smallPot();
660         }
661     }
662 
663     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
664     private
665     returns (uint256)
666     {
667         // calc profit per key & round mask based on this buy:  (dust goes to pot)
668         uint256 _ppt = (_gen.mul(1000000000000000000)) / (bigPot_[_rID].keys);
669         bigPot_[_rID].mask = _ppt.add(bigPot_[_rID].mask);
670 
671         // calculate player earning from their own buy (only based on the keys
672         // they just bought).  & update player earnings mask
673         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
674         plyrRnds_[_pID][_rID].mask = (((bigPot_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
675 
676         // calculate & return dust
677         return (_gen.sub((_ppt.mul(bigPot_[_rID].keys)) / (1000000000000000000)));
678     }
679 
680     function distributeBuy(uint256 _rID, uint256 _eth, uint256 _affID)
681     private
682     {
683         // pay 10% out to team
684         uint256 _team = _eth.mul(15) / 2 / 100;
685         uint256 _team1 = _team;
686         // 10% to aff
687         uint256 _aff = _eth.mul(10) / 100;
688 
689         uint256 _ethMaxAff = _eth.mul(5) / 100;
690 
691         if (_affID == 0) {
692             _team = _team.add(_aff);
693             _aff = 0;
694         }
695         if (affKeyMaxPlayId_ == 0) {
696             _team = _team.add(_ethMaxAff);
697             _ethMaxAff = 0;
698         }
699         // 10% to big Pot
700         uint256 _bigPot = _eth / 10;
701         // 10% to small Pot
702         uint256 _smallPot = _eth / 10;
703 
704         // pay out team
705         plyr_[1].aff = _team.add(plyr_[1].aff);
706         plyr_[2].aff = _team1.add(plyr_[2].aff);
707 
708         if (_ethMaxAff != 0) {
709             plyr_[affKeyMaxPlayId_].aff = _ethMaxAff.add(plyr_[affKeyMaxPlayId_].aff);
710         }
711         if (_aff != 0) {
712             // 通过 affID 得到 推荐玩家pID， 并将_aff驾到 pID玩家的 aff中
713             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
714         }
715 
716         // move money to Pot
717         bigPot_[_rID].pot = bigPot_[_rID].pot.add(_bigPot);
718         smallPot_.pot = smallPot_.pot.add(_smallPot);
719     }
720 
721     function smallPot()
722     private
723     {
724         uint256 _now = now;
725 
726         if (smallPot_.on == false && smallPot_.keys >= (1000)) {
727             smallPot_.on = true;
728             smallPot_.eth = smallPot_.pot;
729             smallPot_.strt = _now;
730             smallPot_.end = _now + smallTime_;
731         } else if (smallPot_.on == true && _now > smallPot_.end) {
732             uint256 _winSmallPot = smallPot_.eth;
733             uint256 _currentPot = smallPot_.pot;
734             uint256 _surplus = _currentPot.sub(_winSmallPot);
735             uint256 _winPID = pIDxAddr_[keyMaxAddress_];
736             smallPot_.on = false;
737             smallPot_.keys = 0;
738             smallPot_.eth = 0;
739             smallPot_.pot = 0;
740             smallPot_.plyr = 0;
741             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
742             if (_surplus > 0) {
743                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
744             }
745         }
746     }
747 
748 
749     function updateTimer(uint256 _keys, uint256 _rID)
750     private
751     {
752 
753         // grab time
754         uint256 _now = now;
755 
756         // calculate time based on number of keys bought
757         uint256 _newTime;
758         if (_now > bigPot_[_rID].end && bigPot_[_rID].plyr == 0)
759             _newTime = ((_keys).mul(rndInc_)).add(_now);
760         else
761             _newTime = ((_keys).mul(rndInc_)).add(bigPot_[_rID].end);
762 
763         // compare to max and set new end time
764         if (_newTime < (rndMax_).add(_now))
765             bigPot_[_rID].end = _newTime;
766         else
767             bigPot_[_rID].end = rndMax_.add(_now);
768 
769     }
770 
771     function getPlayerIdxAddr(address _addr) public view returns (uint256){
772         if (pIDxAddr_[_addr] == 0) {
773             return pIDxAddr_[_addr];
774         } else {
775             return 0;
776         }
777     }
778 
779 
780     function receivePlayerInfo(uint256 _pID, address _addr)
781     external
782     {
783         require(msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
784         if (pIDxAddr_[_addr] != _pID)
785             pIDxAddr_[_addr] = _pID;
786         if (plyr_[_pID].addr != _addr)
787             plyr_[_pID].addr = _addr;
788     }
789 
790 
791     //==============================================================================
792     //     _  _ _|__|_ _  _ _  .
793     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
794     //=====_|=======================================================================
795     /**
796     * @dev return the price buyer will pay for next 1 individual key.
797     * -functionhash- 0x018a25e8
798     * @return price for next key bought (in wei format)
799     */
800     // function getBuyPrice()
801     // public
802     // view
803     // returns (uint256)
804     // {
805     //     if (now < round_[rID_].start) {
806     //         // 当前轮游戏开始前
807     //         return 5;
808     //     } else if (now > round_[rID_].start && now < rndTmEth_[rID_]) {
809     //         // 当前轮游戏进行中
810     //         return 10;
811     //     } else if (now > rndTmEth_[rID_]) {
812     //         // 当前轮游戏已结束
813     //         return 5;
814     //     }
815     // }
816 
817     function getTimeLeft() public
818     view returns (uint256){
819         return rndTmEth_[rID_] - now;
820     }
821 
822     function getrID() public
823     view returns (uint256){
824         return rID_;
825     }
826 
827     function getAdmin() public
828     view returns (address){
829         return admin;
830     }
831 
832     //==============================================================================
833     //    (~ _  _    _._|_    .
834     //    _)(/_(_|_|| | | \/  .
835     //====================/=========================================================
836     /** upon contract deploy, it will be deactivated.  this is a one time
837      * use function that will activate the contract.  we do this so devs
838      * have time to set things up on the web end                            **/
839     bool public activated_ = false;
840     uint256  public end_ = 0;
841 
842     function activate()
843     public
844     {
845         // only team just can activate
846         require(msg.sender == admin, "only admin can activate");
847         // can only be ran once
848         require(activated_ == false, "FOMO Short already activated");
849 
850         // activate the contract
851         activated_ = true;
852 
853         // lets start first round
854         rID_ = 1;
855         uint256 _now = now;
856 
857         bigPot_[1].strt = _now;
858         bigPot_[1].end = _now + rndMax_;
859     }
860 
861     function getAuctionTimer()
862     public
863     view
864     returns (uint256, uint256, uint256, uint256, bool, uint256, uint256)
865     {
866         // setup local rID
867         uint256 _rID = rID_;
868         uint256 _now = now;
869         return
870         (
871         _rID, //1
872         auction_[_rID].strt,
873         auction_[_rID].end,
874         _now,
875         _now > auction_[_rID].end,
876         bigPot_[_rID].strt,
877         bigPot_[_rID].end            //2
878         );
879     }
880 
881 
882     // ================== 页面数据方法 start ======================
883 
884     // 获取当前轮BigPot数据
885     function getCurrentRoundBigPotInfo()
886     public
887     view
888     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
889     {
890         // setup local rID
891         uint256 _rID = rID_;
892         uint256 _now = now;
893         uint256 _currentpID = pIDxAddr_[keyMaxAddress_];
894         uint256 _eth = bigPot_[_rID].eth;
895         return
896         (
897         _rID, // round index
898         // bitPot data
899         _currentpID, // pID of player in lead for Big pot
900         bigPot_[_rID].ended, // has round end function been ran
901         bigPot_[_rID].strt, // time round started
902         bigPot_[_rID].end, // time ends/ended
903         bigPot_[_rID].end - _now,
904         bigPot_[_rID].keys, // keys
905         _eth, // total eth in
906         bigPot_[_rID].pot, // eth to pot (during round) / final amount paid to winner (after round ends)
907         keyMaxAddress_, // current lead address
908         keyMax_,
909         affKeyMax_
910         );
911     }
912 
913     // 获取当前轮SmallPot数据
914     function getSmallPotInfo()
915     public
916     view
917     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, address)
918     {
919         // setup local rID
920         uint256 _rID = rID_;
921         uint256 _now = now;
922         uint256 _currentpID = pIDxAddr_[keyMaxAddress_];
923         return
924         (
925         _rID, // round index
926         // smallPot data
927         _currentpID,
928         smallPot_.on,
929         smallPot_.strt,
930         smallPot_.end,
931         smallPot_.end - _now,
932         smallPot_.keys,
933         smallPot_.eth,
934         smallPot_.pot,
935         keyMaxAddress_ // current lead address
936         );
937     }
938 
939     // 获取当前轮数据
940     function getPlayerInfoxAddr()
941     public
942     view
943     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
944     {
945         // setup local rID
946         uint256 _rID = rID_;
947         uint256 _pID = pIDxAddr_[msg.sender];
948         return
949         (_rID, //1
950         _pID, //1
951         plyrRnds_[_pID][_rID].eth,
952         plyrRnds_[_pID][_rID].auc,
953         plyrRnds_[_pID][_rID].keys,
954         plyrRnds_[_pID][_rID].mask, //2
955         plyrRnds_[_pID][_rID].refID //2
956         );
957     }
958 
959     // 获取用户钱包信息
960     function getPlayerVaultxAddr()
961     public
962     view
963     returns (uint256, address, uint256, uint256, uint256, uint256)
964     {
965         // setup local rID
966         address addr = msg.sender;
967         uint256 _pID = pIDxAddr_[addr];
968         return
969         (
970         _pID, //1
971         plyr_[_pID].addr,
972         plyr_[_pID].winBigPot,
973         plyr_[_pID].winSmallPot,
974         plyr_[_pID].gen,
975         plyr_[_pID].aff
976         );
977     }
978 
979     function getPlayerVaults(uint256 _pID)
980     public
981     view
982     returns (uint256, uint256, uint256, uint256)
983     {
984         // setup local rID
985         uint256 _rID = rID_;
986 
987         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
988         if (now > bigPot_[_rID].end && bigPot_[_rID].ended == false && keyMaxAddress_ != address(0))
989         {
990             // if player is winner
991             if (pIDxAddr_[keyMaxAddress_] == _pID)
992             {
993                 return
994                 (
995                 plyr_[_pID].winBigPot.add(bigPot_[_rID].pot),
996                 plyr_[_pID].winSmallPot,
997                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
998                 plyr_[_pID].aff
999                 );
1000 
1001                 // if player is not the winner
1002             } else {
1003                 return
1004                 (
1005                 plyr_[_pID].winBigPot,
1006                 plyr_[_pID].winSmallPot,
1007                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1008                 plyr_[_pID].aff
1009                 );
1010             }
1011 
1012             // if round is still going on, or round has ended and round end has been ran
1013         } else {
1014             return
1015             (
1016             plyr_[_pID].winBigPot,
1017             plyr_[_pID].winSmallPot,
1018             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1019             plyr_[_pID].aff
1020             );
1021         }
1022     }
1023 
1024     // ================== 页面数据方法 end ======================
1025 
1026 
1027 
1028     function getPlayerInfoByAddress(address addr)
1029     public
1030     view
1031     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1032     {
1033         // setup local rID
1034         uint256 _rID = rID_;
1035         address _addr = addr;
1036 
1037         if (_addr == address(0))
1038         {
1039             _addr == msg.sender;
1040         }
1041         uint256 _pID = pIDxAddr_[_addr];
1042         return
1043         (
1044         _pID, //0
1045         _addr, //1
1046         _rID, //2
1047         plyr_[_pID].winBigPot, //3
1048         plyr_[_pID].winSmallPot, //4
1049         plyr_[_pID].gen, //5
1050         plyr_[_pID].aff, //6
1051         plyrRnds_[_pID][_rID].keys, //7
1052         plyrRnds_[_pID][_rID].eth, //
1053         plyrRnds_[_pID][_rID].auc, //
1054         plyrRnds_[_pID][_rID].mask, //
1055         plyrRnds_[_pID][_rID].refID //
1056         );
1057     }
1058 
1059     function getPlayerInfoById(uint256 pID)
1060     public
1061     view
1062     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1063     {
1064         // setup local rID
1065         uint256 _rID = rID_;
1066         uint256 _pID = pID;
1067         address _addr = msg.sender;
1068         return
1069         (
1070         _pID, //0
1071         _addr, //1
1072         _rID, //2
1073         plyr_[_pID].winBigPot, //3
1074         plyr_[_pID].winSmallPot, //4
1075         plyr_[_pID].gen, //5
1076         plyr_[_pID].aff, //6
1077         plyrRnds_[_pID][_rID].keys, //7
1078         plyrRnds_[_pID][_rID].eth, //
1079         plyrRnds_[_pID][_rID].auc, //
1080         plyrRnds_[_pID][_rID].mask, //
1081         plyrRnds_[_pID][_rID].refID //
1082         );
1083     }
1084 }