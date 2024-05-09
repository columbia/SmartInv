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
252 
253 
254 interface PlayerBookInterface {
255     function getPlayerID(address _addr) external returns (uint256);
256     function getPlayerAddr(uint256 _pID) external view returns (address);
257 }
258 
259 
260 
261 contract F3Devents {
262     event eventAuction(
263         string funName,
264         uint256 round,
265         uint256 plyr,
266         uint256 money,
267         uint256 keyPrice,
268         uint256 plyrEth,
269         uint256 plyrAuc,
270         uint256 plyrKeys,
271         uint256 aucEth,
272         uint256 aucKeys
273     );
274 
275     event onPot(
276         uint256 plyrBP, // pID of player in lead for Big pot
277         uint256 ethBP,
278         uint256 plyrSP, // pID of player in lead for Small pot
279         uint256 ethSP   // eth to pot (during round) / final amount paid to winner (after round ends)
280     );
281 
282 }
283 
284 contract FoMo3DFast is F3Devents {
285     using SafeMath for *;
286     //    using F3DKeysCalcShort for uint256;
287     //
288     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x77ae3DEC9462C8Ac8F1e6D222C1785B5250F0F62);
289 
290     address private admin = msg.sender;
291     uint256 private prepareTime = 30 minutes;
292     uint256 private aucDur = 120 minutes;     // length of the very first ICO
293     // uint256 constant private rndInit_ = 88 minutes;                // round timer starts at this
294     uint256 constant private rndInc_ = 360 seconds;              // every full key purchased adds this much to the timer
295     uint256 constant private smallTime_ = 5 minutes;              // small time
296     uint256 constant private rndMax_ = 10080 minutes;                // max length a round timer can be
297     uint256 public rID_;    // round id number / total rounds that have happened
298     uint256 constant public keyPriceAuc_ = 5000000000000000;
299     uint256 constant public keyPricePot_ = 10000000000000000;
300     //****************
301     // PLAYER DATA
302     //****************
303     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
304     mapping(uint256 => F3Ddatasets.PlayerVault) public plyr_;   // (pID => data) player data
305     // (pID => rID => data) player round data by player id & round id
306     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRound)) public plyrRnds_;
307     //****************
308     // ROUND DATA
309     //****************
310     mapping(uint256 => F3Ddatasets.Auction) public auction_;   // (rID => data) round data
311     mapping(uint256 => F3Ddatasets.BigPot) public bigPot_;   // (rID => data) round data
312     F3Ddatasets.SmallPot public smallPot_;   // (rID => data) round data
313     mapping(uint256 => uint256) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
314 
315 
316     // referee  (rID => referee[] data)
317     mapping(uint256 => F3Ddatasets.Referee[]) public referees_;
318     uint256 minOfferValue_;
319     uint256 constant referalSlot_ = 2;
320 
321     constructor()
322     public
323     {
324 
325     }
326     //==============================================================================
327     //     _ _  _  _|. |`. _  _ _  .
328     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
329     //==============================================================================
330     /**
331     * @dev used to make sure no one can interact with contract until it has
332     * been activated.
333     */
334     modifier isActivated() {
335         require(activated_ == true, "its not ready yet.  check ?eta in discord");
336         _;
337     }
338 
339     /**
340     * @dev prevents contracts from interacting with fomo3d
341     */
342     modifier isHuman() {
343         address _addr = msg.sender;
344         uint256 _codeLength;
345 
346         assembly {_codeLength := extcodesize(_addr)}
347         require(_codeLength == 0, "sorry humans only");
348         _;
349     }
350 
351     /**
352     * @dev sets boundaries for incoming tx
353     */
354     modifier isWithinLimits(uint256 _eth) {
355         require(_eth >= 1000000000, "pocket lint: not a valid currency");
356         _;
357     }
358 
359     //==============================================================================
360     //     _    |_ |. _   |`    _  __|_. _  _  _  .
361     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
362     //====|=========================================================================
363     /**
364     * @dev emergency buy uses last stored affiliate ID and team snek
365     */
366     function()
367     isActivated()
368     isHuman()
369     isWithinLimits(msg.value)
370     public
371     payable
372     {
373         // get/set pID for current player
374         determinePID(msg.sender);
375 
376         // fetch player id
377         uint256 _pID = pIDxAddr_[msg.sender];
378         uint256 _now = now;
379         uint256 _rID = rID_;
380 
381         if (_now > auction_[_rID].strt && _now < auction_[_rID].end)
382         {
383             // Auction phase
384             buyAuction(_pID);
385         } else if (_now > bigPot_[_rID].strt && _now < bigPot_[_rID].end) {
386             // Round(big pot) phase
387             buy(_pID, 9999);
388         } else {
389             // check to see if end round needs to be ran
390             if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false)
391             {
392                 // end the round (distributes pot) & start new round
393                 bigPot_[_rID].ended = true;
394                 endRound();
395             }
396 
397             // put eth in players vault
398             plyr_[_pID].gen = msg.value.add(plyr_[_pID].gen);
399         }
400     }
401 
402     function buyXQR(address _realSender, uint256 _affID)
403     isActivated()
404     isWithinLimits(msg.value)
405     public
406     payable
407     {
408         // get/set pID for current player
409         determinePID(_realSender);
410 
411         // fetch player id
412         uint256 _pID = pIDxAddr_[_realSender];
413         uint256 _now = now;
414         uint256 _rID = rID_;
415 
416         if (_now > auction_[_rID].strt && _now < auction_[_rID].end)
417         {
418             // Auction phase
419             buyAuction(_pID);
420         } else if (_now > bigPot_[_rID].strt && _now < bigPot_[_rID].end) {
421             // Round(big pot) phase
422             buy(_pID, _affID);
423         } else {
424             // check to see if end round needs to be ran
425             if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false)
426             {
427                 // end the round (distributes pot) & start new round
428                 bigPot_[_rID].ended = true;
429                 endRound();
430             }
431 
432             // put eth in players vault
433             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
434         }
435     }
436 
437     function endRound()
438     private
439     {
440         // setup local rID
441         uint256 _rID = rID_;
442 
443         // grab our winning player and team id's
444         uint256 _winPID = bigPot_[_rID].plyr;
445 
446         // grab our pot amount
447         uint256 _win = bigPot_[_rID].pot;
448         // 10000000000000000000 10个ether
449 
450         // pay our winner bigPot
451         plyr_[_winPID].winBigPot = _win.add(plyr_[_winPID].winBigPot);
452 
453         // pay smallPot
454         uint256 _currentPot = smallPot_.eth;
455         if (smallPot_.on == true) {
456             uint256 _winSmallPot = smallPot_.pot;
457             uint256 _surplus = _currentPot.sub(_winSmallPot);
458             smallPot_.on = false;
459             smallPot_.keys = 0;
460             smallPot_.eth = 0;
461             smallPot_.pot = 0;
462             smallPot_.plyr = 0;
463             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
464             if (_surplus > 0) {
465                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
466             }
467         } else {
468             if (_currentPot > 0) {
469                 plyr_[1].winSmallPot = _currentPot.add(plyr_[1].winSmallPot);
470             }
471         }
472 
473 
474         // start next round
475         rID_++;
476         _rID++;
477         uint256 _now = now;
478         auction_[_rID].strt = _now;
479         auction_[_rID].end = _now + aucDur;
480 
481         bigPot_[_rID].strt = _now + aucDur;
482         bigPot_[_rID].end = _now + aucDur + rndMax_;
483     }
484 
485     function withdrawXQR(address _realSender)
486     payable
487     isActivated()
488     public
489     {
490         // setup local rID
491         uint256 _rID = rID_;
492 
493         // grab time
494         uint256 _now = now;
495 
496         // fetch player ID
497         uint256 _pID = pIDxAddr_[_realSender];
498 
499         // setup temp var for player eth
500         uint256 _eth;
501 
502         // check to see if round has ended and no one has run round end yet
503         if (_now > bigPot_[_rID].end && bigPot_[_rID].ended == false && bigPot_[_rID].plyr != 0)
504         {
505             // end the round (distributes pot)
506             bigPot_[_rID].ended = true;
507             endRound();
508 
509             // get their earnings
510             _eth = withdrawEarnings(_pID);
511 
512             // gib moni
513             if (_eth > 0)
514                 plyr_[_pID].addr.transfer(_eth);
515 
516             // in any other situation
517         } else {
518             // get their earnings
519             _eth = withdrawEarnings(_pID);
520 
521             // gib moni
522             if (_eth > 0)
523                 plyr_[_pID].addr.transfer(_eth);
524 
525         }
526     }
527 
528     function withdrawEarnings(uint256 _pID)
529     private
530     returns (uint256)
531     {
532         updateGenVault(_pID, plyr_[_pID].lrnd);
533         // from vaults
534         uint256 _earnings = (plyr_[_pID].winBigPot).add(plyr_[_pID].winSmallPot).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
535         if (_earnings > 0)
536         {
537             plyr_[_pID].winBigPot = 0;
538             plyr_[_pID].winSmallPot = 0;
539             plyr_[_pID].gen = 0;
540             plyr_[_pID].aff = 0;
541         }
542         return (_earnings);
543     }
544 
545     function updateGenVault(uint256 _pID, uint256 _rIDlast)
546         private 
547     {
548         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
549         if (_earnings > 0)
550         {
551             // put in gen vault
552             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
553             // zero out their earnings by updating mask
554             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
555         }
556     }
557 
558     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
559         private
560         view
561         returns(uint256)
562     {
563         return( (((bigPot_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask) );
564     }
565 
566     function managePlayer(uint256 _pID)
567         private
568     {
569         // if player has played a previous round, move their unmasked earnings
570         // from that round to gen vault.
571         if (plyr_[_pID].lrnd != 0)
572             updateGenVault(_pID, plyr_[_pID].lrnd);
573             
574         // update player's last round played
575         plyr_[_pID].lrnd = rID_;
576     }
577 
578 
579     function buyAuction(uint256 _pID)
580     private
581     {
582         // setup local variables
583         uint256 _rID = rID_;
584         uint256 _keyPrice = keyPriceAuc_;
585 
586         // 加入未统计的分钥匙的钱
587         if (plyrRnds_[_pID][_rID].keys == 0)
588             managePlayer(_pID);
589         
590         // update bigPot leader
591         bigPot_[_rID].plyr = _pID;
592 
593         uint256 _eth = msg.value;
594         // calculate keys purchased
595         uint256 _keys = _eth / _keyPrice;
596 
597         // plry {eth, auc, keys}
598         plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
599         plyrRnds_[_pID][_rID].auc = _eth.add(plyrRnds_[_pID][_rID].auc);
600         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
601 
602         uint256 plyrEth = plyrRnds_[_pID][_rID].eth;
603         uint256 plyrAuc = plyrRnds_[_pID][_rID].auc;
604         uint256 plyrKeys = plyrRnds_[_pID][_rID].keys;
605 
606         // auction {eth, keys}
607         auction_[_rID].eth = auction_[_rID].eth.add(_eth);
608         auction_[_rID].keys = auction_[_rID].keys.add(_keys);
609         uint256 aucEth = auction_[_rID].eth;
610         uint256 aucKeys = auction_[_rID].keys;
611 
612         emit eventAuction
613         (
614             "buyFunction",
615             _rID,
616             _pID,
617             _eth,
618             _keyPrice,
619             plyrEth,
620             plyrAuc,
621             plyrKeys,
622             aucEth,
623             aucKeys
624         );
625 
626         // update round
627         refereeCore(_pID, plyrRnds_[_pID][_rID].auc);
628 
629         // 分钱
630         distributeAuction(_rID, _eth);
631     }
632 
633     function distributeAuction(uint256 _rID, uint256 _eth)
634     private
635     {
636         // pay 50% out to team
637         uint256 _team = _eth / 2;
638         uint256 _pot = _eth.sub(_team);
639         // 50% to big Pot
640         uint256 _bigPot = _pot / 2;
641         // 50% to small Pot
642         uint256 _smallPot = _pot / 2;
643 
644         // pay out p3d
645         admin.transfer(_team);
646 
647         // move money to Pot
648         bigPot_[_rID].pot = bigPot_[_rID].pot.add(_bigPot);
649         smallPot_.pot = smallPot_.pot.add(_smallPot);
650         emit onPot(bigPot_[_rID].plyr, bigPot_[_rID].pot, smallPot_.plyr, smallPot_.pot);
651     }
652 
653     function buy(uint256 _pID, uint256 _affID)
654     private
655     {
656         // setup local rID
657         uint256 _rID = rID_;
658         uint256 _keyPrice = keyPricePot_;
659 
660         if (plyrRnds_[_pID][_rID].keys == 0)
661             managePlayer(_pID);
662 
663         uint256 _eth = msg.value;
664 
665         uint256 _keys = _eth / _keyPrice;
666 
667         if (_eth > 1000000000)
668         {
669             // if they bought at least 1 whole key
670             if (_eth >= 1000000000000000000)
671             {
672                 updateTimer(_eth, _rID);
673                 // set new leaders
674                 if (bigPot_[_rID].plyr != _pID)
675                     bigPot_[_rID].plyr = _pID;
676             }
677 
678 
679             // update round
680             bigPot_[_rID].keys = _keys.add(bigPot_[_rID].keys);
681             bigPot_[_rID].eth = _eth.add(bigPot_[_rID].eth);
682 
683             // update player
684             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
685             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
686 
687             // key sharing earnings
688             uint256 _gen = _eth.mul(6) / 10;
689             updateMasks(_rID, _pID, _gen, _keys);
690             // if (_dust > 0)
691             //     _gen = _gen.sub(_dust);
692 
693             distributeBuy(_rID, _eth, _affID);
694             smallPot();
695         }
696     }
697 
698     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
699         private
700         returns(uint256)
701     {
702         // calc profit per key & round mask based on this buy:  (dust goes to pot)
703         uint256 _ppt = (_gen.mul(1000000000000000000)) / (bigPot_[_rID].keys);
704         bigPot_[_rID].mask = _ppt.add(bigPot_[_rID].mask); 
705             
706         // calculate player earning from their own buy (only based on the keys
707         // they just bought).  & update player earnings mask
708         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
709         plyrRnds_[_pID][_rID].mask = (((bigPot_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
710         
711         // calculate & return dust
712         return(_gen.sub((_ppt.mul(bigPot_[_rID].keys)) / (1000000000000000000)));
713     }
714 
715     function distributeBuy(uint256 _rID, uint256 _eth, uint256 _affID)
716     private
717     {
718         // pay 10% out to team
719         uint256 _team = _eth / 10;
720         // 10% to aff
721         uint256 _aff = _eth / 10;
722         if (_affID == 9999) {
723             _team = _team.add(_aff);
724             _aff = 0;
725         }
726 
727         // 10% to big Pot
728         uint256 _bigPot = _eth / 10;
729         // 10% to small Pot
730         uint256 _smallPot = _eth / 10;
731 
732         // pay out team
733         admin.transfer(_team);
734 
735         if (_aff != 0) {
736             // 通过 affID 得到 推荐玩家pID， 并将_aff驾到 pID玩家的 aff中
737             uint256 affPID = referees_[_rID][_affID].pID;
738             plyr_[affPID].aff = _aff.add(plyr_[affPID].aff);
739         }
740 
741         // move money to Pot
742         bigPot_[_rID].pot = bigPot_[_rID].pot.add(_bigPot);
743         smallPot_.pot = smallPot_.pot.add(_smallPot);
744 
745         emit onPot(bigPot_[_rID].plyr, bigPot_[_rID].pot, smallPot_.plyr, smallPot_.pot);
746     }
747 
748     function smallPot()
749     private
750     {
751         uint256 _now = now;
752 
753         if (smallPot_.on == false && smallPot_.keys >= (1000)) {
754             smallPot_.on = true;
755             smallPot_.pot = smallPot_.eth;
756             smallPot_.strt = _now;
757             smallPot_.end = _now + smallTime_;
758         } else if (smallPot_.on == true && _now > smallPot_.end) {
759             uint256 _winSmallPot = smallPot_.pot;
760             uint256 _currentPot = smallPot_.eth;
761             uint256 _surplus = _currentPot.sub(_winSmallPot);
762             uint256 _winPID = smallPot_.plyr;
763             smallPot_.on = false;
764             smallPot_.keys = 0;
765             smallPot_.eth = 0;
766             smallPot_.pot = 0;
767             smallPot_.plyr = 0;
768             plyr_[_winPID].winSmallPot = _winSmallPot.add(plyr_[_winPID].winSmallPot);
769             if (_surplus > 0) {
770                 plyr_[1].winSmallPot = _surplus.add(plyr_[1].winSmallPot);
771             }
772         }
773     }
774 
775     event onBigPot(
776         string eventname,
777         uint256 rID,
778         uint256 plyr, // pID of player in lead for Big pot
779     // big pot phase
780         uint256 end, // time ends/ended
781         uint256 strt, // time round started
782         uint256 eth, // eth to pot (during round) / final amount paid to winner (after round ends)
783         uint256 keys, // eth to pot (during round) / final amount paid to winner (after round ends)
784         bool ended     // has round end function been ran
785     );
786 
787     function updateTimer(uint256 _keys, uint256 _rID)
788     private
789     {
790         emit onBigPot
791         (
792             "updateTimer_start:",
793             _rID,
794             bigPot_[_rID].plyr,
795             bigPot_[_rID].end,
796             bigPot_[_rID].strt,
797             bigPot_[_rID].eth,
798             bigPot_[_rID].keys,
799             bigPot_[_rID].ended
800         );
801         // grab time
802         uint256 _now = now;
803 
804         // calculate time based on number of keys bought
805         uint256 _newTime;
806         if (_now > bigPot_[_rID].end && bigPot_[_rID].plyr == 0)
807             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
808         else
809             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(bigPot_[_rID].end);
810 
811         // compare to max and set new end time
812         if (_newTime < (rndMax_).add(_now))
813             bigPot_[_rID].end = _newTime;
814         else
815             bigPot_[_rID].end = rndMax_.add(_now);
816 
817         emit onBigPot
818         (
819             "updateTimer_end:",
820             _rID,
821             bigPot_[_rID].plyr,
822             bigPot_[_rID].end,
823             bigPot_[_rID].strt,
824             bigPot_[_rID].eth,
825             bigPot_[_rID].keys,
826             bigPot_[_rID].ended
827         );
828 
829     }
830 
831     event pidUpdate(address sender, uint256 pidOri, uint256 pidNew);
832 
833     function determinePID(address _realSender)
834     private
835     {
836 
837         uint256 _pID = pIDxAddr_[_realSender];
838         uint256 _pIDOri = _pID;
839         // if player is new to this version of fomo3d
840         if (_pID == 0)
841         {
842             // grab their player ID, name and last aff ID, from player names contract
843             _pID = PlayerBook.getPlayerID(_realSender);
844 
845             // set up player account
846             pIDxAddr_[_realSender] = _pID;
847             plyr_[_pID].addr = _realSender;
848 
849         }
850         emit pidUpdate(_realSender, _pIDOri, _pID);
851     }
852 
853 
854     function getPlayerIdxAddr(address _addr) public view returns (uint256){
855         if (pIDxAddr_[_addr] == 0) {
856             return pIDxAddr_[_addr];
857         } else {
858             return 0;
859         }
860     }
861 
862 
863     function receivePlayerInfo(uint256 _pID, address _addr)
864     external
865     {
866         require(msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
867         if (pIDxAddr_[_addr] != _pID)
868             pIDxAddr_[_addr] = _pID;
869         if (plyr_[_pID].addr != _addr)
870             plyr_[_pID].addr = _addr;
871     }
872 
873     event consolerefereeCore(
874         uint256 _pID, uint256 _value, uint256 minOfferIndex, uint256 minOfferpID, uint256 minOfferValue
875     );
876 
877     function refereeCore(uint256 _pID, uint256 _value) private {
878         uint256 _rID = rID_;
879         uint256 length_ = referees_[_rID].length;
880         emit consolerefereeCore(_pID, _value, _rID, length_, minOfferValue_);
881         if (_value > minOfferValue_) {
882 
883             uint256 minXvalue = _value;
884             uint256 minXindex = 9999;
885             uint256 flag = 1;
886 
887             // 找到当前玩家，不改变数组，更新玩家出价
888             for (uint256 i = 0; i < referees_[_rID].length; i++) {
889                 if (_pID == referees_[_rID][i].pID) {
890                     referees_[_rID][i].offer = _value;
891                     flag = 0;
892                     break;
893                 }
894             }
895 
896             // 未找到当前玩家，则改变数组，更新玩家出价
897             if (flag == 1) {
898                 emit consolerefereeCore(1111, minXindex, _rID, referees_[_rID].length, minXvalue);
899                 // 找到当前数组中最低出价及最低出价的index
900                 for (uint256 j = 0; j < referees_[_rID].length; j++) {
901                     if (referees_[_rID][j].offer < minXvalue) {
902                         minXvalue = referees_[_rID][j].offer;
903                         emit consolerefereeCore(2222, minXindex, _rID, referees_[_rID].length, minXvalue);
904                         minXindex = j;
905                     }
906                 }
907                 emit consolerefereeCore(3333, minXindex, _rID, referees_[_rID].length, minXvalue);
908                 // 若数组未满， 则直接加入
909                 if (referees_[_rID].length < referalSlot_) {
910                     referees_[_rID].push(F3Ddatasets.Referee(_pID, _value));
911                 } else {
912                     // 替换最低出价
913                     if (minXindex != 9999) {
914                         referees_[_rID][minXindex].offer = _value;
915                         referees_[_rID][minXindex].pID = _pID;
916                         minOfferValue_ = _value;
917                     }
918                 }
919             }
920         }
921     }
922     //==============================================================================
923     //     _  _ _|__|_ _  _ _  .
924     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
925     //=====_|=======================================================================
926     /**
927     * @dev return the price buyer will pay for next 1 individual key.
928     * -functionhash- 0x018a25e8
929     * @return price for next key bought (in wei format)
930     */
931     // function getBuyPrice()
932     // public
933     // view
934     // returns (uint256)
935     // {
936     //     if (now < round_[rID_].start) {
937     //         // 当前轮游戏开始前
938     //         return 5;
939     //     } else if (now > round_[rID_].start && now < rndTmEth_[rID_]) {
940     //         // 当前轮游戏进行中
941     //         return 10;
942     //     } else if (now > rndTmEth_[rID_]) {
943     //         // 当前轮游戏已结束
944     //         return 5;
945     //     }
946     // }
947 
948     function getTimeLeft() public
949     view returns (uint256){
950         return rndTmEth_[rID_] - now;
951     }
952 
953     function getrID() public
954     view returns (uint256){
955         return rID_;
956     }
957 
958     function getAdmin() public
959     view returns (address){
960         return admin;
961     }
962 
963     //==============================================================================
964     //    (~ _  _    _._|_    .
965     //    _)(/_(_|_|| | | \/  .
966     //====================/=========================================================
967     /** upon contract deploy, it will be deactivated.  this is a one time
968      * use function that will activate the contract.  we do this so devs
969      * have time to set things up on the web end                            **/
970     bool public activated_ = false;
971     uint256  public end_ = 0;
972 
973     function activate()
974     public
975     {
976         // only team just can activate
977         require(msg.sender == admin, "only admin can activate");
978         // can only be ran once
979         require(activated_ == false, "FOMO Short already activated");
980 
981         // activate the contract
982         activated_ = true;
983 
984         // lets start first round
985         rID_ = 1;
986         uint256 _now = now;
987 
988         auction_[1].strt = _now;
989         auction_[1].end = _now + aucDur;
990 
991         bigPot_[1].strt = _now + aucDur;
992         bigPot_[1].end = _now + aucDur + rndMax_;
993     }
994 
995     function getAuctionTimer()
996     public
997     view
998     returns (uint256, uint256, uint256, uint256, bool, uint256, uint256)
999     {
1000         // setup local rID
1001         uint256 _rID = rID_;
1002         uint256 _now = now;
1003         return
1004         (
1005         _rID, //1
1006         auction_[_rID].strt,
1007         auction_[_rID].end,
1008         _now,
1009         _now > auction_[_rID].end,
1010         bigPot_[_rID].strt,
1011         bigPot_[_rID].end            //2
1012         );
1013     }
1014 
1015 
1016     // ================== 页面数据方法 start ======================
1017 
1018     // 获取当前轮auc数据
1019     function getCurrentRoundAucInfo()
1020     public
1021     view
1022     returns (uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256)
1023     {
1024         // setup local rID
1025         uint256 _rID = rID_;
1026         uint256 _now = now;
1027 
1028         return
1029         (
1030         _rID, // round index
1031         // auc data
1032         auction_[_rID].isAuction, // true: auction; false: bigPot
1033         auction_[_rID].strt,
1034         auction_[_rID].end,
1035         auction_[_rID].end - _now,
1036         auction_[_rID].eth,
1037         auction_[_rID].gen,
1038         auction_[_rID].keys
1039         );
1040     }
1041 
1042     // 获取当前轮BigPot数据
1043     function getCurrentRoundBigPotInfo()
1044     public
1045     view
1046     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256)
1047     {
1048         // setup local rID
1049         uint256 _rID = rID_;
1050         uint256 _now = now;
1051         uint256 _currentpID = bigPot_[_rID].plyr;
1052         uint256 _eth = bigPot_[_rID].eth;
1053         return
1054         (
1055         _rID, // round index
1056         // bitPot data
1057         _currentpID, // pID of player in lead for Big pot
1058         bigPot_[_rID].ended, // has round end function been ran
1059         bigPot_[_rID].strt, // time round started
1060         bigPot_[_rID].end, // time ends/ended
1061         bigPot_[_rID].end - _now,
1062         bigPot_[_rID].keys, // keys
1063         _eth, // total eth in
1064         _eth.mul(60) / 100,
1065         bigPot_[_rID].pot, // eth to pot (during round) / final amount paid to winner (after round ends)
1066         plyr_[_currentpID].addr, // current lead address
1067         keyPricePot_
1068         );
1069     }
1070 
1071     // 获取当前轮SmallPot数据
1072     function getSmallPotInfo()
1073     public
1074     view
1075     returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, address)
1076     {
1077         // setup local rID
1078         uint256 _rID = rID_;
1079         uint256 _now = now;
1080         uint256 _currentpID = smallPot_.plyr;
1081         return
1082         (
1083         _rID, // round index
1084         // smallPot data
1085         _currentpID,
1086         smallPot_.on,
1087         smallPot_.strt,
1088         smallPot_.end,
1089         smallPot_.end - _now,
1090         smallPot_.keys,
1091         smallPot_.eth,
1092         smallPot_.pot,
1093         plyr_[_currentpID].addr // current lead address
1094         );
1095     }
1096 
1097     // 获取当前轮数据
1098     function getPlayerInfoxAddr()
1099     public
1100     view
1101     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1102     {
1103         // setup local rID
1104         uint256 _rID = rID_;
1105         uint256 _pID = pIDxAddr_[msg.sender];
1106         return
1107         (_rID, //1
1108         _pID, //1
1109         plyrRnds_[_pID][_rID].eth,
1110         plyrRnds_[_pID][_rID].auc,
1111         plyrRnds_[_pID][_rID].keys,
1112         plyrRnds_[_pID][_rID].mask, //2
1113         plyrRnds_[_pID][_rID].refID //2
1114         );
1115     }
1116 
1117     // 获取用户钱包信息
1118     function getPlayerVaultxAddr()
1119     public
1120     view
1121     returns (uint256, address, uint256, uint256, uint256, uint256)
1122     {
1123         // setup local rID
1124         address addr = msg.sender;
1125         uint256 _pID = pIDxAddr_[addr];
1126         return
1127         (
1128         _pID, //1
1129         plyr_[_pID].addr,
1130         plyr_[_pID].winBigPot,
1131         plyr_[_pID].winSmallPot,
1132         plyr_[_pID].gen,
1133         plyr_[_pID].aff
1134         );
1135     }
1136     // ================== 页面数据方法 end ======================
1137 
1138     event consoleRef(uint256 index, uint256 pID, uint256 value);
1139 
1140     function getReferees()
1141     public
1142     payable
1143     {
1144         // setup local rID
1145         uint256 _rID = rID_;
1146         for (uint256 i = 0; i < referees_[_rID].length; i++) {
1147             emit consoleRef(i, referees_[_rID][i].pID, referees_[_rID][i].offer);
1148         }
1149     }
1150 
1151     function getPlayerInfoByAddress(address addr)
1152     public
1153     view
1154     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1155     {
1156         // setup local rID
1157         uint256 _rID = rID_;
1158         address _addr = addr;
1159 
1160         if (_addr == address(0))
1161         {
1162             _addr == msg.sender;
1163         }
1164         uint256 _pID = pIDxAddr_[_addr];
1165         return
1166         (
1167         _pID, //0
1168         _addr, //1
1169         _rID, //2
1170         plyr_[_pID].winBigPot, //3
1171         plyr_[_pID].winSmallPot, //4
1172         plyr_[_pID].gen, //5
1173         plyr_[_pID].aff, //6
1174         plyrRnds_[_pID][_rID].keys, //7
1175         plyrRnds_[_pID][_rID].eth, //
1176         plyrRnds_[_pID][_rID].auc, //
1177         plyrRnds_[_pID][_rID].mask, //
1178         plyrRnds_[_pID][_rID].refID //
1179         );
1180     }
1181 
1182     function getPlayerInfoById(uint256 pID)
1183     public
1184     view
1185     returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1186     {
1187         // setup local rID
1188         uint256 _rID = rID_;
1189         uint256 _pID = pID;
1190         address _addr = msg.sender;
1191         return
1192         (
1193         _pID, //0
1194         _addr, //1
1195         _rID, //2
1196         plyr_[_pID].winBigPot, //3
1197         plyr_[_pID].winSmallPot, //4
1198         plyr_[_pID].gen, //5
1199         plyr_[_pID].aff, //6
1200         plyrRnds_[_pID][_rID].keys, //7
1201         plyrRnds_[_pID][_rID].eth, //
1202         plyrRnds_[_pID][_rID].auc, //
1203         plyrRnds_[_pID][_rID].mask, //
1204         plyrRnds_[_pID][_rID].refID //
1205         );
1206     }
1207 
1208     function kill() public {
1209         if (admin == msg.sender) { // 检查谁在调用
1210             selfdestruct(admin); // 销毁合约
1211         }
1212     }
1213 
1214 }