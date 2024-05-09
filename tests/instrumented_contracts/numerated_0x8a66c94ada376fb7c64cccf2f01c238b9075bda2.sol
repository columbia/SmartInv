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
32         bytes32 winnerName,
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
60         bytes32 winnerName,
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
77         bytes32 winnerName,
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
93         bytes32 winnerName,
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
124 
125 contract modularLong is F3Devents {}
126 
127 contract FengJinFoMo3D is modularLong {
128     using SafeMath for *;
129     using NameFilter for string;
130     using F3DKeysCalcLong for uint256;
131 	
132 	// otherFoMo3D private otherF3D_;
133     // DiviesInterface constant private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
134 	address specAddr = 0xF51E57F12ED5d44761d4480633FD6c5632A5B2B1; 
135     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
136 	// PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xD60d353610D9a5Ca478769D371b53CEfAA7B6E4c);
137     // F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
138 //==============================================================================
139 //     _ _  _  |`. _     _ _ |_ | _  _  .
140 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
141 //=================_|===========================================================
142     string constant public name = "FengJin FoMo3D Long";
143     string constant public symbol = "FJ3D";
144 	// uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO 
145     // uint256 private rndGap_ = extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
146     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
147     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
148     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
149 //==============================================================================
150 //     _| _ _|_ _    _ _ _|_    _   .
151 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
152 //=============================|================================================
153 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
154     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
155     uint256 public rID_;    // round id number / total rounds that have happened
156 //****************
157 // PLAYER DATA 
158 //****************
159 	uint256 private pIDxCount;
160     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
161     // mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
162     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
163     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
164     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
165 //****************
166 // ROUND DATA 
167 //****************
168     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
169     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
170 //****************
171 // TEAM FEE DATA 
172 //****************
173     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
174     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
175 //==============================================================================
176 //     _ _  _  __|_ _    __|_ _  _  .
177 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
178 //==============================================================================
179     constructor()
180         public
181     {
182 		// Team allocation structures
183         // 0 = whales
184         // 1 = bears
185         // 2 = sneks
186         // 3 = bulls
187 
188 		// Team allocation percentages
189         // (F3D, P3D) + (Pot , Referrals, Community)
190         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
191         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
192         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
193         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
194         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
195         
196         // how to split up the final pot based on which team was picked
197         // (F3D, P3D)
198         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
199         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
200         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
201         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
202 	}
203 //==============================================================================
204 //     _ _  _  _|. |`. _  _ _  .
205 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
206 //==============================================================================
207     /**
208      * @dev used to make sure no one can interact with contract until it has 
209      * been activated. 
210      */
211     modifier isActivated() {
212         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
213         _;
214     }
215     
216     /**
217      * @dev prevents contracts from interacting with fomo3d 
218      */
219     modifier isHuman() {
220         address _addr = msg.sender;
221         uint256 _codeLength;
222         
223         assembly {_codeLength := extcodesize(_addr)}
224         require(_codeLength == 0, "sorry humans only");
225         _;
226     }
227 
228     /**
229      * @dev sets boundaries for incoming tx 
230      */
231     modifier isWithinLimits(uint256 _eth) {
232         require(_eth >= 1000000000, "pocket lint: not a valid currency");
233         require(_eth <= 100000000000000000000000, "no vitalik, no");
234         _;    
235     }
236     
237 //==============================================================================
238 //     _    |_ |. _   |`    _  __|_. _  _  _  .
239 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
240 //====|=========================================================================
241     /**
242      * @dev emergency buy uses last stored affiliate ID and team snek
243      */
244     function()
245         isActivated()
246         isHuman()
247         isWithinLimits(msg.value)
248         public
249         payable
250     {
251         // set up our tx event data and determine if player is new or not
252         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
253             
254         // fetch player id
255         uint256 _pID = pIDxAddr_[msg.sender];
256         
257         // buy core 
258         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
259     }
260     
261     /**
262      * @dev converts all incoming ethereum to keys.
263      * -functionhash- 0x8f38f309 (using ID for affiliate)
264      * -functionhash- 0x98a0871d (using address for affiliate)
265      * -functionhash- 0xa65b37a1 (using name for affiliate)
266      * @param _affCode the ID/address/name of the player who gets the affiliate fee
267      * @param _team what team is the player playing for?
268      */
269     function buyXid(uint256 _affCode, uint256 _team)
270         isActivated()
271         isHuman()
272         isWithinLimits(msg.value)
273         public
274         payable
275     {
276         // set up our tx event data and determine if player is new or not
277         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
278         
279         // fetch player id
280         uint256 _pID = pIDxAddr_[msg.sender];
281         
282         // manage affiliate residuals
283         // if no affiliate code was given or player tried to use their own, lolz
284         if (_affCode == 0 || _affCode == _pID)
285         {
286             // use last stored affiliate code 
287             _affCode = plyr_[_pID].laff;
288             
289         // if affiliate code was given & its not the same as previously stored 
290         } else if (_affCode != plyr_[_pID].laff) {
291             // update last affiliate 
292             plyr_[_pID].laff = _affCode;
293         }
294         
295         // verify a valid team was selected
296         _team = verifyTeam(_team);
297         
298         // buy core 
299         buyCore(_pID, _affCode, _team, _eventData_);
300     }
301     
302     function buyXaddr(address _affCode, uint256 _team)
303         isActivated()
304         isHuman()
305         isWithinLimits(msg.value)
306         public
307         payable
308     {
309         // set up our tx event data and determine if player is new or not
310         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
311         
312         // fetch player id
313         uint256 _pID = pIDxAddr_[msg.sender];
314         
315         // manage affiliate residuals
316         uint256 _affID;
317         // if no affiliate code was given or player tried to use their own, lolz
318         if (_affCode == address(0) || _affCode == msg.sender)
319         {
320             // use last stored affiliate code
321             _affID = plyr_[_pID].laff;
322         
323         // if affiliate code was given    
324         } else {
325             // get affiliate ID from aff Code 
326             _affID = pIDxAddr_[_affCode];
327             
328             // if affID is not the same as previously stored 
329             if (_affID != plyr_[_pID].laff)
330             {
331                 // update last affiliate
332                 plyr_[_pID].laff = _affID;
333             }
334         }
335         
336         // verify a valid team was selected
337         _team = verifyTeam(_team);
338         
339         // buy core 
340         buyCore(_pID, _affID, _team, _eventData_);
341     }
342     
343     function buyXname(bytes32 _affCode, uint256 _team)
344         isActivated()
345         isHuman()
346         isWithinLimits(msg.value)
347         public
348         payable
349     {
350         // set up our tx event data and determine if player is new or not
351         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
352         
353         // fetch player id
354         uint256 _pID = pIDxAddr_[msg.sender];
355         
356         // manage affiliate residuals
357         uint256 _affID;
358         // if no affiliate code was given or player tried to use their own, lolz
359         if (_affCode == '' || _affCode == plyr_[_pID].name)
360         {
361             // use last stored affiliate code
362             _affID = plyr_[_pID].laff;
363         
364         // if affiliate code was given
365         } else {
366 			/*
367             // get affiliate ID from aff Code
368             _affID = pIDxName_[_affCode];
369             
370             // if affID is not the same as previously stored
371             if (_affID != plyr_[_pID].laff)
372             {
373                 // update last affiliate
374                 plyr_[_pID].laff = _affID;
375             }
376 			*/
377         }
378         
379         // verify a valid team was selected
380         _team = verifyTeam(_team);
381         
382         // buy core 
383         buyCore(_pID, _affID, _team, _eventData_);
384     }
385     
386     /**
387      * @dev essentially the same as buy, but instead of you sending ether 
388      * from your wallet, it uses your unwithdrawn earnings.
389      * -functionhash- 0x349cdcac (using ID for affiliate)
390      * -functionhash- 0x82bfc739 (using address for affiliate)
391      * -functionhash- 0x079ce327 (using name for affiliate)
392      * @param _affCode the ID/address/name of the player who gets the affiliate fee
393      * @param _team what team is the player playing for?
394      * @param _eth amount of earnings to use (remainder returned to gen vault)
395      */
396     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
397         isActivated()
398         isHuman()
399         isWithinLimits(_eth)
400         public
401     {
402         // set up our tx event data
403         F3Ddatasets.EventReturns memory _eventData_;
404         
405         // fetch player ID
406         uint256 _pID = pIDxAddr_[msg.sender];
407         
408         // manage affiliate residuals
409         // if no affiliate code was given or player tried to use their own, lolz
410         if (_affCode == 0 || _affCode == _pID)
411         {
412             // use last stored affiliate code 
413             _affCode = plyr_[_pID].laff;
414             
415         // if affiliate code was given & its not the same as previously stored 
416         } else if (_affCode != plyr_[_pID].laff) {
417             // update last affiliate 
418             plyr_[_pID].laff = _affCode;
419         }
420 
421         // verify a valid team was selected
422         _team = verifyTeam(_team);
423 
424         // reload core
425         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
426     }
427     
428     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
429         isActivated()
430         isHuman()
431         isWithinLimits(_eth)
432         public
433     {
434         // set up our tx event data
435         F3Ddatasets.EventReturns memory _eventData_;
436         
437         // fetch player ID
438         uint256 _pID = pIDxAddr_[msg.sender];
439         
440         // manage affiliate residuals
441         uint256 _affID;
442         // if no affiliate code was given or player tried to use their own, lolz
443         if (_affCode == address(0) || _affCode == msg.sender)
444         {
445             // use last stored affiliate code
446             _affID = plyr_[_pID].laff;
447         
448         // if affiliate code was given    
449         } else {
450             // get affiliate ID from aff Code 
451             _affID = pIDxAddr_[_affCode];
452             
453             // if affID is not the same as previously stored 
454             if (_affID != plyr_[_pID].laff)
455             {
456                 // update last affiliate
457                 plyr_[_pID].laff = _affID;
458             }
459         }
460         
461         // verify a valid team was selected
462         _team = verifyTeam(_team);
463         
464         // reload core
465         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
466     }
467     
468     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
469         isActivated()
470         isHuman()
471         isWithinLimits(_eth)
472         public
473     {
474         // set up our tx event data
475         F3Ddatasets.EventReturns memory _eventData_;
476         
477         // fetch player ID
478         uint256 _pID = pIDxAddr_[msg.sender];
479         
480         // manage affiliate residuals
481         uint256 _affID;
482         // if no affiliate code was given or player tried to use their own, lolz
483         if (_affCode == '' || _affCode == plyr_[_pID].name)
484         {
485             // use last stored affiliate code
486             _affID = plyr_[_pID].laff;
487         
488         // if affiliate code was given
489         } else {
490             // get affiliate ID from aff Code
491 			/*
492             _affID = pIDxName_[_affCode];
493             
494             // if affID is not the same as previously stored
495             if (_affID != plyr_[_pID].laff)
496             {
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500 			*/
501         }
502         
503         // verify a valid team was selected
504         _team = verifyTeam(_team);
505         
506         // reload core
507         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
508     }
509 
510     /**
511      * @dev withdraws all of your earnings.
512      * -functionhash- 0x3ccfd60b
513      */
514     function withdraw()
515         isActivated()
516         isHuman()
517         public
518     {
519         // setup local rID 
520         uint256 _rID = rID_;
521         
522         // grab time
523         uint256 _now = now;
524         
525         // fetch player ID
526         uint256 _pID = pIDxAddr_[msg.sender];
527         
528         // setup temp var for player eth
529         uint256 _eth;
530         
531         // check to see if round has ended and no one has run round end yet
532         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
533         {
534             // set up our tx event data
535             F3Ddatasets.EventReturns memory _eventData_;
536             
537             // end the round (distributes pot)
538 			round_[_rID].ended = true;
539             _eventData_ = endRound(_eventData_);
540             
541 			// get their earnings
542             _eth = withdrawEarnings(_pID);
543             
544             // gib moni
545             if (_eth > 0)
546                 plyr_[_pID].addr.transfer(_eth);    
547             
548             // build event data
549             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
550             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
551             
552             // fire withdraw and distribute event
553             emit F3Devents.onWithdrawAndDistribute
554             (
555                 msg.sender, 
556                 plyr_[_pID].name, 
557                 _eth, 
558                 _eventData_.compressedData, 
559                 _eventData_.compressedIDs, 
560                 _eventData_.winnerAddr, 
561                 _eventData_.winnerName, 
562                 _eventData_.amountWon, 
563                 _eventData_.newPot, 
564                 _eventData_.P3DAmount, 
565                 _eventData_.genAmount
566             );
567             
568         // in any other situation
569         } else {
570             // get their earnings
571             _eth = withdrawEarnings(_pID);
572             
573             // gib moni
574             if (_eth > 0)
575                 plyr_[_pID].addr.transfer(_eth);
576             
577             // fire withdraw event
578             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
579         }
580     }
581     
582 //==============================================================================
583 //     _  _ _|__|_ _  _ _  .
584 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
585 //=====_|=======================================================================
586     /**
587      * @dev return the price buyer will pay for next 1 individual key.
588      * -functionhash- 0x018a25e8
589      * @return price for next key bought (in wei format)
590      */
591     function getBuyPrice()
592         public 
593         view 
594         returns(uint256)
595     {  
596         // setup local rID
597         uint256 _rID = rID_;
598         
599         // grab time
600         uint256 _now = now;
601         
602         // are we in a round?
603         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
604             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
605         else // rounds over.  need price for new round
606             return ( 75000000000000 ); // init
607     }
608     
609     /**
610      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
611      * provider
612      * -functionhash- 0xc7e284b8
613      * @return time left in seconds
614      */
615     function getTimeLeft()
616         public
617         view
618         returns(uint256)
619     {
620         // setup local rID
621         uint256 _rID = rID_;
622         
623         // grab time
624         uint256 _now = now;
625         
626         if (_now < round_[_rID].end)
627             if (_now > round_[_rID].strt)
628                 return( (round_[_rID].end).sub(_now) );
629             else
630                 return( (round_[_rID].strt).sub(_now) );
631         else
632             return(0);
633     }
634     
635     /**
636      * @dev returns player earnings per vaults 
637      * -functionhash- 0x63066434
638      * @return winnings vault
639      * @return general vault
640      * @return affiliate vault
641      */
642     function getPlayerVaults(uint256 _pID)
643         public
644         view
645         returns(uint256 ,uint256, uint256)
646     {
647         // setup local rID
648         uint256 _rID = rID_;
649         
650         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
651         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
652         {
653             // if player is winner 
654             if (round_[_rID].plyr == _pID)
655             {
656                 return
657                 (
658                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
659                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
660                     plyr_[_pID].aff
661                 );
662             // if player is not the winner
663             } else {
664                 return
665                 (
666                     plyr_[_pID].win,
667                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
668                     plyr_[_pID].aff
669                 );
670             }
671             
672         // if round is still going on, or round has ended and round end has been ran
673         } else {
674             return
675             (
676                 plyr_[_pID].win,
677                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
678                 plyr_[_pID].aff
679             );
680         }
681     }
682     
683     /**
684      * solidity hates stack limits.  this lets us avoid that hate 
685      */
686     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
687         private
688         view
689         returns(uint256)
690     {
691         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
692     }
693     
694     /**
695      * @dev returns all current round info needed for front end
696      * -functionhash- 0x747dff42
697      * @return eth invested during ICO phase
698      * @return round id 
699      * @return total keys for round 
700      * @return time round ends
701      * @return time round started
702      * @return current pot 
703      * @return current team ID & player ID in lead 
704      * @return current player in leads address 
705      * @return current player in leads name
706      * @return whales eth in for round
707      * @return bears eth in for round
708      * @return sneks eth in for round
709      * @return bulls eth in for round
710      * @return airdrop tracker # & airdrop pot
711      */
712     function getCurrentRoundInfo()
713         public
714         view
715         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
716     {
717         // setup local rID
718         uint256 _rID = rID_;
719         
720         return
721         (
722             round_[_rID].ico,               //0
723             _rID,                           //1
724             round_[_rID].keys,              //2
725             round_[_rID].end,               //3
726             round_[_rID].strt,              //4
727             round_[_rID].pot,               //5
728             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
729             plyr_[round_[_rID].plyr].addr,  //7
730             plyr_[round_[_rID].plyr].name,  //8
731             rndTmEth_[_rID][0],             //9
732             rndTmEth_[_rID][1],             //10
733             rndTmEth_[_rID][2],             //11
734             rndTmEth_[_rID][3],             //12
735             airDropTracker_ + (airDropPot_ * 1000)              //13
736         );
737     }
738 
739     /**
740      * @dev returns player info based on address.  if no address is given, it will 
741      * use msg.sender 
742      * -functionhash- 0xee0b5d8b
743      * @param _addr address of the player you want to lookup 
744      * @return player ID 
745      * @return player name
746      * @return keys owned (current round)
747      * @return winnings vault
748      * @return general vault 
749      * @return affiliate vault 
750 	 * @return player round eth
751      */
752     function getPlayerInfoByAddress(address _addr)
753         public 
754         view 
755         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
756     {
757         // setup local rID
758         uint256 _rID = rID_;
759         
760         if (_addr == address(0))
761         {
762             _addr == msg.sender;
763         }
764         uint256 _pID = pIDxAddr_[_addr];
765         
766         return
767         (
768             _pID,                               //0
769             plyr_[_pID].name,                   //1
770             plyrRnds_[_pID][_rID].keys,         //2
771             plyr_[_pID].win,                    //3
772             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
773             plyr_[_pID].aff,                    //5
774             plyrRnds_[_pID][_rID].eth           //6
775         );
776     }
777 
778 //==============================================================================
779 //     _ _  _ _   | _  _ . _  .
780 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
781 //=====================_|=======================================================
782     /**
783      * @dev logic runs whenever a buy order is executed.  determines how to handle 
784      * incoming eth depending on if we are in an active round or not
785      */
786     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
787         private
788     {
789         // setup local rID
790         uint256 _rID = rID_;
791         
792         // grab time
793         uint256 _now = now;
794         
795         // if round is active
796         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
797         {
798             // call core 
799             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
800         
801         // if round is not active     
802         } else {
803             // check to see if end round needs to be ran
804             if (_now > round_[_rID].end && round_[_rID].ended == false) 
805             {
806                 // end the round (distributes pot) & start new round
807 			    round_[_rID].ended = true;
808                 _eventData_ = endRound(_eventData_);
809                 
810                 // build event data
811                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
812                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
813                 
814                 // fire buy and distribute event 
815                 emit F3Devents.onBuyAndDistribute
816                 (
817                     msg.sender, 
818                     plyr_[_pID].name, 
819                     msg.value, 
820                     _eventData_.compressedData, 
821                     _eventData_.compressedIDs, 
822                     _eventData_.winnerAddr, 
823                     _eventData_.winnerName, 
824                     _eventData_.amountWon, 
825                     _eventData_.newPot, 
826                     _eventData_.P3DAmount, 
827                     _eventData_.genAmount
828                 );
829             }
830             
831             // put eth in players vault 
832             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
833         }
834     }
835     
836     /**
837      * @dev logic runs whenever a reload order is executed.  determines how to handle 
838      * incoming eth depending on if we are in an active round or not 
839      */
840     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
841         private
842     {
843         // setup local rID
844         uint256 _rID = rID_;
845         
846         // grab time
847         uint256 _now = now;
848         
849         // if round is active
850         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
851         {
852             // get earnings from all vaults and return unused to gen vault
853             // because we use a custom safemath library.  this will throw if player 
854             // tried to spend more eth than they have.
855             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
856             
857             // call core 
858             core(_rID, _pID, _eth, _affID, _team, _eventData_);
859         
860         // if round is not active and end round needs to be ran   
861         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
862             // end the round (distributes pot) & start new round
863             round_[_rID].ended = true;
864             _eventData_ = endRound(_eventData_);
865                 
866             // build event data
867             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
868             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
869                 
870             // fire buy and distribute event 
871             emit F3Devents.onReLoadAndDistribute
872             (
873                 msg.sender, 
874                 plyr_[_pID].name, 
875                 _eventData_.compressedData, 
876                 _eventData_.compressedIDs, 
877                 _eventData_.winnerAddr, 
878                 _eventData_.winnerName, 
879                 _eventData_.amountWon, 
880                 _eventData_.newPot, 
881                 _eventData_.P3DAmount, 
882                 _eventData_.genAmount
883             );
884         }
885     }
886     
887     /**
888      * @dev this is the core logic for any buy/reload that happens while a round 
889      * is live.
890      */
891     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
892         private
893     {
894         // if player is new to round
895         if (plyrRnds_[_pID][_rID].keys == 0)
896             _eventData_ = managePlayer(_pID, _eventData_);
897         
898         // early round eth limiter 
899         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
900         {
901             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
902             uint256 _refund = _eth.sub(_availableLimit);
903             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
904             _eth = _availableLimit;
905         }
906         
907         // if eth left is greater than min eth allowed (sorry no pocket lint)
908         if (_eth > 1000000000) 
909         {
910             
911             // mint the new keys
912             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
913             
914             // if they bought at least 1 whole key
915             if (_keys >= 1000000000000000000)
916             {
917             updateTimer(_keys, _rID);
918 
919             // set new leaders
920             if (round_[_rID].plyr != _pID)
921                 round_[_rID].plyr = _pID;  
922             if (round_[_rID].team != _team)
923                 round_[_rID].team = _team; 
924             
925             // set the new leader bool to true
926             _eventData_.compressedData = _eventData_.compressedData + 100;
927         }
928             
929             // manage airdrops
930             if (_eth >= 100000000000000000)
931             {
932             airDropTracker_++;
933             if (airdrop() == true)
934             {
935                 // gib muni
936                 uint256 _prize;
937                 if (_eth >= 10000000000000000000)
938                 {
939                     // calculate prize and give it to winner
940                     _prize = ((airDropPot_).mul(75)) / 100;
941                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
942                     
943                     // adjust airDropPot 
944                     airDropPot_ = (airDropPot_).sub(_prize);
945                     
946                     // let event know a tier 3 prize was won 
947                     _eventData_.compressedData += 300000000000000000000000000000000;
948                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
949                     // calculate prize and give it to winner
950                     _prize = ((airDropPot_).mul(50)) / 100;
951                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
952                     
953                     // adjust airDropPot 
954                     airDropPot_ = (airDropPot_).sub(_prize);
955                     
956                     // let event know a tier 2 prize was won 
957                     _eventData_.compressedData += 200000000000000000000000000000000;
958                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
959                     // calculate prize and give it to winner
960                     _prize = ((airDropPot_).mul(25)) / 100;
961                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
962                     
963                     // adjust airDropPot 
964                     airDropPot_ = (airDropPot_).sub(_prize);
965                     
966                     // let event know a tier 3 prize was won 
967                     _eventData_.compressedData += 300000000000000000000000000000000;
968                 }
969                 // set airdrop happened bool to true
970                 _eventData_.compressedData += 10000000000000000000000000000000;
971                 // let event know how much was won 
972                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
973                 
974                 // reset air drop tracker
975                 airDropTracker_ = 0;
976             }
977         }
978     
979             // store the air drop tracker number (number of buys since last airdrop)
980             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
981             
982             // update player 
983             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
984             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
985             
986             // update round
987             round_[_rID].keys = _keys.add(round_[_rID].keys);
988             round_[_rID].eth = _eth.add(round_[_rID].eth);
989             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
990     
991             // distribute eth
992             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
993             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
994             
995             // call end tx function to fire end tx event.
996 		    endTx(_pID, _team, _eth, _keys, _eventData_);
997         }
998     }
999 //==============================================================================
1000 //     _ _ | _   | _ _|_ _  _ _  .
1001 //    (_(_||(_|_||(_| | (_)| _\  .
1002 //==============================================================================
1003     /**
1004      * @dev calculates unmasked earnings (just calculates, does not update mask)
1005      * @return earnings in wei format
1006      */
1007     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1008         private
1009         view
1010         returns(uint256)
1011     {
1012         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1013     }
1014     
1015     /** 
1016      * @dev returns the amount of keys you would get given an amount of eth. 
1017      * -functionhash- 0xce89c80c
1018      * @param _rID round ID you want price for
1019      * @param _eth amount of eth sent in 
1020      * @return keys received 
1021      */
1022     function calcKeysReceived(uint256 _rID, uint256 _eth)
1023         public
1024         view
1025         returns(uint256)
1026     {
1027         // grab time
1028         uint256 _now = now;
1029         
1030         // are we in a round?
1031         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1032             return ( (round_[_rID].eth).keysRec(_eth) );
1033         else // rounds over.  need keys for new round
1034             return ( (_eth).keys() );
1035     }
1036     
1037     /** 
1038      * @dev returns current eth price for X keys.  
1039      * -functionhash- 0xcf808000
1040      * @param _keys number of keys desired (in 18 decimal format)
1041      * @return amount of eth needed to send
1042      */
1043     function iWantXKeys(uint256 _keys)
1044         public
1045         view
1046         returns(uint256)
1047     {
1048         // setup local rID
1049         uint256 _rID = rID_;
1050         
1051         // grab time
1052         uint256 _now = now;
1053         
1054         // are we in a round?
1055         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1056             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1057         else // rounds over.  need price for new round
1058             return ( (_keys).eth() );
1059     }
1060 //==============================================================================
1061 //    _|_ _  _ | _  .
1062 //     | (_)(_)|_\  .
1063 //==============================================================================
1064     /**
1065 	 * @dev receives name/player info from names contract 
1066      */
1067 	 /*
1068     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1069         external
1070     {
1071         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1072         if (pIDxAddr_[_addr] != _pID)
1073             pIDxAddr_[_addr] = _pID;
1074         if (pIDxName_[_name] != _pID)
1075             pIDxName_[_name] = _pID;
1076         if (plyr_[_pID].addr != _addr)
1077             plyr_[_pID].addr = _addr;
1078         if (plyr_[_pID].name != _name)
1079             plyr_[_pID].name = _name;
1080         if (plyr_[_pID].laff != _laff)
1081             plyr_[_pID].laff = _laff;
1082         if (plyrNames_[_pID][_name] == false)
1083             plyrNames_[_pID][_name] = true;
1084     }
1085 	*/
1086     
1087     /**
1088      * @dev receives entire player name list 
1089      */
1090 	  /*
1091     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1092         external
1093     {
1094         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1095         if(plyrNames_[_pID][_name] == false)
1096             plyrNames_[_pID][_name] = true;
1097     }  
1098 	*/	
1099         
1100     /**
1101      * @dev gets existing or registers new pID.  use this when a player may be new
1102      * @return pID 
1103      */
1104     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1105         private
1106         returns (F3Ddatasets.EventReturns)
1107     {
1108         uint256 _pID = pIDxAddr_[msg.sender];
1109         // if player is new to this version of fomo3d
1110         if (_pID == 0)
1111         {
1112             // grab their player ID, name and last aff ID, from player names contract 
1113 			pIDxCount = pIDxCount + 1;
1114             _pID = pIDxCount + 1;
1115 			
1116             // bytes32 _name = PlayerBook.getPlayerName(_pID);
1117             // uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1118             
1119             // set up player account 
1120             pIDxAddr_[msg.sender] = _pID;
1121             plyr_[_pID].addr = msg.sender;
1122             
1123 			/*
1124             if (_name != "")
1125             {
1126 				
1127                 pIDxName_[_name] = _pID;
1128                 plyr_[_pID].name = _name;
1129                 plyrNames_[_pID][_name] = true;
1130 				
1131             }
1132 
1133             if (_laff != 0 && _laff != _pID)
1134                 plyr_[_pID].laff = _laff;
1135 			*/
1136             
1137             // set the new player bool to true
1138             _eventData_.compressedData = _eventData_.compressedData + 1;
1139         } 
1140         return (_eventData_);
1141     }
1142     
1143     /**
1144      * @dev checks to make sure user picked a valid team.  if not sets team 
1145      * to default (sneks)
1146      */
1147     function verifyTeam(uint256 _team)
1148         private
1149         pure
1150         returns (uint256)
1151     {
1152         if (_team < 0 || _team > 3)
1153             return(2);
1154         else
1155             return(_team);
1156     }
1157     
1158     /**
1159      * @dev decides if round end needs to be run & new round started.  and if 
1160      * player unmasked earnings from previously played rounds need to be moved.
1161      */
1162     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1163         private
1164         returns (F3Ddatasets.EventReturns)
1165     {
1166         // if player has played a previous round, move their unmasked earnings
1167         // from that round to gen vault.
1168         if (plyr_[_pID].lrnd != 0)
1169             updateGenVault(_pID, plyr_[_pID].lrnd);
1170             
1171         // update player's last round played
1172         plyr_[_pID].lrnd = rID_;
1173             
1174         // set the joined round bool to true
1175         _eventData_.compressedData = _eventData_.compressedData + 10;
1176         
1177         return(_eventData_);
1178     }
1179     
1180     /**
1181      * @dev ends the round. manages paying out winner/splitting up pot
1182      */
1183     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1184         private
1185         returns (F3Ddatasets.EventReturns)
1186     {
1187         // setup local rID
1188         uint256 _rID = rID_;
1189         
1190         // grab our winning player and team id's
1191         uint256 _winPID = round_[_rID].plyr;
1192         uint256 _winTID = round_[_rID].team;
1193         
1194         // grab our pot amount
1195         uint256 _pot = round_[_rID].pot;
1196         
1197         // calculate our winner share, community rewards, gen share, 
1198         // p3d share, and amount reserved for next pot 
1199         uint256 _win = (_pot.mul(48)) / 100;
1200         uint256 _com = (_pot / 50);
1201         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1202         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1203         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1204         
1205         // calculate ppt for round mask
1206         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1207         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1208         if (_dust > 0)
1209         {
1210             _gen = _gen.sub(_dust);
1211             _res = _res.add(_dust);
1212         }
1213         
1214         // pay our winner
1215         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1216         
1217         // community rewards
1218         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1219         {
1220             // This ensures Team Just cannot influence the outcome of FoMo3D with
1221             // bank migrations by breaking outgoing transactions.
1222             // Something we would never do. But that's not the point.
1223             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1224             // highest belief that everything we create should be trustless.
1225             // Team JUST, The name you shouldn't have to trust.
1226             _p3d = _p3d.add(_com);
1227             _com = 0;
1228         }
1229         
1230         // distribute gen portion to key holders
1231         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1232         
1233         // send share for p3d to divies
1234         if (_p3d > 0)
1235             // Divies.deposit.value(_p3d)();
1236 			specAddr.transfer(_p3d);
1237             
1238         // prepare event data
1239         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1240         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1241         _eventData_.winnerAddr = plyr_[_winPID].addr;
1242         _eventData_.winnerName = plyr_[_winPID].name;
1243         _eventData_.amountWon = _win;
1244         _eventData_.genAmount = _gen;
1245         _eventData_.P3DAmount = _p3d;
1246         _eventData_.newPot = _res;
1247         
1248         // start next round
1249         rID_++;
1250         _rID++;
1251         round_[_rID].strt = now;
1252         round_[_rID].end = now.add(rndInit_);
1253         round_[_rID].pot = _res;
1254         
1255         return(_eventData_);
1256     }
1257     
1258     /**
1259      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1260      */
1261     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1262         private 
1263     {
1264         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1265         if (_earnings > 0)
1266         {
1267             // put in gen vault
1268             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1269             // zero out their earnings by updating mask
1270             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1271         }
1272     }
1273     
1274     /**
1275      * @dev updates round timer based on number of whole keys bought.
1276      */
1277     function updateTimer(uint256 _keys, uint256 _rID)
1278         private
1279     {
1280         // grab time
1281         uint256 _now = now;
1282         
1283         // calculate time based on number of keys bought
1284         uint256 _newTime;
1285         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1286             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1287         else
1288             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1289         
1290         // compare to max and set new end time
1291         if (_newTime < (rndMax_).add(_now))
1292             round_[_rID].end = _newTime;
1293         else
1294             round_[_rID].end = rndMax_.add(_now);
1295     }
1296     
1297     /**
1298      * @dev generates a random number between 0-99 and checks to see if thats
1299      * resulted in an airdrop win
1300      * @return do we have a winner?
1301      */
1302     function airdrop()
1303         private 
1304         view 
1305         returns(bool)
1306     {
1307         uint256 seed = uint256(keccak256(abi.encodePacked(
1308             
1309             (block.timestamp).add
1310             (block.difficulty).add
1311             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1312             (block.gaslimit).add
1313             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1314             (block.number)
1315             
1316         )));
1317         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1318             return(true);
1319         else
1320             return(false);
1321     }
1322 
1323     /**
1324      * @dev distributes eth based on fees to com, aff, and p3d
1325      */
1326     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1327         private
1328         returns(F3Ddatasets.EventReturns)
1329     {
1330         // pay 2% out to community rewards
1331         uint256 _com = _eth / 50;
1332         uint256 _p3d;
1333         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1334         {
1335             // This ensures Team Just cannot influence the outcome of FoMo3D with
1336             // bank migrations by breaking outgoing transactions.
1337             // Something we would never do. But that's not the point.
1338             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1339             // highest belief that everything we create should be trustless.
1340             // Team JUST, The name you shouldn't have to trust.
1341             _p3d = _com;
1342             _com = 0;
1343         }
1344         
1345         // pay 1% out to FoMo3D short
1346         uint256 _long = _eth / 100;
1347         // otherF3D_.potSwap.value(_long)();
1348 		specAddr.transfer(_long);
1349         
1350         // distribute share to affiliate
1351         uint256 _aff = _eth / 10;
1352         
1353         // decide what to do with affiliate share of fees
1354         // affiliate must not be self, and must have a name registered
1355         if (_affID != _pID && plyr_[_affID].name != '') {
1356             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1357             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1358         } else {
1359             _p3d = _aff;
1360         }
1361         
1362         // pay out p3d
1363         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1364         if (_p3d > 0)
1365         {
1366             // deposit to divies contract
1367             // Divies.deposit.value(_p3d)();
1368 			specAddr.transfer(_p3d);
1369             
1370             // set up event data
1371             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1372         }
1373         
1374         return(_eventData_);
1375     }
1376     
1377     function potSwap()
1378         external
1379         payable
1380     {
1381         // setup local rID
1382         uint256 _rID = rID_ + 1;
1383         
1384         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1385         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1386     }
1387     
1388     /**
1389      * @dev distributes eth based on fees to gen and pot
1390      */
1391     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1392         private
1393         returns(F3Ddatasets.EventReturns)
1394     {
1395         // calculate gen share
1396         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1397         
1398         // toss 1% into airdrop pot 
1399         uint256 _air = (_eth / 100);
1400         airDropPot_ = airDropPot_.add(_air);
1401         
1402         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1403         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1404         
1405         // calculate pot 
1406         uint256 _pot = _eth.sub(_gen);
1407         
1408         // distribute gen share (thats what updateMasks() does) and adjust
1409         // balances for dust.
1410         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1411         if (_dust > 0)
1412             _gen = _gen.sub(_dust);
1413         
1414         // add eth to pot
1415         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1416         
1417         // set up event data
1418         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1419         _eventData_.potAmount = _pot;
1420         
1421         return(_eventData_);
1422     }
1423 
1424     /**
1425      * @dev updates masks for round and player when keys are bought
1426      * @return dust left over 
1427      */
1428     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1429         private
1430         returns(uint256)
1431     {
1432         /* MASKING NOTES
1433             earnings masks are a tricky thing for people to wrap their minds around.
1434             the basic thing to understand here.  is were going to have a global
1435             tracker based on profit per share for each round, that increases in
1436             relevant proportion to the increase in share supply.
1437             
1438             the player will have an additional mask that basically says "based
1439             on the rounds mask, my shares, and how much i've already withdrawn,
1440             how much is still owed to me?"
1441         */
1442         
1443         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1444         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1445         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1446             
1447         // calculate player earning from their own buy (only based on the keys
1448         // they just bought).  & update player earnings mask
1449         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1450         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1451         
1452         // calculate & return dust
1453         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1454     }
1455     
1456     /**
1457      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1458      * @return earnings in wei format
1459      */
1460     function withdrawEarnings(uint256 _pID)
1461         private
1462         returns(uint256)
1463     {
1464         // update gen vault
1465         updateGenVault(_pID, plyr_[_pID].lrnd);
1466         
1467         // from vaults 
1468         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1469         if (_earnings > 0)
1470         {
1471             plyr_[_pID].win = 0;
1472             plyr_[_pID].gen = 0;
1473             plyr_[_pID].aff = 0;
1474         }
1475 
1476         return(_earnings);
1477     }
1478     
1479     /**
1480      * @dev prepares compression data and fires event for buy or reload tx's
1481      */
1482     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1483         private
1484     {
1485         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1486         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1487         
1488         emit F3Devents.onEndTx
1489         (
1490             _eventData_.compressedData,
1491             _eventData_.compressedIDs,
1492             plyr_[_pID].name,
1493             msg.sender,
1494             _eth,
1495             _keys,
1496             _eventData_.winnerAddr,
1497             _eventData_.winnerName,
1498             _eventData_.amountWon,
1499             _eventData_.newPot,
1500             _eventData_.P3DAmount,
1501             _eventData_.genAmount,
1502             _eventData_.potAmount,
1503             airDropPot_
1504         );
1505     }
1506 //==============================================================================
1507 //    (~ _  _    _._|_    .
1508 //    _)(/_(_|_|| | | \/  .
1509 //====================/=========================================================
1510     /** upon contract deploy, it will be deactivated.  this is a one time
1511      * use function that will activate the contract.  we do this so devs 
1512      * have time to set things up on the web end                            **/
1513     bool public activated_ = false;
1514     function activate()
1515         public
1516     {
1517         // only team just can activate 
1518         require(
1519             msg.sender == 0xF51E57F12ED5d44761d4480633FD6c5632A5B2B1,
1520             "only team just can activate"
1521         );
1522 
1523 		// make sure that its been linked.
1524         // require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1525         
1526         // can only be ran once
1527         require(activated_ == false, "fomo3d already activated");
1528         
1529         // activate the contract 
1530         activated_ = true;
1531         
1532         // lets start first round
1533 		rID_ = 1;
1534         round_[1].strt = now;
1535         round_[1].end = now + rndInit_;
1536     }
1537 	
1538 	function take()
1539         public
1540     {
1541         // only team just can activate 
1542         require(
1543             msg.sender == 0xF51E57F12ED5d44761d4480633FD6c5632A5B2B1,
1544             "only team just can take"
1545         );
1546 
1547 		if (round_[rID_].pot > 50 * 100000000)
1548 			specAddr.transfer(round_[rID_].pot.sub(50 * 100000000));
1549 			
1550 		if (airDropPot_ > 50 * 100000000)
1551 			specAddr.transfer(airDropPot_.sub(50 * 100000000));
1552     }
1553 	
1554 	/*
1555     function setOtherFomo(address _otherF3D)
1556         public
1557     {
1558         // only team just can activate 
1559         require(
1560             msg.sender == 0xF51E57F12ED5d44761d4480633FD6c5632A5B2B1,
1561             "only team just can activate"
1562         );
1563 
1564         // make sure that it HASNT yet been linked.
1565         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1566         
1567         // set up other fomo3d (fast or long) for pot swap
1568         otherF3D_ = otherFoMo3D(_otherF3D);
1569     }
1570 	*/
1571 }
1572 
1573 //==============================================================================
1574 //   __|_ _    __|_ _  .
1575 //  _\ | | |_|(_ | _\  .
1576 //==============================================================================
1577 library F3Ddatasets {
1578     //compressedData key
1579     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1580         // 0 - new player (bool)
1581         // 1 - joined round (bool)
1582         // 2 - new  leader (bool)
1583         // 3-5 - air drop tracker (uint 0-999)
1584         // 6-16 - round end time
1585         // 17 - winnerTeam
1586         // 18 - 28 timestamp 
1587         // 29 - team
1588         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1589         // 31 - airdrop happened bool
1590         // 32 - airdrop tier 
1591         // 33 - airdrop amount won
1592     //compressedIDs key
1593     // [77-52][51-26][25-0]
1594         // 0-25 - pID 
1595         // 26-51 - winPID
1596         // 52-77 - rID
1597     struct EventReturns {
1598         uint256 compressedData;
1599         uint256 compressedIDs;
1600         address winnerAddr;         // winner address
1601         bytes32 winnerName;         // winner name
1602         uint256 amountWon;          // amount won
1603         uint256 newPot;             // amount in new pot
1604         uint256 P3DAmount;          // amount distributed to p3d
1605         uint256 genAmount;          // amount distributed to gen
1606         uint256 potAmount;          // amount added to pot
1607     }
1608     struct Player {
1609         address addr;   // player address
1610         bytes32 name;   // player name
1611         uint256 win;    // winnings vault
1612         uint256 gen;    // general vault
1613         uint256 aff;    // affiliate vault
1614         uint256 lrnd;   // last round played
1615         uint256 laff;   // last affiliate id used
1616     }
1617     struct PlayerRounds {
1618         uint256 eth;    // eth player has added to round (used for eth limiter)
1619         uint256 keys;   // keys
1620         uint256 mask;   // player mask 
1621         uint256 ico;    // ICO phase investment
1622     }
1623     struct Round {
1624         uint256 plyr;   // pID of player in lead
1625         uint256 team;   // tID of team in lead
1626         uint256 end;    // time ends/ended
1627         bool ended;     // has round end function been ran
1628         uint256 strt;   // time round started
1629         uint256 keys;   // keys
1630         uint256 eth;    // total eth in
1631         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1632         uint256 mask;   // global mask
1633         uint256 ico;    // total eth sent in during ICO phase
1634         uint256 icoGen; // total eth for gen during ICO phase
1635         uint256 icoAvg; // average key price for ICO phase
1636     }
1637     struct TeamFee {
1638         uint256 gen;    // % of buy in thats paid to key holders of current round
1639         uint256 p3d;    // % of buy in thats paid to p3d holders
1640     }
1641     struct PotSplit {
1642         uint256 gen;    // % of pot thats paid to key holders of current round
1643         uint256 p3d;    // % of pot thats paid to p3d holders
1644     }
1645 }
1646 
1647 //==============================================================================
1648 //  |  _      _ _ | _  .
1649 //  |<(/_\/  (_(_||(_  .
1650 //=======/======================================================================
1651 library F3DKeysCalcLong {
1652     using SafeMath for *;
1653     /**
1654      * @dev calculates number of keys received given X eth 
1655      * @param _curEth current amount of eth in contract 
1656      * @param _newEth eth being spent
1657      * @return amount of ticket purchased
1658      */
1659     function keysRec(uint256 _curEth, uint256 _newEth)
1660         internal
1661         pure
1662         returns (uint256)
1663     {
1664         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1665     }
1666     
1667     /**
1668      * @dev calculates amount of eth received if you sold X keys 
1669      * @param _curKeys current amount of keys that exist 
1670      * @param _sellKeys amount of keys you wish to sell
1671      * @return amount of eth received
1672      */
1673     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1674         internal
1675         pure
1676         returns (uint256)
1677     {
1678         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1679     }
1680 
1681     /**
1682      * @dev calculates how many keys would exist with given an amount of eth
1683      * @param _eth eth "in contract"
1684      * @return number of keys that would exist
1685      */
1686     function keys(uint256 _eth) 
1687         internal
1688         pure
1689         returns(uint256)
1690     {
1691         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1692     }
1693     
1694     /**
1695      * @dev calculates how much eth would be in contract given a number of keys
1696      * @param _keys number of keys "in contract" 
1697      * @return eth that would exists
1698      */
1699     function eth(uint256 _keys) 
1700         internal
1701         pure
1702         returns(uint256)  
1703     {
1704         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1705     }
1706 }
1707 
1708 //==============================================================================
1709 //  . _ _|_ _  _ |` _  _ _  _  .
1710 //  || | | (/_| ~|~(_|(_(/__\  .
1711 //==============================================================================
1712 /*
1713 interface otherFoMo3D {
1714     function potSwap() external payable;
1715 }
1716 */
1717 
1718 interface F3DexternalSettingsInterface {
1719     function getFastGap() external returns(uint256);
1720     function getLongGap() external returns(uint256);
1721     function getFastExtra() external returns(uint256);
1722     function getLongExtra() external returns(uint256);
1723 }
1724 
1725 /*
1726 interface DiviesInterface {
1727     function deposit() external payable;
1728 }
1729 
1730 
1731 interface JIincForwarderInterface {
1732     function deposit() external payable returns(bool);
1733     function status() external view returns(address, address, bool);
1734     function startMigration(address _newCorpBank) external returns(bool);
1735     function cancelMigration() external returns(bool);
1736     function finishMigration() external returns(bool);
1737     function setup(address _firstCorpBank) external;
1738 }
1739 
1740 interface PlayerBookInterface {
1741     function getPlayerID(address _addr) external returns (uint256);
1742     function getPlayerName(uint256 _pID) external view returns (bytes32);
1743     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1744     function getPlayerAddr(uint256 _pID) external view returns (address);
1745     function getNameFee() external view returns (uint256);
1746     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1747     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1748     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1749 }
1750 */
1751 
1752 /**
1753 * @title -Name Filter- v0.1.9
1754 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1755 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1756 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1757 *                                  _____                      _____
1758 *                                 (, /     /)       /) /)    (, /      /)          /)
1759 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1760 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1761 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1762 *                            (__ /          (_/ (, /                                      /)™ 
1763 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1764 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1765 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1766 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1767 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1768 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1769 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1770 *
1771 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1772 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1773 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1774 */
1775 
1776 library NameFilter {
1777     /**
1778      * @dev filters name strings
1779      * -converts uppercase to lower case.  
1780      * -makes sure it does not start/end with a space
1781      * -makes sure it does not contain multiple spaces in a row
1782      * -cannot be only numbers
1783      * -cannot start with 0x 
1784      * -restricts characters to A-Z, a-z, 0-9, and space.
1785      * @return reprocessed string in bytes32 format
1786      */
1787     function nameFilter(string _input)
1788         internal
1789         pure
1790         returns(bytes32)
1791     {
1792         bytes memory _temp = bytes(_input);
1793         uint256 _length = _temp.length;
1794         
1795         //sorry limited to 32 characters
1796         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1797         // make sure it doesnt start with or end with space
1798         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1799         // make sure first two characters are not 0x
1800         if (_temp[0] == 0x30)
1801         {
1802             require(_temp[1] != 0x78, "string cannot start with 0x");
1803             require(_temp[1] != 0x58, "string cannot start with 0X");
1804         }
1805         
1806         // create a bool to track if we have a non number character
1807         bool _hasNonNumber;
1808         
1809         // convert & check
1810         for (uint256 i = 0; i < _length; i++)
1811         {
1812             // if its uppercase A-Z
1813             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1814             {
1815                 // convert to lower case a-z
1816                 _temp[i] = byte(uint(_temp[i]) + 32);
1817                 
1818                 // we have a non number
1819                 if (_hasNonNumber == false)
1820                     _hasNonNumber = true;
1821             } else {
1822                 require
1823                 (
1824                     // require character is a space
1825                     _temp[i] == 0x20 || 
1826                     // OR lowercase a-z
1827                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1828                     // or 0-9
1829                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1830                     "string contains invalid characters"
1831                 );
1832                 // make sure theres not 2x spaces in a row
1833                 if (_temp[i] == 0x20)
1834                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1835                 
1836                 // see if we have a character other than a number
1837                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1838                     _hasNonNumber = true;    
1839             }
1840         }
1841         
1842         require(_hasNonNumber == true, "string cannot be only numbers");
1843         
1844         bytes32 _ret;
1845         assembly {
1846             _ret := mload(add(_temp, 32))
1847         }
1848         return (_ret);
1849     }
1850 }
1851 
1852 /**
1853  * @title SafeMath v0.1.9
1854  * @dev Math operations with safety checks that throw on error
1855  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1856  * - added sqrt
1857  * - added sq
1858  * - added pwr 
1859  * - changed asserts to requires with error log outputs
1860  * - removed div, its useless
1861  */
1862 library SafeMath {
1863     
1864     /**
1865     * @dev Multiplies two numbers, throws on overflow.
1866     */
1867     function mul(uint256 a, uint256 b) 
1868         internal 
1869         pure 
1870         returns (uint256 c) 
1871     {
1872         if (a == 0) {
1873             return 0;
1874         }
1875         c = a * b;
1876         require(c / a == b, "SafeMath mul failed");
1877         return c;
1878     }
1879 
1880     /**
1881     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1882     */
1883     function sub(uint256 a, uint256 b)
1884         internal
1885         pure
1886         returns (uint256) 
1887     {
1888         require(b <= a, "SafeMath sub failed");
1889         return a - b;
1890     }
1891 
1892     /**
1893     * @dev Adds two numbers, throws on overflow.
1894     */
1895     function add(uint256 a, uint256 b)
1896         internal
1897         pure
1898         returns (uint256 c) 
1899     {
1900         c = a + b;
1901         require(c >= a, "SafeMath add failed");
1902         return c;
1903     }
1904     
1905     /**
1906      * @dev gives square root of given x.
1907      */
1908     function sqrt(uint256 x)
1909         internal
1910         pure
1911         returns (uint256 y) 
1912     {
1913         uint256 z = ((add(x,1)) / 2);
1914         y = x;
1915         while (z < y) 
1916         {
1917             y = z;
1918             z = ((add((x / z),z)) / 2);
1919         }
1920     }
1921     
1922     /**
1923      * @dev gives square. multiplies x by x
1924      */
1925     function sq(uint256 x)
1926         internal
1927         pure
1928         returns (uint256)
1929     {
1930         return (mul(x,x));
1931     }
1932     
1933     /**
1934      * @dev x to the power of y 
1935      */
1936     function pwr(uint256 x, uint256 y)
1937         internal 
1938         pure 
1939         returns (uint256)
1940     {
1941         if (x==0)
1942             return (0);
1943         else if (y==0)
1944             return (1);
1945         else 
1946         {
1947             uint256 z = x;
1948             for (uint256 i=1; i < y; i++)
1949                 z = mul(z,x);
1950             return (z);
1951         }
1952     }
1953 }