1 pragma solidity ^0.4.24;
2 
3 contract FOMOEvents {
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
31         uint256 tokenAmount,
32         uint256 genAmount,
33         uint256 potAmount
34     );
35 
36     // fired whenever theres a withdraw
37     event onWithdraw
38     (
39         uint256 indexed playerID,
40         address playerAddress,
41         bytes32 playerName,
42         uint256 ethOut,
43         uint256 timeStamp
44     );
45 
46     // fired whenever a withdraw forces end round to be ran
47     event onWithdrawAndDistribute
48     (
49         address playerAddress,
50         bytes32 playerName,
51         uint256 ethOut,
52         uint256 compressedData,
53         uint256 compressedIDs,
54         address winnerAddr,
55         bytes32 winnerName,
56         uint256 amountWon,
57         uint256 newPot,
58         uint256 tokenAmount,
59         uint256 genAmount
60     );
61 
62     // fired whenever a player tries a buy after round timer
63     // hit zero, and causes end round to be ran.
64     event onBuyAndDistribute
65     (
66         address playerAddress,
67         bytes32 playerName,
68         uint256 ethIn,
69         uint256 compressedData,
70         uint256 compressedIDs,
71         address winnerAddr,
72         bytes32 winnerName,
73         uint256 amountWon,
74         uint256 newPot,
75         uint256 tokenAmount,
76         uint256 genAmount
77     );
78 
79     // fired whenever a player tries a reload after round timer
80     // hit zero, and causes end round to be ran.
81     event onReLoadAndDistribute
82     (
83         address playerAddress,
84         bytes32 playerName,
85         uint256 compressedData,
86         uint256 compressedIDs,
87         address winnerAddr,
88         bytes32 winnerName,
89         uint256 amountWon,
90         uint256 newPot,
91         uint256 tokenAmount,
92         uint256 genAmount
93     );
94 
95     // fired whenever an affiliate is paid
96     event onAffiliatePayout
97     (
98         uint256 indexed affiliateID,
99         address affiliateAddress,
100         bytes32 affiliateName,
101         uint256 indexed roundID,
102         uint256 indexed buyerID,
103         uint256 amount,
104         uint256 timeStamp
105     );
106 }
107 
108 //==============================================================================
109 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
110 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
111 //====================================|=========================================
112 
113 contract BATMO is FOMOEvents {
114     using SafeMath for *;
115     using NameFilter for string;
116     using KeysCalc for uint256;
117 
118     PlayerBookInterface  private PlayerBook;
119 
120 //==============================================================================
121 //     _ _  _  |`. _     _ _ |_ | _  _  .
122 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
123 //=================_|===========================================================
124     OBOK public ObokContract;
125     address private admin = msg.sender;
126     address private admin2;
127     string constant public name = "BATMO";
128     string constant public symbol = "BATMO";
129     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
130     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
131     uint256 constant private rndInit_ = 2 hours;                // round timer starts at this
132     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
133     uint256 constant private rndMax_ = 2 hours;                // max length a round timer can be
134 //==============================================================================
135 //     _| _ _|_ _    _ _ _|_    _   .
136 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
137 //=============================|================================================
138     uint256 public rID_;    // round id number / total rounds that have happened
139 //****************
140 // PLAYER DATA
141 //****************
142     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
143     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
144     mapping (uint256 => BATMODatasets.Player) public plyr_;   // (pID => data) player data
145     mapping (uint256 => mapping (uint256 => BATMODatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
146     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
147 //****************
148 // ROUND DATA
149 //****************
150     mapping (uint256 => BATMODatasets.Round) public round_;   // (rID => data) round data
151     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
152 //****************
153 // TEAM FEE DATA
154 //****************
155     mapping (uint256 => BATMODatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
156     mapping (uint256 => BATMODatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
157 //==============================================================================
158 //     _ _  _  __|_ _    __|_ _  _  .
159 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
160 //==============================================================================
161     constructor(address otherAdmin, address token, address playerbook)
162         public
163     {
164         admin2 = otherAdmin;
165         ObokContract = OBOK(token);
166         PlayerBook = PlayerBookInterface(playerbook);
167         //no teams... 
168         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
169         fees_[0] = BATMODatasets.TeamFee(47,10);   //30% to pot, 10% to aff, 3% to com
170        
171 
172         potSplit_[0] = BATMODatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
173     }
174 //==============================================================================
175 //     _ _  _  _|. |`. _  _ _  .
176 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
177 //==============================================================================
178     /**
179      * @dev used to make sure no one can interact with contract until it has
180      * been activated.
181      */
182     modifier isActivated() {
183         require(activated_ == true);
184         _;
185     }
186 
187     /**
188      * @dev prevents contracts from interacting with fomo3d
189      */
190     modifier isHuman() {
191         address _addr = msg.sender;
192         uint256 _codeLength;
193         require (msg.sender == tx.origin);
194         assembly {_codeLength := extcodesize(_addr)}
195         require(_codeLength == 0);
196         
197         _;
198     }
199 
200     /**
201      * @dev sets boundaries for incoming tx
202      */
203     modifier isWithinLimits(uint256 _eth) {
204         require(_eth >= 1000000000);
205         require(_eth <= 100000000000000000000000);
206         _;
207     }
208 
209 //==============================================================================
210 //     _    |_ |. _   |`    _  __|_. _  _  _  .
211 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
212 //====|=========================================================================
213     /**
214      * @dev emergency buy uses last stored affiliate ID
215      */
216     function()
217         isActivated()
218         isHuman()
219         isWithinLimits(msg.value)
220         public
221         payable
222     {
223         // set up our tx event data and determine if player is new or not
224         BATMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
225 
226         // fetch player id
227         uint256 _pID = pIDxAddr_[msg.sender];
228 
229         // buy core
230         buyCore(_pID, plyr_[_pID].laff, _eventData_);
231     }
232 
233     /**
234      * @dev converts all incoming ethereum to keys.
235      * -functionhash- 0x8f38f309 (using ID for affiliate)
236      * -functionhash- 0x98a0871d (using address for affiliate)
237      * -functionhash- 0xa65b37a1 (using name for affiliate)
238      * @param _affCode the ID/address/name of the player who gets the affiliate fee
239      */
240     function buyXid(uint256 _affCode)
241         isActivated()
242         isHuman()
243         isWithinLimits(msg.value)
244         public
245         payable
246     {
247         // set up our tx event data and determine if player is new or not
248         BATMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
249 
250         // fetch player id
251         uint256 _pID = pIDxAddr_[msg.sender];
252 
253         // manage affiliate residuals
254         // if no affiliate code was given or player tried to use their own, lolz
255         if (_affCode == 0 || _affCode == _pID)
256         {
257             // use last stored affiliate code
258             _affCode = plyr_[_pID].laff;
259 
260         // if affiliate code was given & its not the same as previously stored
261         } else if (_affCode != plyr_[_pID].laff) {
262             // update last affiliate
263             plyr_[_pID].laff = _affCode;
264         }
265 
266         // buy core
267         buyCore(_pID, _affCode, _eventData_);
268     }
269 
270     function buyXaddr(address _affCode)
271         isActivated()
272         isHuman()
273         isWithinLimits(msg.value)
274         public
275         payable
276     {
277         // set up our tx event data and determine if player is new or not
278         BATMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
279 
280         // fetch player id
281         uint256 _pID = pIDxAddr_[msg.sender];
282 
283         // manage affiliate residuals
284         uint256 _affID;
285         // if no affiliate code was given or player tried to use their own, lolz
286         if (_affCode == address(0) || _affCode == msg.sender)
287         {
288             // use last stored affiliate code
289             _affID = plyr_[_pID].laff;
290 
291         // if affiliate code was given
292         } else {
293             // get affiliate ID from aff Code
294             _affID = pIDxAddr_[_affCode];
295 
296             // if affID is not the same as previously stored
297             if (_affID != plyr_[_pID].laff)
298             {
299                 // update last affiliate
300                 plyr_[_pID].laff = _affID;
301             }
302         }
303         // buy core
304         buyCore(_pID, _affID, _eventData_);
305     }
306 
307     function buyXname(bytes32 _affCode)
308         isActivated()
309         isHuman()
310         isWithinLimits(msg.value)
311         public
312         payable
313     {
314         // set up our tx event data and determine if player is new or not
315         BATMODatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
316 
317         // fetch player id
318         uint256 _pID = pIDxAddr_[msg.sender];
319 
320         // manage affiliate residuals
321         uint256 _affID;
322         // if no affiliate code was given or player tried to use their own, lolz
323         if (_affCode == '' || _affCode == plyr_[_pID].name)
324         {
325             // use last stored affiliate code
326             _affID = plyr_[_pID].laff;
327 
328         // if affiliate code was given
329         } else {
330             // get affiliate ID from aff Code
331             _affID = pIDxName_[_affCode];
332 
333             // if affID is not the same as previously stored
334             if (_affID != plyr_[_pID].laff)
335             {
336                 // update last affiliate
337                 plyr_[_pID].laff = _affID;
338             }
339         }
340 
341         // buy core
342         buyCore(_pID, _affID, _eventData_);
343     }
344 
345     /**
346      * @dev essentially the same as buy, but instead of you sending ether
347      * from your wallet, it uses your unwithdrawn earnings.
348      * -functionhash- 0x349cdcac (using ID for affiliate)
349      * -functionhash- 0x82bfc739 (using address for affiliate)
350      * -functionhash- 0x079ce327 (using name for affiliate)
351      * @param _affCode the ID/address/name of the player who gets the affiliate fee
352      * @param _eth amount of earnings to use (remainder returned to gen vault)
353      */
354     function reLoadXid(uint256 _affCode, uint256 _eth)
355         isActivated()
356         isHuman()
357         isWithinLimits(_eth)
358         public
359     {
360         // set up our tx event data
361         BATMODatasets.EventReturns memory _eventData_;
362 
363         // fetch player ID
364         uint256 _pID = pIDxAddr_[msg.sender];
365 
366         // manage affiliate residuals
367         // if no affiliate code was given or player tried to use their own, lolz
368         if (_affCode == 0 || _affCode == _pID)
369         {
370             // use last stored affiliate code
371             _affCode = plyr_[_pID].laff;
372 
373         // if affiliate code was given & its not the same as previously stored
374         } else if (_affCode != plyr_[_pID].laff) {
375             // update last affiliate
376             plyr_[_pID].laff = _affCode;
377         }
378 
379         // reload core
380         reLoadCore(_pID, _affCode,  _eth, _eventData_);
381     }
382 
383     function reLoadXaddr(address _affCode, uint256 _eth)
384         isActivated()
385         isHuman()
386         isWithinLimits(_eth)
387         public
388     {
389         // set up our tx event data
390         BATMODatasets.EventReturns memory _eventData_;
391 
392         // fetch player ID
393         uint256 _pID = pIDxAddr_[msg.sender];
394 
395         // manage affiliate residuals
396         uint256 _affID;
397         // if no affiliate code was given or player tried to use their own, lolz
398         if (_affCode == address(0) || _affCode == msg.sender)
399         {
400             // use last stored affiliate code
401             _affID = plyr_[_pID].laff;
402 
403         // if affiliate code was given
404         } else {
405             // get affiliate ID from aff Code
406             _affID = pIDxAddr_[_affCode];
407 
408             // if affID is not the same as previously stored
409             if (_affID != plyr_[_pID].laff)
410             {
411                 // update last affiliate
412                 plyr_[_pID].laff = _affID;
413             }
414         }
415 
416         // reload core
417         reLoadCore(_pID, _affID, _eth, _eventData_);
418     }
419 
420     function reLoadXname(bytes32 _affCode, uint256 _eth)
421         isActivated()
422         isHuman()
423         isWithinLimits(_eth)
424         public
425     {
426         // set up our tx event data
427         BATMODatasets.EventReturns memory _eventData_;
428 
429         // fetch player ID
430         uint256 _pID = pIDxAddr_[msg.sender];
431 
432         // manage affiliate residuals
433         uint256 _affID;
434         // if no affiliate code was given or player tried to use their own, lolz
435         if (_affCode == '' || _affCode == plyr_[_pID].name)
436         {
437             // use last stored affiliate code
438             _affID = plyr_[_pID].laff;
439 
440         // if affiliate code was given
441         } else {
442             // get affiliate ID from aff Code
443             _affID = pIDxName_[_affCode];
444 
445             // if affID is not the same as previously stored
446             if (_affID != plyr_[_pID].laff)
447             {
448                 // update last affiliate
449                 plyr_[_pID].laff = _affID;
450             }
451         }
452 
453         // reload core
454         reLoadCore(_pID, _affID, _eth, _eventData_);
455     }
456 
457     /**
458      * @dev withdraws all of your earnings.
459      * -functionhash- 0x3ccfd60b
460      */
461     function withdraw()
462         isActivated()
463         isHuman()
464         public
465     {
466         // setup local rID
467         uint256 _rID = rID_;
468 
469         // grab time
470         uint256 _now = now;
471 
472         // fetch player ID
473         uint256 _pID = pIDxAddr_[msg.sender];
474 
475         // setup temp var for player eth
476         uint256 _eth;
477 
478         // check to see if round has ended and no one has run round end yet
479         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
480         {
481             // set up our tx event data
482             BATMODatasets.EventReturns memory _eventData_;
483 
484             // end the round (distributes pot)
485             round_[_rID].ended = true;
486             _eventData_ = endRound(_eventData_);
487 
488             // get their earnings
489             _eth = withdrawEarnings(_pID);
490 
491             // gib moni
492             if (_eth > 0)
493                 plyr_[_pID].addr.transfer(_eth);
494 
495             // build event data
496             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
497             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
498 
499             // fire withdraw and distribute event
500             emit FOMOEvents.onWithdrawAndDistribute
501             (
502                 msg.sender,
503                 plyr_[_pID].name,
504                 _eth,
505                 _eventData_.compressedData,
506                 _eventData_.compressedIDs,
507                 _eventData_.winnerAddr,
508                 _eventData_.winnerName,
509                 _eventData_.amountWon,
510                 _eventData_.newPot,
511                 _eventData_.tokenAmount,
512                 _eventData_.genAmount
513             );
514 
515         // in any other situation
516         } else {
517             // get their earnings
518             _eth = withdrawEarnings(_pID);
519 
520             // gib moni
521             if (_eth > 0)
522                 plyr_[_pID].addr.transfer(_eth);
523 
524             // fire withdraw event
525             emit FOMOEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
526         }
527     }
528 
529     /**
530      * @dev use these to register names.  they are just wrappers that will send the
531      * registration requests to the PlayerBook contract.  So registering here is the
532      * same as registering there.  UI will always display the last name you registered.
533      * but you will still own all previously registered names to use as affiliate
534      * links.
535      * - must pay a registration fee.
536      * - name must be unique
537      * - names will be converted to lowercase
538      * - name cannot start or end with a space
539      * - cannot have more than 1 space in a row
540      * - cannot be only numbers
541      * - cannot start with 0x
542      * - name must be at least 1 char
543      * - max length of 32 characters long
544      * - allowed characters: a-z, 0-9, and space
545      * -functionhash- 0x921dec21 (using ID for affiliate)
546      * -functionhash- 0x3ddd4698 (using address for affiliate)
547      * -functionhash- 0x685ffd83 (using name for affiliate)
548      * @param _nameString players desired name
549      * @param _affCode affiliate ID, address, or name of who referred you
550      * @param _all set to true if you want this to push your info to all games
551      * (this might cost a lot of gas)
552      */
553     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
554         isHuman()
555         public
556         payable
557     {
558         bytes32 _name = _nameString.nameFilter();
559         address _addr = msg.sender;
560         uint256 _paid = msg.value;
561         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
562 
563         uint256 _pID = pIDxAddr_[_addr];
564 
565         // fire event
566         emit FOMOEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
567     }
568 
569     function registerNameXaddr(string _nameString, address _affCode, bool _all)
570         isHuman()
571         public
572         payable
573     {
574         bytes32 _name = _nameString.nameFilter();
575         address _addr = msg.sender;
576         uint256 _paid = msg.value;
577         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
578 
579         uint256 _pID = pIDxAddr_[_addr];
580 
581         // fire event
582         emit FOMOEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
583     }
584 
585     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
586         isHuman()
587         public
588         payable
589     {
590         bytes32 _name = _nameString.nameFilter();
591         address _addr = msg.sender;
592         uint256 _paid = msg.value;
593         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
594 
595         uint256 _pID = pIDxAddr_[_addr];
596 
597         // fire event
598         emit FOMOEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
599     }
600 //==============================================================================
601 //     _  _ _|__|_ _  _ _  .
602 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
603 //=====_|=======================================================================
604     /**
605      * @dev return the price buyer will pay for next 1 individual key.
606      * -functionhash- 0x018a25e8
607      * @return price for next key bought (in wei format)
608      */
609     function getBuyPrice()
610         public
611         view
612         returns(uint256)
613     {
614         // setup local rID
615         uint256 _rID = rID_;
616 
617         // grab time
618         uint256 _now = now;
619 
620         // are we in a round?
621         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
622             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
623         else // rounds over.  need price for new round
624             return ( 75000000000000 ); // init
625     }
626 
627     /**
628      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
629      * provider
630      * -functionhash- 0xc7e284b8
631      * @return time left in seconds
632      */
633     function getTimeLeft()
634         public
635         view
636         returns(uint256)
637     {
638         // setup local rID
639         uint256 _rID = rID_;
640 
641         // grab time
642         uint256 _now = now;
643 
644         if (_now < round_[_rID].end)
645             if (_now > round_[_rID].strt + rndGap_)
646                 return( (round_[_rID].end).sub(_now) );
647             else
648                 return( (round_[_rID].strt + rndGap_).sub(_now) );
649         else
650             return(0);
651     }
652 
653     /**
654      * @dev returns player earnings per vaults
655      * -functionhash- 0x63066434
656      * @return winnings vault
657      * @return general vault
658      * @return affiliate vault
659      */
660     function getPlayerVaults(uint256 _pID)
661         public
662         view
663         returns(uint256 ,uint256, uint256)
664     {
665         // setup local rID
666         uint256 _rID = rID_;
667 
668         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
669         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
670         {
671             // if player is winner
672             if (round_[_rID].plyr == _pID)
673             {
674                 return
675                 (
676                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
677                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
678                     plyr_[_pID].aff
679                 );
680             // if player is not the winner
681             } else {
682                 return
683                 (
684                     plyr_[_pID].win,
685                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
686                     plyr_[_pID].aff
687                 );
688             }
689 
690         // if round is still going on, or round has ended and round end has been ran
691         } else {
692             return
693             (
694                 plyr_[_pID].win,
695                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
696                 plyr_[_pID].aff
697             );
698         }
699     }
700 
701     /**
702      * solidity hates stack limits.  this lets us avoid that hate
703      */
704     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
705         private
706         view
707         returns(uint256)
708     {
709         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
710     }
711 
712     /**
713      * @dev returns all current round info needed for front end
714      * -functionhash- 0x747dff42
715      * @return eth invested during ICO phase
716      * @return round id
717      * @return total keys for round
718      * @return time round ends
719      * @return time round started
720      * @return current pot
721      * @return current team ID & player ID in lead
722      * @return current player in leads address
723      * @return current player in leads name
724      * @return team eth in for round
725      */
726     function getCurrentRoundInfo()
727         public
728         view
729         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256)
730     {
731         // setup local rID
732         uint256 _rID = rID_;
733 
734         return
735         (
736             round_[_rID].ico,               //0
737             _rID,                           //1
738             round_[_rID].keys,              //2
739             round_[_rID].end,               //3
740             round_[_rID].strt,              //4
741             round_[_rID].pot,               //5
742             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
743             plyr_[round_[_rID].plyr].addr,  //7
744             plyr_[round_[_rID].plyr].name,  //8
745             rndTmEth_[_rID][0]             //9
746             
747         );
748     }
749 
750     /**
751      * @dev returns player info based on address.  if no address is given, it will
752      * use msg.sender
753      * -functionhash- 0xee0b5d8b
754      * @param _addr address of the player you want to lookup
755      * @return player ID
756      * @return player name
757      * @return keys owned (current round)
758      * @return winnings vault
759      * @return general vault
760      * @return affiliate vault
761      * @return player round eth
762      */
763     function getPlayerInfoByAddress(address _addr)
764         public
765         view
766         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
767     {
768         // setup local rID
769         uint256 _rID = rID_;
770 
771         if (_addr == address(0))
772         {
773             _addr == msg.sender;
774         }
775         uint256 _pID = pIDxAddr_[_addr];
776 
777         return
778         (
779             _pID,                               //0
780             plyr_[_pID].name,                   //1
781             plyrRnds_[_pID][_rID].keys,         //2
782             plyr_[_pID].win,                    //3
783             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
784             plyr_[_pID].aff,                    //5
785             plyrRnds_[_pID][_rID].eth           //6
786         );
787     }
788 
789 //==============================================================================
790 //     _ _  _ _   | _  _ . _  .
791 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
792 //=====================_|=======================================================
793     /**
794      * @dev logic runs whenever a buy order is executed.  determines how to handle
795      * incoming eth depending on if we are in an active round or not
796      */
797     function buyCore(uint256 _pID, uint256 _affID, BATMODatasets.EventReturns memory _eventData_)
798         private
799     {
800         // setup local rID
801         uint256 _rID = rID_;
802 
803         // grab time
804         uint256 _now = now;
805 
806         // if round is active
807         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
808         {
809             // call core
810             core(_rID, _pID, msg.value, _affID, 0, _eventData_);
811 
812         // if round is not active
813         } else {
814             // check to see if end round needs to be ran
815             if (_now > round_[_rID].end && round_[_rID].ended == false)
816             {
817                 // end the round (distributes pot) & start new round
818                 round_[_rID].ended = true;
819                 _eventData_ = endRound(_eventData_);
820 
821                 // build event data
822                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
823                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
824 
825                 // fire buy and distribute event
826                 emit FOMOEvents.onBuyAndDistribute
827                 (
828                     msg.sender,
829                     plyr_[_pID].name,
830                     msg.value,
831                     _eventData_.compressedData,
832                     _eventData_.compressedIDs,
833                     _eventData_.winnerAddr,
834                     _eventData_.winnerName,
835                     _eventData_.amountWon,
836                     _eventData_.newPot,
837                     _eventData_.tokenAmount,
838                     _eventData_.genAmount
839                 );
840             }
841 
842             // put eth in players vault
843             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
844         }
845     }
846 
847     /**
848      * @dev logic runs whenever a reload order is executed.  determines how to handle
849      * incoming eth depending on if we are in an active round or not
850      */
851     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, BATMODatasets.EventReturns memory _eventData_)
852         private
853     {
854         // setup local rID
855         uint256 _rID = rID_;
856 
857         // grab time
858         uint256 _now = now;
859 
860         // if round is active
861         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
862         {
863             // get earnings from all vaults and return unused to gen vault
864             // because we use a custom safemath library.  this will throw if player
865             // tried to spend more eth than they have.
866             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
867 
868             // call core
869             core(_rID, _pID, _eth, _affID, 0, _eventData_);
870 
871         // if round is not active and end round needs to be ran
872         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
873             // end the round (distributes pot) & start new round
874             round_[_rID].ended = true;
875             _eventData_ = endRound(_eventData_);
876 
877             // build event data
878             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
879             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
880 
881             // fire buy and distribute event
882             emit FOMOEvents.onReLoadAndDistribute
883             (
884                 msg.sender,
885                 plyr_[_pID].name,
886                 _eventData_.compressedData,
887                 _eventData_.compressedIDs,
888                 _eventData_.winnerAddr,
889                 _eventData_.winnerName,
890                 _eventData_.amountWon,
891                 _eventData_.newPot,
892                 _eventData_.tokenAmount,
893                 _eventData_.genAmount
894             );
895         }
896     }
897 
898     /**
899      * @dev this is the core logic for any buy/reload that happens while a round
900      * is live.
901      */
902     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, BATMODatasets.EventReturns memory _eventData_)
903         private
904     {
905         // if player is new to round
906         if (plyrRnds_[_pID][_rID].keys == 0)
907             _eventData_ = managePlayer(_pID, _eventData_);
908 
909         // early round eth limiter
910         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
911         {
912             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
913             uint256 _refund = _eth.sub(_availableLimit);
914             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
915             _eth = _availableLimit;
916         }
917 
918         // if eth left is greater than min eth allowed (sorry no pocket lint)
919         if (_eth > 1000000000)
920         {
921 
922             // mint the new keys
923             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
924 
925             // if they bought at least 1 whole key
926             if (_keys >= 1000000000000000000)
927             {
928             updateTimer(_keys, _rID);
929 
930             // set new leaders
931             if (round_[_rID].plyr != _pID)
932                 round_[_rID].plyr = _pID;
933             if (round_[_rID].team != _team)
934                 round_[_rID].team = _team;
935 
936             // set the new leader bool to true
937             _eventData_.compressedData = _eventData_.compressedData + 100;
938         }
939 
940             // update player
941             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
942             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
943 
944             // update round
945             round_[_rID].keys = _keys.add(round_[_rID].keys);
946             round_[_rID].eth = _eth.add(round_[_rID].eth);
947             rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);
948 
949             // distribute eth
950             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
951             _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);
952 
953             // call end tx function to fire end tx event.
954             endTx(_pID, 0, _eth, _keys, _eventData_);
955         }
956     }
957 //==============================================================================
958 //     _ _ | _   | _ _|_ _  _ _  .
959 //    (_(_||(_|_||(_| | (_)| _\  .
960 //==============================================================================
961     /**
962      * @dev calculates unmasked earnings (just calculates, does not update mask)
963      * @return earnings in wei format
964      */
965     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
966         private
967         view
968         returns(uint256)
969     {
970         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
971     }
972 
973     /**
974      * @dev returns the amount of keys you would get given an amount of eth.
975      * -functionhash- 0xce89c80c
976      * @param _rID round ID you want price for
977      * @param _eth amount of eth sent in
978      * @return keys received
979      */
980     function calcKeysReceived(uint256 _rID, uint256 _eth)
981         public
982         view
983         returns(uint256)
984     {
985         // grab time
986         uint256 _now = now;
987 
988         // are we in a round?
989         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
990             return ( (round_[_rID].eth).keysRec(_eth) );
991         else // rounds over.  need keys for new round
992             return ( (_eth).keys() );
993     }
994 
995     /**
996      * @dev returns current eth price for X keys.
997      * -functionhash- 0xcf808000
998      * @param _keys number of keys desired (in 18 decimal format)
999      * @return amount of eth needed to send
1000      */
1001     function iWantXKeys(uint256 _keys)
1002         public
1003         view
1004         returns(uint256)
1005     {
1006         // setup local rID
1007         uint256 _rID = rID_;
1008 
1009         // grab time
1010         uint256 _now = now;
1011 
1012         // are we in a round?
1013         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1014             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1015         else // rounds over.  need price for new round
1016             return ( (_keys).eth() );
1017     }
1018 //==============================================================================
1019 //    _|_ _  _ | _  .
1020 //     | (_)(_)|_\  .
1021 //==============================================================================
1022     /**
1023      * @dev receives name/player info from names contract
1024      */
1025     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1026         external
1027     {
1028         require (msg.sender == address(PlayerBook));
1029         if (pIDxAddr_[_addr] != _pID)
1030             pIDxAddr_[_addr] = _pID;
1031         if (pIDxName_[_name] != _pID)
1032             pIDxName_[_name] = _pID;
1033         if (plyr_[_pID].addr != _addr)
1034             plyr_[_pID].addr = _addr;
1035         if (plyr_[_pID].name != _name)
1036             plyr_[_pID].name = _name;
1037         if (plyr_[_pID].laff != _laff)
1038             plyr_[_pID].laff = _laff;
1039         if (plyrNames_[_pID][_name] == false)
1040             plyrNames_[_pID][_name] = true;
1041     }
1042 
1043     /**
1044      * @dev receives entire player name list
1045      */
1046     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1047         external
1048     {
1049         require (msg.sender == address(PlayerBook));
1050         if(plyrNames_[_pID][_name] == false)
1051             plyrNames_[_pID][_name] = true;
1052     }
1053 
1054     /**
1055      * @dev gets existing or registers new pID.  use this when a player may be new
1056      * @return pID
1057      */
1058     function determinePID(BATMODatasets.EventReturns memory _eventData_)
1059         private
1060         returns (BATMODatasets.EventReturns)
1061     {
1062         uint256 _pID = pIDxAddr_[msg.sender];
1063         // if player is new to this version of fomo3d
1064         if (_pID == 0)
1065         {
1066             // grab their player ID, name and last aff ID, from player names contract
1067             _pID = PlayerBook.getPlayerID(msg.sender);
1068             bytes32 _name = PlayerBook.getPlayerName(_pID);
1069             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1070 
1071             // set up player account
1072             pIDxAddr_[msg.sender] = _pID;
1073             plyr_[_pID].addr = msg.sender;
1074 
1075             if (_name != "")
1076             {
1077                 pIDxName_[_name] = _pID;
1078                 plyr_[_pID].name = _name;
1079                 plyrNames_[_pID][_name] = true;
1080             }
1081 
1082             if (_laff != 0 && _laff != _pID)
1083                 plyr_[_pID].laff = _laff;
1084 
1085             // set the new player bool to true
1086             _eventData_.compressedData = _eventData_.compressedData + 1;
1087         }
1088         return (_eventData_);
1089     }
1090 
1091     
1092 
1093     /**
1094      * @dev decides if round end needs to be run & new round started.  and if
1095      * player unmasked earnings from previously played rounds need to be moved.
1096      */
1097     function managePlayer(uint256 _pID, BATMODatasets.EventReturns memory _eventData_)
1098         private
1099         returns (BATMODatasets.EventReturns)
1100     {
1101         // if player has played a previous round, move their unmasked earnings
1102         // from that round to gen vault.
1103         if (plyr_[_pID].lrnd != 0)
1104             updateGenVault(_pID, plyr_[_pID].lrnd);
1105 
1106         // update player's last round played
1107         plyr_[_pID].lrnd = rID_;
1108 
1109         // set the joined round bool to true
1110         _eventData_.compressedData = _eventData_.compressedData + 10;
1111 
1112         return(_eventData_);
1113     }
1114 
1115     /**
1116      * @dev ends the round. manages paying out winner/splitting up pot
1117      */
1118     function endRound(BATMODatasets.EventReturns memory _eventData_)
1119         private
1120         returns (BATMODatasets.EventReturns)
1121     {
1122         // setup local rID
1123         uint256 _rID = rID_;
1124 
1125         // grab our winning player and team id's
1126         uint256 _winPID = round_[_rID].plyr;
1127         uint256 _winTID = round_[_rID].team;
1128 
1129         // grab our pot amount
1130         uint256 _pot = round_[_rID].pot;
1131 
1132         // calculate our winner share, community rewards, gen share,
1133         // tokenholder share, and amount reserved for next pot
1134         uint256 _win = (_pot.mul(48)) / 100;   //48%
1135         uint256 _dev = (_pot / 50);            //2%
1136         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1137         uint256 _OBOK = (_pot.mul(potSplit_[_winTID].obok)) / 100;
1138         uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_OBOK);
1139 
1140         // calculate ppt for round mask
1141         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1142         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1143         if (_dust > 0)
1144         {
1145             _gen = _gen.sub(_dust);
1146             _res = _res.add(_dust);
1147         }
1148 
1149         // pay our winner
1150         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1151 
1152         // community rewards
1153 
1154         admin.transfer(_dev / 2);
1155         admin2.transfer(_dev / 2);
1156 
1157         address(ObokContract).call.value(_OBOK.sub((_OBOK / 3).mul(2)))(bytes4(keccak256("donateDivs()")));  //66%
1158 
1159         round_[_rID].pot = _pot.add(_OBOK / 3);  // 33%
1160 
1161         // distribute gen portion to key holders
1162         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1163 
1164         // prepare event data
1165         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1166         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1167         _eventData_.winnerAddr = plyr_[_winPID].addr;
1168         _eventData_.winnerName = plyr_[_winPID].name;
1169         _eventData_.amountWon = _win;
1170         _eventData_.genAmount = _gen;
1171         _eventData_.tokenAmount = _OBOK;
1172         _eventData_.newPot = _res;
1173 
1174         // start next round
1175         rID_++;
1176         _rID++;
1177         round_[_rID].strt = now;
1178         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1179         round_[_rID].pot += _res;
1180 
1181         return(_eventData_);
1182     }
1183 
1184     /**
1185      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1186      */
1187     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1188         private
1189     {
1190         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1191         if (_earnings > 0)
1192         {
1193             // put in gen vault
1194             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1195             // zero out their earnings by updating mask
1196             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1197         }
1198     }
1199 
1200     /**
1201      * @dev updates round timer based on number of whole keys bought.
1202      */
1203     function updateTimer(uint256 _keys, uint256 _rID)
1204         private
1205     {
1206         // grab time
1207         uint256 _now = now;
1208 
1209         // calculate time based on number of keys bought
1210         uint256 _newTime;
1211         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1212             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1213         else
1214             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1215 
1216         // compare to max and set new end time
1217         if (_newTime < (rndMax_).add(_now))
1218             round_[_rID].end = _newTime;
1219         else
1220             round_[_rID].end = rndMax_.add(_now);
1221     }
1222 
1223    
1224     /**
1225      * @dev distributes eth based on fees to com, aff, and p3d
1226      */
1227     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, BATMODatasets.EventReturns memory _eventData_)
1228         private
1229         returns(BATMODatasets.EventReturns)
1230     {
1231         // pay 3% out to community rewards
1232         uint256 _p1 = _eth / 100;  //  1%
1233         uint256 _dev = _eth / 50;  //  2%
1234         _dev = _dev.add(_p1);  //  1%  + 2% = 3%
1235 
1236         uint256 _OBOK;
1237         if (!address(admin).call.value(_dev/2)() && !address(admin2).call.value(_dev/2)())
1238         {
1239             _OBOK = _dev;
1240             _dev = 0;
1241         }
1242 
1243 
1244         // distribute share to affiliate
1245         uint256 _aff = _eth / 10;
1246 
1247         // decide what to do with affiliate share of fees
1248         // affiliate must not be self, and must have a name registered
1249         if (_affID != _pID && plyr_[_affID].name != '') {
1250             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1251             emit FOMOEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1252         } else {
1253             _OBOK = _aff;
1254         }
1255 
1256         // pay out obok
1257         _OBOK = _OBOK.add((_eth.mul(fees_[_team].obok)) / (100));
1258         if (_OBOK > 0)
1259         {
1260             // deposit to divies contract
1261             uint256 _potAmount = _OBOK / 2;
1262             
1263             address(ObokContract).call.value(_OBOK.sub(_potAmount))(bytes4(keccak256("donateDivs()")));
1264 
1265             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1266 
1267             // set up event data
1268             _eventData_.tokenAmount = _OBOK.add(_eventData_.tokenAmount);
1269         }
1270 
1271         return(_eventData_);
1272     }
1273 
1274     /**
1275      * @dev distributes eth based on fees to gen and pot
1276      */
1277     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, BATMODatasets.EventReturns memory _eventData_)
1278         private
1279         returns(BATMODatasets.EventReturns)
1280     {
1281         // calculate gen share
1282         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1283 
1284         // update eth balance (eth = eth - (com share + pot swap share + aff share + obok share))
1285         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].obok)) / 100));
1286 
1287         // calculate pot
1288         uint256 _pot = _eth.sub(_gen);
1289 
1290         // distribute gen share (thats what updateMasks() does) and adjust
1291         // balances for dust.
1292         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1293         if (_dust > 0)
1294             _gen = _gen.sub(_dust);
1295 
1296         // add eth to pot
1297         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1298 
1299         // set up event data
1300         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1301         _eventData_.potAmount = _pot;
1302 
1303         return(_eventData_);
1304     }
1305 
1306     /**
1307      * @dev updates masks for round and player when keys are bought
1308      * @return dust left over
1309      */
1310     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1311         private
1312         returns(uint256)
1313     {
1314         /* MASKING NOTES
1315             earnings masks are a tricky thing for people to wrap their minds around.
1316             the basic thing to understand here.  is were going to have a global
1317             tracker based on profit per share for each round, that increases in
1318             relevant proportion to the increase in share supply.
1319 
1320             the player will have an additional mask that basically says "based
1321             on the rounds mask, my shares, and how much i've already withdrawn,
1322             how much is still owed to me?"
1323         */
1324 
1325         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1326         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1327         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1328 
1329         // calculate player earning from their own buy (only based on the keys
1330         // they just bought).  & update player earnings mask
1331         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1332         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1333 
1334         // calculate & return dust
1335         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1336     }
1337 
1338     /**
1339      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1340      * @return earnings in wei format
1341      */
1342     function withdrawEarnings(uint256 _pID)
1343         private
1344         returns(uint256)
1345     {
1346         // update gen vault
1347         updateGenVault(_pID, plyr_[_pID].lrnd);
1348 
1349         // from vaults
1350         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1351         if (_earnings > 0)
1352         {
1353             plyr_[_pID].win = 0;
1354             plyr_[_pID].gen = 0;
1355             plyr_[_pID].aff = 0;
1356         }
1357 
1358         return(_earnings);
1359     }
1360 
1361     /**
1362      * @dev prepares compression data and fires event for buy or reload tx's
1363      */
1364     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, BATMODatasets.EventReturns memory _eventData_)
1365         private
1366     {
1367         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1368         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1369 
1370         emit FOMOEvents.onEndTx
1371         (
1372             _eventData_.compressedData,
1373             _eventData_.compressedIDs,
1374             plyr_[_pID].name,
1375             msg.sender,
1376             _eth,
1377             _keys,
1378             _eventData_.winnerAddr,
1379             _eventData_.winnerName,
1380             _eventData_.amountWon,
1381             _eventData_.newPot,
1382             _eventData_.tokenAmount,
1383             _eventData_.genAmount,
1384             _eventData_.potAmount
1385         );
1386     }
1387 //==============================================================================
1388 //    (~ _  _    _._|_    .
1389 //    _)(/_(_|_|| | | \/  .
1390 //====================/=========================================================
1391     /** upon contract deploy, it will be deactivated.  this is a one time
1392      * use function that will activate the contract.  we do this so devs
1393      * have time to set things up on the web end                            **/
1394     bool public activated_ = false;
1395     function activate()
1396         public
1397     {
1398         // only team just can activate
1399         require(msg.sender == admin, "only admin can activate");
1400 
1401 
1402         // can only be ran once
1403         require(activated_ == false, "FOMO Short already activated");
1404 
1405         // activate the contract
1406         activated_ = true;
1407 
1408         // lets start first round
1409         rID_ = 1;
1410             round_[1].strt = now + rndExtra_ - rndGap_;
1411             round_[1].end = now + rndInit_ + rndExtra_;
1412     }
1413 }
1414 
1415 //==============================================================================
1416 //   __|_ _    __|_ _  .
1417 //  _\ | | |_|(_ | _\  .
1418 //==============================================================================
1419 library BATMODatasets {
1420     
1421     struct EventReturns {
1422         uint256 compressedData;
1423         uint256 compressedIDs;
1424         address winnerAddr;         // winner address
1425         bytes32 winnerName;         // winner name
1426         uint256 amountWon;          // amount won
1427         uint256 newPot;             // amount in new pot
1428         uint256 tokenAmount;          // amount distributed to tokenholders
1429         uint256 genAmount;          // amount distributed to gen
1430         uint256 potAmount;          // amount added to pot
1431     }
1432     struct Player {
1433         address addr;   // player address
1434         bytes32 name;   // player name
1435         uint256 win;    // winnings vault
1436         uint256 gen;    // general vault
1437         uint256 aff;    // affiliate vault
1438         uint256 lrnd;   // last round played
1439         uint256 laff;   // last affiliate id used
1440     }
1441     struct PlayerRounds {
1442         uint256 eth;    // eth player has added to round (used for eth limiter)
1443         uint256 keys;   // keys
1444         uint256 mask;   // player mask
1445         uint256 ico;    // ICO phase investment
1446     }
1447     struct Round {
1448         uint256 plyr;   // pID of player in lead
1449         uint256 team;   // tID of team in lead
1450         uint256 end;    // time ends/ended
1451         bool ended;     // has round end function been ran
1452         uint256 strt;   // time round started
1453         uint256 keys;   // keys
1454         uint256 eth;    // total eth in
1455         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1456         uint256 mask;   // global mask
1457         uint256 ico;    // total eth sent in during ICO phase
1458         uint256 icoGen; // total eth for gen during ICO phase
1459         uint256 icoAvg; // average key price for ICO phase
1460     }
1461     struct TeamFee {
1462         uint256 gen;    // % of buy in thats paid to key holders of current round
1463         uint256 obok;    // % of buy in thats paid to obok holders
1464     }
1465     struct PotSplit {
1466         uint256 gen;    // % of pot thats paid to key holders of current round
1467         uint256 obok;    // % of pot thats paid to obok holders
1468     }
1469 }
1470 
1471 //==============================================================================
1472 //  |  _      _ _ | _  .
1473 //  |<(/_\/  (_(_||(_  .
1474 //=======/======================================================================
1475 library KeysCalc {
1476     using SafeMath for *;
1477     /**
1478      * @dev calculates number of keys received given X eth
1479      * @param _curEth current amount of eth in contract
1480      * @param _newEth eth being spent
1481      * @return amount of ticket purchased
1482      */
1483     function keysRec(uint256 _curEth, uint256 _newEth)
1484         internal
1485         pure
1486         returns (uint256)
1487     {
1488         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1489     }
1490 
1491     /**
1492      * @dev calculates amount of eth received if you sold X keys
1493      * @param _curKeys current amount of keys that exist
1494      * @param _sellKeys amount of keys you wish to sell
1495      * @return amount of eth received
1496      */
1497     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1498         internal
1499         pure
1500         returns (uint256)
1501     {
1502         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1503     }
1504 
1505     /**
1506      * @dev calculates how many keys would exist with given an amount of eth
1507      * @param _eth eth "in contract"
1508      * @return number of keys that would exist
1509      */
1510     function keys(uint256 _eth)
1511         internal
1512         pure
1513         returns(uint256)
1514     {
1515         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1516     }
1517 
1518     /**
1519      * @dev calculates how much eth would be in contract given a number of keys
1520      * @param _keys number of keys "in contract"
1521      * @return eth that would exists
1522      */
1523     function eth(uint256 _keys)
1524         internal
1525         pure
1526         returns(uint256)
1527     {
1528         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1529     }
1530 }
1531 
1532 //==============================================================================
1533 //  . _ _|_ _  _ |` _  _ _  _  .
1534 //  || | | (/_| ~|~(_|(_(/__\  .
1535 //==============================================================================
1536 
1537 //Define the Obok token for the PoCWHALE
1538 contract OBOK 
1539 {
1540     function donateDivs() public payable;
1541 }
1542 
1543 interface PlayerBookInterface {
1544     function getPlayerID(address _addr) external returns (uint256);
1545     function getPlayerName(uint256 _pID) external view returns (bytes32);
1546     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1547     function getPlayerAddr(uint256 _pID) external view returns (address);
1548     function getNameFee() external view returns (uint256);
1549     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1550     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1551     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1552 }
1553 
1554 
1555 library NameFilter {
1556     /**
1557      * @dev filters name strings
1558      * -converts uppercase to lower case.
1559      * -makes sure it does not start/end with a space
1560      * -makes sure it does not contain multiple spaces in a row
1561      * -cannot be only numbers
1562      * -cannot start with 0x
1563      * -restricts characters to A-Z, a-z, 0-9, and space.
1564      * @return reprocessed string in bytes32 format
1565      */
1566     function nameFilter(string _input)
1567         internal
1568         pure
1569         returns(bytes32)
1570     {
1571         bytes memory _temp = bytes(_input);
1572         uint256 _length = _temp.length;
1573 
1574         //sorry limited to 32 characters
1575         require (_length <= 32 && _length > 0);
1576         // make sure it doesnt start with or end with space
1577         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20);
1578         // make sure first two characters are not 0x
1579         if (_temp[0] == 0x30)
1580         {
1581             require(_temp[1] != 0x78);
1582             require(_temp[1] != 0x58);
1583         }
1584 
1585         // create a bool to track if we have a non number character
1586         bool _hasNonNumber;
1587 
1588         // convert & check
1589         for (uint256 i = 0; i < _length; i++)
1590         {
1591             // if its uppercase A-Z
1592             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1593             {
1594                 // convert to lower case a-z
1595                 _temp[i] = byte(uint(_temp[i]) + 32);
1596 
1597                 // we have a non number
1598                 if (_hasNonNumber == false)
1599                     _hasNonNumber = true;
1600             } else {
1601                 require
1602                 (
1603                     // require character is a space
1604                     _temp[i] == 0x20 ||
1605                     // OR lowercase a-z
1606                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1607                     // or 0-9
1608                     (_temp[i] > 0x2f && _temp[i] < 0x3a));
1609                 // make sure theres not 2x spaces in a row
1610                 if (_temp[i] == 0x20)
1611                     require( _temp[i+1] != 0x20);
1612 
1613                 // see if we have a character other than a number
1614                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1615                     _hasNonNumber = true;
1616             }
1617         }
1618 
1619         require(_hasNonNumber == true);
1620 
1621         bytes32 _ret;
1622         assembly {
1623             _ret := mload(add(_temp, 32))
1624         }
1625         return (_ret);
1626     }
1627 }
1628 
1629 /**
1630  * @title SafeMath v0.1.9
1631  * @dev Math operations with safety checks that throw on error
1632  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1633  * - added sqrt
1634  * - added sq
1635  * - added pwr
1636  * - changed asserts to requires with error log outputs
1637  * - removed div, its useless
1638  */
1639 library SafeMath {
1640 
1641     /**
1642     * @dev Multiplies two numbers, throws on overflow.
1643     */
1644     function mul(uint256 a, uint256 b)
1645         internal
1646         pure
1647         returns (uint256 c)
1648     {
1649         if (a == 0) {
1650             return 0;
1651         }
1652         c = a * b;
1653         require(c / a == b, "SafeMath mul failed");
1654         return c;
1655     }
1656 
1657     /**
1658     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1659     */
1660     function sub(uint256 a, uint256 b)
1661         internal
1662         pure
1663         returns (uint256)
1664     {
1665         require(b <= a, "SafeMath sub failed");
1666         return a - b;
1667     }
1668 
1669     /**
1670     * @dev Adds two numbers, throws on overflow.
1671     */
1672     function add(uint256 a, uint256 b)
1673         internal
1674         pure
1675         returns (uint256 c)
1676     {
1677         c = a + b;
1678         require(c >= a, "SafeMath add failed");
1679         return c;
1680     }
1681 
1682     /**
1683      * @dev gives square root of given x.
1684      */
1685     function sqrt(uint256 x)
1686         internal
1687         pure
1688         returns (uint256 y)
1689     {
1690         uint256 z = ((add(x,1)) / 2);
1691         y = x;
1692         while (z < y)
1693         {
1694             y = z;
1695             z = ((add((x / z),z)) / 2);
1696         }
1697     }
1698 
1699     /**
1700      * @dev gives square. multiplies x by x
1701      */
1702     function sq(uint256 x)
1703         internal
1704         pure
1705         returns (uint256)
1706     {
1707         return (mul(x,x));
1708     }
1709 
1710     /**
1711      * @dev x to the power of y
1712      */
1713     function pwr(uint256 x, uint256 y)
1714         internal
1715         pure
1716         returns (uint256)
1717     {
1718         if (x==0)
1719             return (0);
1720         else if (y==0)
1721             return (1);
1722         else
1723         {
1724             uint256 z = x;
1725             for (uint256 i=1; i < y; i++)
1726                 z = mul(z,x);
1727             return (z);
1728         }
1729     }
1730 }