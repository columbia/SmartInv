1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-05
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /****************************************************************************************************************************
8                                                         EVENTS
9 ****************************************************************************************************************************/
10 contract RPevents {
11     // fired whenever a player registers a name
12     event onNewName
13     (
14         uint256 indexed playerID,
15         address indexed playerAddress,
16         bytes32 indexed playerName,
17         bool isNewPlayer,
18         uint256 affiliateID,
19         address affiliateAddress,
20         bytes32 affiliateName,
21         uint256 amountPaid,
22         uint256 timeStamp
23     );
24     
25     // fired at end of buy or reload
26     event onEndTx
27     (
28         uint256 compressedData,     
29         uint256 compressedIDs,      
30         bytes32 playerName,
31         address playerAddress,
32         uint256 ethIn,
33         uint256 keysBought,
34         address winnerAddr,
35         bytes32 winnerName,
36         uint256 amountWon,
37         uint256 newPot,
38         uint256 P3DAmount,
39         uint256 genAmount,
40         uint256 potAmount,
41         uint256 airDropPot
42     );
43     
44 	// fired whenever theres a withdraw
45     event onWithdraw
46     (
47         uint256 indexed playerID,
48         address playerAddress,
49         bytes32 playerName,
50         uint256 ethOut,
51         uint256 timeStamp
52     );
53     
54     // fired whenever a withdraw forces end round to be ran
55     event onWithdrawAndDistribute
56     (
57         address playerAddress,
58         bytes32 playerName,
59         uint256 ethOut,
60         uint256 compressedData,
61         uint256 compressedIDs,
62         address winnerAddr,
63         bytes32 winnerName,
64         uint256 amountWon,
65         uint256 newPot,
66         uint256 P3DAmount,
67         uint256 genAmount
68     );
69     
70     // (fomo3d long only) fired whenever a player tries a buy after round timer 
71     // hit zero, and causes end round to be ran.
72     event onBuyAndDistribute
73     (
74         address playerAddress,
75         bytes32 playerName,
76         uint256 ethIn,
77         uint256 compressedData,
78         uint256 compressedIDs,
79         address winnerAddr,
80         bytes32 winnerName,
81         uint256 amountWon,
82         uint256 newPot,
83         uint256 P3DAmount,
84         uint256 genAmount
85     );
86     
87     // (fomo3d long only) fired whenever a player tries a reload after round timer 
88     // hit zero, and causes end round to be ran.
89     event onReLoadAndDistribute
90     (
91         address playerAddress,
92         bytes32 playerName,
93         uint256 compressedData,
94         uint256 compressedIDs,
95         address winnerAddr,
96         bytes32 winnerName,
97         uint256 amountWon,
98         uint256 newPot,
99         uint256 P3DAmount,
100         uint256 genAmount
101     );
102     
103     // fired whenever an affiliate is paid
104     event onAffiliatePayout
105     (
106         uint256 indexed affiliateID,
107         address affiliateAddress,
108         bytes32 affiliateName,
109         uint256 indexed roundID,
110         uint256 indexed buyerID,
111         uint256 amount,
112         uint256 timeStamp
113     );
114     
115     // received pot swap deposit
116     event onPotSwapDeposit
117     (
118         uint256 roundID,
119         uint256 amountAddedToPot
120     );
121 }
122 
123 /****************************************************************************************************************************
124                                                         CONTRACT SETUP 
125 ****************************************************************************************************************************/
126 
127 contract modularShort is RPevents {}
128 
129 contract BChain is modularShort {
130     using SafeMath for *;
131     using NameFilter for string;
132 
133     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x8c0731db98b74c856c7fedef22274d8874758348);
134 	DiviesInterface constant private Divies = DiviesInterface(0xfc158712224ba9fd9d78006124404f88e8cfa685);
135 
136 /****************************************************************************************************************************
137                                                         CONFIGURABLES 
138 ****************************************************************************************************************************/
139 
140     address private admin = msg.sender;
141     string constant public name = "B Chain";
142     string constant public symbol = "RPG";
143     uint256 private rndGap_ = 1 seconds;         // length of ICO phase
144     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
145     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
146     uint256 constant private rndMax_ =  24 hours;                // max length a round timer can be
147     
148     uint256 public ethConstant_ = 0;
149     uint256 public keyConstant_ = 0;
150     
151     uint256 keyPrice_ = 0;
152 
153     
154 /****************************************************************************************************************************
155                                                         DATA SETUP 
156 ****************************************************************************************************************************/
157 
158 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
159     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
160     uint256 public rID_;    // round id number / total rounds that have happened    
161 //****************
162 // PLAYER DATA 
163 //****************
164     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
165     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
166     mapping (uint256 => RPdatasets.Player) public plyr_;   // (pID => data) player data
167     mapping (uint256 => mapping (uint256 => RPdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
168     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
169 //****************
170 // ROUND DATA 
171 //****************
172     mapping (uint256 => RPdatasets.Round) public round_;   // (rID => data) round data
173     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
174 //****************
175 // TEAM FEE DATA 
176 //****************
177     mapping (uint256 => RPdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
178     mapping (uint256 => RPdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
179 //****************
180 // KEY STORE
181 //****************
182      mapping (address => uint256) public keystore_;
183 
184 
185 /****************************************************************************************************************************
186                                                         CONSTRUCTOR 
187 ****************************************************************************************************************************/
188 
189 
190     constructor()
191         public
192     {
193         // Team allocation structures
194         // 0 = Thor
195         // 1 = Captain
196         // 2 = IronMan
197         // 3 = Hulk
198 
199         // Team allocation percentages
200         // (F3D, P3D) + (Pot , Referrals, Community), We are not giving any part to P3D holder.
201             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
202         fees_[0] = RPdatasets.TeamFee(20, 48, 20, 10, 2);   //50% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
203         fees_[1] = RPdatasets.TeamFee(48, 20, 20, 10, 2);   //37% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
204 
205 
206         // how to split up the final pot based on which team was picked
207         // (F3D, P3D)
208         potSplit_[0] = RPdatasets.PotSplit(48, 2, 10, 20, 20);  //25% to winner, 25% to next round, 3% to com
209         potSplit_[1] = RPdatasets.PotSplit(48, 2, 20, 10, 20);   //25% to winner, 25% to next round, 3% to com
210 
211     }
212     
213 /****************************************************************************************************************************
214                                                         MODIFIERS 
215 ****************************************************************************************************************************/
216 
217     /**
218      * @dev used to make sure no one can interact with contract until it has 
219      * been activated. 
220      */
221     modifier isActivated() {
222         require(activated_ == true, "ouch, ccontract is not ready yet !");
223         _;
224     }
225 
226     /**
227      * @dev prevents contracts from interacting with fomo3d
228      */
229     modifier isHuman() {
230         require(msg.sender == tx.origin, "nope, you're not an Human buddy !!");
231         _;
232     }
233 
234     /**
235      * @dev sets boundaries for incoming tx 
236      */
237     modifier isWithinLimits(uint256 _eth) {
238         require(_eth >= 1000000000, "pocket lint: not a valid currency");
239         require(_eth <= 100000000000000000000000, "no vitalik, no");
240         _;
241     }
242 
243 /****************************************************************************************************************************
244                                                         PUBLIC FUNCTIONS
245 ****************************************************************************************************************************/
246 
247     /**
248      * @dev emergency buy uses last stored affiliate ID and team snek
249      */
250     function()
251         isActivated()
252         isHuman()
253         isWithinLimits(msg.value)
254         public
255         payable
256     {
257         // set up our tx event data and determine if player is new or not
258         RPdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
259 
260         // fetch player id
261         uint256 _pID = pIDxAddr_[msg.sender];
262 
263         // buy core
264         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
265     }
266 
267     /**
268      * @dev converts all incoming ethereum to keys.
269      * -functionhash- 0x8f38f309 (using ID for affiliate)
270      * -functionhash- 0x98a0871d (using address for affiliate)
271      * -functionhash- 0xa65b37a1 (using name for affiliate)
272      * @param _affCode the ID/address/name of the player who gets the affiliate fee
273      * @param _team what team is the player playing for?
274      */
275     function buyXid(uint256 _affCode, uint256 _team)
276         isActivated()
277         isHuman()
278         isWithinLimits(msg.value)
279         public
280         payable
281     {
282         // set up our tx event data and determine if player is new or not
283         RPdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
284         
285         // fetch player id
286         uint256 _pID = pIDxAddr_[msg.sender];
287         
288         // manage affiliate residuals
289         // if no affiliate code was given or player tried to use their own, lolz
290         if (_affCode == 0 || _affCode == _pID)
291         {
292             // use last stored affiliate code 
293             _affCode = plyr_[_pID].laff;
294             
295         // if affiliate code was given & its not the same as previously stored 
296         } else if (_affCode != plyr_[_pID].laff) {
297             // update last affiliate 
298             plyr_[_pID].laff = _affCode;
299         }
300         
301         // verify a valid team was selected
302         _team = verifyTeam(_team);
303         
304         // buy core 
305         buyCore(_pID, _affCode, _team, _eventData_);
306     }
307 
308     function buyXaddr(address _affCode, uint256 _team)
309         isActivated()
310         isHuman()
311         isWithinLimits(msg.value)
312         public
313         payable
314     {
315         // set up our tx event data and determine if player is new or not
316         RPdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
317         
318         // fetch player id
319         uint256 _pID = pIDxAddr_[msg.sender];
320 
321         // manage affiliate residuals
322         uint256 _affID;
323         // if no affiliate code was given or player tried to use their own, lolz
324         if (_affCode == address(0) || _affCode == msg.sender)
325         {
326             // use last stored affiliate code
327             _affID = plyr_[_pID].laff;
328         
329         // if affiliate code was given    
330         } else {
331             // get affiliate ID from aff Code 
332             _affID = pIDxAddr_[_affCode];
333 
334             // if affID is not the same as previously stored 
335             if (_affID != plyr_[_pID].laff)
336             {
337                 // update last affiliate
338                 plyr_[_pID].laff = _affID;
339             }
340         }
341         
342         // verify a valid team was selected
343         _team = verifyTeam(_team);
344         
345         // buy core
346         buyCore(_pID, _affID, _team, _eventData_);
347     }
348 
349     function buyXname(bytes32 _affCode, uint256 _team)
350         isActivated()
351         isHuman()
352         isWithinLimits(msg.value)
353         public
354         payable
355     {
356         // set up our tx event data and determine if player is new or not
357         RPdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
358         
359         // fetch player id
360         uint256 _pID = pIDxAddr_[msg.sender];
361         
362         // manage affiliate residuals
363         uint256 _affID;
364         // if no affiliate code was given or player tried to use their own, lolz
365         if (_affCode == '' || _affCode == plyr_[_pID].name)
366         {
367             // use last stored affiliate code
368             _affID = plyr_[_pID].laff;
369 
370         // if affiliate code was given
371         } else {
372             // get affiliate ID from aff Code
373             _affID = pIDxName_[_affCode];
374             
375             // if affID is not the same as previously stored
376             if (_affID != plyr_[_pID].laff)
377             {
378                 // update last affiliate
379                 plyr_[_pID].laff = _affID;
380             }
381         }
382         
383         // verify a valid team was selected
384         _team = verifyTeam(_team);
385         
386         // buy core
387         buyCore(_pID, _affID, _team, _eventData_);
388     }
389 
390     /**
391      * @dev essentially the same as buy, but instead of you sending ether 
392      * from your wallet, it uses your unwithdrawn earnings.
393      * -functionhash- 0x349cdcac (using ID for affiliate)
394      * -functionhash- 0x82bfc739 (using address for affiliate)
395      * -functionhash- 0x079ce327 (using name for affiliate)
396      * @param _affCode the ID/address/name of the player who gets the affiliate fee
397      * @param _team what team is the player playing for?
398      * @param _eth amount of earnings to use (remainder returned to gen vault)
399      */
400     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
401         isActivated()
402         isHuman()
403         isWithinLimits(_eth)
404         public
405     {
406         // set up our tx event data
407         RPdatasets.EventReturns memory _eventData_;
408         
409         // fetch player ID
410         uint256 _pID = pIDxAddr_[msg.sender];
411         
412         // manage affiliate residuals
413         // if no affiliate code was given or player tried to use their own, lolz
414         if (_affCode == 0 || _affCode == _pID)
415         {
416             // use last stored affiliate code 
417             _affCode = plyr_[_pID].laff;
418             
419         // if affiliate code was given & its not the same as previously stored 
420         } else if (_affCode != plyr_[_pID].laff) {
421             // update last affiliate 
422             plyr_[_pID].laff = _affCode;
423         }
424 
425         // verify a valid team was selected
426         _team = verifyTeam(_team);
427 
428         // reload core
429         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
430     }
431 
432     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
433         isActivated()
434         isHuman()
435         isWithinLimits(_eth)
436         public
437     {
438         // set up our tx event data
439         RPdatasets.EventReturns memory _eventData_;
440         
441         // fetch player ID
442         uint256 _pID = pIDxAddr_[msg.sender];
443         
444         // manage affiliate residuals
445         uint256 _affID;
446         // if no affiliate code was given or player tried to use their own, lolz
447         if (_affCode == address(0) || _affCode == msg.sender)
448         {
449             // use last stored affiliate code
450             _affID = plyr_[_pID].laff;
451         
452         // if affiliate code was given    
453         } else {
454             // get affiliate ID from aff Code 
455             _affID = pIDxAddr_[_affCode];
456             
457             // if affID is not the same as previously stored 
458             if (_affID != plyr_[_pID].laff)
459             {
460                 // update last affiliate
461                 plyr_[_pID].laff = _affID;
462             }
463         }
464         
465         // verify a valid team was selected
466         _team = verifyTeam(_team);
467         
468         // reload core
469         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
470     }
471 
472     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
473         isActivated()
474         isHuman()
475         isWithinLimits(_eth)
476         public
477     {
478         // set up our tx event data
479         RPdatasets.EventReturns memory _eventData_;
480         
481         // fetch player ID
482         uint256 _pID = pIDxAddr_[msg.sender];
483         
484         // manage affiliate residuals
485         uint256 _affID;
486         // if no affiliate code was given or player tried to use their own, lolz
487         if (_affCode == '' || _affCode == plyr_[_pID].name)
488         {
489             // use last stored affiliate code
490             _affID = plyr_[_pID].laff;
491         
492         // if affiliate code was given
493         } else {
494             // get affiliate ID from aff Code
495             _affID = pIDxName_[_affCode];
496             
497             // if affID is not the same as previously stored
498             if (_affID != plyr_[_pID].laff)
499             {
500                 // update last affiliate
501                 plyr_[_pID].laff = _affID;
502             }
503         }
504         
505         // verify a valid team was selected
506         _team = verifyTeam(_team);
507         
508         // reload core
509         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
510     }
511 
512     /**
513      * @dev withdraws all of your earnings.
514      * -functionhash- 0x3ccfd60b
515      */
516     function withdraw()
517         isActivated()
518         isHuman()
519         public
520     {
521         // setup local rID 
522         uint256 _rID = rID_;
523         
524         // grab time
525         uint256 _now = now;
526         
527         // fetch player ID
528         uint256 _pID = pIDxAddr_[msg.sender];
529         
530         // setup temp var for player eth
531         uint256 _eth;
532         
533         
534    }
535 
536     /**
537      * @dev use these to register names.  they are just wrappers that will send the
538      * registration requests to the PlayerBook contract.  So registering here is the 
539      * same as registering there.  UI will always display the last name you registered.
540      * but you will still own all previously registered names to use as affiliate 
541      * links.
542      * - must pay a registration fee.
543      * - name must be unique
544      * - names will be converted to lowercase
545      * - name cannot start or end with a space 
546      * - cannot have more than 1 space in a row
547      * - cannot be only numbers
548      * - cannot start with 0x 
549      * - name must be at least 1 char
550      * - max length of 32 characters long
551      * - allowed characters: a-z, 0-9, and space
552      * -functionhash- 0x921dec21 (using ID for affiliate)
553      * -functionhash- 0x3ddd4698 (using address for affiliate)
554      * -functionhash- 0x685ffd83 (using name for affiliate)
555      * @param _nameString players desired name
556      * @param _affCode affiliate ID, address, or name of who referred you
557      * @param _all set to true if you want this to push your info to all games 
558      * (this might cost a lot of gas)
559      */
560     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
561         isHuman()
562         public
563         payable
564     {
565         bytes32 _name = _nameString.nameFilter();
566         address _addr = msg.sender;
567         uint256 _paid = msg.value;
568         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
569 
570         uint256 _pID = pIDxAddr_[_addr];
571 
572         // fire event
573         emit RPevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
574     }
575 
576     function registerNameXaddr(string _nameString, address _affCode, bool _all)
577         isHuman()
578         public
579         payable
580     {
581         bytes32 _name = _nameString.nameFilter();
582         address _addr = msg.sender;
583         uint256 _paid = msg.value;
584         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
585 
586         uint256 _pID = pIDxAddr_[_addr];
587 
588         // fire event
589         emit RPevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
590     }
591 
592     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
593         isHuman()
594         public
595         payable
596     {
597         bytes32 _name = _nameString.nameFilter();
598         address _addr = msg.sender;
599         uint256 _paid = msg.value;
600         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
601 
602         uint256 _pID = pIDxAddr_[_addr];
603 
604         // fire event
605         emit RPevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
606     }
607     
608     
609     /**
610      * @dev Set emerald price
611      * @param _price of emerald
612      */
613     function setEmeraldPrice(uint256 _price) public{
614 
615         keyConstant_ = computeKeyConstant(_price);
616         
617         ethConstant_ = computeEthConstant(_price);
618         
619         keyPrice_ = _price;
620         
621     }
622     
623     
624     /**
625      * @dev Get total key bought
626      */
627     function getPlayerKeyCount() public view returns(uint256){
628 
629         return keystore_[msg.sender];
630         
631     }
632     
633     /**
634      * @dev updates round timer based on number of whole keys bought.
635      */
636     function updateTimer(uint256 _keys, uint256 _rID)
637         public
638     {
639         // grab time
640         uint256 _now = now;
641 
642         // calculate time based on number of keys bought
643         uint256 _newTime;
644         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
645             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
646         else
647             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
648 
649         // compare to max and set new end time
650         if (_newTime < (rndMax_).add(_now))
651             round_[_rID].end = _newTime;
652         else
653             round_[_rID].end = rndMax_.add(_now);
654             
655         keystore_[msg.sender] = keystore_[msg.sender].sub(_keys);
656                     
657     }    
658     
659     
660 /****************************************************************************************************************************
661                                                             GETTERS 
662 ****************************************************************************************************************************/
663 
664 
665     /**
666      * @dev return the price buyer will pay for next 1 individual key.
667      * -functionhash- 0x018a25e8
668      * @return price for next key bought (in wei format)
669      */
670     function getBuyPrice()
671         public
672         view
673         returns(uint256)
674     {
675         // setup local rID
676         uint256 _rID = rID_;
677         
678         // grab time
679         uint256 _now = now;
680         
681         // are we in a round?
682         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
683             return  ethRec(round_[_rID].keys.add(1000000000000000000), 1000000000000000000 );
684         else // rounds over.  need price for new round
685             return ( keyPrice_ ); // init
686     }
687 
688     /**
689      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
690      * provider
691      * -functionhash- 0xc7e284b8
692      * @return time left in seconds
693      */
694     function getTimeLeft()
695         public
696         view
697         returns(uint256)
698     {
699         // setup local rID
700         uint256 _rID = rID_;
701 
702         // grab time
703         uint256 _now = now;
704 
705         if (_now < round_[_rID].end)
706             if (_now > round_[_rID].strt + rndGap_)
707                 return( (round_[_rID].end).sub(_now) );
708             else
709                 return( (round_[_rID].strt + rndGap_).sub(_now) );
710         else
711             return(0);
712     }
713 
714     /**
715      * @dev returns player earnings per vaults 
716      * -functionhash- 0x63066434
717      * @return winnings vault
718      * @return general vault
719      * @return affiliate vault
720      */
721     function getPlayerVaults(uint256 _pID)
722         public
723         view
724         returns(uint256 ,uint256, uint256)
725     {
726         // Setup local rID
727         uint256 _rID = rID_;
728 
729         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
730         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
731         {
732             // if player is winner 
733             if (round_[_rID].plyr == _pID)
734             {
735                 return
736                 (
737                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(25)) / 100 ),
738                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
739                     plyr_[_pID].aff
740                 );
741             // if the player is not the winner
742             } else {
743                 return
744                 (
745                     plyr_[_pID].win,
746                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
747                     plyr_[_pID].aff
748                 );
749             }
750 
751         // if round is still going on, or round has ended and round end has been ran
752         } else {
753             return
754             (
755                 plyr_[_pID].win,
756                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
757                 plyr_[_pID].aff
758             );
759         }
760     }
761 
762     /**
763      *  solidity hates stack limits.  this lets us avoid that hate
764      */
765     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
766         private
767         view
768         returns(uint256)
769     {
770         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].emerald))).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
771     }
772 
773     /**
774      * @dev returns all current round info needed for front end
775      * -functionhash- 0x747dff42
776      * @return eth invested during ICO phase
777      * @return round id 
778      * @return total keys for round 
779      * @return time round ends
780      * @return time round started
781      * @return current pot 
782      * @return current team ID & player ID in lead 
783      * @return current player in leads address 
784      * @return current player in leads name
785      * @return whales eth in for round
786      * @return bears eth in for round
787      * @return sneks eth in for round
788      * @return bulls eth in for round
789      * @return airdrop tracker # & airdrop pot
790      */
791     function getCurrentRoundInfo()
792         public
793         view
794         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
795     {
796         // setup local rID
797         uint256 _rID = rID_;
798 
799         return
800         (
801             round_[_rID].ico,               //0
802             _rID,                           //1
803             round_[_rID].keys,              //2
804             round_[_rID].end,               //3
805             round_[_rID].strt,              //4
806             round_[_rID].pot,               //5
807             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
808             plyr_[round_[_rID].plyr].addr,  //7
809             plyr_[round_[_rID].plyr].name,  //8
810             rndTmEth_[_rID][0],             //9
811             rndTmEth_[_rID][1],             //10
812             rndTmEth_[_rID][2],             //11
813             rndTmEth_[_rID][3],             //12
814             airDropTracker_ + (airDropPot_ * 1000)              //13
815         );
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
829 	 * @return player round eth
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
845         return
846         (
847             _pID,                               //0
848             plyr_[_pID].name,                   //1
849             plyrRnds_[_pID][_rID].keys,         //2
850             plyr_[_pID].win,                    //3
851             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
852             plyr_[_pID].aff,                    //5
853             plyrRnds_[_pID][_rID].eth           //6
854         );
855     }
856     
857 
858 
859 /****************************************************************************************************************************
860                                                         CORE LOGIC 
861 ****************************************************************************************************************************/
862 
863 
864     /**
865      * @dev logic runs whenever a buy order is executed.  determines how to handle 
866      * incoming eth depending on if we are in an active round or not
867      */
868     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, RPdatasets.EventReturns memory _eventData_)
869         private
870     {
871         // setup local rID
872         uint256 _rID = rID_;
873 
874         // grab time 
875         uint256 _now = now;
876 
877         // if round is active
878 
879         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
880         {
881             // call core
882             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
883 
884         // if round is not active
885         } else {
886             // check to see if end round needs to be ran
887             if (_now > round_[_rID].end && round_[_rID].ended == false)
888             {
889                 // end the round (distributes pot) & start new round
890 			    round_[_rID].ended = true;
891                 _eventData_ = endRound(_eventData_);
892                 
893                 // build event data
894                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
895                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
896 
897                 // // fire buy and distribute event 
898                 emit RPevents.onBuyAndDistribute
899                 (
900                     msg.sender,
901                     plyr_[_pID].name,
902                     msg.value,
903                     _eventData_.compressedData,
904                     _eventData_.compressedIDs,
905                     _eventData_.winnerAddr,
906                     _eventData_.winnerName,
907                     _eventData_.amountWon,
908                     _eventData_.newPot,
909                     _eventData_.P3DAmount,
910                     _eventData_.genAmount
911                 );
912             }
913 
914             // put eth in players vault 
915             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
916         }
917     }
918 
919     
920     /**
921      * @dev logic runs whenever a reload order is executed.  determines how to handle 
922      * incoming eth depending on if we are in an active round or not 
923      */
924     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, RPdatasets.EventReturns memory _eventData_)
925         private
926     {
927         // setup local rID
928         uint256 _rID = rID_;
929 
930         // grab time
931         uint256 _now = now;
932 
933         //if round is active
934         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
935         {
936             // get earnings from all vaults and return unused to gen vault
937             // because we use a custom safemath library.  this will throw if player 
938             // tried to spend more eth than they have.
939             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
940             
941             // call core 
942             core(_rID, _pID, _eth, _affID, _team, _eventData_);
943 
944         // if round is not active and end round needs to be ran   
945         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
946             // end the round (distributes pot) & start new round
947             round_[_rID].ended = true;
948             _eventData_ = endRound(_eventData_);
949                 
950             // build event data
951             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
952             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
953                 
954             // fire buy and distribute event 
955             emit RPevents.onReLoadAndDistribute
956             (
957                 msg.sender,
958                 plyr_[_pID].name,
959                 _eventData_.compressedData,
960                 _eventData_.compressedIDs,
961                 _eventData_.winnerAddr,
962                 _eventData_.winnerName,
963                 _eventData_.amountWon,
964                 _eventData_.newPot,
965                 _eventData_.P3DAmount,
966                 _eventData_.genAmount
967             );
968         }
969     }
970 
971     /**
972      * @dev this is the core logic for any buy/reload that happens while a round 
973      * is live.
974      */
975     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, RPdatasets.EventReturns memory _eventData_)
976         private
977     {
978         // if player is new to round
979         if (plyrRnds_[_pID][_rID].keys == 0)
980             _eventData_ = managePlayer(_pID, _eventData_);
981 
982         // early round eth limiter 
983         if (round_[_rID].eth < 10000000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 100000000000000000000)
984         {
985             uint256 _availableLimit = (100000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
986             uint256 _refund = _eth.sub(_availableLimit);
987             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
988             _eth = _availableLimit;
989         }
990 
991         // if eth left is greater than min eth allowed (sorry no pocket lint)
992         if (_eth > 1000000000) 
993         {
994             
995             // mint the new keys
996             uint256 _keys = keysRec(round_[_rID].eth, _eth);
997             
998             keystore_[msg.sender] = keystore_[msg.sender].add(_keys);
999             
1000             // if they bought at least 1 whole key
1001             if (_keys >= 1000000000000000000)
1002             {
1003             //updateTimer(_keys, _rID);
1004 
1005             // set new leaders
1006             if (round_[_rID].plyr != _pID)
1007                 round_[_rID].plyr = _pID;
1008             if (round_[_rID].team != _team)
1009                 round_[_rID].team = _team;
1010 
1011             // set the new leader bool to true
1012             _eventData_.compressedData = _eventData_.compressedData + 100;
1013         }
1014 
1015 
1016             // store the air drop tracker number (number of buys since last airdrop)
1017             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1018 
1019             // update player
1020             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1021             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1022 
1023             // update round
1024             round_[_rID].keys = _keys.add(round_[_rID].keys);
1025             round_[_rID].eth = _eth.add(round_[_rID].eth);
1026             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1027 
1028             // distribute eth
1029             _eventData_ = distributeExternal(_rID, _eth, _team, _eventData_);
1030             _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
1031 
1032             // call end tx function to fire end tx event.
1033             endTx(_pID, _team, _eth, _keys, _eventData_);
1034         }
1035     }
1036 
1037 
1038 /****************************************************************************************************************************
1039                                                         CALCULATORS 
1040 ****************************************************************************************************************************/
1041 
1042 
1043     /**
1044      * @dev calculates unmasked earnings (just calculates, does not update mask)
1045      * @return earnings in wei format
1046      */
1047     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1048         private
1049         view
1050         returns(uint256)
1051     {
1052         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1053     }
1054 
1055     /** 
1056      * @dev returns the amount of keys you would get given an amount of eth. 
1057      * -functionhash- 0xce89c80c
1058      * @param _rID round ID you want price for
1059      * @param _eth amount of eth sent in 
1060      * @return keys received 
1061      */
1062     function calcKeysReceived(uint256 _rID, uint256 _eth)
1063         public
1064         view
1065         returns(uint256)
1066     {
1067         // grab time
1068         uint256 _now = now;
1069         
1070         // are we in a round?
1071         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1072             return keysRec (round_[_rID].eth, _eth );
1073         else // rounds over.  need keys for new round
1074             return keys(_eth);
1075     }
1076 
1077     /** 
1078      * @dev returns current eth price for X keys.  
1079      * -functionhash- 0xcf808000
1080      * @param _keys number of keys desired (in 18 decimal format)
1081      * @return amount of eth needed to send
1082      */
1083     function iWantXKeys(uint256 _keys)
1084         public
1085         view
1086         returns(uint256)
1087     {
1088         // setup local rID
1089         uint256 _rID = rID_;
1090         
1091         // grab time
1092         uint256 _now = now;
1093         
1094         // are we in a round?
1095         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1096             return ethRec(round_[_rID].keys.add(_keys), _keys);
1097         else // rounds over.  need price for new round
1098             return eth(_keys);
1099     }
1100 	
1101 	
1102    function keysRec(uint256 _curEth, uint256 _newEth)
1103         internal
1104         returns (uint256)
1105     {
1106         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1107     }
1108 
1109     /**
1110      * @dev calculates amount of eth received if you sold X keys 
1111      * @param _curKeys current amount of keys that exist 
1112      * @param _sellKeys amount of keys you wish to sell
1113      * @return amount of eth received
1114      */
1115     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1116         internal
1117         returns (uint256)
1118     {
1119         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1120     }
1121 
1122     /**
1123      * @dev calculates how many keys would exist with given an amount of eth
1124      * @param _eth eth "in contract"
1125      * @return number of keys that would exist
1126      */
1127     function keys(uint256 _eth)
1128         internal
1129         returns(uint256)
1130     {
1131         return ((((((_eth).mul(1000000000000000000)).mul(keyConstant_)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1132     }
1133 
1134     /**
1135      * @dev calculates how much eth would be in contract given a number of keys
1136      * @param _keys number of keys "in contract" 
1137      * @return eth that would exists
1138      */
1139     function eth(uint256 _keys)
1140         internal
1141         returns(uint256)
1142     {
1143         return ((78125000).mul(_keys.sq()).add(((ethConstant_).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1144     }
1145 	
1146 	/**
1147      * @dev calculates keys() function constant
1148      * @param _eth price of eth 
1149      * @return key constant for keys() function
1150      */
1151     function computeKeyConstant(uint256 _eth)
1152         internal
1153         returns (uint256)
1154     {
1155 
1156         
1157         return (((((156250000).mul(1000000000000000000)).add(74999921875000000000000000000000).sq()).sub(5624988281256103515625000000000000000000000000000000000000000000)) / _eth.mul(1000000000000000000)).ceil(1000);
1158         
1159     }
1160     
1161 	/**
1162      * @dev calculates eth() function constant
1163      * @param _eth price of eth
1164      * @return eth constant for eth() function
1165      */
1166     function computeEthConstant(uint256 _eth)
1167         internal
1168         returns (uint256)
1169     {
1170         
1171         uint256 key = 1000000000000000000;
1172         
1173         return (((2).mul(_eth.mul((1000000000000000000).sq()).sub((78125000).mul(key.sq())))) / (key.mul((1000000000000000000)))).ceil(1000);
1174         
1175     }
1176 	
1177 	
1178 /****************************************************************************************************************************
1179                                                         TOOLS 
1180 ****************************************************************************************************************************/
1181 
1182 
1183     /**
1184 	 * @dev receives name/player info from names contract 
1185      */
1186     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1187         external
1188     {
1189         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1190         if (pIDxAddr_[_addr] != _pID)
1191             pIDxAddr_[_addr] = _pID;
1192         if (pIDxName_[_name] != _pID)
1193             pIDxName_[_name] = _pID;
1194         if (plyr_[_pID].addr != _addr)
1195             plyr_[_pID].addr = _addr;
1196         if (plyr_[_pID].name != _name)
1197             plyr_[_pID].name = _name;
1198         if (plyr_[_pID].laff != _laff)
1199             plyr_[_pID].laff = _laff;
1200         if (plyrNames_[_pID][_name] == false)
1201             plyrNames_[_pID][_name] = true;
1202     }
1203 
1204     /**
1205      * @dev receives entire player name list 
1206      */
1207     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1208         external
1209     {
1210         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1211         if(plyrNames_[_pID][_name] == false)
1212             plyrNames_[_pID][_name] = true;
1213     }
1214 
1215     /**
1216      * @dev gets existing or registers new pID.  use this when a player may be new
1217      * @return pID 
1218      */
1219     function determinePID(RPdatasets.EventReturns memory _eventData_)
1220         private
1221         returns (RPdatasets.EventReturns)
1222     {
1223         uint256 _pID = pIDxAddr_[msg.sender];
1224         // if player is new to this version of fomo3d
1225         if (_pID == 0)
1226         {
1227             // grab their player ID, name and last aff ID, from player names contract 
1228             _pID = PlayerBook.getPlayerID(msg.sender);
1229             bytes32 _name = PlayerBook.getPlayerName(_pID);
1230             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1231 
1232             // set up player account 
1233             pIDxAddr_[msg.sender] = _pID;
1234             plyr_[_pID].addr = msg.sender;
1235 
1236             if (_name != "")
1237             {
1238                 pIDxName_[_name] = _pID;
1239                 plyr_[_pID].name = _name;
1240                 plyrNames_[_pID][_name] = true;
1241             }
1242 
1243             if (_laff != 0 && _laff != _pID)
1244                 plyr_[_pID].laff = _laff;
1245 
1246             // set the new player bool to true
1247             _eventData_.compressedData = _eventData_.compressedData + 1;
1248         }
1249         return (_eventData_);
1250     }
1251 
1252     /**
1253      * @dev checks to make sure user picked a valid team.  if not sets team 
1254      * to default (sneks)
1255      */
1256     function verifyTeam(uint256 _team)
1257         private
1258         pure
1259         returns (uint256)
1260     {
1261         if (_team < 0 || _team > 3)
1262             return(2);
1263         else
1264             return(_team);
1265     }
1266 
1267     /**
1268      * @dev decides if round end needs to be run & new round started.  and if 
1269      * player unmasked earnings from previously played rounds need to be moved.
1270      */
1271     function managePlayer(uint256 _pID, RPdatasets.EventReturns memory _eventData_)
1272         private
1273         returns (RPdatasets.EventReturns)
1274     {
1275         // if player has played a previous round, move their unmasked earnings
1276         // from that round to gen vault.
1277         if (plyr_[_pID].lrnd != 0)
1278             updateGenVault(_pID, plyr_[_pID].lrnd);
1279 
1280         // update player's last round played
1281         plyr_[_pID].lrnd = rID_;
1282             
1283         // set the joined round bool to true
1284         _eventData_.compressedData = _eventData_.compressedData + 10;
1285 
1286         return(_eventData_);
1287     }
1288 
1289     /**
1290      * @dev ends the round. manages paying out winner/splitting up pot
1291      */
1292     function endRound(RPdatasets.EventReturns memory _eventData_)
1293         private
1294         returns (RPdatasets.EventReturns)
1295     {
1296         // setup local rID
1297         uint256 _rID = rID_;
1298         
1299         // grab our winning player and team id's
1300         uint256 _winPID = round_[_rID].plyr;
1301         uint256 _winTID = round_[_rID].team;
1302         
1303         // grab our pot amount
1304         uint256 _pot = round_[_rID].pot;
1305         
1306         // calculate our winner share, community rewards, gen share, 
1307         // p3d share, and amount reserved for next pot 
1308         uint256 _win = (_pot.mul(potSplit_[_winTID].pot)) / 100;
1309         uint256 _com = (_pot.mul(potSplit_[_winTID].dev)) / 100;
1310         uint256 _gen = (_pot.mul(potSplit_[_winTID].emerald)) / 100;
1311         uint256 _glk = (_pot.mul(potSplit_[_winTID].glk)) / 100;
1312         uint256 _res = (_pot.mul(potSplit_[_winTID].nextRound)) / 100;
1313 
1314         // calculate ppt for round mask
1315         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1316         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1317         if (_dust > 0)
1318         {
1319             _gen = _gen.sub(_dust);
1320             _res = _res.add(_dust);
1321         }
1322 
1323         // pay our winner
1324         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1325 
1326         // Community awards
1327 
1328         //admin.transfer(_com);
1329 		
1330 		// send share for p3d to divies
1331         if (_glk > 0)
1332             Divies.deposit.value(_glk)();
1333 
1334         // distribute gen portion to key holders
1335         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1336 
1337         // Prepare event data
1338         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1339         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1340         _eventData_.winnerAddr = plyr_[_winPID].addr;
1341         _eventData_.winnerName = plyr_[_winPID].name;
1342         _eventData_.amountWon = _win;
1343         _eventData_.genAmount = _gen;
1344         _eventData_.P3DAmount = _glk;
1345         _eventData_.newPot = _res;
1346 
1347         // Start next round
1348         rID_++;
1349         _rID++;
1350         round_[_rID].strt = now;
1351         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1352         round_[_rID].pot = _res;
1353 
1354         return(_eventData_);
1355     }
1356 
1357     /**
1358      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1359      */
1360     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1361         private
1362     {
1363         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1364         if (_earnings > 0)
1365         {
1366             // put in gen vault
1367             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1368             // zero out their earnings by updating mask
1369             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1370         }
1371     }
1372 
1373     /**
1374      * @dev generates a random number between 0-99 and checks to see if thats
1375      * resulted in an airdrop win
1376      * @return do we have a winner?
1377      */
1378     function airdrop()
1379         private
1380         view
1381         returns(bool)
1382     {
1383         uint256 seed = uint256(keccak256(abi.encodePacked(
1384 
1385             (block.timestamp).add
1386             (block.difficulty).add
1387             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1388             (block.gaslimit).add
1389             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1390             (block.number)
1391 
1392         )));
1393         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1394             return(true);
1395         else
1396             return(false);
1397     }
1398 
1399     /**
1400      * @dev distributes eth based on fees to com, aff, and p3d
1401      */
1402     function distributeExternal(uint256 _rID, uint256 _eth, uint256 _team, RPdatasets.EventReturns memory _eventData_)
1403         private
1404         returns(RPdatasets.EventReturns)
1405     {
1406 
1407         // // pay 3% out to community rewards
1408         uint256 _emerald = (_eth.mul(fees_[_team].emerald)) / 100;
1409         uint256 _glk;
1410         if (!address(admin).call.value(_emerald)())
1411         {
1412             _glk = _emerald;
1413             _emerald = 0;
1414         }
1415 
1416 
1417         // pay p3d
1418         _glk = _glk.add((_eth.mul(fees_[_team].glk)) / 100);
1419         if (_glk > 0)
1420         {
1421             //round_[_rID].pot = round_[_rID].pot.add(_p3d);
1422 			// deposit to divies contract
1423             Divies.deposit.value(_glk)();
1424 
1425             // set event data
1426             _eventData_.P3DAmount = _glk.add(_eventData_.P3DAmount);
1427         }
1428 
1429         return(_eventData_);
1430     }
1431 
1432     // function potSwap()
1433     //     external
1434     //     payable
1435     // {
1436     //     // setup local rID
1437     //     uint256 _rID = rID_ + 1;
1438 
1439     //     round_[_rID].pot = round_[_rID].pot.add(msg.value);
1440     //     emit RPevents.onPotSwapDeposit(_rID, msg.value);
1441     // }
1442 
1443     /**
1444      * @dev distributes eth based on fees to gen and pot
1445      */
1446     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, RPdatasets.EventReturns memory _eventData_)
1447         private
1448         returns(RPdatasets.EventReturns)
1449     {
1450         
1451         // calculate gen share
1452         uint256 _gen = _eth.mul(fees_[_team].emerald) / 100;
1453 
1454         // distribute share to affiliate 15%
1455         uint256 _aff = _eth.mul(fees_[_team].aff) / 100;
1456 
1457         // calculate pot
1458         uint256 _pot = _eth.mul(fees_[_team].pot) / 100;
1459 
1460       // decide what to do with affiliate share of fees
1461         // affiliate must not be self, and must have a name registered
1462         if (_affID != _pID && plyr_[_affID].name != '') {
1463             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1464             emit RPevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1465         } else {
1466             _gen = _gen.add(_aff);
1467         }
1468 
1469         // distribute gen share (thats what updateMasks() does) and adjust
1470         // balances for dust.
1471         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1472         if (_dust > 0)
1473             _gen = _gen.sub(_dust);
1474 
1475         // add eth to pot
1476         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1477 
1478         // set up event data
1479         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1480         _eventData_.potAmount = _pot;
1481   
1482 
1483         return(_eventData_);
1484     }
1485 
1486     /**
1487      * @dev updates masks for round and player when keys are bought
1488      * @return dust left over 
1489      */
1490     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1491         private
1492         returns(uint256)
1493     {
1494         /* MASKING NOTES
1495             earnings masks are a tricky thing for people to wrap their minds around.
1496             the basic thing to understand here.  is were going to have a global
1497             tracker based on profit per share for each round, that increases in
1498             relevant proportion to the increase in share supply.
1499             
1500             the player will have an additional mask that basically says "based
1501             on the rounds mask, my shares, and how much i've already withdrawn,
1502             how much is still owed to me?"
1503         */
1504         
1505         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1506         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1507         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1508 
1509         // calculate player earning from their own buy (only based on the keys
1510         // they just bought).  & update player earnings mask
1511         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1512         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1513 
1514         // calculate and return dust
1515         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1516     }
1517 
1518     /**
1519      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1520      * @return earnings in wei format
1521      */
1522     function withdrawEarnings(uint256 _pID)
1523         private
1524         returns(uint256)
1525     {
1526         // update gen vault
1527         updateGenVault(_pID, plyr_[_pID].lrnd);
1528 
1529         // from vaults
1530         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1531         if (_earnings > 0)
1532         {
1533             plyr_[_pID].win = 0;
1534             plyr_[_pID].gen = 0;
1535             plyr_[_pID].aff = 0;
1536         }
1537 
1538         return(_earnings);
1539     }
1540 
1541      /**
1542      * @dev prepares compression data and fires event for buy or reload tx's
1543      */
1544     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, RPdatasets.EventReturns memory _eventData_)
1545         private
1546     {
1547         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1548         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1549 
1550         emit RPevents.onEndTx
1551         (
1552             _eventData_.compressedData,
1553             _eventData_.compressedIDs,
1554             plyr_[_pID].name,
1555             msg.sender,
1556             _eth,
1557             _keys,
1558             _eventData_.winnerAddr,
1559             _eventData_.winnerName,
1560             _eventData_.amountWon,
1561             _eventData_.newPot,
1562             _eventData_.P3DAmount,
1563             _eventData_.genAmount,
1564             _eventData_.potAmount,
1565             airDropPot_
1566         );
1567     }
1568 
1569 /****************************************************************************************************************************
1570                                                         SECURITY 
1571 ****************************************************************************************************************************/
1572 
1573 
1574     /** upon contract deploy, it will be deactivated.  this is a one time
1575      * use function that will activate the contract.  we do this so devs 
1576      * have time to set things up on the web end                   **/
1577     bool public activated_ = false;
1578     function activate()
1579         public
1580     {
1581         
1582         
1583         // set key price first 
1584         require(keyPrice_ != 0, "key price not set");
1585         
1586         // only admin  just can activate 
1587         require(msg.sender == admin, "only admin can activate");
1588 
1589 
1590         // can only be ran once
1591         require(activated_ == false, "FOMO Free already activated");
1592 
1593         // activate the contract
1594         activated_ = true;
1595 
1596         // let's start the first round
1597         rID_ = 1;
1598             round_[1].strt = now - rndGap_;
1599             round_[1].end = now + rndInit_ ;
1600     }
1601 }
1602 
1603 
1604 /****************************************************************************************************************************
1605                                                         STRUCTS 
1606 ****************************************************************************************************************************/
1607 
1608 
1609 library RPdatasets {
1610     //compressedData key
1611     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1612         // 0 - new player (bool)
1613         // 1 - joined round (bool)
1614         // 2 - new  leader (bool)
1615         // 3-5 - air drop tracker (uint 0-999)
1616         // 6-16 - round end time
1617         // 17 - winnerTeam
1618         // 18 - 28 timestamp 
1619         // 29 - team
1620         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1621         // 31 - airdrop happened bool
1622         // 32 - airdrop tier 
1623         // 33 - airdrop amount won
1624     //compressedIDs key
1625     // [77-52][51-26][25-0]
1626         // 0-25 - pID 
1627         // 26-51 - winPID
1628         // 52-77 - rID
1629     struct EventReturns {
1630         uint256 compressedData;
1631         uint256 compressedIDs;
1632         address winnerAddr;         // winner address
1633         bytes32 winnerName;         // winner name
1634         uint256 amountWon;          // amount won
1635         uint256 newPot;             // amount in new pot
1636         uint256 P3DAmount;          // amount distributed to p3d
1637         uint256 genAmount;          // amount distributed to gen
1638         uint256 potAmount;          // amount added to pot
1639      }
1640     struct Player {
1641         address addr;   // player address
1642         bytes32 name;   // player name
1643         uint256 win;    // winnings vault
1644         uint256 gen;    // general vault
1645         uint256 aff;    // affiliate vault
1646         uint256 lrnd;   // last round played
1647         uint256 laff;   // last affiliate id used
1648     }
1649     struct PlayerRounds {
1650         uint256 eth;    // eth player has added to round (used for eth limiter)
1651         uint256 keys;   // keys
1652         uint256 mask;   // player mask 
1653         uint256 ico;    // ICO phase investment
1654     }
1655     struct Round {
1656         uint256 plyr;   // pID of player in lead
1657         uint256 team;   // tID of team in lead
1658         uint256 end;    // time ends/ended
1659         bool ended;     // has round end function been ran
1660         uint256 strt;   // time round started
1661         uint256 keys;   // keys
1662         uint256 eth;    // total eth in
1663         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1664         uint256 mask;   // global mask
1665         uint256 ico;    // total eth sent in during ICO phase
1666         uint256 icoGen; // total eth for gen during ICO phase
1667         uint256 icoAvg; // average key price for ICO phase
1668     }
1669     struct TeamFee {
1670         uint256 pot; 
1671         uint256 emerald;
1672         uint256 glk;
1673         uint256 aff;
1674         uint256 dev;
1675         
1676     }
1677     struct PotSplit {
1678         uint256 pot;  
1679         uint256 dev; 
1680         uint256 nextRound;
1681         uint256 emerald;
1682         uint256 glk;
1683         
1684     }
1685 
1686 }
1687 
1688 
1689 /****************************************************************************************************************************
1690                                                         INTERFACES 
1691 ****************************************************************************************************************************/
1692 
1693 interface DiviesInterface {
1694     function deposit() external payable;
1695 }
1696 
1697 interface PlayerBookInterface {
1698     function getPlayerID(address _addr) external returns (uint256);
1699     function getPlayerName(uint256 _pID) external view returns (bytes32);
1700     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1701     function getPlayerAddr(uint256 _pID) external view returns (address);
1702     function getNameFee() external view returns (uint256);
1703     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1704     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1705     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1706 }
1707 
1708 
1709 library NameFilter {
1710     /**
1711      * @dev filters name strings
1712      * -converts uppercase to lower case.  
1713      * -makes sure it does not start/end with a space
1714      * -makes sure it does not contain multiple spaces in a row
1715      * -cannot be only numbers
1716      * -cannot start with 0x 
1717      * -restricts characters to A-Z, a-z, 0-9, and space.
1718      * @return reprocessed string in bytes32 format
1719      */
1720     function nameFilter(string _input)
1721         internal
1722         pure
1723         returns(bytes32)
1724     {
1725         bytes memory _temp = bytes(_input);
1726         uint256 _length = _temp.length;
1727 
1728         //sorry limited to 32 characters
1729         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1730         // make sure it doesnt start with or end with space
1731         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1732         // make sure first two characters are not 0x
1733         if (_temp[0] == 0x30)
1734         {
1735             require(_temp[1] != 0x78, "string cannot start with 0x");
1736             require(_temp[1] != 0x58, "string cannot start with 0X");
1737         }
1738 
1739         // create a bool to track if we have a non number character
1740         bool _hasNonNumber;
1741         
1742         // convert & check
1743         for (uint256 i = 0; i < _length; i++)
1744         {
1745             // if its uppercase A-Z
1746             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1747             {
1748                 // convert to lower case a-z
1749                 _temp[i] = byte(uint(_temp[i]) + 32);
1750                 
1751                 // we have a non number
1752                 if (_hasNonNumber == false)
1753                     _hasNonNumber = true;
1754             } else {
1755                 require
1756                 (
1757                     // require character is a space
1758                     _temp[i] == 0x20 || 
1759                     // OR lowercase a-z
1760                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1761                     // or 0-9
1762                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1763                     "string contains invalid characters"
1764                 );
1765                 // make sure theres not 2x spaces in a row
1766                 if (_temp[i] == 0x20)
1767                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1768 
1769                  // see if we have a character other than a number
1770                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1771                     _hasNonNumber = true;
1772             }
1773         }
1774 
1775         require(_hasNonNumber == true, "string cannot be only numbers");
1776 
1777         bytes32 _ret;
1778         assembly {
1779             _ret := mload(add(_temp, 32))
1780         }
1781         return (_ret);
1782     }
1783 }
1784 
1785 /**
1786  * @title SafeMath v0.1.9
1787  * @dev Math operations with safety checks that throw on error
1788  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1789  * - added sqrt
1790  * - added sq
1791  * - added pwr 
1792  * - changed asserts to requires with error log outputs
1793  * - removed div, its useless
1794  */
1795 library SafeMath {
1796 
1797     /**
1798     * @dev Get percent
1799     */
1800     function percent(uint256 _a, uint256 _b) 
1801         internal
1802         pure
1803         returns (uint256 ) {
1804         
1805         uint256 numerator = _b * 1000;
1806         
1807         require(numerator > _b); // overflow. Should use SafeMath throughout if this was a real implementation. 
1808         
1809         uint256 temp = numerator / _a + 5; // proper rounding up
1810         
1811         return temp / 10;
1812 
1813     }
1814 
1815 
1816     /**
1817     * @dev Round up
1818     */
1819     function ceil(uint a, uint m) 
1820         internal
1821         pure
1822         returns (uint ) {
1823         return ((a + m - 1) / m) * m;
1824     }
1825 
1826     /**
1827     * @dev Multiplies two numbers, throws on overflow.
1828     */
1829     function mul(uint256 a, uint256 b)
1830         internal
1831         pure
1832         returns (uint256 c)
1833     {
1834         if (a == 0) {
1835             return 0;
1836         }
1837         c = a * b;
1838         require(c / a == b, "SafeMath mul failed");
1839         return c;
1840     }
1841 
1842     /**
1843     *@dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend)
1844     */
1845     function sub(uint256 a, uint256 b)
1846         internal
1847         pure
1848         returns (uint256)
1849     {
1850         require(b <= a, "SafeMath sub failed");
1851         return a - b;
1852     }
1853 
1854     /**
1855     * @dev Adds two numbers, throws on overflow.
1856     */
1857     function add(uint256 a, uint256 b)
1858         internal
1859         pure
1860         returns (uint256 c) 
1861     {
1862         c = a + b;
1863         require(c >= a, "SafeMath add failed");
1864         return c;
1865     }
1866     
1867     /**
1868      * @dev gives square root of given x.
1869      */
1870     function sqrt(uint256 x)
1871         internal
1872         pure
1873         returns (uint256 y)
1874     {
1875         uint256 z = ((add(x,1)) / 2);
1876         y = x;
1877         while (z < y)
1878         {
1879             y = z;
1880             z = ((add((x / z),z)) / 2);
1881         }
1882     }
1883 
1884     /**
1885      * @dev gives square. multiplies x by x
1886      */
1887     function sq(uint256 x)
1888         internal
1889         pure
1890         returns (uint256)
1891     {
1892         return (mul(x,x));
1893     }
1894 
1895     /**
1896      * @dev x to the power of y 
1897      */
1898     function pwr(uint256 x, uint256 y)
1899         internal
1900         pure
1901         returns (uint256)
1902     {
1903         if (x==0)
1904             return (0);
1905         else if (y==0)
1906             return (1);
1907         else
1908         {
1909             uint256 z = x;
1910             for (uint256 i=1; i < y; i++)
1911                 z = mul(z,x);
1912             return (z);
1913         }
1914     }
1915 }