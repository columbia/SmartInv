1 pragma solidity ^0.4.24;
2 
3 contract MonkeyEvents {
4 
5     // fired whenever a player registers a name
6     event onNewName
7     (
8         uint256 indexed playerID,
9         address indexed playerAddress,
10         bytes32 indexed playerName,
11         bool isNewPlayer,
12         uint256 affiliateID,
13         address affiliateAddress,
14         bytes32 affiliateName,
15         uint256 amountPaid,
16         uint256 timeStamp
17     );
18 
19     // fired at end of buy or reload
20     event onEndTx
21     (
22         uint256 compressedData,
23         uint256 compressedIDs,
24         bytes32 playerName,
25         address playerAddress,
26         uint256 ethIn,
27         uint256 keysBought,
28         address winnerAddr,
29         bytes32 winnerName,
30         uint256 amountWon,
31         uint256 newPot,
32         uint256 genAmount,
33         uint256 potAmount,
34         uint256 airDropPot
35     );
36 
37     // fired whenever theres a withdraw
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
59         uint256 genAmount
60     );
61 
62     // fired whenever a player tries a buy after round timer
63     // hit zero, and causes end round to be ran.
64     event onBuyAndDistribute
65     (
66         address playerAddress,
67         bytes32 playerName,
68         uint256 ethIn,
69         uint256 compressedData,
70         uint256 compressedIDs,
71         address winnerAddr,
72         bytes32 winnerName,
73         uint256 amountWon,
74         uint256 newPot,
75         uint256 genAmount
76     );
77 
78     // fired whenever a player tries a reload after round timer
79     // hit zero, and causes end round to be ran.
80     event onReLoadAndDistribute
81     (
82         address playerAddress,
83         bytes32 playerName,
84         uint256 compressedData,
85         uint256 compressedIDs,
86         address winnerAddr,
87         bytes32 winnerName,
88         uint256 amountWon,
89         uint256 newPot,
90         uint256 genAmount
91     );
92 
93     // fired whenever an affiliate is paid
94     event onAffiliatePayout
95     (
96         uint256 indexed affiliateID,
97         address affiliateAddress,
98         bytes32 affiliateName,
99         uint256 indexed buyerID,
100         uint256 amount,
101         uint256 timeStamp
102     );
103 }
104 
105 contract modularMonkeyScam is MonkeyEvents {}
106 
107 contract MonkeyScam is modularMonkeyScam {
108     using SafeMath for *;
109     using NameFilter for string;
110     using LDKeysCalc for uint256;
111 
112     // TODO: check address
113     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x38A3E0423708f5797284aEDDbac1a69FC0aa3883);
114 
115     address private monkeyKing = 0xb75603Fd0B0E55b283DAC9A9ED516A8a9515e3dB;
116     address private monkeyQueue = 0x2B215DE0Ec7C1A9b72F48aB357f2E1739487c050;
117 
118     string constant public name = "MonkeyScam Round #1";
119     string constant public symbol = "MSR";
120     uint256 private rndGap_ = 0;
121 
122     // TODO: check time
123     uint256 constant private rndInit_ = 72 hours;                // round timer starts at this
124     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
125     uint256 constant private rndMax_ = 72 hours;                // max length a round timer can be
126     //==============================================================================
127     //     _| _ _|_ _    _ _ _|_    _   .
128     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
129     //=============================|================================================
130     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
131     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
132     //****************
133     // PLAYER DATA
134     //****************
135     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
136     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
137     mapping (uint256 => LDdatasets.Player) public plyr_;   // (pID => data) player data
138     mapping (uint256 => LDdatasets.PlayerRounds) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
139     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
140     //****************
141     // ROUND DATA
142     //****************
143     LDdatasets.Round public round_;   // round data
144     //****************
145     // TEAM FEE DATA
146     //****************
147     uint256 public fees_ = 40;          // fee distribution
148     uint256 public potSplit_ = 20;      // pot split distribution
149     //==============================================================================
150     //     _ _  _  _|. |`. _  _ _  .
151     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
152     //==============================================================================
153     /**
154      * @dev used to make sure no one can interact with contract until it has
155      * been activated.
156      */
157     modifier isActivated() {
158         require(activated_ == true, "its not ready yet");
159         _;
160     }
161 
162     /**
163      * @dev prevents contracts from interacting with ratscam
164      */
165     modifier isHuman() {
166         address _addr = msg.sender;
167         uint256 _codeLength;
168 
169         assembly {_codeLength := extcodesize(_addr)}
170         require(_codeLength == 0, "non smart contract address only");
171         _;
172     }
173 
174     /**
175      * @dev sets boundaries for incoming tx
176      */
177     modifier isWithinLimits(uint256 _eth) {
178         require(_eth >= 1000000000, "too little money");
179         require(_eth <= 100000000000000000000000, "too much money");
180         _;
181     }
182 
183     //==============================================================================
184     //     _    |_ |. _   |`    _  __|_. _  _  _  .
185     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
186     //====|=========================================================================
187     /**
188      * @dev emergency buy uses last stored affiliate ID and team snek
189      */
190     function()
191     isActivated()
192     isHuman()
193     isWithinLimits(msg.value)
194     public
195     payable
196     {
197         // set up our tx event data and determine if player is new or not
198         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
199 
200         // fetch player id
201         uint256 _pID = pIDxAddr_[msg.sender];
202 
203         // buy core
204         buyCore(_pID, plyr_[_pID].laff, _eventData_);
205     }
206 
207     /**
208      * @dev converts all incoming ethereum to keys.
209      * -functionhash- 0x8f38f309 (using ID for affiliate)
210      * -functionhash- 0x98a0871d (using address for affiliate)
211      * -functionhash- 0xa65b37a1 (using name for affiliate)
212      * @param _affCode the ID/address/name of the player who gets the affiliate fee
213      */
214     function buyXid(uint256 _affCode)
215     isActivated()
216     isHuman()
217     isWithinLimits(msg.value)
218     public
219     payable
220     {
221         // set up our tx event data and determine if player is new or not
222         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
223 
224         // fetch player id
225         uint256 _pID = pIDxAddr_[msg.sender];
226 
227         // manage affiliate residuals
228         // if no affiliate code was given or player tried to use their own, lolz
229         if (_affCode == 0 || _affCode == _pID)
230         {
231             // use last stored affiliate code
232             _affCode = plyr_[_pID].laff;
233 
234             // if affiliate code was given & its not the same as previously stored
235         } else if (_affCode != plyr_[_pID].laff) {
236             // update last affiliate
237             plyr_[_pID].laff = _affCode;
238         }
239 
240         // buy core
241         buyCore(_pID, _affCode, _eventData_);
242     }
243 
244     function buyXaddr(address _affCode)
245     isActivated()
246     isHuman()
247     isWithinLimits(msg.value)
248     public
249     payable
250     {
251         // set up our tx event data and determine if player is new or not
252         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
253 
254         // fetch player id
255         uint256 _pID = pIDxAddr_[msg.sender];
256 
257         // manage affiliate residuals
258         uint256 _affID;
259         // if no affiliate code was given or player tried to use their own, lolz
260         if (_affCode == address(0) || _affCode == msg.sender)
261         {
262             // use last stored affiliate code
263             _affID = plyr_[_pID].laff;
264 
265             // if affiliate code was given
266         } else {
267             // get affiliate ID from aff Code
268             _affID = pIDxAddr_[_affCode];
269 
270             // if affID is not the same as previously stored
271             if (_affID != plyr_[_pID].laff)
272             {
273                 // update last affiliate
274                 plyr_[_pID].laff = _affID;
275             }
276         }
277 
278         // buy core
279         buyCore(_pID, _affID, _eventData_);
280     }
281 
282     function buyXname(bytes32 _affCode)
283     isActivated()
284     isHuman()
285     isWithinLimits(msg.value)
286     public
287     payable
288     {
289         // set up our tx event data and determine if player is new or not
290         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
291 
292         // fetch player id
293         uint256 _pID = pIDxAddr_[msg.sender];
294 
295         // manage affiliate residuals
296         uint256 _affID;
297         // if no affiliate code was given or player tried to use their own, lolz
298         if (_affCode == '' || _affCode == plyr_[_pID].name)
299         {
300             // use last stored affiliate code
301             _affID = plyr_[_pID].laff;
302 
303             // if affiliate code was given
304         } else {
305             // get affiliate ID from aff Code
306             _affID = pIDxName_[_affCode];
307 
308             // if affID is not the same as previously stored
309             if (_affID != plyr_[_pID].laff)
310             {
311                 // update last affiliate
312                 plyr_[_pID].laff = _affID;
313             }
314         }
315 
316         // buy core
317         buyCore(_pID, _affID, _eventData_);
318     }
319 
320     /**
321      * @dev essentially the same as buy, but instead of you sending ether
322      * from your wallet, it uses your unwithdrawn earnings.
323      * -functionhash- 0x349cdcac (using ID for affiliate)
324      * -functionhash- 0x82bfc739 (using address for affiliate)
325      * -functionhash- 0x079ce327 (using name for affiliate)
326      * @param _affCode the ID/address/name of the player who gets the affiliate fee
327      * @param _eth amount of earnings to use (remainder returned to gen vault)
328      */
329     function reLoadXid(uint256 _affCode, uint256 _eth)
330     isActivated()
331     isHuman()
332     isWithinLimits(_eth)
333     public
334     {
335         // set up our tx event data
336         LDdatasets.EventReturns memory _eventData_;
337 
338         // fetch player ID
339         uint256 _pID = pIDxAddr_[msg.sender];
340 
341         // manage affiliate residuals
342         // if no affiliate code was given or player tried to use their own, lolz
343         if (_affCode == 0 || _affCode == _pID)
344         {
345             // use last stored affiliate code
346             _affCode = plyr_[_pID].laff;
347 
348             // if affiliate code was given & its not the same as previously stored
349         } else if (_affCode != plyr_[_pID].laff) {
350             // update last affiliate
351             plyr_[_pID].laff = _affCode;
352         }
353 
354         // reload core
355         reLoadCore(_pID, _affCode, _eth, _eventData_);
356     }
357 
358     function reLoadXaddr(address _affCode, uint256 _eth)
359     isActivated()
360     isHuman()
361     isWithinLimits(_eth)
362     public
363     {
364         // set up our tx event data
365         LDdatasets.EventReturns memory _eventData_;
366 
367         // fetch player ID
368         uint256 _pID = pIDxAddr_[msg.sender];
369 
370         // manage affiliate residuals
371         uint256 _affID;
372         // if no affiliate code was given or player tried to use their own, lolz
373         if (_affCode == address(0) || _affCode == msg.sender)
374         {
375             // use last stored affiliate code
376             _affID = plyr_[_pID].laff;
377 
378             // if affiliate code was given
379         } else {
380             // get affiliate ID from aff Code
381             _affID = pIDxAddr_[_affCode];
382 
383             // if affID is not the same as previously stored
384             if (_affID != plyr_[_pID].laff)
385             {
386                 // update last affiliate
387                 plyr_[_pID].laff = _affID;
388             }
389         }
390 
391         // reload core
392         reLoadCore(_pID, _affID, _eth, _eventData_);
393     }
394 
395     function reLoadXname(bytes32 _affCode, uint256 _eth)
396     isActivated()
397     isHuman()
398     isWithinLimits(_eth)
399     public
400     {
401         // set up our tx event data
402         LDdatasets.EventReturns memory _eventData_;
403 
404         // fetch player ID
405         uint256 _pID = pIDxAddr_[msg.sender];
406 
407         // manage affiliate residuals
408         uint256 _affID;
409         // if no affiliate code was given or player tried to use their own, lolz
410         if (_affCode == '' || _affCode == plyr_[_pID].name)
411         {
412             // use last stored affiliate code
413             _affID = plyr_[_pID].laff;
414 
415             // if affiliate code was given
416         } else {
417             // get affiliate ID from aff Code
418             _affID = pIDxName_[_affCode];
419 
420             // if affID is not the same as previously stored
421             if (_affID != plyr_[_pID].laff)
422             {
423                 // update last affiliate
424                 plyr_[_pID].laff = _affID;
425             }
426         }
427 
428         // reload core
429         reLoadCore(_pID, _affID, _eth, _eventData_);
430     }
431 
432     /**
433      * @dev withdraws all of your earnings.
434      * -functionhash- 0x3ccfd60b
435      */
436     function withdraw()
437     isActivated()
438     isHuman()
439     public
440     {
441         // grab time
442         uint256 _now = now;
443 
444         // fetch player ID
445         uint256 _pID = pIDxAddr_[msg.sender];
446 
447         // setup temp var for player eth
448         uint256 _eth;
449 
450         // check to see if round has ended and no one has run round end yet
451         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
452         {
453             // set up our tx event data
454             LDdatasets.EventReturns memory _eventData_;
455 
456             // end the round (distributes pot)
457             round_.ended = true;
458             _eventData_ = endRound(_eventData_);
459 
460             // get their earnings
461             _eth = withdrawEarnings(_pID);
462 
463             // gib moni
464             if (_eth > 0)
465                 plyr_[_pID].addr.transfer(_eth);
466 
467             // build event data
468             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
469             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
470 
471             // fire withdraw and distribute event
472             emit MonkeyEvents.onWithdrawAndDistribute
473             (
474                 msg.sender,
475                 plyr_[_pID].name,
476                 _eth,
477                 _eventData_.compressedData,
478                 _eventData_.compressedIDs,
479                 _eventData_.winnerAddr,
480                 _eventData_.winnerName,
481                 _eventData_.amountWon,
482                 _eventData_.newPot,
483                 _eventData_.genAmount
484             );
485 
486             // in any other situation
487         } else {
488             // get their earnings
489             _eth = withdrawEarnings(_pID);
490 
491             // gib moni
492             if (_eth > 0)
493                 plyr_[_pID].addr.transfer(_eth);
494 
495             // fire withdraw event
496             emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
497         }
498     }
499 
500     /**
501      * @dev use these to register names.  they are just wrappers that will send the
502      * registration requests to the PlayerBook contract.  So registering here is the
503      * same as registering there.  UI will always display the last name you registered.
504      * but you will still own all previously registered names to use as affiliate
505      * links.
506      * - must pay a registration fee.
507      * - name must be unique
508      * - names will be converted to lowercase
509      * - name cannot start or end with a space
510      * - cannot have more than 1 space in a row
511      * - cannot be only numbers
512      * - cannot start with 0x
513      * - name must be at least 1 char
514      * - max length of 32 characters long
515      * - allowed characters: a-z, 0-9, and space
516      * -functionhash- 0x921dec21 (using ID for affiliate)
517      * -functionhash- 0x3ddd4698 (using address for affiliate)
518      * -functionhash- 0x685ffd83 (using name for affiliate)
519      * @param _nameString players desired name
520      * @param _affCode affiliate ID, address, or name of who referred you
521      * @param _all set to true if you want this to push your info to all games
522      * (this might cost a lot of gas)
523      */
524     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
525     isHuman()
526     public
527     payable
528     {
529         bytes32 _name = _nameString.nameFilter();
530         address _addr = msg.sender;
531         uint256 _paid = msg.value;
532         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
533 
534         uint256 _pID = pIDxAddr_[_addr];
535 
536         // fire event
537         emit MonkeyEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
538     }
539 
540     function registerNameXaddr(string _nameString, address _affCode, bool _all)
541     isHuman()
542     public
543     payable
544     {
545         bytes32 _name = _nameString.nameFilter();
546         address _addr = msg.sender;
547         uint256 _paid = msg.value;
548         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
549 
550         uint256 _pID = pIDxAddr_[_addr];
551 
552         // fire event
553         emit MonkeyEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
554     }
555 
556     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
557     isHuman()
558     public
559     payable
560     {
561         bytes32 _name = _nameString.nameFilter();
562         address _addr = msg.sender;
563         uint256 _paid = msg.value;
564         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
565 
566         uint256 _pID = pIDxAddr_[_addr];
567 
568         // fire event
569         emit MonkeyEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
570     }
571     //==============================================================================
572     //     _  _ _|__|_ _  _ _  .
573     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
574     //=====_|=======================================================================
575     /**
576      * @dev return the price buyer will pay for next 1 individual key.
577      * -functionhash- 0x018a25e8
578      * @return price for next key bought (in wei format)
579      */
580     function getBuyPrice()
581     public
582     view
583     returns(uint256)
584     {
585         // grab time
586         uint256 _now = now;
587 
588         // are we in a round?
589         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
590             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
591         else // rounds over.  need price for new round
592             return ( 75000000000000 ); // init
593     }
594 
595     /**
596      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
597      * provider
598      * -functionhash- 0xc7e284b8
599      * @return time left in seconds
600      */
601     function getTimeLeft()
602     public
603     view
604     returns(uint256)
605     {
606         // grab time
607         uint256 _now = now;
608 
609         if (_now < round_.end)
610             if (_now > round_.strt + rndGap_)
611                 return( (round_.end).sub(_now) );
612             else
613                 return( (round_.strt + rndGap_).sub(_now));
614         else
615             return(0);
616     }
617 
618     /**
619      * @dev returns player earnings per vaults
620      * -functionhash- 0x63066434
621      * @return winnings vault
622      * @return general vault
623      * @return affiliate vault
624      */
625     function getPlayerVaults(uint256 _pID)
626     public
627     view
628     returns(uint256 ,uint256, uint256)
629     {
630         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
631         if (now > round_.end && round_.ended == false && round_.plyr != 0)
632         {
633             // if player is winner
634             if (round_.plyr == _pID)
635             {
636                 return
637                 (
638                 (plyr_[_pID].win).add( ((round_.pot).mul(45)) / 100 ),
639                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
640                 plyr_[_pID].aff
641                 );
642                 // if player is not the winner
643             } else {
644                 return
645                 (
646                 plyr_[_pID].win,
647                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
648                 plyr_[_pID].aff
649                 );
650             }
651 
652             // if round is still going on, or round has ended and round end has been ran
653         } else {
654             return
655             (
656             plyr_[_pID].win,
657             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
658             plyr_[_pID].aff
659             );
660         }
661     }
662 
663     /**
664      * solidity hates stack limits.  this lets us avoid that hate
665      */
666     function getPlayerVaultsHelper(uint256 _pID)
667     private
668     view
669     returns(uint256)
670     {
671         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
672     }
673 
674     /**
675      * @dev returns all current round info needed for front end
676      * -functionhash- 0x747dff42
677      * @return total keys
678      * @return time ends
679      * @return time started
680      * @return current pot
681      * @return current player ID in lead
682      * @return current player in leads address
683      * @return current player in leads name
684      * @return airdrop tracker
685      * @return airdrop pot
686      */
687     function getCurrentRoundInfo()
688     public
689     view
690     returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256)
691     {
692         return
693         (
694         round_.keys,              //0
695         round_.end,               //1
696         round_.strt,              //2
697         round_.pot,               //3
698         round_.plyr,              //4
699         plyr_[round_.plyr].addr,  //5
700         plyr_[round_.plyr].name,  //6
701         airDropTracker_,          //7
702         airDropPot_               //8
703         );
704     }
705 
706     /**
707      * @dev returns player info based on address.  if no address is given, it will
708      * use msg.sender
709      * -functionhash- 0xee0b5d8b
710      * @param _addr address of the player you want to lookup
711      * @return player ID
712      * @return player name
713      * @return keys owned (current round)
714      * @return winnings vault
715      * @return general vault
716      * @return affiliate vault
717      * @return player round eth
718      */
719     function getPlayerInfoByAddress(address _addr)
720     public
721     view
722     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
723     {
724         if (_addr == address(0))
725         {
726             _addr == msg.sender;
727         }
728         uint256 _pID = pIDxAddr_[_addr];
729 
730         return
731         (
732         _pID,                               //0
733         plyr_[_pID].name,                   //1
734         plyrRnds_[_pID].keys,         //2
735         plyr_[_pID].win,                    //3
736         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
737         plyr_[_pID].aff,                    //5
738         plyrRnds_[_pID].eth           //6
739         );
740     }
741 
742     //==============================================================================
743     //     _ _  _ _   | _  _ . _  .
744     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
745     //=====================_|=======================================================
746     /**
747      * @dev logic runs whenever a buy order is executed.  determines how to handle
748      * incoming eth depending on if we are in an active round or not
749      */
750     function buyCore(uint256 _pID, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
751     private
752     {
753         // grab time
754         uint256 _now = now;
755 
756         // if round is active
757         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
758         {
759             // call core
760             core(_pID, msg.value, _affID, _eventData_);
761 
762             // if round is not active
763         } else {
764             // check to see if end round needs to be ran
765             if (_now > round_.end && round_.ended == false)
766             {
767                 // end the round (distributes pot) & start new round
768                 round_.ended = true;
769                 _eventData_ = endRound(_eventData_);
770 
771                 // build event data
772                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
773                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
774 
775                 // fire buy and distribute event
776                 emit MonkeyEvents.onBuyAndDistribute
777                 (
778                     msg.sender,
779                     plyr_[_pID].name,
780                     msg.value,
781                     _eventData_.compressedData,
782                     _eventData_.compressedIDs,
783                     _eventData_.winnerAddr,
784                     _eventData_.winnerName,
785                     _eventData_.amountWon,
786                     _eventData_.newPot,
787                     _eventData_.genAmount
788                 );
789             }
790 
791             // put eth in players vault
792             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
793         }
794     }
795 
796     /**
797      * @dev logic runs whenever a reload order is executed.  determines how to handle
798      * incoming eth depending on if we are in an active round or not
799      */
800     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, LDdatasets.EventReturns memory _eventData_)
801     private
802     {
803         // grab time
804         uint256 _now = now;
805 
806         // if round is active
807         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
808         {
809             // get earnings from all vaults and return unused to gen vault
810             // because we use a custom safemath library.  this will throw if player
811             // tried to spend more eth than they have.
812             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
813 
814             // call core
815             core(_pID, _eth, _affID, _eventData_);
816 
817             // if round is not active and end round needs to be ran
818         } else if (_now > round_.end && round_.ended == false) {
819             // end the round (distributes pot) & start new round
820             round_.ended = true;
821             _eventData_ = endRound(_eventData_);
822 
823             // build event data
824             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
825             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
826 
827             // fire buy and distribute event
828             emit MonkeyEvents.onReLoadAndDistribute
829             (
830                 msg.sender,
831                 plyr_[_pID].name,
832                 _eventData_.compressedData,
833                 _eventData_.compressedIDs,
834                 _eventData_.winnerAddr,
835                 _eventData_.winnerName,
836                 _eventData_.amountWon,
837                 _eventData_.newPot,
838                 _eventData_.genAmount
839             );
840         }
841     }
842 
843     /**
844      * @dev this is the core logic for any buy/reload that happens while a round
845      * is live.
846      */
847     function core(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
848     private
849     {
850         // if player is new to round
851         if (plyrRnds_[_pID].keys == 0)
852             _eventData_ = managePlayer(_pID, _eventData_);
853 
854         // early round eth limiter
855         if (round_.eth < 100000000000000000000 && plyrRnds_[_pID].eth.add(_eth) > 10000000000000000000)
856         {
857             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID].eth);
858             uint256 _refund = _eth.sub(_availableLimit);
859             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
860             _eth = _availableLimit;
861         }
862 
863         // if eth left is greater than min eth allowed (sorry no pocket lint)
864         if (_eth > 1000000000)
865         {
866 
867             // mint the new keys
868             uint256 _keys = (round_.eth).keysRec(_eth);
869 
870             // if they bought at least 1 whole key
871             if (_keys >= 1000000000000000000)
872             {
873                 updateTimer(_keys);
874 
875                 // set new leaders
876                 if (round_.plyr != _pID)
877                     round_.plyr = _pID;
878 
879                 // set the new leader bool to true
880                 _eventData_.compressedData = _eventData_.compressedData + 100;
881             }
882 
883             // manage airdrops
884             if (_eth >= 100000000000000000)  // larger 0.1eth
885             {
886                 airDropTracker_++;
887                 if (airdrop() == true)
888                 {
889                     // gib muni
890                     uint256 _prize;
891                     if (_eth >= 10000000000000000000)  // larger 10eth
892                     {
893                         // calculate prize and give it to winner
894                         _prize = ((airDropPot_).mul(75)) / 100;
895                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
896 
897                         // adjust airDropPot
898                         airDropPot_ = (airDropPot_).sub(_prize);
899 
900                         // let event know a tier 3 prize was won
901                         _eventData_.compressedData += 300000000000000000000000000000000;
902                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
903                         // calculate prize and give it to winner
904                         _prize = ((airDropPot_).mul(50)) / 100;
905                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
906 
907                         // adjust airDropPot
908                         airDropPot_ = (airDropPot_).sub(_prize);
909 
910                         // let event know a tier 2 prize was won
911                         _eventData_.compressedData += 200000000000000000000000000000000;
912                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
913                         // calculate prize and give it to winner
914                         _prize = ((airDropPot_).mul(25)) / 100;
915                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
916 
917                         // adjust airDropPot
918                         airDropPot_ = (airDropPot_).sub(_prize);
919 
920                         // let event know a tier 1 prize was won
921                         _eventData_.compressedData += 100000000000000000000000000000000;
922                     }
923                     // set airdrop happened bool to true
924                     _eventData_.compressedData += 10000000000000000000000000000000;
925                     // let event know how much was won
926                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
927 
928                     // reset air drop tracker
929                     airDropTracker_ = 0;
930                 }
931             }
932 
933             // store the air drop tracker number (number of buys since last airdrop)
934             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
935 
936             // update player
937             plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
938             plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
939 
940             // update round
941             round_.keys = _keys.add(round_.keys);
942             round_.eth = _eth.add(round_.eth);
943 
944             // distribute eth
945             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
946             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
947 
948             // call end tx function to fire end tx event.
949             endTx(_pID, _eth, _keys, _eventData_);
950         }
951     }
952     //==============================================================================
953     //     _ _ | _   | _ _|_ _  _ _  .
954     //    (_(_||(_|_||(_| | (_)| _\  .
955     //==============================================================================
956     /**
957      * @dev calculates unmasked earnings (just calculates, does not update mask)
958      * @return earnings in wei format
959      */
960     function calcUnMaskedEarnings(uint256 _pID)
961     private
962     view
963     returns(uint256)
964     {
965         return((((round_.mask).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask));
966     }
967 
968     /**
969      * @dev returns the amount of keys you would get given an amount of eth.
970      * -functionhash- 0xce89c80c
971      * @param _eth amount of eth sent in
972      * @return keys received
973      */
974     function calcKeysReceived(uint256 _eth)
975     public
976     view
977     returns(uint256)
978     {
979         // grab time
980         uint256 _now = now;
981 
982         // are we in a round?
983         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
984             return ( (round_.eth).keysRec(_eth) );
985         else // rounds over.  need keys for new round
986             return ( (_eth).keys() );
987     }
988 
989     /**
990      * @dev returns current eth price for X keys.
991      * -functionhash- 0xcf808000
992      * @param _keys number of keys desired (in 18 decimal format)
993      * @return amount of eth needed to send
994      */
995     function iWantXKeys(uint256 _keys)
996     public
997     view
998     returns(uint256)
999     {
1000         // grab time
1001         uint256 _now = now;
1002 
1003         // are we in a round?
1004         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1005             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1006         else // rounds over.  need price for new round
1007             return ( (_keys).eth() );
1008     }
1009     //==============================================================================
1010     //    _|_ _  _ | _  .
1011     //     | (_)(_)|_\  .
1012     //==============================================================================
1013     /**
1014      * @dev receives name/player info from names contract
1015      */
1016     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1017     external
1018     {
1019         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1020         if (pIDxAddr_[_addr] != _pID)
1021             pIDxAddr_[_addr] = _pID;
1022         if (pIDxName_[_name] != _pID)
1023             pIDxName_[_name] = _pID;
1024         if (plyr_[_pID].addr != _addr)
1025             plyr_[_pID].addr = _addr;
1026         if (plyr_[_pID].name != _name)
1027             plyr_[_pID].name = _name;
1028         if (plyr_[_pID].laff != _laff)
1029             plyr_[_pID].laff = _laff;
1030         if (plyrNames_[_pID][_name] == false)
1031             plyrNames_[_pID][_name] = true;
1032     }
1033 
1034     /**
1035      * @dev receives entire player name list
1036      */
1037     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1038     external
1039     {
1040         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1041         if(plyrNames_[_pID][_name] == false)
1042             plyrNames_[_pID][_name] = true;
1043     }
1044 
1045     /**
1046      * @dev gets existing or registers new pID.  use this when a player may be new
1047      * @return pID
1048      */
1049     function determinePID(LDdatasets.EventReturns memory _eventData_)
1050     private
1051     returns (LDdatasets.EventReturns)
1052     {
1053         uint256 _pID = pIDxAddr_[msg.sender];
1054         // if player is new to this version of ratscam
1055         if (_pID == 0)
1056         {
1057             // grab their player ID, name and last aff ID, from player names contract
1058             _pID = PlayerBook.getPlayerID(msg.sender);
1059             bytes32 _name = PlayerBook.getPlayerName(_pID);
1060             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1061 
1062             // set up player account
1063             pIDxAddr_[msg.sender] = _pID;
1064             plyr_[_pID].addr = msg.sender;
1065 
1066             if (_name != "")
1067             {
1068                 pIDxName_[_name] = _pID;
1069                 plyr_[_pID].name = _name;
1070                 plyrNames_[_pID][_name] = true;
1071             }
1072 
1073             if (_laff != 0 && _laff != _pID)
1074                 plyr_[_pID].laff = _laff;
1075 
1076             // set the new player bool to true
1077             _eventData_.compressedData = _eventData_.compressedData + 1;
1078         }
1079         return (_eventData_);
1080     }
1081 
1082     /**
1083      * @dev decides if round end needs to be run & new round started.  and if
1084      * player unmasked earnings from previously played rounds need to be moved.
1085      */
1086     function managePlayer(uint256 _pID, LDdatasets.EventReturns memory _eventData_)
1087     private
1088     returns (LDdatasets.EventReturns)
1089     {
1090         // set the joined round bool to true
1091         _eventData_.compressedData = _eventData_.compressedData + 10;
1092 
1093         return(_eventData_);
1094     }
1095 
1096     /**
1097      * @dev ends the round. manages paying out winner/splitting up pot
1098      */
1099     function endRound(LDdatasets.EventReturns memory _eventData_)
1100     private
1101     returns (LDdatasets.EventReturns)
1102     {
1103         // grab our winning player and team id's
1104         uint256 _winPID = round_.plyr;
1105 
1106         // grab our pot amount
1107         // add airdrop pot into the final pot
1108         uint256 _pot = round_.pot + airDropPot_;
1109 
1110         // calculate our winner share, community rewards, gen share,
1111         uint256 _win = (_pot.mul(40)) / 100;
1112         uint256 _com = (_pot.mul(30)) / 100;
1113         uint256 _queen = (_pot.mul(10)) / 100;
1114         uint256 _gen = (_pot.mul(20)) / 100;
1115 
1116         // calculate ppt for round mask
1117         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1118         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1119         if (_dust > 0)
1120         {
1121             _gen = _gen.sub(_dust);
1122             _com = _com.add(_dust);
1123         }
1124 
1125         // pay our winner
1126         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1127 
1128         // community rewards
1129         if (!address(monkeyKing).call.value(_com)())
1130         {
1131             _gen = _gen.add(_com);
1132             _com = 0;
1133         }
1134 
1135         if (!address(monkeyQueue).call.value(_queen)())
1136         {
1137             _gen = _gen.add(_queen);
1138             _queen = 0;
1139         }
1140 
1141         // distribute gen portion to key holders
1142         round_.mask = _ppt.add(round_.mask);
1143 
1144         // prepare event data
1145         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1146         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1147         _eventData_.winnerAddr = plyr_[_winPID].addr;
1148         _eventData_.winnerName = plyr_[_winPID].name;
1149         _eventData_.amountWon = _win;
1150         _eventData_.genAmount = _gen;
1151         _eventData_.newPot = 0;
1152 
1153         return(_eventData_);
1154     }
1155 
1156     /**
1157      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1158      */
1159     function updateGenVault(uint256 _pID)
1160     private
1161     {
1162         uint256 _earnings = calcUnMaskedEarnings(_pID);
1163         if (_earnings > 0)
1164         {
1165             // put in gen vault
1166             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1167             // zero out their earnings by updating mask
1168             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1169         }
1170     }
1171 
1172     /**
1173      * @dev updates round timer based on number of whole keys bought.
1174      */
1175     function updateTimer(uint256 _keys)
1176     private
1177     {
1178         // grab time
1179         uint256 _now = now;
1180 
1181         // calculate time based on number of keys bought
1182         uint256 _newTime;
1183         if (_now > round_.end && round_.plyr == 0)
1184             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1185         else
1186             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1187 
1188         // compare to max and set new end time
1189         if (_newTime < (rndMax_).add(_now))
1190             round_.end = _newTime;
1191         else
1192             round_.end = rndMax_.add(_now);
1193     }
1194 
1195     /**
1196      * @dev generates a random number between 0-99 and checks to see if thats
1197      * resulted in an airdrop win
1198      * @return do we have a winner?
1199      */
1200     function airdrop()
1201     private
1202     view
1203     returns(bool)
1204     {
1205         uint256 seed = uint256(keccak256(abi.encodePacked(
1206 
1207                 (block.timestamp).add
1208                 (block.difficulty).add
1209                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1210                 (block.gaslimit).add
1211                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1212                 (block.number)
1213 
1214             )));
1215         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1216             return(true);
1217         else
1218             return(false);
1219     }
1220 
1221     /**
1222      * @dev distributes eth based on fees to com, aff, and p3d
1223      */
1224     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
1225     private
1226     returns(LDdatasets.EventReturns)
1227     {
1228         // pay 15% out to community rewards
1229         uint256 _com = _eth * 15 / 100;
1230 
1231         // distribute share to affiliate 25%
1232         uint256 _aff = _eth*25 / 100;
1233 
1234         uint256 _toqueen = 0;
1235 
1236         // decide what to do with affiliate share of fees
1237         // affiliate must not be self, and must have a name registered
1238         if (_affID != _pID && plyr_[_affID].name != '') {
1239             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1240             emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1241         } else {
1242             // no affiliates, add to community
1243             _com += (_aff*80/100);
1244             _toqueen += (_aff*20/100);
1245         }
1246 
1247         if (_toqueen > 0) {
1248             if(!address(monkeyQueue).call.value(_toqueen)()) {
1249                 //do nothing
1250             }
1251         }
1252 
1253         if (!address(monkeyKing).call.value(_com)())
1254         {
1255             // This ensures Team Just cannot influence the outcome of FoMo3D with
1256             // bank migrations by breaking outgoing transactions.
1257             // Something we would never do. But that's not the point.
1258             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1259             // highest belief that everything we create should be trustless.
1260             // Team JUST, The name you shouldn't have to trust.
1261         }
1262 
1263         return(_eventData_);
1264     }
1265 
1266     /**
1267      * @dev distributes eth based on fees to gen and pot
1268      */
1269     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, LDdatasets.EventReturns memory _eventData_)
1270     private
1271     returns(LDdatasets.EventReturns)
1272     {
1273         // calculate gen share
1274         uint256 _gen = (_eth.mul(fees_)) / 100;
1275 
1276         // toss 5% into airdrop pot
1277         uint256 _air = (_eth / 20);
1278         airDropPot_ = airDropPot_.add(_air);
1279 
1280         // calculate pot (15%)
1281         uint256 _pot = (_eth.mul(15) / 100);
1282 
1283         // distribute gen share (thats what updateMasks() does) and adjust
1284         // balances for dust.
1285         uint256 _dust = updateMasks(_pID, _gen, _keys);
1286         if (_dust > 0)
1287             _gen = _gen.sub(_dust);
1288 
1289         // add eth to pot
1290         round_.pot = _pot.add(_dust).add(round_.pot);
1291 
1292         // set up event data
1293         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1294         _eventData_.potAmount = _pot;
1295 
1296         return(_eventData_);
1297     }
1298 
1299     /**
1300      * @dev updates masks for round and player when keys are bought
1301      * @return dust left over
1302      */
1303     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1304     private
1305     returns(uint256)
1306     {
1307         /* MASKING NOTES
1308             earnings masks are a tricky thing for people to wrap their minds around.
1309             the basic thing to understand here.  is were going to have a global
1310             tracker based on profit per share for each round, that increases in
1311             relevant proportion to the increase in share supply.
1312 
1313             the player will have an additional mask that basically says "based
1314             on the rounds mask, my shares, and how much i've already withdrawn,
1315             how much is still owed to me?"
1316         */
1317 
1318         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1319         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1320         round_.mask = _ppt.add(round_.mask);
1321 
1322         // calculate player earning from their own buy (only based on the keys
1323         // they just bought).  & update player earnings mask
1324         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1325         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1326 
1327         // calculate & return dust
1328         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1329     }
1330 
1331     /**
1332      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1333      * @return earnings in wei format
1334      */
1335     function withdrawEarnings(uint256 _pID)
1336     private
1337     returns(uint256)
1338     {
1339         // update gen vault
1340         updateGenVault(_pID);
1341 
1342         // from vaults
1343         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1344         if (_earnings > 0)
1345         {
1346             plyr_[_pID].win = 0;
1347             plyr_[_pID].gen = 0;
1348             plyr_[_pID].aff = 0;
1349         }
1350 
1351         return(_earnings);
1352     }
1353 
1354     /**
1355      * @dev prepares compression data and fires event for buy or reload tx's
1356      */
1357     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, LDdatasets.EventReturns memory _eventData_)
1358     private
1359     {
1360         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1361         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1362 
1363         emit MonkeyEvents.onEndTx
1364         (
1365             _eventData_.compressedData,
1366             _eventData_.compressedIDs,
1367             plyr_[_pID].name,
1368             msg.sender,
1369             _eth,
1370             _keys,
1371             _eventData_.winnerAddr,
1372             _eventData_.winnerName,
1373             _eventData_.amountWon,
1374             _eventData_.newPot,
1375             _eventData_.genAmount,
1376             _eventData_.potAmount,
1377             airDropPot_
1378         );
1379     }
1380 
1381     /** upon contract deploy, it will be deactivated.  this is a one time
1382      * use function that will activate the contract.  we do this so devs
1383      * have time to set things up on the web end                            **/
1384     bool public activated_ = false;
1385     function activate()
1386     public
1387     {
1388         // only owner can activate
1389         // TODO: set owner
1390         require(
1391             msg.sender == 0xb75603Fd0B0E55b283DAC9A9ED516A8a9515e3dB ||
1392             msg.sender == 0x029800F64f16d81FC164319Edb84cf85bFf15e80,
1393             "only owner can activate"
1394         );
1395 
1396         // can only be ran once
1397         require(activated_ == false, "dogscam already activated");
1398 
1399         // activate the contract
1400         activated_ = true;
1401 
1402         round_.strt = now - rndGap_;
1403         round_.end = now + rndInit_;
1404     }
1405 }
1406 
1407 //==============================================================================
1408 //   __|_ _    __|_ _  .
1409 //  _\ | | |_|(_ | _\  .
1410 //==============================================================================
1411 library LDdatasets {
1412     //compressedData key
1413     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1414     // 0 - new player (bool)
1415     // 1 - joined round (bool)
1416     // 2 - new  leader (bool)
1417     // 3-5 - air drop tracker (uint 0-999)
1418     // 6-16 - round end time
1419     // 17 - winnerTeam
1420     // 18 - 28 timestamp
1421     // 29 - team
1422     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1423     // 31 - airdrop happened bool
1424     // 32 - airdrop tier
1425     // 33 - airdrop amount won
1426     //compressedIDs key
1427     // [77-52][51-26][25-0]
1428     // 0-25 - pID
1429     // 26-51 - winPID
1430     // 52-77 - rID
1431     struct EventReturns {
1432         uint256 compressedData;
1433         uint256 compressedIDs;
1434         address winnerAddr;         // winner address
1435         bytes32 winnerName;         // winner name
1436         uint256 amountWon;          // amount won
1437         uint256 newPot;             // amount in new pot
1438         uint256 genAmount;          // amount distributed to gen
1439         uint256 potAmount;          // amount added to pot
1440     }
1441     struct Player {
1442         address addr;   // player address
1443         bytes32 name;   // player name
1444         uint256 win;    // winnings vault
1445         uint256 gen;    // general vault
1446         uint256 aff;    // affiliate vault
1447         uint256 laff;   // last affiliate id used
1448     }
1449     struct PlayerRounds {
1450         uint256 eth;    // eth player has added to round (used for eth limiter)
1451         uint256 keys;   // keys
1452         uint256 mask;   // player mask
1453     }
1454     struct Round {
1455         uint256 plyr;   // pID of player in lead
1456         uint256 end;    // time ends/ended
1457         bool ended;     // has round end function been ran
1458         uint256 strt;   // time round started
1459         uint256 keys;   // keys
1460         uint256 eth;    // total eth in
1461         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1462         uint256 mask;   // global mask
1463     }
1464 }
1465 
1466 //==============================================================================
1467 //  |  _      _ _ | _  .
1468 //  |<(/_\/  (_(_||(_  .
1469 //=======/======================================================================
1470 library LDKeysCalc {
1471     using SafeMath for *;
1472     /**
1473      * @dev calculates number of keys received given X eth
1474      * @param _curEth current amount of eth in contract
1475      * @param _newEth eth being spent
1476      * @return amount of ticket purchased
1477      */
1478     function keysRec(uint256 _curEth, uint256 _newEth)
1479     internal
1480     pure
1481     returns (uint256)
1482     {
1483         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1484     }
1485 
1486     /**
1487      * @dev calculates amount of eth received if you sold X keys
1488      * @param _curKeys current amount of keys that exist
1489      * @param _sellKeys amount of keys you wish to sell
1490      * @return amount of eth received
1491      */
1492     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1493     internal
1494     pure
1495     returns (uint256)
1496     {
1497         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1498     }
1499 
1500     /**
1501      * @dev calculates how many keys would exist with given an amount of eth
1502      * @param _eth eth "in contract"
1503      * @return number of keys that would exist
1504      */
1505     function keys(uint256 _eth)
1506     internal
1507     pure
1508     returns(uint256)
1509     {
1510         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1511     }
1512 
1513     /**
1514      * @dev calculates how much eth would be in contract given a number of keys
1515      * @param _keys number of keys "in contract"
1516      * @return eth that would exists
1517      */
1518     function eth(uint256 _keys)
1519     internal
1520     pure
1521     returns(uint256)
1522     {
1523         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1524     }
1525 }
1526 
1527 
1528 interface PlayerBookInterface {
1529     function getPlayerID(address _addr) external returns (uint256);
1530     function getPlayerName(uint256 _pID) external view returns (bytes32);
1531     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1532     function getPlayerAddr(uint256 _pID) external view returns (address);
1533     function getNameFee() external view returns (uint256);
1534     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1535     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1536     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1537 }
1538 
1539 library NameFilter {
1540     /**
1541      * @dev filters name strings
1542      * -converts uppercase to lower case.
1543      * -makes sure it does not start/end with a space
1544      * -makes sure it does not contain multiple spaces in a row
1545      * -cannot be only numbers
1546      * -cannot start with 0x
1547      * -restricts characters to A-Z, a-z, 0-9, and space.
1548      * @return reprocessed string in bytes32 format
1549      */
1550     function nameFilter(string _input)
1551     internal
1552     pure
1553     returns(bytes32)
1554     {
1555         bytes memory _temp = bytes(_input);
1556         uint256 _length = _temp.length;
1557 
1558         //sorry limited to 32 characters
1559         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1560         // make sure it doesnt start with or end with space
1561         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1562         // make sure first two characters are not 0x
1563         if (_temp[0] == 0x30)
1564         {
1565             require(_temp[1] != 0x78, "string cannot start with 0x");
1566             require(_temp[1] != 0x58, "string cannot start with 0X");
1567         }
1568 
1569         // create a bool to track if we have a non number character
1570         bool _hasNonNumber;
1571 
1572         // convert & check
1573         for (uint256 i = 0; i < _length; i++)
1574         {
1575             // if its uppercase A-Z
1576             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1577             {
1578                 // convert to lower case a-z
1579                 _temp[i] = byte(uint(_temp[i]) + 32);
1580 
1581                 // we have a non number
1582                 if (_hasNonNumber == false)
1583                     _hasNonNumber = true;
1584             } else {
1585                 require
1586                 (
1587                 // require character is a space
1588                     _temp[i] == 0x20 ||
1589                 // OR lowercase a-z
1590                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1591                 // or 0-9
1592                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1593                     "string contains invalid characters"
1594                 );
1595                 // make sure theres not 2x spaces in a row
1596                 if (_temp[i] == 0x20)
1597                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1598 
1599                 // see if we have a character other than a number
1600                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1601                     _hasNonNumber = true;
1602             }
1603         }
1604 
1605         require(_hasNonNumber == true, "string cannot be only numbers");
1606 
1607         bytes32 _ret;
1608         assembly {
1609             _ret := mload(add(_temp, 32))
1610         }
1611         return (_ret);
1612     }
1613 }
1614 
1615 /**
1616  * @title SafeMath v0.1.9
1617  * @dev Math operations with safety checks that throw on error
1618  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1619  * - added sqrt
1620  * - added sq
1621  * - changed asserts to requires with error log outputs
1622  * - removed div, its useless
1623  */
1624 library SafeMath {
1625 
1626     /**
1627     * @dev Multiplies two numbers, throws on overflow.
1628     */
1629     function mul(uint256 a, uint256 b)
1630     internal
1631     pure
1632     returns (uint256 c)
1633     {
1634         if (a == 0) {
1635             return 0;
1636         }
1637         c = a * b;
1638         require(c / a == b, "SafeMath mul failed");
1639         return c;
1640     }
1641 
1642     /**
1643     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1644     */
1645     function sub(uint256 a, uint256 b)
1646     internal
1647     pure
1648     returns (uint256)
1649     {
1650         require(b <= a, "SafeMath sub failed");
1651         return a - b;
1652     }
1653 
1654     /**
1655     * @dev Adds two numbers, throws on overflow.
1656     */
1657     function add(uint256 a, uint256 b)
1658     internal
1659     pure
1660     returns (uint256 c)
1661     {
1662         c = a + b;
1663         require(c >= a, "SafeMath add failed");
1664         return c;
1665     }
1666 
1667     /**
1668      * @dev gives square root of given x.
1669      */
1670     function sqrt(uint256 x)
1671     internal
1672     pure
1673     returns (uint256 y)
1674     {
1675         uint256 z = ((add(x,1)) / 2);
1676         y = x;
1677         while (z < y)
1678         {
1679             y = z;
1680             z = ((add((x / z),z)) / 2);
1681         }
1682     }
1683 
1684     /**
1685      * @dev gives square. multiplies x by x
1686      */
1687     function sq(uint256 x)
1688     internal
1689     pure
1690     returns (uint256)
1691     {
1692         return (mul(x,x));
1693     }
1694 }