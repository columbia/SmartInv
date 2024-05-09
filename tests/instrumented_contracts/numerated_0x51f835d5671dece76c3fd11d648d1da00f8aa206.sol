1 pragma solidity ^0.4.24;
2 /**
3  * @title -Heaven-3D v0.1.0
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
195 	mapping (uint256 => uint256) pPAIDxID_;          // (pID => paid eth) returns paid eth by player id
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
248     /**
249      * @dev sets boundaries for incoming tx 
250      */
251     modifier isWithinLimits(uint256 _eth) {
252         require(_eth >= 1000000000, "pocket lint: not a valid currency");
253         require(_eth <= 100000000000000000000000, "no vitalik, no");
254         _;    
255     }
256     
257 //==============================================================================
258 //     _    |_ |. _   |`    _  __|_. _  _  _  .
259 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
260 //====|=========================================================================
261     /**
262      * @dev fallback function
263 	 * emergency buy uses last stored affiliate ID and team snek
264      */
265     function()
266         isActivated()
267         isHuman()
268         isWithinLimits(msg.value)
269         public
270         payable
271     {
272         // set up our tx event data and determine if player is new or not
273         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
274             
275         // fetch player id
276         uint256 _pID = pIDxAddr_[msg.sender];
277         
278         // buy core 
279         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
280     }
281     
282     /**
283      * @dev converts all incoming ethereum to keys.
284      * -functionhash- 0x8f38f309 (using ID for affiliate)
285      * -functionhash- 0x98a0871d (using address for affiliate)
286      * -functionhash- 0xa65b37a1 (using name for affiliate)
287      * @param _affCode the ID/address/name of the player who gets the affiliate fee
288      * @param _team what team is the player playing for?
289      */
290     function buyXid(uint256 _affCode, uint256 _team)
291         isActivated()
292         isHuman()
293         isWithinLimits(msg.value)
294         public
295         payable
296     {
297         // set up our tx event data and determine if player is new or not
298         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
299         
300         // fetch player id
301         uint256 _pID = pIDxAddr_[msg.sender];
302         
303         // manage affiliate residuals
304         // if no affiliate code was given or player tried to use their own, lolz
305         if (_affCode == 0 || _affCode == _pID)
306         {
307             // use last stored affiliate code 
308             _affCode = plyr_[_pID].laff;
309             
310         // if affiliate code was given & its not the same as previously stored 
311         } else if (_affCode != plyr_[_pID].laff) {
312             // update last affiliate 
313             plyr_[_pID].laff = _affCode;
314         }
315         
316         // verify a valid team was selected
317         _team = verifyTeam(_team);
318         
319         // buy core 
320         buyCore(_pID, _affCode, _team, _eventData_);
321     }
322     
323     function buyXaddr(address _affCode, uint256 _team)
324         isActivated()
325         isHuman()
326         isWithinLimits(msg.value)
327         public
328         payable
329     {
330         // set up our tx event data and determine if player is new or not
331         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
332         
333         // fetch player id
334         uint256 _pID = pIDxAddr_[msg.sender];
335         
336         // manage affiliate residuals
337         uint256 _affID;
338         // if no affiliate code was given or player tried to use their own, lolz
339         if (_affCode == address(0) || _affCode == msg.sender)
340         {
341             // use last stored affiliate code
342             _affID = plyr_[_pID].laff;
343         
344         // if affiliate code was given    
345         } else {
346             // get affiliate ID from aff Code 
347             _affID = pIDxAddr_[_affCode];
348             
349             // if affID is not the same as previously stored 
350             if (_affID != plyr_[_pID].laff)
351             {
352                 // update last affiliate
353                 plyr_[_pID].laff = _affID;
354             }
355         }
356         
357         // verify a valid team was selected
358         _team = verifyTeam(_team);
359         
360         // buy core 
361         buyCore(_pID, _affID, _team, _eventData_);
362     }
363     
364     function buyXname(bytes32 _affCode, uint256 _team)
365         isActivated()
366         isHuman()
367         isWithinLimits(msg.value)
368         public
369         payable
370     {
371         // set up our tx event data and determine if player is new or not
372         H3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
373         
374         // fetch player id
375         uint256 _pID = pIDxAddr_[msg.sender];
376         
377         // manage affiliate residuals
378         uint256 _affID;
379         // if no affiliate code was given or player tried to use their own, lolz
380         if (_affCode == '' || _affCode == plyr_[_pID].name)
381         {
382             // use last stored affiliate code
383             _affID = plyr_[_pID].laff;
384         
385         // if affiliate code was given
386         } else {
387             // get affiliate ID from aff Code
388             _affID = pIDxName_[_affCode];
389             
390             // if affID is not the same as previously stored
391             if (_affID != plyr_[_pID].laff)
392             {
393                 // update last affiliate
394                 plyr_[_pID].laff = _affID;
395             }
396         }
397         
398         // verify a valid team was selected
399         _team = verifyTeam(_team);
400         
401         // buy core 
402         buyCore(_pID, _affID, _team, _eventData_);
403     }
404     
405     /**
406      * @dev essentially the same as buy, but instead of you sending ether 
407      * from your wallet, it uses your unwithdrawn earnings.
408      * -functionhash- 0x349cdcac (using ID for affiliate)
409      * -functionhash- 0x82bfc739 (using address for affiliate)
410      * -functionhash- 0x079ce327 (using name for affiliate)
411      * @param _affCode the ID/address/name of the player who gets the affiliate fee
412      * @param _team what team is the player playing for?
413      * @param _eth amount of earnings to use (remainder returned to gen vault)
414      */
415     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
416         isActivated()
417         isHuman()
418         isWithinLimits(_eth)
419         public
420     {
421         // set up our tx event data
422         H3Ddatasets.EventReturns memory _eventData_;
423         
424         // fetch player ID
425         uint256 _pID = pIDxAddr_[msg.sender];
426         
427         // manage affiliate residuals
428         // if no affiliate code was given or player tried to use their own, lolz
429         if (_affCode == 0 || _affCode == _pID)
430         {
431             // use last stored affiliate code 
432             _affCode = plyr_[_pID].laff;
433             
434         // if affiliate code was given & its not the same as previously stored 
435         } else if (_affCode != plyr_[_pID].laff) {
436             // update last affiliate 
437             plyr_[_pID].laff = _affCode;
438         }
439 
440         // verify a valid team was selected
441         _team = verifyTeam(_team);
442 
443         // reload core
444         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
445     }
446     
447     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
448         isActivated()
449         isHuman()
450         isWithinLimits(_eth)
451         public
452     {
453         // set up our tx event data
454         H3Ddatasets.EventReturns memory _eventData_;
455         
456         // fetch player ID
457         uint256 _pID = pIDxAddr_[msg.sender];
458         
459         // manage affiliate residuals
460         uint256 _affID;
461         // if no affiliate code was given or player tried to use their own, lolz
462         if (_affCode == address(0) || _affCode == msg.sender)
463         {
464             // use last stored affiliate code
465             _affID = plyr_[_pID].laff;
466         
467         // if affiliate code was given    
468         } else {
469             // get affiliate ID from aff Code 
470             _affID = pIDxAddr_[_affCode];
471             
472             // if affID is not the same as previously stored 
473             if (_affID != plyr_[_pID].laff)
474             {
475                 // update last affiliate
476                 plyr_[_pID].laff = _affID;
477             }
478         }
479         
480         // verify a valid team was selected
481         _team = verifyTeam(_team);
482         
483         // reload core
484         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
485     }
486     
487     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
488         isActivated()
489         isHuman()
490         isWithinLimits(_eth)
491         public
492     {
493         // set up our tx event data
494         H3Ddatasets.EventReturns memory _eventData_;
495         
496         // fetch player ID
497         uint256 _pID = pIDxAddr_[msg.sender];
498         
499         // manage affiliate residuals
500         uint256 _affID;
501         // if no affiliate code was given or player tried to use their own, lolz
502         if (_affCode == '' || _affCode == plyr_[_pID].name)
503         {
504             // use last stored affiliate code
505             _affID = plyr_[_pID].laff;
506         
507         // if affiliate code was given
508         } else {
509             // get affiliate ID from aff Code
510             _affID = pIDxName_[_affCode];
511             
512             // if affID is not the same as previously stored
513             if (_affID != plyr_[_pID].laff)
514             {
515                 // update last affiliate
516                 plyr_[_pID].laff = _affID;
517             }
518         }
519         
520         // verify a valid team was selected
521         _team = verifyTeam(_team);
522         
523         // reload core
524         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
525     }
526 
527 	/**
528      * @dev set the flag noMoreNextRound_
529      */
530     function noMoreNextRoundSetting(bool _noMoreNextRound)
531         isActivated()
532 		isHuman()
533         public
534 	{
535         // only Team Dream can activate 
536         require(
537             msg.sender == owner,
538             "only Team Dream can activate"
539         );
540 		
541 		noMoreNextRound_ = _noMoreNextRound;
542 	}		
543 			
544     /**
545      * @dev withdraws all of your earnings.
546      * -functionhash- 0x3ccfd60b
547      */
548     function withdraw()
549         isActivated()
550         isHuman()
551         public
552     {
553         // setup local rID 
554         uint256 _rID = rID_;
555         
556         // grab time
557         uint256 _now = now;
558         
559         // fetch player ID
560         uint256 _pID = pIDxAddr_[msg.sender];
561         
562         // setup temp var for player eth
563         uint256 _eth;
564         
565         // check to see if round has ended and no one has run round end yet
566         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
567         {
568             // set up our tx event data
569             H3Ddatasets.EventReturns memory _eventData_;
570             endRoundControl(_eventData_);            
571 			
572 			// get their earnings
573             _eth = withdrawEarnings(_pID);
574             
575             // gib moni
576             if (_eth > 0)
577                 plyr_[_pID].addr.transfer(_eth);    
578             
579 			if(round_[_rID].ended == true)
580 			{
581 	            // build event data
582 	            _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
583 	            _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
584             
585 	            // fire withdraw and distribute event
586 	            emit H3Devents.onWithdrawAndDistribute
587 	            (
588 	                msg.sender, 
589 	                plyr_[_pID].name, 
590 	                _eth, 
591 	                _eventData_.compressedData, 
592 	                _eventData_.compressedIDs, 
593 	                _eventData_.winnerAddr, 
594 	                _eventData_.winnerName, 
595 	                _eventData_.amountWon, 
596 	                _eventData_.newPot, 
597 	                _eventData_.P3DAmount, 
598 	                _eventData_.genAmount
599 	            );
600 			}
601 			else
602 			{
603 				// fire withdraw event
604             	emit H3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
605 			}            
606             
607         // in any other situation
608         } else {
609             // get their earnings
610             _eth = withdrawEarnings(_pID);
611             
612             // gib moni
613             if (_eth > 0)
614                 plyr_[_pID].addr.transfer(_eth);
615             
616             // fire withdraw event
617             emit H3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
618         }
619     }
620     
621     /**
622      * @dev use these to register names.  they are just wrappers that will send the
623      * registration requests to the PlayerBook contract.  So registering here is the 
624      * same as registering there.  UI will always display the last name you registered.
625      * but you will still own all previously registered names to use as affiliate 
626      * links.
627      * - must pay a registration fee.
628      * - name must be unique
629      * - names will be converted to lowercase
630      * - name cannot start or end with a space 
631      * - cannot have more than 1 space in a row
632      * - cannot be only numbers
633      * - cannot start with 0x 
634      * - name must be at least 1 char
635      * - max length of 32 characters long
636      * - allowed characters: a-z, 0-9, and space
637      * -functionhash- 0x921dec21 (using ID for affiliate)
638      * -functionhash- 0x3ddd4698 (using address for affiliate)
639      * -functionhash- 0x685ffd83 (using name for affiliate)
640      * @param _nameString players desired name
641      * @param _affCode affiliate ID, address, or name of who referred you
642      * @param _all set to true if you want this to push your info to all games 
643      * (this might cost a lot of gas)
644      */
645     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
646         isHuman()
647         public
648         payable
649     {
650         bytes32 _name = _nameString.nameFilter();
651         address _addr = msg.sender;
652         uint256 _paid = msg.value;
653         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
654         
655         uint256 _pID = pIDxAddr_[_addr];
656         
657         // fire event
658         emit H3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
659     }
660     
661     function registerNameXaddr(string _nameString, address _affCode, bool _all)
662         isHuman()
663         public
664         payable
665     {
666         bytes32 _name = _nameString.nameFilter();
667         address _addr = msg.sender;
668         uint256 _paid = msg.value;
669         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
670         
671         uint256 _pID = pIDxAddr_[_addr];
672         
673         // fire event
674         emit H3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
675     }
676     
677     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
678         isHuman()
679         public
680         payable
681     {
682         bytes32 _name = _nameString.nameFilter();
683         address _addr = msg.sender;
684         uint256 _paid = msg.value;
685         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
686         
687         uint256 _pID = pIDxAddr_[_addr];
688         
689         // fire event
690         emit H3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
691     }
692 //==============================================================================
693 //     _  _ _|__|_ _  _ _  .
694 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
695 //=====_|=======================================================================
696     /**
697      * @dev return the price buyer will pay for next 1 individual key.
698      * -functionhash- 0x018a25e8
699      * @return price for next key bought (in wei format)
700      */
701     function getBuyPrice()
702         public 
703         view 
704         returns(uint256)
705     {  
706         // setup local rID
707         uint256 _rID = rID_;
708         
709         // grab time
710         uint256 _now = now;
711         
712         // are we in a round?
713         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
714             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
715         else // rounds over.  need price for new round
716             return ( 75000000000000 ); // init
717     }
718     
719     /**
720      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
721      * provider
722      * -functionhash- 0xc7e284b8
723      * @return time left in seconds
724      */
725     function getTimeLeft()
726         public
727         view
728         returns(uint256)
729     {
730         // setup local rID
731         uint256 _rID = rID_;
732         
733         // grab time
734         uint256 _now = now;
735         
736         if (_now < round_[_rID].end)
737             if (_now > round_[_rID].strt + rndGap_)
738                 return( (round_[_rID].end).sub(_now) );
739             else
740                 return( (round_[_rID].strt + rndGap_).sub(_now) );
741         else
742             return(0);
743     }
744     
745     /**
746      * @dev returns player earnings per vaults 
747      * -functionhash- 0x63066434
748      * @return winnings vault
749      * @return general vault
750      * @return affiliate vault
751      */
752     function getPlayerVaults(uint256 _pID)
753         public
754         view
755         returns(uint256 ,uint256, uint256)
756     {
757         // setup local rID
758         uint256 _rID = rID_;
759         
760         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
761         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
762         {
763             // if player is winner 
764             if (round_[_rID].plyr == _pID)
765             {
766                 return
767                 (
768                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
769                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
770                     plyr_[_pID].aff
771                 );
772             // if player is not the winner
773             } else {
774                 return
775                 (
776                     plyr_[_pID].win,
777                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
778                     plyr_[_pID].aff
779                 );
780             }
781             
782         // if round is still going on, or round has ended and round end has been ran
783         } else {
784             return
785             (
786                 plyr_[_pID].win,
787                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
788                 plyr_[_pID].aff
789             );
790         }
791     }
792     
793     /**
794      * solidity hates stack limits.  this lets us avoid that hate 
795      */
796     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
797         private
798         view
799         returns(uint256)
800     {
801         return(  ((((round_[_rID].mask)).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
802     }
803     
804     /**
805      * @dev returns all current round info needed for front end
806      * -functionhash- 0x747dff42
807      * @return eth invested during ICO phase
808      * @return round id 
809      * @return total keys for round 
810      * @return time round ends
811      * @return time round started
812      * @return current pot 
813      * @return current team ID & player ID in lead 
814      * @return current player in leads address 
815      * @return current player in leads name
816      * @return whales eth in for round
817      * @return bears eth in for round
818      * @return sneks eth in for round
819      * @return bulls eth in for round
820      * @return airdrop tracker # & airdrop pot
821      */
822     function getCurrentRoundInfo()
823         public
824         view
825         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
826     {
827         // setup local rID
828         uint256 _rID = rID_;
829         
830         return
831         (
832             round_[_rID].ico,               //0
833             _rID,                           //1
834             round_[_rID].keys,              //2
835             round_[_rID].end,               //3
836             round_[_rID].strt,              //4
837             round_[_rID].pot,               //5
838             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
839             plyr_[round_[_rID].plyr].addr,  //7
840             plyr_[round_[_rID].plyr].name,  //8
841             rndTmEth_[_rID][0],             //9
842             rndTmEth_[_rID][1],             //10
843             rndTmEth_[_rID][2],             //11
844             rndTmEth_[_rID][3],             //12
845             randomDecisionPhase_            //13
846         );
847     }
848 
849     /**
850      * @dev returns player info based on address.  if no address is given, it will 
851      * use msg.sender 
852      * -functionhash- 0xee0b5d8b
853      * @param _addr address of the player you want to lookup 
854      * @return player ID 
855      * @return player name
856      * @return keys owned (current round)
857      * @return winnings vault
858      * @return general vault 
859      * @return affiliate vault 
860 	 * @return player round eth
861      */
862     function getPlayerInfoByAddress(address _addr)
863         public 
864         view 
865         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
866     {
867         // setup local rID
868         uint256 _rID = rID_;
869         
870         if (_addr == address(0))
871         {
872             _addr == msg.sender;
873         }
874         uint256 _pID = pIDxAddr_[_addr];
875 		
876 		uint256 limitedDividends = (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd));
877 		if(limitedDividends > plyrRnds_[_pID][_rID].eth.mul(3))
878 			limitedDividends = plyrRnds_[_pID][_rID].eth.mul(3);
879         
880         return
881         (
882             _pID,                               //0
883             plyr_[_pID].name,                   //1
884             plyrRnds_[_pID][_rID].keys,         //2
885             plyr_[_pID].win,                    //3
886             limitedDividends,       //4
887             plyr_[_pID].aff,                    //5
888             plyrRnds_[_pID][_rID].eth           //6
889         );
890     }
891 
892 //==============================================================================
893 //     _ _  _ _   | _  _ . _  .
894 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
895 //=====================_|=======================================================
896 
897     function endRoundControl(H3Ddatasets.EventReturns memory _eventData_)
898         private
899 	{
900 	    // setup local rID 
901         uint256 _rID = rID_;
902 		
903 		randomDecisionPhase_ = 101; // set true for randomDecisionPhase_ we're in!
904         
905         // setup local address_of_last_rand_gen_source_ 
906         address _address_of_last_rand_gen_source_ = address_of_last_rand_gen_source_;
907         
908 		bool goMakeDecision = true;
909 		
910 		if((_address_of_last_rand_gen_source_ == address(0)) || (_address_of_last_rand_gen_source_ == msg.sender)) // 1st time to make decision OR sender is also the validator
911 		{
912 			goMakeDecision = true; // prior check FAILED		
913 		}
914 		else // prior check PASS
915 		{
916 			if(checkNotSmartContract(_address_of_last_rand_gen_source_)) // last sender is human
917 			{							
918 				if(endRoundDecisionResult_ == true) // the decision generated is true
919 				{							
920 					// end the round (distributes pot) & start new round
921 					round_[_rID].ended = true;
922 					_eventData_ = endRound(_eventData_);																
923 					randomDecisionPhase_ = 100;
924 				}
925 				else
926 				{
927 					// grab time
928 					uint256 _now = now;
929 					
930 					// set new end time by adding rndDeciExt_ to NOW
931 					round_[_rID].end = rndDeciExt_.add(_now);
932 				}
933 				
934 				//reset all flags -- because we're leaving endGamePrcoess and not going to come back within a period of time.
935 				endRoundDecisionResult_ = false;
936 				address_of_last_rand_gen_source_ = address(0);
937 				goMakeDecision = false;
938 			}
939 			else
940 			{
941 				goMakeDecision = true; // because last sender is SC.
942 			}
943 		}
944 
945 		if(goMakeDecision == true)
946 		{
947 			//make a decision
948 			address_of_last_rand_gen_source_ = msg.sender;
949 			endRoundDecisionResult_ = endRoundDecision();	
950 		}				
951 	}
952 
953     /**
954      * @dev logic runs whenever a buy order is executed.  determines how to handle 
955      * incoming eth depending on if we are in an active round or not
956      */
957     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, H3Ddatasets.EventReturns memory _eventData_)
958         private
959     {
960         // setup local rID
961         uint256 _rID = rID_;
962         
963         // grab time
964         uint256 _now = now;
965         
966         // if round is active
967         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
968         {
969             // call core 
970             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
971         
972         // if round is not active     
973         } else {
974             // check to see if end round needs to be ran
975             if (_now > round_[_rID].end && round_[_rID].ended == false) 
976             {
977                 endRoundControl(_eventData_); 
978 				
979 				if(round_[_rID].ended == true)
980 				{
981 	                // build event data
982 	                _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
983 	                _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
984                 
985 	                // fire buy and distribute event 
986 	                emit H3Devents.onBuyAndDistribute
987 	                (
988 	                    msg.sender, 
989 	                    plyr_[_pID].name, 
990 	                    msg.value, 
991 	                    _eventData_.compressedData, 
992 	                    _eventData_.compressedIDs, 
993 	                    _eventData_.winnerAddr, 
994 	                    _eventData_.winnerName, 
995 	                    _eventData_.amountWon, 
996 	                    _eventData_.newPot, 
997 	                    _eventData_.P3DAmount, 
998 	                    _eventData_.genAmount
999 	                );
1000 				}
1001             }
1002             
1003             // put eth in players vault 
1004             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1005         }
1006     }
1007     
1008     /**
1009      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1010      * incoming eth depending on if we are in an active round or not 
1011      */
1012     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, H3Ddatasets.EventReturns memory _eventData_)
1013         private
1014     {
1015         // setup local rID
1016         uint256 _rID = rID_;
1017         
1018         // grab time
1019         uint256 _now = now;
1020         
1021         // if round is active
1022         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1023         {
1024             // get earnings from all vaults and return unused to gen vault
1025             // because we use a custom safemath library.  this will throw if player 
1026             // tried to spend more eth than they have.
1027             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1028             
1029             // call core 
1030             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1031         
1032         // if round is not active and end round needs to be ran   
1033         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1034 			
1035 			endRoundControl(_eventData_); 
1036 			
1037 			if(round_[_rID].ended == true)
1038 			{	            // build event data
1039 	            _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1040 	            _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1041                 
1042 	            // fire buy and distribute event 
1043 	            emit H3Devents.onReLoadAndDistribute
1044 	            (
1045 	                msg.sender, 
1046 	                plyr_[_pID].name, 
1047 	                _eventData_.compressedData, 
1048 	                _eventData_.compressedIDs, 
1049 	                _eventData_.winnerAddr, 
1050 	                _eventData_.winnerName, 
1051 	                _eventData_.amountWon, 
1052 	                _eventData_.newPot, 
1053 	                _eventData_.P3DAmount, 
1054 	                _eventData_.genAmount
1055 	            );
1056 			}
1057         }
1058     }
1059     
1060     /**
1061      * @dev this is the core logic for any buy/reload that happens while a round 
1062      * is live.
1063      */
1064     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, H3Ddatasets.EventReturns memory _eventData_)
1065         private
1066     {
1067         // if player is new to round
1068         if (plyrRnds_[_pID][_rID].keys == 0)
1069             _eventData_ = managePlayer(_pID, _eventData_); // don't have to do updateGenVault again because we have it in managePlayer()
1070 		else // if not, can use _rID directly, but we decided to still go with plyr_[_pID].lrnd
1071 			updateGenVault(_pID, plyr_[_pID].lrnd);	
1072         
1073         // early round eth limiter 
1074         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1075         {
1076             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1077             uint256 _refund = _eth.sub(_availableLimit);
1078             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1079             _eth = _availableLimit;
1080         }
1081         
1082         // if eth left is greater than min eth allowed (sorry no pocket lint)
1083         if (_eth > 1000000000) 
1084         {            
1085             // mint the new keys
1086             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1087             
1088             // if they bought at least 1 whole key
1089             if (_keys >= 1000000000000000000)
1090             {
1091 				updateTimer(_keys, _rID);
1092 
1093 				// set new leaders
1094 				if (round_[_rID].plyr != _pID)
1095 					round_[_rID].plyr = _pID;  
1096 				if (round_[_rID].team != _team)
1097 					round_[_rID].team = _team; 
1098 				
1099 				// set the new leader bool to true
1100 				_eventData_.compressedData = _eventData_.compressedData + 100;
1101 			}            
1102     
1103             // store the air drop tracker number (number of buys since last airdrop)
1104             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1105             
1106             // update player 
1107             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1108             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1109             
1110             // update round
1111             round_[_rID].keys = _keys.add(round_[_rID].keys);
1112             round_[_rID].eth = _eth.add(round_[_rID].eth);
1113             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1114     
1115             // distribute eth
1116             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
1117             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
1118 			
1119 			internalNoter(_rID, _pID);
1120 			
1121             // call end tx function to fire end tx event.
1122 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1123         }
1124     }
1125 //==============================================================================
1126 //     _ _ | _   | _ _|_ _  _ _  .
1127 //    (_(_||(_|_||(_| | (_)| _\  .
1128 //==============================================================================
1129     /**
1130      * @dev calculates unmasked earnings (just calculates, does not update mask)
1131      * @return earnings in wei format
1132      */
1133     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1134         private
1135         view
1136         returns(uint256)
1137     {
1138         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1139     }
1140     
1141     /** 
1142      * @dev returns the amount of keys you would get given an amount of eth. 
1143      * -functionhash- 0xce89c80c
1144      * @param _rID round ID you want price for
1145      * @param _eth amount of eth sent in 
1146      * @return keys received 
1147      */
1148     function calcKeysReceived(uint256 _rID, uint256 _eth)
1149         public
1150         view
1151         returns(uint256)
1152     {
1153         // grab time
1154         uint256 _now = now;
1155         
1156         // are we in a round?
1157         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1158             return ( (round_[_rID].eth).keysRec(_eth) );
1159         else // rounds over.  need keys for new round
1160             return ( (_eth).keys() );
1161     }
1162     
1163     /** 
1164      * @dev returns current eth price for X keys.  
1165      * -functionhash- 0xcf808000
1166      * @param _keys number of keys desired (in 18 decimal format)
1167      * @return amount of eth needed to send
1168      */
1169     function iWantXKeys(uint256 _keys)
1170         public
1171         view
1172         returns(uint256)
1173     {
1174         // setup local rID
1175         uint256 _rID = rID_;
1176         
1177         // grab time
1178         uint256 _now = now;
1179         
1180         // are we in a round?
1181         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1182             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1183         else // rounds over.  need price for new round
1184             return ( (_keys).eth() );
1185     }
1186 //==============================================================================
1187 //    _|_ _  _ | _  .
1188 //     | (_)(_)|_\  .
1189 //==============================================================================
1190     /**
1191 	 * @dev receives name/player info from names contract 
1192      */
1193     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1194         external
1195     {
1196         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1197         if (pIDxAddr_[_addr] != _pID)
1198             pIDxAddr_[_addr] = _pID;
1199         if (pIDxName_[_name] != _pID)
1200             pIDxName_[_name] = _pID;
1201         if (plyr_[_pID].addr != _addr)
1202             plyr_[_pID].addr = _addr;
1203         if (plyr_[_pID].name != _name)
1204             plyr_[_pID].name = _name;
1205         if (plyr_[_pID].laff != _laff)
1206             plyr_[_pID].laff = _laff;
1207         if (plyrNames_[_pID][_name] == false)
1208             plyrNames_[_pID][_name] = true;
1209     }
1210     
1211     /**
1212      * @dev receives entire player name list 
1213      */
1214     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1215         external
1216     {
1217         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1218         if(plyrNames_[_pID][_name] == false)
1219             plyrNames_[_pID][_name] = true;
1220     }   
1221         
1222     /**
1223      * @dev gets existing or registers new pID.  use this when a player may be new
1224      * @return pID 
1225      */
1226     function determinePID(H3Ddatasets.EventReturns memory _eventData_)
1227         private
1228         returns (H3Ddatasets.EventReturns)
1229     {
1230         uint256 _pID = pIDxAddr_[msg.sender];
1231         // if player is new to this version of Heaven3D
1232         if (_pID == 0)
1233         {
1234             // grab their player ID, name and last aff ID, from player names contract 
1235             _pID = PlayerBook.getPlayerID(msg.sender);
1236             bytes32 _name = PlayerBook.getPlayerName(_pID);
1237             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1238             
1239             // set up player account 
1240             pIDxAddr_[msg.sender] = _pID;
1241             plyr_[_pID].addr = msg.sender;
1242             
1243             if (_name != "")
1244             {
1245                 pIDxName_[_name] = _pID;
1246                 plyr_[_pID].name = _name;
1247                 plyrNames_[_pID][_name] = true;
1248             }
1249             
1250             if (_laff != 0 && _laff != _pID)
1251                 plyr_[_pID].laff = _laff;
1252             
1253             // set the new player bool to true
1254             _eventData_.compressedData = _eventData_.compressedData + 1;
1255         } 
1256         return (_eventData_);
1257     }
1258     
1259     /**
1260      * @dev checks to make sure user picked a valid team.  if not sets team 
1261      * to default (sneks)
1262      */
1263     function verifyTeam(uint256 _team)
1264         private
1265         pure
1266         returns (uint256)
1267     {
1268         if (_team < 0 || _team > 3)
1269             return(2);
1270         else
1271             return(_team);
1272     }
1273     
1274     /**
1275      * @dev decides if round end needs to be run & new round started.  and if 
1276      * player unmasked earnings from previously played rounds need to be moved.
1277      */
1278     function managePlayer(uint256 _pID, H3Ddatasets.EventReturns memory _eventData_)
1279         private
1280         returns (H3Ddatasets.EventReturns)
1281     {
1282         // if player has played a previous round, move their unmasked earnings
1283         // from that round to gen vault.
1284         if (plyr_[_pID].lrnd != 0)
1285             updateGenVault(_pID, plyr_[_pID].lrnd);
1286             
1287         // update player's last round played
1288         plyr_[_pID].lrnd = rID_;
1289             
1290         // set the joined round bool to true
1291         _eventData_.compressedData = _eventData_.compressedData + 10;
1292         
1293         return(_eventData_);
1294     }
1295     
1296     /**
1297      * @dev ends the round. manages paying out winner/splitting up pot
1298      */
1299     function endRound(H3Ddatasets.EventReturns memory _eventData_)
1300         private
1301         returns (H3Ddatasets.EventReturns)
1302     {
1303         // setup local rID
1304         uint256 _rID = rID_;
1305         
1306         // grab our winning player and team id's
1307         uint256 _winPID = round_[_rID].plyr;
1308         uint256 _winTID = round_[_rID].team;
1309         
1310         // grab our pot amount
1311         uint256 _pot = round_[_rID].pot;
1312         
1313         // calculate our winner share, community rewards, gen share, 
1314         // p3d share, and amount reserved for next pot 
1315         uint256 _win = (_pot.mul(68)) / 100; // for all winners
1316         uint256 _com = (_pot.mul(10)) / 100; // for community 
1317         uint256 _gen = 0; 
1318         uint256 _p3d = 0;
1319 		
1320 		// community rewards
1321 		TeamDreamHub_.deposit.value(_com)();
1322 		
1323 		uint256 _res = ((_pot.sub(_com)).sub(_gen)).sub(_p3d); // _win should be handled later.        
1324 		(_res,_eventData_) = winnersProfitDistributor(_rID, _win, _res, _eventData_); // distribute to all winners
1325 		
1326 		// if update in smart contract is neccessary, the developers will trigger this mechanism.
1327 		// in this condition we're going into maintenance mode in order to update the smart contract on the blockchain
1328 		// we developers will put _res into the next pot manually when H3D is going online again.
1329 		// the down time is expected to be short.
1330 		if(noMoreNextRound_ == true)
1331 		{
1332 			owner.transfer(_res);
1333 			_res = 0;
1334 		}
1335             
1336         // prepare event data
1337         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1338         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1339         _eventData_.winnerAddr = plyr_[_winPID].addr;
1340         _eventData_.winnerName = plyr_[_winPID].name;
1341         _eventData_.amountWon = _win;
1342         _eventData_.genAmount = _gen;
1343         _eventData_.P3DAmount = _p3d;
1344         _eventData_.newPot = _res;
1345         
1346         // start next round
1347         rID_++;
1348         _rID++;
1349         round_[_rID].strt = now;
1350         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1351         round_[_rID].pot = _res; // the rest goes to next pot
1352         
1353         return(_eventData_);
1354     }
1355     
1356     /**
1357      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1358      */
1359     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1360         private 
1361     {
1362         uint256 dividend_yet_distribute = calcUnMaskedEarnings(_pID, _rIDlast);
1363         if (dividend_yet_distribute > 0)
1364         {			
1365 			uint256 _earnings;
1366 			uint256 all_dividend_earned = dividend_yet_distribute.add(plyrRnds_[_pID][_rIDlast].eth_went_to_gen);
1367 			//check 3x limit
1368 			if (all_dividend_earned > (plyrRnds_[_pID][_rIDlast].eth).mul(3))
1369 			{	
1370 				//===adjustment done accordingly===
1371 				
1372 				//seperate exceeds_part from dividend_yet_distribute
1373 				uint256 remain_quota = (plyrRnds_[_pID][_rIDlast].eth).mul(3).sub(plyrRnds_[_pID][_rIDlast].eth_went_to_gen); // can only provide the dividend withing 3x of inputed eth.
1374 				uint256 exceeds_part = dividend_yet_distribute.sub(remain_quota);
1375 
1376 				_earnings = remain_quota;
1377 				
1378 		        // add exceeds_part as new profit to the current round and adjust round.mask accordingly				
1379 				uint256 _dust = updateMasks(rID_, _pID, exceeds_part, 0); // keys = 0 because didn't add new key.
1380 				if (_dust > 0) // add dust to pot
1381 					round_[rID_].pot = round_[rID_].pot.add(_dust);	
1382 			}
1383 			else
1384 			{
1385 				_earnings = dividend_yet_distribute;
1386 			}
1387 			
1388 			// put in gen vault
1389 			plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1390 			
1391 			//note to eth_went_to_gen, in order to estimate all eth passed to geb vault in the current round.
1392 			plyrRnds_[_pID][_rIDlast].eth_went_to_gen = _earnings.add(plyrRnds_[_pID][_rIDlast].eth_went_to_gen);			
1393 			
1394 			// zero out their earnings by updating mask
1395 			plyrRnds_[_pID][_rIDlast].mask = dividend_yet_distribute.add(plyrRnds_[_pID][_rIDlast].mask);
1396         }
1397     }
1398     
1399     /**
1400      * @dev updates round timer based on number of whole keys bought.
1401      */
1402     function updateTimer(uint256 _keys, uint256 _rID)
1403         private
1404     {
1405         // grab time
1406         uint256 _now = now;
1407         
1408         // calculate time based on number of keys bought
1409         uint256 _newTime;
1410         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1411             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1412         else
1413             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1414         
1415         // compare to max and set new end time
1416         if (_newTime < (rndMax_).add(_now))
1417             round_[_rID].end = _newTime;
1418         else
1419             round_[_rID].end = rndMax_.add(_now);
1420     }
1421 	
1422 	/**
1423      * @dev generates a random number in order to make a decision
1424      * @return PASS or REJECT?
1425      */
1426     function endRoundDecision()
1427         private 
1428         returns(bool)
1429     {
1430 		bool decision = false;
1431         uint256 seed = uint256(keccak256(abi.encodePacked(
1432             
1433             (block.timestamp).add
1434             (block.difficulty).add
1435             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1436             (block.gaslimit).add
1437             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1438             (block.number)
1439             
1440         )));
1441         
1442 		uint256 randNum = (seed - ((seed / 1000) * 1000));
1443 		if(randNum < 50) // 5% probability
1444             decision = true;
1445 		
1446 		// fire event
1447 		emit H3Devents.onNewDecision(msg.sender,randNum,decision);
1448 		
1449 		return decision;
1450     }	
1451 	
1452 	/**
1453      * @dev check if an address is smart contract
1454      * @return true (Not smart contract) or false
1455      */
1456     function checkNotSmartContract(address targetAddr)
1457         private 
1458         returns(bool)
1459     {
1460 		uint256 _codeLength;        
1461 		assembly {
1462 			_codeLength := extcodesize(targetAddr)
1463 		}
1464 		
1465 		if(_codeLength == 0) // last sender is human
1466 			return true;
1467 		else
1468 			return false;
1469     }	
1470     
1471 
1472     /**
1473      * @dev distributes eth based on fees to com, aff, and p3d
1474      */
1475     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, H3Ddatasets.EventReturns memory _eventData_)
1476         private
1477         returns(H3Ddatasets.EventReturns)
1478     {
1479         // pay 10% out to community fund
1480         uint256 _com = (_eth.mul(10)) / 100;
1481         uint256 _p3d = 0;
1482                 
1483         // distribute share to affiliate
1484         uint256 _aff = _eth / 10;
1485         
1486         // decide what to do with affiliate share of fees
1487         // affiliate must not be self, and must have a name registered
1488         if (_affID != _pID && plyr_[_affID].name != '') {
1489             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1490             emit H3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1491         } else {
1492 			_com = _com.add(_aff);
1493         }
1494 		
1495 		// payout community rewards
1496 		TeamDreamHub_.deposit.value(_com)();
1497         
1498         return(_eventData_);
1499     }
1500     
1501     function potSwap()
1502         external
1503         payable
1504     {
1505         // setup local rID
1506         uint256 _rID = rID_ + 1;
1507         
1508         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1509         emit H3Devents.onPotSwapDeposit(_rID, msg.value);
1510     }
1511     
1512     /**
1513      * @dev distributes eth based on fees to gen and pot
1514      */
1515     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, H3Ddatasets.EventReturns memory _eventData_)
1516         private
1517         returns(H3Ddatasets.EventReturns)
1518     {
1519         // calculate gen share
1520         uint256 _gen = (_eth.mul(60)) / 100; 
1521         
1522         // update eth balance (eth = eth - (com share + aff share + p3d share + airdrop pot share))
1523         _eth = _eth.sub((_eth.mul(20)) / 100);
1524         
1525         // calculate pot 
1526         uint256 _pot = _eth.sub(_gen);
1527         
1528         // distribute gen share (thats what updateMasks() does) and adjust
1529         // balances for dust.
1530         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1531         if (_dust > 0)
1532             _gen = _gen.sub(_dust);
1533         
1534         // add eth to pot
1535         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1536         
1537         // set up event data
1538         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1539         _eventData_.potAmount = _pot;
1540         
1541         return(_eventData_);
1542     }
1543 	
1544 	/**
1545      * @dev distribute profits (_win) to the pot winners)
1546      */
1547     function winnersProfitDistributor(uint256 _rID, uint256 _win, uint256 _res, H3Ddatasets.EventReturns memory _eventData_)
1548         private
1549 		returns (uint256, H3Ddatasets.EventReturns)
1550     {		
1551 		uint256 _pIDtmp; 
1552 		uint256 _paidPlayerCount; // note how many players have been paid already.
1553 		uint256 _bonus_portion; // compute portions
1554 
1555 		// pay the rand number generator caller
1556 		_bonus_portion = (_win.mul(10)) / 1000;		// 1%; to random number generator's caller		
1557         _eventData_ = determinePID(_eventData_);
1558         _pIDtmp = pIDxAddr_[address_of_last_rand_gen_source_];
1559 		plyr_[_pIDtmp].win = _bonus_portion.add(plyr_[_pIDtmp].win);
1560 		_res = _res.sub(_bonus_portion);
1561         
1562 		// pay our latestPlayers
1563 		_bonus_portion = (_win.mul(49)) / 1000; // 49x10 = 490; _win_latestPlayer_slot
1564 		_paidPlayerCount = 0;
1565         for (uint i = 0; i < round_[_rID].latestPlayers.length; i++) // remove _pID from the list first
1566 		{			
1567 			if(round_[_rID].latestPlayers[i] == 0)  // early-stop
1568 			{
1569 				break;
1570 			}
1571 			
1572 			if(_paidPlayerCount == rule_limit_latestPlayersCnt) // already paid enough players
1573 			{
1574 				break;
1575 			}
1576 							
1577 			// only pay out for human player
1578 			_pIDtmp = round_[_rID].latestPlayers[i];
1579 			if(checkNotSmartContract(plyr_[_pIDtmp].addr))
1580 			{
1581 				plyr_[_pIDtmp].win = _bonus_portion.add(plyr_[_pIDtmp].win);
1582 				_res = _res.sub(_bonus_portion);
1583 				pPAIDxID_[round_[_rID].latestPlayers[i]] = _bonus_portion;
1584 				_paidPlayerCount++;
1585 			}
1586 			
1587 		}
1588 		
1589 		// pay our heavyPlayers
1590 		_bonus_portion = (_win.mul(50)) / 1000; // 50x10 = 500; _win_heavyPlayer_slot		
1591 		_paidPlayerCount = 0;
1592 		for (i = 0; i < round_[_rID].heavyPlayers.length; i++) // remove _pID from the list first
1593 		{			
1594 			if(round_[_rID].heavyPlayers[i] == 0)  // early-stop
1595 			{
1596 				break;								
1597 			}
1598 			
1599 			if(_paidPlayerCount == rule_limit_heavyPlayersCnt) // already paid enough players
1600 			{
1601 				break;			
1602 			}
1603 			
1604 			// only pay out for human player
1605 			_pIDtmp = round_[_rID].heavyPlayers[i];
1606 			if(checkNotSmartContract(plyr_[_pIDtmp].addr))
1607 			{				
1608 				if(pPAIDxID_[_pIDtmp] != 0) // don't paid the latestPlayer again.
1609 					continue;
1610 				
1611 				plyr_[_pIDtmp].win = _bonus_portion.add(plyr_[_pIDtmp].win);
1612 				_res = _res.sub(_bonus_portion);
1613 				_paidPlayerCount++;
1614 			}
1615 		}		
1616 		// clear pPAIDxID_ for the use in next round's endround process.
1617 		for (i = 0; i < round_[_rID].latestPlayers.length; i++)
1618 			pPAIDxID_[round_[_rID].latestPlayers[i]] = 0;		
1619 		
1620 		return (_res,_eventData_);
1621 	}
1622 	
1623     /**
1624      * @dev note neccessary info.
1625      */
1626     function internalNoter(uint256 _rID, uint256 _pID)
1627         private
1628     {
1629 			//update latestPlayers
1630 			uint idx_to_insert = round_[_rID].latestPlayers.length - 1; // default goes to the end of list
1631 			for (uint i = 0; i < round_[_rID].latestPlayers.length; i++) // remove _pID from the list first
1632 			{
1633 				if(round_[_rID].latestPlayers[i] == 0)  // early-stop
1634 				{
1635 					idx_to_insert = i;
1636 					break;								
1637 				}
1638 				if(round_[_rID].latestPlayers[i] == _pID) // case: if _pID already on the list
1639 				{
1640 					for (uint j = i; j < (round_[_rID].latestPlayers.length - 1); j++)
1641 					{
1642 						round_[_rID].latestPlayers[j] = round_[_rID].latestPlayers[j+1]; // remove item i
1643 						if(round_[_rID].latestPlayers[j+1] == 0) // early-stop
1644 							break;
1645 					}
1646 					break;
1647 				}			
1648 			}			
1649 			if (idx_to_insert == (round_[_rID].latestPlayers.length - 1)) // only do it when former loop hasn't found an idx to insert
1650 			{
1651 				for (i = (round_[_rID].latestPlayers.length - 1); i >= 0; i--) // reversely checking for an empty position
1652 				{	
1653 					if(round_[_rID].latestPlayers[i] == 0) // case: in the beginning
1654 					{
1655 						idx_to_insert = i;
1656 						break;
1657 					}						
1658 				}
1659 			}
1660 			round_[_rID].latestPlayers[idx_to_insert] = _pID; // note the player to the list
1661 				
1662 				
1663 			//update heavyPlayers
1664 			idx_to_insert = round_[_rID].heavyPlayers.length - 1; // default goes to the end of list
1665 			for (i = 0; i < round_[_rID].heavyPlayers.length; i++) // remove _pID from the list first
1666 			{
1667 				if(round_[_rID].heavyPlayers[i] == 0)  // early-stop
1668 				{
1669 					// do NOT take this idx as the idx_to_insert because should also sort the list based on playerRound.eth
1670 					break;								
1671 				}
1672 				if(round_[_rID].heavyPlayers[i] == _pID) // case: if _pID already on the list
1673 				{
1674 					for (j = i; j < (round_[_rID].heavyPlayers.length - 1); j++)
1675 					{
1676 						round_[_rID].heavyPlayers[j] = round_[_rID].heavyPlayers[j+1]; // remove item i
1677 						if(round_[_rID].heavyPlayers[j+1] == 0) // early-stop
1678 						{
1679 							// do NOT take this idx as the idx_to_insert because should also sort the list based on playerRound.eth
1680 							break;
1681 						}
1682 					}
1683 					break;
1684 				}			
1685 			}							
1686 			for (i = 0; i < round_[_rID].heavyPlayers.length; i++)
1687 			{	
1688 				if(round_[_rID].heavyPlayers[i] == 0) // case: in the beginning
1689 				{
1690 					idx_to_insert = i;
1691 					break;
1692 				}	
1693 				else
1694 				{
1695 					if(plyrRnds_[_pID][_rID].eth > plyrRnds_[round_[_rID].heavyPlayers[i]][_rID].eth) // found spent eth more than another player on the list
1696 					{
1697 						idx_to_insert = i;
1698 						for (j = i; j < (round_[_rID].heavyPlayers.length - 1); j++)
1699 						{
1700 							round_[_rID].heavyPlayers[j+1] = round_[_rID].heavyPlayers[j]; // remove item in the end
1701 						}
1702 						break;						
1703 					}			
1704 				}				
1705 			}
1706 			round_[_rID].heavyPlayers[idx_to_insert] = _pID; // note the player to the list            
1707     }	
1708 
1709     /**
1710      * @dev updates masks for round and player when keys are bought
1711      * @return dust left over 
1712      */
1713     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1714         private
1715         returns(uint256)
1716     {
1717         /* MASKING NOTES
1718             earnings masks are a tricky thing for people to wrap their minds around.
1719             the basic thing to understand here.  is were going to have a global
1720             tracker based on profit per share for each round, that increases in
1721             relevant proportion to the increase in share supply.
1722             
1723             the player will have an additional mask that basically says "based
1724             on the rounds mask, my shares, and how much i've already withdrawn,
1725             how much is still owed to me?"
1726         */
1727         
1728 		uint256 _ppt;
1729 		if(round_[_rID].keys.sub(_keys) == 0) // only 1st key buyer can earn dividend based on the keys just purchased
1730 		{
1731 			// calc profit per key & round mask based on this buy:  (dust goes to pot)
1732 			_ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1733 			round_[_rID].mask = _ppt.add(round_[_rID].mask);
1734 				
1735 			// calculate player earning from their own buy (only based on the keys
1736 			// they just bought).  & update player earnings mask
1737 			uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1738 			plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1739 			return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000))); // calculate & return dust
1740 		}
1741 		else
1742 		{
1743 			// calc profit per key & round mask based on this buy:  (dust goes to pot)
1744 			_ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys.sub(_keys));
1745 			round_[_rID].mask = _ppt.add(round_[_rID].mask);
1746 				
1747 			// update player earnings mask so they cannot obtain profit generated based on their own input
1748 			plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000))).add(plyrRnds_[_pID][_rID].mask);
1749 			return(_gen.sub((_ppt.mul(round_[_rID].keys.sub(_keys))) / (1000000000000000000))); // calculate & return dust
1750 		}		
1751         
1752     }
1753     
1754     /**
1755      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1756      * @return earnings in wei format
1757      */
1758     function withdrawEarnings(uint256 _pID)
1759         private
1760         returns(uint256)
1761     {
1762         // update gen vault
1763         updateGenVault(_pID, plyr_[_pID].lrnd);
1764         
1765         // from vaults 
1766         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1767         if (_earnings > 0)
1768         {
1769             plyr_[_pID].win = 0;
1770             plyr_[_pID].gen = 0;
1771             plyr_[_pID].aff = 0;
1772         }
1773 
1774         return(_earnings);
1775     }
1776     
1777     /**
1778      * @dev prepares compression data and fires event for buy or reload tx's
1779      */
1780     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, H3Ddatasets.EventReturns memory _eventData_)
1781         private
1782     {
1783         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1784         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1785         
1786         emit H3Devents.onEndTx
1787         (
1788             _eventData_.compressedData,
1789             _eventData_.compressedIDs,
1790             plyr_[_pID].name,
1791             msg.sender,
1792             _eth,
1793             _keys,
1794             _eventData_.winnerAddr,
1795             _eventData_.winnerName,
1796             _eventData_.amountWon,
1797             _eventData_.newPot,
1798             _eventData_.P3DAmount,
1799             _eventData_.genAmount,
1800             _eventData_.potAmount,
1801             airDropPot_
1802         );
1803     }
1804 //==============================================================================
1805 //    (~ _  _    _._|_    .
1806 //    _)(/_(_|_|| | | \/  .
1807 //====================/=========================================================
1808     /** upon contract deploy, it will be deactivated.  this is a one time
1809      * use function that will activate the contract.  we do this so devs 
1810      * have time to set things up on the web end                            **/
1811     bool public activated_ = false;
1812     function activate()
1813         public
1814     {
1815         // only Team Dream can activate 
1816         require(
1817             msg.sender == owner,
1818             "only Team Dream can activate"
1819         );
1820         
1821         // can only be ran once
1822         require(activated_ == false, "Heaven3D already activated");
1823         
1824         // activate the contract 
1825         activated_ = true;
1826         
1827         // lets start first round
1828 		rID_ = 1;
1829         round_[1].strt = now + rndExtra_ - rndGap_;
1830         round_[1].end = now + rndInit_ + rndExtra_;
1831     }
1832 	
1833 }
1834 
1835 //==============================================================================
1836 //   __|_ _    __|_ _  .
1837 //  _\ | | |_|(_ | _\  .
1838 //==============================================================================
1839 library H3Ddatasets {
1840     //compressedData key
1841     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1842         // 0 - new player (bool)
1843         // 1 - joined round (bool)
1844         // 2 - new  leader (bool)
1845         // 3-5 - air drop tracker (uint 0-999)
1846         // 6-16 - round end time
1847         // 17 - winnerTeam
1848         // 18 - 28 timestamp 
1849         // 29 - team
1850         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1851         // 31 - airdrop happened bool
1852         // 32 - airdrop tier 
1853         // 33 - airdrop amount won
1854     //compressedIDs key
1855     // [77-52][51-26][25-0]
1856         // 0-25 - pID 
1857         // 26-51 - winPID
1858         // 52-77 - rID
1859     struct EventReturns {
1860         uint256 compressedData;
1861         uint256 compressedIDs;
1862         address winnerAddr;         // winner address
1863         bytes32 winnerName;         // winner name
1864         uint256 amountWon;          // amount won
1865         uint256 newPot;             // amount in new pot
1866         uint256 P3DAmount;          // amount distributed to p3d
1867         uint256 genAmount;          // amount distributed to gen
1868         uint256 potAmount;          // amount added to pot
1869     }
1870     struct Player {
1871         address addr;   // player address
1872         bytes32 name;   // player name
1873         uint256 win;    // winnings vault
1874         uint256 gen;    // general vault
1875         uint256 aff;    // affiliate vault
1876         uint256 lrnd;   // last round played
1877         uint256 laff;   // last affiliate id used
1878     }
1879     struct PlayerRounds {
1880         uint256 eth;    // eth player has added to round (used for eth limiter and also for dividend upper bound limiter)
1881         uint256 keys;   // keys
1882         uint256 mask;   // player mask 
1883 		uint256 eth_went_to_gen;    // dividend earned and moved to gen bal. 
1884         uint256 ico;    // ICO phase investment
1885     }
1886     struct Round {
1887 		uint256[20] latestPlayers; 	// latest players
1888 		uint256[20] heavyPlayers; 	// players with top eth invested 
1889 	
1890         uint256 plyr;   // pID of player in lead
1891         uint256 team;   // tID of team in lead
1892         uint256 end;    // time ends/ended
1893         bool ended;     // has round end function been ran
1894         uint256 strt;   // time round started
1895         uint256 keys;   // keys
1896         uint256 eth;    // total eth in
1897         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1898         uint256 mask;   // global mask
1899         uint256 ico;    // total eth sent in during ICO phase
1900         uint256 icoGen; // total eth for gen during ICO phase
1901         uint256 icoAvg; // average key price for ICO phase
1902     }
1903 }
1904 
1905 //==============================================================================
1906 //  |  _      _ _ | _  .
1907 //  |<(/_\/  (_(_||(_  .
1908 //=======/======================================================================
1909 library H3DKeysCalcLong {
1910     using SafeMath for *;
1911     /**
1912      * @dev calculates number of keys received given X eth 
1913      * @param _curEth current amount of eth in contract 
1914      * @param _newEth eth being spent
1915      * @return amount of ticket purchased
1916      */
1917     function keysRec(uint256 _curEth, uint256 _newEth)
1918         internal
1919         pure
1920         returns (uint256)
1921     {
1922         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1923     }
1924     
1925     /**
1926      * @dev calculates amount of eth received if you sold X keys 
1927      * @param _curKeys current amount of keys that exist 
1928      * @param _sellKeys amount of keys you wish to sell
1929      * @return amount of eth received
1930      */
1931     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1932         internal
1933         pure
1934         returns (uint256)
1935     {
1936         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1937     }
1938 
1939     /**
1940      * @dev calculates how many keys would exist with given an amount of eth
1941      * @param _eth eth "in contract"
1942      * @return number of keys that would exist
1943      */
1944     function keys(uint256 _eth) 
1945         internal
1946         pure
1947         returns(uint256)
1948     {
1949         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1950     }
1951     
1952     /**
1953      * @dev calculates how much eth would be in contract given a number of keys
1954      * @param _keys number of keys "in contract" 
1955      * @return eth that would exists
1956      */
1957     function eth(uint256 _keys) 
1958         internal
1959         pure
1960         returns(uint256)  
1961     {
1962         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1963     }
1964 }
1965 
1966 //==============================================================================
1967 //  . _ _|_ _  _ |` _  _ _  _  .
1968 //  || | | (/_| ~|~(_|(_(/__\  .
1969 //==============================================================================
1970 interface PlayerBookInterface {
1971     function getPlayerID(address _addr) external returns (uint256);
1972     function getPlayerName(uint256 _pID) external view returns (bytes32);
1973     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1974     function getPlayerAddr(uint256 _pID) external view returns (address);
1975     function getNameFee() external view returns (uint256);
1976     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1977     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1978     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1979 }
1980 
1981 interface TeamDreamHubInterface {
1982     function deposit() external payable;
1983 }
1984 
1985 /**
1986 * @title -Name Filter- v0.1.9
1987 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1988 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1989 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1990 *                                  _____                      _____
1991 *                                 (, /     /)       /) /)    (, /      /)          /)
1992 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1993 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1994 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1995 *                            (__ /          (_/ (, /                                      /)™ 
1996 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1997 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1998 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1999 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
2000 *              _       __    _      ____      ____  _   _    _____  ____  ___  
2001 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
2002 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
2003 *
2004 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
2005 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
2006 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
2007 */
2008 
2009 library NameFilter {
2010     /**
2011      * @dev filters name strings
2012      * -converts uppercase to lower case.  
2013      * -makes sure it does not start/end with a space
2014      * -makes sure it does not contain multiple spaces in a row
2015      * -cannot be only numbers
2016      * -cannot start with 0x 
2017      * -restricts characters to A-Z, a-z, 0-9, and space.
2018      * @return reprocessed string in bytes32 format
2019      */
2020     function nameFilter(string _input)
2021         internal
2022         pure
2023         returns(bytes32)
2024     {
2025         bytes memory _temp = bytes(_input);
2026         uint256 _length = _temp.length;
2027         
2028         //sorry limited to 32 characters
2029         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
2030         // make sure it doesnt start with or end with space
2031         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
2032         // make sure first two characters are not 0x
2033         if (_temp[0] == 0x30)
2034         {
2035             require(_temp[1] != 0x78, "string cannot start with 0x");
2036             require(_temp[1] != 0x58, "string cannot start with 0X");
2037         }
2038         
2039         // create a bool to track if we have a non number character
2040         bool _hasNonNumber;
2041         
2042         // convert & check
2043         for (uint256 i = 0; i < _length; i++)
2044         {
2045             // if its uppercase A-Z
2046             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2047             {
2048                 // convert to lower case a-z
2049                 _temp[i] = byte(uint(_temp[i]) + 32);
2050                 
2051                 // we have a non number
2052                 if (_hasNonNumber == false)
2053                     _hasNonNumber = true;
2054             } else {
2055                 require
2056                 (
2057                     // require character is a space
2058                     _temp[i] == 0x20 || 
2059                     // OR lowercase a-z
2060                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2061                     // or 0-9
2062                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2063                     "string contains invalid characters"
2064                 );
2065                 // make sure theres not 2x spaces in a row
2066                 if (_temp[i] == 0x20)
2067                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2068                 
2069                 // see if we have a character other than a number
2070                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2071                     _hasNonNumber = true;    
2072             }
2073         }
2074         
2075         require(_hasNonNumber == true, "string cannot be only numbers");
2076         
2077         bytes32 _ret;
2078         assembly {
2079             _ret := mload(add(_temp, 32))
2080         }
2081         return (_ret);
2082     }
2083 }
2084 
2085 /**
2086  * @title SafeMath v0.1.9
2087  * @dev Math operations with safety checks that throw on error
2088  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2089  * - added sqrt
2090  * - added sq
2091  * - added pwr 
2092  * - changed asserts to requires with error log outputs
2093  * - removed div, its useless
2094  */
2095 library SafeMath {
2096     
2097     /**
2098     * @dev Multiplies two numbers, throws on overflow.
2099     */
2100     function mul(uint256 a, uint256 b) 
2101         internal 
2102         pure 
2103         returns (uint256 c) 
2104     {
2105         if (a == 0) {
2106             return 0;
2107         }
2108         c = a * b;
2109         require(c / a == b, "SafeMath mul failed");
2110         return c;
2111     }
2112 
2113     /**
2114     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2115     */
2116     function sub(uint256 a, uint256 b)
2117         internal
2118         pure
2119         returns (uint256) 
2120     {
2121         require(b <= a, "SafeMath sub failed");
2122         return a - b;
2123     }
2124 
2125     /**
2126     * @dev Adds two numbers, throws on overflow.
2127     */
2128     function add(uint256 a, uint256 b)
2129         internal
2130         pure
2131         returns (uint256 c) 
2132     {
2133         c = a + b;
2134         require(c >= a, "SafeMath add failed");
2135         return c;
2136     }
2137     
2138     /**
2139      * @dev gives square root of given x.
2140      */
2141     function sqrt(uint256 x)
2142         internal
2143         pure
2144         returns (uint256 y) 
2145     {
2146         uint256 z = ((add(x,1)) / 2);
2147         y = x;
2148         while (z < y) 
2149         {
2150             y = z;
2151             z = ((add((x / z),z)) / 2);
2152         }
2153     }
2154     
2155     /**
2156      * @dev gives square. multiplies x by x
2157      */
2158     function sq(uint256 x)
2159         internal
2160         pure
2161         returns (uint256)
2162     {
2163         return (mul(x,x));
2164     }
2165     
2166     /**
2167      * @dev x to the power of y 
2168      */
2169     function pwr(uint256 x, uint256 y)
2170         internal 
2171         pure 
2172         returns (uint256)
2173     {
2174         if (x==0)
2175             return (0);
2176         else if (y==0)
2177             return (1);
2178         else 
2179         {
2180             uint256 z = x;
2181             for (uint256 i=1; i < y; i++)
2182                 z = mul(z,x);
2183             return (z);
2184         }
2185     }
2186 }