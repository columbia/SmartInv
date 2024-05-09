1 pragma solidity ^0.4.24;
2 /**
3  * @title -FoMo-3D v0.0.1
4  * 
5  * This product is protected under license.  Any unauthorized copy, modification, or use without 
6  * express written consent from the creators is prohibited.
7  * 
8  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
9  */
10 contract Owned {
11     address public owner;
12     address public newOwner;
13 
14     constructor()
15         public
16     {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address _newOwner) public onlyOwner {
26         newOwner = _newOwner;
27     }
28     function acceptOwnership() public {
29         require(msg.sender == newOwner);
30         owner = newOwner;
31         newOwner = address(0);
32     }
33 }
34 /**
35  * 通知部分
36  */
37 contract LOLevents {
38     // fired whenever a player registers a name
39     // 发送用户名事件
40     event onNewName
41     (
42         uint256 indexed playerID,           //用户ID
43         address indexed playerAddress,      //用户以太坊地址
44         bytes32 indexed playerName,         //用户昵称
45         bool isNewPlayer,                   //是否为新用户
46         uint256 affiliateID,                //推荐人ID
47         address affiliateAddress,           //推荐人地址
48         bytes32 affiliateName,              //推荐人昵称
49         uint256 amountPaid,                 //
50         uint256 timeStamp                   //时间戳
51     );
52     
53     // fired at end of buy or reload
54     event onEndTx
55     (
56         uint256 compressedData,     
57         uint256 compressedIDs,      
58         bytes32 playerName,
59         address playerAddress,
60         uint256 ethIn,
61         uint256 keysBought,
62         address winnerAddr,
63         bytes32 winnerName,
64         uint256 amountWon,
65         uint256 newPot,
66         uint256 P3DAmount,
67         uint256 genAmount,
68         uint256 potAmount,
69         uint256 airDropPot
70     );
71     
72 	// fired whenever theres a withdraw
73     event onWithdraw
74     (
75         uint256 indexed playerID,
76         address playerAddress,
77         bytes32 playerName,
78         uint256 ethOut,
79         uint256 timeStamp
80     );
81     
82     // fired whenever a withdraw forces end round to be ran
83     event onWithdrawAndDistribute
84     (
85         address playerAddress,
86         bytes32 playerName,
87         uint256 ethOut,
88         uint256 compressedData,
89         uint256 compressedIDs,
90         address winnerAddr,
91         bytes32 winnerName,
92         uint256 amountWon,
93         uint256 newPot,
94         uint256 P3DAmount,
95         uint256 genAmount
96     );
97     
98     // fired whenever a player tries a buy after round timer 
99     // hit zero, and causes end round to be ran.
100     event onBuyAndDistribute
101     (
102         address playerAddress,
103         bytes32 playerName,
104         uint256 ethIn,
105         uint256 compressedData,
106         uint256 compressedIDs,
107         address winnerAddr,
108         bytes32 winnerName,
109         uint256 amountWon,
110         uint256 newPot,
111         uint256 P3DAmount,
112         uint256 genAmount
113     );
114     
115     // fired whenever a player tries a reload after round timer 
116     // hit zero, and causes end round to be ran.
117     event onReLoadAndDistribute
118     (
119         address playerAddress,
120         bytes32 playerName,
121         uint256 compressedData,
122         uint256 compressedIDs,
123         address winnerAddr,
124         bytes32 winnerName,
125         uint256 amountWon,
126         uint256 newPot,
127         uint256 P3DAmount,
128         uint256 genAmount
129     );
130     
131     // fired whenever an affiliate is paid
132     event onAffiliatePayout
133     (
134         uint256 indexed affiliateID,
135         address affiliateAddress,
136         bytes32 affiliateName,
137         uint256 indexed roundID,
138         uint256 indexed buyerID,
139         uint256 amount,
140         uint256 timeStamp
141     );
142     
143     // received pot swap deposit
144     event onPotSwapDeposit
145     (
146         uint256 roundID,
147         uint256 amountAddedToPot
148     );
149 }
150 
151 //==============================================================================
152 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
153 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
154 //====================================|=========================================
155 
156 contract modularLong is LOLevents {}
157 
158 contract LOLlong is modularLong,Owned {
159     using SafeMath for *;                   //数学函数
160     using NameFilter for string;            //名字过滤
161     using LOLKeysCalcLong for uint256;
162 	
163 	//otherFoMo3D private otherF3D_;
164                                 
165     LOLOfficalBankInterface constant private lol_offical_bank = LOLOfficalBankInterface(0xF66E2D098D85b803D5ae710008fCc876c8656fFd);       
166 	LOLPlayerBookInterface constant private PlayerBook = LOLPlayerBookInterface(0xb9Db77600A611c1DfC923c2c8b513cB1Fc4Fe113);               
167 
168 //==============================================================================
169 //     _ _  _  |`. _     _ _ |_ | _  _  .
170 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
171 //=================_|===========================================================
172     string constant public name = "LOL Official";
173     string constant public symbol = "LOL";
174 	uint256 private rndExtra_ = 1 hours;//extSettings.getLongExtra();     // length of the very first ICO 
175     uint256 private rndGap_ = 24 hours;//extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
176     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
177     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
178     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
179 //==============================================================================
180 //     _| _ _|_ _    _ _ _|_    _   .
181 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
182 //=============================|================================================
183 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
184     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
185     uint256 public rID_;    // round id number / total rounds that have happened
186 //****************
187 // PLAYER DATA 
188 //****************
189     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
190     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
191     mapping (uint256 => LOLdatasets.Player) public plyr_;   // (pID => data) player data
192     mapping (uint256 => mapping (uint256 => LOLdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
193     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
194 //****************
195 // ROUND DATA 
196 //****************
197     mapping (uint256 => LOLdatasets.Round) public round_;   // (rID => data) round data
198     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
199 //****************
200 // TEAM FEE DATA 
201 //****************
202     mapping (uint256 => LOLdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
203     mapping (uint256 => LOLdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
204 //==============================================================================
205 //     _ _  _  __|_ _    __|_ _  _  .
206 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
207 //==============================================================================
208     constructor()
209         public
210     {
211 		// Team allocation structures
212         // 0 = whales
213         // 1 = bears
214         // 2 = sneks
215         // 3 = bulls
216 
217 		// Team allocation percentages
218         // (F3D, P3D) + (Pot , Referrals, Community)
219             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
220         fees_[0] = LOLdatasets.TeamFee(36,0);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
221         fees_[1] = LOLdatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
222         fees_[2] = LOLdatasets.TeamFee(66,0);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
223         fees_[3] = LOLdatasets.TeamFee(51,0);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
224         
225         // how to split up the final pot based on which team was picked
226         // (F3D, P3D)
227         potSplit_[0] = LOLdatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com 鲸鱼
228         potSplit_[1] = LOLdatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com 熊
229         potSplit_[2] = LOLdatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com 蛇
230         potSplit_[3] = LOLdatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com 牛
231 	}
232 //==============================================================================
233 //     _ _  _  _|. |`. _  _ _  .
234 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
235 //==============================================================================
236     /**
237      * @dev used to make sure no one can interact with contract until it has 
238      * been activated. 
239      */
240     modifier isActivated() {
241         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
242         _;
243     }
244     
245     /**
246      * @dev prevents contracts from interacting with fomo3d 
247      */
248     modifier isHuman() {
249         address _addr = msg.sender;
250         uint256 _codeLength;
251         
252         assembly {_codeLength := extcodesize(_addr)}
253         require(_codeLength == 0, "sorry humans only");
254         _;
255     }
256 
257     /**
258      * @dev sets boundaries for incoming tx 
259      */
260     modifier isWithinLimits(uint256 _eth) {
261         require(_eth >= 1000000000, "pocket lint: not a valid currency");
262         require(_eth <= 100000000000000000000000, "no vitalik, no");
263         _;    
264     }
265     
266 //==============================================================================
267 //     _    |_ |. _   |`    _  __|_. _  _  _  .
268 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
269 //====|=========================================================================
270     /**
271      * @dev emergency buy uses last stored affiliate ID and team snek
272      */
273     function()
274         isActivated()
275         isHuman()
276         isWithinLimits(msg.value)
277         public
278         payable
279     {
280         // set up our tx event data and determine if player is new or not
281         LOLdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
282             
283         // fetch player id
284         uint256 _pID = pIDxAddr_[msg.sender];
285         
286         // buy core 
287         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
288     }
289     
290     /**
291      * @dev converts all incoming ethereum to keys.
292      * -functionhash- 0x8f38f309 (using ID for affiliate)
293      * -functionhash- 0x98a0871d (using address for affiliate)
294      * -functionhash- 0xa65b37a1 (using name for affiliate)
295      * @param _affCode the ID/address/name of the player who gets the affiliate fee
296      * @param _team what team is the player playing for?
297      */
298     function buyXid(uint256 _affCode, uint256 _team)
299         isActivated()
300         isHuman()
301         isWithinLimits(msg.value)
302         public
303         payable
304     {
305         // set up our tx event data and determine if player is new or not
306         LOLdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
307         
308         // fetch player id
309         uint256 _pID = pIDxAddr_[msg.sender];
310         
311         // manage affiliate residuals
312         // if no affiliate code was given or player tried to use their own, lolz
313         if (_affCode == 0 || _affCode == _pID)
314         {
315             // use last stored affiliate code 
316             _affCode = plyr_[_pID].laff;
317             
318         // if affiliate code was given & its not the same as previously stored 
319         } else if (_affCode != plyr_[_pID].laff) {
320             // update last affiliate 
321             plyr_[_pID].laff = _affCode;
322         }
323         
324         // verify a valid team was selected
325         _team = verifyTeam(_team);
326         
327         // buy core 
328         buyCore(_pID, _affCode, _team, _eventData_);
329     }
330     
331     function buyXaddr(address _affCode, uint256 _team)
332         isActivated()
333         isHuman()
334         isWithinLimits(msg.value)
335         public
336         payable
337     {
338         // set up our tx event data and determine if player is new or not
339         LOLdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
340         
341         // fetch player id
342         uint256 _pID = pIDxAddr_[msg.sender];
343         
344         // manage affiliate residuals
345         uint256 _affID;
346         // if no affiliate code was given or player tried to use their own, lolz
347         if (_affCode == address(0) || _affCode == msg.sender)
348         {
349             // use last stored affiliate code
350             _affID = plyr_[_pID].laff;
351         
352         // if affiliate code was given    
353         } else {
354             // get affiliate ID from aff Code 
355             _affID = pIDxAddr_[_affCode];
356             
357             // if affID is not the same as previously stored 
358             if (_affID != plyr_[_pID].laff)
359             {
360                 // update last affiliate
361                 plyr_[_pID].laff = _affID;
362             }
363         }
364         
365         // verify a valid team was selected
366         _team = verifyTeam(_team);
367         
368         // buy core 
369         buyCore(_pID, _affID, _team, _eventData_);
370     }
371     
372     function buyXname(bytes32 _affCode, uint256 _team)
373         isActivated()
374         isHuman()
375         isWithinLimits(msg.value)
376         public
377         payable
378     {
379         // set up our tx event data and determine if player is new or not
380         LOLdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
381         
382         // fetch player id
383         uint256 _pID = pIDxAddr_[msg.sender];
384         
385         // manage affiliate residuals
386         uint256 _affID;
387         // if no affiliate code was given or player tried to use their own, lolz
388         if (_affCode == '' || _affCode == plyr_[_pID].name)
389         {
390             // use last stored affiliate code
391             _affID = plyr_[_pID].laff;
392         
393         // if affiliate code was given
394         } else {
395             // get affiliate ID from aff Code
396             _affID = pIDxName_[_affCode];
397             
398             // if affID is not the same as previously stored
399             if (_affID != plyr_[_pID].laff)
400             {
401                 // update last affiliate
402                 plyr_[_pID].laff = _affID;
403             }
404         }
405         
406         // verify a valid team was selected
407         _team = verifyTeam(_team);
408         
409         // buy core 
410         buyCore(_pID, _affID, _team, _eventData_);
411     }
412     
413     /**
414      * @dev essentially the same as buy, but instead of you sending ether 
415      * from your wallet, it uses your unwithdrawn earnings.
416      * -functionhash- 0x349cdcac (using ID for affiliate)
417      * -functionhash- 0x82bfc739 (using address for affiliate)
418      * -functionhash- 0x079ce327 (using name for affiliate)
419      * @param _affCode the ID/address/name of the player who gets the affiliate fee
420      * @param _team what team is the player playing for?
421      * @param _eth amount of earnings to use (remainder returned to gen vault)
422      */
423     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
424         isActivated()
425         isHuman()
426         isWithinLimits(_eth)
427         public
428     {
429         // set up our tx event data
430         LOLdatasets.EventReturns memory _eventData_;
431         
432         // fetch player ID
433         uint256 _pID = pIDxAddr_[msg.sender];
434         
435         // manage affiliate residuals
436         // if no affiliate code was given or player tried to use their own, lolz
437         if (_affCode == 0 || _affCode == _pID)
438         {
439             // use last stored affiliate code 
440             _affCode = plyr_[_pID].laff;
441             
442         // if affiliate code was given & its not the same as previously stored 
443         } else if (_affCode != plyr_[_pID].laff) {
444             // update last affiliate 
445             plyr_[_pID].laff = _affCode;
446         }
447 
448         // verify a valid team was selected
449         _team = verifyTeam(_team);
450 
451         // reload core
452         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
453     }
454     
455     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
456         isActivated()
457         isHuman()
458         isWithinLimits(_eth)
459         public
460     {
461         // set up our tx event data
462         LOLdatasets.EventReturns memory _eventData_;
463         
464         // fetch player ID
465         uint256 _pID = pIDxAddr_[msg.sender];
466         
467         // manage affiliate residuals
468         uint256 _affID;
469         // if no affiliate code was given or player tried to use their own, lolz
470         if (_affCode == address(0) || _affCode == msg.sender)
471         {
472             // use last stored affiliate code
473             _affID = plyr_[_pID].laff;
474         
475         // if affiliate code was given    
476         } else {
477             // get affiliate ID from aff Code 
478             _affID = pIDxAddr_[_affCode];
479             
480             // if affID is not the same as previously stored 
481             if (_affID != plyr_[_pID].laff)
482             {
483                 // update last affiliate
484                 plyr_[_pID].laff = _affID;
485             }
486         }
487         
488         // verify a valid team was selected
489         _team = verifyTeam(_team);
490         
491         // reload core
492         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
493     }
494     
495     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
496         isActivated()
497         isHuman()
498         isWithinLimits(_eth)
499         public
500     {
501         // set up our tx event data
502         LOLdatasets.EventReturns memory _eventData_;
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
560             LOLdatasets.EventReturns memory _eventData_;
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
578             emit LOLevents.onWithdrawAndDistribute
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
603             emit LOLevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
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
644         emit LOLevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
660         emit LOLevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
676         emit LOLevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
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
699         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
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
723             if (_now > round_[_rID].strt + rndGap_)
724                 return( (round_[_rID].end).sub(_now) );
725             else
726                 return( (round_[_rID].strt + rndGap_).sub(_now) );
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
882     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, LOLdatasets.EventReturns memory _eventData_)
883         private
884     {
885         // setup local rID
886         uint256 _rID = rID_;
887         
888         // grab time
889         uint256 _now = now;
890         
891         // if round is active
892         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
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
911                 emit LOLevents.onBuyAndDistribute
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
936     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, LOLdatasets.EventReturns memory _eventData_)
937         private
938     {
939         // setup local rID
940         uint256 _rID = rID_;
941         
942         // grab time
943         uint256 _now = now;
944         
945         // if round is active
946         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
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
967             emit LOLevents.onReLoadAndDistribute
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
987     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, LOLdatasets.EventReturns memory _eventData_)
988         private
989     {
990         // if player is new to round
991         if (plyrRnds_[_pID][_rID].keys == 0)
992             _eventData_ = managePlayer(_pID, _eventData_);
993         
994         // if eth left is greater than min eth allowed (sorry no pocket lint)
995         if (_eth > 1000000000) 
996         {
997             
998             // mint the new keys
999             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1000             
1001             // if they bought at least 1 whole key
1002             if (_keys >= 1000000000000000000)
1003             {
1004             updateTimer(_keys, _rID);
1005 
1006             // set new leaders
1007             if (round_[_rID].plyr != _pID)
1008                 round_[_rID].plyr = _pID;  
1009             if (round_[_rID].team != _team)
1010                 round_[_rID].team = _team; 
1011             
1012             // set the new leader bool to true
1013             _eventData_.compressedData = _eventData_.compressedData + 100;
1014         }
1015             
1016             // manage airdrops
1017             if (_eth >= 100000000000000000)
1018             {
1019             airDropTracker_++;
1020             if (airdrop() == true)
1021             {
1022                 // gib muni
1023                 uint256 _prize;
1024                 if (_eth >= 10000000000000000000)
1025                 {
1026                     // calculate prize and give it to winner
1027                     _prize = ((airDropPot_).mul(75)) / 100;
1028                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1029                     
1030                     // adjust airDropPot 
1031                     airDropPot_ = (airDropPot_).sub(_prize);
1032                     
1033                     // let event know a tier 3 prize was won 
1034                     _eventData_.compressedData += 300000000000000000000000000000000;
1035                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1036                     // calculate prize and give it to winner
1037                     _prize = ((airDropPot_).mul(50)) / 100;
1038                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1039                     
1040                     // adjust airDropPot 
1041                     airDropPot_ = (airDropPot_).sub(_prize);
1042                     
1043                     // let event know a tier 2 prize was won 
1044                     _eventData_.compressedData += 200000000000000000000000000000000;
1045                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1046                     // calculate prize and give it to winner
1047                     _prize = ((airDropPot_).mul(25)) / 100;
1048                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1049                     
1050                     // adjust airDropPot 
1051                     airDropPot_ = (airDropPot_).sub(_prize);
1052                     
1053                     // let event know a tier 3 prize was won 
1054                     _eventData_.compressedData += 300000000000000000000000000000000;
1055                 }
1056                 // set airdrop happened bool to true
1057                 _eventData_.compressedData += 10000000000000000000000000000000;
1058                 // let event know how much was won 
1059                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1060                 
1061                 // reset air drop tracker
1062                 airDropTracker_ = 0;
1063             }
1064         }
1065     
1066             // store the air drop tracker number (number of buys since last airdrop)
1067             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1068             
1069             // update player 
1070             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1071             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1072             
1073             // update round
1074             round_[_rID].keys = _keys.add(round_[_rID].keys);
1075             round_[_rID].eth = _eth.add(round_[_rID].eth);
1076             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1077     
1078             // distribute eth
1079             // 支付社区2%，分享人10%，P3D持有者
1080             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1081             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1082             
1083             // call end tx function to fire end tx event.
1084 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1085         }
1086     }
1087 //==============================================================================
1088 //     _ _ | _   | _ _|_ _  _ _  .
1089 //    (_(_||(_|_||(_| | (_)| _\  .
1090 //==============================================================================
1091     /**
1092      * @dev calculates unmasked earnings (just calculates, does not update mask)
1093      * @return earnings in wei format
1094      */
1095     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1096         private
1097         view
1098         returns(uint256)
1099     {
1100         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1101     }
1102     
1103     /** 
1104      * @dev returns the amount of keys you would get given an amount of eth. 
1105      * -functionhash- 0xce89c80c
1106      * @param _rID round ID you want price for
1107      * @param _eth amount of eth sent in 
1108      * @return keys received 
1109      */
1110     function calcKeysReceived(uint256 _rID, uint256 _eth)
1111         public
1112         view
1113         returns(uint256)
1114     {
1115         // grab time
1116         uint256 _now = now;
1117         
1118         // are we in a round?
1119         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1120             return ( (round_[_rID].eth).keysRec(_eth) );
1121         else // rounds over.  need keys for new round
1122             return ( (_eth).keys() );
1123     }
1124     
1125     /** 
1126      * @dev returns current eth price for X keys.  
1127      * -functionhash- 0xcf808000
1128      * @param _keys number of keys desired (in 18 decimal format)
1129      * @return amount of eth needed to send
1130      */
1131     function iWantXKeys(uint256 _keys)
1132         public
1133         view
1134         returns(uint256)
1135     {
1136         // setup local rID
1137         uint256 _rID = rID_;
1138         
1139         // grab time
1140         uint256 _now = now;
1141         
1142         // are we in a round?
1143         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1144             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1145         else // rounds over.  need price for new round
1146             return ( (_keys).eth() );
1147     }
1148 //==============================================================================
1149 //    _|_ _  _ | _  .
1150 //     | (_)(_)|_\  .
1151 //==============================================================================
1152     /**
1153 	 * @dev receives name/player info from names contract 
1154      */
1155     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1156         external
1157     {
1158         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1159         if (pIDxAddr_[_addr] != _pID)
1160             pIDxAddr_[_addr] = _pID;
1161         if (pIDxName_[_name] != _pID)
1162             pIDxName_[_name] = _pID;
1163         if (plyr_[_pID].addr != _addr)
1164             plyr_[_pID].addr = _addr;
1165         if (plyr_[_pID].name != _name)
1166             plyr_[_pID].name = _name;
1167         if (plyr_[_pID].laff != _laff)
1168             plyr_[_pID].laff = _laff;
1169         if (plyrNames_[_pID][_name] == false)
1170             plyrNames_[_pID][_name] = true;
1171     }
1172     
1173     /**
1174      * @dev receives entire player name list 
1175      */
1176     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1177         external
1178     {
1179         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1180         if(plyrNames_[_pID][_name] == false)
1181             plyrNames_[_pID][_name] = true;
1182     }   
1183         
1184     /**
1185      * @dev gets existing or registers new pID.  use this when a player may be new
1186      * @return pID 
1187      */
1188     function determinePID(LOLdatasets.EventReturns memory _eventData_)
1189         private
1190         returns (LOLdatasets.EventReturns)
1191     {
1192         uint256 _pID = pIDxAddr_[msg.sender];
1193         // if player is new to this version of fomo3d
1194         if (_pID == 0)
1195         {
1196             // grab their player ID, name and last aff ID, from player names contract 
1197             _pID = PlayerBook.getPlayerID(msg.sender);
1198             bytes32 _name = PlayerBook.getPlayerName(_pID);
1199             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1200             
1201             // set up player account 
1202             pIDxAddr_[msg.sender] = _pID;
1203             plyr_[_pID].addr = msg.sender;
1204             
1205             if (_name != "")
1206             {
1207                 pIDxName_[_name] = _pID;
1208                 plyr_[_pID].name = _name;
1209                 plyrNames_[_pID][_name] = true;
1210             }
1211             
1212             if (_laff != 0 && _laff != _pID)
1213                 plyr_[_pID].laff = _laff;
1214             
1215             // set the new player bool to true
1216             _eventData_.compressedData = _eventData_.compressedData + 1;
1217         } 
1218         return (_eventData_);
1219     }
1220     
1221     /**
1222      * @dev checks to make sure user picked a valid team.  if not sets team 
1223      * to default (sneks)
1224      */
1225     function verifyTeam(uint256 _team)
1226         private
1227         pure
1228         returns (uint256)
1229     {
1230         if (_team < 0 || _team > 3)
1231             return(2);
1232         else
1233             return(_team);
1234     }
1235     
1236     /**
1237      * @dev decides if round end needs to be run & new round started.  and if 
1238      * player unmasked earnings from previously played rounds need to be moved.
1239      */
1240     function managePlayer(uint256 _pID, LOLdatasets.EventReturns memory _eventData_)
1241         private
1242         returns (LOLdatasets.EventReturns)
1243     {
1244         // if player has played a previous round, move their unmasked earnings
1245         // from that round to gen vault.
1246         if (plyr_[_pID].lrnd != 0)
1247             updateGenVault(_pID, plyr_[_pID].lrnd);
1248             
1249         // update player's last round played
1250         plyr_[_pID].lrnd = rID_;
1251             
1252         // set the joined round bool to true
1253         _eventData_.compressedData = _eventData_.compressedData + 10;
1254         
1255         return(_eventData_);
1256     }
1257     
1258     /**
1259      * @dev ends the round. manages paying out winner/splitting up pot
1260      */
1261     function endRound(LOLdatasets.EventReturns memory _eventData_)
1262         private
1263         returns (LOLdatasets.EventReturns)
1264     {
1265         // setup local rID
1266         uint256 _rID = rID_;
1267         
1268         // grab our winning player and team id's
1269         uint256 _winPID = round_[_rID].plyr;
1270         uint256 _winTID = round_[_rID].team;
1271         
1272         // grab our pot amount
1273         uint256 _pot = round_[_rID].pot;
1274         
1275         // calculate our winner share, community rewards, gen share, 
1276         // p3d share, and amount reserved for next pot 
1277         uint256 _win = (_pot.mul(48)) / 100;
1278         uint256 _com = (_pot / 50);
1279         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1280         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1281         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1282         
1283         // calculate ppt for round mask
1284         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1285         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1286         if (_dust > 0)
1287         {
1288             _gen = _gen.sub(_dust);
1289             _res = _res.add(_dust);
1290         }
1291         
1292         // pay our winner
1293         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1294         
1295         // community rewards
1296         if (!address(lol_offical_bank).call.value(_com)(bytes4(keccak256("deposit()"))))
1297         {
1298             // This ensures Team Just cannot influence the outcome of FoMo3D with
1299             // bank migrations by breaking outgoing transactions.
1300             // Something we would never do. But that's not the point.
1301             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1302             // highest belief that everything we create should be trustless.
1303             // Team JUST, The name you shouldn't have to trust.
1304             _p3d = _p3d.add(_com);
1305             _com = 0;
1306         }
1307         
1308         // distribute gen portion to key holders
1309         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1310         
1311             
1312         // prepare event data
1313         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1314         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1315         _eventData_.winnerAddr = plyr_[_winPID].addr;
1316         _eventData_.winnerName = plyr_[_winPID].name;
1317         _eventData_.amountWon = _win;
1318         _eventData_.genAmount = _gen;
1319         _eventData_.P3DAmount = 0;
1320         _eventData_.newPot = _res;
1321         
1322         // start next round
1323         rID_++;
1324         _rID++;
1325         round_[_rID].strt = now;
1326         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1327         round_[_rID].pot = _res;
1328         
1329         return(_eventData_);
1330     }
1331     
1332     /**
1333      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1334      */
1335     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1336         private 
1337     {
1338         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1339         if (_earnings > 0)
1340         {
1341             // put in gen vault
1342             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1343             // zero out their earnings by updating mask
1344             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1345         }
1346     }
1347     
1348     /**
1349      * @dev updates round timer based on number of whole keys bought.
1350      */
1351     function updateTimer(uint256 _keys, uint256 _rID)
1352         private
1353     {
1354         // grab time
1355         uint256 _now = now;
1356         
1357         // calculate time based on number of keys bought
1358         uint256 _newTime;
1359         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1360             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1361         else
1362             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1363         
1364         // compare to max and set new end time
1365         if (_newTime < (rndMax_).add(_now))
1366             round_[_rID].end = _newTime;
1367         else
1368             round_[_rID].end = rndMax_.add(_now);
1369     }
1370     
1371     /**
1372      * @dev generates a random number between 0-99 and checks to see if thats
1373      * resulted in an airdrop win
1374      * @return do we have a winner?
1375      */
1376     function airdrop()
1377         private 
1378         view 
1379         returns(bool)
1380     {
1381         uint256 seed = uint256(keccak256(abi.encodePacked(
1382             
1383             (block.timestamp).add
1384             (block.difficulty).add
1385             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1386             (block.gaslimit).add
1387             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1388             (block.number)
1389             
1390         )));
1391         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1392             return(true);
1393         else
1394             return(false);
1395     }
1396 
1397     /**
1398      * @dev distributes eth based on fees to com, aff, and p3d
1399      */
1400     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, LOLdatasets.EventReturns memory _eventData_)
1401         private
1402         returns(LOLdatasets.EventReturns)
1403     {
1404         // pay 2% out to community rewards
1405         uint256 _com = _eth / 50;
1406         uint256 _p3d;
1407         
1408         
1409     
1410         
1411         // distribute share to affiliate
1412         uint256 _aff = _eth / 10;
1413         
1414         // decide what to do with affiliate share of fees
1415         // affiliate must not be self, and must have a name registered
1416         if (_affID != _pID && plyr_[_affID].name != '') {
1417             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1418             emit LOLevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1419         } else {
1420             _com = _com.add(_aff);
1421         }
1422 
1423         address(lol_offical_bank).call.value(_com)(bytes4(keccak256("deposit()")));
1424         
1425         // pay out p3d
1426         //_p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1427         //if (_p3d > 0)
1428         //{
1429             // deposit to divies contract nbnb
1430             //Divies.deposit.value(_p3d)(); 
1431             
1432             // set up event data
1433             //_eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1434         //}
1435         
1436         return(_eventData_);
1437     }
1438     
1439     /**
1440      * @dev distributes eth based on fees to gen and pot
1441      */
1442     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, LOLdatasets.EventReturns memory _eventData_)
1443         private
1444         returns(LOLdatasets.EventReturns)
1445     {
1446         // calculate gen share
1447         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1448         
1449         // toss 2% into airdrop pot 
1450         uint256 _air = (_eth / 50);
1451         airDropPot_ = airDropPot_.add(_air);
1452         
1453         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1454         _eth = _eth.sub(((_eth.mul(14)) / 100));
1455         
1456         // calculate pot 
1457         uint256 _pot = _eth.sub(_gen);
1458         
1459         // distribute gen share (thats what updateMasks() does) and adjust
1460         // balances for dust.
1461         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1462         if (_dust > 0)
1463             _gen = _gen.sub(_dust);
1464         
1465         // add eth to pot
1466         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1467         
1468         // set up event data
1469         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1470         _eventData_.potAmount = _pot;
1471         
1472         return(_eventData_);
1473     }
1474 
1475     /**
1476      * @dev updates masks for round and player when keys are bought
1477      * @return dust left over 
1478      */
1479     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1480         private
1481         returns(uint256)
1482     {
1483         /* MASKING NOTES
1484             earnings masks are a tricky thing for people to wrap their minds around.
1485             the basic thing to understand here.  is were going to have a global
1486             tracker based on profit per share for each round, that increases in
1487             relevant proportion to the increase in share supply.
1488             
1489             the player will have an additional mask that basically says "based
1490             on the rounds mask, my shares, and how much i've already withdrawn,
1491             how much is still owed to me?"
1492         */
1493         
1494         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1495         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1496         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1497             
1498         // calculate player earning from their own buy (only based on the keys
1499         // they just bought).  & update player earnings mask
1500         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1501         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1502         
1503         // calculate & return dust
1504         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1505     }
1506     
1507     /**
1508      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1509      * @return earnings in wei format
1510      */
1511     function withdrawEarnings(uint256 _pID)
1512         private
1513         returns(uint256)
1514     {
1515         // update gen vault
1516         updateGenVault(_pID, plyr_[_pID].lrnd);
1517         
1518         // from vaults 
1519         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1520         if (_earnings > 0)
1521         {
1522             plyr_[_pID].win = 0;
1523             plyr_[_pID].gen = 0;
1524             plyr_[_pID].aff = 0;
1525         }
1526 
1527         return(_earnings);
1528     }
1529     
1530     /**
1531      * @dev prepares compression data and fires event for buy or reload tx's
1532      */
1533     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, LOLdatasets.EventReturns memory _eventData_)
1534         private
1535     {
1536         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1537         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1538         
1539         emit LOLevents.onEndTx
1540         (
1541             _eventData_.compressedData,
1542             _eventData_.compressedIDs,
1543             plyr_[_pID].name,
1544             msg.sender,
1545             _eth,
1546             _keys,
1547             _eventData_.winnerAddr,
1548             _eventData_.winnerName,
1549             _eventData_.amountWon,
1550             _eventData_.newPot,
1551             _eventData_.P3DAmount,
1552             _eventData_.genAmount,
1553             _eventData_.potAmount,
1554             airDropPot_
1555         );
1556     }
1557 //==============================================================================
1558 //    (~ _  _    _._|_    .
1559 //    _)(/_(_|_|| | | \/  .
1560 //====================/=========================================================
1561     /** upon contract deploy, it will be deactivated.  this is a one time
1562      * use function that will activate the contract.  we do this so devs 
1563      * have time to set things up on the web end                            **/
1564     bool public activated_ = false;
1565     function activate()
1566         public
1567     {
1568         // only team just can activate 
1569         require(
1570             msg.sender == owner,
1571             "only team just can activate"
1572         );
1573 
1574         
1575         // can only be ran once
1576         require(activated_ == false, "fomo3d already activated");
1577         
1578         // activate the contract 
1579         activated_ = true;
1580         
1581         // lets start first round
1582 		rID_ = 1;
1583         round_[1].strt = now + rndExtra_ - rndGap_;
1584         round_[1].end = now + rndInit_ + rndExtra_;
1585     }
1586 }
1587 
1588 //==============================================================================
1589 //   __|_ _    __|_ _  .
1590 //  _\ | | |_|(_ | _\  .
1591 //==============================================================================
1592 library LOLdatasets {
1593     //compressedData key
1594     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1595         // 0 - new player (bool)
1596         // 1 - joined round (bool)
1597         // 2 - new  leader (bool)
1598         // 3-5 - air drop tracker (uint 0-999)
1599         // 6-16 - round end time
1600         // 17 - winnerTeam
1601         // 18 - 28 timestamp 
1602         // 29 - team
1603         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1604         // 31 - airdrop happened bool
1605         // 32 - airdrop tier 
1606         // 33 - airdrop amount won
1607     //compressedIDs key
1608     // [77-52][51-26][25-0]
1609         // 0-25 - pID 
1610         // 26-51 - winPID
1611         // 52-77 - rID
1612     struct EventReturns {
1613         uint256 compressedData;
1614         uint256 compressedIDs;
1615         address winnerAddr;         // winner address
1616         bytes32 winnerName;         // winner name
1617         uint256 amountWon;          // amount won
1618         uint256 newPot;             // amount in new pot
1619         uint256 P3DAmount;          // amount distributed to p3d
1620         uint256 genAmount;          // amount distributed to gen
1621         uint256 potAmount;          // amount added to pot
1622     }
1623     struct Player {
1624         address addr;   // player address
1625         bytes32 name;   // player name
1626         uint256 win;    // winnings vault
1627         uint256 gen;    // general vault
1628         uint256 aff;    // affiliate vault
1629         uint256 lrnd;   // last round played
1630         uint256 laff;   // last affiliate id used
1631     }
1632     struct PlayerRounds {
1633         uint256 eth;    // eth player has added to round (used for eth limiter)
1634         uint256 keys;   // keys
1635         uint256 mask;   // player mask 
1636         uint256 ico;    // ICO phase investment
1637     }
1638     struct Round {
1639         uint256 plyr;   // pID of player in lead
1640         uint256 team;   // tID of team in lead
1641         uint256 end;    // time ends/ended
1642         bool ended;     // has round end function been ran
1643         uint256 strt;   // time round started
1644         uint256 keys;   // keys
1645         uint256 eth;    // total eth in
1646         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1647         uint256 mask;   // global mask
1648         uint256 ico;    // total eth sent in during ICO phase
1649         uint256 icoGen; // total eth for gen during ICO phase
1650         uint256 icoAvg; // average key price for ICO phase
1651     }
1652     struct TeamFee {
1653         uint256 gen;    // % of buy in thats paid to key holders of current round
1654         uint256 p3d;    // % of buy in thats paid to p3d holders
1655     }
1656     struct PotSplit {
1657         uint256 gen;    // % of pot thats paid to key holders of current round
1658         uint256 p3d;    // % of pot thats paid to p3d holders
1659     }
1660 }
1661 
1662 //==============================================================================
1663 //  |  _      _ _ | _  .
1664 //  |<(/_\/  (_(_||(_  .
1665 //=======/======================================================================
1666 library LOLKeysCalcLong {
1667     using SafeMath for *;
1668     /**
1669      * @dev calculates number of keys received given X eth 
1670      * @param _curEth current amount of eth in contract 
1671      * @param _newEth eth being spent
1672      * @return amount of ticket purchased
1673      */
1674     function keysRec(uint256 _curEth, uint256 _newEth)
1675         internal
1676         pure
1677         returns (uint256)
1678     {
1679         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1680     }
1681     
1682     /**
1683      * @dev calculates amount of eth received if you sold X keys 
1684      * @param _curKeys current amount of keys that exist 
1685      * @param _sellKeys amount of keys you wish to sell
1686      * @return amount of eth received
1687      */
1688     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1689         internal
1690         pure
1691         returns (uint256)
1692     {
1693         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1694     }
1695 
1696     /**
1697      * @dev calculates how many keys would exist with given an amount of eth
1698      * @param _eth eth "in contract"
1699      * @return number of keys that would exist
1700      */
1701     function keys(uint256 _eth) 
1702         internal
1703         pure
1704         returns(uint256)
1705     {
1706         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1707     }
1708     
1709     /**
1710      * @dev calculates how much eth would be in contract given a number of keys
1711      * @param _keys number of keys "in contract" 
1712      * @return eth that would exists
1713      */
1714     function eth(uint256 _keys) 
1715         internal
1716         pure
1717         returns(uint256)  
1718     {
1719         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1720     }
1721 }
1722 
1723 //==============================================================================
1724 //  . _ _|_ _  _ |` _  _ _  _  .
1725 //  || | | (/_| ~|~(_|(_(/__\  .
1726 //==============================================================================
1727 
1728 interface LOLOfficalBankInterface {
1729     function deposit() external payable returns(bool);
1730 }
1731 
1732 interface LOLPlayerBookInterface {
1733     function getPlayerID(address _addr) external returns (uint256);
1734     function getPlayerName(uint256 _pID) external view returns (bytes32);
1735     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1736     function getPlayerAddr(uint256 _pID) external view returns (address);
1737     function getNameFee() external view returns (uint256);
1738     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1739     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1740     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1741 }
1742 
1743 
1744 library NameFilter {
1745     /**
1746      * @dev filters name strings
1747      * -converts uppercase to lower case.  
1748      * -makes sure it does not start/end with a space
1749      * -makes sure it does not contain multiple spaces in a row
1750      * -cannot be only numbers
1751      * -cannot start with 0x 
1752      * -restricts characters to A-Z, a-z, 0-9, and space.
1753      * @return reprocessed string in bytes32 format
1754      */
1755     function nameFilter(string _input)
1756         internal
1757         pure
1758         returns(bytes32)
1759     {
1760         bytes memory _temp = bytes(_input);
1761         uint256 _length = _temp.length;
1762         
1763         //sorry limited to 32 characters
1764         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1765         // make sure it doesnt start with or end with space
1766         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1767         // make sure first two characters are not 0x
1768         if (_temp[0] == 0x30)
1769         {
1770             require(_temp[1] != 0x78, "string cannot start with 0x");
1771             require(_temp[1] != 0x58, "string cannot start with 0X");
1772         }
1773         
1774         // create a bool to track if we have a non number character
1775         bool _hasNonNumber;
1776         
1777         // convert & check
1778         for (uint256 i = 0; i < _length; i++)
1779         {
1780             // if its uppercase A-Z
1781             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1782             {
1783                 // convert to lower case a-z
1784                 _temp[i] = byte(uint(_temp[i]) + 32);
1785                 
1786                 // we have a non number
1787                 if (_hasNonNumber == false)
1788                     _hasNonNumber = true;
1789             } else {
1790                 require
1791                 (
1792                     // require character is a space
1793                     _temp[i] == 0x20 || 
1794                     // OR lowercase a-z
1795                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1796                     // or 0-9
1797                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1798                     "string contains invalid characters"
1799                 );
1800                 // make sure theres not 2x spaces in a row
1801                 if (_temp[i] == 0x20)
1802                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1803                 
1804                 // see if we have a character other than a number
1805                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1806                     _hasNonNumber = true;    
1807             }
1808         }
1809         
1810         require(_hasNonNumber == true, "string cannot be only numbers");
1811         
1812         bytes32 _ret;
1813         assembly {
1814             _ret := mload(add(_temp, 32))
1815         }
1816         return (_ret);
1817     }
1818 }
1819 
1820 /**
1821  * @title SafeMath v0.1.9
1822  * @dev Math operations with safety checks that throw on error
1823  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1824  * - added sqrt
1825  * - added sq
1826  * - added pwr 
1827  * - changed asserts to requires with error log outputs
1828  * - removed div, its useless
1829  */
1830 library SafeMath {
1831     
1832     /**
1833     * @dev Multiplies two numbers, throws on overflow.
1834     */
1835     function mul(uint256 a, uint256 b) 
1836         internal 
1837         pure 
1838         returns (uint256 c) 
1839     {
1840         if (a == 0) {
1841             return 0;
1842         }
1843         c = a * b;
1844         require(c / a == b, "SafeMath mul failed");
1845         return c;
1846     }
1847 
1848     /**
1849     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1850     */
1851     function sub(uint256 a, uint256 b)
1852         internal
1853         pure
1854         returns (uint256) 
1855     {
1856         require(b <= a, "SafeMath sub failed");
1857         return a - b;
1858     }
1859 
1860     /**
1861     * @dev Adds two numbers, throws on overflow.
1862     */
1863     function add(uint256 a, uint256 b)
1864         internal
1865         pure
1866         returns (uint256 c) 
1867     {
1868         c = a + b;
1869         require(c >= a, "SafeMath add failed");
1870         return c;
1871     }
1872     
1873     /**
1874      * @dev gives square root of given x.
1875      */
1876     function sqrt(uint256 x)
1877         internal
1878         pure
1879         returns (uint256 y) 
1880     {
1881         uint256 z = ((add(x,1)) / 2);
1882         y = x;
1883         while (z < y) 
1884         {
1885             y = z;
1886             z = ((add((x / z),z)) / 2);
1887         }
1888     }
1889     
1890     /**
1891      * @dev gives square. multiplies x by x
1892      */
1893     function sq(uint256 x)
1894         internal
1895         pure
1896         returns (uint256)
1897     {
1898         return (mul(x,x));
1899     }
1900     
1901     /**
1902      * @dev x to the power of y 
1903      */
1904     function pwr(uint256 x, uint256 y)
1905         internal 
1906         pure 
1907         returns (uint256)
1908     {
1909         if (x==0)
1910             return (0);
1911         else if (y==0)
1912             return (1);
1913         else 
1914         {
1915             uint256 z = x;
1916             for (uint256 i=1; i < y; i++)
1917                 z = mul(z,x);
1918             return (z);
1919         }
1920     }
1921 }