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
113     MonkeyInterfaceForForwarder constant private MonkeyKingCorp = MonkeyInterfaceForForwarder(0xd7630d881355151850f62df8c101a978c8ea01f0);
114     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x61c279b55538fbb6fcaccbf84673bae6b5308788);
115 
116     string constant public name = "MonkeyScam Round #1";
117     string constant public symbol = "MSR";
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
135     mapping (uint256 => LDdatasets.Player) public plyr_;   // (pID => data) player data
136     mapping (uint256 => LDdatasets.PlayerRounds) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
137     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
138 //****************
139 // ROUND DATA 
140 //****************
141     LDdatasets.Round public round_;   // round data
142 //****************
143 // TEAM FEE DATA 
144 //****************
145     uint256 public fees_ = 60;          // fee distribution
146     uint256 public potSplit_ = 45;      // pot split distribution
147 //==============================================================================
148 //     _ _  _  _|. |`. _  _ _  .
149 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
150 //==============================================================================
151     /**
152      * @dev used to make sure no one can interact with contract until it has 
153      * been activated. 
154      */
155     modifier isActivated() {
156         require(activated_ == true, "its not ready yet"); 
157         _;
158     }
159     
160     /**
161      * @dev prevents contracts from interacting with ratscam 
162      */
163     modifier isHuman() {
164         address _addr = msg.sender;
165         uint256 _codeLength;
166         
167         assembly {_codeLength := extcodesize(_addr)}
168         require(_codeLength == 0, "non smart contract address only");
169         _;
170     }
171 
172     /**
173      * @dev sets boundaries for incoming tx 
174      */
175     modifier isWithinLimits(uint256 _eth) {
176         require(_eth >= 1000000000, "too little money");
177         require(_eth <= 100000000000000000000000, "too much money");
178         _;    
179     }
180     
181 //==============================================================================
182 //     _    |_ |. _   |`    _  __|_. _  _  _  .
183 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
184 //====|=========================================================================
185     /**
186      * @dev emergency buy uses last stored affiliate ID and team snek
187      */
188     function()
189         isActivated()
190         isHuman()
191         isWithinLimits(msg.value)
192         public
193         payable
194     {
195         // set up our tx event data and determine if player is new or not
196         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
197             
198         // fetch player id
199         uint256 _pID = pIDxAddr_[msg.sender];
200         
201         // buy core 
202         buyCore(_pID, plyr_[_pID].laff, _eventData_);
203     }
204     
205     /**
206      * @dev converts all incoming ethereum to keys.
207      * -functionhash- 0x8f38f309 (using ID for affiliate)
208      * -functionhash- 0x98a0871d (using address for affiliate)
209      * -functionhash- 0xa65b37a1 (using name for affiliate)
210      * @param _affCode the ID/address/name of the player who gets the affiliate fee
211      */
212     function buyXid(uint256 _affCode)
213         isActivated()
214         isHuman()
215         isWithinLimits(msg.value)
216         public
217         payable
218     {
219         // set up our tx event data and determine if player is new or not
220         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
221         
222         // fetch player id
223         uint256 _pID = pIDxAddr_[msg.sender];
224         
225         // manage affiliate residuals
226         // if no affiliate code was given or player tried to use their own, lolz
227         if (_affCode == 0 || _affCode == _pID)
228         {
229             // use last stored affiliate code 
230             _affCode = plyr_[_pID].laff;
231             
232         // if affiliate code was given & its not the same as previously stored 
233         } else if (_affCode != plyr_[_pID].laff) {
234             // update last affiliate 
235             plyr_[_pID].laff = _affCode;
236         }
237                 
238         // buy core 
239         buyCore(_pID, _affCode, _eventData_);
240     }
241     
242     function buyXaddr(address _affCode)
243         isActivated()
244         isHuman()
245         isWithinLimits(msg.value)
246         public
247         payable
248     {
249         // set up our tx event data and determine if player is new or not
250         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
251         
252         // fetch player id
253         uint256 _pID = pIDxAddr_[msg.sender];
254         
255         // manage affiliate residuals
256         uint256 _affID;
257         // if no affiliate code was given or player tried to use their own, lolz
258         if (_affCode == address(0) || _affCode == msg.sender)
259         {
260             // use last stored affiliate code
261             _affID = plyr_[_pID].laff;
262         
263         // if affiliate code was given    
264         } else {
265             // get affiliate ID from aff Code 
266             _affID = pIDxAddr_[_affCode];
267             
268             // if affID is not the same as previously stored 
269             if (_affID != plyr_[_pID].laff)
270             {
271                 // update last affiliate
272                 plyr_[_pID].laff = _affID;
273             }
274         }
275         
276         // buy core 
277         buyCore(_pID, _affID, _eventData_);
278     }
279     
280     function buyXname(bytes32 _affCode)
281         isActivated()
282         isHuman()
283         isWithinLimits(msg.value)
284         public
285         payable
286     {
287         // set up our tx event data and determine if player is new or not
288         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
289         
290         // fetch player id
291         uint256 _pID = pIDxAddr_[msg.sender];
292         
293         // manage affiliate residuals
294         uint256 _affID;
295         // if no affiliate code was given or player tried to use their own, lolz
296         if (_affCode == '' || _affCode == plyr_[_pID].name)
297         {
298             // use last stored affiliate code
299             _affID = plyr_[_pID].laff;
300         
301         // if affiliate code was given
302         } else {
303             // get affiliate ID from aff Code
304             _affID = pIDxName_[_affCode];
305             
306             // if affID is not the same as previously stored
307             if (_affID != plyr_[_pID].laff)
308             {
309                 // update last affiliate
310                 plyr_[_pID].laff = _affID;
311             }
312         }
313         
314         // buy core 
315         buyCore(_pID, _affID, _eventData_);
316     }
317     
318     /**
319      * @dev essentially the same as buy, but instead of you sending ether 
320      * from your wallet, it uses your unwithdrawn earnings.
321      * -functionhash- 0x349cdcac (using ID for affiliate)
322      * -functionhash- 0x82bfc739 (using address for affiliate)
323      * -functionhash- 0x079ce327 (using name for affiliate)
324      * @param _affCode the ID/address/name of the player who gets the affiliate fee
325      * @param _eth amount of earnings to use (remainder returned to gen vault)
326      */
327     function reLoadXid(uint256 _affCode, uint256 _eth)
328         isActivated()
329         isHuman()
330         isWithinLimits(_eth)
331         public
332     {
333         // set up our tx event data
334         LDdatasets.EventReturns memory _eventData_;
335         
336         // fetch player ID
337         uint256 _pID = pIDxAddr_[msg.sender];
338         
339         // manage affiliate residuals
340         // if no affiliate code was given or player tried to use their own, lolz
341         if (_affCode == 0 || _affCode == _pID)
342         {
343             // use last stored affiliate code 
344             _affCode = plyr_[_pID].laff;
345             
346         // if affiliate code was given & its not the same as previously stored 
347         } else if (_affCode != plyr_[_pID].laff) {
348             // update last affiliate 
349             plyr_[_pID].laff = _affCode;
350         }
351 
352         // reload core
353         reLoadCore(_pID, _affCode, _eth, _eventData_);
354     }
355     
356     function reLoadXaddr(address _affCode, uint256 _eth)
357         isActivated()
358         isHuman()
359         isWithinLimits(_eth)
360         public
361     {
362         // set up our tx event data
363         LDdatasets.EventReturns memory _eventData_;
364         
365         // fetch player ID
366         uint256 _pID = pIDxAddr_[msg.sender];
367         
368         // manage affiliate residuals
369         uint256 _affID;
370         // if no affiliate code was given or player tried to use their own, lolz
371         if (_affCode == address(0) || _affCode == msg.sender)
372         {
373             // use last stored affiliate code
374             _affID = plyr_[_pID].laff;
375         
376         // if affiliate code was given    
377         } else {
378             // get affiliate ID from aff Code 
379             _affID = pIDxAddr_[_affCode];
380             
381             // if affID is not the same as previously stored 
382             if (_affID != plyr_[_pID].laff)
383             {
384                 // update last affiliate
385                 plyr_[_pID].laff = _affID;
386             }
387         }
388                 
389         // reload core
390         reLoadCore(_pID, _affID, _eth, _eventData_);
391     }
392     
393     function reLoadXname(bytes32 _affCode, uint256 _eth)
394         isActivated()
395         isHuman()
396         isWithinLimits(_eth)
397         public
398     {
399         // set up our tx event data
400         LDdatasets.EventReturns memory _eventData_;
401         
402         // fetch player ID
403         uint256 _pID = pIDxAddr_[msg.sender];
404         
405         // manage affiliate residuals
406         uint256 _affID;
407         // if no affiliate code was given or player tried to use their own, lolz
408         if (_affCode == '' || _affCode == plyr_[_pID].name)
409         {
410             // use last stored affiliate code
411             _affID = plyr_[_pID].laff;
412         
413         // if affiliate code was given
414         } else {
415             // get affiliate ID from aff Code
416             _affID = pIDxName_[_affCode];
417             
418             // if affID is not the same as previously stored
419             if (_affID != plyr_[_pID].laff)
420             {
421                 // update last affiliate
422                 plyr_[_pID].laff = _affID;
423             }
424         }
425                 
426         // reload core
427         reLoadCore(_pID, _affID, _eth, _eventData_);
428     }
429 
430     /**
431      * @dev withdraws all of your earnings.
432      * -functionhash- 0x3ccfd60b
433      */
434     function withdraw()
435         isActivated()
436         isHuman()
437         public
438     {        
439         // grab time
440         uint256 _now = now;
441         
442         // fetch player ID
443         uint256 _pID = pIDxAddr_[msg.sender];
444         
445         // setup temp var for player eth
446         uint256 _eth;
447         
448         // check to see if round has ended and no one has run round end yet
449         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
450         {
451             // set up our tx event data
452             LDdatasets.EventReturns memory _eventData_;
453             
454             // end the round (distributes pot)
455             round_.ended = true;
456             _eventData_ = endRound(_eventData_);
457             
458             // get their earnings
459             _eth = withdrawEarnings(_pID);
460             
461             // gib moni
462             if (_eth > 0)
463                 plyr_[_pID].addr.transfer(_eth);    
464             
465             // build event data
466             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
467             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
468             
469             // fire withdraw and distribute event
470             emit MonkeyEvents.onWithdrawAndDistribute
471             (
472                 msg.sender, 
473                 plyr_[_pID].name, 
474                 _eth, 
475                 _eventData_.compressedData, 
476                 _eventData_.compressedIDs, 
477                 _eventData_.winnerAddr, 
478                 _eventData_.winnerName, 
479                 _eventData_.amountWon, 
480                 _eventData_.newPot, 
481                 _eventData_.genAmount
482             );
483             
484         // in any other situation
485         } else {
486             // get their earnings
487             _eth = withdrawEarnings(_pID);
488             
489             // gib moni
490             if (_eth > 0)
491                 plyr_[_pID].addr.transfer(_eth);
492             
493             // fire withdraw event
494             emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
495         }
496     }
497     
498     /**
499      * @dev use these to register names.  they are just wrappers that will send the
500      * registration requests to the PlayerBook contract.  So registering here is the 
501      * same as registering there.  UI will always display the last name you registered.
502      * but you will still own all previously registered names to use as affiliate 
503      * links.
504      * - must pay a registration fee.
505      * - name must be unique
506      * - names will be converted to lowercase
507      * - name cannot start or end with a space 
508      * - cannot have more than 1 space in a row
509      * - cannot be only numbers
510      * - cannot start with 0x 
511      * - name must be at least 1 char
512      * - max length of 32 characters long
513      * - allowed characters: a-z, 0-9, and space
514      * -functionhash- 0x921dec21 (using ID for affiliate)
515      * -functionhash- 0x3ddd4698 (using address for affiliate)
516      * -functionhash- 0x685ffd83 (using name for affiliate)
517      * @param _nameString players desired name
518      * @param _affCode affiliate ID, address, or name of who referred you
519      * @param _all set to true if you want this to push your info to all games 
520      * (this might cost a lot of gas)
521      */
522     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
523         isHuman()
524         public
525         payable
526     {
527         bytes32 _name = _nameString.nameFilter();
528         address _addr = msg.sender;
529         uint256 _paid = msg.value;
530         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
531 
532         uint256 _pID = pIDxAddr_[_addr];
533         
534         // fire event
535         emit MonkeyEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
536     }
537     
538     function registerNameXaddr(string _nameString, address _affCode, bool _all)
539         isHuman()
540         public
541         payable
542     {
543         bytes32 _name = _nameString.nameFilter();
544         address _addr = msg.sender;
545         uint256 _paid = msg.value;
546         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
547         
548         uint256 _pID = pIDxAddr_[_addr];
549         
550         // fire event
551         emit MonkeyEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
552     }
553     
554     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
555         isHuman()
556         public
557         payable
558     {
559         bytes32 _name = _nameString.nameFilter();
560         address _addr = msg.sender;
561         uint256 _paid = msg.value;
562         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
563         
564         uint256 _pID = pIDxAddr_[_addr];
565         
566         // fire event
567         emit MonkeyEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
568     }
569 //==============================================================================
570 //     _  _ _|__|_ _  _ _  .
571 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
572 //=====_|=======================================================================
573     /**
574      * @dev return the price buyer will pay for next 1 individual key.
575      * -functionhash- 0x018a25e8
576      * @return price for next key bought (in wei format)
577      */
578     function getBuyPrice()
579         public 
580         view 
581         returns(uint256)
582     {          
583         // grab time
584         uint256 _now = now;
585         
586         // are we in a round?
587         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
588             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
589         else // rounds over.  need price for new round
590             return ( 75000000000000 ); // init
591     }
592     
593     /**
594      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
595      * provider
596      * -functionhash- 0xc7e284b8
597      * @return time left in seconds
598      */
599     function getTimeLeft()
600         public
601         view
602         returns(uint256)
603     {
604         // grab time
605         uint256 _now = now;
606         
607         if (_now < round_.end)
608             if (_now > round_.strt + rndGap_)
609                 return( (round_.end).sub(_now) );
610             else
611                 return( (round_.strt + rndGap_).sub(_now));
612         else
613             return(0);
614     }
615     
616     /**
617      * @dev returns player earnings per vaults 
618      * -functionhash- 0x63066434
619      * @return winnings vault
620      * @return general vault
621      * @return affiliate vault
622      */
623     function getPlayerVaults(uint256 _pID)
624         public
625         view
626         returns(uint256 ,uint256, uint256)
627     {
628         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
629         if (now > round_.end && round_.ended == false && round_.plyr != 0)
630         {
631             // if player is winner 
632             if (round_.plyr == _pID)
633             {
634                 return
635                 (
636                     (plyr_[_pID].win).add( ((round_.pot).mul(45)) / 100 ),
637                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)   ),
638                     plyr_[_pID].aff
639                 );
640             // if player is not the winner
641             } else {
642                 return
643                 (
644                     plyr_[_pID].win,
645                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask)  ),
646                     plyr_[_pID].aff
647                 );
648             }
649             
650         // if round is still going on, or round has ended and round end has been ran
651         } else {
652             return
653             (
654                 plyr_[_pID].win,
655                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
656                 plyr_[_pID].aff
657             );
658         }
659     }
660     
661     /**
662      * solidity hates stack limits.  this lets us avoid that hate 
663      */
664     function getPlayerVaultsHelper(uint256 _pID)
665         private
666         view
667         returns(uint256)
668     {
669         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
670     }
671     
672     /**
673      * @dev returns all current round info needed for front end
674      * -functionhash- 0x747dff42
675      * @return total keys
676      * @return time ends
677      * @return time started
678      * @return current pot 
679      * @return current player ID in lead 
680      * @return current player in leads address 
681      * @return current player in leads name
682      * @return airdrop tracker
683      * @return airdrop pot
684      */
685     function getCurrentRoundInfo()
686         public
687         view
688         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256)
689     {
690         return
691         (
692             round_.keys,              //0
693             round_.end,               //1
694             round_.strt,              //2
695             round_.pot,               //3
696             round_.plyr,              //4
697             plyr_[round_.plyr].addr,  //5
698             plyr_[round_.plyr].name,  //6
699             airDropTracker_,          //7
700             airDropPot_               //8
701         );
702     }
703 
704     /**
705      * @dev returns player info based on address.  if no address is given, it will 
706      * use msg.sender 
707      * -functionhash- 0xee0b5d8b
708      * @param _addr address of the player you want to lookup 
709      * @return player ID 
710      * @return player name
711      * @return keys owned (current round)
712      * @return winnings vault
713      * @return general vault 
714      * @return affiliate vault 
715      * @return player round eth
716      */
717     function getPlayerInfoByAddress(address _addr)
718         public 
719         view 
720         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
721     {
722         if (_addr == address(0))
723         {
724             _addr == msg.sender;
725         }
726         uint256 _pID = pIDxAddr_[_addr];
727         
728         return
729         (
730             _pID,                               //0
731             plyr_[_pID].name,                   //1
732             plyrRnds_[_pID].keys,         //2
733             plyr_[_pID].win,                    //3
734             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
735             plyr_[_pID].aff,                    //5
736             plyrRnds_[_pID].eth           //6
737         );
738     }
739 
740 //==============================================================================
741 //     _ _  _ _   | _  _ . _  .
742 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
743 //=====================_|=======================================================
744     /**
745      * @dev logic runs whenever a buy order is executed.  determines how to handle 
746      * incoming eth depending on if we are in an active round or not
747      */
748     function buyCore(uint256 _pID, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
749         private
750     {
751         // grab time
752         uint256 _now = now;
753         
754         // if round is active
755         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
756         {
757             // call core 
758             core(_pID, msg.value, _affID, _eventData_);
759         
760         // if round is not active     
761         } else {
762             // check to see if end round needs to be ran
763             if (_now > round_.end && round_.ended == false) 
764             {
765                 // end the round (distributes pot) & start new round
766                 round_.ended = true;
767                 _eventData_ = endRound(_eventData_);
768                 
769                 // build event data
770                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
771                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
772                 
773                 // fire buy and distribute event 
774                 emit MonkeyEvents.onBuyAndDistribute
775                 (
776                     msg.sender, 
777                     plyr_[_pID].name, 
778                     msg.value, 
779                     _eventData_.compressedData, 
780                     _eventData_.compressedIDs, 
781                     _eventData_.winnerAddr, 
782                     _eventData_.winnerName, 
783                     _eventData_.amountWon, 
784                     _eventData_.newPot, 
785                     _eventData_.genAmount
786                 );
787             }
788             
789             // put eth in players vault 
790             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
791         }
792     }
793     
794     /**
795      * @dev logic runs whenever a reload order is executed.  determines how to handle 
796      * incoming eth depending on if we are in an active round or not 
797      */
798     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, LDdatasets.EventReturns memory _eventData_)
799         private
800     {
801         // grab time
802         uint256 _now = now;
803         
804         // if round is active
805         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
806         {
807             // get earnings from all vaults and return unused to gen vault
808             // because we use a custom safemath library.  this will throw if player 
809             // tried to spend more eth than they have.
810             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
811             
812             // call core 
813             core(_pID, _eth, _affID, _eventData_);
814         
815         // if round is not active and end round needs to be ran   
816         } else if (_now > round_.end && round_.ended == false) {
817             // end the round (distributes pot) & start new round
818             round_.ended = true;
819             _eventData_ = endRound(_eventData_);
820                 
821             // build event data
822             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
823             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
824                 
825             // fire buy and distribute event 
826             emit MonkeyEvents.onReLoadAndDistribute
827             (
828                 msg.sender, 
829                 plyr_[_pID].name, 
830                 _eventData_.compressedData, 
831                 _eventData_.compressedIDs, 
832                 _eventData_.winnerAddr, 
833                 _eventData_.winnerName, 
834                 _eventData_.amountWon, 
835                 _eventData_.newPot, 
836                 _eventData_.genAmount
837             );
838         }
839     }
840     
841     /**
842      * @dev this is the core logic for any buy/reload that happens while a round 
843      * is live.
844      */
845     function core(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
846         private
847     {
848         // if player is new to round
849         if (plyrRnds_[_pID].keys == 0)
850             _eventData_ = managePlayer(_pID, _eventData_);
851         
852         // early round eth limiter 
853         if (round_.eth < 100000000000000000000 && plyrRnds_[_pID].eth.add(_eth) > 10000000000000000000)
854         {
855             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID].eth);
856             uint256 _refund = _eth.sub(_availableLimit);
857             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
858             _eth = _availableLimit;
859         }
860         
861         // if eth left is greater than min eth allowed (sorry no pocket lint)
862         if (_eth > 1000000000) 
863         {
864             
865             // mint the new keys
866             uint256 _keys = (round_.eth).keysRec(_eth);
867             
868             // if they bought at least 1 whole key
869             if (_keys >= 1000000000000000000)
870             {
871                 updateTimer(_keys);
872 
873                 // set new leaders
874                 if (round_.plyr != _pID)
875                     round_.plyr = _pID;  
876                 
877                 // set the new leader bool to true
878                 _eventData_.compressedData = _eventData_.compressedData + 100;
879             }
880             
881             // manage airdrops
882             if (_eth >= 100000000000000000)  // larger 0.1eth
883             {
884                 airDropTracker_++;
885                 if (airdrop() == true)
886                 {
887                     // gib muni
888                     uint256 _prize;
889                     if (_eth >= 10000000000000000000)  // larger 10eth
890                     {
891                         // calculate prize and give it to winner
892                         _prize = ((airDropPot_).mul(75)) / 100;
893                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
894                         
895                         // adjust airDropPot 
896                         airDropPot_ = (airDropPot_).sub(_prize);
897                         
898                         // let event know a tier 3 prize was won 
899                         _eventData_.compressedData += 300000000000000000000000000000000;
900                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
901                         // calculate prize and give it to winner
902                         _prize = ((airDropPot_).mul(50)) / 100;
903                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
904                         
905                         // adjust airDropPot 
906                         airDropPot_ = (airDropPot_).sub(_prize);
907                         
908                         // let event know a tier 2 prize was won 
909                         _eventData_.compressedData += 200000000000000000000000000000000;
910                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
911                         // calculate prize and give it to winner
912                         _prize = ((airDropPot_).mul(25)) / 100;
913                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
914                         
915                         // adjust airDropPot 
916                         airDropPot_ = (airDropPot_).sub(_prize);
917                         
918                         // let event know a tier 1 prize was won 
919                         _eventData_.compressedData += 100000000000000000000000000000000;
920                     }
921                     // set airdrop happened bool to true
922                     _eventData_.compressedData += 10000000000000000000000000000000;
923                     // let event know how much was won 
924                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
925                     
926                     // reset air drop tracker
927                     airDropTracker_ = 0;
928                 }
929             }
930     
931             // store the air drop tracker number (number of buys since last airdrop)
932             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
933             
934             // update player 
935             plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
936             plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
937             
938             // update round
939             round_.keys = _keys.add(round_.keys);
940             round_.eth = _eth.add(round_.eth);
941     
942             // distribute eth
943             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
944             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
945             
946             // call end tx function to fire end tx event.
947             endTx(_pID, _eth, _keys, _eventData_);
948         }
949     }
950 //==============================================================================
951 //     _ _ | _   | _ _|_ _  _ _  .
952 //    (_(_||(_|_||(_| | (_)| _\  .
953 //==============================================================================
954     /**
955      * @dev calculates unmasked earnings (just calculates, does not update mask)
956      * @return earnings in wei format
957      */
958     function calcUnMaskedEarnings(uint256 _pID)
959         private
960         view
961         returns(uint256)
962     {
963         return((((round_.mask).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask));
964     }
965     
966     /** 
967      * @dev returns the amount of keys you would get given an amount of eth. 
968      * -functionhash- 0xce89c80c
969      * @param _eth amount of eth sent in 
970      * @return keys received 
971      */
972     function calcKeysReceived(uint256 _eth)
973         public
974         view
975         returns(uint256)
976     {
977         // grab time
978         uint256 _now = now;
979         
980         // are we in a round?
981         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
982             return ( (round_.eth).keysRec(_eth) );
983         else // rounds over.  need keys for new round
984             return ( (_eth).keys() );
985     }
986     
987     /** 
988      * @dev returns current eth price for X keys.  
989      * -functionhash- 0xcf808000
990      * @param _keys number of keys desired (in 18 decimal format)
991      * @return amount of eth needed to send
992      */
993     function iWantXKeys(uint256 _keys)
994         public
995         view
996         returns(uint256)
997     {
998         // grab time
999         uint256 _now = now;
1000         
1001         // are we in a round?
1002         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1003             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1004         else // rounds over.  need price for new round
1005             return ( (_keys).eth() );
1006     }
1007 //==============================================================================
1008 //    _|_ _  _ | _  .
1009 //     | (_)(_)|_\  .
1010 //==============================================================================
1011     /**
1012      * @dev receives name/player info from names contract 
1013      */
1014     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1015         external
1016     {
1017         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1018         if (pIDxAddr_[_addr] != _pID)
1019             pIDxAddr_[_addr] = _pID;
1020         if (pIDxName_[_name] != _pID)
1021             pIDxName_[_name] = _pID;
1022         if (plyr_[_pID].addr != _addr)
1023             plyr_[_pID].addr = _addr;
1024         if (plyr_[_pID].name != _name)
1025             plyr_[_pID].name = _name;
1026         if (plyr_[_pID].laff != _laff)
1027             plyr_[_pID].laff = _laff;
1028         if (plyrNames_[_pID][_name] == false)
1029             plyrNames_[_pID][_name] = true;
1030     }
1031     
1032     /**
1033      * @dev receives entire player name list 
1034      */
1035     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1036         external
1037     {
1038         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1039         if(plyrNames_[_pID][_name] == false)
1040             plyrNames_[_pID][_name] = true;
1041     }   
1042         
1043     /**
1044      * @dev gets existing or registers new pID.  use this when a player may be new
1045      * @return pID 
1046      */
1047     function determinePID(LDdatasets.EventReturns memory _eventData_)
1048         private
1049         returns (LDdatasets.EventReturns)
1050     {
1051         uint256 _pID = pIDxAddr_[msg.sender];
1052         // if player is new to this version of ratscam
1053         if (_pID == 0)
1054         {
1055             // grab their player ID, name and last aff ID, from player names contract 
1056             _pID = PlayerBook.getPlayerID(msg.sender);
1057             bytes32 _name = PlayerBook.getPlayerName(_pID);
1058             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1059             
1060             // set up player account 
1061             pIDxAddr_[msg.sender] = _pID;
1062             plyr_[_pID].addr = msg.sender;
1063             
1064             if (_name != "")
1065             {
1066                 pIDxName_[_name] = _pID;
1067                 plyr_[_pID].name = _name;
1068                 plyrNames_[_pID][_name] = true;
1069             }
1070             
1071             if (_laff != 0 && _laff != _pID)
1072                 plyr_[_pID].laff = _laff;
1073             
1074             // set the new player bool to true
1075             _eventData_.compressedData = _eventData_.compressedData + 1;
1076         } 
1077         return (_eventData_);
1078     }
1079 
1080     /**
1081      * @dev decides if round end needs to be run & new round started.  and if 
1082      * player unmasked earnings from previously played rounds need to be moved.
1083      */
1084     function managePlayer(uint256 _pID, LDdatasets.EventReturns memory _eventData_)
1085         private
1086         returns (LDdatasets.EventReturns)
1087     {            
1088         // set the joined round bool to true
1089         _eventData_.compressedData = _eventData_.compressedData + 10;
1090         
1091         return(_eventData_);
1092     }
1093     
1094     /**
1095      * @dev ends the round. manages paying out winner/splitting up pot
1096      */
1097     function endRound(LDdatasets.EventReturns memory _eventData_)
1098         private
1099         returns (LDdatasets.EventReturns)
1100     {        
1101         // grab our winning player and team id's
1102         uint256 _winPID = round_.plyr;
1103         
1104         // grab our pot amount
1105         // add airdrop pot into the final pot
1106         uint256 _pot = round_.pot + airDropPot_;
1107         
1108         // calculate our winner share, community rewards, gen share, 
1109         uint256 _win = (_pot.mul(45)) / 100;  
1110         uint256 _com = (_pot / 10);
1111         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1112         
1113         // calculate ppt for round mask
1114         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1115         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1116         if (_dust > 0)
1117         {
1118             _gen = _gen.sub(_dust);
1119             _com = _com.add(_dust);
1120         }
1121         
1122         // pay our winner
1123         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1124         
1125         // community rewards
1126         if (!address(MonkeyKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1127         {
1128             _gen = _gen.add(_com);
1129             _com = 0;
1130         }
1131         
1132         // distribute gen portion to key holders
1133         round_.mask = _ppt.add(round_.mask);
1134             
1135         // prepare event data
1136         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1137         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1138         _eventData_.winnerAddr = plyr_[_winPID].addr;
1139         _eventData_.winnerName = plyr_[_winPID].name;
1140         _eventData_.amountWon = _win;
1141         _eventData_.genAmount = _gen;
1142         _eventData_.newPot = 0;
1143         
1144         return(_eventData_);
1145     }
1146     
1147     /**
1148      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1149      */
1150     function updateGenVault(uint256 _pID)
1151         private 
1152     {
1153         uint256 _earnings = calcUnMaskedEarnings(_pID);
1154         if (_earnings > 0)
1155         {
1156             // put in gen vault
1157             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1158             // zero out their earnings by updating mask
1159             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1160         }
1161     }
1162     
1163     /**
1164      * @dev updates round timer based on number of whole keys bought.
1165      */
1166     function updateTimer(uint256 _keys)
1167         private
1168     {
1169         // grab time
1170         uint256 _now = now;
1171         
1172         // calculate time based on number of keys bought
1173         uint256 _newTime;
1174         if (_now > round_.end && round_.plyr == 0)
1175             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1176         else
1177             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1178         
1179         // compare to max and set new end time
1180         if (_newTime < (rndMax_).add(_now))
1181             round_.end = _newTime;
1182         else
1183             round_.end = rndMax_.add(_now);
1184     }
1185     
1186     /**
1187      * @dev generates a random number between 0-99 and checks to see if thats
1188      * resulted in an airdrop win
1189      * @return do we have a winner?
1190      */
1191     function airdrop()
1192         private 
1193         view 
1194         returns(bool)
1195     {
1196         uint256 seed = uint256(keccak256(abi.encodePacked(
1197             
1198             (block.timestamp).add
1199             (block.difficulty).add
1200             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1201             (block.gaslimit).add
1202             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1203             (block.number)
1204             
1205         )));
1206         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1207             return(true);
1208         else
1209             return(false);
1210     }
1211 
1212     /**
1213      * @dev distributes eth based on fees to com, aff, and p3d
1214      */
1215     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
1216         private
1217         returns(LDdatasets.EventReturns)
1218     {
1219         // pay 5% out to community rewards
1220         uint256 _com = _eth * 5 / 100;
1221                 
1222         // distribute share to affiliate
1223         uint256 _aff = _eth / 10;
1224         
1225         // decide what to do with affiliate share of fees
1226         // affiliate must not be self, and must have a name registered
1227         if (_affID != _pID && plyr_[_affID].name != '') {
1228             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1229             emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1230         } else {
1231             // no affiliates, add to community
1232             _com += _aff;
1233         }
1234 
1235         if (!address(MonkeyKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1236         {
1237             // This ensures Team Just cannot influence the outcome of FoMo3D with
1238             // bank migrations by breaking outgoing transactions.
1239             // Something we would never do. But that's not the point.
1240             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1241             // highest belief that everything we create should be trustless.
1242             // Team JUST, The name you shouldn't have to trust.
1243         }
1244 
1245         return(_eventData_);
1246     }
1247     
1248     /**
1249      * @dev distributes eth based on fees to gen and pot
1250      */
1251     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, LDdatasets.EventReturns memory _eventData_)
1252         private
1253         returns(LDdatasets.EventReturns)
1254     {
1255         // calculate gen share
1256         uint256 _gen = (_eth.mul(fees_)) / 100;
1257         
1258         // toss 5% into airdrop pot 
1259         uint256 _air = (_eth / 20);
1260         airDropPot_ = airDropPot_.add(_air);
1261                 
1262         // calculate pot (20%) 
1263         uint256 _pot = (_eth.mul(20) / 100);
1264         
1265         // distribute gen share (thats what updateMasks() does) and adjust
1266         // balances for dust.
1267         uint256 _dust = updateMasks(_pID, _gen, _keys);
1268         if (_dust > 0)
1269             _gen = _gen.sub(_dust);
1270         
1271         // add eth to pot
1272         round_.pot = _pot.add(_dust).add(round_.pot);
1273         
1274         // set up event data
1275         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1276         _eventData_.potAmount = _pot;
1277         
1278         return(_eventData_);
1279     }
1280 
1281     /**
1282      * @dev updates masks for round and player when keys are bought
1283      * @return dust left over 
1284      */
1285     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1286         private
1287         returns(uint256)
1288     {
1289         /* MASKING NOTES
1290             earnings masks are a tricky thing for people to wrap their minds around.
1291             the basic thing to understand here.  is were going to have a global
1292             tracker based on profit per share for each round, that increases in
1293             relevant proportion to the increase in share supply.
1294             
1295             the player will have an additional mask that basically says "based
1296             on the rounds mask, my shares, and how much i've already withdrawn,
1297             how much is still owed to me?"
1298         */
1299         
1300         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1301         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1302         round_.mask = _ppt.add(round_.mask);
1303             
1304         // calculate player earning from their own buy (only based on the keys
1305         // they just bought).  & update player earnings mask
1306         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1307         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1308         
1309         // calculate & return dust
1310         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1311     }
1312     
1313     /**
1314      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1315      * @return earnings in wei format
1316      */
1317     function withdrawEarnings(uint256 _pID)
1318         private
1319         returns(uint256)
1320     {
1321         // update gen vault
1322         updateGenVault(_pID);
1323         
1324         // from vaults 
1325         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1326         if (_earnings > 0)
1327         {
1328             plyr_[_pID].win = 0;
1329             plyr_[_pID].gen = 0;
1330             plyr_[_pID].aff = 0;
1331         }
1332 
1333         return(_earnings);
1334     }
1335     
1336     /**
1337      * @dev prepares compression data and fires event for buy or reload tx's
1338      */
1339     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, LDdatasets.EventReturns memory _eventData_)
1340         private
1341     {
1342         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1343         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1344         
1345         emit MonkeyEvents.onEndTx
1346         (
1347             _eventData_.compressedData,
1348             _eventData_.compressedIDs,
1349             plyr_[_pID].name,
1350             msg.sender,
1351             _eth,
1352             _keys,
1353             _eventData_.winnerAddr,
1354             _eventData_.winnerName,
1355             _eventData_.amountWon,
1356             _eventData_.newPot,
1357             _eventData_.genAmount,
1358             _eventData_.potAmount,
1359             airDropPot_
1360         );
1361     }
1362 
1363     /** upon contract deploy, it will be deactivated.  this is a one time
1364      * use function that will activate the contract.  we do this so devs 
1365      * have time to set things up on the web end                            **/
1366     bool public activated_ = false;
1367     function activate()
1368         public
1369     {
1370         // only owner can activate 
1371         // TODO: set owner
1372         require(
1373             msg.sender == 0xa2d917811698d92D7FF80ed988775F274a51b435,
1374             "only owner can activate"
1375         );
1376         
1377         // can only be ran once
1378         require(activated_ == false, "dogscam already activated");
1379         
1380         // activate the contract 
1381         activated_ = true;
1382         
1383         round_.strt = now - rndGap_;
1384         round_.end = now + rndInit_;
1385     }
1386 }
1387 
1388 //==============================================================================
1389 //   __|_ _    __|_ _  .
1390 //  _\ | | |_|(_ | _\  .
1391 //==============================================================================
1392 library LDdatasets {
1393     //compressedData key
1394     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1395         // 0 - new player (bool)
1396         // 1 - joined round (bool)
1397         // 2 - new  leader (bool)
1398         // 3-5 - air drop tracker (uint 0-999)
1399         // 6-16 - round end time
1400         // 17 - winnerTeam
1401         // 18 - 28 timestamp 
1402         // 29 - team
1403         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1404         // 31 - airdrop happened bool
1405         // 32 - airdrop tier 
1406         // 33 - airdrop amount won
1407     //compressedIDs key
1408     // [77-52][51-26][25-0]
1409         // 0-25 - pID 
1410         // 26-51 - winPID
1411         // 52-77 - rID
1412     struct EventReturns {
1413         uint256 compressedData;
1414         uint256 compressedIDs;
1415         address winnerAddr;         // winner address
1416         bytes32 winnerName;         // winner name
1417         uint256 amountWon;          // amount won
1418         uint256 newPot;             // amount in new pot
1419         uint256 genAmount;          // amount distributed to gen
1420         uint256 potAmount;          // amount added to pot
1421     }
1422     struct Player {
1423         address addr;   // player address
1424         bytes32 name;   // player name
1425         uint256 win;    // winnings vault
1426         uint256 gen;    // general vault
1427         uint256 aff;    // affiliate vault
1428         uint256 laff;   // last affiliate id used
1429     }
1430     struct PlayerRounds {
1431         uint256 eth;    // eth player has added to round (used for eth limiter)
1432         uint256 keys;   // keys
1433         uint256 mask;   // player mask 
1434     }
1435     struct Round {
1436         uint256 plyr;   // pID of player in lead
1437         uint256 end;    // time ends/ended
1438         bool ended;     // has round end function been ran
1439         uint256 strt;   // time round started
1440         uint256 keys;   // keys
1441         uint256 eth;    // total eth in
1442         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1443         uint256 mask;   // global mask
1444     }
1445 }
1446 
1447 //==============================================================================
1448 //  |  _      _ _ | _  .
1449 //  |<(/_\/  (_(_||(_  .
1450 //=======/======================================================================
1451 library LDKeysCalc {
1452     using SafeMath for *;
1453     /**
1454      * @dev calculates number of keys received given X eth 
1455      * @param _curEth current amount of eth in contract 
1456      * @param _newEth eth being spent
1457      * @return amount of ticket purchased
1458      */
1459     function keysRec(uint256 _curEth, uint256 _newEth)
1460         internal
1461         pure
1462         returns (uint256)
1463     {
1464         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1465     }
1466     
1467     /**
1468      * @dev calculates amount of eth received if you sold X keys 
1469      * @param _curKeys current amount of keys that exist 
1470      * @param _sellKeys amount of keys you wish to sell
1471      * @return amount of eth received
1472      */
1473     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1474         internal
1475         pure
1476         returns (uint256)
1477     {
1478         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1479     }
1480 
1481     /**
1482      * @dev calculates how many keys would exist with given an amount of eth
1483      * @param _eth eth "in contract"
1484      * @return number of keys that would exist
1485      */
1486     function keys(uint256 _eth) 
1487         internal
1488         pure
1489         returns(uint256)
1490     {
1491         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1492     }
1493     
1494     /**
1495      * @dev calculates how much eth would be in contract given a number of keys
1496      * @param _keys number of keys "in contract" 
1497      * @return eth that would exists
1498      */
1499     function eth(uint256 _keys) 
1500         internal
1501         pure
1502         returns(uint256)  
1503     {
1504         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1505     }
1506 }
1507 
1508 interface MonkeyInterfaceForForwarder {
1509     function deposit() external payable returns(bool);
1510 }
1511 
1512 interface PlayerBookInterface {
1513     function getPlayerID(address _addr) external returns (uint256);
1514     function getPlayerName(uint256 _pID) external view returns (bytes32);
1515     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1516     function getPlayerAddr(uint256 _pID) external view returns (address);
1517     function getNameFee() external view returns (uint256);
1518     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1519     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1520     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1521 }
1522 
1523 library NameFilter {
1524     /**
1525      * @dev filters name strings
1526      * -converts uppercase to lower case.  
1527      * -makes sure it does not start/end with a space
1528      * -makes sure it does not contain multiple spaces in a row
1529      * -cannot be only numbers
1530      * -cannot start with 0x 
1531      * -restricts characters to A-Z, a-z, 0-9, and space.
1532      * @return reprocessed string in bytes32 format
1533      */
1534     function nameFilter(string _input)
1535         internal
1536         pure
1537         returns(bytes32)
1538     {
1539         bytes memory _temp = bytes(_input);
1540         uint256 _length = _temp.length;
1541         
1542         //sorry limited to 32 characters
1543         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1544         // make sure it doesnt start with or end with space
1545         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1546         // make sure first two characters are not 0x
1547         if (_temp[0] == 0x30)
1548         {
1549             require(_temp[1] != 0x78, "string cannot start with 0x");
1550             require(_temp[1] != 0x58, "string cannot start with 0X");
1551         }
1552         
1553         // create a bool to track if we have a non number character
1554         bool _hasNonNumber;
1555         
1556         // convert & check
1557         for (uint256 i = 0; i < _length; i++)
1558         {
1559             // if its uppercase A-Z
1560             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1561             {
1562                 // convert to lower case a-z
1563                 _temp[i] = byte(uint(_temp[i]) + 32);
1564                 
1565                 // we have a non number
1566                 if (_hasNonNumber == false)
1567                     _hasNonNumber = true;
1568             } else {
1569                 require
1570                 (
1571                     // require character is a space
1572                     _temp[i] == 0x20 || 
1573                     // OR lowercase a-z
1574                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1575                     // or 0-9
1576                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1577                     "string contains invalid characters"
1578                 );
1579                 // make sure theres not 2x spaces in a row
1580                 if (_temp[i] == 0x20)
1581                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1582                 
1583                 // see if we have a character other than a number
1584                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1585                     _hasNonNumber = true;    
1586             }
1587         }
1588         
1589         require(_hasNonNumber == true, "string cannot be only numbers");
1590         
1591         bytes32 _ret;
1592         assembly {
1593             _ret := mload(add(_temp, 32))
1594         }
1595         return (_ret);
1596     }
1597 }
1598 
1599 /**
1600  * @title SafeMath v0.1.9
1601  * @dev Math operations with safety checks that throw on error
1602  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1603  * - added sqrt
1604  * - added sq
1605  * - changed asserts to requires with error log outputs
1606  * - removed div, its useless
1607  */
1608 library SafeMath {
1609     
1610     /**
1611     * @dev Multiplies two numbers, throws on overflow.
1612     */
1613     function mul(uint256 a, uint256 b) 
1614         internal 
1615         pure 
1616         returns (uint256 c) 
1617     {
1618         if (a == 0) {
1619             return 0;
1620         }
1621         c = a * b;
1622         require(c / a == b, "SafeMath mul failed");
1623         return c;
1624     }
1625 
1626     /**
1627     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1628     */
1629     function sub(uint256 a, uint256 b)
1630         internal
1631         pure
1632         returns (uint256) 
1633     {
1634         require(b <= a, "SafeMath sub failed");
1635         return a - b;
1636     }
1637 
1638     /**
1639     * @dev Adds two numbers, throws on overflow.
1640     */
1641     function add(uint256 a, uint256 b)
1642         internal
1643         pure
1644         returns (uint256 c) 
1645     {
1646         c = a + b;
1647         require(c >= a, "SafeMath add failed");
1648         return c;
1649     }
1650 
1651     /**
1652      * @dev gives square root of given x.
1653      */
1654     function sqrt(uint256 x)
1655         internal
1656         pure
1657         returns (uint256 y) 
1658     {
1659         uint256 z = ((add(x,1)) / 2);
1660         y = x;
1661         while (z < y) 
1662         {
1663             y = z;
1664             z = ((add((x / z),z)) / 2);
1665         }
1666     }
1667 
1668     /**
1669      * @dev gives square. multiplies x by x
1670      */
1671     function sq(uint256 x)
1672         internal
1673         pure
1674         returns (uint256)
1675     {
1676         return (mul(x,x));
1677     }
1678 }