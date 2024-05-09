1 pragma solidity ^0.4.24;
2 
3 /*
4  * @title - XCasino Team
5  *                                       __  __                 _               
6  *                                       \ \/ / ___  __ _  ___ (_) _ __    ___  
7  *                                        \  / / __|/ _` |/ __|| || '_ \  / _ \ 
8  *                                        /  \| (__| (_| |\__ \| || | | || (_) |
9  *                                       /_/\_\\___|\__,_||___/|_||_| |_| \___/ 
10  *
11  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐                       
12  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │                      
13  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘                      
14  *===========================================================================================*
15  */
16 
17 contract J3Devents {
18     // fired whenever a player registers a name
19     event onNewName
20     (
21         uint256 indexed playerID,
22         address indexed playerAddress,
23         bytes32 indexed playerName,
24         bool isNewPlayer,
25         uint256 affiliateID,
26         address affiliateAddress,
27         bytes32 affiliateName,
28         uint256 amountPaid,
29         uint256 timeStamp
30     );
31     
32     // fired at end of buy or reload
33     event onEndTx
34     (
35         uint256 compressedData,     
36         uint256 compressedIDs,      
37         bytes32 playerName,
38         address playerAddress,
39         uint256 ethIn,
40         uint256 keysBought,
41         address winnerAddr,
42         bytes32 winnerName,
43         uint256 amountWon,
44         uint256 newPot,
45         uint256 P3DAmount,
46         uint256 genAmount,
47         uint256 potAmount,
48         uint256 airDropPot
49     );
50     
51 	// fired whenever theres a withdraw
52     event onWithdraw
53     (
54         uint256 indexed playerID,
55         address playerAddress,
56         bytes32 playerName,
57         uint256 ethOut,
58         uint256 timeStamp
59     );
60     
61     // fired whenever a withdraw forces end round to be ran
62     event onWithdrawAndDistribute
63     (
64         address playerAddress,
65         bytes32 playerName,
66         uint256 ethOut,
67         uint256 compressedData,
68         uint256 compressedIDs,
69         address winnerAddr,
70         bytes32 winnerName,
71         uint256 amountWon,
72         uint256 newPot,
73         uint256 P3DAmount,
74         uint256 genAmount
75     );
76     
77     // hit zero, and causes end round to be ran.
78     event onBuyAndDistribute
79     (
80         address playerAddress,
81         bytes32 playerName,
82         uint256 ethIn,
83         uint256 compressedData,
84         uint256 compressedIDs,
85         address winnerAddr,
86         bytes32 winnerName,
87         uint256 amountWon,
88         uint256 newPot,
89         uint256 P3DAmount,
90         uint256 genAmount
91     );
92     
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
126     
127     // fired whenever an janwin is paid
128     event onNewJanWin
129     (
130         uint256 indexed roundID,
131         uint256 indexed buyerID,
132         address playerAddress,
133         bytes32 playerName,
134         uint256 amount,
135         uint256 timeStamp
136     );
137 }
138 
139 contract modularLong is J3Devents {}
140 
141 interface JIincForwarderInterface {
142     function deposit() external payable returns(bool);
143     function status() external view returns(address, address, bool);
144     function startMigration(address _newCorpBank) external returns(bool);
145     function cancelMigration() external returns(bool);
146     function finishMigration() external returns(bool);
147     function setup(address _firstCorpBank) external;
148 }
149 
150 interface PlayerBookInterface {
151     function getPlayerID(address _addr) external returns (uint256);
152     function getPlayerName(uint256 _pID) external view returns (bytes32);
153     function getPlayerLAff(uint256 _pID) external view returns (uint256);
154     function getPlayerAddr(uint256 _pID) external view returns (address);
155     function getNameFee() external view returns (uint256);
156     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
157     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
158     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
159 }
160 
161 interface HourglassInterface {
162     function() payable external;
163     function buy(address _playerAddress) payable external returns(uint256);
164     function sell(uint256 _amountOfTokens) external;
165     function reinvest() external;
166     function withdraw() external;
167     function exit() external;
168     function dividendsOf(address _playerAddress) external view returns(uint256);
169     function balanceOf(address _playerAddress) external view returns(uint256);
170     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
171     function stakingRequirement() external view returns(uint256);
172 }
173 
174 contract JanKenPon is modularLong {
175     using SafeMath for *;
176     using NameFilter for string;
177     using J3DKeysCalcLong for uint256;
178     
179     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x7f546aC4261CA5dE2D5e12E16Ae0F1B5c479b0c2);
180     PlayerBookInterface private PlayerBook = PlayerBookInterface(0x0183f4E77F21b232F60fAf6898D6a8FE899489CB);
181     //address public playerbookaddr ;
182     //address public jekylladdr ;
183     
184 //==============================================================================
185 //     _ _  _  |`. _     _ _ |_ | _  _  .
186 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
187 //=================_|===========================================================
188     string constant public name = "Jan Ken Pon";
189     string constant public symbol = "JKP";
190     uint256 private rndExtra_ = 0;								//extSettings.getLongExtra();
191     uint256 private rndGap_ = 30;								//extSettings.getLongGap();
192     uint256 constant private rndInit_ = 3 hours;                // round timer starts at this
193     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
194     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
195     uint256 public  gasPriceLimit_ = 500000000000;      // max gas price to 500Gwei we will set a limit if need
196 //==============================================================================
197 //     _| _ _|_ _    _ _ _|_    _   .
198 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
199 //=============================|================================================
200     uint256 public rID_;    // round id number / total rounds that have happened
201     uint256 public janPot_;  // person who win the jan will get part of this pot
202 //****************
203 // PLAYER DATA 
204 //****************
205     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
206     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
207     mapping (uint256 => J3Ddatasets.Player) public plyr_;   // (pID => data) player data
208     mapping (uint256 => mapping (uint256 => J3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
209     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
210 //****************
211 // ROUND DATA 
212 //****************
213     mapping (uint256 => J3Ddatasets.Round) public round_;   // (rID => data) round data
214     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
215 //****************
216 // TEAM FEE DATA 
217 //****************
218     mapping (uint256 => J3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
219     mapping (uint256 => J3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
220 //==============================================================================
221 //     _ _  _  __|_ _    __|_ _  _  .
222 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
223 //==============================================================================
224 	constructor()
225     //constructor(address addr1,address addr2)
226         public
227     {
228     
229         //playerbookaddr = addr2;
230     	//jekylladdr = addr1;
231     
232     	//Jekyll_Island_Inc = JIincForwarderInterface(jekylladdr);
233     	//PlayerBook = PlayerBookInterface(playerbookaddr);
234     
235 		// Team allocation structures
236         // 0 = Jan
237         // 1 = Ken
238         // 2 = Pon
239         // 3 = Random
240         // 0 > 1 ; 1 > 2 ; 2 > 0;
241 
242 		// Team allocation percentages
243         // (Keys, Pot , Referrals, Community, JanPot)
244         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
245         fees_[0] = J3Ddatasets.TeamFee(50,25,15,5,5);   //50% to gen 25% to pot, 15% to aff, 5% to com, 5% to pot Jan
246         fees_[1] = J3Ddatasets.TeamFee(50,25,15,5,5);   //50% to gen 25% to pot, 15% to aff, 5% to com, 5% to pot Jan
247         fees_[2] = J3Ddatasets.TeamFee(50,25,15,5,5);   //50% to gen 25% to pot, 15% to aff, 5% to com, 5% to pot Jan
248         fees_[3] = J3Ddatasets.TeamFee(50,25,15,5,5);   //50% to gen 25% to pot, 15% to aff, 5% to com, 5% to pot Jan
249         
250         // how to split up the final pot based on which team was picked
251         // (Keys, Winner, Next round, Community)
252         potSplit_[0] = J3Ddatasets.PotSplit(30,50,10,10);  //30% to Keys 50% to winner, 10% to next round, 10% to com
253         potSplit_[1] = J3Ddatasets.PotSplit(30,50,10,10);  //30% to Keys 50% to winner, 10% to next round, 10% to com
254         potSplit_[2] = J3Ddatasets.PotSplit(30,50,10,10);  //30% to Keys 50% to winner, 10% to next round, 10% to com
255         potSplit_[3] = J3Ddatasets.PotSplit(30,50,10,10);  //30% to Keys 50% to winner, 10% to next round, 10% to com
256     }
257 //==============================================================================
258 //     _ _  _  _|. |`. _  _ _  .
259 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
260 //==============================================================================
261     /**
262      * @dev used to make sure no one can interact with contract until it has 
263      * been activated. 
264      */
265     modifier isActivated() {
266         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
267         _;
268     }
269     
270     /**
271      * @dev prevents contracts from interacting
272      */
273     modifier isHuman() {
274         address _addr = msg.sender;
275         uint256 _codeLength;
276         
277         assembly {_codeLength := extcodesize(_addr)}
278         require(_codeLength == 0, "sorry humans only");
279         _;
280     }
281 
282     /**
283      * @dev sets boundaries for incoming tx 
284      */
285     modifier isWithinLimits(uint256 _eth) {
286         require(_eth >= 1000000000, "pocket lint: not a valid currency");
287         require(_eth <= 100000000000000000000000, "no vitalik, no");
288         _;    
289     }
290     
291     /**
292      * @dev sets gasLimit 
293      */
294     modifier isGasLimit() {
295         require(gasPriceLimit_ >= tx.gasprice, "GasPrice too high");
296         _;    
297     }
298     
299 //==============================================================================
300 //     _    |_ |. _   |`    _  __|_. _  _  _  .
301 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
302 //====|=========================================================================
303     /**
304      * @dev emergency buy uses last stored affiliate ID and team snek
305      */
306     function()
307         isActivated()
308         isHuman()
309         isWithinLimits(msg.value)
310         isGasLimit()
311         public
312         payable
313     {
314         // set up our tx event data and determine if player is new or not
315         J3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
316             
317         // fetch player id
318         uint256 _pID = pIDxAddr_[msg.sender];
319         uint256 _team = randomTeam();
320         // buy core 
321         buyCore(_pID, plyr_[_pID].laff,_team, _eventData_);
322     }
323     
324     /**
325      * @dev converts all incoming ethereum to keys.
326      * -functionhash- 0x8f38f309 (using ID for affiliate)
327      * -functionhash- 0x98a0871d (using address for affiliate)
328      * -functionhash- 0xa65b37a1 (using name for affiliate)
329      * @param _affCode the ID/address/name of the player who gets the affiliate fee
330      * @param _team what team is the player playing for?
331      */
332 
333     function buyXid(uint256 _affCode, uint256 _team)
334         isActivated()
335         isHuman()
336         isWithinLimits(msg.value)
337         isGasLimit()
338         public
339         payable
340     {
341     	
342         // set up our tx event data and determine if player is new or not
343         J3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
344         // fetch player id
345         uint256 _pID = pIDxAddr_[msg.sender];
346         // manage affiliate residuals
347         // if no affiliate code was given or player tried to use their own, lolz
348         if (_affCode == 0 || _affCode == _pID)
349         {
350             // use last stored affiliate code 
351             _affCode = plyr_[_pID].laff;
352         // if affiliate code was given & its not the same as previously stored 
353         } else if (_affCode != plyr_[_pID].laff) {
354             // update last affiliate 
355             plyr_[_pID].laff = _affCode;
356         }
357         // verify a valid team was selected
358         _team = verifyTeam(_team);
359         // buy core 
360         buyCore(_pID, _affCode, _team, _eventData_);
361     }
362     
363     function buyXaddr(address _affCode, uint256 _team)
364         isActivated()
365         isHuman()
366         isWithinLimits(msg.value)
367         isGasLimit()
368         public
369         payable
370     {
371         // set up our tx event data and determine if player is new or not
372         J3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
373         
374         // fetch player id
375         uint256 _pID = pIDxAddr_[msg.sender];
376         
377         // manage affiliate residuals
378         uint256 _affID;
379         // if no affiliate code was given or player tried to use their own, lolz
380         if (_affCode == address(0) || _affCode == msg.sender)
381         {
382             // use last stored affiliate code
383             _affID = plyr_[_pID].laff;
384         
385         // if affiliate code was given    
386         } else {
387             // get affiliate ID from aff Code 
388             _affID = pIDxAddr_[_affCode];
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
405     function buyXname(bytes32 _affCode, uint256 _team)
406         isActivated()
407         isHuman()
408         isWithinLimits(msg.value)
409         isGasLimit()
410         public
411         payable
412     {
413         // set up our tx event data and determine if player is new or not
414         J3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
415         
416         // fetch player id
417         uint256 _pID = pIDxAddr_[msg.sender];
418         
419         // manage affiliate residuals
420         uint256 _affID;
421         // if no affiliate code was given or player tried to use their own, lolz
422         if (_affCode == '' || _affCode == plyr_[_pID].name)
423         {
424             // use last stored affiliate code
425             _affID = plyr_[_pID].laff;
426         
427         // if affiliate code was given
428         } else {
429             // get affiliate ID from aff Code
430             _affID = pIDxName_[_affCode];
431             
432             // if affID is not the same as previously stored
433             if (_affID != plyr_[_pID].laff)
434             {
435                 // update last affiliate
436                 plyr_[_pID].laff = _affID;
437             }
438         }
439         
440         // verify a valid team was selected
441         _team = verifyTeam(_team);
442         
443         // buy core 
444         buyCore(_pID, _affID, _team, _eventData_);
445     }
446     
447     /**
448      * @dev essentially the same as buy, but instead of you sending ether 
449      * from your wallet, it uses your unwithdrawn earnings.
450      * -functionhash- 0x349cdcac (using ID for affiliate)
451      * -functionhash- 0x82bfc739 (using address for affiliate)
452      * -functionhash- 0x079ce327 (using name for affiliate)
453      * @param _affCode the ID/address/name of the player who gets the affiliate fee
454      * @param _team what team is the player playing for?
455      * @param _eth amount of earnings to use (remainder returned to gen vault)
456      */
457     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
458         isActivated()
459         isHuman()
460         isWithinLimits(_eth)
461         isGasLimit()
462         public
463     {
464         // set up our tx event data
465         J3Ddatasets.EventReturns memory _eventData_;
466         
467         // fetch player ID
468         uint256 _pID = pIDxAddr_[msg.sender];
469         
470         // manage affiliate residuals
471         // if no affiliate code was given or player tried to use their own, lolz
472         if (_affCode == 0 || _affCode == _pID)
473         {
474             // use last stored affiliate code 
475             _affCode = plyr_[_pID].laff;
476             
477         // if affiliate code was given & its not the same as previously stored 
478         } else if (_affCode != plyr_[_pID].laff) {
479             // update last affiliate 
480             plyr_[_pID].laff = _affCode;
481         }
482 
483         // verify a valid team was selected
484         _team = verifyTeam(_team);
485 
486         // reload core
487         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
488     }
489     
490     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
491         isActivated()
492         isHuman()
493         isWithinLimits(_eth)
494         isGasLimit()
495         public
496     {
497         // set up our tx event data
498         J3Ddatasets.EventReturns memory _eventData_;
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
535         isGasLimit()
536         public
537     {
538         // set up our tx event data
539         J3Ddatasets.EventReturns memory _eventData_;
540         
541         // fetch player ID
542         uint256 _pID = pIDxAddr_[msg.sender];
543         
544         // manage affiliate residuals
545         uint256 _affID;
546         // if no affiliate code was given or player tried to use their own, lolz
547         if (_affCode == '' || _affCode == plyr_[_pID].name)
548         {
549             // use last stored affiliate code
550             _affID = plyr_[_pID].laff;
551         
552         // if affiliate code was given
553         } else {
554             // get affiliate ID from aff Code
555             _affID = pIDxName_[_affCode];
556             
557             // if affID is not the same as previously stored
558             if (_affID != plyr_[_pID].laff)
559             {
560                 // update last affiliate
561                 plyr_[_pID].laff = _affID;
562             }
563         }
564         
565         // verify a valid team was selected
566         _team = verifyTeam(_team);
567         
568         // reload core
569         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
570     }
571 
572     /**
573      * @dev withdraws all of your earnings.
574      * -functionhash- 0x3ccfd60b
575      */
576     function withdraw()
577         isActivated()
578         isHuman()
579         public
580     {
581         // setup local rID 
582         uint256 _rID = rID_;
583         
584         // grab time
585         uint256 _now = now;
586         
587         // fetch player ID
588         uint256 _pID = pIDxAddr_[msg.sender];
589         
590         // setup temp var for player eth
591         uint256 _eth;
592         
593         // check to see if round has ended and no one has run round end yet
594         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
595         {
596             // set up our tx event data
597             J3Ddatasets.EventReturns memory _eventData_;
598             
599             // end the round (distributes pot)
600 			round_[_rID].ended = true;
601             _eventData_ = endRound(_eventData_);
602             
603 			// get their earnings
604             _eth = withdrawEarnings(_pID);
605             
606             // gib moni
607             if (_eth > 0)
608                 plyr_[_pID].addr.transfer(_eth);    
609             
610             // build event data
611             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
612             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
613             
614             // fire withdraw and distribute event
615             emit J3Devents.onWithdrawAndDistribute
616             (
617                 msg.sender, 
618                 plyr_[_pID].name, 
619                 _eth, 
620                 _eventData_.compressedData, 
621                 _eventData_.compressedIDs, 
622                 _eventData_.winnerAddr, 
623                 _eventData_.winnerName, 
624                 _eventData_.amountWon, 
625                 _eventData_.newPot, 
626                 _eventData_.P3DAmount, 
627                 _eventData_.genAmount
628             );
629             
630         // in any other situation
631         } else {
632             // get their earnings
633             _eth = withdrawEarnings(_pID);
634             
635             // gib moni
636             if (_eth > 0)
637                 plyr_[_pID].addr.transfer(_eth);
638             
639             // fire withdraw event
640             emit J3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
641         }
642     }
643     
644     /**
645      * @dev use these to register names.  they are just wrappers that will send the
646      * registration requests to the PlayerBook contract.  So registering here is the 
647      * same as registering there.  UI will always display the last name you registered.
648      * but you will still own all previously registered names to use as affiliate 
649      * links.
650      * - must pay a registration fee.
651      * - name must be unique
652      * - names will be converted to lowercase
653      * - name cannot start or end with a space 
654      * - cannot have more than 1 space in a row
655      * - cannot be only numbers
656      * - cannot start with 0x 
657      * - name must be at least 1 char
658      * - max length of 32 characters long
659      * - allowed characters: a-z, 0-9, and space
660      * -functionhash- 0x921dec21 (using ID for affiliate)
661      * -functionhash- 0x3ddd4698 (using address for affiliate)
662      * -functionhash- 0x685ffd83 (using name for affiliate)
663      * @param _nameString players desired name
664      * @param _affCode affiliate ID, address, or name of who referred you
665      * @param _all set to true if you want this to push your info to all games 
666      * (this might cost a lot of gas)
667      */
668     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
669         isHuman()
670         public
671         payable
672     {
673         bytes32 _name = _nameString.nameFilter();
674         address _addr = msg.sender;
675         uint256 _paid = msg.value;
676         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
677         
678         uint256 _pID = pIDxAddr_[_addr];
679         
680         // fire event
681         emit J3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
682     }
683     
684     function registerNameXaddr(string _nameString, address _affCode, bool _all)
685         isHuman()
686         public
687         payable
688     {
689         bytes32 _name = _nameString.nameFilter();
690         address _addr = msg.sender;
691         uint256 _paid = msg.value;
692         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
693         
694         uint256 _pID = pIDxAddr_[_addr];
695         
696         // fire event
697         emit J3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
698     }
699     
700     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
701         isHuman()
702         public
703         payable
704     {
705         bytes32 _name = _nameString.nameFilter();
706         address _addr = msg.sender;
707         uint256 _paid = msg.value;
708         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
709         
710         uint256 _pID = pIDxAddr_[_addr];
711         
712         // fire event
713         emit J3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
714     }
715 //==============================================================================
716 //     _  _ _|__|_ _  _ _  .
717 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
718 //=====_|=======================================================================
719     /**
720      * @dev return the price buyer will pay for next 1 individual key.
721      * -functionhash- 0x018a25e8
722      * @return price for next key bought (in wei format)
723      */
724     function getBuyPrice()
725         public 
726         view 
727         returns(uint256)
728     {  
729         // setup local rID
730         uint256 _rID = rID_;
731         
732         // grab time
733         uint256 _now = now;
734         
735         // are we in a round?
736         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
737             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
738         else // rounds over.  need price for new round
739             return ( 75000000000000 ); // init
740     }
741     
742     /**
743      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
744      * provider
745      * -functionhash- 0xc7e284b8
746      * @return time left in seconds
747      */
748     function getTimeLeft()
749         public
750         view
751         returns(uint256)
752     {
753         // setup local rID
754         uint256 _rID = rID_;
755         
756         // grab time
757         uint256 _now = now;
758         
759         if (_now < round_[_rID].end)
760             if (_now > round_[_rID].strt + rndGap_)
761                 return( (round_[_rID].end).sub(_now) );
762             else
763                 return( (round_[_rID].strt + rndGap_).sub(_now) );
764         else
765             return(0);
766     }
767     
768     /**
769      * @dev returns player earnings per vaults 
770      * -functionhash- 0x63066434
771      * @return winnings vault
772      * @return general vault
773      * @return affiliate vault
774      */
775     function getPlayerVaults(uint256 _pID)
776         public
777         view
778         returns(uint256 ,uint256, uint256)
779     {
780         // setup local rID
781         uint256 _rID = rID_;
782         
783         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
784         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
785         {
786             // if player is winner 
787             if (round_[_rID].plyr == _pID)
788             {
789                 return
790                 (
791                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
792                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
793                     plyr_[_pID].aff
794                 );
795             // if player is not the winner
796             } else {
797                 return
798                 (
799                     plyr_[_pID].win,
800                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
801                     plyr_[_pID].aff
802                 );
803             }
804             
805         // if round is still going on, or round has ended and round end has been ran
806         } else {
807             return
808             (
809                 plyr_[_pID].win,
810                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
811                 plyr_[_pID].aff
812             );
813         }
814     }
815     
816     /**
817      * solidity hates stack limits.  this lets us avoid that hate 
818      */
819     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
820         private
821         view
822         returns(uint256)
823     {
824         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
825     }
826     
827     /**
828      * @dev returns all current round info needed for front end
829      * -functionhash- 0x747dff42
830      * @return eth invested during ICO phase
831      * @return round id 
832      * @return total keys for round 
833      * @return time round ends
834      * @return time round started
835      * @return current pot 
836      * @return current team ID & player ID in lead 
837      * @return current player in leads address 
838      * @return current player in leads name
839      * @return whales eth in for round
840      * @return bears eth in for round
841      * @return sneks eth in for round
842      * @return bulls eth in for round
843      * @return janPot
844      */
845     function getCurrentRoundInfo()
846         public
847         view
848         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
849     {
850         // setup local rID
851         uint256 _rID = rID_;
852         
853         return
854         (
855             round_[_rID].eth,               //0
856             _rID,                           //1
857             round_[_rID].keys,              //2
858             round_[_rID].end,               //3
859             round_[_rID].strt,              //4
860             round_[_rID].pot,               //5
861             round_[_rID].team,     			//6
862             round_[_rID].plyr,				//7
863             plyr_[round_[_rID].plyr].addr,  //8
864             plyr_[round_[_rID].plyr].name,  //9
865             rndTmEth_[_rID][0],             //10
866             rndTmEth_[_rID][1],             //11
867             rndTmEth_[_rID][2],             //12
868             janPot_                         //13
869         );
870     }
871     
872     function getCurrentPotInfo()
873     public
874     view
875     returns(uint256, uint256, uint256, uint256)
876     {
877     	// setup local rID
878         uint256 _rID = rID_;
879         
880         return
881         (
882             _rID,                           //0 the id of round
883             round_[_rID].pot,               //3 the pot value
884             round_[_rID].team,     			//4 last team value
885             janPot_  						//5 the jan pot
886         );
887     }
888 
889     /**
890      * @dev returns player info based on address.  if no address is given, it will 
891      * use msg.sender 
892      * -functionhash- 0xee0b5d8b
893      * @param _addr address of the player you want to lookup 
894      * @return player ID 
895      * @return player name
896      * @return keys owned (current round)
897      * @return winnings vault
898      * @return general vault 
899      * @return affiliate vault 
900 	 * @return player round eth
901      */
902     function getPlayerInfoByAddress(address _addr)
903         public 
904         view 
905         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
906     {
907         // setup local rID
908         uint256 _rID = rID_;
909         
910         if (_addr == address(0))
911         {
912             _addr == msg.sender;
913         }
914         uint256 _pID = pIDxAddr_[_addr];
915         
916         return
917         (
918             _pID,                               //0
919             plyr_[_pID].name,                   //1
920             plyrRnds_[_pID][_rID].keys,         //2
921             plyr_[_pID].win,                    //3
922             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
923             plyr_[_pID].aff,                    //5
924             plyrRnds_[_pID][_rID].eth           //6
925         );
926     }
927 
928 //==============================================================================
929 //     _ _  _ _   | _  _ . _  .
930 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
931 //=====================_|=======================================================
932     /**
933      * @dev logic runs whenever a buy order is executed.  determines how to handle 
934      * incoming eth depending on if we are in an active round or not
935      */
936     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, J3Ddatasets.EventReturns memory _eventData_)
937         private
938     {
939         // setup local rID
940         uint256 _rID = rID_;
941         
942         // grab time
943         uint256 _now = now;
944         
945         // if round is active
946         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
947         {
948             // call core 
949             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
950         // if round is not active     
951         } else {
952             // check to see if end round needs to be ran
953             if (_now > round_[_rID].end && round_[_rID].ended == false) 
954             {
955                 // end the round (distributes pot) & start new round
956 			    round_[_rID].ended = true;
957                 _eventData_ = endRound(_eventData_);
958                 
959                 // build event data
960                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
961                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
962                 
963                 // fire buy and distribute event 
964                 emit J3Devents.onBuyAndDistribute
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
989     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, J3Ddatasets.EventReturns memory _eventData_)
990         private
991     {
992         // setup local rID
993         uint256 _rID = rID_;
994         
995         // grab time
996         uint256 _now = now;
997         
998         // if round is active
999         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
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
1020             emit J3Devents.onReLoadAndDistribute
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
1036     /**
1037      * @dev this is the core logic for any buy/reload that happens while a round 
1038      * is live.
1039      */
1040     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, J3Ddatasets.EventReturns memory _eventData_)
1041         private
1042     {
1043     	//uint256 a = 1;
1044         // if player is new to round
1045         if (plyrRnds_[_pID][_rID].keys == 0)
1046             _eventData_ = managePlayer(_pID, _eventData_);
1047         
1048         // early round eth limiter 
1049         if (round_[_rID].eth < 50000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 2000000000000000000)
1050         {
1051             uint256 _availableLimit = (2000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1052             uint256 _refund = _eth.sub(_availableLimit);
1053             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1054             _eth = _availableLimit;
1055         }
1056         
1057         // if eth left is greater than min eth allowed (sorry no pocket lint)
1058         if (_eth > 1000000000) 
1059         {
1060             // mint the new keys
1061             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1062             
1063             // if they bought at least 1 whole key
1064             if (_keys >= 1000000000000000000)
1065             {
1066             	updateTimer(_keys, _rID);
1067 
1068 				if(janwin(round_[_rID].team,_team))
1069 				{
1070 					uint _janprice;
1071 					if (_eth >= 10000000000000000000)
1072                 	{
1073                     	// calculate prize and give it to winner
1074                     	_janprice = ((janPot_).mul(75)) / 100;
1075                     	plyr_[_pID].win = (plyr_[_pID].win).add(_janprice);
1076                     
1077                     	// adjust airDropPot 
1078                     	janPot_ = (janPot_).sub(_janprice);
1079                     
1080                     	// let event know a tier 3 prize was won 
1081                     	//_eventData_.compressedData += 300000000000000000000000000000000;
1082                 	} else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1083                     	// calculate prize and give it to winner
1084                     	_janprice = ((janPot_).mul(50)) / 100;
1085                     	plyr_[_pID].win = (plyr_[_pID].win).add(_janprice);
1086                     
1087                     	// adjust airDropPot 
1088                     	janPot_ = (janPot_).sub(_janprice);
1089                     
1090                     	// let event know a tier 2 prize was won 
1091                     	//_eventData_.compressedData += 200000000000000000000000000000000;
1092                 	} else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1093                     	// calculate prize and give it to winner
1094                     	_janprice = ((janPot_).mul(25)) / 100;
1095                     	plyr_[_pID].win = (plyr_[_pID].win).add(_janprice);
1096                     
1097                     	// adjust airDropPot 
1098                     	janPot_ = (janPot_).sub(_janprice);
1099                     
1100                     	// let event know a tier 3 prize was won 
1101                     	//_eventData_.compressedData += 300000000000000000000000000000000;
1102                 	}
1103                 	if(_janprice > 0){
1104                 		// fired whenever an janwin is paid
1105     					 emit J3Devents.onNewJanWin(
1106     					 	_rID,
1107     					 	_pID,
1108     					 	plyr_[_pID].addr,
1109     					 	plyr_[_pID].name,
1110     					 	_janprice,
1111     					 	now
1112     					 );
1113                 	}
1114                 	    
1115                 	
1116 				}
1117 
1118             	// set new leaders
1119             	if (round_[_rID].plyr != _pID)
1120                 	round_[_rID].plyr = _pID;  
1121             	if (round_[_rID].team != _team)
1122                 	round_[_rID].team = _team; 
1123             
1124             	// set the new leader bool to true
1125             	_eventData_.compressedData = _eventData_.compressedData + 100;
1126         	}
1127         	
1128 
1129             // store the air drop tracker number (number of buys since last airdrop)
1130             //_eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1131             
1132             // update player 
1133             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1134             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1135             
1136             // update round
1137             round_[_rID].keys = _keys.add(round_[_rID].keys);
1138             round_[_rID].eth = _eth.add(round_[_rID].eth);
1139             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1140     
1141             // distribute eth
1142             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1143 
1144             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1145             
1146             // call end tx function to fire end tx event.
1147 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1148         }
1149     }
1150 //==============================================================================
1151 //     _ _ | _   | _ _|_ _  _ _  .
1152 //    (_(_||(_|_||(_| | (_)| _\  .
1153 //==============================================================================
1154     /**
1155      * @dev calculates unmasked earnings (just calculates, does not update mask)
1156      * @return earnings in wei format
1157      */
1158     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1159         private
1160         view
1161         returns(uint256)
1162     {
1163         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1164     }
1165     
1166     /** 
1167      * @dev returns the amount of keys you would get given an amount of eth. 
1168      * -functionhash- 0xce89c80c
1169      * @param _rID round ID you want price for
1170      * @param _eth amount of eth sent in 
1171      * @return keys received 
1172      */
1173     function calcKeysReceived(uint256 _rID, uint256 _eth)
1174         public
1175         view
1176         returns(uint256)
1177     {
1178         // grab time
1179         uint256 _now = now;
1180         
1181         // are we in a round?
1182         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1183             return ( (round_[_rID].eth).keysRec(_eth) );
1184         else // rounds over.  need keys for new round
1185             return ( (_eth).keys() );
1186     }
1187     
1188     /** 
1189      * @dev returns current eth price for X keys.  
1190      * -functionhash- 0xcf808000
1191      * @param _keys number of keys desired (in 18 decimal format)
1192      * @return amount of eth needed to send
1193      */
1194     function iWantXKeys(uint256 _keys)
1195         public
1196         view
1197         returns(uint256)
1198     {
1199         // setup local rID
1200         uint256 _rID = rID_;
1201         
1202         // grab time
1203         uint256 _now = now;
1204         
1205         // are we in a round?
1206         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1207             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1208         else // rounds over.  need price for new round
1209             return ( (_keys).eth() );
1210     }
1211 //==============================================================================
1212 //    _|_ _  _ | _  .
1213 //     | (_)(_)|_\  .
1214 //==============================================================================
1215     /**
1216 	 * @dev receives name/player info from names contract 
1217      */
1218     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1219         external
1220     {
1221         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1222         if (pIDxAddr_[_addr] != _pID)
1223             pIDxAddr_[_addr] = _pID;
1224         if (pIDxName_[_name] != _pID)
1225             pIDxName_[_name] = _pID;
1226         if (plyr_[_pID].addr != _addr)
1227             plyr_[_pID].addr = _addr;
1228         if (plyr_[_pID].name != _name)
1229             plyr_[_pID].name = _name;
1230         if (plyr_[_pID].laff != _laff)
1231             plyr_[_pID].laff = _laff;
1232         if (plyrNames_[_pID][_name] == false)
1233             plyrNames_[_pID][_name] = true;
1234     }
1235     
1236     /**
1237      * @dev receives entire player name list 
1238      */
1239     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1240         external
1241     {
1242         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1243         if(plyrNames_[_pID][_name] == false)
1244             plyrNames_[_pID][_name] = true;
1245     }   
1246         
1247     /**
1248      * @dev gets existing or registers new pID.  use this when a player may be new
1249      * @return pID 
1250      */
1251     function determinePID(J3Ddatasets.EventReturns memory _eventData_)
1252         private
1253         returns (J3Ddatasets.EventReturns)
1254     {
1255         uint256 _pID = pIDxAddr_[msg.sender];
1256         // if player is new to this version of jkp
1257         if (_pID == 0)
1258         {
1259             // grab their player ID, name and last aff ID, from player names contract 
1260             _pID = PlayerBook.getPlayerID(msg.sender);
1261             bytes32 _name = PlayerBook.getPlayerName(_pID);
1262             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1263             
1264             // set up player account 
1265             pIDxAddr_[msg.sender] = _pID;
1266             plyr_[_pID].addr = msg.sender;
1267             
1268             if (_name != "")
1269             {
1270                 pIDxName_[_name] = _pID;
1271                 plyr_[_pID].name = _name;
1272                 plyrNames_[_pID][_name] = true;
1273             }
1274             
1275             if (_laff != 0 && _laff != _pID)
1276                 plyr_[_pID].laff = _laff;
1277             
1278             // set the new player bool to true
1279             _eventData_.compressedData = _eventData_.compressedData + 1;
1280         } 
1281         return (_eventData_);
1282     }
1283     
1284     /**
1285      * @dev checks to make sure user picked a valid team.  if not sets team 
1286      * to default (sneks)
1287      */
1288     function verifyTeam(uint256 _team)
1289         private
1290         view
1291         returns (uint256)
1292     {
1293         if (_team < 0 || _team > 2){
1294             uint256 seed = uint256(keccak256(abi.encodePacked(
1295             
1296             (block.timestamp).add
1297             (block.difficulty).add
1298             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1299             (block.gaslimit).add
1300             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1301             (block.number)
1302             
1303         )));
1304             
1305         _team = (seed - ((seed / 3) * 3));
1306         }
1307         return(_team);
1308     }
1309     
1310     /**
1311      * @dev decides if round end needs to be run & new round started.  and if 
1312      * player unmasked earnings from previously played rounds need to be moved.
1313      */
1314     function managePlayer(uint256 _pID, J3Ddatasets.EventReturns memory _eventData_)
1315         private
1316         returns (J3Ddatasets.EventReturns)
1317     {
1318         // if player has played a previous round, move their unmasked earnings
1319         // from that round to gen vault.
1320         if (plyr_[_pID].lrnd != 0)
1321             updateGenVault(_pID, plyr_[_pID].lrnd);
1322             
1323         // update player's last round played
1324         plyr_[_pID].lrnd = rID_;
1325             
1326         // set the joined round bool to true
1327         _eventData_.compressedData = _eventData_.compressedData + 10;
1328         
1329         return(_eventData_);
1330     }
1331     
1332     /**
1333      * @dev ends the round. manages paying out winner/splitting up pot
1334      * J3Ddatasets.PotSplit(40,0);  //50% to winner, 0% to next round, 10% to com
1335      */
1336     function endRound(J3Ddatasets.EventReturns memory _eventData_)
1337         private
1338         returns (J3Ddatasets.EventReturns)
1339     {
1340         // setup local rID
1341         uint256 _rID = rID_;
1342         
1343         // grab our winning player and team id's
1344         uint256 _winPID = round_[_rID].plyr;
1345         uint256 _winTID = round_[_rID].team;
1346         
1347         // grab our pot amount
1348         uint256 _pot = round_[_rID].pot;
1349         
1350         // calculate our winner share, community rewards, gen share, 
1351         // p3d share, and amount reserved for next pot 
1352         uint256 _win = (_pot.mul(potSplit_[_winTID].win)) / 100;
1353         uint256 _com = (_pot.mul(potSplit_[_winTID].com)) / 100;
1354         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1355         //uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1356         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));//.sub(_p3d);
1357         
1358         // calculate ppt for round mask
1359         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1360         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1361         if (_dust > 0)
1362         {
1363             _gen = _gen.sub(_dust);
1364             _res = _res.add(_dust);
1365         }
1366         
1367         // pay our winner
1368         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1369         
1370         if(janPot_ > 0){
1371         	_com = _com.add(janPot_);
1372         	janPot_ = 0;
1373         }
1374         
1375         // community rewards
1376         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1377         {
1378             // This ensures Team Just cannot influence the outcome of JKP with
1379             // bank migrations by breaking outgoing transactions.
1380             // Something we would never do. But that's not the point.
1381             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1382             // highest belief that everything we create should be trustless.
1383             // Team JUST, The name you shouldn't have to trust.
1384             //_p3d = _p3d.add(_com);
1385             _res = _res.add(_com);
1386             _com = 0;
1387         }
1388         
1389         // distribute gen portion to key holders
1390         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1391         
1392         // send share for p3d to divies
1393         //if (_p3d > 0)
1394         //    Divies.deposit.value(_p3d)();
1395             
1396         // prepare event data
1397         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1398         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1399         _eventData_.winnerAddr = plyr_[_winPID].addr;
1400         _eventData_.winnerName = plyr_[_winPID].name;
1401         _eventData_.amountWon = _win;
1402         _eventData_.genAmount = _gen;
1403         //_eventData_.P3DAmount = _p3d;
1404         _eventData_.newPot = _res;
1405         
1406         // start next round
1407         rID_++;
1408         _rID++;
1409         round_[_rID].strt = now;
1410         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1411         round_[_rID].pot = _res;
1412         
1413         return(_eventData_);
1414     }
1415     
1416     /**
1417      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1418      */
1419     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1420         private 
1421     {
1422         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1423         if (_earnings > 0)
1424         {
1425             // put in gen vault
1426             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1427             // zero out their earnings by updating mask
1428             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1429         }
1430     }
1431     
1432     /**
1433      * @dev updates round timer based on number of whole keys bought.
1434      */
1435     function updateTimer(uint256 _keys, uint256 _rID)
1436         private
1437     {
1438         // grab time
1439         uint256 _now = now;
1440         
1441         // calculate time based on number of keys bought
1442         uint256 _newTime;
1443         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1444             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1445         else
1446             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1447         
1448         // compare to max and set new end time
1449         if (_newTime < (rndMax_).add(_now))
1450             round_[_rID].end = _newTime;
1451         else
1452             round_[_rID].end = rndMax_.add(_now);
1453     }
1454     
1455     function janwin(uint256 team1,uint256 team2)
1456     private
1457     pure
1458     returns(bool){
1459     	if(team2 == 0 && team1 == 1){
1460     		return true;
1461     	}
1462     	else if(team2 == 1 && team1 == 2 ){
1463     		return true;
1464     	}
1465     	else if(team2 == 2 && team1 == 0 ){
1466     		return true;
1467     	}
1468     	return false;
1469     }
1470     
1471     function randomTeam()
1472     public 
1473     view
1474     returns(uint256){
1475     	uint256 seed = uint256(keccak256(abi.encodePacked(
1476             
1477             (block.timestamp).add
1478             (block.difficulty).add
1479             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1480             (block.gaslimit).add
1481             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1482             (block.number)
1483             
1484         )));
1485             
1486         return (seed - ((seed / 3) * 3));
1487     }
1488     
1489 
1490     /**
1491      * @dev distributes eth based on fees to com, aff, and p3d
1492      * fees_[0] = J3Ddatasets.TeamFee(50,0);   //30% to pot, 10% to aff, 5% to com, 4% to pot Jan, 1% to air drop pot
1493      */
1494     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, J3Ddatasets.EventReturns memory _eventData_)
1495         private
1496         returns(J3Ddatasets.EventReturns)
1497     {
1498         // pay 2% out to community rewards
1499         uint256 _com = _eth.mul(fees_[_team].com) / 100;
1500         //uint256 _p3d;
1501         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1502         {
1503             // This ensures Team Just cannot influence the outcome of JKP with
1504             // bank migrations by breaking outgoing transactions.
1505             // Something we would never do. But that's not the point.
1506             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1507             // highest belief that everything we create should be trustless.
1508             // Team JUST, The name you shouldn't have to trust.
1509             //_p3d = _com;
1510             round_[rID_].pot = round_[rID_].pot.add(_com);
1511             _com = 0;
1512         }
1513         
1514         // pay 1% out to pot jan short
1515         //uint256 _long = _eth / 100;
1516         //otherF3D_.potSwap.value(_long)();
1517         
1518         // distribute share to affiliate
1519         uint256 _aff = _eth.mul(fees_[_team].aff) / 100;
1520         
1521         // decide what to do with affiliate share of fees
1522         // affiliate must not be self, and must have a name registered
1523         if (_affID != _pID && plyr_[_affID].name != '') {
1524             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1525             emit J3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1526         } else {
1527         	// if no affiliate add it to pot
1528         	round_[rID_].pot = round_[rID_].pot.add(_aff);
1529             //_p3d = _aff;
1530         }
1531         
1532         // pay out p3d
1533         //_p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1534         //_p3d = 0;
1535         //if (_p3d > 0)
1536         //{
1537             // deposit to divies contract
1538             //Divies.deposit.value(_p3d)();
1539             
1540             // set up event data
1541         //    _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1542         //}
1543         
1544         return(_eventData_);
1545     }
1546     
1547     function potSwap()
1548         external
1549         payable
1550     {
1551         // setup local rID
1552         uint256 _rID = rID_ + 1;
1553         
1554         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1555         emit J3Devents.onPotSwapDeposit(_rID, msg.value);
1556     }
1557     
1558     /**
1559      * @dev distributes eth based on fees to gen and pot
1560      * fees_[0] = J3Ddatasets.TeamFee(50,0);   //30% to pot, 10% to aff, 5% to com, 4% to pot Jan, 1% to air drop pot
1561      */
1562     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, J3Ddatasets.EventReturns memory _eventData_)
1563         private
1564         returns(J3Ddatasets.EventReturns)
1565     {
1566         // calculate gen share
1567         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1568         
1569         // into airdrop pot 
1570         //uint256 _air = (_eth / 100);
1571         //airDropPot_ = airDropPot_.add(_air);
1572         
1573         // to janPot
1574         uint256 _jan = (_eth.mul(fees_[_team].jan)) / 100;
1575         janPot_ = janPot_.add(_jan);
1576         
1577         // update eth balance (eth = eth - (com share + jan pot share + aff share + p3d share + airdrop pot share))
1578         //_eth = _eth.sub(((_eth.mul(20)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1579         _eth = _eth.sub((_eth.mul(fees_[_team].com + fees_[_team].aff + fees_[_team].jan)) / 100);
1580         // calculate pot 
1581         uint256 _pot = _eth.sub(_gen);
1582         
1583         // distribute gen share (thats what updateMasks() does) and adjust
1584         // balances for dust.
1585         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1586         if (_dust > 0)
1587             _gen = _gen.sub(_dust);
1588         
1589         // add eth to pot
1590         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1591         
1592         // set up event data
1593         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1594         _eventData_.potAmount = _pot;
1595         
1596         return(_eventData_);
1597     }
1598 
1599     /**
1600      * @dev updates masks for round and player when keys are bought
1601      * @return dust left over 
1602      */
1603     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1604         private
1605         returns(uint256)
1606     {
1607         /* MASKING NOTES
1608             earnings masks are a tricky thing for people to wrap their minds around.
1609             the basic thing to understand here.  is were going to have a global
1610             tracker based on profit per share for each round, that increases in
1611             relevant proportion to the increase in share supply.
1612             
1613             the player will have an additional mask that basically says "based
1614             on the rounds mask, my shares, and how much i've already withdrawn,
1615             how much is still owed to me?"
1616         */
1617         
1618         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1619         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1620         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1621             
1622         // calculate player earning from their own buy (only based on the keys
1623         // they just bought).  & update player earnings mask
1624         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1625         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1626         
1627         // calculate & return dust
1628         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1629     }
1630     
1631     /**
1632      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1633      * @return earnings in wei format
1634      */
1635     function withdrawEarnings(uint256 _pID)
1636         private
1637         returns(uint256)
1638     {
1639         // update gen vault
1640         updateGenVault(_pID, plyr_[_pID].lrnd);
1641         
1642         // from vaults 
1643         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1644         if (_earnings > 0)
1645         {
1646             plyr_[_pID].win = 0;
1647             plyr_[_pID].gen = 0;
1648             plyr_[_pID].aff = 0;
1649         }
1650 
1651         return(_earnings);
1652     }
1653     
1654     /**
1655      * @dev prepares compression data and fires event for buy or reload tx's
1656      */
1657     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, J3Ddatasets.EventReturns memory _eventData_)
1658         private
1659     {
1660         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1661         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1662         
1663         emit J3Devents.onEndTx
1664         (
1665             _eventData_.compressedData,
1666             _eventData_.compressedIDs,
1667             plyr_[_pID].name,
1668             msg.sender,
1669             _eth,
1670             _keys,
1671             _eventData_.winnerAddr,
1672             _eventData_.winnerName,
1673             _eventData_.amountWon,
1674             _eventData_.newPot,
1675             _eventData_.P3DAmount,
1676             _eventData_.genAmount,
1677             _eventData_.potAmount,
1678             janPot_
1679         );
1680     }
1681 //==============================================================================
1682 //    (~ _  _    _._|_    .
1683 //    _)(/_(_|_|| | | \/  .
1684 //====================/=========================================================
1685     /** upon contract deploy, it will be deactivated.  this is a one time
1686      * use function that will activate the contract.  we do this so devs 
1687      * have time to set things up on the web end                            **/
1688     bool public activated_ = false;
1689     function activate()
1690         public
1691     {
1692         // only team can activate 
1693         require(
1694         	msg.sender == 0x189a9E570DAFbCEB2417f177be8448B6aa3126f7 ||
1695         	msg.sender == 0x3fbF05B1035ACBe87E4931ad143FeeC3BeCaD348 ,
1696             "only team just can activate"
1697         );
1698         
1699         // can only be ran once
1700         require(activated_ == false, "jkp already activated");
1701         
1702         // activate the contract 
1703         activated_ = true;
1704         
1705         // lets start first round
1706 		rID_ = 1;
1707         round_[1].strt = now + rndExtra_ - rndGap_;
1708         round_[1].end = now + rndInit_ + rndExtra_;
1709     }
1710     
1711     function setGasPriceLimit(uint256 priceLimit)
1712     public
1713     {
1714         // only team can change gas price limit 
1715         require(
1716         	msg.sender == 0x189a9E570DAFbCEB2417f177be8448B6aa3126f7 ||
1717         	msg.sender == 0x3fbF05B1035ACBe87E4931ad143FeeC3BeCaD348 ,
1718             "only team just can activate"
1719         );
1720     	gasPriceLimit_ = priceLimit;
1721     }
1722     
1723 }
1724 
1725 
1726 library SafeMath {
1727     
1728     /**
1729     * @dev Multiplies two numbers, throws on overflow.
1730     */
1731     function mul(uint256 a, uint256 b) 
1732         internal 
1733         pure 
1734         returns (uint256 c) 
1735     {
1736         if (a == 0) {
1737             return 0;
1738         }
1739         c = a * b;
1740         require(c / a == b, "SafeMath mul failed");
1741         return c;
1742     }
1743 
1744     /**
1745     * @dev Integer division of two numbers, truncating the quotient.
1746     */
1747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1748         // assert(b > 0); // Solidity automatically throws when dividing by 0
1749         uint256 c = a / b;
1750         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1751         return c;
1752     }
1753     
1754     /**
1755     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1756     */
1757     function sub(uint256 a, uint256 b)
1758         internal
1759         pure
1760         returns (uint256) 
1761     {
1762         require(b <= a, "SafeMath sub failed");
1763         return a - b;
1764     }
1765 
1766     /**
1767     * @dev Adds two numbers, throws on overflow.
1768     */
1769     function add(uint256 a, uint256 b)
1770         internal
1771         pure
1772         returns (uint256 c) 
1773     {
1774         c = a + b;
1775         require(c >= a, "SafeMath add failed");
1776         return c;
1777     }
1778     
1779     /**
1780      * @dev gives square root of given x.
1781      */
1782     function sqrt(uint256 x)
1783         internal
1784         pure
1785         returns (uint256 y) 
1786     {
1787         uint256 z = ((add(x,1)) / 2);
1788         y = x;
1789         while (z < y) 
1790         {
1791             y = z;
1792             z = ((add((x / z),z)) / 2);
1793         }
1794     }
1795     
1796     /**
1797      * @dev gives square. multiplies x by x
1798      */
1799     function sq(uint256 x)
1800         internal
1801         pure
1802         returns (uint256)
1803     {
1804         return (mul(x,x));
1805     }
1806     
1807     /**
1808      * @dev x to the power of y 
1809      */
1810     function pwr(uint256 x, uint256 y)
1811         internal 
1812         pure 
1813         returns (uint256)
1814     {
1815         if (x==0)
1816             return (0);
1817         else if (y==0)
1818             return (1);
1819         else 
1820         {
1821             uint256 z = x;
1822             for (uint256 i=1; i < y; i++)
1823                 z = mul(z,x);
1824             return (z);
1825         }
1826     }
1827 }
1828 library UintCompressor {
1829     using SafeMath for *;
1830     
1831     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
1832         internal
1833         pure
1834         returns(uint256)
1835     {
1836         // check conditions 
1837         require(_end < 77 && _start < 77, "start/end must be less than 77");
1838         require(_end >= _start, "end must be >= start");
1839         
1840         // format our start/end points
1841         _end = exponent(_end).mul(10);
1842         _start = exponent(_start);
1843         
1844         // check that the include data fits into its segment 
1845         require(_include < (_end / _start));
1846         
1847         // build middle
1848         if (_include > 0)
1849             _include = _include.mul(_start);
1850         
1851         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
1852     }
1853     
1854     function extract(uint256 _input, uint256 _start, uint256 _end)
1855 	    internal
1856 	    pure
1857 	    returns(uint256)
1858     {
1859         // check conditions
1860         require(_end < 77 && _start < 77, "start/end must be less than 77");
1861         require(_end >= _start, "end must be >= start");
1862         
1863         // format our start/end points
1864         _end = exponent(_end).mul(10);
1865         _start = exponent(_start);
1866         
1867         // return requested section
1868         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
1869     }
1870     
1871     function exponent(uint256 _position)
1872         private
1873         pure
1874         returns(uint256)
1875     {
1876         return((10).pwr(_position));
1877     }
1878 }
1879 
1880 library NameFilter {
1881     /**
1882      * @dev filters name strings
1883      * -converts uppercase to lower case.  
1884      * -makes sure it does not start/end with a space
1885      * -makes sure it does not contain multiple spaces in a row
1886      * -cannot be only numbers
1887      * -cannot start with 0x 
1888      * -restricts characters to A-Z, a-z, 0-9, and space.
1889      * @return reprocessed string in bytes32 format
1890      */
1891     function nameFilter(string _input)
1892         internal
1893         pure
1894         returns(bytes32)
1895     {
1896         bytes memory _temp = bytes(_input);
1897         uint256 _length = _temp.length;
1898         
1899         //sorry limited to 32 characters
1900         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1901         // make sure it doesnt start with or end with space
1902         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1903         // make sure first two characters are not 0x
1904         if (_temp[0] == 0x30)
1905         {
1906             require(_temp[1] != 0x78, "string cannot start with 0x");
1907             require(_temp[1] != 0x58, "string cannot start with 0X");
1908         }
1909         
1910         // create a bool to track if we have a non number character
1911         bool _hasNonNumber;
1912         
1913         // convert & check
1914         for (uint256 i = 0; i < _length; i++)
1915         {
1916             // if its uppercase A-Z
1917             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1918             {
1919                 // convert to lower case a-z
1920                 _temp[i] = byte(uint(_temp[i]) + 32);
1921                 
1922                 // we have a non number
1923                 if (_hasNonNumber == false)
1924                     _hasNonNumber = true;
1925             } else {
1926                 require
1927                 (
1928                     // require character is a space
1929                     _temp[i] == 0x20 || 
1930                     // OR lowercase a-z
1931                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1932                     // or 0-9
1933                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1934                     "string contains invalid characters"
1935                 );
1936                 // make sure theres not 2x spaces in a row
1937                 if (_temp[i] == 0x20)
1938                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1939                 
1940                 // see if we have a character other than a number
1941                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1942                     _hasNonNumber = true;    
1943             }
1944         }
1945         
1946         require(_hasNonNumber == true, "string cannot be only numbers");
1947         
1948         bytes32 _ret;
1949         assembly {
1950             _ret := mload(add(_temp, 32))
1951         }
1952         return (_ret);
1953     }
1954 }
1955 
1956 library J3DKeysCalcLong {
1957     using SafeMath for *;
1958     /**
1959      * @dev calculates number of keys received given X eth 
1960      * @param _curEth current amount of eth in contract 
1961      * @param _newEth eth being spent
1962      * @return amount of ticket purchased
1963      */
1964     function keysRec(uint256 _curEth, uint256 _newEth)
1965         internal
1966         pure
1967         returns (uint256)
1968     {
1969         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1970     }
1971     
1972     /**
1973      * @dev calculates amount of eth received if you sold X keys 
1974      * @param _curKeys current amount of keys that exist 
1975      * @param _sellKeys amount of keys you wish to sell
1976      * @return amount of eth received
1977      */
1978     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1979         internal
1980         pure
1981         returns (uint256)
1982     {
1983         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1984     }
1985 
1986     /**
1987      * @dev calculates how many keys would exist with given an amount of eth
1988      * @param _eth eth "in contract"
1989      * @return number of keys that would exist
1990      */
1991     function keys(uint256 _eth) 
1992         internal
1993         pure
1994         returns(uint256)
1995     {
1996         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1997     }
1998     
1999     /**
2000      * @dev calculates how much eth would be in contract given a number of keys
2001      * @param _keys number of keys "in contract" 
2002      * @return eth that would exists
2003      */
2004     function eth(uint256 _keys) 
2005         internal
2006         pure
2007         returns(uint256)  
2008     {
2009         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
2010     }
2011 }
2012 
2013 
2014 library J3Ddatasets {
2015     //compressedData key
2016     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
2017         // 0 - new player (bool)
2018         // 1 - joined round (bool)
2019         // 2 - new  leader (bool)
2020         // 3-5 - air drop tracker (uint 0-999)
2021         // 6-16 - round end time
2022         // 17 - winnerTeam
2023         // 18 - 28 timestamp 
2024         // 29 - team
2025         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
2026         // 31 - airdrop happened bool
2027         // 32 - airdrop tier 
2028         // 33 - airdrop amount won
2029     //compressedIDs key
2030     // [77-52][51-26][25-0]
2031         // 0-25 - pID 
2032         // 26-51 - winPID
2033         // 52-77 - rID
2034     struct EventReturns {
2035         uint256 compressedData;
2036         uint256 compressedIDs;
2037         address winnerAddr;         // winner address
2038         bytes32 winnerName;         // winner name
2039         uint256 amountWon;          // amount won
2040         uint256 newPot;             // amount in new pot
2041         uint256 P3DAmount;          // amount distributed to p3d
2042         uint256 genAmount;          // amount distributed to gen
2043         uint256 potAmount;          // amount added to pot
2044     }
2045     struct Player {
2046         address addr;   // player address
2047         bytes32 name;   // player name
2048         uint256 win;    // winnings vault
2049         uint256 gen;    // general vault
2050         uint256 aff;    // affiliate vault
2051         uint256 lrnd;   // last round played
2052         uint256 laff;   // last affiliate id used
2053     }
2054     struct PlayerRounds {
2055         uint256 eth;    // eth player has added to round (used for eth limiter)
2056         uint256 keys;   // keys
2057         uint256 mask;   // player mask 
2058         uint256 ico;    // ICO phase investment
2059     }
2060     struct Round {
2061         uint256 plyr;   // pID of player in lead
2062         uint256 team;   // tID of team in lead
2063         uint256 end;    // time ends/ended
2064         bool ended;     // has round end function been ran
2065         uint256 strt;   // time round started
2066         uint256 keys;   // keys
2067         uint256 eth;    // total eth in
2068         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
2069         uint256 mask;   // global mask
2070         uint256 ico;    // total eth sent in during ICO phase
2071         uint256 icoGen; // total eth for gen during ICO phase
2072         uint256 icoAvg; // average key price for ICO phase
2073     }
2074     struct TeamFee {
2075         uint256 gen;    // % of buy in thats paid to key holders of current round
2076         uint256 pot;    // % of buy in thats paid to p3d holders
2077         uint256 aff;
2078         uint256 jan;
2079         uint256 com;
2080     }
2081     struct PotSplit {
2082         uint256 gen;    // % of pot thats paid to key holders of current round
2083         uint256 win;    // % of pot thats paid to p3d holders
2084         uint256 next;
2085         uint256 com;
2086     }
2087 }