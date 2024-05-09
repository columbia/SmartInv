1 pragma solidity ^0.4.24;
2 
3 contract RSEvents {
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
105 contract modularRatScam is RSEvents {}
106 
107 contract RatScam is modularRatScam {
108     using SafeMath for *;
109     using NameFilter for string;
110     using RSKeysCalc for uint256;
111 	
112     // TODO: check address
113     RatInterfaceForForwarder constant private RatKingCorp = RatInterfaceForForwarder(0xe7c3101745b3dd71228006084dccb619340f8390);
114 	RatBookInterface constant private RatBook = RatBookInterface(0xf5c4a2c3a92a8450899d064074cec29a9756c95d);
115 
116     string constant public name = "RatScam Round #1";
117     string constant public symbol = "RS1";
118     uint256 private rndGap_ = 0;
119 
120     // TODO: check time
121     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
122     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
123     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
124 //==============================================================================
125 //     _| _ _|_ _    _ _ _|_    _   .
126 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
127 //=============================|================================================
128 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
129     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
130 //****************
131 // PLAYER DATA 
132 //****************
133     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
134     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
135     mapping (uint256 => RSdatasets.Player) public plyr_;   // (pID => data) player data
136     mapping (uint256 => RSdatasets.PlayerRounds) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
137     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
138 //****************
139 // ROUND DATA 
140 //****************
141     RSdatasets.Round public round_;   // round data
142 //****************
143 // TEAM FEE DATA 
144 //****************
145     uint256 public fees_ = 60;          // fee distribution
146     uint256 public potSplit_ = 45;     // pot split distribution
147 //==============================================================================
148 //     _ _  _  __|_ _    __|_ _  _  .
149 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
150 //==============================================================================
151     constructor()
152         public
153     {
154 	}
155 //==============================================================================
156 //     _ _  _  _|. |`. _  _ _  .
157 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
158 //==============================================================================
159     /**
160      * @dev used to make sure no one can interact with contract until it has 
161      * been activated. 
162      */
163     modifier isActivated() {
164         require(activated_ == true, "its not ready yet"); 
165         _;
166     }
167     
168     /**
169      * @dev prevents contracts from interacting with ratscam 
170      */
171     modifier isHuman() {
172         require(msg.sender == tx.origin);
173         _;
174     }
175 
176     /**
177      * @dev sets boundaries for incoming tx 
178      */
179     modifier isWithinLimits(uint256 _eth) {
180         require(_eth >= 1000000000, "too little money");
181         require(_eth <= 100000000000000000000000, "too much money");
182         _;    
183     }
184     
185 //==============================================================================
186 //     _    |_ |. _   |`    _  __|_. _  _  _  .
187 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
188 //====|=========================================================================
189     /**
190      * @dev emergency buy uses last stored affiliate ID and team snek
191      */
192     function()
193         isActivated()
194         isHuman()
195         isWithinLimits(msg.value)
196         public
197         payable
198     {
199         // set up our tx event data and determine if player is new or not
200         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
201             
202         // fetch player id
203         uint256 _pID = pIDxAddr_[msg.sender];
204         
205         // buy core 
206         buyCore(_pID, plyr_[_pID].laff, _eventData_);
207     }
208     
209     /**
210      * @dev converts all incoming ethereum to keys.
211      * -functionhash- 0x8f38f309 (using ID for affiliate)
212      * -functionhash- 0x98a0871d (using address for affiliate)
213      * -functionhash- 0xa65b37a1 (using name for affiliate)
214      * @param _affCode the ID/address/name of the player who gets the affiliate fee
215      */
216     function buyXid(uint256 _affCode)
217         isActivated()
218         isHuman()
219         isWithinLimits(msg.value)
220         public
221         payable
222     {
223         // set up our tx event data and determine if player is new or not
224         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
225         
226         // fetch player id
227         uint256 _pID = pIDxAddr_[msg.sender];
228         
229         // manage affiliate residuals
230         // if no affiliate code was given or player tried to use their own, lolz
231         if (_affCode == 0 || _affCode == _pID)
232         {
233             // use last stored affiliate code 
234             _affCode = plyr_[_pID].laff;
235             
236         // if affiliate code was given & its not the same as previously stored 
237         } else if (_affCode != plyr_[_pID].laff) {
238             // update last affiliate 
239             plyr_[_pID].laff = _affCode;
240         }
241                 
242         // buy core 
243         buyCore(_pID, _affCode, _eventData_);
244     }
245     
246     function buyXaddr(address _affCode)
247         isActivated()
248         isHuman()
249         isWithinLimits(msg.value)
250         public
251         payable
252     {
253         // set up our tx event data and determine if player is new or not
254         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
255         
256         // fetch player id
257         uint256 _pID = pIDxAddr_[msg.sender];
258         
259         // manage affiliate residuals
260         uint256 _affID;
261         // if no affiliate code was given or player tried to use their own, lolz
262         if (_affCode == address(0) || _affCode == msg.sender)
263         {
264             // use last stored affiliate code
265             _affID = plyr_[_pID].laff;
266         
267         // if affiliate code was given    
268         } else {
269             // get affiliate ID from aff Code 
270             _affID = pIDxAddr_[_affCode];
271             
272             // if affID is not the same as previously stored 
273             if (_affID != plyr_[_pID].laff)
274             {
275                 // update last affiliate
276                 plyr_[_pID].laff = _affID;
277             }
278         }
279         
280         // buy core 
281         buyCore(_pID, _affID, _eventData_);
282     }
283     
284     function buyXname(bytes32 _affCode)
285         isActivated()
286         isHuman()
287         isWithinLimits(msg.value)
288         public
289         payable
290     {
291         // set up our tx event data and determine if player is new or not
292         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
293         
294         // fetch player id
295         uint256 _pID = pIDxAddr_[msg.sender];
296         
297         // manage affiliate residuals
298         uint256 _affID;
299         // if no affiliate code was given or player tried to use their own, lolz
300         if (_affCode == '' || _affCode == plyr_[_pID].name)
301         {
302             // use last stored affiliate code
303             _affID = plyr_[_pID].laff;
304         
305         // if affiliate code was given
306         } else {
307             // get affiliate ID from aff Code
308             _affID = pIDxName_[_affCode];
309             
310             // if affID is not the same as previously stored
311             if (_affID != plyr_[_pID].laff)
312             {
313                 // update last affiliate
314                 plyr_[_pID].laff = _affID;
315             }
316         }
317         
318         // buy core 
319         buyCore(_pID, _affID, _eventData_);
320     }
321     
322     /**
323      * @dev essentially the same as buy, but instead of you sending ether 
324      * from your wallet, it uses your unwithdrawn earnings.
325      * -functionhash- 0x349cdcac (using ID for affiliate)
326      * -functionhash- 0x82bfc739 (using address for affiliate)
327      * -functionhash- 0x079ce327 (using name for affiliate)
328      * @param _affCode the ID/address/name of the player who gets the affiliate fee
329      * @param _eth amount of earnings to use (remainder returned to gen vault)
330      */
331     function reLoadXid(uint256 _affCode, uint256 _eth)
332         isActivated()
333         isHuman()
334         isWithinLimits(_eth)
335         public
336     {
337         // set up our tx event data
338         RSdatasets.EventReturns memory _eventData_;
339         
340         // fetch player ID
341         uint256 _pID = pIDxAddr_[msg.sender];
342         
343         // manage affiliate residuals
344         // if no affiliate code was given or player tried to use their own, lolz
345         if (_affCode == 0 || _affCode == _pID)
346         {
347             // use last stored affiliate code 
348             _affCode = plyr_[_pID].laff;
349             
350         // if affiliate code was given & its not the same as previously stored 
351         } else if (_affCode != plyr_[_pID].laff) {
352             // update last affiliate 
353             plyr_[_pID].laff = _affCode;
354         }
355 
356         // reload core
357         reLoadCore(_pID, _affCode, _eth, _eventData_);
358     }
359     
360     function reLoadXaddr(address _affCode, uint256 _eth)
361         isActivated()
362         isHuman()
363         isWithinLimits(_eth)
364         public
365     {
366         // set up our tx event data
367         RSdatasets.EventReturns memory _eventData_;
368         
369         // fetch player ID
370         uint256 _pID = pIDxAddr_[msg.sender];
371         
372         // manage affiliate residuals
373         uint256 _affID;
374         // if no affiliate code was given or player tried to use their own, lolz
375         if (_affCode == address(0) || _affCode == msg.sender)
376         {
377             // use last stored affiliate code
378             _affID = plyr_[_pID].laff;
379         
380         // if affiliate code was given    
381         } else {
382             // get affiliate ID from aff Code 
383             _affID = pIDxAddr_[_affCode];
384             
385             // if affID is not the same as previously stored 
386             if (_affID != plyr_[_pID].laff)
387             {
388                 // update last affiliate
389                 plyr_[_pID].laff = _affID;
390             }
391         }
392                 
393         // reload core
394         reLoadCore(_pID, _affID, _eth, _eventData_);
395     }
396     
397     function reLoadXname(bytes32 _affCode, uint256 _eth)
398         isActivated()
399         isHuman()
400         isWithinLimits(_eth)
401         public
402     {
403         // set up our tx event data
404         RSdatasets.EventReturns memory _eventData_;
405         
406         // fetch player ID
407         uint256 _pID = pIDxAddr_[msg.sender];
408         
409         // manage affiliate residuals
410         uint256 _affID;
411         // if no affiliate code was given or player tried to use their own, lolz
412         if (_affCode == '' || _affCode == plyr_[_pID].name)
413         {
414             // use last stored affiliate code
415             _affID = plyr_[_pID].laff;
416         
417         // if affiliate code was given
418         } else {
419             // get affiliate ID from aff Code
420             _affID = pIDxName_[_affCode];
421             
422             // if affID is not the same as previously stored
423             if (_affID != plyr_[_pID].laff)
424             {
425                 // update last affiliate
426                 plyr_[_pID].laff = _affID;
427             }
428         }
429                 
430         // reload core
431         reLoadCore(_pID, _affID, _eth, _eventData_);
432     }
433 
434     /**
435      * @dev withdraws all of your earnings.
436      * -functionhash- 0x3ccfd60b
437      */
438     function withdraw()
439         isActivated()
440         isHuman()
441         public
442     {        
443         // grab time
444         uint256 _now = now;
445         
446         // fetch player ID
447         uint256 _pID = pIDxAddr_[msg.sender];
448         
449         // setup temp var for player eth
450         uint256 _eth;
451         
452         // check to see if round has ended and no one has run round end yet
453         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
454         {
455             // set up our tx event data
456             RSdatasets.EventReturns memory _eventData_;
457             
458             // end the round (distributes pot)
459 			round_.ended = true;
460             _eventData_ = endRound(_eventData_);
461             
462 			// get their earnings
463             _eth = withdrawEarnings(_pID);
464             
465             // gib moni
466             if (_eth > 0)
467                 plyr_[_pID].addr.transfer(_eth);    
468             
469             // build event data
470             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
471             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
472             
473             // fire withdraw and distribute event
474             emit RSEvents.onWithdrawAndDistribute
475             (
476                 msg.sender, 
477                 plyr_[_pID].name, 
478                 _eth, 
479                 _eventData_.compressedData, 
480                 _eventData_.compressedIDs, 
481                 _eventData_.winnerAddr, 
482                 _eventData_.winnerName, 
483                 _eventData_.amountWon, 
484                 _eventData_.newPot, 
485                 _eventData_.genAmount
486             );
487             
488         // in any other situation
489         } else {
490             // get their earnings
491             _eth = withdrawEarnings(_pID);
492             
493             // gib moni
494             if (_eth > 0)
495                 plyr_[_pID].addr.transfer(_eth);
496             
497             // fire withdraw event
498             emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
499         }
500     }
501     
502     /**
503      * @dev use these to register names.  they are just wrappers that will send the
504      * registration requests to the PlayerBook contract.  So registering here is the 
505      * same as registering there.  UI will always display the last name you registered.
506      * but you will still own all previously registered names to use as affiliate 
507      * links.
508      * - must pay a registration fee.
509      * - name must be unique
510      * - names will be converted to lowercase
511      * - name cannot start or end with a space 
512      * - cannot have more than 1 space in a row
513      * - cannot be only numbers
514      * - cannot start with 0x 
515      * - name must be at least 1 char
516      * - max length of 32 characters long
517      * - allowed characters: a-z, 0-9, and space
518      * -functionhash- 0x921dec21 (using ID for affiliate)
519      * -functionhash- 0x3ddd4698 (using address for affiliate)
520      * -functionhash- 0x685ffd83 (using name for affiliate)
521      * @param _nameString players desired name
522      * @param _affCode affiliate ID, address, or name of who referred you
523      * @param _all set to true if you want this to push your info to all games 
524      * (this might cost a lot of gas)
525      */
526     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
527         isHuman()
528         public
529         payable
530     {
531         bytes32 _name = _nameString.nameFilter();
532         address _addr = msg.sender;
533         uint256 _paid = msg.value;
534         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
535 
536         uint256 _pID = pIDxAddr_[_addr];
537         
538         // fire event
539         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
540     }
541     
542     function registerNameXaddr(string _nameString, address _affCode, bool _all)
543         isHuman()
544         public
545         payable
546     {
547         bytes32 _name = _nameString.nameFilter();
548         address _addr = msg.sender;
549         uint256 _paid = msg.value;
550         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
551         
552         uint256 _pID = pIDxAddr_[_addr];
553         
554         // fire event
555         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
556     }
557     
558     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
559         isHuman()
560         public
561         payable
562     {
563         bytes32 _name = _nameString.nameFilter();
564         address _addr = msg.sender;
565         uint256 _paid = msg.value;
566         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
567         
568         uint256 _pID = pIDxAddr_[_addr];
569         
570         // fire event
571         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
572     }
573 //==============================================================================
574 //     _  _ _|__|_ _  _ _  .
575 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
576 //=====_|=======================================================================
577     /**
578      * @dev return the price buyer will pay for next 1 individual key.
579      * -functionhash- 0x018a25e8
580      * @return price for next key bought (in wei format)
581      */
582     function getBuyPrice()
583         public 
584         view 
585         returns(uint256)
586     {          
587         // grab time
588         uint256 _now = now;
589         
590         // are we in a round?
591         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
592             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
593         else // rounds over.  need price for new round
594             return ( 75000000000000 ); // init
595     }
596     
597     /**
598      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
599      * provider
600      * -functionhash- 0xc7e284b8
601      * @return time left in seconds
602      */
603     function getTimeLeft()
604         public
605         view
606         returns(uint256)
607     {
608         // grab time
609         uint256 _now = now;
610         
611         if (_now < round_.end)
612             if (_now > round_.strt + rndGap_)
613                 return( (round_.end).sub(_now) );
614             else
615                 return( (round_.strt + rndGap_).sub(_now));
616         else
617             return(0);
618     }
619     
620     /**
621      * @dev returns player earnings per vaults 
622      * -functionhash- 0x63066434
623      * @return winnings vault
624      * @return general vault
625      * @return affiliate vault
626      */
627     function getPlayerVaults(uint256 _pID)
628         public
629         view
630         returns(uint256 ,uint256, uint256)
631     {
632         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
633         if (now > round_.end && round_.ended == false && round_.plyr != 0)
634         {
635             // if player is winner 
636             if (round_.plyr == _pID)
637             {
638                 return
639                 (
640                     (plyr_[_pID].win).add( ((round_.pot).mul(48)) / 100 ),
641                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
642                     plyr_[_pID].aff
643                 );
644             // if player is not the winner
645             } else {
646                 return
647                 (
648                     plyr_[_pID].win,
649                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
650                     plyr_[_pID].aff
651                 );
652             }
653             
654         // if round is still going on, or round has ended and round end has been ran
655         } else {
656             return
657             (
658                 plyr_[_pID].win,
659                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
660                 plyr_[_pID].aff
661             );
662         }
663     }
664     
665     /**
666      * solidity hates stack limits.  this lets us avoid that hate 
667      */
668     function getPlayerVaultsHelper(uint256 _pID)
669         private
670         view
671         returns(uint256)
672     {
673         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
674     }
675     
676     /**
677      * @dev returns all current round info needed for front end
678      * -functionhash- 0x747dff42
679      * @return total keys
680      * @return time ends
681      * @return time started
682      * @return current pot 
683      * @return current player ID in lead 
684      * @return current player in leads address 
685      * @return current player in leads name
686      * @return airdrop tracker # & airdrop pot
687      */
688     function getCurrentRoundInfo()
689         public
690         view
691         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
692     {
693         return
694         (
695             round_.keys,              //0
696             round_.end,               //1
697             round_.strt,              //2
698             round_.pot,               //3
699             round_.plyr,              //4
700             plyr_[round_.plyr].addr,  //5
701             plyr_[round_.plyr].name,  //6
702             airDropTracker_ + (airDropPot_ * 1000)              //7
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
717 	 * @return player round eth
718      */
719     function getPlayerInfoByAddress(address _addr)
720         public 
721         view 
722         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
723     {
724         if (_addr == address(0))
725         {
726             _addr == msg.sender;
727         }
728         uint256 _pID = pIDxAddr_[_addr];
729         
730         return
731         (
732             _pID,                               //0
733             plyr_[_pID].name,                   //1
734             plyrRnds_[_pID].keys,         //2
735             plyr_[_pID].win,                    //3
736             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
737             plyr_[_pID].aff,                    //5
738             plyrRnds_[_pID].eth           //6
739         );
740     }
741 
742 //==============================================================================
743 //     _ _  _ _   | _  _ . _  .
744 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
745 //=====================_|=======================================================
746     /**
747      * @dev logic runs whenever a buy order is executed.  determines how to handle 
748      * incoming eth depending on if we are in an active round or not
749      */
750     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
751         private
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
762         // if round is not active     
763         } else {
764             // check to see if end round needs to be ran
765             if (_now > round_.end && round_.ended == false) 
766             {
767                 // end the round (distributes pot) & start new round
768 			    round_.ended = true;
769                 _eventData_ = endRound(_eventData_);
770                 
771                 // build event data
772                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
773                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
774                 
775                 // fire buy and distribute event 
776                 emit RSEvents.onBuyAndDistribute
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
800     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
801         private
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
817         // if round is not active and end round needs to be ran   
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
828             emit RSEvents.onReLoadAndDistribute
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
847     function core(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
848         private
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
873             updateTimer(_keys);
874 
875             // set new leaders
876             if (round_.plyr != _pID)
877                 round_.plyr = _pID;  
878             
879             // set the new leader bool to true
880             _eventData_.compressedData = _eventData_.compressedData + 100;
881         }
882             
883             // manage airdrops
884             if (_eth >= 100000000000000000)
885             {
886             airDropTracker_++;
887             if (airdrop() == true)
888             {
889                 // gib muni
890                 uint256 _prize;
891                 if (_eth >= 10000000000000000000)
892                 {
893                     // calculate prize and give it to winner
894                     _prize = ((airDropPot_).mul(75)) / 100;
895                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
896                     
897                     // adjust airDropPot 
898                     airDropPot_ = (airDropPot_).sub(_prize);
899                     
900                     // let event know a tier 3 prize was won 
901                     _eventData_.compressedData += 300000000000000000000000000000000;
902                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
903                     // calculate prize and give it to winner
904                     _prize = ((airDropPot_).mul(50)) / 100;
905                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
906                     
907                     // adjust airDropPot 
908                     airDropPot_ = (airDropPot_).sub(_prize);
909                     
910                     // let event know a tier 2 prize was won 
911                     _eventData_.compressedData += 200000000000000000000000000000000;
912                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
913                     // calculate prize and give it to winner
914                     _prize = ((airDropPot_).mul(25)) / 100;
915                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
916                     
917                     // adjust airDropPot 
918                     airDropPot_ = (airDropPot_).sub(_prize);
919                     
920                     // let event know a tier 1 prize was won 
921                     _eventData_.compressedData += 100000000000000000000000000000000;
922                 }
923                 // set airdrop happened bool to true
924                 _eventData_.compressedData += 10000000000000000000000000000000;
925                 // let event know how much was won 
926                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
927                 
928                 // reset air drop tracker
929                 airDropTracker_ = 0;
930             }
931         }
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
949 		    endTx(_pID, _eth, _keys, _eventData_);
950         }
951     }
952 //==============================================================================
953 //     _ _ | _   | _ _|_ _  _ _  .
954 //    (_(_||(_|_||(_| | (_)| _\  .
955 //==============================================================================
956     /**
957      * @dev calculates unmasked earnings (just calculates, does not update mask)
958      * @return earnings in wei format
959      */
960     function calcUnMaskedEarnings(uint256 _pID)
961         private
962         view
963         returns(uint256)
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
975         public
976         view
977         returns(uint256)
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
996         public
997         view
998         returns(uint256)
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
1009 //==============================================================================
1010 //    _|_ _  _ | _  .
1011 //     | (_)(_)|_\  .
1012 //==============================================================================
1013     /**
1014 	 * @dev receives name/player info from names contract 
1015      */
1016     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1017         external
1018     {
1019         require (msg.sender == address(RatBook), "only RatBook can call this function");
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
1038         external
1039     {
1040         require (msg.sender == address(RatBook), "only RatBook can call this function");
1041         if(plyrNames_[_pID][_name] == false)
1042             plyrNames_[_pID][_name] = true;
1043     }   
1044         
1045     /**
1046      * @dev gets existing or registers new pID.  use this when a player may be new
1047      * @return pID 
1048      */
1049     function determinePID(RSdatasets.EventReturns memory _eventData_)
1050         private
1051         returns (RSdatasets.EventReturns)
1052     {
1053         uint256 _pID = pIDxAddr_[msg.sender];
1054         // if player is new to this version of ratscam
1055         if (_pID == 0)
1056         {
1057             // grab their player ID, name and last aff ID, from player names contract 
1058             _pID = RatBook.getPlayerID(msg.sender);
1059             bytes32 _name = RatBook.getPlayerName(_pID);
1060             uint256 _laff = RatBook.getPlayerLAff(_pID);
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
1086     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1087         private
1088         returns (RSdatasets.EventReturns)
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
1099     function endRound(RSdatasets.EventReturns memory _eventData_)
1100         private
1101         returns (RSdatasets.EventReturns)
1102     {        
1103         // grab our winning player and team id's
1104         uint256 _winPID = round_.plyr;
1105         
1106         // grab our pot amount
1107         // add airdrop pot into the final pot
1108         uint256 _pot = round_.pot + airDropPot_;
1109         
1110         // calculate our winner share, community rewards, gen share, 
1111         // p3d share, and amount reserved for next pot 
1112         uint256 _win = (_pot.mul(45)) / 100;
1113         uint256 _com = (_pot / 10);
1114         uint256 _gen = (_pot.mul(potSplit_)) / 100;
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
1129         if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1130         {
1131             _gen = _gen.add(_com);
1132             _com = 0;
1133         }
1134         
1135         // distribute gen portion to key holders
1136         round_.mask = _ppt.add(round_.mask);
1137             
1138         // prepare event data
1139         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1140         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1141         _eventData_.winnerAddr = plyr_[_winPID].addr;
1142         _eventData_.winnerName = plyr_[_winPID].name;
1143         _eventData_.amountWon = _win;
1144         _eventData_.genAmount = _gen;
1145         _eventData_.newPot = 0;
1146         
1147         return(_eventData_);
1148     }
1149     
1150     /**
1151      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1152      */
1153     function updateGenVault(uint256 _pID)
1154         private 
1155     {
1156         uint256 _earnings = calcUnMaskedEarnings(_pID);
1157         if (_earnings > 0)
1158         {
1159             // put in gen vault
1160             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1161             // zero out their earnings by updating mask
1162             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1163         }
1164     }
1165     
1166     /**
1167      * @dev updates round timer based on number of whole keys bought.
1168      */
1169     function updateTimer(uint256 _keys)
1170         private
1171     {
1172         // grab time
1173         uint256 _now = now;
1174         
1175         // calculate time based on number of keys bought
1176         uint256 _newTime;
1177         if (_now > round_.end && round_.plyr == 0)
1178             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1179         else
1180             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1181         
1182         // compare to max and set new end time
1183         if (_newTime < (rndMax_).add(_now))
1184             round_.end = _newTime;
1185         else
1186             round_.end = rndMax_.add(_now);
1187     }
1188     
1189     /**
1190      * @dev generates a random number between 0-99 and checks to see if thats
1191      * resulted in an airdrop win
1192      * @return do we have a winner?
1193      */
1194     function airdrop()
1195         private 
1196         view 
1197         returns(bool)
1198     {
1199         uint256 seed = uint256(keccak256(abi.encodePacked(
1200             
1201             (block.timestamp).add
1202             (block.difficulty).add
1203             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1204             (block.gaslimit).add
1205             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1206             (block.number)
1207             
1208         )));
1209         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1210             return(true);
1211         else
1212             return(false);
1213     }
1214 
1215     /**
1216      * @dev distributes eth based on fees to com, aff, and p3d
1217      */
1218     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1219         private
1220         returns(RSdatasets.EventReturns)
1221     {
1222         // pay 5% out to community rewards
1223         uint256 _com = _eth * 5 / 100;
1224                 
1225         // distribute share to affiliate
1226         uint256 _aff = _eth / 10;
1227         
1228         // decide what to do with affiliate share of fees
1229         // affiliate must not be self, and must have a name registered
1230         if (_affID != _pID && plyr_[_affID].name != '') {
1231             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1232             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1233         } else {
1234             // no affiliates, add to your vault 
1235             plyr_[_pID].aff = _aff.add(plyr_[_pID].aff);
1236         }
1237 
1238         if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1239         {
1240             // This ensures Team Just cannot influence the outcome of FoMo3D with
1241             // bank migrations by breaking outgoing transactions.
1242             // Something we would never do. But that's not the point.
1243             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1244             // highest belief that everything we create should be trustless.
1245             // Team JUST, The name you shouldn't have to trust.
1246         }
1247 
1248         return(_eventData_);
1249     }
1250     
1251     /**
1252      * @dev distributes eth based on fees to gen and pot
1253      */
1254     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1255         private
1256         returns(RSdatasets.EventReturns)
1257     {
1258         // calculate gen share
1259         uint256 _gen = (_eth.mul(fees_)) / 100;
1260         
1261         // toss 5% into airdrop pot 
1262         uint256 _air = (_eth / 20);
1263         airDropPot_ = airDropPot_.add(_air);
1264                 
1265         // calculate pot (20%) 
1266         uint256 _pot = (_eth.mul(20) / 100);
1267         
1268         // distribute gen share (thats what updateMasks() does) and adjust
1269         // balances for dust.
1270         uint256 _dust = updateMasks(_pID, _gen, _keys);
1271         if (_dust > 0)
1272             _gen = _gen.sub(_dust);
1273         
1274         // add eth to pot
1275         round_.pot = _pot.add(_dust).add(round_.pot);
1276         
1277         // set up event data
1278         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1279         _eventData_.potAmount = _pot;
1280         
1281         return(_eventData_);
1282     }
1283 
1284     /**
1285      * @dev updates masks for round and player when keys are bought
1286      * @return dust left over 
1287      */
1288     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1289         private
1290         returns(uint256)
1291     {
1292         /* MASKING NOTES
1293             earnings masks are a tricky thing for people to wrap their minds around.
1294             the basic thing to understand here.  is were going to have a global
1295             tracker based on profit per share for each round, that increases in
1296             relevant proportion to the increase in share supply.
1297             
1298             the player will have an additional mask that basically says "based
1299             on the rounds mask, my shares, and how much i've already withdrawn,
1300             how much is still owed to me?"
1301         */
1302         
1303         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1304         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1305         round_.mask = _ppt.add(round_.mask);
1306             
1307         // calculate player earning from their own buy (only based on the keys
1308         // they just bought).  & update player earnings mask
1309         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1310         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1311         
1312         // calculate & return dust
1313         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1314     }
1315     
1316     /**
1317      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1318      * @return earnings in wei format
1319      */
1320     function withdrawEarnings(uint256 _pID)
1321         private
1322         returns(uint256)
1323     {
1324         // update gen vault
1325         updateGenVault(_pID);
1326         
1327         // from vaults 
1328         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1329         if (_earnings > 0)
1330         {
1331             plyr_[_pID].win = 0;
1332             plyr_[_pID].gen = 0;
1333             plyr_[_pID].aff = 0;
1334         }
1335 
1336         return(_earnings);
1337     }
1338     
1339     /**
1340      * @dev prepares compression data and fires event for buy or reload tx's
1341      */
1342     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1343         private
1344     {
1345         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1346         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1347         
1348         emit RSEvents.onEndTx
1349         (
1350             _eventData_.compressedData,
1351             _eventData_.compressedIDs,
1352             plyr_[_pID].name,
1353             msg.sender,
1354             _eth,
1355             _keys,
1356             _eventData_.winnerAddr,
1357             _eventData_.winnerName,
1358             _eventData_.amountWon,
1359             _eventData_.newPot,
1360             _eventData_.genAmount,
1361             _eventData_.potAmount,
1362             airDropPot_
1363         );
1364     }
1365 
1366     /** upon contract deploy, it will be deactivated.  this is a one time
1367      * use function that will activate the contract.  we do this so devs 
1368      * have time to set things up on the web end                            **/
1369     bool public activated_ = false;
1370     function activate()
1371         public
1372     {
1373         // only owner can activate 
1374         // TODO: set owner
1375         require(
1376             (msg.sender == 0x20C945800de43394F70D789874a4daC9cFA57451 || msg.sender == 0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285),
1377             "only owner can activate"
1378         );
1379         
1380         // can only be ran once
1381         require(activated_ == false, "ratscam already activated");
1382         
1383         // activate the contract 
1384         activated_ = true;
1385         
1386         round_.strt = now - rndGap_;
1387         round_.end = now + rndInit_;
1388     }
1389 }
1390 
1391 //==============================================================================
1392 //   __|_ _    __|_ _  .
1393 //  _\ | | |_|(_ | _\  .
1394 //==============================================================================
1395 library RSdatasets {
1396     //compressedData key
1397     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1398         // 0 - new player (bool)
1399         // 1 - joined round (bool)
1400         // 2 - new  leader (bool)
1401         // 3-5 - air drop tracker (uint 0-999)
1402         // 6-16 - round end time
1403         // 17 - winnerTeam
1404         // 18 - 28 timestamp 
1405         // 29 - team
1406         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1407         // 31 - airdrop happened bool
1408         // 32 - airdrop tier 
1409         // 33 - airdrop amount won
1410     //compressedIDs key
1411     // [77-52][51-26][25-0]
1412         // 0-25 - pID 
1413         // 26-51 - winPID
1414         // 52-77 - rID
1415     struct EventReturns {
1416         uint256 compressedData;
1417         uint256 compressedIDs;
1418         address winnerAddr;         // winner address
1419         bytes32 winnerName;         // winner name
1420         uint256 amountWon;          // amount won
1421         uint256 newPot;             // amount in new pot
1422         uint256 genAmount;          // amount distributed to gen
1423         uint256 potAmount;          // amount added to pot
1424     }
1425     struct Player {
1426         address addr;   // player address
1427         bytes32 name;   // player name
1428         uint256 win;    // winnings vault
1429         uint256 gen;    // general vault
1430         uint256 aff;    // affiliate vault
1431         uint256 laff;   // last affiliate id used
1432     }
1433     struct PlayerRounds {
1434         uint256 eth;    // eth player has added to round (used for eth limiter)
1435         uint256 keys;   // keys
1436         uint256 mask;   // player mask 
1437     }
1438     struct Round {
1439         uint256 plyr;   // pID of player in lead
1440         uint256 end;    // time ends/ended
1441         bool ended;     // has round end function been ran
1442         uint256 strt;   // time round started
1443         uint256 keys;   // keys
1444         uint256 eth;    // total eth in
1445         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1446         uint256 mask;   // global mask
1447     }
1448 }
1449 
1450 //==============================================================================
1451 //  |  _      _ _ | _  .
1452 //  |<(/_\/  (_(_||(_  .
1453 //=======/======================================================================
1454 library RSKeysCalc {
1455     using SafeMath for *;
1456     /**
1457      * @dev calculates number of keys received given X eth 
1458      * @param _curEth current amount of eth in contract 
1459      * @param _newEth eth being spent
1460      * @return amount of ticket purchased
1461      */
1462     function keysRec(uint256 _curEth, uint256 _newEth)
1463         internal
1464         pure
1465         returns (uint256)
1466     {
1467         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1468     }
1469     
1470     /**
1471      * @dev calculates amount of eth received if you sold X keys 
1472      * @param _curKeys current amount of keys that exist 
1473      * @param _sellKeys amount of keys you wish to sell
1474      * @return amount of eth received
1475      */
1476     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1477         internal
1478         pure
1479         returns (uint256)
1480     {
1481         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1482     }
1483 
1484     /**
1485      * @dev calculates how many keys would exist with given an amount of eth
1486      * @param _eth eth "in contract"
1487      * @return number of keys that would exist
1488      */
1489     function keys(uint256 _eth) 
1490         internal
1491         pure
1492         returns(uint256)
1493     {
1494         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1495     }
1496     
1497     /**
1498      * @dev calculates how much eth would be in contract given a number of keys
1499      * @param _keys number of keys "in contract" 
1500      * @return eth that would exists
1501      */
1502     function eth(uint256 _keys) 
1503         internal
1504         pure
1505         returns(uint256)  
1506     {
1507         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1508     }
1509 }
1510 
1511 interface RatInterfaceForForwarder {
1512     function deposit() external payable returns(bool);
1513 }
1514 
1515 interface RatBookInterface {
1516     function getPlayerID(address _addr) external returns (uint256);
1517     function getPlayerName(uint256 _pID) external view returns (bytes32);
1518     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1519     function getPlayerAddr(uint256 _pID) external view returns (address);
1520     function getNameFee() external view returns (uint256);
1521     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1522     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1523     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1524 }
1525 
1526 library NameFilter {
1527     /**
1528      * @dev filters name strings
1529      * -converts uppercase to lower case.  
1530      * -makes sure it does not start/end with a space
1531      * -makes sure it does not contain multiple spaces in a row
1532      * -cannot be only numbers
1533      * -cannot start with 0x 
1534      * -restricts characters to A-Z, a-z, 0-9, and space.
1535      * @return reprocessed string in bytes32 format
1536      */
1537     function nameFilter(string _input)
1538         internal
1539         pure
1540         returns(bytes32)
1541     {
1542         bytes memory _temp = bytes(_input);
1543         uint256 _length = _temp.length;
1544         
1545         //sorry limited to 32 characters
1546         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1547         // make sure it doesnt start with or end with space
1548         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1549         // make sure first two characters are not 0x
1550         if (_temp[0] == 0x30)
1551         {
1552             require(_temp[1] != 0x78, "string cannot start with 0x");
1553             require(_temp[1] != 0x58, "string cannot start with 0X");
1554         }
1555         
1556         // create a bool to track if we have a non number character
1557         bool _hasNonNumber;
1558         
1559         // convert & check
1560         for (uint256 i = 0; i < _length; i++)
1561         {
1562             // if its uppercase A-Z
1563             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1564             {
1565                 // convert to lower case a-z
1566                 _temp[i] = byte(uint(_temp[i]) + 32);
1567                 
1568                 // we have a non number
1569                 if (_hasNonNumber == false)
1570                     _hasNonNumber = true;
1571             } else {
1572                 require
1573                 (
1574                     // require character is a space
1575                     _temp[i] == 0x20 || 
1576                     // OR lowercase a-z
1577                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1578                     // or 0-9
1579                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1580                     "string contains invalid characters"
1581                 );
1582                 // make sure theres not 2x spaces in a row
1583                 if (_temp[i] == 0x20)
1584                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1585                 
1586                 // see if we have a character other than a number
1587                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1588                     _hasNonNumber = true;    
1589             }
1590         }
1591         
1592         require(_hasNonNumber == true, "string cannot be only numbers");
1593         
1594         bytes32 _ret;
1595         assembly {
1596             _ret := mload(add(_temp, 32))
1597         }
1598         return (_ret);
1599     }
1600 }
1601 
1602 /**
1603  * @title SafeMath v0.1.9
1604  * @dev Math operations with safety checks that throw on error
1605  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1606  * - added sqrt
1607  * - added sq
1608  * - changed asserts to requires with error log outputs
1609  * - removed div, its useless
1610  */
1611 library SafeMath {
1612     
1613     /**
1614     * @dev Multiplies two numbers, throws on overflow.
1615     */
1616     function mul(uint256 a, uint256 b) 
1617         internal 
1618         pure 
1619         returns (uint256 c) 
1620     {
1621         if (a == 0) {
1622             return 0;
1623         }
1624         c = a * b;
1625         require(c / a == b, "SafeMath mul failed");
1626         return c;
1627     }
1628 
1629     /**
1630     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1631     */
1632     function sub(uint256 a, uint256 b)
1633         internal
1634         pure
1635         returns (uint256) 
1636     {
1637         require(b <= a, "SafeMath sub failed");
1638         return a - b;
1639     }
1640 
1641     /**
1642     * @dev Adds two numbers, throws on overflow.
1643     */
1644     function add(uint256 a, uint256 b)
1645         internal
1646         pure
1647         returns (uint256 c) 
1648     {
1649         c = a + b;
1650         require(c >= a, "SafeMath add failed");
1651         return c;
1652     }
1653 
1654     /**
1655      * @dev gives square root of given x.
1656      */
1657     function sqrt(uint256 x)
1658         internal
1659         pure
1660         returns (uint256 y) 
1661     {
1662         uint256 z = ((add(x,1)) / 2);
1663         y = x;
1664         while (z < y) 
1665         {
1666             y = z;
1667             z = ((add((x / z),z)) / 2);
1668         }
1669     }
1670 
1671     /**
1672      * @dev gives square. multiplies x by x
1673      */
1674     function sq(uint256 x)
1675         internal
1676         pure
1677         returns (uint256)
1678     {
1679         return (mul(x,x));
1680     }
1681 }