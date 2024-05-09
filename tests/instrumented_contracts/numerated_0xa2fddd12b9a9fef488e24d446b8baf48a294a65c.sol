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
105 contract modularLastUnicorn is RSEvents {}
106 
107 contract LastUnicorn is modularLastUnicorn {
108     using SafeMath for *;
109     using NameFilter for string;
110     using RSKeysCalc for uint256;
111 	
112     // TODO: check address
113     UnicornInterfaceForForwarder constant private TeamUnicorn = UnicornInterfaceForForwarder(0xBB14004A6f3D15945B3786012E00D9358c63c92a);
114 	UnicornBookInterface constant private UnicornBook = UnicornBookInterface(0x98547788f328e1011065E4068A8D72bacA1DDB49);
115 
116     string constant public name = "LastUnicorn Round #2";
117     string constant public symbol = "LUR2";
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
169      * @dev prevents contracts from interacting with LastUnicorn 
170      */
171     modifier isHuman() {
172         address _addr = msg.sender;
173         require (_addr == tx.origin);
174         
175         uint256 _codeLength;
176         
177         assembly {_codeLength := extcodesize(_addr)}
178         require(_codeLength == 0, "non smart contract address only");
179         _;
180     }
181 
182     /**
183      * @dev sets boundaries for incoming tx 
184      */
185     modifier isWithinLimits(uint256 _eth) {
186         require(_eth >= 1000000000, "too little money");
187         require(_eth <= 100000000000000000000000, "too much money");
188         _;    
189     }
190     
191 //==============================================================================
192 //     _    |_ |. _   |`    _  __|_. _  _  _  .
193 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
194 //====|=========================================================================
195     /**
196      * @dev emergency buy uses last stored affiliate ID and team snek
197      */
198     function()
199         isActivated()
200         isHuman()
201         isWithinLimits(msg.value)
202         public
203         payable
204     {
205         // set up our tx event data and determine if player is new or not
206         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
207             
208         // fetch player id
209         uint256 _pID = pIDxAddr_[msg.sender];
210         
211         // buy core 
212         buyCore(_pID, plyr_[_pID].laff, _eventData_);
213     }
214     
215     /**
216      * @dev converts all incoming ethereum to keys.
217      * -functionhash- 0x8f38f309 (using ID for affiliate)
218      * -functionhash- 0x98a0871d (using address for affiliate)
219      * -functionhash- 0xa65b37a1 (using name for affiliate)
220      * @param _affCode the ID/address/name of the player who gets the affiliate fee
221      */
222     function buyXid(uint256 _affCode)
223         isActivated()
224         isHuman()
225         isWithinLimits(msg.value)
226         public
227         payable
228     {
229         // set up our tx event data and determine if player is new or not
230         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
231         
232         // fetch player id
233         uint256 _pID = pIDxAddr_[msg.sender];
234         
235         // manage affiliate residuals
236         // if no affiliate code was given or player tried to use their own, lolz
237         if (_affCode == 0 || _affCode == _pID)
238         {
239             // use last stored affiliate code 
240             _affCode = plyr_[_pID].laff;
241             
242         // if affiliate code was given & its not the same as previously stored 
243         } else if (_affCode != plyr_[_pID].laff) {
244             // update last affiliate 
245             plyr_[_pID].laff = _affCode;
246         }
247                 
248         // buy core 
249         buyCore(_pID, _affCode, _eventData_);
250     }
251     
252     function buyXaddr(address _affCode)
253         isActivated()
254         isHuman()
255         isWithinLimits(msg.value)
256         public
257         payable
258     {
259         // set up our tx event data and determine if player is new or not
260         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
261         
262         // fetch player id
263         uint256 _pID = pIDxAddr_[msg.sender];
264         
265         // manage affiliate residuals
266         uint256 _affID;
267         // if no affiliate code was given or player tried to use their own, lolz
268         if (_affCode == address(0) || _affCode == msg.sender)
269         {
270             // use last stored affiliate code
271             _affID = plyr_[_pID].laff;
272         
273         // if affiliate code was given    
274         } else {
275             // get affiliate ID from aff Code 
276             _affID = pIDxAddr_[_affCode];
277             
278             // if affID is not the same as previously stored 
279             if (_affID != plyr_[_pID].laff)
280             {
281                 // update last affiliate
282                 plyr_[_pID].laff = _affID;
283             }
284         }
285         
286         // buy core 
287         buyCore(_pID, _affID, _eventData_);
288     }
289     
290     function buyXname(bytes32 _affCode)
291         isActivated()
292         isHuman()
293         isWithinLimits(msg.value)
294         public
295         payable
296     {
297         // set up our tx event data and determine if player is new or not
298         RSdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
299         
300         // fetch player id
301         uint256 _pID = pIDxAddr_[msg.sender];
302         
303         // manage affiliate residuals
304         uint256 _affID;
305         // if no affiliate code was given or player tried to use their own, lolz
306         if (_affCode == '' || _affCode == plyr_[_pID].name)
307         {
308             // use last stored affiliate code
309             _affID = plyr_[_pID].laff;
310         
311         // if affiliate code was given
312         } else {
313             // get affiliate ID from aff Code
314             _affID = pIDxName_[_affCode];
315             
316             // if affID is not the same as previously stored
317             if (_affID != plyr_[_pID].laff)
318             {
319                 // update last affiliate
320                 plyr_[_pID].laff = _affID;
321             }
322         }
323         
324         // buy core 
325         buyCore(_pID, _affID, _eventData_);
326     }
327     
328     /**
329      * @dev essentially the same as buy, but instead of you sending ether 
330      * from your wallet, it uses your unwithdrawn earnings.
331      * -functionhash- 0x349cdcac (using ID for affiliate)
332      * -functionhash- 0x82bfc739 (using address for affiliate)
333      * -functionhash- 0x079ce327 (using name for affiliate)
334      * @param _affCode the ID/address/name of the player who gets the affiliate fee
335      * @param _eth amount of earnings to use (remainder returned to gen vault)
336      */
337     function reLoadXid(uint256 _affCode, uint256 _eth)
338         isActivated()
339         isHuman()
340         isWithinLimits(_eth)
341         public
342     {
343         // set up our tx event data
344         RSdatasets.EventReturns memory _eventData_;
345         
346         // fetch player ID
347         uint256 _pID = pIDxAddr_[msg.sender];
348         
349         // manage affiliate residuals
350         // if no affiliate code was given or player tried to use their own, lolz
351         if (_affCode == 0 || _affCode == _pID)
352         {
353             // use last stored affiliate code 
354             _affCode = plyr_[_pID].laff;
355             
356         // if affiliate code was given & its not the same as previously stored 
357         } else if (_affCode != plyr_[_pID].laff) {
358             // update last affiliate 
359             plyr_[_pID].laff = _affCode;
360         }
361 
362         // reload core
363         reLoadCore(_pID, _affCode, _eth, _eventData_);
364     }
365     
366     function reLoadXaddr(address _affCode, uint256 _eth)
367         isActivated()
368         isHuman()
369         isWithinLimits(_eth)
370         public
371     {
372         // set up our tx event data
373         RSdatasets.EventReturns memory _eventData_;
374         
375         // fetch player ID
376         uint256 _pID = pIDxAddr_[msg.sender];
377         
378         // manage affiliate residuals
379         uint256 _affID;
380         // if no affiliate code was given or player tried to use their own, lolz
381         if (_affCode == address(0) || _affCode == msg.sender)
382         {
383             // use last stored affiliate code
384             _affID = plyr_[_pID].laff;
385         
386         // if affiliate code was given    
387         } else {
388             // get affiliate ID from aff Code 
389             _affID = pIDxAddr_[_affCode];
390             
391             // if affID is not the same as previously stored 
392             if (_affID != plyr_[_pID].laff)
393             {
394                 // update last affiliate
395                 plyr_[_pID].laff = _affID;
396             }
397         }
398                 
399         // reload core
400         reLoadCore(_pID, _affID, _eth, _eventData_);
401     }
402     
403     function reLoadXname(bytes32 _affCode, uint256 _eth)
404         isActivated()
405         isHuman()
406         isWithinLimits(_eth)
407         public
408     {
409         // set up our tx event data
410         RSdatasets.EventReturns memory _eventData_;
411         
412         // fetch player ID
413         uint256 _pID = pIDxAddr_[msg.sender];
414         
415         // manage affiliate residuals
416         uint256 _affID;
417         // if no affiliate code was given or player tried to use their own, lolz
418         if (_affCode == '' || _affCode == plyr_[_pID].name)
419         {
420             // use last stored affiliate code
421             _affID = plyr_[_pID].laff;
422         
423         // if affiliate code was given
424         } else {
425             // get affiliate ID from aff Code
426             _affID = pIDxName_[_affCode];
427             
428             // if affID is not the same as previously stored
429             if (_affID != plyr_[_pID].laff)
430             {
431                 // update last affiliate
432                 plyr_[_pID].laff = _affID;
433             }
434         }
435                 
436         // reload core
437         reLoadCore(_pID, _affID, _eth, _eventData_);
438     }
439 
440     /**
441      * @dev withdraws all of your earnings.
442      * -functionhash- 0x3ccfd60b
443      */
444     function withdraw()
445         isActivated()
446         isHuman()
447         public
448     {        
449         // grab time
450         uint256 _now = now;
451         
452         // fetch player ID
453         uint256 _pID = pIDxAddr_[msg.sender];
454         
455         // setup temp var for player eth
456         uint256 _eth;
457         
458         // check to see if round has ended and no one has run round end yet
459         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
460         {
461             // set up our tx event data
462             RSdatasets.EventReturns memory _eventData_;
463             
464             // end the round (distributes pot)
465 			round_.ended = true;
466             _eventData_ = endRound(_eventData_);
467             
468 			// get their earnings
469             _eth = withdrawEarnings(_pID);
470             
471             // gib moni
472             if (_eth > 0)
473                 plyr_[_pID].addr.transfer(_eth);    
474             
475             // build event data
476             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
477             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
478             
479             // fire withdraw and distribute event
480             emit RSEvents.onWithdrawAndDistribute
481             (
482                 msg.sender, 
483                 plyr_[_pID].name, 
484                 _eth, 
485                 _eventData_.compressedData, 
486                 _eventData_.compressedIDs, 
487                 _eventData_.winnerAddr, 
488                 _eventData_.winnerName, 
489                 _eventData_.amountWon, 
490                 _eventData_.newPot, 
491                 _eventData_.genAmount
492             );
493             
494         // in any other situation
495         } else {
496             // get their earnings
497             _eth = withdrawEarnings(_pID);
498             
499             // gib moni
500             if (_eth > 0)
501                 plyr_[_pID].addr.transfer(_eth);
502             
503             // fire withdraw event
504             emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
505         }
506     }
507     
508     /**
509      * @dev use these to register names.  they are just wrappers that will send the
510      * registration requests to the PlayerBook contract.  So registering here is the 
511      * same as registering there.  UI will always display the last name you registered.
512      * but you will still own all previously registered names to use as affiliate 
513      * links.
514      * - must pay a registration fee.
515      * - name must be unique
516      * - names will be converted to lowercase
517      * - name cannot start or end with a space 
518      * - cannot have more than 1 space in a row
519      * - cannot be only numbers
520      * - cannot start with 0x 
521      * - name must be at least 1 char
522      * - max length of 32 characters long
523      * - allowed characters: a-z, 0-9, and space
524      * -functionhash- 0x921dec21 (using ID for affiliate)
525      * -functionhash- 0x3ddd4698 (using address for affiliate)
526      * -functionhash- 0x685ffd83 (using name for affiliate)
527      * @param _nameString players desired name
528      * @param _affCode affiliate ID, address, or name of who referred you
529      * @param _all set to true if you want this to push your info to all games 
530      * (this might cost a lot of gas)
531      */
532     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
533         isHuman()
534         public
535         payable
536     {
537         bytes32 _name = _nameString.nameFilter();
538         address _addr = msg.sender;
539         uint256 _paid = msg.value;
540         (bool _isNewPlayer, uint256 _affID) = UnicornBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
541 
542         uint256 _pID = pIDxAddr_[_addr];
543         
544         // fire event
545         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
546     }
547     
548     function registerNameXaddr(string _nameString, address _affCode, bool _all)
549         isHuman()
550         public
551         payable
552     {
553         bytes32 _name = _nameString.nameFilter();
554         address _addr = msg.sender;
555         uint256 _paid = msg.value;
556         (bool _isNewPlayer, uint256 _affID) = UnicornBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
557         
558         uint256 _pID = pIDxAddr_[_addr];
559         
560         // fire event
561         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
562     }
563     
564     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
565         isHuman()
566         public
567         payable
568     {
569         bytes32 _name = _nameString.nameFilter();
570         address _addr = msg.sender;
571         uint256 _paid = msg.value;
572         (bool _isNewPlayer, uint256 _affID) = UnicornBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
573         
574         uint256 _pID = pIDxAddr_[_addr];
575         
576         // fire event
577         emit RSEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
578     }
579 //==============================================================================
580 //     _  _ _|__|_ _  _ _  .
581 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
582 //=====_|=======================================================================
583     /**
584      * @dev return the price buyer will pay for next 1 individual key.
585      * -functionhash- 0x018a25e8
586      * @return price for next key bought (in wei format)
587      */
588     function getBuyPrice()
589         public 
590         view 
591         returns(uint256)
592     {          
593         // grab time
594         uint256 _now = now;
595         
596         // are we in a round?
597         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
598             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
599         else // rounds over.  need price for new round
600             return ( 75000000000000 ); // init
601     }
602     
603     /**
604      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
605      * provider
606      * -functionhash- 0xc7e284b8
607      * @return time left in seconds
608      */
609     function getTimeLeft()
610         public
611         view
612         returns(uint256)
613     {
614         // grab time
615         uint256 _now = now;
616         
617         if (_now < round_.end)
618             if (_now > round_.strt + rndGap_)
619                 return( (round_.end).sub(_now) );
620             else
621                 return( (round_.strt + rndGap_).sub(_now));
622         else
623             return(0);
624     }
625     
626     /**
627      * @dev returns player earnings per vaults 
628      * -functionhash- 0x63066434
629      * @return winnings vault
630      * @return general vault
631      * @return affiliate vault
632      */
633     function getPlayerVaults(uint256 _pID)
634         public
635         view
636         returns(uint256 ,uint256, uint256)
637     {
638         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
639         if (now > round_.end && round_.ended == false && round_.plyr != 0)
640         {
641             // if player is winner 
642             if (round_.plyr == _pID)
643             {
644                 return
645                 (
646                     (plyr_[_pID].win).add( ((round_.pot).mul(48)) / 100 ),
647                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
648                     plyr_[_pID].aff
649                 );
650             // if player is not the winner
651             } else {
652                 return
653                 (
654                     plyr_[_pID].win,
655                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
656                     plyr_[_pID].aff
657                 );
658             }
659             
660         // if round is still going on, or round has ended and round end has been ran
661         } else {
662             return
663             (
664                 plyr_[_pID].win,
665                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
666                 plyr_[_pID].aff
667             );
668         }
669     }
670     
671     /**
672      * solidity hates stack limits.  this lets us avoid that hate 
673      */
674     function getPlayerVaultsHelper(uint256 _pID)
675         private
676         view
677         returns(uint256)
678     {
679         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
680     }
681     
682     /**
683      * @dev returns all current round info needed for front end
684      * -functionhash- 0x747dff42
685      * @return total keys
686      * @return time ends
687      * @return time started
688      * @return current pot 
689      * @return current player ID in lead 
690      * @return current player in leads address 
691      * @return current player in leads name
692      * @return airdrop tracker # & airdrop pot
693      */
694     function getCurrentRoundInfo()
695         public
696         view
697         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
698     {
699         return
700         (
701             round_.keys,              //0
702             round_.end,               //1
703             round_.strt,              //2
704             round_.pot,               //3
705             round_.plyr,              //4
706             plyr_[round_.plyr].addr,  //5
707             plyr_[round_.plyr].name,  //6
708             airDropTracker_ + (airDropPot_ * 1000)              //7
709         );
710     }
711 
712     /**
713      * @dev returns player info based on address.  if no address is given, it will 
714      * use msg.sender 
715      * -functionhash-
716      * @param _addr address of the player you want to lookup 
717      * @return player ID 
718      * @return player name
719      * @return keys owned (current round)
720      * @return winnings vault
721      * @return general vault 
722      * @return affiliate vault 
723 	 * @return player round eth
724      */
725     function getPlayerInfoByAddress(address _addr)
726         public 
727         view 
728         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
729     {
730         if (_addr == address(0))
731         {
732             _addr == msg.sender;
733         }
734         uint256 _pID = pIDxAddr_[_addr];
735         
736         return
737         (
738             _pID,                               //0
739             plyr_[_pID].name,                   //1
740             plyrRnds_[_pID].keys,         //2
741             plyr_[_pID].win,                    //3
742             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
743             plyr_[_pID].aff,                    //5
744             plyrRnds_[_pID].eth           //6
745         );
746     }
747 
748 //==============================================================================
749 //     _ _  _ _   | _  _ . _  .
750 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
751 //=====================_|=======================================================
752     /**
753      * @dev logic runs whenever a buy order is executed.  determines how to handle 
754      * incoming eth depending on if we are in an active round or not
755      */
756     function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
757         private
758     {
759         // grab time
760         uint256 _now = now;
761         
762         // if round is active
763         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
764         {
765             // call core 
766             core(_pID, msg.value, _affID, _eventData_);
767         
768         // if round is not active     
769         } else {
770             // check to see if end round needs to be ran
771             if (_now > round_.end && round_.ended == false) 
772             {
773                 // end the round (distributes pot) & start new round
774 			    round_.ended = true;
775                 _eventData_ = endRound(_eventData_);
776                 
777                 // build event data
778                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
779                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
780                 
781                 // fire buy and distribute event 
782                 emit RSEvents.onBuyAndDistribute
783                 (
784                     msg.sender, 
785                     plyr_[_pID].name, 
786                     msg.value, 
787                     _eventData_.compressedData, 
788                     _eventData_.compressedIDs, 
789                     _eventData_.winnerAddr, 
790                     _eventData_.winnerName, 
791                     _eventData_.amountWon, 
792                     _eventData_.newPot, 
793                     _eventData_.genAmount
794                 );
795             }
796             
797             // put eth in players vault 
798             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
799         }
800     }
801     
802     /**
803      * @dev logic runs whenever a reload order is executed.  determines how to handle 
804      * incoming eth depending on if we are in an active round or not 
805      */
806     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, RSdatasets.EventReturns memory _eventData_)
807         private
808     {
809         // grab time
810         uint256 _now = now;
811         
812         // if round is active
813         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
814         {
815             // get earnings from all vaults and return unused to gen vault
816             // because we use a custom safemath library.  this will throw if player 
817             // tried to spend more eth than they have.
818             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
819             
820             // call core 
821             core(_pID, _eth, _affID, _eventData_);
822         
823         // if round is not active and end round needs to be ran   
824         } else if (_now > round_.end && round_.ended == false) {
825             // end the round (distributes pot) & start new round
826             round_.ended = true;
827             _eventData_ = endRound(_eventData_);
828                 
829             // build event data
830             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
831             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
832                 
833             // fire buy and distribute event 
834             emit RSEvents.onReLoadAndDistribute
835             (
836                 msg.sender, 
837                 plyr_[_pID].name, 
838                 _eventData_.compressedData, 
839                 _eventData_.compressedIDs, 
840                 _eventData_.winnerAddr, 
841                 _eventData_.winnerName, 
842                 _eventData_.amountWon, 
843                 _eventData_.newPot, 
844                 _eventData_.genAmount
845             );
846         }
847     }
848     
849     /**
850      * @dev this is the core logic for any buy/reload that happens while a round 
851      * is live.
852      */
853     function core(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
854         private
855     {
856         // if player is new to round
857         if (plyrRnds_[_pID].keys == 0)
858             _eventData_ = managePlayer(_pID, _eventData_);
859         
860         // early round eth limiter 
861         if (round_.eth < 100000000000000000000 && plyrRnds_[_pID].eth.add(_eth) > 10000000000000000000)
862         {
863             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID].eth);
864             uint256 _refund = _eth.sub(_availableLimit);
865             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
866             _eth = _availableLimit;
867         }
868         
869         // if eth left is greater than min eth allowed (sorry no pocket lint)
870         if (_eth > 1000000000) 
871         {
872             
873             // mint the new keys
874             uint256 _keys = (round_.eth).keysRec(_eth);
875             
876             // if they bought at least 1 whole key
877             if (_keys >= 1000000000000000000)
878             {
879             updateTimer(_keys);
880 
881             // set new leaders
882             if (round_.plyr != _pID)
883                 round_.plyr = _pID;  
884             
885             // set the new leader bool to true
886             _eventData_.compressedData = _eventData_.compressedData + 100;
887         }
888             
889             // manage airdrops
890             if (_eth >= 100000000000000000)
891             {
892             airDropTracker_++;
893             if (airdrop() == true)
894             {
895                 // gib muni
896                 uint256 _prize;
897                 if (_eth >= 10000000000000000000)
898                 {
899                     // calculate prize and give it to winner
900                     _prize = ((airDropPot_).mul(75)) / 100;
901                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
902                     
903                     // adjust airDropPot 
904                     airDropPot_ = (airDropPot_).sub(_prize);
905                     
906                     // let event know a tier 3 prize was won 
907                     _eventData_.compressedData += 300000000000000000000000000000000;
908                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
909                     // calculate prize and give it to winner
910                     _prize = ((airDropPot_).mul(50)) / 100;
911                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
912                     
913                     // adjust airDropPot 
914                     airDropPot_ = (airDropPot_).sub(_prize);
915                     
916                     // let event know a tier 2 prize was won 
917                     _eventData_.compressedData += 200000000000000000000000000000000;
918                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
919                     // calculate prize and give it to winner
920                     _prize = ((airDropPot_).mul(25)) / 100;
921                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
922                     
923                     // adjust airDropPot 
924                     airDropPot_ = (airDropPot_).sub(_prize);
925                     
926                     // let event know a tier 1 prize was won 
927                     _eventData_.compressedData += 100000000000000000000000000000000;
928                 }
929                 // set airdrop happened bool to true
930                 _eventData_.compressedData += 10000000000000000000000000000000;
931                 // let event know how much was won 
932                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
933                 
934                 // reset air drop tracker
935                 airDropTracker_ = 0;
936             }
937         }
938     
939             // store the air drop tracker number (number of buys since last airdrop)
940             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
941             
942             // update player 
943             plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
944             plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
945             
946             // update round
947             round_.keys = _keys.add(round_.keys);
948             round_.eth = _eth.add(round_.eth);
949     
950             // distribute eth
951             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
952             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
953             
954             // call end tx function to fire end tx event.
955 		    endTx(_pID, _eth, _keys, _eventData_);
956         }
957     }
958 //==============================================================================
959 //     _ _ | _   | _ _|_ _  _ _  .
960 //    (_(_||(_|_||(_| | (_)| _\  .
961 //==============================================================================
962     /**
963      * @dev calculates unmasked earnings (just calculates, does not update mask)
964      * @return earnings in wei format
965      */
966     function calcUnMaskedEarnings(uint256 _pID)
967         private
968         view
969         returns(uint256)
970     {
971         return((((round_.mask).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask));
972     }
973     
974     /** 
975      * @dev returns the amount of keys you would get given an amount of eth. 
976      * -functionhash- 0xce89c80c
977      * @param _eth amount of eth sent in 
978      * @return keys received 
979      */
980     function calcKeysReceived(uint256 _eth)
981         public
982         view
983         returns(uint256)
984     {
985         // grab time
986         uint256 _now = now;
987         
988         // are we in a round?
989         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
990             return ( (round_.eth).keysRec(_eth) );
991         else // rounds over.  need keys for new round
992             return ( (_eth).keys() );
993     }
994     
995     /** 
996      * @dev returns current eth price for X keys.  
997      * -functionhash- 0xcf808000
998      * @param _keys number of keys desired (in 18 decimal format)
999      * @return amount of eth needed to send
1000      */
1001     function iWantXKeys(uint256 _keys)
1002         public
1003         view
1004         returns(uint256)
1005     {
1006         // grab time
1007         uint256 _now = now;
1008         
1009         // are we in a round?
1010         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1011             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1012         else // rounds over.  need price for new round
1013             return ( (_keys).eth() );
1014     }
1015 //==============================================================================
1016 //    _|_ _  _ | _  .
1017 //     | (_)(_)|_\  .
1018 //==============================================================================
1019     /**
1020 	 * @dev receives name/player info from names contract 
1021      */
1022     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1023         external
1024     {
1025         require (msg.sender == address(UnicornBook), "only UnicornBook can call this function");
1026         if (pIDxAddr_[_addr] != _pID)
1027             pIDxAddr_[_addr] = _pID;
1028         if (pIDxName_[_name] != _pID)
1029             pIDxName_[_name] = _pID;
1030         if (plyr_[_pID].addr != _addr)
1031             plyr_[_pID].addr = _addr;
1032         if (plyr_[_pID].name != _name)
1033             plyr_[_pID].name = _name;
1034         if (plyr_[_pID].laff != _laff)
1035             plyr_[_pID].laff = _laff;
1036         if (plyrNames_[_pID][_name] == false)
1037             plyrNames_[_pID][_name] = true;
1038     }
1039     
1040     /**
1041      * @dev receives entire player name list 
1042      */
1043     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1044         external
1045     {
1046         require (msg.sender == address(UnicornBook), "only UnicornBook can call this function");
1047         if(plyrNames_[_pID][_name] == false)
1048             plyrNames_[_pID][_name] = true;
1049     }   
1050         
1051     /**
1052      * @dev gets existing or registers new pID.  use this when a player may be new
1053      * @return pID 
1054      */
1055     function determinePID(RSdatasets.EventReturns memory _eventData_)
1056         private
1057         returns (RSdatasets.EventReturns)
1058     {
1059         uint256 _pID = pIDxAddr_[msg.sender];
1060         // if player is new to this version of LastUnicorn
1061         if (_pID == 0)
1062         {
1063             // grab their player ID, name and last aff ID, from player names contract 
1064             _pID = UnicornBook.getPlayerID(msg.sender);
1065             bytes32 _name = UnicornBook.getPlayerName(_pID);
1066             uint256 _laff = UnicornBook.getPlayerLAff(_pID);
1067             
1068             // set up player account 
1069             pIDxAddr_[msg.sender] = _pID;
1070             plyr_[_pID].addr = msg.sender;
1071             
1072             if (_name != "")
1073             {
1074                 pIDxName_[_name] = _pID;
1075                 plyr_[_pID].name = _name;
1076                 plyrNames_[_pID][_name] = true;
1077             }
1078             
1079             if (_laff != 0 && _laff != _pID)
1080                 plyr_[_pID].laff = _laff;
1081             
1082             // set the new player bool to true
1083             _eventData_.compressedData = _eventData_.compressedData + 1;
1084         } 
1085         return (_eventData_);
1086     }
1087 
1088     /**
1089      * @dev decides if round end needs to be run & new round started.  and if 
1090      * player unmasked earnings from previously played rounds need to be moved.
1091      */
1092     function managePlayer(uint256 _pID, RSdatasets.EventReturns memory _eventData_)
1093         private
1094         returns (RSdatasets.EventReturns)
1095     {            
1096         // set the joined round bool to true
1097         _eventData_.compressedData = _eventData_.compressedData + 10;
1098         
1099         return(_eventData_);
1100     }
1101     
1102     /**
1103      * @dev ends the round. manages paying out winner/splitting up pot
1104      */
1105     function endRound(RSdatasets.EventReturns memory _eventData_)
1106         private
1107         returns (RSdatasets.EventReturns)
1108     {        
1109         // grab our winning player and team id's
1110         uint256 _winPID = round_.plyr;
1111         
1112         // grab our pot amount
1113         // add airdrop pot into the final pot
1114         uint256 _pot = round_.pot + airDropPot_;
1115         
1116         // calculate our winner share, community rewards, gen share, 
1117         // p3d share, and amount reserved for next pot 
1118         uint256 _win = (_pot.mul(45)) / 100;
1119         uint256 _com = (_pot / 10);
1120         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1121         
1122         // calculate ppt for round mask
1123         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1124         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1125         if (_dust > 0)
1126         {
1127             _gen = _gen.sub(_dust);
1128             _com = _com.add(_dust);
1129         }
1130         
1131         // pay our winner
1132         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1133         
1134         // community rewards
1135         if (!address(TeamUnicorn).call.value(_com)(bytes4(keccak256("deposit()"))))
1136         {
1137             _gen = _gen.add(_com);
1138             _com = 0;
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
1160         private 
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
1176         private
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
1201         private 
1202         view 
1203         returns(bool)
1204     {
1205         uint256 seed = uint256(keccak256(abi.encodePacked(
1206             
1207             (block.timestamp).add
1208             (block.difficulty).add
1209             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1210             (block.gaslimit).add
1211             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1212             (block.number)
1213             
1214         )));
1215         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1216             return(true);
1217         else
1218             return(false);
1219     }
1220 
1221     /**
1222      * @dev distributes eth based on fees to com, aff, and p3d
1223      */
1224     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
1225         private
1226         returns(RSdatasets.EventReturns)
1227     {
1228         // pay 5% out to community rewards
1229         uint256 _com = _eth * 5 / 100;
1230                 
1231         // distribute share to affiliate
1232         uint256 _aff = _eth / 10;
1233         
1234         // decide what to do with affiliate share of fees
1235         // affiliate must not be self, and must have a name registered
1236         if (_affID != _pID && plyr_[_affID].name != '') {
1237             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1238             emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1239         } else {
1240             // no affiliates, add to community
1241             _com += _aff;
1242         }
1243 
1244         if (!address(TeamUnicorn).call.value(_com)(bytes4(keccak256("deposit()"))))
1245         {
1246             // This ensures TeamUnicorn cannot influence the outcome
1247             // bank migrations by breaking outgoing transactions.
1248         }
1249 
1250         return(_eventData_);
1251     }
1252     
1253     /**
1254      * @dev distributes eth based on fees to gen and pot
1255      */
1256     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1257         private
1258         returns(RSdatasets.EventReturns)
1259     {
1260         // calculate gen share
1261         uint256 _gen = (_eth.mul(fees_)) / 100;
1262         
1263         // toss 5% into airdrop pot 
1264         uint256 _air = (_eth / 20);
1265         airDropPot_ = airDropPot_.add(_air);
1266                 
1267         // calculate pot (20%) 
1268         uint256 _pot = (_eth.mul(20) / 100);
1269         
1270         // distribute gen share (thats what updateMasks() does) and adjust
1271         // balances for dust.
1272         uint256 _dust = updateMasks(_pID, _gen, _keys);
1273         if (_dust > 0)
1274             _gen = _gen.sub(_dust);
1275         
1276         // add eth to pot
1277         round_.pot = _pot.add(_dust).add(round_.pot);
1278         
1279         // set up event data
1280         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1281         _eventData_.potAmount = _pot;
1282         
1283         return(_eventData_);
1284     }
1285 
1286     /**
1287      * @dev updates masks for round and player when keys are bought
1288      * @return dust left over 
1289      */
1290     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1291         private
1292         returns(uint256)
1293     {
1294         /* MASKING NOTES
1295             earnings masks are a tricky thing for people to wrap their minds around.
1296             the basic thing to understand here.  is were going to have a global
1297             tracker based on profit per share for each round, that increases in
1298             relevant proportion to the increase in share supply.
1299             
1300             the player will have an additional mask that basically says "based
1301             on the rounds mask, my shares, and how much i've already withdrawn,
1302             how much is still owed to me?"
1303         */
1304         
1305         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1306         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1307         round_.mask = _ppt.add(round_.mask);
1308             
1309         // calculate player earning from their own buy (only based on the keys
1310         // they just bought).  & update player earnings mask
1311         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1312         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1313         
1314         // calculate & return dust
1315         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1316     }
1317     
1318     /**
1319      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1320      * @return earnings in wei format
1321      */
1322     function withdrawEarnings(uint256 _pID)
1323         private
1324         returns(uint256)
1325     {
1326         // update gen vault
1327         updateGenVault(_pID);
1328         
1329         // from vaults 
1330         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1331         if (_earnings > 0)
1332         {
1333             plyr_[_pID].win = 0;
1334             plyr_[_pID].gen = 0;
1335             plyr_[_pID].aff = 0;
1336         }
1337 
1338         return(_earnings);
1339     }
1340     
1341     /**
1342      * @dev prepares compression data and fires event for buy or reload tx's
1343      */
1344     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, RSdatasets.EventReturns memory _eventData_)
1345         private
1346     {
1347         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1348         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1349         
1350         emit RSEvents.onEndTx
1351         (
1352             _eventData_.compressedData,
1353             _eventData_.compressedIDs,
1354             plyr_[_pID].name,
1355             msg.sender,
1356             _eth,
1357             _keys,
1358             _eventData_.winnerAddr,
1359             _eventData_.winnerName,
1360             _eventData_.amountWon,
1361             _eventData_.newPot,
1362             _eventData_.genAmount,
1363             _eventData_.potAmount,
1364             airDropPot_
1365         );
1366     }
1367 
1368     /** upon contract deploy, it will be deactivated.  this is a one time
1369      * use function that will activate the contract.  we do this so devs 
1370      * have time to set things up on the web end                            **/
1371     bool public activated_ = false;
1372     function activate()
1373         public
1374     {
1375         // only owner can activate 
1376         // TODO: set owner
1377         require(
1378             (msg.sender == 0xcD0fce8d255349092496F131f2900DF25f0569F8),
1379             "only owner can activate"
1380         );
1381         
1382         // can only be ran once
1383         require(activated_ == false, "LastUnicorn already activated");
1384         
1385         // activate the contract 
1386         activated_ = true;
1387         
1388         round_.strt = now - rndGap_;
1389         round_.end = now + rndInit_;
1390     }
1391 }
1392 
1393 //==============================================================================
1394 //   __|_ _    __|_ _  .
1395 //  _\ | | |_|(_ | _\  .
1396 //==============================================================================
1397 library RSdatasets {
1398     //compressedData key
1399     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1400         // 0 - new player (bool)
1401         // 1 - joined round (bool)
1402         // 2 - new  leader (bool)
1403         // 3-5 - air drop tracker (uint 0-999)
1404         // 6-16 - round end time
1405         // 17 - winnerTeam
1406         // 18 - 28 timestamp 
1407         // 29 - team
1408         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1409         // 31 - airdrop happened bool
1410         // 32 - airdrop tier 
1411         // 33 - airdrop amount won
1412     //compressedIDs key
1413     // [77-52][51-26][25-0]
1414         // 0-25 - pID 
1415         // 26-51 - winPID
1416         // 52-77 - rID
1417     struct EventReturns {
1418         uint256 compressedData;
1419         uint256 compressedIDs;
1420         address winnerAddr;         // winner address
1421         bytes32 winnerName;         // winner name
1422         uint256 amountWon;          // amount won
1423         uint256 newPot;             // amount in new pot
1424         uint256 genAmount;          // amount distributed to gen
1425         uint256 potAmount;          // amount added to pot
1426     }
1427     struct Player {
1428         address addr;   // player address
1429         bytes32 name;   // player name
1430         uint256 win;    // winnings vault
1431         uint256 gen;    // general vault
1432         uint256 aff;    // affiliate vault
1433         uint256 laff;   // last affiliate id used
1434     }
1435     struct PlayerRounds {
1436         uint256 eth;    // eth player has added to round (used for eth limiter)
1437         uint256 keys;   // keys
1438         uint256 mask;   // player mask 
1439     }
1440     struct Round {
1441         uint256 plyr;   // pID of player in lead
1442         uint256 end;    // time ends/ended
1443         bool ended;     // has round end function been ran
1444         uint256 strt;   // time round started
1445         uint256 keys;   // keys
1446         uint256 eth;    // total eth in
1447         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1448         uint256 mask;   // global mask
1449     }
1450 }
1451 
1452 //==============================================================================
1453 //  |  _      _ _ | _  .
1454 //  |<(/_\/  (_(_||(_  .
1455 //=======/======================================================================
1456 library RSKeysCalc {
1457     using SafeMath for *;
1458     /**
1459      * @dev calculates number of keys received given X eth 
1460      * @param _curEth current amount of eth in contract 
1461      * @param _newEth eth being spent
1462      * @return amount of ticket purchased
1463      */
1464     function keysRec(uint256 _curEth, uint256 _newEth)
1465         internal
1466         pure
1467         returns (uint256)
1468     {
1469         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1470     }
1471     
1472     /**
1473      * @dev calculates amount of eth received if you sold X keys 
1474      * @param _curKeys current amount of keys that exist 
1475      * @param _sellKeys amount of keys you wish to sell
1476      * @return amount of eth received
1477      */
1478     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1479         internal
1480         pure
1481         returns (uint256)
1482     {
1483         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1484     }
1485 
1486     /**
1487      * @dev calculates how many keys would exist with given an amount of eth
1488      * @param _eth eth "in contract"
1489      * @return number of keys that would exist
1490      */
1491     function keys(uint256 _eth) 
1492         internal
1493         pure
1494         returns(uint256)
1495     {
1496         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1497     }
1498     
1499     /**
1500      * @dev calculates how much eth would be in contract given a number of keys
1501      * @param _keys number of keys "in contract" 
1502      * @return eth that would exists
1503      */
1504     function eth(uint256 _keys) 
1505         internal
1506         pure
1507         returns(uint256)  
1508     {
1509         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1510     }
1511 }
1512 
1513 interface UnicornInterfaceForForwarder {
1514     function deposit() external payable returns(bool);
1515 }
1516 
1517 interface UnicornBookInterface {
1518     function getPlayerID(address _addr) external returns (uint256);
1519     function getPlayerName(uint256 _pID) external view returns (bytes32);
1520     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1521     function getPlayerAddr(uint256 _pID) external view returns (address);
1522     function getNameFee() external view returns (uint256);
1523     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1524     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1525     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1526 }
1527 
1528 library NameFilter {
1529     /**
1530      * @dev filters name strings
1531      * -converts uppercase to lower case.  
1532      * -makes sure it does not start/end with a space
1533      * -makes sure it does not contain multiple spaces in a row
1534      * -cannot be only numbers
1535      * -cannot start with 0x 
1536      * -restricts characters to A-Z, a-z, 0-9, and space.
1537      * @return reprocessed string in bytes32 format
1538      */
1539     function nameFilter(string _input)
1540         internal
1541         pure
1542         returns(bytes32)
1543     {
1544         bytes memory _temp = bytes(_input);
1545         uint256 _length = _temp.length;
1546         
1547         //sorry limited to 32 characters
1548         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1549         // make sure it doesnt start with or end with space
1550         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1551         // make sure first two characters are not 0x
1552         if (_temp[0] == 0x30)
1553         {
1554             require(_temp[1] != 0x78, "string cannot start with 0x");
1555             require(_temp[1] != 0x58, "string cannot start with 0X");
1556         }
1557         
1558         // create a bool to track if we have a non number character
1559         bool _hasNonNumber;
1560         
1561         // convert & check
1562         for (uint256 i = 0; i < _length; i++)
1563         {
1564             // if its uppercase A-Z
1565             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1566             {
1567                 // convert to lower case a-z
1568                 _temp[i] = byte(uint(_temp[i]) + 32);
1569                 
1570                 // we have a non number
1571                 if (_hasNonNumber == false)
1572                     _hasNonNumber = true;
1573             } else {
1574                 require
1575                 (
1576                     // require character is a space
1577                     _temp[i] == 0x20 || 
1578                     // OR lowercase a-z
1579                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1580                     // or 0-9
1581                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1582                     "string contains invalid characters"
1583                 );
1584                 // make sure theres not 2x spaces in a row
1585                 if (_temp[i] == 0x20)
1586                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1587                 
1588                 // see if we have a character other than a number
1589                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1590                     _hasNonNumber = true;    
1591             }
1592         }
1593         
1594         require(_hasNonNumber == true, "string cannot be only numbers");
1595         
1596         bytes32 _ret;
1597         assembly {
1598             _ret := mload(add(_temp, 32))
1599         }
1600         return (_ret);
1601     }
1602 }
1603 
1604 /**
1605  * @title SafeMath v0.1.9
1606  * @dev Math operations with safety checks that throw on error
1607  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1608  * - added sqrt
1609  * - added sq
1610  * - changed asserts to requires with error log outputs
1611  * - removed div, its useless
1612  */
1613 library SafeMath {
1614     
1615     /**
1616     * @dev Multiplies two numbers, throws on overflow.
1617     */
1618     function mul(uint256 a, uint256 b) 
1619         internal 
1620         pure 
1621         returns (uint256 c) 
1622     {
1623         if (a == 0) {
1624             return 0;
1625         }
1626         c = a * b;
1627         require(c / a == b, "SafeMath mul failed");
1628         return c;
1629     }
1630 
1631     /**
1632     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1633     */
1634     function sub(uint256 a, uint256 b)
1635         internal
1636         pure
1637         returns (uint256) 
1638     {
1639         require(b <= a, "SafeMath sub failed");
1640         return a - b;
1641     }
1642 
1643     /**
1644     * @dev Adds two numbers, throws on overflow.
1645     */
1646     function add(uint256 a, uint256 b)
1647         internal
1648         pure
1649         returns (uint256 c) 
1650     {
1651         c = a + b;
1652         require(c >= a, "SafeMath add failed");
1653         return c;
1654     }
1655 
1656     /**
1657      * @dev gives square root of given x.
1658      */
1659     function sqrt(uint256 x)
1660         internal
1661         pure
1662         returns (uint256 y) 
1663     {
1664         uint256 z = ((add(x,1)) / 2);
1665         y = x;
1666         while (z < y) 
1667         {
1668             y = z;
1669             z = ((add((x / z),z)) / 2);
1670         }
1671     }
1672 
1673     /**
1674      * @dev gives square. multiplies x by x
1675      */
1676     function sq(uint256 x)
1677         internal
1678         pure
1679         returns (uint256)
1680     {
1681         return (mul(x,x));
1682     }
1683 }