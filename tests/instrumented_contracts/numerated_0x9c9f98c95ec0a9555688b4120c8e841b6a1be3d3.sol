1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
4     // fired whenever a player registers a name
5     event onNewName
6     (
7         uint256 indexed playerID,
8         address indexed playerAddress,
9         bytes32 indexed playerName,
10         bool isNewPlayer,
11         uint256 affiliateID,
12         address affiliateAddress,
13         bytes32 affiliateName,
14         uint256 amountPaid,
15         uint256 timeStamp
16     );
17 
18     // fired at end of buy or reload
19     event onEndTx
20     (
21         uint256 compressedData,
22         uint256 compressedIDs,
23         bytes32 playerName,
24         address playerAddress,
25         uint256 ethIn,
26         uint256 keysBought,
27         address winnerAddr,
28         bytes32 winnerName,
29         uint256 amountWon,
30         uint256 newPot,
31         uint256 P3DAmount,
32         uint256 genAmount,
33         uint256 potAmount,
34         uint256 airDropPot
35     );
36 
37 	// fired whenever theres a withdraw
38     event onWithdraw
39     (
40         uint256 indexed playerID,
41         address playerAddress,
42         bytes32 playerName,
43         uint256 ethOut,
44         uint256 timeStamp
45     );
46 
47     // fired whenever a withdraw forces end round to be ran
48     event onWithdrawAndDistribute
49     (
50         address playerAddress,
51         bytes32 playerName,
52         uint256 ethOut,
53         uint256 compressedData,
54         uint256 compressedIDs,
55         address winnerAddr,
56         bytes32 winnerName,
57         uint256 amountWon,
58         uint256 newPot,
59         uint256 P3DAmount,
60         uint256 genAmount
61     );
62 
63     // (fomo3d short only) fired whenever a player tries a buy after round timer
64     // hit zero, and causes end round to be ran.
65     event onBuyAndDistribute
66     (
67         address playerAddress,
68         bytes32 playerName,
69         uint256 ethIn,
70         uint256 compressedData,
71         uint256 compressedIDs,
72         address winnerAddr,
73         bytes32 winnerName,
74         uint256 amountWon,
75         uint256 newPot,
76         uint256 P3DAmount,
77         uint256 genAmount
78     );
79 
80     // (fomo3d short only) fired whenever a player tries a reload after round timer
81     // hit zero, and causes end round to be ran.
82     event onReLoadAndDistribute
83     (
84         address playerAddress,
85         bytes32 playerName,
86         uint256 compressedData,
87         uint256 compressedIDs,
88         address winnerAddr,
89         bytes32 winnerName,
90         uint256 amountWon,
91         uint256 newPot,
92         uint256 P3DAmount,
93         uint256 genAmount
94     );
95 
96     // fired whenever an affiliate is paid
97     event onAffiliatePayout
98     (
99         uint256 indexed affiliateID,
100         address affiliateAddress,
101         bytes32 affiliateName,
102         uint256 indexed roundID,
103         uint256 indexed buyerID,
104         uint256 amount,
105         uint256 timeStamp
106     );
107 }
108 
109 //==============================================================================
110 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
111 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
112 //====================================|=========================================
113 
114 contract modularShort is F3Devents {}
115 
116 contract NewChance is modularShort {
117     using SafeMath for *;
118     using NameFilter for string;
119     using F3DKeysCalcShort for uint256;
120 
121     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x2A8Cc43F5124Af19386A34DCb8BF0b2EFc3594Ba);
122 
123 //==============================================================================
124 //     _ _  _  |`. _     _ _ |_ | _  _  .
125 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
126 //=================_|===========================================================
127     address private admin = msg.sender;
128     string constant public name = "New Chance";
129     string constant public symbol = "NEWCH";
130     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
131     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
132     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
133     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
134     uint256 constant private rndMax_ = 30 minutes;                // max length a round timer can be
135 //==============================================================================
136 //     _| _ _|_ _    _ _ _|_    _   .
137 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
138 //=============================|================================================
139     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
140     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
141     uint256 public rID_;    // round id number / total rounds that have happened
142 //****************
143 // PLAYER DATA
144 //****************
145     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
146     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
147     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
148     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
149     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
150 //****************
151 // ROUND DATA
152 //****************
153     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
154     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
155 //****************
156 // TEAM FEE DATA
157 //****************
158     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
159     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
160 //==============================================================================
161 //     _ _  _  __|_ _    __|_ _  _  .
162 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
163 //==============================================================================
164     constructor()
165         public
166     {
167 		// Team allocation structures
168         // 0 = whales
169         // 1 = bears
170         // 2 = sneks
171         // 3 = bulls
172 
173 		// Team allocation percentages
174         // (F3D, P3D) + (Pot , Referrals, Community)
175             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
176         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
177         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 3% to com, 0% to pot swap, 1% to air drop pot
178         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
179         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
180 
181         // how to split up the final pot based on which team was picked
182         // (F3D, P3D)
183         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
184         potSplit_[1] = F3Ddatasets.PotSplit(22,0);   //48% to winner, 10% to next round, 20% to com
185         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
186         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
187 	}
188 //==============================================================================
189 //     _ _  _  _|. |`. _  _ _  .
190 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
191 //==============================================================================
192     /**
193      * @dev used to make sure no one can interact with contract until it has
194      * been activated.
195      */
196     modifier isActivated() {
197         require(activated_ == true, "its not ready yet.  check ?eta in discord");
198         _;
199     }
200 
201     /**
202      * @dev prevents contracts from interacting with fomo3d
203      */
204     modifier isHuman() {
205         address _addr = msg.sender;
206         uint256 _codeLength;
207 
208         assembly {_codeLength := extcodesize(_addr)}
209         require(_codeLength == 0, "sorry humans only");
210         _;
211     }
212 
213     /**
214      * @dev sets boundaries for incoming tx
215      */
216     modifier isWithinLimits(uint256 _eth) {
217         require(_eth >= 1000000000, "pocket lint: not a valid currency");
218         require(_eth <= 100000000000000000000000, "no vitalik, no");
219         _;
220     }
221 
222 //==============================================================================
223 //     _    |_ |. _   |`    _  __|_. _  _  _  .
224 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
225 //====|=========================================================================
226     /**
227      * @dev emergency buy uses last stored affiliate ID and team 1
228      */
229     function()
230         isActivated()
231         isHuman()
232         isWithinLimits(msg.value)
233         public
234         payable
235     {
236         // set up our tx event data and determine if player is new or not
237         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
238 
239         // fetch player id
240         uint256 _pID = pIDxAddr_[msg.sender];
241 
242         // buy core
243         buyCore(_pID, plyr_[_pID].laff, 1, _eventData_);
244     }
245 
246     /**
247      * @dev converts all incoming ethereum to keys.
248      * -functionhash- 0x8f38f309 (using ID for affiliate)
249      * -functionhash- 0x98a0871d (using address for affiliate)
250      * -functionhash- 0xa65b37a1 (using name for affiliate)
251      * @param _affCode the ID/address/name of the player who gets the affiliate fee
252      * @param _team what team is the player playing for?
253      */
254     function buyXid(uint256 _affCode, uint256 _team)
255         isActivated()
256         isHuman()
257         isWithinLimits(msg.value)
258         public
259         payable
260     {
261         // set up our tx event data and determine if player is new or not
262         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
263 
264         // fetch player id
265         uint256 _pID = pIDxAddr_[msg.sender];
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
302         // if no affiliate code was given or player tried to use their own, lolz
303         if (_affCode == address(0) || _affCode == msg.sender)
304         {
305             // use last stored affiliate code
306             _affID = plyr_[_pID].laff;
307 
308         // if affiliate code was given
309         } else {
310             // get affiliate ID from aff Code
311             _affID = pIDxAddr_[_affCode];
312 
313             // if affID is not the same as previously stored
314             if (_affID != plyr_[_pID].laff)
315             {
316                 // update last affiliate
317                 plyr_[_pID].laff = _affID;
318             }
319         }
320 
321         // verify a valid team was selected
322         _team = verifyTeam(_team);
323 
324         // buy core
325         buyCore(_pID, _affID, _team, _eventData_);
326     }
327 
328     /**
329      * @dev essentially the same as buy, but instead of you sending ether
330      * from your wallet, it uses your unwithdrawn earnings.
331      * -functionhash- 0x349cdcac (using ID for affiliate)
332      * -functionhash- 0x82bfc739 (using address for affiliate)
333      * -functionhash- 0x079ce327 (using name for affiliate)
334      * @param _affCode the ID/address/name of the player who gets the affiliate fee
335      * @param _team what team is the player playing for?
336      * @param _eth amount of earnings to use (remainder returned to gen vault)
337      */
338     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
339         isActivated()
340         isHuman()
341         isWithinLimits(_eth)
342         public
343     {
344         // set up our tx event data
345         F3Ddatasets.EventReturns memory _eventData_;
346 
347         // fetch player ID
348         uint256 _pID = pIDxAddr_[msg.sender];
349 
350         // manage affiliate residuals
351         // if no affiliate code was given or player tried to use their own, lolz
352         if (_affCode == 0 || _affCode == _pID)
353         {
354             // use last stored affiliate code
355             _affCode = plyr_[_pID].laff;
356 
357         // if affiliate code was given & its not the same as previously stored
358         } else if (_affCode != plyr_[_pID].laff) {
359             // update last affiliate
360             plyr_[_pID].laff = _affCode;
361         }
362 
363         // verify a valid team was selected
364         _team = verifyTeam(_team);
365 
366         // reload core
367         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
368     }
369 
370     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
371         isActivated()
372         isHuman()
373         isWithinLimits(_eth)
374         public
375     {
376         // set up our tx event data
377         F3Ddatasets.EventReturns memory _eventData_;
378 
379         // fetch player ID
380         uint256 _pID = pIDxAddr_[msg.sender];
381 
382         // manage affiliate residuals
383         uint256 _affID;
384         // if no affiliate code was given or player tried to use their own, lolz
385         if (_affCode == address(0) || _affCode == msg.sender)
386         {
387             // use last stored affiliate code
388             _affID = plyr_[_pID].laff;
389 
390         // if affiliate code was given
391         } else {
392             // get affiliate ID from aff Code
393             _affID = pIDxAddr_[_affCode];
394 
395             // if affID is not the same as previously stored
396             if (_affID != plyr_[_pID].laff)
397             {
398                 // update last affiliate
399                 plyr_[_pID].laff = _affID;
400             }
401         }
402 
403         // verify a valid team was selected
404         _team = verifyTeam(_team);
405 
406         // reload core
407         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
408     }
409 
410     /**
411      * @dev withdraws all of your earnings.
412      * -functionhash- 0x3ccfd60b
413      */
414     function withdraw()
415         isActivated()
416         isHuman()
417         public
418     {
419         // setup local rID
420         uint256 _rID = rID_;
421 
422         // grab time
423         uint256 _now = now;
424 
425         // fetch player ID
426         uint256 _pID = pIDxAddr_[msg.sender];
427 
428         // setup temp var for player eth
429         uint256 _eth;
430 
431         // check to see if round has ended and no one has run round end yet
432         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
433         {
434             // set up our tx event data
435             F3Ddatasets.EventReturns memory _eventData_;
436 
437             // end the round (distributes pot)
438 			round_[_rID].ended = true;
439             _eventData_ = endRound(_eventData_);
440 
441 			// get their earnings
442             _eth = withdrawEarnings(_pID);
443 
444             // gib moni
445             if (_eth > 0)
446                 plyr_[_pID].addr.transfer(_eth);
447 
448             // build event data
449             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
450             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
451 
452             // fire withdraw and distribute event
453             emit F3Devents.onWithdrawAndDistribute
454             (
455                 msg.sender,
456                 plyr_[_pID].name,
457                 _eth,
458                 _eventData_.compressedData,
459                 _eventData_.compressedIDs,
460                 _eventData_.winnerAddr,
461                 _eventData_.winnerName,
462                 _eventData_.amountWon,
463                 _eventData_.newPot,
464                 _eventData_.P3DAmount,
465                 _eventData_.genAmount
466             );
467 
468         // in any other situation
469         } else {
470             // get their earnings
471             _eth = withdrawEarnings(_pID);
472 
473             // gib moni
474             if (_eth > 0)
475                 plyr_[_pID].addr.transfer(_eth);
476 
477             // fire withdraw event
478             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
479         }
480     }
481 
482     /**
483      * @dev use these to register names.  they are just wrappers that will send the
484      * registration requests to the PlayerBook contract.  So registering here is the
485      * same as registering there.  UI will always display the last name you registered.
486      * but you will still own all previously registered names to use as affiliate
487      * links.
488      * - must pay a registration fee.
489      * - name must be unique
490      * - names will be converted to lowercase
491      * - name cannot start or end with a space
492      * - cannot have more than 1 space in a row
493      * - cannot be only numbers
494      * - cannot start with 0x
495      * - name must be at least 1 char
496      * - max length of 32 characters long
497      * - allowed characters: a-z, 0-9, and space
498      * -functionhash- 0x921dec21 (using ID for affiliate)
499      * -functionhash- 0x3ddd4698 (using address for affiliate)
500      * -functionhash- 0x685ffd83 (using name for affiliate)
501      * @param _nameString players desired name
502      * @param _affCode affiliate ID, address, or name of who referred you
503      * @param _all set to true if you want this to push your info to all games
504      * (this might cost a lot of gas)
505      */
506     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
507         isHuman()
508         public
509         payable
510     {
511         bytes32 _name = _nameString.nameFilter();
512         address _addr = msg.sender;
513         uint256 _paid = msg.value;
514         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
515 
516         uint256 _pID = pIDxAddr_[_addr];
517 
518         // fire event
519         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
520     }
521 
522     function registerNameXaddr(string _nameString, address _affCode, bool _all)
523         isHuman()
524         public
525         payable
526     {
527         bytes32 _name = _nameString.nameFilter();
528         address _addr = msg.sender;
529         uint256 _paid = msg.value;
530         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
531 
532         uint256 _pID = pIDxAddr_[_addr];
533 
534         // fire event
535         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
536     }
537 
538     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
539         isHuman()
540         public
541         payable
542     {
543         bytes32 _name = _nameString.nameFilter();
544         address _addr = msg.sender;
545         uint256 _paid = msg.value;
546         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
547 
548         uint256 _pID = pIDxAddr_[_addr];
549 
550         // fire event
551         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
552     }
553 //==============================================================================
554 //     _  _ _|__|_ _  _ _  .
555 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
556 //=====_|=======================================================================
557     /**
558      * @dev return the price buyer will pay for next 1 individual key.
559      * -functionhash- 0x018a25e8
560      * @return price for next key bought (in wei format)
561      */
562     function getBuyPrice()
563         public
564         view
565         returns(uint256)
566     {
567         // setup local rID
568         uint256 _rID = rID_;
569 
570         // grab time
571         uint256 _now = now;
572 
573         // are we in a round?
574         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
575             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
576         else // rounds over.  need price for new round
577             return ( 75000000000000 ); // init
578     }
579 
580     /**
581      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
582      * provider
583      * -functionhash- 0xc7e284b8
584      * @return time left in seconds
585      */
586     function getTimeLeft()
587         public
588         view
589         returns(uint256)
590     {
591         // setup local rID
592         uint256 _rID = rID_;
593 
594         // grab time
595         uint256 _now = now;
596 
597         if (_now < round_[_rID].end)
598             if (_now > round_[_rID].strt + rndGap_)
599                 return( (round_[_rID].end).sub(_now) );
600             else
601                 return( (round_[_rID].strt + rndGap_).sub(_now) );
602         else
603             return(0);
604     }
605 
606     /**
607      * @dev returns player earnings per vaults
608      * -functionhash- 0x63066434
609      * @return winnings vault
610      * @return general vault
611      * @return affiliate vault
612      */
613     function getPlayerVaults(uint256 _pID)
614         public
615         view
616         returns(uint256 ,uint256, uint256)
617     {
618         // setup local rID
619         uint256 _rID = rID_;
620 
621         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
622         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
623         {
624             // if player is winner
625             if (round_[_rID].plyr == _pID)
626             {
627                 return
628                 (
629                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
630                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
631                     plyr_[_pID].aff
632                 );
633             // if player is not the winner
634             } else {
635                 return
636                 (
637                     plyr_[_pID].win,
638                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
639                     plyr_[_pID].aff
640                 );
641             }
642 
643         // if round is still going on, or round has ended and round end has been ran
644         } else {
645             return
646             (
647                 plyr_[_pID].win,
648                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
649                 plyr_[_pID].aff
650             );
651         }
652     }
653 
654     /**
655      * solidity hates stack limits.  this lets us avoid that hate
656      */
657     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
658         private
659         view
660         returns(uint256)
661     {
662         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
663     }
664 
665     /**
666      * @dev returns all current round info needed for front end
667      * -functionhash- 0x747dff42
668      * @return eth invested during ICO phase
669      * @return round id
670      * @return total keys for round
671      * @return time round ends
672      * @return time round started
673      * @return current pot
674      * @return current team ID & player ID in lead
675      * @return current player in leads address
676      * @return current player in leads name
677      * @return whales eth in for round
678      * @return bears eth in for round
679      * @return sneks eth in for round
680      * @return bulls eth in for round
681      * @return airdrop tracker # & airdrop pot
682      */
683     function getCurrentRoundInfo()
684         public
685         view
686         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
687     {
688         // setup local rID
689         uint256 _rID = rID_;
690 
691         return
692         (
693             round_[_rID].ico,               //0
694             _rID,                           //1
695             round_[_rID].keys,              //2
696             round_[_rID].end,               //3
697             round_[_rID].strt,              //4
698             round_[_rID].pot,               //5
699             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
700             plyr_[round_[_rID].plyr].addr,  //7
701             plyr_[round_[_rID].plyr].name,  //8
702             rndTmEth_[_rID][0],             //9
703             rndTmEth_[_rID][1],             //10
704             rndTmEth_[_rID][2],             //11
705             rndTmEth_[_rID][3],             //12
706             airDropTracker_ + (airDropPot_ * 1000)              //13
707         );
708     }
709 
710     /**
711      * @dev returns player info based on address.  if no address is given, it will
712      * use msg.sender
713      * -functionhash- 0xee0b5d8b
714      * @param _addr address of the player you want to lookup
715      * @return player ID
716      * @return player name
717      * @return keys owned (current round)
718      * @return winnings vault
719      * @return general vault
720      * @return affiliate vault
721 	 * @return player round eth
722      */
723     function getPlayerInfoByAddress(address _addr)
724         public
725         view
726         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
727     {
728         // setup local rID
729         uint256 _rID = rID_;
730 
731         if (_addr == address(0))
732         {
733             _addr == msg.sender;
734         }
735         uint256 _pID = pIDxAddr_[_addr];
736 
737         return
738         (
739             _pID,                               //0
740             plyr_[_pID].name,                   //1
741             plyrRnds_[_pID][_rID].keys,         //2
742             plyr_[_pID].win,                    //3
743             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
744             plyr_[_pID].aff,                    //5
745             plyrRnds_[_pID][_rID].eth           //6
746         );
747     }
748 
749 //==============================================================================
750 //     _ _  _ _   | _  _ . _  .
751 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
752 //=====================_|=======================================================
753     /**
754      * @dev logic runs whenever a buy order is executed.  determines how to handle
755      * incoming eth depending on if we are in an active round or not
756      */
757     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
758         private
759     {
760         // setup local rID
761         uint256 _rID = rID_;
762 
763         // grab time
764         uint256 _now = now;
765 
766         // if round is active
767         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
768         {
769             // call core
770             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
771 
772         // if round is not active
773         } else {
774             // check to see if end round needs to be ran
775             if (_now > round_[_rID].end && round_[_rID].ended == false)
776             {
777                 // end the round (distributes pot) & start new round
778 			    round_[_rID].ended = true;
779                 _eventData_ = endRound(_eventData_);
780 
781                 // build event data
782                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
783                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
784 
785                 // fire buy and distribute event
786                 emit F3Devents.onBuyAndDistribute
787                 (
788                     msg.sender,
789                     plyr_[_pID].name,
790                     msg.value,
791                     _eventData_.compressedData,
792                     _eventData_.compressedIDs,
793                     _eventData_.winnerAddr,
794                     _eventData_.winnerName,
795                     _eventData_.amountWon,
796                     _eventData_.newPot,
797                     _eventData_.P3DAmount,
798                     _eventData_.genAmount
799                 );
800             }
801 
802             // put eth in players vault
803             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
804         }
805     }
806 
807     /**
808      * @dev logic runs whenever a reload order is executed.  determines how to handle
809      * incoming eth depending on if we are in an active round or not
810      */
811     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
812         private
813     {
814         // setup local rID
815         uint256 _rID = rID_;
816 
817         // grab time
818         uint256 _now = now;
819 
820         // if round is active
821         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
822         {
823             // get earnings from all vaults and return unused to gen vault
824             // because we use a custom safemath library.  this will throw if player
825             // tried to spend more eth than they have.
826             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
827 
828             // call core
829             core(_rID, _pID, _eth, _affID, _team, _eventData_);
830 
831         // if round is not active and end round needs to be ran
832         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
833             // end the round (distributes pot) & start new round
834             round_[_rID].ended = true;
835             _eventData_ = endRound(_eventData_);
836 
837             // build event data
838             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
839             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
840 
841             // fire buy and distribute event
842             emit F3Devents.onReLoadAndDistribute
843             (
844                 msg.sender,
845                 plyr_[_pID].name,
846                 _eventData_.compressedData,
847                 _eventData_.compressedIDs,
848                 _eventData_.winnerAddr,
849                 _eventData_.winnerName,
850                 _eventData_.amountWon,
851                 _eventData_.newPot,
852                 _eventData_.P3DAmount,
853                 _eventData_.genAmount
854             );
855         }
856     }
857 
858     /**
859      * @dev this is the core logic for any buy/reload that happens while a round
860      * is live.
861      */
862     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
863         private
864     {
865         // if player is new to round
866         if (plyrRnds_[_pID][_rID].keys == 0)
867             _eventData_ = managePlayer(_pID, _eventData_);
868 
869         // early round eth limiter
870         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
871         {
872             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
873             uint256 _refund = _eth.sub(_availableLimit);
874             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
875             _eth = _availableLimit;
876         }
877 
878         // if eth left is greater than min eth allowed (sorry no pocket lint)
879         if (_eth > 1000000000)
880         {
881 
882             // mint the new keys
883             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
884 
885             // if they bought at least 1 whole key
886             if (_keys >= 1000000000000000000)
887             {
888             updateTimer(_keys, _rID);
889 
890             // set new leaders
891             if (round_[_rID].plyr != _pID)
892                 round_[_rID].plyr = _pID;
893             if (round_[_rID].team != _team)
894                 round_[_rID].team = _team;
895 
896             // set the new leader bool to true
897             _eventData_.compressedData = _eventData_.compressedData + 100;
898         }
899 
900             // manage airdrops
901             if (_eth >= 100000000000000000)
902             {
903             airDropTracker_++;
904             if (airdrop() == true)
905             {
906                 // gib muni
907                 uint256 _prize;
908                 if (_eth >= 10000000000000000000)
909                 {
910                     // calculate prize and give it to winner
911                     _prize = ((airDropPot_).mul(75)) / 100;
912                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
913 
914                     // adjust airDropPot
915                     airDropPot_ = (airDropPot_).sub(_prize);
916 
917                     // let event know a tier 3 prize was won
918                     _eventData_.compressedData += 300000000000000000000000000000000;
919                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
920                     // calculate prize and give it to winner
921                     _prize = ((airDropPot_).mul(50)) / 100;
922                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
923 
924                     // adjust airDropPot
925                     airDropPot_ = (airDropPot_).sub(_prize);
926 
927                     // let event know a tier 2 prize was won
928                     _eventData_.compressedData += 200000000000000000000000000000000;
929                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
930                     // calculate prize and give it to winner
931                     _prize = ((airDropPot_).mul(25)) / 100;
932                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
933 
934                     // adjust airDropPot
935                     airDropPot_ = (airDropPot_).sub(_prize);
936 
937                     // let event know a tier 3 prize was won
938                     _eventData_.compressedData += 300000000000000000000000000000000;
939                 }
940                 // set airdrop happened bool to true
941                 _eventData_.compressedData += 10000000000000000000000000000000;
942                 // let event know how much was won
943                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
944 
945                 // reset air drop tracker
946                 airDropTracker_ = 0;
947             }
948         }
949 
950             // store the air drop tracker number (number of buys since last airdrop)
951             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
952 
953             // update player
954             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
955             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
956 
957             // update round
958             round_[_rID].keys = _keys.add(round_[_rID].keys);
959             round_[_rID].eth = _eth.add(round_[_rID].eth);
960             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
961 
962             // distribute eth
963             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
964             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
965 
966             // call end tx function to fire end tx event.
967 		    endTx(_pID, _team, _eth, _keys, _eventData_);
968         }
969     }
970 //==============================================================================
971 //     _ _ | _   | _ _|_ _  _ _  .
972 //    (_(_||(_|_||(_| | (_)| _\  .
973 //==============================================================================
974     /**
975      * @dev calculates unmasked earnings (just calculates, does not update mask)
976      * @return earnings in wei format
977      */
978     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
979         private
980         view
981         returns(uint256)
982     {
983         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
984     }
985 
986     /**
987      * @dev returns the amount of keys you would get given an amount of eth.
988      * -functionhash- 0xce89c80c
989      * @param _rID round ID you want price for
990      * @param _eth amount of eth sent in
991      * @return keys received
992      */
993     function calcKeysReceived(uint256 _rID, uint256 _eth)
994         public
995         view
996         returns(uint256)
997     {
998         // grab time
999         uint256 _now = now;
1000 
1001         // are we in a round?
1002         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1003             return ( (round_[_rID].eth).keysRec(_eth) );
1004         else // rounds over.  need keys for new round
1005             return ( (_eth).keys() );
1006     }
1007 
1008     /**
1009      * @dev returns current eth price for X keys.
1010      * -functionhash- 0xcf808000
1011      * @param _keys number of keys desired (in 18 decimal format)
1012      * @return amount of eth needed to send
1013      */
1014     function iWantXKeys(uint256 _keys)
1015         public
1016         view
1017         returns(uint256)
1018     {
1019         // setup local rID
1020         uint256 _rID = rID_;
1021 
1022         // grab time
1023         uint256 _now = now;
1024 
1025         // are we in a round?
1026         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1027             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1028         else // rounds over.  need price for new round
1029             return ( (_keys).eth() );
1030     }
1031 //==============================================================================
1032 //    _|_ _  _ | _  .
1033 //     | (_)(_)|_\  .
1034 //==============================================================================
1035     /**
1036 	 * @dev receives name/player info from names contract
1037      */
1038     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1039         external
1040     {
1041         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1042         if (pIDxAddr_[_addr] != _pID)
1043             pIDxAddr_[_addr] = _pID;
1044         if (pIDxName_[_name] != _pID)
1045             pIDxName_[_name] = _pID;
1046         if (plyr_[_pID].addr != _addr)
1047             plyr_[_pID].addr = _addr;
1048         if (plyr_[_pID].name != _name)
1049             plyr_[_pID].name = _name;
1050         if (plyr_[_pID].laff != _laff)
1051             plyr_[_pID].laff = _laff;
1052         if (plyrNames_[_pID][_name] == false)
1053             plyrNames_[_pID][_name] = true;
1054     }
1055 
1056     /**
1057      * @dev receives entire player name list
1058      */
1059     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1060         external
1061     {
1062         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1063         if(plyrNames_[_pID][_name] == false)
1064             plyrNames_[_pID][_name] = true;
1065     }
1066 
1067     /**
1068      * @dev gets existing or registers new pID.  use this when a player may be new
1069      * @return pID
1070      */
1071     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1072         private
1073         returns (F3Ddatasets.EventReturns)
1074     {
1075         uint256 _pID = pIDxAddr_[msg.sender];
1076         // if player is new to this version of fomo3d
1077         if (_pID == 0)
1078         {
1079             // grab their player ID, name and last aff ID, from player names contract
1080             _pID = PlayerBook.getPlayerID(msg.sender);
1081             bytes32 _name = PlayerBook.getPlayerName(_pID);
1082             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1083 
1084             // set up player account
1085             pIDxAddr_[msg.sender] = _pID;
1086             plyr_[_pID].addr = msg.sender;
1087 
1088             if (_name != "")
1089             {
1090                 pIDxName_[_name] = _pID;
1091                 plyr_[_pID].name = _name;
1092                 plyrNames_[_pID][_name] = true;
1093             }
1094 
1095             if (_laff != 0 && _laff != _pID)
1096                 plyr_[_pID].laff = _laff;
1097 
1098             // set the new player bool to true
1099             _eventData_.compressedData = _eventData_.compressedData + 1;
1100         }
1101         return (_eventData_);
1102     }
1103 
1104     /**
1105      * @dev checks to make sure user picked a valid team.  if not sets team
1106      * to default (sneks)
1107      */
1108     function verifyTeam(uint256 _team)
1109         private
1110         pure
1111         returns (uint256)
1112     {
1113         if (_team < 0 || _team > 3)
1114             return(2);
1115         else
1116             return(_team);
1117     }
1118 
1119     /**
1120      * @dev decides if round end needs to be run & new round started.  and if
1121      * player unmasked earnings from previously played rounds need to be moved.
1122      */
1123     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1124         private
1125         returns (F3Ddatasets.EventReturns)
1126     {
1127         // if player has played a previous round, move their unmasked earnings
1128         // from that round to gen vault.
1129         if (plyr_[_pID].lrnd != 0)
1130             updateGenVault(_pID, plyr_[_pID].lrnd);
1131 
1132         // update player's last round played
1133         plyr_[_pID].lrnd = rID_;
1134 
1135         // set the joined round bool to true
1136         _eventData_.compressedData = _eventData_.compressedData + 10;
1137 
1138         return(_eventData_);
1139     }
1140 
1141     /**
1142      * @dev ends the round. manages paying out winner/splitting up pot
1143      */
1144     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1145         private
1146         returns (F3Ddatasets.EventReturns)
1147     {
1148         // setup local rID
1149         uint256 _rID = rID_;
1150 
1151         // grab our winning player and team id's
1152         uint256 _winPID = round_[_rID].plyr;
1153         uint256 _winTID = round_[_rID].team;
1154 
1155         // grab our pot amount
1156         uint256 _pot = round_[_rID].pot;
1157 
1158         // calculate our winner share, community rewards, gen share,
1159         // p3d share, and amount reserved for next pot
1160         uint256 _win = (_pot.mul(48)) / 100;
1161         uint256 _com = (_pot.mul(20)) / 100;
1162         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1163         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1164         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1165 
1166         // calculate ppt for round mask
1167         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1168         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1169         if (_dust > 0)
1170         {
1171             _gen = _gen.sub(_dust);
1172             _res = _res.add(_dust);
1173         }
1174 
1175         // pay our winner
1176         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1177 
1178         // community rewards
1179 
1180         admin.transfer(_com);
1181 
1182         admin.transfer(_p3d.sub(_p3d / 2));
1183 
1184         round_[_rID].pot = _pot.add(_p3d / 2);
1185 
1186         // distribute gen portion to key holders
1187         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1188 
1189         // prepare event data
1190         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1191         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1192         _eventData_.winnerAddr = plyr_[_winPID].addr;
1193         _eventData_.winnerName = plyr_[_winPID].name;
1194         _eventData_.amountWon = _win;
1195         _eventData_.genAmount = _gen;
1196         _eventData_.P3DAmount = _p3d;
1197         _eventData_.newPot = _res;
1198 
1199         // start next round
1200         rID_++;
1201         _rID++;
1202         round_[_rID].strt = now;
1203         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1204         round_[_rID].pot = _res;
1205 
1206         return(_eventData_);
1207     }
1208 
1209     /**
1210      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1211      */
1212     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1213         private
1214     {
1215         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1216         if (_earnings > 0)
1217         {
1218             // put in gen vault
1219             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1220             // zero out their earnings by updating mask
1221             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1222         }
1223     }
1224 
1225     /**
1226      * @dev updates round timer based on number of whole keys bought.
1227      */
1228     function updateTimer(uint256 _keys, uint256 _rID)
1229         private
1230     {
1231         // grab time
1232         uint256 _now = now;
1233 
1234         // calculate time based on number of keys bought
1235         uint256 _newTime;
1236         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1237             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1238         else
1239             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1240 
1241         // compare to max and set new end time
1242         if (_newTime < (rndMax_).add(_now))
1243             round_[_rID].end = _newTime;
1244         else
1245             round_[_rID].end = rndMax_.add(_now);
1246     }
1247 
1248     /**
1249      * @dev generates a random number between 0-99 and checks to see if thats
1250      * resulted in an airdrop win
1251      * @return do we have a winner?
1252      */
1253     function airdrop()
1254         private
1255         view
1256         returns(bool)
1257     {
1258         uint256 seed = uint256(keccak256(abi.encodePacked(
1259 
1260             (block.timestamp).add
1261             (block.difficulty).add
1262             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1263             (block.gaslimit).add
1264             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1265             (block.number)
1266 
1267         )));
1268         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1269             return(true);
1270         else
1271             return(false);
1272     }
1273 
1274     /**
1275      * @dev distributes eth based on fees to com, aff, and p3d
1276      */
1277     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1278         private
1279         returns(F3Ddatasets.EventReturns)
1280     {
1281         // pay 3% out to community rewards
1282         uint256 _p1 = _eth / 100;
1283         uint256 _com = _eth / 50;
1284         _com = _com.add(_p1);
1285 
1286         uint256 _p3d;
1287         if (!address(admin).call.value(_com)())
1288         {
1289             // This ensures Team Just cannot influence the outcome of FoMo3D with
1290             // bank migrations by breaking outgoing transactions.
1291             // Something we would never do. But that's not the point.
1292             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1293             // highest belief that everything we create should be trustless.
1294             // Team JUST, The name you shouldn't have to trust.
1295             _p3d = _com;
1296             _com = 0;
1297         }
1298 
1299 
1300         // distribute share to affiliate
1301         uint256 _aff = _eth / 10;
1302 
1303         // decide what to do with affiliate share of fees
1304         // affiliate must not be self, and must have a name registered
1305         if (_affID != _pID && plyr_[_affID].name != '') {
1306             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1307             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1308         } else {
1309             _p3d = _aff;
1310         }
1311 
1312         // pay out p3d
1313         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1314         if (_p3d > 0)
1315         {
1316             // deposit to divies contract
1317             uint256 _potAmount = _p3d / 2;
1318 
1319             admin.transfer(_p3d.sub(_potAmount));
1320 
1321             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1322 
1323             // set up event data
1324             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1325         }
1326 
1327         return(_eventData_);
1328     }
1329 
1330     /**
1331      * @dev distributes eth based on fees to gen and pot
1332      */
1333     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1334         private
1335         returns(F3Ddatasets.EventReturns)
1336     {
1337         // calculate gen share
1338         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1339 
1340         // toss 1% into airdrop pot
1341         uint256 _air = (_eth / 100);
1342         airDropPot_ = airDropPot_.add(_air);
1343 
1344         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1345         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1346 
1347         // calculate pot
1348         uint256 _pot = _eth.sub(_gen);
1349 
1350         // distribute gen share (thats what updateMasks() does) and adjust
1351         // balances for dust.
1352         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1353         if (_dust > 0)
1354             _gen = _gen.sub(_dust);
1355 
1356         // add eth to pot
1357         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1358 
1359         // set up event data
1360         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1361         _eventData_.potAmount = _pot;
1362 
1363         return(_eventData_);
1364     }
1365 
1366     /**
1367      * @dev updates masks for round and player when keys are bought
1368      * @return dust left over
1369      */
1370     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1371         private
1372         returns(uint256)
1373     {
1374         /* MASKING NOTES
1375             earnings masks are a tricky thing for people to wrap their minds around.
1376             the basic thing to understand here.  is were going to have a global
1377             tracker based on profit per share for each round, that increases in
1378             relevant proportion to the increase in share supply.
1379 
1380             the player will have an additional mask that basically says "based
1381             on the rounds mask, my shares, and how much i've already withdrawn,
1382             how much is still owed to me?"
1383         */
1384 
1385         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1386         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1387         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1388 
1389         // calculate player earning from their own buy (only based on the keys
1390         // they just bought).  & update player earnings mask
1391         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1392         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1393 
1394         // calculate & return dust
1395         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1396     }
1397 
1398     /**
1399      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1400      * @return earnings in wei format
1401      */
1402     function withdrawEarnings(uint256 _pID)
1403         private
1404         returns(uint256)
1405     {
1406         // update gen vault
1407         updateGenVault(_pID, plyr_[_pID].lrnd);
1408 
1409         // from vaults
1410         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1411         if (_earnings > 0)
1412         {
1413             plyr_[_pID].win = 0;
1414             plyr_[_pID].gen = 0;
1415             plyr_[_pID].aff = 0;
1416         }
1417 
1418         return(_earnings);
1419     }
1420 
1421     /**
1422      * @dev prepares compression data and fires event for buy or reload tx's
1423      */
1424     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1425         private
1426     {
1427         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1428         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1429 
1430         emit F3Devents.onEndTx
1431         (
1432             _eventData_.compressedData,
1433             _eventData_.compressedIDs,
1434             plyr_[_pID].name,
1435             msg.sender,
1436             _eth,
1437             _keys,
1438             _eventData_.winnerAddr,
1439             _eventData_.winnerName,
1440             _eventData_.amountWon,
1441             _eventData_.newPot,
1442             _eventData_.P3DAmount,
1443             _eventData_.genAmount,
1444             _eventData_.potAmount,
1445             airDropPot_
1446         );
1447     }
1448 //==============================================================================
1449 //    (~ _  _    _._|_    .
1450 //    _)(/_(_|_|| | | \/  .
1451 //====================/=========================================================
1452     /** upon contract deploy, it will be deactivated.  this is a one time
1453      * use function that will activate the contract.  we do this so devs
1454      * have time to set things up on the web end                            **/
1455     bool public activated_ = false;
1456     function activate()
1457         public
1458     {
1459         // only team just can activate
1460         require(msg.sender == admin, "only admin can activate");
1461 
1462 
1463         // can only be ran once
1464         require(activated_ == false, "FOMO Short already activated");
1465 
1466         // activate the contract
1467         activated_ = true;
1468 
1469         // lets start first round
1470         rID_ = 1;
1471             round_[1].strt = now + rndExtra_ - rndGap_;
1472             round_[1].end = now + rndInit_ + rndExtra_;
1473     }
1474 }
1475 
1476 //==============================================================================
1477 //   __|_ _    __|_ _  .
1478 //  _\ | | |_|(_ | _\  .
1479 //==============================================================================
1480 library F3Ddatasets {
1481     //compressedData key
1482     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1483         // 0 - new player (bool)
1484         // 1 - joined round (bool)
1485         // 2 - new  leader (bool)
1486         // 3-5 - air drop tracker (uint 0-999)
1487         // 6-16 - round end time
1488         // 17 - winnerTeam
1489         // 18 - 28 timestamp
1490         // 29 - team
1491         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1492         // 31 - airdrop happened bool
1493         // 32 - airdrop tier
1494         // 33 - airdrop amount won
1495     //compressedIDs key
1496     // [77-52][51-26][25-0]
1497         // 0-25 - pID
1498         // 26-51 - winPID
1499         // 52-77 - rID
1500     struct EventReturns {
1501         uint256 compressedData;
1502         uint256 compressedIDs;
1503         address winnerAddr;         // winner address
1504         bytes32 winnerName;         // winner name
1505         uint256 amountWon;          // amount won
1506         uint256 newPot;             // amount in new pot
1507         uint256 P3DAmount;          // amount distributed to p3d
1508         uint256 genAmount;          // amount distributed to gen
1509         uint256 potAmount;          // amount added to pot
1510     }
1511     struct Player {
1512         address addr;   // player address
1513         bytes32 name;   // player name
1514         uint256 win;    // winnings vault
1515         uint256 gen;    // general vault
1516         uint256 aff;    // affiliate vault
1517         uint256 lrnd;   // last round played
1518         uint256 laff;   // last affiliate id used
1519     }
1520     struct PlayerRounds {
1521         uint256 eth;    // eth player has added to round (used for eth limiter)
1522         uint256 keys;   // keys
1523         uint256 mask;   // player mask
1524         uint256 ico;    // ICO phase investment
1525     }
1526     struct Round {
1527         uint256 plyr;   // pID of player in lead
1528         uint256 team;   // tID of team in lead
1529         uint256 end;    // time ends/ended
1530         bool ended;     // has round end function been ran
1531         uint256 strt;   // time round started
1532         uint256 keys;   // keys
1533         uint256 eth;    // total eth in
1534         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1535         uint256 mask;   // global mask
1536         uint256 ico;    // total eth sent in during ICO phase
1537         uint256 icoGen; // total eth for gen during ICO phase
1538         uint256 icoAvg; // average key price for ICO phase
1539     }
1540     struct TeamFee {
1541         uint256 gen;    // % of buy in thats paid to key holders of current round
1542         uint256 p3d;    // % of buy in thats paid to p3d holders
1543     }
1544     struct PotSplit {
1545         uint256 gen;    // % of pot thats paid to key holders of current round
1546         uint256 p3d;    // % of pot thats paid to p3d holders
1547     }
1548 }
1549 
1550 //==============================================================================
1551 //  |  _      _ _ | _  .
1552 //  |<(/_\/  (_(_||(_  .
1553 //=======/======================================================================
1554 library F3DKeysCalcShort {
1555     using SafeMath for *;
1556     /**
1557      * @dev calculates number of keys received given X eth
1558      * @param _curEth current amount of eth in contract
1559      * @param _newEth eth being spent
1560      * @return amount of ticket purchased
1561      */
1562     function keysRec(uint256 _curEth, uint256 _newEth)
1563         internal
1564         pure
1565         returns (uint256)
1566     {
1567         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1568     }
1569 
1570     /**
1571      * @dev calculates amount of eth received if you sold X keys
1572      * @param _curKeys current amount of keys that exist
1573      * @param _sellKeys amount of keys you wish to sell
1574      * @return amount of eth received
1575      */
1576     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1577         internal
1578         pure
1579         returns (uint256)
1580     {
1581         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1582     }
1583 
1584     /**
1585      * @dev calculates how many keys would exist with given an amount of eth
1586      * @param _eth eth "in contract"
1587      * @return number of keys that would exist
1588      */
1589     function keys(uint256 _eth)
1590         internal
1591         pure
1592         returns(uint256)
1593     {
1594         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1595     }
1596 
1597     /**
1598      * @dev calculates how much eth would be in contract given a number of keys
1599      * @param _keys number of keys "in contract"
1600      * @return eth that would exists
1601      */
1602     function eth(uint256 _keys)
1603         internal
1604         pure
1605         returns(uint256)
1606     {
1607         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1608     }
1609 }
1610 
1611 //==============================================================================
1612 //  . _ _|_ _  _ |` _  _ _  _  .
1613 //  || | | (/_| ~|~(_|(_(/__\  .
1614 //==============================================================================
1615 
1616 interface PlayerBookInterface {
1617     function getPlayerID(address _addr) external returns (uint256);
1618     function getPlayerName(uint256 _pID) external view returns (bytes32);
1619     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1620     function getPlayerAddr(uint256 _pID) external view returns (address);
1621     function getNameFee() external view returns (uint256);
1622     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1623     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1624     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1625 }
1626 
1627 /**
1628 * @title -Name Filter- v0.1.9
1629 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1630 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1631 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1632 *                                  _____                      _____
1633 *                                 (, /     /)       /) /)    (, /      /)          /)
1634 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1635 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1636 *          ┴ ┴                /   /          .-/ _____   (__ /
1637 *                            (__ /          (_/ (, /                                      /)™
1638 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1639 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1640 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1641 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1642 *              _       __    _      ____      ____  _   _    _____  ____  ___
1643 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1644 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1645 *
1646 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1647 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1648 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1649 */
1650 
1651 library NameFilter {
1652     /**
1653      * @dev filters name strings
1654      * -converts uppercase to lower case.
1655      * -makes sure it does not start/end with a space
1656      * -makes sure it does not contain multiple spaces in a row
1657      * -cannot be only numbers
1658      * -cannot start with 0x
1659      * -restricts characters to A-Z, a-z, 0-9, and space.
1660      * @return reprocessed string in bytes32 format
1661      */
1662     function nameFilter(string _input)
1663         internal
1664         pure
1665         returns(bytes32)
1666     {
1667         bytes memory _temp = bytes(_input);
1668         uint256 _length = _temp.length;
1669 
1670         //sorry limited to 32 characters
1671         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1672         // make sure it doesnt start with or end with space
1673         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1674         // make sure first two characters are not 0x
1675         if (_temp[0] == 0x30)
1676         {
1677             require(_temp[1] != 0x78, "string cannot start with 0x");
1678             require(_temp[1] != 0x58, "string cannot start with 0X");
1679         }
1680 
1681         // create a bool to track if we have a non number character
1682         bool _hasNonNumber;
1683 
1684         // convert & check
1685         for (uint256 i = 0; i < _length; i++)
1686         {
1687             // if its uppercase A-Z
1688             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1689             {
1690                 // convert to lower case a-z
1691                 _temp[i] = byte(uint(_temp[i]) + 32);
1692 
1693                 // we have a non number
1694                 if (_hasNonNumber == false)
1695                     _hasNonNumber = true;
1696             } else {
1697                 require
1698                 (
1699                     // require character is a space
1700                     _temp[i] == 0x20 ||
1701                     // OR lowercase a-z
1702                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1703                     // or 0-9
1704                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1705                     "string contains invalid characters"
1706                 );
1707                 // make sure theres not 2x spaces in a row
1708                 if (_temp[i] == 0x20)
1709                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1710 
1711                 // see if we have a character other than a number
1712                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1713                     _hasNonNumber = true;
1714             }
1715         }
1716 
1717         require(_hasNonNumber == true, "string cannot be only numbers");
1718 
1719         bytes32 _ret;
1720         assembly {
1721             _ret := mload(add(_temp, 32))
1722         }
1723         return (_ret);
1724     }
1725 }
1726 
1727 /**
1728  * @title SafeMath v0.1.9
1729  * @dev Math operations with safety checks that throw on error
1730  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1731  * - added sqrt
1732  * - added sq
1733  * - added pwr
1734  * - changed asserts to requires with error log outputs
1735  * - removed div, its useless
1736  */
1737 library SafeMath {
1738 
1739     /**
1740     * @dev Multiplies two numbers, throws on overflow.
1741     */
1742     function mul(uint256 a, uint256 b)
1743         internal
1744         pure
1745         returns (uint256 c)
1746     {
1747         if (a == 0) {
1748             return 0;
1749         }
1750         c = a * b;
1751         require(c / a == b, "SafeMath mul failed");
1752         return c;
1753     }
1754 
1755     /**
1756     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1757     */
1758     function sub(uint256 a, uint256 b)
1759         internal
1760         pure
1761         returns (uint256)
1762     {
1763         require(b <= a, "SafeMath sub failed");
1764         return a - b;
1765     }
1766 
1767     /**
1768     * @dev Adds two numbers, throws on overflow.
1769     */
1770     function add(uint256 a, uint256 b)
1771         internal
1772         pure
1773         returns (uint256 c)
1774     {
1775         c = a + b;
1776         require(c >= a, "SafeMath add failed");
1777         return c;
1778     }
1779 
1780     /**
1781      * @dev gives square root of given x.
1782      */
1783     function sqrt(uint256 x)
1784         internal
1785         pure
1786         returns (uint256 y)
1787     {
1788         uint256 z = ((add(x,1)) / 2);
1789         y = x;
1790         while (z < y)
1791         {
1792             y = z;
1793             z = ((add((x / z),z)) / 2);
1794         }
1795     }
1796 
1797     /**
1798      * @dev gives square. multiplies x by x
1799      */
1800     function sq(uint256 x)
1801         internal
1802         pure
1803         returns (uint256)
1804     {
1805         return (mul(x,x));
1806     }
1807 
1808     /**
1809      * @dev x to the power of y
1810      */
1811     function pwr(uint256 x, uint256 y)
1812         internal
1813         pure
1814         returns (uint256)
1815     {
1816         if (x==0)
1817             return (0);
1818         else if (y==0)
1819             return (1);
1820         else
1821         {
1822             uint256 z = x;
1823             for (uint256 i=1; i < y; i++)
1824                 z = mul(z,x);
1825             return (z);
1826         }
1827     }
1828 }