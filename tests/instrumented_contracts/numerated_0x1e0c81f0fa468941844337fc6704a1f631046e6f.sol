1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title -FoMo-3Dx beta
5  * 
6  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
7  */
8 
9 //==============================================================================
10 //     _    _  _ _|_ _  .
11 //    (/_\/(/_| | | _\  .
12 //==============================================================================
13 contract F3Devents {
14     // fired whenever a player registers a name
15     event onNewName
16     (
17         uint256 indexed playerID,
18         address indexed playerAddress,
19         bytes32 indexed playerName,
20         bool isNewPlayer,
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
37         uint256 devAmount,
38         uint256 genAmount,
39         uint256 potAmount
40     );
41     
42 	// fired whenever theres a withdraw
43     event onWithdraw
44     (
45         uint256 indexed playerID,
46         address playerAddress,
47         bytes32 playerName,
48         uint256 ethOut,
49         uint256 timeStamp
50     );
51     
52     // fired whenever a withdraw forces end round to be ran
53     event onWithdrawAndDistribute
54     (
55         address playerAddress,
56         bytes32 playerName,
57         uint256 ethOut,
58         uint256 compressedData,
59         uint256 compressedIDs,
60         address winnerAddr,
61         bytes32 winnerName,
62         uint256 amountWon,
63         uint256 devAmount,
64         uint256 genAmount
65     );
66     
67     // (fomo3dx only) fired whenever a player tries a buy after round timer 
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
79         uint256 devAmount,
80         uint256 genAmount
81     );
82     
83     // (fomo3dx only) fired whenever a player tries a reload after round timer 
84     // hit zero, and causes end round to be ran.
85     event onReLoadAndDistribute
86     (
87         address playerAddress,
88         bytes32 playerName,
89         uint256 compressedData,
90         uint256 compressedIDs,
91         address winnerAddr,
92         bytes32 winnerName,
93         uint256 amountWon,
94         uint256 devAmount,
95         uint256 genAmount
96     );
97 }
98 
99 //==============================================================================
100 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
101 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
102 //====================================|=========================================
103 
104 contract modularLong is F3Devents {}
105 
106 contract F3Dx is modularLong {
107     using SafeMath for *;
108     using NameFilter for string;
109     using F3DKeysCalcLong for uint256;
110 
111     address constant private AwardPool = 0xb14D7b0ec631Daf0cF02d69860974df04987a9f8;
112     address constant private DeveloperRewards = 0xb14D7b0ec631Daf0cF02d69860974df04987a9f8;
113     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xdAc532cA5598Ee19a2dfC1244c7608C766c6C415);
114 //==============================================================================
115 //     _ _  _  |`. _     _ _ |_ | _  _  .
116 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
117 //=================_|===========================================================
118     string constant public name = "FoMo3D X";
119     string constant public symbol = "F3Dx";
120     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
121     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
122     uint256 constant private rndMax_ = 8 hours;                // max length a round timer can be
123 //==============================================================================
124 //     _| _ _|_ _    _ _ _|_    _   .
125 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
126 //=============================|================================================
127     uint256 public rID_;    // round id number / total rounds that have happened
128 //****************
129 // PLAYER DATA 
130 //****************
131     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
132     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
133     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
134     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
135     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
136 //****************
137 // ROUND DATA 
138 //****************
139     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
140 //****************
141 // FEE DATA 
142 //****************
143     F3Ddatasets.KeyFee public fees_;          // fee distribution by holder
144     F3Ddatasets.PotSplit public potSplit_;     // fees pot split distribution
145 //==============================================================================
146 //     _ _  _  __|_ _    __|_ _  _  .
147 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
148 //==============================================================================
149     constructor()
150         public
151     {
152 
153 		// Key allocation percentages
154         // F3Dx + (Pot, Share, Developer)
155         fees_ = F3Ddatasets.KeyFee(50,10);   //40% to pot, 50% to key holder, 10% to dev reward
156         
157         // Pot allocation percentages
158         // (WIN, DEV)
159         potSplit_ = F3Ddatasets.PotSplit(40,10);  //40% to offcial then transfer to winner, 10% to dev reward, 50% to official
160     }
161 //==============================================================================
162 //     _ _  _  _|. |`. _  _ _  .
163 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
164 //==============================================================================
165     /**
166      * @dev used to make sure no one can interact with contract until it has 
167      * been activated. 
168      */
169     modifier isActivated() {
170         require(activated_ == true, "its not ready yet."); 
171         _;
172     }
173     
174     /**
175      * @dev prevents contracts from interacting with fomo3dx 
176      */
177     modifier isHuman() {
178         address _addr = msg.sender;
179         uint256 _codeLength;
180         
181         assembly {_codeLength := extcodesize(_addr)}
182         require(_codeLength == 0, "sorry humans only");
183         _;
184     }
185 
186     /**
187      * @dev sets boundaries for incoming tx 
188      */
189     modifier isWithinLimits(uint256 _eth) {
190         require(_eth >= 1000000000, "pocket lint: not a valid currency");
191         require(_eth <= 100000000000000000000000, "no vitalik, no");
192         _;    
193     }
194     
195 //==============================================================================
196 //     _    |_ |. _   |`    _  __|_. _  _  _  .
197 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
198 //====|=========================================================================
199     /**
200      * @dev emergency buy
201      */
202     function()
203         isActivated()
204         isHuman()
205         isWithinLimits(msg.value)
206         public
207         payable
208     {
209         // set up our tx event data and determine if player is new or not
210         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
211             
212         // fetch player id
213         uint256 _pID = pIDxAddr_[msg.sender];
214         
215         // buy core 
216         buyCore(_pID, _eventData_);
217     }
218     
219     /**
220      * @dev converts all incoming ethereum to keys.
221      */
222     function buyXid()
223         isActivated()
224         isHuman()
225         isWithinLimits(msg.value)
226         public
227         payable
228     {
229         // set up our tx event data and determine if player is new or not
230         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
231         
232         // fetch player id
233         uint256 _pID = pIDxAddr_[msg.sender];
234         
235         // buy core 
236         buyCore(_pID, _eventData_);
237     }
238     
239     function buyXaddr()
240         isActivated()
241         isHuman()
242         isWithinLimits(msg.value)
243         public
244         payable
245     {
246         // set up our tx event data and determine if player is new or not
247         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
248         
249         // fetch player id
250         uint256 _pID = pIDxAddr_[msg.sender];
251         
252         // buy core 
253         buyCore(_pID, _eventData_);
254     }
255     
256     function buyXname()
257         isActivated()
258         isHuman()
259         isWithinLimits(msg.value)
260         public
261         payable
262     {
263         // set up our tx event data and determine if player is new or not
264         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
265         
266         // fetch player id
267         uint256 _pID = pIDxAddr_[msg.sender];
268         
269         // buy core 
270         buyCore(_pID, _eventData_);
271     }
272     
273     /**
274      * @dev essentially the same as buy, but instead of you sending ether 
275      * from your wallet, it uses your unwithdrawn earnings.
276      * @param _eth amount of earnings to use (remainder returned to gen vault)
277      */
278     function reLoadXid(uint256 _eth)
279         isActivated()
280         isHuman()
281         isWithinLimits(_eth)
282         public
283     {
284         // set up our tx event data
285         F3Ddatasets.EventReturns memory _eventData_;
286         
287         // fetch player ID
288         uint256 _pID = pIDxAddr_[msg.sender];
289 
290         // reload core
291         reLoadCore(_pID, _eth, _eventData_);
292     }
293     
294     function reLoadXaddr(uint256 _eth)
295         isActivated()
296         isHuman()
297         isWithinLimits(_eth)
298         public
299     {
300         // set up our tx event data
301         F3Ddatasets.EventReturns memory _eventData_;
302         
303         // fetch player ID
304         uint256 _pID = pIDxAddr_[msg.sender];
305         
306         // reload core
307         reLoadCore(_pID, _eth, _eventData_);
308     }
309     
310     function reLoadXname(uint256 _eth)
311         isActivated()
312         isHuman()
313         isWithinLimits(_eth)
314         public
315     {
316         // set up our tx event data
317         F3Ddatasets.EventReturns memory _eventData_;
318         
319         // fetch player ID
320         uint256 _pID = pIDxAddr_[msg.sender];
321     
322         // reload core
323         reLoadCore(_pID, _eth, _eventData_);
324     }
325 
326     /**
327      * @dev withdraws all of your earnings.
328      * -functionhash- 0x3ccfd60b
329      */
330     function withdraw()
331         isActivated()
332         isHuman()
333         public
334     {
335         // setup local rID 
336         uint256 _rID = rID_;
337         
338         // grab time
339         uint256 _now = now;
340         
341         // fetch player ID
342         uint256 _pID = pIDxAddr_[msg.sender];
343         
344         // setup temp var for player eth
345         uint256 _eth;
346         
347         // check to see if round has ended and no one has run round end yet
348         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
349         {
350             // set up our tx event data
351             F3Ddatasets.EventReturns memory _eventData_;
352             
353             // end the round (distributes pot)
354 	        round_[_rID].ended = true;
355             _eventData_ = endRound(_eventData_);
356             
357 			// get their earnings
358             _eth = withdrawEarnings(_pID);
359             
360             // gib moni
361             if (_eth > 0)
362                 plyr_[_pID].addr.transfer(_eth);    
363             
364             // build event data
365             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
366             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
367             
368             // fire withdraw and distribute event
369             emit F3Devents.onWithdrawAndDistribute
370             (
371                 msg.sender, 
372                 plyr_[_pID].name, 
373                 _eth, 
374                 _eventData_.compressedData, 
375                 _eventData_.compressedIDs, 
376                 _eventData_.winnerAddr, 
377                 _eventData_.winnerName, 
378                 _eventData_.amountWon, 
379                 _eventData_.devAmount, 
380                 _eventData_.genAmount
381             );
382             
383         // in any other situation
384         } else {
385             // get their earnings
386             _eth = withdrawEarnings(_pID);
387             
388             // gib moni
389             if (_eth > 0)
390                 plyr_[_pID].addr.transfer(_eth);
391             
392             // fire withdraw event
393             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
394         }
395     }
396     
397     /**
398      * @dev use these to register names.  they are just wrappers that will send the
399      * registration requests to the PlayerBook contract.  So registering here is the 
400      * same as registering there.  UI will always display the last name you registered.
401      * - must pay a registration fee.
402      * - name must be unique
403      * - names will be converted to lowercase
404      * - name cannot start or end with a space 
405      * - cannot have more than 1 space in a row
406      * - cannot be only numbers
407      * - cannot start with 0x 
408      * - name must be at least 1 char
409      * - max length of 32 characters long
410      * - allowed characters: a-z, 0-9, and space
411      * @param _nameString players desired name
412      * @param _all set to true if you want this to push your info to all games 
413      * (this might cost a lot of gas)
414      */
415     function registerNameXID(string _nameString, bool _all)
416         isHuman()
417         public
418         payable
419     {
420         bytes32 _name = _nameString.nameFilter();
421         address _addr = msg.sender;
422         uint256 _paid = msg.value;
423         bool _isNewPlayer = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _all);
424         
425         uint256 _pID = pIDxAddr_[_addr];
426         
427         // fire event
428         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _paid, now);
429     }
430     
431     function registerNameXaddr(string _nameString, bool _all)
432         isHuman()
433         public
434         payable
435     {
436         bytes32 _name = _nameString.nameFilter();
437         address _addr = msg.sender;
438         uint256 _paid = msg.value;
439         bool _isNewPlayer = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _all);
440         
441         uint256 _pID = pIDxAddr_[_addr];
442         
443         // fire event
444         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _paid, now);
445     }
446     
447     function registerNameXname(string _nameString, bool _all)
448         isHuman()
449         public
450         payable
451     {
452         bytes32 _name = _nameString.nameFilter();
453         address _addr = msg.sender;
454         uint256 _paid = msg.value;
455         bool _isNewPlayer = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _all);
456         
457         uint256 _pID = pIDxAddr_[_addr];
458         
459         // fire event
460         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _paid, now);
461     }
462 //==============================================================================
463 //     _  _ _|__|_ _  _ _  .
464 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
465 //=====_|=======================================================================
466     /**
467      * @dev return the price buyer will pay for next 1 individual key.
468      * -functionhash- 0x018a25e8
469      * @return price for next key bought (in wei format)
470      */
471     function getBuyPrice()
472         public 
473         view 
474         returns(uint256)
475     {  
476         // setup local rID
477         uint256 _rID = rID_;
478         
479         // grab time
480         uint256 _now = now;
481         
482         // are we in a round?
483         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
484             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
485         else // rounds over.  need price for new round
486             return ( 75000000000000 ); // init
487     }
488     
489     /**
490      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
491      * provider
492      * -functionhash- 0xc7e284b8
493      * @return time left in seconds
494      */
495     function getTimeLeft()
496         public
497         view
498         returns(uint256)
499     {
500         // setup local rID
501         uint256 _rID = rID_;
502         
503         // grab time
504         uint256 _now = now;
505         
506         if (_now < round_[_rID].end)
507             if (_now > round_[_rID].strt)
508                 return( (round_[_rID].end).sub(_now) );
509             else
510                 return( (round_[_rID].strt).sub(_now) );
511         else
512             return(0);
513     }
514     
515     /**
516      * @dev returns player earnings per vaults 
517      * -functionhash- 0x63066434
518      * @return winnings vault
519      * @return general vault
520      */
521     function getPlayerVaults(uint256 _pID)
522         public
523         view
524         returns(uint256 ,uint256)
525     {
526         // setup local rID
527         uint256 _rID = rID_;
528         
529         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
530         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
531         {
532             return
533             (
534                 plyr_[_pID].win,
535                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  )
536             );
537         // if round is still going on, or round has ended and round end has been ran
538         } else {
539             return
540             (
541                 plyr_[_pID].win,
542                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd))
543             );
544         }
545     }
546     
547     /**
548      * solidity hates stack limits.  this lets us avoid that hate 
549      */
550     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
551         private
552         view
553         returns(uint256)
554     {
555         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(50)).div(100)).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
556     }
557     
558     /**
559      * @dev returns all current round info needed for front end
560      * -functionhash- 0x747dff42
561      * @return eth invested during ICO phase
562      * @return round id 
563      * @return total keys for round 
564      * @return time round ends
565      * @return time round started
566      * @return current pot 
567      * @return player ID in lead 
568      * @return current player in leads address 
569      * @return current player in leads name
570      */
571     function getCurrentRoundInfo()
572         public
573         view
574         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32)
575     {
576         // setup local rID
577         uint256 _rID = rID_;
578         
579         return
580         (
581             round_[_rID].ico,               //0
582             _rID,                           //1
583             round_[_rID].keys,              //2
584             round_[_rID].end,               //3
585             round_[_rID].strt,              //4
586             round_[_rID].pot,               //5
587             (round_[_rID].plyr * 10),     //6
588             plyr_[round_[_rID].plyr].addr,  //7
589             plyr_[round_[_rID].plyr].name  //8
590         );
591     }
592 
593     /**
594      * @dev returns player info based on address.  if no address is given, it will 
595      * use msg.sender 
596      * -functionhash- 0xee0b5d8b
597      * @param _addr address of the player you want to lookup 
598      * @return player ID 
599      * @return player name
600      * @return keys owned (current round)
601      * @return winnings vault
602      * @return general vault 
603 	 * @return player round eth
604      */
605     function getPlayerInfoByAddress(address _addr)
606         public 
607         view 
608         returns(uint256, bytes32, uint256, uint256, uint256, uint256)
609     {
610         // setup local rID
611         uint256 _rID = rID_;
612         
613         if (_addr == address(0))
614         {
615             _addr == msg.sender;
616         }
617         uint256 _pID = pIDxAddr_[_addr];
618         
619         return
620         (
621             _pID,                               //0
622             plyr_[_pID].name,                   //1
623             plyrRnds_[_pID][_rID].keys,         //2
624             plyr_[_pID].win,                    //3
625             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
626             plyrRnds_[_pID][_rID].eth           //5
627         );
628     }
629 
630 //==============================================================================
631 //     _ _  _ _   | _  _ . _  .
632 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
633 //=====================_|=======================================================
634     /**
635      * @dev logic runs whenever a buy order is executed.  determines how to handle 
636      * incoming eth depending on if we are in an active round or not
637      */
638     function buyCore(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
639         private
640     {
641         // setup local rID
642         uint256 _rID = rID_;
643         
644         // grab time
645         uint256 _now = now;
646         
647         // if round is active
648         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
649         {
650             // call core 
651             core(_rID, _pID, msg.value, _eventData_);
652         
653         // if round is not active     
654         } else {
655             // check to see if end round needs to be ran
656             if (_now > round_[_rID].end && round_[_rID].ended == false) 
657             {
658                 // end the round (distributes pot) & start new round
659 			    round_[_rID].ended = true;
660                 _eventData_ = endRound(_eventData_);
661                 
662                 // build event data
663                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
664                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
665                 
666                 // fire buy and distribute event 
667                 emit F3Devents.onBuyAndDistribute
668                 (
669                     msg.sender, 
670                     plyr_[_pID].name, 
671                     msg.value, 
672                     _eventData_.compressedData, 
673                     _eventData_.compressedIDs, 
674                     _eventData_.winnerAddr, 
675                     _eventData_.winnerName, 
676                     _eventData_.amountWon, 
677                     _eventData_.devAmount, 
678                     _eventData_.genAmount
679                 );
680             }
681             
682             // put eth in players vault 
683             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
684         }
685     }
686     
687     /**
688      * @dev logic runs whenever a reload order is executed.  determines how to handle 
689      * incoming eth depending on if we are in an active round or not 
690      */
691     function reLoadCore(uint256 _pID, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
692         private
693     {
694         // setup local rID
695         uint256 _rID = rID_;
696         
697         // grab time
698         uint256 _now = now;
699         
700         // if round is active
701         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
702         {
703             // get earnings from all vaults and return unused to gen vault
704             // because we use a custom safemath library.  this will throw if player 
705             // tried to spend more eth than they have.
706             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
707             
708             // call core 
709             core(_rID, _pID, _eth, _eventData_);
710         
711         // if round is not active and end round needs to be ran   
712         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
713             // end the round (distributes pot) & start new round
714             round_[_rID].ended = true;
715             _eventData_ = endRound(_eventData_);
716                 
717             // build event data
718             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
719             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
720                 
721             // fire buy and distribute event 
722             emit F3Devents.onReLoadAndDistribute
723             (
724                 msg.sender, 
725                 plyr_[_pID].name, 
726                 _eventData_.compressedData, 
727                 _eventData_.compressedIDs, 
728                 _eventData_.winnerAddr, 
729                 _eventData_.winnerName, 
730                 _eventData_.amountWon, 
731                 _eventData_.devAmount, 
732                 _eventData_.genAmount
733             );
734         }
735     }
736     
737     /**
738      * @dev this is the core logic for any buy/reload that happens while a round 
739      * is live.
740      */
741     function core(uint256 _rID, uint256 _pID, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
742         private
743     {
744         // if player is new to round
745         if (plyrRnds_[_pID][_rID].keys == 0)
746             _eventData_ = managePlayer(_pID, _eventData_);
747         
748         // early round eth limiter 
749         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
750         {
751             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
752             uint256 _refund = _eth.sub(_availableLimit);
753             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
754             _eth = _availableLimit;
755         }
756         
757         // if eth left is greater than min eth allowed (sorry no pocket lint)
758         if (_eth > 1000000000) 
759         {
760             
761             // mint the new keys
762             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
763             
764             // if they bought at least 1 whole key
765             if (_keys >= 1000000000000000000)
766             {
767             updateTimer(_keys, _rID);
768 
769             // set new leaders
770             if (round_[_rID].plyr != _pID)
771                 round_[_rID].plyr = _pID;
772             
773             // set the new leader bool to true
774             _eventData_.compressedData = _eventData_.compressedData + 100;
775         }
776             
777             // update player 
778             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
779             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
780             
781             // update round
782             round_[_rID].keys = _keys.add(round_[_rID].keys);
783             round_[_rID].eth = _eth.add(round_[_rID].eth);
784     
785             // distribute eth
786             _eventData_ = distributeExternal(_eth, _eventData_);
787             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
788             
789             // call end tx function to fire end tx event.
790 		    endTx(_pID, _eth, _keys, _eventData_);
791         }
792     }
793 //==============================================================================
794 //     _ _ | _   | _ _|_ _  _ _  .
795 //    (_(_||(_|_||(_| | (_)| _\  .
796 //==============================================================================
797     /**
798      * @dev calculates unmasked earnings (just calculates, does not update mask)
799      * @return earnings in wei format
800      */
801     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
802         private
803         view
804         returns(uint256)
805     {   
806         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
807     }
808     
809     /** 
810      * @dev returns the amount of keys you would get given an amount of eth. 
811      * -functionhash- 0xce89c80c
812      * @param _rID round ID you want price for
813      * @param _eth amount of eth sent in 
814      * @return keys received 
815      */
816     function calcKeysReceived(uint256 _rID, uint256 _eth)
817         public
818         view
819         returns(uint256)
820     {
821         // grab time
822         uint256 _now = now;
823         
824         // are we in a round?
825         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
826             return ( (round_[_rID].eth).keysRec(_eth) );
827         else // rounds over.  need keys for new round
828             return ( (_eth).keys() );
829     }
830     
831     /** 
832      * @dev returns current eth price for X keys.  
833      * -functionhash- 0xcf808000
834      * @param _keys number of keys desired (in 18 decimal format)
835      * @return amount of eth needed to send
836      */
837     function iWantXKeys(uint256 _keys)
838         public
839         view
840         returns(uint256)
841     {
842         // setup local rID
843         uint256 _rID = rID_;
844         
845         // grab time
846         uint256 _now = now;
847         
848         // are we in a round?
849         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
850             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
851         else // rounds over.  need price for new round
852             return ( (_keys).eth() );
853     }
854 //==============================================================================
855 //    _|_ _  _ | _  .
856 //     | (_)(_)|_\  .
857 //==============================================================================
858     /**
859 	 * @dev receives name/player info from names contract 
860      */
861     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name)
862         external
863     {
864         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
865         if (pIDxAddr_[_addr] != _pID)
866             pIDxAddr_[_addr] = _pID;
867         if (pIDxName_[_name] != _pID)
868             pIDxName_[_name] = _pID;
869         if (plyr_[_pID].addr != _addr)
870             plyr_[_pID].addr = _addr;
871         if (plyr_[_pID].name != _name)
872             plyr_[_pID].name = _name;
873         if (plyrNames_[_pID][_name] == false)
874             plyrNames_[_pID][_name] = true;
875     }
876     
877     /**
878      * @dev receives entire player name list 
879      */
880     function receivePlayerNameList(uint256 _pID, bytes32 _name)
881         external
882     {
883         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
884         if(plyrNames_[_pID][_name] == false)
885             plyrNames_[_pID][_name] = true;
886     }   
887         
888     /**
889      * @dev gets existing or registers new pID.  use this when a player may be new
890      * @return pID 
891      */
892     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
893         private
894         returns (F3Ddatasets.EventReturns)
895     {
896         uint256 _pID = pIDxAddr_[msg.sender];
897         // if player is new to this version of fomo3dx
898         if (_pID == 0)
899         {
900             // grab their player ID, name, from player names contract 
901             _pID = PlayerBook.getPlayerID(msg.sender);
902             bytes32 _name = PlayerBook.getPlayerName(_pID);
903             
904             // set up player account 
905             pIDxAddr_[msg.sender] = _pID;
906             plyr_[_pID].addr = msg.sender;
907             
908             if (_name != "")
909             {
910                 pIDxName_[_name] = _pID;
911                 plyr_[_pID].name = _name;
912                 plyrNames_[_pID][_name] = true;
913             }
914             
915             // set the new player bool to true
916             _eventData_.compressedData = _eventData_.compressedData + 1;
917         } 
918         return (_eventData_);
919     }
920     
921     /**
922      * @dev decides if round end needs to be run & new round started.  and if 
923      * player unmasked earnings from previously played rounds need to be moved.
924      */
925     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
926         private
927         returns (F3Ddatasets.EventReturns)
928     {
929         // if player has played a previous round, move their unmasked earnings
930         // from that round to gen vault.
931         if (plyr_[_pID].lrnd != 0)
932             updateGenVault(_pID, plyr_[_pID].lrnd);
933             
934         // update player's last round played
935         plyr_[_pID].lrnd = rID_;
936             
937         // set the joined round bool to true
938         _eventData_.compressedData = _eventData_.compressedData + 10;
939         
940         return(_eventData_);
941     }
942     
943     /**
944      * @dev ends the round. manages paying out winner/splitting up pot
945      */
946     function endRound(F3Ddatasets.EventReturns memory _eventData_)
947         private
948         returns (F3Ddatasets.EventReturns)
949     {
950         // setup local rID
951         uint256 _rID = rID_;
952         
953         // grab our winning player
954         uint256 _winPID = round_[_rID].plyr;
955         
956         // grab our pot amount
957         uint256 _pot = round_[_rID].pot;
958         
959         // calculate our winner share and developer rewards
960         uint256 _win = (_pot.mul(potSplit_.win)).div(100); // 40% to winner
961         uint256 _dev = (_pot.mul(potSplit_.dev)).div(100); // 10% to dev rewards
962         _pot = (_pot.sub(_win)).sub(_dev); // calc remaining amount to pot
963 
964         // pay out to official then transfer to winner
965         AwardPool.transfer(_win);
966 
967         // pay our developer
968         DeveloperRewards.transfer(_dev);
969 
970         // ended this pot
971         AwardPool.transfer(_pot);
972 
973         // prepare event data
974         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
975         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
976         _eventData_.winnerAddr = plyr_[_winPID].addr;
977         _eventData_.winnerName = plyr_[_winPID].name;
978         _eventData_.amountWon = _win;
979         _eventData_.potAmount = _pot;
980         _eventData_.devAmount = _dev;
981         
982         // start next round
983         rID_++;
984         _rID++;
985         round_[_rID].strt = now;
986         round_[_rID].end = now.add(rndInit_);
987         
988         return(_eventData_);
989     }
990     
991     /**
992      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
993      */
994     function updateGenVault(uint256 _pID, uint256 _rIDlast)
995         private 
996     {
997         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
998         if (_earnings > 0)
999         {
1000             // put in gen vault
1001             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1002             // zero out their earnings by updating mask
1003             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1004         }
1005     }
1006     
1007     /**
1008      * @dev updates round timer based on number of whole keys bought.
1009      */
1010     function updateTimer(uint256 _keys, uint256 _rID)
1011         private
1012     {
1013         // grab time
1014         uint256 _now = now;
1015         
1016         // calculate time based on number of keys bought
1017         uint256 _newTime;
1018         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1019             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1020         else
1021             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1022         
1023         // compare to max and set new end time
1024         if (_newTime < (rndMax_).add(_now))
1025             round_[_rID].end = _newTime;
1026         else
1027             round_[_rID].end = rndMax_.add(_now);
1028     }
1029 
1030     /**
1031      * @dev distributes eth based on fees to dev
1032      */
1033     function distributeExternal(uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1034         private
1035         returns(F3Ddatasets.EventReturns)
1036     {
1037         // pay 10% out to developer rewards
1038         uint256 _dev = (_eth.mul(fees_.dev)).div(100);
1039         
1040         // transfer to developer rewards contract
1041         DeveloperRewards.transfer(_dev);
1042 
1043         // set up event data
1044         _eventData_.devAmount = _dev.add(_eventData_.devAmount);
1045         
1046         return(_eventData_);
1047     }
1048     
1049     /**
1050      * @dev distributes eth based on fees to gen and pot
1051      */
1052     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1053         private
1054         returns(F3Ddatasets.EventReturns)
1055     {
1056         // calculate gen share
1057         uint256 _gen = (_eth.mul(fees_.gen)).div(100);
1058         
1059         // update eth balance (eth = eth - dev share)
1060         _eth = _eth.sub((_eth.mul(fees_.dev)).div(100));
1061         
1062         // calculate pot 
1063         uint256 _pot = _eth.sub(_gen);
1064         
1065         // distribute gen share (thats what updateMasks() does) and adjust
1066         // balances for dust.
1067         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1068         if (_dust > 0)
1069             _gen = _gen.sub(_dust);
1070         
1071         // add eth to pot
1072         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1073         
1074         // set up event data
1075         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1076         _eventData_.potAmount = _pot;
1077         
1078         return(_eventData_);
1079     }
1080 
1081     /**
1082      * @dev updates masks for round and player when keys are bought
1083      * @return dust left over 
1084      */
1085     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1086         private
1087         returns(uint256)
1088     {
1089         /* MASKING NOTES
1090             earnings masks are a tricky thing for people to wrap their minds around.
1091             the basic thing to understand here.  is were going to have a global
1092             tracker based on profit per share for each round, that increases in
1093             relevant proportion to the increase in share supply.
1094             
1095             the player will have an additional mask that basically says "based
1096             on the rounds mask, my shares, and how much i've already withdrawn,
1097             how much is still owed to me?"
1098         */
1099 
1100         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1101         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1102         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1103             
1104         // calculate player earning from their own buy (only based on the keys
1105         // they just bought).  & update player earnings mask
1106         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1107         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1108         
1109         // calculate & return dust
1110         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1111     }
1112     
1113     /**
1114      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1115      * @return earnings in wei format
1116      */
1117     function withdrawEarnings(uint256 _pID)
1118         private
1119         returns(uint256)
1120     {
1121         // update gen vault
1122         updateGenVault(_pID, plyr_[_pID].lrnd);
1123         
1124         // from vaults 
1125         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen);
1126         if (_earnings > 0)
1127         {
1128             plyr_[_pID].win = 0;
1129             plyr_[_pID].gen = 0;
1130         }
1131 
1132         return(_earnings);
1133     }
1134     
1135     /**
1136      * @dev prepares compression data and fires event for buy or reload tx's
1137      */
1138     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1139         private
1140     {
1141         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
1142         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1143         
1144         emit F3Devents.onEndTx
1145         (
1146             _eventData_.compressedData,
1147             _eventData_.compressedIDs,
1148             plyr_[_pID].name,
1149             msg.sender,
1150             _eth,
1151             _keys,
1152             _eventData_.winnerAddr,
1153             _eventData_.winnerName,
1154             _eventData_.amountWon,
1155             _eventData_.devAmount,
1156             _eventData_.genAmount,
1157             _eventData_.potAmount
1158         );
1159     }
1160 //==============================================================================
1161 //    (~ _  _    _._|_    .
1162 //    _)(/_(_|_|| | | \/  .
1163 //====================/=========================================================
1164     /** upon contract deploy, it will be deactivated.  this is a one time
1165      * use function that will activate the contract.  we do this so devs 
1166      * have time to set things up on the web end                            **/
1167     bool public activated_ = false;
1168     function activate()
1169         public
1170     {
1171         // only team can activate 
1172         require(msg.sender == 0x4a1061afb0af7d9f6c2d545ada068da68052c060, "only team can activate");
1173         
1174         // can only be ran once
1175         require(activated_ == false, "fomo3dx already activated");
1176         
1177         // activate the contract 
1178         activated_ = true;
1179         
1180         // lets start first round
1181 		rID_ = 1;
1182         round_[1].strt = now;
1183         round_[1].end = now + rndInit_;
1184     }
1185 }
1186 
1187 //==============================================================================
1188 //   __|_ _    __|_ _  .
1189 //  _\ | | |_|(_ | _\  .
1190 //==============================================================================
1191 library F3Ddatasets {
1192     //compressedData key
1193     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1194         // 0 - new player (bool)
1195         // 1 - joined round (bool)
1196         // 2 - new  leader (bool)
1197         // 6-16 - round end time
1198         // 17 - winnerTeam
1199         // 18 - 28 timestamp 
1200         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1201     //compressedIDs key
1202     // [77-52][51-26][25-0]
1203         // 0-25 - pID 
1204         // 26-51 - winPID
1205         // 52-77 - rID
1206     struct EventReturns {
1207         uint256 compressedData;
1208         uint256 compressedIDs;
1209         address winnerAddr;         // winner address
1210         bytes32 winnerName;         // winner name
1211         uint256 amountWon;          // amount won
1212         uint256 devAmount;          // amount distributed to dev
1213         uint256 genAmount;          // amount distributed to gen
1214         uint256 potAmount;          // amount added to pot
1215     }
1216     struct Player {
1217         address addr;   // player address
1218         bytes32 name;   // player name
1219         uint256 win;    // winnings vault
1220         uint256 gen;    // general vault
1221         uint256 lrnd;   // last round played
1222     }
1223     struct PlayerRounds {
1224         uint256 eth;    // eth player has added to round (used for eth limiter)
1225         uint256 keys;   // keys
1226         uint256 mask;   // player mask 
1227         uint256 ico;    // ICO phase investment
1228     }
1229     struct Round {
1230         uint256 plyr;   // pID of player in lead
1231         uint256 end;    // time ends/ended
1232         bool ended;     // has round end function been ran
1233         uint256 strt;   // time round started
1234         uint256 keys;   // keys
1235         uint256 eth;    // total eth in
1236         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1237         uint256 mask;   // global mask
1238         uint256 ico;    // total eth sent in during ICO phase
1239         uint256 icoGen; // total eth for gen during ICO phase
1240         uint256 icoAvg; // average key price for ICO phase
1241     }
1242     struct KeyFee {
1243         uint256 gen;    // % of buy in thats paid to key holders of current round
1244         uint256 dev;    // % of buy in thats paid to develper
1245     }
1246     struct PotSplit {
1247         uint256 win;    // % of pot thats paid to winner of current round
1248         uint256 dev;    // % of pot thats paid to developer
1249     }
1250 }
1251 
1252 //==============================================================================
1253 //  |  _      _ _ | _  .
1254 //  |<(/_\/  (_(_||(_  .
1255 //=======/======================================================================
1256 library F3DKeysCalcLong {
1257     using SafeMath for *;
1258     /**
1259      * @dev calculates number of keys received given X eth 
1260      * @param _curEth current amount of eth in contract 
1261      * @param _newEth eth being spent
1262      * @return amount of ticket purchased
1263      */
1264     function keysRec(uint256 _curEth, uint256 _newEth)
1265         internal
1266         pure
1267         returns (uint256)
1268     {
1269         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1270     }
1271     
1272     /**
1273      * @dev calculates amount of eth received if you sold X keys 
1274      * @param _curKeys current amount of keys that exist 
1275      * @param _sellKeys amount of keys you wish to sell
1276      * @return amount of eth received
1277      */
1278     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1279         internal
1280         pure
1281         returns (uint256)
1282     {
1283         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1284     }
1285 
1286     /**
1287      * @dev calculates how many keys would exist with given an amount of eth
1288      * @param _eth eth "in contract"
1289      * @return number of keys that would exist
1290      */
1291     function keys(uint256 _eth) 
1292         internal
1293         pure
1294         returns(uint256)
1295     {
1296         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1297     }
1298     
1299     /**
1300      * @dev calculates how much eth would be in contract given a number of keys
1301      * @param _keys number of keys "in contract" 
1302      * @return eth that would exists
1303      */
1304     function eth(uint256 _keys) 
1305         internal
1306         pure
1307         returns(uint256)  
1308     {
1309         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1310     }
1311 }
1312 
1313 //==============================================================================
1314 //  . _ _|_ _  _ |` _  _ _  _  .
1315 //  || | | (/_| ~|~(_|(_(/__\  .
1316 //==============================================================================
1317 interface PlayerBookInterface {
1318     function getPlayerID(address _addr) external returns (uint256);
1319     function getPlayerName(uint256 _pID) external view returns (bytes32);
1320     function getPlayerAddr(uint256 _pID) external view returns (address);
1321     function getNameFee() external view returns (uint256);
1322     function registerNameXIDFromDapp(address _addr, bytes32 _name, bool _all) external payable returns(bool);
1323     function registerNameXaddrFromDapp(address _addr, bytes32 _name, bool _all) external payable returns(bool);
1324     function registerNameXnameFromDapp(address _addr, bytes32 _name, bool _all) external payable returns(bool);
1325 }
1326 
1327 /**
1328 * @title -Name Filter- beta
1329 */
1330 library NameFilter {
1331     /**
1332      * @dev filters name strings
1333      * -converts uppercase to lower case.  
1334      * -makes sure it does not start/end with a space
1335      * -makes sure it does not contain multiple spaces in a row
1336      * -cannot be only numbers
1337      * -cannot start with 0x 
1338      * -restricts characters to A-Z, a-z, 0-9, and space.
1339      * @return reprocessed string in bytes32 format
1340      */
1341     function nameFilter(string _input)
1342         internal
1343         pure
1344         returns(bytes32)
1345     {
1346         bytes memory _temp = bytes(_input);
1347         uint256 _length = _temp.length;
1348         
1349         //sorry limited to 32 characters
1350         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1351         // make sure it doesnt start with or end with space
1352         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1353         // make sure first two characters are not 0x
1354         if (_temp[0] == 0x30)
1355         {
1356             require(_temp[1] != 0x78, "string cannot start with 0x");
1357             require(_temp[1] != 0x58, "string cannot start with 0X");
1358         }
1359         
1360         // create a bool to track if we have a non number character
1361         bool _hasNonNumber;
1362         
1363         // convert & check
1364         for (uint256 i = 0; i < _length; i++)
1365         {
1366             // if its uppercase A-Z
1367             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1368             {
1369                 // convert to lower case a-z
1370                 _temp[i] = byte(uint(_temp[i]) + 32);
1371                 
1372                 // we have a non number
1373                 if (_hasNonNumber == false)
1374                     _hasNonNumber = true;
1375             } else {
1376                 require
1377                 (
1378                     // require character is a space
1379                     _temp[i] == 0x20 || 
1380                     // OR lowercase a-z
1381                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1382                     // or 0-9
1383                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1384                     "string contains invalid characters"
1385                 );
1386                 // make sure theres not 2x spaces in a row
1387                 if (_temp[i] == 0x20)
1388                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1389                 
1390                 // see if we have a character other than a number
1391                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1392                     _hasNonNumber = true;    
1393             }
1394         }
1395         
1396         require(_hasNonNumber == true, "string cannot be only numbers");
1397         
1398         bytes32 _ret;
1399         assembly {
1400             _ret := mload(add(_temp, 32))
1401         }
1402         return (_ret);
1403     }
1404 }
1405 
1406 /**
1407  * @title SafeMath
1408  * @dev Math operations with safety checks that throw on error
1409  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1410  * - added sqrt
1411  * - added sq
1412  * - added pwr 
1413  * - changed asserts to requires with error log outputs
1414  */
1415 library SafeMath {
1416     
1417     /**
1418     * @dev Multiplies two numbers, throws on overflow.
1419     */
1420     function mul(uint256 a, uint256 b) 
1421         internal 
1422         pure 
1423         returns (uint256 c) 
1424     {
1425         if (a == 0) {
1426             return 0;
1427         }
1428         c = a * b;
1429         require(c / a == b, "SafeMath mul failed");
1430         return c;
1431     }
1432 
1433     /**
1434     * @dev Integer division of two numbers, truncating the quotient.
1435     */
1436     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1437         require(b > 0); // Solidity only automatically asserts when dividing by 0
1438         uint256 c = a / b;
1439         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1440         return c;
1441     }
1442     
1443     /**
1444     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1445     */
1446     function sub(uint256 a, uint256 b)
1447         internal
1448         pure
1449         returns (uint256) 
1450     {
1451         require(b <= a, "SafeMath sub failed");
1452         return a - b;
1453     }
1454 
1455     /**
1456     * @dev Adds two numbers, throws on overflow.
1457     */
1458     function add(uint256 a, uint256 b)
1459         internal
1460         pure
1461         returns (uint256 c) 
1462     {
1463         c = a + b;
1464         require(c >= a, "SafeMath add failed");
1465         return c;
1466     }
1467     
1468     /**
1469      * @dev gives square root of given x.
1470      */
1471     function sqrt(uint256 x)
1472         internal
1473         pure
1474         returns (uint256 y) 
1475     {
1476         uint256 z = ((add(x,1)) / 2);
1477         y = x;
1478         while (z < y) 
1479         {
1480             y = z;
1481             z = ((add((x / z),z)) / 2);
1482         }
1483     }
1484     
1485     /**
1486      * @dev gives square. multiplies x by x
1487      */
1488     function sq(uint256 x)
1489         internal
1490         pure
1491         returns (uint256)
1492     {
1493         return (mul(x,x));
1494     }
1495     
1496     /**
1497      * @dev x to the power of y 
1498      */
1499     function pwr(uint256 x, uint256 y)
1500         internal 
1501         pure 
1502         returns (uint256)
1503     {
1504         if (x==0)
1505             return (0);
1506         else if (y==0)
1507             return (1);
1508         else 
1509         {
1510             uint256 z = x;
1511             for (uint256 i=1; i < y; i++)
1512                 z = mul(z,x);
1513             return (z);
1514         }
1515     }
1516 
1517     /**
1518     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1519     * reverts when dividing by zero.
1520     */
1521     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1522         require(b != 0);
1523         return a % b;
1524     }
1525 }