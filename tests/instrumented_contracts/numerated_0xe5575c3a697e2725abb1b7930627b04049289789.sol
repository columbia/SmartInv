1 pragma solidity ^0.4.24;
2 contract F4Devents {
3     event onNewName
4     (
5         uint256 indexed playerID,
6         address indexed playerAddress,
7         bytes32 indexed playerName,
8         bool isNewPlayer,
9         uint256 affiliateID,
10         address affiliateAddress,
11         bytes32 affiliateName,
12         uint256 amountPaid,
13         uint256 timeStamp
14     );
15     
16     event onEndTx
17     (
18         uint256 compressedData,     
19         uint256 compressedIDs,      
20         bytes32 playerName,
21         address playerAddress,
22         uint256 ethIn,
23         uint256 keysBought,
24         address winnerAddr,
25         bytes32 winnerName,
26         uint256 amountWon,
27         uint256 newPot,
28         uint256 genAmount,
29         uint256 potAmount
30     );
31     
32     event onWithdraw
33     (
34         uint256 indexed playerID,
35         address playerAddress,
36         bytes32 playerName,
37         uint256 ethOut,
38         uint256 timeStamp
39     );
40     
41     event onWithdrawAndDistribute
42     (
43         address playerAddress,
44         bytes32 playerName,
45         uint256 ethOut,
46         uint256 compressedData,
47         uint256 compressedIDs,
48         address winnerAddr,
49         bytes32 winnerName,
50         uint256 amountWon,
51         uint256 newPot,
52         uint256 genAmount
53     );
54     
55     event onBuyAndDistribute
56     (
57         address playerAddress,
58         bytes32 playerName,
59         uint256 ethIn,
60         uint256 compressedData,
61         uint256 compressedIDs,
62         address winnerAddr,
63         bytes32 winnerName,
64         uint256 amountWon,
65         uint256 newPot,
66         uint256 genAmount
67     );
68     
69     event onReLoadAndDistribute
70     (
71         address playerAddress,
72         bytes32 playerName,
73         uint256 compressedData,
74         uint256 compressedIDs,
75         address winnerAddr,
76         bytes32 winnerName,
77         uint256 amountWon,
78         uint256 newPot,
79         uint256 genAmount
80     );
81     
82     event onAffiliatePayout
83     (
84         uint256 indexed affiliateID,
85         address affiliateAddress,
86         bytes32 affiliateName,
87         uint256 indexed roundID,
88         uint256 indexed buyerID,
89         uint256 amount,
90         uint256 timeStamp
91     );
92     
93     event onPotSwapDeposit
94     (
95         uint256 roundID,
96         uint256 amountAddedToPot
97     );
98 }
99 
100 contract Fomo4D is F4Devents {
101     using SafeMath for *;
102     using NameFilter for string;
103     using F4DKeysCalcLong for uint256;
104 	
105     address private owner_;
106 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xeEd618C15d12C635C3C319aEe7BDED2E2879AEa0);
107     string constant public name = "Fomo4D";
108     string constant public symbol = "F4D";
109 	uint256 private rndExtra_ = 0;                              // length of the very first ICO 
110     uint256 private rndGap_ = 0;                                // length of ICO phase, set to 1 year for EOS.
111     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
112     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
113     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
114     uint256 public rID_;                                        // round id number / total rounds that have happened
115     mapping (address => uint256) public pIDxAddr_;              // (addr => pID) returns player id by address
116     mapping (bytes32 => uint256) public pIDxName_;              // (name => pID) returns player id by name
117     mapping (uint256 => F4Ddatasets.Player) public plyr_;       // (pID => data) player data
118     mapping (uint256 => mapping (uint256 => F4Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
119     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;   // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
120     mapping (uint256 => F4Ddatasets.Round) public round_;               // (rID => data) round data
121     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
122 
123     mapping (uint256 => F4Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
124     mapping (uint256 => F4Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
125 
126     constructor()
127         public
128     {
129         owner_ = msg.sender;
130 		// Team allocation structures
131         // 0 = whales
132         // 1 = bears
133         // 2 = sneks
134         // 3 = bulls
135         fees_[0] = F4Ddatasets.TeamFee(24);
136         fees_[1] = F4Ddatasets.TeamFee(38);
137         fees_[2] = F4Ddatasets.TeamFee(50);
138         fees_[3] = F4Ddatasets.TeamFee(42);
139  
140         potSplit_[0] = F4Ddatasets.PotSplit(12);
141         potSplit_[1] = F4Ddatasets.PotSplit(19);
142         potSplit_[2] = F4Ddatasets.PotSplit(26);
143         potSplit_[3] = F4Ddatasets.PotSplit(30);
144 	}
145 //modifier
146     /**
147      * @dev used to make sure no one can interact with contract until it has 
148      * been activated. 
149      */
150     modifier isActivated() {
151         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
152         _;
153     }
154     
155     /**
156      * @dev prevents contracts from interacting with fomo3d 
157      */
158     modifier isHuman() {
159         address _addr = msg.sender;
160         uint256 _codeLength;
161         
162         assembly {_codeLength := extcodesize(_addr)}
163         require(_codeLength == 0, "sorry humans only");
164         _;
165     }
166 
167     /**
168      * @dev sets boundaries for incoming tx 
169      */
170     modifier isWithinLimits(uint256 _eth) {
171         require(_eth >= 1000000000, "pocket lint: not a valid currency");
172         require(_eth <= 100000000000000000000000, "no vitalik, no");
173         _;    
174     }
175     
176 //public functions
177     /**
178      * @dev emergency buy uses last stored affiliate ID and team snek
179      */
180     function()
181         isActivated()
182         isHuman()
183         isWithinLimits(msg.value)
184         public
185         payable
186     {
187         // set up our tx event data and determine if player is new or not
188         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
189             
190         // fetch player id
191         uint256 _pID = pIDxAddr_[msg.sender];
192         
193         // buy core 
194         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
195     }
196     
197     /**
198      * @dev converts all incoming ethereum to keys.
199      * -functionhash- 0x8f38f309 (using ID for affiliate)
200      * -functionhash- 0x98a0871d (using address for affiliate)
201      * -functionhash- 0xa65b37a1 (using name for affiliate)
202      * @param _affCode the ID/address/name of the player who gets the affiliate fee
203      * @param _team what team is the player playing for?
204      */
205     function buyXid(uint256 _affCode, uint256 _team)
206         isActivated()
207         isHuman()
208         isWithinLimits(msg.value)
209         public
210         payable
211     {
212         // set up our tx event data and determine if player is new or not
213         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
214         
215         // fetch player id
216         uint256 _pID = pIDxAddr_[msg.sender];
217         
218         // manage affiliate residuals
219         // if no affiliate code was given or player tried to use their own, lolz
220         if (_affCode == 0 || _affCode == _pID)
221         {
222             // use last stored affiliate code 
223             _affCode = plyr_[_pID].laff;
224             
225         // if affiliate code was given & its not the same as previously stored 
226         } else if (_affCode != plyr_[_pID].laff) {
227             // update last affiliate 
228             plyr_[_pID].laff = _affCode;
229         }
230         
231         // verify a valid team was selected
232         _team = verifyTeam(_team);
233         
234         // buy core 
235         buyCore(_pID, _affCode, _team, _eventData_);
236     }
237     
238     function buyXaddr(address _affCode, uint256 _team)
239         isActivated()
240         isHuman()
241         isWithinLimits(msg.value)
242         public
243         payable
244     {
245         // set up our tx event data and determine if player is new or not
246         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
247         
248         // fetch player id
249         uint256 _pID = pIDxAddr_[msg.sender];
250         
251         // manage affiliate residuals
252         uint256 _affID;
253         // if no affiliate code was given or player tried to use their own, lolz
254         if (_affCode == address(0) || _affCode == msg.sender)
255         {
256             // use last stored affiliate code
257             _affID = plyr_[_pID].laff;
258         
259         // if affiliate code was given    
260         } else {
261             // get affiliate ID from aff Code 
262             _affID = pIDxAddr_[_affCode];
263             
264             // if affID is not the same as previously stored 
265             if (_affID != plyr_[_pID].laff)
266             {
267                 // update last affiliate
268                 plyr_[_pID].laff = _affID;
269             }
270         }
271         
272         // verify a valid team was selected
273         _team = verifyTeam(_team);
274         
275         // buy core 
276         buyCore(_pID, _affID, _team, _eventData_);
277     }
278     
279     function buyXname(bytes32 _affCode, uint256 _team)
280         isActivated()
281         isHuman()
282         isWithinLimits(msg.value)
283         public
284         payable
285     {
286         // set up our tx event data and determine if player is new or not
287         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
288         
289         // fetch player id
290         uint256 _pID = pIDxAddr_[msg.sender];
291         
292         // manage affiliate residuals
293         uint256 _affID;
294         // if no affiliate code was given or player tried to use their own, lolz
295         if (_affCode == '' || _affCode == plyr_[_pID].name)
296         {
297             // use last stored affiliate code
298             _affID = plyr_[_pID].laff;
299         
300         // if affiliate code was given
301         } else {
302             // get affiliate ID from aff Code
303             _affID = pIDxName_[_affCode];
304             
305             // if affID is not the same as previously stored
306             if (_affID != plyr_[_pID].laff)
307             {
308                 // update last affiliate
309                 plyr_[_pID].laff = _affID;
310             }
311         }
312         
313         // verify a valid team was selected
314         _team = verifyTeam(_team);
315         
316         // buy core 
317         buyCore(_pID, _affID, _team, _eventData_);
318     }
319     
320     /**
321      * @dev essentially the same as buy, but instead of you sending ether 
322      * from your wallet, it uses your unwithdrawn earnings.
323      * -functionhash- 0x349cdcac (using ID for affiliate)
324      * -functionhash- 0x82bfc739 (using address for affiliate)
325      * -functionhash- 0x079ce327 (using name for affiliate)
326      * @param _affCode the ID/address/name of the player who gets the affiliate fee
327      * @param _team what team is the player playing for?
328      * @param _eth amount of earnings to use (remainder returned to gen vault)
329      */
330     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
331         isActivated()
332         isHuman()
333         isWithinLimits(_eth)
334         public
335     {
336         // set up our tx event data
337         F4Ddatasets.EventReturns memory _eventData_;
338         
339         // fetch player ID
340         uint256 _pID = pIDxAddr_[msg.sender];
341         
342         // manage affiliate residuals
343         // if no affiliate code was given or player tried to use their own, lolz
344         if (_affCode == 0 || _affCode == _pID)
345         {
346             // use last stored affiliate code 
347             _affCode = plyr_[_pID].laff;
348             
349         // if affiliate code was given & its not the same as previously stored 
350         } else if (_affCode != plyr_[_pID].laff) {
351             // update last affiliate 
352             plyr_[_pID].laff = _affCode;
353         }
354 
355         // verify a valid team was selected
356         _team = verifyTeam(_team);
357 
358         // reload core
359         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
360     }
361     
362     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
363         isActivated()
364         isHuman()
365         isWithinLimits(_eth)
366         public
367     {
368         // set up our tx event data
369         F4Ddatasets.EventReturns memory _eventData_;
370         
371         // fetch player ID
372         uint256 _pID = pIDxAddr_[msg.sender];
373         
374         // manage affiliate residuals
375         uint256 _affID;
376         // if no affiliate code was given or player tried to use their own, lolz
377         if (_affCode == address(0) || _affCode == msg.sender)
378         {
379             // use last stored affiliate code
380             _affID = plyr_[_pID].laff;
381         
382         // if affiliate code was given    
383         } else {
384             // get affiliate ID from aff Code 
385             _affID = pIDxAddr_[_affCode];
386             
387             // if affID is not the same as previously stored 
388             if (_affID != plyr_[_pID].laff)
389             {
390                 // update last affiliate
391                 plyr_[_pID].laff = _affID;
392             }
393         }
394         
395         // verify a valid team was selected
396         _team = verifyTeam(_team);
397         
398         // reload core
399         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
400     }
401     
402     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
403         isActivated()
404         isHuman()
405         isWithinLimits(_eth)
406         public
407     {
408         // set up our tx event data
409         F4Ddatasets.EventReturns memory _eventData_;
410         
411         // fetch player ID
412         uint256 _pID = pIDxAddr_[msg.sender];
413         
414         // manage affiliate residuals
415         uint256 _affID;
416         // if no affiliate code was given or player tried to use their own, lolz
417         if (_affCode == '' || _affCode == plyr_[_pID].name)
418         {
419             // use last stored affiliate code
420             _affID = plyr_[_pID].laff;
421         
422         // if affiliate code was given
423         } else {
424             // get affiliate ID from aff Code
425             _affID = pIDxName_[_affCode];
426             
427             // if affID is not the same as previously stored
428             if (_affID != plyr_[_pID].laff)
429             {
430                 // update last affiliate
431                 plyr_[_pID].laff = _affID;
432             }
433         }
434         
435         // verify a valid team was selected
436         _team = verifyTeam(_team);
437         
438         // reload core
439         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
440     }
441 
442     /**
443      * @dev withdraws all of your earnings.
444      * -functionhash- 0x3ccfd60b
445      */
446     function withdraw()
447         isActivated()
448         isHuman()
449         public
450     {
451         // setup local rID 
452         uint256 _rID = rID_;
453         
454         // grab time
455         uint256 _now = now;
456         
457         // fetch player ID
458         uint256 _pID = pIDxAddr_[msg.sender];
459         
460         // setup temp var for player eth
461         uint256 _eth;
462         
463         // check to see if round has ended and no one has run round end yet
464         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
465         {
466             // set up our tx event data
467             F4Ddatasets.EventReturns memory _eventData_;
468             
469             // end the round (distributes pot)
470 			round_[_rID].ended = true;
471             _eventData_ = endRound(_eventData_);
472             
473 			// get their earnings
474             _eth = withdrawEarnings(_pID);
475             
476             // gib moni
477             if (_eth > 0)
478                 plyr_[_pID].addr.transfer(_eth);    
479             
480             // build event data
481             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
482             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
483             
484             // fire withdraw and distribute event
485             emit F4Devents.onWithdrawAndDistribute
486             (
487                 msg.sender, 
488                 plyr_[_pID].name, 
489                 _eth, 
490                 _eventData_.compressedData, 
491                 _eventData_.compressedIDs, 
492                 _eventData_.winnerAddr, 
493                 _eventData_.winnerName, 
494                 _eventData_.amountWon, 
495                 _eventData_.newPot, 
496                 _eventData_.genAmount
497             );
498             
499         // in any other situation
500         } else {
501             // get their earnings
502             _eth = withdrawEarnings(_pID);
503             
504             // gib moni
505             if (_eth > 0)
506                 plyr_[_pID].addr.transfer(_eth);
507             
508             // fire withdraw event
509             emit F4Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
510         }
511     }
512     
513     /**
514      * @dev use these to register names.  they are just wrappers that will send the
515      * registration requests to the PlayerBook contract.  So registering here is the 
516      * same as registering there.  UI will always display the last name you registered.
517      * but you will still own all previously registered names to use as affiliate 
518      * links.
519      * - must pay a registration fee.
520      * - name must be unique
521      * - names will be converted to lowercase
522      * - name cannot start or end with a space 
523      * - cannot have more than 1 space in a row
524      * - cannot be only numbers
525      * - cannot start with 0x 
526      * - name must be at least 1 char
527      * - max length of 32 characters long
528      * - allowed characters: a-z, 0-9, and space
529      * -functionhash- 0x921dec21 (using ID for affiliate)
530      * -functionhash- 0x3ddd4698 (using address for affiliate)
531      * -functionhash- 0x685ffd83 (using name for affiliate)
532      * @param _nameString players desired name
533      * @param _affCode affiliate ID, address, or name of who referred you
534      * @param _all set to true if you want this to push your info to all games 
535      * (this might cost a lot of gas)
536      */
537     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
538         isHuman()
539         public
540         payable
541     {
542         bytes32 _name = _nameString.nameFilter();
543         address _addr = msg.sender;
544         uint256 _paid = msg.value;
545         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
546         
547         uint256 _pID = pIDxAddr_[_addr];
548         
549         // fire event
550         emit F4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
551     }
552     
553     function registerNameXaddr(string _nameString, address _affCode, bool _all)
554         isHuman()
555         public
556         payable
557     {
558         bytes32 _name = _nameString.nameFilter();
559         address _addr = msg.sender;
560         uint256 _paid = msg.value;
561         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
562         
563         uint256 _pID = pIDxAddr_[_addr];
564         
565         // fire event
566         emit F4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
567     }
568     
569     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
570         isHuman()
571         public
572         payable
573     {
574         bytes32 _name = _nameString.nameFilter();
575         address _addr = msg.sender;
576         uint256 _paid = msg.value;
577         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
578         
579         uint256 _pID = pIDxAddr_[_addr];
580         
581         // fire event
582         emit F4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
583     }
584 //view
585     /**
586      * @dev return the price buyer will pay for next 1 individual key.
587      * -functionhash- 0x018a25e8
588      * @return price for next key bought (in wei format)
589      */
590     function getBuyPrice()
591         public 
592         view 
593         returns(uint256)
594     {  
595         // setup local rID
596         uint256 _rID = rID_;
597         
598         // grab time
599         uint256 _now = now;
600         
601         // are we in a round?
602         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
603             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
604         else // rounds over.  need price for new round
605             return ( 75000000000000 ); // init
606     }
607     
608     /**
609      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
610      * provider
611      * -functionhash- 0xc7e284b8
612      * @return time left in seconds
613      */
614     function getTimeLeft()
615         public
616         view
617         returns(uint256)
618     {
619         // setup local rID
620         uint256 _rID = rID_;
621         
622         // grab time
623         uint256 _now = now;
624         
625         if (_now < round_[_rID].end)
626             if (_now > round_[_rID].strt + rndGap_)
627                 return( (round_[_rID].end).sub(_now) );
628             else
629                 return( (round_[_rID].strt + rndGap_).sub(_now) );
630         else
631             return(0);
632     }
633     
634     /**
635      * @dev returns player earnings per vaults 
636      * -functionhash- 0x63066434
637      * @return winnings vault
638      * @return general vault
639      * @return affiliate vault
640      */
641     function getPlayerVaults(uint256 _pID)
642         public
643         view
644         returns(uint256 ,uint256, uint256)
645     {
646         // setup local rID
647         uint256 _rID = rID_;
648         
649         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
650         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
651         {
652             // if player is winner 
653             if (round_[_rID].plyr == _pID)
654             {
655                 return
656                 (
657                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
658                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
659                     plyr_[_pID].aff
660                 );
661             // if player is not the winner
662             } else {
663                 return
664                 (
665                     plyr_[_pID].win,
666                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
667                     plyr_[_pID].aff
668                 );
669             }
670             
671         // if round is still going on, or round has ended and round end has been ran
672         } else {
673             return
674             (
675                 plyr_[_pID].win,
676                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
677                 plyr_[_pID].aff
678             );
679         }
680     }
681     
682     /**
683      * solidity hates stack limits.  this lets us avoid that hate 
684      */
685     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
686         private
687         view
688         returns(uint256)
689     {
690         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
691     }
692     
693     /**
694      * @dev returns all current round info needed for front end
695      * -functionhash- 0x747dff42
696      * @return eth invested during ICO phase
697      * @return round id 
698      * @return total keys for round 
699      * @return time round ends
700      * @return time round started
701      * @return current pot 
702      * @return current team ID & player ID in lead 
703      * @return current player in leads address 
704      * @return current player in leads name
705      * @return whales eth in for round
706      * @return bears eth in for round
707      * @return sneks eth in for round
708      * @return bulls eth in for round
709      */
710     function getCurrentRoundInfo()
711         public
712         view
713         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
714     {
715         // setup local rID
716         uint256 _rID = rID_;
717         
718         return
719         (
720             0,                              //0
721             _rID,                           //1
722             round_[_rID].keys,              //2
723             round_[_rID].end,               //3
724             round_[_rID].strt,              //4
725             round_[_rID].pot,               //5
726             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
727             plyr_[round_[_rID].plyr].addr,  //7
728             plyr_[round_[_rID].plyr].name,  //8
729             rndTmEth_[_rID][0],             //9
730             rndTmEth_[_rID][1],             //10
731             rndTmEth_[_rID][2],             //11
732             rndTmEth_[_rID][3]              //12
733         );
734     }
735 
736     /**
737      * @dev returns player info based on address.  if no address is given, it will 
738      * use msg.sender 
739      * -functionhash- 0xee0b5d8b
740      * @param _addr address of the player you want to lookup 
741      * @return player ID 
742      * @return player name
743      * @return keys owned (current round)
744      * @return winnings vault
745      * @return general vault 
746      * @return affiliate vault 
747 	 * @return player round eth
748      */
749     function getPlayerInfoByAddress(address _addr)
750         public 
751         view 
752         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
753     {
754         // setup local rID
755         uint256 _rID = rID_;
756         
757         if (_addr == address(0))
758         {
759             _addr == msg.sender;
760         }
761         uint256 _pID = pIDxAddr_[_addr];
762         
763         return
764         (
765             _pID,                               //0
766             plyr_[_pID].name,                   //1
767             plyrRnds_[_pID][_rID].keys,         //2
768             plyr_[_pID].win,                    //3
769             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
770             plyr_[_pID].aff,                    //5
771             plyrRnds_[_pID][_rID].eth           //6
772         );
773     }
774 
775 //core logic
776     /**
777      * @dev logic runs whenever a buy order is executed.  determines how to handle 
778      * incoming eth depending on if we are in an active round or not
779      */
780     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F4Ddatasets.EventReturns memory _eventData_)
781         private
782     {
783         // setup local rID
784         uint256 _rID = rID_;
785         
786         // grab time
787         uint256 _now = now;
788         
789         // if round is active
790         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
791         {
792             // call core 
793             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
794         
795         // if round is not active     
796         } else {
797             // check to see if end round needs to be ran
798             if (_now > round_[_rID].end && round_[_rID].ended == false) 
799             {
800                 // end the round (distributes pot) & start new round
801 			    round_[_rID].ended = true;
802                 _eventData_ = endRound(_eventData_);
803                 
804                 // build event data
805                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
806                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
807                 
808                 // fire buy and distribute event 
809                 emit F4Devents.onBuyAndDistribute
810                 (
811                     msg.sender, 
812                     plyr_[_pID].name, 
813                     msg.value, 
814                     _eventData_.compressedData, 
815                     _eventData_.compressedIDs, 
816                     _eventData_.winnerAddr, 
817                     _eventData_.winnerName, 
818                     _eventData_.amountWon, 
819                     _eventData_.newPot, 
820                     _eventData_.genAmount
821                 );
822             }
823             
824             // put eth in players vault 
825             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
826         }
827     }
828     
829     /**
830      * @dev logic runs whenever a reload order is executed.  determines how to handle 
831      * incoming eth depending on if we are in an active round or not 
832      */
833     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F4Ddatasets.EventReturns memory _eventData_)
834         private
835     {
836         // setup local rID
837         uint256 _rID = rID_;
838         
839         // grab time
840         uint256 _now = now;
841         
842         // if round is active
843         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
844         {
845             // get earnings from all vaults and return unused to gen vault
846             // because we use a custom safemath library.  this will throw if player 
847             // tried to spend more eth than they have.
848             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
849             
850             // call core 
851             core(_rID, _pID, _eth, _affID, _team, _eventData_);
852         
853         // if round is not active and end round needs to be ran   
854         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
855             // end the round (distributes pot) & start new round
856             round_[_rID].ended = true;
857             _eventData_ = endRound(_eventData_);
858                 
859             // build event data
860             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
861             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
862                 
863             // fire buy and distribute event 
864             emit F4Devents.onReLoadAndDistribute
865             (
866                 msg.sender, 
867                 plyr_[_pID].name, 
868                 _eventData_.compressedData, 
869                 _eventData_.compressedIDs, 
870                 _eventData_.winnerAddr, 
871                 _eventData_.winnerName, 
872                 _eventData_.amountWon, 
873                 _eventData_.newPot, 
874                 _eventData_.genAmount
875             );
876         }
877     }
878     
879     /**
880      * @dev this is the core logic for any buy/reload that happens while a round 
881      * is live.
882      */
883     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F4Ddatasets.EventReturns memory _eventData_)
884         private
885     {
886         // if player is new to round
887         if (plyrRnds_[_pID][_rID].keys == 0)
888             _eventData_ = managePlayer(_pID, _eventData_);
889         
890         // early round eth limiter 
891         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
892         {
893             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
894             uint256 _refund = _eth.sub(_availableLimit);
895             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
896             _eth = _availableLimit;
897         }
898         
899         // if eth left is greater than min eth allowed (sorry no pocket lint)
900         if (_eth > 1000000000) 
901         {
902             
903             // mint the new keys
904             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
905             
906             // if they bought at least 1 whole key
907             if (_keys >= 1000000000000000000)
908             {
909                 updateTimer(_keys, _rID);
910 
911                 // set new leaders
912                 if (round_[_rID].plyr != _pID)
913                     round_[_rID].plyr = _pID;  
914                 if (round_[_rID].team != _team)
915                     round_[_rID].team = _team; 
916                 
917                 // set the new leader bool to true
918                 _eventData_.compressedData = _eventData_.compressedData + 100;
919             }
920             
921             // update player 
922             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
923             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
924             
925             // update round
926             round_[_rID].keys = _keys.add(round_[_rID].keys);
927             round_[_rID].eth = _eth.add(round_[_rID].eth);
928             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
929     
930             // distribute eth
931             _eventData_ = distributeExternal(_rID, _pID, _eth, _eventData_);
932             _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
933             
934             // call end tx function to fire end tx event.
935 		    endTx(_pID, _team, _eth, _keys, _eventData_);
936         }
937     }
938     /**
939      * @dev calculates unmasked earnings (just calculates, does not update mask)
940      * @return earnings in wei format
941      */
942     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
943         private
944         view
945         returns(uint256)
946     {
947         return(
948             (
949                 (
950                     (round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)
951                 ) / (1000000000000000000)
952             ).sub(plyrRnds_[_pID][_rIDlast].mask)
953         );
954     }
955     
956     /** 
957      * @dev returns the amount of keys you would get given an amount of eth. 
958      * -functionhash- 0xce89c80c
959      * @param _rID round ID you want price for
960      * @param _eth amount of eth sent in 
961      * @return keys received 
962      */
963     function calcKeysReceived(uint256 _rID, uint256 _eth)
964         public
965         view
966         returns(uint256)
967     {
968         // grab time
969         uint256 _now = now;
970         
971         // are we in a round?
972         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
973             return ( (round_[_rID].eth).keysRec(_eth) );
974         else // rounds over.  need keys for new round
975             return ( (_eth).keys() );
976     }
977     
978     /** 
979      * @dev returns current eth price for X keys.  
980      * -functionhash- 0xcf808000
981      * @param _keys number of keys desired (in 18 decimal format)
982      * @return amount of eth needed to send
983      */
984     function iWantXKeys(uint256 _keys)
985         public
986         view
987         returns(uint256)
988     {
989         // setup local rID
990         uint256 _rID = rID_;
991         
992         // grab time
993         uint256 _now = now;
994         
995         // are we in a round?
996         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
997             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
998         else // rounds over.  need price for new round
999             return ( (_keys).eth() );
1000     }
1001 
1002     /**
1003 	 * @dev receives name/player info from names contract 
1004      */
1005     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1006         external
1007     {
1008         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1009         if (pIDxAddr_[_addr] != _pID)
1010             pIDxAddr_[_addr] = _pID;
1011         if (pIDxName_[_name] != _pID)
1012             pIDxName_[_name] = _pID;
1013         if (plyr_[_pID].addr != _addr)
1014             plyr_[_pID].addr = _addr;
1015         if (plyr_[_pID].name != _name)
1016             plyr_[_pID].name = _name;
1017         if (plyr_[_pID].laff != _laff)
1018             plyr_[_pID].laff = _laff;
1019         if (plyrNames_[_pID][_name] == false)
1020             plyrNames_[_pID][_name] = true;
1021     }
1022     
1023     /**
1024      * @dev receives entire player name list 
1025      */
1026     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1027         external
1028     {
1029         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1030         if(plyrNames_[_pID][_name] == false)
1031             plyrNames_[_pID][_name] = true;
1032     }   
1033         
1034     /**
1035      * @dev gets existing or registers new pID.  use this when a player may be new
1036      * @return pID 
1037      */
1038     function determinePID(F4Ddatasets.EventReturns memory _eventData_)
1039         private
1040         returns (F4Ddatasets.EventReturns)
1041     {
1042         uint256 _pID = pIDxAddr_[msg.sender];
1043         // if player is new to this version of fomo3d
1044         if (_pID == 0)
1045         {
1046             // grab their player ID, name and last aff ID, from player names contract 
1047             _pID = PlayerBook.getPlayerID(msg.sender);
1048             bytes32 _name = PlayerBook.getPlayerName(_pID);
1049             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1050             
1051             // set up player account 
1052             pIDxAddr_[msg.sender] = _pID;
1053             plyr_[_pID].addr = msg.sender;
1054             
1055             if (_name != "")
1056             {
1057                 pIDxName_[_name] = _pID;
1058                 plyr_[_pID].name = _name;
1059                 plyrNames_[_pID][_name] = true;
1060             }
1061             
1062             if (_laff != 0 && _laff != _pID)
1063                 plyr_[_pID].laff = _laff;
1064             
1065             // set the new player bool to true
1066             _eventData_.compressedData = _eventData_.compressedData + 1;
1067         } 
1068         return (_eventData_);
1069     }
1070     
1071     /**
1072      * @dev checks to make sure user picked a valid team.  if not sets team 
1073      * to default (sneks)
1074      */
1075     function verifyTeam(uint256 _team)
1076         private
1077         pure
1078         returns (uint256)
1079     {
1080         if (_team < 0 || _team > 3)
1081             return(2);
1082         else
1083             return(_team);
1084     }
1085     
1086     /**
1087      * @dev decides if round end needs to be run & new round started.  and if 
1088      * player unmasked earnings from previously played rounds need to be moved.
1089      */
1090     function managePlayer(uint256 _pID, F4Ddatasets.EventReturns memory _eventData_)
1091         private
1092         returns (F4Ddatasets.EventReturns)
1093     {
1094         // if player has played a previous round, move their unmasked earnings
1095         // from that round to gen vault.
1096         if (plyr_[_pID].lrnd != 0)
1097             updateGenVault(_pID, plyr_[_pID].lrnd);
1098             
1099         // update player's last round played
1100         plyr_[_pID].lrnd = rID_;
1101             
1102         // set the joined round bool to true
1103         _eventData_.compressedData = _eventData_.compressedData + 10;
1104         
1105         return(_eventData_);
1106     }
1107     
1108     /**
1109      * @dev ends the round. manages paying out winner/splitting up pot
1110      */
1111     function endRound(F4Ddatasets.EventReturns memory _eventData_)
1112         private
1113         returns (F4Ddatasets.EventReturns)
1114     {
1115         // setup local rID
1116         uint256 _rID = rID_;
1117         
1118         // grab our winning player and team id's
1119         uint256 _winPID = round_[_rID].plyr;
1120         uint256 _winTID = round_[_rID].team;
1121         
1122         // grab our pot amount
1123         uint256 _pot = round_[_rID].pot;
1124         
1125         // calculate our winner share, community rewards, gen share, 
1126         // p3d share, and amount reserved for next pot 
1127         uint256 _win = (_pot.mul(48)) / 100;
1128         uint256 _own = (_pot.mul(14) / 100);
1129         owner_.transfer(_own);
1130         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1131         uint256 _res = (((_pot.sub(_win)).sub(_own)).sub(_gen));
1132         
1133         // calculate ppt for round mask
1134         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1135         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1136         if (_dust > 0)
1137         {
1138             _gen = _gen.sub(_dust);
1139             _res = _res.add(_dust);
1140         }
1141         
1142         // pay our winner
1143         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1144         
1145         
1146         // distribute gen portion to key holders
1147         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1148         
1149             
1150         // prepare event data
1151         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1152         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1153         _eventData_.winnerAddr = plyr_[_winPID].addr;
1154         _eventData_.winnerName = plyr_[_winPID].name;
1155         _eventData_.amountWon = _win;
1156         _eventData_.genAmount = _gen;
1157         _eventData_.newPot = _res;
1158         
1159         // start next round
1160         rID_++;
1161         _rID++;
1162         round_[_rID].strt = now;
1163         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1164         round_[_rID].pot = _res;
1165         
1166         return(_eventData_);
1167     }
1168     
1169     /**
1170      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1171      */
1172     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1173         private 
1174     {
1175         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1176         if (_earnings > 0)
1177         {
1178             // put in gen vault
1179             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1180             // zero out their earnings by updating mask
1181             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1182         }
1183     }
1184     
1185     /**
1186      * @dev updates round timer based on number of whole keys bought.
1187      */
1188     function updateTimer(uint256 _keys, uint256 _rID)
1189         private
1190     {
1191         // grab time
1192         uint256 _now = now;
1193         
1194         // calculate time based on number of keys bought
1195         uint256 _newTime;
1196         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1197             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1198         else
1199             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1200         
1201         // compare to max and set new end time
1202         if (_newTime < (rndMax_).add(_now))
1203             round_[_rID].end = _newTime;
1204         else
1205             round_[_rID].end = rndMax_.add(_now);
1206     }
1207 
1208     /**
1209      * @dev distributes eth based on fees to com, aff, and p3d
1210      */
1211     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, F4Ddatasets.EventReturns memory _eventData_)
1212         private
1213         returns(F4Ddatasets.EventReturns)
1214     {
1215         // pay 14% out to owner rewards
1216         uint256 _own = _eth.mul(14) / 100;
1217         owner_.transfer(_own);
1218         
1219         return(_eventData_);
1220     }
1221     
1222     function potSwap()
1223         external
1224         payable
1225     {
1226         // setup local rID
1227         uint256 _rID = rID_ + 1;
1228         
1229         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1230         emit F4Devents.onPotSwapDeposit(_rID, msg.value);
1231     }
1232     
1233     /**
1234      * @dev distributes eth based on fees to gen and pot
1235      */
1236     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, F4Ddatasets.EventReturns memory _eventData_)
1237         private
1238         returns(F4Ddatasets.EventReturns)
1239     {
1240         // calculate gen share
1241         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1242 
1243         // distribute share to affiliate 10%
1244         uint256 _aff = _eth / 10;
1245         
1246         // decide what to do with affiliate share of fees
1247         // affiliate must not be self, and must have a name registered
1248         if (_affID != _pID && plyr_[_affID].name != '') {
1249             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1250             emit F4Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1251         } else {
1252             _gen = _gen.add(_aff);
1253             _aff = 0;
1254         }
1255         
1256         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1257         _eth = _eth.sub((_eth.mul(14)) / 100);
1258         
1259         // calculate pot 
1260         uint256 _pot = _eth.sub(_gen).sub(_aff);
1261         
1262         // distribute gen share (thats what updateMasks() does) and adjust
1263         // balances for dust.
1264         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1265         if (_dust > 0)
1266         {
1267             _gen = _gen.sub(_dust);
1268             _pot = _pot.add(_dust);
1269         }
1270         
1271         // add eth to pot
1272         round_[_rID].pot = _pot.add(round_[_rID].pot);
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
1285     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
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
1301         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1302         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1303             
1304         // calculate player earning from their own buy (only based on the keys
1305         // they just bought).  & update player earnings mask
1306         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1307         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1308         
1309         // calculate & return dust
1310         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
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
1322         updateGenVault(_pID, plyr_[_pID].lrnd);
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
1339     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F4Ddatasets.EventReturns memory _eventData_)
1340         private
1341     {
1342         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1343         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1344         
1345         emit F4Devents.onEndTx
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
1358             _eventData_.potAmount
1359         );
1360     }
1361     /** upon contract deploy, it will be deactivated.  this is a one time
1362      * use function that will activate the contract.  we do this so devs 
1363      * have time to set things up on the web end                            **/
1364     bool public activated_ = false;
1365     function activate()
1366         public
1367     {
1368         // only team just can activate 
1369         require(
1370             msg.sender == owner_,
1371             "only team just can activate"
1372         );
1373         
1374         // can only be ran once
1375         require(activated_ == false, "fomo3d already activated");
1376         
1377         // activate the contract 
1378         activated_ = true;
1379         
1380         // lets start first round
1381 		rID_ = 1;
1382         round_[1].strt = now + rndExtra_ - rndGap_;
1383         round_[1].end = now + rndInit_ + rndExtra_;
1384     }
1385 }
1386 
1387 //structs
1388 library F4Ddatasets {
1389     //compressedData key
1390     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1391         // 0 - new player (bool)
1392         // 1 - joined round (bool)
1393         // 2 - new  leader (bool)
1394         // 6-16 - round end time
1395         // 17 - winnerTeam
1396         // 18 - 28 timestamp 
1397         // 29 - team
1398         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1399     //compressedIDs key
1400     // [77-52][51-26][25-0]
1401         // 0-25 - pID 
1402         // 26-51 - winPID
1403         // 52-77 - rID
1404     struct EventReturns {
1405         uint256 compressedData;
1406         uint256 compressedIDs;
1407         address winnerAddr;         // winner address
1408         bytes32 winnerName;         // winner name
1409         uint256 amountWon;          // amount won
1410         uint256 newPot;             // amount in new pot
1411         uint256 genAmount;          // amount distributed to gen
1412         uint256 potAmount;          // amount added to pot
1413     }
1414     struct Player {
1415         address addr;   // player address
1416         bytes32 name;   // player name
1417         uint256 win;    // winnings vault
1418         uint256 gen;    // general vault
1419         uint256 aff;    // affiliate vault
1420         uint256 lrnd;   // last round played
1421         uint256 laff;   // last affiliate id used
1422     }
1423     struct PlayerRounds {
1424         uint256 eth;    // eth player has added to round (used for eth limiter)
1425         uint256 keys;   // keys
1426         uint256 mask;   // player mask 
1427     }
1428     struct Round {
1429         uint256 plyr;   // pID of player in lead
1430         uint256 team;   // tID of team in lead
1431         uint256 end;    // time ends/ended
1432         bool ended;     // has round end function been ran
1433         uint256 strt;   // time round started
1434         uint256 keys;   // keys
1435         uint256 eth;    // total eth in
1436         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1437         uint256 mask;   // global mask
1438     }
1439     struct TeamFee {
1440         uint256 gen;    // % of buy in thats paid to key holders of current round
1441     }
1442     struct PotSplit {
1443         uint256 gen;    // % of pot thats paid to key holders of current round
1444     }
1445 }
1446 
1447 library F4DKeysCalcLong {
1448     using SafeMath for *;
1449     /**
1450      * @dev calculates number of keys received given X eth 
1451      * @param _curEth current amount of eth in contract 
1452      * @param _newEth eth being spent
1453      * @return amount of ticket purchased
1454      */
1455     function keysRec(uint256 _curEth, uint256 _newEth)
1456         internal
1457         pure
1458         returns (uint256)
1459     {
1460         return(
1461                 keys((_curEth).add(_newEth))
1462                 .sub(
1463                     keys(_curEth)
1464                 ) 
1465         );
1466     }
1467     
1468     /**
1469      * @dev calculates amount of eth received if you sold X keys 
1470      * @param _curKeys current amount of keys that exist 
1471      * @param _sellKeys amount of keys you wish to sell
1472      * @return amount of eth received
1473      */
1474     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1475         internal
1476         pure
1477         returns (uint256)
1478     {
1479         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1480     }
1481 
1482     /**
1483      * @dev calculates how many keys would exist with given an amount of eth
1484      * @param _eth eth "in contract"
1485      * @return number of keys that would exist
1486      */
1487     function keys(uint256 _eth) 
1488         internal
1489         pure
1490         returns(uint256)
1491     {
1492         // (sqrt(_eth * 10^18 * 312500000 * 10 ^ 18 + 5624988281256103515625000000000000000000000000 * 10 ^ 18) - 74999921875000 * 10 ^ 18) / 156250000
1493         return (
1494                     (
1495                         (
1496                             (
1497                                 (
1498                                     (_eth).mul(1000000000000000000)
1499                                 ).mul(312500000000000000000000000)
1500                             ).add(5624988281256103515625000000000000000000000000000000000000000000)
1501                         ).sqrt()
1502                     ).sub(74999921875000000000000000000000)
1503                 ) / (156250000);
1504     }
1505     
1506     /**
1507      * @dev calculates how much eth would be in contract given a number of keys
1508      * @param _keys number of keys "in contract" 
1509      * @return eth that would exists
1510      */
1511     function eth(uint256 _keys) 
1512         internal
1513         pure
1514         returns(uint256)  
1515     {
1516         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1517     }
1518 }
1519 
1520 interface PlayerBookInterface {
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
1531 
1532 library NameFilter {
1533     /**
1534      * @dev filters name strings
1535      * -converts uppercase to lower case.  
1536      * -makes sure it does not start/end with a space
1537      * -makes sure it does not contain multiple spaces in a row
1538      * -cannot be only numbers
1539      * -cannot start with 0x 
1540      * -restricts characters to A-Z, a-z, 0-9, and space.
1541      * @return reprocessed string in bytes32 format
1542      */
1543     function nameFilter(string _input)
1544         internal
1545         pure
1546         returns(bytes32)
1547     {
1548         bytes memory _temp = bytes(_input);
1549         uint256 _length = _temp.length;
1550         
1551         //sorry limited to 32 characters
1552         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1553         // make sure it doesnt start with or end with space
1554         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1555         // make sure first two characters are not 0x
1556         if (_temp[0] == 0x30)
1557         {
1558             require(_temp[1] != 0x78, "string cannot start with 0x");
1559             require(_temp[1] != 0x58, "string cannot start with 0X");
1560         }
1561         
1562         // create a bool to track if we have a non number character
1563         bool _hasNonNumber;
1564         
1565         // convert & check
1566         for (uint256 i = 0; i < _length; i++)
1567         {
1568             // if its uppercase A-Z
1569             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1570             {
1571                 // convert to lower case a-z
1572                 _temp[i] = byte(uint(_temp[i]) + 32);
1573                 
1574                 // we have a non number
1575                 if (_hasNonNumber == false)
1576                     _hasNonNumber = true;
1577             } else {
1578                 require
1579                 (
1580                     // require character is a space
1581                     _temp[i] == 0x20 || 
1582                     // OR lowercase a-z
1583                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1584                     // or 0-9
1585                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1586                     "string contains invalid characters"
1587                 );
1588                 // make sure theres not 2x spaces in a row
1589                 if (_temp[i] == 0x20)
1590                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1591                 
1592                 // see if we have a character other than a number
1593                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1594                     _hasNonNumber = true;    
1595             }
1596         }
1597         
1598         require(_hasNonNumber == true, "string cannot be only numbers");
1599         
1600         bytes32 _ret;
1601         assembly {
1602             _ret := mload(add(_temp, 32))
1603         }
1604         return (_ret);
1605     }
1606 }
1607 
1608 /**
1609  * @title SafeMath v0.1.9
1610  * @dev Math operations with safety checks that throw on error
1611  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1612  * - added sqrt
1613  * - added sq
1614  * - added pwr 
1615  * - changed asserts to requires with error log outputs
1616  * - removed div, its useless
1617  */
1618 library SafeMath {
1619     
1620     /**
1621     * @dev Multiplies two numbers, throws on overflow.
1622     */
1623     function mul(uint256 a, uint256 b) 
1624         internal 
1625         pure 
1626         returns (uint256 c) 
1627     {
1628         if (a == 0) {
1629             return 0;
1630         }
1631         c = a * b;
1632         require(c / a == b, "SafeMath mul failed");
1633         return c;
1634     }
1635 
1636     /**
1637     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1638     */
1639     function sub(uint256 a, uint256 b)
1640         internal
1641         pure
1642         returns (uint256) 
1643     {
1644         require(b <= a, "SafeMath sub failed");
1645         return a - b;
1646     }
1647 
1648     /**
1649     * @dev Adds two numbers, throws on overflow.
1650     */
1651     function add(uint256 a, uint256 b)
1652         internal
1653         pure
1654         returns (uint256 c) 
1655     {
1656         c = a + b;
1657         require(c >= a, "SafeMath add failed");
1658         return c;
1659     }
1660     
1661     /**
1662      * @dev gives square root of given x.
1663      */
1664     function sqrt(uint256 x)
1665         internal
1666         pure
1667         returns (uint256 y) 
1668     {
1669         uint256 z = ((add(x,1)) / 2);
1670         y = x;
1671         while (z < y) 
1672         {
1673             y = z;
1674             z = ((add((x / z),z)) / 2);
1675         }
1676     }
1677     
1678     /**
1679      * @dev gives square. multiplies x by x
1680      */
1681     function sq(uint256 x)
1682         internal
1683         pure
1684         returns (uint256)
1685     {
1686         return (mul(x,x));
1687     }
1688     
1689     /**
1690      * @dev x to the power of y 
1691      */
1692     function pwr(uint256 x, uint256 y)
1693         internal 
1694         pure 
1695         returns (uint256)
1696     {
1697         if (x==0)
1698             return (0);
1699         else if (y==0)
1700             return (1);
1701         else 
1702         {
1703             uint256 z = x;
1704             for (uint256 i=1; i < y; i++)
1705                 z = mul(z,x);
1706             return (z);
1707         }
1708     }
1709 }