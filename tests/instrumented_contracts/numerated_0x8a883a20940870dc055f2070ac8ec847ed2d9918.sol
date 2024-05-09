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
113     RatInterfaceForForwarder constant private RatKingCorp = RatInterfaceForForwarder(0x5edbe4c6275be3b42a02fd77674d0a6e490e9aa0);
114 	RatBookInterface constant private RatBook = RatBookInterface(0x89348bf4fb32c4cea21e4158b2d92ed9ee03cf79);
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
172         address _addr = msg.sender;
173         uint256 _codeLength;
174         
175         assembly {_codeLength := extcodesize(_addr)}
176         require(_codeLength == 0, "non smart contract address only");
177         _;
178     }
179 
180     /**
181      * @dev sets boundaries for incoming tx 
182      */
183     modifier isWithinLimits(uint256 _eth) {
184         require(_eth >= 1000000000, "too little money");
185         require(_eth <= 100000000000000000000000, "too much money");
186         _;    
187     }
188     
189 //==============================================================================
190 //     _    |_ |. _   |`    _  __|_. _  _  _  .
191 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
192 //====|=========================================================================
193     /**
194      * @dev emergency buy uses last stored affiliate ID and team snek
195      */
196     function()
197         isActivated()
198         isHuman()
199         isWithinLimits(msg.value)
200         public
201         payable
202     {
203         // set up our tx event data and determine if player is new or not
204         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
205             
206         // fetch player id
207         uint256 _pID = pIDxAddr_[msg.sender];
208         
209         // buy core 
210         buyCore(_pID, plyr_[_pID].laff, _eventData_);
211     }
212     
213     /**
214      * @dev converts all incoming ethereum to keys.
215      * -functionhash- 0x8f38f309 (using ID for affiliate)
216      * -functionhash- 0x98a0871d (using address for affiliate)
217      * -functionhash- 0xa65b37a1 (using name for affiliate)
218      * @param _affCode the ID/address/name of the player who gets the affiliate fee
219      */
220     function buyXid(uint256 _affCode)
221         isActivated()
222         isHuman()
223         isWithinLimits(msg.value)
224         public
225         payable
226     {
227         // set up our tx event data and determine if player is new or not
228         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
229         
230         // fetch player id
231         uint256 _pID = pIDxAddr_[msg.sender];
232         
233         // manage affiliate residuals
234         // if no affiliate code was given or player tried to use their own, lolz
235         if (_affCode == 0 || _affCode == _pID)
236         {
237             // use last stored affiliate code 
238             _affCode = plyr_[_pID].laff;
239             
240         // if affiliate code was given & its not the same as previously stored 
241         } else if (_affCode != plyr_[_pID].laff) {
242             // update last affiliate 
243             plyr_[_pID].laff = _affCode;
244         }
245                 
246         // buy core 
247         buyCore(_pID, _affCode, _eventData_);
248     }
249     
250     function buyXaddr(address _affCode)
251         isActivated()
252         isHuman()
253         isWithinLimits(msg.value)
254         public
255         payable
256     {
257         // set up our tx event data and determine if player is new or not
258         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
259         
260         // fetch player id
261         uint256 _pID = pIDxAddr_[msg.sender];
262         
263         // manage affiliate residuals
264         uint256 _affID;
265         // if no affiliate code was given or player tried to use their own, lolz
266         if (_affCode == address(0) || _affCode == msg.sender)
267         {
268             // use last stored affiliate code
269             _affID = plyr_[_pID].laff;
270         
271         // if affiliate code was given    
272         } else {
273             // get affiliate ID from aff Code 
274             _affID = pIDxAddr_[_affCode];
275             
276             // if affID is not the same as previously stored 
277             if (_affID != plyr_[_pID].laff)
278             {
279                 // update last affiliate
280                 plyr_[_pID].laff = _affID;
281             }
282         }
283         
284         // buy core 
285         buyCore(_pID, _affID, _eventData_);
286     }
287     
288     function buyXname(bytes32 _affCode)
289         isActivated()
290         isHuman()
291         isWithinLimits(msg.value)
292         public
293         payable
294     {
295         // set up our tx event data and determine if player is new or not
296         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
297         
298         // fetch player id
299         uint256 _pID = pIDxAddr_[msg.sender];
300         
301         // manage affiliate residuals
302         uint256 _affID;
303         // if no affiliate code was given or player tried to use their own, lolz
304         if (_affCode == '' || _affCode == plyr_[_pID].name)
305         {
306             // use last stored affiliate code
307             _affID = plyr_[_pID].laff;
308         
309         // if affiliate code was given
310         } else {
311             // get affiliate ID from aff Code
312             _affID = pIDxName_[_affCode];
313             
314             // if affID is not the same as previously stored
315             if (_affID != plyr_[_pID].laff)
316             {
317                 // update last affiliate
318                 plyr_[_pID].laff = _affID;
319             }
320         }
321         
322         // buy core 
323         buyCore(_pID, _affID, _eventData_);
324     }
325     
326     /**
327      * @dev essentially the same as buy, but instead of you sending ether 
328      * from your wallet, it uses your unwithdrawn earnings.
329      * -functionhash- 0x349cdcac (using ID for affiliate)
330      * -functionhash- 0x82bfc739 (using address for affiliate)
331      * -functionhash- 0x079ce327 (using name for affiliate)
332      * @param _affCode the ID/address/name of the player who gets the affiliate fee
333      * @param _eth amount of earnings to use (remainder returned to gen vault)
334      */
335     function reLoadXid(uint256 _affCode, uint256 _eth)
336         isActivated()
337         isHuman()
338         isWithinLimits(_eth)
339         public
340     {
341         // set up our tx event data
342         RSdatasets.EventReturns memory _eventData_;
343         
344         // fetch player ID
345         uint256 _pID = pIDxAddr_[msg.sender];
346         
347         // manage affiliate residuals
348         // if no affiliate code was given or player tried to use their own, lolz
349         if (_affCode == 0 || _affCode == _pID)
350         {
351             // use last stored affiliate code 
352             _affCode = plyr_[_pID].laff;
353             
354         // if affiliate code was given & its not the same as previously stored 
355         } else if (_affCode != plyr_[_pID].laff) {
356             // update last affiliate 
357             plyr_[_pID].laff = _affCode;
358         }
359 
360         // reload core
361         reLoadCore(_pID, _affCode, _eth, _eventData_);
362     }
363     
364     function reLoadXaddr(address _affCode, uint256 _eth)
365         isActivated()
366         isHuman()
367         isWithinLimits(_eth)
368         public
369     {
370         // set up our tx event data
371         RSdatasets.EventReturns memory _eventData_;
372         
373         // fetch player ID
374         uint256 _pID = pIDxAddr_[msg.sender];
375         
376         // manage affiliate residuals
377         uint256 _affID;
378         // if no affiliate code was given or player tried to use their own, lolz
379         if (_affCode == address(0) || _affCode == msg.sender)
380         {
381             // use last stored affiliate code
382             _affID = plyr_[_pID].laff;
383         
384         // if affiliate code was given    
385         } else {
386             // get affiliate ID from aff Code 
387             _affID = pIDxAddr_[_affCode];
388             
389             // if affID is not the same as previously stored 
390             if (_affID != plyr_[_pID].laff)
391             {
392                 // update last affiliate
393                 plyr_[_pID].laff = _affID;
394             }
395         }
396                 
397         // reload core
398         reLoadCore(_pID, _affID, _eth, _eventData_);
399     }
400     
401     function reLoadXname(bytes32 _affCode, uint256 _eth)
402         isActivated()
403         isHuman()
404         isWithinLimits(_eth)
405         public
406     {
407         // set up our tx event data
408         RSdatasets.EventReturns memory _eventData_;
409         
410         // fetch player ID
411         uint256 _pID = pIDxAddr_[msg.sender];
412         
413         // manage affiliate residuals
414         uint256 _affID;
415         // if no affiliate code was given or player tried to use their own, lolz
416         if (_affCode == '' || _affCode == plyr_[_pID].name)
417         {
418             // use last stored affiliate code
419             _affID = plyr_[_pID].laff;
420         
421         // if affiliate code was given
422         } else {
423             // get affiliate ID from aff Code
424             _affID = pIDxName_[_affCode];
425             
426             // if affID is not the same as previously stored
427             if (_affID != plyr_[_pID].laff)
428             {
429                 // update last affiliate
430                 plyr_[_pID].laff = _affID;
431             }
432         }
433                 
434         // reload core
435         reLoadCore(_pID, _affID, _eth, _eventData_);
436     }
437 
438     /**
439      * @dev withdraws all of your earnings.
440      * -functionhash- 0x3ccfd60b
441      */
442     function withdraw()
443         isActivated()
444         isHuman()
445         public
446     {        
447         // grab time
448         uint256 _now = now;
449         
450         // fetch player ID
451         uint256 _pID = pIDxAddr_[msg.sender];
452         
453         // setup temp var for player eth
454         uint256 _eth;
455         
456         // check to see if round has ended and no one has run round end yet
457         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
458         {
459             // set up our tx event data
460             RSdatasets.EventReturns memory _eventData_;
461             
462             // end the round (distributes pot)
463 			round_.ended = true;
464             _eventData_ = endRound(_eventData_);
465             
466 			// get their earnings
467             _eth = withdrawEarnings(_pID);
468             
469             // gib moni
470             if (_eth > 0)
471                 plyr_[_pID].addr.transfer(_eth);    
472             
473             // build event data
474             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
475             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
476             
477             // fire withdraw and distribute event
478             emit RSEvents.onWithdrawAndDistribute
479             (
480                 msg.sender, 
481                 plyr_[_pID].name, 
482                 _eth, 
483                 _eventData_.compressedData, 
484                 _eventData_.compressedIDs, 
485                 _eventData_.winnerAddr, 
486                 _eventData_.winnerName, 
487                 _eventData_.amountWon, 
488                 _eventData_.newPot, 
489                 _eventData_.genAmount
490             );
491             
492         // in any other situation
493         } else {
494             // get their earnings
495             _eth = withdrawEarnings(_pID);
496             
497             // gib moni
498             if (_eth > 0)
499                 plyr_[_pID].addr.transfer(_eth);
500             
501             // fire withdraw event
502             emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
503         }
504     }
505     
506     /**
507      * @dev use these to register names.  they are just wrappers that will send the
508      * registration requests to the PlayerBook contract.  So registering here is the 
509      * same as registering there.  UI will always display the last name you registered.
510      * but you will still own all previously registered names to use as affiliate 
511      * links.
512      * - must pay a registration fee.
513      * - name must be unique
514      * - names will be converted to lowercase
515      * - name cannot start or end with a space 
516      * - cannot have more than 1 space in a row
517      * - cannot be only numbers
518      * - cannot start with 0x 
519      * - name must be at least 1 char
520      * - max length of 32 characters long
521      * - allowed characters: a-z, 0-9, and space
522      * -functionhash- 0x921dec21 (using ID for affiliate)
523      * -functionhash- 0x3ddd4698 (using address for affiliate)
524      * -functionhash- 0x685ffd83 (using name for affiliate)
525      * @param _nameString players desired name
526      * @param _affCode affiliate ID, address, or name of who referred you
527      * @param _all set to true if you want this to push your info to all games 
528      * (this might cost a lot of gas)
529      */
530     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
531         isHuman()
532         public
533         payable
534     {
535         bytes32 _name = _nameString.nameFilter();
536         address _addr = msg.sender;
537         uint256 _paid = msg.value;
538         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
539 
540         uint256 _pID = pIDxAddr_[_addr];
541         
542         // fire event
543         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
544     }
545     
546     function registerNameXaddr(string _nameString, address _affCode, bool _all)
547         isHuman()
548         public
549         payable
550     {
551         bytes32 _name = _nameString.nameFilter();
552         address _addr = msg.sender;
553         uint256 _paid = msg.value;
554         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
555         
556         uint256 _pID = pIDxAddr_[_addr];
557         
558         // fire event
559         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
560     }
561     
562     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
563         isHuman()
564         public
565         payable
566     {
567         bytes32 _name = _nameString.nameFilter();
568         address _addr = msg.sender;
569         uint256 _paid = msg.value;
570         (bool _isNewPlayer, uint256 _affID) = RatBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
571         
572         uint256 _pID = pIDxAddr_[_addr];
573         
574         // fire event
575         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
576     }
577 //==============================================================================
578 //     _  _ _|__|_ _  _ _  .
579 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
580 //=====_|=======================================================================
581     /**
582      * @dev return the price buyer will pay for next 1 individual key.
583      * -functionhash- 0x018a25e8
584      * @return price for next key bought (in wei format)
585      */
586     function getBuyPrice()
587         public 
588         view 
589         returns(uint256)
590     {          
591         // grab time
592         uint256 _now = now;
593         
594         // are we in a round?
595         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
596             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
597         else // rounds over.  need price for new round
598             return ( 75000000000000 ); // init
599     }
600     
601     /**
602      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
603      * provider
604      * -functionhash- 0xc7e284b8
605      * @return time left in seconds
606      */
607     function getTimeLeft()
608         public
609         view
610         returns(uint256)
611     {
612         // grab time
613         uint256 _now = now;
614         
615         if (_now < round_.end)
616             if (_now > round_.strt + rndGap_)
617                 return( (round_.end).sub(_now) );
618             else
619                 return( (round_.strt + rndGap_).sub(_now));
620         else
621             return(0);
622     }
623     
624     /**
625      * @dev returns player earnings per vaults 
626      * -functionhash- 0x63066434
627      * @return winnings vault
628      * @return general vault
629      * @return affiliate vault
630      */
631     function getPlayerVaults(uint256 _pID)
632         public
633         view
634         returns(uint256 ,uint256, uint256)
635     {
636         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
637         if (now > round_.end && round_.ended == false && round_.plyr != 0)
638         {
639             // if player is winner 
640             if (round_.plyr == _pID)
641             {
642                 return
643                 (
644                     (plyr_[_pID].win).add( ((round_.pot).mul(48)) / 100 ),
645                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
646                     plyr_[_pID].aff
647                 );
648             // if player is not the winner
649             } else {
650                 return
651                 (
652                     plyr_[_pID].win,
653                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
654                     plyr_[_pID].aff
655                 );
656             }
657             
658         // if round is still going on, or round has ended and round end has been ran
659         } else {
660             return
661             (
662                 plyr_[_pID].win,
663                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
664                 plyr_[_pID].aff
665             );
666         }
667     }
668     
669     /**
670      * solidity hates stack limits.  this lets us avoid that hate 
671      */
672     function getPlayerVaultsHelper(uint256 _pID)
673         private
674         view
675         returns(uint256)
676     {
677         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
678     }
679     
680     /**
681      * @dev returns all current round info needed for front end
682      * -functionhash- 0x747dff42
683      * @return total keys
684      * @return time ends
685      * @return time started
686      * @return current pot 
687      * @return current player ID in lead 
688      * @return current player in leads address 
689      * @return current player in leads name
690      * @return airdrop tracker # & airdrop pot
691      */
692     function getCurrentRoundInfo()
693         public
694         view
695         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
696     {
697         return
698         (
699             round_.keys,              //0
700             round_.end,               //1
701             round_.strt,              //2
702             round_.pot,               //3
703             round_.plyr,              //4
704             plyr_[round_.plyr].addr,  //5
705             plyr_[round_.plyr].name,  //6
706             airDropTracker_ + (airDropPot_ * 1000)              //7
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
728         if (_addr == address(0))
729         {
730             _addr == msg.sender;
731         }
732         uint256 _pID = pIDxAddr_[_addr];
733         
734         return
735         (
736             _pID,                               //0
737             plyr_[_pID].name,                   //1
738             plyrRnds_[_pID].keys,         //2
739             plyr_[_pID].win,                    //3
740             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
741             plyr_[_pID].aff,                    //5
742             plyrRnds_[_pID].eth           //6
743         );
744     }
745 
746 //==============================================================================
747 //     _ _  _ _   | _  _ . _  .
748 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
749 //=====================_|=======================================================
750     /**
751      * @dev logic runs whenever a buy order is executed.  determines how to handle 
752      * incoming eth depending on if we are in an active round or not
753      */
754     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
755         private
756     {
757         // grab time
758         uint256 _now = now;
759         
760         // if round is active
761         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
762         {
763             // call core 
764             core(_pID, msg.value, _affID, _eventData_);
765         
766         // if round is not active     
767         } else {
768             // check to see if end round needs to be ran
769             if (_now > round_.end && round_.ended == false) 
770             {
771                 // end the round (distributes pot) & start new round
772 			    round_.ended = true;
773                 _eventData_ = endRound(_eventData_);
774                 
775                 // build event data
776                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
777                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
778                 
779                 // fire buy and distribute event 
780                 emit RSEvents.onBuyAndDistribute
781                 (
782                     msg.sender, 
783                     plyr_[_pID].name, 
784                     msg.value, 
785                     _eventData_.compressedData, 
786                     _eventData_.compressedIDs, 
787                     _eventData_.winnerAddr, 
788                     _eventData_.winnerName, 
789                     _eventData_.amountWon, 
790                     _eventData_.newPot, 
791                     _eventData_.genAmount
792                 );
793             }
794             
795             // put eth in players vault 
796             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
797         }
798     }
799     
800     /**
801      * @dev logic runs whenever a reload order is executed.  determines how to handle 
802      * incoming eth depending on if we are in an active round or not 
803      */
804     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
805         private
806     {
807         // grab time
808         uint256 _now = now;
809         
810         // if round is active
811         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
812         {
813             // get earnings from all vaults and return unused to gen vault
814             // because we use a custom safemath library.  this will throw if player 
815             // tried to spend more eth than they have.
816             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
817             
818             // call core 
819             core(_pID, _eth, _affID, _eventData_);
820         
821         // if round is not active and end round needs to be ran   
822         } else if (_now > round_.end && round_.ended == false) {
823             // end the round (distributes pot) & start new round
824             round_.ended = true;
825             _eventData_ = endRound(_eventData_);
826                 
827             // build event data
828             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
829             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
830                 
831             // fire buy and distribute event 
832             emit RSEvents.onReLoadAndDistribute
833             (
834                 msg.sender, 
835                 plyr_[_pID].name, 
836                 _eventData_.compressedData, 
837                 _eventData_.compressedIDs, 
838                 _eventData_.winnerAddr, 
839                 _eventData_.winnerName, 
840                 _eventData_.amountWon, 
841                 _eventData_.newPot, 
842                 _eventData_.genAmount
843             );
844         }
845     }
846     
847     /**
848      * @dev this is the core logic for any buy/reload that happens while a round 
849      * is live.
850      */
851     function core(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
852         private
853     {
854         // if player is new to round
855         if (plyrRnds_[_pID].keys == 0)
856             _eventData_ = managePlayer(_pID, _eventData_);
857         
858         // early round eth limiter 
859         if (round_.eth < 100000000000000000000 && plyrRnds_[_pID].eth.add(_eth) > 10000000000000000000)
860         {
861             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID].eth);
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
872             uint256 _keys = (round_.eth).keysRec(_eth);
873             
874             // if they bought at least 1 whole key
875             if (_keys >= 1000000000000000000)
876             {
877             updateTimer(_keys);
878 
879             // set new leaders
880             if (round_.plyr != _pID)
881                 round_.plyr = _pID;  
882             
883             // set the new leader bool to true
884             _eventData_.compressedData = _eventData_.compressedData + 100;
885         }
886             
887             // manage airdrops
888             if (_eth >= 100000000000000000)
889             {
890             airDropTracker_++;
891             if (airdrop() == true)
892             {
893                 // gib muni
894                 uint256 _prize;
895                 if (_eth >= 10000000000000000000)
896                 {
897                     // calculate prize and give it to winner
898                     _prize = ((airDropPot_).mul(75)) / 100;
899                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
900                     
901                     // adjust airDropPot 
902                     airDropPot_ = (airDropPot_).sub(_prize);
903                     
904                     // let event know a tier 3 prize was won 
905                     _eventData_.compressedData += 300000000000000000000000000000000;
906                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
907                     // calculate prize and give it to winner
908                     _prize = ((airDropPot_).mul(50)) / 100;
909                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
910                     
911                     // adjust airDropPot 
912                     airDropPot_ = (airDropPot_).sub(_prize);
913                     
914                     // let event know a tier 2 prize was won 
915                     _eventData_.compressedData += 200000000000000000000000000000000;
916                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
917                     // calculate prize and give it to winner
918                     _prize = ((airDropPot_).mul(25)) / 100;
919                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
920                     
921                     // adjust airDropPot 
922                     airDropPot_ = (airDropPot_).sub(_prize);
923                     
924                     // let event know a tier 1 prize was won 
925                     _eventData_.compressedData += 100000000000000000000000000000000;
926                 }
927                 // set airdrop happened bool to true
928                 _eventData_.compressedData += 10000000000000000000000000000000;
929                 // let event know how much was won 
930                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
931                 
932                 // reset air drop tracker
933                 airDropTracker_ = 0;
934             }
935         }
936     
937             // store the air drop tracker number (number of buys since last airdrop)
938             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
939             
940             // update player 
941             plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
942             plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
943             
944             // update round
945             round_.keys = _keys.add(round_.keys);
946             round_.eth = _eth.add(round_.eth);
947     
948             // distribute eth
949             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
950             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
951             
952             // call end tx function to fire end tx event.
953 		    endTx(_pID, _eth, _keys, _eventData_);
954         }
955     }
956 //==============================================================================
957 //     _ _ | _   | _ _|_ _  _ _  .
958 //    (_(_||(_|_||(_| | (_)| _\  .
959 //==============================================================================
960     /**
961      * @dev calculates unmasked earnings (just calculates, does not update mask)
962      * @return earnings in wei format
963      */
964     function calcUnMaskedEarnings(uint256 _pID)
965         private
966         view
967         returns(uint256)
968     {
969         return((((round_.mask).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask));
970     }
971     
972     /** 
973      * @dev returns the amount of keys you would get given an amount of eth. 
974      * -functionhash- 0xce89c80c
975      * @param _eth amount of eth sent in 
976      * @return keys received 
977      */
978     function calcKeysReceived(uint256 _eth)
979         public
980         view
981         returns(uint256)
982     {
983         // grab time
984         uint256 _now = now;
985         
986         // are we in a round?
987         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
988             return ( (round_.eth).keysRec(_eth) );
989         else // rounds over.  need keys for new round
990             return ( (_eth).keys() );
991     }
992     
993     /** 
994      * @dev returns current eth price for X keys.  
995      * -functionhash- 0xcf808000
996      * @param _keys number of keys desired (in 18 decimal format)
997      * @return amount of eth needed to send
998      */
999     function iWantXKeys(uint256 _keys)
1000         public
1001         view
1002         returns(uint256)
1003     {
1004         // grab time
1005         uint256 _now = now;
1006         
1007         // are we in a round?
1008         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1009             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1010         else // rounds over.  need price for new round
1011             return ( (_keys).eth() );
1012     }
1013 //==============================================================================
1014 //    _|_ _  _ | _  .
1015 //     | (_)(_)|_\  .
1016 //==============================================================================
1017     /**
1018 	 * @dev receives name/player info from names contract 
1019      */
1020     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1021         external
1022     {
1023         require (msg.sender == address(RatBook), "only RatBook can call this function");
1024         if (pIDxAddr_[_addr] != _pID)
1025             pIDxAddr_[_addr] = _pID;
1026         if (pIDxName_[_name] != _pID)
1027             pIDxName_[_name] = _pID;
1028         if (plyr_[_pID].addr != _addr)
1029             plyr_[_pID].addr = _addr;
1030         if (plyr_[_pID].name != _name)
1031             plyr_[_pID].name = _name;
1032         if (plyr_[_pID].laff != _laff)
1033             plyr_[_pID].laff = _laff;
1034         if (plyrNames_[_pID][_name] == false)
1035             plyrNames_[_pID][_name] = true;
1036     }
1037     
1038     /**
1039      * @dev receives entire player name list 
1040      */
1041     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1042         external
1043     {
1044         require (msg.sender == address(RatBook), "only RatBook can call this function");
1045         if(plyrNames_[_pID][_name] == false)
1046             plyrNames_[_pID][_name] = true;
1047     }   
1048         
1049     /**
1050      * @dev gets existing or registers new pID.  use this when a player may be new
1051      * @return pID 
1052      */
1053     function determinePID(RSdatasets.EventReturns memory _eventData_)
1054         private
1055         returns (RSdatasets.EventReturns)
1056     {
1057         uint256 _pID = pIDxAddr_[msg.sender];
1058         // if player is new to this version of ratscam
1059         if (_pID == 0)
1060         {
1061             // grab their player ID, name and last aff ID, from player names contract 
1062             _pID = RatBook.getPlayerID(msg.sender);
1063             bytes32 _name = RatBook.getPlayerName(_pID);
1064             uint256 _laff = RatBook.getPlayerLAff(_pID);
1065             
1066             // set up player account 
1067             pIDxAddr_[msg.sender] = _pID;
1068             plyr_[_pID].addr = msg.sender;
1069             
1070             if (_name != "")
1071             {
1072                 pIDxName_[_name] = _pID;
1073                 plyr_[_pID].name = _name;
1074                 plyrNames_[_pID][_name] = true;
1075             }
1076             
1077             if (_laff != 0 && _laff != _pID)
1078                 plyr_[_pID].laff = _laff;
1079             
1080             // set the new player bool to true
1081             _eventData_.compressedData = _eventData_.compressedData + 1;
1082         } 
1083         return (_eventData_);
1084     }
1085 
1086     /**
1087      * @dev decides if round end needs to be run & new round started.  and if 
1088      * player unmasked earnings from previously played rounds need to be moved.
1089      */
1090     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1091         private
1092         returns (RSdatasets.EventReturns)
1093     {            
1094         // set the joined round bool to true
1095         _eventData_.compressedData = _eventData_.compressedData + 10;
1096         
1097         return(_eventData_);
1098     }
1099     
1100     /**
1101      * @dev ends the round. manages paying out winner/splitting up pot
1102      */
1103     function endRound(RSdatasets.EventReturns memory _eventData_)
1104         private
1105         returns (RSdatasets.EventReturns)
1106     {        
1107         // grab our winning player and team id's
1108         uint256 _winPID = round_.plyr;
1109         
1110         // grab our pot amount
1111         // add airdrop pot into the final pot
1112         uint256 _pot = round_.pot + airDropPot_;
1113         
1114         // calculate our winner share, community rewards, gen share, 
1115         // p3d share, and amount reserved for next pot 
1116         uint256 _win = (_pot.mul(45)) / 100;
1117         uint256 _com = (_pot / 10);
1118         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1119         
1120         // calculate ppt for round mask
1121         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1122         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1123         if (_dust > 0)
1124         {
1125             _gen = _gen.sub(_dust);
1126             _com = _com.add(_dust);
1127         }
1128         
1129         // pay our winner
1130         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1131         
1132         // community rewards
1133         if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1134         {
1135             _gen = _gen.add(_com);
1136             _com = 0;
1137         }
1138         
1139         // distribute gen portion to key holders
1140         round_.mask = _ppt.add(round_.mask);
1141             
1142         // prepare event data
1143         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1144         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1145         _eventData_.winnerAddr = plyr_[_winPID].addr;
1146         _eventData_.winnerName = plyr_[_winPID].name;
1147         _eventData_.amountWon = _win;
1148         _eventData_.genAmount = _gen;
1149         _eventData_.newPot = 0;
1150         
1151         return(_eventData_);
1152     }
1153     
1154     /**
1155      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1156      */
1157     function updateGenVault(uint256 _pID)
1158         private 
1159     {
1160         uint256 _earnings = calcUnMaskedEarnings(_pID);
1161         if (_earnings > 0)
1162         {
1163             // put in gen vault
1164             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1165             // zero out their earnings by updating mask
1166             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1167         }
1168     }
1169     
1170     /**
1171      * @dev updates round timer based on number of whole keys bought.
1172      */
1173     function updateTimer(uint256 _keys)
1174         private
1175     {
1176         // grab time
1177         uint256 _now = now;
1178         
1179         // calculate time based on number of keys bought
1180         uint256 _newTime;
1181         if (_now > round_.end && round_.plyr == 0)
1182             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1183         else
1184             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1185         
1186         // compare to max and set new end time
1187         if (_newTime < (rndMax_).add(_now))
1188             round_.end = _newTime;
1189         else
1190             round_.end = rndMax_.add(_now);
1191     }
1192     
1193     /**
1194      * @dev generates a random number between 0-99 and checks to see if thats
1195      * resulted in an airdrop win
1196      * @return do we have a winner?
1197      */
1198     function airdrop()
1199         private 
1200         view 
1201         returns(bool)
1202     {
1203         uint256 seed = uint256(keccak256(abi.encodePacked(
1204             
1205             (block.timestamp).add
1206             (block.difficulty).add
1207             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1208             (block.gaslimit).add
1209             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1210             (block.number)
1211             
1212         )));
1213         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1214             return(true);
1215         else
1216             return(false);
1217     }
1218 
1219     /**
1220      * @dev distributes eth based on fees to com, aff, and p3d
1221      */
1222     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1223         private
1224         returns(RSdatasets.EventReturns)
1225     {
1226         // pay 5% out to community rewards
1227         uint256 _com = _eth * 5 / 100;
1228                 
1229         // distribute share to affiliate
1230         uint256 _aff = _eth / 10;
1231         
1232         // decide what to do with affiliate share of fees
1233         // affiliate must not be self, and must have a name registered
1234         if (_affID != _pID && plyr_[_affID].name != '') {
1235             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1236             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1237         } else {
1238             // no affiliates, add to community
1239             _com += _aff;
1240         }
1241 
1242         if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1243         {
1244             // This ensures Team Just cannot influence the outcome of FoMo3D with
1245             // bank migrations by breaking outgoing transactions.
1246             // Something we would never do. But that's not the point.
1247             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1248             // highest belief that everything we create should be trustless.
1249             // Team JUST, The name you shouldn't have to trust.
1250         }
1251 
1252         return(_eventData_);
1253     }
1254     
1255     /**
1256      * @dev distributes eth based on fees to gen and pot
1257      */
1258     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1259         private
1260         returns(RSdatasets.EventReturns)
1261     {
1262         // calculate gen share
1263         uint256 _gen = (_eth.mul(fees_)) / 100;
1264         
1265         // toss 5% into airdrop pot 
1266         uint256 _air = (_eth / 20);
1267         airDropPot_ = airDropPot_.add(_air);
1268                 
1269         // calculate pot (20%) 
1270         uint256 _pot = (_eth.mul(20) / 100);
1271         
1272         // distribute gen share (thats what updateMasks() does) and adjust
1273         // balances for dust.
1274         uint256 _dust = updateMasks(_pID, _gen, _keys);
1275         if (_dust > 0)
1276             _gen = _gen.sub(_dust);
1277         
1278         // add eth to pot
1279         round_.pot = _pot.add(_dust).add(round_.pot);
1280         
1281         // set up event data
1282         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1283         _eventData_.potAmount = _pot;
1284         
1285         return(_eventData_);
1286     }
1287 
1288     /**
1289      * @dev updates masks for round and player when keys are bought
1290      * @return dust left over 
1291      */
1292     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1293         private
1294         returns(uint256)
1295     {
1296         /* MASKING NOTES
1297             earnings masks are a tricky thing for people to wrap their minds around.
1298             the basic thing to understand here.  is were going to have a global
1299             tracker based on profit per share for each round, that increases in
1300             relevant proportion to the increase in share supply.
1301             
1302             the player will have an additional mask that basically says "based
1303             on the rounds mask, my shares, and how much i've already withdrawn,
1304             how much is still owed to me?"
1305         */
1306         
1307         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1308         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1309         round_.mask = _ppt.add(round_.mask);
1310             
1311         // calculate player earning from their own buy (only based on the keys
1312         // they just bought).  & update player earnings mask
1313         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1314         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1315         
1316         // calculate & return dust
1317         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1318     }
1319     
1320     /**
1321      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1322      * @return earnings in wei format
1323      */
1324     function withdrawEarnings(uint256 _pID)
1325         private
1326         returns(uint256)
1327     {
1328         // update gen vault
1329         updateGenVault(_pID);
1330         
1331         // from vaults 
1332         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1333         if (_earnings > 0)
1334         {
1335             plyr_[_pID].win = 0;
1336             plyr_[_pID].gen = 0;
1337             plyr_[_pID].aff = 0;
1338         }
1339 
1340         return(_earnings);
1341     }
1342     
1343     /**
1344      * @dev prepares compression data and fires event for buy or reload tx's
1345      */
1346     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1347         private
1348     {
1349         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1350         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1351         
1352         emit RSEvents.onEndTx
1353         (
1354             _eventData_.compressedData,
1355             _eventData_.compressedIDs,
1356             plyr_[_pID].name,
1357             msg.sender,
1358             _eth,
1359             _keys,
1360             _eventData_.winnerAddr,
1361             _eventData_.winnerName,
1362             _eventData_.amountWon,
1363             _eventData_.newPot,
1364             _eventData_.genAmount,
1365             _eventData_.potAmount,
1366             airDropPot_
1367         );
1368     }
1369 
1370     /** upon contract deploy, it will be deactivated.  this is a one time
1371      * use function that will activate the contract.  we do this so devs 
1372      * have time to set things up on the web end                            **/
1373     bool public activated_ = false;
1374     function activate()
1375         public
1376     {
1377         // only owner can activate 
1378         // TODO: set owner
1379         require(
1380             msg.sender == 0xc14f8469D4Bb31C8E69fae9c16E262f45edc3635,
1381             "only owner can activate"
1382         );
1383         
1384         // can only be ran once
1385         require(activated_ == false, "ratscam already activated");
1386         
1387         // activate the contract 
1388         activated_ = true;
1389         
1390         round_.strt = now - rndGap_;
1391         round_.end = now + rndInit_;
1392     }
1393 }
1394 
1395 //==============================================================================
1396 //   __|_ _    __|_ _  .
1397 //  _\ | | |_|(_ | _\  .
1398 //==============================================================================
1399 library RSdatasets {
1400     //compressedData key
1401     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1402         // 0 - new player (bool)
1403         // 1 - joined round (bool)
1404         // 2 - new  leader (bool)
1405         // 3-5 - air drop tracker (uint 0-999)
1406         // 6-16 - round end time
1407         // 17 - winnerTeam
1408         // 18 - 28 timestamp 
1409         // 29 - team
1410         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1411         // 31 - airdrop happened bool
1412         // 32 - airdrop tier 
1413         // 33 - airdrop amount won
1414     //compressedIDs key
1415     // [77-52][51-26][25-0]
1416         // 0-25 - pID 
1417         // 26-51 - winPID
1418         // 52-77 - rID
1419     struct EventReturns {
1420         uint256 compressedData;
1421         uint256 compressedIDs;
1422         address winnerAddr;         // winner address
1423         bytes32 winnerName;         // winner name
1424         uint256 amountWon;          // amount won
1425         uint256 newPot;             // amount in new pot
1426         uint256 genAmount;          // amount distributed to gen
1427         uint256 potAmount;          // amount added to pot
1428     }
1429     struct Player {
1430         address addr;   // player address
1431         bytes32 name;   // player name
1432         uint256 win;    // winnings vault
1433         uint256 gen;    // general vault
1434         uint256 aff;    // affiliate vault
1435         uint256 laff;   // last affiliate id used
1436     }
1437     struct PlayerRounds {
1438         uint256 eth;    // eth player has added to round (used for eth limiter)
1439         uint256 keys;   // keys
1440         uint256 mask;   // player mask 
1441     }
1442     struct Round {
1443         uint256 plyr;   // pID of player in lead
1444         uint256 end;    // time ends/ended
1445         bool ended;     // has round end function been ran
1446         uint256 strt;   // time round started
1447         uint256 keys;   // keys
1448         uint256 eth;    // total eth in
1449         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1450         uint256 mask;   // global mask
1451     }
1452 }
1453 
1454 //==============================================================================
1455 //  |  _      _ _ | _  .
1456 //  |<(/_\/  (_(_||(_  .
1457 //=======/======================================================================
1458 library RSKeysCalc {
1459     using SafeMath for *;
1460     /**
1461      * @dev calculates number of keys received given X eth 
1462      * @param _curEth current amount of eth in contract 
1463      * @param _newEth eth being spent
1464      * @return amount of ticket purchased
1465      */
1466     function keysRec(uint256 _curEth, uint256 _newEth)
1467         internal
1468         pure
1469         returns (uint256)
1470     {
1471         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1472     }
1473     
1474     /**
1475      * @dev calculates amount of eth received if you sold X keys 
1476      * @param _curKeys current amount of keys that exist 
1477      * @param _sellKeys amount of keys you wish to sell
1478      * @return amount of eth received
1479      */
1480     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1481         internal
1482         pure
1483         returns (uint256)
1484     {
1485         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1486     }
1487 
1488     /**
1489      * @dev calculates how many keys would exist with given an amount of eth
1490      * @param _eth eth "in contract"
1491      * @return number of keys that would exist
1492      */
1493     function keys(uint256 _eth) 
1494         internal
1495         pure
1496         returns(uint256)
1497     {
1498         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1499     }
1500     
1501     /**
1502      * @dev calculates how much eth would be in contract given a number of keys
1503      * @param _keys number of keys "in contract" 
1504      * @return eth that would exists
1505      */
1506     function eth(uint256 _keys) 
1507         internal
1508         pure
1509         returns(uint256)  
1510     {
1511         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1512     }
1513 }
1514 
1515 interface RatInterfaceForForwarder {
1516     function deposit() external payable returns(bool);
1517 }
1518 
1519 interface RatBookInterface {
1520     function getPlayerID(address _addr) external returns (uint256);
1521     function getPlayerName(uint256 _pID) external view returns (bytes32);
1522     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1523     function getPlayerAddr(uint256 _pID) external view returns (address);
1524     function getNameFee() external view returns (uint256);
1525     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1526     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1527     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1528 }
1529 
1530 library NameFilter {
1531     /**
1532      * @dev filters name strings
1533      * -converts uppercase to lower case.  
1534      * -makes sure it does not start/end with a space
1535      * -makes sure it does not contain multiple spaces in a row
1536      * -cannot be only numbers
1537      * -cannot start with 0x 
1538      * -restricts characters to A-Z, a-z, 0-9, and space.
1539      * @return reprocessed string in bytes32 format
1540      */
1541     function nameFilter(string _input)
1542         internal
1543         pure
1544         returns(bytes32)
1545     {
1546         bytes memory _temp = bytes(_input);
1547         uint256 _length = _temp.length;
1548         
1549         //sorry limited to 32 characters
1550         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1551         // make sure it doesnt start with or end with space
1552         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1553         // make sure first two characters are not 0x
1554         if (_temp[0] == 0x30)
1555         {
1556             require(_temp[1] != 0x78, "string cannot start with 0x");
1557             require(_temp[1] != 0x58, "string cannot start with 0X");
1558         }
1559         
1560         // create a bool to track if we have a non number character
1561         bool _hasNonNumber;
1562         
1563         // convert & check
1564         for (uint256 i = 0; i < _length; i++)
1565         {
1566             // if its uppercase A-Z
1567             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1568             {
1569                 // convert to lower case a-z
1570                 _temp[i] = byte(uint(_temp[i]) + 32);
1571                 
1572                 // we have a non number
1573                 if (_hasNonNumber == false)
1574                     _hasNonNumber = true;
1575             } else {
1576                 require
1577                 (
1578                     // require character is a space
1579                     _temp[i] == 0x20 || 
1580                     // OR lowercase a-z
1581                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1582                     // or 0-9
1583                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1584                     "string contains invalid characters"
1585                 );
1586                 // make sure theres not 2x spaces in a row
1587                 if (_temp[i] == 0x20)
1588                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1589                 
1590                 // see if we have a character other than a number
1591                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1592                     _hasNonNumber = true;    
1593             }
1594         }
1595         
1596         require(_hasNonNumber == true, "string cannot be only numbers");
1597         
1598         bytes32 _ret;
1599         assembly {
1600             _ret := mload(add(_temp, 32))
1601         }
1602         return (_ret);
1603     }
1604 }
1605 
1606 /**
1607  * @title SafeMath v0.1.9
1608  * @dev Math operations with safety checks that throw on error
1609  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1610  * - added sqrt
1611  * - added sq
1612  * - changed asserts to requires with error log outputs
1613  * - removed div, its useless
1614  */
1615 library SafeMath {
1616     
1617     /**
1618     * @dev Multiplies two numbers, throws on overflow.
1619     */
1620     function mul(uint256 a, uint256 b) 
1621         internal 
1622         pure 
1623         returns (uint256 c) 
1624     {
1625         if (a == 0) {
1626             return 0;
1627         }
1628         c = a * b;
1629         require(c / a == b, "SafeMath mul failed");
1630         return c;
1631     }
1632 
1633     /**
1634     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1635     */
1636     function sub(uint256 a, uint256 b)
1637         internal
1638         pure
1639         returns (uint256) 
1640     {
1641         require(b <= a, "SafeMath sub failed");
1642         return a - b;
1643     }
1644 
1645     /**
1646     * @dev Adds two numbers, throws on overflow.
1647     */
1648     function add(uint256 a, uint256 b)
1649         internal
1650         pure
1651         returns (uint256 c) 
1652     {
1653         c = a + b;
1654         require(c >= a, "SafeMath add failed");
1655         return c;
1656     }
1657 
1658     /**
1659      * @dev gives square root of given x.
1660      */
1661     function sqrt(uint256 x)
1662         internal
1663         pure
1664         returns (uint256 y) 
1665     {
1666         uint256 z = ((add(x,1)) / 2);
1667         y = x;
1668         while (z < y) 
1669         {
1670             y = z;
1671             z = ((add((x / z),z)) / 2);
1672         }
1673     }
1674 
1675     /**
1676      * @dev gives square. multiplies x by x
1677      */
1678     function sq(uint256 x)
1679         internal
1680         pure
1681         returns (uint256)
1682     {
1683         return (mul(x,x));
1684     }
1685 }