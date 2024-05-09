1 pragma solidity ^0.4.24;
2 
3 // _____.___.              __   .__.__     _____             .___.__  _____.__           .___
4 // \__  |   | ____   ____ |  | _|__|__|   /     \   ____   __| _/|__|/ ____\__| ____   __| _/
5 //  /   |   |/  _ \_/ ___\|  |/ /  |  |  /  \ /  \ /  _ \ / __ | |  \   __\|  |/ __ \ / __ | 
6 //  \____   (  <_> )  \___|    <|  |  | /    Y    (  <_> ) /_/ | |  ||  |  |  \  ___// /_/ | 
7 //  / ______|\____/ \___  >__|_ \__|__| \____|__  /\____/\____ | |__||__|  |__|\___  >____ | 
8 //  \/                  \/     \/               \/            \/                   \/     \/ 
9 // Team Just Copyright Received.
10 // yocki17@gmail.com modified
11 //==============================================================================
12 //     _    _  _ _|_ _  .
13 //    (/_\/(/_| | | _\  .
14 //==============================================================================
15 contract F3Devents {
16     // fired whenever a player registers a name
17     event onNewName
18     (
19         uint256 indexed playerID,
20         address indexed playerAddress,
21         bytes32 indexed playerName,
22         bool isNewPlayer,
23         uint256 affiliateID,
24         address affiliateAddress,
25         bytes32 affiliateName,
26         uint256 amountPaid,
27         uint256 timeStamp
28     );
29     
30     // fired at end of buy or reload
31     event onEndTx
32     (
33         uint256 compressedData,     
34         uint256 compressedIDs,      
35         bytes32 playerName,
36         address playerAddress,
37         uint256 ethIn,
38         uint256 keysBought,
39         address winnerAddr,
40         bytes32 winnerName,
41         uint256 amountWon,
42         uint256 newPot,
43         uint256 P3DAmount,
44         uint256 genAmount,
45         uint256 potAmount,
46         uint256 airDropPot
47     );
48     
49 	// fired whenever theres a withdraw
50     event onWithdraw
51     (
52         uint256 indexed playerID,
53         address playerAddress,
54         bytes32 playerName,
55         uint256 ethOut,
56         uint256 timeStamp
57     );
58     
59     // fired whenever a withdraw forces end round to be ran
60     event onWithdrawAndDistribute
61     (
62         address playerAddress,
63         bytes32 playerName,
64         uint256 ethOut,
65         uint256 compressedData,
66         uint256 compressedIDs,
67         address winnerAddr,
68         bytes32 winnerName,
69         uint256 amountWon,
70         uint256 newPot,
71         uint256 P3DAmount,
72         uint256 genAmount
73     );
74     
75     // (fomo3d long only) fired whenever a player tries a buy after round timer 
76     // hit zero, and causes end round to be ran.
77     event onBuyAndDistribute
78     (
79         address playerAddress,
80         bytes32 playerName,
81         uint256 ethIn,
82         uint256 compressedData,
83         uint256 compressedIDs,
84         address winnerAddr,
85         bytes32 winnerName,
86         uint256 amountWon,
87         uint256 newPot,
88         uint256 P3DAmount,
89         uint256 genAmount
90     );
91     
92     // (fomo3d long only) fired whenever a player tries a reload after round timer 
93     // hit zero, and causes end round to be ran.
94     event onReLoadAndDistribute
95     (
96         address playerAddress,
97         bytes32 playerName,
98         uint256 compressedData,
99         uint256 compressedIDs,
100         address winnerAddr,
101         bytes32 winnerName,
102         uint256 amountWon,
103         uint256 newPot,
104         uint256 P3DAmount,
105         uint256 genAmount
106     );
107     
108     // fired whenever an affiliate is paid
109     event onAffiliatePayout
110     (
111         uint256 indexed affiliateID,
112         address affiliateAddress,
113         bytes32 affiliateName,
114         uint256 indexed roundID,
115         uint256 indexed buyerID,
116         uint256 amount,
117         uint256 timeStamp
118     );
119     
120     // received pot swap deposit
121     event onPotSwapDeposit
122     (
123         uint256 roundID,
124         uint256 amountAddedToPot
125     );
126 }
127 
128 //==============================================================================
129 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
130 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
131 //====================================|=========================================
132 
133 contract modularLong is F3Devents {}
134 
135 contract EthKillerLong is modularLong {
136     using SafeMath for *;
137     using NameFilter for string;
138     using F3DKeysCalcLong for uint256;
139 
140     address public teamAddress = 0xc2daaf4e63af76b394dea9a98a1fa650fc626b91;
141 
142     function setTeamAddress(address addr) isOwner() public {
143         teamAddress = addr;
144     }
145     function gameSettings(uint256 rndExtra, uint256 rndGap) isOwner() public {
146         rndExtra_ = rndExtra;
147         rndGap_ = rndGap;
148     }
149 //==============================================================================
150 //     _ _  _  |`. _     _ _ |_ | _  _  .
151 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
152 //=================_|===========================================================
153     string constant public name = "Eth Killer Long Official";
154     string constant public symbol = "EKL";
155     uint256 private rndExtra_ = 0;     // length of the very first ICO 
156     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
157     uint256 constant private rndInit_ = 12 hours;                // round timer starts at this
158     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
159     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
160 //==============================================================================
161 //     _| _ _|_ _    _ _ _|_    _   .
162 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
163 //=============================|================================================
164     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
165     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
166     uint256 public rID_;    // round id number / total rounds that have happened
167     uint256 public registrationFee_ = 10 finney;            // price to register a name
168 //****************
169 // PLAYER DATA 
170 //****************
171     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
172     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
173     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
174     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
175     // mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
176     uint256 private playerCount = 0;
177     uint256 private totalWinnersKeys_;
178     uint256 constant private winnerNum_ = 5; // sync change in structure Round.plyrs
179 
180     ///////////// playerbook  ///////////
181     function registerName(address _addr, bytes32 _name, uint256 _affCode) private returns(bool, uint256) {
182         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
183         require(pIDxName_[_name] == 0, "sorry that names already taken");
184 
185         uint256 _pID = pIDxAddr_[_addr];
186         bool isNew = false;
187         if (_pID == 0) {
188             isNew = true;
189             playerCount++;
190             _pID = playerCount;
191             pIDxAddr_[_addr] = _pID;
192             plyr_[_pID].name = _name;
193             pIDxName_[_name] = _pID;
194         }
195         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) {
196             plyr_[_pID].laff = _affCode;
197         } else if (_affCode == _pID) {
198             _affCode = 0;
199         }
200         return (isNew, _affCode);
201     }
202     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode) private returns(bool, uint256) {
203         uint256 _affID = 0;
204         if (_affCode != address(0) && _affCode != _addr) {
205             _affID = pIDxAddr_[_affCode];
206         }
207         return registerName(_addr, _name, _affID);
208     }
209     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode) private returns(bool, uint256) {
210         uint256 _affID = 0;
211         if (_affCode != "" && _affCode != _name) {
212             _affID = pIDxName_[_affCode];
213         }
214         return registerName(_addr, _name, _affID);
215     }
216 //****************
217 // ROUND DATA 
218 //****************
219     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
220     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
221 //****************
222 // TEAM FEE DATA 
223 //****************
224     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
225     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
226 //==============================================================================
227 //     _ _  _  __|_ _    __|_ _  _  .
228 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
229 //==============================================================================
230     address owner;
231     constructor()
232         public
233     {
234         owner = msg.sender;
235 		// Team allocation structures
236         // 0 = whales
237         // 1 = bears
238         // 2 = sneks
239         // 3 = bulls
240 
241 		// Team allocation percentages
242         fees_[0] = F3Ddatasets.TeamFee(30,12);
243         fees_[1] = F3Ddatasets.TeamFee(43,7);
244         fees_[2] = F3Ddatasets.TeamFee(52,16);
245         fees_[3] = F3Ddatasets.TeamFee(43,15);
246         
247         // how to split up the final pot based on which team was picked
248         potSplit_[0] = F3Ddatasets.PotSplit(15,15);
249         potSplit_[1] = F3Ddatasets.PotSplit(25,10);
250         potSplit_[2] = F3Ddatasets.PotSplit(20,24);
251         potSplit_[3] = F3Ddatasets.PotSplit(30,14);
252     }
253 //==============================================================================
254 //     _ _  _  _|. |`. _  _ _  .
255 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
256 //==============================================================================
257     /**
258      * @dev used to make sure no one can interact with contract until it has 
259      * been activated. 
260      */
261     modifier isActivated() {
262         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
263         _;
264     }
265     
266     modifier isOwner() {
267         require(owner == msg.sender, "sorry owner only");
268         _;
269     }
270 
271     /**
272      * @dev prevents contracts from interacting with fomo3d 
273      */
274     modifier isHuman() {
275         address _addr = msg.sender;
276         uint256 _codeLength;
277         
278         assembly {_codeLength := extcodesize(_addr)}
279         require(_codeLength == 0, "sorry humans only");
280         _;
281     }
282 
283     /**
284      * @dev sets boundaries for incoming tx 
285      */
286     modifier isWithinLimits(uint256 _eth) {
287         require(_eth >= 1000000000, "pocket lint: not a valid currency");
288         require(_eth <= 100000000000000000000000, "no vitalik, no");
289         _;    
290     }
291     
292 //==============================================================================
293 //     _    |_ |. _   |`    _  __|_. _  _  _  .
294 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
295 //====|=========================================================================
296     /**
297      * @dev emergency buy uses last stored affiliate ID and team snek
298      */
299     function()
300         isActivated()
301         isHuman()
302         isWithinLimits(msg.value)
303         public
304         payable
305     {
306         // set up our tx event data and determine if player is new or not
307         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
308             
309         // fetch player id
310         uint256 _pID = pIDxAddr_[msg.sender];
311         
312         // buy core 
313         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
314     }
315 
316     function updateContract(address newContract) isOwner() public returns (bool) {
317         if (round_[rID_].end < now) {
318             Fomo3dContract nc = Fomo3dContract(newContract);
319             newContract.transfer(address(this).balance);
320             nc.setOldContractData(address(this));
321             return (true);
322         }
323         return (false);
324     }
325     
326     /**
327      * @dev converts all incoming ethereum to keys.
328      * -functionhash- 0x8f38f309 (using ID for affiliate)
329      * -functionhash- 0x98a0871d (using address for affiliate)
330      * -functionhash- 0xa65b37a1 (using name for affiliate)
331      * @param _affCode the ID/address/name of the player who gets the affiliate fee
332      * @param _team what team is the player playing for?
333      */
334     function buyXid(uint256 _affCode, uint256 _team)
335         isActivated()
336         isHuman()
337         isWithinLimits(msg.value)
338         public
339         payable
340     {
341         // set up our tx event data and determine if player is new or not
342         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
343         
344         // fetch player id
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
360         // verify a valid team was selected
361         _team = verifyTeam(_team);
362         
363         // buy core 
364         buyCore(_pID, _affCode, _team, _eventData_);
365     }
366     
367     function buyXaddr(address _affCode, uint256 _team)
368         isActivated()
369         isHuman()
370         isWithinLimits(msg.value)
371         public
372         payable
373     {
374         // set up our tx event data and determine if player is new or not
375         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
376         
377         // fetch player id
378         uint256 _pID = pIDxAddr_[msg.sender];
379         
380         // manage affiliate residuals
381         uint256 _affID;
382         // if no affiliate code was given or player tried to use their own, lolz
383         if (_affCode == address(0) || _affCode == msg.sender)
384         {
385             // use last stored affiliate code
386             _affID = plyr_[_pID].laff;
387         
388         // if affiliate code was given    
389         } else {
390             // get affiliate ID from aff Code 
391             _affID = pIDxAddr_[_affCode];
392             
393             // if affID is not the same as previously stored 
394             if (_affID != plyr_[_pID].laff)
395             {
396                 // update last affiliate
397                 plyr_[_pID].laff = _affID;
398             }
399         }
400         
401         // verify a valid team was selected
402         _team = verifyTeam(_team);
403         
404         // buy core 
405         buyCore(_pID, _affID, _team, _eventData_);
406     }
407     
408     function buyXname(bytes32 _affCode, uint256 _team)
409         isActivated()
410         isHuman()
411         isWithinLimits(msg.value)
412         public
413         payable
414     {
415         // set up our tx event data and determine if player is new or not
416         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
417         
418         // fetch player id
419         uint256 _pID = pIDxAddr_[msg.sender];
420         
421         // manage affiliate residuals
422         uint256 _affID;
423         // if no affiliate code was given or player tried to use their own, lolz
424         if (_affCode == "" || _affCode == plyr_[_pID].name)
425         {
426             // use last stored affiliate code
427             _affID = plyr_[_pID].laff;
428         
429         // if affiliate code was given
430         } else {
431             // get affiliate ID from aff Code
432             _affID = pIDxName_[_affCode];
433             
434             // if affID is not the same as previously stored
435             if (_affID != plyr_[_pID].laff)
436             {
437                 // update last affiliate
438                 plyr_[_pID].laff = _affID;
439             }
440         }
441         
442         // verify a valid team was selected
443         _team = verifyTeam(_team);
444         
445         // buy core 
446         buyCore(_pID, _affID, _team, _eventData_);
447     }
448     
449     /**
450      * @dev essentially the same as buy, but instead of you sending ether 
451      * from your wallet, it uses your unwithdrawn earnings.
452      * -functionhash- 0x349cdcac (using ID for affiliate)
453      * -functionhash- 0x82bfc739 (using address for affiliate)
454      * -functionhash- 0x079ce327 (using name for affiliate)
455      * @param _affCode the ID/address/name of the player who gets the affiliate fee
456      * @param _team what team is the player playing for?
457      * @param _eth amount of earnings to use (remainder returned to gen vault)
458      */
459     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
460         isActivated()
461         isHuman()
462         isWithinLimits(_eth)
463         public
464     {
465         // set up our tx event data
466         F3Ddatasets.EventReturns memory _eventData_;
467         
468         // fetch player ID
469         uint256 _pID = pIDxAddr_[msg.sender];
470         
471         // manage affiliate residuals
472         // if no affiliate code was given or player tried to use their own, lolz
473         if (_affCode == 0 || _affCode == _pID)
474         {
475             // use last stored affiliate code 
476             _affCode = plyr_[_pID].laff;
477             
478         // if affiliate code was given & its not the same as previously stored 
479         } else if (_affCode != plyr_[_pID].laff) {
480             // update last affiliate 
481             plyr_[_pID].laff = _affCode;
482         }
483 
484         // verify a valid team was selected
485         _team = verifyTeam(_team);
486 
487         // reload core
488         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
489     }
490     
491     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
492         isActivated()
493         isHuman()
494         isWithinLimits(_eth)
495         public
496     {
497         // set up our tx event data
498         F3Ddatasets.EventReturns memory _eventData_;
499         
500         // fetch player ID
501         uint256 _pID = pIDxAddr_[msg.sender];
502         
503         // manage affiliate residuals
504         uint256 _affID;
505         // if no affiliate code was given or player tried to use their own, lolz
506         if (_affCode == address(0) || _affCode == msg.sender)
507         {
508             // use last stored affiliate code
509             _affID = plyr_[_pID].laff;
510         
511         // if affiliate code was given    
512         } else {
513             // get affiliate ID from aff Code 
514             _affID = pIDxAddr_[_affCode];
515             
516             // if affID is not the same as previously stored 
517             if (_affID != plyr_[_pID].laff)
518             {
519                 // update last affiliate
520                 plyr_[_pID].laff = _affID;
521             }
522         }
523         
524         // verify a valid team was selected
525         _team = verifyTeam(_team);
526         
527         // reload core
528         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
529     }
530     
531     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
532         isActivated()
533         isHuman()
534         isWithinLimits(_eth)
535         public
536     {
537         // set up our tx event data
538         F3Ddatasets.EventReturns memory _eventData_;
539         
540         // fetch player ID
541         uint256 _pID = pIDxAddr_[msg.sender];
542         
543         // manage affiliate residuals
544         uint256 _affID;
545         // if no affiliate code was given or player tried to use their own, lolz
546         if (_affCode == "" || _affCode == plyr_[_pID].name)
547         {
548             // use last stored affiliate code
549             _affID = plyr_[_pID].laff;
550         
551         // if affiliate code was given
552         } else {
553             // get affiliate ID from aff Code
554             _affID = pIDxName_[_affCode];
555             
556             // if affID is not the same as previously stored
557             if (_affID != plyr_[_pID].laff)
558             {
559                 // update last affiliate
560                 plyr_[_pID].laff = _affID;
561             }
562         }
563         
564         // verify a valid team was selected
565         _team = verifyTeam(_team);
566         
567         // reload core
568         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
569     }
570 
571     /**
572      * @dev withdraws all of your earnings.
573      * -functionhash- 0x3ccfd60b
574      */
575     function withdraw()
576         isActivated()
577         isHuman()
578         public
579     {
580         // setup local rID 
581         uint256 _rID = rID_;
582         
583         // grab time
584         uint256 _now = now;
585         
586         // fetch player ID
587         uint256 _pID = pIDxAddr_[msg.sender];
588         
589         // setup temp var for player eth
590         uint256 _eth;
591         
592         // check to see if round has ended and no one has run round end yet
593         if (_now > round_[_rID].end && round_[_rID].ended == false && hasPlayersInRound(_rID) == true)
594         {
595             // set up our tx event data
596             F3Ddatasets.EventReturns memory _eventData_;
597             
598             // end the round (distributes pot)
599             round_[_rID].ended = true;
600             _eventData_ = endRound(_eventData_);
601             
602 			// get their earnings
603             _eth = withdrawEarnings(_pID);
604             
605             // gib moni
606             if (_eth > 0)
607                 plyr_[_pID].addr.transfer(_eth);    
608             
609             // build event data
610             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
611             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
612             
613             // fire withdraw and distribute event
614             emit F3Devents.onWithdrawAndDistribute
615             (
616                 msg.sender, 
617                 plyr_[_pID].name, 
618                 _eth, 
619                 _eventData_.compressedData, 
620                 _eventData_.compressedIDs, 
621                 _eventData_.winnerAddr, 
622                 _eventData_.winnerName, 
623                 _eventData_.amountWon, 
624                 _eventData_.newPot, 
625                 _eventData_.P3DAmount, 
626                 _eventData_.genAmount
627             );
628             
629         // in any other situation
630         } else {
631             // get their earnings
632             _eth = withdrawEarnings(_pID);
633             
634             // gib moni
635             if (_eth > 0)
636                 plyr_[_pID].addr.transfer(_eth);
637             
638             // fire withdraw event
639             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
640         }
641     }
642     
643     /**
644      * @dev use these to register names.  they are just wrappers that will send the
645      * registration requests to the PlayerBook contract.  So registering here is the 
646      * same as registering there.  UI will always display the last name you registered.
647      * but you will still own all previously registered names to use as affiliate 
648      * links.
649      * - must pay a registration fee.
650      * - name must be unique
651      * - names will be converted to lowercase
652      * - name cannot start or end with a space 
653      * - cannot have more than 1 space in a row
654      * - cannot be only numbers
655      * - cannot start with 0x 
656      * - name must be at least 1 char
657      * - max length of 32 characters long
658      * - allowed characters: a-z, 0-9, and space
659      * -functionhash- 0x921dec21 (using ID for affiliate)
660      * -functionhash- 0x3ddd4698 (using address for affiliate)
661      * -functionhash- 0x685ffd83 (using name for affiliate)
662      * @param _nameString players desired name
663      * @param _affCode affiliate ID, address, or name of who referred you
664      * (this might cost a lot of gas)
665      */
666     function registerNameXID(string _nameString, uint256 _affCode)
667         isHuman()
668         public
669         payable
670     {
671         bytes32 _name = _nameString.nameFilter();
672         address _addr = msg.sender;
673         uint256 _paid = msg.value;
674         (bool _isNewPlayer, uint256 _affID) = registerName(_addr, _name, _affCode);
675         
676         uint256 _pID = pIDxAddr_[_addr];
677         
678         // fire event
679         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
680     }
681     
682     function registerNameXaddr(string _nameString, address _affCode)
683         isHuman()
684         public
685         payable
686     {
687         bytes32 _name = _nameString.nameFilter();
688         address _addr = msg.sender;
689         uint256 _paid = msg.value;
690         (bool _isNewPlayer, uint256 _affID) = registerNameXaddrFromDapp(msg.sender, _name, _affCode);
691         
692         uint256 _pID = pIDxAddr_[_addr];
693         
694         // fire event
695         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
696     }
697     
698     function registerNameXname(string _nameString, bytes32 _affCode)
699         isHuman()
700         public
701         payable
702     {
703         bytes32 _name = _nameString.nameFilter();
704         address _addr = msg.sender;
705         uint256 _paid = msg.value;
706         (bool _isNewPlayer, uint256 _affID) = registerNameXnameFromDapp(msg.sender, _name, _affCode);
707         
708         uint256 _pID = pIDxAddr_[_addr];
709         
710         // fire event
711         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
712     }
713 //==============================================================================
714 //     _  _ _|__|_ _  _ _  .
715 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
716 //=====_|=======================================================================
717     /**
718      * @dev return the price buyer will pay for next 1 individual key.
719      * -functionhash- 0x018a25e8
720      * @return price for next key bought (in wei format)
721      */
722     function getBuyPrice()
723         public 
724         view 
725         returns(uint256)
726     {  
727         // setup local rID
728         uint256 _rID = rID_;
729         
730         // grab time
731         uint256 _now = now;
732         
733         // are we in a round?
734         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && hasPlayersInRound(_rID) == false)))
735             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
736         else // rounds over.  need price for new round
737             return ( 75000000000000 ); // init
738     }
739     
740     /**
741      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
742      * provider
743      * -functionhash- 0xc7e284b8
744      * @return time left in seconds
745      */
746     function getTimeLeft()
747         public
748         view
749         returns(uint256)
750     {
751         // setup local rID
752         uint256 _rID = rID_;
753         
754         // grab time
755         uint256 _now = now;
756         
757         if (_now < round_[_rID].end)
758             if (_now > round_[_rID].strt + rndGap_)
759                 return( (round_[_rID].end).sub(_now) );
760             else
761                 return( (round_[_rID].strt + rndGap_).sub(_now) );
762         else
763             return(0);
764     }
765     
766     function isWinner(uint256 _pID, uint256 _rID) private view returns (bool) {
767         for (uint8 i = 0; i < winnerNum_; i++) {
768             if (round_[_rID].plyrs[i] == _pID) {
769                 return (true);
770             }
771         }
772         return (false);
773     }
774 
775     /**
776      * @dev returns player earnings per vaults 
777      * -functionhash- 0x63066434
778      * @return winnings vault
779      * @return general vault
780      * @return affiliate vault
781      */
782     function getPlayerVaults(uint256 _pID)
783         public
784         view
785         returns(uint256 ,uint256, uint256)
786     {
787         // setup local rID
788         uint256 _rID = rID_;
789         
790         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
791         if (now > round_[_rID].end && round_[_rID].ended == false && hasPlayersInRound(_rID) == true)
792         {
793             // if player is winner 
794             if (isWinner(_pID, _rID))
795             {
796                 calcTotalWinnerKeys(_rID);
797                 return
798                 (
799                     (plyr_[_pID].win).add( (((round_[_rID].pot).mul(48)) / 100).mul(plyrRnds_[_pID][_rID].keys) / totalWinnersKeys_ ),
800                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
801                     plyr_[_pID].aff
802                 );
803             // if player is not the winner
804             } else {
805                 return
806                 (
807                     plyr_[_pID].win,
808                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
809                     plyr_[_pID].aff
810                 );
811             }
812             
813         // if round is still going on, or round has ended and round end has been ran
814         } else {
815             return
816             (
817                 plyr_[_pID].win,
818                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
819                 plyr_[_pID].aff
820             );
821         }
822     }
823     
824     /**
825      * solidity hates stack limits.  this lets us avoid that hate 
826      */
827     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
828         private
829         view
830         returns(uint256)
831     {
832         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
833     }
834     
835     /**
836      * @dev returns all current round info needed for front end
837      * -functionhash- 0x747dff42
838      * @return eth invested during ICO phase
839      * @return round id 
840      * @return total keys for round 
841      * @return time round ends
842      * @return time round started
843      * @return current pot 
844      * @return current team ID & player ID in lead 
845      * @return current player in leads address 
846      * @return current player in leads name
847      * @return whales eth in for round
848      * @return bears eth in for round
849      * @return sneks eth in for round
850      * @return bulls eth in for round
851      * @return airdrop tracker # & airdrop pot
852      */
853     function getCurrentRoundInfo()
854         public
855         view
856         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
857     {
858         // setup local rID
859         // uint256 _rID = rID_;
860         return
861         (
862             round_[rID_].ico,               //0
863             rID_,                           //1
864             round_[rID_].keys,              //2
865             round_[rID_].end,               //3
866             round_[rID_].strt,              //4
867             round_[rID_].pot,               //5
868             (round_[rID_].team + (round_[rID_].plyrs[winnerNum_ - 1] * 10)),     //6
869             plyr_[round_[rID_].plyrs[winnerNum_ - 1]].addr,  //7
870             plyr_[round_[rID_].plyrs[winnerNum_ - 1]].name,  //8
871             rndTmEth_[rID_][0],             //9
872             rndTmEth_[rID_][1],             //10
873             rndTmEth_[rID_][2],             //11
874             rndTmEth_[rID_][3],             //12
875             airDropTracker_ + (airDropPot_ * 1000)              //13
876         );
877     }
878 
879     /**
880      * @dev returns player info based on address.  if no address is given, it will 
881      * use msg.sender 
882      * -functionhash- 0xee0b5d8b
883      * @param _addr address of the player you want to lookup 
884      * @return player ID 
885      * @return player name
886      * @return keys owned (current round)
887      * @return winnings vault
888      * @return general vault 
889      * @return affiliate vault 
890 	 * @return player round eth
891      */
892     function getPlayerInfoByAddress(address _addr)
893         public 
894         view 
895         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
896     {
897         // setup local rID
898         uint256 _rID = rID_;
899         
900         if (_addr == address(0))
901         {
902             _addr == msg.sender;
903         }
904         uint256 _pID = pIDxAddr_[_addr];
905         
906         return
907         (
908             _pID,                               //0
909             plyr_[_pID].name,                   //1
910             plyrRnds_[_pID][_rID].keys,         //2
911             plyr_[_pID].win,                    //3
912             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
913             plyr_[_pID].aff,                    //5
914             plyrRnds_[_pID][_rID].eth           //6
915         );
916     }
917 
918 //==============================================================================
919 //     _ _  _ _   | _  _ . _  .
920 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
921 //=====================_|=======================================================
922     function hasPlayersInRound(uint256 _rID) private view returns (bool){
923         for (uint8 i = 0; i < round_[_rID].plyrs.length; i++) {
924             if (round_[_rID].plyrs[i] != 0) {
925                 return (true);
926             }
927         }
928         return (false);
929     }
930 
931     /**
932      * @dev logic runs whenever a buy order is executed.  determines how to handle 
933      * incoming eth depending on if we are in an active round or not
934      */
935     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
936         private
937     {
938         // setup local rID
939         uint256 _rID = rID_;
940         
941         // grab time
942         uint256 _now = now;
943         
944         // if round is active
945         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && hasPlayersInRound(_rID) == false))) 
946         {
947             // call core 
948             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
949         
950         // if round is not active
951         } else {
952             // check to see if end round needs to be ran
953             if (_now > round_[_rID].end && round_[_rID].ended == false) 
954             {
955                 // end the round (distributes pot) & start new round
956                 round_[_rID].ended = true;
957                 _eventData_ = endRound(_eventData_);
958                 
959                 // build event data
960                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
961                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
962                 
963                 // fire buy and distribute event 
964                 emit F3Devents.onBuyAndDistribute
965                 (
966                     msg.sender, 
967                     plyr_[_pID].name, 
968                     msg.value, 
969                     _eventData_.compressedData, 
970                     _eventData_.compressedIDs, 
971                     _eventData_.winnerAddr, 
972                     _eventData_.winnerName, 
973                     _eventData_.amountWon, 
974                     _eventData_.newPot, 
975                     _eventData_.P3DAmount, 
976                     _eventData_.genAmount
977                 );
978             }
979             
980             // put eth in players vault 
981             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
982         }
983     }
984     
985     /**
986      * @dev logic runs whenever a reload order is executed.  determines how to handle 
987      * incoming eth depending on if we are in an active round or not 
988      */
989     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
990         private
991     {
992         // setup local rID
993         uint256 _rID = rID_;
994         
995         // grab time
996         uint256 _now = now;
997         
998         // if round is active
999         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && hasPlayersInRound(_rID) == false))) 
1000         {
1001             // get earnings from all vaults and return unused to gen vault
1002             // because we use a custom safemath library.  this will throw if player 
1003             // tried to spend more eth than they have.
1004             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1005             
1006             // call core 
1007             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1008         
1009         // if round is not active and end round needs to be ran   
1010         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1011             // end the round (distributes pot) & start new round
1012             round_[_rID].ended = true;
1013             _eventData_ = endRound(_eventData_);
1014                 
1015             // build event data
1016             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1017             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1018                 
1019             // fire buy and distribute event 
1020             emit F3Devents.onReLoadAndDistribute
1021             (
1022                 msg.sender, 
1023                 plyr_[_pID].name, 
1024                 _eventData_.compressedData, 
1025                 _eventData_.compressedIDs, 
1026                 _eventData_.winnerAddr, 
1027                 _eventData_.winnerName, 
1028                 _eventData_.amountWon, 
1029                 _eventData_.newPot, 
1030                 _eventData_.P3DAmount, 
1031                 _eventData_.genAmount
1032             );
1033         }
1034     }
1035     
1036     function contains(uint256 _pID, uint256[winnerNum_] memory array) private pure returns (bool) {
1037         for (uint8 i = 0; i < array.length; i++) {
1038             if (array[i] == _pID) {
1039                 return (true);
1040             }
1041         }
1042         return (false);
1043     }
1044 
1045     function calcTotalWinnerKeys(uint256 _rID) private {
1046         uint256[winnerNum_] memory winnerPIDs;
1047         totalWinnersKeys_ = 0;
1048         for (uint8 i = 0; i < winnerNum_; i++) {
1049             if (!contains(round_[_rID].plyrs[i], winnerPIDs)) {
1050                 winnerPIDs[i] = round_[_rID].plyrs[i];
1051                 totalWinnersKeys_ = totalWinnersKeys_.add(plyrRnds_[round_[_rID].plyrs[i]][_rID].keys);
1052             }
1053         }
1054     }
1055 
1056     /**
1057      * @dev this is the core logic for any buy/reload that happens while a round 
1058      * is live.
1059      */
1060     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1061         private
1062     {
1063         // if player is new to round
1064         if (plyrRnds_[_pID][_rID].keys == 0)
1065             _eventData_ = managePlayer(_pID, _eventData_);
1066         
1067         // early round eth limiter 
1068         if (round_[_rID].eth < (100 ether) && plyrRnds_[_pID][_rID].eth.add(_eth) > (1 ether))
1069         {
1070             uint256 _availableLimit = (1 ether).sub(plyrRnds_[_pID][_rID].eth);
1071             uint256 _refund = _eth.sub(_availableLimit);
1072             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1073             _eth = _availableLimit;
1074         }
1075         
1076         // if eth left is greater than min eth allowed (sorry no pocket lint)
1077         if (_eth > 1000000000) 
1078         {
1079             
1080             // mint the new keys
1081             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1082             
1083             // if they bought at least 1 whole key
1084             if (_keys >= 1000000000000000000)
1085             {
1086                 updateTimer(_keys, _rID);
1087 
1088                 // set new leaders
1089                 round_[_rID].plyrs[0] = round_[_rID].plyrs[1];
1090                 round_[_rID].plyrs[1] = round_[_rID].plyrs[2];
1091                 round_[_rID].plyrs[2] = round_[_rID].plyrs[3];
1092                 round_[_rID].plyrs[3] = round_[_rID].plyrs[4];
1093                 round_[_rID].plyrs[4] = _pID;
1094                 if (round_[_rID].team != _team) {
1095                     round_[_rID].team = _team; 
1096                 }
1097                 
1098                 // set the new leader bool to true
1099                 _eventData_.compressedData = _eventData_.compressedData + 100;
1100             }
1101             
1102             // manage airdrops
1103             if (_eth >= 100000000000000000)
1104             {
1105                 airDropTracker_++;
1106                 if (airdrop() == true)
1107                 {
1108                     // gib muni
1109                     uint256 _prize;
1110                     if (_eth >= 10000000000000000000)
1111                     {
1112                         // calculate prize and give it to winner
1113                         _prize = ((airDropPot_).mul(75)) / 100;
1114                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1115                         
1116                         // adjust airDropPot 
1117                         airDropPot_ = (airDropPot_).sub(_prize);
1118                         
1119                         // let event know a tier 3 prize was won 
1120                         _eventData_.compressedData += 300000000000000000000000000000000;
1121                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1122                         // calculate prize and give it to winner
1123                         _prize = ((airDropPot_).mul(50)) / 100;
1124                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1125                         
1126                         // adjust airDropPot 
1127                         airDropPot_ = (airDropPot_).sub(_prize);
1128                         
1129                         // let event know a tier 2 prize was won 
1130                         _eventData_.compressedData += 200000000000000000000000000000000;
1131                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1132                         // calculate prize and give it to winner
1133                         _prize = ((airDropPot_).mul(25)) / 100;
1134                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1135                         
1136                         // adjust airDropPot 
1137                         airDropPot_ = (airDropPot_).sub(_prize);
1138                         
1139                         // let event know a tier 3 prize was won 
1140                         _eventData_.compressedData += 300000000000000000000000000000000;
1141                     }
1142                     // set airdrop happened bool to true
1143                     _eventData_.compressedData += 10000000000000000000000000000000;
1144                     // let event know how much was won 
1145                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1146                     
1147                     // reset air drop tracker
1148                     airDropTracker_ = 0;
1149                 }
1150             }
1151     
1152             // store the air drop tracker number (number of buys since last airdrop)
1153             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1154             
1155             // update player 
1156             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1157             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1158             
1159             // update round
1160             round_[_rID].keys = _keys.add(round_[_rID].keys);
1161             round_[_rID].eth = _eth.add(round_[_rID].eth);
1162             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1163     
1164             // distribute eth
1165             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1166             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1167             
1168             // call end tx function to fire end tx event.
1169             endTx(_pID, _team, _eth, _keys, _eventData_);
1170         }
1171     }
1172 //==============================================================================
1173 //     _ _ | _   | _ _|_ _  _ _  .
1174 //    (_(_||(_|_||(_| | (_)| _\  .
1175 //==============================================================================
1176     /**
1177      * @dev calculates unmasked earnings (just calculates, does not update mask)
1178      * @return earnings in wei format
1179      */
1180     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1181         private
1182         view
1183         returns(uint256)
1184     {
1185         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1186     }
1187     
1188     /** 
1189      * @dev returns the amount of keys you would get given an amount of eth. 
1190      * -functionhash- 0xce89c80c
1191      * @param _rID round ID you want price for
1192      * @param _eth amount of eth sent in 
1193      * @return keys received 
1194      */
1195     function calcKeysReceived(uint256 _rID, uint256 _eth)
1196         public
1197         view
1198         returns(uint256)
1199     {
1200         // grab time
1201         uint256 _now = now;
1202         
1203         // are we in a round?
1204         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && hasPlayersInRound(_rID) == false)))
1205             return ( (round_[_rID].eth).keysRec(_eth) );
1206         else // rounds over.  need keys for new round
1207             return ( (_eth).keys() );
1208     }
1209     
1210     /** 
1211      * @dev returns current eth price for X keys.  
1212      * -functionhash- 0xcf808000
1213      * @param _keys number of keys desired (in 18 decimal format)
1214      * @return amount of eth needed to send
1215      */
1216     function iWantXKeys(uint256 _keys)
1217         public
1218         view
1219         returns(uint256)
1220     {
1221         // setup local rID
1222         uint256 _rID = rID_;
1223         
1224         // grab time
1225         uint256 _now = now;
1226         
1227         // are we in a round?
1228         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && hasPlayersInRound(_rID) == false)))
1229             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1230         else // rounds over.  need price for new round
1231             return ( (_keys).eth() );
1232     }
1233 //==============================================================================
1234 //    _|_ _  _ | _  .
1235 //     | (_)(_)|_\  .
1236 //==============================================================================
1237     /**
1238      * @dev gets existing or registers new pID.  use this when a player may be new
1239      * @return pID 
1240      */
1241     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1242         private
1243         returns (F3Ddatasets.EventReturns)
1244     {
1245         uint256 _pID = pIDxAddr_[msg.sender];
1246         // if player is new to this version of fomo3d
1247         if (_pID == 0)
1248         {
1249             // grab their player ID, name and last aff ID, from player names contract 
1250             playerCount++;
1251             _pID = playerCount;
1252             bytes32 _name = plyr_[_pID].name;
1253             uint256 _laff = plyr_[_pID].laff;
1254             
1255             // set up player account 
1256             pIDxAddr_[msg.sender] = _pID;
1257             plyr_[_pID].addr = msg.sender;
1258             
1259             if (_name != "")
1260             {
1261                 pIDxName_[_name] = _pID;
1262                 plyr_[_pID].name = _name;
1263             }
1264             
1265             if (_laff != 0 && _laff != _pID)
1266                 plyr_[_pID].laff = _laff;
1267             
1268             // set the new player bool to true
1269             _eventData_.compressedData = _eventData_.compressedData + 1;
1270         } 
1271         return (_eventData_);
1272     }
1273     
1274     /**
1275      * @dev checks to make sure user picked a valid team.  if not sets team 
1276      * to default (sneks)
1277      */
1278     function verifyTeam(uint256 _team)
1279         private
1280         pure
1281         returns (uint256)
1282     {
1283         if (_team < 0 || _team > 3)
1284             return(2);
1285         else
1286             return(_team);
1287     }
1288     
1289     /**
1290      * @dev decides if round end needs to be run & new round started.  and if 
1291      * player unmasked earnings from previously played rounds need to be moved.
1292      */
1293     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1294         private
1295         returns (F3Ddatasets.EventReturns)
1296     {
1297         // if player has played a previous round, move their unmasked earnings
1298         // from that round to gen vault.
1299         if (plyr_[_pID].lrnd != 0)
1300             updateGenVault(_pID, plyr_[_pID].lrnd);
1301             
1302         // update player's last round played
1303         plyr_[_pID].lrnd = rID_;
1304             
1305         // set the joined round bool to true
1306         _eventData_.compressedData = _eventData_.compressedData + 10;
1307         
1308         return(_eventData_);
1309     }
1310     
1311     /**
1312      * @dev ends the round. manages paying out winner/splitting up pot
1313      */
1314     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1315         private
1316         returns (F3Ddatasets.EventReturns)
1317     {
1318         // setup local rID
1319         uint256 _rID = rID_;
1320         
1321         // grab our winning player and team id's
1322         // uint256 _winPID = round_[_rID].plyrs[winnerNum_ - 1];
1323         // uint256 _winTID = round_[_rID].team;
1324         
1325         // grab our pot amount
1326         // uint256 _pot = round_[_rID].pot;
1327         
1328         // calculate our winner share, community rewards, gen share, 
1329         // p3d share, and amount reserved for next pot 
1330         uint256 _win = ((round_[_rID].pot).mul(48)) / 100;
1331         // uint256 _com = (_pot / 50);
1332         uint256 _gen = ((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100;
1333         // uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1334         uint256 _fee = ((round_[_rID].pot) / 50).add(((round_[_rID].pot).mul(potSplit_[round_[_rID].team].p3d)) / 100);
1335         uint256 _res = ((((round_[_rID].pot).sub(_win)).sub(_fee)).sub(_gen));
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
1346         calcTotalWinnerKeys(_rID);
1347         // pay our winner
1348         plyr_[round_[_rID].plyrs[winnerNum_ - 1]].win = (_win.mul(plyrRnds_[round_[_rID].plyrs[winnerNum_ - 1]][_rID].keys) / totalWinnersKeys_).add(plyr_[round_[_rID].plyrs[winnerNum_ - 1]].win);
1349         for (uint8 i = 0; i < winnerNum_ - 1; i++) {
1350             plyr_[round_[_rID].plyrs[i]].win = (_win.mul(plyrRnds_[round_[_rID].plyrs[i]][_rID].keys) / totalWinnersKeys_).add(plyr_[round_[_rID].plyrs[i]].win);
1351         }
1352         
1353         // distribute gen portion to key holders
1354         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1355         
1356         // send share for p3d to divies
1357         if (!teamAddress.send(_fee)) {
1358             // Nothing
1359         }
1360             
1361         // prepare event data
1362         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1363         _eventData_.compressedIDs = _eventData_.compressedIDs + (round_[_rID].plyrs[winnerNum_ - 1] * 100000000000000000000000000) + (round_[_rID].team * 100000000000000000);
1364         _eventData_.winnerAddr = plyr_[round_[_rID].plyrs[winnerNum_ - 1]].addr;
1365         _eventData_.winnerName = plyr_[round_[_rID].plyrs[winnerNum_ - 1]].name;
1366         _eventData_.amountWon = _win;
1367         _eventData_.genAmount = _gen;
1368         _eventData_.P3DAmount = ((round_[_rID].pot).mul(potSplit_[round_[_rID].team].p3d)) / 100;
1369         _eventData_.newPot = _res;
1370         
1371         // start next round
1372         rID_++;
1373         _rID++;
1374         round_[_rID].strt = now;
1375         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1376         round_[_rID].pot = _res;
1377         
1378         return(_eventData_);
1379     }
1380     
1381     /**
1382      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1383      */
1384     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1385         private 
1386     {
1387         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1388         if (_earnings > 0)
1389         {
1390             // put in gen vault
1391             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1392             // zero out their earnings by updating mask
1393             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1394         }
1395     }
1396     
1397     /**
1398      * @dev updates round timer based on number of whole keys bought.
1399      */
1400     function updateTimer(uint256 _keys, uint256 _rID)
1401         private
1402     {
1403         // grab time
1404         uint256 _now = now;
1405         // if (round_[_rID].end.sub(_now) <= (60 seconds) && hasPlayersInRound(_rID) == true) {
1406         //     return;
1407         // }
1408         
1409         // calculate time based on number of keys bought
1410         uint256 _newTime;
1411         if (_now > round_[_rID].end && hasPlayersInRound(_rID) == false)
1412             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1413         else
1414             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1415         
1416         // rndSubed_ 根据资金量扣减时间
1417         uint256 _rndEth = round_[_rID].eth; // 本轮eth总量
1418         uint256 _rndNeedSub = 0; // 本轮最大时间需减少的时间
1419         if (_rndEth >= (2000 ether)) {
1420             if (_rndEth <= (46000 ether)) { // sub hours
1421                 _rndNeedSub = (1 hours).mul(_rndEth / (2000 ether));
1422             } else {
1423                 _rndNeedSub = (1 hours).mul(23);
1424                 uint256 _ethLeft = _rndEth.sub(46000 ether);
1425                 if (_ethLeft <= (12000 ether)) {
1426                     _rndNeedSub = _rndNeedSub.add((590 seconds).mul(_ethLeft / (2000 ether)));
1427                 } else { // 最后一分钟
1428                     _rndNeedSub = 999;
1429                 }
1430             }
1431         }
1432 
1433         if (_rndNeedSub != 999) {
1434             uint256 _rndMax = rndMax_.sub(_rndNeedSub);
1435             // compare to max and set new end time
1436             if (_newTime < (_rndMax).add(_now))
1437                 round_[_rID].end = _newTime;
1438             else
1439                 round_[_rID].end = _rndMax.add(_now);
1440         }
1441     }
1442     
1443     /**
1444      * @dev generates a random number between 0-99 and checks to see if thats
1445      * resulted in an airdrop win
1446      * @return do we have a winner?
1447      */
1448     function airdrop()
1449         private 
1450         view 
1451         returns(bool)
1452     {
1453         uint256 seed = uint256(keccak256(abi.encodePacked(
1454             
1455             (block.timestamp).add
1456             (block.difficulty).add
1457             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1458             (block.gaslimit).add
1459             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1460             (block.number)
1461             
1462         )));
1463         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1464             return(true);
1465         else
1466             return(false);
1467     }
1468 
1469     /**
1470      * @dev distributes eth based on fees to com, aff, and p3d
1471      */
1472     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1473         private
1474         returns(F3Ddatasets.EventReturns)
1475     {
1476         // pay 2% out to community rewards
1477         uint256 _com = _eth / 50;
1478         uint256 _p3d;
1479         uint256 _long = _eth / 100;
1480         
1481         // distribute share to affiliate
1482         uint256 _aff = _eth / 10;
1483         
1484         // decide what to do with affiliate share of fees
1485         // affiliate must not be self, and must have a name registered
1486         if (_affID != _pID && plyr_[_affID].name != "") {
1487             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1488             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1489         } else {
1490             _p3d = _aff;
1491         }
1492         
1493         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1494         if (_p3d > 0)
1495         {   
1496             // set up event data
1497             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1498         }
1499 
1500 
1501         // deposit to divies contract
1502         // Divies.deposit.value(_p3d)();
1503         if (!teamAddress.send(_p3d.add(_com).add(_long))) {
1504             // Nothing
1505         }
1506         
1507         return(_eventData_);
1508     }
1509     
1510     function potSwap()
1511         external
1512         payable
1513     {
1514         // setup local rID
1515         uint256 _rID = rID_ + 1;
1516         
1517         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1518         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1519     }
1520     
1521     /**
1522      * @dev distributes eth based on fees to gen and pot
1523      */
1524     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1525         private
1526         returns(F3Ddatasets.EventReturns)
1527     {
1528         // calculate gen share
1529         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1530         
1531         // toss 1% into airdrop pot 
1532         uint256 _air = (_eth / 100);
1533         airDropPot_ = airDropPot_.add(_air);
1534         
1535         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1536         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1537         
1538         // calculate pot 
1539         uint256 _pot = _eth.sub(_gen);
1540         
1541         // distribute gen share (thats what updateMasks() does) and adjust
1542         // balances for dust.
1543         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1544         if (_dust > 0)
1545             _gen = _gen.sub(_dust);
1546         
1547         // add eth to pot
1548         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1549         
1550         // set up event data
1551         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1552         _eventData_.potAmount = _pot;
1553         
1554         return(_eventData_);
1555     }
1556 
1557     /**
1558      * @dev updates masks for round and player when keys are bought
1559      * @return dust left over 
1560      */
1561     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1562         private
1563         returns(uint256)
1564     {
1565         /* MASKING NOTES
1566             earnings masks are a tricky thing for people to wrap their minds around.
1567             the basic thing to understand here.  is were going to have a global
1568             tracker based on profit per share for each round, that increases in
1569             relevant proportion to the increase in share supply.
1570             
1571             the player will have an additional mask that basically says "based
1572             on the rounds mask, my shares, and how much i've already withdrawn,
1573             how much is still owed to me?"
1574         */
1575         
1576         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1577         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1578         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1579             
1580         // calculate player earning from their own buy (only based on the keys
1581         // they just bought).  & update player earnings mask
1582         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1583         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1584         
1585         // calculate & return dust
1586         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1587     }
1588     
1589     /**
1590      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1591      * @return earnings in wei format
1592      */
1593     function withdrawEarnings(uint256 _pID)
1594         private
1595         returns(uint256)
1596     {
1597         // update gen vault
1598         updateGenVault(_pID, plyr_[_pID].lrnd);
1599         
1600         // from vaults 
1601         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1602         if (_earnings > 0)
1603         {
1604             plyr_[_pID].win = 0;
1605             plyr_[_pID].gen = 0;
1606             plyr_[_pID].aff = 0;
1607         }
1608 
1609         return(_earnings);
1610     }
1611     
1612     /**
1613      * @dev prepares compression data and fires event for buy or reload tx's
1614      */
1615     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1616         private
1617     {
1618         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1619         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1620         
1621         emit F3Devents.onEndTx
1622         (
1623             _eventData_.compressedData,
1624             _eventData_.compressedIDs,
1625             plyr_[_pID].name,
1626             msg.sender,
1627             _eth,
1628             _keys,
1629             _eventData_.winnerAddr,
1630             _eventData_.winnerName,
1631             _eventData_.amountWon,
1632             _eventData_.newPot,
1633             _eventData_.P3DAmount,
1634             _eventData_.genAmount,
1635             _eventData_.potAmount,
1636             airDropPot_
1637         );
1638     }
1639 //==============================================================================
1640 //    (~ _  _    _._|_    .
1641 //    _)(/_(_|_|| | | \/  .
1642 //====================/=========================================================
1643     /** upon contract deploy, it will be deactivated.  this is a one time
1644      * use function that will activate the contract.  we do this so devs 
1645      * have time to set things up on the web end                            **/
1646     bool public activated_ = false;
1647     function activate()
1648         isOwner()
1649         public
1650     {
1651 		// make sure that its been linked.
1652         // require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1653         
1654         // can only be ran once
1655         require(activated_ == false, "fomo3d already activated");
1656         
1657         // activate the contract 
1658         activated_ = true;
1659         
1660         // lets start first round
1661         rID_ = 1;
1662         round_[1].strt = now + rndExtra_ - rndGap_;
1663         round_[1].end = now + rndInit_ + rndExtra_;
1664     }
1665 }
1666 
1667 //==============================================================================
1668 //   __|_ _    __|_ _  .
1669 //  _\ | | |_|(_ | _\  .
1670 //==============================================================================
1671 library F3Ddatasets {
1672     //compressedData key
1673     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1674         // 0 - new player (bool)
1675         // 1 - joined round (bool)
1676         // 2 - new  leader (bool)
1677         // 3-5 - air drop tracker (uint 0-999)
1678         // 6-16 - round end time
1679         // 17 - winnerTeam
1680         // 18 - 28 timestamp 
1681         // 29 - team
1682         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1683         // 31 - airdrop happened bool
1684         // 32 - airdrop tier 
1685         // 33 - airdrop amount won
1686     //compressedIDs key
1687     // [77-52][51-26][25-0]
1688         // 0-25 - pID 
1689         // 26-51 - winPID
1690         // 52-77 - rID
1691     struct EventReturns {
1692         uint256 compressedData;
1693         uint256 compressedIDs;
1694         address winnerAddr;         // winner address
1695         bytes32 winnerName;         // winner name
1696         uint256 amountWon;          // amount won
1697         uint256 newPot;             // amount in new pot
1698         uint256 P3DAmount;          // amount distributed to p3d
1699         uint256 genAmount;          // amount distributed to gen
1700         uint256 potAmount;          // amount added to pot
1701     }
1702     struct Player {
1703         address addr;   // player address
1704         bytes32 name;   // player name
1705         uint256 win;    // winnings vault
1706         uint256 gen;    // general vault
1707         uint256 aff;    // affiliate vault
1708         uint256 lrnd;   // last round played
1709         uint256 laff;   // last affiliate id used
1710     }
1711     struct PlayerRounds {
1712         uint256 eth;    // eth player has added to round (used for eth limiter)
1713         uint256 keys;   // keys
1714         uint256 mask;   // player mask 
1715         uint256 ico;    // ICO phase investment
1716     }
1717     struct Round {
1718         uint256[5] plyrs;   // pID of player in lead
1719         uint256 team;   // tID of team in lead
1720         uint256 end;    // time ends/ended
1721         bool ended;     // has round end function been ran
1722         uint256 strt;   // time round started
1723         uint256 keys;   // keys
1724         uint256 eth;    // total eth in
1725         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1726         uint256 mask;   // global mask
1727         uint256 ico;    // total eth sent in during ICO phase
1728         uint256 icoGen; // total eth for gen during ICO phase
1729         uint256 icoAvg; // average key price for ICO phase
1730     }
1731     struct TeamFee {
1732         uint256 gen;    // % of buy in thats paid to key holders of current round
1733         uint256 p3d;    // % of buy in thats paid to p3d holders
1734     }
1735     struct PotSplit {
1736         uint256 gen;    // % of pot thats paid to key holders of current round
1737         uint256 p3d;    // % of pot thats paid to p3d holders
1738     }
1739 }
1740 
1741 //==============================================================================
1742 //  |  _      _ _ | _  .
1743 //  |<(/_\/  (_(_||(_  .
1744 //=======/======================================================================
1745 library F3DKeysCalcLong {
1746     using SafeMath for *;
1747     /**
1748      * @dev calculates number of keys received given X eth 
1749      * @param _curEth current amount of eth in contract 
1750      * @param _newEth eth being spent
1751      * @return amount of ticket purchased
1752      */
1753     function keysRec(uint256 _curEth, uint256 _newEth)
1754         internal
1755         pure
1756         returns (uint256)
1757     {
1758         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1759     }
1760     
1761     /**
1762      * @dev calculates amount of eth received if you sold X keys 
1763      * @param _curKeys current amount of keys that exist 
1764      * @param _sellKeys amount of keys you wish to sell
1765      * @return amount of eth received
1766      */
1767     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1768         internal
1769         pure
1770         returns (uint256)
1771     {
1772         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1773     }
1774 
1775     /**
1776      * @dev calculates how many keys would exist with given an amount of eth
1777      * @param _eth eth "in contract"
1778      * @return number of keys that would exist
1779      */
1780     function keys(uint256 _eth) 
1781         internal
1782         pure
1783         returns(uint256)
1784     {
1785         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1786     }
1787     
1788     /**
1789      * @dev calculates how much eth would be in contract given a number of keys
1790      * @param _keys number of keys "in contract" 
1791      * @return eth that would exists
1792      */
1793     function eth(uint256 _keys) 
1794         internal
1795         pure
1796         returns(uint256)  
1797     {
1798         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1799     }
1800 }
1801 
1802 //==============================================================================
1803 //  . _ _|_ _  _ |` _  _ _  _  .
1804 //  || | | (/_| ~|~(_|(_(/__\  .
1805 //==============================================================================
1806 
1807 interface Fomo3dContract {
1808     function setOldContractData(address oldContract) external payable;
1809 }
1810 
1811 /**
1812 * @title -Name Filter- v0.1.9
1813 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1814 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1815 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1816 *                                  _____                      _____
1817 *                                 (, /     /)       /) /)    (, /      /)          /)
1818 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1819 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1820 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1821 *                            (__ /          (_/ (, /                                      /)™ 
1822 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1823 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1824 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1825 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1826 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1827 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1828 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1829 *
1830 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1831 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1832 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1833 */
1834 
1835 library NameFilter {
1836     /**
1837      * @dev filters name strings
1838      * -converts uppercase to lower case.  
1839      * -makes sure it does not start/end with a space
1840      * -makes sure it does not contain multiple spaces in a row
1841      * -cannot be only numbers
1842      * -cannot start with 0x 
1843      * -restricts characters to A-Z, a-z, 0-9, and space.
1844      * @return reprocessed string in bytes32 format
1845      */
1846     function nameFilter(string _input)
1847         internal
1848         pure
1849         returns(bytes32)
1850     {
1851         bytes memory _temp = bytes(_input);
1852         uint256 _length = _temp.length;
1853         
1854         //sorry limited to 32 characters
1855         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1856         // make sure it doesnt start with or end with space
1857         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1858         // make sure first two characters are not 0x
1859         if (_temp[0] == 0x30)
1860         {
1861             require(_temp[1] != 0x78, "string cannot start with 0x");
1862             require(_temp[1] != 0x58, "string cannot start with 0X");
1863         }
1864         
1865         // create a bool to track if we have a non number character
1866         bool _hasNonNumber;
1867         
1868         // convert & check
1869         for (uint256 i = 0; i < _length; i++)
1870         {
1871             // if its uppercase A-Z
1872             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1873             {
1874                 // convert to lower case a-z
1875                 _temp[i] = byte(uint(_temp[i]) + 32);
1876                 
1877                 // we have a non number
1878                 if (_hasNonNumber == false)
1879                     _hasNonNumber = true;
1880             } else {
1881                 require
1882                 (
1883                     // require character is a space
1884                     _temp[i] == 0x20 || 
1885                     // OR lowercase a-z
1886                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1887                     // or 0-9
1888                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1889                     "string contains invalid characters"
1890                 );
1891                 // make sure theres not 2x spaces in a row
1892                 if (_temp[i] == 0x20)
1893                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1894                 
1895                 // see if we have a character other than a number
1896                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1897                     _hasNonNumber = true;    
1898             }
1899         }
1900         
1901         require(_hasNonNumber == true, "string cannot be only numbers");
1902         
1903         bytes32 _ret;
1904         assembly {
1905             _ret := mload(add(_temp, 32))
1906         }
1907         return (_ret);
1908     }
1909 }
1910 
1911 /**
1912  * @title SafeMath v0.1.9
1913  * @dev Math operations with safety checks that throw on error
1914  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1915  * - added sqrt
1916  * - added sq
1917  * - added pwr 
1918  * - changed asserts to requires with error log outputs
1919  * - removed div, its useless
1920  */
1921 library SafeMath {
1922     
1923     /**
1924     * @dev Multiplies two numbers, throws on overflow.
1925     */
1926     function mul(uint256 a, uint256 b) 
1927         internal 
1928         pure 
1929         returns (uint256 c) 
1930     {
1931         if (a == 0) {
1932             return 0;
1933         }
1934         c = a * b;
1935         require(c / a == b, "SafeMath mul failed");
1936         return c;
1937     }
1938 
1939     /**
1940     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1941     */
1942     function sub(uint256 a, uint256 b)
1943         internal
1944         pure
1945         returns (uint256) 
1946     {
1947         require(b <= a, "SafeMath sub failed");
1948         return a - b;
1949     }
1950 
1951     /**
1952     * @dev Adds two numbers, throws on overflow.
1953     */
1954     function add(uint256 a, uint256 b)
1955         internal
1956         pure
1957         returns (uint256 c) 
1958     {
1959         c = a + b;
1960         require(c >= a, "SafeMath add failed");
1961         return c;
1962     }
1963     
1964     /**
1965      * @dev gives square root of given x.
1966      */
1967     function sqrt(uint256 x)
1968         internal
1969         pure
1970         returns (uint256 y) 
1971     {
1972         uint256 z = ((add(x,1)) / 2);
1973         y = x;
1974         while (z < y) 
1975         {
1976             y = z;
1977             z = ((add((x / z),z)) / 2);
1978         }
1979     }
1980     
1981     /**
1982      * @dev gives square. multiplies x by x
1983      */
1984     function sq(uint256 x)
1985         internal
1986         pure
1987         returns (uint256)
1988     {
1989         return (mul(x,x));
1990     }
1991     
1992     /**
1993      * @dev x to the power of y 
1994      */
1995     function pwr(uint256 x, uint256 y)
1996         internal 
1997         pure 
1998         returns (uint256)
1999     {
2000         if (x==0)
2001             return (0);
2002         else if (y==0)
2003             return (1);
2004         else 
2005         {
2006             uint256 z = x;
2007             for (uint256 i=1; i < y; i++)
2008                 z = mul(z,x);
2009             return (z);
2010         }
2011     }
2012 }