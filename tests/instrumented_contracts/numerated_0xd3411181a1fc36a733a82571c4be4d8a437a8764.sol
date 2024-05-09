1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title -LuckyStar v0.0.1
5  *
6  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
7  */
8 
9 contract PlayerBook {
10     using NameFilter for string;
11     using SafeMath for *;
12     address private admin = msg.sender;
13     //address community=address(0x465b31ae487c4e6cede5f98a72472f1a6a81c826);
14     uint256 public registrationFee_ = 10 finney;
15     uint256 pIdx_=1;
16     uint256 public pID_;        // total number of players
17     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
18     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
19     mapping (uint256 => LSDatasets.Player) public plyr_;   // (pID => data) player data
20     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
21     //mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
22     modifier onlyOwner() {
23         require(msg.sender == admin);
24         _;
25     }
26     modifier isHuman() {
27         address _addr = msg.sender;
28         uint256 _codeLength;
29 
30         assembly {_codeLength := extcodesize(_addr)}
31         require(_codeLength == 0, "sorry humans only");
32         _;
33     }
34     function getPlayerID(address _addr)
35     public
36         returns (uint256)
37     {
38         determinePID(_addr);
39         return (pIDxAddr_[_addr]);
40     }
41     function getPlayerName(uint256 _pID)
42     public
43         view
44         returns (bytes32)
45     {
46         return (plyr_[_pID].name);
47     }
48     function getPlayerLAff(uint256 _pID)
49     public
50         view
51         returns (uint256)
52     {
53         return (plyr_[_pID].laff);
54     }
55     function getPlayerAddr(uint256 _pID)
56     public
57         view
58         returns (address)
59     {
60         return (plyr_[_pID].addr);
61     }
62     function getNameFee()
63     public
64         view
65         returns (uint256)
66     {
67         return(registrationFee_);
68     }
69     function determinePID(address _addr)
70         private
71         returns (bool)
72     {
73         if (pIDxAddr_[_addr] == 0)
74         {
75             pID_++;
76             pIDxAddr_[_addr] = pID_;
77             plyr_[pID_].addr = _addr;
78 
79             // set the new player bool to true
80             return (true);
81         } else {
82             return (false);
83         }
84     }
85 
86     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
87         isHuman()
88         public
89         payable
90     {
91         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
92         bytes32 _name = _nameString.nameFilter();
93         address _addr = msg.sender;
94 
95 
96         // set up our tx event data and determine if player is new or not
97         bool _isNewPlayer = determinePID(_addr);
98 
99         // fetch player id
100         uint256 _pID = pIDxAddr_[_addr];
101 
102         // manage affiliate residuals
103         // if no affiliate code was given or player tried to use their own, lolz
104         uint256 _affID;
105         if (_affCode != "" && _affCode != _name)
106         {
107             // get affiliate ID from aff Code
108             _affID = pIDxName_[_affCode];
109 
110             // if affID is not the same as previously stored
111             if (_affID != plyr_[_pID].laff)
112             {
113                 // update last affiliate
114                 plyr_[_pID].laff = _affID;
115             }
116         }
117 
118         // register name
119         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
120     }
121 
122     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer)
123         private
124     {
125         // if names already has been used, require that current msg sender owns the name
126         if (pIDxName_[_name] != 0)
127             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
128 
129         // add name to player profile, registry, and name book
130         plyr_[_pID].name = _name;
131         pIDxName_[_name] = _pID;
132         if (plyrNames_[_pID][_name] == false)
133         {
134             plyrNames_[_pID][_name] = true;
135         }
136 
137         // registration fee goes directly to community rewards
138         //admin.transfer(address(this).balance);
139         uint256 _paid=msg.value;
140         //plyr_[pIdx_].aff=_paid.add(plyr_[pIdx_].aff);
141         admin.transfer(_paid);
142 
143     }
144     function setSuper(address _addr,bool isSuper)
145      onlyOwner()
146      public{
147         uint256 _pID=pIDxAddr_[_addr];
148         if(_pID!=0){
149             plyr_[_pID].super=isSuper;
150         }else{
151             revert();
152         }
153     }
154 
155     function setRegistrationFee(uint256 _fee)
156       onlyOwner()
157         public{
158          registrationFee_ = _fee;
159     }
160 }
161 
162 contract LuckyStar is PlayerBook {
163     using SafeMath for *;
164     using NameFilter for string;
165     using LSKeysCalcShort for uint256;
166 
167 
168 
169 //==============================================================================
170 //     _ _  _  |`. _     _ _ |_ | _  _  .
171 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
172 //=================_|===========================================================
173     address private admin = msg.sender;
174 
175     string constant public name = "LuckyStar";
176     string constant public symbol = "LuckyStar";
177     uint256 constant gen_=55;
178     uint256 constant bigPrize_ =30;
179     uint256 public minBuyForPrize_=100 finney;
180     uint256 constant private rndInit_ = 3 hours;            // round timer starts at this  1H17m17s
181     uint256 constant private rndInc_ = 1 minutes;              // every full key purchased adds this much to the timer
182     uint256 constant private rndMax_ = 6 hours;             // max length a round timer can be  ；3Hours
183     uint256 constant private prizeTimeInc_= 1 days;
184     uint256 constant private stopTime_=1 hours;
185 //==============================================================================
186 //     _| _ _|_ _    _ _ _|_    _   .
187 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
188 //=============================|================================================
189     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
190     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
191     uint256 public rID_;    // round id number / total rounds that have happened
192 //****************
193 // PLAYER DATA
194 //****************
195     mapping (uint256 => uint256) public plyrOrders_; // plyCounter => pID
196     mapping (uint256 => uint256) public plyrForPrizeOrders_; // playCounter => pID
197     mapping (uint256 => mapping (uint256 => LSDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
198 
199 //****************
200 // ROUND DATA
201 //****************
202     mapping (uint256 => LSDatasets.Round) public round_;   // (rID => data) round data
203     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
204 //****************
205 
206 //==============================================================================
207 //     _ _  _  __|_ _    __|_ _  _  .
208 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
209 //==============================================================================
210     constructor()
211         public
212     {
213 		pIDxAddr_[address(0xc7FcAD2Ad400299a7690d5aa6d7295F9dDB7Fc33)] = 1;
214         plyr_[1].addr = address(0xc7FcAD2Ad400299a7690d5aa6d7295F9dDB7Fc33);
215         plyr_[1].name = "sumpunk";
216         plyr_[1].super=true;
217         pIDxName_["sumpunk"] = 1;
218         plyrNames_[1]["sumpunk"] = true;
219 
220         pIDxAddr_[address(0x2f52362c266c1Df356A2313F79E4bE4E7de281cc)] = 2;
221         plyr_[2].addr = address(0x2f52362c266c1Df356A2313F79E4bE4E7de281cc);
222         plyr_[2].name = "xiaokan";
223         plyr_[2].super=true;
224         pIDxName_["xiaokan"] = 2;
225         plyrNames_[1]["xiaokan"] = true;
226 
227         pIDxAddr_[address(0xA97F850B019871B7a356956f8b43255988d1578a)] = 3;
228         plyr_[3].addr = address(0xA97F850B019871B7a356956f8b43255988d1578a);
229         plyr_[3].name = "Mr Shen";
230         plyr_[3].super=true;
231         pIDxName_["Mr Shen"] = 3;
232         plyrNames_[3]["Mr Shen"] = true;
233 
234         pID_ = 3;
235 }
236 
237 //==============================================================================
238 //     _ _  _  _|. |`. _  _ _  .
239 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
240 //==============================================================================
241     /**
242      * @dev used to make sure no one can interact with contract until it has
243      * been activated.
244      */
245     modifier isActivated() {
246         require(activated_ == true, "its not ready yet.  check ?eta in discord");
247         _;
248     }
249 
250     /**
251      * @dev prevents contracts from interacting with fomo3d
252      */
253     modifier isHuman() {
254         address _addr = msg.sender;
255         uint256 _codeLength;
256 
257         assembly {_codeLength := extcodesize(_addr)}
258         require(_codeLength == 0, "sorry humans only");
259         _;
260     }
261 
262     /**
263      * @dev sets boundaries for incoming tx
264      */
265     modifier isWithinLimits(uint256 _eth) {
266         require(_eth >= 1000000000, "pocket lint: not a valid currency");
267         require(_eth <= 100000000000000000000000, "no vitalik, no");
268         _;
269     }
270 
271 //==============================================================================
272 //     _    |_ |. _   |`    _  __|_. _  _  _  .
273 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
274 //====|=========================================================================
275     /**
276      * @dev emergency buy uses last stored affiliate ID and team snek
277      */
278     function()
279         isActivated()
280         isHuman()
281         isWithinLimits(msg.value)
282         public
283         payable
284     {
285         // set up our tx event data and determine if player is new or not
286         LSDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
287 
288         // fetch player id
289         uint256 _pID = pIDxAddr_[msg.sender];
290 
291         // buy core
292         buyCore(_pID, plyr_[_pID].laff, 0, _eventData_);
293     }
294 
295     /**
296      * @dev converts all incoming ethereum to keys.
297      * -functionhash- 0x8f38f309 (using ID for affiliate)
298      * -functionhash- 0x98a0871d (using address for affiliate)
299      * -functionhash- 0xa65b37a1 (using name for affiliate)
300      * @param _affCode the ID/address/name of the player who gets the affiliate fee
301      * @param _team what team is the player playing for?
302      */
303     function buyXid(uint256 _affCode, uint256 _team)
304         isActivated()
305         isHuman()
306         isWithinLimits(msg.value)
307         public
308         payable
309     {
310         // set up our tx event data and determine if player is new or not
311         LSDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
312 
313         // fetch player id
314         uint256 _pID = pIDxAddr_[msg.sender];
315 
316         // manage affiliate residuals
317         // if no affiliate code was given or player tried to use their own, lolz
318         if (_affCode == 0 || _affCode == _pID)
319         {
320             // use last stored affiliate code
321             _affCode = plyr_[_pID].laff;
322 
323         // if affiliate code was given & its not the same as previously stored
324         } else if (_affCode != plyr_[_pID].laff) {
325             // update last affiliate
326             plyr_[_pID].laff = _affCode;
327         }
328 
329         // verify a valid team was selected
330         //_team = verifyTeam(_team);
331 
332         // buy core
333         buyCore(_pID, _affCode, _team, _eventData_);
334     }
335 
336     function buyXaddr(address _affCode, uint256 _team)
337         isActivated()
338         isHuman()
339         isWithinLimits(msg.value)
340         public
341         payable
342     {
343         // set up our tx event data and determine if player is new or not
344         LSDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
345 
346         // fetch player id
347         uint256 _pID = pIDxAddr_[msg.sender];
348 
349         // manage affiliate residuals
350         uint256 _affID;
351         // if no affiliate code was given or player tried to use their own, lolz
352         if (_affCode == address(0) || _affCode == msg.sender)
353         {
354             // use last stored affiliate code
355             _affID = plyr_[_pID].laff;
356 
357         // if affiliate code was given
358         } else {
359             // get affiliate ID from aff Code
360             _affID = pIDxAddr_[_affCode];
361 
362             // if affID is not the same as previously stored
363             if (_affID != plyr_[_pID].laff)
364             {
365                 // update last affiliate
366                 plyr_[_pID].laff = _affID;
367             }
368         }
369         // buy core
370         buyCore(_pID, _affID, _team, _eventData_);
371     }
372 
373     /**
374      * @dev essentially the same as buy, but instead of you sending ether
375      * from your wallet, it uses your unwithdrawn earnings.
376      * -functionhash- 0x349cdcac (using ID for affiliate)
377      * -functionhash- 0x82bfc739 (using address for affiliate)
378      * -functionhash- 0x079ce327 (using name for affiliate)
379      * @param _affCode the ID/address/name of the player who gets the affiliate fee
380      * @param _team what team is the player playing for?
381      * @param _eth amount of earnings to use (remainder returned to gen vault)
382      */
383     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
384         isActivated()
385         isHuman()
386         isWithinLimits(_eth)
387         public
388     {
389         // set up our tx event data
390         LSDatasets.EventReturns memory _eventData_;
391 
392         // fetch player ID
393         uint256 _pID = pIDxAddr_[msg.sender];
394 
395         // manage affiliate residuals
396         // if no affiliate code was given or player tried to use their own, lolz
397         if (_affCode == 0 || _affCode == _pID)
398         {
399             // use last stored affiliate code
400             _affCode = plyr_[_pID].laff;
401 
402         // if affiliate code was given & its not the same as previously stored
403         } else if (_affCode != plyr_[_pID].laff) {
404             // update last affiliate
405             plyr_[_pID].laff = _affCode;
406         }
407 
408         // verify a valid team was selected
409         //_team = verifyTeam(_team);
410 
411         // reload core
412         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
413     }
414 
415     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
416         isActivated()
417         isHuman()
418         isWithinLimits(_eth)
419         public
420     {
421         // set up our tx event data
422         LSDatasets.EventReturns memory _eventData_;
423 
424         // fetch player ID
425         uint256 _pID = pIDxAddr_[msg.sender];
426 
427         // manage affiliate residuals
428         uint256 _affID;
429         // if no affiliate code was given or player tried to use their own, lolz
430         if (_affCode == address(0) || _affCode == msg.sender)
431         {
432             // use last stored affiliate code
433             _affID = plyr_[_pID].laff;
434 
435         // if affiliate code was given
436         } else {
437             // get affiliate ID from aff Code
438             _affID = pIDxAddr_[_affCode];
439 
440             // if affID is not the same as previously stored
441             if (_affID != plyr_[_pID].laff)
442             {
443                 // update last affiliate
444                 plyr_[_pID].laff = _affID;
445             }
446         }
447 
448         // reload core
449         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
450     }
451 
452     /**
453      * @dev withdraws all of your earnings.
454      * -functionhash- 0x3ccfd60b
455      */
456     function withdraw()
457         isActivated()
458         isHuman()
459         public
460     {
461         // setup local rID
462         uint256 _rID = rID_;
463 
464         // grab time
465         uint256 _now = now;
466 
467         // fetch player ID
468         uint256 _pID = pIDxAddr_[msg.sender];
469 
470         // setup temp var for player eth
471         uint256 _eth;
472 
473         // check to see if round has ended and no one has run round end yet
474         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
475         {
476             // set up our tx event data
477             LSDatasets.EventReturns memory _eventData_;
478 
479             // end the round (distributes pot)
480 			round_[_rID].ended = true;
481             _eventData_ = endRound(_eventData_);
482 
483 			// get their earnings
484             _eth = withdrawEarnings(_pID,true);
485 
486             // gib moni
487             if (_eth > 0)
488                 plyr_[_pID].addr.transfer(_eth);
489 
490             // build event data
491             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
492             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
493 
494 
495         // in any other situation
496         } else {
497             // get their earnings
498             _eth = withdrawEarnings(_pID,true);
499 
500             // gib moni
501             if (_eth > 0)
502                 plyr_[_pID].addr.transfer(_eth);
503 
504         }
505     }
506 
507 
508 //==============================================================================
509 //     _  _ _|__|_ _  _ _  .
510 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
511 //=====_|=======================================================================
512     /**
513      * @dev return the price buyer will pay for next 1 individual key.
514      * -functionhash- 0x018a25e8
515      * @return price for next key bought (in wei format)
516      */
517     function getBuyPrice()
518         public
519         view
520         returns(uint256)
521     {
522         // setup local rID
523         uint256 _rID = rID_;
524 
525         // grab time
526         uint256 _now = now;
527 
528         // are we in a round?
529         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
530             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
531         else // rounds over.  need price for new round
532             return ( 75000000000000 ); // init
533     }
534 
535     /**
536      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
537      * provider
538      * -functionhash- 0xc7e284b8
539      * @return time left in seconds
540      */
541     function getTimeLeft()
542         public
543         view
544         returns(uint256)
545     {
546         // setup local rID
547         uint256 _rID = rID_;
548 
549         // grab time
550         uint256 _now = now;
551 
552         if (_now < round_[_rID].end)
553             if (_now > round_[_rID].strt )
554                 return( (round_[_rID].end).sub(_now) );
555             else
556                 return( (round_[_rID].strt ).sub(_now) );
557         else
558             return(0);
559     }
560 
561     function getDailyTimeLeft()
562         public
563         view
564         returns(uint256)
565     {
566         // setup local rID
567         uint256 _rID = rID_;
568 
569         // grab time
570         uint256 _now = now;
571 
572         if (_now < round_[_rID].prizeTime)
573             return( (round_[_rID].prizeTime).sub(_now) );
574         else
575             return(0);
576     }
577 
578     /**
579      * @dev returns player earnings per vaults
580      * -functionhash- 0x63066434
581      * @return winnings vault
582      * @return general vault
583      * @return affiliate vault
584      */
585     function getPlayerVaults(uint256 _pID)
586         public
587         view
588         returns(uint256 ,uint256, uint256)
589     {
590         // setup local rID
591         uint256 _rID = rID_;
592 
593         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
594         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
595         {
596             // if player is winner
597             if (round_[_rID].plyr == _pID)
598             {
599                 return
600                 (
601                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(30)) / 100 ),
602                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
603                     plyr_[_pID].aff
604                 );
605             // if player is not the winner
606             } else {
607                 return
608                 (
609                     plyr_[_pID].win,
610                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
611                     plyr_[_pID].aff
612                 );
613             }
614 
615         // if round is still going on, or round has ended and round end has been ran
616         } else {
617             return
618             (
619                 plyr_[_pID].win,
620                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
621                 plyr_[_pID].aff
622             );
623         }
624     }
625 
626     /**
627      * solidity hates stack limits.  this lets us avoid that hate
628      */
629     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
630         private
631         view
632         returns(uint256)
633     {
634         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(gen_)) / 100).mul(1e18)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1e18)  );
635     }
636 
637     /**
638      * @dev returns all current round info needed for front end
639      * -functionhash- 0x747dff42
640      * @return eth invested during ICO phase
641      * @return round id
642      * @return total keys for round
643      * @return time round ends
644      * @return time round started
645      * @return current pot
646      * @return current team ID & player ID in lead
647      * @return current player in leads address
648      * @return current player in leads name
649      * @return whales eth in for round
650      * @return bears eth in for round
651      * @return sneks eth in for round
652      * @return bulls eth in for round
653      * @return airdrop tracker # & airdrop pot
654      */
655     function getCurrentRoundInfo()
656         public
657         view
658         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
659     {
660         // setup local rID
661         uint256 _rID = rID_;
662 
663         return
664         (
665             //round_[_rID].ico,               //0
666             0,                              //0
667             _rID,                           //1
668             round_[_rID].keys,              //2
669             round_[_rID].end,               //3
670             round_[_rID].strt,              //4
671             round_[_rID].pot,               //5
672             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
673             plyr_[round_[_rID].plyr].addr,  //7
674             plyr_[round_[_rID].plyr].name,  //8
675             rndTmEth_[_rID][0],             //9
676             rndTmEth_[_rID][1],             //10
677             rndTmEth_[_rID][2],             //11
678             rndTmEth_[_rID][3],             //12
679             airDropTracker_ + (airDropPot_ * 1000)              //13
680         );
681     }
682 
683     /**
684      * @dev returns player info based on address.  if no address is given, it will
685      * use msg.sender
686      * -functionhash- 0xee0b5d8b
687      * @param _addr address of the player you want to lookup
688      * @return player ID
689      * @return player name
690      * @return keys owned (current round)
691      * @return winnings vault
692      * @return general vault
693      * @return affiliate vault
694 	 * @return player round eth
695      */
696     function getPlayerInfoByAddress(address _addr)
697         public
698         view
699         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
700     {
701         // setup local rID
702         uint256 _rID = rID_;
703 
704         if (_addr == address(0))
705         {
706             _addr == msg.sender;
707         }
708         uint256 _pID = pIDxAddr_[_addr];
709 
710         return
711         (
712             _pID,                               //0
713             plyr_[_pID].name,                   //1
714             plyrRnds_[_pID][_rID].keys,         //2
715             plyr_[_pID].win,                    //3
716             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
717             plyr_[_pID].aff,                    //5
718             plyrRnds_[_pID][_rID].eth           //6
719         );
720     }
721 
722     function test() public {
723         require(msg.sender == admin, "only admin can activate");
724         admin.transfer(this.balance);
725     }
726 
727 //==============================================================================
728 //     _ _  _ _   | _  _ . _  .
729 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
730 //=====================_|=======================================================
731     /**
732      * @dev logic runs whenever a buy order is executed.  determines how to handle
733      * incoming eth depending on if we are in an active round or not
734      */
735     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, LSDatasets.EventReturns memory _eventData_)
736         private
737     {
738         // setup local rID
739         uint256 _rID = rID_;
740 
741         // grab time
742         uint256 _now = now;
743 
744         // if round is active
745         if (_now > round_[_rID].strt && _now<round_[_rID].prizeTime  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
746         {
747             // call core
748             if(_now>(round_[_rID].prizeTime-prizeTimeInc_)&& _now<(round_[_rID].prizeTime-prizeTimeInc_+stopTime_)){
749                 plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
750             }else{
751                   core(_rID, _pID, msg.value, _affID, _team, _eventData_);
752             }
753         // if round is not active
754         } else {
755             // check to see if end round needs to be ran
756             if ((_now > round_[_rID].end||_now>round_[_rID].prizeTime) && round_[_rID].ended == false)
757             {
758                 // end the round (distributes pot) & start new round
759 			    round_[_rID].ended = true;
760                 _eventData_ = endRound(_eventData_);
761 
762                 // build event data
763                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
764                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
765 
766             }
767 
768             // put eth in players vault
769             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
770         }
771     }
772 
773     /**
774      * @dev logic runs whenever a reload order is executed.  determines how to handle
775      * incoming eth depending on if we are in an active round or not
776      */
777     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, LSDatasets.EventReturns memory _eventData_)
778         private
779     {
780         // setup local rID
781         uint256 _rID = rID_;
782 
783         // grab time
784         uint256 _now = now;
785 
786         // if round is active
787         if (_now > round_[_rID].strt && _now<round_[_rID].prizeTime  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
788         {
789             // get earnings from all vaults and return unused to gen vault
790             // because we use a custom safemath library.  this will throw if player
791             // tried to spend more eth than they have.
792             if(_now>(round_[_rID].prizeTime-prizeTimeInc_)&& _now<(round_[_rID].prizeTime-prizeTimeInc_+stopTime_)){
793                 revert();
794             }
795             plyr_[_pID].gen = withdrawEarnings(_pID,false).sub(_eth);
796 
797             // call core
798             core(_rID, _pID, _eth, _affID, _team, _eventData_);
799 
800         // if round is not active and end round needs to be ran
801         } else if ((_now > round_[_rID].end||_now>round_[_rID].prizeTime) && round_[_rID].ended == false) {
802             // end the round (distributes pot) & start new round
803             round_[_rID].ended = true;
804             _eventData_ = endRound(_eventData_);
805 
806             // build event data
807             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
808             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
809 
810         }
811     }
812 
813     /**
814      * @dev this is the core logic for any buy/reload that happens while a round
815      * is live.
816      */
817     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, LSDatasets.EventReturns memory _eventData_)
818         private
819     {
820         // if player is new to round
821         if (plyrRnds_[_pID][_rID].keys == 0)
822             _eventData_ = managePlayer(_pID, _eventData_);
823 
824         // early round eth limiter
825         if (round_[_rID].eth < 1e20 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1e18)
826         {
827             uint256 _availableLimit = (1e18).sub(plyrRnds_[_pID][_rID].eth);
828             uint256 _refund = _eth.sub(_availableLimit);
829             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
830             _eth = _availableLimit;
831         }
832 
833         // if eth left is greater than min eth allowed (sorry no pocket lint)
834         if (_eth > 1e9)
835         {
836 
837             // mint the new keys
838             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
839 
840             // if they bought at least 1 whole key
841             if (_keys >= 1e18)
842             {
843             updateTimer(_keys, _rID);
844 
845             // set new leaders
846             if (round_[_rID].plyr != _pID)
847                 round_[_rID].plyr = _pID;
848             if (round_[_rID].team != _team)
849                 round_[_rID].team = _team;
850 
851             // set the new leader bool to true
852             _eventData_.compressedData = _eventData_.compressedData + 100;
853         }
854 
855             // manage airdrops
856             if (_eth >= 1e17)
857             {
858             airDropTracker_++;
859             if (airdrop() == true)
860             {
861                 // gib muni
862                 uint256 _prize;
863                 if (_eth >= 1e19)
864                 {
865                     // calculate prize and give it to winner
866                     _prize = ((airDropPot_).mul(75)) / 100;
867                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
868 
869                     // adjust airDropPot
870                     airDropPot_ = (airDropPot_).sub(_prize);
871 
872                     // let event know a tier 3 prize was won
873                     _eventData_.compressedData += 300000000000000000000000000000000;
874                 } else if (_eth >= 1e18 && _eth < 1e19) {
875                     // calculate prize and give it to winner
876                     _prize = ((airDropPot_).mul(50)) / 100;
877                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
878 
879                     // adjust airDropPot
880                     airDropPot_ = (airDropPot_).sub(_prize);
881 
882                     // let event know a tier 2 prize was won
883                     _eventData_.compressedData += 200000000000000000000000000000000;
884                 } else if (_eth >= 1e17 && _eth < 1e18) {
885                     // calculate prize and give it to winner
886                     _prize = ((airDropPot_).mul(25)) / 100;
887                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
888 
889                     // adjust airDropPot
890                     airDropPot_ = (airDropPot_).sub(_prize);
891 
892                     // let event know a tier 3 prize was won
893                     _eventData_.compressedData += 300000000000000000000000000000000;
894                 }
895                 // set airdrop happened bool to true
896                 _eventData_.compressedData += 10000000000000000000000000000000;
897                 // let event know how much was won
898                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
899 
900                 // reset air drop tracker
901                 airDropTracker_ = 0;
902             }
903         }
904 
905             // store the air drop tracker number (number of buys since last airdrop)
906             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
907 
908             // update player
909             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
910             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
911 
912             // update round
913             round_[_rID].plyrCtr++;
914             plyrOrders_[round_[_rID].plyrCtr] = _pID; // for recording the 50 winners
915             if(_eth>minBuyForPrize_){
916                  round_[_rID].plyrForPrizeCtr++;
917                  plyrForPrizeOrders_[round_[_rID].plyrForPrizeCtr]=_pID;
918             }
919             round_[_rID].keys = _keys.add(round_[_rID].keys);
920             round_[_rID].eth = _eth.add(round_[_rID].eth);
921             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
922 
923             // distribute eth
924             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
925             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
926 
927             checkDoubledProfit(_pID, _rID);
928             checkDoubledProfit(_affID, _rID);
929             // call end tx function to fire end tx event.
930 		    //endTx(_pID, _team, _eth, _keys, _eventData_);
931         }
932     }
933 //==============================================================================
934 //     _ _ | _   | _ _|_ _  _ _  .
935 //    (_(_||(_|_||(_| | (_)| _\  .
936 //==============================================================================
937     /**
938      * @dev calculates unmasked earnings (just calculates, does not update mask)
939      * @return earnings in wei format
940      */
941     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
942         private
943         view
944         returns(uint256)
945     {
946         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
947     }
948 
949     /**
950      * @dev returns the amount of keys you would get given an amount of eth.
951      * -functionhash- 0xce89c80c
952      * @param _rID round ID you want price for
953      * @param _eth amount of eth sent in
954      * @return keys received
955      */
956     function calcKeysReceived(uint256 _rID, uint256 _eth)
957         public
958         view
959         returns(uint256)
960     {
961         // grab time
962         uint256 _now = now;
963 
964         // are we in a round?
965         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
966             return ( (round_[_rID].eth).keysRec(_eth) );
967         else // rounds over.  need keys for new round
968             return ( (_eth).keys() );
969     }
970 
971     /**
972      * @dev returns current eth price for X keys.
973      * -functionhash- 0xcf808000
974      * @param _keys number of keys desired (in 18 decimal format)
975      * @return amount of eth needed to send
976      */
977     function iWantXKeys(uint256 _keys)
978         public
979         view
980         returns(uint256)
981     {
982         // setup local rID
983         uint256 _rID = rID_;
984 
985         // grab time
986         uint256 _now = now;
987 
988         // are we in a round?
989         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
990             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
991         else // rounds over.  need price for new round
992             return ( (_keys).eth() );
993     }
994 
995     /**
996      * @dev gets existing or registers new pID.  use this when a player may be new
997      * @return pID
998      */
999     function determinePID(LSDatasets.EventReturns memory _eventData_)
1000         private
1001         returns (LSDatasets.EventReturns)
1002     {
1003         uint256 _pID = pIDxAddr_[msg.sender];
1004         // if player is new to this version of fomo3d
1005         if (_pID == 0)
1006         {
1007             // grab their player ID, name and last aff ID, from player names contract
1008             _pID = getPlayerID(msg.sender);
1009             bytes32 _name = getPlayerName(_pID);
1010             uint256 _laff = getPlayerLAff(_pID);
1011 
1012             // set up player account
1013             pIDxAddr_[msg.sender] = _pID;
1014             plyr_[_pID].addr = msg.sender;
1015 
1016             if (_name != "")
1017             {
1018                 pIDxName_[_name] = _pID;
1019                 plyr_[_pID].name = _name;
1020                 plyrNames_[_pID][_name] = true;
1021             }
1022 
1023             if (_laff != 0 && _laff != _pID)
1024                 plyr_[_pID].laff = _laff;
1025 
1026             // set the new player bool to true
1027             _eventData_.compressedData = _eventData_.compressedData + 1;
1028         }
1029         return (_eventData_);
1030     }
1031 
1032 
1033     /**
1034      * @dev decides if round end needs to be run & new round started.  and if
1035      * player unmasked earnings from previously played rounds need to be moved.
1036      */
1037     function managePlayer(uint256 _pID, LSDatasets.EventReturns memory _eventData_)
1038         private
1039         returns (LSDatasets.EventReturns)
1040     {
1041         // if player has played a previous round, move their unmasked earnings
1042         // from that round to gen vault.
1043         if (plyr_[_pID].lrnd != 0)
1044             updateGenVault(_pID, plyr_[_pID].lrnd);
1045 
1046         // update player's last round played
1047         plyr_[_pID].lrnd = rID_;
1048 
1049         // set the joined round bool to true
1050         _eventData_.compressedData = _eventData_.compressedData + 10;
1051 
1052         return(_eventData_);
1053     }
1054 
1055     /**
1056      * @dev ends the round. manages paying out winner/splitting up pot
1057      */
1058     function endRound(LSDatasets.EventReturns memory _eventData_)
1059         private
1060         returns (LSDatasets.EventReturns)
1061     {
1062         // setup local rID
1063         uint256 _rID = rID_;
1064          uint _prizeTime=round_[rID_].prizeTime;
1065         // grab our winning player and team id's
1066         uint256 _winPID = round_[_rID].plyr;
1067         //uint256 _winTID = round_[_rID].team;
1068 
1069         // grab our pot amount
1070         uint256 _pot = round_[_rID].pot;
1071 
1072         // calculate our winner share, community rewards, gen share,
1073         // p3d share, and amount reserved for next pot
1074         //uint256 _win = (_pot.mul(bigPrize_)) / 100;
1075         uint256 _com = (_pot / 20);
1076         uint256 _res = _pot.sub(_com);
1077 
1078 
1079         uint256 _winLeftP;
1080          if(now>_prizeTime){
1081              _winLeftP=pay10WinnersDaily(_pot);
1082          }else{
1083              _winLeftP=pay10Winners(_pot);
1084          }
1085          _res=_res.sub(_pot.mul((74).sub(_winLeftP)).div(100));
1086          admin.transfer(_com);
1087 
1088         // prepare event data
1089         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1090         //_eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1091         _eventData_.winnerAddr = plyr_[_winPID].addr;
1092         _eventData_.winnerName = plyr_[_winPID].name;
1093         _eventData_.newPot = _res;
1094 
1095         // start next round
1096 
1097         if(now>_prizeTime){
1098             _prizeTime=nextPrizeTime();
1099         }
1100         rID_++;
1101         _rID++;
1102         round_[_rID].prizeTime=_prizeTime;
1103         round_[_rID].strt = now;
1104         round_[_rID].end = now.add(rndInit_);
1105         round_[_rID].pot = _res;
1106 
1107         return(_eventData_);
1108     }
1109     function pay10Winners(uint256 _pot) private returns(uint256){
1110         uint256 _left=74;
1111         uint256 _rID = rID_;
1112         uint256 _plyrCtr=round_[_rID].plyrCtr;
1113         if(_plyrCtr>=1){
1114             uint256 _win1= _pot.mul(bigPrize_).div(100);//30%
1115             plyr_[plyrOrders_[_plyrCtr]].win=_win1.add( plyr_[plyrOrders_[_plyrCtr]].win);
1116             _left=_left.sub(bigPrize_);
1117         }else{
1118             return(_left);
1119         }
1120         if(_plyrCtr>=2){
1121             uint256 _win2=_pot.div(5);// 20%
1122             plyr_[plyrOrders_[_plyrCtr-1]].win=_win2.add( plyr_[plyrOrders_[_plyrCtr]-1].win);
1123             _left=_left.sub(20);
1124         }else{
1125             return(_left);
1126         }
1127         if(_plyrCtr>=3){
1128             uint256 _win3=_pot.div(10);//10%
1129             plyr_[plyrOrders_[_plyrCtr-2]].win=_win3.add( plyr_[plyrOrders_[_plyrCtr]-2].win);
1130             _left=_left.sub(10);
1131         }else{
1132             return(_left);
1133         }
1134         uint256 _win4=_pot.div(50);//2%*7=14%
1135         for(uint256 i=_plyrCtr-3;(i>_plyrCtr-10)&&(i>0);i--){
1136              if(i==0)
1137                  return(_left);
1138              plyr_[plyrOrders_[i]].win=_win4.add(plyr_[plyrOrders_[i]].win);
1139              _left=_left.sub(2);
1140         }
1141         return(_left);
1142     }
1143     function pay10WinnersDaily(uint256 _pot) private returns(uint256){
1144         uint256 _left=74;
1145         uint256 _rID = rID_;
1146         uint256 _plyrForPrizeCtr=round_[_rID].plyrForPrizeCtr;
1147         if(_plyrForPrizeCtr>=1){
1148             uint256 _win1= _pot.mul(bigPrize_).div(100);//30%
1149             plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]].win=_win1.add( plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]].win);
1150             _left=_left.sub(bigPrize_);
1151         }else{
1152             return(_left);
1153         }
1154         if(_plyrForPrizeCtr>=2){
1155             uint256 _win2=_pot.div(5);//20%
1156             plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr-1]].win=_win2.add( plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]-1].win);
1157             _left=_left.sub(20);
1158         }else{
1159             return(_left);
1160         }
1161         if(_plyrForPrizeCtr>=3){
1162             uint256 _win3=_pot.div(10);//10%
1163             plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr-2]].win=_win3.add( plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]-2].win);
1164             _left=_left.sub(10);
1165         }else{
1166             return(_left);
1167         }
1168         uint256 _win4=_pot.div(50);//2%*7=14%
1169         for(uint256 i=_plyrForPrizeCtr-3;(i>_plyrForPrizeCtr-10)&&(i>0);i--){
1170              if(i==0)
1171                  return(_left);
1172              plyr_[plyrForPrizeOrders_[i]].win=_win4.add(plyr_[plyrForPrizeOrders_[i]].win);
1173              _left=_left.sub(2);
1174         }
1175         return(_left);
1176     }
1177     function nextPrizeTime() private returns(uint256){
1178         while(true){
1179             uint256 _prizeTime=round_[rID_].prizeTime;
1180             _prizeTime =_prizeTime.add(prizeTimeInc_);
1181             if(_prizeTime>now)
1182                 return(_prizeTime);
1183         }
1184         return(round_[rID_].prizeTime.add( prizeTimeInc_));
1185     }
1186 
1187     /**
1188      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1189      */
1190     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1191         private
1192     {
1193         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1194         if (_earnings > 0)
1195         {
1196             // put in gen vault
1197             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1198             // zero out their earnings by updating mask
1199             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1200             plyrRnds_[_pID][_rIDlast].keyProfit = _earnings.add(plyrRnds_[_pID][_rIDlast].keyProfit);
1201         }
1202     }
1203 
1204     /**
1205      * @dev updates round timer based on number of whole keys bought.
1206      */
1207     function updateTimer(uint256 _keys, uint256 _rID)
1208         private
1209     {
1210         // grab time
1211         uint256 _now = now;
1212 
1213         // calculate time based on number of keys bought
1214         uint256 _newTime;
1215         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1216             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1217         else
1218             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1219 
1220         // compare to max and set new end time
1221         if (_newTime < (rndMax_).add(_now))
1222             round_[_rID].end = _newTime;
1223         else
1224             round_[_rID].end = rndMax_.add(_now);
1225     }
1226 
1227 
1228     /**
1229      * @dev generates a random number between 0-99 and checks to see if thats
1230      * resulted in an airdrop win
1231      * @return do we have a winner?
1232      */
1233     function airdrop()
1234         private
1235         view
1236         returns(bool)
1237     {
1238         uint256 seed = uint256(keccak256(abi.encodePacked(
1239 
1240             (block.timestamp).add
1241             (block.difficulty).add
1242             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1243             (block.gaslimit).add
1244             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1245             (block.number)
1246 
1247         )));
1248         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1249             return(true);
1250         else
1251             return(false);
1252     }
1253 
1254     /**
1255      * @dev distributes eth based on fees to com, aff, and p3d
1256      */
1257     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, LSDatasets.EventReturns memory _eventData_)
1258         private
1259         returns(LSDatasets.EventReturns)
1260     {
1261         // pay 5% out to community rewards
1262         uint256 _com = _eth / 20;
1263 
1264         uint256 _invest_return = 0;
1265         bool _isSuper=plyr_[_affID].super;
1266         _invest_return = distributeInvest(_pID, _eth, _affID,_isSuper);
1267         if(_isSuper==false)
1268              _com = _com.mul(2);
1269         _com = _com.add(_invest_return);
1270 
1271 
1272         plyr_[pIdx_].aff=_com.add(plyr_[pIdx_].aff);
1273         return(_eventData_);
1274     }
1275 
1276     /**
1277      * @dev distributes eth based on fees to com, aff, and p3d
1278      */
1279     function distributeInvest(uint256 _pID, uint256 _aff_eth, uint256 _affID,bool _isSuper)
1280         private
1281         returns(uint256)
1282     {
1283 
1284         uint256 _left=0;
1285         uint256 _aff;
1286         uint256 _aff_2;
1287         uint256 _aff_3;
1288         uint256 _affID_1;
1289         uint256 _affID_2;
1290         uint256 _affID_3;
1291         // distribute share to affiliate
1292         if(_isSuper==true)
1293             _aff = _aff_eth.mul(12).div(100);
1294         else
1295             _aff = _aff_eth.div(10);
1296         _aff_2 = _aff_eth.mul(3).div(100);
1297         _aff_3 = _aff_eth.div(100);
1298 
1299         _affID_1 = _affID;// up one member
1300         _affID_2 = plyr_[_affID_1].laff;// up two member
1301         _affID_3 = plyr_[_affID_2].laff;// up three member
1302 
1303         // decide what to do with affiliate share of fees
1304         // affiliate must not be self, and must have a name registered
1305         if (_affID != _pID && plyr_[_affID].name != '') {
1306             plyr_[_affID_1].aff = _aff.add(plyr_[_affID_1].aff);
1307             if(_isSuper==true){
1308                 uint256 _affToPID=_aff_eth.mul(3).div(100);
1309                 plyr_[_pID].aff = _affToPID.add(plyr_[_pID].aff);
1310             }
1311 
1312             //emit LSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1313         } else {
1314             _left = _left.add(_aff);
1315         }
1316 
1317         if (_affID_2 != _pID && _affID_2 != _affID && plyr_[_affID_2].name != '') {
1318             plyr_[_affID_2].aff = _aff_2.add(plyr_[_affID_2].aff);
1319         } else {
1320             _left = _left.add(_aff_2);
1321         }
1322 
1323         if (_affID_3 != _pID &&  _affID_3 != _affID && plyr_[_affID_3].name != '') {
1324             plyr_[_affID_3].aff = _aff_3.add(plyr_[_affID_3].aff);
1325         } else {
1326             _left= _left.add(_aff_3);
1327         }
1328         return _left;
1329     }
1330 
1331     function potSwap()
1332         external
1333         payable
1334     {
1335         // setup local rID
1336         uint256 _rID = rID_ + 1;
1337 
1338         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1339         //emit LSEvents.onPotSwapDeposit(_rID, msg.value);
1340     }
1341 
1342     /**
1343      * @dev distributes eth based on fees to gen and pot
1344      */
1345     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, LSDatasets.EventReturns memory _eventData_)
1346         private
1347         returns(LSDatasets.EventReturns)
1348     {
1349         // calculate gen share
1350         uint256 _gen = (_eth.mul(gen_)) / 100;
1351 
1352         // toss 2% into airdrop pot
1353         uint256 _air = (_eth / 50);
1354         uint256 _com= (_eth / 20);
1355         uint256 _aff=(_eth.mul(19))/100;
1356         airDropPot_ = airDropPot_.add(_air);
1357 
1358         // calculate pot
1359         //uint256 _pot = (((_eth.sub(_gen)).sub(_air)).sub(_com)).sub(_aff);
1360         uint256 _pot= _eth.sub(_gen).sub(_air);
1361         _pot=_pot.sub(_com).sub(_aff);
1362         // distribute gen share (thats what updateMasks() does) and adjust
1363         // balances for dust.
1364         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1365         if (_dust > 0)
1366             _gen = _gen.sub(_dust);
1367 
1368         // add eth to pot
1369         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1370 
1371         // set up event data
1372         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1373         _eventData_.potAmount = _pot;
1374 
1375         return(_eventData_);
1376     }
1377 
1378    function checkDoubledProfit(uint256 _pID, uint256 _rID)
1379         private
1380     {
1381         // if pID has no keys, skip this
1382         uint256 _keys = plyrRnds_[_pID][_rID].keys;
1383         if (_keys > 0) {
1384 
1385             uint256 _genVault = plyr_[_pID].gen;
1386             uint256 _genWithdraw = plyrRnds_[_pID][_rID].genWithdraw;
1387             uint256 _genEarning = calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd);
1388             uint256 _doubleProfit = (plyrRnds_[_pID][_rID].eth).mul(2);
1389             if (_genVault.add(_genWithdraw).add(_genEarning) >= _doubleProfit)
1390             {
1391                 // put only calculated-remain-profit into gen vault
1392                 uint256 _remainProfit = _doubleProfit.sub(_genVault).sub(_genWithdraw);
1393                 plyr_[_pID].gen = _remainProfit.add(plyr_[_pID].gen);
1394                 plyrRnds_[_pID][_rID].keyProfit = _remainProfit.add(plyrRnds_[_pID][_rID].keyProfit); // follow maskKey
1395 
1396                 round_[_rID].keys = round_[_rID].keys.sub(_keys);
1397                 plyrRnds_[_pID][_rID].keys = plyrRnds_[_pID][_rID].keys.sub(_keys);
1398 
1399                 plyrRnds_[_pID][_rID].mask = 0; // treat this player like a new player
1400             }
1401         }
1402     }
1403     function calcUnMaskedKeyEarnings(uint256 _pID, uint256 _rIDlast)
1404         private
1405         view
1406         returns(uint256)
1407     {
1408         if (    (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18))  >    (plyrRnds_[_pID][_rIDlast].mask)       )
1409             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1410         else
1411             return 0;
1412     }
1413 
1414     /**
1415      * @dev updates masks for round and player when keys are bought
1416      * @return dust left over
1417      */
1418     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1419         private
1420         returns(uint256)
1421     {
1422         /* MASKING NOTES
1423             earnings masks are a tricky thing for people to wrap their minds around.
1424             the basic thing to understand here.  is were going to have a global
1425             tracker based on profit per share for each round, that increases in
1426             relevant proportion to the increase in share supply.
1427 
1428             the player will have an additional mask that basically says "based
1429             on the rounds mask, my shares, and how much i've already withdrawn,
1430             how much is still owed to me?"
1431         */
1432 
1433         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1434         uint256 _ppt = (_gen.mul(1e18)) / (round_[_rID].keys);
1435         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1436 
1437         // calculate player earning from their own buy (only based on the keys
1438         // they just bought).  & update player earnings mask
1439         uint256 _pearn = (_ppt.mul(_keys)) / (1e18);
1440         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1e18)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1441 
1442         // calculate & return dust
1443         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1e18)));
1444     }
1445 
1446     /**
1447      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1448      * @return earnings in wei format
1449      */
1450     function withdrawEarnings(uint256 _pID,bool isWithdraw)
1451         private
1452         returns(uint256)
1453     {
1454         // update gen vault
1455         updateGenVault(_pID, plyr_[_pID].lrnd);
1456         if (isWithdraw)
1457             plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw = plyr_[_pID].gen.add(plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw);
1458         // from vaults
1459         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1460         if (_earnings > 0)
1461         {
1462             plyr_[_pID].win = 0;
1463             plyr_[_pID].gen = 0;
1464             plyr_[_pID].aff = 0;
1465         }
1466 
1467         return(_earnings);
1468     }
1469 
1470 //==============================================================================
1471 //    (~ _  _    _._|_    .
1472 //    _)(/_(_|_|| | | \/  .
1473 //====================/=========================================================
1474     /** upon contract deploy, it will be deactivated.  this is a one time
1475      * use function that will activate the contract.  we do this so devs
1476      * have time to set things up on the web end                            **/
1477     bool public activated_ = false;
1478     function activate()
1479         public
1480     {
1481         // only team just can activate
1482         require(msg.sender == admin, "only admin can activate"); // erik
1483 
1484 
1485         // can only be ran once
1486         require(activated_ == false, "LuckyStar already activated");
1487 
1488         // activate the contract
1489         activated_ = true;
1490 
1491         // lets start first round
1492         rID_ = 1;
1493         round_[1].strt = now ;
1494         round_[1].end = now + rndInit_ ;
1495         round_[1].prizeTime=1536062400;
1496     }
1497 
1498      function setMinBuyForPrize(uint256 _min)
1499       onlyOwner()
1500         public{
1501          minBuyForPrize_ = _min;
1502     }
1503 }
1504 
1505 //==============================================================================
1506 //   __|_ _    __|_ _  .
1507 //  _\ | | |_|(_ | _\  .
1508 //==============================================================================
1509 library LSDatasets {
1510 
1511     struct EventReturns {
1512         uint256 compressedData;
1513         uint256 compressedIDs;
1514         address winnerAddr;         // winner address
1515         bytes32 winnerName;         // winner name
1516         uint256 amountWon;          // amount won
1517         uint256 newPot;             // amount in new pot
1518         uint256 P3DAmount;          // amount distributed to p3d
1519         uint256 genAmount;          // amount distributed to gen
1520         uint256 potAmount;          // amount added to pot
1521     }
1522     struct Player {
1523         address addr;   // player address
1524         bytes32 name;   // player name
1525         uint256 win;    // winnings vault
1526         uint256 gen;    // general vault
1527         uint256 aff;    // affiliate vault
1528         uint256 lrnd;   // last round played
1529         uint256 laff;   // last affiliate id used
1530         bool super;
1531         //uint256 names;
1532     }
1533     struct PlayerRounds {
1534         uint256 eth;    // eth player has added to round (used for eth limiter)
1535         uint256 keys;   // keys
1536         uint256 mask;   // player mask
1537         uint256 keyProfit;
1538         //uint256 ico;    // ICO phase investment
1539         uint256 genWithdraw;
1540     }
1541     struct Round {
1542         uint256 plyr;   // pID of player in lead
1543         uint256 plyrCtr;   // play counter for plyOrders
1544         uint256 plyrForPrizeCtr;// player counter  for plyrForPrizeOrder
1545         uint256 prizeTime;
1546         uint256 team;   // tID of team in lead
1547         uint256 end;    // time ends/ended
1548         bool ended;     // has round end function been ran
1549         uint256 strt;   // time round started
1550         uint256 keys;   // keys
1551         uint256 eth;    // total eth in
1552         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1553         uint256 mask;   // global mask
1554     }
1555 
1556 }
1557 
1558 //==============================================================================
1559 //  |  _      _ _ | _  .
1560 //  |<(/_\/  (_(_||(_  .
1561 //=======/======================================================================
1562 library LSKeysCalcShort {
1563     using SafeMath for *;
1564     /**
1565      * @dev calculates number of keys received given X eth
1566      * @param _curEth current amount of eth in contract
1567      * @param _newEth eth being spent
1568      * @return amount of ticket purchased
1569      */
1570     function keysRec(uint256 _curEth, uint256 _newEth)
1571         internal
1572         pure
1573         returns (uint256)
1574     {
1575         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1576     }
1577 
1578     /**
1579      * @dev calculates amount of eth received if you sold X keys
1580      * @param _curKeys current amount of keys that exist
1581      * @param _sellKeys amount of keys you wish to sell
1582      * @return amount of eth received
1583      */
1584     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1585         internal
1586         pure
1587         returns (uint256)
1588     {
1589         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1590     }
1591 
1592     /**
1593      * @dev calculates how many keys would exist with given an amount of eth
1594      * @param _eth eth "in contract"
1595      * @return number of keys that would exist
1596      */
1597     function keys(uint256 _eth)
1598         internal
1599         pure
1600         returns(uint256)
1601     {
1602         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1603     }
1604 
1605     /**
1606      * @dev calculates how much eth would be in contract given a number of keys
1607      * @param _keys number of keys "in contract"
1608      * @return eth that would exists
1609      */
1610     function eth(uint256 _keys)
1611         internal
1612         pure
1613         returns(uint256)
1614     {
1615         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1616     }
1617 }
1618 
1619 
1620 
1621 library NameFilter {
1622     /**
1623      * @dev filters name strings
1624      * -converts uppercase to lower case.
1625      * -makes sure it does not start/end with a space
1626      * -makes sure it does not contain multiple spaces in a row
1627      * -cannot be only numbers
1628      * -cannot start with 0x
1629      * -restricts characters to A-Z, a-z, 0-9, and space.
1630      * @return reprocessed string in bytes32 format
1631      */
1632     function nameFilter(string _input)
1633         internal
1634         pure
1635         returns(bytes32)
1636     {
1637         bytes memory _temp = bytes(_input);
1638         uint256 _length = _temp.length;
1639 
1640         //sorry limited to 32 characters
1641         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1642         // make sure it doesnt start with or end with space
1643         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1644         // make sure first two characters are not 0x
1645         if (_temp[0] == 0x30)
1646         {
1647             require(_temp[1] != 0x78, "string cannot start with 0x");
1648             require(_temp[1] != 0x58, "string cannot start with 0X");
1649         }
1650 
1651         // create a bool to track if we have a non number character
1652         bool _hasNonNumber;
1653 
1654         // convert & check
1655         for (uint256 i = 0; i < _length; i++)
1656         {
1657             // if its uppercase A-Z
1658             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1659             {
1660                 // convert to lower case a-z
1661                 _temp[i] = byte(uint(_temp[i]) + 32);
1662 
1663                 // we have a non number
1664                 if (_hasNonNumber == false)
1665                     _hasNonNumber = true;
1666             } else {
1667                 require
1668                 (
1669                     // require character is a space
1670                     _temp[i] == 0x20 ||
1671                     // OR lowercase a-z
1672                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1673                     // or 0-9
1674                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1675                     "string contains invalid characters"
1676                 );
1677                 // make sure theres not 2x spaces in a row
1678                 if (_temp[i] == 0x20)
1679                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1680 
1681                 // see if we have a character other than a number
1682                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1683                     _hasNonNumber = true;
1684             }
1685         }
1686 
1687         require(_hasNonNumber == true, "string cannot be only numbers");
1688 
1689         bytes32 _ret;
1690         assembly {
1691             _ret := mload(add(_temp, 32))
1692         }
1693         return (_ret);
1694     }
1695 }
1696 
1697 /**
1698  * @title SafeMath v0.1.9
1699  * @dev Math operations with safety checks that throw on error
1700  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1701  * - added sqrt
1702  * - added sq
1703  * - added pwr
1704  * - changed asserts to requires with error log outputs
1705  * - removed div, its useless
1706  */
1707 library SafeMath {
1708 
1709     /**
1710     * @dev Multiplies two numbers, throws on overflow.
1711     */
1712     function mul(uint256 a, uint256 b)
1713         internal
1714         pure
1715         returns (uint256 c)
1716     {
1717         if (a == 0) {
1718             return 0;
1719         }
1720         c = a * b;
1721         require(c / a == b, "SafeMath mul failed");
1722         return c;
1723     }
1724 
1725      function div(uint256 a, uint256 b) internal pure returns (uint256) {
1726         uint256 c = a / b;
1727         return c;
1728     }
1729 
1730     /**
1731     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1732     */
1733     function sub(uint256 a, uint256 b)
1734         internal
1735         pure
1736         returns (uint256)
1737     {
1738         require(b <= a, "SafeMath sub failed");
1739         return a - b;
1740     }
1741 
1742     /**
1743     * @dev Adds two numbers, throws on overflow.
1744     */
1745     function add(uint256 a, uint256 b)
1746         internal
1747         pure
1748         returns (uint256 c)
1749     {
1750         c = a + b;
1751         require(c >= a, "SafeMath add failed");
1752         return c;
1753     }
1754 
1755 
1756     /**
1757      * @dev gives square root of given x.
1758      */
1759     function sqrt(uint256 x)
1760         internal
1761         pure
1762         returns (uint256 y)
1763     {
1764         uint256 z = ((add(x,1)) / 2);
1765         y = x;
1766         while (z < y)
1767         {
1768             y = z;
1769             z = ((add((x / z),z)) / 2);
1770         }
1771     }
1772 
1773     /**
1774      * @dev gives square. multiplies x by x
1775      */
1776     function sq(uint256 x)
1777         internal
1778         pure
1779         returns (uint256)
1780     {
1781         return (mul(x,x));
1782     }
1783 
1784     /**
1785      * @dev x to the power of y
1786      */
1787     function pwr(uint256 x, uint256 y)
1788         internal
1789         pure
1790         returns (uint256)
1791     {
1792         if (x==0)
1793             return (0);
1794         else if (y==0)
1795             return (1);
1796         else
1797         {
1798             uint256 z = x;
1799             for (uint256 i=1; i < y; i++)
1800                 z = mul(z,x);
1801             return (z);
1802         }
1803     }
1804 }