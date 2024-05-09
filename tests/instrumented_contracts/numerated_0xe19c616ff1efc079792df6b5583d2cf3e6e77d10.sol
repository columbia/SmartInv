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
37     // fired whenever theres a withdraw
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
114 }
115 
116 contract modularLong is F3Devents {}
117 
118 contract FoMo3Dlong is modularLong {
119     using SafeMath for *;
120     using NameFilter for string;
121     using F3DKeysCalcLong for uint256;
122 
123     address private otherF3D_ = 0x6ccAb77AC0A2a7665E84f2B84b44Ca31beB435eB; // 慈善基金
124     address constant private reward = 0x03164e242C8CBD528a1400B805d796Df02E13544; // 团队基金
125     address constant private deployer = 0xDb9396B9c7D639b7B79C33f1d100F78E042e725f; // 开发者
126     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xcdE4B62AADdf8c94c78acC47dC26364170e609da);
127 
128     string constant public name = "The Winner";
129     string constant public symbol = "WINNER";
130     uint256 constant private rndInit_ = 12 hours;                // round timer starts at this
131     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
132     uint256 constant private rndMax_ = 12 hours;                // max length a round timer can be
133     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
134     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
135     uint256 public rID_;    // round id number / total rounds that have happened
136 
137     // (addr => pID) returns player id by address
138     mapping (address => uint256) public pIDxAddr_;          
139     // (name => pID) returns player id by name
140     mapping (bytes32 => uint256) public pIDxName_;          
141     // (pID => data) player data
142     mapping (uint256 => F3Ddatasets.Player) public plyr_;   
143     // (pID => rID => data) player round data by player id & round id
144     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;   
145     // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own) 
146     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; 
147     // (rID => data) round data
148     mapping (uint256 => F3Ddatasets.Round) public round_;   
149     // (rID => tID => data) eth in per team, by round id and team id
150     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      
151     // (team => fees) fee distribution by team
152     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          
153     // (team => fees) pot split distribution by team
154     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     
155 
156     // initial data setup upon contract deploy
157     constructor()
158         public
159     {
160         // Team allocation structures
161         // 0 = whales = 暴风 -> A
162         // 1 = bears  = 冰川 -> B
163         // 2 = sneks  = 雷电 -> C
164         // 3 = bulls  = 烈日 -> D
165 
166         // X.FLY HACK gen 意思改为玩家分配比例，p3d 意思改为奖池分配比例
167         fees_[0] = F3Ddatasets.TeamFee(73,11);
168         fees_[1] = F3Ddatasets.TeamFee(81,3);
169         fees_[2] = F3Ddatasets.TeamFee(32,32);
170         fees_[3] = F3Ddatasets.TeamFee(40,10);
171         
172         potSplit_[0] = F3Ddatasets.PotSplit(90,10);
173         potSplit_[1] = F3Ddatasets.PotSplit(67,33);
174         potSplit_[2] = F3Ddatasets.PotSplit(93,7);
175         potSplit_[3] = F3Ddatasets.PotSplit(80,20);
176     }
177 
178     /**
179      * @dev used to make sure no one can interact with contract until it has 
180      * been activated. these are safety checks
181      */
182     modifier isActivated() {
183         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
184         _;
185     }
186     
187     /**
188      * @dev prevents contracts from interacting with fomo3d 
189      */
190     modifier isHuman() {
191         address _addr = msg.sender;
192         uint256 _codeLength;
193         
194         assembly {_codeLength := extcodesize(_addr)}
195         require(_codeLength == 0, "sorry humans only");
196         _;
197     }
198 
199     /**
200      * @dev sets boundaries for incoming tx 
201      */
202     modifier isWithinLimits(uint256 _eth) {
203         require(_eth >= 1000000000, "pocket lint: not a valid currency");
204         require(_eth <= 100000000000000000000000, "no vitalik, no");
205         _;    
206     }
207     
208     /**
209      * @dev emergency buy uses last stored affiliate ID and team snek
210      */
211     function()
212         public
213         isActivated()
214         isHuman()
215         isWithinLimits(msg.value)
216         payable
217     {
218         // set up our tx event data and determine if player is new or not
219         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
220             
221         // fetch player id
222         uint256 _pID = pIDxAddr_[msg.sender];
223         
224         // buy core 
225         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
226     }
227     
228     /**
229      * @dev converts all incoming ethereum to keys.
230      * -functionhash- 0x8f38f309 (using ID for affiliate)
231      * -functionhash- 0x98a0871d (using address for affiliate)
232      * -functionhash- 0xa65b37a1 (using name for affiliate)
233      * @param _affCode the ID/address/name of the player who gets the affiliate fee
234      * @param _team what team is the player playing for?
235      */
236     function buyXid(uint256 _affCode, uint256 _team)
237         isActivated()
238         isHuman()
239         isWithinLimits(msg.value)
240         public
241         payable
242     {
243         // set up our tx event data and determine if player is new or not
244         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
245         
246         // fetch player id
247         uint256 _pID = pIDxAddr_[msg.sender];
248         
249         // manage affiliate residuals
250         // if no affiliate code was given or player tried to use their own, lolz
251         if (_affCode == 0 || _affCode == _pID)
252         {
253             // use last stored affiliate code 
254             _affCode = plyr_[_pID].laff;
255             
256         // if affiliate code was given & its not the same as previously stored 
257         } else if (_affCode != plyr_[_pID].laff) {
258             // update last affiliate 
259             plyr_[_pID].laff = _affCode;
260         }
261         
262         // verify a valid team was selected
263         _team = verifyTeam(_team);
264         
265         // buy core 
266         buyCore(_pID, _affCode, _team, _eventData_);
267     }
268     
269     function buyXaddr(
270         address _affCode, 
271         uint256 _team
272     )
273         public
274         isActivated()
275         isHuman()
276         isWithinLimits(msg.value)
277         payable
278     {
279         // set up our tx event data and determine if player is new or not
280         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
281         
282         // fetch player id
283         uint256 _pID = pIDxAddr_[msg.sender];
284         
285         // manage affiliate residuals
286         uint256 _affID;
287         // if no affiliate code was given or player tried to use their own, lolz
288         if (_affCode == address(0) || _affCode == msg.sender)
289         {
290             // use last stored affiliate code
291             _affID = plyr_[_pID].laff;
292         
293         // if affiliate code was given    
294         } else {
295             // get affiliate ID from aff Code 
296             _affID = pIDxAddr_[_affCode];
297             
298             // if affID is not the same as previously stored 
299             if (_affID != plyr_[_pID].laff)
300             {
301                 // update last affiliate
302                 plyr_[_pID].laff = _affID;
303             }
304         }
305         
306         // verify a valid team was selected
307         _team = verifyTeam(_team);
308         
309         // buy core 
310         buyCore(_pID, _affID, _team, _eventData_);
311     }
312     
313     function buyXname(bytes32 _affCode, uint256 _team)
314         isActivated()
315         isHuman()
316         isWithinLimits(msg.value)
317         public
318         payable
319     {
320         // set up our tx event data and determine if player is new or not
321         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
322         
323         // fetch player id
324         uint256 _pID = pIDxAddr_[msg.sender];
325         
326         // manage affiliate residuals
327         uint256 _affID;
328         // if no affiliate code was given or player tried to use their own, lolz
329         if (_affCode == "" || _affCode == plyr_[_pID].name)
330         {
331             // use last stored affiliate code
332             _affID = plyr_[_pID].laff;
333         
334         // if affiliate code was given
335         } else {
336             // get affiliate ID from aff Code
337             _affID = pIDxName_[_affCode];
338             
339             // if affID is not the same as previously stored
340             if (_affID != plyr_[_pID].laff)
341             {
342                 // update last affiliate
343                 plyr_[_pID].laff = _affID;
344             }
345         }
346         
347         // verify a valid team was selected
348         _team = verifyTeam(_team);
349         
350         // buy core 
351         buyCore(_pID, _affID, _team, _eventData_);
352     }
353     
354     /**
355      * @dev essentially the same as buy, but instead of you sending ether 
356      * from your wallet, it uses your unwithdrawn earnings.
357      * -functionhash- 0x349cdcac (using ID for affiliate)
358      * -functionhash- 0x82bfc739 (using address for affiliate)
359      * -functionhash- 0x079ce327 (using name for affiliate)
360      * @param _affCode the ID/address/name of the player who gets the affiliate fee
361      * @param _team what team is the player playing for?
362      * @param _eth amount of earnings to use (remainder returned to gen vault)
363      */
364     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
365         isActivated()
366         isHuman()
367         isWithinLimits(_eth)
368         public
369     {
370         // set up our tx event data
371         F3Ddatasets.EventReturns memory _eventData_;
372         
373         // fetch player ID
374         uint256 _pID = pIDxAddr_[msg.sender];
375         
376         // manage affiliate residuals
377         // if no affiliate code was given or player tried to use their own, lolz
378         if (_affCode == 0 || _affCode == _pID)
379         {
380             // use last stored affiliate code 
381             _affCode = plyr_[_pID].laff;
382             
383         // if affiliate code was given & its not the same as previously stored 
384         } else if (_affCode != plyr_[_pID].laff) {
385             // update last affiliate 
386             plyr_[_pID].laff = _affCode;
387         }
388 
389         // verify a valid team was selected
390         _team = verifyTeam(_team);
391 
392         // reload core
393         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
394     }
395     
396     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
397         public
398         isActivated()
399         isHuman()
400         isWithinLimits(_eth)
401     {
402         // set up our tx event data
403         F3Ddatasets.EventReturns memory _eventData_;
404         
405         // fetch player ID
406         uint256 _pID = pIDxAddr_[msg.sender];
407         
408         // manage affiliate residuals
409         uint256 _affID;
410         // if no affiliate code was given or player tried to use their own, lolz
411         if (_affCode == address(0) || _affCode == msg.sender)
412         {
413             // use last stored affiliate code
414             _affID = plyr_[_pID].laff;
415         
416         // if affiliate code was given    
417         } else {
418             // get affiliate ID from aff Code 
419             _affID = pIDxAddr_[_affCode];
420             
421             // if affID is not the same as previously stored 
422             if (_affID != plyr_[_pID].laff)
423             {
424                 // update last affiliate
425                 plyr_[_pID].laff = _affID;
426             }
427         }
428         
429         // verify a valid team was selected
430         _team = verifyTeam(_team);
431         
432         // reload core
433         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
434     }
435     
436     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
437         public
438         isActivated()
439         isHuman()
440         isWithinLimits(_eth)
441     {
442         // set up our tx event data
443         F3Ddatasets.EventReturns memory _eventData_;
444         
445         // fetch player ID
446         uint256 _pID = pIDxAddr_[msg.sender];
447         
448         // manage affiliate residuals
449         uint256 _affID;
450         // if no affiliate code was given or player tried to use their own, lolz
451         if (_affCode == "" || _affCode == plyr_[_pID].name)
452         {
453             // use last stored affiliate code
454             _affID = plyr_[_pID].laff;
455         
456         // if affiliate code was given
457         } else {
458             // get affiliate ID from aff Code
459             _affID = pIDxName_[_affCode];
460             
461             // if affID is not the same as previously stored
462             if (_affID != plyr_[_pID].laff)
463             {
464                 // update last affiliate
465                 plyr_[_pID].laff = _affID;
466             }
467         }
468         
469         // verify a valid team was selected
470         _team = verifyTeam(_team);
471         
472         // reload core
473         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
474     }
475 
476     /**
477      * @dev withdraws all of your earnings.
478      * -functionhash- 0x3ccfd60b
479      */
480     function withdraw()
481         public
482         isActivated()
483         isHuman()
484     {
485         // setup local rID 
486         uint256 _rID = rID_;
487         
488         // grab time
489         uint256 _now = now;
490         
491         // fetch player ID
492         uint256 _pID = pIDxAddr_[msg.sender];
493         
494         // setup temp var for player eth
495         uint256 _eth;
496         
497         // check to see if round has ended and no one has run round end yet
498         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
499         {
500             // set up our tx event data
501             F3Ddatasets.EventReturns memory _eventData_;
502             
503             // end the round (distributes pot)
504             round_[_rID].ended = true;
505             _eventData_ = endRound(_eventData_);
506             
507             // get their earnings
508             _eth = withdrawEarnings(_pID);
509             
510             // gib moni
511             if (_eth > 0)
512                 plyr_[_pID].addr.transfer(_eth);    
513             
514             // build event data
515             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
516             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
517             
518             // fire withdraw and distribute event
519             emit F3Devents.onWithdrawAndDistribute
520             (
521                 msg.sender, 
522                 plyr_[_pID].name, 
523                 _eth, 
524                 _eventData_.compressedData, 
525                 _eventData_.compressedIDs, 
526                 _eventData_.winnerAddr, 
527                 _eventData_.winnerName, 
528                 _eventData_.amountWon, 
529                 _eventData_.newPot, 
530                 _eventData_.P3DAmount, 
531                 _eventData_.genAmount
532             );
533             
534         // in any other situation
535         } else {
536             // get their earnings
537             _eth = withdrawEarnings(_pID);
538             
539             // gib moni
540             if (_eth > 0)
541                 plyr_[_pID].addr.transfer(_eth);
542             
543             // fire withdraw event
544             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
545         }
546     }
547     
548     /**
549      * @dev use these to register names.  they are just wrappers that will send the
550      * registration requests to the PlayerBook contract.  So registering here is the 
551      * same as registering there.  UI will always display the last name you registered.
552      * but you will still own all previously registered names to use as affiliate 
553      * links.
554      * - must pay a registration fee.
555      * - name must be unique
556      * - names will be converted to lowercase
557      * - name cannot start or end with a space 
558      * - cannot have more than 1 space in a row
559      * - cannot be only numbers
560      * - cannot start with 0x 
561      * - name must be at least 1 char
562      * - max length of 32 characters long
563      * - allowed characters: a-z, 0-9, and space
564      * -functionhash- 0x921dec21 (using ID for affiliate)
565      * -functionhash- 0x3ddd4698 (using address for affiliate)
566      * -functionhash- 0x685ffd83 (using name for affiliate)
567      * @param _nameString players desired name
568      * @param _affCode affiliate ID, address, or name of who referred you
569      * @param _all set to true if you want this to push your info to all games 
570      * (this might cost a lot of gas)
571      */
572     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
573         public
574         isHuman()
575         payable
576     {
577         bytes32 _name = _nameString.nameFilter();
578         address _addr = msg.sender;
579         uint256 _paid = msg.value;
580         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
581         
582         uint256 _pID = pIDxAddr_[_addr];
583         
584         // fire event
585         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
586     }
587     
588     function registerNameXaddr(string _nameString, address _affCode, bool _all)
589         public
590         isHuman()
591         payable
592     {
593         bytes32 _name = _nameString.nameFilter();
594         address _addr = msg.sender;
595         uint256 _paid = msg.value;
596         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
597         
598         uint256 _pID = pIDxAddr_[_addr];
599         
600         // fire event
601         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
602     }
603     
604     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
605         public
606         isHuman()
607         payable
608     {
609         bytes32 _name = _nameString.nameFilter();
610         address _addr = msg.sender;
611         uint256 _paid = msg.value;
612         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
613         
614         uint256 _pID = pIDxAddr_[_addr];
615         
616         // fire event
617         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
618     }
619 //==============================================================================
620 //     _  _ _|__|_ _  _ _  .
621 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
622 //=====_|=======================================================================
623     /**
624      * @dev return the price buyer will pay for next 1 individual key.
625      * -functionhash- 0x018a25e8
626      * @return price for next key bought (in wei format)
627      */
628     function getBuyPrice()
629         public 
630         view 
631         returns(uint256)
632     {  
633         // setup local rID
634         uint256 _rID = rID_;
635         
636         // grab time
637         uint256 _now = now;
638         
639         // are we in a round?
640         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
641             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
642         else // rounds over.  need price for new round
643             return ( 75000000000000 ); // init
644     }
645     
646     /**
647      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
648      * provider
649      * -functionhash- 0xc7e284b8
650      * @return time left in seconds
651      */
652     function getTimeLeft()
653         public
654         view
655         returns(uint256)
656     {
657         // setup local rID
658         uint256 _rID = rID_;
659         
660         // grab time
661         uint256 _now = now;
662         
663         if (_now < round_[_rID].end)
664             if (_now > round_[_rID].strt)
665                 return( (round_[_rID].end).sub(_now) );
666             else
667                 return( (round_[_rID].strt).sub(_now) );
668         else
669             return(0);
670     }
671     
672     /**
673      * @dev returns player earnings per vaults 
674      * -functionhash- 0x63066434
675      * @return winnings vault
676      * @return general vault
677      * @return affiliate vault
678      */
679     function getPlayerVaults(uint256 _pID)
680         public
681         view
682         returns(uint256 ,uint256, uint256)
683     {
684         // setup local rID
685         uint256 _rID = rID_;
686         
687         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
688         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
689         {
690             // if player is winner 
691             if (round_[_rID].plyr == _pID)
692             {
693                 return
694                 (
695                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
696                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
697                     plyr_[_pID].aff
698                 );
699             // if player is not the winner
700             } else {
701                 return
702                 (
703                     plyr_[_pID].win,
704                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
705                     plyr_[_pID].aff
706                 );
707             }
708             
709         // if round is still going on, or round has ended and round end has been ran
710         } else {
711             return
712             (
713                 plyr_[_pID].win,
714                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
715                 plyr_[_pID].aff
716             );
717         }
718     }
719     
720     /**
721      * solidity hates stack limits.  this lets us avoid that hate 
722      */
723     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
724         private
725         view
726         returns(uint256)
727     {
728         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
729     }
730     
731     /**
732      * @dev returns all current round info needed for front end
733      * -functionhash- 0x747dff42
734      * @return eth invested during ICO phase
735      * @return round id 
736      * @return total keys for round 
737      * @return time round ends
738      * @return time round started
739      * @return current pot 
740      * @return current team ID & player ID in lead 
741      * @return current player in leads address 
742      * @return current player in leads name
743      * @return whales eth in for round
744      * @return bears eth in for round
745      * @return sneks eth in for round
746      * @return bulls eth in for round
747      * @return airdrop tracker # & airdrop pot
748      */
749     function getCurrentRoundInfo()
750         public
751         view
752         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
753     {
754         // setup local rID
755         uint256 _rID = rID_;
756         
757         return
758         (
759             round_[_rID].ico,               //0
760             _rID,                           //1
761             round_[_rID].keys,              //2
762             round_[_rID].end,               //3
763             round_[_rID].strt,              //4
764             round_[_rID].pot,               //5
765             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
766             plyr_[round_[_rID].plyr].addr,  //7
767             plyr_[round_[_rID].plyr].name,  //8
768             rndTmEth_[_rID][0],             //9
769             rndTmEth_[_rID][1],             //10
770             rndTmEth_[_rID][2],             //11
771             rndTmEth_[_rID][3],             //12
772             airDropTracker_ + (airDropPot_ * 1000)              //13
773         );
774     }
775 
776     /**
777      * @dev returns player info based on address.  if no address is given, it will 
778      * use msg.sender 
779      * -functionhash- 0xee0b5d8b
780      * @param _addr address of the player you want to lookup 
781      * @return player ID 
782      * @return player name
783      * @return keys owned (current round)
784      * @return winnings vault
785      * @return general vault 
786      * @return affiliate vault 
787      * @return player round eth
788      */
789     function getPlayerInfoByAddress(address _addr)
790         public 
791         view 
792         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
793     {
794         // setup local rID
795         uint256 _rID = rID_;
796         
797         if (_addr == address(0))
798         {
799             _addr == msg.sender;
800         }
801         uint256 _pID = pIDxAddr_[_addr];
802         
803         return
804         (
805             _pID,                               //0
806             plyr_[_pID].name,                   //1
807             plyrRnds_[_pID][_rID].keys,         //2
808             plyr_[_pID].win,                    //3
809             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
810             plyr_[_pID].aff,                    //5
811             plyrRnds_[_pID][_rID].eth           //6
812         );
813     }
814 
815 //==============================================================================
816 //     _ _  _ _   | _  _ . _  .
817 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
818 //=====================_|=======================================================
819     /**
820      * @dev logic runs whenever a buy order is executed.  determines how to handle 
821      * incoming eth depending on if we are in an active round or not
822      */
823     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
824         private
825     {
826         // setup local rID
827         uint256 _rID = rID_;
828         
829         // grab time
830         uint256 _now = now;
831         
832         // if round is active
833         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
834         {
835             // call core 
836             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
837         
838         // if round is not active     
839         } else {
840             // check to see if end round needs to be ran
841             if (_now > round_[_rID].end && round_[_rID].ended == false) 
842             {
843                 // end the round (distributes pot) & start new round
844                 round_[_rID].ended = true;
845                 _eventData_ = endRound(_eventData_);
846                 
847                 // build event data
848                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
849                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
850                 
851                 // fire buy and distribute event 
852                 emit F3Devents.onBuyAndDistribute
853                 (
854                     msg.sender, 
855                     plyr_[_pID].name, 
856                     msg.value, 
857                     _eventData_.compressedData, 
858                     _eventData_.compressedIDs, 
859                     _eventData_.winnerAddr, 
860                     _eventData_.winnerName, 
861                     _eventData_.amountWon, 
862                     _eventData_.newPot, 
863                     _eventData_.P3DAmount, 
864                     _eventData_.genAmount
865                 );
866             }
867             
868             // put eth in players vault 
869             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
870         }
871     }
872     
873     /**
874      * @dev logic runs whenever a reload order is executed.  determines how to handle 
875      * incoming eth depending on if we are in an active round or not 
876      */
877     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
878         private
879     {
880         // setup local rID
881         uint256 _rID = rID_;
882         
883         // grab time
884         uint256 _now = now;
885         
886         // if round is active
887         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
888         {
889             // get earnings from all vaults and return unused to gen vault
890             // because we use a custom safemath library.  this will throw if player 
891             // tried to spend more eth than they have.
892             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
893             
894             // call core 
895             core(_rID, _pID, _eth, _affID, _team, _eventData_);
896         
897         // if round is not active and end round needs to be ran   
898         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
899             // end the round (distributes pot) & start new round
900             round_[_rID].ended = true;
901             _eventData_ = endRound(_eventData_);
902                 
903             // build event data
904             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
905             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
906                 
907             // fire buy and distribute event 
908             emit F3Devents.onReLoadAndDistribute
909             (
910                 msg.sender, 
911                 plyr_[_pID].name, 
912                 _eventData_.compressedData, 
913                 _eventData_.compressedIDs, 
914                 _eventData_.winnerAddr, 
915                 _eventData_.winnerName, 
916                 _eventData_.amountWon, 
917                 _eventData_.newPot, 
918                 _eventData_.P3DAmount, 
919                 _eventData_.genAmount
920             );
921         }
922     }
923     
924     /**
925      * @dev this is the core logic for any buy/reload that happens while a round 
926      * is live.
927      */
928     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
929         private
930     {
931         // if player is new to round
932         if (plyrRnds_[_pID][_rID].keys == 0)
933             _eventData_ = managePlayer(_pID, _eventData_);
934         
935         // early round eth limiter 
936         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
937         {
938             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
939             uint256 _refund = _eth.sub(_availableLimit);
940             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
941             _eth = _availableLimit;
942         }
943         
944         // if eth left is greater than min eth allowed (sorry no pocket lint)
945         if (_eth > 1000000000) 
946         {
947             // mint the new keys
948             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
949             
950             // if they bought at least 1 whole key
951             if (_keys >= 1000000000000000000)
952             {
953                 updateTimer(_keys, _rID);
954 
955                 // set new leaders
956                 if (round_[_rID].plyr != _pID)
957                     round_[_rID].plyr = _pID;  
958                 if (round_[_rID].team != _team)
959                     round_[_rID].team = _team; 
960                 
961                 // set the new leader bool to true
962                 _eventData_.compressedData = _eventData_.compressedData + 100;
963             }
964             
965             // manage airdrops
966             if (_eth >= 100000000000000000)
967             {
968                 airDropTracker_++;
969                 if (airdrop() == true)
970                 {
971                     // gib muni
972                     uint256 _prize;
973                     if (_eth >= 10000000000000000000)
974                     {
975                         // calculate prize and give it to winner
976                         _prize = ((airDropPot_).mul(75)) / 100;
977                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
978                         
979                         // adjust airDropPot 
980                         airDropPot_ = (airDropPot_).sub(_prize);
981                         
982                         // let event know a tier 3 prize was won 
983                         _eventData_.compressedData += 300000000000000000000000000000000;
984                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
985                         // calculate prize and give it to winner
986                         _prize = ((airDropPot_).mul(50)) / 100;
987                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
988                         
989                         // adjust airDropPot 
990                         airDropPot_ = (airDropPot_).sub(_prize);
991                         
992                         // let event know a tier 2 prize was won 
993                         _eventData_.compressedData += 200000000000000000000000000000000;
994                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
995                         // calculate prize and give it to winner
996                         _prize = ((airDropPot_).mul(25)) / 100;
997                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
998                         
999                         // adjust airDropPot 
1000                         airDropPot_ = (airDropPot_).sub(_prize);
1001                         
1002                         // let event know a tier 3 prize was won 
1003                         _eventData_.compressedData += 300000000000000000000000000000000;
1004                     }
1005                     // set airdrop happened bool to true
1006                     _eventData_.compressedData += 10000000000000000000000000000000;
1007                     // let event know how much was won 
1008                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1009                     
1010                     // reset air drop tracker
1011                     airDropTracker_ = 0;
1012                 }
1013             }
1014     
1015             // store the air drop tracker number (number of buys since last airdrop)
1016             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1017             
1018             // update player 
1019             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1020             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1021             
1022             // update round
1023             round_[_rID].keys = _keys.add(round_[_rID].keys);
1024             round_[_rID].eth = _eth.add(round_[_rID].eth);
1025             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1026     
1027             // distribute eth
1028             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1029             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1030             
1031             // call end tx function to fire end tx event.
1032             endTx(_pID, _team, _eth, _keys, _eventData_);
1033         }
1034     }
1035 //==============================================================================
1036 //     _ _ | _   | _ _|_ _  _ _  .
1037 //    (_(_||(_|_||(_| | (_)| _\  .
1038 //==============================================================================
1039     /**
1040      * @dev calculates unmasked earnings (just calculates, does not update mask)
1041      * @return earnings in wei format
1042      */
1043     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1044         private
1045         view
1046         returns(uint256)
1047     {
1048         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1049     }
1050     
1051     /** 
1052      * @dev returns the amount of keys you would get given an amount of eth. 
1053      * -functionhash- 0xce89c80c
1054      * @param _rID round ID you want price for
1055      * @param _eth amount of eth sent in 
1056      * @return keys received 
1057      */
1058     function calcKeysReceived(uint256 _rID, uint256 _eth)
1059         public
1060         view
1061         returns(uint256)
1062     {
1063         // grab time
1064         uint256 _now = now;
1065         
1066         // are we in a round?
1067         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1068             return ( (round_[_rID].eth).keysRec(_eth) );
1069         else // rounds over.  need keys for new round
1070             return ( (_eth).keys() );
1071     }
1072     
1073     /** 
1074      * @dev returns current eth price for X keys.  
1075      * -functionhash- 0xcf808000
1076      * @param _keys number of keys desired (in 18 decimal format)
1077      * @return amount of eth needed to send
1078      */
1079     function iWantXKeys(uint256 _keys)
1080         public
1081         view
1082         returns(uint256)
1083     {
1084         // setup local rID
1085         uint256 _rID = rID_;
1086         
1087         // grab time
1088         uint256 _now = now;
1089         
1090         // are we in a round?
1091         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1092             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1093         else // rounds over.  need price for new round
1094             return ( (_keys).eth() );
1095     }
1096 //==============================================================================
1097 //    _|_ _  _ | _  .
1098 //     | (_)(_)|_\  .
1099 //==============================================================================
1100     /**
1101      * @dev receives name/player info from names contract 
1102      */
1103     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1104         external
1105     {
1106         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1107         if (pIDxAddr_[_addr] != _pID)
1108             pIDxAddr_[_addr] = _pID;
1109         if (pIDxName_[_name] != _pID)
1110             pIDxName_[_name] = _pID;
1111         if (plyr_[_pID].addr != _addr)
1112             plyr_[_pID].addr = _addr;
1113         if (plyr_[_pID].name != _name)
1114             plyr_[_pID].name = _name;
1115         if (plyr_[_pID].laff != _laff)
1116             plyr_[_pID].laff = _laff;
1117         if (plyrNames_[_pID][_name] == false)
1118             plyrNames_[_pID][_name] = true;
1119     }
1120     
1121     /**
1122      * @dev receives entire player name list 
1123      */
1124     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1125         external
1126     {
1127         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1128         if(plyrNames_[_pID][_name] == false)
1129             plyrNames_[_pID][_name] = true;
1130     }   
1131         
1132     /**
1133      * @dev gets existing or registers new pID.  use this when a player may be new
1134      * @return pID 
1135      */
1136     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1137         private
1138         returns (F3Ddatasets.EventReturns)
1139     {
1140         uint256 _pID = pIDxAddr_[msg.sender];
1141         // if player is new to this version of fomo3d
1142         if (_pID == 0)
1143         {
1144             // grab their player ID, name and last aff ID, from player names contract 
1145             _pID = PlayerBook.getPlayerID(msg.sender);
1146             bytes32 _name = PlayerBook.getPlayerName(_pID);
1147             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1148             
1149             // set up player account 
1150             pIDxAddr_[msg.sender] = _pID;
1151             plyr_[_pID].addr = msg.sender;
1152             
1153             if (_name != "")
1154             {
1155                 pIDxName_[_name] = _pID;
1156                 plyr_[_pID].name = _name;
1157                 plyrNames_[_pID][_name] = true;
1158             }
1159             
1160             if (_laff != 0 && _laff != _pID)
1161                 plyr_[_pID].laff = _laff;
1162             
1163             // set the new player bool to true
1164             _eventData_.compressedData = _eventData_.compressedData + 1;
1165         } 
1166         return (_eventData_);
1167     }
1168     
1169     /**
1170      * @dev checks to make sure user picked a valid team.  if not sets team 
1171      * to default (sneks)
1172      */
1173     function verifyTeam(uint256 _team)
1174         private
1175         pure
1176         returns (uint256)
1177     {
1178         if (_team < 0 || _team > 3)
1179             return(2);
1180         else
1181             return(_team);
1182     }
1183     
1184     /**
1185      * @dev decides if round end needs to be run & new round started.  and if 
1186      * player unmasked earnings from previously played rounds need to be moved.
1187      */
1188     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1189         private
1190         returns (F3Ddatasets.EventReturns)
1191     {
1192         // if player has played a previous round, move their unmasked earnings
1193         // from that round to gen vault.
1194         if (plyr_[_pID].lrnd != 0)
1195             updateGenVault(_pID, plyr_[_pID].lrnd);
1196             
1197         // update player's last round played
1198         plyr_[_pID].lrnd = rID_;
1199             
1200         // set the joined round bool to true
1201         _eventData_.compressedData = _eventData_.compressedData + 10;
1202         
1203         return(_eventData_);
1204     }
1205     
1206     /**
1207      * @dev ends the round. manages paying out winner/splitting up pot
1208      */
1209     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1210         private
1211         returns (F3Ddatasets.EventReturns)
1212     {
1213         // setup local rID
1214         uint256 _rID = rID_;
1215         
1216         // grab our winning player and team id's
1217         uint256 _winPID = round_[_rID].plyr;
1218         uint256 _winTID = round_[_rID].team;
1219         
1220         // grab our pot amount
1221         uint256 _pot = round_[_rID].pot;
1222         
1223         // calculate our winner share, community rewards, gen share, amount reserved for next pot 
1224         // X.FLY HACK
1225         // gen 意思变为赢家分配比例，p3d 意思变为下一轮分配比例，
1226         // 移除其他分配
1227         uint256 _win = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1228         uint256 _res = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1229         
1230         // pay our winner
1231         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1232 
1233         // prepare event data
1234         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1235         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1236         _eventData_.winnerAddr = plyr_[_winPID].addr;
1237         _eventData_.winnerName = plyr_[_winPID].name;
1238         _eventData_.amountWon = _win;
1239         _eventData_.genAmount = 0;
1240         _eventData_.P3DAmount = 0;
1241         _eventData_.newPot = _res;
1242         
1243         // start next round
1244         rID_++;
1245         _rID++;
1246         round_[_rID].strt = now;
1247         round_[_rID].end = now.add(rndInit_);
1248         round_[_rID].pot = _res;
1249         
1250         return(_eventData_);
1251     }
1252     
1253     /**
1254      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1255      */
1256     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1257         private 
1258     {
1259         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1260         if (_earnings > 0)
1261         {
1262             // put in gen vault
1263             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1264             // zero out their earnings by updating mask
1265             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1266         }
1267     }
1268     
1269     /**
1270      * @dev updates round timer based on number of whole keys bought.
1271      */
1272     function updateTimer(uint256 _keys, uint256 _rID)
1273         private
1274     {
1275         // grab time
1276         uint256 _now = now;
1277         
1278         // calculate time based on number of keys bought
1279         uint256 _newTime;
1280         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1281             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1282         else
1283             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1284         
1285         // compare to max and set new end time
1286         if (_newTime < (rndMax_).add(_now))
1287             round_[_rID].end = _newTime;
1288         else
1289             round_[_rID].end = rndMax_.add(_now);
1290     }
1291     
1292     /**
1293      * @dev generates a random number between 0-99 and checks to see if thats
1294      * resulted in an airdrop win
1295      * @return do we have a winner?
1296      */
1297     function airdrop()
1298         private 
1299         view 
1300         returns(bool)
1301     {
1302         uint256 seed = uint256(keccak256(abi.encodePacked(
1303             
1304             (block.timestamp).add
1305             (block.difficulty).add
1306             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1307             (block.gaslimit).add
1308             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1309             (block.number)
1310             
1311         )));
1312         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1313             return(true);
1314         else
1315             return(false);
1316     }
1317 
1318     /**
1319      * @dev distributes eth based on fees to com, aff
1320      */
1321     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1322         private
1323         returns(F3Ddatasets.EventReturns)
1324     {
1325         // pay 2% out to community rewards
1326         uint256 _com = _eth / 50;
1327         reward.transfer(_com);
1328 
1329         // X.FLY HACK，将该地址作为慈善基金地址，分配 2%
1330         uint256 _long = _eth / 50;
1331         otherF3D_.transfer(_long);
1332         
1333         // distribute share to affiliate
1334         // uint256 _aff = _eth / 10;
1335         // X.FLY HACK，根据战队分配推广邀请
1336         uint256 _aff = 0;
1337         if (_team == 0) {
1338             _aff = (_eth.mul(11)) / (100);
1339         } else if (_team == 1) {
1340             _aff = (_eth.mul(11)) / (100);
1341         } else if (_team == 2) {
1342             _aff = (_eth.mul(31)) / (100);
1343         } else if (_team == 3) {
1344             _aff = (_eth.mul(45)) / (100);
1345         }
1346         
1347         // decide what to do with affiliate share of fees
1348         // affiliate must not be self, and must have a name registered
1349         if (_affID != _pID && plyr_[_affID].name != "") {
1350             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1351             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1352         }
1353         
1354         return(_eventData_);
1355     }
1356     
1357     function potSwap()
1358         external
1359         payable
1360     {
1361         // setup local rID
1362         uint256 _rID = rID_ + 1;
1363         
1364         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1365         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1366     }
1367     
1368     /**
1369      * @dev distributes eth based on fees to gen and pot
1370      */
1371     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1372         private
1373         returns(F3Ddatasets.EventReturns)
1374     {
1375         // calculate gen share
1376         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1377         
1378         // toss 1% into airdrop pot 
1379         uint256 _air = (_eth / 100);
1380         airDropPot_ = airDropPot_.add(_air);
1381         
1382         // X.FLY HACK
1383         // 这里的 14 就是 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
1384         
1385         // calculate pot 
1386         // uint256 _pot = _eth.sub(_gen);
1387         uint256 _pot = (_eth.mul(fees_[_team].p3d)) / 100;
1388         
1389         // distribute gen share (thats what updateMasks() does) and adjust
1390         // balances for dust.
1391         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1392         if (_dust > 0)
1393             _gen = _gen.sub(_dust);
1394         
1395         // add eth to pot
1396         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1397         
1398         // set up event data
1399         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1400         _eventData_.potAmount = _pot;
1401         
1402         return(_eventData_);
1403     }
1404 
1405     /**
1406      * @dev updates masks for round and player when keys are bought
1407      * @return dust left over 
1408      */
1409     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1410         private
1411         returns(uint256)
1412     {
1413         /* MASKING NOTES
1414             earnings masks are a tricky thing for people to wrap their minds around.
1415             the basic thing to understand here.  is were going to have a global
1416             tracker based on profit per share for each round, that increases in
1417             relevant proportion to the increase in share supply.
1418             
1419             the player will have an additional mask that basically says "based
1420             on the rounds mask, my shares, and how much i've already withdrawn,
1421             how much is still owed to me?"
1422         */
1423         
1424         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1425         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1426         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1427             
1428         // calculate player earning from their own buy (only based on the keys
1429         // they just bought).  & update player earnings mask
1430         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1431         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1432         
1433         // calculate & return dust
1434         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1435     }
1436     
1437     /**
1438      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1439      * @return earnings in wei format
1440      */
1441     function withdrawEarnings(uint256 _pID)
1442         private
1443         returns(uint256)
1444     {
1445         // update gen vault
1446         updateGenVault(_pID, plyr_[_pID].lrnd);
1447         
1448         // from vaults 
1449         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1450         if (_earnings > 0)
1451         {
1452             plyr_[_pID].win = 0;
1453             plyr_[_pID].gen = 0;
1454             plyr_[_pID].aff = 0;
1455         }
1456 
1457         return(_earnings);
1458     }
1459     
1460     /**
1461      * @dev prepares compression data and fires event for buy or reload tx's
1462      */
1463     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1464         private
1465     {
1466         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1467         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1468         
1469         emit F3Devents.onEndTx
1470         (
1471             _eventData_.compressedData,
1472             _eventData_.compressedIDs,
1473             plyr_[_pID].name,
1474             msg.sender,
1475             _eth,
1476             _keys,
1477             _eventData_.winnerAddr,
1478             _eventData_.winnerName,
1479             _eventData_.amountWon,
1480             _eventData_.newPot,
1481             _eventData_.P3DAmount,
1482             _eventData_.genAmount,
1483             _eventData_.potAmount,
1484             airDropPot_
1485         );
1486     }
1487 //==============================================================================
1488 //    (~ _  _    _._|_    .
1489 //    _)(/_(_|_|| | | \/  .
1490 //====================/=========================================================
1491     /** upon contract deploy, it will be deactivated.  this is a one time
1492      * use function that will activate the contract.  we do this so devs 
1493      * have time to set things up on the web end                            **/
1494     bool public activated_ = false;
1495     function activate()
1496         public
1497     {
1498         // only team just can activate 
1499         require(msg.sender == deployer, "only team just can activate");
1500 
1501         // make sure that its been linked.
1502         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1503         
1504         // can only be ran once
1505         require(activated_ == false, "fomo3d already activated");
1506         
1507         // activate the contract 
1508         activated_ = true;
1509         
1510         // lets start first round
1511         rID_ = 1;
1512         round_[1].strt = now;
1513         round_[1].end = now + rndInit_;
1514     }
1515     function setOtherFomo(address _otherF3D)
1516         public
1517     {
1518         // only team just can activate 
1519         require(msg.sender == deployer, "only team just can activate");
1520         
1521         // // set up other fomo3d (fast or long) for pot swap
1522         otherF3D_ = _otherF3D;
1523     }
1524 }
1525 
1526 //==============================================================================
1527 //   __|_ _    __|_ _  .
1528 //  _\ | | |_|(_ | _\  .
1529 //==============================================================================
1530 library F3Ddatasets {
1531     //compressedData key
1532     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1533         // 0 - new player (bool)
1534         // 1 - joined round (bool)
1535         // 2 - new  leader (bool)
1536         // 3-5 - air drop tracker (uint 0-999)
1537         // 6-16 - round end time
1538         // 17 - winnerTeam
1539         // 18 - 28 timestamp 
1540         // 29 - team
1541         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1542         // 31 - airdrop happened bool
1543         // 32 - airdrop tier 
1544         // 33 - airdrop amount won
1545     //compressedIDs key
1546     // [77-52][51-26][25-0]
1547         // 0-25 - pID 
1548         // 26-51 - winPID
1549         // 52-77 - rID
1550     struct EventReturns {
1551         uint256 compressedData;
1552         uint256 compressedIDs;
1553         address winnerAddr;         // winner address
1554         bytes32 winnerName;         // winner name
1555         uint256 amountWon;          // amount won
1556         uint256 newPot;             // amount in new pot
1557         uint256 P3DAmount;          // amount distributed to p3d
1558         uint256 genAmount;          // amount distributed to gen
1559         uint256 potAmount;          // amount added to pot
1560     }
1561     struct Player {
1562         address addr;   // player address
1563         bytes32 name;   // player name
1564         uint256 win;    // winnings vault
1565         uint256 gen;    // general vault
1566         uint256 aff;    // affiliate vault
1567         uint256 lrnd;   // last round played
1568         uint256 laff;   // last affiliate id used
1569     }
1570     struct PlayerRounds {
1571         uint256 eth;    // eth player has added to round (used for eth limiter)
1572         uint256 keys;   // keys
1573         uint256 mask;   // player mask 
1574         uint256 ico;    // ICO phase investment
1575     }
1576     struct Round {
1577         uint256 plyr;   // pID of player in lead
1578         uint256 team;   // tID of team in lead
1579         uint256 end;    // time ends/ended
1580         bool ended;     // has round end function been ran
1581         uint256 strt;   // time round started
1582         uint256 keys;   // keys
1583         uint256 eth;    // total eth in
1584         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1585         uint256 mask;   // global mask
1586         uint256 ico;    // total eth sent in during ICO phase
1587         uint256 icoGen; // total eth for gen during ICO phase
1588         uint256 icoAvg; // average key price for ICO phase
1589     }
1590     struct TeamFee {
1591         uint256 gen;    // % of buy in thats paid to key holders of current round
1592         uint256 p3d;    // % of buy in thats paid to p3d holders
1593     }
1594     struct PotSplit {
1595         uint256 gen;    // % of pot thats paid to key holders of current round
1596         uint256 p3d;    // % of pot thats paid to p3d holders
1597     }
1598 }
1599 
1600 //==============================================================================
1601 //  |  _      _ _ | _  .
1602 //  |<(/_\/  (_(_||(_  .
1603 //=======/======================================================================
1604 library F3DKeysCalcLong {
1605     using SafeMath for *;
1606     /**
1607      * @dev calculates number of keys received given X eth 
1608      * @param _curEth current amount of eth in contract 
1609      * @param _newEth eth being spent
1610      * @return amount of ticket purchased
1611      */
1612     function keysRec(uint256 _curEth, uint256 _newEth)
1613         internal
1614         pure
1615         returns (uint256)
1616     {
1617         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1618     }
1619     
1620     /**
1621      * @dev calculates amount of eth received if you sold X keys 
1622      * @param _curKeys current amount of keys that exist 
1623      * @param _sellKeys amount of keys you wish to sell
1624      * @return amount of eth received
1625      */
1626     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1627         internal
1628         pure
1629         returns (uint256)
1630     {
1631         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1632     }
1633 
1634     /**
1635      * @dev calculates how many keys would exist with given an amount of eth
1636      * @param _eth eth "in contract"
1637      * @return number of keys that would exist
1638      */
1639     function keys(uint256 _eth) 
1640         internal
1641         pure
1642         returns(uint256)
1643     {
1644         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1645     }
1646     
1647     /**
1648      * @dev calculates how much eth would be in contract given a number of keys
1649      * @param _keys number of keys "in contract" 
1650      * @return eth that would exists
1651      */
1652     function eth(uint256 _keys) 
1653         internal
1654         pure
1655         returns(uint256)  
1656     {
1657         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1658     }
1659 }
1660 
1661 //==============================================================================
1662 //  . _ _|_ _  _ |` _  _ _  _  .
1663 //  || | | (/_| ~|~(_|(_(/__\  .
1664 //==============================================================================
1665 interface otherFoMo3D {
1666     function potSwap() external payable;
1667 }
1668 
1669 interface PlayerBookInterface {
1670     function getPlayerID(address _addr) external returns (uint256);
1671     function getPlayerName(uint256 _pID) external view returns (bytes32);
1672     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1673     function getPlayerAddr(uint256 _pID) external view returns (address);
1674     function getNameFee() external view returns (uint256);
1675     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1676     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1677     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1678 }
1679 
1680 library NameFilter {
1681     /**
1682      * @dev filters name strings
1683      * -converts uppercase to lower case.  
1684      * -makes sure it does not start/end with a space
1685      * -makes sure it does not contain multiple spaces in a row
1686      * -cannot be only numbers
1687      * -cannot start with 0x 
1688      * -restricts characters to A-Z, a-z, 0-9, and space.
1689      * @return reprocessed string in bytes32 format
1690      */
1691     function nameFilter(string _input)
1692         internal
1693         pure
1694         returns(bytes32)
1695     {
1696         bytes memory _temp = bytes(_input);
1697         uint256 _length = _temp.length;
1698         
1699         //sorry limited to 32 characters
1700         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1701         // make sure it doesnt start with or end with space
1702         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1703         // make sure first two characters are not 0x
1704         if (_temp[0] == 0x30)
1705         {
1706             require(_temp[1] != 0x78, "string cannot start with 0x");
1707             require(_temp[1] != 0x58, "string cannot start with 0X");
1708         }
1709         
1710         // create a bool to track if we have a non number character
1711         bool _hasNonNumber;
1712         
1713         // convert & check
1714         for (uint256 i = 0; i < _length; i++)
1715         {
1716             // if its uppercase A-Z
1717             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1718             {
1719                 // convert to lower case a-z
1720                 _temp[i] = byte(uint(_temp[i]) + 32);
1721                 
1722                 // we have a non number
1723                 if (_hasNonNumber == false)
1724                     _hasNonNumber = true;
1725             } else {
1726                 require
1727                 (
1728                     // require character is a space
1729                     _temp[i] == 0x20 || 
1730                     // OR lowercase a-z
1731                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1732                     // or 0-9
1733                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1734                     "string contains invalid characters"
1735                 );
1736                 // make sure theres not 2x spaces in a row
1737                 if (_temp[i] == 0x20)
1738                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1739                 
1740                 // see if we have a character other than a number
1741                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1742                     _hasNonNumber = true;    
1743             }
1744         }
1745         
1746         require(_hasNonNumber == true, "string cannot be only numbers");
1747         
1748         bytes32 _ret;
1749         assembly {
1750             _ret := mload(add(_temp, 32))
1751         }
1752         return (_ret);
1753     }
1754 }
1755 
1756 /**
1757  * @title SafeMath v0.1.9
1758  * @dev Math operations with safety checks that throw on error
1759  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1760  * - added sqrt
1761  * - added sq
1762  * - added pwr 
1763  * - changed asserts to requires with error log outputs
1764  * - removed div, its useless
1765  */
1766 library SafeMath {
1767     
1768     /**
1769     * @dev Multiplies two numbers, throws on overflow.
1770     */
1771     function mul(uint256 a, uint256 b) 
1772         internal 
1773         pure 
1774         returns (uint256 c) 
1775     {
1776         if (a == 0) {
1777             return 0;
1778         }
1779         c = a * b;
1780         require(c / a == b, "SafeMath mul failed");
1781         return c;
1782     }
1783 
1784     /**
1785     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1786     */
1787     function sub(uint256 a, uint256 b)
1788         internal
1789         pure
1790         returns (uint256) 
1791     {
1792         require(b <= a, "SafeMath sub failed");
1793         return a - b;
1794     }
1795 
1796     /**
1797     * @dev Adds two numbers, throws on overflow.
1798     */
1799     function add(uint256 a, uint256 b)
1800         internal
1801         pure
1802         returns (uint256 c) 
1803     {
1804         c = a + b;
1805         require(c >= a, "SafeMath add failed");
1806         return c;
1807     }
1808     
1809     /**
1810      * @dev gives square root of given x.
1811      */
1812     function sqrt(uint256 x)
1813         internal
1814         pure
1815         returns (uint256 y) 
1816     {
1817         uint256 z = ((add(x,1)) / 2);
1818         y = x;
1819         while (z < y) 
1820         {
1821             y = z;
1822             z = ((add((x / z),z)) / 2);
1823         }
1824     }
1825     
1826     /**
1827      * @dev gives square. multiplies x by x
1828      */
1829     function sq(uint256 x)
1830         internal
1831         pure
1832         returns (uint256)
1833     {
1834         return (mul(x,x));
1835     }
1836     
1837     /**
1838      * @dev x to the power of y 
1839      */
1840     function pwr(uint256 x, uint256 y)
1841         internal 
1842         pure 
1843         returns (uint256)
1844     {
1845         if (x==0)
1846             return (0);
1847         else if (y==0)
1848             return (1);
1849         else 
1850         {
1851             uint256 z = x;
1852             for (uint256 i=1; i < y; i++)
1853                 z = mul(z,x);
1854             return (z);
1855         }
1856     }
1857 }