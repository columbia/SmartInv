1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath v0.1.9
6  * @dev Math operations with safety checks that throw on error
7  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
8  * - added sqrt
9  * - added sq
10  * - added pwr
11  * - changed asserts to requires with error log outputs
12  * - removed div, its useless
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b)
20         internal
21         pure
22         returns (uint256 c)
23     {
24         if (a == 0) {
25             return 0;
26         }
27         c = a * b;
28         require(c / a == b, "SafeMath mul failed");
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b)
36         internal
37         pure
38         returns (uint256)
39     {
40         require(b <= a, "SafeMath sub failed");
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b)
48         internal
49         pure
50         returns (uint256 c)
51     {
52         c = a + b;
53         require(c >= a, "SafeMath add failed");
54         return c;
55     }
56 
57     /**
58      * @dev gives square root of given x.
59      */
60     function sqrt(uint256 x)
61         internal
62         pure
63         returns (uint256 y)
64     {
65         uint256 z = ((add(x,1)) / 2);
66         y = x;
67         while (z < y)
68         {
69             y = z;
70             z = ((add((x / z),z)) / 2);
71         }
72     }
73 
74     /**
75      * @dev gives square. multiplies x by x
76      */
77     function sq(uint256 x)
78         internal
79         pure
80         returns (uint256)
81     {
82         return (mul(x,x));
83     }
84 
85     /**
86      * @dev x to the power of y
87      */
88     function pwr(uint256 x, uint256 y)
89         internal
90         pure
91         returns (uint256)
92     {
93         if (x==0)
94             return (0);
95         else if (y==0)
96             return (1);
97         else
98         {
99             uint256 z = x;
100             for (uint256 i=1; i < y; i++)
101                 z = mul(z,x);
102             return (z);
103         }
104     }
105 }
106 
107 
108 
109 //==============================================================================
110 //   __|_ _    __|_ _  .
111 //  _\ | | |_|(_ | _\  .
112 //==============================================================================
113 library F3Ddatasets {
114     struct Referee {
115         uint256 pID;
116         uint256 offer;
117     }
118     
119     struct EventReturns {
120         address winnerBigPotAddr;         // winner address
121         uint256 amountWonBigPot;          // amount won
122 
123         address winnerSmallPotAddr;         // winner address
124         uint256 amountWonSmallPot;          // amount won
125 
126         uint256 newPot;             // amount in new pot
127         uint256 P3DAmount;          // amount distributed to p3d
128         uint256 genAmount;          // amount distributed to key money sharer
129         uint256 potAmount;          // amount added to pot
130     }
131 
132     struct PlayerVault {
133         address addr;   // player address
134         uint256 winBigPot;    // winnings vault
135         uint256 winSmallPot;    // winnings vault
136         uint256 gen;    // general vault
137         uint256 aff;    // affiliate vault
138         uint256 lrnd;
139     }
140 
141     struct PlayerRound {
142         uint256 eth;    // eth player has added to round (used for eth limiter)
143         uint256 auc;    // auction phase investment
144         uint256 keys;   // keys
145         uint256 mask;   // player mask
146         uint256 refID;  // referal right ID -- 推荐权利 ID
147     }
148 
149     struct SmallPot {
150         uint256 plyr;   // pID of player in lead for Small pot
151         uint256 end;    // time ends/ended
152         uint256 strt;   // time round started
153         uint256 pot;     // eth to pot (during round) / final amount paid to winner (after round ends)
154         uint256 keys;   // keys
155         uint256 eth;   // total eth
156         bool on;     // has round end function been ran
157     }
158 
159     struct BigPot {
160         uint256 plyr;   // pID of player in lead for Big pot
161         uint256 end;    // time ends/ended
162         uint256 strt;   // time round started
163         uint256 keys;   // keys
164         uint256 eth;    // total eth in
165         uint256 gen;
166         uint256 mask;
167         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
168         bool ended;     // has round end function been ran
169     }
170 
171 
172     struct Auction {
173         // auction phase
174         bool isAuction; // true: auction; false: bigPot
175         uint256 end;    // time ends/ended
176         uint256 strt;   // time round started
177         uint256 eth;    // total eth sent in during AUC phase
178         uint256 gen; // total eth for gen during AUC phase
179         uint256 keys;   // keys
180         // uint256 eth;    // total eth in
181         // uint256 mask;   // global mask
182     }
183 }
184 
185 //==============================================================================
186 //  |  _      _ _ | _  .
187 //  |<(/_\/  (_(_||(_  .
188 //=======/======================================================================
189 library F3DKeysCalcShort {
190     using SafeMath for *;
191     /**
192      * @dev calculates number of keys received given X eth
193      * @param _curEth current amount of eth in contract
194      * @param _newEth eth being spent
195      * @return amount of ticket purchased
196      */
197     function keysRec(uint256 _curEth, uint256 _newEth)
198         internal
199         pure
200         returns (uint256)
201     {
202         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
203     }
204 
205     /**
206      * @dev calculates amount of eth received if you sold X keys
207      * @param _curKeys current amount of keys that exist
208      * @param _sellKeys amount of keys you wish to sell
209      * @return amount of eth received
210      */
211     function ethRec(uint256 _curKeys, uint256 _sellKeys)
212         internal
213         pure
214         returns (uint256)
215     {
216         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
217     }
218 
219     /**
220      * @dev calculates how many keys would exist with given an amount of eth
221      * @param _eth eth "in contract"
222      * @return number of keys that would exist
223      */
224     function keys(uint256 _eth)
225         internal
226         pure
227         returns(uint256)
228     {
229         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
230     }
231 
232     /**
233      * @dev calculates how much eth would be in contract given a number of keys
234      * @param _keys number of keys "in contract"
235      * @return eth that would exists
236      */
237     function eth(uint256 _keys)
238         internal
239         pure
240         returns(uint256)
241     {
242         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
243     }
244 }
245 
246 //==============================================================================
247 //  . _ _|_ _  _ |` _  _ _  _  .
248 //  || | | (/_| ~|~(_|(_(/__\  .
249 //==============================================================================
250 
251 
252 interface PlayerBookInterface {
253     function getPlayerID(address _addr) external returns (uint256);
254     function getPlayerAddr(uint256 _pID) external view returns (address);
255 }
256 
257 
258 
259 contract F3Devents {
260     event eventAuction(
261         string funName,
262         uint256 round,
263         uint256 plyr,
264         uint256 money,
265         uint256 keyPrice,
266         uint256 plyrEth,
267         uint256 plyrAuc,
268         uint256 plyrKeys,
269         uint256 aucEth,
270         uint256 aucKeys
271     );
272 
273     event onPot(
274         uint256 plyrBP, // pID of player in lead for Big pot
275         uint256 ethBP,
276         uint256 plyrSP, // pID of player in lead for Small pot
277         uint256 ethSP   // eth to pot (during round) / final amount paid to winner (after round ends)
278     );
279 
280 }
281 
282 
283 contract FoMo3DFast is F3Devents {
284     using SafeMath for *;
285     //    using F3DKeysCalcShort for uint256;
286     //
287     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x2C0C48F27350b50ede309BFC7E2349BbEb0aCC72);
288 
289     address private admin = msg.sender;
290     uint256 private prepareTime = 30 minutes;
291     uint256 private aucDur = 120 minutes;     // length of the very first auc
292     uint256 constant private rndInc_ = 360 minutes;              // every full key purchased adds 6hrs to timer
293     uint256 constant private smallTime_ = 5 minutes;              // small time, small pot time
294     uint256 constant private rndMax_ = 10080 minutes;                // max length a round timer can be, 1 week
295     uint256 public rID_;    // round id number / total rounds that have happened
296     uint256 constant public keyPriceAuc_ = 5000000000000000;
297     uint256 constant public keyPricePot_ = 10000000000000000;
298     //****************
299     // PLAYER DATA
300     //****************
301     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
302     mapping(uint256 => F3Ddatasets.PlayerVault) public plyr_;   // (pID => data) player data
303     // (pID => rID => data) player round data by player id & round id
304     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRound)) public plyrRnds_;
305     //****************
306     // ROUND DATA
307     //****************
308     mapping(uint256 => F3Ddatasets.Auction) public auction_;   // (rID => data) round data
309     mapping(uint256 => F3Ddatasets.BigPot) public bigPot_;   // (rID => data) round data
310     F3Ddatasets.SmallPot public smallPot_;   // (rID => data) round data
311     mapping(uint256 => uint256) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
312 
313 
314     // referee  (rID => referee[] data)
315     mapping(uint256 => F3Ddatasets.Referee[]) public referees_;
316     uint256 minOfferValue_;
317     uint256 constant referalSlot_ = 2;
318 
319     constructor()
320     public
321     {
322 
323     }
324     //==============================================================================
325     //     _ _  _  _|. |`. _  _ _  .
326     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
327     //==============================================================================
328     /**
329     * @dev used to make sure no one can interact with contract until it has
330     * been activated.
331     */
332     modifier isActivated() {
333         require(activated_ == true, "its not ready yet.  check ?eta in discord");
334         _;
335     }
336 
337     /**
338     * @dev prevents contracts from interacting with fomo3d
339     */
340     modifier isHuman() {
341         address _addr = msg.sender;
342         uint256 _codeLength;
343 
344         assembly {_codeLength := extcodesize(_addr)}
345         require(_codeLength == 0, "sorry humans only");
346         _;
347     }
348 
349     /**
350     * @dev sets boundaries for incoming tx
351     */
352     modifier isWithinLimits(uint256 _eth) {
353         require(_eth >= 1000000000, "pocket lint: not a valid currency");
354         _;
355     }
356 
357     //==============================================================================
358     //     _    |_ |. _   |`    _  __|_. _  _  _  .
359     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
360     //====|=========================================================================
361     /**
362     * @dev emergency buy uses last stored affiliate ID and team snek
363     */
364     function()
365     isActivated()
366     isHuman()
367     isWithinLimits(msg.value)
368     public
369     payable
370     {
371         // get/set pID for current player
372         determinePID();
373 
374         // fetch player id
375         uint256 _pID = pIDxAddr_[msg.sender];
376         uint256 _now = now;
377         uint256 _rID = rID_;
378 
379         if (_now > auction_[_rID].strt && _now < auction_[_rID].end)
380         {
381             // Auction phase
382             buyAuction(_pID);
383         } else if (_now > bigPot_[_rID].strt && _now < bigPot_[_rID].end) {
384             // Round(big pot) phase
385             buy(_pID, 9999);
386         } else {
387             // check to see if end round needs to be ran
388             if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false)
389             {
390                 // end the round (distributes pot) & start new round
391                 bigPot_[_rID].ended = true;
392                 endRound();
393             }
394 
395             // put eth in players vault
396             plyr_[_pID].gen = msg.value.add(plyr_[_pID].gen);
397         }
398     }
399 
400     function buyXQR(address senderAddr, uint256 _affID)
401     isActivated()
402     isWithinLimits(msg.value)
403     public
404     payable
405     {
406         // get/set pID for current player
407         determinePID();
408 
409         // fetch player id
410         uint256 _pID = pIDxAddr_[senderAddr];
411         uint256 _now = now;
412         uint256 _rID = rID_;
413 
414         if (_now > auction_[_rID].strt && _now < auction_[_rID].end)
415         {
416             // Auction phase
417             buyAuction(_pID);
418         } else if (_now > bigPot_[_rID].strt && _now < bigPot_[_rID].end) {
419             // Round(big pot) phase
420             buy(_pID, _affID);
421         } else {
422             // check to see if end round needs to be ran
423             if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false)
424             {
425                 // end the round (distributes pot) & start new round
426                 bigPot_[_rID].ended = true;
427                 endRound();
428             }
429 
430             // put eth in players vault
431             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
432         }
433     }
434 
435     function endRound()
436     private
437     {
438         // setup local rID
439         uint256 _rID = rID_;
440 
441         // grab our winning player and team id's
442         uint256 _winPID = bigPot_[_rID].plyr;
443 
444         // grab our pot amount
445         uint256 _win = bigPot_[_rID].pot;
446         // 10000000000000000000 10个ether
447 
448         // pay our winner bigPot
449         plyr_[_winPID].winBigPot = _win.add(plyr_[_winPID].winBigPot);
450 
451         // pay smallPot
452         uint256 _currentPot = smallPot_.eth;
453         if (smallPot_.on == true) {
454             uint256 _winSmallPot = smallPot_.pot;
455             uint256 _surplus = _currentPot.sub(_winSmallPot);
456             smallPot_.on = false;
457             smallPot_.keys = 0;
458             smallPot_.eth = 0;
459             smallPot_.pot = 0;
460             smallPot_.plyr = 0;
461             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
462             if (_surplus > 0) {
463                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
464             }
465         } else {
466             if (_currentPot > 0) {
467                 plyr_[1].winSmallPot = _currentPot.add(plyr_[1].winSmallPot);
468             }
469         }
470 
471 
472         // start next round
473         rID_++;
474         _rID++;
475         uint256 _now = now;
476         auction_[_rID].strt = _now;
477         auction_[_rID].end = _now + aucDur;
478 
479         bigPot_[_rID].strt = _now + aucDur;
480         bigPot_[_rID].end = _now + aucDur + rndMax_;
481     }
482 
483     function withdrawXQR(address _realSender)
484     payable
485     isActivated()
486     public
487     {
488         // setup local rID
489         uint256 _rID = rID_;
490 
491         // grab time
492         uint256 _now = now;
493 
494         // fetch player ID
495         uint256 _pID = pIDxAddr_[_realSender];
496 
497         // setup temp var for player eth
498         uint256 _eth;
499 
500         // check to see if round has ended and no one has run round end yet
501         if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false && bigPot_[_rID].plyr != 0)
502         {
503             // end the round (distributes pot)
504             bigPot_[_rID].ended = true;
505             endRound();
506 
507             // get their earnings
508             _eth = withdrawEarnings(_pID);
509 
510             // gib moni
511             if (_eth > 0)
512                 plyr_[_pID].addr.transfer(_eth);
513 
514             // in any other situation
515         } else {
516             // get their earnings
517             _eth = withdrawEarnings(_pID);
518 
519             // gib moni
520             if (_eth > 0)
521                 plyr_[_pID].addr.transfer(_eth);
522 
523         }
524     }
525 
526     function withdrawEarnings(uint256 _pID)
527     private
528     returns (uint256)
529     {
530         updateGenVault(_pID, plyr_[_pID].lrnd);
531         // from vaults
532         uint256 _earnings = (plyr_[_pID].winBigPot).add(plyr_[_pID].winSmallPot).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
533         if (_earnings > 0)
534         {
535             plyr_[_pID].winBigPot = 0;
536             plyr_[_pID].winSmallPot = 0;
537             plyr_[_pID].gen = 0;
538             plyr_[_pID].aff = 0;
539         }
540         return (_earnings);
541     }
542 
543     function updateGenVault(uint256 _pID, uint256 _rIDlast)
544         private 
545     {
546         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
547         if (_earnings > 0)
548         {
549             // put in gen vault
550             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
551             // zero out their earnings by updating mask
552             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
553         }
554     }
555 
556     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
557         private
558         view
559         returns(uint256)
560     {
561         return( (((bigPot_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask) );
562     }
563 
564     function managePlayer(uint256 _pID)
565         private
566     {
567         // if player has played a previous round, move their unmasked earnings
568         // from that round to gen vault.
569         if (plyr_[_pID].lrnd != 0)
570             updateGenVault(_pID, plyr_[_pID].lrnd);
571             
572         // update player's last round played
573         plyr_[_pID].lrnd = rID_;
574     }
575 
576 
577     function buyAuction(uint256 _pID)
578     private
579     {
580         // setup local variables
581         uint256 _rID = rID_;
582         uint256 _keyPrice = keyPriceAuc_;
583 
584         // 加入未统计的分钥匙的钱
585         if (plyrRnds_[_pID][_rID].keys == 0)
586             managePlayer(_pID);
587         
588         // update bigPot leader
589         bigPot_[_rID].plyr = _pID;
590 
591         uint256 _eth = msg.value;
592         // calculate keys purchased
593         uint256 _keys = _eth / _keyPrice;
594 
595         // plry {eth, auc, keys}
596         plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
597         plyrRnds_[_pID][_rID].auc = _eth.add(plyrRnds_[_pID][_rID].auc);
598         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
599 
600         uint256 plyrEth = plyrRnds_[_pID][_rID].eth;
601         uint256 plyrAuc = plyrRnds_[_pID][_rID].auc;
602         uint256 plyrKeys = plyrRnds_[_pID][_rID].keys;
603 
604         // auction {eth, keys}
605         auction_[_rID].eth = auction_[_rID].eth.add(_eth);
606         auction_[_rID].keys = auction_[_rID].keys.add(_keys);
607         uint256 aucEth = auction_[_rID].eth;
608         uint256 aucKeys = auction_[_rID].keys;
609 
610         emit eventAuction
611         (
612             "buyFunction",
613             _rID,
614             _pID,
615             _eth,
616             _keyPrice,
617             plyrEth,
618             plyrAuc,
619             plyrKeys,
620             aucEth,
621             aucKeys
622         );
623 
624         // update round
625         refereeCore(_pID, plyrRnds_[_pID][_rID].auc);
626 
627         // 分钱
628         distributeAuction(_rID, _eth);
629     }
630 
631     function distributeAuction(uint256 _rID, uint256 _eth)
632     private
633     {
634         // pay 50% out to team
635         uint256 _team = _eth / 2;
636         uint256 _pot = _eth.sub(_team);
637         // 50% to big Pot
638         uint256 _bigPot = _pot / 2;
639         // 50% to small Pot
640         uint256 _smallPot = _pot / 2;
641 
642         // pay out p3d
643         admin.transfer(_team);
644 
645         // move money to Pot
646         bigPot_[_rID].pot = bigPot_[_rID].pot.add(_bigPot);
647         smallPot_.pot = smallPot_.pot.add(_smallPot);
648         emit onPot(bigPot_[_rID].plyr, bigPot_[_rID].pot, smallPot_.plyr, smallPot_.pot);
649     }
650 
651     function buy(uint256 _pID, uint256 _affID)
652     private
653     {
654         // setup local rID
655         uint256 _rID = rID_;
656         uint256 _keyPrice = keyPricePot_;
657 
658         if (plyrRnds_[_pID][_rID].keys == 0)
659             managePlayer(_pID);
660 
661         uint256 _eth = msg.value;
662 
663         uint256 _keys = _eth / _keyPrice;
664 
665         if (_eth > 1000000000)
666         {
667             // if they bought at least 1 whole key
668             if (_eth >= 1000000000000000000)
669             {
670                 updateTimer(_eth, _rID);
671                 // set new leaders
672                 if (bigPot_[_rID].plyr != _pID)
673                     bigPot_[_rID].plyr = _pID;
674             }
675 
676 
677             // update round
678             bigPot_[_rID].keys = _keys.add(bigPot_[_rID].keys);
679             bigPot_[_rID].eth = _eth.add(bigPot_[_rID].eth);
680 
681             // update player
682             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
683             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
684 
685             // key sharing earnings
686             uint256 _gen = _eth.mul(6) / 10;
687             updateMasks(_rID, _pID, _gen, _keys);
688             // if (_dust > 0)
689             //     _gen = _gen.sub(_dust);
690 
691             distributeBuy(_rID, _eth, _affID);
692             smallPot();
693         }
694     }
695 
696     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
697         private
698         returns(uint256)
699     {
700         // calc profit per key & round mask based on this buy:  (dust goes to pot)
701         uint256 _ppt = (_gen.mul(1000000000000000000)) / (bigPot_[_rID].keys);
702         bigPot_[_rID].mask = _ppt.add(bigPot_[_rID].mask); 
703             
704         // calculate player earning from their own buy (only based on the keys
705         // they just bought).  & update player earnings mask
706         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
707         plyrRnds_[_pID][_rID].mask = (((bigPot_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
708         
709         // calculate & return dust
710         return(_gen.sub((_ppt.mul(bigPot_[_rID].keys)) / (1000000000000000000)));
711     }
712 
713     function distributeBuy(uint256 _rID, uint256 _eth, uint256 _affID)
714     private
715     {
716         // pay 10% out to team
717         uint256 _team = _eth / 10;
718         // 10% to aff
719         uint256 _aff = _eth / 10;
720         if (_affID == 9999) {
721             _team = _team.add(_aff);
722             _aff = 0;
723         }
724 
725         // 10% to big Pot
726         uint256 _bigPot = _eth / 10;
727         // 10% to small Pot
728         uint256 _smallPot = _eth / 10;
729 
730         // pay out team
731         admin.transfer(_team);
732 
733         if (_aff != 0) {
734             // 通过 affID 得到 推荐玩家pID， 并将_aff驾到 pID玩家的 aff中
735             uint256 affPID = referees_[_rID][_affID].pID;
736             plyr_[affPID].aff = _aff.add(plyr_[affPID].aff);
737         }
738 
739         // move money to Pot
740         bigPot_[_rID].pot = bigPot_[_rID].pot.add(_bigPot);
741         smallPot_.pot = smallPot_.pot.add(_smallPot);
742 
743         emit onPot(bigPot_[_rID].plyr, bigPot_[_rID].pot, smallPot_.plyr, smallPot_.pot);
744     }
745 
746     function smallPot()
747     private
748     {
749         uint256 _now = now;
750 
751         if (smallPot_.on == false && smallPot_.keys >= (1000)) {
752             smallPot_.on = true;
753             smallPot_.pot = smallPot_.eth;
754             smallPot_.strt = _now;
755             smallPot_.end = _now + smallTime_;
756         } else if (smallPot_.on == true && _now > smallPot_.end) {
757             uint256 _winSmallPot = smallPot_.pot;
758             uint256 _currentPot = smallPot_.eth;
759             uint256 _surplus = _currentPot.sub(_winSmallPot);
760             uint256 _winPID = smallPot_.plyr;
761             smallPot_.on = false;
762             smallPot_.keys = 0;
763             smallPot_.eth = 0;
764             smallPot_.pot = 0;
765             smallPot_.plyr = 0;
766             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
767             if (_surplus > 0) {
768                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
769             }
770         }
771     }
772 
773     event onBigPot(
774         string eventname,
775         uint256 rID,
776         uint256 plyr, // pID of player in lead for Big pot
777     // big pot phase
778         uint256 end, // time ends/ended
779         uint256 strt, // time round started
780         uint256 eth, // eth to pot (during round) / final amount paid to winner (after round ends)
781         uint256 keys, // eth to pot (during round) / final amount paid to winner (after round ends)
782         bool ended     // has round end function been ran
783     );
784 
785     function updateTimer(uint256 _keys, uint256 _rID)
786     private
787     {
788         emit onBigPot
789         (
790             "updateTimer_start:",
791             _rID,
792             bigPot_[_rID].plyr,
793             bigPot_[_rID].end,
794             bigPot_[_rID].strt,
795             bigPot_[_rID].eth,
796             bigPot_[_rID].keys,
797             bigPot_[_rID].ended
798         );
799         // grab time
800         uint256 _now = now;
801 
802         // calculate time based on number of keys bought
803         uint256 _newTime;
804         if (_now > bigPot_[_rID].end && bigPot_[_rID].plyr == 0)
805             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
806         else
807             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(bigPot_[_rID].end);
808 
809         // compare to max and set new end time
810         if (_newTime < (rndMax_).add(_now))
811             bigPot_[_rID].end = _newTime;
812         else
813             bigPot_[_rID].end = rndMax_.add(_now);
814 
815         emit onBigPot
816         (
817             "updateTimer_end:",
818             _rID,
819             bigPot_[_rID].plyr,
820             bigPot_[_rID].end,
821             bigPot_[_rID].strt,
822             bigPot_[_rID].eth,
823             bigPot_[_rID].keys,
824             bigPot_[_rID].ended
825         );
826 
827     }
828 
829     event pidUpdate(address sender, uint256 pidOri, uint256 pidNew);
830 
831     function determinePID()
832     private
833     {
834 
835         uint256 _pID = pIDxAddr_[msg.sender];
836         uint256 _pIDOri = _pID;
837         // if player is new to this version of fomo3d
838         if (_pID == 0)
839         {
840             // grab their player ID, name and last aff ID, from player names contract
841             _pID = PlayerBook.getPlayerID(msg.sender);
842 
843             // set up player account
844             pIDxAddr_[msg.sender] = _pID;
845             plyr_[_pID].addr = msg.sender;
846 
847         }
848         emit pidUpdate(msg.sender, _pIDOri, _pID);
849     }
850 
851 
852     function getPlayerIdxAddr(address _addr) public view returns (uint256){
853         if (pIDxAddr_[_addr] == 0) {
854             return pIDxAddr_[_addr];
855         } else {
856             return 0;
857         }
858     }
859 
860 
861     function receivePlayerInfo(uint256 _pID, address _addr)
862     external
863     {
864         require(msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
865         if (pIDxAddr_[_addr] != _pID)
866             pIDxAddr_[_addr] = _pID;
867         if (plyr_[_pID].addr != _addr)
868             plyr_[_pID].addr = _addr;
869     }
870 
871     event consolerefereeCore(
872         uint256 _pID, uint256 _value, uint256 minOfferIndex, uint256 minOfferpID, uint256 minOfferValue
873     );
874 
875     function refereeCore(uint256 _pID, uint256 _value) private {
876         uint256 _rID = rID_;
877         uint256 length_ = referees_[_rID].length;
878         emit consolerefereeCore(_pID, _value, _rID, length_, minOfferValue_);
879         if (_value > minOfferValue_) {
880 
881             uint256 minXvalue = _value;
882             uint256 minXindex = 9999;
883             uint256 flag = 1;
884 
885             // 找到当前玩家，不改变数组，更新玩家出价
886             for (uint256 i = 0; i < referees_[_rID].length; i++) {
887                 if (_pID == referees_[_rID][i].pID) {
888                     referees_[_rID][i].offer = _value;
889                     flag = 0;
890                     break;
891                 }
892             }
893 
894             // 未找到当前玩家，则改变数组，更新玩家出价
895             if (flag == 1) {
896                 emit consolerefereeCore(1111, minXindex, _rID, referees_[_rID].length, minXvalue);
897                 // 找到当前数组中最低出价及最低出价的index
898                 for (uint256 j = 0; j < referees_[_rID].length; j++) {
899                     if (referees_[_rID][j].offer < minXvalue) {
900                         minXvalue = referees_[_rID][j].offer;
901                         emit consolerefereeCore(2222, minXindex, _rID, referees_[_rID].length, minXvalue);
902                         minXindex = j;
903                     }
904                 }
905                 emit consolerefereeCore(3333, minXindex, _rID, referees_[_rID].length, minXvalue);
906                 // 若数组未满， 则直接加入
907                 if (referees_[_rID].length < referalSlot_) {
908                     referees_[_rID].push(F3Ddatasets.Referee(_pID, _value));
909                 } else {
910                     // 替换最低出价
911                     if (minXindex != 9999) {
912                         referees_[_rID][minXindex].offer = _value;
913                         referees_[_rID][minXindex].pID = _pID;
914                         minOfferValue_ = _value;
915                     }
916                 }
917             }
918         }
919     }
920     //==============================================================================
921     //     _  _ _|__|_ _  _ _  .
922     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
923     //=====_|=======================================================================
924     /**
925     * @dev return the price buyer will pay for next 1 individual key.
926     * -functionhash- 0x018a25e8
927     * @return price for next key bought (in wei format)
928     */
929     // function getBuyPrice()
930     // public
931     // view
932     // returns (uint256)
933     // {
934     //     if (now < round_[rID_].start) {
935     //         // 当前轮游戏开始前
936     //         return 5;
937     //     } else if (now > round_[rID_].start && now < rndTmEth_[rID_]) {
938     //         // 当前轮游戏进行中
939     //         return 10;
940     //     } else if (now > rndTmEth_[rID_]) {
941     //         // 当前轮游戏已结束
942     //         return 5;
943     //     }
944     // }
945 
946     function getTimeLeft() public
947     view returns (uint256){
948         return rndTmEth_[rID_] - now;
949     }
950 
951     function getrID() public
952     view returns (uint256){
953         return rID_;
954     }
955 
956     function getAdmin() public
957     view returns (address){
958         return admin;
959     }
960 
961     //==============================================================================
962     //    (~ _  _    _._|_    .
963     //    _)(/_(_|_|| | | \/  .
964     //====================/=========================================================
965     /** upon contract deploy, it will be deactivated.  this is a one time
966      * use function that will activate the contract.  we do this so devs
967      * have time to set things up on the web end                            **/
968     bool public activated_ = false;
969     uint256  public end_ = 0;
970 
971     function activate()
972     public
973     {
974         // only team just can activate
975         require(msg.sender == admin, "only admin can activate");
976         // can only be ran once
977         require(activated_ == false, "FOMO Short already activated");
978 
979         // activate the contract
980         activated_ = true;
981 
982         // lets start first round
983         rID_ = 1;
984         uint256 _now = now;
985 
986         auction_[1].strt = _now;
987         auction_[1].end = _now + aucDur;
988 
989         bigPot_[1].strt = _now + aucDur;
990         bigPot_[1].end = _now + aucDur + rndMax_;
991     }
992 
993     function getAuctionTimer()
994     public
995     view
996     returns (uint256, uint256, uint256, uint256, bool, uint256, uint256)
997     {
998         // setup local rID
999         uint256 _rID = rID_;
1000         uint256 _now = now;
1001         return
1002         (
1003         _rID, //1
1004         auction_[_rID].strt,
1005         auction_[_rID].end,
1006         _now,
1007         _now > auction_[_rID].end,
1008         bigPot_[_rID].strt,
1009         bigPot_[_rID].end            //2
1010         );
1011     }
1012 
1013 
1014     // ================== 页面数据方法 start ======================
1015 
1016     // 获取当前轮auc数据
1017     function getCurrentRoundAucInfo()
1018     public
1019     view
1020     returns (uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256)
1021     {
1022         // setup local rID
1023         uint256 _rID = rID_;
1024         uint256 _now = now;
1025 
1026         return
1027         (
1028         _rID, // round index
1029         // auc data
1030         auction_[_rID].isAuction, // true: auction; false: bigPot
1031         auction_[_rID].strt,
1032         auction_[_rID].end,
1033         auction_[_rID].end - _now,
1034         auction_[_rID].eth,
1035         auction_[_rID].gen,
1036         auction_[_rID].keys
1037         );
1038     }
1039 
1040     // 获取当前轮BigPot数据
1041     function getCurrentRoundBigPotInfo()
1042     public
1043     view
1044     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256)
1045     {
1046         // setup local rID
1047         uint256 _rID = rID_;
1048         uint256 _now = now;
1049         uint256 _currentpID = bigPot_[_rID].plyr;
1050         uint256 _eth = bigPot_[_rID].eth;
1051         return
1052         (
1053         _rID, // round index
1054         // bitPot data
1055         _currentpID, // pID of player in lead for Big pot
1056         bigPot_[_rID].ended, // has round end function been ran
1057         bigPot_[_rID].strt, // time round started
1058         bigPot_[_rID].end, // time ends/ended
1059         bigPot_[_rID].end - _now,
1060         bigPot_[_rID].keys, // keys
1061         _eth, // total eth in
1062         _eth.mul(60) / 100,
1063         bigPot_[_rID].pot, // eth to pot (during round) / final amount paid to winner (after round ends)
1064         plyr_[_currentpID].addr, // current lead address
1065         keyPricePot_
1066         );
1067     }
1068 
1069     // 获取当前轮SmallPot数据
1070     function getSmallPotInfo()
1071     public
1072     view
1073     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, address)
1074     {
1075         // setup local rID
1076         uint256 _rID = rID_;
1077         uint256 _now = now;
1078         uint256 _currentpID = smallPot_.plyr;
1079         return
1080         (
1081         _rID, // round index
1082         // smallPot data
1083         _currentpID,
1084         smallPot_.on,
1085         smallPot_.strt,
1086         smallPot_.end,
1087         smallPot_.end - _now,
1088         smallPot_.keys,
1089         smallPot_.eth,
1090         smallPot_.pot,
1091         plyr_[_currentpID].addr // current lead address
1092         );
1093     }
1094 
1095     // 获取当前轮数据
1096     function getPlayerInfoxAddr()
1097     public
1098     view
1099     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1100     {
1101         // setup local rID
1102         uint256 _rID = rID_;
1103         uint256 _pID = pIDxAddr_[msg.sender];
1104         return
1105         (_rID, //1
1106         _pID, //1
1107         plyrRnds_[_pID][_rID].eth,
1108         plyrRnds_[_pID][_rID].auc,
1109         plyrRnds_[_pID][_rID].keys,
1110         plyrRnds_[_pID][_rID].mask, //2
1111         plyrRnds_[_pID][_rID].refID //2
1112         );
1113     }
1114 
1115     // 获取用户钱包信息
1116     function getPlayerVaultxAddr()
1117     public
1118     view
1119     returns (uint256, address, uint256, uint256, uint256, uint256)
1120     {
1121         // setup local rID
1122         address addr = msg.sender;
1123         uint256 _pID = pIDxAddr_[addr];
1124         return
1125         (
1126         _pID, //1
1127         plyr_[_pID].addr,
1128         plyr_[_pID].winBigPot,
1129         plyr_[_pID].winSmallPot,
1130         plyr_[_pID].gen,
1131         plyr_[_pID].aff
1132         );
1133     }
1134     // ================== 页面数据方法 end ======================
1135 
1136     event consoleRef(uint256 index, uint256 pID, uint256 value);
1137 
1138     function getReferees()
1139     public
1140     payable
1141     {
1142         // setup local rID
1143         uint256 _rID = rID_;
1144         for (uint256 i = 0; i < referees_[_rID].length; i++) {
1145             emit consoleRef(i, referees_[_rID][i].pID, referees_[_rID][i].offer);
1146         }
1147     }
1148 
1149     function getPlayerInfoByAddress(address addr)
1150     public
1151     view
1152     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1153     {
1154         // setup local rID
1155         uint256 _rID = rID_;
1156         address _addr = addr;
1157 
1158         if (_addr == address(0))
1159         {
1160             _addr == msg.sender;
1161         }
1162         uint256 _pID = pIDxAddr_[_addr];
1163         return
1164         (
1165         _pID, //0
1166         _addr, //1
1167         _rID, //2
1168         plyr_[_pID].winBigPot, //3
1169         plyr_[_pID].winSmallPot, //4
1170         plyr_[_pID].gen, //5
1171         plyr_[_pID].aff, //6
1172         plyrRnds_[_pID][_rID].keys, //7
1173         plyrRnds_[_pID][_rID].eth, //
1174         plyrRnds_[_pID][_rID].auc, //
1175         plyrRnds_[_pID][_rID].mask, //
1176         plyrRnds_[_pID][_rID].refID //
1177         );
1178     }
1179 
1180     function getPlayerInfoById(uint256 pID)
1181     public
1182     view
1183     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1184     {
1185         // setup local rID
1186         uint256 _rID = rID_;
1187         uint256 _pID = pID;
1188         address _addr = msg.sender;
1189         return
1190         (
1191         _pID, //0
1192         _addr, //1
1193         _rID, //2
1194         plyr_[_pID].winBigPot, //3
1195         plyr_[_pID].winSmallPot, //4
1196         plyr_[_pID].gen, //5
1197         plyr_[_pID].aff, //6
1198         plyrRnds_[_pID][_rID].keys, //7
1199         plyrRnds_[_pID][_rID].eth, //
1200         plyrRnds_[_pID][_rID].auc, //
1201         plyrRnds_[_pID][_rID].mask, //
1202         plyrRnds_[_pID][_rID].refID //
1203         );
1204     }
1205 
1206 }