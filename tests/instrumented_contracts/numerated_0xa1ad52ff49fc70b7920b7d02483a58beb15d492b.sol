1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
4     // fired whenever a player registers a name
5     event onNewName
6     (
7         uint256 indexed playerID,
8         address indexed playerAddress,
9         bytes32 indexed playerName,
10         bool isNewPlayer,
11         uint256 affiliateID,
12         address affiliateAddress,
13         bytes32 affiliateName,
14         uint256 amountPaid,
15         uint256 timeStamp
16     );
17     
18     // fired at end of buy or reload
19     event onEndTx
20     (
21         uint256 compressedData,     
22         uint256 compressedIDs,      
23         bytes32 playerName,
24         address playerAddress,
25         uint256 ethIn,
26         uint256 keysBought,
27         address winnerAddr,
28         bytes32 winnerName,
29         uint256 amountWon,
30         uint256 newPot,
31         uint256 P3DAmount,
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
59         uint256 P3DAmount,
60         uint256 genAmount
61     );
62     
63     // (fomo3d long only) fired whenever a player tries a buy after round timer 
64     // hit zero, and causes end round to be ran.
65     event onBuyAndDistribute
66     (
67         address playerAddress,
68         bytes32 playerName,
69         uint256 ethIn,
70         uint256 compressedData,
71         uint256 compressedIDs,
72         address winnerAddr,
73         bytes32 winnerName,
74         uint256 amountWon,
75         uint256 newPot,
76         uint256 P3DAmount,
77         uint256 genAmount
78     );
79     
80     // (fomo3d long only) fired whenever a player tries a reload after round timer 
81     // hit zero, and causes end round to be ran.
82     event onReLoadAndDistribute
83     (
84         address playerAddress,
85         bytes32 playerName,
86         uint256 compressedData,
87         uint256 compressedIDs,
88         address winnerAddr,
89         bytes32 winnerName,
90         uint256 amountWon,
91         uint256 newPot,
92         uint256 P3DAmount,
93         uint256 genAmount
94     );
95     
96     // fired whenever an affiliate is paid
97     event onAffiliatePayout
98     (
99         uint256 indexed affiliateID,
100         address affiliateAddress,
101         bytes32 affiliateName,
102         uint256 indexed roundID,
103         uint256 indexed buyerID,
104         uint256 amount,
105         uint256 timeStamp
106     );
107     
108     // received pot swap deposit
109     event onPotSwapDeposit
110     (
111         uint256 roundID,
112         uint256 amountAddedToPot
113     );
114     
115     event onAirPot(
116          uint256 roundID,
117          uint256 potType,
118          address winner,
119          uint256 prize
120     );
121 }
122 
123 //==============================================================================
124 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
125 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
126 //====================================|=========================================
127 
128 contract modularLong is F3Devents {}
129 
130 contract FoMo3Dlong is modularLong {
131     using SafeMath for *;
132     using NameFilter for string;
133     using F3DKeysCalcLong for uint256;
134 	
135 	  address private owner = 0x0c204d9C438553a107B29cdE1d1e7954673b29B3;
136 	  address private opAddress = 0x0c204d9C438553a107B29cdE1d1e7954673b29B3;
137 	  address private comAddress = 0x24D160101C72c035287f772a8ac2b744a477F489;
138   	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x0f717ffff71e639636fcdd33727ee8c17c4724bf);
139 
140 //==============================================================================
141 //     _ _  _  |`. _     _ _ |_ | _  _  .
142 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
143 //=================_|===========================================================
144     string constant public name = "FoMo3D Long Official";
145     string constant public symbol = "F3D";
146 	  uint256 private rndExtra_ = 0;//extSettings.getLongExtra();     // length of the very first ICO 
147     //uint256 private rndGap_ = 0 hours ;// extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
148     uint256 constant private rndInit_ = 2 hours;                // round timer starts at this
149     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
150     uint256 constant private rndMax_ = 2 hours;                // max length a round timer can be
151     uint256 constant private comDropGap_ = 24 hours; 
152     
153     uint256 constant private rndNTR_ = 168 hours;
154 //==============================================================================
155 //     _| _ _|_ _    _ _ _|_    _   .
156 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
157 //=============================|================================================
158 	  uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
159 	  uint256 public airDropPot2_;  
160     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
161     uint256 public airDropTracker2_ = 0;
162     uint256 public rID_;    // round id number / total rounds that have happened
163     uint256 public comReWards_;
164     uint256 public comAirDrop_;
165 //****************
166 // PLAYER DATA 
167 //****************
168     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
169     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
170     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
171     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
172     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
173     mapping (uint256 => uint256) public inviteCount_;
174     mapping (address => bool) public addrLock_; 
175 //****************
176 // ROUND DATA 
177 //****************
178     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
179     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
180     
181     mapping (uint256 => uint256[10]) public lastTen_;
182     mapping (uint256 => uint256) public roundBetCount_;
183     
184     //rId => team => datetime
185     mapping (uint256 => mapping (uint256 =>uint256)) public comDropLastTime_;
186 //****************
187 // TEAM FEE DATA 
188 //****************
189     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
190     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
191 //==============================================================================
192 //     _ _  _  __|_ _    __|_ _  _  .
193 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
194 //==============================================================================
195     constructor()
196         public
197     {
198 		// Team allocation structures
199         // 0 = whales
200         // 1 = bears
201         // 2 = sneks
202         // 3 = bulls
203 
204 		// Team allocation percentages
205         // (F3D, P3D) + (Pot , Referrals, Community)
206             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
207             //not p3d change to owner 20%
208         fees_[0] = F3Ddatasets.TeamFee(48,0);//(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
209         fees_[1] = F3Ddatasets.TeamFee(33,0);//(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
210         fees_[2] = F3Ddatasets.TeamFee(18,0);//(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
211        // fees_[3] = F3Ddatasets.TeamFee(51,0);//(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
212         
213         // how to split up the final pot based on which team was picked
214         // (F3D, P3D)
215         potSplit_[0] = F3Ddatasets.PotSplit(10,20);//(15,10);  //48% to winner, 25% to next round, 2% to com
216         potSplit_[1] = F3Ddatasets.PotSplit(5,20);   //48% to winner, 25% to next round, 2% to com
217         potSplit_[2] = F3Ddatasets.PotSplit(20,20);//(20,20);  //48% to winner, 10% to next round, 2% to com
218        // potSplit_[3] = F3Ddatasets.PotSplit(40,20);//(30,10);  //48% to winner, 10% to next round, 2% to com
219 	}
220 //==============================================================================
221 //     _ _  _  _|. |`. _  _ _  .
222 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
223 //==============================================================================
224     /**
225      * @dev used to make sure no one can interact with contract until it has 
226      * been activated. 
227      */
228     modifier isActivated() {
229         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
230         _;
231     }
232     
233     /**
234      * @dev prevents contracts from interacting with fomo3d 
235      */
236     modifier isHuman() {
237         address _addr = msg.sender;
238         uint256 _codeLength;
239         
240         assembly {_codeLength := extcodesize(_addr)}
241         require(_codeLength == 0, "sorry humans only");
242         _;
243     }
244 
245     /**
246      * @dev sets boundaries for incoming tx 
247      */
248     modifier isWithinLimits(uint256 _eth) {
249         require(_eth >= 1000000000, "pocket lint: not a valid currency");
250         require(_eth <= 100000000000000000000000, "no vitalik, no");
251         _;    
252     }
253     
254    /* modifier locked() {
255     	  require(!addrLock_[msg.sender],"this address is locked");
256     	  _; 
257     }*/
258     
259 //==============================================================================
260 //     _    |_ |. _   |`    _  __|_. _  _  _  .
261 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
262 //====|=========================================================================
263     /**
264      * @dev emergency buy uses last stored affiliate ID and team snek
265      */
266     function()
267         isActivated()
268         isHuman()
269         //locked()
270         isWithinLimits(msg.value)
271         public
272         payable
273     {
274         // set up our tx event data and determine if player is new or not
275         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
276             
277         // fetch player id
278         uint256 _pID = pIDxAddr_[msg.sender];
279         
280         // buy core 
281         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
282     }
283     
284     /**
285      * @dev converts all incoming ethereum to keys.
286      * -functionhash- 0x8f38f309 (using ID for affiliate)
287      * -functionhash- 0x98a0871d (using address for affiliate)
288      * -functionhash- 0xa65b37a1 (using name for affiliate)
289      * @param _affCode the ID/address/name of the player who gets the affiliate fee
290      * @param _team what team is the player playing for?
291      */
292     function buyXid(uint256 _affCode, uint256 _team)
293         isActivated()
294         isHuman()
295         //locked()
296         isWithinLimits(msg.value)
297         public
298         payable
299     {
300         // set up our tx event data and determine if player is new or not
301         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
302         
303         // fetch player id
304         uint256 _pID = pIDxAddr_[msg.sender];
305         
306         // manage affiliate residuals
307         // if no affiliate code was given or player tried to use their own, lolz
308         if (_affCode == 0 || _affCode == _pID)
309         {
310             // use last stored affiliate code 
311             _affCode = plyr_[_pID].laff;
312             
313         // if affiliate code was given & its not the same as previously stored 
314         } else if (_affCode != plyr_[_pID].laff) {
315             // update last affiliate 
316             plyr_[_pID].laff = _affCode;
317         }
318         
319         // verify a valid team was selected
320         _team = verifyTeam(_team);
321         
322         // buy core 
323         buyCore(_pID, _affCode, _team, _eventData_);
324     }
325     
326     function buyXaddr(address _affCode, uint256 _team)
327         isActivated()
328         isHuman()
329         //locked()
330         isWithinLimits(msg.value)
331         public
332         payable
333     {
334         // set up our tx event data and determine if player is new or not
335         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
336         
337         // fetch player id
338         uint256 _pID = pIDxAddr_[msg.sender];
339         
340         // manage affiliate residuals
341         uint256 _affID;
342         // if no affiliate code was given or player tried to use their own, lolz
343         if (_affCode == address(0) || _affCode == msg.sender)
344         {
345             // use last stored affiliate code
346             _affID = plyr_[_pID].laff;
347         
348         // if affiliate code was given    
349         } else {
350             // get affiliate ID from aff Code 
351             _affID = pIDxAddr_[_affCode];
352             
353             // if affID is not the same as previously stored 
354             if (_affID != plyr_[_pID].laff)
355             {
356                 // update last affiliate
357                 plyr_[_pID].laff = _affID;
358             }
359         }
360         
361         // verify a valid team was selected
362         _team = verifyTeam(_team);
363         
364         // buy core 
365         buyCore(_pID, _affID, _team, _eventData_);
366     }
367     
368     function buyXname(bytes32 _affCode, uint256 _team)
369         isActivated()
370         isHuman()
371         //locked()
372         isWithinLimits(msg.value)
373         public
374         payable
375     {
376         // set up our tx event data and determine if player is new or not
377         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
423         //locked()
424         isWithinLimits(_eth)
425         public
426     {
427         // set up our tx event data
428         F3Ddatasets.EventReturns memory _eventData_;
429         
430         // fetch player ID
431         uint256 _pID = pIDxAddr_[msg.sender];
432         
433         // manage affiliate residuals
434         // if no affiliate code was given or player tried to use their own, lolz
435         if (_affCode == 0 || _affCode == _pID)
436         {
437             // use last stored affiliate code 
438             _affCode = plyr_[_pID].laff;
439             
440         // if affiliate code was given & its not the same as previously stored 
441         } else if (_affCode != plyr_[_pID].laff) {
442             // update last affiliate 
443             plyr_[_pID].laff = _affCode;
444         }
445 
446         // verify a valid team was selected
447         _team = verifyTeam(_team);
448 
449         // reload core
450         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
451     }
452     
453     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
454         isActivated()
455         isHuman()
456         //locked()
457         isWithinLimits(_eth)
458         public
459     {
460         // set up our tx event data
461         F3Ddatasets.EventReturns memory _eventData_;
462         
463         // fetch player ID
464         uint256 _pID = pIDxAddr_[msg.sender];
465         
466         // manage affiliate residuals
467         uint256 _affID;
468         // if no affiliate code was given or player tried to use their own, lolz
469         if (_affCode == address(0) || _affCode == msg.sender)
470         {
471             // use last stored affiliate code
472             _affID = plyr_[_pID].laff;
473         
474         // if affiliate code was given    
475         } else {
476             // get affiliate ID from aff Code 
477             _affID = pIDxAddr_[_affCode];
478             
479             // if affID is not the same as previously stored 
480             if (_affID != plyr_[_pID].laff)
481             {
482                 // update last affiliate
483                 plyr_[_pID].laff = _affID;
484             }
485         }
486         
487         // verify a valid team was selected
488         _team = verifyTeam(_team);
489         
490         // reload core
491         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
492     }
493     
494     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
495         isActivated()
496         isHuman()
497         //locked()
498         isWithinLimits(_eth)
499         public
500     {
501         // set up our tx event data
502         F3Ddatasets.EventReturns memory _eventData_;
503         
504         // fetch player ID
505         uint256 _pID = pIDxAddr_[msg.sender];
506         
507         // manage affiliate residuals
508         uint256 _affID;
509         // if no affiliate code was given or player tried to use their own, lolz
510         if (_affCode == '' || _affCode == plyr_[_pID].name)
511         {
512             // use last stored affiliate code
513             _affID = plyr_[_pID].laff;
514         
515         // if affiliate code was given
516         } else {
517             // get affiliate ID from aff Code
518             _affID = pIDxName_[_affCode];
519             
520             // if affID is not the same as previously stored
521             if (_affID != plyr_[_pID].laff)
522             {
523                 // update last affiliate
524                 plyr_[_pID].laff = _affID;
525             }
526         }
527         
528         // verify a valid team was selected
529         _team = verifyTeam(_team);
530         
531         // reload core
532         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
533     }
534 
535     /**
536      * @dev withdraws all of your earnings.
537      * -functionhash- 0x3ccfd60b
538      */
539     function withdraw()
540         isActivated()
541         isHuman()
542         public
543     {
544         // setup local rID 
545         uint256 _rID = rID_;
546         
547         // grab time
548         uint256 _now = now;
549         
550         // fetch player ID
551         uint256 _pID = pIDxAddr_[msg.sender];
552         
553         // setup temp var for player eth
554         uint256 _eth;
555         
556         // check to see if round has ended and no one has run round end yet
557         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
558         {
559             // set up our tx event data
560             F3Ddatasets.EventReturns memory _eventData_;
561             
562             // end the round (distributes pot)
563 			round_[_rID].ended = true;
564             _eventData_ = endRound(_eventData_);
565             
566 			// get their earnings
567             _eth = withdrawEarnings(_pID);
568             
569             // gib moni
570             if (_eth > 0)
571                 plyr_[_pID].addr.transfer(_eth);    
572             
573             // build event data
574             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
575             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
576             
577             // fire withdraw and distribute event
578             emit F3Devents.onWithdrawAndDistribute
579             (
580                 msg.sender, 
581                 plyr_[_pID].name, 
582                 _eth, 
583                 _eventData_.compressedData, 
584                 _eventData_.compressedIDs, 
585                 _eventData_.winnerAddr, 
586                 _eventData_.winnerName, 
587                 _eventData_.amountWon, 
588                 _eventData_.newPot, 
589                 _eventData_.P3DAmount, 
590                 _eventData_.genAmount
591             );
592             
593         // in any other situation
594         } else {
595             // get their earnings
596             _eth = withdrawEarnings(_pID);
597             
598             // gib moni
599             if (_eth > 0)
600                 plyr_[_pID].addr.transfer(_eth);
601             
602             // fire withdraw event
603             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
604         }
605     }
606     
607     /**
608      * @dev use these to register names.  they are just wrappers that will send the
609      * registration requests to the PlayerBook contract.  So registering here is the 
610      * same as registering there.  UI will always display the last name you registered.
611      * but you will still own all previously registered names to use as affiliate 
612      * links.
613      * - must pay a registration fee.
614      * - name must be unique
615      * - names will be converted to lowercase
616      * - name cannot start or end with a space 
617      * - cannot have more than 1 space in a row
618      * - cannot be only numbers
619      * - cannot start with 0x 
620      * - name must be at least 1 char
621      * - max length of 32 characters long
622      * - allowed characters: a-z, 0-9, and space
623      * -functionhash- 0x921dec21 (using ID for affiliate)
624      * -functionhash- 0x3ddd4698 (using address for affiliate)
625      * -functionhash- 0x685ffd83 (using name for affiliate)
626      * @param _nameString players desired name
627      * @param _affCode affiliate ID, address, or name of who referred you
628      * @param _all set to true if you want this to push your info to all games 
629      * (this might cost a lot of gas)
630      */
631     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
632         isHuman()
633         public
634         payable
635     {
636         bytes32 _name = _nameString.nameFilter();
637         address _addr = msg.sender;
638         uint256 _paid = msg.value;
639         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
640         
641         uint256 _pID = pIDxAddr_[_addr];
642         
643         // fire event
644         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
645     }
646     
647     function registerNameXaddr(string _nameString, address _affCode, bool _all)
648         isHuman()
649         public
650         payable
651     {
652         bytes32 _name = _nameString.nameFilter();
653         address _addr = msg.sender;
654         uint256 _paid = msg.value;
655         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
656         
657         uint256 _pID = pIDxAddr_[_addr];
658         
659         // fire event
660         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
661     }
662     
663     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
664         isHuman()
665         public
666         payable
667     {
668         bytes32 _name = _nameString.nameFilter();
669         address _addr = msg.sender;
670         uint256 _paid = msg.value;
671         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
672         
673         uint256 _pID = pIDxAddr_[_addr];
674         
675         // fire event
676         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
677     }
678 //==============================================================================
679 //     _  _ _|__|_ _  _ _  .
680 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
681 //=====_|=======================================================================
682     /**
683      * @dev return the price buyer will pay for next 1 individual key.
684      * -functionhash- 0x018a25e8
685      * @return price for next key bought (in wei format)
686      */
687     function getBuyPrice()
688         public 
689         view 
690         returns(uint256)
691     {  
692         // setup local rID
693         uint256 _rID = rID_;
694         
695         // grab time
696         uint256 _now = now;
697         
698         // are we in a round?
699         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
700             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
701         else // rounds over.  need price for new round
702             return ( 75000000000000 ); // init
703     }
704     
705     /**
706      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
707      * provider
708      * -functionhash- 0xc7e284b8
709      * @return time left in seconds
710      */
711     function getTimeLeft()
712         public
713         view
714         returns(uint256)
715     {
716         // setup local rID
717         uint256 _rID = rID_;
718         
719         // grab time
720         uint256 _now = now;
721         
722         if (_now < round_[_rID].end)
723             if (_now > round_[_rID].strt )
724                 return( (round_[_rID].end).sub(_now) );
725             else
726                 return( (round_[_rID].strt ).sub(_now) );
727         else
728             return(0);
729     }
730     
731     /**
732      * @dev returns player earnings per vaults 
733      * -functionhash- 0x63066434
734      * @return winnings vault
735      * @return general vault
736      * @return affiliate vault
737      */
738     function getPlayerVaults(uint256 _pID)
739         public
740         view
741         returns(uint256 ,uint256, uint256)
742     {
743         // setup local rID
744         uint256 _rID = rID_;
745         
746         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
747         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
748         {
749             // if player is winner 
750             if (round_[_rID].plyr == _pID)
751             {
752                 return
753                 (
754                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
755                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
756                     plyr_[_pID].aff
757                 );
758             // if player is not the winner
759             } else {
760                 return
761                 (
762                     plyr_[_pID].win,
763                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
764                     plyr_[_pID].aff
765                 );
766             }
767             
768         // if round is still going on, or round has ended and round end has been ran
769         } else {
770             return
771             (
772                 plyr_[_pID].win,
773                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
774                 plyr_[_pID].aff
775             );
776         }
777     }
778     
779     /**
780      * solidity hates stack limits.  this lets us avoid that hate 
781      */
782     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
783         private
784         view
785         returns(uint256)
786     {
787         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
788     }
789     
790     /**
791      * @dev returns all current round info needed for front end
792      * -functionhash- 0x747dff42
793      * @return eth invested during ICO phase
794      * @return round id 
795      * @return total keys for round 
796      * @return time round ends
797      * @return time round started
798      * @return current pot 
799      * @return current team ID & player ID in lead 
800      * @return current player in leads address 
801      * @return current player in leads name
802      * @return whales eth in for round
803      * @return bears eth in for round
804      * @return sneks eth in for round
805      * @return bulls eth in for round
806      * @return airdrop tracker # & airdrop pot
807      */
808     function getCurrentRoundInfo()
809         public
810         view
811         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
812     {
813         // setup local rID
814         uint256 _rID = rID_;
815         
816         return
817         (
818             round_[_rID].ico,               //0
819             _rID,                           //1
820             round_[_rID].keys,              //2
821             round_[_rID].end,               //3
822             round_[_rID].strt,              //4
823             round_[_rID].pot,               //5
824             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
825             plyr_[round_[_rID].plyr].addr,  //7
826             plyr_[round_[_rID].plyr].name,  //8
827             rndTmEth_[_rID][0],             //9
828             rndTmEth_[_rID][1],             //10
829             rndTmEth_[_rID][2],             //11
830             rndTmEth_[_rID][3],             //12
831             airDropTracker_ + (airDropPot_ * 1000)              //13
832         );
833     }
834 
835     /**
836      * @dev returns player info based on address.  if no address is given, it will 
837      * use msg.sender 
838      * -functionhash- 0xee0b5d8b
839      * @param _addr address of the player you want to lookup 
840      * @return player ID 
841      * @return player name
842      * @return keys owned (current round)
843      * @return winnings vault
844      * @return general vault 
845      * @return affiliate vault 
846 	 * @return player round eth
847      */
848     function getPlayerInfoByAddress(address _addr)
849         public 
850         view 
851         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
852     {
853         // setup local rID
854         uint256 _rID = rID_;
855         
856         if (_addr == address(0))
857         {
858             _addr == msg.sender;
859         }
860         uint256 _pID = pIDxAddr_[_addr];
861         
862         return
863         (
864             _pID,                               //0
865             plyr_[_pID].name,                   //1
866             plyrRnds_[_pID][_rID].keys,         //2
867             plyr_[_pID].win,                    //3
868             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
869             plyr_[_pID].aff,                    //5
870             plyrRnds_[_pID][_rID].eth           //6
871         );
872     }
873 
874 //==============================================================================
875 //     _ _  _ _   | _  _ . _  .
876 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
877 //=====================_|=======================================================
878     /**
879      * @dev logic runs whenever a buy order is executed.  determines how to handle 
880      * incoming eth depending on if we are in an active round or not
881      */
882     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
883         private
884     {
885         // setup local rID
886         uint256 _rID = rID_;
887         
888         // grab time
889         uint256 _now = now;
890         
891         // if round is active
892         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
893         {
894             // call core 
895             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
896         
897         // if round is not active     
898         } else {
899             // check to see if end round needs to be ran
900             if (_now > round_[_rID].end && round_[_rID].ended == false) 
901             {
902                 // end the round (distributes pot) & start new round
903 			    round_[_rID].ended = true;
904                 _eventData_ = endRound(_eventData_);
905                 
906                 // build event data
907                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
908                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
909                 
910                 // fire buy and distribute event 
911                 emit F3Devents.onBuyAndDistribute
912                 (
913                     msg.sender, 
914                     plyr_[_pID].name, 
915                     msg.value, 
916                     _eventData_.compressedData, 
917                     _eventData_.compressedIDs, 
918                     _eventData_.winnerAddr, 
919                     _eventData_.winnerName, 
920                     _eventData_.amountWon, 
921                     _eventData_.newPot, 
922                     _eventData_.P3DAmount, 
923                     _eventData_.genAmount
924                 );
925             }
926             
927             // put eth in players vault 
928             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
929         }
930     }
931     
932     /**
933      * @dev logic runs whenever a reload order is executed.  determines how to handle 
934      * incoming eth depending on if we are in an active round or not 
935      */
936     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
937         private
938     {
939         // setup local rID
940         uint256 _rID = rID_;
941         
942         // grab time
943         uint256 _now = now;
944         
945         // if round is active
946         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
947         {
948             // get earnings from all vaults and return unused to gen vault
949             // because we use a custom safemath library.  this will throw if player 
950             // tried to spend more eth than they have.
951             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
952             
953             // call core 
954             core(_rID, _pID, _eth, _affID, _team, _eventData_);
955         
956         // if round is not active and end round needs to be ran   
957         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
958             // end the round (distributes pot) & start new round
959             round_[_rID].ended = true;
960             _eventData_ = endRound(_eventData_);
961                 
962             // build event data
963             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
964             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
965                 
966             // fire buy and distribute event 
967             emit F3Devents.onReLoadAndDistribute
968             (
969                 msg.sender, 
970                 plyr_[_pID].name, 
971                 _eventData_.compressedData, 
972                 _eventData_.compressedIDs, 
973                 _eventData_.winnerAddr, 
974                 _eventData_.winnerName, 
975                 _eventData_.amountWon, 
976                 _eventData_.newPot, 
977                 _eventData_.P3DAmount, 
978                 _eventData_.genAmount
979             );
980         }
981     }
982     
983     /**
984      * @dev this is the core logic for any buy/reload that happens while a round 
985      * is live.
986      */
987     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
988         private
989     {
990         // if player is new to round
991         if (plyrRnds_[_pID][_rID].keys == 0)
992             _eventData_ = managePlayer(_pID, _eventData_);
993         
994         // early round eth limiter 
995         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
996         {
997             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
998             uint256 _refund = _eth.sub(_availableLimit);
999             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1000             _eth = _availableLimit;
1001         }
1002         
1003         // if eth left is greater than min eth allowed (sorry no pocket lint)
1004         if (_eth > 1000000000) 
1005         {
1006             
1007             // mint the new keys
1008             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1009             
1010             // if they bought at least 1 whole key
1011             if (_keys >= 1000000000000000000)
1012             {
1013             updateTimer(_keys, _rID);
1014 
1015             // set new leaders
1016            // if (round_[_rID].plyr != _pID)
1017                 round_[_rID].plyr = _pID;  
1018            
1019             lastTen_[_rID][roundBetCount_[_rID] % 10] = _pID;
1020             roundBetCount_[_rID]++;
1021             
1022             if (round_[_rID].team != _team)
1023                 round_[_rID].team = _team; 
1024             
1025             // set the new leader bool to true
1026             _eventData_.compressedData = _eventData_.compressedData + 100;
1027         }
1028             
1029             // manage airdrops
1030             if (_eth >= 100000000000000000)
1031             {
1032             airDropTracker_++;
1033             if (airdrop() == true)
1034             {
1035                 // gib muni
1036                 uint256 _prize;
1037                 if (_eth >= 10000000000000000000)
1038                 {
1039                     // calculate prize and give it to winner
1040                     _prize = ((airDropPot_).mul(75)) / 100;
1041                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1042                     
1043                     // adjust airDropPot 
1044                     airDropPot_ = (airDropPot_).sub(_prize);
1045                     
1046                     // let event know a tier 3 prize was won 
1047                     _eventData_.compressedData += 300000000000000000000000000000000;
1048                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1049                     // calculate prize and give it to winner
1050                     _prize = ((airDropPot_).mul(50)) / 100;
1051                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1052                     
1053                     // adjust airDropPot 
1054                     airDropPot_ = (airDropPot_).sub(_prize);
1055                     
1056                     // let event know a tier 2 prize was won 
1057                     _eventData_.compressedData += 200000000000000000000000000000000;
1058                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1059                     // calculate prize and give it to winner
1060                     _prize = ((airDropPot_).mul(25)) / 100;
1061                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1062                     
1063                     // adjust airDropPot 
1064                     airDropPot_ = (airDropPot_).sub(_prize);
1065                     
1066                     // let event know a tier 3 prize was won 
1067                     _eventData_.compressedData += 300000000000000000000000000000000;
1068                 }
1069                 // set airdrop happened bool to true
1070                 _eventData_.compressedData += 10000000000000000000000000000000;
1071                 // let event know how much was won 
1072                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1073                 emit onAirPot(_rID,1,plyr_[_pID].addr,_prize);
1074                 // reset air drop tracker
1075                 airDropTracker_ = 0;
1076             }
1077         }
1078         
1079           if (_eth >= 500000000000000000 && round_[_rID].pot >=100000000000000000000){
1080               
1081               air2( _rID, _pID,  _affID);
1082               
1083           } 
1084           
1085           
1086           if(inviteCount_[_pID] >= 100 && (comDropLastTime_[_rID][_team] + comDropGap_) <= now){
1087              comDrop(_rID,_pID,_affID,_team);
1088           } 
1089     
1090             // store the air drop tracker number (number of buys since last airdrop)
1091             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1092             
1093             // update player 
1094             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1095             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1096             
1097             // update round
1098             round_[_rID].keys = _keys.add(round_[_rID].keys);
1099             round_[_rID].eth = _eth.add(round_[_rID].eth);
1100             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1101     
1102             // distribute eth
1103             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1104             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1105             
1106             // call end tx function to fire end tx event.
1107 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1108         }
1109     }
1110     
1111     function air2(uint256 _rID, uint256 _pID, uint256 _affID) private {
1112         // airDrop2
1113        // uint256 compressedData = 0;
1114         
1115             airDropTracker2_++;
1116             if (airdrop2() == true)
1117             {
1118                 // gib muni
1119                 uint256 _prize2;
1120                
1121                 // calculate prize and give it to winner
1122                 _prize2 = ((airDropPot2_).mul(50)) / 100;
1123                 plyr_[_pID].win = (plyr_[_pID].win).add(_prize2.mul(80) / 100);
1124                 
1125                 uint256 _affIDUp = plyr_[_affID].laff;
1126                 if (_affIDUp !=0 && _affIDUp != _pID && plyr_[_affIDUp].name != '') {
1127                 	  plyr_[_affIDUp].win = (plyr_[_affIDUp].win).add(_prize2.mul(20) / 100);	
1128                 }else{
1129                 	_prize2  = (_prize2.mul(80) / 100);
1130                 }
1131                     
1132                 // adjust airDropPot2 
1133                 airDropPot2_ = (airDropPot2_).sub(_prize2);
1134                     
1135                 // let event know a tier 3 prize was won 
1136               //  compressedData = 300000000000000000000000000000000;
1137                
1138                 // set airdrop happened bool to true
1139              //   compressedData += 10000000000000000000000000000000;
1140                 // let event know how much was won 
1141              //   compressedData += _prize2 * 1000000000000000000000000000000000;
1142                  emit onAirPot(_rID,2,plyr_[_pID].addr,_prize2);
1143                 // reset air drop tracker
1144                 airDropTracker2_ = 0;
1145             }
1146       //  return compressedData;
1147     }
1148     
1149     function comDrop(uint256 _rID, uint256 _pID, uint256 _affID, uint256 _team) private  {
1150     	// uint256 compressedData = 0;
1151     	  uint256 seed = uint256(keccak256(abi.encodePacked(
1152             (block.timestamp).add
1153             (block.difficulty).add
1154             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1155             (block.gaslimit).add
1156             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now))
1157             
1158         )));
1159         if((seed - ((seed / 100) * 100)) < 15){
1160             // calculate prize and give it to winner
1161             uint256 _prize3 = comAirDrop_ / 10;
1162             plyr_[_pID].win = (plyr_[_pID].win).add(_prize3.mul(2));
1163                 
1164             uint256 _affIDUp = plyr_[_affID].laff;
1165             if (_affIDUp !=0 && _affIDUp != _pID && plyr_[_affIDUp].name != '') {
1166                 plyr_[_affIDUp].win = (plyr_[_affIDUp].win).add(_prize3);	
1167                 _prize3  = _prize3.mul(3) ;
1168             }else{
1169                 _prize3  = _prize3.mul(2) ;
1170             }
1171             
1172             comAirDrop_	 = (comAirDrop_).sub(_prize3);
1173                     
1174             // let event know a tier 3 prize was won 
1175          //   compressedData = 300000000000000000000000000000000;
1176                
1177             // set airdrop happened bool to true
1178           //  compressedData += 10000000000000000000000000000000;
1179             // let event know how much was won 
1180           //  compressedData += _prize3 * 1000000000000000000000000000000000;
1181             
1182             emit onAirPot(_rID,3,plyr_[_pID].addr,_prize3);
1183             
1184             comDropLastTime_[_rID][_team] = now;
1185         }
1186     		
1187         
1188        // return compressedData;
1189     }
1190     
1191 //==============================================================================
1192 //     _ _ | _   | _ _|_ _  _ _  .
1193 //    (_(_||(_|_||(_| | (_)| _\  .
1194 //==============================================================================
1195     /**
1196      * @dev calculates unmasked earnings (just calculates, does not update mask)
1197      * @return earnings in wei format
1198      */
1199     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1200         private
1201         view
1202         returns(uint256)
1203     {
1204         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1205     }
1206     
1207     /** 
1208      * @dev returns the amount of keys you would get given an amount of eth. 
1209      * -functionhash- 0xce89c80c
1210      * @param _rID round ID you want price for
1211      * @param _eth amount of eth sent in 
1212      * @return keys received 
1213      */
1214     function calcKeysReceived(uint256 _rID, uint256 _eth)
1215         public
1216         view
1217         returns(uint256)
1218     {
1219         // grab time
1220         uint256 _now = now;
1221         
1222         // are we in a round?
1223         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1224             return ( (round_[_rID].eth).keysRec(_eth) );
1225         else // rounds over.  need keys for new round
1226             return ( (_eth).keys() );
1227     }
1228     
1229     /** 
1230      * @dev returns current eth price for X keys.  
1231      * -functionhash- 0xcf808000
1232      * @param _keys number of keys desired (in 18 decimal format)
1233      * @return amount of eth needed to send
1234      */
1235     function iWantXKeys(uint256 _keys)
1236         public
1237         view
1238         returns(uint256)
1239     {
1240         // setup local rID
1241         uint256 _rID = rID_;
1242         
1243         // grab time
1244         uint256 _now = now;
1245         
1246         // are we in a round?
1247         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1248             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1249         else // rounds over.  need price for new round
1250             return ( (_keys).eth() );
1251     }
1252 //==============================================================================
1253 //    _|_ _  _ | _  .
1254 //     | (_)(_)|_\  .
1255 //==============================================================================
1256     /**
1257 	 * @dev receives name/player info from names contract 
1258      */
1259     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1260         external
1261     {
1262         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1263         if (pIDxAddr_[_addr] != _pID)
1264             pIDxAddr_[_addr] = _pID;
1265         if (pIDxName_[_name] != _pID)
1266             pIDxName_[_name] = _pID;
1267         if (plyr_[_pID].addr != _addr)
1268             plyr_[_pID].addr = _addr;
1269         if (plyr_[_pID].name != _name)
1270             plyr_[_pID].name = _name;
1271         if (plyr_[_pID].laff != _laff)
1272             plyr_[_pID].laff = _laff;
1273         if (plyrNames_[_pID][_name] == false)
1274             plyrNames_[_pID][_name] = true;
1275     }
1276     
1277     /**
1278      * @dev receives entire player name list 
1279      */
1280     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1281         external
1282     {
1283         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1284         if(plyrNames_[_pID][_name] == false)
1285             plyrNames_[_pID][_name] = true;
1286     }   
1287         
1288     /**
1289      * @dev gets existing or registers new pID.  use this when a player may be new
1290      * @return pID 
1291      */
1292     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1293         private
1294         returns (F3Ddatasets.EventReturns)
1295     {
1296         uint256 _pID = pIDxAddr_[msg.sender];
1297         // if player is new to this version of fomo3d
1298         if (_pID == 0)
1299         {
1300             // grab their player ID, name and last aff ID, from player names contract 
1301             _pID = PlayerBook.getPlayerID(msg.sender);
1302             bytes32 _name = PlayerBook.getPlayerName(_pID);
1303             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1304             
1305             // set up player account 
1306             pIDxAddr_[msg.sender] = _pID;
1307             plyr_[_pID].addr = msg.sender;
1308             
1309             if (_name != "")
1310             {
1311                 pIDxName_[_name] = _pID;
1312                 plyr_[_pID].name = _name;
1313                 plyrNames_[_pID][_name] = true;
1314             }
1315             
1316             if (_laff != 0 && _laff != _pID)
1317                 plyr_[_pID].laff = _laff;
1318             
1319             // set the new player bool to true
1320             _eventData_.compressedData = _eventData_.compressedData + 1;
1321         } 
1322         return (_eventData_);
1323     }
1324     
1325     /**
1326      * @dev checks to make sure user picked a valid team.  if not sets team 
1327      * to default (sneks)
1328      */
1329     function verifyTeam(uint256 _team)
1330         private
1331         pure
1332         returns (uint256)
1333     {
1334         if (_team < 0 || _team > 2)
1335             return(0);
1336         else
1337             return(_team);
1338     }
1339     
1340     /**
1341      * @dev decides if round end needs to be run & new round started.  and if 
1342      * player unmasked earnings from previously played rounds need to be moved.
1343      */
1344     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1345         private
1346         returns (F3Ddatasets.EventReturns)
1347     {
1348         // if player has played a previous round, move their unmasked earnings
1349         // from that round to gen vault.
1350         if (plyr_[_pID].lrnd != 0)
1351             updateGenVault(_pID, plyr_[_pID].lrnd);
1352             
1353         // update player's last round played
1354         plyr_[_pID].lrnd = rID_;
1355             
1356         // set the joined round bool to true
1357         _eventData_.compressedData = _eventData_.compressedData + 10;
1358         
1359         return(_eventData_);
1360     }
1361     
1362     /**
1363      * @dev ends the round. manages paying out winner/splitting up pot
1364      */
1365     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1366         private
1367         returns (F3Ddatasets.EventReturns)
1368     {
1369         // setup local rID
1370         uint256 _rID = rID_;
1371         
1372         // grab our winning player and team id's
1373         uint256 _winPID = round_[_rID].plyr;
1374         uint256 _winTID = round_[_rID].team;
1375         
1376         // grab our pot amount
1377         uint256 _pot = round_[_rID].pot;
1378         
1379         // calculate our winner share, community rewards, gen share, 
1380         // p3d share, and amount reserved for next pot 
1381         uint256 _win = (_pot.mul(48)) / 100;
1382         
1383         
1384         // community rewards
1385         uint256 _com = (_pot / 50);
1386         //uint256 _comTotal = ;
1387         comAddress.transfer(_com.add(comAirDrop_).add(comReWards_).add(airDropPot_).add(airDropPot2_));
1388         comAirDrop_ = 0;
1389         comReWards_ = 0;
1390         airDropPot_ = 0;
1391         airDropPot2_ = 0;
1392         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1393         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1394         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1395         
1396         // calculate ppt for round mask
1397         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1398         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1399         if (_dust > 0)
1400         {
1401             _gen = _gen.sub(_dust);
1402             _res = _res.add(_dust);
1403         }
1404         
1405         // pay our winner
1406         //plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1407         //last ten share
1408        shareLastTen( _rID, _win);
1409         
1410         
1411         
1412         
1413         // distribute gen portion to key holders
1414         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1415         
1416         // send share for p3d to divies
1417         //if (_p3d > 0)
1418         opAddress.transfer(_p3d);
1419         
1420         
1421         
1422             
1423         // prepare event data
1424         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1425         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1426         _eventData_.winnerAddr = plyr_[_winPID].addr;
1427         _eventData_.winnerName = plyr_[_winPID].name;
1428         _eventData_.amountWon = _win;
1429         _eventData_.genAmount = _gen;
1430         _eventData_.P3DAmount = _p3d;
1431         _eventData_.newPot = _res;
1432         
1433         // start next round
1434         rID_++;
1435         _rID++;
1436         round_[_rID].strt = now.add(comDropGap_);
1437         round_[_rID].end = now.add(comDropGap_).add(rndInit_);
1438         round_[_rID].pot = _res;
1439         
1440         return(_eventData_);
1441     }
1442     
1443     
1444     
1445     function shareLastTen(uint256 _rID, uint256 _win) private {
1446         
1447          if(roundBetCount_[_rID] >= 10){
1448             uint256 _singleWin = _win / 10; 
1449         	plyr_[lastTen_[_rID][0]].win = _singleWin.add(plyr_[lastTen_[_rID][0]].win);
1450             plyr_[lastTen_[_rID][1]].win = _singleWin.add(plyr_[lastTen_[_rID][1]].win);
1451             plyr_[lastTen_[_rID][2]].win = _singleWin.add(plyr_[lastTen_[_rID][2]].win);
1452             plyr_[lastTen_[_rID][3]].win = _singleWin.add(plyr_[lastTen_[_rID][3]].win);
1453             plyr_[lastTen_[_rID][4]].win = _singleWin.add(plyr_[lastTen_[_rID][4]].win);
1454             plyr_[lastTen_[_rID][5]].win = _singleWin.add(plyr_[lastTen_[_rID][5]].win);
1455             plyr_[lastTen_[_rID][6]].win = _singleWin.add(plyr_[lastTen_[_rID][6]].win);
1456             plyr_[lastTen_[_rID][7]].win = _singleWin.add(plyr_[lastTen_[_rID][7]].win);
1457             plyr_[lastTen_[_rID][8]].win = _singleWin.add(plyr_[lastTen_[_rID][8]].win);
1458             plyr_[lastTen_[_rID][9]].win = _singleWin.add(plyr_[lastTen_[_rID][9]].win);
1459         } else{
1460             uint256 _avarageWin = _win / roundBetCount_[_rID]; 
1461             
1462             for(uint256 _index = 0; _index < roundBetCount_[_rID] ; _index++  ){
1463                 plyr_[lastTen_[_rID][_index]].win = _avarageWin.add(plyr_[lastTen_[_rID][_index]].win);
1464             }
1465         }
1466     }
1467     
1468     /**
1469      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1470      */
1471     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1472         private 
1473     {
1474         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1475         if (_earnings > 0)
1476         {
1477             // put in gen vault
1478             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1479             // zero out their earnings by updating mask
1480             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1481         }
1482     }
1483     
1484     /**
1485      * @dev updates round timer based on number of whole keys bought.
1486      */
1487     function updateTimer(uint256 _keys, uint256 _rID)
1488         private
1489     {
1490         // grab time
1491         uint256 _now = now;
1492         
1493         // calculate time based on number of keys bought
1494         uint256 _newTime;
1495         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1496             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1497         else
1498             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1499         
1500         
1501         if(round_[_rID].strt.add(rndNTR_) >= now){
1502            // compare to max and set new end time
1503 		        if (_newTime < (rndMax_).add(_now))
1504 		            round_[_rID].end = _newTime;
1505 		        else
1506 		            round_[_rID].end = rndMax_.add(_now);
1507         }
1508         
1509     }
1510     
1511     /**
1512      * @dev generates a random number between 0-99 and checks to see if thats
1513      * resulted in an airdrop win
1514      * @return do we have a winner?
1515      */
1516     function airdrop()
1517         private 
1518         view 
1519         returns(bool)
1520     {
1521         uint256 seed = uint256(keccak256(abi.encodePacked(
1522             
1523             (block.timestamp).add
1524             (block.difficulty).add
1525             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1526             (block.gaslimit).add
1527             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1528             (block.number)
1529             
1530         )));
1531         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1532             return(true);
1533         else
1534             return(false);
1535     }
1536     
1537     
1538     function airdrop2()
1539         private 
1540         view 
1541         returns(bool)
1542     {
1543         uint256 seed = uint256(keccak256(abi.encodePacked(
1544             
1545             (block.timestamp).add
1546             (block.difficulty).add
1547             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1548             //(block.gaslimit).add
1549             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1550             (block.number)
1551             
1552         )));
1553         if((seed - ((seed / 1000) * 1000)) < airDropTracker2_)
1554             return(true);
1555         else
1556             return(false);
1557     }
1558 
1559     /**
1560      * @dev distributes eth based on fees to com, aff, and p3d
1561      */
1562     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1563         private
1564         returns(F3Ddatasets.EventReturns)
1565     {
1566        
1567         uint256 _p3d = 0;
1568         
1569         uint256 opEth = _eth.mul(18) / 100;
1570         
1571         opAddress.transfer(opEth);
1572         
1573         // decide what to do with affiliate share of fees
1574         // affiliate must not be self, and must have a name registered
1575         _p3d = affsend( _affID,  _pID,  _rID,  _eth,  _p3d);
1576  
1577         // pay out p3d
1578         //_p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1579         if (_p3d > 0)
1580         {
1581             // deposit to divies contract
1582             //change to owner
1583             //Divies.deposit.value(_p3d)();  
1584             owner.transfer(_p3d);
1585             // set up event data
1586             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1587         }
1588         
1589         return(_eventData_);
1590     }
1591     
1592      function affsend(uint256 _affID, uint256 _pID, uint256 _rID, uint256 _eth, uint256 _p3d)
1593         private
1594         returns(uint256)
1595     {
1596         
1597         // distribute share to affiliate  10%
1598         uint256 _aff = _eth / 10;
1599         
1600         // distribute share to affiliate  3%
1601         uint256 _affUp = _eth.mul(3) / 100;
1602         
1603          if (_affID != _pID && plyr_[_affID].name != '') {
1604             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1605             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1606             uint256 _affIDUp = plyr_[_affID].laff;
1607             inviteCount_[_affID] ++;
1608             
1609             if (_affIDUp !=0 && _affIDUp != _pID && plyr_[_affIDUp].name != '') {
1610 	            plyr_[_affIDUp].aff = _affUp.add(plyr_[_affIDUp].aff);
1611 	            emit F3Devents.onAffiliatePayout(_affIDUp, plyr_[_affIDUp].addr, plyr_[_affIDUp].name, _rID, _pID, _affUp, now);
1612 	            inviteCount_[_affIDUp] ++;
1613             }else{
1614                _p3d = _p3d.add(_affUp);
1615             }
1616            
1617             
1618         } else {
1619             _p3d = _aff;
1620         }
1621         
1622         return _p3d;
1623     }
1624     
1625     
1626     function potSwap()
1627         external
1628         payable
1629     {
1630         // setup local rID
1631         uint256 _rID = rID_ + 1;
1632         
1633         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1634         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1635     }
1636     
1637     /**
1638      * @dev distributes eth based on fees to gen and pot
1639      */
1640     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1641         private
1642         returns(F3Ddatasets.EventReturns)
1643     { 
1644     	   //1. pay 2% out to community rewards
1645         comReWards_ = comReWards_.add(_eth / 50);
1646         
1647         comAirDrop_ = comAirDrop_.add(_eth / 100);
1648         
1649         // calculate gen share
1650         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1651         
1652         // toss 1% into airdrop pot 
1653         uint256 _air = (_eth / 100);
1654         airDropPot_ = airDropPot_.add(_air);
1655         
1656          // toss 10% into airdrop2 pot 
1657         airDropPot2_ = airDropPot2_.add(_eth / 10);
1658         
1659         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1660         _eth = _eth.sub(((_eth.mul(39)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1661         
1662         // calculate pot 
1663         uint256 _pot = _eth.sub(_gen);
1664         
1665         // distribute gen share (thats what updateMasks() does) and adjust
1666         // balances for dust.
1667         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1668         if (_dust > 0)
1669             _gen = _gen.sub(_dust);
1670         
1671         // add eth to pot
1672         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1673         
1674         // set up event data
1675         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1676         _eventData_.potAmount = _pot;
1677         
1678         return(_eventData_);
1679     }
1680 
1681     /**
1682      * @dev updates masks for round and player when keys are bought
1683      * @return dust left over 
1684      */
1685     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1686         private
1687         returns(uint256)
1688     {
1689         /* MASKING NOTES
1690             earnings masks are a tricky thing for people to wrap their minds around.
1691             the basic thing to understand here.  is were going to have a global
1692             tracker based on profit per share for each round, that increases in
1693             relevant proportion to the increase in share supply.
1694             
1695             the player will have an additional mask that basically says "based
1696             on the rounds mask, my shares, and how much i've already withdrawn,
1697             how much is still owed to me?"
1698         */
1699         
1700         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1701         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1702         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1703             
1704         // calculate player earning from their own buy (only based on the keys
1705         // they just bought).  & update player earnings mask
1706         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1707         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1708         
1709         // calculate & return dust
1710         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1711     }
1712     
1713     /**
1714      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1715      * @return earnings in wei format
1716      */
1717     function withdrawEarnings(uint256 _pID)
1718         private
1719         returns(uint256)
1720     {
1721         // update gen vault
1722         updateGenVault(_pID, plyr_[_pID].lrnd);
1723         
1724         // from vaults 
1725         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1726         if (_earnings > 0)
1727         {
1728             plyr_[_pID].win = 0;
1729             plyr_[_pID].gen = 0;
1730             plyr_[_pID].aff = 0;
1731         }
1732 
1733         return(_earnings);
1734     }
1735     
1736     /**
1737      * @dev prepares compression data and fires event for buy or reload tx's
1738      */
1739     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1740         private
1741     {
1742         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1743         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1744         
1745         emit F3Devents.onEndTx
1746         (
1747             _eventData_.compressedData,
1748             _eventData_.compressedIDs,
1749             plyr_[_pID].name,
1750             msg.sender,
1751             _eth,
1752             _keys,
1753             _eventData_.winnerAddr,
1754             _eventData_.winnerName,
1755             _eventData_.amountWon,
1756             _eventData_.newPot,
1757             _eventData_.P3DAmount,
1758             _eventData_.genAmount,
1759             _eventData_.potAmount,
1760             airDropPot_
1761         );
1762     }
1763 //==============================================================================
1764 //    (~ _  _    _._|_    .
1765 //    _)(/_(_|_|| | | \/  .
1766 //====================/=========================================================
1767     /** upon contract deploy, it will be deactivated.  this is a one time
1768      * use function that will activate the contract.  we do this so devs 
1769      * have time to set things up on the web end                            **/
1770     bool public activated_ = false;
1771     function activate()
1772         public
1773     {
1774         // only team just can activate 
1775         require(
1776             msg.sender == owner ,
1777             "only team just can activate"
1778         );
1779 
1780 		// make sure that its been linked.
1781         //require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1782         
1783         // can only be ran once
1784         require(activated_ == false, "fomo3d already activated");
1785         
1786         // activate the contract 
1787         activated_ = true;
1788         
1789         // lets start first round
1790 		    rID_ = 1;
1791         round_[1].strt = now + rndExtra_ ;
1792         round_[1].end = now + rndInit_ + rndExtra_;
1793     }
1794 
1795 }
1796 
1797 //==============================================================================
1798 //   __|_ _    __|_ _  .
1799 //  _\ | | |_|(_ | _\  .
1800 //==============================================================================
1801 library F3Ddatasets {
1802     //compressedData key
1803     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1804         // 0 - new player (bool)
1805         // 1 - joined round (bool)
1806         // 2 - new  leader (bool)
1807         // 3-5 - air drop tracker (uint 0-999)
1808         // 6-16 - round end time
1809         // 17 - winnerTeam
1810         // 18 - 28 timestamp 
1811         // 29 - team
1812         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1813         // 31 - airdrop happened bool
1814         // 32 - airdrop tier 
1815         // 33 - airdrop amount won
1816     //compressedIDs key
1817     // [77-52][51-26][25-0]
1818         // 0-25 - pID 
1819         // 26-51 - winPID
1820         // 52-77 - rID
1821     struct EventReturns {
1822         uint256 compressedData;
1823         uint256 compressedIDs;
1824         address winnerAddr;         // winner address
1825         bytes32 winnerName;         // winner name
1826         uint256 amountWon;          // amount won
1827         uint256 newPot;             // amount in new pot
1828         uint256 P3DAmount;          // amount distributed to p3d
1829         uint256 genAmount;          // amount distributed to gen
1830         uint256 potAmount;          // amount added to pot
1831     }
1832     struct Player {
1833         address addr;   // player address
1834         bytes32 name;   // player name
1835         uint256 win;    // winnings vault
1836         uint256 gen;    // general vault
1837         uint256 aff;    // affiliate vault
1838         uint256 lrnd;   // last round played
1839         uint256 laff;   // last affiliate id used
1840     }
1841     struct PlayerRounds {
1842         uint256 eth;    // eth player has added to round (used for eth limiter)
1843         uint256 keys;   // keys
1844         uint256 mask;   // player mask 
1845         uint256 ico;    // ICO phase investment
1846     }
1847     struct Round {
1848         uint256 plyr;   // pID of player in lead
1849         uint256 team;   // tID of team in lead
1850         uint256 end;    // time ends/ended
1851         bool ended;     // has round end function been ran
1852         uint256 strt;   // time round started
1853         uint256 keys;   // keys
1854         uint256 eth;    // total eth in
1855         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1856         uint256 mask;   // global mask
1857         uint256 ico;    // total eth sent in during ICO phase
1858         uint256 icoGen; // total eth for gen during ICO phase
1859         uint256 icoAvg; // average key price for ICO phase
1860     }
1861     struct TeamFee {
1862         uint256 gen;    // % of buy in thats paid to key holders of current round
1863         uint256 p3d;    // % of buy in thats paid to p3d holders
1864     }
1865     struct PotSplit {
1866         uint256 gen;    // % of pot thats paid to key holders of current round
1867         uint256 p3d;    // % of pot thats paid to p3d holders
1868     }
1869 }
1870 
1871 //==============================================================================
1872 //  |  _      _ _ | _  .
1873 //  |<(/_\/  (_(_||(_  .
1874 //=======/======================================================================
1875 library F3DKeysCalcLong {
1876     using SafeMath for *;
1877     /**
1878      * @dev calculates number of keys received given X eth 
1879      * @param _curEth current amount of eth in contract 
1880      * @param _newEth eth being spent
1881      * @return amount of ticket purchased
1882      */
1883     function keysRec(uint256 _curEth, uint256 _newEth)
1884         internal
1885         pure
1886         returns (uint256)
1887     {
1888         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1889     }
1890     
1891     /**
1892      * @dev calculates amount of eth received if you sold X keys 
1893      * @param _curKeys current amount of keys that exist 
1894      * @param _sellKeys amount of keys you wish to sell
1895      * @return amount of eth received
1896      */
1897     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1898         internal
1899         pure
1900         returns (uint256)
1901     {
1902         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1903     }
1904 
1905     /**
1906      * @dev calculates how many keys would exist with given an amount of eth
1907      * @param _eth eth "in contract"
1908      * @return number of keys that would exist
1909      */
1910     function keys(uint256 _eth) 
1911         internal
1912         pure
1913         returns(uint256)
1914     {
1915         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1916     }
1917     
1918     /**
1919      * @dev calculates how much eth would be in contract given a number of keys
1920      * @param _keys number of keys "in contract" 
1921      * @return eth that would exists
1922      */
1923     function eth(uint256 _keys) 
1924         internal
1925         pure
1926         returns(uint256)  
1927     {
1928         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1929     }
1930 }
1931 
1932 //==============================================================================
1933 //  . _ _|_ _  _ |` _  _ _  _  .
1934 //  || | | (/_| ~|~(_|(_(/__\  .
1935 //==============================================================================
1936 
1937 
1938 
1939 interface PlayerBookInterface {
1940     function getPlayerID(address _addr) external returns (uint256);
1941     function getPlayerName(uint256 _pID) external view returns (bytes32);
1942     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1943     function getPlayerAddr(uint256 _pID) external view returns (address);
1944     function getNameFee() external view returns (uint256);
1945     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1946     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1947     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1948 }
1949 
1950 
1951 
1952 library NameFilter {
1953     /**
1954      * @dev filters name strings
1955      * -converts uppercase to lower case.  
1956      * -makes sure it does not start/end with a space
1957      * -makes sure it does not contain multiple spaces in a row
1958      * -cannot be only numbers
1959      * -cannot start with 0x 
1960      * -restricts characters to A-Z, a-z, 0-9, and space.
1961      * @return reprocessed string in bytes32 format
1962      */
1963     function nameFilter(string _input)
1964         internal
1965         pure
1966         returns(bytes32)
1967     {
1968         bytes memory _temp = bytes(_input);
1969         uint256 _length = _temp.length;
1970         
1971         //sorry limited to 32 characters
1972         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1973         // make sure it doesnt start with or end with space
1974         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1975         // make sure first two characters are not 0x
1976         if (_temp[0] == 0x30)
1977         {
1978             require(_temp[1] != 0x78, "string cannot start with 0x");
1979             require(_temp[1] != 0x58, "string cannot start with 0X");
1980         }
1981         
1982         // create a bool to track if we have a non number character
1983         bool _hasNonNumber;
1984         
1985         // convert & check
1986         for (uint256 i = 0; i < _length; i++)
1987         {
1988             // if its uppercase A-Z
1989             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1990             {
1991                 // convert to lower case a-z
1992                 _temp[i] = byte(uint(_temp[i]) + 32);
1993                 
1994                 // we have a non number
1995                 if (_hasNonNumber == false)
1996                     _hasNonNumber = true;
1997             } else {
1998                 require
1999                 (
2000                     // require character is a space
2001                     _temp[i] == 0x20 || 
2002                     // OR lowercase a-z
2003                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2004                     // or 0-9
2005                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2006                     "string contains invalid characters"
2007                 );
2008                 // make sure theres not 2x spaces in a row
2009                 if (_temp[i] == 0x20)
2010                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2011                 
2012                 // see if we have a character other than a number
2013                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2014                     _hasNonNumber = true;    
2015             }
2016         }
2017         
2018         require(_hasNonNumber == true, "string cannot be only numbers");
2019         
2020         bytes32 _ret;
2021         assembly {
2022             _ret := mload(add(_temp, 32))
2023         }
2024         return (_ret);
2025     }
2026 }
2027 
2028 /**
2029  * @title SafeMath v0.1.9
2030  * @dev Math operations with safety checks that throw on error
2031  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2032  * - added sqrt
2033  * - added sq
2034  * - added pwr 
2035  * - changed asserts to requires with error log outputs
2036  * - removed div, its useless
2037  */
2038 library SafeMath {
2039     
2040     /**
2041     * @dev Multiplies two numbers, throws on overflow.
2042     */
2043     function mul(uint256 a, uint256 b) 
2044         internal 
2045         pure 
2046         returns (uint256 c) 
2047     {
2048         if (a == 0) {
2049             return 0;
2050         }
2051         c = a * b;
2052         require(c / a == b, "SafeMath mul failed");
2053         return c;
2054     }
2055 
2056     /**
2057     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2058     */
2059     function sub(uint256 a, uint256 b)
2060         internal
2061         pure
2062         returns (uint256) 
2063     {
2064         require(b <= a, "SafeMath sub failed");
2065         return a - b;
2066     }
2067 
2068     /**
2069     * @dev Adds two numbers, throws on overflow.
2070     */
2071     function add(uint256 a, uint256 b)
2072         internal
2073         pure
2074         returns (uint256 c) 
2075     {
2076         c = a + b;
2077         require(c >= a, "SafeMath add failed");
2078         return c;
2079     }
2080     
2081     /**
2082      * @dev gives square root of given x.
2083      */
2084     function sqrt(uint256 x)
2085         internal
2086         pure
2087         returns (uint256 y) 
2088     {
2089         uint256 z = ((add(x,1)) / 2);
2090         y = x;
2091         while (z < y) 
2092         {
2093             y = z;
2094             z = ((add((x / z),z)) / 2);
2095         }
2096     }
2097     
2098     /**
2099      * @dev gives square. multiplies x by x
2100      */
2101     function sq(uint256 x)
2102         internal
2103         pure
2104         returns (uint256)
2105     {
2106         return (mul(x,x));
2107     }
2108     
2109     /**
2110      * @dev x to the power of y 
2111      */
2112     function pwr(uint256 x, uint256 y)
2113         internal 
2114         pure 
2115         returns (uint256)
2116     {
2117         if (x==0)
2118             return (0);
2119         else if (y==0)
2120             return (1);
2121         else 
2122         {
2123             uint256 z = x;
2124             for (uint256 i=1; i < y; i++)
2125                 z = mul(z,x);
2126             return (z);
2127         }
2128     }
2129  
2130 }