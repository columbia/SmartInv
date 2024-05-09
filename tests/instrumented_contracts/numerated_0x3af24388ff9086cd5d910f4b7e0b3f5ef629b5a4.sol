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
85     function register(address _addr,uint256 _affID,bool _isSuper)  onlyOwner() public{
86         bool _isNewPlayer = determinePID(_addr);
87         bytes32 _name="LuckyStar";
88         uint256 _pID = pIDxAddr_[_addr];
89         plyr_[_pID].laff = _affID;
90         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
91     }
92     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
93         isHuman()
94         public
95         payable
96     {
97         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
98         bytes32 _name = _nameString.nameFilter();
99         address _addr = msg.sender;
100 
101 
102         // set up our tx event data and determine if player is new or not
103         bool _isNewPlayer = determinePID(_addr);
104 
105         // fetch player id
106         uint256 _pID = pIDxAddr_[_addr];
107 
108         // manage affiliate residuals
109         // if no affiliate code was given or player tried to use their own, lolz
110         uint256 _affID;
111         if (_affCode != "" && _affCode != _name)
112         {
113             // get affiliate ID from aff Code
114             _affID = pIDxName_[_affCode];
115 
116             // if affID is not the same as previously stored
117             if (_affID != plyr_[_pID].laff)
118             {
119                 // update last affiliate
120                 plyr_[_pID].laff = _affID;
121             }
122         }
123 
124         // register name
125         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer);
126     }
127 
128     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer)
129         private
130     {
131         // if names already has been used, require that current msg sender owns the name
132         if (pIDxName_[_name] != 0)
133             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
134 
135         // add name to player profile, registry, and name book
136         plyr_[_pID].name = _name;
137         pIDxName_[_name] = _pID;
138         if (plyrNames_[_pID][_name] == false)
139         {
140             plyrNames_[_pID][_name] = true;
141         }
142 
143         // registration fee goes directly to community rewards
144         //admin.transfer(address(this).balance);
145         uint256 _paid=msg.value;
146         //plyr_[pIdx_].aff=_paid.add(plyr_[pIdx_].aff);
147         admin.transfer(_paid);
148 
149     }
150     function setSuper(address _addr,bool isSuper) 
151      onlyOwner()
152      public{
153         uint256 _pID=pIDxAddr_[_addr];
154         if(_pID!=0){
155             plyr_[_pID].super=isSuper;
156         }else{
157             revert();
158         }
159     }
160     
161     function setRegistrationFee(uint256 _fee)
162       onlyOwner()
163         public{
164          registrationFee_ = _fee;
165     }
166 }
167 
168 contract LuckyStar is PlayerBook {
169     using SafeMath for *;
170     using NameFilter for string;
171     using LSKeysCalcShort for uint256;
172 
173     
174 
175 //==============================================================================
176 //     _ _  _  |`. _     _ _ |_ | _  _  .
177 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
178 //=================_|===========================================================
179     address private admin = msg.sender;
180 
181     string constant public name = "LuckyStar";
182     string constant public symbol = "LuckyStar";
183     uint256 constant gen_=55;
184     uint256 constant bigPrize_ =30;
185     uint256 public minBuyForPrize_=100 finney;
186     uint256 constant private rndInit_ = 3 hours;            // round timer starts at this  1H17m17s
187     uint256 constant private rndInc_ = 1 minutes;              // every full key purchased adds this much to the timer
188     uint256 constant private rndMax_ = 6 hours;             // max length a round timer can be  ；3Hours
189     uint256 constant private prizeTimeInc_= 1 days;
190     uint256 constant private stopTime_=1 hours;
191 //==============================================================================
192 //     _| _ _|_ _    _ _ _|_    _   .
193 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
194 //=============================|================================================
195     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
196     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
197     uint256 public rID_;    // round id number / total rounds that have happened
198 //****************
199 // PLAYER DATA
200 //****************
201     mapping (uint256 => uint256) public plyrOrders_; // plyCounter => pID
202     mapping (uint256 => uint256) public plyrForPrizeOrders_; // playCounter => pID
203     mapping (uint256 => mapping (uint256 => LSDatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
204 
205 //****************
206 // ROUND DATA
207 //****************
208     mapping (uint256 => LSDatasets.Round) public round_;   // (rID => data) round data
209     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
210 //****************
211 
212 //==============================================================================
213 //     _ _  _  __|_ _    __|_ _  _  .
214 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
215 //==============================================================================
216     constructor()
217         public
218     {
219 		pIDxAddr_[address(0xc7FcAD2Ad400299a7690d5aa6d7295F9dDB7Fc33)] = 1;
220         plyr_[1].addr = address(0xc7FcAD2Ad400299a7690d5aa6d7295F9dDB7Fc33);
221         plyr_[1].name = "sumpunk";
222         plyr_[1].super=true;
223         pIDxName_["sumpunk"] = 1;
224         plyrNames_[1]["sumpunk"] = true;
225         
226         pIDxAddr_[address(0x2f52362c266c1Df356A2313F79E4bE4E7de281cc)] = 2;
227         plyr_[2].addr = address(0x2f52362c266c1Df356A2313F79E4bE4E7de281cc);
228         plyr_[2].name = "xiaokan";
229         plyr_[2].super=true;
230         pIDxName_["xiaokan"] = 2;
231         plyrNames_[2]["xiaokan"] = true;
232         
233         pIDxAddr_[address(0xA97F850B019871B7a356956f8b43255988d1578a)] = 3;
234         plyr_[3].addr = address(0xA97F850B019871B7a356956f8b43255988d1578a);
235         plyr_[3].name = "Mr Shen";
236         plyr_[3].super=true;
237         pIDxName_["Mr Shen"] = 3;
238         plyrNames_[3]["Mr Shen"] = true;
239         
240         pIDxAddr_[address(0x84408183fC70A65d378f720f4E95e4f9bD9EbeBE)] = 4;
241         plyr_[4].addr = address(0x84408183fC70A65d378f720f4E95e4f9bD9EbeBE);
242         plyr_[4].name = "4";
243         plyr_[4].super=false;
244         pIDxName_["4"] = 4;
245         plyrNames_[4]["4"] = true;
246         
247         pIDxAddr_[address(0xa21E15d5933502DAD475daB3ed235fffFa537f85)] = 5;
248         plyr_[5].addr = address(0xa21E15d5933502DAD475daB3ed235fffFa537f85);
249         plyr_[5].name = "5";
250         plyr_[5].super=true;
251         pIDxName_["5"] = 5;
252         plyrNames_[5]["5"] = true;
253         
254         pIDxAddr_[address(0xEb892446E9096a7e6e28B89EE416564E50504A68)] = 6;
255         plyr_[6].addr = address(0xEb892446E9096a7e6e28B89EE416564E50504A68);
256         plyr_[6].name = "6";
257         plyr_[6].super=true;
258         pIDxName_["6"] = 6;
259         plyrNames_[6]["6"] = true;
260         
261         pIDxAddr_[address(0x75DF1440094346d4156cf4563a85dC5C564D2100)] = 7;
262         plyr_[7].addr = address(0x75DF1440094346d4156cf4563a85dC5C564D2100);
263         plyr_[7].name = "7";
264         plyr_[7].super=true;
265         pIDxName_["7"] = 7;
266         plyrNames_[7]["7"] = true;
267         
268         pIDxAddr_[address(0xb00B860546F13268DC9Fa922B63342BC9C5a28a6)] = 8;
269         plyr_[8].addr = address(0xb00B860546F13268DC9Fa922B63342BC9C5a28a6);
270         plyr_[8].name = "8";
271         plyr_[8].super=false;
272         pIDxName_["8"] = 8;
273         plyrNames_[8]["8"] = true;
274         
275         pIDxAddr_[address(0x9DC1bB8FDD15C9781d7D590B59E5DAFC0e37Cf3e)] = 9;
276         plyr_[9].addr = address(0x9DC1bB8FDD15C9781d7D590B59E5DAFC0e37Cf3e);
277         plyr_[9].name = "9";
278         plyr_[9].super=false;
279         pIDxName_["9"] = 9;
280         plyrNames_[9]["9"] = true;
281         
282         pIDxAddr_[address(0x142Ba743cf9317eB54ba10c157870Af3cBb66bD3)] = 10;
283         plyr_[10].addr = address(0x142Ba743cf9317eB54ba10c157870Af3cBb66bD3);
284         plyr_[10].name = "10";
285         plyr_[10].super=false;
286         pIDxName_["10"] =10;
287         plyrNames_[10]["10"] = true;
288         
289         pIDxAddr_[address(0x8B8F389Eb845eB0735D6eA084A3215d86Ed70344)] = 11;
290         plyr_[11].addr = address(0x8B8F389Eb845eB0735D6eA084A3215d86Ed70344);
291         plyr_[11].name = "11";
292         plyr_[11].super=false;
293         pIDxName_["11"] =11;
294         plyrNames_[11]["11"] = true;
295         
296         pIDxAddr_[address(0x73974391d9B8Eae6F883503EffBc21E7dbAcf62c)] = 12;
297         plyr_[12].addr = address(0x73974391d9B8Eae6F883503EffBc21E7dbAcf62c);
298         plyr_[12].name = "12";
299         plyr_[12].super=false;
300         pIDxName_["12"] =12;
301         plyrNames_[12]["12"] = true;
302         
303         pIDxAddr_[address(0xf1b9167F73847874AdD274FDFf4E1546CC184d03)] = 13;
304         plyr_[13].addr = address(0xf1b9167F73847874AdD274FDFf4E1546CC184d03);
305         plyr_[13].name = "13";
306         plyr_[13].super=false;
307         pIDxName_["13"] =13;
308         plyrNames_[13]["13"] = true;
309         
310         pIDxAddr_[address(0x56948841d665A2903218018728979C0a8a47648A)] = 14;
311         plyr_[14].addr = address(0x56948841d665A2903218018728979C0a8a47648A);
312         plyr_[14].name = "14";
313         plyr_[14].super=false;
314         pIDxName_["14"] =14;
315         plyrNames_[14]["14"] = true;
316         
317         pIDxAddr_[address(0x94bC531328e2b39C53B7D2EBb8461E794d7999A1)] = 15;
318         plyr_[15].addr = address(0x94bC531328e2b39C53B7D2EBb8461E794d7999A1);
319         plyr_[15].name = "15";
320         plyr_[15].super=true;
321         pIDxName_["15"] =15;
322         plyrNames_[15]["15"] = true;
323         
324         pID_ = 15;
325 }
326 
327 //==============================================================================
328 //     _ _  _  _|. |`. _  _ _  .
329 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
330 //==============================================================================
331     /**
332      * @dev used to make sure no one can interact with contract until it has
333      * been activated.
334      */
335     modifier isActivated() {
336         require(activated_ == true, "its not ready yet.  check ?eta in discord");
337         _;
338     }
339 
340     /**
341      * @dev prevents contracts from interacting with fomo3d
342      */
343     modifier isHuman() {
344         address _addr = msg.sender;
345         uint256 _codeLength;
346 
347         assembly {_codeLength := extcodesize(_addr)}
348         require(_codeLength == 0, "sorry humans only");
349         _;
350     }
351 
352     /**
353      * @dev sets boundaries for incoming tx
354      */
355     modifier isWithinLimits(uint256 _eth) {
356         require(_eth >= 1000000000, "pocket lint: not a valid currency");
357         require(_eth <= 100000000000000000000000, "no vitalik, no");
358         _;
359     }
360 
361 //==============================================================================
362 //     _    |_ |. _   |`    _  __|_. _  _  _  .
363 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
364 //====|=========================================================================
365     /**
366      * @dev emergency buy uses last stored affiliate ID and team snek
367      */
368     function()
369         isActivated()
370         isHuman()
371         isWithinLimits(msg.value)
372         public
373         payable
374     {
375         // set up our tx event data and determine if player is new or not
376         LSDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
377 
378         // fetch player id
379         uint256 _pID = pIDxAddr_[msg.sender];
380 
381         // buy core
382         buyCore(_pID, plyr_[_pID].laff, 0, _eventData_);
383     }
384 
385     /**
386      * @dev converts all incoming ethereum to keys.
387      * -functionhash- 0x8f38f309 (using ID for affiliate)
388      * -functionhash- 0x98a0871d (using address for affiliate)
389      * -functionhash- 0xa65b37a1 (using name for affiliate)
390      * @param _affCode the ID/address/name of the player who gets the affiliate fee
391      * @param _team what team is the player playing for?
392      */
393     function buyXid(uint256 _affCode, uint256 _team)
394         isActivated()
395         isHuman()
396         isWithinLimits(msg.value)
397         public
398         payable
399     {
400         // set up our tx event data and determine if player is new or not
401         LSDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
402 
403         // fetch player id
404         uint256 _pID = pIDxAddr_[msg.sender];
405 
406         // manage affiliate residuals
407         // if no affiliate code was given or player tried to use their own, lolz
408         if (_affCode == 0 || _affCode == _pID)
409         {
410             // use last stored affiliate code
411             _affCode = plyr_[_pID].laff;
412 
413         // if affiliate code was given & its not the same as previously stored
414         } else if (_affCode != plyr_[_pID].laff) {
415             // update last affiliate
416             plyr_[_pID].laff = _affCode;
417         }
418 
419         // verify a valid team was selected
420         //_team = verifyTeam(_team);
421 
422         // buy core
423         buyCore(_pID, _affCode, _team, _eventData_);
424     }
425 
426     function buyXaddr(address _affCode, uint256 _team)
427         isActivated()
428         isHuman()
429         isWithinLimits(msg.value)
430         public
431         payable
432     {
433         // set up our tx event data and determine if player is new or not
434         LSDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
435 
436         // fetch player id
437         uint256 _pID = pIDxAddr_[msg.sender];
438 
439         // manage affiliate residuals
440         uint256 _affID;
441         // if no affiliate code was given or player tried to use their own, lolz
442         if (_affCode == address(0) || _affCode == msg.sender)
443         {
444             // use last stored affiliate code
445             _affID = plyr_[_pID].laff;
446 
447         // if affiliate code was given
448         } else {
449             // get affiliate ID from aff Code
450             _affID = pIDxAddr_[_affCode];
451 
452             // if affID is not the same as previously stored
453             if (_affID != plyr_[_pID].laff)
454             {
455                 // update last affiliate
456                 plyr_[_pID].laff = _affID;
457             }
458         }
459         // buy core
460         buyCore(_pID, _affID, _team, _eventData_);
461     }
462 
463     /**
464      * @dev essentially the same as buy, but instead of you sending ether
465      * from your wallet, it uses your unwithdrawn earnings.
466      * -functionhash- 0x349cdcac (using ID for affiliate)
467      * -functionhash- 0x82bfc739 (using address for affiliate)
468      * -functionhash- 0x079ce327 (using name for affiliate)
469      * @param _affCode the ID/address/name of the player who gets the affiliate fee
470      * @param _team what team is the player playing for?
471      * @param _eth amount of earnings to use (remainder returned to gen vault)
472      */
473     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
474         isActivated()
475         isHuman()
476         isWithinLimits(_eth)
477         public
478     {
479         // set up our tx event data
480         LSDatasets.EventReturns memory _eventData_;
481 
482         // fetch player ID
483         uint256 _pID = pIDxAddr_[msg.sender];
484 
485         // manage affiliate residuals
486         // if no affiliate code was given or player tried to use their own, lolz
487         if (_affCode == 0 || _affCode == _pID)
488         {
489             // use last stored affiliate code
490             _affCode = plyr_[_pID].laff;
491 
492         // if affiliate code was given & its not the same as previously stored
493         } else if (_affCode != plyr_[_pID].laff) {
494             // update last affiliate
495             plyr_[_pID].laff = _affCode;
496         }
497 
498         // verify a valid team was selected
499         //_team = verifyTeam(_team);
500 
501         // reload core
502         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
503     }
504 
505     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
506         isActivated()
507         isHuman()
508         isWithinLimits(_eth)
509         public
510     {
511         // set up our tx event data
512         LSDatasets.EventReturns memory _eventData_;
513 
514         // fetch player ID
515         uint256 _pID = pIDxAddr_[msg.sender];
516 
517         // manage affiliate residuals
518         uint256 _affID;
519         // if no affiliate code was given or player tried to use their own, lolz
520         if (_affCode == address(0) || _affCode == msg.sender)
521         {
522             // use last stored affiliate code
523             _affID = plyr_[_pID].laff;
524 
525         // if affiliate code was given
526         } else {
527             // get affiliate ID from aff Code
528             _affID = pIDxAddr_[_affCode];
529 
530             // if affID is not the same as previously stored
531             if (_affID != plyr_[_pID].laff)
532             {
533                 // update last affiliate
534                 plyr_[_pID].laff = _affID;
535             }
536         }
537 
538         // reload core
539         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
540     }
541 
542     /**
543      * @dev withdraws all of your earnings.
544      * -functionhash- 0x3ccfd60b
545      */
546     function withdraw()
547         isActivated()
548         isHuman()
549         public
550     {
551         // setup local rID
552         uint256 _rID = rID_;
553 
554         // grab time
555         uint256 _now = now;
556 
557         // fetch player ID
558         uint256 _pID = pIDxAddr_[msg.sender];
559 
560         // setup temp var for player eth
561         uint256 _eth;
562 
563         // check to see if round has ended and no one has run round end yet
564         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
565         {
566             // set up our tx event data
567             LSDatasets.EventReturns memory _eventData_;
568 
569             // end the round (distributes pot)
570 			round_[_rID].ended = true;
571             _eventData_ = endRound(_eventData_);
572 
573 			// get their earnings
574             _eth = withdrawEarnings(_pID,true);
575 
576             // gib moni
577             if (_eth > 0)
578                 plyr_[_pID].addr.transfer(_eth);
579 
580             // build event data
581             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
582             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
583 
584            
585         // in any other situation
586         } else {
587             // get their earnings
588             _eth = withdrawEarnings(_pID,true);
589 
590             // gib moni
591             if (_eth > 0)
592                 plyr_[_pID].addr.transfer(_eth);
593 
594         }
595     }
596 
597 
598 //==============================================================================
599 //     _  _ _|__|_ _  _ _  .
600 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
601 //=====_|=======================================================================
602     /**
603      * @dev return the price buyer will pay for next 1 individual key.
604      * -functionhash- 0x018a25e8
605      * @return price for next key bought (in wei format)
606      */
607     function getBuyPrice()
608         public
609         view
610         returns(uint256)
611     {
612         // setup local rID
613         uint256 _rID = rID_;
614 
615         // grab time
616         uint256 _now = now;
617 
618         // are we in a round?
619         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
620             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
621         else // rounds over.  need price for new round
622             return ( 75000000000000 ); // init
623     }
624 
625     /**
626      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
627      * provider
628      * -functionhash- 0xc7e284b8
629      * @return time left in seconds
630      */
631     function getTimeLeft()
632         public
633         view
634         returns(uint256)
635     {
636         // setup local rID
637         uint256 _rID = rID_;
638 
639         // grab time
640         uint256 _now = now;
641 
642         if (_now < round_[_rID].end)
643             if (_now > round_[_rID].strt )
644                 return( (round_[_rID].end).sub(_now) );
645             else
646                 return( (round_[_rID].strt ).sub(_now) );
647         else
648             return(0);
649     }
650     
651     function getDailyTimeLeft()
652         public
653         view
654         returns(uint256)
655     {
656         // setup local rID
657         uint256 _rID = rID_;
658 
659         // grab time
660         uint256 _now = now;
661 
662         if (_now < round_[_rID].prizeTime)
663             return( (round_[_rID].prizeTime).sub(_now) );
664         else
665             return(0);
666     }
667 
668     /**
669      * @dev returns player earnings per vaults
670      * -functionhash- 0x63066434
671      * @return winnings vault
672      * @return general vault
673      * @return affiliate vault
674      */
675     function getPlayerVaults(uint256 _pID)
676         public
677         view
678         returns(uint256 ,uint256, uint256)
679     {
680         // setup local rID
681         uint256 _rID = rID_;
682 
683         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
684         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
685         {
686             // if player is winner
687             if (round_[_rID].plyr == _pID)
688             {
689                 return
690                 (
691                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(30)) / 100 ),
692                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
693                     plyr_[_pID].aff
694                 );
695             // if player is not the winner
696             } else {
697                 return
698                 (
699                     plyr_[_pID].win,
700                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
701                     plyr_[_pID].aff
702                 );
703             }
704 
705         // if round is still going on, or round has ended and round end has been ran
706         } else {
707             return
708             (
709                 plyr_[_pID].win,
710                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
711                 plyr_[_pID].aff
712             );
713         }
714     }
715 
716     /**
717      * solidity hates stack limits.  this lets us avoid that hate
718      */
719     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
720         private
721         view
722         returns(uint256)
723     {
724         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(gen_)) / 100).mul(1e18)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1e18)  );
725     }
726 
727     /**
728      * @dev returns all current round info needed for front end
729      * -functionhash- 0x747dff42
730      * @return eth invested during ICO phase
731      * @return round id
732      * @return total keys for round
733      * @return time round ends
734      * @return time round started
735      * @return current pot
736      * @return current team ID & player ID in lead
737      * @return current player in leads address
738      * @return current player in leads name
739      * @return whales eth in for round
740      * @return bears eth in for round
741      * @return sneks eth in for round
742      * @return bulls eth in for round
743      * @return airdrop tracker # & airdrop pot
744      */
745     function getCurrentRoundInfo()
746         public
747         view
748         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
749     {
750         // setup local rID
751         uint256 _rID = rID_;
752 
753         return
754         (
755             //round_[_rID].ico,               //0
756             0,                              //0
757             _rID,                           //1
758             round_[_rID].keys,              //2
759             round_[_rID].end,               //3
760             round_[_rID].strt,              //4
761             round_[_rID].pot,               //5
762             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
763             plyr_[round_[_rID].plyr].addr,  //7
764             plyr_[round_[_rID].plyr].name,  //8
765             rndTmEth_[_rID][0],             //9
766             rndTmEth_[_rID][1],             //10
767             rndTmEth_[_rID][2],             //11
768             rndTmEth_[_rID][3],             //12
769             airDropTracker_ + (airDropPot_ * 1000)              //13
770         );
771     }
772 
773     /**
774      * @dev returns player info based on address.  if no address is given, it will
775      * use msg.sender
776      * -functionhash- 0xee0b5d8b
777      * @param _addr address of the player you want to lookup
778      * @return player ID
779      * @return player name
780      * @return keys owned (current round)
781      * @return winnings vault
782      * @return general vault
783      * @return affiliate vault
784 	 * @return player round eth
785      */
786     function getPlayerInfoByAddress(address _addr)
787         public
788         view
789         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
790     {
791         // setup local rID
792         uint256 _rID = rID_;
793 
794         if (_addr == address(0))
795         {
796             _addr == msg.sender;
797         }
798         uint256 _pID = pIDxAddr_[_addr];
799 
800         return
801         (
802             _pID,                               //0
803             plyr_[_pID].name,                   //1
804             plyrRnds_[_pID][_rID].keys,         //2
805             plyr_[_pID].win,                    //3
806             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
807             plyr_[_pID].aff,                    //5
808             plyrRnds_[_pID][_rID].eth           //6
809         );
810     }
811 //==============================================================================
812 //     _ _  _ _   | _  _ . _  .
813 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
814 //=====================_|=======================================================
815     /**
816      * @dev logic runs whenever a buy order is executed.  determines how to handle
817      * incoming eth depending on if we are in an active round or not
818      */
819     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, LSDatasets.EventReturns memory _eventData_)
820         private
821     {
822         // setup local rID
823         uint256 _rID = rID_;
824 
825         // grab time
826         uint256 _now = now;
827 
828         // if round is active
829         if (_now > round_[_rID].strt && _now<round_[_rID].prizeTime  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
830         {
831             // call core
832             if(_now>(round_[_rID].prizeTime-prizeTimeInc_)&& _now<(round_[_rID].prizeTime-prizeTimeInc_+stopTime_)){
833                 plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
834             }else{
835                   core(_rID, _pID, msg.value, _affID, _team, _eventData_);
836             }
837         // if round is not active
838         } else {
839             // check to see if end round needs to be ran
840             if ((_now > round_[_rID].end||_now>round_[_rID].prizeTime) && round_[_rID].ended == false)
841             {
842                 // end the round (distributes pot) & start new round
843 			    round_[_rID].ended = true;
844                 _eventData_ = endRound(_eventData_);
845 
846                 // build event data
847                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
848                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
849 
850             }
851 
852             // put eth in players vault
853             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
854         }
855     }
856 
857     /**
858      * @dev logic runs whenever a reload order is executed.  determines how to handle
859      * incoming eth depending on if we are in an active round or not
860      */
861     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, LSDatasets.EventReturns memory _eventData_)
862         private
863     {
864         // setup local rID
865         uint256 _rID = rID_;
866 
867         // grab time
868         uint256 _now = now;
869 
870         // if round is active
871         if (_now > round_[_rID].strt && _now<round_[_rID].prizeTime  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
872         {
873             // get earnings from all vaults and return unused to gen vault
874             // because we use a custom safemath library.  this will throw if player
875             // tried to spend more eth than they have.
876             if(_now>(round_[_rID].prizeTime-prizeTimeInc_)&& _now<(round_[_rID].prizeTime-prizeTimeInc_+stopTime_)){
877                 revert();
878             }
879             plyr_[_pID].gen = withdrawEarnings(_pID,false).sub(_eth);
880 
881             // call core
882             core(_rID, _pID, _eth, _affID, _team, _eventData_);
883 
884         // if round is not active and end round needs to be ran
885         } else if ((_now > round_[_rID].end||_now>round_[_rID].prizeTime) && round_[_rID].ended == false) {
886             // end the round (distributes pot) & start new round
887             round_[_rID].ended = true;
888             _eventData_ = endRound(_eventData_);
889 
890             // build event data
891             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
892             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
893 
894         }
895     }
896 
897     /**
898      * @dev this is the core logic for any buy/reload that happens while a round
899      * is live.
900      */
901     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, LSDatasets.EventReturns memory _eventData_)
902         private
903     {
904         // if player is new to round
905         if (plyrRnds_[_pID][_rID].keys == 0)
906             _eventData_ = managePlayer(_pID, _eventData_);
907 
908         // early round eth limiter
909         if (round_[_rID].eth < 1e20 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1e18)
910         {
911             uint256 _availableLimit = (1e18).sub(plyrRnds_[_pID][_rID].eth);
912             uint256 _refund = _eth.sub(_availableLimit);
913             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
914             _eth = _availableLimit;
915         }
916 
917         // if eth left is greater than min eth allowed (sorry no pocket lint)
918         if (_eth > 1e9)
919         {
920 
921             // mint the new keys
922             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
923 
924             // if they bought at least 1 whole key
925             if (_keys >= 1e18)
926             {
927             updateTimer(_keys, _rID);
928 
929             // set new leaders
930             if (round_[_rID].plyr != _pID)
931                 round_[_rID].plyr = _pID;
932             if (round_[_rID].team != _team)
933                 round_[_rID].team = _team;
934 
935             // set the new leader bool to true
936             _eventData_.compressedData = _eventData_.compressedData + 100;
937         }
938 
939             // manage airdrops
940             if (_eth >= 1e17)
941             {
942             airDropTracker_++;
943             if (airdrop() == true)
944             {
945                 // gib muni
946                 uint256 _prize;
947                 if (_eth >= 1e19)
948                 {
949                     // calculate prize and give it to winner
950                     _prize = ((airDropPot_).mul(75)) / 100;
951                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
952 
953                     // adjust airDropPot
954                     airDropPot_ = (airDropPot_).sub(_prize);
955 
956                     // let event know a tier 3 prize was won
957                     _eventData_.compressedData += 300000000000000000000000000000000;
958                 } else if (_eth >= 1e18 && _eth < 1e19) {
959                     // calculate prize and give it to winner
960                     _prize = ((airDropPot_).mul(50)) / 100;
961                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
962 
963                     // adjust airDropPot
964                     airDropPot_ = (airDropPot_).sub(_prize);
965 
966                     // let event know a tier 2 prize was won
967                     _eventData_.compressedData += 200000000000000000000000000000000;
968                 } else if (_eth >= 1e17 && _eth < 1e18) {
969                     // calculate prize and give it to winner
970                     _prize = ((airDropPot_).mul(25)) / 100;
971                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
972 
973                     // adjust airDropPot
974                     airDropPot_ = (airDropPot_).sub(_prize);
975 
976                     // let event know a tier 3 prize was won
977                     _eventData_.compressedData += 300000000000000000000000000000000;
978                 }
979                 // set airdrop happened bool to true
980                 _eventData_.compressedData += 10000000000000000000000000000000;
981                 // let event know how much was won
982                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
983 
984                 // reset air drop tracker
985                 airDropTracker_ = 0;
986             }
987         }
988 
989             // store the air drop tracker number (number of buys since last airdrop)
990             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
991 
992             // update player
993             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
994             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
995 
996             // update round
997             round_[_rID].plyrCtr++;
998             plyrOrders_[round_[_rID].plyrCtr] = _pID; // for recording the 50 winners
999             if(_eth>minBuyForPrize_){
1000                  round_[_rID].plyrForPrizeCtr++;
1001                  plyrForPrizeOrders_[round_[_rID].plyrForPrizeCtr]=_pID;
1002             }
1003             round_[_rID].keys = _keys.add(round_[_rID].keys);
1004             round_[_rID].eth = _eth.add(round_[_rID].eth);
1005             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1006 
1007             // distribute eth
1008             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1009             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1010 
1011             checkDoubledProfit(_pID, _rID);
1012             checkDoubledProfit(_affID, _rID);
1013             // call end tx function to fire end tx event.
1014 		    //endTx(_pID, _team, _eth, _keys, _eventData_);
1015         }
1016     }
1017 //==============================================================================
1018 //     _ _ | _   | _ _|_ _  _ _  .
1019 //    (_(_||(_|_||(_| | (_)| _\  .
1020 //==============================================================================
1021     /**
1022      * @dev calculates unmasked earnings (just calculates, does not update mask)
1023      * @return earnings in wei format
1024      */
1025     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1026         private
1027         view
1028         returns(uint256)
1029     {
1030         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1031     }
1032 
1033     /**
1034      * @dev returns the amount of keys you would get given an amount of eth.
1035      * -functionhash- 0xce89c80c
1036      * @param _rID round ID you want price for
1037      * @param _eth amount of eth sent in
1038      * @return keys received
1039      */
1040     function calcKeysReceived(uint256 _rID, uint256 _eth)
1041         public
1042         view
1043         returns(uint256)
1044     {
1045         // grab time
1046         uint256 _now = now;
1047 
1048         // are we in a round?
1049         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1050             return ( (round_[_rID].eth).keysRec(_eth) );
1051         else // rounds over.  need keys for new round
1052             return ( (_eth).keys() );
1053     }
1054 
1055     /**
1056      * @dev returns current eth price for X keys.
1057      * -functionhash- 0xcf808000
1058      * @param _keys number of keys desired (in 18 decimal format)
1059      * @return amount of eth needed to send
1060      */
1061     function iWantXKeys(uint256 _keys)
1062         public
1063         view
1064         returns(uint256)
1065     {
1066         // setup local rID
1067         uint256 _rID = rID_;
1068 
1069         // grab time
1070         uint256 _now = now;
1071 
1072         // are we in a round?
1073         if (_now > round_[_rID].strt  && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1074             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1075         else // rounds over.  need price for new round
1076             return ( (_keys).eth() );
1077     }
1078 
1079     /**
1080      * @dev gets existing or registers new pID.  use this when a player may be new
1081      * @return pID
1082      */
1083     function determinePID(LSDatasets.EventReturns memory _eventData_)
1084         private
1085         returns (LSDatasets.EventReturns)
1086     {
1087         uint256 _pID = pIDxAddr_[msg.sender];
1088         // if player is new to this version of fomo3d
1089         if (_pID == 0)
1090         {
1091             // grab their player ID, name and last aff ID, from player names contract
1092             _pID = getPlayerID(msg.sender);
1093             bytes32 _name = getPlayerName(_pID);
1094             uint256 _laff = getPlayerLAff(_pID);
1095 
1096             // set up player account
1097             pIDxAddr_[msg.sender] = _pID;
1098             plyr_[_pID].addr = msg.sender;
1099 
1100             if (_name != "")
1101             {
1102                 pIDxName_[_name] = _pID;
1103                 plyr_[_pID].name = _name;
1104                 plyrNames_[_pID][_name] = true;
1105             }
1106 
1107             if (_laff != 0 && _laff != _pID)
1108                 plyr_[_pID].laff = _laff;
1109 
1110             // set the new player bool to true
1111             _eventData_.compressedData = _eventData_.compressedData + 1;
1112         }
1113         return (_eventData_);
1114     }
1115 
1116     
1117     /**
1118      * @dev decides if round end needs to be run & new round started.  and if
1119      * player unmasked earnings from previously played rounds need to be moved.
1120      */
1121     function managePlayer(uint256 _pID, LSDatasets.EventReturns memory _eventData_)
1122         private
1123         returns (LSDatasets.EventReturns)
1124     {
1125         // if player has played a previous round, move their unmasked earnings
1126         // from that round to gen vault.
1127         if (plyr_[_pID].lrnd != 0)
1128             updateGenVault(_pID, plyr_[_pID].lrnd);
1129 
1130         // update player's last round played
1131         plyr_[_pID].lrnd = rID_;
1132 
1133         // set the joined round bool to true
1134         _eventData_.compressedData = _eventData_.compressedData + 10;
1135 
1136         return(_eventData_);
1137     }
1138 
1139     /**
1140      * @dev ends the round. manages paying out winner/splitting up pot
1141      */
1142     function endRound(LSDatasets.EventReturns memory _eventData_)
1143         private
1144         returns (LSDatasets.EventReturns)
1145     {
1146         // setup local rID
1147         uint256 _rID = rID_;
1148          uint _prizeTime=round_[rID_].prizeTime;
1149         // grab our winning player and team id's
1150         uint256 _winPID = round_[_rID].plyr;
1151         //uint256 _winTID = round_[_rID].team;
1152 
1153         // grab our pot amount
1154         uint256 _pot = round_[_rID].pot;
1155 
1156         // calculate our winner share, community rewards, gen share,
1157         // p3d share, and amount reserved for next pot
1158         //uint256 _win = (_pot.mul(bigPrize_)) / 100;
1159         uint256 _com = (_pot / 20);
1160         uint256 _res = _pot.sub(_com);
1161        
1162 
1163         uint256 _winLeftP;
1164          if(now>_prizeTime){
1165              _winLeftP=pay10WinnersDaily(_pot);
1166          }else{
1167              _winLeftP=pay10Winners(_pot);
1168          }
1169          _res=_res.sub(_pot.mul((74).sub(_winLeftP)).div(100));
1170          admin.transfer(_com);
1171 
1172         // prepare event data
1173         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1174         //_eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1175         _eventData_.winnerAddr = plyr_[_winPID].addr;
1176         _eventData_.winnerName = plyr_[_winPID].name;
1177         _eventData_.newPot = _res;
1178 
1179         // start next round
1180        
1181         if(now>_prizeTime){
1182             _prizeTime=nextPrizeTime();
1183         }
1184         rID_++;
1185         _rID++;
1186         round_[_rID].prizeTime=_prizeTime;
1187         round_[_rID].strt = now;
1188         round_[_rID].end = now.add(rndInit_);
1189         round_[_rID].pot = _res;
1190 
1191         return(_eventData_);
1192     }
1193     function pay10Winners(uint256 _pot) private returns(uint256){
1194         uint256 _left=74;
1195         uint256 _rID = rID_;
1196         uint256 _plyrCtr=round_[_rID].plyrCtr;
1197         if(_plyrCtr>=1){
1198             uint256 _win1= _pot.mul(bigPrize_).div(100);//30%
1199             plyr_[plyrOrders_[_plyrCtr]].win=_win1.add( plyr_[plyrOrders_[_plyrCtr]].win);
1200             _left=_left.sub(bigPrize_);
1201         }else{
1202             return(_left);
1203         }
1204         if(_plyrCtr>=2){
1205             uint256 _win2=_pot.div(5);// 20%
1206             plyr_[plyrOrders_[_plyrCtr-1]].win=_win2.add( plyr_[plyrOrders_[_plyrCtr]-1].win);
1207             _left=_left.sub(20);
1208         }else{
1209             return(_left);
1210         }
1211         if(_plyrCtr>=3){
1212             uint256 _win3=_pot.div(10);//10%
1213             plyr_[plyrOrders_[_plyrCtr-2]].win=_win3.add( plyr_[plyrOrders_[_plyrCtr]-2].win);
1214             _left=_left.sub(10);
1215         }else{
1216             return(_left);
1217         }
1218         uint256 _win4=_pot.div(50);//2%*7=14%
1219         for(uint256 i=_plyrCtr-3;(i>_plyrCtr-10)&&(i>0);i--){
1220              if(i==0)
1221                  return(_left);
1222              plyr_[plyrOrders_[i]].win=_win4.add(plyr_[plyrOrders_[i]].win);
1223              _left=_left.sub(2);
1224         }
1225         return(_left);
1226     }
1227     function pay10WinnersDaily(uint256 _pot) private returns(uint256){
1228         uint256 _left=74;
1229         uint256 _rID = rID_;
1230         uint256 _plyrForPrizeCtr=round_[_rID].plyrForPrizeCtr;
1231         if(_plyrForPrizeCtr>=1){
1232             uint256 _win1= _pot.mul(bigPrize_).div(100);//30%
1233             plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]].win=_win1.add( plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]].win);
1234             _left=_left.sub(bigPrize_);
1235         }else{
1236             return(_left);
1237         }
1238         if(_plyrForPrizeCtr>=2){
1239             uint256 _win2=_pot.div(5);//20%
1240             plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr-1]].win=_win2.add( plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]-1].win);
1241             _left=_left.sub(20);
1242         }else{
1243             return(_left);
1244         }
1245         if(_plyrForPrizeCtr>=3){
1246             uint256 _win3=_pot.div(10);//10%
1247             plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr-2]].win=_win3.add( plyr_[plyrForPrizeOrders_[_plyrForPrizeCtr]-2].win);
1248             _left=_left.sub(10);
1249         }else{
1250             return(_left);
1251         }
1252         uint256 _win4=_pot.div(50);//2%*7=14%
1253         for(uint256 i=_plyrForPrizeCtr-3;(i>_plyrForPrizeCtr-10)&&(i>0);i--){
1254              if(i==0)
1255                  return(_left);
1256              plyr_[plyrForPrizeOrders_[i]].win=_win4.add(plyr_[plyrForPrizeOrders_[i]].win);
1257              _left=_left.sub(2);
1258         }
1259         return(_left);
1260     }
1261     function nextPrizeTime() private returns(uint256){
1262         while(true){
1263             uint256 _prizeTime=round_[rID_].prizeTime;
1264             _prizeTime =_prizeTime.add(prizeTimeInc_);
1265             if(_prizeTime>now)
1266                 return(_prizeTime);
1267         }
1268         return(round_[rID_].prizeTime.add( prizeTimeInc_));
1269     }
1270 
1271     /**
1272      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1273      */
1274     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1275         private
1276     {
1277         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1278         if (_earnings > 0)
1279         {
1280             // put in gen vault
1281             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1282             // zero out their earnings by updating mask
1283             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1284             plyrRnds_[_pID][_rIDlast].keyProfit = _earnings.add(plyrRnds_[_pID][_rIDlast].keyProfit); 
1285         }
1286     }
1287 
1288     /**
1289      * @dev updates round timer based on number of whole keys bought.
1290      */
1291     function updateTimer(uint256 _keys, uint256 _rID)
1292         private
1293     {
1294         // grab time
1295         uint256 _now = now;
1296 
1297         // calculate time based on number of keys bought
1298         uint256 _newTime;
1299         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1300             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1301         else
1302             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1303 
1304         // compare to max and set new end time
1305         if (_newTime < (rndMax_).add(_now))
1306             round_[_rID].end = _newTime;
1307         else
1308             round_[_rID].end = rndMax_.add(_now);
1309     }
1310 
1311 
1312     /**
1313      * @dev generates a random number between 0-99 and checks to see if thats
1314      * resulted in an airdrop win
1315      * @return do we have a winner?
1316      */
1317     function airdrop()
1318         private
1319         view
1320         returns(bool)
1321     {
1322         uint256 seed = uint256(keccak256(abi.encodePacked(
1323 
1324             (block.timestamp).add
1325             (block.difficulty).add
1326             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1327             (block.gaslimit).add
1328             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1329             (block.number)
1330 
1331         )));
1332         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1333             return(true);
1334         else
1335             return(false);
1336     }
1337 
1338     /**
1339      * @dev distributes eth based on fees to com, aff, and p3d
1340      */
1341     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, LSDatasets.EventReturns memory _eventData_)
1342         private
1343         returns(LSDatasets.EventReturns)
1344     {
1345         // pay 5% out to community rewards
1346         uint256 _com = _eth / 20;
1347 
1348         uint256 _invest_return = 0;
1349         bool _isSuper=plyr_[_affID].super;
1350         _invest_return = distributeInvest(_pID, _eth, _affID,_isSuper);
1351         if(_isSuper==false)
1352              _com = _com.mul(2);
1353         _com = _com.add(_invest_return);
1354 
1355 
1356         plyr_[pIdx_].aff=_com.add(plyr_[pIdx_].aff);
1357         return(_eventData_);
1358     }
1359 
1360     /**
1361      * @dev distributes eth based on fees to com, aff, and p3d
1362      */
1363     function distributeInvest(uint256 _pID, uint256 _aff_eth, uint256 _affID,bool _isSuper)
1364         private
1365         returns(uint256)
1366     {
1367 
1368         uint256 _left=0;
1369         uint256 _aff;
1370         uint256 _aff_2;
1371         uint256 _aff_3;
1372         uint256 _affID_1;
1373         uint256 _affID_2;
1374         uint256 _affID_3;
1375         // distribute share to affiliate
1376         if(_isSuper==true)
1377             _aff = _aff_eth.mul(12).div(100);
1378         else
1379             _aff = _aff_eth.div(10);
1380         _aff_2 = _aff_eth.mul(3).div(100);
1381         _aff_3 = _aff_eth.div(100);
1382 
1383         _affID_1 = _affID;// up one member
1384         _affID_2 = plyr_[_affID_1].laff;// up two member
1385         _affID_3 = plyr_[_affID_2].laff;// up three member
1386 
1387         // decide what to do with affiliate share of fees
1388         // affiliate must not be self, and must have a name registered
1389         if (_affID != _pID && plyr_[_affID].name != '') {
1390             plyr_[_affID_1].aff = _aff.add(plyr_[_affID_1].aff);
1391             if(_isSuper==true){
1392                 uint256 _affToPID=_aff_eth.mul(3).div(100);
1393                 plyr_[_pID].aff = _affToPID.add(plyr_[_pID].aff);
1394             }
1395               
1396             //emit LSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1397         } else {
1398             _left = _left.add(_aff);
1399         }
1400 
1401         if (_affID_2 != _pID && _affID_2 != _affID && plyr_[_affID_2].name != '') {
1402             plyr_[_affID_2].aff = _aff_2.add(plyr_[_affID_2].aff);
1403         } else {
1404             _left = _left.add(_aff_2);
1405         }
1406 
1407         if (_affID_3 != _pID &&  _affID_3 != _affID && plyr_[_affID_3].name != '') {
1408             plyr_[_affID_3].aff = _aff_3.add(plyr_[_affID_3].aff);
1409         } else {
1410             _left= _left.add(_aff_3);
1411         }
1412         return _left;
1413     }
1414 
1415     function potSwap()
1416         external
1417         payable
1418     {
1419         // setup local rID
1420         uint256 _rID = rID_ + 1;
1421 
1422         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1423         //emit LSEvents.onPotSwapDeposit(_rID, msg.value);
1424     }
1425 
1426     /**
1427      * @dev distributes eth based on fees to gen and pot
1428      */
1429     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, LSDatasets.EventReturns memory _eventData_)
1430         private
1431         returns(LSDatasets.EventReturns)
1432     {
1433         // calculate gen share
1434         uint256 _gen = (_eth.mul(gen_)) / 100;
1435 
1436         // toss 2% into airdrop pot
1437         uint256 _air = (_eth / 50);
1438         uint256 _com= (_eth / 20);
1439         uint256 _aff=(_eth.mul(19))/100;
1440         airDropPot_ = airDropPot_.add(_air);
1441 
1442         // calculate pot
1443         //uint256 _pot = (((_eth.sub(_gen)).sub(_air)).sub(_com)).sub(_aff);
1444         uint256 _pot= _eth.sub(_gen).sub(_air);
1445         _pot=_pot.sub(_com).sub(_aff);
1446         // distribute gen share (thats what updateMasks() does) and adjust
1447         // balances for dust.
1448         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1449         if (_dust > 0)
1450             _gen = _gen.sub(_dust);
1451 
1452         // add eth to pot
1453         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1454 
1455         // set up event data
1456         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1457         _eventData_.potAmount = _pot;
1458 
1459         return(_eventData_);
1460     }
1461 
1462    function checkDoubledProfit(uint256 _pID, uint256 _rID)
1463         private
1464     {   
1465         // if pID has no keys, skip this
1466         uint256 _keys = plyrRnds_[_pID][_rID].keys;
1467         if (_keys > 0) {
1468 
1469             uint256 _genVault = plyr_[_pID].gen;
1470             uint256 _genWithdraw = plyrRnds_[_pID][_rID].genWithdraw;
1471             uint256 _genEarning = calcUnMaskedKeyEarnings(_pID, plyr_[_pID].lrnd);
1472             uint256 _doubleProfit = (plyrRnds_[_pID][_rID].eth).mul(2);
1473             if (_genVault.add(_genWithdraw).add(_genEarning) >= _doubleProfit)
1474             {
1475                 // put only calculated-remain-profit into gen vault
1476                 uint256 _remainProfit = _doubleProfit.sub(_genVault).sub(_genWithdraw);
1477                 plyr_[_pID].gen = _remainProfit.add(plyr_[_pID].gen); 
1478                 plyrRnds_[_pID][_rID].keyProfit = _remainProfit.add(plyrRnds_[_pID][_rID].keyProfit); // follow maskKey
1479 
1480                 round_[_rID].keys = round_[_rID].keys.sub(_keys);
1481                 plyrRnds_[_pID][_rID].keys = plyrRnds_[_pID][_rID].keys.sub(_keys);
1482 
1483                 plyrRnds_[_pID][_rID].mask = 0; // treat this player like a new player
1484             }   
1485         }
1486     }
1487     function calcUnMaskedKeyEarnings(uint256 _pID, uint256 _rIDlast)
1488         private
1489         view
1490         returns(uint256)
1491     {
1492         if (    (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18))  >    (plyrRnds_[_pID][_rIDlast].mask)       )
1493             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1e18)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1494         else
1495             return 0;
1496     }
1497 
1498     /**
1499      * @dev updates masks for round and player when keys are bought
1500      * @return dust left over
1501      */
1502     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1503         private
1504         returns(uint256)
1505     {
1506         /* MASKING NOTES
1507             earnings masks are a tricky thing for people to wrap their minds around.
1508             the basic thing to understand here.  is were going to have a global
1509             tracker based on profit per share for each round, that increases in
1510             relevant proportion to the increase in share supply.
1511 
1512             the player will have an additional mask that basically says "based
1513             on the rounds mask, my shares, and how much i've already withdrawn,
1514             how much is still owed to me?"
1515         */
1516 
1517         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1518         uint256 _ppt = (_gen.mul(1e18)) / (round_[_rID].keys);
1519         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1520 
1521         // calculate player earning from their own buy (only based on the keys
1522         // they just bought).  & update player earnings mask
1523         uint256 _pearn = (_ppt.mul(_keys)) / (1e18);
1524         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1e18)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1525 
1526         // calculate & return dust
1527         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1e18)));
1528     }
1529 
1530     /**
1531      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1532      * @return earnings in wei format
1533      */
1534     function withdrawEarnings(uint256 _pID,bool isWithdraw)
1535         private
1536         returns(uint256)
1537     {
1538         // update gen vault
1539         updateGenVault(_pID, plyr_[_pID].lrnd);
1540         if (isWithdraw)
1541             plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw = plyr_[_pID].gen.add(plyrRnds_[_pID][plyr_[_pID].lrnd].genWithdraw);
1542         // from vaults
1543         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1544         if (_earnings > 0)
1545         {
1546             plyr_[_pID].win = 0;
1547             plyr_[_pID].gen = 0;
1548             plyr_[_pID].aff = 0;
1549         }
1550 
1551         return(_earnings);
1552     }
1553 
1554 //==============================================================================
1555 //    (~ _  _    _._|_    .
1556 //    _)(/_(_|_|| | | \/  .
1557 //====================/=========================================================
1558     /** upon contract deploy, it will be deactivated.  this is a one time
1559      * use function that will activate the contract.  we do this so devs
1560      * have time to set things up on the web end                            **/
1561     bool public activated_ = false;
1562     function activate()
1563         public
1564     {
1565         // only team just can activate
1566         require(msg.sender == admin, "only admin can activate"); // erik
1567 
1568 
1569         // can only be ran once
1570         require(activated_ == false, "LuckyStar already activated");
1571 
1572         // activate the contract
1573         activated_ = true;
1574 
1575         // lets start first round
1576         rID_ = 1;
1577         round_[1].strt = now ;
1578         round_[1].end = now + rndInit_ ;
1579         round_[1].prizeTime=1536062400;
1580     }
1581     
1582      function setMinBuyForPrize(uint256 _min)
1583       onlyOwner()
1584         public{
1585          minBuyForPrize_ = _min;
1586     }
1587 }
1588 
1589 //==============================================================================
1590 //   __|_ _    __|_ _  .
1591 //  _\ | | |_|(_ | _\  .
1592 //==============================================================================
1593 library LSDatasets {
1594 
1595     struct EventReturns {
1596         uint256 compressedData;
1597         uint256 compressedIDs;
1598         address winnerAddr;         // winner address
1599         bytes32 winnerName;         // winner name
1600         uint256 amountWon;          // amount won
1601         uint256 newPot;             // amount in new pot
1602         uint256 P3DAmount;          // amount distributed to p3d
1603         uint256 genAmount;          // amount distributed to gen
1604         uint256 potAmount;          // amount added to pot
1605     }
1606     struct Player {
1607         address addr;   // player address
1608         bytes32 name;   // player name
1609         uint256 win;    // winnings vault
1610         uint256 gen;    // general vault
1611         uint256 aff;    // affiliate vault
1612         uint256 lrnd;   // last round played
1613         uint256 laff;   // last affiliate id used
1614         bool super;
1615         //uint256 names;
1616     }
1617     struct PlayerRounds {
1618         uint256 eth;    // eth player has added to round (used for eth limiter)
1619         uint256 keys;   // keys
1620         uint256 mask;   // player mask
1621         uint256 keyProfit;
1622         //uint256 ico;    // ICO phase investment
1623         uint256 genWithdraw;
1624     }
1625     struct Round {
1626         uint256 plyr;   // pID of player in lead
1627         uint256 plyrCtr;   // play counter for plyOrders
1628         uint256 plyrForPrizeCtr;// player counter  for plyrForPrizeOrder
1629         uint256 prizeTime;
1630         uint256 team;   // tID of team in lead
1631         uint256 end;    // time ends/ended
1632         bool ended;     // has round end function been ran
1633         uint256 strt;   // time round started
1634         uint256 keys;   // keys
1635         uint256 eth;    // total eth in
1636         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1637         uint256 mask;   // global mask
1638     }
1639 
1640 }
1641 
1642 //==============================================================================
1643 //  |  _      _ _ | _  .
1644 //  |<(/_\/  (_(_||(_  .
1645 //=======/======================================================================
1646 library LSKeysCalcShort {
1647     using SafeMath for *;
1648     /**
1649      * @dev calculates number of keys received given X eth
1650      * @param _curEth current amount of eth in contract
1651      * @param _newEth eth being spent
1652      * @return amount of ticket purchased
1653      */
1654     function keysRec(uint256 _curEth, uint256 _newEth)
1655         internal
1656         pure
1657         returns (uint256)
1658     {
1659         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1660     }
1661 
1662     /**
1663      * @dev calculates amount of eth received if you sold X keys
1664      * @param _curKeys current amount of keys that exist
1665      * @param _sellKeys amount of keys you wish to sell
1666      * @return amount of eth received
1667      */
1668     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1669         internal
1670         pure
1671         returns (uint256)
1672     {
1673         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1674     }
1675 
1676     /**
1677      * @dev calculates how many keys would exist with given an amount of eth
1678      * @param _eth eth "in contract"
1679      * @return number of keys that would exist
1680      */
1681     function keys(uint256 _eth)
1682         internal
1683         pure
1684         returns(uint256)
1685     {
1686         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1687     }
1688 
1689     /**
1690      * @dev calculates how much eth would be in contract given a number of keys
1691      * @param _keys number of keys "in contract"
1692      * @return eth that would exists
1693      */
1694     function eth(uint256 _keys)
1695         internal
1696         pure
1697         returns(uint256)
1698     {
1699         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1700     }
1701 }
1702 
1703 
1704 
1705 library NameFilter {
1706     /**
1707      * @dev filters name strings
1708      * -converts uppercase to lower case.
1709      * -makes sure it does not start/end with a space
1710      * -makes sure it does not contain multiple spaces in a row
1711      * -cannot be only numbers
1712      * -cannot start with 0x
1713      * -restricts characters to A-Z, a-z, 0-9, and space.
1714      * @return reprocessed string in bytes32 format
1715      */
1716     function nameFilter(string _input)
1717         internal
1718         pure
1719         returns(bytes32)
1720     {
1721         bytes memory _temp = bytes(_input);
1722         uint256 _length = _temp.length;
1723 
1724         //sorry limited to 32 characters
1725         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1726         // make sure it doesnt start with or end with space
1727         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1728         // make sure first two characters are not 0x
1729         if (_temp[0] == 0x30)
1730         {
1731             require(_temp[1] != 0x78, "string cannot start with 0x");
1732             require(_temp[1] != 0x58, "string cannot start with 0X");
1733         }
1734 
1735         // create a bool to track if we have a non number character
1736         bool _hasNonNumber;
1737 
1738         // convert & check
1739         for (uint256 i = 0; i < _length; i++)
1740         {
1741             // if its uppercase A-Z
1742             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1743             {
1744                 // convert to lower case a-z
1745                 _temp[i] = byte(uint(_temp[i]) + 32);
1746 
1747                 // we have a non number
1748                 if (_hasNonNumber == false)
1749                     _hasNonNumber = true;
1750             } else {
1751                 require
1752                 (
1753                     // require character is a space
1754                     _temp[i] == 0x20 ||
1755                     // OR lowercase a-z
1756                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1757                     // or 0-9
1758                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1759                     "string contains invalid characters"
1760                 );
1761                 // make sure theres not 2x spaces in a row
1762                 if (_temp[i] == 0x20)
1763                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1764 
1765                 // see if we have a character other than a number
1766                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1767                     _hasNonNumber = true;
1768             }
1769         }
1770 
1771         require(_hasNonNumber == true, "string cannot be only numbers");
1772 
1773         bytes32 _ret;
1774         assembly {
1775             _ret := mload(add(_temp, 32))
1776         }
1777         return (_ret);
1778     }
1779 }
1780 
1781 /**
1782  * @title SafeMath v0.1.9
1783  * @dev Math operations with safety checks that throw on error
1784  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1785  * - added sqrt
1786  * - added sq
1787  * - added pwr
1788  * - changed asserts to requires with error log outputs
1789  * - removed div, its useless
1790  */
1791 library SafeMath {
1792 
1793     /**
1794     * @dev Multiplies two numbers, throws on overflow.
1795     */
1796     function mul(uint256 a, uint256 b)
1797         internal
1798         pure
1799         returns (uint256 c)
1800     {
1801         if (a == 0) {
1802             return 0;
1803         }
1804         c = a * b;
1805         require(c / a == b, "SafeMath mul failed");
1806         return c;
1807     }
1808 
1809      function div(uint256 a, uint256 b) internal pure returns (uint256) {
1810         uint256 c = a / b;
1811         return c;
1812     }
1813 
1814     /**
1815     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1816     */
1817     function sub(uint256 a, uint256 b)
1818         internal
1819         pure
1820         returns (uint256)
1821     {
1822         require(b <= a, "SafeMath sub failed");
1823         return a - b;
1824     }
1825 
1826     /**
1827     * @dev Adds two numbers, throws on overflow.
1828     */
1829     function add(uint256 a, uint256 b)
1830         internal
1831         pure
1832         returns (uint256 c)
1833     {
1834         c = a + b;
1835         require(c >= a, "SafeMath add failed");
1836         return c;
1837     }
1838 
1839 
1840     /**
1841      * @dev gives square root of given x.
1842      */
1843     function sqrt(uint256 x)
1844         internal
1845         pure
1846         returns (uint256 y)
1847     {
1848         uint256 z = ((add(x,1)) / 2);
1849         y = x;
1850         while (z < y)
1851         {
1852             y = z;
1853             z = ((add((x / z),z)) / 2);
1854         }
1855     }
1856 
1857     /**
1858      * @dev gives square. multiplies x by x
1859      */
1860     function sq(uint256 x)
1861         internal
1862         pure
1863         returns (uint256)
1864     {
1865         return (mul(x,x));
1866     }
1867 
1868     /**
1869      * @dev x to the power of y
1870      */
1871     function pwr(uint256 x, uint256 y)
1872         internal
1873         pure
1874         returns (uint256)
1875     {
1876         if (x==0)
1877             return (0);
1878         else if (y==0)
1879             return (1);
1880         else
1881         {
1882             uint256 z = x;
1883             for (uint256 i=1; i < y; i++)
1884                 z = mul(z,x);
1885             return (z);
1886         }
1887     }
1888 }