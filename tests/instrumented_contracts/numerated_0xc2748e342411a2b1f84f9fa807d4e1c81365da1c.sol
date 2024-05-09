1 pragma solidity ^0.4.24;
2 contract F4Devents {
3     // fired whenever a player registers a name
4     event onNewName
5     (
6         uint256 indexed playerID,
7         address indexed playerAddress,
8         bytes32 indexed playerName,
9         bool isNewPlayer,
10         uint256 affiliateID,
11         address affiliateAddress,
12         bytes32 affiliateName,
13         uint256 amountPaid,
14         uint256 timeStamp
15     );
16     
17     // fired at end of buy or reload
18     event onEndTx
19     (
20         uint256 compressedData,     
21         uint256 compressedIDs,      
22         bytes32 playerName,
23         address playerAddress,
24         uint256 ethIn,
25         uint256 keysBought,
26         address winnerAddr,
27         bytes32 winnerName,
28         uint256 amountWon,
29         uint256 newPot,
30         uint256 P3DAmount,
31         uint256 genAmount,
32         uint256 potAmount
33     );
34     
35 	// fired whenever theres a withdraw
36     event onWithdraw
37     (
38         uint256 indexed playerID,
39         address playerAddress,
40         bytes32 playerName,
41         uint256 ethOut,
42         uint256 timeStamp
43     );
44     
45     // fired whenever a withdraw forces end round to be ran
46     event onWithdrawAndDistribute
47     (
48         address playerAddress,
49         bytes32 playerName,
50         uint256 ethOut,
51         uint256 compressedData,
52         uint256 compressedIDs,
53         address winnerAddr,
54         bytes32 winnerName,
55         uint256 amountWon,
56         uint256 newPot,
57         uint256 P3DAmount,
58         uint256 genAmount
59     );
60     
61     // (FoMo4D long only) fired whenever a player tries a buy after round timer 
62     // hit zero, and causes end round to be ran.
63     event onBuyAndDistribute
64     (
65         address playerAddress,
66         bytes32 playerName,
67         uint256 ethIn,
68         uint256 compressedData,
69         uint256 compressedIDs,
70         address winnerAddr,
71         bytes32 winnerName,
72         uint256 amountWon,
73         uint256 newPot,
74         uint256 P3DAmount,
75         uint256 genAmount
76     );
77     
78     // (FoMo4D long only) fired whenever a player tries a reload after round timer 
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
90         uint256 P3DAmount,
91         uint256 genAmount
92     );
93     
94     // fired whenever an affiliate is paid
95     event onAffiliatePayout
96     (
97         uint256 indexed affiliateID,
98         address affiliateAddress,
99         bytes32 affiliateName,
100         uint256 indexed roundID,
101         uint256 indexed buyerID,
102         uint256 amount,
103         uint256 timeStamp
104     );
105     
106     // received pot swap deposit
107     event onPotSwapDeposit
108     (
109         uint256 roundID,
110         uint256 amountAddedToPot
111     );
112 }
113 
114 contract FoMo4DSoon is F4Devents{
115     using SafeMath for uint256;
116     using NameFilter for string;
117     using F4DKeysCalcFast for uint256;
118     
119     address private owner_;
120 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xeB367060583fd067Edec36202339360071e617Db);
121     string constant public name = "Fomo4D Soon";
122     string constant public symbol = "F4D";
123 	uint256 private rndGap_ = 60 seconds;                       // length of ICO phase, set to 1 year for EOS.
124     uint256 constant private rndInit_ = 5 minutes;              // round timer starts at this
125     uint256 constant private rndInc_ = 5 minutes;               // every full key purchased adds this much to the timer
126     uint256 constant private rndMax_ = 5 minutes;               // max length a round timer can be
127     uint256 public rID_;    // round id number / total rounds that have happened
128 //****************
129 // PLAYER DATA 
130 //****************
131     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
132     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
133     mapping (uint256 => F4Ddatasets.Player) public plyr_;   // (pID => data) player data
134     mapping (uint256 => mapping (uint256 => F4Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
135     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
136 //****************
137 // ROUND DATA 
138 //****************
139     mapping (uint256 => F4Ddatasets.Round) public round_;   // (rID => data) round data
140     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
141 //****************
142 // TEAM FEE DATA 
143 //****************
144     mapping (uint256 => F4Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
145     mapping (uint256 => F4Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
146     
147     constructor()
148         public
149     {
150         owner_ = msg.sender;
151 		// Team allocation structures
152         // 0 = whales
153         // 1 = bears
154         // 2 = sneks
155         // 3 = bulls
156 
157         fees_[0] = F4Ddatasets.TeamFee(24);
158         fees_[1] = F4Ddatasets.TeamFee(38);
159         fees_[2] = F4Ddatasets.TeamFee(50);
160         fees_[3] = F4Ddatasets.TeamFee(42);
161          
162         potSplit_[0] = F4Ddatasets.PotSplit(12);
163         potSplit_[1] = F4Ddatasets.PotSplit(19);
164         potSplit_[2] = F4Ddatasets.PotSplit(26);
165         potSplit_[3] = F4Ddatasets.PotSplit(30);
166 	}
167     
168     /**
169      * @dev used to make sure no one can interact with contract until it has 
170      * been activated. 
171      */
172     modifier isActivated() {
173         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
174         _;
175     }
176     
177     /**
178      * @dev prevents contracts from interacting with FoMo4D 
179      */
180     modifier isHuman() {
181         address _addr = msg.sender;
182         require (_addr == tx.origin);
183         
184         uint256 _codeLength;
185         
186         assembly {_codeLength := extcodesize(_addr)}
187         require(_codeLength == 0, "sorry humans only");
188         _;
189     }
190 
191     /**
192      * @dev sets boundaries for incoming tx 
193      */
194     modifier isWithinLimits(uint256 _eth) {
195         require(_eth >= 1000000000, "pocket lint: not a valid currency");
196         require(_eth <= 100000000000000000000000, "no vitalik, no");    /** NOTE THIS NEEDS TO BE CHECKED **/
197 		_;    
198 	}
199     
200     /**
201      * @dev emergency buy uses last stored affiliate ID and team snek
202      */
203     function()
204         isActivated()
205         isHuman()
206         isWithinLimits(msg.value)
207         public
208         payable
209     {
210         // set up our tx event data and determine if player is new or not
211         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
212         
213         // fetch player id
214         uint256 _pID = pIDxAddr_[msg.sender];
215         
216         // buy core 
217         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
218     }
219     
220     /**
221      * @dev converts all incoming ethereum to keys.
222      * -functionhash- 0x8f38f309 (using ID for affiliate)
223      * -functionhash- 0x98a0871d (using address for affiliate)
224      * -functionhash- 0xa65b37a1 (using name for affiliate)
225      * @param _affCode the ID/address/name of the player who gets the affiliate fee
226      * @param _team what team is the player playing for?
227      */
228     function buyXid(uint256 _affCode, uint256 _team)
229         isActivated()
230         isHuman()
231         isWithinLimits(msg.value)
232         public
233         payable
234     {
235         // set up our tx event data and determine if player is new or not
236         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
237         
238         // fetch player id
239         uint256 _pID = pIDxAddr_[msg.sender];
240         
241         // manage affiliate residuals
242         // if no affiliate code was given or player tried to use their own, lolz
243         if (_affCode == 0 || _affCode == _pID)
244         {
245             // use last stored affiliate code 
246             _affCode = plyr_[_pID].laff;
247             
248         // if affiliate code was given & its not the same as previously stored 
249         } else if (_affCode != plyr_[_pID].laff) {
250             // update last affiliate 
251             plyr_[_pID].laff = _affCode;
252         }
253         
254         // verify a valid team was selected
255         _team = verifyTeam(_team);
256         
257         // buy core 
258         buyCore(_pID, _affCode, _team, _eventData_);
259     }
260     
261     function buyXaddr(address _affCode, uint256 _team)
262         isActivated()
263         isHuman()
264         isWithinLimits(msg.value)
265         public
266         payable
267     {
268         // set up our tx event data and determine if player is new or not
269         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
270         
271         // fetch player id
272         uint256 _pID = pIDxAddr_[msg.sender];
273         
274         // manage affiliate residuals
275         uint256 _affID;
276         // if no affiliate code was given or player tried to use their own, lolz
277         if (_affCode == address(0) || _affCode == msg.sender)
278         {
279             // use last stored affiliate code
280             _affID = plyr_[_pID].laff;
281         
282         // if affiliate code was given    
283         } else {
284             // get affiliate ID from aff Code 
285             _affID = pIDxAddr_[_affCode];
286             
287             // if affID is not the same as previously stored 
288             if (_affID != plyr_[_pID].laff)
289             {
290                 // update last affiliate
291                 plyr_[_pID].laff = _affID;
292             }
293         }
294         
295         // verify a valid team was selected
296         _team = verifyTeam(_team);
297         
298         // buy core 
299         buyCore(_pID, _affID, _team, _eventData_);
300     }
301     
302     function buyXname(bytes32 _affCode, uint256 _team)
303         isActivated()
304         isHuman()
305         isWithinLimits(msg.value)
306         public
307         payable
308     {
309         // set up our tx event data and determine if player is new or not
310         F4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
311         
312         // fetch player id
313         uint256 _pID = pIDxAddr_[msg.sender];
314         
315         // manage affiliate residuals
316         uint256 _affID;
317         // if no affiliate code was given or player tried to use their own, lolz
318         if (_affCode == '' || _affCode == plyr_[_pID].name)
319         {
320             // use last stored affiliate code
321             _affID = plyr_[_pID].laff;
322         
323         // if affiliate code was given
324         } else {
325             // get affiliate ID from aff Code
326             _affID = pIDxName_[_affCode];
327             
328             // if affID is not the same as previously stored
329             if (_affID != plyr_[_pID].laff)
330             {
331                 // update last affiliate
332                 plyr_[_pID].laff = _affID;
333             }
334         }
335         
336         // verify a valid team was selected
337         _team = verifyTeam(_team);
338         
339         // buy core 
340         buyCore(_pID, _affID, _team, _eventData_);
341     }
342     
343     /**
344      * @dev essentially the same as buy, but instead of you sending ether 
345      * from your wallet, it uses your unwithdrawn earnings.
346      * -functionhash- 0x349cdcac (using ID for affiliate)
347      * -functionhash- 0x82bfc739 (using address for affiliate)
348      * -functionhash- 0x079ce327 (using name for affiliate)
349      * @param _affCode the ID/address/name of the player who gets the affiliate fee
350      * @param _team what team is the player playing for?
351      * @param _eth amount of earnings to use (remainder returned to gen vault)
352      */
353     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
354         isActivated()
355         isHuman()
356         isWithinLimits(_eth)
357         public
358     {
359         // set up our tx event data
360         F4Ddatasets.EventReturns memory _eventData_;
361         
362         // fetch player ID
363         uint256 _pID = pIDxAddr_[msg.sender];
364         
365         // manage affiliate residuals
366         // if no affiliate code was given or player tried to use their own, lolz
367         if (_affCode == 0 || _affCode == _pID)
368         {
369             // use last stored affiliate code 
370             _affCode = plyr_[_pID].laff;
371             
372         // if affiliate code was given & its not the same as previously stored 
373         } else if (_affCode != plyr_[_pID].laff) {
374             // update last affiliate 
375             plyr_[_pID].laff = _affCode;
376         }
377 
378         // verify a valid team was selected
379         _team = verifyTeam(_team);
380             
381         // reload core
382         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
383     }
384     
385     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
386         isActivated()
387         isHuman()
388         isWithinLimits(_eth)
389         public
390     {
391         // set up our tx event data
392         F4Ddatasets.EventReturns memory _eventData_;
393         
394         // fetch player ID
395         uint256 _pID = pIDxAddr_[msg.sender];
396         
397         // manage affiliate residuals
398         uint256 _affID;
399         // if no affiliate code was given or player tried to use their own, lolz
400         if (_affCode == address(0) || _affCode == msg.sender)
401         {
402             // use last stored affiliate code
403             _affID = plyr_[_pID].laff;
404         
405         // if affiliate code was given    
406         } else {
407             // get affiliate ID from aff Code 
408             _affID = pIDxAddr_[_affCode];
409             
410             // if affID is not the same as previously stored 
411             if (_affID != plyr_[_pID].laff)
412             {
413                 // update last affiliate
414                 plyr_[_pID].laff = _affID;
415             }
416         }
417         
418         // verify a valid team was selected
419         _team = verifyTeam(_team);
420         
421         // reload core
422         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
423     }
424     
425     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
426         isActivated()
427         isHuman()
428         isWithinLimits(_eth)
429         public
430     {
431         // set up our tx event data
432         F4Ddatasets.EventReturns memory _eventData_;
433         
434         // fetch player ID
435         uint256 _pID = pIDxAddr_[msg.sender];
436         
437         // manage affiliate residuals
438         uint256 _affID;
439         // if no affiliate code was given or player tried to use their own, lolz
440         if (_affCode == '' || _affCode == plyr_[_pID].name)
441         {
442             // use last stored affiliate code
443             _affID = plyr_[_pID].laff;
444         
445         // if affiliate code was given
446         } else {
447             // get affiliate ID from aff Code
448             _affID = pIDxName_[_affCode];
449             
450             // if affID is not the same as previously stored
451             if (_affID != plyr_[_pID].laff)
452             {
453                 // update last affiliate
454                 plyr_[_pID].laff = _affID;
455             }
456         }
457         
458         // verify a valid team was selected
459         _team = verifyTeam(_team);
460         
461         // reload core
462         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
463     }
464 
465     /**
466      * @dev withdraws all of your earnings.
467      * -functionhash- 0x3ccfd60b
468      */
469     function withdraw()
470         isActivated()
471         isHuman()
472         public
473     {
474         // setup local rID
475         uint256 _rID = rID_;
476         
477         // grab time
478         uint256 _now = now;
479         
480         // fetch player ID
481         uint256 _pID = pIDxAddr_[msg.sender];
482         
483         // setup temp var for player eth
484         uint256 _eth;
485         
486         // check to see if round has ended and no one has run round end yet
487         if (_now > round_[_rID].end && round_[_rID].ended == false)
488         {
489             // set up our tx event data
490             F4Ddatasets.EventReturns memory _eventData_;
491             
492             // end the round (distributes pot)
493 			round_[_rID].ended = true;
494             _eventData_ = endRound(_eventData_);
495             
496 			// get their earnings
497             _eth = withdrawEarnings(_pID);
498             
499             // gib moni
500             if (_eth > 0)
501                 plyr_[_pID].addr.transfer(_eth);    
502             
503             // build event data
504             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
505             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
506             
507             // fire withdraw and distribute event
508             emit F4Devents.onWithdrawAndDistribute
509             (
510                 msg.sender, 
511                 plyr_[_pID].name, 
512                 _eth, 
513                 _eventData_.compressedData, 
514                 _eventData_.compressedIDs, 
515                 _eventData_.winnerAddr, 
516                 _eventData_.winnerName, 
517                 _eventData_.amountWon, 
518                 _eventData_.newPot, 
519                 _eventData_.P3DAmount, 
520                 _eventData_.genAmount
521             );
522             
523         // in any other situation
524         } else {
525             // get their earnings
526             _eth = withdrawEarnings(_pID);
527             
528             // gib moni
529             if (_eth > 0)
530                 plyr_[_pID].addr.transfer(_eth);
531             
532             // fire withdraw event
533             emit F4Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
534         }
535     }
536     
537     /**
538      * @dev use these to register names.  they are just wrappers that will send the
539      * registration requests to the PlayerBook contract.  So registering here is the 
540      * same as registering there.  UI will always display the last name you registered.
541      * but you will still own all previously registered names to use as affiliate 
542      * links.
543      * - must pay a registration fee.
544      * - name must be unique
545      * - names will be converted to lowercase
546      * - name cannot start or end with a space 
547      * - cannot have more than 1 space in a row
548      * - cannot be only numbers
549      * - cannot start with 0x 
550      * - name must be at least 1 char
551      * - max length of 32 characters long
552      * - allowed characters: a-z, 0-9, and space
553      * -functionhash- 0x921dec21 (using ID for affiliate)
554      * -functionhash- 0x3ddd4698 (using address for affiliate)
555      * -functionhash- 0x685ffd83 (using name for affiliate)
556      * @param _nameString players desired name
557      * @param _affCode affiliate ID, address, or name of who referred you
558      * @param _all set to true if you want this to push your info to all games 
559      * (this might cost a lot of gas)
560      */
561     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
562         isHuman()
563         public
564         payable
565     {
566         bytes32 _name = _nameString.nameFilter();
567         address _addr = msg.sender;
568         uint256 _paid = msg.value;
569         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
570         
571         uint256 _pID = pIDxAddr_[_addr];
572         
573         // fire event
574         emit F4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
575     }
576     
577     function registerNameXaddr(string _nameString, address _affCode, bool _all)
578         isHuman()
579         public
580         payable
581     {
582         bytes32 _name = _nameString.nameFilter();
583         address _addr = msg.sender;
584         uint256 _paid = msg.value;
585         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
586         
587         uint256 _pID = pIDxAddr_[_addr];
588         
589         // fire event
590         emit F4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
591     }
592     
593     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
594         isHuman()
595         public
596         payable
597     {
598         bytes32 _name = _nameString.nameFilter();
599         address _addr = msg.sender;
600         uint256 _paid = msg.value;
601         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
602         
603         uint256 _pID = pIDxAddr_[_addr];
604         
605         // fire event
606         emit F4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
607     }
608     
609     /**
610      * @dev return the price buyer will pay for next 1 individual key.
611      * - during live round.  this is accurate. (well... unless someone buys before 
612      * you do and ups the price!  you better HURRY!)
613      * - during ICO phase.  this is the max you would get based on current eth 
614      * invested during ICO phase.  if others invest after you, you will receive
615      * less.  (so distract them with meme vids till ICO is over)
616      * -functionhash- 0x018a25e8
617      * @return price for next key bought (in wei format)
618      */
619     function getBuyPrice()
620         public 
621         view 
622         returns(uint256)
623     {  
624         // setup local rID
625         uint256 _rID = rID_;
626             
627         // grab time
628         uint256 _now = now;
629         
630         // is ICO phase over??  & theres eth in the round?
631         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
632             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
633         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
634             return ( ((round_[_rID].ico.keys()).add(1000000000000000000)).ethRec(1000000000000000000) );
635         else // rounds over.  need price for new round
636             return ( 100000000000000 ); // init
637     }
638     
639     /**
640      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
641      * provider
642      * -functionhash- 0xc7e284b8
643      * @return time left in seconds
644      */
645     function getTimeLeft()
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
656         // are we in ICO phase?
657         if (_now <= round_[_rID].strt + rndGap_)
658             return( ((round_[_rID].end).sub(rndInit_)).sub(_now) );
659         else 
660             if (_now < round_[_rID].end)
661                 return( (round_[_rID].end).sub(_now) );
662             else
663                 return(0);
664     }
665     
666     /**
667      * @dev returns player earnings per vaults 
668      * -functionhash- 0x63066434
669      * @return winnings vault
670      * @return general vault
671      * @return affiliate vault
672      */
673     function getPlayerVaults(uint256 _pID)
674         public
675         view
676         returns(uint256 ,uint256, uint256)
677     {
678         // setup local rID
679         uint256 _rID = rID_;
680         
681         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
682         if (now > round_[_rID].end && round_[_rID].ended == false)
683         {
684             uint256 _roundMask;
685             uint256 _roundEth;
686             uint256 _roundKeys;
687             uint256 _roundPot;
688             if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
689             {
690                 // create a temp round eth based on eth sent in during ICO phase
691                 _roundEth = round_[_rID].ico;
692                 
693                 // create a temp round keys based on keys bought during ICO phase
694                 _roundKeys = (round_[_rID].ico).keys();
695                 
696                 // create a temp round mask based on eth and keys from ICO phase
697                 _roundMask = ((round_[_rID].icoGen).mul(1000000000000000000)) / _roundKeys;
698                 
699                 // create a temp rount pot based on pot, and dust from mask
700                 _roundPot = (round_[_rID].pot).add((round_[_rID].icoGen).sub((_roundMask.mul(_roundKeys)) / (1000000000000000000)));
701             } else {
702                 _roundEth = round_[_rID].eth;
703                 _roundKeys = round_[_rID].keys;
704                 _roundMask = round_[_rID].mask;
705                 _roundPot = round_[_rID].pot;
706             }
707             
708             uint256 _playerKeys;
709             if (plyrRnds_[_pID][plyr_[_pID].lrnd].ico == 0)
710                 _playerKeys = plyrRnds_[_pID][plyr_[_pID].lrnd].keys;
711             else
712                 _playerKeys = calcPlayerICOPhaseKeys(_pID, _rID);
713             
714             // if player is winner 
715             if (round_[_rID].plyr == _pID)
716             {
717                 return
718                 (
719                     (plyr_[_pID].win).add( (_roundPot.mul(48)) / 100 ),
720                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
721                     plyr_[_pID].aff
722                 );
723             // if player is not the winner
724             } else {
725                 return
726                 (
727                     plyr_[_pID].win,   
728                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
729                     plyr_[_pID].aff
730                 );
731             }
732             
733         // if round is still going on, we are in ico phase, or round has ended and round end has been ran
734         } else {
735             return
736             (
737                 plyr_[_pID].win,
738                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
739                 plyr_[_pID].aff
740             );
741         }
742     }
743     
744     /**
745      * solidity hates stack limits.  this lets us avoid that hate 
746      */
747     function getPlayerVaultsHelper(uint256 _pID, uint256 _roundMask, uint256 _roundPot, uint256 _roundKeys, uint256 _playerKeys)
748         private
749         view
750         returns(uint256)
751     {
752         return(  (((_roundMask.add((((_roundPot.mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000)) / _roundKeys)).mul(_playerKeys)) / 1000000000000000000).sub(plyrRnds_[_pID][rID_].mask)  );
753     }
754     
755     /**
756      * @dev returns all current round info needed for front end
757      * -functionhash- 0x747dff42
758      * @return eth invested during ICO phase
759      * @return round id 
760      * @return total keys for round 
761      * @return time round ends
762      * @return time round started
763      * @return current pot 
764      * @return current team ID & player ID in lead 
765      * @return current player in leads address 
766      * @return current player in leads name
767      * @return whales eth in for round
768      * @return bears eth in for round
769      * @return sneks eth in for round
770      * @return bulls eth in for round
771      */
772     function getCurrentRoundInfo()
773         public
774         view
775         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
776     {
777         // setup local rID
778         uint256 _rID = rID_;
779         
780         if (round_[_rID].eth != 0)
781         {
782             return
783             (
784                 round_[_rID].ico,               //0
785                 _rID,                           //1
786                 round_[_rID].keys,              //2
787                 round_[_rID].end,               //3
788                 round_[_rID].strt,              //4
789                 round_[_rID].pot,               //5
790                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
791                 plyr_[round_[_rID].plyr].addr,  //7
792                 plyr_[round_[_rID].plyr].name,  //8
793                 rndTmEth_[_rID][0],             //9
794                 rndTmEth_[_rID][1],             //10
795                 rndTmEth_[_rID][2],             //11
796                 rndTmEth_[_rID][3]              //12
797             );
798         } else {
799             return
800             (
801                 round_[_rID].ico,               //0
802                 _rID,                           //1
803                 (round_[_rID].ico).keys(),      //2
804                 round_[_rID].end,               //3
805                 round_[_rID].strt,              //4
806                 round_[_rID].pot,               //5
807                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
808                 plyr_[round_[_rID].plyr].addr,  //7
809                 plyr_[round_[_rID].plyr].name,  //8
810                 rndTmEth_[_rID][0],             //9
811                 rndTmEth_[_rID][1],             //10
812                 rndTmEth_[_rID][2],             //11
813                 rndTmEth_[_rID][3]              //12
814             );
815         }
816     }
817 
818     /**
819      * @dev returns player info based on address.  if no address is given, it will 
820      * use msg.sender 
821      * -functionhash- 0xee0b5d8b
822      * @param _addr address of the player you want to lookup 
823      * @return player ID 
824      * @return player name
825      * @return keys owned (current round)
826      * @return winnings vault
827      * @return general vault 
828      * @return affiliate vault 
829 	 * @return player ico eth
830      */
831     function getPlayerInfoByAddress(address _addr)
832         public 
833         view 
834         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
835     {
836         // setup local rID
837         uint256 _rID = rID_;
838         
839         if (_addr == address(0))
840         {
841             _addr == msg.sender;
842         }
843         uint256 _pID = pIDxAddr_[_addr];
844         
845         if (plyrRnds_[_pID][_rID].ico == 0)
846         {
847             return
848             (
849                 _pID,                               //0
850                 plyr_[_pID].name,                   //1
851                 plyrRnds_[_pID][_rID].keys,         //2
852                 plyr_[_pID].win,                    //3
853                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
854                 plyr_[_pID].aff,                    //5
855 				0						            //6
856             );
857         } else {
858             return
859             (
860                 _pID,                               //0
861                 plyr_[_pID].name,                   //1
862                 calcPlayerICOPhaseKeys(_pID, _rID), //2
863                 plyr_[_pID].win,                    //3
864                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
865                 plyr_[_pID].aff,                    //5
866 				plyrRnds_[_pID][_rID].ico           //6
867             );
868         }
869         
870     }
871 
872 
873     /**
874      * @dev logic runs whenever a buy order is executed.  determines how to handle 
875      * incoming eth depending on if we are in ICO phase or not 
876      */
877     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F4Ddatasets.EventReturns memory _eventData_)
878         private
879     {
880         // check to see if round has ended.  and if player is new to round
881         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
882         
883         // are we in ICO phase?
884         if (now <= round_[rID_].strt + rndGap_) 
885         {
886             // let event data know this is a ICO phase buy order
887             _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;
888         
889             // ICO phase core
890             icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);
891         
892         
893         // round is live
894         } else {
895              // let event data know this is a buy order
896             _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;
897         
898             // call core
899             core(_pID, msg.value, _affID, _team, _eventData_);
900         }
901     }
902 
903     /**
904      * @dev logic runs whenever a reload order is executed.  determines how to handle 
905      * incoming eth depending on if we are in ICO phase or not 
906      */
907     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F4Ddatasets.EventReturns memory _eventData_)
908         private 
909     {
910         // check to see if round has ended.  and if player is new to round
911         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
912         
913         // get earnings from all vaults and return unused to gen vault
914         // because we use a custom safemath library.  this will throw if player 
915         // tried to spend more eth than they have.
916         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
917                 
918         // are we in ICO phase?
919         if (now <= round_[rID_].strt + rndGap_) 
920         {
921             // let event data know this is an ICO phase reload 
922             _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;
923                 
924             // ICO phase core
925             icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);
926 
927 
928         // round is live
929         } else {
930             // call core
931             core(_pID, _eth, _affID, _team, _eventData_);
932         }
933     }    
934     
935     /**
936      * @dev during ICO phase all eth sent in by each player.  will be added to an 
937      * "investment pool".  upon end of ICO phase, all eth will be used to buy keys.
938      * each player receives an amount based on how much they put in, and the 
939      * the average price attained.
940      */
941     function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F4Ddatasets.EventReturns memory _eventData_)
942         private
943     {
944         // setup local rID
945         uint256 _rID = rID_;
946         
947         // if they bought at least 1 whole key (at time of purchase)
948         if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
949         {
950             // set new leaders
951             if (round_[_rID].plyr != _pID)
952                 round_[_rID].plyr = _pID;  
953             if (round_[_rID].team != _team)
954                 round_[_rID].team = _team;
955             
956             // set the new leader bool to true
957             _eventData_.compressedData = _eventData_.compressedData + 100;
958         }
959         
960         // add eth to our players & rounds ICO phase investment. this will be used 
961         // to determine total keys and each players share 
962         plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
963         round_[_rID].ico = _eth.add(round_[_rID].ico);
964         
965         // add eth in to team eth tracker
966         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
967         
968         // send eth share to com, p3d, affiliate, and FoMo4D long
969         _eventData_ = distributeExternal(_eth, _eventData_);
970 
971         // calculate gen share 
972         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
973         
974         uint256 _aff = _eth / 10;
975         if (_affID != _pID && plyr_[_affID].name != '') {
976             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
977             emit F4Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
978         } else {
979             _gen = _gen.add(_aff);
980         }
981 
982         // add gen share to rounds ICO phase gen tracker (will be distributed 
983         // when round starts)
984         round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);
985         
986         uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100))).sub(_gen);
987         
988         // add eth to pot
989         round_[_rID].pot = _pot.add(round_[_rID].pot);
990         
991         // set up event data
992         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
993         _eventData_.potAmount = _pot;
994         
995         // fire event
996         endTx(_rID, _pID, _team, _eth, 0, _eventData_);
997     }
998     
999     /**
1000      * @dev this is the core logic for any buy/reload that happens while a round 
1001      * is live.
1002      */
1003     function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F4Ddatasets.EventReturns memory _eventData_)
1004         private
1005     {
1006         // setup local rID
1007         uint256 _rID = rID_;
1008         
1009         // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
1010         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1011             roundClaimICOKeys(_rID);
1012         
1013         // if player is new to round and is owed keys from ICO phase 
1014         if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
1015         {
1016             // assign player their keys from ICO phase
1017             plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
1018             // zero out ICO phase investment
1019             plyrRnds_[_pID][_rID].ico = 0;
1020         }
1021             
1022         // mint the new keys
1023         uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1024         
1025         // if they bought at least 1 whole key
1026         if (_keys >= 1000000000000000000)
1027         {
1028             updateTimer(_keys, _rID);
1029 
1030             // set new leaders
1031             if (round_[_rID].plyr != _pID)
1032                 round_[_rID].plyr = _pID;  
1033             if (round_[_rID].team != _team)
1034                 round_[_rID].team = _team; 
1035             
1036             // set the new leader bool to true
1037             _eventData_.compressedData = _eventData_.compressedData + 100;
1038         }
1039         
1040         
1041         // update player 
1042         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1043         
1044         // update round
1045         round_[_rID].keys = _keys.add(round_[_rID].keys);
1046         round_[_rID].eth = _eth.add(round_[_rID].eth);
1047         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1048 
1049         // distribute eth
1050         _eventData_ = distributeExternal(_eth, _eventData_);
1051         _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
1052         
1053         // call end tx function to fire end tx event.
1054         endTx(_rID, _pID, _team, _eth, _keys, _eventData_);
1055     }
1056     
1057     /**
1058      * @dev calculates unmasked earnings (just calculates, does not update mask)
1059      * @return earnings in wei format
1060      */
1061     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1062         private
1063         view
1064         returns(uint256)
1065     {
1066         // if player does not have unclaimed keys bought in ICO phase
1067         // return their earnings based on keys held only.
1068         if (plyrRnds_[_pID][_rIDlast].ico == 0)
1069             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1070         else
1071             if (now > round_[_rIDlast].strt + rndGap_ && round_[_rIDlast].eth == 0)
1072                 return(  (((((round_[_rIDlast].icoGen).mul(1000000000000000000)) / (round_[_rIDlast].ico).keys()).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1073             else
1074                 return(  (((round_[_rIDlast].mask).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1075         // otherwise return earnings based on keys owed from ICO phase
1076         // (this would be a scenario where they only buy during ICO phase, and never 
1077         // buy/reload during round)
1078     }
1079     
1080     /**
1081      * @dev average ico phase key price is total eth put in, during ICO phase, 
1082      * divided by the number of keys that were bought with that eth.
1083      * -functionhash- 0xdcb6af48
1084      * @return average key price 
1085      */
1086     function calcAverageICOPhaseKeyPrice(uint256 _rID)
1087         public 
1088         view 
1089         returns(uint256)
1090     {
1091         return(  (round_[_rID].ico).mul(1000000000000000000) / (round_[_rID].ico).keys()  );
1092     }
1093     
1094     /**
1095      * @dev at end of ICO phase, each player is entitled to X keys based on final 
1096      * average ICO phase key price, and the amount of eth they put in during ICO.
1097      * if a player participates in the round post ICO, these will be "claimed" and 
1098      * added to their rounds total keys.  if not, this will be used to calculate 
1099      * their gen earnings throughout round and on round end.
1100      * -functionhash- 0x75661f4c
1101      * @return players keys bought during ICO phase 
1102      */
1103     function calcPlayerICOPhaseKeys(uint256 _pID, uint256 _rID)
1104         public 
1105         view
1106         returns(uint256)
1107     {
1108         if (round_[_rID].icoAvg != 0 || round_[_rID].ico == 0 )
1109             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / round_[_rID].icoAvg  );
1110         else
1111             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / calcAverageICOPhaseKeyPrice(_rID)  );
1112     }
1113     
1114     /** 
1115      * @dev returns the amount of keys you would get given an amount of eth. 
1116      * - during live round.  this is accurate. (well... unless someone buys before 
1117      * you do and ups the price!  you better HURRY!)
1118      * - during ICO phase.  this is the max you would get based on current eth 
1119      * invested during ICO phase.  if others invest after you, you will receive
1120      * less.  (so distract them with meme vids till ICO is over)
1121      * -functionhash- 0xce89c80c
1122      * @param _rID round ID you want price for
1123      * @param _eth amount of eth sent in 
1124      * @return keys received 
1125      */
1126     function calcKeysReceived(uint256 _rID, uint256 _eth)
1127         public
1128         view
1129         returns(uint256)
1130     {
1131         // grab time
1132         uint256 _now = now;
1133         
1134         // is ICO phase over??  & theres eth in the round?
1135         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1136             return ( (round_[_rID].eth).keysRec(_eth) );
1137         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1138             return ( (round_[_rID].ico).keysRec(_eth) );
1139         else // rounds over.  need keys for new round
1140             return ( (_eth).keys() );
1141     }
1142     
1143     /** 
1144      * @dev returns current eth price for X keys.  
1145      * - during live round.  this is accurate. (well... unless someone buys before 
1146      * you do and ups the price!  you better HURRY!)
1147      * - during ICO phase.  this is the max you would get based on current eth 
1148      * invested during ICO phase.  if others invest after you, you will receive
1149      * less.  (so distract them with meme vids till ICO is over)
1150      * -functionhash- 0xcf808000
1151      * @param _keys number of keys desired (in 18 decimal format)
1152      * @return amount of eth needed to send
1153      */
1154     function iWantXKeys(uint256 _keys)
1155         public
1156         view
1157         returns(uint256)
1158     {
1159         // setup local rID
1160         uint256 _rID = rID_;
1161         
1162         // grab time
1163         uint256 _now = now;
1164         
1165         // is ICO phase over??  & theres eth in the round?
1166         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1167             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1168         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1169             return ( (((round_[_rID].ico).keys()).add(_keys)).ethRec(_keys) );
1170         else // rounds over.  need price for new round
1171             return ( (_keys).eth() );
1172     }
1173     
1174     /**
1175 	 * @dev receives name/player info from names contract 
1176      */
1177     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1178         external
1179     {
1180         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1181         if (pIDxAddr_[_addr] != _pID)
1182             pIDxAddr_[_addr] = _pID;
1183         if (pIDxName_[_name] != _pID)
1184             pIDxName_[_name] = _pID;
1185         if (plyr_[_pID].addr != _addr)
1186             plyr_[_pID].addr = _addr;
1187         if (plyr_[_pID].name != _name)
1188             plyr_[_pID].name = _name;
1189         if (plyr_[_pID].laff != _laff)
1190             plyr_[_pID].laff = _laff;
1191         if (plyrNames_[_pID][_name] == false)
1192             plyrNames_[_pID][_name] = true;
1193     }
1194 
1195     /**
1196      * @dev receives entire player name list 
1197      */
1198     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1199         external
1200     {
1201         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1202         if(plyrNames_[_pID][_name] == false)
1203             plyrNames_[_pID][_name] = true;
1204     }  
1205         
1206     /**
1207      * @dev gets existing or registers new pID.  use this when a player may be new
1208      * @return pID 
1209      */
1210     function determinePID(F4Ddatasets.EventReturns memory _eventData_)
1211         private
1212         returns (F4Ddatasets.EventReturns)
1213     {
1214         uint256 _pID = pIDxAddr_[msg.sender];
1215         // if player is new to this version of FoMo4D
1216         if (_pID == 0)
1217         {
1218             // grab their player ID, name and last aff ID, from player names contract 
1219             _pID = PlayerBook.getPlayerID(msg.sender);
1220             bytes32 _name = PlayerBook.getPlayerName(_pID);
1221             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1222             
1223             // set up player account 
1224             pIDxAddr_[msg.sender] = _pID;
1225             plyr_[_pID].addr = msg.sender;
1226             
1227             if (_name != "")
1228             {
1229                 pIDxName_[_name] = _pID;
1230                 plyr_[_pID].name = _name;
1231                 plyrNames_[_pID][_name] = true;
1232             }
1233             
1234             if (_laff != 0 && _laff != _pID)
1235                 plyr_[_pID].laff = _laff;
1236             
1237             // set the new player bool to true
1238             _eventData_.compressedData = _eventData_.compressedData + 1;
1239         } 
1240         return (_eventData_);
1241     }
1242     
1243     /**
1244      * @dev checks to make sure user picked a valid team.  if not sets team 
1245      * to default (sneks)
1246      */
1247     function verifyTeam(uint256 _team)
1248         private
1249         pure
1250         returns (uint256)
1251     {
1252         if (_team < 0 || _team > 3)
1253             return(2);
1254         else
1255             return(_team);
1256     }
1257     
1258     /**
1259      * @dev decides if round end needs to be run & new round started.  and if 
1260      * player unmasked earnings from previously played rounds need to be moved.
1261      */
1262     function manageRoundAndPlayer(uint256 _pID, F4Ddatasets.EventReturns memory _eventData_)
1263         private
1264         returns (F4Ddatasets.EventReturns)
1265     {
1266         // setup local rID
1267         uint256 _rID = rID_;
1268         
1269         // grab time
1270         uint256 _now = now;
1271         
1272         // check to see if round has ended.  we use > instead of >= so that LAST
1273         // second snipe tx can extend the round.
1274         if (_now > round_[_rID].end)
1275         {
1276             // check to see if round end has been run yet.  (distributes pot)
1277             if (round_[_rID].ended == false)
1278             {
1279                 _eventData_ = endRound(_eventData_);
1280                 round_[_rID].ended = true;
1281             }
1282             
1283             // start next round in ICO phase
1284             rID_++;
1285             _rID++;
1286             round_[_rID].strt = _now;
1287             round_[_rID].end = _now.add(rndInit_).add(rndGap_);
1288         }
1289         
1290         // is player new to round?
1291         if (plyr_[_pID].lrnd != _rID)
1292         {
1293             // if player has played a previous round, move their unmasked earnings
1294             // from that round to gen vault.
1295             if (plyr_[_pID].lrnd != 0)
1296                 updateGenVault(_pID, plyr_[_pID].lrnd);
1297             
1298             // update player's last round played
1299             plyr_[_pID].lrnd = _rID;
1300             
1301             // set the joined round bool to true
1302             _eventData_.compressedData = _eventData_.compressedData + 10;
1303         }
1304         
1305         return(_eventData_);
1306     }
1307     
1308     /**
1309      * @dev ends the round. manages paying out winner/splitting up pot
1310      */
1311     function endRound(F4Ddatasets.EventReturns memory _eventData_)
1312         private
1313         returns (F4Ddatasets.EventReturns)
1314     {
1315         // setup local rID
1316         uint256 _rID = rID_;
1317         
1318         // check to round ended with ONLY ico phase transactions
1319         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1320             roundClaimICOKeys(_rID);
1321         
1322         // grab our winning player and team id's
1323         uint256 _winPID = round_[_rID].plyr;
1324         uint256 _winTID = round_[_rID].team;
1325         
1326         // grab our pot amount
1327         uint256 _pot = round_[_rID].pot;
1328         
1329         // calculate our winner share, community rewards, gen share, 
1330         // p3d share, and amount reserved for next pot 
1331         uint256 _win = (_pot.mul(48)) / 100;
1332         uint256 _own = (_pot.mul(14) / 100);
1333         owner_.transfer(_own);
1334         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1335         uint256 _res = (((_pot.sub(_win)).sub(_own)).sub(_gen));
1336         
1337         // calculate ppt for round mask
1338         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1339         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1340         if (_dust > 0)
1341         {
1342             _gen = _gen.sub(_dust);
1343             _res = _res.add(_dust);
1344         }
1345         
1346         // pay our winner
1347         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1348 
1349             
1350         // distribute gen portion to key holders
1351         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1352                     
1353         // fill next round pot with its share
1354         round_[_rID + 1].pot += _res;
1355         
1356         // prepare event data
1357         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1358         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1359         _eventData_.winnerAddr = plyr_[_winPID].addr;
1360         _eventData_.winnerName = plyr_[_winPID].name;
1361         _eventData_.amountWon = _win;
1362         _eventData_.genAmount = _gen;
1363         _eventData_.newPot = _res;
1364         
1365         return(_eventData_);
1366     }
1367     
1368     /**
1369      * @dev takes keys bought during ICO phase, and adds them to round.  pays 
1370      * out gen rewards that accumulated during ICO phase 
1371      */
1372     function roundClaimICOKeys(uint256 _rID)
1373         private
1374     {
1375         // update round eth to account for ICO phase eth investment 
1376         round_[_rID].eth = round_[_rID].ico;
1377                 
1378         // add keys to round that were bought during ICO phase
1379         round_[_rID].keys = (round_[_rID].ico).keys();
1380         
1381         // store average ICO key price 
1382         round_[_rID].icoAvg = calcAverageICOPhaseKeyPrice(_rID);
1383                 
1384         // set round mask from ICO phase
1385         uint256 _ppt = ((round_[_rID].icoGen).mul(1000000000000000000)) / (round_[_rID].keys);
1386         uint256 _dust = (round_[_rID].icoGen).sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000));
1387         if (_dust > 0)
1388             round_[_rID].pot = (_dust).add(round_[_rID].pot);   // <<< your adding to pot and havent updated event data
1389                 
1390         // distribute gen portion to key holders
1391         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1392     }
1393     
1394     /**
1395      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1396      */
1397     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1398         private 
1399     {
1400         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1401         if (_earnings > 0)
1402         {
1403             // put in gen vault
1404             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1405             // zero out their earnings by updating mask
1406             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1407         }
1408     }
1409     
1410     /**
1411      * @dev updates round timer based on number of whole keys bought.
1412      */
1413     function updateTimer(uint256 _keys, uint256 _rID)
1414         private
1415     {
1416         // calculate time based on number of keys bought
1417         uint256 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1418         
1419         // grab time
1420         uint256 _now = now;
1421         
1422         // compare to max and set new end time
1423         if (_newTime < (rndMax_).add(_now))
1424             round_[_rID].end = _newTime;
1425         else
1426             round_[_rID].end = rndMax_.add(_now);
1427     }
1428 
1429     /**
1430      * @dev distributes eth based on fees to com, aff, and p3d
1431      */
1432     function distributeExternal(uint256 _eth, F4Ddatasets.EventReturns memory _eventData_)
1433         private
1434         returns(F4Ddatasets.EventReturns)
1435     {
1436         // pay 14% out to owner rewards
1437         uint256 _own = _eth.mul(14) / 100;
1438         owner_.transfer(_own);
1439         
1440         return(_eventData_);
1441     }
1442     
1443     function potSwap()
1444         external
1445         payable
1446     {
1447         // setup local rID
1448         uint256 _rID = rID_ + 1;
1449         
1450         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1451         emit F4Devents.onPotSwapDeposit(_rID, msg.value);
1452     }
1453     
1454     /**
1455      * @dev distributes eth based on fees to gen and pot
1456      */
1457     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, F4Ddatasets.EventReturns memory _eventData_)
1458         private
1459         returns(F4Ddatasets.EventReturns)
1460     {
1461         // calculate gen share
1462         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1463         
1464         // distribute share to affiliate 10%
1465         uint256 _aff = _eth / 10;
1466                 
1467         // decide what to do with affiliate share of fees
1468         // affiliate must not be self, and must have a name registered
1469         if (_affID != _pID && plyr_[_affID].name != '') {
1470             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1471             emit F4Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1472         } else {
1473             _gen = _gen.add(_aff);
1474         }
1475         
1476         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share))
1477         _eth = _eth.sub(((_eth.mul(14)) / 100));
1478         
1479         // calculate pot 
1480         uint256 _pot = _eth.sub(_gen);
1481         
1482         // distribute gen share (thats what updateMasks() does) and adjust
1483         // balances for dust.
1484         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1485         if (_dust > 0)
1486             _gen = _gen.sub(_dust);
1487         
1488         // add eth to pot
1489         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1490         
1491         // set up event data
1492         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1493         _eventData_.potAmount = _pot;
1494         
1495         return(_eventData_);
1496     }
1497 
1498     /**
1499      * @dev updates masks for round and player when keys are bought
1500      * @return dust left over 
1501      */
1502     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1503         private
1504         returns(uint256)
1505     {
1506         /* MASKING NOTES
1507             earnings masks are a tricky thing for people to wrap their minds around.
1508             the basic thing to understand here.  is were going to have a global
1509             tracker based on profit per share for each round, that increases in
1510             relevant proportion to the increase in share supply.
1511             
1512             the player will have an additional mask that basically says "based
1513             on the rounds mask, my shares, and how much i've already withdrawn,
1514             how much is still owed to me?"
1515         */
1516         
1517         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1518         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1519         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1520             
1521         // calculate player earning from their own buy (only based on the keys
1522         // they just bought).  & update player earnings mask
1523         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1524         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1525         
1526         // calculate & return dust
1527         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1528     }
1529     
1530     /**
1531      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1532      * @return earnings in wei format
1533      */
1534     function withdrawEarnings(uint256 _pID)
1535         private
1536         returns(uint256)
1537     {
1538         // update gen vault
1539         updateGenVault(_pID, plyr_[_pID].lrnd);
1540         
1541         // from vaults 
1542         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1543         if (_earnings > 0)
1544         {
1545             plyr_[_pID].win = 0;
1546             plyr_[_pID].gen = 0;
1547             plyr_[_pID].aff = 0;
1548         }
1549 
1550         return(_earnings);
1551     }
1552     
1553     /**
1554      * @dev prepares compression data and fires event for buy or reload tx's
1555      */
1556     function endTx(uint256 _rID, uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F4Ddatasets.EventReturns memory _eventData_)
1557         private
1558     {
1559         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1560         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (_rID * 10000000000000000000000000000000000000000000000000000);
1561         
1562         emit F4Devents.onEndTx
1563         (
1564             _eventData_.compressedData,
1565             _eventData_.compressedIDs,
1566             plyr_[_pID].name,
1567             msg.sender,
1568             _eth,
1569             _keys,
1570             _eventData_.winnerAddr,
1571             _eventData_.winnerName,
1572             _eventData_.amountWon,
1573             _eventData_.newPot,
1574             _eventData_.P3DAmount,
1575             _eventData_.genAmount,
1576             _eventData_.potAmount
1577         );
1578     }
1579     
1580     /** upon contract deploy, it will be deactivated.  this is a one time
1581      * use function that will activate the contract.  we do this so devs 
1582      * have time to set things up on the web end                            **/
1583     bool public activated_ = false;
1584     function activate()
1585         public
1586     {
1587         // only team just can activate 
1588         require(
1589             msg.sender == owner_,
1590             "only team just can activate"
1591         );
1592 
1593         // can only be ran once
1594         require(activated_ == false, "FoMo4D already activated");
1595         
1596         // activate the contract 
1597         activated_ = true;
1598         
1599         // lets start first round in ICO phase
1600 		rID_ = 1;
1601         round_[1].strt = now;
1602         round_[1].end = now + rndInit_ + rndGap_;
1603     }
1604 }
1605 
1606 
1607 
1608 library F4Ddatasets {
1609     //compressedData key
1610     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1611         // 0 - new player (bool)
1612         // 1 - joined round (bool)
1613         // 2 - new  leader (bool)
1614         // 6-16 - round end time
1615         // 17 - winnerTeam
1616         // 18 - 28 timestamp 
1617         // 29 - team
1618         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1619     //compressedIDs key
1620     // [77-52][51-26][25-0]
1621         // 0-25 - pID 
1622         // 26-51 - winPID
1623         // 52-77 - rID
1624     struct EventReturns {
1625         uint256 compressedData;
1626         uint256 compressedIDs;
1627         address winnerAddr;         // winner address
1628         bytes32 winnerName;         // winner name
1629         uint256 amountWon;          // amount won
1630         uint256 newPot;             // amount in new pot
1631         uint256 P3DAmount;          // amount distributed to p3d
1632         uint256 genAmount;          // amount distributed to gen
1633         uint256 potAmount;          // amount added to pot
1634     }
1635     struct Player {
1636         address addr;   // player address
1637         bytes32 name;   // player name
1638         uint256 win;    // winnings vault
1639         uint256 gen;    // general vault
1640         uint256 aff;    // affiliate vault
1641         uint256 lrnd;   // last round played
1642         uint256 laff;   // last affiliate id used
1643     }
1644     struct PlayerRounds {
1645         uint256 eth;    // eth player has added to round (used for eth limiter)
1646         uint256 keys;   // keys
1647         uint256 mask;   // player mask 
1648         uint256 ico;    // ICO phase investment
1649     }
1650     struct Round {
1651         uint256 plyr;   // pID of player in lead
1652         uint256 team;   // tID of team in lead
1653         uint256 end;    // time ends/ended
1654         bool ended;     // has round end function been ran
1655         uint256 strt;   // time round started
1656         uint256 keys;   // keys
1657         uint256 eth;    // total eth in
1658         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1659         uint256 mask;   // global mask
1660         uint256 ico;    // total eth sent in during ICO phase
1661         uint256 icoGen; // total eth for gen during ICO phase
1662         uint256 icoAvg; // average key price for ICO phase
1663     }
1664     struct TeamFee {
1665         uint256 gen;    // % of buy in thats paid to key holders of current round
1666     }
1667     struct PotSplit {
1668         uint256 gen;    // % of pot thats paid to key holders of current round
1669     }
1670 }
1671 
1672 
1673 library F4DKeysCalcFast {
1674     using SafeMath for *;
1675     
1676     /**
1677      * @dev calculates number of keys received given X eth 
1678      * @param _curEth current amount of eth in contract 
1679      * @param _newEth eth being spent
1680      * @return amount of ticket purchased
1681      */
1682     function keysRec(uint256 _curEth, uint256 _newEth)
1683         internal
1684         pure
1685         returns (uint256)
1686     {
1687         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1688     }
1689     
1690     /**
1691      * @dev calculates amount of eth received if you sold X keys 
1692      * @param _curKeys current amount of keys that exist 
1693      * @param _sellKeys amount of keys you wish to sell
1694      * @return amount of eth received
1695      */
1696     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1697         internal
1698         pure
1699         returns (uint256)
1700     {
1701         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1702     }
1703 
1704     /**
1705      * @dev calculates how many keys would exist with given an amount of eth
1706      * @param _eth eth "in contract"
1707      * @return number of keys that would exist
1708      */
1709     function keys(uint256 _eth) 
1710         internal
1711         pure
1712         returns(uint256)
1713     {
1714         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1715     }
1716     
1717     /**
1718      * @dev calculates how much eth would be in contract given a number of keys
1719      * @param _keys number of keys "in contract" 
1720      * @return eth that would exists
1721      */
1722     function eth(uint256 _keys) 
1723         internal
1724         pure
1725         returns(uint256)  
1726     {
1727         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1728     }
1729 }
1730 
1731 interface PlayerBookInterface {
1732     function getPlayerID(address _addr) external returns (uint256);
1733     function getPlayerName(uint256 _pID) external view returns (bytes32);
1734     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1735     function getPlayerAddr(uint256 _pID) external view returns (address);
1736     function getNameFee() external view returns (uint256);
1737     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1738     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1739     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1740 }
1741 
1742 
1743 library NameFilter {
1744     
1745     /**
1746      * @dev filters name strings
1747      * -converts uppercase to lower case.  
1748      * -makes sure it does not start/end with a space
1749      * -makes sure it does not contain multiple spaces in a row
1750      * -cannot be only numbers
1751      * -cannot start with 0x 
1752      * -restricts characters to A-Z, a-z, 0-9, and space.
1753      * @return reprocessed string in bytes32 format
1754      */
1755     function nameFilter(string _input)
1756         internal
1757         pure
1758         returns(bytes32)
1759     {
1760         bytes memory _temp = bytes(_input);
1761         uint256 _length = _temp.length;
1762         
1763         //sorry limited to 32 characters
1764         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1765         // make sure it doesnt start with or end with space
1766         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1767         // make sure first two characters are not 0x
1768         if (_temp[0] == 0x30)
1769         {
1770             require(_temp[1] != 0x78, "string cannot start with 0x");
1771             require(_temp[1] != 0x58, "string cannot start with 0X");
1772         }
1773         
1774         // create a bool to track if we have a non number character
1775         bool _hasNonNumber;
1776         
1777         // convert & check
1778         for (uint256 i = 0; i < _length; i++)
1779         {
1780             // if its uppercase A-Z
1781             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1782             {
1783                 // convert to lower case a-z
1784                 _temp[i] = byte(uint(_temp[i]) + 32);
1785                 
1786                 // we have a non number
1787                 if (_hasNonNumber == false)
1788                     _hasNonNumber = true;
1789             } else {
1790                 require
1791                 (
1792                     // require character is a space
1793                     _temp[i] == 0x20 || 
1794                     // OR lowercase a-z
1795                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1796                     // or 0-9
1797                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1798                     "string contains invalid characters"
1799                 );
1800                 // make sure theres not 2x spaces in a row
1801                 if (_temp[i] == 0x20)
1802                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1803                 
1804                 // see if we have a character other than a number
1805                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1806                     _hasNonNumber = true;    
1807             }
1808         }
1809         
1810         require(_hasNonNumber == true, "string cannot be only numbers");
1811         
1812         bytes32 _ret;
1813         assembly {
1814             _ret := mload(add(_temp, 32))
1815         }
1816         return (_ret);
1817     }
1818 }
1819 
1820 /**
1821  * @title SafeMath v0.1.9
1822  * @dev Math operations with safety checks that throw on error
1823  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1824  * - added sqrt
1825  * - added sq
1826  * - added pwr 
1827  * - changed asserts to requires with error log outputs
1828  * - removed div, its useless
1829  */
1830 library SafeMath {
1831     
1832     /**
1833     * @dev Multiplies two numbers, throws on overflow.
1834     */
1835     function mul(uint256 a, uint256 b) 
1836         internal 
1837         pure 
1838         returns (uint256 c) 
1839     {
1840         if (a == 0) {
1841             return 0;
1842         }
1843         c = a * b;
1844         require(c / a == b, "SafeMath mul failed");
1845         return c;
1846     }
1847 
1848     /**
1849     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1850     */
1851     function sub(uint256 a, uint256 b)
1852         internal
1853         pure
1854         returns (uint256) 
1855     {
1856         require(b <= a, "SafeMath sub failed");
1857         return a - b;
1858     }
1859 
1860     /**
1861     * @dev Adds two numbers, throws on overflow.
1862     */
1863     function add(uint256 a, uint256 b)
1864         internal
1865         pure
1866         returns (uint256 c) 
1867     {
1868         c = a + b;
1869         require(c >= a, "SafeMath add failed");
1870         return c;
1871     }
1872     
1873     /**
1874      * @dev gives square root of given x.
1875      */
1876     function sqrt(uint256 x)
1877         internal
1878         pure
1879         returns (uint256 y) 
1880     {
1881         uint256 z = ((add(x,1)) / 2);
1882         y = x;
1883         while (z < y) 
1884         {
1885             y = z;
1886             z = ((add((x / z),z)) / 2);
1887         }
1888     }
1889     
1890     /**
1891      * @dev gives square. multiplies x by x
1892      */
1893     function sq(uint256 x)
1894         internal
1895         pure
1896         returns (uint256)
1897     {
1898         return (mul(x,x));
1899     }
1900     
1901     /**
1902      * @dev x to the power of y 
1903      */
1904     function pwr(uint256 x, uint256 y)
1905         internal 
1906         pure 
1907         returns (uint256)
1908     {
1909         if (x==0)
1910             return (0);
1911         else if (y==0)
1912             return (1);
1913         else 
1914         {
1915             uint256 z = x;
1916             for (uint256 i=1; i < y; i++)
1917                 z = mul(z,x);
1918             return (z);
1919         }
1920     }
1921 }