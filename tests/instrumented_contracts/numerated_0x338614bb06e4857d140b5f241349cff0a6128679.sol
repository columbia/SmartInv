1 pragma solidity ^0.4.24;
2 
3 //==============================================================================
4 //     _    _  _ _|_ _  .
5 //    (/_\/(/_| | | _\  .
6 //==============================================================================
7 contract F3Devents {
8     // fired whenever a player registers a name
9     event onNewName
10     (
11         uint256 indexed playerID,
12         address indexed playerAddress,
13         bytes32 indexed playerName,
14         bool isNewPlayer,
15         uint256 affiliateID,
16         address affiliateAddress,
17         bytes32 affiliateName,
18         uint256 amountPaid,
19         uint256 timeStamp
20     );
21     
22     // fired at end of buy or reload
23     event onEndTx
24     (
25         uint256 compressedData,     
26         uint256 compressedIDs,      
27         bytes32 playerName,
28         address playerAddress,
29         uint256 ethIn,
30         uint256 keysBought,
31         address winnerAddr,
32         uint256 winnerId,
33         uint256 amountWon,
34         uint256 newPot,
35         uint256 P3DAmount,
36         uint256 genAmount,
37         uint256 potAmount,
38         uint256 airDropPot
39     );
40     
41 	// fired whenever theres a withdraw
42     event onWithdraw
43     (
44         uint256 indexed playerID,
45         address playerAddress,
46         bytes32 playerName,
47         uint256 ethOut,
48         uint256 timeStamp
49     );
50     
51     // fired whenever a withdraw forces end round to be ran
52     event onWithdrawAndDistribute
53     (
54         address playerAddress,
55         bytes32 playerName,
56         uint256 ethOut,
57         uint256 compressedData,
58         uint256 compressedIDs,
59         address winnerAddr,
60         uint256 winnerId,
61         uint256 amountWon,
62         uint256 newPot,
63         uint256 P3DAmount,
64         uint256 genAmount
65     );
66     
67     // (fomo3d long only) fired whenever a player tries a buy after round timer 
68     // hit zero, and causes end round to be ran.
69     event onBuyAndDistribute
70     (
71         address playerAddress,
72         bytes32 playerName,
73         uint256 ethIn,
74         uint256 compressedData,
75         uint256 compressedIDs,
76         address winnerAddr,
77         uint256 winnerId,
78         uint256 amountWon,
79         uint256 newPot,
80         uint256 P3DAmount,
81         uint256 genAmount
82     );
83     
84     // (fomo3d long only) fired whenever a player tries a reload after round timer 
85     // hit zero, and causes end round to be ran.
86     event onReLoadAndDistribute
87     (
88         address playerAddress,
89         bytes32 playerName,
90         uint256 compressedData,
91         uint256 compressedIDs,
92         address winnerAddr,
93         uint256 winnerId,
94         uint256 amountWon,
95         uint256 newPot,
96         uint256 P3DAmount,
97         uint256 genAmount
98     );
99     
100     // fired whenever an affiliate is paid
101     event onAffiliatePayout
102     (
103         uint256 indexed affiliateID,
104         address affiliateAddress,
105         bytes32 affiliateName,
106         uint256 indexed roundID,
107         uint256 indexed buyerID,
108         uint256 amount,
109         uint256 timeStamp
110     );
111     
112     // received pot swap deposit
113     event onPotSwapDeposit
114     (
115         uint256 roundID,
116         uint256 amountAddedToPot
117     );
118 }
119 
120 //==============================================================================
121 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
122 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
123 //====================================|=========================================
124 contract FoMo3Dlong is F3Devents {
125     using SafeMath for *;
126     using F3DKeysCalcLong for uint256;
127 
128 //==============================================================================
129 //     _ _  _  |`. _     _ _ |_ | _  _  .
130 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
131 //=================_|===========================================================
132     string constant public name = "FoMo3D Chicken";
133     string constant public symbol = "FomoC";
134 	uint256 private rndExtra_ =0 ;     // length of the very first ICO 
135     uint256 constant private rndInit_ = 72 hours;                // round timer starts at this
136     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
137     uint256 constant private rndMax_ = 72 hours;                // max length a round timer can be
138 //==============================================================================
139 //     _| _ _|_ _    _ _ _|_    _   .
140 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
141 //=============================|================================================
142 
143     uint256 public rID_;    // round id number / total rounds that have happened
144     uint256 public comB_;
145     //uint256 public keyPrice_=10000000000000; //default key price
146 //****************
147 // PLAYER DATA 
148 //****************
149     uint256 public userCount_  = 1;
150     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
151     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
152     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
153 //****************
154 // ROUND DATA 
155 //****************
156     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
157     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
158 //****************
159 // TEAM FEE DATA 
160 //****************
161     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
162     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
163 //==============================================================================
164 //     _ _  _  __|_ _    __|_ _  _  .
165 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
166 //==============================================================================
167     constructor()
168         public
169     {
170 		// Team allocation structures
171         // 0 = gansidui
172         // 1 = duzhandui
173 
174 		// Team allocation percentages
175         // (F3D, P3D) + (Pot , Referrals, Community)
176             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
177         fees_[0] = F3Ddatasets.TeamFee(63,0);   //20% to pot, 10% to aff, 7% to com
178         fees_[1] = F3Ddatasets.TeamFee(40,0);   //43% to pot, 10% to aff, 7% to com
179      
180         // how to split up the final pot based on which team was picked
181         // (F3D, winner)
182         potSplit_[0] =  F3Ddatasets.PotSplit(30,50); //50% to winner, 10% to next round, 10% to com
183         potSplit_[1] = F3Ddatasets.PotSplit(20,60);  //60% to winner, 10% to next round, 10% to com
184 	}
185 //==============================================================================
186 //     _ _  _  _|. |`. _  _ _  .
187 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
188 //==============================================================================
189     /**
190      * @dev used to make sure no one can interact with contract until it has 
191      * been activated. 
192      */
193     modifier isActivated() {
194         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
195         _;
196     }
197     
198     /**
199      * @dev prevents contracts from interacting with fomo3d 
200      */
201     modifier isHuman() {
202         address _addr = msg.sender;
203         uint256 _codeLength;
204         
205         assembly {_codeLength := extcodesize(_addr)}
206         require(_codeLength == 0, "sorry humans only");
207         _;
208     }
209 
210     /**
211      * @dev sets boundaries for incoming tx 
212      */
213     modifier isWithinLimits(uint256 _eth) {
214         require(_eth >= 1000000000, "pocket lint: not a valid currency");
215         require(_eth <= 100000000000000000000000, "no vitalik, no");
216         _;    
217     }
218     
219 //==============================================================================
220 //     _    |_ |. _   |`    _  __|_. _  _  _  .
221 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
222 //====|=========================================================================
223     /**
224      * @dev emergency buy uses last stored affiliate ID and team snek
225      */
226     function()
227         isActivated()
228         isHuman()
229         isWithinLimits(msg.value)
230         public
231         payable
232     {
233         // set up our tx event data and determine if player is new or not
234         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
235             
236         // fetch player id
237         uint256 _pID = pIDxAddr_[msg.sender];
238         
239         // buy core 
240         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
241     }
242     
243     /**
244      * @dev converts all incoming ethereum to keys.
245      * -functionhash- 0x8f38f309 (using ID for affiliate)
246      * -functionhash- 0x98a0871d (using address for affiliate)
247      * -functionhash- 0xa65b37a1 (using name for affiliate)
248      * @param _affCode the ID/address/name of the player who gets the affiliate fee
249      * @param _team what team is the player playing for?
250      */
251     function buyXid(uint256 _affCode, uint256 _team)
252         isActivated()
253         isHuman()
254         isWithinLimits(msg.value)
255         public
256         payable
257     {
258         // set up our tx event data and determine if player is new or not
259         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
260         
261         // fetch player id
262         uint256 _pID = pIDxAddr_[msg.sender];
263         
264         if(plyr_[_affCode].addr==address(0))
265             _affCode = 0;
266         
267         // manage affiliate residuals
268         // if no affiliate code was given or player tried to use their own, lolz
269         if (_affCode == 0 || _affCode == _pID)
270         {
271             // use last stored affiliate code 
272             _affCode = plyr_[_pID].laff;
273             
274         // if affiliate code was given & its not the same as previously stored 
275         } else if (_affCode != plyr_[_pID].laff) {
276             // update last affiliate 
277             plyr_[_pID].laff = _affCode;
278         }
279         
280         // verify a valid team was selected
281         _team = verifyTeam(_team);
282         
283         // buy core 
284         buyCore(_pID, _affCode, _team, _eventData_);
285     }
286     
287     function buyXaddr(address _affCode, uint256 _team)
288         isActivated()
289         isHuman()
290         isWithinLimits(msg.value)
291         public
292         payable
293     {
294         // set up our tx event data and determine if player is new or not
295         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
296         
297         // fetch player id
298         uint256 _pID = pIDxAddr_[msg.sender];
299         
300         // manage affiliate residuals
301         uint256 _affID;
302         if(pIDxAddr_[_affCode]==0)
303             _affID = 0;
304         // if no affiliate code was given or player tried to use their own, lolz
305         if (_affCode == address(0) || _affCode == msg.sender)
306         {
307             // use last stored affiliate code
308             _affID = plyr_[_pID].laff;
309         
310         // if affiliate code was given    
311         } else {
312             // get affiliate ID from aff Code 
313             _affID = pIDxAddr_[_affCode];
314             
315             // if affID is not the same as previously stored 
316             if (_affID != plyr_[_pID].laff)
317             {
318                 // update last affiliate
319                 plyr_[_pID].laff = _affID;
320             }
321         }
322         
323         // verify a valid team was selected
324         _team = verifyTeam(_team);
325         
326         // buy core 
327         buyCore(_pID, _affID, _team, _eventData_);
328     }
329   
330     
331     /**
332      * @dev essentially the same as buy, but instead of you sending ether 
333      * from your wallet, it uses your unwithdrawn earnings.
334      * -functionhash- 0x349cdcac (using ID for affiliate)
335      * -functionhash- 0x82bfc739 (using address for affiliate)
336      * -functionhash- 0x079ce327 (using name for affiliate)
337      * @param _affCode the ID/address/name of the player who gets the affiliate fee
338      * @param _team what team is the player playing for?
339      * @param _eth amount of earnings to use (remainder returned to gen vault)
340      */
341     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
342         isActivated()
343         isHuman()
344         isWithinLimits(_eth)
345         public
346     {
347         // set up our tx event data
348         F3Ddatasets.EventReturns memory _eventData_;
349         
350         // fetch player ID
351         uint256 _pID = pIDxAddr_[msg.sender];
352         if(plyr_[_affCode].addr==address(0))
353            _affCode = 0;
354            
355         // manage affiliate residuals
356         // if no affiliate code was given or player tried to use their own, lolz
357         if (_affCode == 0 || _affCode == _pID)
358         {
359             // use last stored affiliate code 
360             _affCode = plyr_[_pID].laff;
361             
362         // if affiliate code was given & its not the same as previously stored 
363         } else if (_affCode != plyr_[_pID].laff) {
364             // update last affiliate 
365             plyr_[_pID].laff = _affCode;
366         }
367 
368         // verify a valid team was selected
369         _team = verifyTeam(_team);
370 
371         // reload core
372         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
373     }
374     
375     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
376         isActivated()
377         isHuman()
378         isWithinLimits(_eth)
379         public
380     {
381         // set up our tx event data
382         F3Ddatasets.EventReturns memory _eventData_;
383         
384         // fetch player ID
385         uint256 _pID = pIDxAddr_[msg.sender];
386         
387         // manage affiliate residuals
388         uint256 _affID;
389         if(pIDxAddr_[_affCode]==0)
390            _affCode = address(0);
391         // if no affiliate code was given or player tried to use their own, lolz
392         if (_affCode == address(0) || _affCode == msg.sender)
393         {
394             // use last stored affiliate code
395             _affID = plyr_[_pID].laff;
396         
397         // if affiliate code was given    
398         } else {
399             // get affiliate ID from aff Code 
400             _affID = pIDxAddr_[_affCode];
401             
402             // if affID is not the same as previously stored 
403             if (_affID != plyr_[_pID].laff)
404             {
405                 // update last affiliate
406                 plyr_[_pID].laff = _affID;
407             }
408         }
409         
410         // verify a valid team was selected
411         _team = verifyTeam(_team);
412         
413         // reload core
414         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
415     }
416 
417     /**
418      * @dev withdraws all of your earnings.
419      * -functionhash- 0x3ccfd60b
420      */
421     function withdraw()
422         isActivated()
423         isHuman()
424         public
425     {
426         // setup local rID 
427         uint256 _rID = rID_;
428         
429         // grab time
430         uint256 _now = now;
431         
432         // fetch player ID
433         uint256 _pID = pIDxAddr_[msg.sender];
434         
435         // setup temp var for player eth
436         uint256 _eth;
437         
438         // check to see if round has ended and no one has run round end yet
439         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
440         {
441             // set up our tx event data
442             F3Ddatasets.EventReturns memory _eventData_;
443             
444             // end the round (distributes pot)
445 			round_[_rID].ended = true;
446             _eventData_ = endRound(_eventData_);
447             
448 			// get their earnings
449             _eth = withdrawEarnings(_pID);
450             
451             // gib moni
452             if (_eth > 0)
453                 plyr_[_pID].addr.transfer(_eth);    
454             
455             // build event data
456             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
457             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
458             
459             // fire withdraw and distribute event
460             emit F3Devents.onWithdrawAndDistribute
461             (
462                 msg.sender, 
463                 plyr_[_pID].name, 
464                 _eth, 
465                 _eventData_.compressedData, 
466                 _eventData_.compressedIDs, 
467                 _eventData_.winnerAddr, 
468                 _eventData_.winnerId, 
469                 _eventData_.amountWon, 
470                 _eventData_.newPot, 
471                 0, 
472                 _eventData_.genAmount
473             );
474             
475         // in any other situation
476         } else {
477             // get their earnings
478             _eth = withdrawEarnings(_pID);
479             
480             // gib moni
481             if (_eth > 0)
482                 plyr_[_pID].addr.transfer(_eth);
483             
484             // fire withdraw event
485             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
486         }
487     }
488     
489     	function withdrawComB()
490         isActivated()
491         isHuman()
492         public
493         {
494               require(
495                 msg.sender == 0xD1CD0b21AE458D39992eFb110ff74DD839f91162 ||           
496     			msg.sender == 0xD1CD0b21AE458D39992eFb110ff74DD839f91162,
497                 "only team just can activate"
498             );
499           
500             require(comB_ > 0 , "Com balance = 0");
501     		 address director =0xD1CD0b21AE458D39992eFb110ff74DD839f91162;
502     		 director.transfer(comB_);
503     		 comB_=0;
504         }
505         
506 //==============================================================================
507 //     _  _ _|__|_ _  _ _  .
508 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
509 //=====_|=======================================================================
510     /**
511      * @dev return the price buyer will pay for next 1 individual key.
512      * -functionhash- 0x018a25e8
513      * @return price for next key bought (in wei format)
514      */
515     function getBuyPrice()
516         public 
517         view 
518         returns(uint256)
519     {  
520        /* // setup local rID
521         uint256 _rID = rID_;
522         
523         // grab time
524         uint256 _now = now;
525         
526         // are we in a round?
527         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
528             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
529         else // rounds over.  need price for new round
530             return ( 75000000000000 ); // init
531             */
532             return round_[rID_].keyPrice;
533     }
534     
535     /**
536      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
537      * provider
538      * -functionhash- 0xc7e284b8
539      * @return time left in seconds
540      */
541     function getTimeLeft()
542         public
543         view
544         returns(uint256)
545     {
546         // setup local rID
547         uint256 _rID = rID_;
548         
549         // grab time
550         uint256 _now = now;
551         
552         if (_now < round_[_rID].end)
553             if (_now > round_[_rID].strt )
554                 return( (round_[_rID].end).sub(_now) );
555             else
556                 return( (round_[_rID].strt ).sub(_now) );
557         else
558             return(0);
559     }
560     
561     /**
562      * @dev returns player earnings per vaults 
563      * -functionhash- 0x63066434
564      * @return winnings vault
565      * @return general vault
566      * @return affiliate vault
567      */
568     function getPlayerVaults(uint256 _pID)
569         public
570         view
571         returns(uint256 ,uint256, uint256)
572     {
573         // setup local rID
574         uint256 _rID = rID_;
575         
576         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
577         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
578         {
579             // if player is winner 
580             if (round_[_rID].plyr == _pID)
581             {
582                 return
583                 (
584                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
585                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
586                     plyr_[_pID].aff
587                 );
588             // if player is not the winner
589             } else {
590                 return
591                 (
592                     plyr_[_pID].win,
593                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
594                     plyr_[_pID].aff
595                 );
596             }
597             
598         // if round is still going on, or round has ended and round end has been ran
599         } else {
600             return
601             (
602                 plyr_[_pID].win,
603                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
604                 plyr_[_pID].aff
605             );
606         }
607     }
608     
609     /**
610      * solidity hates stack limits.  this lets us avoid that hate 
611      */
612     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
613         private
614         view
615         returns(uint256)
616     {
617         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
618     }
619     
620     /**
621      * @dev returns all current round info needed for front end
622      * -functionhash- 0x747dff42
623      * @return eth invested during ICO phase
624      * @return round id 
625      * @return total keys for round 
626      * @return time round ends
627      * @return time round started
628      * @return current pot 
629      * @return current team ID & player ID in lead 
630      * @return current player in leads address 
631      * @return current player in leads name
632      * @return whales eth in for round
633      * @return bears eth in for round
634      * @return sneks eth in for round
635      * @return bulls eth in for round
636      * @return airdrop tracker # & airdrop pot
637      */
638     function getCurrentRoundInfo()
639         public
640         view
641         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
642     {
643         // setup local rID
644         uint256 _rID = rID_;
645         
646         return
647         (
648             round_[_rID].ico,               //0
649             _rID,                           //1
650             round_[_rID].keys,              //2
651             round_[_rID].end,               //3
652             round_[_rID].strt,              //4
653             round_[_rID].pot,               //5
654             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
655             plyr_[round_[_rID].plyr].addr,  //7
656             plyr_[round_[_rID].plyr].name,  //8
657             rndTmEth_[_rID][0],             //9
658             rndTmEth_[_rID][1],             //10
659             rndTmEth_[_rID][2],             //11
660             rndTmEth_[_rID][3],             //12
661            0              //13
662         );
663     }
664 
665     /**
666      * @dev returns player info based on address.  if no address is given, it will 
667      * use msg.sender 
668      * -functionhash- 0xee0b5d8b
669      * @param _addr address of the player you want to lookup 
670      * @return player ID 
671      * @return player name
672      * @return keys owned (current round)
673      * @return winnings vault
674      * @return general vault 
675      * @return affiliate vault 
676 	 * @return player round eth
677      */
678     function getPlayerInfoByAddress(address _addr)
679         public 
680         view 
681         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
682     {
683         // setup local rID
684         uint256 _rID = rID_;
685         
686         if (_addr == address(0))
687         {
688             _addr == msg.sender;
689         }
690         uint256 _pID = pIDxAddr_[_addr];
691         
692         return
693         (
694             _pID,                               //0
695             plyr_[_pID].name,                   //1
696             plyrRnds_[_pID][_rID].keys,         //2
697             plyr_[_pID].win,                    //3
698             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
699             plyr_[_pID].aff,                    //5
700             plyrRnds_[_pID][_rID].eth           //6
701         );
702     }
703 
704 //==============================================================================
705 //     _ _  _ _   | _  _ . _  .
706 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
707 //=====================_|=======================================================
708     /**
709      * @dev logic runs whenever a buy order is executed.  determines how to handle 
710      * incoming eth depending on if we are in an active round or not
711      */
712     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
713         private
714     {
715         // setup local rID
716         uint256 _rID = rID_;
717         
718         // grab time
719         uint256 _now = now;
720         
721         // if round is active
722         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
723         {
724             // call core 
725             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
726         
727         // if round is not active     
728         } else {
729             // check to see if end round needs to be ran
730             if (_now > round_[_rID].end && round_[_rID].ended == false) 
731             {
732                 // end the round (distributes pot) & start new round
733 			    round_[_rID].ended = true;
734                 _eventData_ = endRound(_eventData_);
735                 
736                 // build event data
737                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
738                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
739                 
740                 // fire buy and distribute event 
741                 emit F3Devents.onBuyAndDistribute
742                 (
743                     msg.sender, 
744                     plyr_[_pID].name, 
745                     msg.value, 
746                     _eventData_.compressedData, 
747                     _eventData_.compressedIDs, 
748                     _eventData_.winnerAddr, 
749                     _eventData_.winnerId, 
750                     _eventData_.amountWon, 
751                     _eventData_.newPot, 
752                     0, 
753                     _eventData_.genAmount
754                 );
755             }
756             
757             // put eth in players vault 
758             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
759         }
760     }
761     
762     /**
763      * @dev logic runs whenever a reload order is executed.  determines how to handle 
764      * incoming eth depending on if we are in an active round or not 
765      */
766     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
767         private
768     {
769         // setup local rID
770         uint256 _rID = rID_;
771         
772         // grab time
773         uint256 _now = now;
774         
775         // if round is active
776         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
777         {
778             // get earnings from all vaults and return unused to gen vault
779             // because we use a custom safemath library.  this will throw if player 
780             // tried to spend more eth than they have.
781             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
782             
783             // call core 
784             core(_rID, _pID, _eth, _affID, _team, _eventData_);
785         
786         // if round is not active and end round needs to be ran   
787         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
788             // end the round (distributes pot) & start new round
789             round_[_rID].ended = true;
790             _eventData_ = endRound(_eventData_);
791                 
792             // build event data
793             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
794             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
795                 
796             // fire buy and distribute event 
797             emit F3Devents.onReLoadAndDistribute
798             (
799                 msg.sender, 
800                 plyr_[_pID].name, 
801                 _eventData_.compressedData, 
802                 _eventData_.compressedIDs, 
803                 _eventData_.winnerAddr, 
804                 _eventData_.winnerId, 
805                 _eventData_.amountWon, 
806                 _eventData_.newPot, 
807                 0, 
808                 _eventData_.genAmount
809             );
810         }
811     }
812     
813     /**
814      * @dev this is the core logic for any buy/reload that happens while a round 
815      * is live.
816      */
817     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
818         private
819     {
820         // if player is new to round
821         if (plyrRnds_[_pID][_rID].keys == 0)
822             _eventData_ = managePlayer(_pID, _eventData_);
823         
824         // if eth left is greater than min eth allowed (sorry no pocket lint)
825         if (_eth > 1000000000) 
826         {
827             
828             // mint the new keys
829             uint256 _keys = (_eth.mul(1000000000000000000) / round_[_rID].keyPrice);
830             
831             // if they bought at least 1 whole key
832             if (_keys >= 1000000000000000000)
833             {
834                 
835             round_[_rID].keyPrice = round_[_rID].keyPrice.add(10000000000000);//update key price
836             updateTimer(_keys, _rID);
837 
838             // set new leaders
839             if (round_[_rID].plyr != _pID)
840                 round_[_rID].plyr = _pID;  
841             if (round_[_rID].team != _team)
842                 round_[_rID].team = _team; 
843             
844             // set the new leader bool to true
845             _eventData_.compressedData = _eventData_.compressedData + 100;
846             }
847             
848             // update player 
849             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
850             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
851             
852             // update round
853             round_[_rID].keys = _keys.add(round_[_rID].keys);
854             round_[_rID].eth = _eth.add(round_[_rID].eth);
855             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
856     
857             // distribute eth
858             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
859             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
860             
861             // call end tx function to fire end tx event.
862 		    endTx(_pID, _team, _eth, _keys, _eventData_);
863         }
864     }
865 //==============================================================================
866 //     _ _ | _   | _ _|_ _  _ _  .
867 //    (_(_||(_|_||(_| | (_)| _\  .
868 //==============================================================================
869     /**
870      * @dev calculates unmasked earnings (just calculates, does not update mask)
871      * @return earnings in wei format
872      */
873     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
874         private
875         view
876         returns(uint256)
877     {
878         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
879     }
880     
881     /** 
882      * @dev returns the amount of keys you would get given an amount of eth. 
883      * -functionhash- 0xce89c80c
884      * @param _rID round ID you want price for
885      * @param _eth amount of eth sent in 
886      * @return keys received 
887      */
888     function calcKeysReceived(uint256 _rID, uint256 _eth)
889         public
890         view
891         returns(uint256)
892     {
893         return ( _eth.mul(1000000000000000000) / round_[_rID].keyPrice);
894     }
895     
896     /** 
897      * @dev returns current eth price for X keys.  
898      * -functionhash- 0xcf808000
899      * @param _keys number of keys desired (in 18 decimal format)
900      * @return amount of eth needed to send
901      */
902     function iWantXKeys(uint256 _keys)
903         public
904         view
905         returns(uint256)
906     {
907         // setup local rID
908         uint256 _rID = rID_;
909         return _keys.mul(round_[_rID].keyPrice);
910     }
911 //==============================================================================
912 //    _|_ _  _ | _  .
913 //     | (_)(_)|_\  .
914 //==============================================================================
915      /**
916      * @dev gets existing or registers new pID.  use this when a player may be new
917      * @return pID 
918      */
919     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
920         private
921         returns (F3Ddatasets.EventReturns)
922     {
923         uint256 _pID = pIDxAddr_[msg.sender];
924         // if player is new to this version of fomo3d
925         if (_pID == 0)
926         {
927             // grab their player ID, name and last aff ID, from player names contract 
928             userCount_=userCount_+1;
929             _pID =userCount_;
930          
931             // set up player account 
932             pIDxAddr_[msg.sender] = _pID;
933             plyr_[_pID].addr = msg.sender;
934        
935             // set the new player bool to true
936             _eventData_.compressedData = _eventData_.compressedData + 1;
937         } 
938         return (_eventData_);
939     }
940     
941     /**
942      * @dev checks to make sure user picked a valid team.  if not sets team 
943      * to default (sneks)
944      */
945     function verifyTeam(uint256 _team)
946         private
947         pure
948         returns (uint256)
949     {
950         if (_team < 0 || _team > 1)
951             return(0);
952         else
953             return(_team);
954     }
955     
956     /**
957      * @dev decides if round end needs to be run & new round started.  and if 
958      * player unmasked earnings from previously played rounds need to be moved.
959      */
960     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
961         private
962         returns (F3Ddatasets.EventReturns)
963     {
964         // if player has played a previous round, move their unmasked earnings
965         // from that round to gen vault.
966         if (plyr_[_pID].lrnd != 0)
967             updateGenVault(_pID, plyr_[_pID].lrnd);
968             
969         // update player's last round played
970         plyr_[_pID].lrnd = rID_;
971             
972         // set the joined round bool to true
973         _eventData_.compressedData = _eventData_.compressedData + 10;
974         
975         return(_eventData_);
976     }
977     
978     /**
979      * @dev ends the round. manages paying out winner/splitting up pot
980      */
981     function endRound(F3Ddatasets.EventReturns memory _eventData_)
982         private
983         returns (F3Ddatasets.EventReturns)
984     {
985         // setup local rID
986         uint256 _rID = rID_;
987         
988         // grab our winning player and team id's
989         uint256 _winPID = round_[_rID].plyr;
990         uint256 _winTID = round_[_rID].team;
991         
992         // grab our pot amount
993         uint256 _pot = round_[_rID].pot;
994         
995         // calculate our winner share, community rewards, gen share, 
996         // p3d share, and amount reserved for next pot 
997         uint256 _win = (_pot.mul(potSplit_[_winTID].win)) / 100;
998         uint256 _com = (_pot / 10);
999         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1000         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));   //next round pot
1001         
1002         // calculate ppt for round mask
1003         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1004         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1005         if (_dust > 0)
1006         {
1007             _gen = _gen.sub(_dust);
1008             _res = _res.add(_dust);
1009         }
1010         
1011         // pay our winner
1012         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1013         
1014         //pay to com
1015         comB_=comB_.add(_com);
1016        
1017         // distribute gen portion to key holders
1018         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1019         
1020             
1021         // prepare event data
1022         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1023         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1024         _eventData_.winnerAddr = plyr_[_winPID].addr;
1025         _eventData_.winnerId = _winPID;
1026         _eventData_.amountWon = _win;
1027         _eventData_.genAmount = _gen;
1028         _eventData_.P3DAmount = 0;
1029         _eventData_.newPot = _res;
1030         
1031         // start next round
1032         rID_++;
1033         _rID++;
1034         round_[_rID].strt = now;
1035         round_[_rID].end = now.add(rndInit_);
1036         round_[_rID].pot = _res;
1037         round_[_rID].keyPrice=100000000000000;
1038         
1039         return(_eventData_);
1040     }
1041     
1042     /**
1043      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1044      */
1045     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1046         private 
1047     {
1048         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1049         if (_earnings > 0)
1050         {
1051             // put in gen vault
1052             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1053             // zero out their earnings by updating mask
1054             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1055         }
1056     }
1057     
1058     /**
1059      * @dev updates round timer based on number of whole keys bought.
1060      */
1061     function updateTimer(uint256 _keys, uint256 _rID)
1062         private
1063     {
1064         // grab time
1065         uint256 _now = now;
1066         
1067         // calculate time based on number of keys bought
1068         uint256 _newTime;
1069         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1070             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1071         else
1072             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1073         
1074         // compare to max and set new end time
1075         if (_newTime < (rndMax_).add(_now))
1076             round_[_rID].end = _newTime;
1077         else
1078             round_[_rID].end = rndMax_.add(_now);
1079     }
1080  
1081     /**
1082      * @dev distributes eth based on fees to com, aff, and p3d
1083      */
1084     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1085         private
1086         returns(F3Ddatasets.EventReturns)
1087     {
1088         // pay 7% out to community rewards
1089         uint256 _com = _eth * 7 / 100;
1090         comB_=comB_.add(_com);
1091         
1092         // distribute share to affiliate
1093         uint256 _aff = _eth / 10;
1094         
1095         // decide what to do with affiliate share of fees
1096         // affiliate must not be self, and must have a name registered
1097         if (_affID != _pID && _affID != 0) {
1098             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1099             plyr_[_pID].laff=_affID;
1100             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1101         } else {
1102              plyr_[1].gen=plyr_[1].gen.add(_aff);
1103         }
1104         return(_eventData_);
1105     }
1106     
1107     /**
1108      * @dev distributes eth based on fees to gen and pot
1109      */
1110     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1111         private
1112         returns(F3Ddatasets.EventReturns)
1113     {
1114         // calculate gen share
1115         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1116         
1117         // toss 1% into airdrop pot 
1118         //uint256 _air = (_eth / 100);
1119         //airDropPot_ = airDropPot_.add(_air);
1120         
1121         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1122         _eth = _eth.sub(_eth.mul(17) / 100);
1123         
1124         // calculate pot 
1125         uint256 _pot = _eth.sub(_gen);
1126         
1127         // distribute gen share (thats what updateMasks() does) and adjust
1128         // balances for dust.
1129         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1130         if (_dust > 0)
1131             _gen = _gen.sub(_dust);
1132         
1133         // add eth to pot
1134         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1135         
1136         // set up event data
1137         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1138         _eventData_.potAmount = _pot;
1139         
1140         return(_eventData_);
1141     }
1142 
1143     /**
1144      * @dev updates masks for round and player when keys are bought
1145      * @return dust left over 
1146      */
1147     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1148         private
1149         returns(uint256)
1150     {
1151         /* MASKING NOTES
1152             earnings masks are a tricky thing for people to wrap their minds around.
1153             the basic thing to understand here.  is were going to have a global
1154             tracker based on profit per share for each round, that increases in
1155             relevant proportion to the increase in share supply.
1156             
1157             the player will have an additional mask that basically says "based
1158             on the rounds mask, my shares, and how much i've already withdrawn,
1159             how much is still owed to me?"
1160         */
1161         
1162         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1163         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1164         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1165             
1166         // calculate player earning from their own buy (only based on the keys
1167         // they just bought).  & update player earnings mask
1168         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1169         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1170         
1171         // calculate & return dust
1172         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1173     }
1174     
1175     /**
1176      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1177      * @return earnings in wei format
1178      */
1179     function withdrawEarnings(uint256 _pID)
1180         private
1181         returns(uint256)
1182     {
1183         // update gen vault
1184         updateGenVault(_pID, plyr_[_pID].lrnd);
1185         
1186         // from vaults 
1187         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1188         if (_earnings > 0)
1189         {
1190             plyr_[_pID].win = 0;
1191             plyr_[_pID].gen = 0;
1192             plyr_[_pID].aff = 0;
1193         }
1194 
1195         return(_earnings);
1196     }
1197     
1198     /**
1199      * @dev prepares compression data and fires event for buy or reload tx's
1200      */
1201     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1202         private
1203     {
1204         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1205         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1206         
1207         emit F3Devents.onEndTx
1208         (
1209             _eventData_.compressedData,
1210             _eventData_.compressedIDs,
1211             plyr_[_pID].name,
1212             msg.sender,
1213             _eth,
1214             _keys,
1215             _eventData_.winnerAddr,
1216             _eventData_.winnerId,
1217             _eventData_.amountWon,
1218             _eventData_.newPot,
1219             0,
1220             _eventData_.genAmount,
1221             _eventData_.potAmount,
1222             0
1223         );
1224     }
1225 //==============================================================================
1226 //    (~ _  _    _._|_    .
1227 //    _)(/_(_|_|| | | \/  .
1228 //====================/=========================================================
1229     /** upon contract deploy, it will be deactivated.  this is a one time
1230      * use function that will activate the contract.  we do this so devs 
1231      * have time to set things up on the web end                            **/
1232     bool public activated_ = false;
1233     function activate()
1234         public
1235     {
1236         // only team just can activate 
1237         require(
1238             msg.sender == 0xD1CD0b21AE458D39992eFb110ff74DD839f91162 ||
1239 			msg.sender == 0xD1CD0b21AE458D39992eFb110ff74DD839f91162,
1240             "only team just can activate"
1241         );
1242 
1243         // can only be ran once
1244         require(activated_ == false, "fomo3d already activated");
1245         
1246         // activate the contract 
1247         activated_ = true;
1248         
1249         // lets start first round
1250 		rID_ = 1;
1251         round_[1].strt = now + rndExtra_;
1252         round_[1].end = now + rndInit_ + rndExtra_;
1253         round_[1].keyPrice=100000000000000;
1254         
1255          pIDxAddr_[0xD1CD0b21AE458D39992eFb110ff74DD839f91162] = 1;
1256          plyr_[1].addr = 0xD1CD0b21AE458D39992eFb110ff74DD839f91162;
1257     }
1258 }
1259 
1260 //==============================================================================
1261 //   __|_ _    __|_ _  .
1262 //  _\ | | |_|(_ | _\  .
1263 //==============================================================================
1264 library F3Ddatasets {
1265     //compressedData key
1266     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1267         // 0 - new player (bool)
1268         // 1 - joined round (bool)
1269         // 2 - new  leader (bool)
1270         // 3-5 - air drop tracker (uint 0-999)
1271         // 6-16 - round end time
1272         // 17 - winnerTeam
1273         // 18 - 28 timestamp 
1274         // 29 - team
1275         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1276         // 31 - airdrop happened bool
1277         // 32 - airdrop tier 
1278         // 33 - airdrop amount won
1279     //compressedIDs key
1280     // [77-52][51-26][25-0]
1281         // 0-25 - pID 
1282         // 26-51 - winPID
1283         // 52-77 - rID
1284     struct EventReturns {
1285         uint256 compressedData;
1286         uint256 compressedIDs;
1287         address winnerAddr;         // winner address
1288         uint256 winnerId;         // winner Id
1289         uint256 amountWon;          // amount won
1290         uint256 newPot;             // amount in new pot
1291         uint256 P3DAmount;          // amount distributed to p3d
1292         uint256 genAmount;          // amount distributed to gen
1293         uint256 potAmount;          // amount added to pot
1294     }
1295     struct Player {
1296         address addr;   // player address
1297         bytes32 name;   // player name
1298         uint256 win;    // winnings vault
1299         uint256 gen;    // general vault
1300         uint256 aff;    // affiliate vault
1301         uint256 lrnd;   // last round played
1302         uint256 laff;   // last affiliate id used
1303     }
1304     struct PlayerRounds {
1305         uint256 eth;    // eth player has added to round (used for eth limiter)
1306         uint256 keys;   // keys
1307         uint256 mask;   // player mask 
1308         uint256 ico;    // ICO phase investment
1309     }
1310     struct Round {
1311         uint256 plyr;   // pID of player in lead
1312         uint256 team;   // tID of team in lead
1313         uint256 end;    // time ends/ended
1314         bool ended;     // has round end function been ran
1315         uint256 strt;   // time round started
1316         uint256 keys;   // keys
1317         uint256 keyPrice; //key price
1318         uint256 eth;    // total eth in
1319         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1320         uint256 mask;   // global mask
1321         uint256 ico;    // total eth sent in during ICO phase
1322         uint256 icoGen; // total eth for gen during ICO phase
1323         uint256 icoAvg; // average key price for ICO phase
1324     }
1325     struct TeamFee {
1326         uint256 gen;    // % of buy in thats paid to key holders of current round
1327         uint256 p3d;    // % of buy in thats paid to p3d holders
1328     }
1329     struct PotSplit {
1330         uint256 gen;    // % of pot thats paid to key holders of current round
1331         uint256 win;    // % of pot thats paid to winner
1332     }
1333 }
1334 
1335 //==============================================================================
1336 //  |  _      _ _ | _  .
1337 //  |<(/_\/  (_(_||(_  .
1338 //=======/======================================================================
1339 library F3DKeysCalcLong {
1340     using SafeMath for *;
1341     
1342     /**
1343      * @dev calculates number of keys received given X eth
1344      * @param _eth current amount of eth in contract
1345      * @param _keyPrice eth being spent
1346      * @return amount of ticket purchased
1347      */
1348     function keysRec(uint256 _eth, uint256 _keyPrice)
1349         internal
1350         pure
1351         returns (uint256)
1352     {
1353         return (_eth/_keyPrice);
1354     }
1355 
1356     /**
1357      * @dev calculates amount of eth received if you sold X keys
1358      * @param _keys current amount of keys that exist
1359      * @param _keyPrice amount of keys you wish to sell
1360      * @return amount of eth received
1361      */
1362     function ethRec(uint256 _keys, uint256 _keyPrice)
1363         internal
1364         pure
1365         returns (uint256)
1366     {
1367         return( _keys.mul(_keyPrice));
1368     }
1369 }
1370 
1371 //==============================================================================
1372 //  . _ _|_ _  _ |` _  _ _  _  .
1373 //  || | | (/_| ~|~(_|(_(/__\  .
1374 //==============================================================================
1375 
1376 
1377 interface F3DexternalSettingsInterface {
1378     function getFastGap() external returns(uint256);
1379     function getLongGap() external returns(uint256);
1380     function getFastExtra() external returns(uint256);
1381     function getLongExtra() external returns(uint256);
1382 }
1383 
1384 interface DiviesInterface {
1385     function deposit() external payable;
1386 }
1387 
1388 interface JIincForwarderInterface {
1389     function deposit() external payable returns(bool);
1390     function status() external view returns(address, address, bool);
1391     function startMigration(address _newCorpBank) external returns(bool);
1392     function cancelMigration() external returns(bool);
1393     function finishMigration() external returns(bool);
1394     function setup(address _firstCorpBank) external;
1395 }
1396 
1397 interface PlayerBookInterface {
1398     function getPlayerID(address _addr) external returns (uint256);
1399     function getPlayerName(uint256 _pID) external view returns (bytes32);
1400     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1401     function getPlayerAddr(uint256 _pID) external view returns (address);
1402     function getNameFee() external view returns (uint256);
1403     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1404     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1405     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1406 }
1407 
1408 /**
1409 * @title -Name Filter- v0.1.9
1410 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1411 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1412 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1413 *                                  _____                      _____
1414 *                                 (, /     /)       /) /)    (, /      /)          /)
1415 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1416 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1417 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1418 *                            (__ /          (_/ (, /                                      /)™ 
1419 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1420 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1421 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1422 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1423 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1424 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1425 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1426 *
1427 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1428 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1429 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1430 */
1431 
1432 /**
1433  * @title SafeMath v0.1.9
1434  * @dev Math operations with safety checks that throw on error
1435  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1436  * - added sqrt
1437  * - added sq
1438  * - added pwr 
1439  * - changed asserts to requires with error log outputs
1440  * - removed div, its useless
1441  */
1442 library SafeMath {
1443     
1444     /**
1445     * @dev Multiplies two numbers, throws on overflow.
1446     */
1447     function mul(uint256 a, uint256 b) 
1448         internal 
1449         pure 
1450         returns (uint256 c) 
1451     {
1452         if (a == 0) {
1453             return 0;
1454         }
1455         c = a * b;
1456         require(c / a == b, "SafeMath mul failed");
1457         return c;
1458     }
1459 
1460     /**
1461     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1462     */
1463     function sub(uint256 a, uint256 b)
1464         internal
1465         pure
1466         returns (uint256) 
1467     {
1468         require(b <= a, "SafeMath sub failed");
1469         return a - b;
1470     }
1471 
1472     /**
1473     * @dev Adds two numbers, throws on overflow.
1474     */
1475     function add(uint256 a, uint256 b)
1476         internal
1477         pure
1478         returns (uint256 c) 
1479     {
1480         c = a + b;
1481         require(c >= a, "SafeMath add failed");
1482         return c;
1483     }
1484     
1485     /**
1486      * @dev gives square root of given x.
1487      */
1488     function sqrt(uint256 x)
1489         internal
1490         pure
1491         returns (uint256 y) 
1492     {
1493         uint256 z = ((add(x,1)) / 2);
1494         y = x;
1495         while (z < y) 
1496         {
1497             y = z;
1498             z = ((add((x / z),z)) / 2);
1499         }
1500     }
1501     
1502     /**
1503      * @dev gives square. multiplies x by x
1504      */
1505     function sq(uint256 x)
1506         internal
1507         pure
1508         returns (uint256)
1509     {
1510         return (mul(x,x));
1511     }
1512     
1513     /**
1514      * @dev x to the power of y 
1515      */
1516     function pwr(uint256 x, uint256 y)
1517         internal 
1518         pure 
1519         returns (uint256)
1520     {
1521         if (x==0)
1522             return (0);
1523         else if (y==0)
1524             return (1);
1525         else 
1526         {
1527             uint256 z = x;
1528             for (uint256 i=1; i < y; i++)
1529                 z = mul(z,x);
1530             return (z);
1531         }
1532     }
1533 }