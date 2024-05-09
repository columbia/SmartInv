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
21         internal 
22         pure 
23         returns (uint256 c) 
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
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42     
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47         internal
48         pure
49         returns (uint256) 
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b)
59         internal
60         pure
61         returns (uint256 c) 
62     {
63         c = a + b;
64         require(c >= a, "SafeMath add failed");
65         return c;
66     }
67     
68     /**
69      * @dev gives square root of given x.
70      */
71     function sqrt(uint256 x)
72         internal
73         pure
74         returns (uint256 y) 
75     {
76         uint256 z = ((add(x,1)) / 2);
77         y = x;
78         while (z < y) 
79         {
80             y = z;
81             z = ((add((x / z),z)) / 2);
82         }
83     }
84     
85     /**
86      * @dev gives square. multiplies x by x
87      */
88     function sq(uint256 x)
89         internal
90         pure
91         returns (uint256)
92     {
93         return (mul(x,x));
94     }
95     
96     /**
97      * @dev x to the power of y 
98      */
99     function pwr(uint256 x, uint256 y)
100         internal 
101         pure 
102         returns (uint256)
103     {
104         if (x==0)
105             return (0);
106         else if (y==0)
107             return (1);
108         else 
109         {
110             uint256 z = x;
111             for (uint256 i=1; i < y; i++)
112                 z = mul(z,x);
113             return (z);
114         }
115     }
116 }
117 
118 library BMKeysCalcLong {
119     using SafeMath for *;
120     /**
121      * @dev calculates number of keys received given X eth 
122      * @param _curEth current amount of eth in contract 
123      * @param _newEth eth being spent
124      * @return amount of ticket purchased
125      */
126     function keysRec(uint256 _curEth, uint256 _newEth)
127         internal
128         pure
129         returns (uint256)
130     {
131         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
132     }
133     
134     /**
135      * @dev calculates amount of eth received if you sold X keys 
136      * @param _curKeys current amount of keys that exist 
137      * @param _sellKeys amount of keys you wish to sell
138      * @return amount of eth received
139      */
140     function ethRec(uint256 _curKeys, uint256 _sellKeys)
141         internal
142         pure
143         returns (uint256)
144     {
145         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
146     }
147 
148     /**
149      * @dev calculates how many keys would exist with given an amount of eth
150      * @param _eth eth "in contract"
151      * @return number of keys that would exist
152      */
153     function keys(uint256 _eth) 
154         internal
155         pure
156         returns(uint256)
157     {
158         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
159     }
160     
161     /**
162      * @dev calculates how much eth would be in contract given a number of keys
163      * @param _keys number of keys "in contract" 
164      * @return eth that would exists
165      */
166     function eth(uint256 _keys) 
167         internal
168         pure
169         returns(uint256)  
170     {
171         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
172     }
173 }
174 library BMDatasets {
175     //compressedData key
176     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
177         // 0 - new player (bool)
178         // 1 - joined round (bool)
179         // 2 - new  leader (bool)
180         // 3-5 - air drop tracker (uint 0-999)
181         // 6-16 - round end time
182         // 17 - winnerTeam
183         // 18 - 28 timestamp 
184         // 29 - team
185         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
186         // 31 - airdrop happened bool
187         // 32 - airdrop tier 
188         // 33 - airdrop amount won
189     //compressedIDs key
190     // [77-52][51-26][25-0]
191         // 0-25 - pID 
192         // 26-51 - winPID
193         // 52-77 - rID
194     struct EventReturns {
195         uint256 compressedData;
196         uint256 compressedIDs;
197         address winnerAddr;         // winner address
198         bytes32 winnerName;         // winner name
199         uint256 amountWon;          // amount won
200         uint256 newPot;             // amount in new pot
201         uint256 genAmount;          // amount distributed to gen
202         uint256 potAmount;          // amount added to pot
203     }
204     struct Player {
205         address addr;   // player address
206         uint256 win;    // winnings vault
207         uint256 gen;    // general vault
208         uint256 lrnd;   // last round played
209     }
210 
211     struct PlayerRounds {
212         uint256 eth;    // eth player has added to round (used for eth limiter)
213         uint256 keys;   // keys
214         uint256 mask;   // player mask 
215     }
216     
217     struct Round {
218         uint256 plyr;   // pID of player in lead
219         uint256 team;   // tID of team in lead
220         uint256 end;    // time ends/ended
221         bool ended;     // has round end function been ran
222         uint256 strt;   // time round started
223         uint256 keys;   // keys
224         uint256 eth;    // total eth in
225         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
226         uint256 mask;   // global mask
227     }
228     struct TeamFee {
229         uint256 gen;    // % of buy in thats paid to key holders of current round
230     }
231     struct PotSplit {
232         uint256 gen;    // % of pot thats paid to key holders of current round
233     }
234 }
235 contract BMEvents {
236     
237     // fired at end of buy or reload
238     event onEndTx
239     (
240         uint256 compressedData,     
241         uint256 compressedIDs,      
242         address playerAddress,
243         uint256 ethIn,
244         uint256 keysBought,
245         address winnerAddr,
246         uint256 amountWon,
247         uint256 newPot,
248         uint256 genAmount,
249         uint256 potAmount,
250         uint256 airDropPot
251     );
252     
253 	// fired whenever theres a withdraw
254     event onWithdraw
255     (
256         uint256 indexed playerID,
257         address playerAddress,
258         uint256 ethOut,
259         uint256 timeStamp
260     );
261     
262     // fired whenever a withdraw forces end round to be ran
263     event onWithdrawAndDistribute
264     (
265         address playerAddress,
266         uint256 ethOut,
267         uint256 compressedData,
268         uint256 compressedIDs,
269         address winnerAddr,
270         uint256 amountWon,
271         uint256 newPot,
272         uint256 genAmount
273     );
274     
275     // fired whenever a player tries a buy after round timer 
276     // hit zero, and causes end round to be ran.
277     event onBuyAndDistribute
278     (
279         address playerAddress,
280         uint256 ethIn,
281         uint256 compressedData,
282         uint256 compressedIDs,
283         address winnerAddr,
284         uint256 amountWon,
285         uint256 newPot,
286         uint256 genAmount
287     );
288     
289     // fired whenever a player tries a reload after round timer 
290     // hit zero, and causes end round to be ran.
291     event onReLoadAndDistribute
292     (
293         address playerAddress,
294         uint256 compressedData,
295         uint256 compressedIDs,
296         address winnerAddr,
297         uint256 amountWon,
298         uint256 newPot,
299         uint256 genAmount
300     );
301 }
302 
303 contract BMGame is BMEvents {
304     using SafeMath for *;
305     using BMKeysCalcLong for uint256;
306 
307     address  public Banker_Address;
308 
309     //==============================================================================
310     // game settings
311     //==============================================================================
312     uint256 private rndExtra_ = 30;//extSettings.getLongExtra();     // length of the very first ICO
313     uint256 private rndGap_ = 30; //extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
314     uint256 constant private rndInit_ = 5 minutes;                // round timer starts at this
315     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
316     uint256 constant private rndMax_ = 10 minutes;                // max length a round timer can be
317     //==============================================================================
318     // data used to store game info that changes
319     //==============================================================================
320     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
321     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
322     //****************
323     // PLAYER DATA
324     //****************
325     uint256 public pID_ = 0;                              // total number of players
326     mapping(address => uint256) public pIDxAddr_;         // (addr => pID) returns player id by address
327     mapping(uint256 => BMDatasets.Player) public plyr_;   // (pID => data) player data
328     mapping(uint256 => mapping(uint256 => BMDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
329     //****************
330     // ROUND DATA
331     //****************
332     uint256 public rID_;                    // round id number / total rounds that have happened
333     mapping(uint256 => BMDatasets.Round) public round_;   // (rID => data) round data
334     mapping(uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
335     //****************
336     // TEAM FEE DATA
337     //****************
338     mapping(uint256 => BMDatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
339     mapping(uint256 => BMDatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
340 
341 
342     address public owner;
343 
344     //==============================================================================
345     // (initial data setup upon contract deploy)
346     //==============================================================================
347     constructor()
348     public
349     {
350         owner = msg.sender;
351         // Team allocation structures
352         // 0 = whales 2
353         // 1 = bears  3
354         // 2 = sneks  0
355         // 3 = bulls  1
356 
357         // Team allocation percentages
358         fees_[0] = BMDatasets.TeamFee(70);
359         //20% to pot, 5% to com, 5% to air drop pot
360         fees_[1] = BMDatasets.TeamFee(55);
361         //35% to pot, 5% to com, 5% to air drop pot
362         fees_[2] = BMDatasets.TeamFee(40);
363         //50% to pot, 5% to com, 5% to air drop pot
364         fees_[3] = BMDatasets.TeamFee(30);
365         //60% to pot, 5% to com, 5% to air drop pot
366 
367         // how to split up the final pot based on which team was picked
368         potSplit_[0] = BMDatasets.PotSplit(50);
369         //48% to winner, 0% to next round, 2% to com
370         potSplit_[1] = BMDatasets.PotSplit(40);
371         //48% to winner, 10% to next round, 2% to com
372         potSplit_[2] = BMDatasets.PotSplit(25);
373         //48% to winner, 25% to next round, 2% to com
374         potSplit_[3] = BMDatasets.PotSplit(10);
375         //48% to winner, 40% to next round, 2% to com
376     }
377     
378     //==============================================================================
379     // (these are safety checks)
380     //==============================================================================
381 
382     /**
383      * @dev used to make sure no one can interact with contract until it has 
384      * been activated. 
385      */
386     modifier isActivated() {
387         require(activated_ == true, "its not ready yet.");
388         _;
389     }
390 
391     /**
392      * @dev prevents contracts from interacting with bmg 
393      */
394     modifier isHuman() {
395         address _addr = msg.sender;
396         uint256 _codeLength;
397 
398         assembly {_codeLength := extcodesize(_addr)}
399         require(_codeLength == 0, "sorry humans only");
400         _;
401     }
402 
403     /**
404      * @dev sets boundaries for incoming tx 
405      */
406     modifier isWithinLimits(uint256 _eth) {
407         require(_eth >= 1000000000, "pocket lint: not a valid currency");
408         require(_eth <= 100000000000000000000000, "no vitalik, no");
409         _;
410     }
411 
412     //==============================================================================
413     // (use these to interact with contract)
414     //==============================================================================
415     /**
416      * @dev emergency buy uses team snek
417      */
418     function()
419     isActivated()
420     isHuman()
421     isWithinLimits(msg.value)
422     public
423     payable
424     {
425         // set up our tx event data and determine if player is new or not
426         BMDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
427 
428         // fetch player id
429         uint256 _pID = pIDxAddr_[msg.sender];
430 
431         // buy core 
432         buyCore(_pID, 2, _eventData_);
433     }
434 
435     /**
436      * @dev converts all incoming ethereum to keys.
437      * @param _team what team is the player playing for?
438      */
439     function buyKey(uint256 _team)
440     isActivated()
441     isHuman()
442     isWithinLimits(msg.value)
443     public
444     payable
445     {
446         // set up our tx event data and determine if player is new or not
447         BMDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
448 
449         // fetch player id
450         uint256 _pID = pIDxAddr_[msg.sender];
451 
452         // verify a valid team was selected
453         _team = verifyTeam(_team);
454 
455         // buy core 
456         buyCore(_pID, _team, _eventData_);
457     }
458 
459     /**
460      * @dev essentially the same as buy, but instead of you sending ether 
461      * from your wallet, it uses your unwithdrawn earnings.
462      * @param _team what team is the player playing for?
463      * @param _eth amount of earnings to use (remainder returned to gen vault)
464      */
465     function reLoadKey(uint256 _team, uint256 _eth)
466     isActivated()
467     isHuman()
468     isWithinLimits(_eth)
469     public
470     {
471         // set up our tx event data
472         BMDatasets.EventReturns memory _eventData_;
473 
474         // fetch player ID
475         uint256 _pID = pIDxAddr_[msg.sender];
476 
477         // verify a valid team was selected
478         _team = verifyTeam(_team);
479 
480         // reload core
481         reLoadCore(_pID, _team, _eth, _eventData_);
482     }
483 
484     /**
485      * @dev withdraws all of your earnings.
486      */
487     function withdraw()
488     isActivated()
489     isHuman()
490     public
491     {
492         // setup local rID 
493         uint256 _rID = rID_;
494 
495         // grab time
496         uint256 _now = now;
497 
498         // fetch player ID
499         uint256 _pID = pIDxAddr_[msg.sender];
500 
501         // setup temp var for player eth
502         uint256 _eth;
503 
504         // check to see if round has ended and no one has run round end yet
505         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
506         {
507             // set up our tx event data
508             BMDatasets.EventReturns memory _eventData_;
509 
510             // end the round (distributes pot)
511             round_[_rID].ended = true;
512             _eventData_ = endRound(_eventData_);
513 
514             // get their earnings
515             _eth = withdrawEarnings(_pID);
516 
517             // gib moni
518             if (_eth > 0)
519                 plyr_[_pID].addr.transfer(_eth);
520 
521             // build event data
522             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
523             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
524 
525             // fire withdraw and distribute event
526             emit BMEvents.onWithdrawAndDistribute
527             (
528                 msg.sender,
529                 _eth,
530                 _eventData_.compressedData,
531                 _eventData_.compressedIDs,
532                 _eventData_.winnerAddr,
533                 _eventData_.amountWon,
534                 _eventData_.newPot,
535                 _eventData_.genAmount
536             );
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
547             // fire withdraw event
548             emit BMEvents.onWithdraw(_pID, msg.sender, _eth, _now);
549         }
550     }
551 
552 
553     //==============================================================================
554     // (for UI & viewing things on etherscan)
555     //==============================================================================
556     /**
557      * @dev return the price buyer will pay for next 1 individual key.
558      * @return price for next key bought (in wei format)
559      */
560     function getBuyPrice()
561     public
562     view
563     returns (uint256)
564     {
565         // setup local rID
566         uint256 _rID = rID_;
567 
568         // grab time
569         uint256 _now = now;
570 
571         // are we in a round?
572         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
573             return ((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000));
574         else // rounds over.  need price for new round
575             return (75000000000000);
576         // init
577     }
578 
579     /**
580      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
581      * provider
582      * @return time left in seconds
583      */
584     function getTimeLeft()
585     public
586     view
587     returns (uint256)
588     {
589         // setup local rID
590         uint256 _rID = rID_;
591 
592         // grab time
593         uint256 _now = now;
594 
595         if (_now < round_[_rID].end)
596             if (_now > round_[_rID].strt + rndGap_)
597                 return ((round_[_rID].end).sub(_now));
598             else
599                 return ((round_[_rID].strt + rndGap_).sub(_now));
600         else
601             return (0);
602     }
603 
604     /**
605      * @dev returns player earnings per vaults 
606      * @return winnings vault
607      * @return general vault
608      */
609     function getPlayerVaults(uint256 _pID)
610     public
611     view
612     returns (uint256, uint256)
613     {
614         // setup local rID
615         uint256 _rID = rID_;
616 
617         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
618         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
619         {
620             // if player is winner 
621             if (round_[_rID].plyr == _pID)
622             {
623                 return
624                 (
625                 (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
626                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask))                
627                 );
628                 // if player is not the winner
629             } else {
630                 return
631                 (
632                 plyr_[_pID].win,
633                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask))
634                 );
635             }
636 
637             // if round is still going on, or round has ended and round end has been ran
638         } else {
639             return
640             (
641             plyr_[_pID].win,
642             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd))
643             );
644         }
645     }
646 
647     /**
648      * solidity hates stack limits.  this lets us avoid that hate 
649      */
650     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
651     private
652     view
653     returns (uint256)
654     {
655         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
656     }
657 
658     /**
659      * @dev returns all current round info needed for front end
660      * @return round id 
661      * @return total keys for round 
662      * @return time round ends
663      * @return time round started
664      * @return current pot 
665      * @return current team ID & player ID in lead 
666      * @return current player in leads address 
667      * @return whales eth in for round
668      * @return bears eth in for round
669      * @return sneks eth in for round
670      * @return bulls eth in for round
671      * @return airdrop tracker # & airdrop pot
672      */
673     function getCurrentRoundInfo()
674     public
675     view
676     returns (uint256, uint256, uint256, uint256, uint256, uint256, address, uint256, uint256, uint256, uint256, uint256)
677     {
678         // setup local rID
679         uint256 _rID = rID_;
680 
681         return
682         (
683         _rID, //0
684         round_[_rID].keys, //1
685         round_[_rID].end, //2
686         round_[_rID].strt, //3
687         round_[_rID].pot, //4
688         (round_[_rID].team + (round_[_rID].plyr * 10)), //5
689         plyr_[round_[_rID].plyr].addr, //6
690         rndTmEth_[_rID][0], //7
691         rndTmEth_[_rID][1], //8
692         rndTmEth_[_rID][2], //9
693         rndTmEth_[_rID][3], //10
694         airDropTracker_ + (airDropPot_ * 1000)              //11
695         );
696     }
697 
698     /**
699      * @dev returns player info based on address.  if no address is given, it will 
700      * use msg.sender 
701      * @param _addr address of the player you want to lookup 
702      * @return player ID 
703      * @return player name
704      * @return keys owned (current round)
705      * @return winnings vault
706      * @return general vault 
707      * @return affiliate vault 
708 	 * @return player round eth
709      */
710     function getPlayerInfoByAddress(address _addr)
711     public
712     view
713     returns (uint256, uint256, uint256, uint256, uint256)
714     {
715         // setup local rID
716         uint256 _rID = rID_;
717 
718         if (_addr == address(0))
719         {
720             _addr == msg.sender;
721         }
722         uint256 _pID = pIDxAddr_[_addr];
723 
724         return
725         (
726         _pID, //0
727         plyrRnds_[_pID][_rID].keys, //1
728         plyr_[_pID].win, //2
729         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), //3
730         plyrRnds_[_pID][_rID].eth           //4
731         );
732     }
733 
734     //==============================================================================
735     // (this + tools + calcs + modules = our softwares engine)
736     //==============================================================================
737     /**
738      * @dev logic runs whenever a buy order is executed.  determines how to handle 
739      * incoming eth depending on if we are in an active round or not
740      */
741     function buyCore(uint256 _pID, uint256 _team, BMDatasets.EventReturns memory _eventData_)
742     private
743     {
744         // setup local rID
745         uint256 _rID = rID_;
746 
747         // grab time
748         uint256 _now = now;
749 
750         // if round is active
751         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
752         {
753             // call core 
754             core(_rID, _pID, msg.value, _team, _eventData_);
755 
756             // if round is not active
757         } else {
758             // check to see if end round needs to be ran
759             if (_now > round_[_rID].end && round_[_rID].ended == false)
760             {
761                 // end the round (distributes pot) & start new round
762                 round_[_rID].ended = true;
763                 _eventData_ = endRound(_eventData_);
764 
765                 // build event data
766                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
767                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
768 
769                 // fire buy and distribute event 
770                 emit BMEvents.onBuyAndDistribute
771                 (
772                     msg.sender,
773                     msg.value,
774                     _eventData_.compressedData,
775                     _eventData_.compressedIDs,
776                     _eventData_.winnerAddr,
777                     _eventData_.amountWon,
778                     _eventData_.newPot,
779                     _eventData_.genAmount
780                 );
781             }
782 
783             core(rID_, _pID, msg.value, _team, _eventData_);
784 
785             // put eth in players vault 
786             //plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
787         }
788     }
789 
790     /**
791      * @dev logic runs whenever a reload order is executed.  determines how to handle 
792      * incoming eth depending on if we are in an active round or not 
793      */
794     function reLoadCore(uint256 _pID, uint256 _team, uint256 _eth, BMDatasets.EventReturns memory _eventData_)
795     private
796     {
797         // setup local rID
798         uint256 _rID = rID_;
799 
800         // grab time
801         uint256 _now = now;
802 
803         // if round is active
804         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
805         {
806             // get earnings from all vaults and return unused to gen vault
807             // because we use a custom safemath library.  this will throw if player 
808             // tried to spend more eth than they have.
809             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
810 
811             // call core 
812             core(_rID, _pID, _eth, _team, _eventData_);
813 
814             // if round is not active and end round needs to be ran
815         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
816             // end the round (distributes pot) & start new round
817             round_[_rID].ended = true;
818             _eventData_ = endRound(_eventData_);
819 
820             // build event data
821             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
822             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
823 
824             // fire buy and distribute event 
825             emit BMEvents.onReLoadAndDistribute
826             (
827                 msg.sender,
828                 _eventData_.compressedData,
829                 _eventData_.compressedIDs,
830                 _eventData_.winnerAddr,
831                 _eventData_.amountWon,
832                 _eventData_.newPot,
833                 _eventData_.genAmount
834             );
835 
836             // get earnings from all vaults and return unused to gen vault
837             // because we use a custom safemath library.  this will throw if player 
838             // tried to spend more eth than they have.
839             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
840 
841             // call core 
842             core(rID_, _pID, _eth, _team, _eventData_);
843 
844         }
845     }
846 
847     /**
848      * @dev this is the core logic for any buy/reload that happens while a round 
849      * is live.
850      */
851     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, BMDatasets.EventReturns memory _eventData_)
852     private
853     {
854         // if player is new to round
855         if (plyrRnds_[_pID][_rID].keys == 0)
856             _eventData_ = managePlayer(_pID, _eventData_);
857 
858         // early round eth limiter 
859         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
860         {
861             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
862             uint256 _refund = _eth.sub(_availableLimit);
863             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
864             _eth = _availableLimit;
865         }
866 
867         // if eth left is greater than min eth allowed (sorry no pocket lint)
868         if (_eth > 1000000000)
869         {
870 
871             // mint the new keys
872             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
873 
874             // if they bought at least 1 whole key
875             if (_keys >= 1000000000000000000)
876             {
877                 updateTimer(_keys, _rID);
878 
879                 // set new leaders
880                 if (round_[_rID].plyr != _pID)
881                     round_[_rID].plyr = _pID;
882                 if (round_[_rID].team != _team)
883                     round_[_rID].team = _team;
884 
885                 // set the new leader bool to true
886                 _eventData_.compressedData = _eventData_.compressedData + 100;
887             }
888 
889             // manage airdrops
890             if (_eth >= 100000000000000000)
891             {
892                 airDropTracker_++;
893                 if (airdrop() == true)
894                 {
895                     // gib muni
896                     uint256 _prize;
897                     if (_eth >= 10000000000000000000)
898                     {
899                         // calculate prize and give it to winner
900                         _prize = ((airDropPot_).mul(75)) / 100;
901                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
902 
903                         // adjust airDropPot
904                         airDropPot_ = (airDropPot_).sub(_prize);
905 
906                         // let event know a tier 3 prize was won
907                         _eventData_.compressedData += 300000000000000000000000000000000;
908                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
909                         // calculate prize and give it to winner
910                         _prize = ((airDropPot_).mul(50)) / 100;
911                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
912 
913                         // adjust airDropPot
914                         airDropPot_ = (airDropPot_).sub(_prize);
915 
916                         // let event know a tier 2 prize was won
917                         _eventData_.compressedData += 200000000000000000000000000000000;
918                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
919                         // calculate prize and give it to winner
920                         _prize = ((airDropPot_).mul(25)) / 100;
921                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
922 
923                         // adjust airDropPot
924                         airDropPot_ = (airDropPot_).sub(_prize);
925 
926                         // let event know a tier 3 prize was won
927                         _eventData_.compressedData += 300000000000000000000000000000000;
928                     }
929                     // set airdrop happened bool to true
930                     _eventData_.compressedData += 10000000000000000000000000000000;
931                     // let event know how much was won
932                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
933 
934                     // reset air drop tracker
935                     airDropTracker_ = 0;
936                 }
937             }
938 
939             // store the air drop tracker number (number of buys since last airdrop)
940             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
941 
942             // update player 
943             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
944             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
945 
946             // update round
947             round_[_rID].keys = _keys.add(round_[_rID].keys);
948             round_[_rID].eth = _eth.add(round_[_rID].eth);
949             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
950 
951             // distribute eth
952             _eventData_ = distribute(_rID, _pID, _eth, _team, _keys, _eventData_);
953 
954             // call end tx function to fire end tx event.
955             endTx(_pID, _team, _eth, _keys, _eventData_);
956         }
957     }
958     //==============================================================================
959     // (calculates)
960     //==============================================================================
961     /**
962      * @dev calculates unmasked earnings (just calculates, does not update mask)
963      * @return earnings in wei format
964      */
965     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
966     private
967     view
968     returns (uint256)
969     {
970         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
971     }
972 
973     /** 
974      * @dev returns the amount of keys you would get given an amount of eth. 
975      * @param _rID round ID you want price for
976      * @param _eth amount of eth sent in 
977      * @return keys received 
978      */
979     function calcKeysReceived(uint256 _rID, uint256 _eth)
980     public
981     view
982     returns (uint256)
983     {
984         // grab time
985         uint256 _now = now;
986 
987         // are we in a round?
988         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
989             return ((round_[_rID].eth).keysRec(_eth));
990         else // rounds over.  need keys for new round
991             return ((_eth).keys());
992     }
993 
994     /** 
995      * @dev returns current eth price for X keys.  
996      * @param _keys number of keys desired (in 18 decimal format)
997      * @return amount of eth needed to send
998      */
999     function iWantXKeys(uint256 _keys)
1000     public
1001     view
1002     returns (uint256)
1003     {
1004         // setup local rID
1005         uint256 _rID = rID_;
1006 
1007         // grab time
1008         uint256 _now = now;
1009 
1010         // are we in a round?
1011         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1012             return ((round_[_rID].keys.add(_keys)).ethRec(_keys));
1013         else // rounds over.  need price for new round
1014             return ((_keys).eth());
1015     }
1016 
1017     /**
1018      * @dev gets existing or registers new pID.  use this when a player may be new
1019      * @return pID 
1020      */
1021     function determinePID(BMDatasets.EventReturns memory _eventData_)
1022     private
1023     returns (BMDatasets.EventReturns)
1024     {
1025         uint256 _pID = pIDxAddr_[msg.sender];
1026         // if player is new to this version of bmg
1027         if (_pID == 0)
1028         {
1029             pID_++;
1030             // set up player account 
1031             pIDxAddr_[msg.sender] = pID_;
1032             plyr_[pID_].addr = msg.sender;
1033 
1034             // set the new player bool to true
1035             _eventData_.compressedData = _eventData_.compressedData + 1;
1036         }
1037         return (_eventData_);
1038     }
1039 
1040     /**
1041      * @dev checks to make sure user picked a valid team.  if not sets team 
1042      * to default (sneks)
1043      */
1044     function verifyTeam(uint256 _team)
1045     private
1046     pure
1047     returns (uint256)
1048     {
1049         if (_team < 0 || _team > 3)
1050             return (2);
1051         else
1052             return (_team);
1053     }
1054 
1055     /**
1056      * @dev decides if round end needs to be run & new round started.  and if 
1057      * player unmasked earnings from previously played rounds need to be moved.
1058      */
1059     function managePlayer(uint256 _pID, BMDatasets.EventReturns memory _eventData_)
1060     private
1061     returns (BMDatasets.EventReturns)
1062     {
1063         // if player has played a previous round, move their unmasked earnings
1064         // from that round to gen vault.
1065         if (plyr_[_pID].lrnd != 0)
1066             updateGenVault(_pID, plyr_[_pID].lrnd);
1067 
1068         // update player's last round played
1069         plyr_[_pID].lrnd = rID_;
1070 
1071         // set the joined round bool to true
1072         _eventData_.compressedData = _eventData_.compressedData + 10;
1073 
1074         return (_eventData_);
1075     }
1076 
1077     /**
1078      * @dev ends the round. manages paying out winner/splitting up pot
1079      */
1080     function endRound(BMDatasets.EventReturns memory _eventData_)
1081     private
1082     returns (BMDatasets.EventReturns)
1083     {
1084         // setup local rID
1085         uint256 _rID = rID_;
1086 
1087         // grab our winning player and team id's
1088         uint256 _winPID = round_[_rID].plyr;
1089         uint256 _winTID = round_[_rID].team;
1090 
1091         // grab our pot amount
1092         uint256 _pot = round_[_rID].pot;
1093 
1094         // calculate our winner share, community rewards, gen share, 
1095         // and amount reserved for next pot 
1096         uint256 _win = (_pot.mul(48)) / 100;
1097         uint256 _com = (_pot / 50);
1098         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1099         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1100 
1101         // calculate ppt for round mask
1102         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1103         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1104         if (_dust > 0)
1105         {
1106             _gen = _gen.sub(_dust);
1107             _res = _res.add(_dust);
1108         }
1109 
1110         // pay our winner
1111         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1112 
1113         // community rewards
1114         if (!address(Banker_Address).send(_com))
1115         {
1116             //if failed add to pot
1117             _res = _res.add(_com);
1118             _com = 0;
1119         }
1120 
1121         // distribute gen portion to key holders
1122         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1123 
1124         // prepare event data
1125         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1126         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1127         _eventData_.winnerAddr = plyr_[_winPID].addr;
1128         _eventData_.amountWon = _win;
1129         _eventData_.genAmount = _gen;
1130         _eventData_.newPot = _res;
1131 
1132         // start next round
1133         rID_++;
1134         _rID++;
1135         round_[_rID].strt = now;
1136         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1137         round_[_rID].pot = _res;
1138 
1139         return (_eventData_);
1140     }
1141 
1142     /**
1143      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1144      */
1145     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1146     private
1147     {
1148         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1149         if (_earnings > 0)
1150         {
1151             // put in gen vault
1152             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1153             // zero out their earnings by updating mask
1154             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1155         }
1156     }
1157 
1158     /**
1159      * @dev updates round timer based on number of whole keys bought.
1160      */
1161     function updateTimer(uint256 _keys, uint256 _rID)
1162     private
1163     {
1164         // grab time
1165         uint256 _now = now;
1166 
1167         // calculate time based on number of keys bought
1168         uint256 _newTime;
1169         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1170             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1171         else
1172             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1173 
1174         // compare to max and set new end time
1175         if (_newTime < (rndMax_).add(_now))
1176             round_[_rID].end = _newTime;
1177         else
1178             round_[_rID].end = rndMax_.add(_now);
1179     }
1180 
1181     /**
1182      * @dev generates a random number between 0-99 and checks to see if thats
1183      * resulted in an airdrop win
1184      * @return do we have a winner?
1185      */
1186     function airdrop()
1187     private
1188     view
1189     returns (bool)
1190     {
1191         uint256 seed = uint256(keccak256(abi.encodePacked(
1192 
1193                 (block.timestamp).add
1194                 (block.difficulty).add
1195                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1196                 (block.gaslimit).add
1197                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1198                 (block.number)
1199 
1200             )));
1201         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1202             return (true);
1203         else
1204             return (false);
1205     }
1206 
1207     /**
1208      * @dev distributes eth based on fees to gen and pot
1209      */
1210     function distribute(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, BMDatasets.EventReturns memory _eventData_)
1211     private
1212     returns (BMDatasets.EventReturns)
1213     {
1214         // pay 5% out to community rewards
1215         uint256 _com = _eth / 20;
1216         if (!address(Banker_Address).send(_com))
1217         {
1218             _com = 0;
1219         }
1220 
1221         // calculate gen share
1222         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1223 
1224         // toss 5% into airdrop pot 
1225         uint256 _air = (_eth / 20);
1226         airDropPot_ = airDropPot_.add(_air);
1227 
1228         // calculate pot 
1229         uint256 _pot = _eth.sub(_com).sub(_air).sub(_gen);
1230 
1231         // distribute gen share (thats what updateMasks() does) and adjust
1232         // balances for dust.
1233         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1234         if (_dust > 0)
1235             _gen = _gen.sub(_dust);
1236 
1237         // add eth to pot
1238         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1239 
1240         // set up event data
1241         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1242         _eventData_.potAmount = _pot;
1243 
1244         return (_eventData_);
1245     }
1246 
1247     /**
1248      * @dev updates masks for round and player when keys are bought
1249      * @return dust left over 
1250      */
1251     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1252     private
1253     returns (uint256)
1254     {
1255         /* MASKING NOTES
1256             earnings masks are a tricky thing for people to wrap their minds around.
1257             the basic thing to understand here.  is were going to have a global
1258             tracker based on profit per share for each round, that increases in
1259             relevant proportion to the increase in share supply.
1260             
1261             the player will have an additional mask that basically says "based
1262             on the rounds mask, my shares, and how much i've already withdrawn,
1263             how much is still owed to me?"
1264         */
1265 
1266         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1267         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1268         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1269 
1270         // calculate player earning from their own buy (only based on the keys
1271         // they just bought).  & update player earnings mask
1272         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1273         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1274 
1275         // calculate & return dust
1276         return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1277     }
1278 
1279     /**
1280      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1281      * @return earnings in wei format
1282      */
1283     function withdrawEarnings(uint256 _pID)
1284     private
1285     returns (uint256)
1286     {
1287         // update gen vault
1288         updateGenVault(_pID, plyr_[_pID].lrnd);
1289 
1290         // from vaults 
1291         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen);
1292         if (_earnings > 0)
1293         {
1294             plyr_[_pID].win = 0;
1295             plyr_[_pID].gen = 0;
1296         }
1297 
1298         return (_earnings);
1299     }
1300 
1301     /**
1302      * @dev prepares compression data and fires event for buy or reload tx's
1303      */
1304     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, BMDatasets.EventReturns memory _eventData_)
1305     private
1306     {
1307         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1308         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1309 
1310         emit BMEvents.onEndTx
1311         (
1312             _eventData_.compressedData,
1313             _eventData_.compressedIDs,
1314             msg.sender,
1315             _eth,
1316             _keys,
1317             _eventData_.winnerAddr,
1318             _eventData_.amountWon,
1319             _eventData_.newPot,
1320             _eventData_.genAmount,
1321             _eventData_.potAmount,
1322             airDropPot_
1323         );
1324     }
1325 
1326     //==============================================================================
1327     // (activate)
1328     //==============================================================================
1329     /** upon contract deploy, it will be deactivated.  this is a one time
1330      * use function that will activate the contract.  we do this so devs 
1331      * have time to set things up on the web end                            **/
1332     bool public activated_ = false;
1333 
1334     function activate()
1335     public
1336     {
1337 
1338         // can only be ran once
1339         require(msg.sender == owner, 'only dev!');
1340         require(activated_ == false, "BiMoney Game already activated");
1341 
1342         // activate the contract 
1343         activated_ = true;
1344 
1345         Banker_Address = msg.sender;
1346 
1347         // lets start first round
1348         rID_ = 1;
1349         round_[1].strt = now + rndExtra_ - rndGap_;
1350         round_[1].end = now + rndInit_ + rndExtra_;
1351     }
1352 
1353 
1354 }