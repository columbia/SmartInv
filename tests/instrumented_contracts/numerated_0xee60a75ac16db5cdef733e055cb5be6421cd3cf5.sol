1 pragma solidity ^0.5.0;
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
134         address payable addr;   // player address
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
296     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xA5127434738A47c068c1BE84D314677A1c63a278);
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
363     function determinePID(address payable senderAddr)
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
416     function buyXQR(address payable senderAddr, uint256 _affID)
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
472         uint256 _currentPot = smallPot_.eth;
473         uint256 _winSmallPot = smallPot_.pot;
474         uint256 _surplus = _currentPot.sub(_winSmallPot);
475         smallPot_.keys = 0;
476         smallPot_.eth = 0;
477         smallPot_.pot = 0;
478         smallPot_.plyr = 0;
479         if (smallPot_.on == true) {
480             smallPot_.on = false;
481             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
482             if (_surplus > 0) {
483                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
484             }
485         } else {
486             if (_currentPot > 0) {
487                 plyr_[1].winSmallPot = _currentPot.add(plyr_[1].winSmallPot);
488             }
489         }
490 
491 
492         // start next round
493         rID_++;
494         _rID++;
495         uint256 _now = now;
496 
497         bigPot_[_rID].strt = _now;
498         bigPot_[_rID].end = _now + rndMax_;
499         keyMax_ = 0;
500         keyMaxAddress_ = address(0);
501         affKeyMax_ = 0;
502         affKeyMaxPlayId_ = 0;
503     }
504 
505 
506     function withdrawXQR(address _realSender)
507     isActivated()
508     public
509     {
510         // setup local rID
511         uint256 _rID = rID_;
512 
513         // grab time
514         uint256 _now = now;
515 
516         // fetch player ID
517         uint256 _pID = pIDxAddr_[_realSender];
518 
519         // setup temp var for player eth
520         uint256 _eth;
521 
522         // check to see if round has ended and no one has run round end yet
523         if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false && bigPot_[_rID].plyr != 0)
524         {
525             // end the round (distributes pot)
526             bigPot_[_rID].ended = true;
527             endRound();
528 
529             // get their earnings
530             _eth = withdrawEarnings(_pID);
531 
532             // gib moni
533             if (_eth > 0)
534                 plyr_[_pID].addr.transfer(_eth);
535 
536             // in any other situation
537         } else {
538             // get their earnings
539             _eth = withdrawEarnings(_pID);
540 
541             // gib moni
542             if (_eth > 0)
543                 plyr_[_pID].addr.transfer(_eth);
544 
545         }
546     }
547 
548     function withdrawEarnings(uint256 _pID)
549     private
550     returns (uint256)
551     {
552         updateGenVault(_pID, plyr_[_pID].lrnd);
553         // from vaults
554         uint256 _earnings = (plyr_[_pID].winBigPot).add(plyr_[_pID].winSmallPot).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
555         if (_earnings > 0)
556         {
557             plyr_[_pID].winBigPot = 0;
558             plyr_[_pID].winSmallPot = 0;
559             plyr_[_pID].gen = 0;
560             plyr_[_pID].aff = 0;
561         }
562         return (_earnings);
563     }
564 
565     function updateGenVault(uint256 _pID, uint256 _rIDlast)
566     private
567     {
568         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
569         if (_earnings > 0)
570         {
571             // put in gen vault
572             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
573             // zero out their earnings by updating mask
574             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
575         }
576     }
577 
578     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
579     private
580     view
581     returns (uint256)
582     {
583         return ((((bigPot_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
584     }
585 
586     function managePlayer(uint256 _pID)
587     private
588     {
589         // if player has played a previous round, move their unmasked earnings
590         // from that round to gen vault.
591         if (plyr_[_pID].lrnd != 0)
592             updateGenVault(_pID, plyr_[_pID].lrnd);
593 
594         // update player's last round played
595         plyr_[_pID].lrnd = rID_;
596     }
597 
598 
599     function buy(uint256 _pID, uint256 _affID)
600     private
601     {
602         // setup local rID
603         uint256 _rID = rID_;
604         uint256 _keyPrice = keyPricePot_;
605 
606         if (plyrRnds_[_pID][_rID].keys == 0)
607             managePlayer(_pID);
608 
609         uint256 _eth = msg.value;
610 
611         uint256 _keys = _eth / _keyPrice;
612 
613         if (_eth > 1000000000)
614         {
615             // if they bought at least 1 whole key
616             if (_keys >= 1)
617             {
618                 updateTimer(_keys, _rID);
619                 // set new leaders
620                 if (bigPot_[_rID].plyr != _pID)
621                     bigPot_[_rID].plyr = _pID;
622             }
623 
624 
625             // update round
626             bigPot_[_rID].keys = _keys.add(bigPot_[_rID].keys);
627             bigPot_[_rID].eth = _eth.add(bigPot_[_rID].eth);
628 
629             smallPot_.keys = _keys.add(smallPot_.keys);
630 
631             // update player
632             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
633             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
634 
635             if (_affID != 0) {
636                 plyrRnds_[_affID][_rID].affKeys = _keys.add(plyrRnds_[_affID][_rID].affKeys);
637             }
638 
639             // update key max address
640             if (plyrRnds_[_pID][_rID].keys > keyMax_) {
641                 keyMax_ = plyrRnds_[_pID][_rID].keys;
642                 keyMaxAddress_ = plyr_[_pID].addr;
643             }
644 
645             // update key max address
646             if (plyrRnds_[_affID][_rID].affKeys > affKeyMax_) {
647                 affKeyMax_ = plyrRnds_[_affID][_rID].affKeys;
648                 affKeyMaxPlayId_ = pIDxAddr_[plyr_[_affID].addr];
649             }
650 
651 
652             // key sharing earnings
653             uint256 _gen = _eth.mul(5) / 10;
654             updateMasks(_rID, _pID, _gen, _keys);
655 
656             distributeBuy(_rID, _eth, _affID);
657             smallPot();
658         }
659     }
660 
661     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
662     private
663     returns (uint256)
664     {
665         // calc profit per key & round mask based on this buy:  (dust goes to pot)
666         uint256 _ppt = (_gen.mul(1000000000000000000)) / (bigPot_[_rID].keys);
667         bigPot_[_rID].mask = _ppt.add(bigPot_[_rID].mask);
668 
669         // calculate player earning from their own buy (only based on the keys
670         // they just bought).  & update player earnings mask
671         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
672         plyrRnds_[_pID][_rID].mask = (((bigPot_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
673 
674         // calculate & return dust
675         return (_gen.sub((_ppt.mul(bigPot_[_rID].keys)) / (1000000000000000000)));
676     }
677 
678     function distributeBuy(uint256 _rID, uint256 _eth, uint256 _affID)
679     private
680     {
681         // pay 10% out to team
682         uint256 _team = _eth.mul(15) / 2 / 100;
683         uint256 _team1 = _team;
684         // 10% to aff
685         uint256 _aff = _eth.mul(10) / 100;
686 
687         uint256 _ethMaxAff = _eth.mul(5) / 100;
688 
689         if (_affID == 0) {
690             _team = _team.add(_aff);
691             _aff = 0;
692         }
693         if (affKeyMaxPlayId_ == 0) {
694             _team = _team.add(_ethMaxAff);
695             _ethMaxAff = 0;
696         }
697         // 10% to big Pot
698         uint256 _bigPot = _eth / 10;
699         // 10% to small Pot
700         uint256 _smallPot = _eth / 10;
701 
702         // pay out team
703         plyr_[1].aff = _team.add(plyr_[1].aff);
704         plyr_[2].aff = _team1.add(plyr_[2].aff);
705 
706         if (_ethMaxAff != 0) {
707             plyr_[affKeyMaxPlayId_].aff = _ethMaxAff.add(plyr_[affKeyMaxPlayId_].aff);
708         }
709         if (_aff != 0) {
710             // 通过 affID 得到 推荐玩家pID， 并将_aff驾到 pID玩家的 aff中
711             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
712         }
713 
714         // move money to Pot
715         bigPot_[_rID].pot = bigPot_[_rID].pot.add(_bigPot);
716         smallPot_.pot = smallPot_.pot.add(_smallPot);
717     }
718 
719     function smallPot()
720     private
721     {
722         uint256 _now = now;
723 
724         if (smallPot_.on == false && smallPot_.keys >= (1000)) {
725             smallPot_.on = true;
726             smallPot_.eth = smallPot_.pot;
727             smallPot_.strt = _now;
728             smallPot_.end = _now + smallTime_;
729         } else if (smallPot_.on == true && _now > smallPot_.end) {
730             uint256 _winSmallPot = smallPot_.eth;
731             uint256 _currentPot = smallPot_.pot;
732             uint256 _surplus = _currentPot.sub(_winSmallPot);
733             uint256 _winPID = pIDxAddr_[keyMaxAddress_];
734             smallPot_.on = false;
735             smallPot_.keys = 0;
736             smallPot_.eth = 0;
737             smallPot_.pot = 0;
738             smallPot_.plyr = 0;
739             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
740             if (_surplus > 0) {
741                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
742             }
743         }
744     }
745 
746 
747     function updateTimer(uint256 _keys, uint256 _rID)
748     private
749     {
750 
751         // grab time
752         uint256 _now = now;
753 
754         // calculate time based on number of keys bought
755         uint256 _newTime;
756         if (_now > bigPot_[_rID].end && bigPot_[_rID].plyr == 0)
757             _newTime = ((_keys).mul(rndInc_)).add(_now);
758         else
759             _newTime = ((_keys).mul(rndInc_)).add(bigPot_[_rID].end);
760 
761         // compare to max and set new end time
762         if (_newTime < (rndMax_).add(_now))
763             bigPot_[_rID].end = _newTime;
764         else
765             bigPot_[_rID].end = rndMax_.add(_now);
766 
767     }
768 
769     function getPlayerIdxAddr(address _addr) public view returns (uint256){
770         if (pIDxAddr_[_addr] == 0) {
771             return pIDxAddr_[_addr];
772         } else {
773             return 0;
774         }
775     }
776 
777 
778     function receivePlayerInfo(uint256 _pID, address payable _addr)
779     external
780     {
781         require(msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
782         if (pIDxAddr_[_addr] != _pID)
783             pIDxAddr_[_addr] = _pID;
784         if (plyr_[_pID].addr != _addr)
785             plyr_[_pID].addr = _addr;
786     }
787 
788 
789     //==============================================================================
790     //     _  _ _|__|_ _  _ _  .
791     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
792     //=====_|=======================================================================
793     /**
794     * @dev return the price buyer will pay for next 1 individual key.
795     * -functionhash- 0x018a25e8
796     * @return price for next key bought (in wei format)
797     */
798     // function getBuyPrice()
799     // public
800     // view
801     // returns (uint256)
802     // {
803     //     if (now < round_[rID_].start) {
804     //         // 当前轮游戏开始前
805     //         return 5;
806     //     } else if (now > round_[rID_].start && now < rndTmEth_[rID_]) {
807     //         // 当前轮游戏进行中
808     //         return 10;
809     //     } else if (now > rndTmEth_[rID_]) {
810     //         // 当前轮游戏已结束
811     //         return 5;
812     //     }
813     // }
814 
815     function getTimeLeft() public
816     view returns (uint256){
817         return rndTmEth_[rID_] - now;
818     }
819 
820     function getrID() public
821     view returns (uint256){
822         return rID_;
823     }
824 
825     function getAdmin() public
826     view returns (address){
827         return admin;
828     }
829 
830     //==============================================================================
831     //    (~ _  _    _._|_    .
832     //    _)(/_(_|_|| | | \/  .
833     //====================/=========================================================
834     /** upon contract deploy, it will be deactivated.  this is a one time
835      * use function that will activate the contract.  we do this so devs
836      * have time to set things up on the web end                            **/
837     bool public activated_ = false;
838     uint256  public end_ = 0;
839 
840     function activate()
841     public
842     {
843         // only team just can activate
844         require(msg.sender == admin, "only admin can activate");
845         // can only be ran once
846         require(activated_ == false, "FOMO Short already activated");
847 
848         // activate the contract
849         activated_ = true;
850 
851         // lets start first round
852         rID_ = 1;
853         uint256 _now = now;
854 
855         bigPot_[1].strt = _now;
856         bigPot_[1].end = _now + rndMax_;
857     }
858 
859     function getAuctionTimer()
860     public
861     view
862     returns (uint256, uint256, uint256, uint256, bool, uint256, uint256)
863     {
864         // setup local rID
865         uint256 _rID = rID_;
866         uint256 _now = now;
867         return
868         (
869         _rID, //1
870         auction_[_rID].strt,
871         auction_[_rID].end,
872         _now,
873         _now > auction_[_rID].end,
874         bigPot_[_rID].strt,
875         bigPot_[_rID].end            //2
876         );
877     }
878 
879 
880     // ================== 页面数据方法 start ======================
881 
882     // 获取当前轮BigPot数据
883     function getCurrentRoundBigPotInfo()
884     public
885     view
886     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
887     {
888         // setup local rID
889         uint256 _rID = rID_;
890         uint256 _now = now;
891         uint256 _currentpID = pIDxAddr_[keyMaxAddress_];
892         uint256 _eth = bigPot_[_rID].eth;
893         return
894         (
895         _rID, // round index
896         // bitPot data
897         _currentpID, // pID of player in lead for Big pot
898         bigPot_[_rID].ended, // has round end function been ran
899         bigPot_[_rID].strt, // time round started
900         bigPot_[_rID].end, // time ends/ended
901         bigPot_[_rID].end - _now,
902         bigPot_[_rID].keys, // keys
903         _eth, // total eth in
904         bigPot_[_rID].pot, // eth to pot (during round) / final amount paid to winner (after round ends)
905         keyMaxAddress_, // current lead address
906         keyMax_,
907         affKeyMax_
908         );
909     }
910 
911     // 获取当前轮SmallPot数据
912     function getSmallPotInfo()
913     public
914     view
915     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, address)
916     {
917         // setup local rID
918         uint256 _rID = rID_;
919         uint256 _now = now;
920         uint256 _currentpID = pIDxAddr_[keyMaxAddress_];
921         return
922         (
923         _rID, // round index
924         // smallPot data
925         _currentpID,
926         smallPot_.on,
927         smallPot_.strt,
928         smallPot_.end,
929         smallPot_.end - _now,
930         smallPot_.keys,
931         smallPot_.eth,
932         smallPot_.pot,
933         keyMaxAddress_ // current lead address
934         );
935     }
936 
937     // 获取当前轮数据
938     function getPlayerInfoxAddr()
939     public
940     view
941     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
942     {
943         // setup local rID
944         uint256 _rID = rID_;
945         uint256 _pID = pIDxAddr_[msg.sender];
946         return
947         (_rID, //1
948         _pID, //1
949         plyrRnds_[_pID][_rID].eth,
950         plyrRnds_[_pID][_rID].auc,
951         plyrRnds_[_pID][_rID].keys,
952         plyrRnds_[_pID][_rID].mask, //2
953         plyrRnds_[_pID][_rID].refID //2
954         );
955     }
956 
957     // 获取用户钱包信息
958     function getPlayerVaultxAddr()
959     public
960     view
961     returns (uint256, address, uint256, uint256, uint256, uint256)
962     {
963         // setup local rID
964         address addr = msg.sender;
965         uint256 _pID = pIDxAddr_[addr];
966         return
967         (
968         _pID, //1
969         plyr_[_pID].addr,
970         plyr_[_pID].winBigPot,
971         plyr_[_pID].winSmallPot,
972         plyr_[_pID].gen,
973         plyr_[_pID].aff
974         );
975     }
976 
977     function getPlayerVaults(uint256 _pID)
978     public
979     view
980     returns (uint256, uint256, uint256, uint256)
981     {
982         // setup local rID
983         uint256 _rID = rID_;
984 
985         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
986         if (now > bigPot_[_rID].end && bigPot_[_rID].ended == false && keyMaxAddress_ != address(0))
987         {
988             // if player is winner
989             if (pIDxAddr_[keyMaxAddress_] == _pID)
990             {
991                 return
992                 (
993                 plyr_[_pID].winBigPot.add(bigPot_[_rID].pot),
994                 plyr_[_pID].winSmallPot,
995                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
996                 plyr_[_pID].aff
997                 );
998 
999                 // if player is not the winner
1000             } else {
1001                 return
1002                 (
1003                 plyr_[_pID].winBigPot,
1004                 plyr_[_pID].winSmallPot,
1005                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1006                 plyr_[_pID].aff
1007                 );
1008             }
1009 
1010             // if round is still going on, or round has ended and round end has been ran
1011         } else {
1012             return
1013             (
1014             plyr_[_pID].winBigPot,
1015             plyr_[_pID].winSmallPot,
1016             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1017             plyr_[_pID].aff
1018             );
1019         }
1020     }
1021 
1022     // ================== 页面数据方法 end ======================
1023 
1024 
1025 
1026     function getPlayerInfoByAddress(address addr)
1027     public
1028     view
1029     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1030     {
1031         // setup local rID
1032         uint256 _rID = rID_;
1033         address _addr = addr;
1034 
1035         if (_addr == address(0))
1036         {
1037             _addr == msg.sender;
1038         }
1039         uint256 _pID = pIDxAddr_[_addr];
1040         return
1041         (
1042         _pID, //0
1043         _addr, //1
1044         _rID, //2
1045         plyr_[_pID].winBigPot, //3
1046         plyr_[_pID].winSmallPot, //4
1047         plyr_[_pID].gen, //5
1048         plyr_[_pID].aff, //6
1049         plyrRnds_[_pID][_rID].keys, //7
1050         plyrRnds_[_pID][_rID].eth, //
1051         plyrRnds_[_pID][_rID].auc, //
1052         plyrRnds_[_pID][_rID].mask, //
1053         plyrRnds_[_pID][_rID].refID //
1054         );
1055     }
1056 
1057     function getPlayerInfoById(uint256 pID)
1058     public
1059     view
1060     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1061     {
1062         // setup local rID
1063         uint256 _rID = rID_;
1064         uint256 _pID = pID;
1065         address _addr = msg.sender;
1066         return
1067         (
1068         _pID, //0
1069         _addr, //1
1070         _rID, //2
1071         plyr_[_pID].winBigPot, //3
1072         plyr_[_pID].winSmallPot, //4
1073         plyr_[_pID].gen, //5
1074         plyr_[_pID].aff, //6
1075         plyrRnds_[_pID][_rID].keys, //7
1076         plyrRnds_[_pID][_rID].eth, //
1077         plyrRnds_[_pID][_rID].auc, //
1078         plyrRnds_[_pID][_rID].mask, //
1079         plyrRnds_[_pID][_rID].refID //
1080         );
1081     }
1082 }