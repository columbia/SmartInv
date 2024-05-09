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
105 contract modularRatScam is RSEvents {}
106 
107 contract RatScam is modularRatScam {
108     using SafeMath for *;
109     using NameFilter for string;
110     using RSKeysCalc for uint256;
111     
112     // TODO: check address
113     RatInterfaceForForwarder constant private RatKingCorp = RatInterfaceForForwarder(0x85de5b2a5c7866044116eade6543f24702d81de1);
114     RatBookInterface constant private RatBook = RatBookInterface(0xe63d90bbf4d378eeaed5ec5f8266a2e4451ab427);
115 
116     string constant public name = "RatScam Round #1";
117     string constant public symbol = "RS1";
118     uint256 private rndGap_ = 0;
119 
120     // TODO: check time
121     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
122     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
123     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
124 //==============================================================================
125 //     _| _ _|_ _    _ _ _|_    _   .
126 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
127 //=============================|================================================
128     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
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
154     }
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
463             round_.ended = true;
464             _eventData_ = endRound(_eventData_);
465             
466             // get their earnings
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
600     /**
601      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
602      * provider
603      * -functionhash- 0xc7e284b8
604      * @return time left in seconds
605      */
606     function getTimeLeft()
607         public
608         view
609         returns(uint256)
610     {
611         // grab time
612         uint256 _now = now;
613         
614         if (_now < round_.end)
615             if (_now > round_.strt + rndGap_)
616                 return( (round_.end).sub(_now) );
617             else
618                 return( (round_.strt + rndGap_).sub(_now));
619         else
620             return(0);
621     }
622     
623     /**
624      * @dev returns player earnings per vaults 
625      * -functionhash- 0x63066434
626      * @return winnings vault
627      * @return general vault
628      * @return affiliate vault
629      */
630     function getPlayerVaults(uint256 _pID)
631         public
632         view
633         returns(uint256 ,uint256, uint256)
634     {
635         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
636         if (now > round_.end && round_.ended == false && round_.plyr != 0)
637         {
638             // if player is winner 
639             if (round_.plyr == _pID)
640             {
641                 return
642                 (
643                     (plyr_[_pID].win).add( ((round_.pot).mul(48)) / 100 ),
644                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
645                     plyr_[_pID].aff
646                 );
647             // if player is not the winner
648             } else {
649                 return
650                 (
651                     plyr_[_pID].win,
652                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
653                     plyr_[_pID].aff
654                 );
655             }
656             
657         // if round is still going on, or round has ended and round end has been ran
658         } else {
659             return
660             (
661                 plyr_[_pID].win,
662                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
663                 plyr_[_pID].aff
664             );
665         }
666     }
667     
668     /**
669      * solidity hates stack limits.  this lets us avoid that hate 
670      */
671     function getPlayerVaultsHelper(uint256 _pID)
672         private
673         view
674         returns(uint256)
675     {
676         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
677     }
678     
679     /**
680      * @dev returns all current round info needed for front end
681      * -functionhash- 0x747dff42
682      * @return total keys
683      * @return time ends
684      * @return time started
685      * @return current pot 
686      * @return current player ID in lead 
687      * @return current player in leads address 
688      * @return current player in leads name
689      * @return airdrop tracker # & airdrop pot
690      */
691     function getCurrentRoundInfo()
692         public
693         view
694         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
695     {
696         return
697         (
698             round_.keys,              //0
699             round_.end,               //1
700             round_.strt,              //2
701             round_.pot,               //3
702             round_.plyr,              //4
703             plyr_[round_.plyr].addr,  //5
704             plyr_[round_.plyr].name,  //6
705             airDropTracker_ + (airDropPot_ * 1000)              //7
706         );
707     }
708 
709     /**
710      * @dev returns player info based on address.  if no address is given, it will 
711      * use msg.sender 
712      * -functionhash- 0xee0b5d8b
713      * @param _addr address of the player you want to lookup 
714      * @return player ID 
715      * @return player name
716      * @return keys owned (current round)
717      * @return winnings vault
718      * @return general vault 
719      * @return affiliate vault 
720      * @return player round eth
721      */
722     function getPlayerInfoByAddress(address _addr)
723         public 
724         view 
725         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
726     {
727         if (_addr == address(0))
728         {
729             _addr == msg.sender;
730         }
731         uint256 _pID = pIDxAddr_[_addr];
732         
733         return
734         (
735             _pID,                               //0
736             plyr_[_pID].name,                   //1
737             plyrRnds_[_pID].keys,         //2
738             plyr_[_pID].win,                    //3
739             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
740             plyr_[_pID].aff,                    //5
741             plyrRnds_[_pID].eth           //6
742         );
743     }
744 
745 //==============================================================================
746 //     _ _  _ _   | _  _ . _  .
747 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
748 //=====================_|=======================================================
749     /**
750      * @dev logic runs whenever a buy order is executed.  determines how to handle 
751      * incoming eth depending on if we are in an active round or not
752      */
753     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
754         private
755     {
756         // grab time
757         uint256 _now = now;
758         
759         // if round is active
760         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
761         {
762             // call core 
763             core(_pID, msg.value, _affID, _eventData_);
764         
765         // if round is not active     
766         } else {
767             // check to see if end round needs to be ran
768             if (_now > round_.end && round_.ended == false) 
769             {
770                 // end the round (distributes pot) & start new round
771                 round_.ended = true;
772                 _eventData_ = endRound(_eventData_);
773                 
774                 // build event data
775                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
776                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
777                 
778                 // fire buy and distribute event 
779                 emit RSEvents.onBuyAndDistribute
780                 (
781                     msg.sender, 
782                     plyr_[_pID].name, 
783                     msg.value, 
784                     _eventData_.compressedData, 
785                     _eventData_.compressedIDs, 
786                     _eventData_.winnerAddr, 
787                     _eventData_.winnerName, 
788                     _eventData_.amountWon, 
789                     _eventData_.newPot, 
790                     _eventData_.genAmount
791                 );
792             }
793             
794             // put eth in players vault 
795             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
796         }
797     }
798     
799     /**
800      * @dev logic runs whenever a reload order is executed.  determines how to handle 
801      * incoming eth depending on if we are in an active round or not 
802      */
803     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
804         private
805     {
806         // grab time
807         uint256 _now = now;
808         
809         // if round is active
810         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
811         {
812             // get earnings from all vaults and return unused to gen vault
813             // because we use a custom safemath library.  this will throw if player 
814             // tried to spend more eth than they have.
815             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
816             
817             // call core 
818             core(_pID, _eth, _affID, _eventData_);
819         
820         // if round is not active and end round needs to be ran   
821         } else if (_now > round_.end && round_.ended == false) {
822             // end the round (distributes pot) & start new round
823             round_.ended = true;
824             _eventData_ = endRound(_eventData_);
825                 
826             // build event data
827             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
828             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
829                 
830             // fire buy and distribute event 
831             emit RSEvents.onReLoadAndDistribute
832             (
833                 msg.sender, 
834                 plyr_[_pID].name, 
835                 _eventData_.compressedData, 
836                 _eventData_.compressedIDs, 
837                 _eventData_.winnerAddr, 
838                 _eventData_.winnerName, 
839                 _eventData_.amountWon, 
840                 _eventData_.newPot, 
841                 _eventData_.genAmount
842             );
843         }
844     }
845     
846     /**
847      * @dev this is the core logic for any buy/reload that happens while a round 
848      * is live.
849      */
850     function core(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
851         private
852     {
853         // if player is new to round
854         if (plyrRnds_[_pID].keys == 0)
855             _eventData_ = managePlayer(_pID, _eventData_);
856         
857         // early round eth limiter 
858         if (round_.eth < 100000000000000000000 && plyrRnds_[_pID].eth.add(_eth) > 10000000000000000000)
859         {
860             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID].eth);
861             uint256 _refund = _eth.sub(_availableLimit);
862             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
863             _eth = _availableLimit;
864         }
865         
866         // if eth left is greater than min eth allowed (sorry no pocket lint)
867         if (_eth > 1000000000) 
868         {
869             
870             // mint the new keys
871             uint256 _keys = (round_.eth).keysRec(_eth);
872             
873             // if they bought at least 1 whole key
874             if (_keys >= 1000000000000000000)
875             {
876                 updateTimer(_keys);
877 
878                 // set new leaders
879                 if (round_.plyr != _pID)
880                     round_.plyr = _pID;  
881             
882                 // set the new leader bool to true
883                 _eventData_.compressedData = _eventData_.compressedData + 100;
884             }
885             
886             // manage airdrops
887             if (_eth >= 100000000000000000)
888             {
889                 airDropTracker_++;
890                 if (airdrop() == true)
891                 {
892                     // gib muni
893                     uint256 _prize;
894                     if (_eth >= 10000000000000000000)
895                     {
896                         // calculate prize and give it to winner
897                         _prize = ((airDropPot_).mul(75)) / 100;
898                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
899                     
900                         // adjust airDropPot 
901                         airDropPot_ = (airDropPot_).sub(_prize);
902                     
903                         // let event know a tier 3 prize was won 
904                         _eventData_.compressedData += 300000000000000000000000000000000;
905                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
906                         // calculate prize and give it to winner
907                         _prize = ((airDropPot_).mul(50)) / 100;
908                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
909                     
910                         // adjust airDropPot 
911                         airDropPot_ = (airDropPot_).sub(_prize);
912                     
913                         // let event know a tier 2 prize was won 
914                         _eventData_.compressedData += 200000000000000000000000000000000;
915                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
916                         // calculate prize and give it to winner
917                         _prize = ((airDropPot_).mul(25)) / 100;
918                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
919                     
920                         // adjust airDropPot 
921                         airDropPot_ = (airDropPot_).sub(_prize);
922                     
923                         // let event know a tier 1 prize was won 
924                         _eventData_.compressedData += 100000000000000000000000000000000;
925                     }
926                     // set airdrop happened bool to true
927                     _eventData_.compressedData += 10000000000000000000000000000000;
928                     // let event know how much was won 
929                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
930                 
931                     // reset air drop tracker
932                     airDropTracker_ = 0;
933                 }
934             }
935     
936             // store the air drop tracker number (number of buys since last airdrop)
937             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
938             
939             // update player 
940             plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
941             plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
942             
943             // update round
944             round_.keys = _keys.add(round_.keys);
945             round_.eth = _eth.add(round_.eth);
946     
947             // distribute eth
948             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
949             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
950             
951             // call end tx function to fire end tx event.
952             endTx(_pID, _eth, _keys, _eventData_);
953         }
954     }
955 //==============================================================================
956 //     _ _ | _   | _ _|_ _  _ _  .
957 //    (_(_||(_|_||(_| | (_)| _\  .
958 //==============================================================================
959     /**
960      * @dev calculates unmasked earnings (just calculates, does not update mask)
961      * @return earnings in wei format
962      */
963     function calcUnMaskedEarnings(uint256 _pID)
964         private
965         view
966         returns(uint256)
967     {
968         return((((round_.mask).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask));
969     }
970     
971     /** 
972      * @dev returns the amount of keys you would get given an amount of eth. 
973      * -functionhash- 0xce89c80c
974      * @param _eth amount of eth sent in 
975      * @return keys received 
976      */
977     function calcKeysReceived(uint256 _eth)
978         public
979         view
980         returns(uint256)
981     {
982         // grab time
983         uint256 _now = now;
984         
985         // are we in a round?
986         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
987             return ( (round_.eth).keysRec(_eth) );
988         else // rounds over.  need keys for new round
989             return ( (_eth).keys() );
990     }
991     
992     /** 
993      * @dev returns current eth price for X keys.  
994      * -functionhash- 0xcf808000
995      * @param _keys number of keys desired (in 18 decimal format)
996      * @return amount of eth needed to send
997      */
998     function iWantXKeys(uint256 _keys)
999         public
1000         view
1001         returns(uint256)
1002     {
1003         // grab time
1004         uint256 _now = now;
1005         
1006         // are we in a round?
1007         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1008             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1009         else // rounds over.  need price for new round
1010             return ( (_keys).eth() );
1011     }
1012 //==============================================================================
1013 //    _|_ _  _ | _  .
1014 //     | (_)(_)|_\  .
1015 //==============================================================================
1016     /**
1017      * @dev receives name/player info from names contract 
1018      */
1019     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1020         external
1021     {
1022         require (msg.sender == address(RatBook), "only RatBook can call this function");
1023         if (pIDxAddr_[_addr] != _pID)
1024             pIDxAddr_[_addr] = _pID;
1025         if (pIDxName_[_name] != _pID)
1026             pIDxName_[_name] = _pID;
1027         if (plyr_[_pID].addr != _addr)
1028             plyr_[_pID].addr = _addr;
1029         if (plyr_[_pID].name != _name)
1030             plyr_[_pID].name = _name;
1031         if (plyr_[_pID].laff != _laff)
1032             plyr_[_pID].laff = _laff;
1033         if (plyrNames_[_pID][_name] == false)
1034             plyrNames_[_pID][_name] = true;
1035     }
1036     
1037     /**
1038      * @dev receives entire player name list 
1039      */
1040     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1041         external
1042     {
1043         require (msg.sender == address(RatBook), "only RatBook can call this function");
1044         if(plyrNames_[_pID][_name] == false)
1045             plyrNames_[_pID][_name] = true;
1046     }   
1047         
1048     /**
1049      * @dev gets existing or registers new pID.  use this when a player may be new
1050      * @return pID 
1051      */
1052     function determinePID(RSdatasets.EventReturns memory _eventData_)
1053         private
1054         returns (RSdatasets.EventReturns)
1055     {
1056         uint256 _pID = pIDxAddr_[msg.sender];
1057         // if player is new to this version of ratscam
1058         if (_pID == 0)
1059         {
1060             // grab their player ID, name and last aff ID, from player names contract 
1061             _pID = RatBook.getPlayerID(msg.sender);
1062             bytes32 _name = RatBook.getPlayerName(_pID);
1063             uint256 _laff = RatBook.getPlayerLAff(_pID);
1064             
1065             // set up player account 
1066             pIDxAddr_[msg.sender] = _pID;
1067             plyr_[_pID].addr = msg.sender;
1068             
1069             if (_name != "")
1070             {
1071                 pIDxName_[_name] = _pID;
1072                 plyr_[_pID].name = _name;
1073                 plyrNames_[_pID][_name] = true;
1074             }
1075             
1076             if (_laff != 0 && _laff != _pID)
1077                 plyr_[_pID].laff = _laff;
1078             
1079             // set the new player bool to true
1080             _eventData_.compressedData = _eventData_.compressedData + 1;
1081         } 
1082         return (_eventData_);
1083     }
1084 
1085     /**
1086      * @dev decides if round end needs to be run & new round started.  and if 
1087      * player unmasked earnings from previously played rounds need to be moved.
1088      */
1089     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1090         private
1091         returns (RSdatasets.EventReturns)
1092     {            
1093         // set the joined round bool to true
1094         _eventData_.compressedData = _eventData_.compressedData + 10;
1095         
1096         return(_eventData_);
1097     }
1098     
1099     /**
1100      * @dev ends the round. manages paying out winner/splitting up pot
1101      */
1102     function endRound(RSdatasets.EventReturns memory _eventData_)
1103         private
1104         returns (RSdatasets.EventReturns)
1105     {        
1106         // grab our winning player and team id's
1107         uint256 _winPID = round_.plyr;
1108         
1109         // grab our pot amount
1110         // add airdrop pot into the final pot
1111         uint256 _pot = round_.pot + airDropPot_;
1112         
1113         // calculate our winner share, community rewards, gen share, 
1114         // p3d share, and amount reserved for next pot 
1115         uint256 _win = (_pot.mul(45)) / 100;
1116         uint256 _com = (_pot / 10);
1117         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1118         
1119         // calculate ppt for round mask
1120         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1121         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1122         if (_dust > 0)
1123         {
1124             _gen = _gen.sub(_dust);
1125             _com = _com.add(_dust);
1126         }
1127         
1128         // pay our winner
1129         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1130         
1131         // community rewards
1132         if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1133         {
1134             _gen = _gen.add(_com);
1135             _com = 0;
1136         }
1137         
1138         // distribute gen portion to key holders
1139         round_.mask = _ppt.add(round_.mask);
1140             
1141         // prepare event data
1142         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1143         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1144         _eventData_.winnerAddr = plyr_[_winPID].addr;
1145         _eventData_.winnerName = plyr_[_winPID].name;
1146         _eventData_.amountWon = _win;
1147         _eventData_.genAmount = _gen;
1148         _eventData_.newPot = 0;
1149         
1150         return(_eventData_);
1151     }
1152     
1153     /**
1154      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1155      */
1156     function updateGenVault(uint256 _pID)
1157         private 
1158     {
1159         uint256 _earnings = calcUnMaskedEarnings(_pID);
1160         if (_earnings > 0)
1161         {
1162             // put in gen vault
1163             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1164             // zero out their earnings by updating mask
1165             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1166         }
1167     }
1168     
1169     /**
1170      * @dev updates round timer based on number of whole keys bought.
1171      */
1172     function updateTimer(uint256 _keys)
1173         private
1174     {
1175         // grab time
1176         uint256 _now = now;
1177         
1178         // calculate time based on number of keys bought
1179         uint256 _newTime;
1180         if (_now > round_.end && round_.plyr == 0)
1181             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1182         else
1183             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1184         
1185         // compare to max and set new end time
1186         if (_newTime < (rndMax_).add(_now))
1187             round_.end = _newTime;
1188         else
1189             round_.end = rndMax_.add(_now);
1190     }
1191     
1192     /**
1193      * @dev generates a random number between 0-99 and checks to see if thats
1194      * resulted in an airdrop win
1195      * @return do we have a winner?
1196      */
1197     function airdrop()
1198         private 
1199         view 
1200         returns(bool)
1201     {
1202 //        uint256 seed = uint256(keccak256(abi.encodePacked(  
1203 
1204 //            (block.timestamp).add
1205 //            (block.difficulty).add
1206 //            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1207 //            (block.gaslimit).add
1208 //            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1209 //            (block.number)
1210             
1211 //        )));
1212 //        if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1213 //            return(true);
1214 //        else
1215             return(false);
1216     }
1217 
1218     /**
1219      * @dev distributes eth based on fees to com, aff, and p3d
1220      */
1221     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1222         private
1223         returns(RSdatasets.EventReturns)
1224     {
1225         // pay 5% out to community rewards
1226         uint256 _com = _eth * 2 / 100;//5%
1227                 
1228         // distribute share to affiliate
1229         //uint256 _aff = _eth / 10;//10%
1230         uint256 _aff = 0;
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
1263         uint256 _gen = (_eth.mul(fees_)) / 100;//60%
1264         
1265         // toss 5% into airdrop pot 
1266         //uint256 _air = (_eth / 20);//5%
1267         uint256 _air = 0;//5%
1268         airDropPot_ = airDropPot_.add(_air);
1269                 
1270         // calculate pot (20%) 
1271         uint256 _pot = (_eth.mul(38) / 100);//20%
1272         
1273         // distribute gen share (thats what updateMasks() does) and adjust
1274         // balances for dust.
1275         uint256 _dust = updateMasks(_pID, _gen, _keys);
1276         if (_dust > 0)
1277             _gen = _gen.sub(_dust);
1278         
1279         // add eth to pot
1280         round_.pot = _pot.add(_dust).add(round_.pot);
1281         
1282         // set up event data
1283         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1284         _eventData_.potAmount = _pot;
1285         
1286         return(_eventData_);
1287     }
1288 
1289     /**
1290      * @dev updates masks for round and player when keys are bought
1291      * @return dust left over 
1292      */
1293     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1294         private
1295         returns(uint256)
1296     {
1297         /* MASKING NOTES
1298             earnings masks are a tricky thing for people to wrap their minds around.
1299             the basic thing to understand here.  is were going to have a global
1300             tracker based on profit per share for each round, that increases in
1301             relevant proportion to the increase in share supply.
1302             
1303             the player will have an additional mask that basically says "based
1304             on the rounds mask, my shares, and how much i've already withdrawn,
1305             how much is still owed to me?"
1306         */
1307         
1308         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1309         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1310         round_.mask = _ppt.add(round_.mask);
1311             
1312         // calculate player earning from their own buy (only based on the keys
1313         // they just bought).  & update player earnings mask
1314         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1315         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1316         
1317         // calculate & return dust
1318         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1319     }
1320     
1321     /**
1322      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1323      * @return earnings in wei format
1324      */
1325     function withdrawEarnings(uint256 _pID)
1326         private
1327         returns(uint256)
1328     {
1329         // update gen vault
1330         updateGenVault(_pID);
1331         
1332         // from vaults 
1333         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1334         if (_earnings > 0)
1335         {
1336             plyr_[_pID].win = 0;
1337             plyr_[_pID].gen = 0;
1338             plyr_[_pID].aff = 0;
1339         }
1340 
1341         return(_earnings);
1342     }
1343     
1344     /**
1345      * @dev prepares compression data and fires event for buy or reload tx's
1346      */
1347     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1348         private
1349     {
1350         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1351         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1352         
1353         emit RSEvents.onEndTx
1354         (
1355             _eventData_.compressedData,
1356             _eventData_.compressedIDs,
1357             plyr_[_pID].name,
1358             msg.sender,
1359             _eth,
1360             _keys,
1361             _eventData_.winnerAddr,
1362             _eventData_.winnerName,
1363             _eventData_.amountWon,
1364             _eventData_.newPot,
1365             _eventData_.genAmount,
1366             _eventData_.potAmount,
1367             airDropPot_
1368         );
1369     }
1370 
1371     /** upon contract deploy, it will be deactivated.  this is a one time
1372      * use function that will activate the contract.  we do this so devs 
1373      * have time to set things up on the web end                            **/
1374     bool public activated_ = false;
1375     function activate()
1376         public
1377     {
1378         // only owner can activate 
1379         // TODO: set owner
1380         require(
1381             msg.sender == 0x4e0ee71f35cbb738877f31d240a2282d2ac8eb27,
1382             "only owner can activate"
1383         );
1384         
1385         // can only be ran once
1386         require(activated_ == false, "ratscam already activated");
1387         
1388         // activate the contract 
1389         activated_ = true;
1390         
1391         round_.strt = now - rndGap_;
1392         round_.end = now + rndInit_;
1393     }
1394 }
1395 
1396 //==============================================================================
1397 //   __|_ _    __|_ _  .
1398 //  _\ | | |_|(_ | _\  .
1399 //==============================================================================
1400 library RSdatasets {
1401     //compressedData key
1402     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1403         // 0 - new player (bool)
1404         // 1 - joined round (bool)
1405         // 2 - new  leader (bool)
1406         // 3-5 - air drop tracker (uint 0-999)
1407         // 6-16 - round end time
1408         // 17 - winnerTeam
1409         // 18 - 28 timestamp 
1410         // 29 - team
1411         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1412         // 31 - airdrop happened bool
1413         // 32 - airdrop tier 
1414         // 33 - airdrop amount won
1415     //compressedIDs key
1416     // [77-52][51-26][25-0]
1417         // 0-25 - pID 
1418         // 26-51 - winPID
1419         // 52-77 - rID
1420     struct EventReturns {
1421         uint256 compressedData;
1422         uint256 compressedIDs;
1423         address winnerAddr;         // winner address
1424         bytes32 winnerName;         // winner name
1425         uint256 amountWon;          // amount won
1426         uint256 newPot;             // amount in new pot
1427         uint256 genAmount;          // amount distributed to gen
1428         uint256 potAmount;          // amount added to pot
1429     }
1430     struct Player {
1431         address addr;   // player address
1432         bytes32 name;   // player name
1433         uint256 win;    // winnings vault
1434         uint256 gen;    // general vault
1435         uint256 aff;    // affiliate vault
1436         uint256 laff;   // last affiliate id used
1437     }
1438     struct PlayerRounds {
1439         uint256 eth;    // eth player has added to round (used for eth limiter)
1440         uint256 keys;   // keys
1441         uint256 mask;   // player mask 
1442     }
1443     struct Round {
1444         uint256 plyr;   // pID of player in lead
1445         uint256 end;    // time ends/ended
1446         bool ended;     // has round end function been ran
1447         uint256 strt;   // time round started
1448         uint256 keys;   // keys
1449         uint256 eth;    // total eth in
1450         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1451         uint256 mask;   // global mask
1452     }
1453 }
1454 
1455 //==============================================================================
1456 //  |  _      _ _ | _  .
1457 //  |<(/_\/  (_(_||(_  .
1458 //=======/======================================================================
1459 library RSKeysCalc {
1460     using SafeMath for *;
1461     /**
1462      * @dev calculates number of keys received given X eth 
1463      * @param _curEth current amount of eth in contract 
1464      * @param _newEth eth being spent
1465      * @return amount of ticket purchased
1466      */
1467     function keysRec(uint256 _curEth, uint256 _newEth)
1468         internal
1469         pure
1470         returns (uint256)
1471     {
1472         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1473     }
1474     
1475     /**
1476      * @dev calculates amount of eth received if you sold X keys 
1477      * @param _curKeys current amount of keys that exist 
1478      * @param _sellKeys amount of keys you wish to sell
1479      * @return amount of eth received
1480      */
1481     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1482         internal
1483         pure
1484         returns (uint256)
1485     {
1486         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1487     }
1488 
1489     /**
1490      * @dev calculates how many keys would exist with given an amount of eth
1491      * @param _eth eth "in contract"
1492      * @return number of keys that would exist
1493      */
1494     function keys(uint256 _eth) 
1495         internal
1496         pure
1497         returns(uint256)
1498     {
1499         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1500     }
1501     
1502     /**
1503      * @dev calculates how much eth would be in contract given a number of keys
1504      * @param _keys number of keys "in contract" 
1505      * @return eth that would exists
1506      */
1507     function eth(uint256 _keys) 
1508         internal
1509         pure
1510         returns(uint256)  
1511     {
1512         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1513     }
1514 }
1515 
1516 interface RatInterfaceForForwarder {
1517     function deposit() external payable returns(bool);
1518 }
1519 
1520 interface RatBookInterface {
1521     function getPlayerID(address _addr) external returns (uint256);
1522     function getPlayerName(uint256 _pID) external view returns (bytes32);
1523     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1524     function getPlayerAddr(uint256 _pID) external view returns (address);
1525     function getNameFee() external view returns (uint256);
1526     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1527     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1528     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1529 }
1530 
1531 library NameFilter {
1532     /**
1533      * @dev filters name strings
1534      * -converts uppercase to lower case.  
1535      * -makes sure it does not start/end with a space
1536      * -makes sure it does not contain multiple spaces in a row
1537      * -cannot be only numbers
1538      * -cannot start with 0x 
1539      * -restricts characters to A-Z, a-z, 0-9, and space.
1540      * @return reprocessed string in bytes32 format
1541      */
1542     function nameFilter(string _input)
1543         internal
1544         pure
1545         returns(bytes32)
1546     {
1547         bytes memory _temp = bytes(_input);
1548         uint256 _length = _temp.length;
1549         
1550         //sorry limited to 32 characters
1551         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1552         // make sure it doesnt start with or end with space
1553         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1554         // make sure first two characters are not 0x
1555         if (_temp[0] == 0x30)
1556         {
1557             require(_temp[1] != 0x78, "string cannot start with 0x");
1558             require(_temp[1] != 0x58, "string cannot start with 0X");
1559         }
1560         
1561         // create a bool to track if we have a non number character
1562         bool _hasNonNumber;
1563         
1564         // convert & check
1565         for (uint256 i = 0; i < _length; i++)
1566         {
1567             // if its uppercase A-Z
1568             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1569             {
1570                 // convert to lower case a-z
1571                 _temp[i] = byte(uint(_temp[i]) + 32);
1572                 
1573                 // we have a non number
1574                 if (_hasNonNumber == false)
1575                     _hasNonNumber = true;
1576             } else {
1577                 require
1578                 (
1579                     // require character is a space
1580                     _temp[i] == 0x20 || 
1581                     // OR lowercase a-z
1582                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1583                     // or 0-9
1584                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1585                     "string contains invalid characters"
1586                 );
1587                 // make sure theres not 2x spaces in a row
1588                 if (_temp[i] == 0x20)
1589                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1590                 
1591                 // see if we have a character other than a number
1592                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1593                     _hasNonNumber = true;    
1594             }
1595         }
1596         
1597         require(_hasNonNumber == true, "string cannot be only numbers");
1598         
1599         bytes32 _ret;
1600         assembly {
1601             _ret := mload(add(_temp, 32))
1602         }
1603         return (_ret);
1604     }
1605 }
1606 
1607 /**
1608  * @title SafeMath v0.1.9
1609  * @dev Math operations with safety checks that throw on error
1610  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1611  * - added sqrt
1612  * - added sq
1613  * - changed asserts to requires with error log outputs
1614  * - removed div, its useless
1615  */
1616 library SafeMath {
1617     
1618     /**
1619     * @dev Multiplies two numbers, throws on overflow.
1620     */
1621     function mul(uint256 a, uint256 b) 
1622         internal 
1623         pure 
1624         returns (uint256 c) 
1625     {
1626         if (a == 0) {
1627             return 0;
1628         }
1629         c = a * b;
1630         require(c / a == b, "SafeMath mul failed");
1631         return c;
1632     }
1633 
1634     /**
1635     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1636     */
1637     function sub(uint256 a, uint256 b)
1638         internal
1639         pure
1640         returns (uint256) 
1641     {
1642         require(b <= a, "SafeMath sub failed");
1643         return a - b;
1644     }
1645 
1646     /**
1647     * @dev Adds two numbers, throws on overflow.
1648     */
1649     function add(uint256 a, uint256 b)
1650         internal
1651         pure
1652         returns (uint256 c) 
1653     {
1654         c = a + b;
1655         require(c >= a, "SafeMath add failed");
1656         return c;
1657     }
1658 
1659     /**
1660      * @dev gives square root of given x.
1661      */
1662     function sqrt(uint256 x)
1663         internal
1664         pure
1665         returns (uint256 y) 
1666     {
1667         uint256 z = ((add(x,1)) / 2);
1668         y = x;
1669         while (z < y) 
1670         {
1671             y = z;
1672             z = ((add((x / z),z)) / 2);
1673         }
1674     }
1675 
1676     /**
1677      * @dev gives square. multiplies x by x
1678      */
1679     function sq(uint256 x)
1680         internal
1681         pure
1682         returns (uint256)
1683     {
1684         return (mul(x,x));
1685     }
1686 }