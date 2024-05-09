1 pragma solidity ^0.4.24;
2 
3 /*--------------------------------------------------
4   ____                          ____              _ 
5 / ___| _   _ _ __   ___ _ __   / ___|__ _ _ __ __| |
6 \___ \| | | | '_ \ / _ \ '__| | |   / _` | '__/ _` |
7  ___) | |_| | |_) |  __/ |    | |__| (_| | | | (_| |
8 |____/ \__,_| .__/ \___|_|     \____\__,_|_|  \__,_|
9             |_|                                   
10 
11                                          2018-08-08
12 ---------------------------------------------------*/
13 
14 contract SPCevents {
15     // fired whenever a player registers a name
16     event onNewName
17     (
18         uint256 indexed playerID,
19         address indexed playerAddress,
20         bytes32 indexed playerName,
21         bool isNewPlayer,
22         uint256 affiliateID,
23         address affiliateAddress,
24         bytes32 affiliateName,
25         uint256 amountPaid,
26         uint256 timeStamp
27     );
28 
29     // fired at end of buy or reload
30     event onEndTx
31     (
32         uint256 compressedData,
33         uint256 compressedIDs,
34         bytes32 playerName,
35         address playerAddress,
36         uint256 ethIn,
37         uint256 keysBought,
38         address winnerAddr,
39         bytes32 winnerName,
40         uint256 amountWon,
41         uint256 newPot,
42         uint256 P3DAmount,
43         uint256 genAmount,
44         uint256 potAmount,
45         uint256 airDropPot
46     );
47 
48 	// fired whenever theres a withdraw
49     event onWithdraw
50     (
51         uint256 indexed playerID,
52         address playerAddress,
53         bytes32 playerName,
54         uint256 ethOut,
55         uint256 timeStamp
56     );
57 
58     // fired whenever a withdraw forces end round to be ran
59     event onWithdrawAndDistribute
60     (
61         address playerAddress,
62         bytes32 playerName,
63         uint256 ethOut,
64         uint256 compressedData,
65         uint256 compressedIDs,
66         address winnerAddr,
67         bytes32 winnerName,
68         uint256 amountWon,
69         uint256 newPot,
70         uint256 P3DAmount,
71         uint256 genAmount
72     );
73 
74     // (fomo3d short only) fired whenever a player tries a buy after round timer
75     // hit zero, and causes end round to be ran.
76     event onBuyAndDistribute
77     (
78         address playerAddress,
79         bytes32 playerName,
80         uint256 ethIn,
81         uint256 compressedData,
82         uint256 compressedIDs,
83         address winnerAddr,
84         bytes32 winnerName,
85         uint256 amountWon,
86         uint256 newPot,
87         uint256 P3DAmount,
88         uint256 genAmount
89     );
90 
91     // (fomo3d short only) fired whenever a player tries a reload after round timer
92     // hit zero, and causes end round to be ran.
93     event onReLoadAndDistribute
94     (
95         address playerAddress,
96         bytes32 playerName,
97         uint256 compressedData,
98         uint256 compressedIDs,
99         address winnerAddr,
100         bytes32 winnerName,
101         uint256 amountWon,
102         uint256 newPot,
103         uint256 P3DAmount,
104         uint256 genAmount
105     );
106 
107     // fired whenever an affiliate is paid
108     event onAffiliatePayout
109     (
110         uint256 indexed affiliateID,
111         address affiliateAddress,
112         bytes32 affiliateName,
113         uint256 indexed roundID,
114         uint256 indexed buyerID,
115         uint256 amount,
116         uint256 timeStamp
117     );
118 
119     // received pot swap deposit, add pot directly by admin to next round
120     event onPotSwapDeposit
121     (
122         uint256 roundID,
123         uint256 amountAddedToPot
124     );
125 }
126 
127 //==============================================================================
128 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
129 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
130 //====================================|=========================================
131 
132 contract SuperCard is SPCevents {
133     using SafeMath for *;
134     using NameFilter for string;
135 
136     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xBac825cDB506dCF917A7715a4bF3fA1B06aBe3e4);
137 
138 //==============================================================================
139 //     _ _  _  |`. _     _ _ |_ | _  _  .
140 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
141 //=================_|===========================================================
142     address private admin = msg.sender;
143     string constant public name   = "SuperCard";
144     string constant public symbol = "SPC";
145     uint256 private rndExtra_     = 0;     // length of the very first ICO
146     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
147     uint256 constant private rndInit_ = 6 hours;           // round timer starts at this
148     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
149     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
150 //==============================================================================
151 //     _| _ _|_ _    _ _ _|_    _   .
152 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
153 //=============================|================================================
154     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
155     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
156     uint256 public rID_;    // round id number / total rounds that have happened
157 //****************
158 // PLAYER DATA
159 //****************
160     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
161     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
162     mapping (uint256 => SPCdatasets.Player) public plyr_;   // (pID => data) player data
163     mapping (uint256 => mapping (uint256 => SPCdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
164     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
165 //****************
166 // ROUND DATA
167 //****************
168     mapping (uint256 => SPCdatasets.Round) public round_;   // (rID => data) round data
169     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
170 //****************
171 // TEAM FEE DATA
172 //****************
173     mapping (uint256 => SPCdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
174     mapping (uint256 => SPCdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
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
190             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
191         fees_[0] = SPCdatasets.TeamFee(80,2);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
192         fees_[1] = SPCdatasets.TeamFee(80,2);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
193         fees_[2] = SPCdatasets.TeamFee(80,2);  //5% to pot, 10% to aff, 2% to com,
194         fees_[3] = SPCdatasets.TeamFee(80,2);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
195 
196         // how to split up the final pot based on which team was picked
197         // (F3D, P3D)
198         potSplit_[0] = SPCdatasets.PotSplit(20,10);  //48% to winner, 25% to next round, 2% to com
199         potSplit_[1] = SPCdatasets.PotSplit(20,10);  //48% to winner, 25% to next round, 2% to com
200         potSplit_[2] = SPCdatasets.PotSplit(20,10);  //48% to winner, 10% to next round, 2% to com
201         potSplit_[3] = SPCdatasets.PotSplit(20,10);  //48% to winner, 10% to next round, 2% to com
202 
203 		/*
204         activated_ = true;
205 
206         // lets start first round
207         rID_ = 1;
208         round_[1].strt = now + rndExtra_ - rndGap_;
209         round_[1].end = now + rndInit_ + rndExtra_;
210 		*/
211 	}
212 //==============================================================================
213 //     _ _  _  _|. |`. _  _ _  .
214 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
215 //==============================================================================
216     /**
217      * @dev used to make sure no one can interact with contract until it has
218      * been activated.
219      */
220 	modifier isActivated() {
221 	    // Add WangYi 2018-08-10 BEGIN
222 	    if ( activated_ == false )
223 	    {
224 		  if ( (now >= pre_active_time) &&  (pre_active_time > 0) )
225 		  {
226 		    // 自动激活
227 			activated_ = true;
228 
229 			// lets start first round
230 			rID_ = 1;
231 			round_[1].strt = now + rndExtra_ - rndGap_;
232 			round_[1].end = now + rndInit_ + rndExtra_;
233 		  }
234 	    }
235 	    // Add WangYi 2018-08-10 BEGIN
236 
237         require(activated_ == true, "its not ready yet.  check ?eta in discord");
238         _;
239     }
240 
241     /**
242      * @dev prevents contracts from interacting with fomo3d
243      */
244     modifier isHuman() {
245         address _addr = msg.sender;
246         uint256 _codeLength;
247 
248         assembly {_codeLength := extcodesize(_addr)}
249         require(_codeLength == 0, "sorry humans only");
250         _;
251     }
252 
253     /**
254      * @dev sets boundaries for incoming tx
255      */
256     modifier isWithinLimits(uint256 _eth) {
257         require(_eth >= 1000000000, "pocket lint: not a valid currency");
258         require(_eth <= 100000000000000000000000, "no vitalik, no");
259         _;
260     }
261 
262 //==============================================================================
263 //     _    |_ |. _   |`    _  __|_. _  _  _  .
264 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
265 //====|=========================================================================
266     /**
267      * @dev emergency buy uses last stored affiliate ID and team snek
268      */
269     function()
270         isActivated()
271         isHuman()
272         isWithinLimits(msg.value)
273         public
274         payable
275     {
276         // set up our tx event data and determine if player is new or not
277         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
278 
279         // fetch player id
280         uint256 _pID = pIDxAddr_[msg.sender];
281 
282         // buy core
283         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
284     }
285 
286     /**
287      * @dev converts all incoming ethereum to keys.
288      * -functionhash- 0x8f38f309 (using ID for affiliate)
289      * -functionhash- 0x98a0871d (using address for affiliate)
290      * -functionhash- 0xa65b37a1 (using name for affiliate)
291      * @param _affCode the ID/address/name of the player who gets the affiliate fee
292      * @param _team what team is the player playing for?
293      */
294     function buyXid(uint256 _affCode, uint256 _team)
295         isActivated()
296         isHuman()
297         isWithinLimits(msg.value)
298         public
299         payable
300     {
301         // set up our tx event data and determine if player is new or not
302         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
303 
304         // fetch player id
305         uint256 _pID = pIDxAddr_[msg.sender];
306 
307         // manage affiliate residuals
308         // if no affiliate code was given or player tried to use their own, lolz
309         if (_affCode == 0 || _affCode == _pID)
310         {
311             // use last stored affiliate code
312             _affCode = plyr_[_pID].laff;
313 
314         // if affiliate code was given & its not the same as previously stored
315         } else if (_affCode != plyr_[_pID].laff) {
316             // update last affiliate
317             plyr_[_pID].laff = _affCode;
318         }
319 
320         // buy core, team set to 2, snake
321         buyCore(_pID, _affCode, 2, _eventData_);
322     }
323 
324     function buyXaddr(address _affCode, uint256 _team)
325         isActivated()
326         isHuman()
327         isWithinLimits(msg.value)
328         public
329         payable
330     {
331         // set up our tx event data and determine if player is new or not
332         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
333 
334         // fetch player id
335         uint256 _pID = pIDxAddr_[msg.sender];
336 
337         // manage affiliate residuals
338         uint256 _affID;
339         // if no affiliate code was given or player tried to use their own, lolz
340         if (_affCode == address(0) || _affCode == msg.sender)
341         {
342             // use last stored affiliate code
343             _affID = plyr_[_pID].laff;
344 
345         // if affiliate code was given
346         } else {
347             // get affiliate ID from aff Code
348             _affID = pIDxAddr_[_affCode];
349 
350             // if affID is not the same as previously stored
351             if (_affID != plyr_[_pID].laff)
352             {
353                 // update last affiliate
354                 plyr_[_pID].laff = _affID;
355             }
356         }
357 
358         // buy core, team set to 2, snake
359         buyCore(_pID, _affID, 2, _eventData_);
360     }
361 
362     function buyXname(bytes32 _affCode, uint256 _team)
363         isActivated()
364         isHuman()
365         isWithinLimits(msg.value)
366         public
367         payable
368     {
369         // set up our tx event data and determine if player is new or not
370         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
371 
372         // fetch player id
373         uint256 _pID = pIDxAddr_[msg.sender];
374 
375         // manage affiliate residuals
376         uint256 _affID;
377         // if no affiliate code was given or player tried to use their own, lolz
378         if (_affCode == '' || _affCode == plyr_[_pID].name)
379         {
380             // use last stored affiliate code
381             _affID = plyr_[_pID].laff;
382 
383         // if affiliate code was given
384         } else {
385             // get affiliate ID from aff Code
386             _affID = pIDxName_[_affCode];
387 
388             // if affID is not the same as previously stored
389             if (_affID != plyr_[_pID].laff)
390             {
391                 // update last affiliate
392                 plyr_[_pID].laff = _affID;
393             }
394         }
395 
396         // buy core, team set to 2, snake
397         buyCore(_pID, _affID, 2, _eventData_);
398     }
399 
400     /**
401      * @dev essentially the same as buy, but instead of you sending ether
402      * from your wallet, it uses your unwithdrawn earnings.
403      * -functionhash- 0x349cdcac (using ID for affiliate)
404      * -functionhash- 0x82bfc739 (using address for affiliate)
405      * -functionhash- 0x079ce327 (using name for affiliate)
406      * @param _affCode the ID/address/name of the player who gets the affiliate fee
407      * @param _team what team is the player playing for?
408      * @param _eth amount of earnings to use (remainder returned to gen vault)
409      */
410     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
411         isActivated()
412         isHuman()
413         isWithinLimits(_eth)
414         public
415     {
416         // set up our tx event data
417         SPCdatasets.EventReturns memory _eventData_;
418 
419         // fetch player ID
420         uint256 _pID = pIDxAddr_[msg.sender];
421 
422         // manage affiliate residuals
423         // if no affiliate code was given or player tried to use their own, lolz
424         if (_affCode == 0 || _affCode == _pID)
425         {
426             // use last stored affiliate code
427             _affCode = plyr_[_pID].laff;
428 
429         // if affiliate code was given & its not the same as previously stored
430         } else if (_affCode != plyr_[_pID].laff) {
431             // update last affiliate
432             plyr_[_pID].laff = _affCode;
433         }
434 
435         // reload core, team set to 2, snake
436         reLoadCore(_pID, _affCode, _eth, _eventData_);
437     }
438 
439     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
440         isActivated()
441         isHuman()
442         isWithinLimits(_eth)
443         public
444     {
445         // set up our tx event data
446         SPCdatasets.EventReturns memory _eventData_;
447 
448         // fetch player ID
449         uint256 _pID = pIDxAddr_[msg.sender];
450 
451         // manage affiliate residuals
452         uint256 _affID;
453         // if no affiliate code was given or player tried to use their own, lolz
454         if (_affCode == address(0) || _affCode == msg.sender)
455         {
456             // use last stored affiliate code
457             _affID = plyr_[_pID].laff;
458 
459         // if affiliate code was given
460         } else {
461             // get affiliate ID from aff Code
462             _affID = pIDxAddr_[_affCode];
463 
464             // if affID is not the same as previously stored
465             if (_affID != plyr_[_pID].laff)
466             {
467                 // update last affiliate
468                 plyr_[_pID].laff = _affID;
469             }
470         }
471 
472         // reload core, team set to 2, snake
473         reLoadCore(_pID, _affID, _eth, _eventData_);
474     }
475 
476     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
477         isActivated()
478         isHuman()
479         isWithinLimits(_eth)
480         public
481     {
482         // set up our tx event data
483         SPCdatasets.EventReturns memory _eventData_;
484 
485         // fetch player ID
486         uint256 _pID = pIDxAddr_[msg.sender];
487 
488         // manage affiliate residuals
489         uint256 _affID;
490         // if no affiliate code was given or player tried to use their own, lolz
491         if (_affCode == '' || _affCode == plyr_[_pID].name)
492         {
493             // use last stored affiliate code
494             _affID = plyr_[_pID].laff;
495 
496         // if affiliate code was given
497         } else {
498             // get affiliate ID from aff Code
499             _affID = pIDxName_[_affCode];
500 
501             // if affID is not the same as previously stored
502             if (_affID != plyr_[_pID].laff)
503             {
504                 // update last affiliate
505                 plyr_[_pID].laff = _affID;
506             }
507         }
508 
509         // reload core, team set to 2, snake
510         reLoadCore(_pID, _affID, _eth, _eventData_);
511     }
512 
513     /**
514      * @dev withdraws all of your earnings.
515      * -functionhash- 0x3ccfd60b
516      */
517     function withdraw()
518         isActivated()
519         isHuman()
520         public
521     {
522         // setup local rID
523 
524         // grab time
525         uint256 _now = now;
526 
527         // fetch player ID
528         uint256 _pID = pIDxAddr_[msg.sender];
529 
530         // setup temp var for player eth
531 		uint256 upperLimit = 0;
532 		uint256 usedGen = 0;
533 
534 		// eth send to player
535 		uint256 ethout = 0;		
536 		
537 		// 超限收益
538 		uint256 over_gen = 0;
539 
540 		// update gen vault
541 		updateGenVault(_pID, plyr_[_pID].lrnd);
542 
543 		// 当前现存收益
544 		// 先触发限收检测和处理
545 		if (plyr_[_pID].gen > 0)
546 		{
547 			upperLimit = (calceth(plyrRnds_[_pID][rID_].keys).mul(105))/100;
548 			if(plyr_[_pID].gen >= upperLimit)
549 			{
550 				// 超限收益部分
551 				over_gen = (plyr_[_pID].gen).sub(upperLimit);
552 				// keys清零
553 				round_[rID_].keys = (round_[rID_].keys).sub(plyrRnds_[_pID][rID_].keys);
554 				plyrRnds_[_pID][rID_].keys = 0;
555 
556 				// 超出部分转交admin
557 				admin.transfer(over_gen);
558 					
559 				//可用gen
560 				usedGen = upperLimit;				
561 			}
562 			else
563 			{
564 				// keys一部分清减，对应全部gen的量
565 				plyrRnds_[_pID][rID_].keys = (plyrRnds_[_pID][rID_].keys).sub(calckeys(((plyr_[_pID].gen).mul(100))/105));
566 				round_[rID_].keys = (round_[rID_].keys).sub(calckeys(((plyr_[_pID].gen).mul(100))/105));
567 				//可用gen
568 				usedGen = plyr_[_pID].gen;
569 			}
570 
571 			ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
572 		}
573 		else
574 		{
575 			ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff));
576 		}
577 
578 		plyr_[_pID].win = 0;
579 		plyr_[_pID].gen = 0;
580 		plyr_[_pID].aff = 0;
581 
582 		plyr_[_pID].addr.transfer(ethout);
583 
584         // check to see if round has ended and no one has run round end yet
585         if (_now > round_[rID_].end && round_[rID_].ended == false && round_[rID_].plyr != 0)
586         {
587             // set up our tx event data
588             SPCdatasets.EventReturns memory _eventData_;
589 
590             // end the round (distributes pot)
591 			round_[rID_].ended = true;
592             _eventData_ = endRound(_eventData_);
593 
594             // build event data
595             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
596             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
597 
598             // fire withdraw and distribute event
599             emit SPCevents.onWithdrawAndDistribute
600             (
601                 msg.sender,
602                 plyr_[_pID].name,
603                 ethout,
604                 _eventData_.compressedData,
605                 _eventData_.compressedIDs,
606                 _eventData_.winnerAddr,
607                 _eventData_.winnerName,
608                 _eventData_.amountWon,
609                 _eventData_.newPot,
610                 _eventData_.P3DAmount,
611                 _eventData_.genAmount
612             );
613 
614         // in any other situation
615         } else {
616             // fire withdraw event
617             emit SPCevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, ethout, _now);
618         }
619     }
620 
621     /**
622      * @dev use these to register names.  they are just wrappers that will send the
623      * registration requests to the PlayerBook contract.  So registering here is the
624      * same as registering there.  UI will always display the last name you registered.
625      * but you will still own all previously registered names to use as affiliate
626      * links.
627      * - must pay a registration fee.
628      * - name must be unique
629      * - names will be converted to lowercase
630      * - name cannot start or end with a space
631      * - cannot have more than 1 space in a row
632      * - cannot be only numbers
633      * - cannot start with 0x
634      * - name must be at least 1 char
635      * - max length of 32 characters long
636      * - allowed characters: a-z, 0-9, and space
637      * -functionhash- 0x921dec21 (using ID for affiliate)
638      * -functionhash- 0x3ddd4698 (using address for affiliate)
639      * -functionhash- 0x685ffd83 (using name for affiliate)
640      * @param _nameString players desired name
641      * @param _affCode affiliate ID, address, or name of who referred you
642      * @param _all set to true if you want this to push your info to all games
643      * (this might cost a lot of gas)
644      */
645     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
646         isHuman()
647         public
648         payable
649     {
650         bytes32 _name = _nameString.nameFilter();
651         address _addr = msg.sender;
652         uint256 _paid = msg.value;
653         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
654 
655         uint256 _pID = pIDxAddr_[_addr];
656 
657         // fire event
658         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
659     }
660 
661     function registerNameXaddr(string _nameString, address _affCode, bool _all)
662         isHuman()
663         public
664         payable
665     {
666         bytes32 _name = _nameString.nameFilter();
667         address _addr = msg.sender;
668         uint256 _paid = msg.value;
669         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
670 
671         uint256 _pID = pIDxAddr_[_addr];
672 
673         // fire event
674         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
675     }
676 
677     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
678         isHuman()
679         public
680         payable
681     {
682         bytes32 _name = _nameString.nameFilter();
683         address _addr = msg.sender;
684         uint256 _paid = msg.value;
685         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
686 
687         uint256 _pID = pIDxAddr_[_addr];
688 
689         // fire event
690         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
691     }
692 //==============================================================================
693 //     _  _ _|__|_ _  _ _  .
694 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
695 //=====_|=======================================================================
696     /**
697      * @dev return the price buyer will pay for next 1 individual key.
698      * -functionhash- 0x018a25e8
699      * @return price for next key bought (in wei format)
700      */
701     function getBuyPrice()
702         public
703         view
704         returns(uint256)
705     {
706 		// price 0.01 ETH
707 		return(10000000000000000);
708     }
709 
710     /**
711      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
712      * provider
713      * -functionhash- 0xc7e284b8
714      * @return time left in seconds
715      */
716     function getTimeLeft()
717         public
718         view
719         returns(uint256)
720     {
721         // setup local rID
722         uint256 _rID = rID_;
723 
724         // grab time
725         uint256 _now = now;
726 
727         if (_now < round_[_rID].end)
728             if (_now > round_[_rID].strt + rndGap_)
729                 return( (round_[_rID].end).sub(_now) );
730             else
731                 return( (round_[_rID].strt + rndGap_).sub(_now) );
732         else
733             return(0);
734     }
735 
736     /**
737      * @dev returns player earnings per vaults
738      * -functionhash- 0x63066434
739      * @return winnings vault
740      * @return general vault
741      * @return affiliate vault
742      */
743     function getPlayerVaults(uint256 _pID)
744         public
745         view
746         returns(uint256 ,uint256, uint256)
747     {
748         // setup local rID
749         uint256 _rID = rID_;
750 
751         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
752 		return
753         (
754             plyr_[_pID].win,
755             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
756             plyr_[_pID].aff
757         );
758     }
759 
760      /**
761      * @dev returns all current round info needed for front end
762      * -functionhash- 0x747dff42
763      * @return eth invested during ICO phase
764      * @return round id
765      * @return total keys for round
766      * @return time round ends
767      * @return time round started
768      * @return current pot
769      * @return current team ID & player ID in lead
770      * @return current player in leads address
771      * @return current player in leads name
772      * @return whales eth in for round
773      * @return bears eth in for round
774      * @return sneks eth in for round
775      * @return bulls eth in for round
776      * @return airdrop tracker # & airdrop pot
777      */
778     function getCurrentRoundInfo()
779         public
780         view
781         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
782     {
783         // setup local rID
784         uint256 _rID = rID_;
785 
786         return
787         (
788             round_[_rID].ico,               //0
789             _rID,                           //1
790             round_[_rID].keys,              //2
791             round_[_rID].end,               //3
792             round_[_rID].strt,              //4
793             round_[_rID].pot,               //5
794             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
795             plyr_[round_[_rID].plyr].addr,  //7
796             plyr_[round_[_rID].plyr].name,  //8
797             rndTmEth_[_rID][0],             //9
798             rndTmEth_[_rID][1],             //10
799             rndTmEth_[_rID][2],             //11
800             rndTmEth_[_rID][3],             //12
801             airDropTracker_ + (airDropPot_ * 1000)              //13
802         );
803     }
804 
805     /**
806      * @dev returns player info based on address.  if no address is given, it will
807      * use msg.sender
808      * -functionhash- 0xee0b5d8b
809      * @param _addr address of the player you want to lookup
810      * @return player ID
811      * @return player name
812      * @return keys owned (current round)
813      * @return winnings vault
814      * @return general vault
815      * @return affiliate vault
816 	 * @return player round eth
817      */
818     function getPlayerInfoByAddress(address _addr)
819         public
820         view
821         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
822     {
823         // setup local rID
824         uint256 _rID = rID_;
825 
826         if (_addr == address(0))
827         {
828             _addr == msg.sender;
829         }
830         uint256 _pID = pIDxAddr_[_addr];
831 
832         return
833         (
834             _pID,                               //0
835             plyr_[_pID].name,                   //1
836             plyrRnds_[_pID][_rID].keys,         //2
837             plyr_[_pID].win,                    //3
838             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
839             plyr_[_pID].aff,                    //5
840             plyrRnds_[_pID][_rID].eth           //6
841         );
842     }
843 
844 //==============================================================================
845 //     _ _  _ _   | _  _ . _  .
846 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
847 //=====================_|=======================================================
848     /**
849      * @dev logic runs whenever a buy order is executed.  determines how to handle
850      * incoming eth depending on if we are in an active round or not
851      */
852     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
853         private
854     {
855         // setup local rID
856         uint256 _rID = rID_;
857 
858         // grab time
859         uint256 _now = now;
860 
861         // if round is active
862         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
863         {
864             // call core
865             core(_rID, _pID, msg.value, _affID, 2, _eventData_);
866 
867         // if round is not active
868         } else {
869             // check to see if end round needs to be ran
870             if (_now > round_[_rID].end && round_[_rID].ended == false)
871             {
872                 // end the round (distributes pot) & start new round
873 			    round_[_rID].ended = true;
874                 _eventData_ = endRound(_eventData_);
875 
876                 // build event data
877                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
878                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
879 
880                 // fire buy and distribute event
881                 emit SPCevents.onBuyAndDistribute
882                 (
883                     msg.sender,
884                     plyr_[_pID].name,
885                     msg.value,
886                     _eventData_.compressedData,
887                     _eventData_.compressedIDs,
888                     _eventData_.winnerAddr,
889                     _eventData_.winnerName,
890                     _eventData_.amountWon,
891                     _eventData_.newPot,
892                     _eventData_.P3DAmount,
893                     _eventData_.genAmount
894                 );
895             }
896 
897             // 未开局时候的购买，买不到有效key。但仍然是属于玩家的代币。put eth in players vault, 放在win vault
898 			plyr_[_pID].win = plyr_[_pID].win.add(msg.value);
899         }
900     }
901 
902     /**
903      * @dev gen limit handle
904      */
905 	function genLimit(uint256 _pID) 
906 		private 
907 		returns(uint256)
908 	{
909 		uint256 upperLimit = 0;
910 		uint256 usedGen = 0;
911 		
912 		// 超限收益
913 		uint256 over_gen = 0;
914 
915 		// 实际能用的额
916 		uint256 eth_can_use = 0;
917 
918 		// 中间变量
919 		uint256 tempnum = 0;
920 
921 		updateGenVault(_pID, plyr_[_pID].lrnd);
922 
923 		// 当前现存收益
924 		// 先触发限收检测和处理
925 		if (plyr_[_pID].gen > 0)
926 		{
927 			upperLimit = ((plyrRnds_[_pID][rID_].keys).mul(105))/10000;
928 			if(plyr_[_pID].gen >= upperLimit)
929 			{
930 				// 超限收益部分
931 				over_gen = (plyr_[_pID].gen).sub(upperLimit);
932 
933 				// keys清零
934 				round_[rID_].keys = (round_[rID_].keys).sub(plyrRnds_[_pID][rID_].keys);
935 				plyrRnds_[_pID][rID_].keys = 0;
936 
937 				// 超出部分转交admin
938 				admin.transfer(over_gen);
939 					
940 				//可用gen
941 				usedGen = upperLimit;
942 			}
943 			else
944 			{
945 				tempnum = ((plyr_[_pID].gen).mul(10000))/105;
946 				// keys一部分清减，对应全部gen的量
947 				plyrRnds_[_pID][rID_].keys = (plyrRnds_[_pID][rID_].keys).sub(tempnum);
948 				round_[rID_].keys = (round_[rID_].keys).sub(tempnum);
949 				//可用gen为全部gen
950 				usedGen = plyr_[_pID].gen;
951 			}
952 
953 			eth_can_use = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
954 
955 			// 最多这么多代币可以买keys, 并且三个分类账都减为0
956 			plyr_[_pID].win = 0;
957 			plyr_[_pID].gen = 0;
958 			plyr_[_pID].aff = 0;
959 		}
960 		else
961 		{
962 			// 没有gen时候，用win和aff的代币额的量来买，并且这两个分类账都减为0
963 			eth_can_use = (plyr_[_pID].win).add(plyr_[_pID].aff);
964 			plyr_[_pID].win = 0;
965 			plyr_[_pID].aff = 0;
966 		}
967 
968 		return(eth_can_use);
969 	}
970 
971 	/**
972      * @dev logic runs whenever a reload order is executed.  determines how to handle
973      * incoming eth depending on if we are in an active round or not
974      */
975     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, SPCdatasets.EventReturns memory _eventData_)
976         private
977     {
978         // setup local rID
979 
980         // grab time
981         uint256 _now = now;
982 
983 		// 实际能用的额
984 		uint256 eth_can_use = 0;
985 
986         // if round is active
987         if (_now > round_[rID_].strt + rndGap_ && (_now <= round_[rID_].end || (_now > round_[rID_].end && round_[rID_].plyr == 0)))
988         {
989             // get earnings from all vaults and return unused to gen vault
990             // because we use a custom safemath library.  this will throw if player
991             // tried to spend more eth than they have.
992 
993 			// 对上限处理, 现在要求all in！ 用分红购买时，会使用全部已有收益购买！
994 			eth_can_use = genLimit(_pID);
995 			if(eth_can_use > 0)
996 			{
997 				// call core
998 				core(rID_, _pID, eth_can_use, _affID, 2, _eventData_);
999 			}
1000 
1001         // if round is not active and end round needs to be ran
1002         } else if (_now > round_[rID_].end && round_[rID_].ended == false) {
1003             // end the round (distributes pot) & start new round
1004             round_[rID_].ended = true;
1005             _eventData_ = endRound(_eventData_);
1006 
1007             // build event data
1008             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1009             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1010 
1011             // fire buy and distribute event
1012             emit SPCevents.onReLoadAndDistribute
1013             (
1014                 msg.sender,
1015                 plyr_[_pID].name,
1016                 _eventData_.compressedData,
1017                 _eventData_.compressedIDs,
1018                 _eventData_.winnerAddr,
1019                 _eventData_.winnerName,
1020                 _eventData_.amountWon,
1021                 _eventData_.newPot,
1022                 _eventData_.P3DAmount,
1023                 _eventData_.genAmount
1024             );
1025         }
1026     }
1027 
1028     /**
1029      * @dev this is the core logic for any buy/reload that happens while a round
1030      * is live.
1031      */
1032     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
1033         private
1034     {
1035         // if player is new to round，只在玩家在本局第一次购keys时处理。
1036         if (plyrRnds_[_pID][_rID].jionflag != 1)
1037 		{
1038             _eventData_ = managePlayer(_pID, _eventData_);
1039 			plyrRnds_[_pID][_rID].jionflag = 1;
1040 		}
1041 
1042 		if (_eth > 10000000000000000)
1043         {
1044 
1045             // mint the new keys
1046             uint256 _keys = calckeys(_eth);
1047 
1048             // if they bought at least 1 whole key
1049             if (_keys >= 1000000000000000000)
1050             {
1051 				updateTimer(_keys, _rID);
1052 
1053 				// set new leaders
1054 				if (round_[_rID].plyr != _pID)
1055 					round_[_rID].plyr = _pID;
1056 
1057 				// 改为只有一个队伍2
1058 				round_[_rID].team = 2;
1059 
1060 				// set the new leader bool to true
1061 				_eventData_.compressedData = _eventData_.compressedData + 100;
1062 			}
1063 
1064             // update player
1065             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1066             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1067 
1068             // update round
1069             round_[_rID].keys = _keys.add(round_[_rID].keys);
1070             round_[_rID].eth = _eth.add(round_[_rID].eth);
1071 			rndTmEth_[_rID][2] = _eth.add(rndTmEth_[_rID][2]);
1072 
1073             // distribute eth
1074 			_eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 2, _eventData_);
1075             _eventData_ = distributeInternal(_rID, _pID, _eth, 2, _keys, _eventData_);
1076 
1077             // call end tx function to fire end tx event.
1078 			endTx(_pID, 2, _eth, _keys, _eventData_);
1079         }
1080     }
1081 //==============================================================================
1082 //     _ _ | _   | _ _|_ _  _ _  .
1083 //    (_(_||(_|_||(_| | (_)| _\  .
1084 //==============================================================================
1085     /**
1086      * @dev calculates unmasked earnings (just calculates, does not update mask)
1087      * @return earnings in wei format
1088      */
1089     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1090         private
1091         view
1092         returns(uint256)
1093     {
1094 		uint256 temp;
1095 		temp = (round_[_rIDlast].mask).mul((plyrRnds_[_pID][_rIDlast].keys)/1000000000000000000);
1096 		if(temp > plyrRnds_[_pID][_rIDlast].mask)
1097 		{
1098 			return( temp.sub(plyrRnds_[_pID][_rIDlast].mask) );
1099 		}
1100 		else
1101 		{
1102 			return( 0 );
1103 		}
1104     }
1105 
1106     /**
1107      * @dev returns the amount of keys you would get given an amount of eth.
1108      * -functionhash- 0xce89c80c
1109      * @param _rID round ID you want price for
1110      * @param _eth amount of eth sent in
1111      * @return keys received
1112      */
1113     function calcKeysReceived(uint256 _rID, uint256 _eth)
1114         public
1115         view
1116         returns(uint256)
1117     {
1118 		return ( calckeys(_eth) );
1119     }
1120 
1121     /**
1122      * @dev returns current eth price for X keys.
1123      * -functionhash- 0xcf808000
1124      * @param _keys number of keys desired (in 18 decimal format)
1125      * @return amount of eth needed to send
1126      */
1127     function iWantXKeys(uint256 _keys)
1128         public
1129         view
1130         returns(uint256)
1131     {
1132 		return ( _keys/100 );
1133     }
1134 //==============================================================================
1135 //    _|_ _  _ | _  .
1136 //     | (_)(_)|_\  .
1137 //==============================================================================
1138     /**
1139 	 * @dev receives name/player info from names contract
1140      */
1141     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1142         external
1143     {
1144         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1145         if (pIDxAddr_[_addr] != _pID)
1146             pIDxAddr_[_addr] = _pID;
1147         if (pIDxName_[_name] != _pID)
1148             pIDxName_[_name] = _pID;
1149         if (plyr_[_pID].addr != _addr)
1150             plyr_[_pID].addr = _addr;
1151         if (plyr_[_pID].name != _name)
1152             plyr_[_pID].name = _name;
1153         if (plyr_[_pID].laff != _laff)
1154             plyr_[_pID].laff = _laff;
1155         if (plyrNames_[_pID][_name] == false)
1156             plyrNames_[_pID][_name] = true;
1157     }
1158 
1159     /**
1160      * @dev receives entire player name list
1161      */
1162     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1163         external
1164     {
1165         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1166         if(plyrNames_[_pID][_name] == false)
1167             plyrNames_[_pID][_name] = true;
1168     }
1169 
1170     /**
1171      * @dev gets existing or registers new pID.  use this when a player may be new
1172      * @return pID
1173      */
1174     function determinePID(SPCdatasets.EventReturns memory _eventData_)
1175         private
1176         returns (SPCdatasets.EventReturns)
1177     {
1178         uint256 _pID = pIDxAddr_[msg.sender];
1179         // if player is new to this version of fomo3d
1180         if (_pID == 0)
1181         {
1182             // grab their player ID, name and last aff ID, from player names contract
1183             _pID = PlayerBook.getPlayerID(msg.sender);
1184             bytes32 _name = PlayerBook.getPlayerName(_pID);
1185             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1186 
1187             // set up player account
1188             pIDxAddr_[msg.sender] = _pID;
1189             plyr_[_pID].addr = msg.sender;
1190 
1191             if (_name != "")
1192             {
1193                 pIDxName_[_name] = _pID;
1194                 plyr_[_pID].name = _name;
1195                 plyrNames_[_pID][_name] = true;
1196             }
1197 
1198             if (_laff != 0 && _laff != _pID)
1199                 plyr_[_pID].laff = _laff;
1200 
1201             // set the new player bool to true
1202             _eventData_.compressedData = _eventData_.compressedData + 1;
1203         }
1204         return (_eventData_);
1205     }
1206 
1207     /**
1208      * @dev decides if round end needs to be run & new round started.  and if
1209      * player unmasked earnings from previously played rounds need to be moved.
1210      */
1211     function managePlayer(uint256 _pID, SPCdatasets.EventReturns memory _eventData_)
1212         private
1213         returns (SPCdatasets.EventReturns)
1214     {
1215 		uint256 temp_eth = 0;
1216         // if player has played a previous round, move their unmasked earnings
1217         // from that round to win vault. 玩家早前的跨局遗留的收益转入当前win账户，不混入当前局的gen账户
1218         if (plyr_[_pID].lrnd != 0)
1219 		{
1220             updateGenVault(_pID, plyr_[_pID].lrnd);
1221 			temp_eth = ((plyr_[_pID].win).add((plyr_[_pID].gen))).add(plyr_[_pID].aff);
1222 
1223 			plyr_[_pID].gen = 0;
1224 			plyr_[_pID].aff = 0;
1225 			plyr_[_pID].win = temp_eth;
1226 		}
1227 
1228         // update player's last round played
1229         plyr_[_pID].lrnd = rID_;
1230 
1231         // set the joined round bool to true
1232         _eventData_.compressedData = _eventData_.compressedData + 10;
1233 
1234         return(_eventData_);
1235     }
1236 
1237     /**
1238      * @dev ends the round. manages paying out winner/splitting up pot
1239      */
1240     function endRound(SPCdatasets.EventReturns memory _eventData_)
1241         private
1242         returns (SPCdatasets.EventReturns)
1243     {
1244         // setup local rID
1245         uint256 _rID = rID_;
1246 
1247         // grab our winning player and team id's
1248         uint256 _winPID = round_[_rID].plyr;
1249         uint256 _winTID = round_[_rID].team;
1250 
1251         // grab our pot amount
1252         uint256 _pot = round_[_rID].pot;
1253 
1254         // calculate our winner share, community rewards, gen share,
1255         // p3d share, and amount reserved for next pot
1256         uint256 _win = (_pot.mul(30)) / 100;
1257         uint256 _com = (_pot / 10);
1258         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1259         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1260         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1261 
1262         // calculate ppt for round mask
1263         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1264         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1265         if (_dust > 0)
1266         {
1267             _gen = _gen.sub(_dust);
1268         }
1269 
1270         // pay our winner
1271         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1272 
1273         // community rewards
1274         _com = _com.add(_p3d.sub(_p3d / 2));
1275         admin.transfer(_com);
1276 
1277         _res = _res.add(_p3d / 2);
1278 
1279         // distribute gen portion to key holders
1280         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1281 
1282         // prepare event data
1283         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1284         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1285         _eventData_.winnerAddr = plyr_[_winPID].addr;
1286         _eventData_.winnerName = plyr_[_winPID].name;
1287         _eventData_.amountWon = _win;
1288         _eventData_.genAmount = _gen;
1289         _eventData_.P3DAmount = _p3d;
1290         _eventData_.newPot = _res;
1291 
1292         // start next round
1293         rID_++;
1294         _rID++;
1295         round_[_rID].strt = now;
1296         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1297         round_[_rID].pot = _res;
1298 
1299         return(_eventData_);
1300     }
1301 
1302 	/**
1303      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1304      */
1305     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1306         private
1307     {
1308         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1309         if (_earnings > 0)
1310         {
1311             // put in gen vault
1312             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1313             // zero out their earnings by updating mask
1314             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1315         }
1316     }
1317 
1318     /**
1319      * @dev updates round timer based on number of whole keys bought.
1320      */
1321     function updateTimer(uint256 _keys, uint256 _rID)
1322         private
1323     {
1324         // grab time
1325         uint256 _now = now;
1326 
1327         // calculate time based on number of keys bought
1328         uint256 _newTime;
1329         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1330             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1331         else
1332             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1333 
1334         // compare to max and set new end time
1335         if (_newTime < (rndMax_).add(_now))
1336             round_[_rID].end = _newTime;
1337         else
1338             round_[_rID].end = rndMax_.add(_now);
1339     }
1340 
1341     /**
1342      * @dev distributes eth based on fees to com, aff, and p3d
1343      */
1344     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
1345         private
1346         returns(SPCdatasets.EventReturns)
1347     {
1348         // pay 3% out to community rewards
1349         uint256 _p3d = (_eth/100).mul(3);
1350 
1351 // ----------------------------------------
1352 //  BEGIN  Modify by WangYi      2018-08-02
1353 // ----------------------------------------
1354 //
1355 // 开始处理 3级邀请分配制度，规则
1356 // 第一级 2%
1357 //   第二级 3%
1358 //     第三级 5%
1359 // 如果没有，则直接进入 admin
1360 //
1361 // ----------------------------------------
1362               
1363         // distribute share to affiliate
1364         // 三级分配比例 5%:3%:2%
1365         uint256 _aff_cent = (_eth) / 100;
1366         
1367         // 三级邀请ID
1368         uint256 tempID  = _affID;
1369 
1370         // decide what to do with affiliate share of fees
1371         // affiliate must not be self, and must have a name registered
1372         
1373         //第三级 5%
1374         if (tempID != _pID && plyr_[tempID].name != '') 
1375         { 
1376             plyr_[tempID].aff = (_aff_cent.mul(5)).add(plyr_[tempID].aff);
1377             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(5), now);
1378         } 
1379         else 
1380         {
1381         	  // 存入ADMIN 用户
1382             _p3d = _p3d.add(_aff_cent.mul(5));
1383         }
1384         
1385 
1386         //查找第二级
1387         tempID = PlayerBook.getPlayerID(plyr_[tempID].addr);
1388         tempID = PlayerBook.getPlayerLAff(tempID);
1389 
1390         if (tempID != _pID && plyr_[tempID].name != '') 
1391         { 
1392             plyr_[tempID].aff = (_aff_cent.mul(3)).add(plyr_[tempID].aff);
1393             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(3), now);
1394         } 
1395         else 
1396         {
1397         	  // 存入ADMIN 用户
1398             _p3d = _p3d.add(_aff_cent.mul(3));
1399         }
1400         
1401         //查找第一级
1402         tempID = PlayerBook.getPlayerID(plyr_[tempID].addr);
1403         tempID = PlayerBook.getPlayerLAff(tempID);
1404 
1405         if (tempID != _pID && plyr_[tempID].name != '') 
1406         { 
1407             plyr_[tempID].aff = (_aff_cent.mul(2)).add(plyr_[tempID].aff);
1408             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(2), now);
1409         } 
1410         else 
1411         {
1412         	  // 存入ADMIN 用户
1413             _p3d = _p3d.add(_aff_cent.mul(2));
1414         }
1415 
1416 // ----------------------------------------
1417 // END     Modify by WangYi      2018-08-02
1418 // ----------------------------------------
1419 
1420         // pay out p3d
1421 		_p3d = _p3d.add((_eth.mul(fees_[2].p3d)) / (100));
1422         if (_p3d > 0)
1423         {
1424 			admin.transfer(_p3d);
1425             // set up event data
1426             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1427         }
1428 
1429         return(_eventData_);
1430     }
1431 
1432 	/**
1433      * @dev 管理可以把外部资金注入下一局奖池，扩大吸引力。
1434      */
1435     function potSwap()
1436         external
1437         payable
1438     {
1439         // setup local rID
1440         uint256 _rID = rID_ + 1;
1441 
1442         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1443         emit SPCevents.onPotSwapDeposit(_rID, msg.value);
1444     }
1445 
1446     /**
1447      * @dev distributes eth based on fees to gen and pot
1448      */
1449     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, SPCdatasets.EventReturns memory _eventData_)
1450         private
1451         returns(SPCdatasets.EventReturns)
1452     {
1453         // calculate gen share，本版本为80%
1454 		uint256 _gen = (_eth.mul(fees_[2].gen)) / 100;
1455 
1456         // pot份额为 5%
1457         uint256 _pot = (_eth.mul(5)) / 100;
1458 
1459         // distribute gen share (thats what updateMasks() does) and adjust
1460         // balances for dust.
1461         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1462         //if (_dust > 0)
1463         //    _gen = _gen.sub(_dust);
1464 
1465         // add eth to pot
1466         round_[_rID].pot = _pot.add(round_[_rID].pot);
1467 
1468         // set up event data
1469         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1470         _eventData_.potAmount = _pot;
1471 
1472         return(_eventData_);
1473     }
1474 
1475     /**
1476      * @dev updates masks for round and player when keys are bought
1477      * @return dust left over
1478      */
1479     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1480         private
1481         returns(uint256)
1482     {
1483         /* MASKING NOTES
1484             earnings masks are a tricky thing for people to wrap their minds around.
1485             the basic thing to understand here.  is were going to have a global
1486             tracker based on profit per share for each round, that increases in
1487             relevant proportion to the increase in share supply.
1488 
1489             the player will have an additional mask that basically says "based
1490             on the rounds mask, my shares, and how much i've already withdrawn,
1491             how much is still owed to me?"
1492         */
1493 
1494         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1495         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1496         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1497 
1498         // calculate player earning from their own buy (only based on the keys
1499         // they just bought).  & update player earnings mask
1500         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1501         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1502 
1503         // calculate & return dust
1504         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1505     }
1506 
1507     /**
1508      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1509      * @return earnings in wei format
1510      */
1511     function withdrawEarnings(uint256 _pID)
1512         private
1513         returns(uint256)
1514     {
1515         // update gen vault
1516         updateGenVault(_pID, plyr_[_pID].lrnd);
1517 
1518         // from vaults
1519         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1520         if (_earnings > 0)
1521         {
1522             plyr_[_pID].win = 0;
1523             plyr_[_pID].gen = 0;
1524             plyr_[_pID].aff = 0;
1525         }
1526 
1527         return(_earnings);
1528     }
1529 	
1530 	/**
1531      * @dev prepares compression data and fires event for buy or reload tx's
1532      */
1533     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, SPCdatasets.EventReturns memory _eventData_)
1534         private
1535     {
1536 		_eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (2 * 100000000000000000000000000000);
1537         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1538 
1539         emit SPCevents.onEndTx
1540         (
1541             _eventData_.compressedData,
1542             _eventData_.compressedIDs,
1543             plyr_[_pID].name,
1544             msg.sender,
1545             _eth,
1546             _keys,
1547             _eventData_.winnerAddr,
1548             _eventData_.winnerName,
1549             _eventData_.amountWon,
1550             _eventData_.newPot,
1551             _eventData_.P3DAmount,
1552             _eventData_.genAmount,
1553             _eventData_.potAmount,
1554             airDropPot_
1555         );
1556     }
1557 //==============================================================================
1558 //    (~ _  _    _._|_    .
1559 //    _)(/_(_|_|| | | \/  .
1560 //====================/=========================================================
1561     /** upon contract deploy, it will be deactivated.  this is a one time
1562      * use function that will activate the contract.  we do this so devs
1563      * have time to set things up on the web end                            **/
1564 	bool public activated_ = false;
1565     // ----------------------------------------
1566     // Add WY 2018-8-10 BEGIN
1567     // ----------------------------------------
1568     // 预激活时间 
1569     uint256 public pre_active_time = 0;
1570     
1571     /**
1572      * @dev return active flag 、time
1573      * @return active flag
1574      * @return active time
1575      * @return system time
1576      */
1577     function getRunInfo() public view returns(bool, uint256, uint256)
1578     {
1579         return
1580         (
1581             activated_,      //0
1582             pre_active_time, //1
1583             now          //2			
1584         );
1585     }
1586 
1587     function setPreActiveTime(uint256 _pre_time) public
1588     {
1589         // only team just can activate
1590         require(msg.sender == admin, "only admin can activate"); 
1591         pre_active_time = _pre_time;
1592     }
1593 
1594     // ----------------------------------------
1595     // Add WY 2018-8-10 END
1596     // ----------------------------------------
1597     function activate()
1598         public
1599     {
1600         // only team just can activate
1601         require(msg.sender == admin, "only admin can activate"); 
1602 
1603         // can only be ran once
1604         require(activated_ == false, "FOMO Short already activated");
1605 
1606         // activate the contract
1607         activated_ = true;
1608         //activated_ = false;
1609 
1610         // lets start first round
1611         rID_ = 1;
1612 		round_[1].strt = now + rndExtra_ - rndGap_;
1613 		round_[1].end = now + rndInit_ + rndExtra_;
1614     }
1615 
1616 //==============================================================================
1617 //  |  _      _ _ | _  .
1618 //  |<(/_\/  (_(_||(_  .
1619 //=======/======================================================================
1620 	function calckeys(uint256 _eth)
1621         pure
1622 		public
1623         returns(uint256)
1624     {
1625 		return ( (_eth).mul(100) );
1626     }
1627 
1628     /**
1629      * @dev calculates how much eth would be in contract given a number of keys
1630      * @param _keys number of keys "in contract"
1631      * @return eth that would exists
1632      */
1633     function calceth(uint256 _keys)
1634         pure
1635 		public
1636         returns(uint256)
1637     {
1638 		return( (_keys)/100 );
1639     }	
1640 }
1641 
1642 //==============================================================================
1643 //   __|_ _    __|_ _  .
1644 //  _\ | | |_|(_ | _\  .
1645 //==============================================================================
1646 library SPCdatasets {
1647     //compressedData key
1648     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1649         // 0 - new player (bool)
1650         // 1 - joined round (bool)
1651         // 2 - new  leader (bool)
1652         // 3-5 - air drop tracker (uint 0-999)
1653         // 6-16 - round end time
1654         // 17 - winnerTeam
1655         // 18 - 28 timestamp
1656         // 29 - team
1657         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1658         // 31 - airdrop happened bool
1659         // 32 - airdrop tier
1660         // 33 - airdrop amount won
1661     //compressedIDs key
1662     // [77-52][51-26][25-0]
1663         // 0-25 - pID
1664         // 26-51 - winPID
1665         // 52-77 - rID
1666     struct EventReturns {
1667         uint256 compressedData;
1668         uint256 compressedIDs;
1669         address winnerAddr;         // winner address
1670         bytes32 winnerName;         // winner name
1671         uint256 amountWon;          // amount won
1672         uint256 newPot;             // amount in new pot
1673         uint256 P3DAmount;          // amount distributed to p3d
1674         uint256 genAmount;          // amount distributed to gen
1675         uint256 potAmount;          // amount added to pot
1676     }
1677     struct Player {
1678         address addr;   // player address
1679         bytes32 name;   // player name
1680         uint256 win;    // winnings vault
1681         uint256 gen;    // general vault
1682         uint256 aff;    // affiliate vault
1683         uint256 lrnd;   // last round played
1684         uint256 laff;   // last affiliate id used
1685     }
1686     struct PlayerRounds {
1687         uint256 eth;    // eth player has added to round (used for eth limiter)
1688         uint256 keys;   // keys
1689         uint256 mask;   // player mask
1690 		uint256 jionflag;   // player not jion round 尚未参加此局。
1691         uint256 ico;    // ICO phase investment
1692     }
1693     struct Round {
1694         uint256 plyr;   // pID of player in lead
1695         uint256 team;   // tID of team in lead
1696         uint256 end;    // time ends/ended
1697         bool ended;     // has round end function been ran
1698         uint256 strt;   // time round started
1699         uint256 keys;   // keys
1700         uint256 eth;    // total eth in
1701         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1702         uint256 mask;   // global mask
1703         uint256 ico;    // total eth sent in during ICO phase
1704         uint256 icoGen; // total eth for gen during ICO phase
1705         uint256 icoAvg; // average key price for ICO phase
1706     }
1707     struct TeamFee {
1708         uint256 gen;    // % of buy in thats paid to key holders of current round
1709         uint256 p3d;    // % of buy in thats paid to p3d holders
1710     }
1711     struct PotSplit {
1712         uint256 gen;    // % of pot thats paid to key holders of current round
1713         uint256 p3d;    // % of pot thats paid to p3d holders
1714     }
1715 }
1716 
1717 //==============================================================================
1718 //  . _ _|_ _  _ |` _  _ _  _  .
1719 //  || | | (/_| ~|~(_|(_(/__\  .
1720 //==============================================================================
1721 
1722 interface PlayerBookInterface {
1723     function getPlayerID(address _addr) external returns (uint256);
1724     function getPlayerName(uint256 _pID) external view returns (bytes32);
1725     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1726     function getPlayerAddr(uint256 _pID) external view returns (address);
1727     function getNameFee() external view returns (uint256);
1728     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1729     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1730     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1731 }
1732 
1733 /**
1734 * @title -Name Filter- v0.1.9
1735 */
1736 
1737 library NameFilter {
1738     /**
1739      * @dev filters name strings
1740      * -converts uppercase to lower case.
1741      * -makes sure it does not start/end with a space
1742      * -makes sure it does not contain multiple spaces in a row
1743      * -cannot be only numbers
1744      * -cannot start with 0x
1745      * -restricts characters to A-Z, a-z, 0-9, and space.
1746      * @return reprocessed string in bytes32 format
1747      */
1748     function nameFilter(string _input)
1749         internal
1750         pure
1751         returns(bytes32)
1752     {
1753         bytes memory _temp = bytes(_input);
1754         uint256 _length = _temp.length;
1755 
1756         //sorry limited to 32 characters
1757         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1758         // make sure it doesnt start with or end with space
1759         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1760         // make sure first two characters are not 0x
1761         if (_temp[0] == 0x30)
1762         {
1763             require(_temp[1] != 0x78, "string cannot start with 0x");
1764             require(_temp[1] != 0x58, "string cannot start with 0X");
1765         }
1766 
1767         // create a bool to track if we have a non number character
1768         bool _hasNonNumber;
1769 
1770         // convert & check
1771         for (uint256 i = 0; i < _length; i++)
1772         {
1773             // if its uppercase A-Z
1774             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1775             {
1776                 // convert to lower case a-z
1777                 _temp[i] = byte(uint(_temp[i]) + 32);
1778 
1779                 // we have a non number
1780                 if (_hasNonNumber == false)
1781                     _hasNonNumber = true;
1782             } else {
1783                 require
1784                 (
1785                     // require character is a space
1786                     _temp[i] == 0x20 ||
1787                     // OR lowercase a-z
1788                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1789                     // or 0-9
1790                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1791                     "string contains invalid characters"
1792                 );
1793                 // make sure theres not 2x spaces in a row
1794                 if (_temp[i] == 0x20)
1795                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1796 
1797                 // see if we have a character other than a number
1798                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1799                     _hasNonNumber = true;
1800             }
1801         }
1802 
1803         require(_hasNonNumber == true, "string cannot be only numbers");
1804 
1805         bytes32 _ret;
1806         assembly {
1807             _ret := mload(add(_temp, 32))
1808         }
1809         return (_ret);
1810     }
1811 }
1812 
1813 /**
1814  * @title SafeMath v0.1.9
1815  * @dev Math operations with safety checks that throw on error
1816  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1817  * - added sqrt
1818  * - added sq
1819  * - added pwr
1820  * - changed asserts to requires with error log outputs
1821  * - removed div, its useless
1822  */
1823 library SafeMath {
1824 
1825     /**
1826     * @dev Multiplies two numbers, throws on overflow.
1827     */
1828     function mul(uint256 a, uint256 b)
1829         internal
1830         pure
1831         returns (uint256 c)
1832     {
1833         if (a == 0) {
1834             return 0;
1835         }
1836         c = a * b;
1837         require(c / a == b, "SafeMath mul failed");
1838         return c;
1839     }
1840 
1841     /**
1842     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1843     */
1844     function sub(uint256 a, uint256 b)
1845         internal
1846         pure
1847         returns (uint256)
1848     {
1849         require(b <= a, "SafeMath sub failed");
1850         return a - b;
1851     }
1852 
1853     /**
1854     * @dev Adds two numbers, throws on overflow.
1855     */
1856     function add(uint256 a, uint256 b)
1857         internal
1858         pure
1859         returns (uint256 c)
1860     {
1861         c = a + b;
1862         require(c >= a, "SafeMath add failed");
1863         return c;
1864     }
1865 }