1 pragma solidity ^0.4.24;
2 
3 contract FumoEvents {
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
63     // fired whenever a player tries a buy after round timer 
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
80     // fired whenever a player tries a reload after round timer 
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
114 }
115 
116 contract modularShort is FumoEvents {}
117 
118 contract Fumo is modularShort {
119     using SafeMath for *;
120     using NameFilter for string;
121     using FumoKeysCalcLong for uint256;
122 	
123     address community_addr = 0x3705B81d42199138E53FB0Ad57613ce309576077;
124 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xd085AcFC0FDaA418E03E8570EF9A4E25a0E14eCf);
125 //==============================================================================
126 //     _ _  _  |`. _     _ _ |_ | _  _  .
127 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
128 //=================_|===========================================================
129     string constant public name = "Fumo token";
130     string constant public symbol = "FuMo";
131     uint256 private rndExtra_ = 0;     // length of the very first ICO
132     uint256 private rndGap_ = 0;         // length of ICO phase, set to 1 year for EOS.
133     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
134     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
135     uint256 constant private rndMax_ = 1 hours;                // max length a round timer can be             // max length a round timer can be
136 //==============================================================================
137 //     _| _ _|_ _    _ _ _|_    _   .
138 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
139 //=============================|================================================
140 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
141     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
142     uint256 public rID_;    // round id number / total rounds that have happened
143 //****************
144 // PLAYER DATA 
145 //****************
146     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
147     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
148     mapping (uint256 => Fumodatasets.Player) public plyr_;   // (pID => data) player data
149     mapping (uint256 => mapping (uint256 => Fumodatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
150     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
151 //****************
152 // ROUND DATA 
153 //****************
154     mapping (uint256 => Fumodatasets.Round) public round_;   // (rID => data) round data
155     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
156 //****************
157 // TEAM FEE DATA 
158 //****************
159     mapping (uint256 => Fumodatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
160     mapping (uint256 => Fumodatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
161 	//初始化
162     constructor()
163         public
164     {
165 		// Team allocation structures
166         // 0 = whales
167         // 1 = bears
168         // 2 = sneks
169         // 3 = bulls
170 
171 		// Team allocation percentages
172         // (Fumo, 0) + (Pot , Referrals, Community)
173             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
174         fees_[0] = Fumodatasets.TeamFee(30,0);   //46% to pot, 20% to aff, 2% to com, 2% to air drop pot
175         fees_[1] = Fumodatasets.TeamFee(43,0);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
176         fees_[2] = Fumodatasets.TeamFee(56,0);  //20% to pot, 20% to aff, 2% to com, 2% to air drop pot
177         fees_[3] = Fumodatasets.TeamFee(43,8);   //33% to pot, 20% to aff, 2% to com, 2% to air drop pot
178         
179         // how to split up the final pot based on which team was picked
180         // (Fumo, 0)
181         potSplit_[0] = Fumodatasets.PotSplit(15,0);  //48% to winner, 25% to next round, 12% to com
182         potSplit_[1] = Fumodatasets.PotSplit(20,0);   //48% to winner, 20% to next round, 12% to com
183         potSplit_[2] = Fumodatasets.PotSplit(25,0);  //48% to winner, 15% to next round, 12% to com
184         potSplit_[3] = Fumodatasets.PotSplit(30,0);  //48% to winner, 10% to next round, 12% to com
185 	}
186 
187     /**
188      * @dev used to make sure no one can interact with contract until it has 
189      * been activated. 
190      */
191     modifier isActivated() {
192         require(activated_ == true, "its not ready yet.  "); 
193         _;
194     }
195     
196     /**
197      * 判断地址是否正确
198      * @dev prevents contracts from interacting with fomo3d 
199      */
200     modifier isHuman() {
201         address _addr = msg.sender;
202         uint256 _codeLength;
203         
204         assembly {_codeLength := extcodesize(_addr)}
205         require(_codeLength == 0, "sorry humans only");
206         _;
207     }
208 
209     /**
210      * 
211      * @dev sets boundaries for incoming tx 
212      */
213     modifier isWithinLimits(uint256 _eth) {
214         require(_eth >= 1000000000, "pocket lint: not a valid currency");
215         require(_eth <= 100000000000000000000000, "no vitalik, no");
216         _;    
217     }
218     
219 //==============================================================================
220 //     _    |_ |. _   |`    _  __|_. _  _  _  .
221 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
222 //====|=========================================================================
223     /**
224      * @dev emergency buy uses last stored affiliate ID and team snek
225      */
226     function()
227         isActivated()
228         isHuman()
229         isWithinLimits(msg.value)
230         public
231         payable
232     {
233         // set up our tx event data and determine if player is new or not
234         Fumodatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
235             
236         // fetch player id
237         uint256 _pID = pIDxAddr_[msg.sender];
238         
239         // buy core 
240         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
241     }
242     
243     /**
244      * @dev converts all incoming ethereum to keys.
245      * -functionhash- 0x8f38f309 (using ID for affiliate)
246      * -functionhash- 0x98a0871d (using address for affiliate)
247      * -functionhash- 0xa65b37a1 (using name for affiliate)
248      * @param _affCode the ID/address/name of the player who gets the affiliate fee
249      * @param _team what team is the player playing for?
250      */
251     function buyXid(uint256 _affCode, uint256 _team)
252         isActivated()
253         isHuman()
254         isWithinLimits(msg.value)
255         public
256         payable
257     {
258         // set up our tx event data and determine if player is new or not
259         Fumodatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
260         
261         // fetch player id
262         uint256 _pID = pIDxAddr_[msg.sender];
263         
264         // manage affiliate residuals
265         // if no affiliate code was given or player tried to use their own, lolz
266         if (_affCode == 0 || _affCode == _pID)
267         {
268             // use last stored affiliate code 
269             _affCode = plyr_[_pID].laff;
270             
271         // if affiliate code was given & its not the same as previously stored 
272         } else if (_affCode != plyr_[_pID].laff) {
273             // update last affiliate 
274             plyr_[_pID].laff = _affCode;
275         }
276         
277         // verify a valid team was selected
278         _team = verifyTeam(_team);
279         
280         // buy core 
281         buyCore(_pID, _affCode, _team, _eventData_);
282     }
283     
284     function buyXaddr(address _affCode, uint256 _team)
285         isActivated()
286         isHuman()
287         isWithinLimits(msg.value)
288         public
289         payable
290     {
291         // set up our tx event data and determine if player is new or not
292         Fumodatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
293         
294         // fetch player id
295         uint256 _pID = pIDxAddr_[msg.sender];
296         
297         // manage affiliate residuals
298         uint256 _affID;
299         // if no affiliate code was given or player tried to use their own, lolz
300         if (_affCode == address(0) || _affCode == msg.sender)
301         {
302             // use last stored affiliate code
303             _affID = plyr_[_pID].laff;
304         
305         // if affiliate code was given    
306         } else {
307             // get affiliate ID from aff Code 
308             _affID = pIDxAddr_[_affCode];
309             
310             // if affID is not the same as previously stored 
311             if (_affID != plyr_[_pID].laff)
312             {
313                 // update last affiliate
314                 plyr_[_pID].laff = _affID;
315             }
316         }
317         
318         // verify a valid team was selected
319         _team = verifyTeam(_team);
320         
321         // buy core 
322         buyCore(_pID, _affID, _team, _eventData_);
323     }
324     
325     function buyXname(bytes32 _affCode, uint256 _team)
326         isActivated()
327         isHuman()
328         isWithinLimits(msg.value)
329         public
330         payable
331     {
332         // set up our tx event data and determine if player is new or not
333         Fumodatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
334         
335         // fetch player id
336         uint256 _pID = pIDxAddr_[msg.sender];
337         
338         // manage affiliate residuals
339         uint256 _affID;
340         // if no affiliate code was given or player tried to use their own, lolz
341         if (_affCode == '' || _affCode == plyr_[_pID].name)
342         {
343             // use last stored affiliate code
344             _affID = plyr_[_pID].laff;
345         
346         // if affiliate code was given
347         } else {
348             // get affiliate ID from aff Code
349             _affID = pIDxName_[_affCode];
350             
351             // if affID is not the same as previously stored
352             if (_affID != plyr_[_pID].laff)
353             {
354                 // update last affiliate
355                 plyr_[_pID].laff = _affID;
356             }
357         }
358         
359         // verify a valid team was selected
360         _team = verifyTeam(_team);
361         
362         // buy core 
363         buyCore(_pID, _affID, _team, _eventData_);
364     }
365     
366     /**
367      * @dev essentially the same as buy, but instead of you sending ether 
368      * from your wallet, it uses your unwithdrawn earnings.
369      * -functionhash- 0x349cdcac (using ID for affiliate)
370      * -functionhash- 0x82bfc739 (using address for affiliate)
371      * -functionhash- 0x079ce327 (using name for affiliate)
372      * @param _affCode the ID/address/name of the player who gets the affiliate fee
373      * @param _team what team is the player playing for?
374      * @param _eth amount of earnings to use (remainder returned to gen vault)
375      */
376     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
377         isActivated()
378         isHuman()
379         isWithinLimits(_eth)
380         public
381     {
382         // set up our tx event data
383         Fumodatasets.EventReturns memory _eventData_;
384         
385         // fetch player ID
386         uint256 _pID = pIDxAddr_[msg.sender];
387         
388         // manage affiliate residuals
389         // if no affiliate code was given or player tried to use their own, lolz
390         if (_affCode == 0 || _affCode == _pID)
391         {
392             // use last stored affiliate code 
393             _affCode = plyr_[_pID].laff;
394             
395         // if affiliate code was given & its not the same as previously stored 
396         } else if (_affCode != plyr_[_pID].laff) {
397             // update last affiliate 
398             plyr_[_pID].laff = _affCode;
399         }
400 
401         // verify a valid team was selected
402         _team = verifyTeam(_team);
403 
404         // reload core
405         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
406     }
407     
408     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
409         isActivated()
410         isHuman()
411         isWithinLimits(_eth)
412         public
413     {
414         // set up our tx event data
415         Fumodatasets.EventReturns memory _eventData_;
416         
417         // fetch player ID
418         uint256 _pID = pIDxAddr_[msg.sender];
419         
420         // manage affiliate residuals
421         uint256 _affID;
422         // if no affiliate code was given or player tried to use their own, lolz
423         if (_affCode == address(0) || _affCode == msg.sender)
424         {
425             // use last stored affiliate code
426             _affID = plyr_[_pID].laff;
427         
428         // if affiliate code was given    
429         } else {
430             // get affiliate ID from aff Code 
431             _affID = pIDxAddr_[_affCode];
432             
433             // if affID is not the same as previously stored 
434             if (_affID != plyr_[_pID].laff)
435             {
436                 // update last affiliate
437                 plyr_[_pID].laff = _affID;
438             }
439         }
440         
441         // verify a valid team was selected
442         _team = verifyTeam(_team);
443         
444         // reload core
445         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
446     }
447     
448     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
449         isActivated()
450         isHuman()
451         isWithinLimits(_eth)
452         public
453     {
454         // set up our tx event data
455         Fumodatasets.EventReturns memory _eventData_;
456         
457         // fetch player ID
458         uint256 _pID = pIDxAddr_[msg.sender];
459         
460         // manage affiliate residuals
461         uint256 _affID;
462         // if no affiliate code was given or player tried to use their own, lolz
463         if (_affCode == '' || _affCode == plyr_[_pID].name)
464         {
465             // use last stored affiliate code
466             _affID = plyr_[_pID].laff;
467         
468         // if affiliate code was given
469         } else {
470             // get affiliate ID from aff Code
471             _affID = pIDxName_[_affCode];
472             
473             // if affID is not the same as previously stored
474             if (_affID != plyr_[_pID].laff)
475             {
476                 // update last affiliate
477                 plyr_[_pID].laff = _affID;
478             }
479         }
480         
481         // verify a valid team was selected
482         _team = verifyTeam(_team);
483         
484         // reload core
485         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
486     }
487 
488     /**
489      * 提现
490      * @dev withdraws all of your earnings.
491      * -functionhash- 0x3ccfd60b
492      */
493     function withdraw()
494         isActivated()
495         isHuman()
496         public
497     {
498         // setup local rID 
499         uint256 _rID = rID_;
500         
501         // grab time
502         uint256 _now = now;
503         
504         // fetch player ID
505         uint256 _pID = pIDxAddr_[msg.sender];
506         
507         // setup temp var for player eth
508         uint256 _eth;
509         
510         // check to see if round has ended and no one has run round end yet
511         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
512         {
513             // set up our tx event data
514             Fumodatasets.EventReturns memory _eventData_;
515             
516             // end the round (distributes pot)
517 			round_[_rID].ended = true;
518             _eventData_ = endRound(_eventData_);
519             
520 			// get their earnings
521             _eth = withdrawEarnings(_pID);
522             
523             // gib moni
524             if (_eth > 0)
525                 plyr_[_pID].addr.transfer(_eth);    
526             
527             // build event data
528             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
529             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
530             
531             // fire withdraw and distribute event
532             emit FumoEvents.onWithdrawAndDistribute
533             (
534                 msg.sender, 
535                 plyr_[_pID].name, 
536                 _eth, 
537                 _eventData_.compressedData, 
538                 _eventData_.compressedIDs, 
539                 _eventData_.winnerAddr, 
540                 _eventData_.winnerName, 
541                 _eventData_.amountWon, 
542                 _eventData_.newPot, 
543                 _eventData_.P3DAmount, 
544                 _eventData_.genAmount
545             );
546             
547         // in any other situation
548         } else {
549             // get their earnings
550             _eth = withdrawEarnings(_pID);
551             
552             // gib moni
553             if (_eth > 0)
554                 plyr_[_pID].addr.transfer(_eth);
555             
556             // fire withdraw event
557             emit FumoEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
558         }
559     }
560     
561     /**
562      * @dev use these to register names.  they are just wrappers that will send the
563      * registration requests to the PlayerBook contract.  So registering here is the 
564      * same as registering there.  UI will always display the last name you registered.
565      * but you will still own all previously registered names to use as affiliate 
566      * links.
567      * - must pay a registration fee.
568      * - name must be unique
569      * - names will be converted to lowercase
570      * - name cannot start or end with a space 
571      * - cannot have more than 1 space in a row
572      * - cannot be only numbers
573      * - cannot start with 0x 
574      * - name must be at least 1 char
575      * - max length of 32 characters long
576      * - allowed characters: a-z, 0-9, and space
577      * -functionhash- 0x921dec21 (using ID for affiliate)
578      * -functionhash- 0x3ddd4698 (using address for affiliate)
579      * -functionhash- 0x685ffd83 (using name for affiliate)
580      * @param _nameString players desired name
581      * @param _affCode affiliate ID, address, or name of who referred you
582      * @param _all set to true if you want this to push your info to all games 
583      * (this might cost a lot of gas)
584      */
585     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
586         isHuman()
587         public
588         payable
589     {
590         bytes32 _name = _nameString.nameFilter();
591         address _addr = msg.sender;
592         uint256 _paid = msg.value;
593         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
594         
595         uint256 _pID = pIDxAddr_[_addr];
596         
597         // fire event
598         emit FumoEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
599     }
600     
601     function registerNameXaddr(string _nameString, address _affCode, bool _all)
602         isHuman()
603         public
604         payable
605     {
606         bytes32 _name = _nameString.nameFilter();
607         address _addr = msg.sender;
608         uint256 _paid = msg.value;
609         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
610         
611         uint256 _pID = pIDxAddr_[_addr];
612         
613         // fire event
614         emit FumoEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
615     }
616     
617     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
618         isHuman()
619         public
620         payable
621     {
622         bytes32 _name = _nameString.nameFilter();
623         address _addr = msg.sender;
624         uint256 _paid = msg.value;
625         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
626         
627         uint256 _pID = pIDxAddr_[_addr];
628         
629         // fire event
630         emit FumoEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
631     }
632 
633     /**
634      * 获取购买价格
635      * @dev return the price buyer will pay for next 1 individual key.
636      * -functionhash- 0x018a25e8
637      * @return price for next key bought (in wei format)
638      */
639     function getBuyPrice()
640         public 
641         view 
642         returns(uint256)
643     {  
644         // setup local rID
645         uint256 _rID = rID_;
646         
647         // grab time
648         uint256 _now = now;
649         
650         // are we in a round?
651         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
652             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
653         else // rounds over.  need price for new round
654             return ( 75000000000000 ); // init
655     }
656     
657     /**
658      * 获取剩余时间
659      * provider
660      * -functionhash- 0xc7e284b8
661      * @return time left in seconds
662      */
663     function getTimeLeft()
664         public
665         view
666         returns(uint256)
667     {
668         // setup local rID
669         uint256 _rID = rID_;
670         
671         // grab time
672         uint256 _now = now;
673         
674         if (_now < round_[_rID].end)
675             if (_now > round_[_rID].strt + rndGap_)
676                 return( (round_[_rID].end).sub(_now) );
677             else
678                 return( (round_[_rID].strt + rndGap_).sub(_now) );
679         else
680             return(0);
681     }
682     
683     /**
684      * @dev returns player earnings per vaults 
685      * -functionhash- 0x63066434
686      * @return winnings vault
687      * @return general vault
688      * @return affiliate vault
689      */
690     function getPlayerVaults(uint256 _pID)
691         public
692         view
693         returns(uint256 ,uint256, uint256)
694     {
695         // setup local rID
696         uint256 _rID = rID_;
697         
698         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
699         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
700         {
701             // if player is winner 
702             if (round_[_rID].plyr == _pID)
703             {
704                 return
705                 (
706                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
707                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
708                     plyr_[_pID].aff
709                 );
710             // if player is not the winner
711             } else {
712                 return
713                 (
714                     plyr_[_pID].win,
715                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
716                     plyr_[_pID].aff
717                 );
718             }
719             
720         // if round is still going on, or round has ended and round end has been ran
721         } else {
722             return
723             (
724                 plyr_[_pID].win,
725                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
726                 plyr_[_pID].aff
727             );
728         }
729     }
730     
731     /**
732      * solidity hates stack limits.  this lets us avoid that hate 
733      */
734     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
735         private
736         view
737         returns(uint256)
738     {
739         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
740     }
741     
742     /**
743      * @dev returns all current round info needed for front end
744      * -functionhash- 0x747dff42
745      * @return eth invested during ICO phase
746      * @return round id 
747      * @return total keys for round 
748      * @return time round ends
749      * @return time round started
750      * @return current pot 
751      * @return current team ID & player ID in lead 
752      * @return current player in leads address 
753      * @return current player in leads name
754      * @return whales eth in for round
755      * @return bears eth in for round
756      * @return sneks eth in for round
757      * @return bulls eth in for round
758      * @return airdrop tracker # & airdrop pot
759      */
760     function getCurrentRoundInfo()
761         public
762         view
763         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
764     {
765         // setup local rID
766         uint256 _rID = rID_;
767         
768         return
769         (
770             round_[_rID].ico,               //0
771             _rID,                           //1
772             round_[_rID].keys,              //2
773             round_[_rID].end,               //3
774             round_[_rID].strt,              //4
775             round_[_rID].pot,               //5
776             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
777             plyr_[round_[_rID].plyr].addr,  //7
778             plyr_[round_[_rID].plyr].name,  //8
779             rndTmEth_[_rID][0],             //9
780             rndTmEth_[_rID][1],             //10
781             rndTmEth_[_rID][2],             //11
782             rndTmEth_[_rID][3],             //12
783             airDropTracker_ + (airDropPot_ * 1000)              //13
784         );
785     }
786 
787     /**
788      * 根据地址获取用户信息
789      * use msg.sender 
790      * -functionhash- 0xee0b5d8b
791      * @param _addr address of the player you want to lookup 
792      * @return player ID 
793      * @return player name
794      * @return keys owned (current round)
795      * @return winnings vault
796      * @return general vault 
797      * @return affiliate vault 
798 	 * @return player round eth
799      */
800     function getPlayerInfoByAddress(address _addr)
801         public 
802         view 
803         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
804     {
805         // setup local rID
806         uint256 _rID = rID_;
807         
808         if (_addr == address(0))
809         {
810             _addr == msg.sender;
811         }
812         uint256 _pID = pIDxAddr_[_addr];
813         
814         return
815         (
816             _pID,                               //0
817             plyr_[_pID].name,                   //1
818             plyrRnds_[_pID][_rID].keys,         //2
819             plyr_[_pID].win,                    //3
820             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
821             plyr_[_pID].aff,                    //5
822             plyrRnds_[_pID][_rID].eth           //6
823         );
824     }
825 
826 
827     /**
828      * 购买合约处理函数
829      */
830     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Fumodatasets.EventReturns memory _eventData_)
831         private
832     {
833         // setup local rID
834         uint256 _rID = rID_;
835         
836         // grab time
837         uint256 _now = now;
838         
839         // if round is active
840         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
841         {
842             // call core 
843             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
844         
845         // if round is not active     
846         } else {
847             // check to see if end round needs to be ran
848             if (_now > round_[_rID].end && round_[_rID].ended == false) 
849             {
850                 // end the round (distributes pot) & start new round
851 			    round_[_rID].ended = true;
852                 _eventData_ = endRound(_eventData_);
853                 
854                 // build event data
855                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
856                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
857                 
858                 // fire buy and distribute event 
859                 emit FumoEvents.onBuyAndDistribute
860                 (
861                     msg.sender, 
862                     plyr_[_pID].name, 
863                     msg.value, 
864                     _eventData_.compressedData, 
865                     _eventData_.compressedIDs, 
866                     _eventData_.winnerAddr, 
867                     _eventData_.winnerName, 
868                     _eventData_.amountWon, 
869                     _eventData_.newPot, 
870                     _eventData_.P3DAmount, 
871                     _eventData_.genAmount
872                 );
873             }
874             
875             // put eth in players vault 
876             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
877         }
878     }
879     
880     /**
881      * @dev logic runs whenever a reload order is executed.  determines how to handle 
882      * incoming eth depending on if we are in an active round or not 
883      */
884     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Fumodatasets.EventReturns memory _eventData_)
885         private
886     {
887         // setup local rID
888         uint256 _rID = rID_;
889         
890         // grab time
891         uint256 _now = now;
892         
893         // if round is active
894         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
895         {
896             // get earnings from all vaults and return unused to gen vault
897             // because we use a custom safemath library.  this will throw if player 
898             // tried to spend more eth than they have.
899             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
900             
901             // call core 
902             core(_rID, _pID, _eth, _affID, _team, _eventData_);
903         
904         // if round is not active and end round needs to be ran   
905         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
906             // end the round (distributes pot) & start new round
907             round_[_rID].ended = true;
908             _eventData_ = endRound(_eventData_);
909                 
910             // build event data
911             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
912             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
913                 
914             // fire buy and distribute event 
915             emit FumoEvents.onReLoadAndDistribute
916             (
917                 msg.sender, 
918                 plyr_[_pID].name, 
919                 _eventData_.compressedData, 
920                 _eventData_.compressedIDs, 
921                 _eventData_.winnerAddr, 
922                 _eventData_.winnerName, 
923                 _eventData_.amountWon, 
924                 _eventData_.newPot, 
925                 _eventData_.P3DAmount, 
926                 _eventData_.genAmount
927             );
928         }
929     }
930     
931     /**
932      * @dev this is the core logic for any buy/reload that happens while a round 
933      * is live.
934      */
935     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Fumodatasets.EventReturns memory _eventData_)
936         private
937     {
938         // if player is new to round
939         if (plyrRnds_[_pID][_rID].keys == 0)
940             _eventData_ = managePlayer(_pID, _eventData_);
941         
942         // if eth left is greater than min eth allowed (sorry no pocket lint)
943         if (_eth > 1000000000) 
944         {
945             
946             // mint the new keys
947             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
948             
949             // if they bought at least 1 whole key
950             if (_keys >= 1000000000000000000)
951             {
952             updateTimer(_keys, _rID);
953 
954             // set new leaders
955             if (round_[_rID].plyr != _pID)
956                 round_[_rID].plyr = _pID;  
957             if (round_[_rID].team != _team)
958                 round_[_rID].team = _team; 
959             
960             // set the new leader bool to true
961             _eventData_.compressedData = _eventData_.compressedData + 100;
962         }
963             
964             // manage airdrops
965             if (_eth >= 100000000000000000)
966             {
967             airDropTracker_++;
968             if (airdrop() == true)
969             {
970                 // gib muni
971                 uint256 _prize;
972                 if (_eth >= 10000000000000000000)
973                 {
974                     // calculate prize and give it to winner
975                     _prize = ((airDropPot_).mul(75)) / 100;
976                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
977                     
978                     // adjust airDropPot 
979                     airDropPot_ = (airDropPot_).sub(_prize);
980                     
981                     // let event know a tier 3 prize was won 
982                     _eventData_.compressedData += 300000000000000000000000000000000;
983                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
984                     // calculate prize and give it to winner
985                     _prize = ((airDropPot_).mul(50)) / 100;
986                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
987                     
988                     // adjust airDropPot 
989                     airDropPot_ = (airDropPot_).sub(_prize);
990                     
991                     // let event know a tier 2 prize was won 
992                     _eventData_.compressedData += 200000000000000000000000000000000;
993                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
994                     // calculate prize and give it to winner
995                     _prize = ((airDropPot_).mul(25)) / 100;
996                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
997                     
998                     // adjust airDropPot 
999                     airDropPot_ = (airDropPot_).sub(_prize);
1000                     
1001                     // let event know a tier 3 prize was won 
1002                     _eventData_.compressedData += 300000000000000000000000000000000;
1003                 }
1004                 // set airdrop happened bool to true
1005                 _eventData_.compressedData += 10000000000000000000000000000000;
1006                 // let event know how much was won 
1007                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1008                 
1009                 // reset air drop tracker
1010                 airDropTracker_ = 0;
1011             }
1012         }
1013     
1014             // store the air drop tracker number (number of buys since last airdrop)
1015             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1016             
1017             // update player 
1018             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1019             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1020             
1021             // update round
1022             round_[_rID].keys = _keys.add(round_[_rID].keys);
1023             round_[_rID].eth = _eth.add(round_[_rID].eth);
1024             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1025     
1026             // distribute eth
1027             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1028             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1029             
1030             // call end tx function to fire end tx event.
1031 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1032         }
1033     }
1034 //==============================================================================
1035 //     _ _ | _   | _ _|_ _  _ _  .
1036 //    (_(_||(_|_||(_| | (_)| _\  .
1037 //==============================================================================
1038     /**
1039      * @dev calculates unmasked earnings (just calculates, does not update mask)
1040      * @return earnings in wei format
1041      */
1042     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1043         private
1044         view
1045         returns(uint256)
1046     {
1047         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1048     }
1049     
1050     /** 
1051      * @dev returns the amount of keys you would get given an amount of eth. 
1052      * -functionhash- 0xce89c80c
1053      * @param _rID round ID you want price for
1054      * @param _eth amount of eth sent in 
1055      * @return keys received 
1056      */
1057     function calcKeysReceived(uint256 _rID, uint256 _eth)
1058         public
1059         view
1060         returns(uint256)
1061     {
1062         // grab time
1063         uint256 _now = now;
1064         
1065         // are we in a round?
1066         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1067             return ( (round_[_rID].eth).keysRec(_eth) );
1068         else // rounds over.  need keys for new round
1069             return ( (_eth).keys() );
1070     }
1071     
1072     /** 
1073      * @dev returns current eth price for X keys.  
1074      * -functionhash- 0xcf808000
1075      * @param _keys number of keys desired (in 18 decimal format)
1076      * @return amount of eth needed to send
1077      */
1078     function iWantXKeys(uint256 _keys)
1079         public
1080         view
1081         returns(uint256)
1082     {
1083         // setup local rID
1084         uint256 _rID = rID_;
1085         
1086         // grab time
1087         uint256 _now = now;
1088         
1089         // are we in a round?
1090         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1091             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1092         else // rounds over.  need price for new round
1093             return ( (_keys).eth() );
1094     }
1095 //==============================================================================
1096 //    _|_ _  _ | _  .
1097 //     | (_)(_)|_\  .
1098 //==============================================================================
1099     /**
1100 	 * @dev receives name/player info from names contract 
1101      */
1102     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1103         external
1104     {
1105         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1106         if (pIDxAddr_[_addr] != _pID)
1107             pIDxAddr_[_addr] = _pID;
1108         if (pIDxName_[_name] != _pID)
1109             pIDxName_[_name] = _pID;
1110         if (plyr_[_pID].addr != _addr)
1111             plyr_[_pID].addr = _addr;
1112         if (plyr_[_pID].name != _name)
1113             plyr_[_pID].name = _name;
1114         if (plyr_[_pID].laff != _laff)
1115             plyr_[_pID].laff = _laff;
1116         if (plyrNames_[_pID][_name] == false)
1117             plyrNames_[_pID][_name] = true;
1118     }
1119     
1120     /**
1121      * @dev receives entire player name list 
1122      */
1123     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1124         external
1125     {
1126         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1127         if(plyrNames_[_pID][_name] == false)
1128             plyrNames_[_pID][_name] = true;
1129     }   
1130         
1131     /**
1132      * @dev gets existing or registers new pID.  use this when a player may be new
1133      * @return pID 
1134      */
1135     function determinePID(Fumodatasets.EventReturns memory _eventData_)
1136         private
1137         returns (Fumodatasets.EventReturns)
1138     {
1139         uint256 _pID = pIDxAddr_[msg.sender];
1140         // if player is new to this version of fomo3d
1141         if (_pID == 0)
1142         {
1143             // grab their player ID, name and last aff ID, from player names contract 
1144             _pID = PlayerBook.getPlayerID(msg.sender);
1145             bytes32 _name = PlayerBook.getPlayerName(_pID);
1146             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1147             
1148             // set up player account 
1149             pIDxAddr_[msg.sender] = _pID;
1150             plyr_[_pID].addr = msg.sender;
1151             
1152             if (_name != "")
1153             {
1154                 pIDxName_[_name] = _pID;
1155                 plyr_[_pID].name = _name;
1156                 plyrNames_[_pID][_name] = true;
1157             }
1158             
1159             if (_laff != 0 && _laff != _pID)
1160                 plyr_[_pID].laff = _laff;
1161             
1162             // set the new player bool to true
1163             _eventData_.compressedData = _eventData_.compressedData + 1;
1164         } 
1165         return (_eventData_);
1166     }
1167     
1168     /**
1169      * @dev checks to make sure user picked a valid team.  if not sets team 
1170      * to default (sneks)
1171      */
1172     function verifyTeam(uint256 _team)
1173         private
1174         pure
1175         returns (uint256)
1176     {
1177         if (_team < 0 || _team > 3)
1178             return(2);
1179         else
1180             return(_team);
1181     }
1182     
1183     /**
1184      * @dev decides if round end needs to be run & new round started.  and if 
1185      * player unmasked earnings from previously played rounds need to be moved.
1186      */
1187     function managePlayer(uint256 _pID, Fumodatasets.EventReturns memory _eventData_)
1188         private
1189         returns (Fumodatasets.EventReturns)
1190     {
1191         // if player has played a previous round, move their unmasked earnings
1192         // from that round to gen vault.
1193         if (plyr_[_pID].lrnd != 0)
1194             updateGenVault(_pID, plyr_[_pID].lrnd);
1195             
1196         // update player's last round played
1197         plyr_[_pID].lrnd = rID_;
1198             
1199         // set the joined round bool to true
1200         _eventData_.compressedData = _eventData_.compressedData + 10;
1201         
1202         return(_eventData_);
1203     }
1204     
1205     /**
1206      * @dev ends the round. manages paying out winner/splitting up pot
1207      */
1208     function endRound(Fumodatasets.EventReturns memory _eventData_)
1209         private
1210         returns (Fumodatasets.EventReturns)
1211     {
1212         // setup local rID
1213         uint256 _rID = rID_;
1214         
1215         // grab our winning player and team id's
1216         uint256 _winPID = round_[_rID].plyr;
1217         uint256 _winTID = round_[_rID].team;
1218         
1219         // grab our pot amount
1220         uint256 _pot = round_[_rID].pot;
1221         
1222         // calculate our winner share, community rewards, gen share, 
1223         // p3d share, and amount reserved for next pot 
1224         uint256 _win = (_pot.mul(48)) / 100;
1225         uint256 _com = (_pot.mul(6) / 50);
1226         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1227         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1228         
1229         // calculate ppt for round mask
1230         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1231         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1232         if (_dust > 0)
1233         {
1234             _gen = _gen.sub(_dust);
1235             _res = _res.add(_dust);
1236         }
1237         
1238         // pay our winner
1239         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1240         
1241         // community rewards
1242         community_addr.transfer(_com);
1243         
1244         // distribute gen portion to key holders
1245         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1246         
1247             
1248         // prepare event data
1249         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1250         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1251         _eventData_.winnerAddr = plyr_[_winPID].addr;
1252         _eventData_.winnerName = plyr_[_winPID].name;
1253         _eventData_.amountWon = _win;
1254         _eventData_.genAmount = _gen;
1255         _eventData_.P3DAmount = 0;
1256         _eventData_.newPot = _res;
1257         
1258         // start next round
1259         rID_++;
1260         _rID++;
1261         round_[_rID].strt = now;
1262         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1263         round_[_rID].pot = _res;
1264         
1265         return(_eventData_);
1266     }
1267     
1268     /**
1269      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1270      */
1271     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1272         private 
1273     {
1274         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1275         if (_earnings > 0)
1276         {
1277             // put in gen vault
1278             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1279             // zero out their earnings by updating mask
1280             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1281         }
1282     }
1283     
1284     /**
1285      * @dev updates round timer based on number of whole keys bought.
1286      */
1287     function updateTimer(uint256 _keys, uint256 _rID)
1288         private
1289     {
1290         // grab time
1291         uint256 _now = now;
1292         
1293         // calculate time based on number of keys bought
1294         uint256 _newTime;
1295         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1296             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1297         else
1298             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1299         
1300         // compare to max and set new end time
1301         if (_newTime < (rndMax_).add(_now))
1302             round_[_rID].end = _newTime;
1303         else
1304             round_[_rID].end = rndMax_.add(_now);
1305     }
1306     
1307     /**
1308      * @dev generates a random number between 0-99 and checks to see if thats
1309      * resulted in an airdrop win
1310      * @return do we have a winner?
1311      */
1312     function airdrop()
1313         private 
1314         view 
1315         returns(bool)
1316     {
1317         uint256 seed = uint256(keccak256(abi.encodePacked(
1318             
1319             (block.timestamp).add
1320             (block.difficulty).add
1321             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1322             (block.gaslimit).add
1323             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1324             (block.number)
1325             
1326         )));
1327         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1328             return(true);
1329         else
1330             return(false);
1331     }
1332 
1333     /**
1334      * @dev distributes eth based on fees to com, aff, and p3d
1335      */
1336     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Fumodatasets.EventReturns memory _eventData_)
1337         private
1338         returns(Fumodatasets.EventReturns)
1339     {
1340         // pay 2% out to community rewards
1341         uint256 _com = _eth / 50;
1342         
1343     
1344         
1345         // distribute share to affiliate
1346         uint256 _aff = _eth / 5;
1347         
1348         // decide what to do with affiliate share of fees
1349         // affiliate must not be self, and must have a name registered
1350         if (_affID != _pID && plyr_[_affID].name != '') {
1351             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1352             emit FumoEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1353         } else {
1354             _com = _com.add(_aff);
1355         }
1356         community_addr.transfer(_com);
1357         
1358         return(_eventData_);
1359     }
1360     
1361     /**
1362      * @dev distributes eth based on fees to gen and pot
1363      */
1364     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Fumodatasets.EventReturns memory _eventData_)
1365         private
1366         returns(Fumodatasets.EventReturns)
1367     {
1368         // calculate gen share
1369         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1370         
1371         // toss 2% into airdrop pot 
1372         uint256 _air = (_eth / 50);
1373         airDropPot_ = airDropPot_.add(_air);
1374         
1375         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1376         _eth = _eth.sub(((_eth.mul(24)) / 100));
1377         
1378         // calculate pot 
1379         uint256 _pot = _eth.sub(_gen);
1380         
1381         // distribute gen share (thats what updateMasks() does) and adjust
1382         // balances for dust.
1383         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1384         if (_dust > 0)
1385             _gen = _gen.sub(_dust);
1386         
1387         // add eth to pot
1388         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1389         
1390         // set up event data
1391         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1392         _eventData_.potAmount = _pot;
1393         
1394         return(_eventData_);
1395     }
1396 
1397     /**
1398      * @dev updates masks for round and player when keys are bought
1399      * @return dust left over 
1400      */
1401     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1402         private
1403         returns(uint256)
1404     {
1405         /* MASKING NOTES
1406             earnings masks are a tricky thing for people to wrap their minds around.
1407             the basic thing to understand here.  is were going to have a global
1408             tracker based on profit per share for each round, that increases in
1409             relevant proportion to the increase in share supply.
1410             
1411             the player will have an additional mask that basically says "based
1412             on the rounds mask, my shares, and how much i've already withdrawn,
1413             how much is still owed to me?"
1414         */
1415         
1416         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1417         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1418         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1419             
1420         // calculate player earning from their own buy (only based on the keys
1421         // they just bought).  & update player earnings mask
1422         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1423         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1424         
1425         // calculate & return dust
1426         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1427     }
1428     
1429     /**
1430      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1431      * @return earnings in wei format
1432      */
1433     function withdrawEarnings(uint256 _pID)
1434         private
1435         returns(uint256)
1436     {
1437         // update gen vault
1438         updateGenVault(_pID, plyr_[_pID].lrnd);
1439         
1440         // from vaults 
1441         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1442         if (_earnings > 0)
1443         {
1444             plyr_[_pID].win = 0;
1445             plyr_[_pID].gen = 0;
1446             plyr_[_pID].aff = 0;
1447         }
1448 
1449         return(_earnings);
1450     }
1451     
1452     /**
1453      * @dev prepares compression data and fires event for buy or reload tx's
1454      */
1455     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Fumodatasets.EventReturns memory _eventData_)
1456         private
1457     {
1458         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1459         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1460         
1461         emit FumoEvents.onEndTx
1462         (
1463             _eventData_.compressedData,
1464             _eventData_.compressedIDs,
1465             plyr_[_pID].name,
1466             msg.sender,
1467             _eth,
1468             _keys,
1469             _eventData_.winnerAddr,
1470             _eventData_.winnerName,
1471             _eventData_.amountWon,
1472             _eventData_.newPot,
1473             _eventData_.P3DAmount,
1474             _eventData_.genAmount,
1475             _eventData_.potAmount,
1476             airDropPot_
1477         );
1478     }
1479 	//激活合约
1480     bool public activated_ = false;
1481     function activate()
1482         public
1483     {
1484         // only team just can activate 
1485         require(
1486             msg.sender == community_addr, "only community can activate"
1487         );
1488 
1489         
1490         // can only be ran once
1491         require(activated_ == false, "fumo already activated");
1492         
1493         // activate the contract 
1494         activated_ = true;
1495         
1496         // lets start first round
1497 		rID_ = 1;
1498         round_[1].strt = now + rndExtra_ - rndGap_;
1499         round_[1].end = now + rndInit_ + rndExtra_;
1500     }
1501 }
1502 
1503 //==============================================================================
1504 //   __|_ _    __|_ _  .
1505 //  _\ | | |_|(_ | _\  .
1506 //==============================================================================
1507 library Fumodatasets {
1508     //compressedData key
1509     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1510         // 0 - new player (bool)
1511         // 1 - joined round (bool)
1512         // 2 - new  leader (bool)
1513         // 3-5 - air drop tracker (uint 0-999)
1514         // 6-16 - round end time
1515         // 17 - winnerTeam
1516         // 18 - 28 timestamp 
1517         // 29 - team
1518         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1519         // 31 - airdrop happened bool
1520         // 32 - airdrop tier 
1521         // 33 - airdrop amount won
1522     //compressedIDs key
1523     // [77-52][51-26][25-0]
1524         // 0-25 - pID 
1525         // 26-51 - winPID
1526         // 52-77 - rID
1527     struct EventReturns {
1528         uint256 compressedData;
1529         uint256 compressedIDs;
1530         address winnerAddr;         // winner address
1531         bytes32 winnerName;         // winner name
1532         uint256 amountWon;          // amount won
1533         uint256 newPot;             // amount in new pot
1534         uint256 P3DAmount;          // amount distributed to p3d
1535         uint256 genAmount;          // amount distributed to gen
1536         uint256 potAmount;          // amount added to pot
1537     }
1538     struct Player {
1539         address addr;   // player address
1540         bytes32 name;   // player name
1541         uint256 win;    // winnings vault
1542         uint256 gen;    // general vault
1543         uint256 aff;    // affiliate vault
1544         uint256 lrnd;   // last round played
1545         uint256 laff;   // last affiliate id used
1546     }
1547     struct PlayerRounds {
1548         uint256 eth;    // eth player has added to round (used for eth limiter)
1549         uint256 keys;   // keys
1550         uint256 mask;   // player mask 
1551         uint256 ico;    // ICO phase investment
1552     }
1553     struct Round {
1554         uint256 plyr;   // pID of player in lead
1555         uint256 team;   // tID of team in lead
1556         uint256 end;    // time ends/ended
1557         bool ended;     // has round end function been ran
1558         uint256 strt;   // time round started
1559         uint256 keys;   // keys
1560         uint256 eth;    // total eth in
1561         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1562         uint256 mask;   // global mask
1563         uint256 ico;    // total eth sent in during ICO phase
1564         uint256 icoGen; // total eth for gen during ICO phase
1565         uint256 icoAvg; // average key price for ICO phase
1566     }
1567     struct TeamFee {
1568         uint256 gen;    // % of buy in thats paid to key holders of current round
1569         uint256 p3d;    // % of buy in thats paid to p3d holders
1570     }
1571     struct PotSplit {
1572         uint256 gen;    // % of pot thats paid to key holders of current round
1573         uint256 p3d;    // % of pot thats paid to p3d holders
1574     }
1575 }
1576 
1577 //==============================================================================
1578 //  |  _      _ _ | _  .
1579 //  |<(/_\/  (_(_||(_  .
1580 //=======/======================================================================
1581 library FumoKeysCalcLong {
1582     using SafeMath for *;
1583     /**
1584      * @dev calculates number of keys received given X eth 
1585      * @param _curEth current amount of eth in contract 
1586      * @param _newEth eth being spent
1587      * @return amount of ticket purchased
1588      */
1589     function keysRec(uint256 _curEth, uint256 _newEth)
1590         internal
1591         pure
1592         returns (uint256)
1593     {
1594         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1595     }
1596 
1597     /**
1598      * @dev calculates amount of eth received if you sold X keys 
1599      * @param _curKeys current amount of keys that exist 
1600      * @param _sellKeys amount of keys you wish to sell
1601      * @return amount of eth received
1602      */
1603     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1604         internal
1605         pure
1606         returns (uint256)
1607     {
1608         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1609     }
1610 
1611     /**
1612      * @dev calculates how many keys would exist with given an amount of eth
1613      * @param _eth eth "in contract"
1614      * @return number of keys that would exist
1615      */
1616     function keys(uint256 _eth) 
1617         internal
1618         pure
1619         returns(uint256)
1620     {
1621         return ((((((_eth).mul(1000000000000000000)).mul(156250000000000000000000000)).add(1406247070314025878906250000000000000000000000000000000000000000)).sqrt()).sub(37499960937500000000000000000000)) / (78125000);
1622     }
1623 
1624     /**
1625      * @dev calculates how much eth would be in contract given a number of keys
1626      * @param _keys number of keys "in contract" 
1627      * @return eth that would exists
1628      */
1629     function eth(uint256 _keys) 
1630         internal
1631         pure
1632         returns(uint256)  
1633     {
1634         return ((39062500).mul(_keys.sq()).add(((74999921875000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1635     }
1636 }
1637 
1638 //==============================================================================
1639 //  . _ _|_ _  _ |` _  _ _  _  .
1640 //  || | | (/_| ~|~(_|(_(/__\  .
1641 //==============================================================================
1642 
1643 interface PlayerBookInterface {
1644     function getPlayerID(address _addr) external returns (uint256);
1645     function getPlayerName(uint256 _pID) external view returns (bytes32);
1646     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1647     function getPlayerAddr(uint256 _pID) external view returns (address);
1648     function getNameFee() external view returns (uint256);
1649     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1650     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1651     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1652 }
1653 
1654 
1655 library NameFilter {
1656     /**
1657      * @dev filters name strings
1658      * -converts uppercase to lower case.  
1659      * -makes sure it does not start/end with a space
1660      * -makes sure it does not contain multiple spaces in a row
1661      * -cannot be only numbers
1662      * -cannot start with 0x 
1663      * -restricts characters to A-Z, a-z, 0-9, and space.
1664      * @return reprocessed string in bytes32 format
1665      */
1666     function nameFilter(string _input)
1667         internal
1668         pure
1669         returns(bytes32)
1670     {
1671         bytes memory _temp = bytes(_input);
1672         uint256 _length = _temp.length;
1673         
1674         //sorry limited to 32 characters
1675         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1676         // make sure it doesnt start with or end with space
1677         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1678         // make sure first two characters are not 0x
1679         if (_temp[0] == 0x30)
1680         {
1681             require(_temp[1] != 0x78, "string cannot start with 0x");
1682             require(_temp[1] != 0x58, "string cannot start with 0X");
1683         }
1684         
1685         // create a bool to track if we have a non number character
1686         bool _hasNonNumber;
1687         
1688         // convert & check
1689         for (uint256 i = 0; i < _length; i++)
1690         {
1691             // if its uppercase A-Z
1692             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1693             {
1694                 // convert to lower case a-z
1695                 _temp[i] = byte(uint(_temp[i]) + 32);
1696                 
1697                 // we have a non number
1698                 if (_hasNonNumber == false)
1699                     _hasNonNumber = true;
1700             } else {
1701                 require
1702                 (
1703                     // require character is a space
1704                     _temp[i] == 0x20 || 
1705                     // OR lowercase a-z
1706                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1707                     // or 0-9
1708                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1709                     "string contains invalid characters"
1710                 );
1711                 // make sure theres not 2x spaces in a row
1712                 if (_temp[i] == 0x20)
1713                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1714                 
1715                 // see if we have a character other than a number
1716                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1717                     _hasNonNumber = true;    
1718             }
1719         }
1720         
1721         require(_hasNonNumber == true, "string cannot be only numbers");
1722         
1723         bytes32 _ret;
1724         assembly {
1725             _ret := mload(add(_temp, 32))
1726         }
1727         return (_ret);
1728     }
1729 }
1730 
1731 /**
1732  * @title SafeMath v0.1.9
1733  * @dev Math operations with safety checks that throw on error
1734  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1735  * - added sqrt
1736  * - added sq
1737  * - added pwr 
1738  * - changed asserts to requires with error log outputs
1739  * - removed div, its useless
1740  */
1741 library SafeMath {
1742     
1743     /**
1744     * @dev Multiplies two numbers, throws on overflow.
1745     */
1746     function mul(uint256 a, uint256 b) 
1747         internal 
1748         pure 
1749         returns (uint256 c) 
1750     {
1751         if (a == 0) {
1752             return 0;
1753         }
1754         c = a * b;
1755         require(c / a == b, "SafeMath mul failed");
1756         return c;
1757     }
1758 
1759     /**
1760     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1761     */
1762     function sub(uint256 a, uint256 b)
1763         internal
1764         pure
1765         returns (uint256) 
1766     {
1767         require(b <= a, "SafeMath sub failed");
1768         return a - b;
1769     }
1770 
1771     /**
1772     * @dev Adds two numbers, throws on overflow.
1773     */
1774     function add(uint256 a, uint256 b)
1775         internal
1776         pure
1777         returns (uint256 c) 
1778     {
1779         c = a + b;
1780         require(c >= a, "SafeMath add failed");
1781         return c;
1782     }
1783     
1784     /**
1785      * @dev gives square root of given x.
1786      */
1787     function sqrt(uint256 x)
1788         internal
1789         pure
1790         returns (uint256 y) 
1791     {
1792         uint256 z = ((add(x,1)) / 2);
1793         y = x;
1794         while (z < y) 
1795         {
1796             y = z;
1797             z = ((add((x / z),z)) / 2);
1798         }
1799     }
1800     
1801     /**
1802      * @dev gives square. multiplies x by x
1803      */
1804     function sq(uint256 x)
1805         internal
1806         pure
1807         returns (uint256)
1808     {
1809         return (mul(x,x));
1810     }
1811     
1812     /**
1813      * @dev x to the power of y 
1814      */
1815     function pwr(uint256 x, uint256 y)
1816         internal 
1817         pure 
1818         returns (uint256)
1819     {
1820         if (x==0)
1821             return (0);
1822         else if (y==0)
1823             return (1);
1824         else 
1825         {
1826             uint256 z = x;
1827             for (uint256 i=1; i < y; i++)
1828                 z = mul(z,x);
1829             return (z);
1830         }
1831     }
1832 }