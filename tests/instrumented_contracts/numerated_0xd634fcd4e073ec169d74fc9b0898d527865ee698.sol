1 pragma solidity ^0.4.24;
2 /**
3  * @title -Heaven-3D v0.2.0
4  * This work is inspired by the admirable Team JUST, we aimed to perfect their work by making this platform a heaven for everyone.
5  * Specifically, we aimed to create a platform in which players can earn money from it but hard to lose their money.
6  * We believe that this could be achieved by carefully creating a set of rules that favor this result.
7  * We done this for the world, and also as an experiment for ourselves to understand the world.
8  * We are Team DREAM. 
9  */
10 
11 //==============================================================================
12 //     _    _  _ _|_ _  .
13 //    (/_\/(/_| | | _\  .
14 //==============================================================================
15 contract H3Devents {
16 	// fired whenever new decision is made
17 	event onNewDecision
18     (
19         address senderAddress,
20 		uint256 randNum,
21         bool decision
22     );
23 	
24     // fired whenever a player registers a name
25     event onNewName
26     (
27         uint256 indexed playerID,
28         address indexed playerAddress,
29         bytes32 indexed playerName,
30         bool isNewPlayer,
31         uint256 affiliateID,
32         address affiliateAddress,
33         bytes32 affiliateName,
34         uint256 amountPaid,
35         uint256 timeStamp
36     );
37     
38     // fired at end of buy or reload
39     event onEndTx
40     (
41         uint256 compressedData,     
42         uint256 compressedIDs,      
43         bytes32 playerName,
44         address playerAddress,
45         uint256 ethIn,
46         uint256 keysBought,
47         address winnerAddr,
48         bytes32 winnerName,
49         uint256 amountWon,
50         uint256 newPot,
51         uint256 P3DAmount,
52         uint256 genAmount,
53         uint256 potAmount,
54         uint256 airDropPot
55     );
56     
57 	// fired whenever theres a withdraw
58     event onWithdraw
59     (
60         uint256 indexed playerID,
61         address playerAddress,
62         bytes32 playerName,
63         uint256 ethOut,
64         uint256 timeStamp
65     );
66     
67     // fired whenever a withdraw forces end round to be ran
68     event onWithdrawAndDistribute
69     (
70         address playerAddress,
71         bytes32 playerName,
72         uint256 ethOut,
73         uint256 compressedData,
74         uint256 compressedIDs,
75         address winnerAddr,
76         bytes32 winnerName,
77         uint256 amountWon,
78         uint256 newPot,
79         uint256 P3DAmount,
80         uint256 genAmount
81     );
82 	
83 	// fired whenever a withdraw forces end round to be ran
84     event onDistribute
85     (
86         address playerAddress,
87         bytes32 playerName,
88         uint256 compressedData,
89         uint256 compressedIDs,
90         address winnerAddr,
91         bytes32 winnerName,
92         uint256 amountWon,
93         uint256 newPot,
94         uint256 P3DAmount,
95         uint256 genAmount
96     );
97     
98     // (Heaven3D long only) fired whenever a player tries a buy after round timer 
99     // hit zero, and causes end round to be ran.
100     event onBuyAndDistribute
101     (
102         address playerAddress,
103         bytes32 playerName,
104         uint256 ethIn,
105         uint256 compressedData,
106         uint256 compressedIDs,
107         address winnerAddr,
108         bytes32 winnerName,
109         uint256 amountWon,
110         uint256 newPot,
111         uint256 P3DAmount,
112         uint256 genAmount
113     );
114     
115     // (Heaven3D long only) fired whenever a player tries a reload after round timer 
116     // hit zero, and causes end round to be ran.
117     event onReLoadAndDistribute
118     (
119         address playerAddress,
120         bytes32 playerName,
121         uint256 compressedData,
122         uint256 compressedIDs,
123         address winnerAddr,
124         bytes32 winnerName,
125         uint256 amountWon,
126         uint256 newPot,
127         uint256 P3DAmount,
128         uint256 genAmount
129     );
130     
131     // fired whenever an affiliate is paid
132     event onAffiliatePayout
133     (
134         uint256 indexed affiliateID,
135         address affiliateAddress,
136         bytes32 affiliateName,
137         uint256 indexed roundID,
138         uint256 indexed buyerID,
139         uint256 amount,
140         uint256 timeStamp
141     );
142     
143     // received pot swap deposit
144     event onPotSwapDeposit
145     (
146         uint256 roundID,
147         uint256 amountAddedToPot
148     );
149 }
150 
151 //==============================================================================
152 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
153 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
154 //====================================|=========================================
155 
156 contract modularLong is H3Devents {}
157 
158 contract Heaven3D is modularLong {
159     using SafeMath for *;
160     using NameFilter for string;
161     using H3DKeysCalcLong for uint256;
162 	
163 	TeamDreamHubInterface public TeamDreamHub_;
164 	PlayerBookInterface public PlayerBook;
165 //==============================================================================
166 //     _ _  _  |`. _     _ _ |_ | _  _  .
167 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
168 //=================_|===========================================================
169     string constant public name = "Heaven3D Official";
170     string constant public symbol = "H3D";
171 	address private owner;
172 	uint256 constant private rndExtra_ = 0 hours;     // length of the very first ICO 
173     uint256 constant private rndGap_ = 0 hours;         // length of ICO phase, set to 1 year for EOS.
174     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
175     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
176 	uint256 constant private rndDeciExt_ = 360 seconds;              // round extension time decide by random decision
177     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
178 	
179 	uint256 constant private rule_limit_latestPlayersCnt = 10; 	// should smaller than latestPlayers.length
180 	uint256 constant private rule_limit_heavyPlayersCnt = 10; 	// should smaller than heavyPlayers.length
181 //==============================================================================
182 //     _| _ _|_ _    _ _ _|_    _   .
183 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
184 //=============================|================================================
185 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
186 	uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
187     uint256 public rID_;    // round id number / total rounds that have happened
188 //****************
189 // FLOW CONTROL
190 //****************	
191 	bool public noMoreNextRound_ = false; 	// if this flag enabled, in the end of the round the developers are going to update the smart contract of the game, in order to perfect players' gaming experience.
192 	uint256 public randomDecisionPhase_ = 100;
193 	bool private endRoundDecisionResult_ = false;
194 	address private address_of_last_rand_gen_source_ = address(0);
195 	mapping (uint256 => bool) pPAIDxID_;          // (pID => paid eth) returns paid eth by player id
196 //****************
197 // PLAYER DATA 
198 //****************
199     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
200     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
201     mapping (uint256 => H3Ddatasets.Player) public plyr_;   // (pID => data) player data
202     mapping (uint256 => mapping (uint256 => H3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
203     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)	
204 //****************
205 // ROUND DATA 
206 //****************
207     mapping (uint256 => H3Ddatasets.Round) public round_;   // (rID => data) round data
208     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
209 //==============================================================================
210 //     _ _  _  __|_ _    __|_ _  _  .
211 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
212 //==============================================================================
213     constructor(address _TeamDreamHubSCaddress, address _PlayerBookSCaddress)
214         public
215     {
216 		owner = msg.sender;
217 		
218 		TeamDreamHub_ = TeamDreamHubInterface(_TeamDreamHubSCaddress);
219 		PlayerBook = PlayerBookInterface(_PlayerBookSCaddress);
220 	}
221 //==============================================================================
222 //     _ _  _  _|. |`. _  _ _  .
223 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
224 //==============================================================================
225     /**
226      * @dev used to make sure no one can interact with contract until it has 
227      * been activated. 
228      */
229     modifier isActivated() {
230         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
231         _;
232     }
233     
234     /**
235      * @dev prevents contracts from interacting with Heaven3D 
236      */
237     modifier isHuman() {
238         address _addr = msg.sender;
239 		require (_addr == tx.origin);
240 		
241         uint256 _codeLength;
242         
243         assembly {_codeLength := extcodesize(_addr)}
244         require(_codeLength == 0, "sorry humans only");
245         _;
246     }
247 	
248 	modifier onlyOwner() {
249 		require (msg.sender == owner);
250 		_;
251 	}	
252 
253     /**
254      * @dev sets boundaries for incoming tx 
255      */
256     modifier isWithinLimits(uint256 _eth) {
257         require(_eth >= 1000000000, "pocket lint: not a valid currency");
258         require(_eth <= 100000000000000000000000, "no vitalik, no");
259         _;    
260     }
261     
262 //==============================================================================
263 //     _    |_ |. _   |`    _  __|_. _  _  _  .
264 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
265 //====|=========================================================================
266     /**
267      * @dev fallback function
268 	 * emergency buy uses last stored affiliate ID and team snek
269      */
270     function()
271         isActivated()
272         isHuman()
273         isWithinLimits(msg.value)
274         public
275         payable
276     {
277         // set up our tx event data and determine if player is new or not
278         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
279             
280         // fetch player id
281         uint256 _pID = pIDxAddr_[msg.sender];
282         
283         // buy core 
284         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
285     }
286     
287     /**
288      * @dev converts all incoming ethereum to keys.
289      * -functionhash- 0x8f38f309 (using ID for affiliate)
290      * -functionhash- 0x98a0871d (using address for affiliate)
291      * -functionhash- 0xa65b37a1 (using name for affiliate)
292      * @param _affCode the ID/address/name of the player who gets the affiliate fee
293      * @param _team what team is the player playing for?
294      */
295     function buyXid(uint256 _affCode, uint256 _team)
296         isActivated()
297         isHuman()
298         isWithinLimits(msg.value)
299         public
300         payable
301     {
302         // set up our tx event data and determine if player is new or not
303         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
304         
305         // fetch player id
306         uint256 _pID = pIDxAddr_[msg.sender];
307         
308         // manage affiliate residuals
309         // if no affiliate code was given or player tried to use their own, lolz
310         if (_affCode == 0 || _affCode == _pID)
311         {
312             // use last stored affiliate code 
313             _affCode = plyr_[_pID].laff;
314             
315         // if affiliate code was given & its not the same as previously stored 
316         } else if (_affCode != plyr_[_pID].laff) {
317             // update last affiliate 
318             plyr_[_pID].laff = _affCode;
319         }
320         
321         // verify a valid team was selected
322         _team = verifyTeam(_team);
323         
324         // buy core 
325         buyCore(_pID, _affCode, _team, _eventData_);
326     }
327     
328     function buyXaddr(address _affCode, uint256 _team)
329         isActivated()
330         isHuman()
331         isWithinLimits(msg.value)
332         public
333         payable
334     {
335         // set up our tx event data and determine if player is new or not
336         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
337         
338         // fetch player id
339         uint256 _pID = pIDxAddr_[msg.sender];
340         
341         // manage affiliate residuals
342         uint256 _affID;
343         // if no affiliate code was given or player tried to use their own, lolz
344         if (_affCode == address(0) || _affCode == msg.sender)
345         {
346             // use last stored affiliate code
347             _affID = plyr_[_pID].laff;
348         
349         // if affiliate code was given    
350         } else {
351             // get affiliate ID from aff Code 
352             _affID = pIDxAddr_[_affCode];
353             
354             // if affID is not the same as previously stored 
355             if (_affID != plyr_[_pID].laff)
356             {
357                 // update last affiliate
358                 plyr_[_pID].laff = _affID;
359             }
360         }
361         
362         // verify a valid team was selected
363         _team = verifyTeam(_team);
364         
365         // buy core 
366         buyCore(_pID, _affID, _team, _eventData_);
367     }
368     
369     function buyXname(bytes32 _affCode, uint256 _team)
370         isActivated()
371         isHuman()
372         isWithinLimits(msg.value)
373         public
374         payable
375     {
376         // set up our tx event data and determine if player is new or not
377         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
378         
379         // fetch player id
380         uint256 _pID = pIDxAddr_[msg.sender];
381         
382         // manage affiliate residuals
383         uint256 _affID;
384         // if no affiliate code was given or player tried to use their own, lolz
385         if (_affCode == '' || _affCode == plyr_[_pID].name)
386         {
387             // use last stored affiliate code
388             _affID = plyr_[_pID].laff;
389         
390         // if affiliate code was given
391         } else {
392             // get affiliate ID from aff Code
393             _affID = pIDxName_[_affCode];
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
406         // buy core 
407         buyCore(_pID, _affID, _team, _eventData_);
408     }
409     
410     /**
411      * @dev essentially the same as buy, but instead of you sending ether 
412      * from your wallet, it uses your unwithdrawn earnings.
413      * -functionhash- 0x349cdcac (using ID for affiliate)
414      * -functionhash- 0x82bfc739 (using address for affiliate)
415      * -functionhash- 0x079ce327 (using name for affiliate)
416      * @param _affCode the ID/address/name of the player who gets the affiliate fee
417      * @param _team what team is the player playing for?
418      * @param _eth amount of earnings to use (remainder returned to gen vault)
419      */
420     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
421         isActivated()
422         isHuman()
423         isWithinLimits(_eth)
424         public
425     {
426         // set up our tx event data
427         H3Ddatasets.EventReturns memory _eventData_;
428         
429         // fetch player ID
430         uint256 _pID = pIDxAddr_[msg.sender];
431         
432         // manage affiliate residuals
433         // if no affiliate code was given or player tried to use their own, lolz
434         if (_affCode == 0 || _affCode == _pID)
435         {
436             // use last stored affiliate code 
437             _affCode = plyr_[_pID].laff;
438             
439         // if affiliate code was given & its not the same as previously stored 
440         } else if (_affCode != plyr_[_pID].laff) {
441             // update last affiliate 
442             plyr_[_pID].laff = _affCode;
443         }
444 
445         // verify a valid team was selected
446         _team = verifyTeam(_team);
447 
448         // reload core
449         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
450     }
451     
452     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
453         isActivated()
454         isHuman()
455         isWithinLimits(_eth)
456         public
457     {
458         // set up our tx event data
459         H3Ddatasets.EventReturns memory _eventData_;
460         
461         // fetch player ID
462         uint256 _pID = pIDxAddr_[msg.sender];
463         
464         // manage affiliate residuals
465         uint256 _affID;
466         // if no affiliate code was given or player tried to use their own, lolz
467         if (_affCode == address(0) || _affCode == msg.sender)
468         {
469             // use last stored affiliate code
470             _affID = plyr_[_pID].laff;
471         
472         // if affiliate code was given    
473         } else {
474             // get affiliate ID from aff Code 
475             _affID = pIDxAddr_[_affCode];
476             
477             // if affID is not the same as previously stored 
478             if (_affID != plyr_[_pID].laff)
479             {
480                 // update last affiliate
481                 plyr_[_pID].laff = _affID;
482             }
483         }
484         
485         // verify a valid team was selected
486         _team = verifyTeam(_team);
487         
488         // reload core
489         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
490     }
491     
492     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
493         isActivated()
494         isHuman()
495         isWithinLimits(_eth)
496         public
497     {
498         // set up our tx event data
499         H3Ddatasets.EventReturns memory _eventData_;
500         
501         // fetch player ID
502         uint256 _pID = pIDxAddr_[msg.sender];
503         
504         // manage affiliate residuals
505         uint256 _affID;
506         // if no affiliate code was given or player tried to use their own, lolz
507         if (_affCode == '' || _affCode == plyr_[_pID].name)
508         {
509             // use last stored affiliate code
510             _affID = plyr_[_pID].laff;
511         
512         // if affiliate code was given
513         } else {
514             // get affiliate ID from aff Code
515             _affID = pIDxName_[_affCode];
516             
517             // if affID is not the same as previously stored
518             if (_affID != plyr_[_pID].laff)
519             {
520                 // update last affiliate
521                 plyr_[_pID].laff = _affID;
522             }
523         }
524         
525         // verify a valid team was selected
526         _team = verifyTeam(_team);
527         
528         // reload core
529         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
530     }
531 
532 	/**
533      * @dev (use it for contract switching) set the flag noMoreNextRound_
534      */
535     function noMoreNextRoundSetting(bool _noMoreNextRound)
536         isActivated()
537 		onlyOwner()
538         public
539 	{	
540 		noMoreNextRound_ = _noMoreNextRound;
541 	}		
542 	
543 	/**
544      * @dev (use it for contract switching) developers manually put last contract's pot-fund-for-next-round to the current round's pot
545      */
546     function insertToPot()
547         isActivated()
548 		onlyOwner()
549         public
550 		payable
551 	{		
552         round_[rID_].pot = round_[rID_].pot.add(msg.value);
553         emit H3Devents.onPotSwapDeposit(rID_, msg.value);
554 	}
555 			
556     /**
557      * @dev withdraws all of your earnings.
558      * -functionhash- 0x3ccfd60b
559      */
560     function withdraw()
561         isActivated()
562         isHuman()
563         public
564     {
565         // setup local rID 
566         uint256 _rID = rID_;
567         
568         // grab time
569         uint256 _now = now;
570         
571         // fetch player ID
572         uint256 _pID = pIDxAddr_[msg.sender];
573         
574         // setup temp var for player eth
575         uint256 _eth;
576         
577         // check to see if round has ended and no one has run round end yet
578         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
579         {
580             // set up our tx event data
581             H3Ddatasets.EventReturns memory _eventData_;
582             endRoundControl(_eventData_);            
583 			
584 			// get their earnings
585             _eth = withdrawEarnings(_pID);
586             
587             // gib moni
588             if (_eth > 0)
589                 plyr_[_pID].addr.transfer(_eth);    
590             
591 			if(round_[_rID].ended == true)
592 			{
593 	            // build event data
594 	            _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
595 	            _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
596             
597 	            // fire withdraw and distribute event
598 	            emit H3Devents.onWithdrawAndDistribute
599 	            (
600 	                msg.sender, 
601 	                plyr_[_pID].name, 
602 	                _eth, 
603 	                _eventData_.compressedData, 
604 	                _eventData_.compressedIDs, 
605 	                _eventData_.winnerAddr, 
606 	                _eventData_.winnerName, 
607 	                _eventData_.amountWon, 
608 	                _eventData_.newPot, 
609 	                _eventData_.P3DAmount, 
610 	                _eventData_.genAmount
611 	            );
612 			}
613 			else
614 			{
615 				// fire withdraw event
616             	emit H3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
617 			}            
618             
619         // in any other situation
620         } else {
621             // get their earnings
622             _eth = withdrawEarnings(_pID);
623             
624             // gib moni
625             if (_eth > 0)
626                 plyr_[_pID].addr.transfer(_eth);
627             
628             // fire withdraw event
629             emit H3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
630         }
631     }
632     
633     /**
634      * @dev use these to register names.  they are just wrappers that will send the
635      * registration requests to the PlayerBook contract.  So registering here is the 
636      * same as registering there.  UI will always display the last name you registered.
637      * but you will still own all previously registered names to use as affiliate 
638      * links.
639      * - must pay a registration fee.
640      * - name must be unique
641      * - names will be converted to lowercase
642      * - name cannot start or end with a space 
643      * - cannot have more than 1 space in a row
644      * - cannot be only numbers
645      * - cannot start with 0x 
646      * - name must be at least 1 char
647      * - max length of 32 characters long
648      * - allowed characters: a-z, 0-9, and space
649      * -functionhash- 0x921dec21 (using ID for affiliate)
650      * -functionhash- 0x3ddd4698 (using address for affiliate)
651      * -functionhash- 0x685ffd83 (using name for affiliate)
652      * @param _nameString players desired name
653      * @param _affCode affiliate ID, address, or name of who referred you
654      * @param _all set to true if you want this to push your info to all games 
655      * (this might cost a lot of gas)
656      */
657     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
658         isHuman()
659         public
660         payable
661     {
662         bytes32 _name = _nameString.nameFilter();
663         address _addr = msg.sender;
664         uint256 _paid = msg.value;
665         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
666         
667         uint256 _pID = pIDxAddr_[_addr];
668         
669         // fire event
670         emit H3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
671     }
672     
673     function registerNameXaddr(string _nameString, address _affCode, bool _all)
674         isHuman()
675         public
676         payable
677     {
678         bytes32 _name = _nameString.nameFilter();
679         address _addr = msg.sender;
680         uint256 _paid = msg.value;
681         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
682         
683         uint256 _pID = pIDxAddr_[_addr];
684         
685         // fire event
686         emit H3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
687     }
688     
689     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
690         isHuman()
691         public
692         payable
693     {
694         bytes32 _name = _nameString.nameFilter();
695         address _addr = msg.sender;
696         uint256 _paid = msg.value;
697         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
698         
699         uint256 _pID = pIDxAddr_[_addr];
700         
701         // fire event
702         emit H3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
703     }
704 //==============================================================================
705 //     _  _ _|__|_ _  _ _  .
706 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
707 //=====_|=======================================================================
708     /**
709      * @dev return the price buyer will pay for next 1 individual key.
710      * -functionhash- 0x018a25e8
711      * @return price for next key bought (in wei format)
712      */
713     function getBuyPrice()
714         public 
715         view 
716         returns(uint256)
717     {  
718         // setup local rID
719         uint256 _rID = rID_;
720         
721         // grab time
722         uint256 _now = now;
723         
724         // are we in a round?
725         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
726             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
727         else // rounds over.  need price for new round
728             return ( 75000000000000 ); // init
729     }
730     
731     /**
732      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
733      * provider
734      * -functionhash- 0xc7e284b8
735      * @return time left in seconds
736      */
737     function getTimeLeft()
738         public
739         view
740         returns(uint256)
741     {
742         // setup local rID
743         uint256 _rID = rID_;
744         
745         // grab time
746         uint256 _now = now;
747         
748         if (_now < round_[_rID].end)
749             if (_now > round_[_rID].strt + rndGap_)
750                 return( (round_[_rID].end).sub(_now) );
751             else
752                 return( (round_[_rID].strt + rndGap_).sub(_now) );
753         else
754             return(0);
755     }
756     
757     /**
758      * @dev returns player earnings per vaults 
759      * -functionhash- 0x63066434
760      * @return winnings vault
761      * @return general vault
762      * @return affiliate vault
763      */
764     function getPlayerVaults(uint256 _pID)
765         public
766         view
767         returns(uint256 ,uint256, uint256)
768     {
769         // setup local rID
770         uint256 _rID = rID_;
771         
772 		uint256 limitedDividends = (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd));
773 		if(limitedDividends > plyrRnds_[_pID][_rID].eth.mul(3))
774 			limitedDividends = plyrRnds_[_pID][_rID].eth.mul(3);
775 		
776 		return
777 		(
778 			plyr_[_pID].win,
779 			limitedDividends,
780 			plyr_[_pID].aff
781 		);        
782     }
783         
784     /**
785      * @dev returns all current round info needed for front end
786      * -functionhash- 0x747dff42
787      * @return eth invested during ICO phase
788      * @return round id 
789      * @return total keys for round 
790      * @return time round ends
791      * @return time round started
792      * @return current pot 
793      * @return current team ID & player ID in lead 
794      * @return current player in leads address 
795      * @return current player in leads name
796      * @return whales eth in for round
797      * @return bears eth in for round
798      * @return sneks eth in for round
799      * @return bulls eth in for round
800      * @return airdrop tracker # & airdrop pot
801      */
802     function getCurrentRoundInfo()
803         public
804         view
805         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
806     {
807         // setup local rID
808         uint256 _rID = rID_;
809         
810         return
811         (
812             round_[_rID].ico,               //0
813             _rID,                           //1
814             round_[_rID].keys,              //2
815             round_[_rID].end,               //3
816             round_[_rID].strt,              //4
817             round_[_rID].pot,               //5
818             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
819             plyr_[round_[_rID].plyr].addr,  //7
820             plyr_[round_[_rID].plyr].name,  //8
821             rndTmEth_[_rID][0],             //9
822             rndTmEth_[_rID][1],             //10
823             rndTmEth_[_rID][2],             //11
824             rndTmEth_[_rID][3],             //12
825             randomDecisionPhase_            //13
826         );
827     }
828 
829     /**
830      * @dev returns player info based on address.  if no address is given, it will 
831      * use msg.sender 
832      * -functionhash- 0xee0b5d8b
833      * @param _addr address of the player you want to lookup 
834      * @return player ID 
835      * @return player name
836      * @return keys owned (current round)
837      * @return winnings vault
838      * @return general vault 
839      * @return affiliate vault 
840 	 * @return player round eth
841      */
842     function getPlayerInfoByAddress(address _addr)
843         public 
844         view 
845         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
846     {
847         // setup local rID
848         uint256 _rID = rID_;
849         
850         if (_addr == address(0))
851         {
852             _addr == msg.sender;
853         }
854         uint256 _pID = pIDxAddr_[_addr];
855 		
856 		uint256 limitedDividends = (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd));
857 		if(limitedDividends > plyrRnds_[_pID][_rID].eth.mul(3))
858 			limitedDividends = plyrRnds_[_pID][_rID].eth.mul(3);
859         
860         return
861         (
862             _pID,                               //0
863             plyr_[_pID].name,                   //1
864             plyrRnds_[_pID][_rID].keys,         //2
865             plyr_[_pID].win,                    //3
866             limitedDividends,       //4
867             plyr_[_pID].aff,                    //5
868             plyrRnds_[_pID][_rID].eth           //6
869         );
870     }
871 
872 //==============================================================================
873 //     _ _  _ _   | _  _ . _  .
874 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
875 //=====================_|=======================================================
876 
877     function endRoundControl(H3Ddatasets.EventReturns memory _eventData_)
878         private
879 	{
880 	    // setup local rID 
881         uint256 _rID = rID_;
882 		// set true for randomDecisionPhase_ we're in!
883 		randomDecisionPhase_ = 101;        
884         // setup local _address_gen_src 
885         address _address_gen_src = address_of_last_rand_gen_source_;
886         
887 		bool goMakeDecision = true;
888         // case1: 1st time to make decision OR sender is also the validator
889         if((_address_gen_src == address(0)) || (_address_gen_src == msg.sender)) {
890             goMakeDecision = true;
891         }
892 		else {
893 			// case2: last sender is human
894 			if(checkNotSmartContract(_address_gen_src)) {                			
895                 // case2a: prior check PASS: returned by endRoundDecision()
896                 if(endRoundDecisionResult_ == true) {		
897 					// end the round (distributes pot) & start new round
898 					round_[_rID].ended = true;
899 					_eventData_ = endRound(_eventData_);																
900 					randomDecisionPhase_ = 100;
901 				}
902 				// case2b: prior check FAILED: returned by endRoundDecision()
903                 else {
904 					// grab time
905 					uint256 _now = now;					
906 					// set new end time by adding rndDeciExt_ to NOW; normally add 6 minutes
907 					round_[_rID].end = rndDeciExt_.add(_now);
908 				}
909 				
910                 // reset all flags
911                 // because we're leaving endGamePrcoess and not going to come back within a period of time
912 				endRoundDecisionResult_ = false;
913 				address_of_last_rand_gen_source_ = address(0);
914 				goMakeDecision = false;
915 			}
916 			// case3: last player is not human, so let the current player throw the dice again.
917 			else {
918 				goMakeDecision = true; 
919 			}
920 		}
921 
922         if(goMakeDecision == true) {
923 			//throw the dice and wait for next player to validate the result.
924 			address_of_last_rand_gen_source_ = msg.sender;
925 			endRoundDecisionResult_ = endRoundDecision();	
926 		}				
927 	}
928 
929     /**
930      * @dev logic runs whenever a buy order is executed.  determines how to handle 
931      * incoming eth depending on if we are in an active round or not
932      */
933     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, H3Ddatasets.EventReturns memory _eventData_)
934         private
935     {
936         // setup local rID
937         uint256 _rID = rID_;
938         
939         // grab time
940         uint256 _now = now;
941         
942         // if round is active
943         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
944         {
945             // call core 
946             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
947         
948         // if round is not active     
949         } else {
950             // check to see if end round needs to be ran
951             if (_now > round_[_rID].end && round_[_rID].ended == false) 
952             {
953                 endRoundControl(_eventData_); 
954 				
955 				if(round_[_rID].ended == true)
956 				{
957 	                // build event data
958 	                _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
959 	                _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
960                 
961 	                // fire buy and distribute event 
962 	                emit H3Devents.onBuyAndDistribute
963 	                (
964 	                    msg.sender, 
965 	                    plyr_[_pID].name, 
966 	                    msg.value, 
967 	                    _eventData_.compressedData, 
968 	                    _eventData_.compressedIDs, 
969 	                    _eventData_.winnerAddr, 
970 	                    _eventData_.winnerName, 
971 	                    _eventData_.amountWon, 
972 	                    _eventData_.newPot, 
973 	                    _eventData_.P3DAmount, 
974 	                    _eventData_.genAmount
975 	                );
976 				}
977             }
978             
979             // put eth in players vault 
980             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
981         }
982     }
983     
984     /**
985      * @dev logic runs whenever a reload order is executed.  determines how to handle 
986      * incoming eth depending on if we are in an active round or not 
987      */
988     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, H3Ddatasets.EventReturns memory _eventData_)
989         private
990     {
991         // setup local rID
992         uint256 _rID = rID_;
993         
994         // grab time
995         uint256 _now = now;
996         
997         // if round is active
998         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
999         {
1000             // get earnings from all vaults and return unused to gen vault
1001             // because we use a custom safemath library.  this will throw if player 
1002             // tried to spend more eth than they have.
1003             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1004             
1005             // call core 
1006             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1007         
1008         // if round is not active and end round needs to be ran   
1009         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1010 			
1011 			endRoundControl(_eventData_); 
1012 			
1013 			if(round_[_rID].ended == true)
1014 			{	            // build event data
1015 	            _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1016 	            _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1017                 
1018 	            // fire buy and distribute event 
1019 	            emit H3Devents.onReLoadAndDistribute
1020 	            (
1021 	                msg.sender, 
1022 	                plyr_[_pID].name, 
1023 	                _eventData_.compressedData, 
1024 	                _eventData_.compressedIDs, 
1025 	                _eventData_.winnerAddr, 
1026 	                _eventData_.winnerName, 
1027 	                _eventData_.amountWon, 
1028 	                _eventData_.newPot, 
1029 	                _eventData_.P3DAmount, 
1030 	                _eventData_.genAmount
1031 	            );
1032 			}
1033         }
1034     }
1035     
1036     /**
1037      * @dev this is the core logic for any buy/reload that happens while a round 
1038      * is live.
1039      */
1040     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, H3Ddatasets.EventReturns memory _eventData_)
1041         private
1042     {
1043         // if player is new to round
1044         if (plyrRnds_[_pID][_rID].keys == 0)
1045             _eventData_ = managePlayer(_pID, _eventData_); // don't have to do updateGenVault again because we have it in managePlayer()
1046 		else // if not, can use _rID directly, but we decided to still go with plyr_[_pID].lrnd
1047 			updateGenVault(_pID, plyr_[_pID].lrnd);	
1048         
1049         // early round eth limiter 
1050         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1051         {
1052             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1053             uint256 _refund = _eth.sub(_availableLimit);
1054             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1055             _eth = _availableLimit;
1056         }
1057         
1058         // if eth left is greater than min eth allowed (sorry no pocket lint)
1059         if (_eth > 1000000000) 
1060         {            
1061             // mint the new keys
1062             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1063             
1064             // if they bought at least 1 whole key
1065             if (_keys >= 1000000000000000000)
1066             {
1067 				updateTimer(_keys, _rID);
1068 
1069 				// set new leaders
1070 				if (round_[_rID].plyr != _pID)
1071 					round_[_rID].plyr = _pID;  
1072 				if (round_[_rID].team != _team)
1073 					round_[_rID].team = _team; 
1074 				
1075 				// set the new leader bool to true
1076 				_eventData_.compressedData = _eventData_.compressedData + 100;
1077 			}            
1078     
1079             // store the air drop tracker number (number of buys since last airdrop)
1080             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1081             
1082             // update player 
1083             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1084             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1085             
1086             // update round
1087             round_[_rID].keys = _keys.add(round_[_rID].keys);
1088             round_[_rID].eth = _eth.add(round_[_rID].eth);
1089             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1090     
1091             // distribute eth
1092             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
1093             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
1094 			
1095 			internalNoter(_rID, _pID);
1096 			
1097             // call end tx function to fire end tx event.
1098 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1099         }
1100     }
1101 //==============================================================================
1102 //     _ _ | _   | _ _|_ _  _ _  .
1103 //    (_(_||(_|_||(_| | (_)| _\  .
1104 //==============================================================================
1105     /**
1106      * @dev calculates unmasked earnings (just calculates, does not update mask)
1107      * @return earnings in wei format
1108      */
1109     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1110         private
1111         view
1112         returns(uint256)
1113     {
1114         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1115     }
1116     
1117     /** 
1118      * @dev returns the amount of keys you would get given an amount of eth. 
1119      * -functionhash- 0xce89c80c
1120      * @param _rID round ID you want price for
1121      * @param _eth amount of eth sent in 
1122      * @return keys received 
1123      */
1124     function calcKeysReceived(uint256 _rID, uint256 _eth)
1125         public
1126         view
1127         returns(uint256)
1128     {
1129         // grab time
1130         uint256 _now = now;
1131         
1132         // are we in a round?
1133         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1134             return ( (round_[_rID].eth).keysRec(_eth) );
1135         else // rounds over.  need keys for new round
1136             return ( (_eth).keys() );
1137     }
1138     
1139     /** 
1140      * @dev returns current eth price for X keys.  
1141      * -functionhash- 0xcf808000
1142      * @param _keys number of keys desired (in 18 decimal format)
1143      * @return amount of eth needed to send
1144      */
1145     function iWantXKeys(uint256 _keys)
1146         public
1147         view
1148         returns(uint256)
1149     {
1150         // setup local rID
1151         uint256 _rID = rID_;
1152         
1153         // grab time
1154         uint256 _now = now;
1155         
1156         // are we in a round?
1157         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1158             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1159         else // rounds over.  need price for new round
1160             return ( (_keys).eth() );
1161     }
1162 //==============================================================================
1163 //    _|_ _  _ | _  .
1164 //     | (_)(_)|_\  .
1165 //==============================================================================
1166     /**
1167 	 * @dev receives name/player info from names contract 
1168      */
1169     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1170         external
1171     {
1172         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1173         if (pIDxAddr_[_addr] != _pID)
1174             pIDxAddr_[_addr] = _pID;
1175         if (pIDxName_[_name] != _pID)
1176             pIDxName_[_name] = _pID;
1177         if (plyr_[_pID].addr != _addr)
1178             plyr_[_pID].addr = _addr;
1179         if (plyr_[_pID].name != _name)
1180             plyr_[_pID].name = _name;
1181         if (plyr_[_pID].laff != _laff)
1182             plyr_[_pID].laff = _laff;
1183         if (plyrNames_[_pID][_name] == false)
1184             plyrNames_[_pID][_name] = true;
1185     }
1186     
1187     /**
1188      * @dev receives entire player name list 
1189      */
1190     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1191         external
1192     {
1193         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1194         if(plyrNames_[_pID][_name] == false)
1195             plyrNames_[_pID][_name] = true;
1196     }   
1197         
1198     /**
1199      * @dev gets existing or registers new pID.  use this when a player may be new
1200      * @return pID 
1201      */
1202     function determinePID(H3Ddatasets.EventReturns memory _eventData_)
1203         private
1204         returns (H3Ddatasets.EventReturns)
1205     {
1206         uint256 _pID = pIDxAddr_[msg.sender];
1207         // if player is new to this version of Heaven3D
1208         if (_pID == 0)
1209         {
1210             // grab their player ID, name and last aff ID, from player names contract 
1211             _pID = PlayerBook.getPlayerID(msg.sender);
1212             bytes32 _name = PlayerBook.getPlayerName(_pID);
1213             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1214             
1215             // set up player account 
1216             pIDxAddr_[msg.sender] = _pID;
1217             plyr_[_pID].addr = msg.sender;
1218             
1219             if (_name != "")
1220             {
1221                 pIDxName_[_name] = _pID;
1222                 plyr_[_pID].name = _name;
1223                 plyrNames_[_pID][_name] = true;
1224             }
1225             
1226             if (_laff != 0 && _laff != _pID)
1227                 plyr_[_pID].laff = _laff;
1228             
1229             // set the new player bool to true
1230             _eventData_.compressedData = _eventData_.compressedData + 1;
1231         } 
1232         return (_eventData_);
1233     }
1234     
1235     /**
1236      * @dev checks to make sure user picked a valid team.  if not sets team 
1237      * to default (sneks)
1238      */
1239     function verifyTeam(uint256 _team)
1240         private
1241         pure
1242         returns (uint256)
1243     {
1244         if (_team < 0 || _team > 3)
1245             return(2);
1246         else
1247             return(_team);
1248     }
1249     
1250     /**
1251      * @dev decides if round end needs to be run & new round started.  and if 
1252      * player unmasked earnings from previously played rounds need to be moved.
1253      */
1254     function managePlayer(uint256 _pID, H3Ddatasets.EventReturns memory _eventData_)
1255         private
1256         returns (H3Ddatasets.EventReturns)
1257     {
1258         // if player has played a previous round, move their unmasked earnings
1259         // from that round to gen vault.
1260         if (plyr_[_pID].lrnd != 0)
1261             updateGenVault(_pID, plyr_[_pID].lrnd);
1262             
1263         // update player's last round played
1264         plyr_[_pID].lrnd = rID_;
1265             
1266         // set the joined round bool to true
1267         _eventData_.compressedData = _eventData_.compressedData + 10;
1268         
1269         return(_eventData_);
1270     }
1271     
1272     /**
1273      * @dev ends the round. manages paying out winner/splitting up pot
1274      */
1275     function endRound(H3Ddatasets.EventReturns memory _eventData_)
1276         private
1277         returns (H3Ddatasets.EventReturns)
1278     {
1279         // setup local rID
1280         uint256 _rID = rID_;
1281         
1282         // grab our winning player and team id's
1283         uint256 _winPID = round_[_rID].plyr;
1284         uint256 _winTID = round_[_rID].team;
1285         
1286         // grab our pot amount
1287         uint256 _pot = round_[_rID].pot;
1288         
1289         // calculate our winner share, community rewards, gen share, 
1290         // p3d share, and amount reserved for next pot 
1291         uint256 _win = (_pot.mul(68)) / 100; // for all winners
1292         uint256 _com = (_pot.mul(10)) / 100; // for community 
1293         uint256 _gen = 0; 
1294         uint256 _p3d = 0;
1295 		
1296 		// community rewards
1297 		TeamDreamHub_.deposit.value(_com)();
1298 		
1299 		uint256 _res = ((_pot.sub(_com)).sub(_gen)).sub(_p3d); // _win should be handled later.        
1300 		(_res,_eventData_) = winnersProfitDistributor(_rID, _win, _res, _eventData_); // distribute to all winners
1301 		
1302 		// if update in smart contract is neccessary, the developers will trigger this mechanism.
1303 		// in this condition we're going into maintenance mode in order to update the smart contract on the blockchain
1304 		// we developers will put _res into the next pot manually when H3D is going online again.
1305 		// the down time is expected to be short.
1306 		if(noMoreNextRound_ == true)
1307 		{
1308 			owner.transfer(_res);
1309 			_res = 0;
1310 		}
1311             
1312         // prepare event data
1313         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1314         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1315         _eventData_.winnerAddr = plyr_[_winPID].addr;
1316         _eventData_.winnerName = plyr_[_winPID].name;
1317         _eventData_.amountWon = _win;
1318         _eventData_.genAmount = _gen;
1319         _eventData_.P3DAmount = _p3d;
1320         _eventData_.newPot = _res;
1321         
1322         // start next round
1323         rID_++;
1324         _rID++;
1325         round_[_rID].strt = now;
1326         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1327         round_[_rID].pot = _res; // the rest goes to next pot
1328         
1329         return(_eventData_);
1330     }
1331     
1332     /**
1333      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1334      */
1335     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1336         private 
1337     {
1338         uint256 dividend_yet_distribute = calcUnMaskedEarnings(_pID, _rIDlast);
1339         if (dividend_yet_distribute > 0)
1340         {			
1341 			uint256 _earnings;
1342 			uint256 all_dividend_earned = dividend_yet_distribute.add(plyrRnds_[_pID][_rIDlast].eth_went_to_gen);
1343 			//check 3x limit
1344 			if (all_dividend_earned > (plyrRnds_[_pID][_rIDlast].eth).mul(3))
1345 			{	
1346 				//===adjustment done accordingly===
1347 				
1348 				//seperate exceeds_part from dividend_yet_distribute
1349 				uint256 remain_quota = (plyrRnds_[_pID][_rIDlast].eth).mul(3).sub(plyrRnds_[_pID][_rIDlast].eth_went_to_gen); // can only provide the dividend withing 3x of inputed eth.
1350 				uint256 exceeds_part = dividend_yet_distribute.sub(remain_quota);
1351 
1352 				_earnings = remain_quota;
1353 				
1354 		        // add exceeds_part as new profit to the current round and adjust round.mask accordingly				
1355 				uint256 _dust = updateMasks(rID_, _pID, exceeds_part, 0); // keys = 0 because didn't add new key.
1356 				if (_dust > 0) // add dust to pot
1357 					round_[rID_].pot = round_[rID_].pot.add(_dust);	
1358 			}
1359 			else
1360 			{
1361 				_earnings = dividend_yet_distribute;
1362 			}
1363 			
1364 			// put in gen vault
1365 			plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1366 			
1367 			//note to eth_went_to_gen, in order to estimate all eth passed to geb vault in the current round.
1368 			plyrRnds_[_pID][_rIDlast].eth_went_to_gen = _earnings.add(plyrRnds_[_pID][_rIDlast].eth_went_to_gen);			
1369 			
1370 			// zero out their earnings by updating mask
1371 			plyrRnds_[_pID][_rIDlast].mask = dividend_yet_distribute.add(plyrRnds_[_pID][_rIDlast].mask);
1372         }
1373     }
1374     
1375     /**
1376      * @dev updates round timer based on number of whole keys bought.
1377      */
1378     function updateTimer(uint256 _keys, uint256 _rID)
1379         private
1380     {
1381         // grab time
1382         uint256 _now = now;
1383         
1384         // calculate time based on number of keys bought
1385         uint256 _newTime;
1386         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1387             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1388         else
1389             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1390         
1391         // compare to max and set new end time
1392         if (_newTime < (rndMax_).add(_now))
1393             round_[_rID].end = _newTime;
1394         else
1395             round_[_rID].end = rndMax_.add(_now);
1396     }
1397 	
1398 	/**
1399      * @dev generates a random number in order to make a decision
1400      * @return PASS or REJECT?
1401      */
1402     function endRoundDecision()
1403         private 
1404         returns(bool)
1405     {
1406 		bool decision = false;
1407         uint256 seed = uint256(keccak256(abi.encodePacked(
1408             
1409             (block.timestamp).add
1410             (block.difficulty).add
1411             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1412             (block.gaslimit).add
1413             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1414             (block.number)
1415             
1416         )));
1417         
1418 		uint256 randNum = (seed - ((seed / 1000) * 1000));
1419 		if(randNum < 50) // 5% probability
1420             decision = true;
1421 		
1422 		// fire event
1423 		emit H3Devents.onNewDecision(msg.sender,randNum,decision);
1424 		
1425 		return decision;
1426     }	
1427 	
1428 	/**
1429      * @dev check if an address is smart contract
1430      * @return true (Not smart contract) or false
1431      */
1432     function checkNotSmartContract(address targetAddr)
1433         private 
1434         returns(bool)
1435     {
1436 		uint256 _codeLength;        
1437 		assembly {
1438 			_codeLength := extcodesize(targetAddr)
1439 		}
1440 		
1441 		if(_codeLength == 0) // last sender is human
1442 			return true;
1443 		else
1444 			return false;
1445     }	
1446     
1447 
1448     /**
1449      * @dev distributes eth based on fees to com, aff, and p3d
1450      */
1451     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, H3Ddatasets.EventReturns memory _eventData_)
1452         private
1453         returns(H3Ddatasets.EventReturns)
1454     {
1455         // pay 10% out to community fund
1456         uint256 _com = (_eth.mul(10)) / 100;
1457         uint256 _p3d = 0;
1458                 
1459         // distribute share to affiliate
1460         uint256 _aff = _eth / 10;
1461         
1462         // decide what to do with affiliate share of fees
1463         // affiliate must not be self, and must have a name registered
1464         if (_affID != _pID && plyr_[_affID].name != '') {
1465             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1466             emit H3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1467         } else {
1468 			_com = _com.add(_aff);
1469         }
1470 		
1471 		// payout community rewards
1472 		TeamDreamHub_.deposit.value(_com)();
1473         
1474         return(_eventData_);
1475     }
1476     
1477     function potSwap()
1478         external
1479         payable
1480     {
1481         // setup local rID
1482         uint256 _rID = rID_ + 1;
1483         
1484         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1485         emit H3Devents.onPotSwapDeposit(_rID, msg.value);
1486     }
1487     
1488     /**
1489      * @dev distributes eth based on fees to gen and pot
1490      */
1491     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, H3Ddatasets.EventReturns memory _eventData_)
1492         private
1493         returns(H3Ddatasets.EventReturns)
1494     {
1495         // calculate gen share
1496         uint256 _gen = (_eth.mul(60)) / 100; 
1497         
1498         // update eth balance (eth = eth - (com share + aff share + p3d share + airdrop pot share))
1499         _eth = _eth.sub((_eth.mul(20)) / 100);
1500         
1501         // calculate pot 
1502         uint256 _pot = _eth.sub(_gen);
1503         
1504         // distribute gen share (thats what updateMasks() does) and adjust
1505         // balances for dust.
1506         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1507         if (_dust > 0)
1508             _gen = _gen.sub(_dust);
1509         
1510         // add eth to pot
1511         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1512         
1513         // set up event data
1514         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1515         _eventData_.potAmount = _pot;
1516         
1517         return(_eventData_);
1518     }
1519 	
1520 	/**
1521      * @dev distribute profits (_win) to the pot winners)
1522      */
1523     function winnersProfitDistributor(uint256 _rID, uint256 _win, uint256 _res, H3Ddatasets.EventReturns memory _eventData_)
1524         private
1525 		returns (uint256, H3Ddatasets.EventReturns)
1526     {		
1527 		uint256 _pIDtmp; 
1528 		uint256 _paidPlayerCount; // note how many players have been paid already.
1529 		uint256 _bonus_portion; // compute portions
1530 
1531         _eventData_ = determinePID(_eventData_);
1532 
1533         // pay the rand number generator caller (rate = 1%)
1534         _bonus_portion = (_win.mul(10)) / 1000;
1535         _pIDtmp = pIDxAddr_[address_of_last_rand_gen_source_];
1536 		plyr_[_pIDtmp].win = _bonus_portion.add(plyr_[_pIDtmp].win);
1537 		_res = _res.sub(_bonus_portion);
1538         
1539         // pay our latestPlayers (rate = 49% / 10 players = 4.9%)
1540         _bonus_portion = (_win.mul(49)) / 1000;
1541 		_paidPlayerCount = 0;
1542 
1543 		// pay the latest 10 players
1544         for (uint i = 0; i < round_[_rID].latestPlayers.length; i++) {			
1545 			if(round_[_rID].latestPlayers[i] == 0) break; // early-stop						
1546 			if(_paidPlayerCount == rule_limit_latestPlayersCnt) break; // already paid enough players			
1547 										
1548 			_pIDtmp = round_[_rID].latestPlayers[i];
1549 			// only pay out for human players
1550 			if(checkNotSmartContract(plyr_[_pIDtmp].addr)) {
1551 				plyr_[_pIDtmp].win = _bonus_portion.add(plyr_[_pIDtmp].win);
1552 				_res = _res.sub(_bonus_portion);
1553 				_paidPlayerCount++;
1554 				// record the latestPlayers for later use
1555 				pPAIDxID_[round_[_rID].latestPlayers[i]] = true;				
1556 			}			
1557 		}
1558 		
1559         // pay our heavyPlayers (rate = 50% / 10 players = 5%)
1560         _bonus_portion = (_win.mul(50)) / 1000;
1561 		_paidPlayerCount = 0;
1562 		for (i = 0; i < round_[_rID].heavyPlayers.length; i++) {			
1563 			if(round_[_rID].heavyPlayers[i] == 0) break; // early-stop
1564 			if(_paidPlayerCount == rule_limit_heavyPlayersCnt) break; // already paid enough players
1565 						
1566 			_pIDtmp = round_[_rID].heavyPlayers[i];
1567 			// only pay out for human players
1568 			if(checkNotSmartContract(plyr_[_pIDtmp].addr)) {				
1569                 // don't pay if _pIDtmp is one of the latestPlayers
1570                 if(pPAIDxID_[_pIDtmp] == true) continue;
1571 				plyr_[_pIDtmp].win = _bonus_portion.add(plyr_[_pIDtmp].win);
1572 				_res = _res.sub(_bonus_portion);
1573 				_paidPlayerCount++;
1574 			}
1575 		}		
1576 		// clear pPAIDxID_ for the use in next round's endround process.
1577 		for (i = 0; i < round_[_rID].latestPlayers.length; i++)
1578 			pPAIDxID_[round_[_rID].latestPlayers[i]] = false;		
1579 		
1580 		return (_res,_eventData_);
1581 	}
1582 	
1583     /**
1584      * @dev note neccessary info.
1585      */
1586     function internalNoter(uint256 _rID, uint256 _pID)
1587         private
1588     {
1589 		bool hasFoundIdx = false;
1590 		
1591         // [update latestPlayers list]
1592 		// round_[_rID].latestPlayers is a FIFO in which idx = 0 is the head and idx = length - 1 is the tail
1593 		// the latest player will be the closest player (i.e., on the list) to the tail.		
1594         // initially idx_insert is mapping to the last slot
1595         // if idx_insert is not changed with the conditions below
1596         // idx_insert is located in the last slot
1597         uint idx_insert = round_[_rID].latestPlayers.length - 1;
1598 		uint i;
1599 		uint j;
1600 		
1601 		// shift the FIFO to find a slot to insert the current player		
1602 		// case1: when the list is not full
1603 		for (i=0; i<round_[_rID].latestPlayers.length-1; i++) {
1604             // case1a: if _pID exists in the ith slot
1605             if(round_[_rID].latestPlayers[i] == _pID) {
1606                 // shift earlier players to fill the ith slot
1607                 for (j=i; j<round_[_rID].latestPlayers.length-1; j++) {
1608                     round_[_rID].latestPlayers[j] = round_[_rID].latestPlayers[j+1];
1609                     if(round_[_rID].latestPlayers[j] == 0) {
1610                         idx_insert = j;  // new index = j
1611 						hasFoundIdx = true;
1612 						break; // early stop when there's no more non-empty cell left to check on.
1613 					}
1614                 }
1615             }
1616 			// case1b: if _pID doesn't exist in the ith slot, and it's an empty slot
1617             else {
1618                 // if not repeated, check whether the slot is empty (0)
1619                 if(round_[_rID].latestPlayers[i] == 0) {
1620                     idx_insert = i;  // new index = i
1621 					hasFoundIdx = true;
1622 					break; // early stop when find an empty cell already.
1623 				}				
1624 			}				
1625 		}					
1626 
1627 		// case2: when the list is full
1628 		// only do it when former loop hasn't found an idx to insert
1629         if (hasFoundIdx == false) {
1630 			for (i=0; i<round_[_rID].latestPlayers.length-1; i++) {
1631 				// replace the 1st one and leave the last slot empty.			
1632 				round_[_rID].latestPlayers[i] = round_[_rID].latestPlayers[i+1]; 
1633 			}			
1634         }
1635         
1636         // assign the _pID to the corresponding idx_insert for the latestPlayers list
1637         round_[_rID].latestPlayers[idx_insert] = _pID;
1638         
1639         // ----------------------------------------------------
1640 
1641         // [update heavyPlayers list]
1642 		// round_[_rID].heavyPlayers is a list in which idx = 0 is the head and idx = length - 1 is the tail
1643 		// the player who spent largest amount of ether will be the closest player (i.e., on the list) to the head.		
1644         // initially set idx_insert is mapping to the last slot
1645         // if idx_insert is not changed with the conditions below
1646         // idx_insert is located in the last slot
1647 		hasFoundIdx = false;
1648         idx_insert = round_[_rID].heavyPlayers.length - 1;
1649 
1650         // check whether the _pID repeated in the heavyPlayers list
1651 		// case: checking whether the current player is already on the list.
1652         for(i=0; i<round_[_rID].heavyPlayers.length; i++) {
1653             if(round_[_rID].heavyPlayers[i] == 0) break; // early-stop when no more non-empty cells to read.
1654             // if _pID exists in the ith slot
1655             if(round_[_rID].heavyPlayers[i] == _pID) {
1656                 // shift the other players to fill the ith slot
1657                 for(j=i; j<round_[_rID].heavyPlayers.length-1; j++) {
1658                     round_[_rID].heavyPlayers[j] = round_[_rID].heavyPlayers[j+1];
1659                     if(round_[_rID].heavyPlayers[j] == 0) break; 
1660                 }
1661             }
1662         }      
1663 
1664         // after eliminating the repeated _pID, order the players by spent ethers
1665         for(i=0; i<round_[_rID].heavyPlayers.length; i++) {
1666 			// case1: use this in the round beginning
1667 			// case2: spent eth smaller than the others on the list
1668             if(round_[_rID].heavyPlayers[i] == 0) {
1669                 idx_insert = i;  // new index = i
1670 				hasFoundIdx = true;
1671 				break; // early-stop when find a idx_insert to insert
1672 			}			
1673             else {
1674                 // case3: if spent eth larger than someone, insert the current player into the slot
1675                 if(plyrRnds_[_pID][_rID].eth > plyrRnds_[round_[_rID].heavyPlayers[i]][_rID].eth) {
1676                     idx_insert = i;  // new index = i
1677 					hasFoundIdx = true;
1678                     // shift players to vacate the ith slot
1679                     for (j=i; j<round_[_rID].heavyPlayers.length-1; j++) {
1680                         round_[_rID].heavyPlayers[j+1] = round_[_rID].heavyPlayers[j];
1681                         if(round_[_rID].heavyPlayers[j] == 0) break; // early-stop when find an empty cell
1682                     }
1683 					break; // early-stop when already find an idx_insert to insert
1684                 }            
1685             }                
1686         }
1687 
1688 		// assign the _pID to the corresponding idx_insert for the heavyPlayers list, only when really find an appropriate position on the list that is for the player.
1689 		if(hasFoundIdx == true)        
1690 			round_[_rID].heavyPlayers[idx_insert] = _pID;
1691 	}			
1692 
1693     /**
1694      * @dev updates masks for round and player when keys are bought
1695      * @return dust left over 
1696      */
1697     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1698         private
1699         returns(uint256)
1700     {
1701         /* MASKING NOTES
1702             earnings masks are a tricky thing for people to wrap their minds around.
1703             the basic thing to understand here.  is were going to have a global
1704             tracker based on profit per share for each round, that increases in
1705             relevant proportion to the increase in share supply.
1706             
1707             the player will have an additional mask that basically says "based
1708             on the rounds mask, my shares, and how much i've already withdrawn,
1709             how much is still owed to me?"
1710         */
1711         
1712 		uint256 _ppt;
1713 		if(round_[_rID].keys.sub(_keys) == 0) // only 1st key buyer can earn dividend based on the keys just purchased
1714 		{
1715 			// calc profit per key & round mask based on this buy:  (dust goes to pot)
1716 			_ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1717 			round_[_rID].mask = _ppt.add(round_[_rID].mask);
1718 				
1719 			// calculate player earning from their own buy (only based on the keys
1720 			// they just bought).  & update player earnings mask
1721 			uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1722 			plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask); // sub(_pearn) because want to deliver it to the player.
1723 			return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000))); // calculate & return dust
1724 		}
1725 		else
1726 		{
1727 			// calc profit per key & round mask based on this buy:  (dust goes to pot)
1728 			_ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys.sub(_keys)); // sub. _keys because only distribute the profit to former keys.
1729 			round_[_rID].mask = _ppt.add(round_[_rID].mask);
1730 				
1731 			// update player earnings mask so they cannot obtain profit generated based on their own input
1732 			plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000))).add(plyrRnds_[_pID][_rID].mask); 
1733 			return(_gen.sub((_ppt.mul(round_[_rID].keys.sub(_keys))) / (1000000000000000000))); // calculate & return dust; sub. _keys because only distribute the profit to former keys. 
1734 		}		
1735         
1736     }
1737     
1738     /**
1739      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1740      * @return earnings in wei format
1741      */
1742     function withdrawEarnings(uint256 _pID)
1743         private
1744         returns(uint256)
1745     {
1746         // update gen vault
1747         updateGenVault(_pID, plyr_[_pID].lrnd);
1748         
1749         // from vaults 
1750         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1751         if (_earnings > 0)
1752         {
1753             plyr_[_pID].win = 0;
1754             plyr_[_pID].gen = 0;
1755             plyr_[_pID].aff = 0;
1756         }
1757 
1758         return(_earnings);
1759     }
1760     
1761     /**
1762      * @dev prepares compression data and fires event for buy or reload tx's
1763      */
1764     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, H3Ddatasets.EventReturns memory _eventData_)
1765         private
1766     {
1767         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1768         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1769         
1770         emit H3Devents.onEndTx
1771         (
1772             _eventData_.compressedData,
1773             _eventData_.compressedIDs,
1774             plyr_[_pID].name,
1775             msg.sender,
1776             _eth,
1777             _keys,
1778             _eventData_.winnerAddr,
1779             _eventData_.winnerName,
1780             _eventData_.amountWon,
1781             _eventData_.newPot,
1782             _eventData_.P3DAmount,
1783             _eventData_.genAmount,
1784             _eventData_.potAmount,
1785             airDropPot_
1786         );
1787     }
1788 //==============================================================================
1789 //    (~ _  _    _._|_    .
1790 //    _)(/_(_|_|| | | \/  .
1791 //====================/=========================================================
1792     /** upon contract deploy, it will be deactivated.  this is a one time
1793      * use function that will activate the contract.  we do this so devs 
1794      * have time to set things up on the web end                            **/
1795     bool public activated_ = false;
1796     function activate()
1797         public
1798     {
1799         // only Team Dream can activate 
1800         require(
1801             msg.sender == owner,
1802             "only Team Dream can activate"
1803         );
1804         
1805         // can only be ran once
1806         require(activated_ == false, "Heaven3D already activated");
1807         
1808         // activate the contract 
1809         activated_ = true;
1810         
1811         // lets start first round
1812 		rID_ = 1;
1813         round_[1].strt = now + rndExtra_ - rndGap_;
1814         round_[1].end = now + rndInit_ + rndExtra_;
1815     }
1816 	
1817 }
1818 
1819 //==============================================================================
1820 //   __|_ _    __|_ _  .
1821 //  _\ | | |_|(_ | _\  .
1822 //==============================================================================
1823 library H3Ddatasets {
1824     //compressedData key
1825     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1826         // 0 - new player (bool)
1827         // 1 - joined round (bool)
1828         // 2 - new  leader (bool)
1829         // 3-5 - air drop tracker (uint 0-999)
1830         // 6-16 - round end time
1831         // 17 - winnerTeam
1832         // 18 - 28 timestamp 
1833         // 29 - team
1834         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1835         // 31 - airdrop happened bool
1836         // 32 - airdrop tier 
1837         // 33 - airdrop amount won
1838     //compressedIDs key
1839     // [77-52][51-26][25-0]
1840         // 0-25 - pID 
1841         // 26-51 - winPID
1842         // 52-77 - rID
1843     struct EventReturns {
1844         uint256 compressedData;
1845         uint256 compressedIDs;
1846         address winnerAddr;         // winner address
1847         bytes32 winnerName;         // winner name
1848         uint256 amountWon;          // amount won
1849         uint256 newPot;             // amount in new pot
1850         uint256 P3DAmount;          // amount distributed to p3d
1851         uint256 genAmount;          // amount distributed to gen
1852         uint256 potAmount;          // amount added to pot
1853     }
1854     struct Player {
1855         address addr;   // player address
1856         bytes32 name;   // player name
1857         uint256 win;    // winnings vault
1858         uint256 gen;    // general vault
1859         uint256 aff;    // affiliate vault
1860         uint256 lrnd;   // last round played
1861         uint256 laff;   // last affiliate id used
1862     }
1863     struct PlayerRounds {
1864         uint256 eth;    // eth player has added to round (used for eth limiter and also for dividend upper bound limiter)
1865         uint256 keys;   // keys
1866         uint256 mask;   // player mask 
1867 		uint256 eth_went_to_gen;    // dividend earned and moved to gen bal. 
1868         uint256 ico;    // ICO phase investment
1869     }
1870     struct Round {
1871 		uint256[20] latestPlayers; 	// latest players
1872 		uint256[20] heavyPlayers; 	// players with top eth invested 
1873 	
1874         uint256 plyr;   // pID of player in lead
1875         uint256 team;   // tID of team in lead
1876         uint256 end;    // time ends/ended
1877         bool ended;     // has round end function been ran
1878         uint256 strt;   // time round started
1879         uint256 keys;   // keys
1880         uint256 eth;    // total eth in
1881         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1882         uint256 mask;   // global mask
1883         uint256 ico;    // total eth sent in during ICO phase
1884         uint256 icoGen; // total eth for gen during ICO phase
1885         uint256 icoAvg; // average key price for ICO phase
1886     }
1887 }
1888 
1889 //==============================================================================
1890 //  |  _      _ _ | _  .
1891 //  |<(/_\/  (_(_||(_  .
1892 //=======/======================================================================
1893 library H3DKeysCalcLong {
1894     using SafeMath for *;
1895     /**
1896      * @dev calculates number of keys received given X eth 
1897      * @param _curEth current amount of eth in contract 
1898      * @param _newEth eth being spent
1899      * @return amount of ticket purchased
1900      */
1901     function keysRec(uint256 _curEth, uint256 _newEth)
1902         internal
1903         pure
1904         returns (uint256)
1905     {
1906         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1907     }
1908     
1909     /**
1910      * @dev calculates amount of eth received if you sold X keys 
1911      * @param _curKeys current amount of keys that exist 
1912      * @param _sellKeys amount of keys you wish to sell
1913      * @return amount of eth received
1914      */
1915     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1916         internal
1917         pure
1918         returns (uint256)
1919     {
1920         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1921     }
1922 
1923     /**
1924      * @dev calculates how many keys would exist with given an amount of eth
1925      * @param _eth eth "in contract"
1926      * @return number of keys that would exist
1927      */
1928     function keys(uint256 _eth) 
1929         internal
1930         pure
1931         returns(uint256)
1932     {
1933         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1934     }
1935     
1936     /**
1937      * @dev calculates how much eth would be in contract given a number of keys
1938      * @param _keys number of keys "in contract" 
1939      * @return eth that would exists
1940      */
1941     function eth(uint256 _keys) 
1942         internal
1943         pure
1944         returns(uint256)  
1945     {
1946         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1947     }
1948 }
1949 
1950 //==============================================================================
1951 //  . _ _|_ _  _ |` _  _ _  _  .
1952 //  || | | (/_| ~|~(_|(_(/__\  .
1953 //==============================================================================
1954 interface PlayerBookInterface {
1955     function getPlayerID(address _addr) external returns (uint256);
1956     function getPlayerName(uint256 _pID) external view returns (bytes32);
1957     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1958     function getPlayerAddr(uint256 _pID) external view returns (address);
1959     function getNameFee() external view returns (uint256);
1960     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1961     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1962     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1963 }
1964 
1965 interface TeamDreamHubInterface {
1966     function deposit() external payable;
1967 }
1968 
1969 /**
1970 * @title -Name Filter- v0.1.9
1971 */
1972 library NameFilter {
1973     /**
1974      * @dev filters name strings
1975      * -converts uppercase to lower case.  
1976      * -makes sure it does not start/end with a space
1977      * -makes sure it does not contain multiple spaces in a row
1978      * -cannot be only numbers
1979      * -cannot start with 0x 
1980      * -restricts characters to A-Z, a-z, 0-9, and space.
1981      * @return reprocessed string in bytes32 format
1982      */
1983     function nameFilter(string _input)
1984         internal
1985         pure
1986         returns(bytes32)
1987     {
1988         bytes memory _temp = bytes(_input);
1989         uint256 _length = _temp.length;
1990         
1991         //sorry limited to 32 characters
1992         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1993         // make sure it doesnt start with or end with space
1994         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1995         // make sure first two characters are not 0x
1996         if (_temp[0] == 0x30)
1997         {
1998             require(_temp[1] != 0x78, "string cannot start with 0x");
1999             require(_temp[1] != 0x58, "string cannot start with 0X");
2000         }
2001         
2002         // create a bool to track if we have a non number character
2003         bool _hasNonNumber;
2004         
2005         // convert & check
2006         for (uint256 i = 0; i < _length; i++)
2007         {
2008             // if its uppercase A-Z
2009             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2010             {
2011                 // convert to lower case a-z
2012                 _temp[i] = byte(uint(_temp[i]) + 32);
2013                 
2014                 // we have a non number
2015                 if (_hasNonNumber == false)
2016                     _hasNonNumber = true;
2017             } else {
2018                 require
2019                 (
2020                     // require character is a space
2021                     _temp[i] == 0x20 || 
2022                     // OR lowercase a-z
2023                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2024                     // or 0-9
2025                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2026                     "string contains invalid characters"
2027                 );
2028                 // make sure theres not 2x spaces in a row
2029                 if (_temp[i] == 0x20)
2030                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2031                 
2032                 // see if we have a character other than a number
2033                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2034                     _hasNonNumber = true;    
2035             }
2036         }
2037         
2038         require(_hasNonNumber == true, "string cannot be only numbers");
2039         
2040         bytes32 _ret;
2041         assembly {
2042             _ret := mload(add(_temp, 32))
2043         }
2044         return (_ret);
2045     }
2046 }
2047 
2048 /**
2049  * @title SafeMath v0.1.9
2050  * @dev Math operations with safety checks that throw on error
2051  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2052  * - added sqrt
2053  * - added sq
2054  * - added pwr 
2055  * - changed asserts to requires with error log outputs
2056  * - removed div, its useless
2057  */
2058 library SafeMath {
2059     
2060     /**
2061     * @dev Multiplies two numbers, throws on overflow.
2062     */
2063     function mul(uint256 a, uint256 b) 
2064         internal 
2065         pure 
2066         returns (uint256 c) 
2067     {
2068         if (a == 0) {
2069             return 0;
2070         }
2071         c = a * b;
2072         require(c / a == b, "SafeMath mul failed");
2073         return c;
2074     }
2075 
2076     /**
2077     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2078     */
2079     function sub(uint256 a, uint256 b)
2080         internal
2081         pure
2082         returns (uint256) 
2083     {
2084         require(b <= a, "SafeMath sub failed");
2085         return a - b;
2086     }
2087 
2088     /**
2089     * @dev Adds two numbers, throws on overflow.
2090     */
2091     function add(uint256 a, uint256 b)
2092         internal
2093         pure
2094         returns (uint256 c) 
2095     {
2096         c = a + b;
2097         require(c >= a, "SafeMath add failed");
2098         return c;
2099     }
2100     
2101     /**
2102      * @dev gives square root of given x.
2103      */
2104     function sqrt(uint256 x)
2105         internal
2106         pure
2107         returns (uint256 y) 
2108     {
2109         uint256 z = ((add(x,1)) / 2);
2110         y = x;
2111         while (z < y) 
2112         {
2113             y = z;
2114             z = ((add((x / z),z)) / 2);
2115         }
2116     }
2117     
2118     /**
2119      * @dev gives square. multiplies x by x
2120      */
2121     function sq(uint256 x)
2122         internal
2123         pure
2124         returns (uint256)
2125     {
2126         return (mul(x,x));
2127     }
2128     
2129     /**
2130      * @dev x to the power of y 
2131      */
2132     function pwr(uint256 x, uint256 y)
2133         internal 
2134         pure 
2135         returns (uint256)
2136     {
2137         if (x==0)
2138             return (0);
2139         else if (y==0)
2140             return (1);
2141         else 
2142         {
2143             uint256 z = x;
2144             for (uint256 i=1; i < y; i++)
2145                 z = mul(z,x);
2146             return (z);
2147         }
2148     }
2149 }