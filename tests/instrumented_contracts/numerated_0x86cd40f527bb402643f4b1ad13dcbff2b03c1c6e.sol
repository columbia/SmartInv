1 pragma solidity ^0.4.24;
2 
3 
4 /*--------------------------------------------------
5  ____                           ____              _ 
6 / ___| _   _ _ __   ___ _ __   / ___|__ _ _ __ __| |
7 \___ \| | | | '_ \ / _ \ '__| | |   / _` | '__/ _` |
8  ___) | |_| | |_) |  __/ |    | |__| (_| | | | (_| |
9 |____/ \__,_| .__/ \___|_|     \____\__,_|_|  \__,_|
10             |_|                                   
11 
12                                     2018-08-08 V0.8
13 ---------------------------------------------------*/
14 
15 contract SPCevents {
16     // fired whenever a player registers a name
17     event onNewName
18     (
19         uint256 indexed playerID,
20         address indexed playerAddress,
21         bytes32 indexed playerName,
22         bool isNewPlayer,
23         uint256 affiliateID,
24         address affiliateAddress,
25         bytes32 affiliateName,
26         uint256 amountPaid,
27         uint256 timeStamp
28     );
29 
30     // fired at end of buy or reload
31     event onEndTx
32     (
33         uint256 compressedData,
34         uint256 compressedIDs,
35         bytes32 playerName,
36         address playerAddress,
37         uint256 ethIn,
38         uint256 keysBought,
39         address winnerAddr,
40         bytes32 winnerName,
41         uint256 amountWon,
42         uint256 newPot,
43         uint256 P3DAmount,
44         uint256 genAmount,
45         uint256 potAmount,
46         uint256 airDropPot
47     );
48 
49   // fired whenever theres a withdraw
50     event onWithdraw
51     (
52         uint256 indexed playerID,
53         address playerAddress,
54         bytes32 playerName,
55         uint256 ethOut,
56         uint256 timeStamp
57     );
58 
59     // fired whenever a withdraw forces end round to be ran
60     event onWithdrawAndDistribute
61     (
62         address playerAddress,
63         bytes32 playerName,
64         uint256 ethOut,
65         uint256 compressedData,
66         uint256 compressedIDs,
67         address winnerAddr,
68         bytes32 winnerName,
69         uint256 amountWon,
70         uint256 newPot,
71         uint256 P3DAmount,
72         uint256 genAmount
73     );
74 
75     // fired whenever a player tries a buy after round timer
76     // hit zero, and causes end round to be ran.
77     event onBuyAndDistribute
78     (
79         address playerAddress,
80         bytes32 playerName,
81         uint256 ethIn,
82         uint256 compressedData,
83         uint256 compressedIDs,
84         address winnerAddr,
85         bytes32 winnerName,
86         uint256 amountWon,
87         uint256 newPot,
88         uint256 P3DAmount,
89         uint256 genAmount
90     );
91 
92     // fired whenever a player tries a reload after round timer
93     // hit zero, and causes end round to be ran.
94     event onReLoadAndDistribute
95     (
96         address playerAddress,
97         bytes32 playerName,
98         uint256 compressedData,
99         uint256 compressedIDs,
100         address winnerAddr,
101         bytes32 winnerName,
102         uint256 amountWon,
103         uint256 newPot,
104         uint256 P3DAmount,
105         uint256 genAmount
106     );
107 
108     // fired whenever an affiliate is paid
109     event onAffiliatePayout
110     (
111         uint256 indexed affiliateID,
112         address affiliateAddress,
113         bytes32 affiliateName,
114         uint256 indexed roundID,
115         uint256 indexed buyerID,
116         uint256 amount,
117         uint256 timeStamp
118     );
119 
120     // received pot swap deposit, add pot directly by admin to next round
121     event onPotSwapDeposit
122     (
123         uint256 roundID,
124         uint256 amountAddedToPot
125     );
126 }
127 
128 //==============================================================================
129 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
130 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
131 //====================================|=========================================
132 
133 contract SuperCard is SPCevents {
134     using SafeMath for *;
135     using NameFilter for string;
136 
137     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xbac825cdb506dcf917a7715a4bf3fa1b06abe3e4);
138 
139 //==============================================================================
140 //     _ _  _  |`. _     _ _ |_ | _  _  .
141 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
142 //=================_|===========================================================
143     address private admin = msg.sender;
144     string constant public name   = "SuperCard";
145     string constant public symbol = "SPC";
146     uint256 private rndExtra_     = 0;     // length of the very first ICO
147     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
148     uint256 constant private rndInit_ = 6 hours;           // round timer starts at this
149     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
150     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
151 //==============================================================================
152 //     _| _ _|_ _    _ _ _|_    _   .
153 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
154 //=============================|================================================
155     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
156     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
157     uint256 public rID_;    // last rID
158     uint256 public pID_;    // last pID 
159 //****************
160 // PLAYER DATA
161 //****************
162     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
163     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
164     mapping (uint256 => SPCdatasets.Player) public plyr_;   // (pID => data) player data
165     mapping (uint256 => mapping (uint256 => SPCdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
166     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
167 //****************
168 // ROUND DATA
169 //****************
170     mapping (uint256 => SPCdatasets.Round) public round_;   // (rID => data) round data
171     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
172 
173     mapping (uint256 => uint256) public attend;   // (index => pID) player ID attend current round
174 //****************
175 // TEAM FEE DATA
176 //****************
177     mapping (uint256 => SPCdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
178     mapping (uint256 => SPCdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
179 //==============================================================================
180 //     _ _  _  __|_ _    __|_ _  _  .
181 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
182 //==============================================================================
183     constructor()
184         public
185     {
186         fees_[0] = SPCdatasets.TeamFee(80,2);
187         fees_[1] = SPCdatasets.TeamFee(80,2);
188         fees_[2] = SPCdatasets.TeamFee(80,2);
189         fees_[3] = SPCdatasets.TeamFee(80,2);
190 
191         // how to split up the final pot based on which team was picked
192         potSplit_[0] = SPCdatasets.PotSplit(20,10);
193         potSplit_[1] = SPCdatasets.PotSplit(20,10);
194         potSplit_[2] = SPCdatasets.PotSplit(20,10);
195         potSplit_[3] = SPCdatasets.PotSplit(20,10);
196 
197         activated_ = true;
198 
199         // lets start first round
200         rID_ = 1;
201         round_[1].strt = now + rndExtra_ - rndGap_;
202         round_[1].end = now + rndInit_ + rndExtra_;
203   }
204 //==============================================================================
205 //     _ _  _  _|. |`. _  _ _  .
206 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
207 //==============================================================================
208     /**
209      * @dev used to make sure no one can interact with contract until it has
210      * been activated.
211      */
212   modifier isActivated() {
213         if ( activated_ == false ){
214           if ( (now >= pre_active_time) &&  (pre_active_time > 0) ){
215             activated_ = true;
216 
217             // lets start first round
218             rID_ = 1;
219             round_[1].strt = now + rndExtra_ - rndGap_;
220             round_[1].end = now + rndInit_ + rndExtra_;
221           }
222         }
223         require(activated_ == true, "its not ready yet.");
224         _;
225     }
226 
227     /**
228      * @dev prevents contracts from interacting with SuperCard
229      */
230     modifier isHuman() {
231         address _addr = msg.sender;
232         uint256 _codeLength;
233 
234         assembly {_codeLength := extcodesize(_addr)}
235         require(_codeLength == 0, "sorry humans only");
236         _;
237     }
238 
239     /**
240      * @dev sets boundaries for incoming tx
241      */
242     modifier isWithinLimits(uint256 _eth) {
243         require(_eth >= 1000000000, "pocket lint: not a valid currency");
244         require(_eth <= 100000000000000000000000, "no vitalik, no");
245         _;
246     }
247 
248 //==============================================================================
249 //     _    |_ |. _   |`    _  __|_. _  _  _  .
250 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
251 //====|=========================================================================
252     /**
253      * @dev emergency buy uses last stored affiliate ID and team snek
254      */
255     function()
256         isActivated()
257         isHuman()
258         isWithinLimits(msg.value)
259         public
260         payable
261     {
262         // set up our tx event data and determine if player is new or not
263         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
264 
265         // fetch player id
266         uint256 _pID = pIDxAddr_[msg.sender];
267 
268         // buy core
269         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
270     }
271 	
272     function buyXname(bytes32 _affCode, uint256 _team)
273         isActivated()
274         isHuman()
275         isWithinLimits(msg.value)
276         public
277         payable
278     {
279         // set up our tx event data and determine if player is new or not
280         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
281 
282         // fetch player id
283         uint256 _pID = pIDxAddr_[msg.sender];
284 
285         // manage affiliate residuals
286         uint256 _affID;
287         // if no affiliate code was given or player tried to use their own, lolz
288         if (_affCode == '' || _affCode == plyr_[_pID].name)
289         {
290             // use last stored affiliate code
291             _affID = plyr_[_pID].laff;
292 
293         // if affiliate code was given
294         } else {
295             // get affiliate ID from aff Code
296             _affID = pIDxName_[_affCode];
297 
298             // if affID is not the same as previously stored
299             if (_affID != plyr_[_pID].laff)
300             {
301                 // update last affiliate
302                 plyr_[_pID].laff = _affID;
303             }
304         }
305 
306         // buy core, team set to 2, snake
307         buyCore(_pID, _affID, 2, _eventData_);
308     }
309 
310     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
311         isActivated()
312         isHuman()
313         isWithinLimits(_eth)
314         public
315     {
316         // set up our tx event data
317         SPCdatasets.EventReturns memory _eventData_;
318 
319         // fetch player ID
320         uint256 _pID = pIDxAddr_[msg.sender];
321 
322         // manage affiliate residuals
323         uint256 _affID;
324         // if no affiliate code was given or player tried to use their own, lolz
325         if (_affCode == '' || _affCode == plyr_[_pID].name)
326         {
327             // use last stored affiliate code
328             _affID = plyr_[_pID].laff;
329 
330         // if affiliate code was given
331         } else {
332             // get affiliate ID from aff Code
333             _affID = pIDxName_[_affCode];
334 
335             // if affID is not the same as previously stored
336             if (_affID != plyr_[_pID].laff)
337             {
338                 // update last affiliate
339                 plyr_[_pID].laff = _affID;
340             }
341         }
342 
343         // reload core, team set to 2, snake
344         reLoadCore(_pID, _affID, _eth, _eventData_);
345     }
346 	
347     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
348         isActivated()
349         isHuman()
350         isWithinLimits(_eth)
351         public
352     {
353         // set up our tx event data
354         SPCdatasets.EventReturns memory _eventData_;
355 
356         // fetch player ID
357         uint256 _pID = pIDxAddr_[msg.sender];
358 
359         // manage affiliate residuals
360         // if no affiliate code was given or player tried to use their own, lolz
361         if (_affCode == 0 || _affCode == _pID)
362         {
363             // use last stored affiliate code
364             _affCode = plyr_[_pID].laff;
365 
366         // if affiliate code was given & its not the same as previously stored
367         } else if (_affCode != plyr_[_pID].laff) {
368             // update last affiliate
369             plyr_[_pID].laff = _affCode;
370         }
371 
372         // reload core, team set to 2, snake
373         reLoadCore(_pID, _affCode, _eth, _eventData_);
374     }
375 
376     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
377         isActivated()
378         isHuman()
379         isWithinLimits(_eth)
380         public
381     {
382         // set up our tx event data
383         SPCdatasets.EventReturns memory _eventData_;
384 
385         // fetch player ID
386         uint256 _pID = pIDxAddr_[msg.sender];
387 
388         // manage affiliate residuals
389         uint256 _affID;
390         // if no affiliate code was given or player tried to use their own, lolz
391         if (_affCode == address(0) || _affCode == msg.sender)
392         {
393             // use last stored affiliate code
394             _affID = plyr_[_pID].laff;
395 
396         // if affiliate code was given
397         } else {
398             // get affiliate ID from aff Code
399             _affID = pIDxAddr_[_affCode];
400 
401             // if affID is not the same as previously stored
402             if (_affID != plyr_[_pID].laff)
403             {
404                 // update last affiliate
405                 plyr_[_pID].laff = _affID;
406             }
407         }
408 
409         // reload core, team set to 2, snake
410         reLoadCore(_pID, _affID, _eth, _eventData_);
411     }
412 	
413 	    /**
414      * @dev essentially the same as buy, but instead of you sending ether
415      * from your wallet, it uses your unwithdrawn earnings.
416      * -functionhash- 0x349cdcac (using ID for affiliate)
417      * -functionhash- 0x82bfc739 (using address for affiliate)
418      * -functionhash- 0x079ce327 (using name for affiliate)
419      * @param _affCode the ID/address/name of the player who gets the affiliate fee
420      * @param _team what team is the player playing for?
421      * @param _eth amount of earnings to use (remainder returned to gen vault)
422      */
423     
424 
425     /**
426      * @dev withdraws all of your earnings.
427      * -functionhash- 0x3ccfd60b
428      */
429     function withdraw()
430         isActivated()
431         isHuman()
432         public
433     {
434 		// setup local rID
435         uint256 myrID = rID_;
436 
437         // grab time
438         uint256 _now = now;
439 
440         // fetch player ID
441         uint256 _pID = pIDxAddr_[msg.sender];
442 
443         // setup temp var for player eth
444         uint256 upperLimit = 0;
445         uint256 usedGen = 0;
446 
447         // eth send to player
448         uint256 ethout = 0;   
449         
450         uint256 over_gen = 0;
451 
452         updateGenVault(_pID, plyr_[_pID].lrnd);
453 
454         if (plyr_[_pID].gen > 0)
455         {
456           upperLimit = (calceth(plyrRnds_[_pID][myrID].keys).mul(105))/100;
457           if(plyr_[_pID].gen >= upperLimit)
458           {
459             over_gen = (plyr_[_pID].gen).sub(upperLimit);
460 
461             round_[myrID].keys = (round_[myrID].keys).sub(plyrRnds_[_pID][myrID].keys);
462             plyrRnds_[_pID][myrID].keys = 0;
463 
464             round_[myrID].pot = (round_[myrID].pot).add(over_gen);
465               
466             usedGen = upperLimit;       
467           }
468           else
469           {
470             plyrRnds_[_pID][myrID].keys = (plyrRnds_[_pID][myrID].keys).sub(calckeys(((plyr_[_pID].gen).mul(100))/105));
471             round_[myrID].keys = (round_[myrID].keys).sub(calckeys(((plyr_[_pID].gen).mul(100))/105));
472             usedGen = plyr_[_pID].gen;
473           }
474 
475           ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
476         }
477         else
478         {
479           ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff));
480         }
481 
482         plyr_[_pID].win = 0;
483         plyr_[_pID].gen = 0;
484         plyr_[_pID].aff = 0;
485 
486         plyr_[_pID].addr.transfer(ethout);
487 
488         // check to see if round has ended and no one has run round end yet
489         if (_now > round_[myrID].end && round_[myrID].ended == false && round_[myrID].plyr != 0)
490         {
491             // set up our tx event data
492             SPCdatasets.EventReturns memory _eventData_;
493 
494             // end the round (distributes pot)
495             round_[myrID].ended = true;
496             _eventData_ = endRound(_eventData_);
497 
498             // build event data
499             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
500             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
501 
502             // fire withdraw and distribute event
503             emit SPCevents.onWithdrawAndDistribute
504             (
505                 msg.sender,
506                 plyr_[_pID].name,
507                 ethout,
508                 _eventData_.compressedData,
509                 _eventData_.compressedIDs,
510                 _eventData_.winnerAddr,
511                 _eventData_.winnerName,
512                 _eventData_.amountWon,
513                 _eventData_.newPot,
514                 _eventData_.P3DAmount,
515                 _eventData_.genAmount
516             );
517 
518         // in any other situation
519         } else {
520             // fire withdraw event
521             emit SPCevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, ethout, _now);
522         }
523     }
524 
525     /**
526      * @dev use these to register names.  they are just wrappers that will send the
527      * registration requests to the PlayerBook contract.  So registering here is the
528      * same as registering there.  UI will always display the last name you registered.
529      * but you will still own all previously registered names to use as affiliate
530      * links.
531      * - must pay a registration fee.
532      * - name must be unique
533      * - names will be converted to lowercase
534      * - name cannot start or end with a space
535      * - cannot have more than 1 space in a row
536      * - cannot be only numbers
537      * - cannot start with 0x
538      * - name must be at least 1 char
539      * - max length of 32 characters long
540      * - allowed characters: a-z, 0-9, and space
541      * -functionhash- 0x921dec21 (using ID for affiliate)
542      * -functionhash- 0x3ddd4698 (using address for affiliate)
543      * -functionhash- 0x685ffd83 (using name for affiliate)
544      * @param _nameString players desired name
545      * @param _affCode affiliate ID, address, or name of who referred you
546      * @param _all set to true if you want this to push your info to all games
547      * (this might cost a lot of gas)
548      */
549     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
550         isHuman()
551         public
552         payable
553     {
554         bytes32 _name = _nameString.nameFilter();
555         address _addr = msg.sender;
556         uint256 _paid = msg.value;
557         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
558 
559         uint256 _pID = pIDxAddr_[_addr];
560 
561         // fire event
562         emit SPCevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
563     }
564 //==============================================================================
565 //     _  _ _|__|_ _  _ _  .
566 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
567 //=====_|=======================================================================
568     /**
569      * @dev return the price buyer will pay for next 1 individual key.
570      * -functionhash- 0x018a25e8
571      * @return price for next key bought (in wei format)
572      */
573     function getBuyPrice()
574         public
575         view
576         returns(uint256)
577     {
578         // price 0.01 ETH
579         return(10000000000000000);
580     }
581 
582     /**
583      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
584      * provider
585      * -functionhash- 0xc7e284b8
586      * @return time left in seconds
587      */
588     function getTimeLeft()
589         public
590         view
591         returns(uint256)
592     {
593         // setup local rID
594         uint256 _rID = rID_;
595 
596         // grab time
597         uint256 _now = now;
598 
599         if (_now < round_[_rID].end)
600             if (_now > round_[_rID].strt + rndGap_)
601                 return( (round_[_rID].end).sub(_now) );
602             else
603                 return( (round_[_rID].strt + rndGap_).sub(_now) );
604         else
605             return(0);
606     }
607 
608     /**
609      * @dev returns player earnings per vaults
610      * -functionhash- 0x63066434
611      * @return winnings vault
612      * @return general vault
613      * @return affiliate vault
614      */
615     function getPlayerVaults(uint256 _pID)
616         public
617         view
618         returns(uint256 ,uint256, uint256)
619     {
620         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
621         return
622         (
623             plyr_[_pID].win,
624             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
625             plyr_[_pID].aff
626         );
627     }
628 
629      /**
630      * @dev returns all current round info needed for front end
631      * -functionhash- 0x747dff42
632      * @return eth invested during ICO phase
633      * @return round id
634      * @return total keys for round
635      * @return time round ends
636      * @return time round started
637      * @return current pot
638      * @return current team ID & player ID in lead
639      * @return current player in leads address
640      * @return current player in leads name
641      * @return whales eth in for round
642      * @return bears eth in for round
643      * @return sneks eth in for round
644      * @return bulls eth in for round
645      * @return airdrop tracker # & airdrop pot
646      */
647     function getCurrentRoundInfo()
648         public
649         view
650         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
651     {
652         // setup local rID
653         uint256 _rID = rID_;
654 
655         return
656         (
657             round_[_rID].ico,               //0
658             _rID,                           //1
659             round_[_rID].keys,              //2
660             round_[_rID].end,               //3
661             round_[_rID].strt,              //4
662             round_[_rID].pot,               //5
663             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
664             plyr_[round_[_rID].plyr].addr,  //7
665             plyr_[round_[_rID].plyr].name,  //8
666             rndTmEth_[_rID][0],             //9
667             rndTmEth_[_rID][1],             //10
668             rndTmEth_[_rID][2],             //11
669             rndTmEth_[_rID][3],             //12
670             airDropTracker_ + (airDropPot_ * 1000)              //13
671         );
672     }
673 
674     /**
675      * @dev returns player info based on address.  if no address is given, it will
676      * use msg.sender
677      * -functionhash- 0xee0b5d8b
678      * @param _addr address of the player you want to lookup
679      * @return player ID
680      * @return player name
681      * @return keys owned (current round)
682      * @return winnings vault
683      * @return general vault
684      * @return affiliate vault
685    * @return player round eth
686      */
687     function getPlayerInfoByAddress(address _addr)
688         public
689         view
690         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
691     {
692         // setup local rID
693         uint256 _rID = rID_;
694 
695         if (_addr == address(0))
696         {
697             _addr == msg.sender;
698         }
699         uint256 _pID = pIDxAddr_[_addr];
700 
701         return
702         (
703             _pID,                               //0
704             plyr_[_pID].name,                   //1
705             plyrRnds_[_pID][_rID].keys,         //2
706             plyr_[_pID].win,                    //3
707             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
708             plyr_[_pID].aff,                    //5
709             plyrRnds_[_pID][_rID].eth           //6
710         );
711     }
712 	
713 	function buyXaddr(address _affCode, uint256 _team)
714         isActivated()
715         isHuman()
716         isWithinLimits(msg.value)
717         public
718         payable
719     {
720         // set up our tx event data and determine if player is new or not
721         SPCdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
722 
723         // fetch player id
724         uint256 _pID = pIDxAddr_[msg.sender];
725 
726         // manage affiliate residuals
727         uint256 _affID;
728         // if no affiliate code was given or player tried to use their own, lolz
729         if (_affCode == address(0) || _affCode == msg.sender)
730         {
731             // use last stored affiliate code
732             _affID = plyr_[_pID].laff;
733 
734         // if affiliate code was given
735         } else {
736             // get affiliate ID from aff Code
737             _affID = pIDxAddr_[_affCode];
738 
739             // if affID is not the same as previously stored
740             if (_affID != plyr_[_pID].laff)
741             {
742                 // update last affiliate
743                 plyr_[_pID].laff = _affID;
744             }
745         }
746 
747         // buy core, team set to 2, snake
748         buyCore(_pID, _affID, 2, _eventData_);
749     }
750 
751 //==============================================================================
752 //     _ _  _ _   | _  _ . _  .
753 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
754 //=====================_|=======================================================
755     /**
756      * @dev logic runs whenever a buy order is executed.  determines how to handle
757      * incoming eth depending on if we are in an active round or not
758      */
759     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
760         private
761     {
762         // setup local rID
763         uint256 _rID = rID_;
764 
765         // grab time
766         uint256 _now = now;
767 
768         // if round is active
769         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
770         {
771             // call core
772             core(_rID, _pID, msg.value, _affID, 2, _eventData_);
773 
774         // if round is not active
775         } else {
776             // check to see if end round needs to be ran
777             if (_now > round_[_rID].end && round_[_rID].ended == false)
778             {
779                 // end the round (distributes pot) & start new round
780                 round_[_rID].ended = true;
781                 _eventData_ = endRound(_eventData_);
782 
783                 // build event data
784                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
785                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
786 
787                 // fire buy and distribute event
788                 emit SPCevents.onBuyAndDistribute
789                 (
790                     msg.sender,
791                     plyr_[_pID].name,
792                     msg.value,
793                     _eventData_.compressedData,
794                     _eventData_.compressedIDs,
795                     _eventData_.winnerAddr,
796                     _eventData_.winnerName,
797                     _eventData_.amountWon,
798                     _eventData_.newPot,
799                     _eventData_.P3DAmount,
800                     _eventData_.genAmount
801                 );
802             }
803 
804             // put eth in players vault, to win vault
805             plyr_[_pID].win = plyr_[_pID].win.add(msg.value);
806         }
807     }
808 
809     /**
810      * @dev gen limit handle
811      */
812     function genLimit(uint256 _pID) 
813     private 
814     returns(uint256)
815     {
816 		// setup local rID
817         uint256 myrID = rID_;
818 
819       uint256 upperLimit = 0;
820       uint256 usedGen = 0;
821       
822       uint256 over_gen = 0;
823       uint256 eth_can_use = 0;
824 
825       uint256 tempnum = 0;
826 
827       updateGenVault(_pID, plyr_[_pID].lrnd);
828 
829       if (plyr_[_pID].gen > 0)
830       {
831         upperLimit = ((plyrRnds_[_pID][myrID].keys).mul(105))/10000;
832         if(plyr_[_pID].gen >= upperLimit)
833         {
834           over_gen = (plyr_[_pID].gen).sub(upperLimit);
835 
836           round_[myrID].keys = (round_[myrID].keys).sub(plyrRnds_[_pID][myrID].keys);
837           plyrRnds_[_pID][myrID].keys = 0;
838 
839           round_[myrID].pot = (round_[myrID].pot).add(over_gen);
840             
841           usedGen = upperLimit;
842         }
843         else
844         {
845           tempnum = ((plyr_[_pID].gen).mul(10000))/105;
846 
847           plyrRnds_[_pID][myrID].keys = (plyrRnds_[_pID][myrID].keys).sub(tempnum);
848           round_[myrID].keys = (round_[myrID].keys).sub(tempnum);
849 
850           usedGen = plyr_[_pID].gen;
851         }
852 
853         eth_can_use = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
854 
855         plyr_[_pID].win = 0;
856         plyr_[_pID].gen = 0;
857         plyr_[_pID].aff = 0;
858       }
859       else
860       {
861         eth_can_use = (plyr_[_pID].win).add(plyr_[_pID].aff);
862         plyr_[_pID].win = 0;
863         plyr_[_pID].aff = 0;
864       }
865 
866       return(eth_can_use);
867   }
868 
869   /**
870      * @dev logic runs whenever a reload order is executed.  determines how to handle
871      * incoming eth depending on if we are in an active round or not
872      */
873     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, SPCdatasets.EventReturns memory _eventData_)
874         private
875     {
876 		// setup local rID
877         uint256 myrID = rID_;
878 
879         // grab time
880         uint256 _now = now;
881 
882         uint256 eth_can_use = 0;
883 
884         // if round is active
885         if (_now > round_[myrID].strt + rndGap_ && (_now <= round_[myrID].end || (_now > round_[myrID].end && round_[myrID].plyr == 0)))
886         {
887             // get earnings from all vaults and return unused to gen vault
888             // because we use a custom safemath library.  this will throw if player
889             // tried to spend more eth than they have.
890 
891             eth_can_use = genLimit(_pID);
892             if(eth_can_use > 0)
893             {
894               // call core
895               core(myrID, _pID, eth_can_use, _affID, 2, _eventData_);
896             }
897 
898         // if round is not active and end round needs to be ran
899         } else if (_now > round_[myrID].end && round_[myrID].ended == false) {
900             // end the round (distributes pot) & start new round
901             round_[myrID].ended = true;
902             _eventData_ = endRound(_eventData_);
903 
904             // build event data
905             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
906             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
907 
908             // fire buy and distribute event
909             emit SPCevents.onReLoadAndDistribute
910             (
911                 msg.sender,
912                 plyr_[_pID].name,
913                 _eventData_.compressedData,
914                 _eventData_.compressedIDs,
915                 _eventData_.winnerAddr,
916                 _eventData_.winnerName,
917                 _eventData_.amountWon,
918                 _eventData_.newPot,
919                 _eventData_.P3DAmount,
920                 _eventData_.genAmount
921             );
922         }
923     }
924 
925     /**
926      * @dev this is the core logic for any buy/reload that happens while a round
927      * is live.
928      */
929     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
930         private
931     {
932         // if player is new to round。
933         if (plyrRnds_[_pID][_rID].jionflag != 1)
934         {
935           _eventData_ = managePlayer(_pID, _eventData_);
936           plyrRnds_[_pID][_rID].jionflag = 1;
937 
938           attend[round_[_rID].attendNum] = _pID;
939           round_[_rID].attendNum  = (round_[_rID].attendNum).add(1);
940         }
941 
942         if (_eth > 10000000000000000)
943         {
944 
945             // mint the new keys
946             uint256 _keys = calckeys(_eth);
947 
948             // if they bought at least 1 whole key
949             if (_keys >= 1000000000000000000)
950             {
951               updateTimer(_keys, _rID);
952 
953               // set new leaders
954               if (round_[_rID].plyr != _pID)
955                 round_[_rID].plyr = _pID;
956 
957               round_[_rID].team = 2;
958 
959               // set the new leader bool to true
960               _eventData_.compressedData = _eventData_.compressedData + 100;
961             }
962 
963             // update player
964             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
965             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
966 
967             // update round
968             round_[_rID].keys = _keys.add(round_[_rID].keys);
969             round_[_rID].eth = _eth.add(round_[_rID].eth);
970             rndTmEth_[_rID][2] = _eth.add(rndTmEth_[_rID][2]);
971 
972             // distribute eth
973             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 2, _eventData_);
974             _eventData_ = distributeInternal(_rID, _pID, _eth, 2, _keys, _eventData_);
975 
976             // call end tx function to fire end tx event.
977             endTx(_pID, 2, _eth, _keys, _eventData_);
978         }
979     }
980 //==============================================================================
981 //     _ _ | _   | _ _|_ _  _ _  .
982 //    (_(_||(_|_||(_| | (_)| _\  .
983 //==============================================================================
984     /**
985      * @dev calculates unmasked earnings (just calculates, does not update mask)
986      * @return earnings in wei format
987      */
988     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
989         private
990         view
991         returns(uint256)
992     {
993         uint256 temp;
994         temp = (round_[_rIDlast].mask).mul((plyrRnds_[_pID][_rIDlast].keys)/1000000000000000000);
995         if(temp > plyrRnds_[_pID][_rIDlast].mask)
996         {
997           return( temp.sub(plyrRnds_[_pID][_rIDlast].mask) );
998         }
999         else
1000         {
1001           return( 0 );
1002         }
1003     }
1004 
1005     /**
1006      * @dev returns the amount of keys you would get given an amount of eth.
1007      * -functionhash- 0xce89c80c
1008      * @param _rID round ID you want price for
1009      * @param _eth amount of eth sent in
1010      * @return keys received
1011      */
1012     function calcKeysReceived(uint256 _rID, uint256 _eth)
1013         public
1014         view
1015         returns(uint256)
1016     {
1017         return ( calckeys(_eth) );
1018     }
1019 
1020     /**
1021      * @dev returns current eth price for X keys.
1022      * -functionhash- 0xcf808000
1023      * @param _keys number of keys desired (in 18 decimal format)
1024      * @return amount of eth needed to send
1025      */
1026     function iWantXKeys(uint256 _keys)
1027         public
1028         view
1029         returns(uint256)
1030     {
1031         return ( _keys/100 );
1032     }
1033 //==============================================================================
1034 //    _|_ _  _ | _  .
1035 //     | (_)(_)|_\  .
1036 //==============================================================================
1037     /**
1038    * @dev receives name/player info from names contract
1039      */
1040     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1041         external
1042     {
1043         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1044         if (pIDxAddr_[_addr] != _pID)
1045             pIDxAddr_[_addr] = _pID;
1046         if (pIDxName_[_name] != _pID)
1047             pIDxName_[_name] = _pID;
1048         if (plyr_[_pID].addr != _addr)
1049             plyr_[_pID].addr = _addr;
1050         if (plyr_[_pID].name != _name)
1051             plyr_[_pID].name = _name;
1052         if (plyr_[_pID].laff != _laff)
1053             plyr_[_pID].laff = _laff;
1054         if (plyrNames_[_pID][_name] == false)
1055             plyrNames_[_pID][_name] = true;
1056     }
1057 
1058     /**
1059      * @dev receives entire player name list
1060      */
1061     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1062         external
1063     {
1064         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1065         if(plyrNames_[_pID][_name] == false)
1066             plyrNames_[_pID][_name] = true;
1067     }
1068 
1069     /**
1070      * @dev gets existing or registers new pID.  use this when a player may be new
1071      * @return pID
1072      */
1073     function determinePID(SPCdatasets.EventReturns memory _eventData_)
1074         private
1075         returns (SPCdatasets.EventReturns)
1076     {
1077         uint256 _pID = pIDxAddr_[msg.sender];
1078         // if player is new to this version of SuperCard
1079         if (_pID == 0)
1080         {
1081             // grab their player ID, name and last aff ID, from player names contract
1082             _pID = PlayerBook.getPlayerID(msg.sender);
1083             pID_ = _pID; // save Last pID
1084             
1085             bytes32 _name = PlayerBook.getPlayerName(_pID);
1086             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1087 
1088             // set up player account
1089             pIDxAddr_[msg.sender] = _pID;
1090             plyr_[_pID].addr = msg.sender;
1091 
1092             if (_name != "")
1093             {
1094                 pIDxName_[_name] = _pID;
1095                 plyr_[_pID].name = _name;
1096                 plyrNames_[_pID][_name] = true;
1097             }
1098 
1099             if (_laff != 0 && _laff != _pID)
1100                 plyr_[_pID].laff = _laff;
1101 
1102             // set the new player bool to true
1103             _eventData_.compressedData = _eventData_.compressedData + 1;
1104         }
1105         return (_eventData_);
1106     }
1107 
1108     /**
1109      * @dev decides if round end needs to be run & new round started.  and if
1110      * player unmasked earnings from previously played rounds need to be moved.
1111      */
1112     function managePlayer(uint256 _pID, SPCdatasets.EventReturns memory _eventData_)
1113         private
1114         returns (SPCdatasets.EventReturns)
1115     {
1116         uint256 temp_eth = 0;
1117         // if player has played a previous round, move their unmasked earnings
1118         // from that round to win vault. 
1119         if (plyr_[_pID].lrnd != 0)
1120         {
1121           updateGenVault(_pID, plyr_[_pID].lrnd);
1122           temp_eth = ((plyr_[_pID].win).add((plyr_[_pID].gen))).add(plyr_[_pID].aff);
1123 
1124           plyr_[_pID].gen = 0;
1125           plyr_[_pID].aff = 0;
1126           plyr_[_pID].win = temp_eth;
1127         }
1128 
1129         // update player's last round played
1130         plyr_[_pID].lrnd = rID_;
1131 
1132         // set the joined round bool to true
1133         _eventData_.compressedData = _eventData_.compressedData + 10;
1134 
1135         return(_eventData_);
1136     }
1137 
1138     /**
1139      * @dev ends the round. manages paying out winner/splitting up pot
1140      */
1141     function endRound(SPCdatasets.EventReturns memory _eventData_)
1142         private
1143         returns (SPCdatasets.EventReturns)
1144     {
1145         // setup local rID
1146         uint256 _rID = rID_;
1147 
1148         // grab our winning player and team id's
1149         uint256 _winPID = round_[_rID].plyr;
1150         uint256 _winTID = round_[_rID].team;
1151 
1152         // grab our pot amount
1153         uint256 _pot = round_[_rID].pot;
1154 
1155         // calculate our winner share, community rewards, gen share,
1156         // p3d share, and amount reserved for next pot
1157         uint256 _win = (_pot.mul(30)) / 100;
1158         uint256 _com = (_pot / 10);
1159         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1160         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1161         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1162 
1163         // calculate ppt for round mask
1164         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1165         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1166         if (_dust > 0)
1167         {
1168             _gen = _gen.sub(_dust);
1169         }
1170 
1171         // pay our winner
1172         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1173 
1174         // community rewards
1175         _com = _com.add(_p3d.sub(_p3d / 2));
1176         admin.transfer(_com);
1177 
1178         _res = _res.add(_p3d / 2);
1179 
1180         // distribute gen portion to key holders
1181         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1182 
1183         // prepare event data
1184         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1185         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1186         _eventData_.winnerAddr = plyr_[_winPID].addr;
1187         _eventData_.winnerName = plyr_[_winPID].name;
1188         _eventData_.amountWon = _win;
1189         _eventData_.genAmount = _gen;
1190         _eventData_.P3DAmount = _p3d;
1191         _eventData_.newPot = _res;
1192 
1193         // start next round
1194         rID_++;
1195         _rID++;
1196         round_[_rID].strt = now;
1197         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1198         round_[_rID].pot = _res;
1199 
1200         return(_eventData_);
1201     }
1202 
1203   /**
1204      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1205      */
1206     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1207         private
1208     {
1209         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1210         if (_earnings > 0)
1211         {
1212             // put in gen vault
1213             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1214             // zero out their earnings by updating mask
1215             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1216         }
1217     }
1218 
1219     /**
1220      * @dev updates round timer based on number of whole keys bought.
1221      */
1222     function updateTimer(uint256 _keys, uint256 _rID)
1223         private
1224     {
1225         // grab time
1226         uint256 _now = now;
1227 
1228         // calculate time based on number of keys bought
1229         uint256 _newTime;
1230         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1231             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1232         else
1233             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1234 
1235         // compare to max and set new end time
1236         if (_newTime < (rndMax_).add(_now))
1237             round_[_rID].end = _newTime;
1238         else
1239             round_[_rID].end = rndMax_.add(_now);
1240     }
1241 
1242     /**
1243      * @dev distributes eth based on fees to com, aff, and p3d
1244      */
1245     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
1246         private
1247         returns(SPCdatasets.EventReturns)
1248     {
1249         // pay 3% out to community rewards
1250         uint256 _p3d = (_eth/100).mul(3);
1251               
1252         // distribute share to affiliate
1253         // 5%:3%:2%
1254         uint256 _aff_cent = (_eth) / 100;
1255         
1256         uint256 tempID  = _affID;
1257 
1258         // decide what to do with affiliate share of fees
1259         // affiliate must not be self, and must have a name registered
1260         
1261         // 5%
1262         if (tempID != _pID && plyr_[tempID].name != '') 
1263         { 
1264             plyr_[tempID].aff = (_aff_cent.mul(5)).add(plyr_[tempID].aff);
1265             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(5), now);
1266         } 
1267         else 
1268         {
1269             _p3d = _p3d.add(_aff_cent.mul(5));
1270         }
1271 
1272         tempID = PlayerBook.getPlayerID(plyr_[tempID].addr);
1273         tempID = PlayerBook.getPlayerLAff(tempID);
1274 
1275         if (tempID != _pID && plyr_[tempID].name != '') 
1276         { 
1277             plyr_[tempID].aff = (_aff_cent.mul(3)).add(plyr_[tempID].aff);
1278             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(3), now);
1279         } 
1280         else 
1281         {
1282             _p3d = _p3d.add(_aff_cent.mul(3));
1283         }
1284         
1285         tempID = PlayerBook.getPlayerID(plyr_[tempID].addr);
1286         tempID = PlayerBook.getPlayerLAff(tempID);
1287 
1288         if (tempID != _pID && plyr_[tempID].name != '') 
1289         { 
1290             plyr_[tempID].aff = (_aff_cent.mul(2)).add(plyr_[tempID].aff);
1291             emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(2), now);
1292         } 
1293         else 
1294         {
1295             _p3d = _p3d.add(_aff_cent.mul(2));
1296         }
1297 
1298 
1299         // pay out p3d
1300         _p3d = _p3d.add((_eth.mul(fees_[2].p3d)) / (100));
1301         if (_p3d > 0)
1302         {
1303             admin.transfer(_p3d);
1304             // set up event data
1305             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1306         }
1307 
1308         return(_eventData_);
1309     }
1310 
1311   /**
1312      * @dev 
1313      */
1314     function potSwap()
1315         external
1316         payable
1317     {
1318         // setup local rID
1319         uint256 _rID = rID_ + 1;
1320 
1321         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1322         emit SPCevents.onPotSwapDeposit(_rID, msg.value);
1323     }
1324 
1325     /**
1326      * @dev distributes eth based on fees to gen and pot
1327      */
1328     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, SPCdatasets.EventReturns memory _eventData_)
1329         private
1330         returns(SPCdatasets.EventReturns)
1331     {
1332         // calculate gen share，80%
1333         uint256 _gen = (_eth.mul(fees_[2].gen)) / 100;
1334 
1335         // pot 5%
1336         uint256 _pot = (_eth.mul(5)) / 100;
1337 
1338         // distribute gen share (thats what updateMasks() does) and adjust
1339         // balances for dust.
1340         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1341         if (_dust > 0)
1342             _gen = _gen.sub(_dust);
1343 
1344         // add eth to pot
1345         round_[_rID].pot = _pot.add(round_[_rID].pot);
1346 
1347         // set up event data
1348         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1349         _eventData_.potAmount = _pot;
1350 
1351         return(_eventData_);
1352     }
1353 
1354     /**
1355      * @dev updates masks for round and player when keys are bought
1356      * @return dust left over
1357      */
1358     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1359         private
1360         returns(uint256)
1361     {
1362         /* MASKING NOTES
1363             earnings masks are a tricky thing for people to wrap their minds around.
1364             the basic thing to understand here.  is were going to have a global
1365             tracker based on profit per share for each round, that increases in
1366             relevant proportion to the increase in share supply.
1367 
1368             the player will have an additional mask that basically says "based
1369             on the rounds mask, my shares, and how much i've already withdrawn,
1370             how much is still owed to me?"
1371         */
1372 
1373         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1374         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1375         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1376 
1377         // calculate player earning from their own buy (only based on the keys
1378         // they just bought).  & update player earnings mask
1379         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1380         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1381 
1382         // calculate & return dust
1383         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1384     }
1385 
1386   /**
1387      * @dev prepares compression data and fires event for buy or reload tx's
1388      */
1389     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, SPCdatasets.EventReturns memory _eventData_)
1390         private
1391     {
1392     _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (2 * 100000000000000000000000000000);
1393         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1394 
1395         emit SPCevents.onEndTx
1396         (
1397             _eventData_.compressedData,
1398             _eventData_.compressedIDs,
1399             plyr_[_pID].name,
1400             msg.sender,
1401             _eth,
1402             _keys,
1403             _eventData_.winnerAddr,
1404             _eventData_.winnerName,
1405             _eventData_.amountWon,
1406             _eventData_.newPot,
1407             _eventData_.P3DAmount,
1408             _eventData_.genAmount,
1409             _eventData_.potAmount,
1410             airDropPot_
1411         );
1412     }
1413 //==============================================================================
1414 //    (~ _  _    _._|_    .
1415 //    _)(/_(_|_|| | | \/  .
1416 //====================/=========================================================
1417     /** upon contract deploy, it will be deactivated.  this is a one time
1418      * use function that will activate the contract.  we do this so devs
1419      * have time to set things up on the web end                            **/
1420     bool public activated_ = false;
1421 
1422     //uint256 public pre_active_time = 0;
1423     uint256 public pre_active_time = now + 600 seconds;
1424     
1425     /**
1426      * @dev return active flag 、time
1427      * @return active flag
1428      * @return active time
1429      * @return system time
1430      */
1431     function getRunInfo() public view returns(bool, uint256, uint256)
1432     {
1433         return
1434         (
1435             activated_,      //0
1436             pre_active_time, //1
1437             now          //2      
1438         );
1439     }
1440 
1441     function setPreActiveTime(uint256 _pre_time) public
1442     {
1443         // only team just can activate
1444         require(msg.sender == admin, "only admin can activate"); 
1445         pre_active_time = _pre_time;
1446     }
1447 
1448     function activate()
1449         public
1450     {
1451         // only team just can activate
1452         require(msg.sender == admin, "only admin can activate"); 
1453 
1454         // can only be ran once
1455         require(activated_ == false, "SuperCard already activated");
1456 
1457         // activate the contract
1458         activated_ = true;
1459         //activated_ = false;
1460 
1461         // lets start first round
1462         rID_ = 1;
1463         round_[1].strt = now + rndExtra_ - rndGap_;
1464         round_[1].end = now + rndInit_ + rndExtra_;
1465     }
1466 
1467 	
1468 
1469 //==============================================================================
1470 //  |  _      _ _ | _  .
1471 //  |<(/_\/  (_(_||(_  .
1472 //=======/======================================================================
1473   function calckeys(uint256 _eth)
1474         pure
1475     public
1476         returns(uint256)
1477     {
1478         return ( (_eth).mul(100) );
1479     }
1480 
1481     /**
1482      * @dev calculates how much eth would be in contract given a number of keys
1483      * @param _keys number of keys "in contract"
1484      * @return eth that would exists
1485      */
1486     function calceth(uint256 _keys)
1487         pure
1488     public
1489         returns(uint256)
1490     {
1491         return( (_keys)/100 );
1492     } 
1493 	
1494 	function clearKeys(uint256 num)
1495         public
1496     {
1497 		// setup local rID
1498         uint256 myrID = rID_;
1499 
1500         uint256 number = num;
1501         if(num == 1)
1502         {
1503           number = 10000;
1504         }
1505 
1506         uint256 over_gen;
1507         uint256 cleared = 0;
1508         uint256 checkID;
1509         uint256 upperLimit;
1510         uint256 i;
1511         for(i = 0; i< round_[myrID].attendNum; i++)
1512         {
1513           checkID = attend[i];
1514 
1515           updateGenVault(checkID, plyr_[checkID].lrnd);
1516 
1517           if (plyr_[checkID].gen > 0)
1518           {
1519             upperLimit = ((plyrRnds_[checkID][myrID].keys).mul(105))/10000;
1520             if(plyr_[checkID].gen >= upperLimit)
1521             {
1522               over_gen = (plyr_[checkID].gen).sub(upperLimit);
1523 
1524               cleared = cleared.add(plyrRnds_[checkID][myrID].keys);
1525 
1526               round_[myrID].keys = (round_[myrID].keys).sub(plyrRnds_[checkID][myrID].keys);
1527               plyrRnds_[checkID][myrID].keys = 0;
1528 
1529               round_[myrID].pot = (round_[myrID].pot).add(over_gen);
1530 
1531 			  plyr_[checkID].win = ((plyr_[checkID].win).add(upperLimit));
1532 			  plyr_[checkID].gen = 0;
1533 
1534 			  if(cleared >= number)
1535 				  break;
1536             }
1537           }
1538         }
1539     }
1540  
1541     /**
1542      * @dev calc Invalid Keys by rID&pId
1543      */
1544     function calcInvalidKeys(uint256 _rID,uint256 _pID) 
1545       private 
1546       returns(uint256)
1547     {
1548       uint256 InvalidKeys = 0; 
1549       uint256 upperLimit = 0;
1550 
1551       updateGenVault(_pID, plyr_[_pID].lrnd);
1552       if (plyr_[_pID].gen > 0)
1553       {
1554         upperLimit = ((plyrRnds_[_pID][_rID].keys).mul(105))/10000;
1555         if(plyr_[_pID].gen >= upperLimit)
1556         {
1557           InvalidKeys = InvalidKeys.add(plyrRnds_[_pID][_rID].keys);
1558         }
1559       }
1560 
1561       return(InvalidKeys);
1562     }
1563 
1564     /**
1565      * @dev return Invalid Keys
1566      * @return Invalid Keys
1567      * @return Total Keys
1568      * @return timestamp
1569      */
1570 	function getInvalidKeys() public view returns(uint256,uint256,uint256)
1571     {
1572         uint256 LastRID = rID_;
1573         uint256 LastPID = pID_;
1574         
1575         uint256 _rID = 0;
1576         uint256 _pID = 0;
1577         uint256 InvalidKeys = 0;
1578         uint256 TotalKeys = 0;
1579         
1580         for( _rID = 1 ; _rID <= LastRID ; _rID++)
1581         {
1582           TotalKeys = TotalKeys.add(round_[_rID].keys);
1583           for( _pID = 1 ; _pID <= LastPID ; _pID++)
1584           {
1585             InvalidKeys = InvalidKeys.add(calcInvalidKeys(_rID,_pID));
1586           }
1587         }
1588         
1589         return
1590         (
1591             InvalidKeys, //0
1592             TotalKeys,   //1
1593             now          //2      
1594         );
1595     } 	
1596 }
1597 
1598 //==============================================================================
1599 //   __|_ _    __|_ _  .
1600 //  _\ | | |_|(_ | _\  .
1601 //==============================================================================
1602 library SPCdatasets {
1603     //compressedData key
1604     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1605         // 0 - new player (bool)
1606         // 1 - joined round (bool)
1607         // 2 - new  leader (bool)
1608         // 3-5 - air drop tracker (uint 0-999)
1609         // 6-16 - round end time
1610         // 17 - winnerTeam
1611         // 18 - 28 timestamp
1612         // 29 - team
1613         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1614         // 31 - airdrop happened bool
1615         // 32 - airdrop tier
1616         // 33 - airdrop amount won
1617     //compressedIDs key
1618     // [77-52][51-26][25-0]
1619         // 0-25 - pID
1620         // 26-51 - winPID
1621         // 52-77 - rID
1622     struct EventReturns {
1623         uint256 compressedData;
1624         uint256 compressedIDs;
1625         address winnerAddr;         // winner address
1626         bytes32 winnerName;         // winner name
1627         uint256 amountWon;          // amount won
1628         uint256 newPot;             // amount in new pot
1629         uint256 P3DAmount;          // amount distributed to p3d
1630         uint256 genAmount;          // amount distributed to gen
1631         uint256 potAmount;          // amount added to pot
1632     }
1633     struct Player {
1634         address addr;   // player address
1635         bytes32 name;   // player name
1636         uint256 win;    // winnings vault
1637         uint256 gen;    // general vault
1638 		uint256 aff;    // affiliate vault
1639         uint256 lrnd;   // last round played
1640         uint256 laff;   // last affiliate id used
1641     }
1642     struct PlayerRounds {
1643         uint256 eth;    // eth player has added to round (used for eth limiter)
1644         uint256 keys;   // keys
1645         uint256 mask;   // player mask
1646     uint256 jionflag;   // player not jion round
1647         uint256 ico;    // ICO phase investment
1648     }
1649     struct Round {
1650         uint256 plyr;   // pID of player in lead
1651         uint256 team;   // tID of team in lead
1652         uint256 end;    // time ends/ended
1653         bool ended;     // has round end function been ran
1654         uint256 strt;   // time round started
1655         uint256 keys;   // keys
1656         uint256 eth;    // total eth in
1657         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1658         uint256 mask;   // global mask
1659         uint256 ico;    // total eth sent in during ICO phase
1660         uint256 icoGen; // total eth for gen during ICO phase
1661         uint256 icoAvg; // average key price for ICO phase
1662     uint256 attendNum; // number of players attend
1663     }
1664     struct TeamFee {
1665         uint256 gen;    // % of buy in thats paid to key holders of current round
1666         uint256 p3d;    // % of buy in thats paid to p3d holders
1667     }
1668     struct PotSplit {
1669         uint256 gen;    // % of pot thats paid to key holders of current round
1670         uint256 p3d;    // % of pot thats paid to p3d holders
1671     }
1672 }
1673 
1674 //==============================================================================
1675 //  . _ _|_ _  _ |` _  _ _  _  .
1676 //  || | | (/_| ~|~(_|(_(/__\  .
1677 //==============================================================================
1678 
1679 interface PlayerBookInterface {
1680     function getPlayerID(address _addr) external returns (uint256);
1681     function getPlayerName(uint256 _pID) external view returns (bytes32);
1682     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1683     function getPlayerAddr(uint256 _pID) external view returns (address);
1684     function getNameFee() external view returns (uint256);
1685     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1686     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1687     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1688 }
1689 
1690 /**
1691 * @title -Name Filter- v0.1.9
1692 */
1693 
1694 library NameFilter {
1695     /**
1696      * @dev filters name strings
1697      * -converts uppercase to lower case.
1698      * -makes sure it does not start/end with a space
1699      * -makes sure it does not contain multiple spaces in a row
1700      * -cannot be only numbers
1701      * -cannot start with 0x
1702      * -restricts characters to A-Z, a-z, 0-9, and space.
1703      * @return reprocessed string in bytes32 format
1704      */
1705     function nameFilter(string _input)
1706         internal
1707         pure
1708         returns(bytes32)
1709     {
1710         bytes memory _temp = bytes(_input);
1711         uint256 _length = _temp.length;
1712 
1713         //sorry limited to 32 characters
1714         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1715         // make sure it doesnt start with or end with space
1716         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1717         // make sure first two characters are not 0x
1718         if (_temp[0] == 0x30)
1719         {
1720             require(_temp[1] != 0x78, "string cannot start with 0x");
1721             require(_temp[1] != 0x58, "string cannot start with 0X");
1722         }
1723 
1724         // create a bool to track if we have a non number character
1725         bool _hasNonNumber;
1726 
1727         // convert & check
1728         for (uint256 i = 0; i < _length; i++)
1729         {
1730             // if its uppercase A-Z
1731             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1732             {
1733                 // convert to lower case a-z
1734                 _temp[i] = byte(uint(_temp[i]) + 32);
1735 
1736                 // we have a non number
1737                 if (_hasNonNumber == false)
1738                     _hasNonNumber = true;
1739             } else {
1740                 require
1741                 (
1742                     // require character is a space
1743                     _temp[i] == 0x20 ||
1744                     // OR lowercase a-z
1745                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1746                     // or 0-9
1747                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1748                     "string contains invalid characters"
1749                 );
1750                 // make sure theres not 2x spaces in a row
1751                 if (_temp[i] == 0x20)
1752                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1753 
1754                 // see if we have a character other than a number
1755                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1756                     _hasNonNumber = true;
1757             }
1758         }
1759 
1760         require(_hasNonNumber == true, "string cannot be only numbers");
1761 
1762         bytes32 _ret;
1763         assembly {
1764             _ret := mload(add(_temp, 32))
1765         }
1766         return (_ret);
1767     }
1768 }
1769 
1770 /**
1771  * @title SafeMath v0.1.9
1772  * @dev Math operations with safety checks that throw on error
1773  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1774  * - added sqrt
1775  * - added sq
1776  * - added pwr
1777  * - changed asserts to requires with error log outputs
1778  * - removed div, its useless
1779  */
1780 library SafeMath {
1781 
1782     /**
1783     * @dev Multiplies two numbers, throws on overflow.
1784     */
1785     function mul(uint256 a, uint256 b)
1786         internal
1787         pure
1788         returns (uint256 c)
1789     {
1790         if (a == 0) {
1791             return 0;
1792         }
1793         c = a * b;
1794         require(c / a == b, "SafeMath mul failed");
1795         return c;
1796     }
1797 
1798     /**
1799     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1800     */
1801     function sub(uint256 a, uint256 b)
1802         internal
1803         pure
1804         returns (uint256)
1805     {
1806         require(b <= a, "SafeMath sub failed");
1807         return a - b;
1808     }
1809 
1810     /**
1811     * @dev Adds two numbers, throws on overflow.
1812     */
1813     function add(uint256 a, uint256 b)
1814         internal
1815         pure
1816         returns (uint256 c)
1817     {
1818         c = a + b;
1819         require(c >= a, "SafeMath add failed");
1820         return c;
1821     }
1822 }