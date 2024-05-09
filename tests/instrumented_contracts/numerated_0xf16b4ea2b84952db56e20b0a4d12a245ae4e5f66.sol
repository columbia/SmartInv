1 pragma solidity ^0.4.24;
2 //==============================================================================
3 //     _    _  _ _|_ _  .
4 //    (/_\/(/_| | | _\  .
5 //==============================================================================
6 contract BBTevents {
7     // fired whenever a player registers a name
8     event onNewName
9     (
10         uint256 indexed playerID,
11         address indexed playerAddress,
12         bytes32 indexed playerName,
13         bool isNewPlayer,
14         uint256 affiliateID,
15         address affiliateAddress,
16         bytes32 affiliateName,
17         uint256 amountPaid,
18         uint256 timeStamp
19     );
20     
21     // fired at end of buy or reload
22     event onEndTx
23     (
24         uint256 compressedData,     
25         uint256 compressedIDs,      
26         bytes32 playerName,
27         address playerAddress,
28         uint256 ethIn,
29         uint256 keysBought,
30         address winnerAddr,
31         bytes32 winnerName,
32         uint256 amountWon,
33         uint256 newPot,
34         uint256 BBTAmount,
35         uint256 genAmount,
36         uint256 potAmount,
37         uint256 airDropPot
38     );
39     
40     // fired whenever theres a withdraw
41     event onWithdraw
42     (
43         uint256 indexed playerID,
44         address playerAddress,
45         bytes32 playerName,
46         uint256 ethOut,
47         uint256 timeStamp
48     );
49     
50     // fired whenever a withdraw forces end round to be ran
51     event onWithdrawAndDistribute
52     (
53         address playerAddress,
54         bytes32 playerName,
55         uint256 ethOut,
56         uint256 compressedData,
57         uint256 compressedIDs,
58         address winnerAddr,
59         bytes32 winnerName,
60         uint256 amountWon,
61         uint256 newPot,
62         uint256 BBTAmount,
63         uint256 genAmount
64     );
65     
66     // (fomo3d long only) fired whenever a player tries a buy after round timer 
67     // hit zero, and causes end round to be ran.
68     event onBuyAndDistribute
69     (
70         address playerAddress,
71         bytes32 playerName,
72         uint256 ethIn,
73         uint256 compressedData,
74         uint256 compressedIDs,
75         address winnerAddr,
76         bytes32 winnerName,
77         uint256 amountWon,
78         uint256 newPot,
79         uint256 BBTAmount,
80         uint256 genAmount
81     );
82     
83     // (fomo3d long only) fired whenever a player tries a reload after round timer 
84     // hit zero, and causes end round to be ran.
85     event onReLoadAndDistribute
86     (
87         address playerAddress,
88         bytes32 playerName,
89         uint256 compressedData,
90         uint256 compressedIDs,
91         address winnerAddr,
92         bytes32 winnerName,
93         uint256 amountWon,
94         uint256 newPot,
95         uint256 BBTAmount,
96         uint256 genAmount
97     );
98     
99     // fired whenever an affiliate is paid
100     event onAffiliatePayout
101     (
102         uint256 indexed affiliateID,
103         address affiliateAddress,
104         bytes32 affiliateName,
105         uint256 indexed roundID,
106         uint256 indexed buyerID,
107         uint256 amount,
108         uint256 timeStamp
109     );
110     
111     // received pot swap deposit
112     event onPotSwapDeposit
113     (
114         uint256 roundID,
115         uint256 amountAddedToPot
116     );
117 }
118 
119 //==============================================================================
120 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
121 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
122 //====================================|=========================================
123 
124 contract modularBBT is BBTevents {}
125 
126 contract DIZHU is modularBBT {
127     using SafeMath for *;
128     using NameFilter for string;
129     using BBTKeysCalcLong for uint256;
130     
131     address constant private BBTAddress = 0x20aAc60C7f52D062f703AAE653BB931647c4f572;
132     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xf628099229Fae56F0fFBe7140A41d3820a1248F1);
133 //==============================================================================
134 //     _ _  _  |`. _     _ _ |_ | _  _  .
135 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
136 //=================_|===========================================================
137     string constant public name = "LandOwner VS Peasant";
138     string constant public symbol = "Land";
139     uint256 constant private rndGap_ = 0 minutes;         // length of ICO phase, set to 1 year for EOS.
140     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
141     uint256 constant private rndInc_ = 1 minutes;              // every full key purchased adds this much to the timer
142     uint256 constant private rndMax_ = 2 hours;                // max length a round timer can be
143 //==============================================================================
144 //     _| _ _|_ _    _ _ _|_    _   .
145 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
146 //=============================|================================================
147     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
148     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
149     uint256 public rID_;    // round id number / total rounds that have happened
150 //****************
151 // PLAYER DATA 
152 //****************
153     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
154     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
155     mapping (uint256 => BBTdatasets.Player) public plyr_;   // (pID => data) player data
156     mapping (uint256 => mapping (uint256 => BBTdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
157     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
158 //****************
159 // ROUND DATA 
160 //****************
161     mapping (uint256 => BBTdatasets.Round) public round_;   // (rID => data) round data
162     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
163 //****************
164 // TEAM FEE DATA 
165 //****************
166     mapping (uint256 => BBTdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
167     mapping (uint256 => BBTdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
168 //==============================================================================
169 //     _ _  _  __|_ _    __|_ _  _  .
170 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
171 //==============================================================================
172     constructor()
173         public
174     {
175         // Team allocation structures
176         // 0 = farmer
177         // 1 = landowner
178 
179         // Team allocation percentages
180         // (KEY, BBT) + (Pot , Referrals, Community)
181             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
182         fees_[0] = BBTdatasets.TeamFee(45,20);   //15% to pot, 10% to aff,  10% to air drop pot
183         fees_[1] = BBTdatasets.TeamFee(15,20);   //45% to pot, 10% to aff,  10% to air drop pot
184         
185         // how to split up the final pot based on which team was picked
186         // (KEY, BBT)
187         potSplit_[0] = BBTdatasets.PotSplit(30,10);  //50% to winner, 10% to next round, 
188         potSplit_[1] = BBTdatasets.PotSplit(10,10);   //50% to winner, 30% to next round,
189     }
190 //==============================================================================
191 //     _ _  _  _|. |`. _  _ _  .
192 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
193 //==============================================================================
194     /**
195      * @dev used to make sure no one can interact with contract until it has 
196      * been activated. 
197      */
198     modifier isActivated() {
199         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
200         _;
201     }
202     
203     /**
204      * @dev prevents contracts from interacting with fomo3d 
205      */
206     modifier isHuman() {
207         address _addr = msg.sender;
208         uint256 _codeLength;
209         
210         assembly {_codeLength := extcodesize(_addr)}
211         require(_codeLength == 0, "sorry humans only");
212         _;
213     }
214 
215     /**
216      * @dev sets boundaries for incoming tx 
217      */
218     modifier isWithinLimits(uint256 _eth) {
219         require(_eth >= 1000000000, "pocket lint: not a valid currency");
220         require(_eth <= 100000000000000000000000, "no vitalik, no");
221         _;    
222     }
223     
224 //==============================================================================
225 //     _    |_ |. _   |`    _  __|_. _  _  _  .
226 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
227 //====|=========================================================================
228     /**
229      * @dev emergency buy uses last stored affiliate ID and team snek
230      */
231     function()
232         isActivated()
233         isHuman()
234         isWithinLimits(msg.value)
235         public
236         payable
237     {
238         // set up our tx event data and determine if player is new or not
239         BBTdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
240             
241         // fetch player id
242         uint256 _pID = pIDxAddr_[msg.sender];
243         
244         // buy core 
245         buyCore(_pID, plyr_[_pID].laff, 0, _eventData_);
246     }
247     
248     /**
249      * @dev converts all incoming ethereum to keys.
250      * -functionhash- 0x8f38f309 (using ID for affiliate)
251      * -functionhash- 0x98a0871d (using address for affiliate)
252      * -functionhash- 0xa65b37a1 (using name for affiliate)
253      * @param _affCode the ID/address/name of the player who gets the affiliate fee
254      * @param _team what team is the player playing for?
255      */
256     function buyXid(uint256 _affCode, uint256 _team)
257         isActivated()
258         isHuman()
259         isWithinLimits(msg.value)
260         public
261         payable
262     {
263         // set up our tx event data and determine if player is new or not
264         BBTdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
265         
266         // fetch player id
267         uint256 _pID = pIDxAddr_[msg.sender];
268         
269         // manage affiliate residuals
270         // if no affiliate code was given or player tried to use their own, lolz
271         if (_affCode == 0 || _affCode == _pID)
272         {
273             // use last stored affiliate code 
274             _affCode = plyr_[_pID].laff;
275             
276         // if affiliate code was given & its not the same as previously stored 
277         } else if (_affCode != plyr_[_pID].laff) {
278             // update last affiliate 
279             plyr_[_pID].laff = _affCode;
280         }
281         
282         // verify a valid team was selected
283         _team = verifyTeam(_team);
284         
285         // buy core 
286         buyCore(_pID, _affCode, _team, _eventData_);
287     }
288     
289     function buyXaddr(address _affCode, uint256 _team)
290         isActivated()
291         isHuman()
292         isWithinLimits(msg.value)
293         public
294         payable
295     {
296         // set up our tx event data and determine if player is new or not
297         BBTdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
298         
299         // fetch player id
300         uint256 _pID = pIDxAddr_[msg.sender];
301         
302         // manage affiliate residuals
303         uint256 _affID;
304         // if no affiliate code was given or player tried to use their own, lolz
305         if (_affCode == address(0) || _affCode == msg.sender)
306         {
307             // use last stored affiliate code
308             _affID = plyr_[_pID].laff;
309         
310         // if affiliate code was given    
311         } else {
312             // get affiliate ID from aff Code 
313             _affID = pIDxAddr_[_affCode];
314             
315             // if affID is not the same as previously stored 
316             if (_affID != plyr_[_pID].laff)
317             {
318                 // update last affiliate
319                 plyr_[_pID].laff = _affID;
320             }
321         }
322         
323         // verify a valid team was selected
324         _team = verifyTeam(_team);
325         
326         // buy core 
327         buyCore(_pID, _affID, _team, _eventData_);
328     }
329     
330     function buyXname(bytes32 _affCode, uint256 _team)
331         isActivated()
332         isHuman()
333         isWithinLimits(msg.value)
334         public
335         payable
336     {
337         // set up our tx event data and determine if player is new or not
338         BBTdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
339         
340         // fetch player id
341         uint256 _pID = pIDxAddr_[msg.sender];
342         
343         // manage affiliate residuals
344         uint256 _affID;
345         // if no affiliate code was given or player tried to use their own, lolz
346         if (_affCode == '' || _affCode == plyr_[_pID].name)
347         {
348             // use last stored affiliate code
349             _affID = plyr_[_pID].laff;
350         
351         // if affiliate code was given
352         } else {
353             // get affiliate ID from aff Code
354             _affID = pIDxName_[_affCode];
355             
356             // if affID is not the same as previously stored
357             if (_affID != plyr_[_pID].laff)
358             {
359                 // update last affiliate
360                 plyr_[_pID].laff = _affID;
361             }
362         }
363         
364         // verify a valid team was selected
365         _team = verifyTeam(_team);
366         
367         // buy core 
368         buyCore(_pID, _affID, _team, _eventData_);
369     }
370     
371     /**
372      * @dev essentially the same as buy, but instead of you sending ether 
373      * from your wallet, it uses your unwithdrawn earnings.
374      * -functionhash- 0x349cdcac (using ID for affiliate)
375      * -functionhash- 0x82bfc739 (using address for affiliate)
376      * -functionhash- 0x079ce327 (using name for affiliate)
377      * @param _affCode the ID/address/name of the player who gets the affiliate fee
378      * @param _team what team is the player playing for?
379      * @param _eth amount of earnings to use (remainder returned to gen vault)
380      */
381     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
382         isActivated()
383         isHuman()
384         isWithinLimits(_eth)
385         public
386     {
387         // set up our tx event data
388         BBTdatasets.EventReturns memory _eventData_;
389         
390         // fetch player ID
391         uint256 _pID = pIDxAddr_[msg.sender];
392         
393         // manage affiliate residuals
394         // if no affiliate code was given or player tried to use their own, lolz
395         if (_affCode == 0 || _affCode == _pID)
396         {
397             // use last stored affiliate code 
398             _affCode = plyr_[_pID].laff;
399             
400         // if affiliate code was given & its not the same as previously stored 
401         } else if (_affCode != plyr_[_pID].laff) {
402             // update last affiliate 
403             plyr_[_pID].laff = _affCode;
404         }
405 
406         // verify a valid team was selected
407         _team = verifyTeam(_team);
408 
409         // reload core
410         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
411     }
412     
413     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
414         isActivated()
415         isHuman()
416         isWithinLimits(_eth)
417         public
418     {
419         // set up our tx event data
420         BBTdatasets.EventReturns memory _eventData_;
421         
422         // fetch player ID
423         uint256 _pID = pIDxAddr_[msg.sender];
424         
425         // manage affiliate residuals
426         uint256 _affID;
427         // if no affiliate code was given or player tried to use their own, lolz
428         if (_affCode == address(0) || _affCode == msg.sender)
429         {
430             // use last stored affiliate code
431             _affID = plyr_[_pID].laff;
432         
433         // if affiliate code was given    
434         } else {
435             // get affiliate ID from aff Code 
436             _affID = pIDxAddr_[_affCode];
437             
438             // if affID is not the same as previously stored 
439             if (_affID != plyr_[_pID].laff)
440             {
441                 // update last affiliate
442                 plyr_[_pID].laff = _affID;
443             }
444         }
445         
446         // verify a valid team was selected
447         _team = verifyTeam(_team);
448         
449         // reload core
450         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
451     }
452     
453     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
454         isActivated()
455         isHuman()
456         isWithinLimits(_eth)
457         public
458     {
459         // set up our tx event data
460         BBTdatasets.EventReturns memory _eventData_;
461         
462         // fetch player ID
463         uint256 _pID = pIDxAddr_[msg.sender];
464         
465         // manage affiliate residuals
466         uint256 _affID;
467         // if no affiliate code was given or player tried to use their own, lolz
468         if (_affCode == '' || _affCode == plyr_[_pID].name)
469         {
470             // use last stored affiliate code
471             _affID = plyr_[_pID].laff;
472         
473         // if affiliate code was given
474         } else {
475             // get affiliate ID from aff Code
476             _affID = pIDxName_[_affCode];
477             
478             // if affID is not the same as previously stored
479             if (_affID != plyr_[_pID].laff)
480             {
481                 // update last affiliate
482                 plyr_[_pID].laff = _affID;
483             }
484         }
485         
486         // verify a valid team was selected
487         _team = verifyTeam(_team);
488         
489         // reload core
490         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
491     }
492 
493     /**
494      * @dev withdraws all of your earnings.
495      * -functionhash- 0x3ccfd60b
496      */
497     function withdraw()
498         isActivated()
499         isHuman()
500         public
501     {
502         // setup local rID 
503         uint256 _rID = rID_;
504         
505         // grab time
506         uint256 _now = now;
507         
508         // fetch player ID
509         uint256 _pID = pIDxAddr_[msg.sender];
510         
511         // setup temp var for player eth
512         uint256 _eth;
513         
514         // check to see if round has ended and no one has run round end yet
515         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
516         {
517             // set up our tx event data
518             BBTdatasets.EventReturns memory _eventData_;
519             
520             // end the round (distributes pot)
521             round_[_rID].ended = true;
522             _eventData_ = endRound(_eventData_);
523             
524             // get their earnings
525             _eth = withdrawEarnings(_pID);
526             
527             // gib moni
528             if (_eth > 0)
529                 plyr_[_pID].addr.transfer(_eth);    
530             
531             // build event data
532             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
533             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
534             
535             // fire withdraw and distribute event
536             emit BBTevents.onWithdrawAndDistribute
537             (
538                 msg.sender, 
539                 plyr_[_pID].name, 
540                 _eth, 
541                 _eventData_.compressedData, 
542                 _eventData_.compressedIDs, 
543                 _eventData_.winnerAddr, 
544                 _eventData_.winnerName, 
545                 _eventData_.amountWon, 
546                 _eventData_.newPot, 
547                 _eventData_.BBTAmount, 
548                 _eventData_.genAmount
549             );
550             
551         // in any other situation
552         } else {
553             // get their earnings
554             _eth = withdrawEarnings(_pID);
555             
556             // gib moni
557             if (_eth > 0)
558                 plyr_[_pID].addr.transfer(_eth);
559             
560             // fire withdraw event
561             emit BBTevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
562         }
563     }
564     
565     /**
566      * @dev use these to register names.  they are just wrappers that will send the
567      * registration requests to the PlayerBook contract.  So registering here is the 
568      * same as registering there.  UI will always display the last name you registered.
569      * but you will still own all previously registered names to use as affiliate 
570      * links.
571      * - must pay a registration fee.
572      * - name must be unique
573      * - names will be converted to lowercase
574      * - name cannot start or end with a space 
575      * - cannot have more than 1 space in a row
576      * - cannot be only numbers
577      * - cannot start with 0x 
578      * - name must be at least 1 char
579      * - max length of 32 characters long
580      * - allowed characters: a-z, 0-9, and space
581      * -functionhash- 0x921dec21 (using ID for affiliate)
582      * -functionhash- 0x3ddd4698 (using address for affiliate)
583      * -functionhash- 0x685ffd83 (using name for affiliate)
584      * @param _nameString players desired name
585      * @param _affCode affiliate ID, address, or name of who referred you
586      * @param _all set to true if you want this to push your info to all games 
587      * (this might cost a lot of gas)
588      */
589     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
590         isHuman()
591         public
592         payable
593     {
594         bytes32 _name = _nameString.nameFilter();
595         address _addr = msg.sender;
596         uint256 _paid = msg.value;
597         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
598         
599         uint256 _pID = pIDxAddr_[_addr];
600         
601         // fire event
602         emit BBTevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
603     }
604     
605     function registerNameXaddr(string _nameString, address _affCode, bool _all)
606         isHuman()
607         public
608         payable
609     {
610         bytes32 _name = _nameString.nameFilter();
611         address _addr = msg.sender;
612         uint256 _paid = msg.value;
613         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
614         
615         uint256 _pID = pIDxAddr_[_addr];
616         
617         // fire event
618         emit BBTevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
619     }
620     
621     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
622         isHuman()
623         public
624         payable
625     {
626         bytes32 _name = _nameString.nameFilter();
627         address _addr = msg.sender;
628         uint256 _paid = msg.value;
629         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
630         
631         uint256 _pID = pIDxAddr_[_addr];
632         
633         // fire event
634         emit BBTevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
635     }
636 //==============================================================================
637 //     _  _ _|__|_ _  _ _  .
638 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
639 //=====_|=======================================================================
640     /**
641      * @dev return the price buyer will pay for next 1 individual key.
642      * -functionhash- 0x018a25e8
643      * @return price for next key bought (in wei format)
644      */
645     function getBuyPrice()
646         public 
647         view 
648         returns(uint256)
649     {  
650         // setup local rID
651         uint256 _rID = rID_;
652         
653         // grab time
654         uint256 _now = now;
655         
656         // are we in a round?
657         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
658             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
659         else // rounds over.  need price for new round
660             return ( 100000000000000 ); // init
661     }
662     
663     /**
664      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
665      * provider
666      * -functionhash- 0xc7e284b8
667      * @return time left in seconds
668      */
669     function getTimeLeft()
670         public
671         view
672         returns(uint256)
673     {
674         // setup local rID
675         uint256 _rID = rID_;
676         
677         // grab time
678         uint256 _now = now;
679         
680         if (_now < round_[_rID].end)
681             if (_now > round_[_rID].strt + rndGap_)
682                 return( (round_[_rID].end).sub(_now) );
683             else
684                 return( (round_[_rID].strt + rndGap_).sub(_now) );
685         else
686             return(0);
687     }
688     
689     /**
690      * @dev returns player earnings per vaults 
691      * -functionhash- 0x63066434
692      * @return winnings vault
693      * @return general vault
694      * @return affiliate vault
695      */
696     function getPlayerVaults(uint256 _pID)
697         public
698         view
699         returns(uint256 ,uint256, uint256)
700     {
701         // setup local rID
702         uint256 _rID = rID_;
703         
704         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
705         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
706         {
707             // if player is winner 
708             if (round_[_rID].plyr == _pID)
709             {
710                 return
711                 (
712                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(50)) / 100 ),
713                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
714                     plyr_[_pID].aff
715                 );
716             // if player is not the winner
717             } else {
718                 return
719                 (
720                     plyr_[_pID].win,
721                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
722                     plyr_[_pID].aff
723                 );
724             }
725             
726         // if round is still going on, or round has ended and round end has been ran
727         } else {
728             return
729             (
730                 plyr_[_pID].win,
731                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
732                 plyr_[_pID].aff
733             );
734         }
735     }
736     
737     /**
738      * solidity hates stack limits.  this lets us avoid that hate 
739      */
740     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
741         private
742         view
743         returns(uint256)
744     {
745         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
746     }
747     
748     /**
749      * @dev returns all current round info needed for front end
750      * -functionhash- 0x747dff42
751      * @return eth invested during ICO phase
752      * @return round id 
753      * @return total keys for round 
754      * @return time round ends
755      * @return time round started
756      * @return current pot 
757      * @return current team ID & player ID in lead 
758      * @return current player in leads address 
759      * @return current player in leads name
760      * @return farmer eth in for round
761      * @return landowner eth in for round
762      * @return airdrop tracker # & airdrop pot
763      */
764     function getCurrentRoundInfo()
765         public
766         view
767         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256)
768     {
769         // setup local rID
770         uint256 _rID = rID_;
771         
772         return
773         (
774             round_[_rID].ico,               //0
775             _rID,                           //1
776             round_[_rID].keys,              //2
777             round_[_rID].end,               //3
778             round_[_rID].strt,              //4
779             round_[_rID].pot,               //5
780             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
781             plyr_[round_[_rID].plyr].addr,  //7
782             plyr_[round_[_rID].plyr].name,  //8
783             rndTmEth_[_rID][0],             //9
784             rndTmEth_[_rID][1],             //10
785             airDropTracker_ + (airDropPot_ * 1000)  //11
786         );
787     }
788 
789     /**
790      * @dev returns player info based on address.  if no address is given, it will 
791      * use msg.sender 
792      * -functionhash- 0xee0b5d8b
793      * @param _addr address of the player you want to lookup 
794      * @return player ID 
795      * @return player name
796      * @return keys owned (current round)
797      * @return winnings vault
798      * @return general vault 
799      * @return affiliate vault 
800      * @return player round eth
801      */
802     function getPlayerInfoByAddress(address _addr)
803         public 
804         view 
805         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
806     {
807         // setup local rID
808         uint256 _rID = rID_;
809         
810         if (_addr == address(0))
811         {
812             _addr == msg.sender;
813         }
814         uint256 _pID = pIDxAddr_[_addr];
815         
816         return
817         (
818             _pID,                               //0
819             plyr_[_pID].name,                   //1
820             plyrRnds_[_pID][_rID].keys,         //2
821             plyr_[_pID].win,                    //3
822             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
823             plyr_[_pID].aff,                    //5
824             plyrRnds_[_pID][_rID].eth           //6
825         );
826     }
827 
828 //==============================================================================
829 //     _ _  _ _   | _  _ . _  .
830 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
831 //=====================_|=======================================================
832     /**
833      * @dev logic runs whenever a buy order is executed.  determines how to handle 
834      * incoming eth depending on if we are in an active round or not
835      */
836     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, BBTdatasets.EventReturns memory _eventData_)
837         private
838     {
839         // setup local rID
840         uint256 _rID = rID_;
841         
842         // grab time
843         uint256 _now = now;
844         
845         // if round is active
846         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
847         {
848             // call core 
849             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
850         
851         // if round is not active     
852         } else {
853             // check to see if end round needs to be ran
854             if (_now > round_[_rID].end && round_[_rID].ended == false) 
855             {
856                 // end the round (distributes pot) & start new round
857                 round_[_rID].ended = true;
858                 _eventData_ = endRound(_eventData_);
859                 
860                 // build event data
861                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
862                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
863                 
864                 // fire buy and distribute event 
865                 emit BBTevents.onBuyAndDistribute
866                 (
867                     msg.sender, 
868                     plyr_[_pID].name, 
869                     msg.value, 
870                     _eventData_.compressedData, 
871                     _eventData_.compressedIDs, 
872                     _eventData_.winnerAddr, 
873                     _eventData_.winnerName, 
874                     _eventData_.amountWon, 
875                     _eventData_.newPot, 
876                     _eventData_.BBTAmount, 
877                     _eventData_.genAmount
878                 );
879             }
880             
881             // put eth in players vault 
882             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
883         }
884     }
885     
886     /**
887      * @dev logic runs whenever a reload order is executed.  determines how to handle 
888      * incoming eth depending on if we are in an active round or not 
889      */
890     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, BBTdatasets.EventReturns memory _eventData_)
891         private
892     {
893         // setup local rID
894         uint256 _rID = rID_;
895         
896         // grab time
897         uint256 _now = now;
898         
899         // if round is active
900         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
901         {
902             // get earnings from all vaults and return unused to gen vault
903             // because we use a custom safemath library.  this will throw if player 
904             // tried to spend more eth than they have.
905             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
906             
907             // call core 
908             core(_rID, _pID, _eth, _affID, _team, _eventData_);
909         
910         // if round is not active and end round needs to be ran   
911         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
912             // end the round (distributes pot) & start new round
913             round_[_rID].ended = true;
914             _eventData_ = endRound(_eventData_);
915                 
916             // build event data
917             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
918             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
919                 
920             // fire buy and distribute event 
921             emit BBTevents.onReLoadAndDistribute
922             (
923                 msg.sender, 
924                 plyr_[_pID].name, 
925                 _eventData_.compressedData, 
926                 _eventData_.compressedIDs, 
927                 _eventData_.winnerAddr, 
928                 _eventData_.winnerName, 
929                 _eventData_.amountWon, 
930                 _eventData_.newPot, 
931                 _eventData_.BBTAmount, 
932                 _eventData_.genAmount
933             );
934         }
935     }
936     
937     /**
938      * @dev this is the core logic for any buy/reload that happens while a round 
939      * is live.
940      */
941     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, BBTdatasets.EventReturns memory _eventData_)
942         private
943     {
944         // if player is new to round
945         if (plyrRnds_[_pID][_rID].keys == 0)
946             _eventData_ = managePlayer(_pID, _eventData_);
947         
948         // early round eth limiter 
949         if (round_[_rID].eth < 10000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
950         {
951             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
952             uint256 _refund = _eth.sub(_availableLimit);
953             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
954             _eth = _availableLimit;
955         }
956         
957         // if eth left is greater than min eth allowed (sorry no pocket lint)
958         if (_eth > 1000000000) 
959         {
960             
961             // mint the new keys
962             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
963             
964             // if they bought at least 1 whole key
965             if (_keys >= 1000000000000000000)
966             {
967             updateTimer(_keys, _rID);
968 
969             // set new leaders
970             if (round_[_rID].plyr != _pID)
971                 round_[_rID].plyr = _pID;  
972             if (round_[_rID].team != _team)
973                 round_[_rID].team = _team; 
974             
975             // set the new leader bool to true
976             _eventData_.compressedData = _eventData_.compressedData + 100;
977             }
978             
979             // manage airdrops
980             if (_eth >= 100000000000000000)
981             {
982             airDropTracker_++;
983             if (airdrop() == true)
984             {
985                 // gib muni
986                 uint256 _prize;
987                 if (_eth >= 10000000000000000000)
988                 {
989                     // calculate prize and give it to winner
990                     _prize = ((airDropPot_).mul(75)) / 100;
991                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
992                     
993                     // adjust airDropPot 
994                     airDropPot_ = (airDropPot_).sub(_prize);
995                     
996                     // let event know a tier 3 prize was won 
997                     _eventData_.compressedData += 300000000000000000000000000000000;
998                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
999                     // calculate prize and give it to winner
1000                     _prize = ((airDropPot_).mul(50)) / 100;
1001                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1002                     
1003                     // adjust airDropPot 
1004                     airDropPot_ = (airDropPot_).sub(_prize);
1005                     
1006                     // let event know a tier 2 prize was won 
1007                     _eventData_.compressedData += 200000000000000000000000000000000;
1008                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1009                     // calculate prize and give it to winner
1010                     _prize = ((airDropPot_).mul(25)) / 100;
1011                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1012                     
1013                     // adjust airDropPot 
1014                     airDropPot_ = (airDropPot_).sub(_prize);
1015                     
1016                     // let event know a tier 3 prize was won 
1017                     _eventData_.compressedData += 300000000000000000000000000000000;
1018                 }
1019                 // set airdrop happened bool to true
1020                 _eventData_.compressedData += 10000000000000000000000000000000;
1021                 // let event know how much was won 
1022                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1023                 
1024                 // reset air drop tracker
1025                 airDropTracker_ = 0;
1026             }
1027             }
1028     
1029             // store the air drop tracker number (number of buys since last airdrop)
1030             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1031             
1032             // update player 
1033             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1034             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1035             
1036             // update round
1037             round_[_rID].keys = _keys.add(round_[_rID].keys);
1038             round_[_rID].eth = _eth.add(round_[_rID].eth);
1039             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1040     
1041             // distribute eth
1042             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1043             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1044             
1045             // call end tx function to fire end tx event.
1046             endTx(_pID, _team, _eth, _keys, _eventData_);
1047         }
1048     }
1049 //==============================================================================
1050 //     _ _ | _   | _ _|_ _  _ _  .
1051 //    (_(_||(_|_||(_| | (_)| _\  .
1052 //==============================================================================
1053     /**
1054      * @dev calculates unmasked earnings (just calculates, does not update mask)
1055      * @return earnings in wei format
1056      */
1057     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1058         private
1059         view
1060         returns(uint256)
1061     {
1062         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1063     }
1064     
1065     /** 
1066      * @dev returns the amount of keys you would get given an amount of eth. 
1067      * -functionhash- 0xce89c80c
1068      * @param _rID round ID you want price for
1069      * @param _eth amount of eth sent in 
1070      * @return keys received 
1071      */
1072     function calcKeysReceived(uint256 _rID, uint256 _eth)
1073         public
1074         view
1075         returns(uint256)
1076     {
1077         // grab time
1078         uint256 _now = now;
1079         
1080         // are we in a round?
1081         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1082             return ( (round_[_rID].eth).keysRec(_eth) );
1083         else // rounds over.  need keys for new round
1084             return ( (_eth).keys() );
1085     }
1086     
1087     /** 
1088      * @dev returns current eth price for X keys.  
1089      * -functionhash- 0xcf808000
1090      * @param _keys number of keys desired (in 18 decimal format)
1091      * @return amount of eth needed to send
1092      */
1093     function iWantXKeys(uint256 _keys)
1094         public
1095         view
1096         returns(uint256)
1097     {
1098         // setup local rID
1099         uint256 _rID = rID_;
1100         
1101         // grab time
1102         uint256 _now = now;
1103         
1104         // are we in a round?
1105         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1106             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1107         else // rounds over.  need price for new round
1108             return ( (_keys).eth() );
1109     }
1110 //==============================================================================
1111 //    _|_ _  _ | _  .
1112 //     | (_)(_)|_\  .
1113 //==============================================================================
1114     /**
1115      * @dev receives name/player info from names contract 
1116      */
1117     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1118         external
1119     {
1120         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1121         if (pIDxAddr_[_addr] != _pID)
1122             pIDxAddr_[_addr] = _pID;
1123         if (pIDxName_[_name] != _pID)
1124             pIDxName_[_name] = _pID;
1125         if (plyr_[_pID].addr != _addr)
1126             plyr_[_pID].addr = _addr;
1127         if (plyr_[_pID].name != _name)
1128             plyr_[_pID].name = _name;
1129         if (plyr_[_pID].laff != _laff)
1130             plyr_[_pID].laff = _laff;
1131         if (plyrNames_[_pID][_name] == false)
1132             plyrNames_[_pID][_name] = true;
1133     }
1134     
1135     /**
1136      * @dev receives entire player name list 
1137      */
1138     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1139         external
1140     {
1141         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1142         if(plyrNames_[_pID][_name] == false)
1143             plyrNames_[_pID][_name] = true;
1144     }   
1145         
1146     /**
1147      * @dev gets existing or registers new pID.  use this when a player may be new
1148      * @return pID 
1149      */
1150     function determinePID(BBTdatasets.EventReturns memory _eventData_)
1151         private
1152         returns (BBTdatasets.EventReturns)
1153     {
1154         uint256 _pID = pIDxAddr_[msg.sender];
1155         // if player is new to this version of fomo3d
1156         if (_pID == 0)
1157         {
1158             // grab their player ID, name and last aff ID, from player names contract 
1159             _pID = PlayerBook.getPlayerID(msg.sender);
1160             bytes32 _name = PlayerBook.getPlayerName(_pID);
1161             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1162             
1163             // set up player account 
1164             pIDxAddr_[msg.sender] = _pID;
1165             plyr_[_pID].addr = msg.sender;
1166             
1167             if (_name != "")
1168             {
1169                 pIDxName_[_name] = _pID;
1170                 plyr_[_pID].name = _name;
1171                 plyrNames_[_pID][_name] = true;
1172             }
1173             
1174             if (_laff != 0 && _laff != _pID)
1175                 plyr_[_pID].laff = _laff;
1176             
1177             // set the new player bool to true
1178             _eventData_.compressedData = _eventData_.compressedData + 1;
1179         } 
1180         return (_eventData_);
1181     }
1182     
1183     /**
1184      * @dev checks to make sure user picked a valid team.  if not sets team 
1185      * to default (sneks)
1186      */
1187     function verifyTeam(uint256 _team)
1188         private
1189         pure
1190         returns (uint256)
1191     {
1192         if (_team < 0 || _team > 1)
1193             return(0);
1194         else
1195             return(_team);
1196     }
1197     
1198     /**
1199      * @dev decides if round end needs to be run & new round started.  and if 
1200      * player unmasked earnings from previously played rounds need to be moved.
1201      */
1202     function managePlayer(uint256 _pID, BBTdatasets.EventReturns memory _eventData_)
1203         private
1204         returns (BBTdatasets.EventReturns)
1205     {
1206         // if player has played a previous round, move their unmasked earnings
1207         // from that round to gen vault.
1208         if (plyr_[_pID].lrnd != 0)
1209             updateGenVault(_pID, plyr_[_pID].lrnd);
1210             
1211         // update player's last round played
1212         plyr_[_pID].lrnd = rID_;
1213             
1214         // set the joined round bool to true
1215         _eventData_.compressedData = _eventData_.compressedData + 10;
1216         
1217         return(_eventData_);
1218     }
1219     
1220     /**
1221      * @dev ends the round. manages paying out winner/splitting up pot
1222      */
1223     function endRound(BBTdatasets.EventReturns memory _eventData_)
1224         private
1225         returns (BBTdatasets.EventReturns)
1226     {
1227         // setup local rID
1228         uint256 _rID = rID_;
1229         
1230         // grab our winning player and team id's
1231         uint256 _winPID = round_[_rID].plyr;
1232         uint256 _winTID = round_[_rID].team;
1233         
1234         // grab our pot amount
1235         uint256 _pot = round_[_rID].pot;
1236         
1237         // calculate our winner share, community rewards, gen share, 
1238         // bbt share, and amount reserved for next pot 
1239         uint256 _win = (_pot.mul(50)) / 100;
1240         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1241         uint256 _bbt = (_pot.mul(potSplit_[_winTID].bbt)) / 100;
1242         uint256 _res = ((_pot.sub(_win)).sub(_gen)).sub(_bbt);
1243         
1244         // calculate ppt for round mask
1245         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1246         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1247         if (_dust > 0)
1248         {
1249             _gen = _gen.sub(_dust);
1250             _res = _res.add(_dust);
1251         }
1252         
1253         // pay our winner
1254         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1255         
1256         // no community rewards
1257         
1258         // distribute gen portion to key holders
1259         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1260         
1261         // send share for bbt to divies
1262         if (_bbt > 0)
1263             BBTAddress.transfer(_bbt);
1264             
1265         // prepare event data
1266         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1267         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1268         _eventData_.winnerAddr = plyr_[_winPID].addr;
1269         _eventData_.winnerName = plyr_[_winPID].name;
1270         _eventData_.amountWon = _win;
1271         _eventData_.genAmount = _gen;
1272         _eventData_.BBTAmount = _bbt;
1273         _eventData_.newPot = _res;
1274         
1275         // start next round
1276         rID_++;
1277         _rID++;
1278         round_[_rID].strt = now;
1279         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1280         round_[_rID].pot = _res;
1281         
1282         return(_eventData_);
1283     }
1284     
1285     /**
1286      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1287      */
1288     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1289         private 
1290     {
1291         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1292         if (_earnings > 0)
1293         {
1294             // put in gen vault
1295             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1296             // zero out their earnings by updating mask
1297             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1298         }
1299     }
1300     
1301     /**
1302      * @dev updates round timer based on number of whole keys bought.
1303      */
1304     function updateTimer(uint256 _keys, uint256 _rID)
1305         private
1306     {
1307         // grab time
1308         uint256 _now = now;
1309         
1310         // calculate time based on number of keys bought
1311         uint256 _newTime;
1312         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1313             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1314         else
1315             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1316         
1317         // compare to max and set new end time
1318         if (_newTime < (rndMax_).add(_now))
1319             round_[_rID].end = _newTime;
1320         else
1321             round_[_rID].end = rndMax_.add(_now);
1322     }
1323     
1324     /**
1325      * @dev generates a random number between 0-99 and checks to see if thats
1326      * resulted in an airdrop win
1327      * @return do we have a winner?
1328      */
1329     function airdrop()
1330         private 
1331         view 
1332         returns(bool)
1333     {
1334         uint256 seed = uint256(keccak256(abi.encodePacked(
1335             
1336             (block.timestamp).add
1337             (block.difficulty).add
1338             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1339             (block.gaslimit).add
1340             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1341             (block.number)
1342             
1343         )));
1344         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1345             return(true);
1346         else
1347             return(false);
1348     }
1349 
1350     /**
1351      * @dev distributes eth based on fees to com, aff, and bbt
1352      */
1353     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, BBTdatasets.EventReturns memory _eventData_)
1354         private
1355         returns(BBTdatasets.EventReturns)
1356     {
1357         // pay 0 out to community rewards
1358 
1359         //pay 20% to BBT holders
1360         uint256 _bbt;
1361         
1362         // distribute 10% share to affiliate
1363         uint256 _aff = _eth / 10;
1364         
1365         // decide what to do with affiliate share of fees
1366         // affiliate must not be self, and must have a name registered
1367         if (_affID != _pID && plyr_[_affID].name != '') {
1368             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1369             emit BBTevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1370         } else {
1371             _bbt = _aff;
1372         }
1373         
1374         // pay out bbt
1375         _bbt = _bbt.add((_eth.mul(fees_[_team].bbt)) / (100));
1376         if (_bbt > 0)
1377         {
1378             // deposit to BBT contract
1379             BBTAddress.transfer(_bbt);
1380             
1381             // set up event data
1382             _eventData_.BBTAmount = _bbt.add(_eventData_.BBTAmount);
1383         }
1384         
1385         return(_eventData_);
1386     }
1387     
1388     /**
1389      * @dev distributes eth based on fees to gen and pot
1390      */
1391     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, BBTdatasets.EventReturns memory _eventData_)
1392         private
1393         returns(BBTdatasets.EventReturns)
1394     {
1395         // calculate gen share
1396         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1397         
1398         // toss 10% into airdrop pot 
1399         uint256 _air = (_eth / 10);
1400         airDropPot_ = airDropPot_.add(_air);
1401         
1402         // update eth balance (eth = eth - (aff share 10% + bbt share x% + airdrop pot share 10%))
1403         _eth = _eth.sub(((_eth.mul(20)) / 100).add((_eth.mul(fees_[_team].bbt)) / 100));
1404         
1405         // calculate pot - gen share y%
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
1482     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, BBTdatasets.EventReturns memory _eventData_)
1483         private
1484     {
1485         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1486         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1487         
1488         emit BBTevents.onEndTx
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
1500             _eventData_.BBTAmount,
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
1519             msg.sender == 0xFe3701b3071a28CC0d23b46A1d3e722E10A5a8f8 ||
1520             msg.sender == 0xFe3701b3071a28CC0d23b46A1d3e722E10A5a8f8 ||
1521             msg.sender == 0xFe3701b3071a28CC0d23b46A1d3e722E10A5a8f8 ||
1522             msg.sender == 0xFe3701b3071a28CC0d23b46A1d3e722E10A5a8f8 ||
1523             msg.sender == 0xFe3701b3071a28CC0d23b46A1d3e722E10A5a8f8,
1524             "only team just can activate"
1525         );
1526 
1527         
1528         // can only be ran once
1529         require(activated_ == false, "DIZHU already activated");
1530         
1531         // activate the contract 
1532         activated_ = true;
1533         
1534         // lets start first round
1535         rID_ = 1;
1536         round_[1].strt = now;
1537         round_[1].end = now + rndInit_ + rndGap_;
1538     }
1539 }
1540 
1541 //==============================================================================
1542 //   __|_ _    __|_ _  .
1543 //  _\ | | |_|(_ | _\  .
1544 //==============================================================================
1545 library BBTdatasets {
1546     //compressedData key
1547     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1548         // 0 - new player (bool)
1549         // 1 - joined round (bool)
1550         // 2 - new  leader (bool)
1551         // 3-5 - air drop tracker (uint 0-999)
1552         // 6-16 - round end time
1553         // 17 - winnerTeam
1554         // 18 - 28 timestamp 
1555         // 29 - team
1556         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1557         // 31 - airdrop happened bool
1558         // 32 - airdrop tier 
1559         // 33 - airdrop amount won
1560     //compressedIDs key
1561     // [77-52][51-26][25-0]
1562         // 0-25 - pID 
1563         // 26-51 - winPID
1564         // 52-77 - rID
1565     struct EventReturns {
1566         uint256 compressedData;
1567         uint256 compressedIDs;
1568         address winnerAddr;         // winner address
1569         bytes32 winnerName;         // winner name
1570         uint256 amountWon;          // amount won
1571         uint256 newPot;             // amount in new pot
1572         uint256 BBTAmount;          // amount distributed to bbt
1573         uint256 genAmount;          // amount distributed to gen
1574         uint256 potAmount;          // amount added to pot
1575     }
1576     struct Player {
1577         address addr;   // player address
1578         bytes32 name;   // player name
1579         uint256 win;    // winnings vault
1580         uint256 gen;    // general vault
1581         uint256 aff;    // affiliate vault
1582         uint256 lrnd;   // last round played
1583         uint256 laff;   // last affiliate id used
1584     }
1585     struct PlayerRounds {
1586         uint256 eth;    // eth player has added to round (used for eth limiter)
1587         uint256 keys;   // keys
1588         uint256 mask;   // player mask 
1589         uint256 ico;    // ICO phase investment
1590     }
1591     struct Round {
1592         uint256 plyr;   // pID of player in lead
1593         uint256 team;   // tID of team in lead
1594         uint256 end;    // time ends/ended
1595         bool ended;     // has round end function been ran
1596         uint256 strt;   // time round started
1597         uint256 keys;   // keys
1598         uint256 eth;    // total eth in
1599         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1600         uint256 mask;   // global mask
1601         uint256 ico;    // total eth sent in during ICO phase
1602         uint256 icoGen; // total eth for gen during ICO phase
1603         uint256 icoAvg; // average key price for ICO phase
1604     }
1605     struct TeamFee {
1606         uint256 gen;    // % of buy in thats paid to key holders of current round
1607         uint256 bbt;    // % of buy in thats paid to bbt holders
1608     }
1609     struct PotSplit {
1610         uint256 gen;    // % of pot thats paid to key holders of current round
1611         uint256 bbt;    // % of pot thats paid to bbt holders
1612     }
1613 }
1614 
1615 //==============================================================================
1616 //  |  _      _ _ | _  .
1617 //  |<(/_\/  (_(_||(_  .
1618 //=======/======================================================================
1619 library BBTKeysCalcLong {
1620     using SafeMath for *;
1621     /**
1622      * @dev calculates number of keys received given X eth 
1623      * @param _curEth current amount of eth in contract 
1624      * @param _newEth eth being spent
1625      * @return amount of ticket purchased
1626      */
1627     function keysRec(uint256 _curEth, uint256 _newEth)
1628         internal
1629         pure
1630         returns (uint256)
1631     {
1632         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1633     }
1634     
1635     /**
1636      * @dev calculates amount of eth received if you sold X keys 
1637      * @param _curKeys current amount of keys that exist 
1638      * @param _sellKeys amount of keys you wish to sell
1639      * @return amount of eth received
1640      */
1641     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1642         internal
1643         pure
1644         returns (uint256)
1645     {
1646         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1647     }
1648 
1649     /**
1650      * @dev calculates how many keys would exist with given an amount of eth
1651      * @param _eth eth "in contract"
1652      * @return number of keys that would exist
1653      */
1654     function keys(uint256 _eth) 
1655         internal
1656         pure
1657         returns(uint256)
1658     {
1659         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1660     }
1661     
1662     /**
1663      * @dev calculates how much eth would be in contract given a number of keys
1664      * @param _keys number of keys "in contract" 
1665      * @return eth that would exists
1666      */
1667     function eth(uint256 _keys) 
1668         internal
1669         pure
1670         returns(uint256)  
1671     {
1672         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1673     }
1674 }
1675 
1676 
1677 interface PlayerBookInterface {
1678     function getPlayerID(address _addr) external returns (uint256);
1679     function getPlayerName(uint256 _pID) external view returns (bytes32);
1680     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1681     function getPlayerAddr(uint256 _pID) external view returns (address);
1682     function getNameFee() external view returns (uint256);
1683     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1684     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1685     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1686 }
1687 
1688 
1689 library NameFilter {
1690     /**
1691      * @dev filters name strings
1692      * -converts uppercase to lower case.  
1693      * -makes sure it does not start/end with a space
1694      * -makes sure it does not contain multiple spaces in a row
1695      * -cannot be only numbers
1696      * -cannot start with 0x 
1697      * -restricts characters to A-Z, a-z, 0-9, and space.
1698      * @return reprocessed string in bytes32 format
1699      */
1700     function nameFilter(string _input)
1701         internal
1702         pure
1703         returns(bytes32)
1704     {
1705         bytes memory _temp = bytes(_input);
1706         uint256 _length = _temp.length;
1707         
1708         //sorry limited to 32 characters
1709         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1710         // make sure it doesnt start with or end with space
1711         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1712         // make sure first two characters are not 0x
1713         if (_temp[0] == 0x30)
1714         {
1715             require(_temp[1] != 0x78, "string cannot start with 0x");
1716             require(_temp[1] != 0x58, "string cannot start with 0X");
1717         }
1718         
1719         // create a bool to track if we have a non number character
1720         bool _hasNonNumber;
1721         
1722         // convert & check
1723         for (uint256 i = 0; i < _length; i++)
1724         {
1725             // if its uppercase A-Z
1726             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1727             {
1728                 // convert to lower case a-z
1729                 _temp[i] = byte(uint(_temp[i]) + 32);
1730                 
1731                 // we have a non number
1732                 if (_hasNonNumber == false)
1733                     _hasNonNumber = true;
1734             } else {
1735                 require
1736                 (
1737                     // require character is a space
1738                     _temp[i] == 0x20 || 
1739                     // OR lowercase a-z
1740                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1741                     // or 0-9
1742                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1743                     "string contains invalid characters"
1744                 );
1745                 // make sure theres not 2x spaces in a row
1746                 if (_temp[i] == 0x20)
1747                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1748                 
1749                 // see if we have a character other than a number
1750                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1751                     _hasNonNumber = true;    
1752             }
1753         }
1754         
1755         require(_hasNonNumber == true, "string cannot be only numbers");
1756         
1757         bytes32 _ret;
1758         assembly {
1759             _ret := mload(add(_temp, 32))
1760         }
1761         return (_ret);
1762     }
1763 }
1764 
1765 /**
1766  * @title SafeMath v0.1.9
1767  * @dev Math operations with safety checks that throw on error
1768  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1769  * - added sqrt
1770  * - added sq
1771  * - added pwr 
1772  * - changed asserts to requires with error log outputs
1773  * - removed div, its useless
1774  */
1775 library SafeMath {
1776     
1777     /**
1778     * @dev Multiplies two numbers, throws on overflow.
1779     */
1780     function mul(uint256 a, uint256 b) 
1781         internal 
1782         pure 
1783         returns (uint256 c) 
1784     {
1785         if (a == 0) {
1786             return 0;
1787         }
1788         c = a * b;
1789         require(c / a == b, "SafeMath mul failed");
1790         return c;
1791     }
1792 
1793     /**
1794     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1795     */
1796     function sub(uint256 a, uint256 b)
1797         internal
1798         pure
1799         returns (uint256) 
1800     {
1801         require(b <= a, "SafeMath sub failed");
1802         return a - b;
1803     }
1804 
1805     /**
1806     * @dev Adds two numbers, throws on overflow.
1807     */
1808     function add(uint256 a, uint256 b)
1809         internal
1810         pure
1811         returns (uint256 c) 
1812     {
1813         c = a + b;
1814         require(c >= a, "SafeMath add failed");
1815         return c;
1816     }
1817     
1818     /**
1819      * @dev gives square root of given x.
1820      */
1821     function sqrt(uint256 x)
1822         internal
1823         pure
1824         returns (uint256 y) 
1825     {
1826         uint256 z = ((add(x,1)) / 2);
1827         y = x;
1828         while (z < y) 
1829         {
1830             y = z;
1831             z = ((add((x / z),z)) / 2);
1832         }
1833     }
1834     
1835     /**
1836      * @dev gives square. multiplies x by x
1837      */
1838     function sq(uint256 x)
1839         internal
1840         pure
1841         returns (uint256)
1842     {
1843         return (mul(x,x));
1844     }
1845     
1846     /**
1847      * @dev x to the power of y 
1848      */
1849     function pwr(uint256 x, uint256 y)
1850         internal 
1851         pure 
1852         returns (uint256)
1853     {
1854         if (x==0)
1855             return (0);
1856         else if (y==0)
1857             return (1);
1858         else 
1859         {
1860             uint256 z = x;
1861             for (uint256 i=1; i < y; i++)
1862                 z = mul(z,x);
1863             return (z);
1864         }
1865     }
1866 }