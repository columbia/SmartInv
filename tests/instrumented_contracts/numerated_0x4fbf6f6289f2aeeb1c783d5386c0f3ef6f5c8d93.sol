1 pragma solidity ^0.4.24;
2 
3 //==============================================================================
4 //     _    _  _ _|_ _  .
5 //    (/_\/(/_| | | _\  .
6 //==============================================================================
7 contract X3Devents {
8     // fired whenever a player registers a name
9     event onNewName
10     (
11         uint256 indexed playerID,
12         address indexed playerAddress,
13         bytes32 indexed playerName,
14         bool isNewPlayer,
15         uint256 affiliateID,
16         address affiliateAddress,
17         bytes32 affiliateName,
18         uint256 amountPaid,
19         uint256 timeStamp
20     );
21     
22     // fired at end of buy or reload
23     event onEndTx
24     (
25         uint256 compressedData,     
26         uint256 compressedIDs,      
27         bytes32 playerName,
28         address playerAddress,
29         uint256 ethIn,
30         uint256 keysBought,
31         address winnerAddr,
32         bytes32 winnerName,
33         uint256 amountWon,
34         uint256 newPot,
35         uint256 XCOMAmount,
36         uint256 genAmount,
37         uint256 potAmount,
38         uint256 airDropPot
39     );
40     
41 	// fired whenever theres a withdraw
42     event onWithdraw
43     (
44         uint256 indexed playerID,
45         address playerAddress,
46         bytes32 playerName,
47         uint256 ethOut,
48         uint256 timeStamp
49     );
50     
51     // fired whenever a withdraw forces end round to be ran
52     event onWithdrawAndDistribute
53     (
54         address playerAddress,
55         bytes32 playerName,
56         uint256 ethOut,
57         uint256 compressedData,
58         uint256 compressedIDs,
59         address winnerAddr,
60         bytes32 winnerName,
61         uint256 amountWon,
62         uint256 newPot,
63         uint256 XCOMAmount,
64         uint256 genAmount
65     );
66     
67     //fired whenever a player tries a buy after round timer 
68     // hit zero, and causes end round to be ran.
69     event onBuyAndDistribute
70     (
71         address playerAddress,
72         bytes32 playerName,
73         uint256 ethIn,
74         uint256 compressedData,
75         uint256 compressedIDs,
76         address winnerAddr,
77         bytes32 winnerName,
78         uint256 amountWon,
79         uint256 newPot,
80         uint256 XCOMAmount,
81         uint256 genAmount
82     );
83     
84     // fired whenever a player tries a reload after round timer 
85     // hit zero, and causes end round to be ran.
86     event onReLoadAndDistribute
87     (
88         address playerAddress,
89         bytes32 playerName,
90         uint256 compressedData,
91         uint256 compressedIDs,
92         address winnerAddr,
93         bytes32 winnerName,
94         uint256 amountWon,
95         uint256 newPot,
96         uint256 XCOMAmount,
97         uint256 genAmount
98     );
99     
100     // fired whenever an affiliate is paid
101     event onAffiliatePayout
102     (
103         uint256 indexed affiliateID,
104         address affiliateAddress,
105         bytes32 affiliateName,
106         uint256 indexed roundID,
107         uint256 indexed buyerID,
108         uint256 amount,
109         uint256 timeStamp
110     );
111         
112 }
113 
114 
115 /**
116  * @title Ownable
117  * @dev The Ownable contract has an owner address, and provides basic authorization control
118  * functions, this simplifies the implementation of "user permissions".
119  */
120 contract Ownable {
121   address public owner;
122 
123 
124   event OwnershipRenounced(address indexed previousOwner);
125   event OwnershipTransferred(
126     address indexed previousOwner,
127     address indexed newOwner
128   );
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor() public {
136     owner = msg.sender;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to relinquish control of the contract.
149    * @notice Renouncing to ownership will leave the contract without an owner.
150    * It will not be possible to call the functions with the `onlyOwner`
151    * modifier anymore.
152    */
153   function renounceOwnership() public onlyOwner {
154     emit OwnershipRenounced(owner);
155     owner = address(0);
156   }
157 
158   /**
159    * @dev Allows the current owner to transfer control of the contract to a newOwner.
160    * @param _newOwner The address to transfer ownership to.
161    */
162   function transferOwnership(address _newOwner) public onlyOwner {
163     _transferOwnership(_newOwner);
164   }
165 
166   /**
167    * @dev Transfers control of the contract to a newOwner.
168    * @param _newOwner The address to transfer ownership to.
169    */
170   function _transferOwnership(address _newOwner) internal {
171     require(_newOwner != address(0));
172     emit OwnershipTransferred(owner, _newOwner);
173     owner = _newOwner;
174   }
175 }
176 
177 //==============================================================================
178 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
179 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
180 //====================================|=========================================
181 
182 contract modularLong is X3Devents {}
183 
184 contract X3Dlong is modularLong, Ownable {
185     using SafeMath for *;
186     using NameFilter for string;
187     using X3DKeysCalcLong for uint256;
188 	
189     
190 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x00E3A09444bC98686e34fc59E3bC517496E20B146a);
191 
192 
193 //==============================================================================
194 //     _ _  _  |`. _     _ _ |_ | _  _  .
195 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
196 //=================_|===========================================================
197     string constant public name = "X3D Long Official";
198     string constant public symbol = "X3D";
199 	uint256 private rndExtra_ = 0;     // length of the very first ICO 
200     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
201     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
202     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
203     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
204     
205 //==============================================================================
206 //     _| _ _|_ _    _ _ _|_    _   .
207 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
208 //=============================|================================================
209 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
210     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
211     uint256 public rID_;    // round id number / total rounds that have happened
212 
213     address private comBankAddr_;
214 //****************
215 // PLAYER DATA 
216 //****************
217     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
218     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
219     mapping (uint256 => X3Ddatasets.Player) public plyr_;   // (pID => data) player data
220     mapping (uint256 => mapping (uint256 => X3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
221     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
222 //****************
223 // ROUND DATA 
224 //****************
225     mapping (uint256 => X3Ddatasets.Round) public round_;   // (rID => data) round data
226     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
227 //****************
228 // TEAM FEE DATA 
229 //****************
230     mapping (uint256 => X3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
231     mapping (uint256 => X3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
232 //==============================================================================
233 //     _ _  _  __|_ _    __|_ _  _  .
234 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
235 //==============================================================================
236     constructor()
237         public
238     {
239         comBankAddr_ = address(0);
240 
241 		// Team allocation structures
242         // 0 = whales
243         // 1 = bears
244         // 2 = sneks
245         // 3 = bulls
246 
247 		// Team allocation percentages
248        
249         fees_[0] = X3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
250         fees_[1] = X3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
251         fees_[2] = X3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
252         fees_[3] = X3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
253         
254       
255         potSplit_[0] = X3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
256         potSplit_[1] = X3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
257         potSplit_[2] = X3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
258         potSplit_[3] = X3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
259 	}
260 //==============================================================================
261 //     _ _  _  _|. |`. _  _ _  .
262 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
263 //==============================================================================
264     /**
265      * @dev used to make sure no one can interact with contract until it has 
266      * been activated. 
267      */
268     modifier isActivated() {
269         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
270         _;
271     }
272     
273     /**
274      * @dev prevents contracts from interacting with x3d 
275      */
276     modifier isHuman() {
277         address _addr = msg.sender;
278         uint256 _codeLength;
279         
280         assembly {_codeLength := extcodesize(_addr)}
281         require(_codeLength == 0, "sorry humans only");
282         _;
283     }
284 
285     /**
286      * @dev sets boundaries for incoming tx 
287      */
288     modifier isWithinLimits(uint256 _eth) {
289         require(_eth >= 1000000000, "pocket lint: not a valid currency");
290         require(_eth <= 100000000000000000000000, "no vitalik, no");
291         _;    
292     }
293     
294 //==============================================================================
295 //     _    |_ |. _   |`    _  __|_. _  _  _  .
296 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
297 //====|=========================================================================
298     /**
299      * @dev emergency buy uses last stored affiliate ID and team snek
300      */
301     function()
302         isActivated()
303         isHuman()
304         isWithinLimits(msg.value)
305         public
306         payable
307     {
308         // set up our tx event data and determine if player is new or not
309         X3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
310             
311         // fetch player id
312         uint256 _pID = pIDxAddr_[msg.sender];
313         
314         // buy core 
315         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
316     }
317     
318     /**
319      * @dev converts all incoming ethereum to keys.
320      * -functionhash- 0x8f38f309 (using ID for affiliate)
321      * -functionhash- 0x98a0871d (using address for affiliate)
322      * -functionhash- 0xa65b37a1 (using name for affiliate)
323      * @param _affCode the ID/address/name of the player who gets the affiliate fee
324      * @param _team what team is the player playing for?
325      */
326     function buyXid(uint256 _affCode, uint256 _team)
327         isActivated()
328         isHuman()
329         isWithinLimits(msg.value)
330         public
331         payable
332     {
333         // set up our tx event data and determine if player is new or not
334         X3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
335         
336         // fetch player id
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
352         // verify a valid team was selected
353         _team = verifyTeam(_team);
354         
355         // buy core 
356         buyCore(_pID, _affCode, _team, _eventData_);
357     }
358     
359     function buyXaddr(address _affCode, uint256 _team)
360         isActivated()
361         isHuman()
362         isWithinLimits(msg.value)
363         public
364         payable
365     {
366         // set up our tx event data and determine if player is new or not
367         X3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
368         
369         // fetch player id
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
393         // verify a valid team was selected
394         _team = verifyTeam(_team);
395         
396         // buy core 
397         buyCore(_pID, _affID, _team, _eventData_);
398     }
399     
400     function buyXname(bytes32 _affCode, uint256 _team)
401         isActivated()
402         isHuman()
403         isWithinLimits(msg.value)
404         public
405         payable
406     {
407         // set up our tx event data and determine if player is new or not
408         X3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
409         
410         // fetch player id
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
434         // verify a valid team was selected
435         _team = verifyTeam(_team);
436         
437         // buy core 
438         buyCore(_pID, _affID, _team, _eventData_);
439     }
440     
441     /**
442      * @dev essentially the same as buy, but instead of you sending ether 
443      * from your wallet, it uses your unwithdrawn earnings.
444      * -functionhash- 0x349cdcac (using ID for affiliate)
445      * -functionhash- 0x82bfc739 (using address for affiliate)
446      * -functionhash- 0x079ce327 (using name for affiliate)
447      * @param _affCode the ID/address/name of the player who gets the affiliate fee
448      * @param _team what team is the player playing for?
449      * @param _eth amount of earnings to use (remainder returned to gen vault)
450      */
451     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
452         isActivated()
453         isHuman()
454         isWithinLimits(_eth)
455         public
456     {
457         // set up our tx event data
458         X3Ddatasets.EventReturns memory _eventData_;
459         
460         // fetch player ID
461         uint256 _pID = pIDxAddr_[msg.sender];
462         
463         // manage affiliate residuals
464         // if no affiliate code was given or player tried to use their own, lolz
465         if (_affCode == 0 || _affCode == _pID)
466         {
467             // use last stored affiliate code 
468             _affCode = plyr_[_pID].laff;
469             
470         // if affiliate code was given & its not the same as previously stored 
471         } else if (_affCode != plyr_[_pID].laff) {
472             // update last affiliate 
473             plyr_[_pID].laff = _affCode;
474         }
475 
476         // verify a valid team was selected
477         _team = verifyTeam(_team);
478 
479         // reload core
480         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
481     }
482     
483     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
484         isActivated()
485         isHuman()
486         isWithinLimits(_eth)
487         public
488     {
489         // set up our tx event data
490         X3Ddatasets.EventReturns memory _eventData_;
491         
492         // fetch player ID
493         uint256 _pID = pIDxAddr_[msg.sender];
494         
495         // manage affiliate residuals
496         uint256 _affID;
497         // if no affiliate code was given or player tried to use their own, lolz
498         if (_affCode == address(0) || _affCode == msg.sender)
499         {
500             // use last stored affiliate code
501             _affID = plyr_[_pID].laff;
502         
503         // if affiliate code was given    
504         } else {
505             // get affiliate ID from aff Code 
506             _affID = pIDxAddr_[_affCode];
507             
508             // if affID is not the same as previously stored 
509             if (_affID != plyr_[_pID].laff)
510             {
511                 // update last affiliate
512                 plyr_[_pID].laff = _affID;
513             }
514         }
515         
516         // verify a valid team was selected
517         _team = verifyTeam(_team);
518         
519         // reload core
520         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
521     }
522     
523     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
524         isActivated()
525         isHuman()
526         isWithinLimits(_eth)
527         public
528     {
529         // set up our tx event data
530         X3Ddatasets.EventReturns memory _eventData_;
531         
532         // fetch player ID
533         uint256 _pID = pIDxAddr_[msg.sender];
534         
535         // manage affiliate residuals
536         uint256 _affID;
537         // if no affiliate code was given or player tried to use their own, lolz
538         if (_affCode == '' || _affCode == plyr_[_pID].name)
539         {
540             // use last stored affiliate code
541             _affID = plyr_[_pID].laff;
542         
543         // if affiliate code was given
544         } else {
545             // get affiliate ID from aff Code
546             _affID = pIDxName_[_affCode];
547             
548             // if affID is not the same as previously stored
549             if (_affID != plyr_[_pID].laff)
550             {
551                 // update last affiliate
552                 plyr_[_pID].laff = _affID;
553             }
554         }
555         
556         // verify a valid team was selected
557         _team = verifyTeam(_team);
558         
559         // reload core
560         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
561     }
562 
563     /**
564      * @dev withdraws all of your earnings.
565      * -functionhash- 0x3ccfd60b
566      */
567     function withdraw()
568         isActivated()
569         isHuman()
570         public
571     {
572         // setup local rID 
573         uint256 _rID = rID_;
574         
575         // grab time
576         uint256 _now = now;
577         
578         // fetch player ID
579         uint256 _pID = pIDxAddr_[msg.sender];
580         
581         // setup temp var for player eth
582         uint256 _eth;
583         
584         // check to see if round has ended and no one has run round end yet
585         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
586         {
587             // set up our tx event data
588             X3Ddatasets.EventReturns memory _eventData_;
589             
590             // end the round (distributes pot)
591 			round_[_rID].ended = true;
592             _eventData_ = endRound(_eventData_);
593             
594 			// get their earnings
595             _eth = withdrawEarnings(_pID);
596             
597             // gib moni
598             if (_eth > 0)
599                 plyr_[_pID].addr.transfer(_eth);    
600             
601             // build event data
602             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
603             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
604             
605             // fire withdraw and distribute event
606             emit X3Devents.onWithdrawAndDistribute
607             (
608                 msg.sender, 
609                 plyr_[_pID].name, 
610                 _eth, 
611                 _eventData_.compressedData, 
612                 _eventData_.compressedIDs, 
613                 _eventData_.winnerAddr, 
614                 _eventData_.winnerName, 
615                 _eventData_.amountWon, 
616                 _eventData_.newPot, 
617                 _eventData_.XCOMAmount, 
618                 _eventData_.genAmount
619             );
620             
621         // in any other situation
622         } else {
623             // get their earnings
624             _eth = withdrawEarnings(_pID);
625             
626             // gib moni
627             if (_eth > 0)
628                 plyr_[_pID].addr.transfer(_eth);
629             
630             // fire withdraw event
631             emit X3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
632         }
633     }
634     
635     /**
636      * @dev use these to register names.  they are just wrappers that will send the
637      * registration requests to the PlayerBook contract.  So registering here is the 
638      * same as registering there.  UI will always display the last name you registered.
639      * but you will still own all previously registered names to use as affiliate 
640      * links.
641      * - must pay a registration fee.
642      * - name must be unique
643      * - names will be converted to lowercase
644      * - name cannot start or end with a space 
645      * - cannot have more than 1 space in a row
646      * - cannot be only numbers
647      * - cannot start with 0x 
648      * - name must be at least 1 char
649      * - max length of 32 characters long
650      * - allowed characters: a-z, 0-9, and space
651      * -functionhash- 0x921dec21 (using ID for affiliate)
652      * -functionhash- 0x3ddd4698 (using address for affiliate)
653      * -functionhash- 0x685ffd83 (using name for affiliate)
654      * @param _nameString players desired name
655      * @param _affCode affiliate ID, address, or name of who referred you
656      * @param _all set to true if you want this to push your info to all games 
657      * (this might cost a lot of gas)
658      */
659     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
660         isHuman()
661         public
662         payable
663     {
664         bytes32 _name = _nameString.nameFilter();
665         address _addr = msg.sender;
666         uint256 _paid = msg.value;
667         //(bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
668         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
669         uint256 _pID = pIDxAddr_[_addr];
670         
671         // fire event
672         emit X3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
673     }
674     
675     function registerNameXaddr(string _nameString, address _affCode, bool _all)
676         isHuman()
677         public
678         payable
679     {
680         bytes32 _name = _nameString.nameFilter();
681         address _addr = msg.sender;
682         uint256 _paid = msg.value;
683         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
684         
685         uint256 _pID = pIDxAddr_[_addr];
686         
687         // fire event
688         emit X3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
689     }
690     
691     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
692         isHuman()
693         public
694         payable
695     {
696         bytes32 _name = _nameString.nameFilter();
697         address _addr = msg.sender;
698         uint256 _paid = msg.value;
699         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
700         
701         uint256 _pID = pIDxAddr_[_addr];
702         
703         // fire event
704         emit X3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
705     }
706 //==============================================================================
707 //     _  _ _|__|_ _  _ _  .
708 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
709 //=====_|=======================================================================
710     /**
711      * @dev return the price buyer will pay for next 1 individual key.
712      * -functionhash- 0x018a25e8
713      * @return price for next key bought (in wei format)
714      */
715     function getBuyPrice()
716         public 
717         view 
718         returns(uint256)
719     {  
720         // setup local rID
721         uint256 _rID = rID_;
722         
723         // grab time
724         uint256 _now = now;
725         
726         // are we in a round?
727         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
728             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
729         else // rounds over.  need price for new round
730             return ( 75000000000000 ); // init
731     }
732     
733     /**
734      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
735      * provider
736      * -functionhash- 0xc7e284b8
737      * @return time left in seconds
738      */
739     function getTimeLeft()
740         public
741         view
742         returns(uint256)
743     {
744         // setup local rID
745         uint256 _rID = rID_;
746         
747         // grab time
748         uint256 _now = now;
749         
750         if (_now < round_[_rID].end)
751             if (_now > round_[_rID].strt + rndGap_)
752                 return( (round_[_rID].end).sub(_now) );
753             else
754                 return( (round_[_rID].strt + rndGap_).sub(_now) );
755         else
756             return(0);
757     }
758     
759     /**
760      * @dev returns player earnings per vaults 
761      * -functionhash- 0x63066434
762      * @return winnings vault
763      * @return general vault
764      * @return affiliate vault
765      */
766     function getPlayerVaults(uint256 _pID)
767         public
768         view
769         returns(uint256 ,uint256, uint256)
770     {
771         // setup local rID
772         uint256 _rID = rID_;
773         
774         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
775         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
776         {
777             // if player is winner 
778             if (round_[_rID].plyr == _pID)
779             {
780                 return
781                 (
782                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
783                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
784                     plyr_[_pID].aff
785                 );
786             // if player is not the winner
787             } else {
788                 return
789                 (
790                     plyr_[_pID].win,
791                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
792                     plyr_[_pID].aff
793                 );
794             }
795             
796         // if round is still going on, or round has ended and round end has been ran
797         } else {
798             return
799             (
800                 plyr_[_pID].win,
801                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
802                 plyr_[_pID].aff
803             );
804         }
805     }
806     
807     /**
808      * solidity hates stack limits.  this lets us avoid that hate 
809      */
810     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
811         private
812         view
813         returns(uint256)
814     {
815         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
816     }
817     
818     /**
819      * @dev returns all current round info needed for front end
820      * -functionhash- 0x747dff42
821      * @return eth invested during ICO phase
822      * @return round id 
823      * @return total keys for round 
824      * @return time round ends
825      * @return time round started
826      * @return current pot 
827      * @return current team ID & player ID in lead 
828      * @return current player in leads address 
829      * @return current player in leads name
830      * @return whales eth in for round
831      * @return bears eth in for round
832      * @return sneks eth in for round
833      * @return bulls eth in for round
834      * @return airdrop tracker # & airdrop pot
835      */
836     function getCurrentRoundInfo()
837         public
838         view
839         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
840     {
841         // setup local rID
842         uint256 _rID = rID_;
843         
844         return
845         (
846             round_[_rID].ico,               //0
847             _rID,                           //1
848             round_[_rID].keys,              //2
849             round_[_rID].end,               //3
850             round_[_rID].strt,              //4
851             round_[_rID].pot,               //5
852             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
853             plyr_[round_[_rID].plyr].addr,  //7
854             plyr_[round_[_rID].plyr].name,  //8
855             rndTmEth_[_rID][0],             //9
856             rndTmEth_[_rID][1],             //10
857             rndTmEth_[_rID][2],             //11
858             rndTmEth_[_rID][3],             //12
859             airDropTracker_ + (airDropPot_ * 1000)              //13
860         );
861     }
862 
863     /**
864      * @dev returns player info based on address.  if no address is given, it will 
865      * use msg.sender 
866      * -functionhash- 0xee0b5d8b
867      * @param _addr address of the player you want to lookup 
868      * @return player ID 
869      * @return player name
870      * @return keys owned (current round)
871      * @return winnings vault
872      * @return general vault 
873      * @return affiliate vault 
874 	 * @return player round eth
875      */
876     function getPlayerInfoByAddress(address _addr)
877         public 
878         view 
879         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
880     {
881         // setup local rID
882         uint256 _rID = rID_;
883         
884         if (_addr == address(0))
885         {
886             _addr == msg.sender;
887         }
888         uint256 _pID = pIDxAddr_[_addr];
889         
890         return
891         (
892             _pID,                               //0
893             plyr_[_pID].name,                   //1
894             plyrRnds_[_pID][_rID].keys,         //2
895             plyr_[_pID].win,                    //3
896             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
897             plyr_[_pID].aff,                    //5
898             plyrRnds_[_pID][_rID].eth           //6
899         );
900     }
901 
902 //==============================================================================
903 //     _ _  _ _   | _  _ . _  .
904 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
905 //=====================_|=======================================================
906     /**
907      * @dev logic runs whenever a buy order is executed.  determines how to handle 
908      * incoming eth depending on if we are in an active round or not
909      */
910     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, X3Ddatasets.EventReturns memory _eventData_)
911         private
912     {
913         // setup local rID
914         uint256 _rID = rID_;
915         
916         // grab time
917         uint256 _now = now;
918         
919         // if round is active
920         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
921         {
922             // call core 
923             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
924         
925         // if round is not active     
926         } else {
927             // check to see if end round needs to be ran
928             if (_now > round_[_rID].end && round_[_rID].ended == false) 
929             {
930                 // end the round (distributes pot) & start new round
931 			    round_[_rID].ended = true;
932                 _eventData_ = endRound(_eventData_);
933                 
934                 // build event data
935                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
936                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
937                 
938                 // fire buy and distribute event 
939                 emit X3Devents.onBuyAndDistribute
940                 (
941                     msg.sender, 
942                     plyr_[_pID].name, 
943                     msg.value, 
944                     _eventData_.compressedData, 
945                     _eventData_.compressedIDs, 
946                     _eventData_.winnerAddr, 
947                     _eventData_.winnerName, 
948                     _eventData_.amountWon, 
949                     _eventData_.newPot, 
950                     _eventData_.XCOMAmount, 
951                     _eventData_.genAmount
952                 );
953             }
954             
955             // put eth in players vault 
956             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
957         }
958     }
959     
960     /**
961      * @dev logic runs whenever a reload order is executed.  determines how to handle 
962      * incoming eth depending on if we are in an active round or not 
963      */
964     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, X3Ddatasets.EventReturns memory _eventData_)
965         private
966     {
967         // setup local rID
968         uint256 _rID = rID_;
969         
970         // grab time
971         uint256 _now = now;
972         
973         // if round is active
974         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
975         {
976             // get earnings from all vaults and return unused to gen vault
977             // because we use a custom safemath library.  this will throw if player 
978             // tried to spend more eth than they have.
979             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
980             
981             // call core 
982             core(_rID, _pID, _eth, _affID, _team, _eventData_);
983         
984         // if round is not active and end round needs to be ran   
985         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
986             // end the round (distributes pot) & start new round
987             round_[_rID].ended = true;
988             _eventData_ = endRound(_eventData_);
989                 
990             // build event data
991             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
992             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
993                 
994             // fire buy and distribute event 
995             emit X3Devents.onReLoadAndDistribute
996             (
997                 msg.sender, 
998                 plyr_[_pID].name, 
999                 _eventData_.compressedData, 
1000                 _eventData_.compressedIDs, 
1001                 _eventData_.winnerAddr, 
1002                 _eventData_.winnerName, 
1003                 _eventData_.amountWon, 
1004                 _eventData_.newPot, 
1005                 _eventData_.XCOMAmount, 
1006                 _eventData_.genAmount
1007             );
1008         }
1009     }
1010     
1011     /**
1012      * @dev this is the core logic for any buy/reload that happens while a round 
1013      * is live.
1014      */
1015     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, X3Ddatasets.EventReturns memory _eventData_)
1016         private
1017     {
1018         // if player is new to round
1019         if (plyrRnds_[_pID][_rID].keys == 0)
1020             _eventData_ = managePlayer(_pID, _eventData_);
1021         
1022         // early round eth limiter 
1023         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1024         {
1025             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1026             uint256 _refund = _eth.sub(_availableLimit);
1027             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1028             _eth = _availableLimit;
1029         }
1030         
1031         // if eth left is greater than min eth allowed (sorry no pocket lint)
1032         if (_eth > 1000000000) 
1033         {
1034             
1035             // mint the new keys
1036             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1037             
1038             // if they bought at least 1 whole key
1039             if (_keys >= 1000000000000000000)
1040             {
1041             updateTimer(_keys, _rID);
1042 
1043             // set new leaders
1044             if (round_[_rID].plyr != _pID)
1045                 round_[_rID].plyr = _pID;  
1046             if (round_[_rID].team != _team)
1047                 round_[_rID].team = _team; 
1048             
1049             // set the new leader bool to true
1050             _eventData_.compressedData = _eventData_.compressedData + 100;
1051         }
1052             
1053             // manage airdrops
1054             if (_eth >= 100000000000000000)
1055             {
1056             airDropTracker_++;
1057             if (airdrop() == true)
1058             {
1059                 // gib muni
1060                 uint256 _prize;
1061                 if (_eth >= 10000000000000000000)
1062                 {
1063                     // calculate prize and give it to winner
1064                     _prize = ((airDropPot_).mul(75)) / 100;
1065                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1066                     
1067                     // adjust airDropPot 
1068                     airDropPot_ = (airDropPot_).sub(_prize);
1069                     
1070                     // let event know a tier 3 prize was won 
1071                     _eventData_.compressedData += 300000000000000000000000000000000;
1072                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1073                     // calculate prize and give it to winner
1074                     _prize = ((airDropPot_).mul(50)) / 100;
1075                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1076                     
1077                     // adjust airDropPot 
1078                     airDropPot_ = (airDropPot_).sub(_prize);
1079                     
1080                     // let event know a tier 2 prize was won 
1081                     _eventData_.compressedData += 200000000000000000000000000000000;
1082                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1083                     // calculate prize and give it to winner
1084                     _prize = ((airDropPot_).mul(25)) / 100;
1085                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1086                     
1087                     // adjust airDropPot 
1088                     airDropPot_ = (airDropPot_).sub(_prize);
1089                     
1090                     // let event know a tier 3 prize was won 
1091                     _eventData_.compressedData += 300000000000000000000000000000000;
1092                 }
1093                 // set airdrop happened bool to true
1094                 _eventData_.compressedData += 10000000000000000000000000000000;
1095                 // let event know how much was won 
1096                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1097                 
1098                 // reset air drop tracker
1099                 airDropTracker_ = 0;
1100             }
1101         }
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
1116             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1117             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1118             
1119             // call end tx function to fire end tx event.
1120 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1121         }
1122     }
1123 //==============================================================================
1124 //     _ _ | _   | _ _|_ _  _ _  .
1125 //    (_(_||(_|_||(_| | (_)| _\  .
1126 //==============================================================================
1127     /**
1128      * @dev calculates unmasked earnings (just calculates, does not update mask)
1129      * @return earnings in wei format
1130      */
1131     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1132         private
1133         view
1134         returns(uint256)
1135     {
1136         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1137     }
1138     
1139     /** 
1140      * @dev returns the amount of keys you would get given an amount of eth. 
1141      * -functionhash- 0xce89c80c
1142      * @param _rID round ID you want price for
1143      * @param _eth amount of eth sent in 
1144      * @return keys received 
1145      */
1146     function calcKeysReceived(uint256 _rID, uint256 _eth)
1147         public
1148         view
1149         returns(uint256)
1150     {
1151         // grab time
1152         uint256 _now = now;
1153         
1154         // are we in a round?
1155         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1156             return ( (round_[_rID].eth).keysRec(_eth) );
1157         else // rounds over.  need keys for new round
1158             return ( (_eth).keys() );
1159     }
1160     
1161     /** 
1162      * @dev returns current eth price for X keys.  
1163      * -functionhash- 0xcf808000
1164      * @param _keys number of keys desired (in 18 decimal format)
1165      * @return amount of eth needed to send
1166      */
1167     function iWantXKeys(uint256 _keys)
1168         public
1169         view
1170         returns(uint256)
1171     {
1172         // setup local rID
1173         uint256 _rID = rID_;
1174         
1175         // grab time
1176         uint256 _now = now;
1177         
1178         // are we in a round?
1179         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1180             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1181         else // rounds over.  need price for new round
1182             return ( (_keys).eth() );
1183     }
1184 //==============================================================================
1185 //    _|_ _  _ | _  .
1186 //     | (_)(_)|_\  .
1187 //==============================================================================
1188     /**
1189 	 * @dev receives name/player info from names contract 
1190      */
1191     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1192         external
1193     {
1194         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1195         if (pIDxAddr_[_addr] != _pID)
1196             pIDxAddr_[_addr] = _pID;
1197         if (pIDxName_[_name] != _pID)
1198             pIDxName_[_name] = _pID;
1199         if (plyr_[_pID].addr != _addr)
1200             plyr_[_pID].addr = _addr;
1201         if (plyr_[_pID].name != _name)
1202             plyr_[_pID].name = _name;
1203         if (plyr_[_pID].laff != _laff)
1204             plyr_[_pID].laff = _laff;
1205         if (plyrNames_[_pID][_name] == false)
1206             plyrNames_[_pID][_name] = true;
1207     }
1208     
1209     /**
1210      * @dev receives entire player name list 
1211      */
1212     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1213         external
1214     {
1215         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1216         if(plyrNames_[_pID][_name] == false)
1217             plyrNames_[_pID][_name] = true;
1218     }   
1219         
1220     /**
1221      * @dev gets existing or registers new pID.  use this when a player may be new
1222      * @return pID 
1223      */
1224     function determinePID(X3Ddatasets.EventReturns memory _eventData_)
1225         private
1226         returns (X3Ddatasets.EventReturns)
1227     {
1228         uint256 _pID = pIDxAddr_[msg.sender];
1229         // if player is new to this version of x3d
1230         if (_pID == 0)
1231         {
1232             // grab their player ID, name and last aff ID, from player names contract 
1233             _pID = PlayerBook.getPlayerID(msg.sender);
1234             bytes32 _name = PlayerBook.getPlayerName(_pID);
1235             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1236             
1237             // set up player account 
1238             pIDxAddr_[msg.sender] = _pID;
1239             plyr_[_pID].addr = msg.sender;
1240             
1241             if (_name != "")
1242             {
1243                 pIDxName_[_name] = _pID;
1244                 plyr_[_pID].name = _name;
1245                 plyrNames_[_pID][_name] = true;
1246             }
1247             
1248             if (_laff != 0 && _laff != _pID)
1249                 plyr_[_pID].laff = _laff;
1250             
1251             // set the new player bool to true
1252             _eventData_.compressedData = _eventData_.compressedData + 1;
1253         } 
1254         return (_eventData_);
1255     }
1256     
1257     /**
1258      * @dev checks to make sure user picked a valid team.  if not sets team 
1259      * to default (sneks)
1260      */
1261     function verifyTeam(uint256 _team)
1262         private
1263         pure
1264         returns (uint256)
1265     {
1266         if (_team < 0 || _team > 3)
1267             return(2);
1268         else
1269             return(_team);
1270     }
1271     
1272     /**
1273      * @dev decides if round end needs to be run & new round started.  and if 
1274      * player unmasked earnings from previously played rounds need to be moved.
1275      */
1276     function managePlayer(uint256 _pID, X3Ddatasets.EventReturns memory _eventData_)
1277         private
1278         returns (X3Ddatasets.EventReturns)
1279     {
1280         // if player has played a previous round, move their unmasked earnings
1281         // from that round to gen vault.
1282         if (plyr_[_pID].lrnd != 0)
1283             updateGenVault(_pID, plyr_[_pID].lrnd);
1284             
1285         // update player's last round played
1286         plyr_[_pID].lrnd = rID_;
1287             
1288         // set the joined round bool to true
1289         _eventData_.compressedData = _eventData_.compressedData + 10;
1290         
1291         return(_eventData_);
1292     }
1293     
1294     /**
1295      * @dev ends the round. manages paying out winner/splitting up pot
1296      */
1297     function endRound(X3Ddatasets.EventReturns memory _eventData_)
1298         private
1299         returns (X3Ddatasets.EventReturns)
1300     {
1301         // setup local rID
1302         uint256 _rID = rID_;
1303         
1304         // grab our winning player and team id's
1305         uint256 _winPID = round_[_rID].plyr;
1306         uint256 _winTID = round_[_rID].team;
1307         
1308         // grab our pot amount
1309         uint256 _pot = round_[_rID].pot;
1310         
1311         // calculate our winner share, community rewards, gen share, 
1312         // XCOM share, and amount reserved for next pot 
1313         uint256 _win = (_pot.mul(48)) / 100;
1314         uint256 _com = (_pot / 50);
1315         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1316         uint256 _XCOM = (_pot.mul(potSplit_[_winTID].XCOM)) / 100;
1317         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_XCOM);
1318         
1319         // calculate ppt for round mask
1320         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1321         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1322         if (_dust > 0)
1323         {
1324             _gen = _gen.sub(_dust);
1325             _res = _res.add(_dust);
1326         }
1327         
1328         // pay our winner
1329         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1330         
1331         // community rewards
1332         _com = _com.add(_XCOM);
1333         comBankAddr_.transfer(_com);
1334         
1335         // distribute gen portion to key holders
1336         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1337         
1338             
1339         // prepare event data
1340         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1341         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1342         _eventData_.winnerAddr = plyr_[_winPID].addr;
1343         _eventData_.winnerName = plyr_[_winPID].name;
1344         _eventData_.amountWon = _win;
1345         _eventData_.genAmount = _gen;
1346         _eventData_.XCOMAmount = _XCOM;
1347         _eventData_.newPot = _res;
1348         
1349         // start next round
1350         rID_++;
1351         _rID++;
1352         round_[_rID].strt = now;
1353         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1354         round_[_rID].pot = _res;
1355         
1356         return(_eventData_);
1357     }
1358     
1359     /**
1360      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1361      */
1362     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1363         private 
1364     {
1365         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1366         if (_earnings > 0)
1367         {
1368             // put in gen vault
1369             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1370             // zero out their earnings by updating mask
1371             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
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
1398     /**
1399      * @dev generates a random number between 0-99 and checks to see if thats
1400      * resulted in an airdrop win
1401      * @return do we have a winner?
1402      */
1403     function airdrop()
1404         private 
1405         view 
1406         returns(bool)
1407     {
1408         uint256 seed = uint256(keccak256(abi.encodePacked(
1409             
1410             (block.timestamp).add
1411             (block.difficulty).add
1412             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1413             (block.gaslimit).add
1414             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1415             (block.number)
1416             
1417         )));
1418         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1419             return(true);
1420         else
1421             return(false);
1422     }
1423 
1424     /**
1425      * @dev distributes eth based on fees to com, aff, and XCOM
1426      */
1427     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, X3Ddatasets.EventReturns memory _eventData_)
1428         private
1429         returns(X3Ddatasets.EventReturns)
1430     {
1431         // pay 3% out to community rewards
1432 
1433         uint256 _p1 = _eth / 100;
1434         uint256 _com = _eth / 50;
1435         _com = _com.add(_p1);
1436 
1437         uint256 _XCOM;
1438         if (!address(comBankAddr_).call.value(_com)())
1439         {
1440             _XCOM = _com;
1441             _com = 0;
1442         }
1443         
1444     
1445         // distribute share to affiliate
1446         uint256 _aff = _eth / 10;
1447         
1448         // decide what to do with affiliate share of fees
1449         // affiliate must not be self, and must have a name registered
1450         if (_affID != _pID && plyr_[_affID].name != '') {
1451             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1452             emit X3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1453         } else {
1454            _XCOM = _XCOM.add(_aff);
1455         }
1456         
1457         // pay out XCOM
1458         _XCOM = _XCOM.add((_eth.mul(fees_[_team].XCOM)) / (100));
1459         if (_XCOM > 0)
1460         {
1461             comBankAddr_.transfer(_XCOM);
1462             
1463             // set up event data
1464             _eventData_.XCOMAmount = _XCOM.add(_eventData_.XCOMAmount);
1465         }
1466         
1467         return(_eventData_);
1468     }
1469     
1470     /**
1471      * @dev distributes eth based on fees to gen and pot
1472      */
1473     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, X3Ddatasets.EventReturns memory _eventData_)
1474         private
1475         returns(X3Ddatasets.EventReturns)
1476     {
1477         // calculate gen share
1478         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1479         
1480         // toss 1% into airdrop pot 
1481         uint256 _air = (_eth / 100);
1482         airDropPot_ = airDropPot_.add(_air);
1483         
1484         // update eth balance (eth = eth - (com share + pot swap share + aff share + XCOM share + airdrop pot share))
1485         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].XCOM)) / 100));
1486         
1487         // calculate pot 
1488         uint256 _pot = _eth.sub(_gen);
1489         
1490         // distribute gen share (thats what updateMasks() does) and adjust
1491         // balances for dust.
1492         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1493         if (_dust > 0)
1494             _gen = _gen.sub(_dust);
1495         
1496         // add eth to pot
1497         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1498         
1499         // set up event data
1500         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1501         _eventData_.potAmount = _pot;
1502         
1503         return(_eventData_);
1504     }
1505 
1506     /**
1507      * @dev updates masks for round and player when keys are bought
1508      * @return dust left over 
1509      */
1510     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1511         private
1512         returns(uint256)
1513     {
1514         /* MASKING NOTES
1515             earnings masks are a tricky thing for people to wrap their minds around.
1516             the basic thing to understand here.  is were going to have a global
1517             tracker based on profit per share for each round, that increases in
1518             relevant proportion to the increase in share supply.
1519             
1520             the player will have an additional mask that basically says "based
1521             on the rounds mask, my shares, and how much i've already withdrawn,
1522             how much is still owed to me?"
1523         */
1524         
1525         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1526         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1527         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1528             
1529         // calculate player earning from their own buy (only based on the keys
1530         // they just bought).  & update player earnings mask
1531         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1532         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1533         
1534         // calculate & return dust
1535         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1536     }
1537     
1538     /**
1539      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1540      * @return earnings in wei format
1541      */
1542     function withdrawEarnings(uint256 _pID)
1543         private
1544         returns(uint256)
1545     {
1546         // update gen vault
1547         updateGenVault(_pID, plyr_[_pID].lrnd);
1548         
1549         // from vaults 
1550         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1551         if (_earnings > 0)
1552         {
1553             plyr_[_pID].win = 0;
1554             plyr_[_pID].gen = 0;
1555             plyr_[_pID].aff = 0;
1556         }
1557 
1558         return(_earnings);
1559     }
1560     
1561     /**
1562      * @dev prepares compression data and fires event for buy or reload tx's
1563      */
1564     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, X3Ddatasets.EventReturns memory _eventData_)
1565         private
1566     {
1567         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1568         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1569         
1570         emit X3Devents.onEndTx
1571         (
1572             _eventData_.compressedData,
1573             _eventData_.compressedIDs,
1574             plyr_[_pID].name,
1575             msg.sender,
1576             _eth,
1577             _keys,
1578             _eventData_.winnerAddr,
1579             _eventData_.winnerName,
1580             _eventData_.amountWon,
1581             _eventData_.newPot,
1582             _eventData_.XCOMAmount,
1583             _eventData_.genAmount,
1584             _eventData_.potAmount,
1585             airDropPot_
1586         );
1587     }
1588 //==============================================================================
1589 //    (~ _  _    _._|_    .
1590 //    _)(/_(_|_|| | | \/  .
1591 //====================/=========================================================
1592     /** upon contract deploy, it will be deactivated.  this is a one time
1593      * use function that will activate the contract.  we do this so devs 
1594      * have time to set things up on the web end                            **/
1595     bool public activated_ = false;
1596     function activate()
1597         onlyOwner()
1598         public 
1599     {
1600 
1601         require(comBankAddr_ != address(0), "has not community adress bank yet");
1602         
1603         // can only be ran once
1604         require(activated_ == false, "x3d already activated");
1605         
1606         // activate the contract 
1607         activated_ = true;
1608         
1609         // lets start first round
1610 		rID_ = 1;
1611         round_[1].strt = now + rndExtra_ - rndGap_;
1612         round_[1].end = now + rndInit_ + rndExtra_;
1613     }
1614     
1615 
1616     function setup(address addr)
1617         external onlyOwner()
1618     {        
1619         comBankAddr_ = addr;
1620     }
1621 }
1622 
1623 //==============================================================================
1624 //   __|_ _    __|_ _  .
1625 //  _\ | | |_|(_ | _\  .
1626 //==============================================================================
1627 library X3Ddatasets {
1628     //compressedData key
1629     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1630         // 0 - new player (bool)
1631         // 1 - joined round (bool)
1632         // 2 - new  leader (bool)
1633         // 3-5 - air drop tracker (uint 0-999)
1634         // 6-16 - round end time
1635         // 17 - winnerTeam
1636         // 18 - 28 timestamp 
1637         // 29 - team
1638         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1639         // 31 - airdrop happened bool
1640         // 32 - airdrop tier 
1641         // 33 - airdrop amount won
1642     //compressedIDs key
1643     // [77-52][51-26][25-0]
1644         // 0-25 - pID 
1645         // 26-51 - winPID
1646         // 52-77 - rID
1647     struct EventReturns {
1648         uint256 compressedData;
1649         uint256 compressedIDs;
1650         address winnerAddr;         // winner address
1651         bytes32 winnerName;         // winner name
1652         uint256 amountWon;          // amount won
1653         uint256 newPot;             // amount in new pot
1654         uint256 XCOMAmount;          // amount distributed to XCOM
1655         uint256 genAmount;          // amount distributed to gen
1656         uint256 potAmount;          // amount added to pot
1657     }
1658     struct Player {
1659         address addr;   // player address
1660         bytes32 name;   // player name
1661         uint256 win;    // winnings vault
1662         uint256 gen;    // general vault
1663         uint256 aff;    // affiliate vault
1664         uint256 lrnd;   // last round played
1665         uint256 laff;   // last affiliate id used
1666     }
1667     struct PlayerRounds {
1668         uint256 eth;    // eth player has added to round (used for eth limiter)
1669         uint256 keys;   // keys
1670         uint256 mask;   // player mask 
1671         uint256 ico;    // ICO phase investment
1672     }
1673     struct Round {
1674         uint256 plyr;   // pID of player in lead
1675         uint256 team;   // tID of team in lead
1676         uint256 end;    // time ends/ended
1677         bool ended;     // has round end function been ran
1678         uint256 strt;   // time round started
1679         uint256 keys;   // keys
1680         uint256 eth;    // total eth in
1681         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1682         uint256 mask;   // global mask
1683         uint256 ico;    // total eth sent in during ICO phase
1684         uint256 icoGen; // total eth for gen during ICO phase
1685         uint256 icoAvg; // average key price for ICO phase
1686     }
1687     struct TeamFee {
1688         uint256 gen;    // % of buy in thats paid to key holders of current round
1689         uint256 XCOM;    // % of buy in thats paid to XCOM holders
1690     }
1691     struct PotSplit {
1692         uint256 gen;    // % of pot thats paid to key holders of current round
1693         uint256 XCOM;    // % of pot thats paid to XCOM holders
1694     }
1695 }
1696 
1697 //==============================================================================
1698 //  |  _      _ _ | _  .
1699 //  |<(/_\/  (_(_||(_  .
1700 //=======/======================================================================
1701 library X3DKeysCalcLong {
1702     using SafeMath for *;
1703     /**
1704      * @dev calculates number of keys received given X eth 
1705      * @param _curEth current amount of eth in contract 
1706      * @param _newEth eth being spent
1707      * @return amount of ticket purchased
1708      */
1709     function keysRec(uint256 _curEth, uint256 _newEth)
1710         internal
1711         pure
1712         returns (uint256)
1713     {
1714         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1715     }
1716     
1717     /**
1718      * @dev calculates amount of eth received if you sold X keys 
1719      * @param _curKeys current amount of keys that exist 
1720      * @param _sellKeys amount of keys you wish to sell
1721      * @return amount of eth received
1722      */
1723     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1724         internal
1725         pure
1726         returns (uint256)
1727     {
1728         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1729     }
1730 
1731     /**
1732      * @dev calculates how many keys would exist with given an amount of eth
1733      * @param _eth eth "in contract"
1734      * @return number of keys that would exist
1735      */
1736     function keys(uint256 _eth) 
1737         internal
1738         pure
1739         returns(uint256)
1740     {
1741         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1742     }
1743     
1744     /**
1745      * @dev calculates how much eth would be in contract given a number of keys
1746      * @param _keys number of keys "in contract" 
1747      * @return eth that would exists
1748      */
1749     function eth(uint256 _keys) 
1750         internal
1751         pure
1752         returns(uint256)  
1753     {
1754         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1755     }
1756 }
1757 
1758 //==============================================================================
1759 //  . _ _|_ _  _ |` _  _ _  _  .
1760 //  || | | (/_| ~|~(_|(_(/__\  .
1761 //==============================================================================
1762 
1763 interface PlayerBookInterface {
1764     function getPlayerID(address _addr) external returns (uint256);
1765     function getPlayerName(uint256 _pID) external view returns (bytes32);
1766     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1767     function getPlayerAddr(uint256 _pID) external view returns (address);
1768     function getNameFee() external view returns (uint256);
1769     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1770     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1771     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1772 }
1773 
1774 
1775 library NameFilter {
1776     /**
1777      * @dev filters name strings
1778      * -converts uppercase to lower case.  
1779      * -makes sure it does not start/end with a space
1780      * -makes sure it does not contain multiple spaces in a row
1781      * -cannot be only numbers
1782      * -cannot start with 0x 
1783      * -restricts characters to A-Z, a-z, 0-9, and space.
1784      * @return reprocessed string in bytes32 format
1785      */
1786     function nameFilter(string _input)
1787         internal
1788         pure
1789         returns(bytes32)
1790     {
1791         bytes memory _temp = bytes(_input);
1792         uint256 _length = _temp.length;
1793         
1794         //sorry limited to 32 characters
1795         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1796         // make sure it doesnt start with or end with space
1797         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1798         // make sure first two characters are not 0x
1799         if (_temp[0] == 0x30)
1800         {
1801             require(_temp[1] != 0x78, "string cannot start with 0x");
1802             require(_temp[1] != 0x58, "string cannot start with 0X");
1803         }
1804         
1805         // create a bool to track if we have a non number character
1806         bool _hasNonNumber;
1807         
1808         // convert & check
1809         for (uint256 i = 0; i < _length; i++)
1810         {
1811             // if its uppercase A-Z
1812             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1813             {
1814                 // convert to lower case a-z
1815                 _temp[i] = byte(uint(_temp[i]) + 32);
1816                 
1817                 // we have a non number
1818                 if (_hasNonNumber == false)
1819                     _hasNonNumber = true;
1820             } else {
1821                 require
1822                 (
1823                     // require character is a space
1824                     _temp[i] == 0x20 || 
1825                     // OR lowercase a-z
1826                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1827                     // or 0-9
1828                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1829                     "string contains invalid characters"
1830                 );
1831                 // make sure theres not 2x spaces in a row
1832                 if (_temp[i] == 0x20)
1833                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1834                 
1835                 // see if we have a character other than a number
1836                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1837                     _hasNonNumber = true;    
1838             }
1839         }
1840         
1841         require(_hasNonNumber == true, "string cannot be only numbers");
1842         
1843         bytes32 _ret;
1844         assembly {
1845             _ret := mload(add(_temp, 32))
1846         }
1847         return (_ret);
1848     }
1849 }
1850 
1851 /**
1852  * @title SafeMath v0.1.9
1853  * @dev Math operations with safety checks that throw on error
1854  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1855  * - added sqrt
1856  * - added sq
1857  * - added pwr 
1858  * - changed asserts to requires with error log outputs
1859  * - removed div, its useless
1860  */
1861 library SafeMath {
1862     
1863     /**
1864     * @dev Multiplies two numbers, throws on overflow.
1865     */
1866     function mul(uint256 a, uint256 b) 
1867         internal 
1868         pure 
1869         returns (uint256 c) 
1870     {
1871         if (a == 0) {
1872             return 0;
1873         }
1874         c = a * b;
1875         require(c / a == b, "SafeMath mul failed");
1876         return c;
1877     }
1878 
1879     /**
1880     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1881     */
1882     function sub(uint256 a, uint256 b)
1883         internal
1884         pure
1885         returns (uint256) 
1886     {
1887         require(b <= a, "SafeMath sub failed");
1888         return a - b;
1889     }
1890 
1891     /**
1892     * @dev Adds two numbers, throws on overflow.
1893     */
1894     function add(uint256 a, uint256 b)
1895         internal
1896         pure
1897         returns (uint256 c) 
1898     {
1899         c = a + b;
1900         require(c >= a, "SafeMath add failed");
1901         return c;
1902     }
1903     
1904     /**
1905      * @dev gives square root of given x.
1906      */
1907     function sqrt(uint256 x)
1908         internal
1909         pure
1910         returns (uint256 y) 
1911     {
1912         uint256 z = ((add(x,1)) / 2);
1913         y = x;
1914         while (z < y) 
1915         {
1916             y = z;
1917             z = ((add((x / z),z)) / 2);
1918         }
1919     }
1920     
1921     /**
1922      * @dev gives square. multiplies x by x
1923      */
1924     function sq(uint256 x)
1925         internal
1926         pure
1927         returns (uint256)
1928     {
1929         return (mul(x,x));
1930     }
1931     
1932     /**
1933      * @dev x to the power of y 
1934      */
1935     function pwr(uint256 x, uint256 y)
1936         internal 
1937         pure 
1938         returns (uint256)
1939     {
1940         if (x==0)
1941             return (0);
1942         else if (y==0)
1943             return (1);
1944         else 
1945         {
1946             uint256 z = x;
1947             for (uint256 i=1; i < y; i++)
1948                 z = mul(z,x);
1949             return (z);
1950         }
1951     }
1952 }