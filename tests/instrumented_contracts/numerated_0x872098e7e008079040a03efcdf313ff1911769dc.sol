1 pragma solidity ^0.4.24;
2 
3 contract LDEvents {
4 
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
75         uint256 genAmount
76     );
77     
78     // fired whenever a player tries a reload after round timer 
79     // hit zero, and causes end round to be ran.
80     event onReLoadAndDistribute
81     (
82         address playerAddress,
83         bytes32 playerName,
84         uint256 compressedData,
85         uint256 compressedIDs,
86         address winnerAddr,
87         bytes32 winnerName,
88         uint256 amountWon,
89         uint256 newPot,
90         uint256 genAmount
91     );
92     
93     // fired whenever an affiliate is paid
94     event onAffiliatePayout
95     (
96         uint256 indexed affiliateID,
97         address affiliateAddress,
98         bytes32 affiliateName,
99         uint256 indexed buyerID,
100         uint256 amount,
101         uint256 timeStamp
102     );
103 }
104 
105 contract modularDogScam is LDEvents {}
106 
107 contract DogScam is modularDogScam {
108     using SafeMath for *;
109     using NameFilter for string;
110     using LDKeysCalc for uint256;
111     
112     // TODO: check address
113     DogInterfaceForForwarder constant private DogKingCorp = DogInterfaceForForwarder(0xf6c49851adfacdb738c3066842267efc9ed16080);
114     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xEEbfe3EE72Fbb9aAB6e8149Fa56680E2EBcea3C8);
115 
116     string constant public name = "DogScam Round #1";
117     string constant public symbol = "LDOG";
118     uint256 private rndGap_ = 0;
119     bool public activated_ = false;
120 
121     // TODO: check time
122     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
123     uint256 constant private rndInc_ = 24 hours;              // every full key purchased adds this much to the timer
124     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
125 //==============================================================================
126 //     _| _ _|_ _    _ _ _|_    _   .
127 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
128 //=============================|================================================
129     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
130     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
131 //****************
132 // PLAYER DATA 
133 //****************
134     mapping (address => uint256) public withdrawAddr_; 
135     mapping (address => uint256) public shareAddr_; 
136     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
137     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
138     mapping (uint256 => LDdatasets.Player) public plyr_;   // (pID => data) player data
139     mapping (uint256 => mapping (uint256 => LDdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
140     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
141 //****************
142 // ROUND DATA 
143 //****************
144     LDdatasets.Round public round_;   // round data
145 //****************
146 // TEAM FEE DATA 
147 //****************
148     uint256 public fees_ = 0;          // fee distribution
149     uint256 public potSplit_ = 0;      // pot split distribution
150 //==============================================================================
151 //     _ _  _  _|. |`. _  _ _  .
152 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
153 //==============================================================================
154     /**
155      * @dev used to make sure no one can interact with contract until it has 
156      * been activated. 
157      */
158     modifier isActivated() {
159         require(activated_ == true, "its not ready yet"); 
160         _;
161     }
162     
163     /**
164      * @dev prevents contracts from interacting with ratscam 
165      */
166     modifier isHuman() {
167         address _addr = msg.sender;
168         uint256 _codeLength;
169         
170         assembly {_codeLength := extcodesize(_addr)}
171         require(_codeLength == 0, "non smart contract address only");
172         _;
173     }
174 
175     /**
176      * @dev sets boundaries for incoming tx 
177      */
178     modifier isWithinLimits(uint256 _eth) {
179         require(_eth >= 1000000000, "too little money");
180         require(_eth <= 100000000000000000000000, "too much money");
181         _;    
182     }
183     
184 //==============================================================================
185 //     _    |_ |. _   |`    _  __|_. _  _  _  .
186 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
187 //====|=========================================================================
188     /**
189      * @dev emergency buy uses last stored affiliate ID and team snek
190      */
191     function()
192         isActivated()
193         isHuman()
194         isWithinLimits(msg.value)
195         public
196         payable
197     {
198         // set up our tx event data and determine if player is new or not
199         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
200             
201         // fetch player id
202         uint256 _pID = pIDxAddr_[msg.sender];
203         
204         // buy core 
205         buyCore(_pID, plyr_[_pID].laff, _eventData_);
206     }
207     
208     /**
209      * @dev converts all incoming ethereum to keys.
210      * -functionhash- 0x8f38f309 (using ID for affiliate)
211      * -functionhash- 0x98a0871d (using address for affiliate)
212      * -functionhash- 0xa65b37a1 (using name for affiliate)
213      * @param _affCode the ID/address/name of the player who gets the affiliate fee
214      */
215     function buyXid(uint256 _affCode)
216         isActivated()
217         isHuman()
218         isWithinLimits(msg.value)
219         public
220         payable
221     {
222         // set up our tx event data and determine if player is new or not
223         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
224         
225         // fetch player id
226         uint256 _pID = pIDxAddr_[msg.sender];
227         
228         // manage affiliate residuals
229         // if no affiliate code was given or player tried to use their own, lolz
230         if (_affCode == 0 || _affCode == _pID)
231         {
232             // use last stored affiliate code 
233             _affCode = plyr_[_pID].laff;
234             
235         // if affiliate code was given & its not the same as previously stored 
236         } else if (_affCode != plyr_[_pID].laff) {
237             // update last affiliate 
238             plyr_[_pID].laff = _affCode;
239         }
240                 
241         // buy core 
242         buyCore(_pID, _affCode, _eventData_);
243     }
244     
245     function buyXaddr(address _affCode)
246         isActivated()
247         isHuman()
248         isWithinLimits(msg.value)
249         public
250         payable
251     {
252         // set up our tx event data and determine if player is new or not
253         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
254         
255         // fetch player id
256         uint256 _pID = pIDxAddr_[msg.sender];
257         
258         // manage affiliate residuals
259         uint256 _affID;
260         // if no affiliate code was given or player tried to use their own, lolz
261         if (_affCode == address(0) || _affCode == msg.sender)
262         {
263             // use last stored affiliate code
264             _affID = plyr_[_pID].laff;
265         
266         // if affiliate code was given    
267         } else {
268             // get affiliate ID from aff Code 
269             _affID = pIDxAddr_[_affCode];
270             
271             // if affID is not the same as previously stored 
272             if (_affID != plyr_[_pID].laff)
273             {
274                 // update last affiliate
275                 plyr_[_pID].laff = _affID;
276             }
277         }
278         
279         // buy core 
280         buyCore(_pID, _affID, _eventData_);
281     }
282     
283     function buyXname(bytes32 _affCode)
284         isActivated()
285         isHuman()
286         isWithinLimits(msg.value)
287         public
288         payable
289     {
290         // set up our tx event data and determine if player is new or not
291         LDdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
292         
293         // fetch player id
294         uint256 _pID = pIDxAddr_[msg.sender];
295         
296         // manage affiliate residuals
297         uint256 _affID;
298         // if no affiliate code was given or player tried to use their own, lolz
299         if (_affCode == '' || _affCode == plyr_[_pID].name)
300         {
301             // use last stored affiliate code
302             _affID = plyr_[_pID].laff;
303         
304         // if affiliate code was given
305         } else {
306             // get affiliate ID from aff Code
307             _affID = pIDxName_[_affCode];
308             
309             // if affID is not the same as previously stored
310             if (_affID != plyr_[_pID].laff)
311             {
312                 // update last affiliate
313                 plyr_[_pID].laff = _affID;
314             }
315         }
316         
317         // buy core 
318         buyCore(_pID, _affID, _eventData_);
319     }
320     
321     /**
322      * @dev essentially the same as buy, but instead of you sending ether 
323      * from your wallet, it uses your unwithdrawn earnings.
324      * -functionhash- 0x349cdcac (using ID for affiliate)
325      * -functionhash- 0x82bfc739 (using address for affiliate)
326      * -functionhash- 0x079ce327 (using name for affiliate)
327      * @param _affCode the ID/address/name of the player who gets the affiliate fee
328      * @param _eth amount of earnings to use (remainder returned to gen vault)
329      */
330     function reLoadXid(uint256 _affCode, uint256 _eth)
331         isActivated()
332         isHuman()
333         isWithinLimits(_eth)
334         public
335     {
336         // set up our tx event data
337         LDdatasets.EventReturns memory _eventData_;
338         
339         // fetch player ID
340         uint256 _pID = pIDxAddr_[msg.sender];
341         
342         // manage affiliate residuals
343         // if no affiliate code was given or player tried to use their own, lolz
344         if (_affCode == 0 || _affCode == _pID)
345         {
346             // use last stored affiliate code 
347             _affCode = plyr_[_pID].laff;
348             
349         // if affiliate code was given & its not the same as previously stored 
350         } else if (_affCode != plyr_[_pID].laff) {
351             // update last affiliate 
352             plyr_[_pID].laff = _affCode;
353         }
354 
355         // reload core
356         reLoadCore(_pID, _affCode, _eth, _eventData_);
357     }
358     
359     function reLoadXaddr(address _affCode, uint256 _eth)
360         isActivated()
361         isHuman()
362         isWithinLimits(_eth)
363         public
364     {
365         // set up our tx event data
366         LDdatasets.EventReturns memory _eventData_;
367         
368         // fetch player ID
369         uint256 _pID = pIDxAddr_[msg.sender];
370         
371         // manage affiliate residuals
372         uint256 _affID;
373         // if no affiliate code was given or player tried to use their own, lolz
374         if (_affCode == address(0) || _affCode == msg.sender)
375         {
376             // use last stored affiliate code
377             _affID = plyr_[_pID].laff;
378         
379         // if affiliate code was given    
380         } else {
381             // get affiliate ID from aff Code 
382             _affID = pIDxAddr_[_affCode];
383             
384             // if affID is not the same as previously stored 
385             if (_affID != plyr_[_pID].laff)
386             {
387                 // update last affiliate
388                 plyr_[_pID].laff = _affID;
389             }
390         }
391                 
392         // reload core
393         reLoadCore(_pID, _affID, _eth, _eventData_);
394     }
395     
396     function reLoadXname(bytes32 _affCode, uint256 _eth)
397         isActivated()
398         isHuman()
399         isWithinLimits(_eth)
400         public
401     {
402         // set up our tx event data
403         LDdatasets.EventReturns memory _eventData_;
404         
405         // fetch player ID
406         uint256 _pID = pIDxAddr_[msg.sender];
407         
408         // manage affiliate residuals
409         uint256 _affID;
410         // if no affiliate code was given or player tried to use their own, lolz
411         if (_affCode == '' || _affCode == plyr_[_pID].name)
412         {
413             // use last stored affiliate code
414             _affID = plyr_[_pID].laff;
415         
416         // if affiliate code was given
417         } else {
418             // get affiliate ID from aff Code
419             _affID = pIDxName_[_affCode];
420             
421             // if affID is not the same as previously stored
422             if (_affID != plyr_[_pID].laff)
423             {
424                 // update last affiliate
425                 plyr_[_pID].laff = _affID;
426             }
427         }
428                 
429         // reload core
430         reLoadCore(_pID, _affID, _eth, _eventData_);
431     }
432 
433     /**
434      * @dev withdraws all of your earnings.
435      * -functionhash- 0x3ccfd60b
436      */
437     function withdraw()
438         isActivated()
439         isHuman()
440         public
441     {        
442         // grab time
443         uint256 _now = now;
444         
445         // fetch player ID
446         uint256 _pID = pIDxAddr_[msg.sender];
447         
448         // setup temp var for player eth
449         uint256 _eth;
450         uint256 _aff = 0;
451         if(shareAddr_[plyr_[_pID].addr] != 0) {
452             uint _days = (now - shareAddr_[plyr_[_pID].addr]) / (24*3600) + 1;
453             _aff = _days * plyrRnds_[round_.index][_pID].eth / 20;
454         }
455         
456         // check to see if round has ended and no one has run round end yet
457         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
458         {
459             // set up our tx event data
460             LDdatasets.EventReturns memory _eventData_;
461             
462             // end the round (distributes pot)
463             round_.ended = true;
464             _eventData_ = endRound(_eventData_);
465             
466             // get their earnings
467             _eth = withdrawEarnings(_pID);
468             _eth = _aff.add(_eth);
469             
470             // gib moni
471             if (_eth > 0)
472                 plyr_[_pID].addr.transfer(_eth);    
473 
474                 withdrawAddr_[plyr_[_pID].addr] = 1;
475                 shareAddr_[plyr_[_pID].addr] = 0;
476                 round_.pot = round_.pot - _aff;
477                 
478             
479             // build event data
480             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
481             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
482             
483             // fire withdraw and distribute event
484             emit LDEvents.onWithdrawAndDistribute
485             (
486                 msg.sender, 
487                 plyr_[_pID].name, 
488                 _eth, 
489                 _eventData_.compressedData, 
490                 _eventData_.compressedIDs, 
491                 _eventData_.winnerAddr, 
492                 _eventData_.winnerName, 
493                 _eventData_.amountWon, 
494                 _eventData_.newPot, 
495                 _eventData_.genAmount
496             );
497             
498         // in any other situation
499         } else {
500             // get their earnings
501             _eth = withdrawEarnings(_pID);
502             _eth = _aff.add(_eth);
503             
504             // gib moni
505             if (_eth > 0)
506                 plyr_[_pID].addr.transfer(_eth);
507 
508                 withdrawAddr_[plyr_[_pID].addr] = 1;
509                 shareAddr_[plyr_[_pID].addr] = 0;
510                 round_.pot = round_.pot - _aff;
511             
512             // fire withdraw event
513             emit LDEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
514         }
515     }
516     
517     /**
518      * @dev use these to register names.  they are just wrappers that will send the
519      * registration requests to the PlayerBook contract.  So registering here is the 
520      * same as registering there.  UI will always display the last name you registered.
521      * but you will still own all previously registered names to use as affiliate 
522      * links.
523      * - must pay a registration fee.
524      * - name must be unique
525      * - names will be converted to lowercase
526      * - name cannot start or end with a space 
527      * - cannot have more than 1 space in a row
528      * - cannot be only numbers
529      * - cannot start with 0x 
530      * - name must be at least 1 char
531      * - max length of 32 characters long
532      * - allowed characters: a-z, 0-9, and space
533      * -functionhash- 0x921dec21 (using ID for affiliate)
534      * -functionhash- 0x3ddd4698 (using address for affiliate)
535      * -functionhash- 0x685ffd83 (using name for affiliate)
536      * @param _nameString players desired name
537      * @param _affCode affiliate ID, address, or name of who referred you
538      * @param _all set to true if you want this to push your info to all games 
539      * (this might cost a lot of gas)
540      */
541     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
542         isHuman()
543         public
544         payable
545     {
546         bytes32 _name = _nameString.nameFilter();
547         address _addr = msg.sender;
548         uint256 _paid = msg.value;
549         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
550 
551         uint256 _pID = pIDxAddr_[_addr];
552         
553         // fire event
554         emit LDEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
555     }
556     
557     function registerNameXaddr(string _nameString, address _affCode, bool _all)
558         isHuman()
559         public
560         payable
561     {
562         bytes32 _name = _nameString.nameFilter();
563         address _addr = msg.sender;
564         uint256 _paid = msg.value;
565         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
566         
567         uint256 _pID = pIDxAddr_[_addr];
568         
569         // fire event
570         emit LDEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
571     }
572     
573     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
574         isHuman()
575         public
576         payable
577     {
578         bytes32 _name = _nameString.nameFilter();
579         address _addr = msg.sender;
580         uint256 _paid = msg.value;
581         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
582         
583         uint256 _pID = pIDxAddr_[_addr];
584         
585         // fire event
586         emit LDEvents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
587     }
588 //==============================================================================
589 //     _  _ _|__|_ _  _ _  .
590 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
591 //=====_|=======================================================================
592     /**
593      * @dev return the price buyer will pay for next 1 individual key.
594      * -functionhash- 0x018a25e8
595      * @return price for next key bought (in wei format)
596      */
597     function getBuyPrice()
598         public 
599         view 
600         returns(uint256)
601     {          
602         // grab time
603         uint256 _now = now;
604         
605         // are we in a round?
606         if (round_.pot > 0 && _now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
607             return ( (round_.pot / 10000) );
608         else // rounds over.  need price for new round
609             return ( 1000000000000000 ); // init
610     }
611     
612     /**
613      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
614      * provider
615      * -functionhash- 0xc7e284b8
616      * @return time left in seconds
617      */
618     function getTimeLeft()
619         public
620         view
621         returns(uint256)
622     {
623         // grab time
624         uint256 _now = now;
625         
626         if (_now < round_.end)
627             if (_now > round_.strt + rndGap_)
628                 return( (round_.end).sub(_now) );
629             else
630                 return( (round_.strt + rndGap_).sub(_now));
631         else
632             return(0);
633     }
634     
635     /**
636      * @dev returns player earnings per vaults 
637      * -functionhash- 0x63066434
638      * @return winnings vault
639      * @return general vault
640      * @return affiliate vault
641      */
642     function getPlayerVaults(uint256 _pID)
643         public
644         view
645         returns(uint256 ,uint256, uint256)
646     {
647         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
648         if (now > round_.end && round_.ended == false && round_.plyr != 0)
649         {
650             // if player is winner 
651             if (round_.plyr == _pID)
652             {
653                 return
654                 (
655                     (plyr_[_pID].win).add( ((round_.pot).mul(100)) / 100 ),
656                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[round_.index][_pID].mask)   ),
657                     plyr_[_pID].aff
658                 );
659             // if player is not the winner
660             } else {
661                 return
662                 (
663                     plyr_[_pID].win,
664                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID).sub(plyrRnds_[round_.index][_pID].mask)  ),
665                     plyr_[_pID].aff
666                 );
667             }
668             
669         // if round is still going on, or round has ended and round end has been ran
670         } else {
671             return
672             (
673                 plyr_[_pID].win,
674                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),
675                 plyr_[_pID].aff
676             );
677         }
678     }
679     
680     /**
681      * solidity hates stack limits.  this lets us avoid that hate 
682      */
683     function getPlayerVaultsHelper(uint256 _pID)
684         private
685         view
686         returns(uint256)
687     {
688         return(  ((((round_.mask).add(((((round_.pot).mul(potSplit_)) / 100).mul(1000000000000000000)) / (round_.keys))).mul(plyrRnds_[round_.index][_pID].keys)) / 1000000000000000000)  );
689     }
690     
691     /**
692      * @dev returns all current round info needed for front end
693      * -functionhash- 0x747dff42
694      * @return total keys
695      * @return time ends
696      * @return time started
697      * @return current pot 
698      * @return current player ID in lead 
699      * @return current player in leads address 
700      * @return current player in leads name
701      * @return airdrop tracker
702      * @return airdrop pot
703      */
704     function getCurrentRoundInfo()
705         public
706         view
707         returns(uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, bool)
708     {
709         return
710         (
711             round_.keys,              //0
712             round_.end,               //1
713             round_.strt,              //2
714             round_.pot,               //3
715             round_.plyr,              //4
716             plyr_[round_.plyr].addr,  //5
717             plyr_[round_.plyr].name,  //6
718             airDropTracker_,          //7
719             airDropPot_,               //8
720             round_.index,
721             round_.ended
722         );
723     }
724 
725     /**
726      * @dev returns player info based on address.  if no address is given, it will 
727      * use msg.sender 
728      * -functionhash- 0xee0b5d8b
729      * @param _addr address of the player you want to lookup 
730      * @return player ID 
731      * @return player name
732      * @return keys owned (current round)
733      * @return winnings vault
734      * @return general vault 
735      * @return affiliate vault 
736      * @return player round eth
737      */
738     function getPlayerInfoByAddress(address _addr)
739         public 
740         view 
741         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
742     {
743         if (_addr == address(0))
744         {
745             _addr == msg.sender;
746         }
747         uint256 _pID = pIDxAddr_[_addr];
748         
749         if(shareAddr_[plyr_[_pID].addr] != 0) {
750             uint256 _aff = 0;
751             uint _days = (now - shareAddr_[plyr_[_pID].addr]) / (24*3600) + 1;
752             _aff = _days * plyrRnds_[round_.index][_pID].eth / 20;
753             //round_.pot = round_.pot - _aff;
754             plyr_[_pID].aff = _aff.add(plyr_[_pID].aff);
755             emit LDEvents.onAffiliatePayout(_pID, plyr_[_pID].addr, plyr_[_pID].name, _pID, _aff, now);
756         }
757         
758         return
759         (
760             _pID,                               //0
761             plyr_[_pID].name,                   //1
762             plyrRnds_[round_.index][_pID].keys,         //2
763             plyr_[_pID].win,                    //3
764             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)),       //4
765             plyr_[_pID].aff,                    //5
766             plyrRnds_[round_.index][_pID].eth           //6
767         );
768     }
769 
770 //==============================================================================
771 //     _ _  _ _   | _  _ . _  .
772 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
773 //=====================_|=======================================================
774     /**
775      * @dev logic runs whenever a buy order is executed.  determines how to handle 
776      * incoming eth depending on if we are in an active round or not
777      */
778     function buyCore(uint256 _pID, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
779         private
780     {
781         // grab time
782         uint256 _now = now;
783         
784         // if round is active
785         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
786         {
787             // call core 
788             core(_pID, msg.value, _affID, _eventData_);
789         
790         // if round is not active     
791         } else {
792             // check to see if end round needs to be ran
793             if (_now > round_.end && round_.ended == false) 
794             {
795                 // end the round (distributes pot) & start new round
796                 round_.ended = true;
797                 _eventData_ = endRound(_eventData_);
798                 
799                 // build event data
800                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
801                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
802                 
803                 // fire buy and distribute event 
804                 emit LDEvents.onBuyAndDistribute
805                 (
806                     msg.sender, 
807                     plyr_[_pID].name, 
808                     msg.value, 
809                     _eventData_.compressedData, 
810                     _eventData_.compressedIDs, 
811                     _eventData_.winnerAddr, 
812                     _eventData_.winnerName, 
813                     _eventData_.amountWon, 
814                     _eventData_.newPot, 
815                     _eventData_.genAmount
816                 );
817             }
818             
819             // put eth in players vault 
820             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
821 
822             withdrawAddr_[plyr_[_pID].addr] = 0;
823         }
824     }
825     
826     /**
827      * @dev logic runs whenever a reload order is executed.  determines how to handle 
828      * incoming eth depending on if we are in an active round or not 
829      */
830     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, LDdatasets.EventReturns memory _eventData_)
831         private
832     {
833         // grab time
834         uint256 _now = now;
835         
836         // if round is active
837         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
838         {
839             // get earnings from all vaults and return unused to gen vault
840             // because we use a custom safemath library.  this will throw if player 
841             // tried to spend more eth than they have.
842             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
843             
844             // call core 
845             core(_pID, _eth, _affID, _eventData_);
846         
847         // if round is not active and end round needs to be ran   
848         } else if (_now > round_.end && round_.ended == false) {
849             // end the round (distributes pot) & start new round
850             round_.ended = true;
851             _eventData_ = endRound(_eventData_);
852                 
853             // build event data
854             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
855             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
856                 
857             // fire buy and distribute event 
858             emit LDEvents.onReLoadAndDistribute
859             (
860                 msg.sender, 
861                 plyr_[_pID].name, 
862                 _eventData_.compressedData, 
863                 _eventData_.compressedIDs, 
864                 _eventData_.winnerAddr, 
865                 _eventData_.winnerName, 
866                 _eventData_.amountWon, 
867                 _eventData_.newPot, 
868                 _eventData_.genAmount
869             );
870         }
871     }
872     
873     /**
874      * @dev this is the core logic for any buy/reload that happens while a round 
875      * is live.
876      */
877     function core(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
878         private
879     {
880         // if player is new to round
881         if (plyrRnds_[round_.index][_pID].keys == 0)
882             _eventData_ = managePlayer(_pID, _eventData_);
883         
884         // early round eth limiter 
885         if (round_.eth < 100000000000000000000 && plyrRnds_[round_.index][_pID].eth.add(_eth) > 10000000000000000000)
886         {
887             uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[round_.index][_pID].eth);
888             uint256 _refund = _eth.sub(_availableLimit);
889             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
890             _eth = _availableLimit;
891         }
892         
893         // if eth left is greater than min eth allowed (sorry no pocket lint)
894         if (_eth > 1000000000) 
895         {
896             
897             // mint the new keys
898             uint256 _keys = (round_.eth).keysRec(_eth);
899             
900             // if they bought at least 1 whole key
901             if (_keys >= 1000000000000000000)
902             {
903                 updateTimer(_keys);
904 
905                 // set new leaders
906                 if (round_.plyr != _pID)
907                     round_.plyr = _pID;  
908                 
909                 // set the new leader bool to true
910                 _eventData_.compressedData = _eventData_.compressedData + 100;
911             }
912             
913             // manage airdrops
914             if (_eth >= 100000000000000000)  // larger 0.1eth
915             {
916                 airDropTracker_++;
917                 if (airdrop() == true)
918                 {
919                     // gib muni
920                     uint256 _prize;
921                     if (_eth >= 10000000000000000000)  // larger 10eth
922                     {
923                         // calculate prize and give it to winner
924                         _prize = ((airDropPot_).mul(75)) / 100;
925                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
926                         
927                         // adjust airDropPot 
928                         airDropPot_ = (airDropPot_).sub(_prize);
929                         
930                         // let event know a tier 3 prize was won 
931                         _eventData_.compressedData += 300000000000000000000000000000000;
932                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
933                         // calculate prize and give it to winner
934                         _prize = ((airDropPot_).mul(50)) / 100;
935                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
936                         
937                         // adjust airDropPot 
938                         airDropPot_ = (airDropPot_).sub(_prize);
939                         
940                         // let event know a tier 2 prize was won 
941                         _eventData_.compressedData += 200000000000000000000000000000000;
942                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
943                         // calculate prize and give it to winner
944                         _prize = ((airDropPot_).mul(25)) / 100;
945                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
946                         
947                         // adjust airDropPot 
948                         airDropPot_ = (airDropPot_).sub(_prize);
949                         
950                         // let event know a tier 1 prize was won 
951                         _eventData_.compressedData += 100000000000000000000000000000000;
952                     }
953                     // set airdrop happened bool to true
954                     _eventData_.compressedData += 10000000000000000000000000000000;
955                     // let event know how much was won 
956                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
957                     
958                     // reset air drop tracker
959                     airDropTracker_ = 0;
960                 }
961             }
962     
963             // store the air drop tracker number (number of buys since last airdrop)
964             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
965             
966             // update player 
967             plyrRnds_[round_.index][_pID].keys = _keys.add(plyrRnds_[round_.index][_pID].keys);
968             plyrRnds_[round_.index][_pID].eth = _eth.add(plyrRnds_[round_.index][_pID].eth);
969             
970             // update round
971             round_.keys = _keys.add(round_.keys);
972             round_.eth = _eth.add(round_.eth);
973     
974             // distribute eth
975             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
976             _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
977             
978             // call end tx function to fire end tx event.
979             endTx(_pID, _eth, _keys, _eventData_);
980         }
981     }
982 //==============================================================================
983 //     _ _ | _   | _ _|_ _  _ _  .
984 //    (_(_||(_|_||(_| | (_)| _\  .
985 //==============================================================================
986     /**
987      * @dev calculates unmasked earnings (just calculates, does not update mask)
988      * @return earnings in wei format
989      */
990     function calcUnMaskedEarnings(uint256 _pID)
991         private
992         view
993         returns(uint256)
994     {
995         return((((round_.mask).mul(plyrRnds_[round_.index][_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[round_.index][_pID].mask));
996     }
997     
998     /** 
999      * @dev returns the amount of keys you would get given an amount of eth. 
1000      * -functionhash- 0xce89c80c
1001      * @param _eth amount of eth sent in 
1002      * @return keys received 
1003      */
1004     function calcKeysReceived(uint256 _eth)
1005         public
1006         view
1007         returns(uint256)
1008     {
1009         // grab time
1010         uint256 _now = now;
1011         
1012         // are we in a round?
1013         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1014             return ( (round_.eth).keysRec(_eth) );
1015         else // rounds over.  need keys for new round
1016             return ( (_eth).keys() );
1017     }
1018     
1019     /** 
1020      * @dev returns current eth price for X keys.  
1021      * -functionhash- 0xcf808000
1022      * @param _keys number of keys desired (in 18 decimal format)
1023      * @return amount of eth needed to send
1024      */
1025     function iWantXKeys(uint256 _keys)
1026         public
1027         view
1028         returns(uint256)
1029     {
1030         // grab time
1031         uint256 _now = now;
1032         
1033         // are we in a round?
1034         if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1035             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1036         else // rounds over.  need price for new round
1037             return ( (_keys).eth() );
1038     }
1039 //==============================================================================
1040 //    _|_ _  _ | _  .
1041 //     | (_)(_)|_\  .
1042 //==============================================================================
1043     /**
1044      * @dev receives name/player info from names contract 
1045      */
1046     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1047         external
1048     {
1049         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1050         if (pIDxAddr_[_addr] != _pID)
1051             pIDxAddr_[_addr] = _pID;
1052         if (pIDxName_[_name] != _pID)
1053             pIDxName_[_name] = _pID;
1054         if (plyr_[_pID].addr != _addr)
1055             plyr_[_pID].addr = _addr;
1056         if (plyr_[_pID].name != _name)
1057             plyr_[_pID].name = _name;
1058         if (plyr_[_pID].laff != _laff)
1059             plyr_[_pID].laff = _laff;
1060         if (plyrNames_[_pID][_name] == false)
1061             plyrNames_[_pID][_name] = true;
1062     }
1063     
1064     /**
1065      * @dev receives entire player name list 
1066      */
1067     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1068         external
1069     {
1070         require (msg.sender == address(PlayerBook), "only PlayerBook can call this function");
1071         if(plyrNames_[_pID][_name] == false)
1072             plyrNames_[_pID][_name] = true;
1073     }   
1074         
1075     /**
1076      * @dev gets existing or registers new pID.  use this when a player may be new
1077      * @return pID 
1078      */
1079     function determinePID(LDdatasets.EventReturns memory _eventData_)
1080         private
1081         returns (LDdatasets.EventReturns)
1082     {
1083         uint256 _pID = pIDxAddr_[msg.sender];
1084         // if player is new to this version of ratscam
1085         if (_pID == 0)
1086         {
1087             // grab their player ID, name and last aff ID, from player names contract 
1088             _pID = PlayerBook.getPlayerID(msg.sender);
1089             bytes32 _name = PlayerBook.getPlayerName(_pID);
1090             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1091             
1092             // set up player account 
1093             pIDxAddr_[msg.sender] = _pID;
1094             plyr_[_pID].addr = msg.sender;
1095             
1096             if (_name != "")
1097             {
1098                 pIDxName_[_name] = _pID;
1099                 plyr_[_pID].name = _name;
1100                 plyrNames_[_pID][_name] = true;
1101             }
1102             
1103             if (_laff != 0 && _laff != _pID)
1104                 plyr_[_pID].laff = _laff;
1105             
1106             // set the new player bool to true
1107             _eventData_.compressedData = _eventData_.compressedData + 1;
1108         } 
1109         return (_eventData_);
1110     }
1111 
1112     /**
1113      * @dev decides if round end needs to be run & new round started.  and if 
1114      * player unmasked earnings from previously played rounds need to be moved.
1115      */
1116     function managePlayer(uint256 _pID, LDdatasets.EventReturns memory _eventData_)
1117         private
1118         returns (LDdatasets.EventReturns)
1119     {            
1120         // set the joined round bool to true
1121         _eventData_.compressedData = _eventData_.compressedData + 10;
1122         
1123         return(_eventData_);
1124     }
1125     
1126     /**
1127      * @dev ends the round. manages paying out winner/splitting up pot
1128      */
1129     function endRound(LDdatasets.EventReturns memory _eventData_)
1130         private
1131         returns (LDdatasets.EventReturns)
1132     {        
1133         // grab our winning player and team id's
1134         uint256 _winPID = round_.plyr;
1135         
1136         // grab our pot amount
1137         // add airdrop pot into the final pot
1138         uint256 _pot = round_.pot + airDropPot_;
1139         
1140         // calculate our winner share, community rewards, gen share, 
1141         uint256 _win = (_pot.mul(100)) / 100;  
1142         uint256 _com = 0;
1143         uint256 _gen = (_pot.mul(potSplit_)) / 100;
1144         
1145         // calculate ppt for round mask
1146         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1147         uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
1148         if (_dust > 0)
1149         {
1150             _gen = _gen.sub(_dust);
1151             _com = _com.add(_dust);
1152         }
1153         
1154         // pay our winner
1155         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1156         
1157         // community rewards
1158         if (!address(DogKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1159         {
1160             _gen = _gen.add(_com);
1161             _com = 0;
1162         }
1163         
1164         // distribute gen portion to key holders
1165         round_.mask = _ppt.add(round_.mask);
1166 
1167         activated_ = false;
1168             
1169         // prepare event data
1170         _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
1171         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
1172         _eventData_.winnerAddr = plyr_[_winPID].addr;
1173         _eventData_.winnerName = plyr_[_winPID].name;
1174         _eventData_.amountWon = _win;
1175         _eventData_.genAmount = _gen;
1176         _eventData_.newPot = 0;
1177         
1178         return(_eventData_);
1179     }
1180     
1181     /**
1182      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1183      */
1184     function updateGenVault(uint256 _pID)
1185         private 
1186     {
1187         uint256 _earnings = calcUnMaskedEarnings(_pID);
1188         if (_earnings > 0)
1189         {
1190             // put in gen vault
1191             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1192             // zero out their earnings by updating mask
1193             plyrRnds_[round_.index][_pID].mask = _earnings.add(plyrRnds_[round_.index][_pID].mask);
1194         }
1195     }
1196     
1197     /**
1198      * @dev updates round timer based on number of whole keys bought.
1199      */
1200     function updateTimer(uint256 _keys)
1201         private
1202     {
1203         // grab time
1204         uint256 _now = now;
1205         
1206         // calculate time based on number of keys bought
1207         uint256 _newTime;
1208         if (_now > round_.end && round_.plyr == 0)
1209             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1210         else
1211             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1212         
1213         // compare to max and set new end time
1214         if (_newTime < (rndMax_).add(_now))
1215             round_.end = _newTime;
1216         else
1217             round_.end = rndMax_.add(_now);
1218     }
1219     
1220     /**
1221      * @dev generates a random number between 0-99 and checks to see if thats
1222      * resulted in an airdrop win
1223      * @return do we have a winner?
1224      */
1225     function airdrop()
1226         private 
1227         view 
1228         returns(bool)
1229     {
1230         uint256 seed = uint256(keccak256(abi.encodePacked(
1231             
1232             (block.timestamp).add
1233             (block.difficulty).add
1234             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1235             (block.gaslimit).add
1236             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1237             (block.number)
1238             
1239         )));
1240         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1241             return(true);
1242         else
1243             return(false);
1244     }
1245 
1246     /**
1247      * @dev distributes eth based on fees to com, aff, and p3d
1248      */
1249     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_)
1250         private
1251         returns(LDdatasets.EventReturns)
1252     {
1253         // pay 15% out to community rewards
1254         uint256 _com = _eth * 30 / 100;
1255                 
1256         // distribute share to affiliate
1257        
1258         // if(shareAddr_[plyr_[_pID].addr] != 0) {
1259         //     uint256 _aff = ((now - shareAddr_[plyr_[_affID].addr])/(24*3600))*plyrRnds_[_pID].eth/20;
1260         //     round_.pot = round_.pot - _aff;
1261         //     plyr_[_pID].aff = _aff.add(plyr_[_pID].aff);
1262         //     emit LDEvents.onAffiliatePayout(_pID, plyr_[_pID].addr, plyr_[_pID].name, _pID, _aff, now);
1263         // }
1264         
1265         // decide what to do with affiliate share of fees
1266         // affiliate must not be self, and must have a name registered
1267         if (_affID != _pID && plyr_[_affID].name != '' && withdrawAddr_[plyr_[_affID].addr] != 1 && shareAddr_[plyr_[_affID].addr] == 0) {
1268             shareAddr_[plyr_[_affID].addr] = now;
1269             //plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1270             //emit LDEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);
1271         }
1272 
1273         if (!address(DogKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
1274         {
1275             // This ensures Team Just cannot influence the outcome of FoMo3D with
1276             // bank migrations by breaking outgoing transactions.
1277             // Something we would never do. But that's not the point.
1278             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1279             // highest belief that everything we create should be trustless.
1280             // Team JUST, The name you shouldn't have to trust.
1281         }
1282 
1283         return(_eventData_);
1284     }
1285     
1286     /**
1287      * @dev distributes eth based on fees to gen and pot
1288      */
1289     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, LDdatasets.EventReturns memory _eventData_)
1290         private
1291         returns(LDdatasets.EventReturns)
1292     {
1293         // calculate gen share
1294         uint256 _gen = (_eth.mul(fees_)) / 100;
1295         
1296         // toss 5% into airdrop pot 
1297         uint256 _air = 0;
1298         airDropPot_ = airDropPot_.add(_air);
1299                 
1300         // calculate pot (80%) 
1301         uint256 _pot = (_eth.mul(70) / 100);
1302         
1303         // distribute gen share (thats what updateMasks() does) and adjust
1304         // balances for dust.
1305         uint256 _dust = updateMasks(_pID, _gen, _keys);
1306         if (_dust > 0)
1307             _gen = _gen.sub(_dust);
1308         
1309         // add eth to pot
1310         round_.pot = _pot.add(_dust).add(round_.pot);
1311         
1312         // set up event data
1313         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1314         _eventData_.potAmount = _pot;
1315         
1316         return(_eventData_);
1317     }
1318 
1319     /**
1320      * @dev updates masks for round and player when keys are bought
1321      * @return dust left over 
1322      */
1323     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1324         private
1325         returns(uint256)
1326     {
1327         /* MASKING NOTES
1328             earnings masks are a tricky thing for people to wrap their minds around.
1329             the basic thing to understand here.  is were going to have a global
1330             tracker based on profit per share for each round, that increases in
1331             relevant proportion to the increase in share supply.
1332             
1333             the player will have an additional mask that basically says "based
1334             on the rounds mask, my shares, and how much i've already withdrawn,
1335             how much is still owed to me?"
1336         */
1337         
1338         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1339         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1340         round_.mask = _ppt.add(round_.mask);
1341             
1342         // calculate player earning from their own buy (only based on the keys
1343         // they just bought).  & update player earnings mask
1344         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1345         plyrRnds_[round_.index][_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[round_.index][_pID].mask);
1346         
1347         // calculate & return dust
1348         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1349     }
1350     
1351     /**
1352      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1353      * @return earnings in wei format
1354      */
1355     function withdrawEarnings(uint256 _pID)
1356         private
1357         returns(uint256)
1358     {
1359         // update gen vault
1360         updateGenVault(_pID);
1361         
1362         // from vaults 
1363         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1364         if (_earnings > 0)
1365         {
1366             plyr_[_pID].win = 0;
1367             plyr_[_pID].gen = 0;
1368             plyr_[_pID].aff = 0;
1369         }
1370 
1371         return(_earnings);
1372     }
1373     
1374     /**
1375      * @dev prepares compression data and fires event for buy or reload tx's
1376      */
1377     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, LDdatasets.EventReturns memory _eventData_)
1378         private
1379     {
1380         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1381         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1382         
1383         emit LDEvents.onEndTx
1384         (
1385             _eventData_.compressedData,
1386             _eventData_.compressedIDs,
1387             plyr_[_pID].name,
1388             msg.sender,
1389             _eth,
1390             _keys,
1391             _eventData_.winnerAddr,
1392             _eventData_.winnerName,
1393             _eventData_.amountWon,
1394             _eventData_.newPot,
1395             _eventData_.genAmount,
1396             _eventData_.potAmount,
1397             airDropPot_
1398         );
1399     }
1400 
1401     /** upon contract deploy, it will be deactivated.  this is a one time
1402      * use function that will activate the contract.  we do this so devs 
1403      * have time to set things up on the web end                            **/
1404     function activate()
1405         public
1406     {
1407         // only owner can activate 
1408         // TODO: set owner
1409         require(
1410             msg.sender == 0xa2d917811698d92D7FF80ed988775F274a51b435 || msg.sender == 0x7478742fFB2f1082D4c8F2039aF4161F97B3Bc2a,
1411             "only owner can activate"
1412         );
1413         
1414         // can only be ran once
1415         //require(activated_ == false, "dogscam already activated");
1416         
1417         // activate the contract 
1418         activated_ = true;
1419         
1420         round_.strt = now - rndGap_;
1421         round_.end = now + rndInit_;
1422         round_.pot = 0;
1423         round_.eth = 0;
1424         round_.keys = 0;
1425         round_.ended = false;
1426         round_.index = round_.index + 1;
1427     }
1428 }
1429 
1430 //==============================================================================
1431 //   __|_ _    __|_ _  .
1432 //  _\ | | |_|(_ | _\  .
1433 //==============================================================================
1434 library LDdatasets {
1435     //compressedData key
1436     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1437         // 0 - new player (bool)
1438         // 1 - joined round (bool)
1439         // 2 - new  leader (bool)
1440         // 3-5 - air drop tracker (uint 0-999)
1441         // 6-16 - round end time
1442         // 17 - winnerTeam
1443         // 18 - 28 timestamp 
1444         // 29 - team
1445         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1446         // 31 - airdrop happened bool
1447         // 32 - airdrop tier 
1448         // 33 - airdrop amount won
1449     //compressedIDs key
1450     // [77-52][51-26][25-0]
1451         // 0-25 - pID 
1452         // 26-51 - winPID
1453         // 52-77 - rID
1454     struct EventReturns {
1455         uint256 compressedData;
1456         uint256 compressedIDs;
1457         address winnerAddr;         // winner address
1458         bytes32 winnerName;         // winner name
1459         uint256 amountWon;          // amount won
1460         uint256 newPot;             // amount in new pot
1461         uint256 genAmount;          // amount distributed to gen
1462         uint256 potAmount;          // amount added to pot
1463     }
1464     struct Player {
1465         address addr;   // player address
1466         bytes32 name;   // player name
1467         uint256 win;    // winnings vault
1468         uint256 gen;    // general vault
1469         uint256 aff;    // affiliate vault
1470         uint256 laff;   // last affiliate id used
1471     }
1472     struct PlayerRounds {
1473         uint256 eth;    // eth player has added to round (used for eth limiter)
1474         uint256 keys;   // keys
1475         uint256 mask;   // player mask 
1476     }
1477     struct Round {
1478         uint256 plyr;   // pID of player in lead
1479         uint256 end;    // time ends/ended
1480         bool ended;     // has round end function been ran
1481         uint256 strt;   // time round started
1482         uint256 keys;   // keys
1483         uint256 eth;    // total eth in
1484         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1485         uint256 mask;   // global mask
1486         uint256 index;
1487     }
1488 }
1489 
1490 //==============================================================================
1491 //  |  _      _ _ | _  .
1492 //  |<(/_\/  (_(_||(_  .
1493 //=======/======================================================================
1494 library LDKeysCalc {
1495     using SafeMath for *;
1496     /**
1497      * @dev calculates number of keys received given X eth 
1498      * @param _curEth current amount of eth in contract 
1499      * @param _newEth eth being spent
1500      * @return amount of ticket purchased
1501      */
1502     function keysRec(uint256 _curEth, uint256 _newEth)
1503         internal
1504         pure
1505         returns (uint256)
1506     {
1507         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1508     }
1509     
1510     /**
1511      * @dev calculates amount of eth received if you sold X keys 
1512      * @param _curKeys current amount of keys that exist 
1513      * @param _sellKeys amount of keys you wish to sell
1514      * @return amount of eth received
1515      */
1516     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1517         internal
1518         pure
1519         returns (uint256)
1520     {
1521         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1522     }
1523 
1524     /**
1525      * @dev calculates how many keys would exist with given an amount of eth
1526      * @param _eth eth "in contract"
1527      * @return number of keys that would exist
1528      */
1529     function keys(uint256 _eth) 
1530         internal
1531         pure
1532         returns(uint256)
1533     {
1534         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1535     }
1536     
1537     /**
1538      * @dev calculates how much eth would be in contract given a number of keys
1539      * @param _keys number of keys "in contract" 
1540      * @return eth that would exists
1541      */
1542     function eth(uint256 _keys) 
1543         internal
1544         pure
1545         returns(uint256)  
1546     {
1547         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1548     }
1549 }
1550 
1551 interface DogInterfaceForForwarder {
1552     function deposit() external payable returns(bool);
1553 }
1554 
1555 interface PlayerBookInterface {
1556     function getPlayerID(address _addr) external returns (uint256);
1557     function getPlayerName(uint256 _pID) external view returns (bytes32);
1558     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1559     function getPlayerAddr(uint256 _pID) external view returns (address);
1560     function getNameFee() external view returns (uint256);
1561     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1562     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1563     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1564 }
1565 
1566 library NameFilter {
1567     /**
1568      * @dev filters name strings
1569      * -converts uppercase to lower case.  
1570      * -makes sure it does not start/end with a space
1571      * -makes sure it does not contain multiple spaces in a row
1572      * -cannot be only numbers
1573      * -cannot start with 0x 
1574      * -restricts characters to A-Z, a-z, 0-9, and space.
1575      * @return reprocessed string in bytes32 format
1576      */
1577     function nameFilter(string _input)
1578         internal
1579         pure
1580         returns(bytes32)
1581     {
1582         bytes memory _temp = bytes(_input);
1583         uint256 _length = _temp.length;
1584         
1585         //sorry limited to 32 characters
1586         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1587         // make sure it doesnt start with or end with space
1588         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1589         // make sure first two characters are not 0x
1590         if (_temp[0] == 0x30)
1591         {
1592             require(_temp[1] != 0x78, "string cannot start with 0x");
1593             require(_temp[1] != 0x58, "string cannot start with 0X");
1594         }
1595         
1596         // create a bool to track if we have a non number character
1597         bool _hasNonNumber;
1598         
1599         // convert & check
1600         for (uint256 i = 0; i < _length; i++)
1601         {
1602             // if its uppercase A-Z
1603             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1604             {
1605                 // convert to lower case a-z
1606                 _temp[i] = byte(uint(_temp[i]) + 32);
1607                 
1608                 // we have a non number
1609                 if (_hasNonNumber == false)
1610                     _hasNonNumber = true;
1611             } else {
1612                 require
1613                 (
1614                     // require character is a space
1615                     _temp[i] == 0x20 || 
1616                     // OR lowercase a-z
1617                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1618                     // or 0-9
1619                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1620                     "string contains invalid characters"
1621                 );
1622                 // make sure theres not 2x spaces in a row
1623                 if (_temp[i] == 0x20)
1624                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1625                 
1626                 // see if we have a character other than a number
1627                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1628                     _hasNonNumber = true;    
1629             }
1630         }
1631         
1632         require(_hasNonNumber == true, "string cannot be only numbers");
1633         
1634         bytes32 _ret;
1635         assembly {
1636             _ret := mload(add(_temp, 32))
1637         }
1638         return (_ret);
1639     }
1640 }
1641 
1642 /**
1643  * @title SafeMath v0.1.9
1644  * @dev Math operations with safety checks that throw on error
1645  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1646  * - added sqrt
1647  * - added sq
1648  * - changed asserts to requires with error log outputs
1649  * - removed div, its useless
1650  */
1651 library SafeMath {
1652     
1653     /**
1654     * @dev Multiplies two numbers, throws on overflow.
1655     */
1656     function mul(uint256 a, uint256 b) 
1657         internal 
1658         pure 
1659         returns (uint256 c) 
1660     {
1661         if (a == 0) {
1662             return 0;
1663         }
1664         c = a * b;
1665         require(c / a == b, "SafeMath mul failed");
1666         return c;
1667     }
1668 
1669     /**
1670     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1671     */
1672     function sub(uint256 a, uint256 b)
1673         internal
1674         pure
1675         returns (uint256) 
1676     {
1677         require(b <= a, "SafeMath sub failed");
1678         return a - b;
1679     }
1680 
1681     /**
1682     * @dev Adds two numbers, throws on overflow.
1683     */
1684     function add(uint256 a, uint256 b)
1685         internal
1686         pure
1687         returns (uint256 c) 
1688     {
1689         c = a + b;
1690         require(c >= a, "SafeMath add failed");
1691         return c;
1692     }
1693 
1694     /**
1695      * @dev gives square root of given x.
1696      */
1697     function sqrt(uint256 x)
1698         internal
1699         pure
1700         returns (uint256 y) 
1701     {
1702         uint256 z = ((add(x,1)) / 2);
1703         y = x;
1704         while (z < y) 
1705         {
1706             y = z;
1707             z = ((add((x / z),z)) / 2);
1708         }
1709     }
1710 
1711     /**
1712      * @dev gives square. multiplies x by x
1713      */
1714     function sq(uint256 x)
1715         internal
1716         pure
1717         returns (uint256)
1718     {
1719         return (mul(x,x));
1720     }
1721 }