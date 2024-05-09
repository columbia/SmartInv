1 pragma solidity ^0.4.24;
2 
3 
4 contract F3Devents {
5     // fired whenever a player registers a name
6     event onNewName
7     (
8         uint256 indexed playerID,
9         address indexed playerAddress,
10         bytes32 indexed playerName,
11         bool isNewPlayer,
12         uint256 affiliateID,
13         address affiliateAddress,
14         bytes32 affiliateName,
15         uint256 amountPaid,
16         uint256 timeStamp
17     );
18 
19     // fired at end of buy or reload
20     event onEndTx
21     (
22         uint256 compressedData,
23         uint256 compressedIDs,
24         bytes32 playerName,
25         address playerAddress,
26         uint256 ethIn,
27         uint256 keysBought,
28         address winnerAddr,
29         bytes32 winnerName,
30         uint256 amountWon,
31         uint256 newPot,
32         uint256 P3DAmount,
33         uint256 genAmount,
34         uint256 potAmount,
35         uint256 airDropPot
36     );
37 
38     // fired whenever theres a withdraw
39     event onWithdraw
40     (
41         uint256 indexed playerID,
42         address playerAddress,
43         bytes32 playerName,
44         uint256 ethOut,
45         uint256 timeStamp
46     );
47 
48     // fired whenever a withdraw forces end round to be ran
49     event onWithdrawAndDistribute
50     (
51         address playerAddress,
52         bytes32 playerName,
53         uint256 ethOut,
54         uint256 compressedData,
55         uint256 compressedIDs,
56         address winnerAddr,
57         bytes32 winnerName,
58         uint256 amountWon,
59         uint256 newPot,
60         uint256 P3DAmount,
61         uint256 genAmount
62     );
63 
64     // (fomo3d long only) fired whenever a player tries a buy after round timer
65     // hit zero, and causes end round to be ran.
66     event onBuyAndDistribute
67     (
68         address playerAddress,
69         bytes32 playerName,
70         uint256 ethIn,
71         uint256 compressedData,
72         uint256 compressedIDs,
73         address winnerAddr,
74         bytes32 winnerName,
75         uint256 amountWon,
76         uint256 newPot,
77         uint256 P3DAmount,
78         uint256 genAmount
79     );
80 
81     // (fomo3d long only) fired whenever a player tries a reload after round timer
82     // hit zero, and causes end round to be ran.
83     event onReLoadAndDistribute
84     (
85         address playerAddress,
86         bytes32 playerName,
87         uint256 compressedData,
88         uint256 compressedIDs,
89         address winnerAddr,
90         bytes32 winnerName,
91         uint256 amountWon,
92         uint256 newPot,
93         uint256 P3DAmount,
94         uint256 genAmount
95     );
96 
97     // fired whenever an affiliate is paid
98     event onAffiliatePayout
99     (
100         uint256 indexed affiliateID,
101         address affiliateAddress,
102         bytes32 affiliateName,
103         uint256 indexed roundID,
104         uint256 indexed buyerID,
105         uint256 amount,
106         uint256 timeStamp
107     );
108 
109     // received pot swap deposit
110     event onPotSwapDeposit
111     (
112         uint256 roundID,
113         uint256 amountAddedToPot
114     );
115 
116 
117 }
118 
119 
120 
121 contract FoMo3Dlong is F3Devents {
122     using SafeMath for *;
123     using NameFilter for string;
124     using F3DKeysCalcLong for uint256;
125 
126     address private com = 0x0787c7510b21305eea4c267fafd46ab85bdec67e; // community distribution address
127     address private admin = msg.sender;
128 
129 
130 
131     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xB4F9b38A2676f3dB2630219126C917e793C29574);
132 
133 //==============================================================================
134 //     _ _  _  |`. _     _ _ |_ | _  _  .
135 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
136 //=================_|===========================================================
137     string constant public name = "XMG Long Official";
138     string constant public symbol = "XMG";
139     uint256 private rndExtra_ = 0;     // length of the very first ICO
140     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
141     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
142     uint256 constant private rndInc_ = 1 minutes;              // every full key purchased adds this much to the timer
143     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
144 //==============================================================================
145 //     _| _ _|_ _    _ _ _|_    _   .
146 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
147 //=============================|================================================
148     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
149     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
150     uint256 public rID_;    // round id number / total rounds that have happened
151 //****************
152 // PLAYER DATA
153 //****************
154     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
155     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
156     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
157     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
158     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
159 //****************
160 // ROUND DATA
161 //****************
162     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
163     mapping (uint256 => uint256) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
164 
165 
166 //****************
167 // TEAM FEE DATA
168 //****************
169     F3Ddatasets.TeamFee public fees_;          // (team => fees) fee distribution by team
170     F3Ddatasets.PotSplit public potSplit_;     // (team => fees) pot split distribution by team
171 //==============================================================================
172 //     _ _  _  __|_ _    __|_ _  _  .
173 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
174 //==============================================================================
175     constructor()
176         public
177     {
178         // Team allocation structures
179         // 0 = whales
180         // 1 = bears
181         // 2 = sneks
182         // 3 = bulls
183 
184         // Team allocation percentages
185         // (F3D, P3D) + (Pot , Referrals, Community)
186             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
187         fees_ = F3Ddatasets.TeamFee(54,0,20,15,1);   //15% to pot, 10% to aff, 15% to com
188 
189 
190         // how to split up the final pot based on which team was picked
191         // (F3D, P3D)
192         potSplit_ = F3Ddatasets.PotSplit(50,0);  //48% to winner,  2% to com
193 
194     }
195 //==============================================================================
196 //     _ _  _  _|. |`. _  _ _  .
197 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
198 //==============================================================================
199     /**
200      * @dev used to make sure no one can interact with contract until it has
201      * been activated.
202      */
203     modifier isActivated() {
204         require(activated_ == true, "its not ready yet.  check ?eta in discord");
205         _;
206     }
207 
208     /**
209      * @dev prevents contracts from interacting with fomo3d
210      */
211     modifier isHuman() {
212         address _addr = msg.sender;
213         uint256 _codeLength;
214 
215         assembly {_codeLength := extcodesize(_addr)}
216         require(_codeLength == 0, "sorry humans only");
217         _;
218     }
219 
220     /**
221      * @dev sets boundaries for incoming tx
222      */
223     modifier isWithinLimits(uint256 _eth) {
224         require(_eth >= 1000000000, "pocket lint: not a valid currency");
225         require(_eth <= 100000000000000000000000, "no vitalik, no");
226         _;
227     }
228 
229 
230 
231 //==============================================================================
232 //     _    |_ |. _   |`    _  __|_. _  _  _  .
233 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
234 //====|=========================================================================
235     /**
236      * @dev emergency buy uses last stored affiliate ID and team snek
237      */
238     function()
239         isActivated()
240         isHuman()
241         isWithinLimits(msg.value)
242         public
243         payable
244     {
245         // set up our tx event data and determine if player is new or not
246         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
247 
248         // fetch player id
249         uint256 _pID = pIDxAddr_[msg.sender];
250 
251         // buy core
252         buyCore(_pID, plyr_[_pID].laff, _eventData_);
253     }
254 
255     /**
256      * @dev converts all incoming ethereum to keys.
257      * -functionhash- 0x8f38f309 (using ID for affiliate)
258      * -functionhash- 0x98a0871d (using address for affiliate)
259      * -functionhash- 0xa65b37a1 (using name for affiliate)
260      * @param _affCode the ID/address/name of the player who gets the affiliate fee
261      */
262     function buyXid(uint256 _affCode)
263         isActivated()
264         isHuman()
265         isWithinLimits(msg.value)
266         public
267         payable
268     {
269         // set up our tx event data and determine if player is new or not
270         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
271 
272         // fetch player id
273         uint256 _pID = pIDxAddr_[msg.sender];
274 
275         // manage affiliate residuals
276         // if no affiliate code was given or player tried to use their own, lolz
277         if (_affCode == 0 || _affCode == _pID)
278         {
279             // use last stored affiliate code
280             _affCode = plyr_[_pID].laff;
281 
282         // if affiliate code was given & its not the same as previously stored
283         } else if (_affCode != plyr_[_pID].laff) {
284             // update last affiliate
285             plyr_[_pID].laff = _affCode;
286         }
287 
288         // buy core
289         buyCore(_pID, _affCode, _eventData_);
290     }
291 
292     function buyXaddr(address _affCode)
293         isActivated()
294         isHuman()
295         isWithinLimits(msg.value)
296         public
297         payable
298     {
299         // set up our tx event data and determine if player is new or not
300         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
301 
302         // fetch player id
303         uint256 _pID = pIDxAddr_[msg.sender];
304 
305         // manage affiliate residuals
306         uint256 _affID;
307         // if no affiliate code was given or player tried to use their own, lolz
308         if (_affCode == address(0) || _affCode == msg.sender)
309         {
310             // use last stored affiliate code
311             _affID = plyr_[_pID].laff;
312 
313         // if affiliate code was given
314         } else {
315             // get affiliate ID from aff Code
316             _affID = pIDxAddr_[_affCode];
317 
318             // if affID is not the same as previously stored
319             if (_affID != plyr_[_pID].laff)
320             {
321                 // update last affiliate
322                 plyr_[_pID].laff = _affID;
323             }
324         }
325 
326 
327         // buy core
328         buyCore(_pID, _affID, _eventData_);
329     }
330 
331     function buyXname(bytes32 _affCode)
332         isActivated()
333         isHuman()
334         isWithinLimits(msg.value)
335         public
336         payable
337     {
338         // set up our tx event data and determine if player is new or not
339         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
340 
341         // fetch player id
342         uint256 _pID = pIDxAddr_[msg.sender];
343 
344         // manage affiliate residuals
345         uint256 _affID;
346         // if no affiliate code was given or player tried to use their own, lolz
347         if (_affCode == '' || _affCode == plyr_[_pID].name)
348         {
349             // use last stored affiliate code
350             _affID = plyr_[_pID].laff;
351 
352         // if affiliate code was given
353         } else {
354             // get affiliate ID from aff Code
355             _affID = pIDxName_[_affCode];
356 
357             // if affID is not the same as previously stored
358             if (_affID != plyr_[_pID].laff)
359             {
360                 // update last affiliate
361                 plyr_[_pID].laff = _affID;
362             }
363         }
364 
365         // buy core
366         buyCore(_pID, _affID, _eventData_);
367     }
368 
369     /**
370      * @dev essentially the same as buy, but instead of you sending ether
371      * from your wallet, it uses your unwithdrawn earnings.
372      * -functionhash- 0x349cdcac (using ID for affiliate)
373      * -functionhash- 0x82bfc739 (using address for affiliate)
374      * -functionhash- 0x079ce327 (using name for affiliate)
375      * @param _affCode the ID/address/name of the player who gets the affiliate fee
376      * @param _eth amount of earnings to use (remainder returned to gen vault)
377      */
378     function reLoadXid(uint256 _affCode, uint256 _eth)
379         isActivated()
380         isHuman()
381         isWithinLimits(_eth)
382         public
383     {
384         // set up our tx event data
385         F3Ddatasets.EventReturns memory _eventData_;
386 
387         // fetch player ID
388         uint256 _pID = pIDxAddr_[msg.sender];
389 
390         // manage affiliate residuals
391         // if no affiliate code was given or player tried to use their own, lolz
392         if (_affCode == 0 || _affCode == _pID)
393         {
394             // use last stored affiliate code
395             _affCode = plyr_[_pID].laff;
396 
397         // if affiliate code was given & its not the same as previously stored
398         } else if (_affCode != plyr_[_pID].laff) {
399             // update last affiliate
400             plyr_[_pID].laff = _affCode;
401         }
402 
403         // reload core
404         reLoadCore(_pID, _affCode, _eth, _eventData_);
405     }
406 
407     function reLoadXaddr(address _affCode, uint256 _eth)
408         isActivated()
409         isHuman()
410         isWithinLimits(_eth)
411         public
412     {
413         // set up our tx event data
414         F3Ddatasets.EventReturns memory _eventData_;
415 
416         // fetch player ID
417         uint256 _pID = pIDxAddr_[msg.sender];
418 
419         // manage affiliate residuals
420         uint256 _affID;
421         // if no affiliate code was given or player tried to use their own, lolz
422         if (_affCode == address(0) || _affCode == msg.sender)
423         {
424             // use last stored affiliate code
425             _affID = plyr_[_pID].laff;
426 
427         // if affiliate code was given
428         } else {
429             // get affiliate ID from aff Code
430             _affID = pIDxAddr_[_affCode];
431 
432             // if affID is not the same as previously stored
433             if (_affID != plyr_[_pID].laff)
434             {
435                 // update last affiliate
436                 plyr_[_pID].laff = _affID;
437             }
438         }
439 
440         // reload core
441         reLoadCore(_pID, _affID, _eth, _eventData_);
442     }
443 
444     function reLoadXname(bytes32 _affCode, uint256 _eth)
445         isActivated()
446         isHuman()
447         isWithinLimits(_eth)
448         public
449     {
450         // set up our tx event data
451         F3Ddatasets.EventReturns memory _eventData_;
452 
453         // fetch player ID
454         uint256 _pID = pIDxAddr_[msg.sender];
455 
456         // manage affiliate residuals
457         uint256 _affID;
458         // if no affiliate code was given or player tried to use their own, lolz
459         if (_affCode == '' || _affCode == plyr_[_pID].name)
460         {
461             // use last stored affiliate code
462             _affID = plyr_[_pID].laff;
463 
464         // if affiliate code was given
465         } else {
466             // get affiliate ID from aff Code
467             _affID = pIDxName_[_affCode];
468 
469             // if affID is not the same as previously stored
470             if (_affID != plyr_[_pID].laff)
471             {
472                 // update last affiliate
473                 plyr_[_pID].laff = _affID;
474             }
475         }
476 
477         // reload core
478         reLoadCore(_pID, _affID, _eth, _eventData_);
479     }
480 
481     /**
482      * @dev withdraws all of your earnings.
483      * -functionhash- 0x3ccfd60b
484      */
485     function withdraw()
486         isActivated()
487         isHuman()
488         public
489     {
490         // setup local rID
491         uint256 _rID = rID_;
492 
493         // grab time
494         uint256 _now = now;
495 
496         // fetch player ID
497         uint256 _pID = pIDxAddr_[msg.sender];
498 
499         // setup temp var for player eth
500         uint256 _eth;
501 
502         // check to see if round has ended and no one has run round end yet
503         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
504         {
505             // set up our tx event data
506             F3Ddatasets.EventReturns memory _eventData_;
507 
508             // end the round (distributes pot)
509             round_[_rID].ended = true;
510             _eventData_ = endRound(_eventData_);
511 
512             // get their earnings
513             _eth = withdrawEarnings(_pID);
514 
515             // gib moni
516             if (_eth > 0)
517                 plyr_[_pID].addr.transfer(_eth);
518 
519             // build event data
520             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
521             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
522 
523             // fire withdraw and distribute event
524             emit F3Devents.onWithdrawAndDistribute
525             (
526                 msg.sender,
527                 plyr_[_pID].name,
528                 _eth,
529                 _eventData_.compressedData,
530                 _eventData_.compressedIDs,
531                 _eventData_.winnerAddr,
532                 _eventData_.winnerName,
533                 _eventData_.amountWon,
534                 _eventData_.newPot,
535                 _eventData_.P3DAmount,
536                 _eventData_.genAmount
537             );
538 
539         // in any other situation
540         } else {
541             // get their earnings
542             _eth = withdrawEarnings(_pID);
543 
544             // gib moni
545             if (_eth > 0)
546                 plyr_[_pID].addr.transfer(_eth);
547 
548             // fire withdraw event
549             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
550         }
551     }
552 
553     /**
554      * @dev use these to register names.  they are just wrappers that will send the
555      * registration requests to the PlayerBook contract.  So registering here is the
556      * same as registering there.  UI will always display the last name you registered.
557      * but you will still own all previously registered names to use as affiliate
558      * links.
559      * - must pay a registration fee.
560      * - name must be unique
561      * - names will be converted to lowercase
562      * - name cannot start or end with a space
563      * - cannot have more than 1 space in a row
564      * - cannot be only numbers
565      * - cannot start with 0x
566      * - name must be at least 1 char
567      * - max length of 32 characters long
568      * - allowed characters: a-z, 0-9, and space
569      * -functionhash- 0x921dec21 (using ID for affiliate)
570      * -functionhash- 0x3ddd4698 (using address for affiliate)
571      * -functionhash- 0x685ffd83 (using name for affiliate)
572      * @param _nameString players desired name
573      * @param _affCode affiliate ID, address, or name of who referred you
574      * @param _all set to true if you want this to push your info to all games
575      * (this might cost a lot of gas)
576      */
577     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
578         isHuman()
579         public
580         payable
581     {
582         bytes32 _name = _nameString.nameFilter();
583         address _addr = msg.sender;
584         uint256 _paid = msg.value;
585         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
586 
587         uint256 _pID = pIDxAddr_[_addr];
588 
589         // fire event
590         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
591     }
592 
593     function registerNameXaddr(string _nameString, address _affCode, bool _all)
594         isHuman()
595         public
596         payable
597     {
598         bytes32 _name = _nameString.nameFilter();
599         address _addr = msg.sender;
600         uint256 _paid = msg.value;
601         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
602 
603         uint256 _pID = pIDxAddr_[_addr];
604 
605         // fire event
606         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
607     }
608 
609     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
610         isHuman()
611         public
612         payable
613     {
614         bytes32 _name = _nameString.nameFilter();
615         address _addr = msg.sender;
616         uint256 _paid = msg.value;
617         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
618 
619         uint256 _pID = pIDxAddr_[_addr];
620 
621         // fire event
622         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
623     }
624 //==============================================================================
625 //     _  _ _|__|_ _  _ _  .
626 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
627 //=====_|=======================================================================
628     /**
629      * @dev return the price buyer will pay for next 1 individual key.
630      * -functionhash- 0x018a25e8
631      * @return price for next key bought (in wei format)
632      */
633     function getBuyPrice()
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
644         // are we in a round?
645         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
646             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
647         else // rounds over.  need price for new round
648             return ( 75000000000000 ); // init
649     }
650 
651     /**
652      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
653      * provider
654      * -functionhash- 0xc7e284b8
655      * @return time left in seconds
656      */
657     function getTimeLeft()
658         public
659         view
660         returns(uint256)
661     {
662         // setup local rID
663         uint256 _rID = rID_;
664 
665         // grab time
666         uint256 _now = now;
667 
668         if (_now < round_[_rID].end)
669             if (_now > round_[_rID].strt + rndGap_)
670                 return( (round_[_rID].end).sub(_now) );
671             else
672                 return( (round_[_rID].strt + rndGap_).sub(_now) );
673         else
674             return(0);
675     }
676 
677     /**
678      * @dev returns player earnings per vaults
679      * -functionhash- 0x63066434
680      * @return winnings vault
681      * @return general vault
682      * @return affiliate vault
683      */
684     function getPlayerVaults(uint256 _pID)
685         public
686         view
687         returns(uint256 ,uint256, uint256)
688     {
689         // setup local rID
690         uint256 _rID = rID_;
691 
692         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
693         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
694         {
695             // if player is winner
696             if (round_[_rID].plyr == _pID)
697             {
698                 return
699                 (
700                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
701                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
702                     plyr_[_pID].aff
703                 );
704             // if player is not the winner
705             } else {
706                 return
707                 (
708                     plyr_[_pID].win,
709                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
710                     plyr_[_pID].aff
711                 );
712             }
713 
714         // if round is still going on, or round has ended and round end has been ran
715         } else {
716             return
717             (
718                 plyr_[_pID].win,
719                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
720                 plyr_[_pID].aff
721             );
722         }
723     }
724 
725     /**
726      * solidity hates stack limits.  this lets us avoid that hate
727      */
728     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
729         private
730         view
731         returns(uint256)
732     {
733         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_.gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
734     }
735 
736     /**
737      * @dev returns all current round info needed for front end
738      * -functionhash- 0x747dff42
739      * @return eth invested during ICO phase
740      * @return round id
741      * @return total keys for round
742      * @return time round ends
743      * @return time round started
744      * @return current pot
745      * @return current team ID & player ID in lead
746      * @return current player in leads address
747      * @return current player in leads name
748      * @return whales eth in for round
749      * @return bears eth in for round
750      * @return sneks eth in for round
751      * @return bulls eth in for round
752      * @return airdrop tracker # & airdrop pot
753      */
754     function getCurrentRoundInfo()
755         public
756         view
757         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
758     {
759         // setup local rID
760         uint256 _rID = rID_;
761 
762         return
763         (
764             round_[_rID].ico,               //0
765             _rID,                           //1
766             round_[_rID].keys,              //2
767             round_[_rID].end,               //3
768             round_[_rID].strt,              //4
769             round_[_rID].pot,               //5
770             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
771             plyr_[round_[_rID].plyr].addr,  //7
772             plyr_[round_[_rID].plyr].name,  //8
773             rndTmEth_[_rID],             //9
774             0,             //10
775             0,             //11
776             0,             //12
777             airDropTracker_ + (airDropPot_ * 1000)              //13
778         );
779     }
780 
781     /**
782      * @dev returns player info based on address.  if no address is given, it will
783      * use msg.sender
784      * -functionhash- 0xee0b5d8b
785      * @param _addr address of the player you want to lookup
786      * @return player ID
787      * @return player name
788      * @return keys owned (current round)
789      * @return winnings vault
790      * @return general vault
791      * @return affiliate vault
792      * @return player round eth
793      */
794     function getPlayerInfoByAddress(address _addr)
795         public
796         view
797         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
798     {
799         // setup local rID
800         uint256 _rID = rID_;
801 
802         if (_addr == address(0))
803         {
804             _addr == msg.sender;
805         }
806         uint256 _pID = pIDxAddr_[_addr];
807 
808         return
809         (
810             _pID,                               //0
811             plyr_[_pID].name,                   //1
812             plyrRnds_[_pID][_rID].keys,         //2
813             plyr_[_pID].win,                    //3
814             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
815             plyr_[_pID].aff,                    //5
816             plyrRnds_[_pID][_rID].eth           //6
817         );
818     }
819 
820 //==============================================================================
821 //     _ _  _ _   | _  _ . _  .
822 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
823 //=====================_|=======================================================
824     /**
825      * @dev logic runs whenever a buy order is executed.  determines how to handle
826      * incoming eth depending on if we are in an active round or not
827      */
828     function buyCore(uint256 _pID, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
829         private
830     {
831         // setup local rID
832         uint256 _rID = rID_;
833 
834         // grab time
835         uint256 _now = now;
836 
837 
838 
839         // if round is active
840         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
841         {
842             // call core
843             core(_rID, _pID, msg.value, _affID, _eventData_);
844 
845         // if round is not active
846         } else {
847             // check to see if end round needs to be ran
848             if (_now > round_[_rID].end && round_[_rID].ended == false)
849             {
850                 // end the round (distributes pot) & start new round
851                 round_[_rID].ended = true;
852                 _eventData_ = endRound(_eventData_);
853 
854                 // build event data
855                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
856                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
857 
858                 // fire buy and distribute event
859                 emit F3Devents.onBuyAndDistribute
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
884     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
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
902             core(_rID, _pID, _eth, _affID, _eventData_);
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
915             emit F3Devents.onReLoadAndDistribute
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
935     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
936         private
937     {
938         // if player is new to round
939         if (plyrRnds_[_pID][_rID].keys == 0)
940             _eventData_ = managePlayer(_pID, _eventData_);
941 
942         // early round eth limiter
943         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
944         {
945             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
946             uint256 _refund = _eth.sub(_availableLimit);
947             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
948             _eth = _availableLimit;
949         }
950 
951         // if eth left is greater than min eth allowed (sorry no pocket lint)
952         if (_eth > 1000000000)
953         {
954 
955             // mint the new keys
956             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
957 
958             // if they bought at least 1 whole key
959             if (_keys >= 1000000000000000000)
960             {
961             updateTimer(_keys, _rID);
962 
963             // set new leaders
964             if (round_[_rID].plyr != _pID)
965                 round_[_rID].plyr = _pID;
966 
967 
968             // set the new leader bool to true
969             _eventData_.compressedData = _eventData_.compressedData + 100;
970         }
971 
972             // manage airdrops
973             if (_eth >= 100000000000000000)
974             {
975             airDropTracker_++;
976             if (airdrop() == true && airDropPot_ > 250000000000000000)
977             {
978                 // gib muni
979                 uint256 _prize  = 250000000000000000;
980                 if (_eth >= 10000000000000000000)
981                 {
982                     // calculate prize and give it to winner
983 
984                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
985 
986                     // adjust airDropPot
987                     airDropPot_ = (airDropPot_).sub(_prize);
988 
989                     // let event know a tier 3 prize was won
990                     _eventData_.compressedData += 300000000000000000000000000000000;
991                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
992                     // calculate prize and give it to winner
993                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
994 
995                     // adjust airDropPot
996                     airDropPot_ = (airDropPot_).sub(_prize);
997 
998                     // let event know a tier 2 prize was won
999                     _eventData_.compressedData += 200000000000000000000000000000000;
1000                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1001                     // calculate prize and give it to winner
1002                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1003 
1004                     // adjust airDropPot
1005                     airDropPot_ = (airDropPot_).sub(_prize);
1006 
1007                     // let event know a tier 3 prize was won
1008                     _eventData_.compressedData += 300000000000000000000000000000000;
1009                 }
1010                 // set airdrop happened bool to true
1011                 _eventData_.compressedData += 10000000000000000000000000000000;
1012                 // let event know how much was won
1013                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1014 
1015                 // reset air drop tracker
1016                 airDropTracker_ = 0;
1017             }
1018         }
1019 
1020             // store the air drop tracker number (number of buys since last airdrop)
1021             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1022 
1023             // update player
1024             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1025             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1026 
1027             // update round
1028             round_[_rID].keys = _keys.add(round_[_rID].keys);
1029             round_[_rID].eth = _eth.add(round_[_rID].eth);
1030             rndTmEth_[_rID] = _eth.add(rndTmEth_[_rID]);
1031 
1032             // distribute eth
1033             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _eventData_);
1034             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
1035 
1036             // call end tx function to fire end tx event.
1037             endTx(_pID, _eth, _keys, _eventData_);
1038         }
1039     }
1040 //==============================================================================
1041 //     _ _ | _   | _ _|_ _  _ _  .
1042 //    (_(_||(_|_||(_| | (_)| _\  .
1043 //==============================================================================
1044     /**
1045      * @dev calculates unmasked earnings (just calculates, does not update mask)
1046      * @return earnings in wei format
1047      */
1048     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1049         private
1050         view
1051         returns(uint256)
1052     {
1053         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1054     }
1055 
1056     /**
1057      * @dev returns the amount of keys you would get given an amount of eth.
1058      * -functionhash- 0xce89c80c
1059      * @param _rID round ID you want price for
1060      * @param _eth amount of eth sent in
1061      * @return keys received
1062      */
1063     function calcKeysReceived(uint256 _rID, uint256 _eth)
1064         public
1065         view
1066         returns(uint256)
1067     {
1068         // grab time
1069         uint256 _now = now;
1070 
1071         // are we in a round?
1072         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1073             return ( (round_[_rID].eth).keysRec(_eth) );
1074         else // rounds over.  need keys for new round
1075             return ( (_eth).keys() );
1076     }
1077 
1078     /**
1079      * @dev returns current eth price for X keys.
1080      * -functionhash- 0xcf808000
1081      * @param _keys number of keys desired (in 18 decimal format)
1082      * @return amount of eth needed to send
1083      */
1084     function iWantXKeys(uint256 _keys)
1085         public
1086         view
1087         returns(uint256)
1088     {
1089         // setup local rID
1090         uint256 _rID = rID_;
1091 
1092         // grab time
1093         uint256 _now = now;
1094 
1095         // are we in a round?
1096         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1097             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1098         else // rounds over.  need price for new round
1099             return ( (_keys).eth() );
1100     }
1101 //==============================================================================
1102 //    _|_ _  _ | _  .
1103 //     | (_)(_)|_\  .
1104 //==============================================================================
1105     /**
1106      * @dev receives name/player info from names contract
1107      */
1108     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1109         external
1110     {
1111         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1112         if (pIDxAddr_[_addr] != _pID)
1113             pIDxAddr_[_addr] = _pID;
1114         if (pIDxName_[_name] != _pID)
1115             pIDxName_[_name] = _pID;
1116         if (plyr_[_pID].addr != _addr)
1117             plyr_[_pID].addr = _addr;
1118         if (plyr_[_pID].name != _name)
1119             plyr_[_pID].name = _name;
1120         if (plyr_[_pID].laff != _laff)
1121             plyr_[_pID].laff = _laff;
1122         if (plyrNames_[_pID][_name] == false)
1123             plyrNames_[_pID][_name] = true;
1124     }
1125 
1126     /**
1127      * @dev receives entire player name list
1128      */
1129     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1130         external
1131     {
1132         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1133         if(plyrNames_[_pID][_name] == false)
1134             plyrNames_[_pID][_name] = true;
1135     }
1136 
1137     /**
1138      * @dev gets existing or registers new pID.  use this when a player may be new
1139      * @return pID
1140      */
1141     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1142         private
1143         returns (F3Ddatasets.EventReturns)
1144     {
1145         uint256 _pID = pIDxAddr_[msg.sender];
1146         // if player is new to this version of fomo3d
1147         if (_pID == 0)
1148         {
1149             // grab their player ID, name and last aff ID, from player names contract
1150             _pID = PlayerBook.getPlayerID(msg.sender);
1151             bytes32 _name = PlayerBook.getPlayerName(_pID);
1152             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1153 
1154             // set up player account
1155             pIDxAddr_[msg.sender] = _pID;
1156             plyr_[_pID].addr = msg.sender;
1157 
1158             if (_name != "")
1159             {
1160                 pIDxName_[_name] = _pID;
1161                 plyr_[_pID].name = _name;
1162                 plyrNames_[_pID][_name] = true;
1163             }
1164 
1165             if (_laff != 0 && _laff != _pID)
1166                 plyr_[_pID].laff = _laff;
1167 
1168             // set the new player bool to true
1169             _eventData_.compressedData = _eventData_.compressedData + 1;
1170         }
1171         return (_eventData_);
1172     }
1173 
1174 
1175 
1176     /**
1177      * @dev decides if round end needs to be run & new round started.  and if
1178      * player unmasked earnings from previously played rounds need to be moved.
1179      */
1180     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1181         private
1182         returns (F3Ddatasets.EventReturns)
1183     {
1184         // if player has played a previous round, move their unmasked earnings
1185         // from that round to gen vault.
1186         if (plyr_[_pID].lrnd != 0)
1187             updateGenVault(_pID, plyr_[_pID].lrnd);
1188 
1189         // update player's last round played
1190         plyr_[_pID].lrnd = rID_;
1191 
1192         // set the joined round bool to true
1193         _eventData_.compressedData = _eventData_.compressedData + 10;
1194 
1195         return(_eventData_);
1196     }
1197 
1198     /**
1199      * @dev ends the round. manages paying out winner/splitting up pot
1200      */
1201     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1202         private
1203         returns (F3Ddatasets.EventReturns)
1204     {
1205         // setup local rID
1206         uint256 _rID = rID_;
1207 
1208         // grab our winning player and team id's
1209         uint256 _winPID = round_[_rID].plyr;
1210         uint256 _winTID = round_[_rID].team;
1211 
1212         // grab our pot amount
1213         uint256 _pot = round_[_rID].pot;
1214 
1215         // calculate our winner share, community rewards, gen share,
1216         // p3d share, and amount reserved for next pot
1217         uint256 _win = (_pot.mul(48)) / 100;
1218         uint256 _com = (_pot / 50);
1219         uint256 _gen = (_pot.mul(potSplit_.gen)) / 100;
1220         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1221 
1222         // calculate ppt for round mask
1223         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1224         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1225         if (_dust > 0)
1226         {
1227             _gen = _gen.sub(_dust);
1228             _res = _res.add(_dust);
1229         }
1230 
1231         // pay our winner
1232         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1233 
1234         // community rewards
1235         com.transfer(_com);
1236 
1237         // distribute gen portion to key holders
1238         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1239 
1240         // prepare event data
1241         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1242         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1243         _eventData_.winnerAddr = plyr_[_winPID].addr;
1244         _eventData_.winnerName = plyr_[_winPID].name;
1245         _eventData_.amountWon = _win;
1246         _eventData_.genAmount = _gen;
1247         _eventData_.P3DAmount = 0;
1248         _eventData_.newPot = _res;
1249 
1250         // start next round
1251         rID_++;
1252         _rID++;
1253         round_[_rID].strt = now;
1254         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1255         round_[_rID].pot = _res;
1256 
1257         return(_eventData_);
1258     }
1259 
1260     /**
1261      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1262      */
1263     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1264         private
1265     {
1266         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1267         if (_earnings > 0)
1268         {
1269             // put in gen vault
1270             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1271             // zero out their earnings by updating mask
1272             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1273         }
1274     }
1275 
1276     /**
1277      * @dev updates round timer based on number of whole keys bought.
1278      */
1279     function updateTimer(uint256 _keys, uint256 _rID)
1280         private
1281     {
1282         // grab time
1283         uint256 _now = now;
1284 
1285         // calculate time based on number of keys bought
1286         uint256 _newTime;
1287         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1288             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1289         else
1290             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1291 
1292         // compare to max and set new end time
1293         if (_newTime < (rndMax_).add(_now))
1294             round_[_rID].end = _newTime;
1295         else
1296             round_[_rID].end = rndMax_.add(_now);
1297     }
1298 
1299     /**
1300      * @dev generates a random number between 0-99 and checks to see if thats
1301      * resulted in an airdrop win
1302      * @return do we have a winner?
1303      */
1304     function airdrop()
1305         private
1306         view
1307         returns(bool)
1308     {
1309         uint256 seed = uint256(keccak256(abi.encodePacked(
1310 
1311             (block.timestamp).add
1312             (block.difficulty).add
1313             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1314             (block.gaslimit).add
1315             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1316             (block.number)
1317 
1318         )));
1319         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1320             return(true);
1321         else
1322             return(false);
1323     }
1324 
1325     /**
1326      * @dev distributes eth based on fees to com, aff, and p3d
1327      */
1328     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1329         private
1330         returns(F3Ddatasets.EventReturns)
1331     {
1332         // pay 15% out to community rewards
1333         uint256 _com = _eth.mul(fees_.com)/100;
1334 
1335 
1336 
1337          // distribute share to affiliate 10%
1338         uint256 _aff = (_eth / 10);
1339 
1340         // decide what to do with affiliate share of fees
1341         // affiliate must not be self, and must have a name registered
1342         if (_affID != _pID && plyr_[_affID].name != '') {
1343             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1344             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1345         } else {
1346             _com.add(_aff);
1347         }
1348 
1349         com.transfer(_com);
1350         return(_eventData_);
1351     }
1352 
1353     function potSwap()
1354         external
1355         payable
1356     {
1357         // setup local rID
1358         uint256 _rID = rID_ + 1;
1359 
1360         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1361         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1362     }
1363 
1364     /**
1365      * @dev distributes eth based on fees to gen and pot
1366      */
1367     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1368         private
1369         returns(F3Ddatasets.EventReturns)
1370     {
1371         // calculate gen share
1372         uint256 _gen = (_eth.mul(fees_.gen)) / 100;
1373 
1374         // toss 1% into airdrop pot
1375         uint256 _air = (_eth / 100);
1376         airDropPot_ = airDropPot_.add(_air);
1377 
1378         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1379         //_eth = _eth.sub(((_eth.mul(26)) / 100));
1380 
1381         // calculate pot
1382         uint256 _pot = (_eth.mul(fees_.pot)) / 100;
1383 
1384         // distribute gen share (thats what updateMasks() does) and adjust
1385         // balances for dust.
1386         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1387         if (_dust > 0)
1388             _gen = _gen.sub(_dust);
1389 
1390         // add eth to pot
1391         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1392 
1393         // set up event data
1394         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1395         _eventData_.potAmount = _pot;
1396 
1397         return(_eventData_);
1398     }
1399 
1400     /**
1401      * @dev updates masks for round and player when keys are bought
1402      * @return dust left over
1403      */
1404     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1405         private
1406         returns(uint256)
1407     {
1408         /* MASKING NOTES
1409             earnings masks are a tricky thing for people to wrap their minds around.
1410             the basic thing to understand here.  is were going to have a global
1411             tracker based on profit per share for each round, that increases in
1412             relevant proportion to the increase in share supply.
1413 
1414             the player will have an additional mask that basically says "based
1415             on the rounds mask, my shares, and how much i've already withdrawn,
1416             how much is still owed to me?"
1417         */
1418 
1419         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1420         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1421         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1422 
1423         // calculate player earning from their own buy (only based on the keys
1424         // they just bought).  & update player earnings mask
1425         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1426         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1427 
1428         // calculate & return dust
1429         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1430     }
1431 
1432     /**
1433      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1434      * @return earnings in wei format
1435      */
1436     function withdrawEarnings(uint256 _pID)
1437         private
1438         returns(uint256)
1439     {
1440         // update gen vault
1441         updateGenVault(_pID, plyr_[_pID].lrnd);
1442 
1443         // from vaults
1444         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1445         if (_earnings > 0)
1446         {
1447             plyr_[_pID].win = 0;
1448             plyr_[_pID].gen = 0;
1449             plyr_[_pID].aff = 0;
1450         }
1451 
1452         return(_earnings);
1453     }
1454 
1455     /**
1456      * @dev prepares compression data and fires event for buy or reload tx's
1457      */
1458     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1459         private
1460     {
1461         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (100000000000000000000000000000);
1462         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1463 
1464         emit F3Devents.onEndTx
1465         (
1466             _eventData_.compressedData,
1467             _eventData_.compressedIDs,
1468             plyr_[_pID].name,
1469             msg.sender,
1470             _eth,
1471             _keys,
1472             _eventData_.winnerAddr,
1473             _eventData_.winnerName,
1474             _eventData_.amountWon,
1475             _eventData_.newPot,
1476             _eventData_.P3DAmount,
1477             _eventData_.genAmount,
1478             _eventData_.potAmount,
1479             airDropPot_
1480         );
1481     }
1482 //==============================================================================
1483 //    (~ _  _    _._|_    .
1484 //    _)(/_(_|_|| | | \/  .
1485 //====================/=========================================================
1486     /** upon contract deploy, it will be deactivated.  this is a one time
1487      * use function that will activate the contract.  we do this so devs
1488      * have time to set things up on the web end                            **/
1489     bool public activated_ = false;
1490     function activate()
1491         public
1492     {
1493 
1494         require(msg.sender == admin, "only admin can activate");
1495 
1496         // can only be ran once
1497         require(activated_ == false, "fomo3d already activated");
1498 
1499         // activate the contract
1500         activated_ = true;
1501 
1502         // lets start first round
1503         rID_ = 1;
1504         round_[1].strt = now + rndExtra_ - rndGap_;
1505         round_[1].end = now + rndInit_ + rndExtra_;
1506     }
1507 
1508     //==============================================================================
1509 //     _ _ | _   | _ _|_ _  _ _  .
1510 //    (_(_||(_|_||(_| | (_)| _\  .
1511 //==============================================================================
1512 
1513 }
1514 
1515 library F3Ddatasets {
1516     //compressedData key
1517     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1518         // 0 - new player (bool)
1519         // 1 - joined round (bool)
1520         // 2 - new  leader (bool)
1521         // 3-5 - air drop tracker (uint 0-999)
1522         // 6-16 - round end time
1523         // 17 - winnerTeam
1524         // 18 - 28 timestamp
1525         // 29 - team
1526         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1527         // 31 - airdrop happened bool
1528         // 32 - airdrop tier
1529         // 33 - airdrop amount won
1530     //compressedIDs key
1531     // [77-52][51-26][25-0]
1532         // 0-25 - pID
1533         // 26-51 - winPID
1534         // 52-77 - rID
1535     struct EventReturns {
1536         uint256 compressedData;
1537         uint256 compressedIDs;
1538         address winnerAddr;         // winner address
1539         bytes32 winnerName;         // winner name
1540         uint256 amountWon;          // amount won
1541         uint256 newPot;             // amount in new pot
1542         uint256 P3DAmount;          // amount distributed to p3d
1543         uint256 genAmount;          // amount distributed to gen
1544         uint256 potAmount;          // amount added to pot
1545     }
1546     struct Player {
1547         address addr;   // player address
1548         bytes32 name;   // player name
1549         uint256 win;    // winnings vault
1550         uint256 gen;    // general vault
1551         uint256 aff;    // affiliate vault
1552         uint256 lrnd;   // last round played
1553         uint256 laff;   // last affiliate id used
1554     }
1555     struct PlayerRounds {
1556         uint256 eth;    // eth player has added to round (used for eth limiter)
1557         uint256 keys;   // keys
1558         uint256 mask;   // player mask
1559         uint256 ico;    // ICO phase investment
1560     }
1561     struct Round {
1562         uint256 plyr;   // pID of player in lead
1563         uint256 team;   // tID of team in lead
1564         uint256 end;    // time ends/ended
1565         bool ended;     // has round end function been ran
1566         uint256 strt;   // time round started
1567         uint256 keys;   // keys
1568         uint256 eth;    // total eth in
1569         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1570         uint256 mask;   // global mask
1571         uint256 ico;    // total eth sent in during ICO phase
1572         uint256 icoGen; // total eth for gen during ICO phase
1573         uint256 icoAvg; // average key price for ICO phase
1574     }
1575     struct TeamFee {
1576         uint256 gen;    // % of buy in thats paid to key holders of current round
1577         uint256 p3d;    // % of buy in thats paid to p3d holders
1578         uint256 pot;    // % of buy in thats paid to pot
1579         uint256 com;    // % of buy in thats paid to com
1580         uint256 air;    // % of buy in thats paid to air
1581     }
1582     struct PotSplit {
1583         uint256 gen;    // % of pot thats paid to key holders of current round
1584         uint256 p3d;    // % of pot thats paid to p3d holders
1585     }
1586 
1587 }
1588 
1589 /**
1590  * @title SafeMath v0.1.9
1591  * @dev Math operations with safety checks that throw on error
1592  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1593  * - added sqrt
1594  * - added sq
1595  * - added pwr
1596  * - changed asserts to requires with error log outputs
1597  * - removed div, its useless
1598  */
1599 library SafeMath {
1600 
1601     /**
1602     * @dev Multiplies two numbers, throws on overflow.
1603     */
1604     function mul(uint256 a, uint256 b)
1605         internal
1606         pure
1607         returns (uint256 c)
1608     {
1609         if (a == 0) {
1610             return 0;
1611         }
1612         c = a * b;
1613         require(c / a == b, "SafeMath mul failed");
1614         return c;
1615     }
1616 
1617     /**
1618     * @dev Integer division of two numbers, truncating the quotient.
1619     */
1620     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1621         // assert(b > 0); // Solidity automatically throws when dividing by 0
1622         uint256 c = a / b;
1623         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1624         return c;
1625     }
1626 
1627     /**
1628     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1629     */
1630     function sub(uint256 a, uint256 b)
1631         internal
1632         pure
1633         returns (uint256)
1634     {
1635         require(b <= a, "SafeMath sub failed");
1636         return a - b;
1637     }
1638 
1639     /**
1640     * @dev Adds two numbers, throws on overflow.
1641     */
1642     function add(uint256 a, uint256 b)
1643         internal
1644         pure
1645         returns (uint256 c)
1646     {
1647         c = a + b;
1648         require(c >= a, "SafeMath add failed");
1649         return c;
1650     }
1651 
1652     /**
1653      * @dev gives square root of given x.
1654      */
1655     function sqrt(uint256 x)
1656         internal
1657         pure
1658         returns (uint256 y)
1659     {
1660         uint256 z = ((add(x,1)) / 2);
1661         y = x;
1662         while (z < y)
1663         {
1664             y = z;
1665             z = ((add((x / z),z)) / 2);
1666         }
1667     }
1668 
1669     /**
1670      * @dev gives square. multiplies x by x
1671      */
1672     function sq(uint256 x)
1673         internal
1674         pure
1675         returns (uint256)
1676     {
1677         return (mul(x,x));
1678     }
1679 
1680     /**
1681      * @dev x to the power of y
1682      */
1683     function pwr(uint256 x, uint256 y)
1684         internal
1685         pure
1686         returns (uint256)
1687     {
1688         if (x==0)
1689             return (0);
1690         else if (y==0)
1691             return (1);
1692         else
1693         {
1694             uint256 z = x;
1695             for (uint256 i=1; i < y; i++)
1696                 z = mul(z,x);
1697             return (z);
1698         }
1699     }
1700 }
1701 
1702 library F3DKeysCalcLong {
1703     using SafeMath for *;
1704     /**
1705      * @dev calculates number of keys received given X eth
1706      * @param _curEth current amount of eth in contract
1707      * @param _newEth eth being spent
1708      * @return amount of ticket purchased
1709      */
1710     function keysRec(uint256 _curEth, uint256 _newEth)
1711         internal
1712         pure
1713         returns (uint256)
1714     {
1715         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1716     }
1717 
1718     /**
1719      * @dev calculates amount of eth received if you sold X keys
1720      * @param _curKeys current amount of keys that exist
1721      * @param _sellKeys amount of keys you wish to sell
1722      * @return amount of eth received
1723      */
1724     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1725         internal
1726         pure
1727         returns (uint256)
1728     {
1729         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1730     }
1731 
1732     /**
1733      * @dev calculates how many keys would exist with given an amount of eth
1734      * @param _eth eth "in contract"
1735      * @return number of keys that would exist
1736      */
1737     function keys(uint256 _eth)
1738         internal
1739         pure
1740         returns(uint256)
1741     {
1742         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1743     }
1744 
1745     /**
1746      * @dev calculates how much eth would be in contract given a number of keys
1747      * @param _keys number of keys "in contract"
1748      * @return eth that would exists
1749      */
1750     function eth(uint256 _keys)
1751         internal
1752         pure
1753         returns(uint256)
1754     {
1755         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1756     }
1757 }
1758 
1759 
1760 library NameFilter {
1761     /**
1762      * @dev filters name strings
1763      * -converts uppercase to lower case.
1764      * -makes sure it does not start/end with a space
1765      * -makes sure it does not contain multiple spaces in a row
1766      * -cannot be only numbers
1767      * -cannot start with 0x
1768      * -restricts characters to A-Z, a-z, 0-9, and space.
1769      * @return reprocessed string in bytes32 format
1770      */
1771     function nameFilter(string _input)
1772         internal
1773         pure
1774         returns(bytes32)
1775     {
1776         bytes memory _temp = bytes(_input);
1777         uint256 _length = _temp.length;
1778 
1779         //sorry limited to 32 characters
1780         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1781         // make sure it doesnt start with or end with space
1782         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1783         // make sure first two characters are not 0x
1784         if (_temp[0] == 0x30)
1785         {
1786             require(_temp[1] != 0x78, "string cannot start with 0x");
1787             require(_temp[1] != 0x58, "string cannot start with 0X");
1788         }
1789 
1790         // create a bool to track if we have a non number character
1791         bool _hasNonNumber;
1792 
1793         // convert & check
1794         for (uint256 i = 0; i < _length; i++)
1795         {
1796             // if its uppercase A-Z
1797             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1798             {
1799                 // convert to lower case a-z
1800                 _temp[i] = byte(uint(_temp[i]) + 32);
1801 
1802                 // we have a non number
1803                 if (_hasNonNumber == false)
1804                     _hasNonNumber = true;
1805             } else {
1806                 require
1807                 (
1808                     // require character is a space
1809                     _temp[i] == 0x20 ||
1810                     // OR lowercase a-z
1811                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1812                     // or 0-9
1813                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1814                     "string contains invalid characters"
1815                 );
1816                 // make sure theres not 2x spaces in a row
1817                 if (_temp[i] == 0x20)
1818                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1819 
1820                 // see if we have a character other than a number
1821                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1822                     _hasNonNumber = true;
1823             }
1824         }
1825 
1826         require(_hasNonNumber == true, "string cannot be only numbers");
1827 
1828         bytes32 _ret;
1829         assembly {
1830             _ret := mload(add(_temp, 32))
1831         }
1832         return (_ret);
1833     }
1834 }
1835 
1836 interface PlayerBookInterface {
1837     function getPlayerID(address _addr) external returns (uint256);
1838     function getPlayerName(uint256 _pID) external view returns (bytes32);
1839     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1840     function getPlayerAddr(uint256 _pID) external view returns (address);
1841     function getNameFee() external view returns (uint256);
1842     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1843     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1844     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1845 }