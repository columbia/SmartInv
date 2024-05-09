1 pragma solidity ^0.4.24;
2 
3 /**
4  * Based on the open source code of PowerH3D, we built our UPower application ecosystem.
5  * We will inherit the open source spirit of PowerH3D and accept the community review. 
6  * In future, we will launch more creative games to enrich UPower ecosystem. 
7  * Thanks to Just Team!
8  */
9 
10 contract MC2events {
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
38         uint256 UPAmount,
39         uint256 genAmount,
40         uint256 potAmount,
41         uint256 airDropPot
42     );
43     
44     // fired whenever theres a withdraw
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
66         uint256 UPAmount,
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
83         uint256 UPAmount,
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
99         uint256 UPAmount,
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
123 
124 contract modularLong is MC2events {}
125 
126 contract MC2long is modularLong {
127     using SafeMath for *;
128     using NameFilter for string;
129     using MC2KeysCalcLong for uint256;
130     
131     otherMC2 private otherMC2_;
132     DiviesInterface constant private Divies = DiviesInterface(0x33F43Dd20855979f617a983dDBcb4C1C0FA89B2e);
133     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x609e4bb4deE240485Fa546D2bEA2EfAE583E72aC);
134     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xfEc91702792A45070AD7F4Bb07Ed678B863Bc722);
135     MC2SettingInterface constant private extSetting = MC2SettingInterface(0x8371c74F75274602Bdc4efaC209DA5B15E262E4e);
136 
137     string constant public name = "MC2 COSMOS";
138     string constant public symbol = "MC2";
139     uint256 private rndExtra_ = extSetting.getLongExtra();       // length of the very first ICO 
140     uint256 private rndGap_ = extSetting.getLongGap();         // length of ICO phase, set to 1 year for EOS.
141     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
142     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
143     uint256 constant private rndMax_ = 60 minutes;                // max length a round timer can be
144 
145     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
146     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
147     uint256 public rID_;    // round id number / total rounds that have happened
148 //****************
149 // PLAYER DATA 
150 //****************
151     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
152     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
153     mapping (uint256 => MC2datasets.Player) public plyr_;   // (pID => data) player data
154     mapping (uint256 => mapping (uint256 => MC2datasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
155     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
156 //****************
157 // ROUND DATA 
158 //****************
159     mapping (uint256 => MC2datasets.Round) public round_;   // (rID => data) round data
160     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
161 //****************
162 // TEAM FEE DATA 
163 //****************
164     mapping (uint256 => MC2datasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
165     mapping (uint256 => MC2datasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
166 
167     constructor()
168         public
169     {
170         // Team allocation structures
171         // 0 = whales
172         // 1 = bears
173         // 2 = sneks
174         // 3 = bulls
175 
176         // Team allocation percentages
177         // (MC2, UP) + (Pot , Referrals, Community)
178             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
179         fees_[0] = MC2datasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
180         fees_[1] = MC2datasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
181         fees_[2] = MC2datasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
182         fees_[3] = MC2datasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
183         
184         // how to split up the final pot based on which team was picked
185         // (MC2, UP)
186         potSplit_[0] = MC2datasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
187         potSplit_[1] = MC2datasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
188         potSplit_[2] = MC2datasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
189         potSplit_[3] = MC2datasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
190     }
191 
192     /**
193      * @dev used to make sure no one can interact with contract until it has 
194      * been activated. 
195      */
196     modifier isActivated() {
197         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
198         _;
199     }
200     
201     /**
202      * @dev prevents contracts from interacting with fomo3d 
203      */
204     modifier isHuman() {
205         address _addr = msg.sender;
206         uint256 _codeLength;
207         
208         assembly {_codeLength := extcodesize(_addr)}
209         require(_codeLength == 0, "sorry humans only");
210         _;
211     }
212 
213     /**
214      * @dev sets boundaries for incoming tx 
215      */
216     modifier isWithinLimits(uint256 _eth) {
217         require(_eth >= 1000000000, "pocket lint: not a valid currency");
218         require(_eth <= 100000000000000000000000, "no vitalik, no");
219         _;    
220     }
221     
222     /**
223      * @dev emergency buy uses last stored affiliate ID and team snek
224      */
225     function()
226         isActivated()
227         isHuman()
228         isWithinLimits(msg.value)
229         public
230         payable
231     {
232         // set up our tx event data and determine if player is new or not
233         MC2datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
234             
235         // fetch player id
236         uint256 _pID = pIDxAddr_[msg.sender];
237         
238         // buy core 
239         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
240     }
241     
242     /**
243      * @dev converts all incoming ethereum to keys.
244      * -functionhash- 0x8f38f309 (using ID for affiliate)
245      * -functionhash- 0x98a0871d (using address for affiliate)
246      * -functionhash- 0xa65b37a1 (using name for affiliate)
247      * @param _affCode the ID/address/name of the player who gets the affiliate fee
248      * @param _team what team is the player playing for?
249      */
250     function buyXid(uint256 _affCode, uint256 _team)
251         isActivated()
252         isHuman()
253         isWithinLimits(msg.value)
254         public
255         payable
256     {
257         // set up our tx event data and determine if player is new or not
258         MC2datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
259         
260         // fetch player id
261         uint256 _pID = pIDxAddr_[msg.sender];
262         
263         // manage affiliate residuals
264         // if no affiliate code was given or player tried to use their own, lolz
265         if (_affCode == 0 || _affCode == _pID)
266         {
267             // use last stored affiliate code 
268             _affCode = plyr_[_pID].laff;
269             
270         // if affiliate code was given & its not the same as previously stored 
271         } else if (_affCode != plyr_[_pID].laff) {
272             // update last affiliate 
273             plyr_[_pID].laff = _affCode;
274         }
275         
276         // verify a valid team was selected
277         _team = verifyTeam(_team);
278         
279         // buy core 
280         buyCore(_pID, _affCode, _team, _eventData_);
281     }
282     
283     function buyXaddr(address _affCode, uint256 _team)
284         isActivated()
285         isHuman()
286         isWithinLimits(msg.value)
287         public
288         payable
289     {
290         // set up our tx event data and determine if player is new or not
291         MC2datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
292         
293         // fetch player id
294         uint256 _pID = pIDxAddr_[msg.sender];
295         
296         // manage affiliate residuals
297         uint256 _affID;
298         // if no affiliate code was given or player tried to use their own, lolz
299         if (_affCode == address(0) || _affCode == msg.sender)
300         {
301             // use last stored affiliate code
302             _affID = plyr_[_pID].laff;
303         
304         // if affiliate code was given    
305         } else {
306             // get affiliate ID from aff Code 
307             _affID = pIDxAddr_[_affCode];
308             
309             // if affID is not the same as previously stored 
310             if (_affID != plyr_[_pID].laff)
311             {
312                 // update last affiliate
313                 plyr_[_pID].laff = _affID;
314             }
315         }
316         
317         // verify a valid team was selected
318         _team = verifyTeam(_team);
319         
320         // buy core 
321         buyCore(_pID, _affID, _team, _eventData_);
322     }
323     
324     function buyXname(bytes32 _affCode, uint256 _team)
325         isActivated()
326         isHuman()
327         isWithinLimits(msg.value)
328         public
329         payable
330     {
331         // set up our tx event data and determine if player is new or not
332         MC2datasets.EventReturns memory _eventData_ = determinePID(_eventData_);
333         
334         // fetch player id
335         uint256 _pID = pIDxAddr_[msg.sender];
336         
337         // manage affiliate residuals
338         uint256 _affID;
339         // if no affiliate code was given or player tried to use their own, lolz
340         if (_affCode == '' || _affCode == plyr_[_pID].name)
341         {
342             // use last stored affiliate code
343             _affID = plyr_[_pID].laff;
344         
345         // if affiliate code was given
346         } else {
347             // get affiliate ID from aff Code
348             _affID = pIDxName_[_affCode];
349             
350             // if affID is not the same as previously stored
351             if (_affID != plyr_[_pID].laff)
352             {
353                 // update last affiliate
354                 plyr_[_pID].laff = _affID;
355             }
356         }
357         
358         // verify a valid team was selected
359         _team = verifyTeam(_team);
360         
361         // buy core 
362         buyCore(_pID, _affID, _team, _eventData_);
363     }
364     
365     /**
366      * @dev essentially the same as buy, but instead of you sending ether 
367      * from your wallet, it uses your unwithdrawn earnings.
368      * -functionhash- 0x349cdcac (using ID for affiliate)
369      * -functionhash- 0x82bfc739 (using address for affiliate)
370      * -functionhash- 0x079ce327 (using name for affiliate)
371      * @param _affCode the ID/address/name of the player who gets the affiliate fee
372      * @param _team what team is the player playing for?
373      * @param _eth amount of earnings to use (remainder returned to gen vault)
374      */
375     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
376         isActivated()
377         isHuman()
378         isWithinLimits(_eth)
379         public
380     {
381         // set up our tx event data
382         MC2datasets.EventReturns memory _eventData_;
383         
384         // fetch player ID
385         uint256 _pID = pIDxAddr_[msg.sender];
386         
387         // manage affiliate residuals
388         // if no affiliate code was given or player tried to use their own, lolz
389         if (_affCode == 0 || _affCode == _pID)
390         {
391             // use last stored affiliate code 
392             _affCode = plyr_[_pID].laff;
393             
394         // if affiliate code was given & its not the same as previously stored 
395         } else if (_affCode != plyr_[_pID].laff) {
396             // update last affiliate 
397             plyr_[_pID].laff = _affCode;
398         }
399 
400         // verify a valid team was selected
401         _team = verifyTeam(_team);
402 
403         // reload core
404         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
405     }
406     
407     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
408         isActivated()
409         isHuman()
410         isWithinLimits(_eth)
411         public
412     {
413         // set up our tx event data
414         MC2datasets.EventReturns memory _eventData_;
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
440         // verify a valid team was selected
441         _team = verifyTeam(_team);
442         
443         // reload core
444         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
445     }
446     
447     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
448         isActivated()
449         isHuman()
450         isWithinLimits(_eth)
451         public
452     {
453         // set up our tx event data
454         MC2datasets.EventReturns memory _eventData_;
455         
456         // fetch player ID
457         uint256 _pID = pIDxAddr_[msg.sender];
458         
459         // manage affiliate residuals
460         uint256 _affID;
461         // if no affiliate code was given or player tried to use their own, lolz
462         if (_affCode == '' || _affCode == plyr_[_pID].name)
463         {
464             // use last stored affiliate code
465             _affID = plyr_[_pID].laff;
466         
467         // if affiliate code was given
468         } else {
469             // get affiliate ID from aff Code
470             _affID = pIDxName_[_affCode];
471             
472             // if affID is not the same as previously stored
473             if (_affID != plyr_[_pID].laff)
474             {
475                 // update last affiliate
476                 plyr_[_pID].laff = _affID;
477             }
478         }
479         
480         // verify a valid team was selected
481         _team = verifyTeam(_team);
482         
483         // reload core
484         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
485     }
486 
487     /**
488      * @dev withdraws all of your earnings.
489      * -functionhash- 0x3ccfd60b
490      */
491     function withdraw()
492         isActivated()
493         isHuman()
494         public
495     {
496         // setup local rID 
497         uint256 _rID = rID_;
498         
499         // grab time
500         uint256 _now = now;
501         
502         // fetch player ID
503         uint256 _pID = pIDxAddr_[msg.sender];
504         
505         // setup temp var for player eth
506         uint256 _eth;
507         
508         // check to see if round has ended and no one has run round end yet
509         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
510         {
511             // set up our tx event data
512             MC2datasets.EventReturns memory _eventData_;
513             
514             // end the round (distributes pot)
515             round_[_rID].ended = true;
516             _eventData_ = endRound(_eventData_);
517             
518             // get their earnings
519             _eth = withdrawEarnings(_pID);
520             
521             // gib moni
522             if (_eth > 0)
523                 plyr_[_pID].addr.transfer(_eth);    
524             
525             // build event data
526             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
527             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
528             
529             // fire withdraw and distribute event
530             emit MC2events.onWithdrawAndDistribute
531             (
532                 msg.sender, 
533                 plyr_[_pID].name, 
534                 _eth, 
535                 _eventData_.compressedData, 
536                 _eventData_.compressedIDs, 
537                 _eventData_.winnerAddr, 
538                 _eventData_.winnerName, 
539                 _eventData_.amountWon, 
540                 _eventData_.newPot, 
541                 _eventData_.UPAmount,
542                 _eventData_.genAmount
543             );
544             
545         // in any other situation
546         } else {
547             // get their earnings
548             _eth = withdrawEarnings(_pID);
549             
550             // gib moni
551             if (_eth > 0)
552                 plyr_[_pID].addr.transfer(_eth);
553             
554             // fire withdraw event
555             emit MC2events.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
556         }
557     }
558     
559     /**
560      * @dev use these to register names.  they are just wrappers that will send the
561      * registration requests to the PlayerBook contract.  So registering here is the 
562      * same as registering there.  UI will always display the last name you registered.
563      * but you will still own all previously registered names to use as affiliate 
564      * links.
565      * - must pay a registration fee.
566      * - name must be unique
567      * - names will be converted to lowercase
568      * - name cannot start or end with a space 
569      * - cannot have more than 1 space in a row
570      * - cannot be only numbers
571      * - cannot start with 0x 
572      * - name must be at least 1 char
573      * - max length of 32 characters long
574      * - allowed characters: a-z, 0-9, and space
575      * -functionhash- 0x921dec21 (using ID for affiliate)
576      * -functionhash- 0x3ddd4698 (using address for affiliate)
577      * -functionhash- 0x685ffd83 (using name for affiliate)
578      * @param _nameString players desired name
579      * @param _affCode affiliate ID, address, or name of who referred you
580      * @param _all set to true if you want this to push your info to all games 
581      * (this might cost a lot of gas)
582      */
583     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
584         isHuman()
585         public
586         payable
587     {
588         bytes32 _name = _nameString.nameFilter();
589         address _addr = msg.sender;
590         uint256 _paid = msg.value;
591         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
592         
593         uint256 _pID = pIDxAddr_[_addr];
594         
595         // fire event
596         emit MC2events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
597     }
598     
599     function registerNameXaddr(string _nameString, address _affCode, bool _all)
600         isHuman()
601         public
602         payable
603     {
604         bytes32 _name = _nameString.nameFilter();
605         address _addr = msg.sender;
606         uint256 _paid = msg.value;
607         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
608         
609         uint256 _pID = pIDxAddr_[_addr];
610         
611         // fire event
612         emit MC2events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
613     }
614     
615     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
616         isHuman()
617         public
618         payable
619     {
620         bytes32 _name = _nameString.nameFilter();
621         address _addr = msg.sender;
622         uint256 _paid = msg.value;
623         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
624         
625         uint256 _pID = pIDxAddr_[_addr];
626         
627         // fire event
628         emit MC2events.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
629     }
630 
631     /**
632      * @dev return the price buyer will pay for next 1 individual key.
633      * -functionhash- 0x018a25e8
634      * @return price for next key bought (in wei format)
635      */
636     function getBuyPrice()
637         public 
638         view 
639         returns(uint256)
640     {  
641         // setup local rID
642         uint256 _rID = rID_;
643         
644         // grab time
645         uint256 _now = now;
646         
647         // are we in a round?
648         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
649             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
650         else // rounds over.  need price for new round
651             return ( 75000000000000 ); // init
652     }
653     
654     /**
655      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
656      * provider
657      * -functionhash- 0xc7e284b8
658      * @return time left in seconds
659      */
660     function getTimeLeft()
661         public
662         view
663         returns(uint256)
664     {
665         // setup local rID
666         uint256 _rID = rID_;
667         
668         // grab time
669         uint256 _now = now;
670         
671         if (_now < round_[_rID].end)
672             if (_now > round_[_rID].strt + rndGap_)
673                 return( (round_[_rID].end).sub(_now) );
674             else
675                 return( (round_[_rID].strt + rndGap_).sub(_now) );
676         else
677             return(0);
678     }
679     
680     /**
681      * @dev returns player earnings per vaults 
682      * -functionhash- 0x63066434
683      * @return winnings vault
684      * @return general vault
685      * @return affiliate vault
686      */
687     function getPlayerVaults(uint256 _pID)
688         public
689         view
690         returns(uint256 ,uint256, uint256)
691     {
692         // setup local rID
693         uint256 _rID = rID_;
694         
695         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
696         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
697         {
698             // if player is winner 
699             if (round_[_rID].plyr == _pID)
700             {
701                 return
702                 (
703                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
704                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
705                     plyr_[_pID].aff
706                 );
707             // if player is not the winner
708             } else {
709                 return
710                 (
711                     plyr_[_pID].win,
712                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
713                     plyr_[_pID].aff
714                 );
715             }
716             
717         // if round is still going on, or round has ended and round end has been ran
718         } else {
719             return
720             (
721                 plyr_[_pID].win,
722                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
723                 plyr_[_pID].aff
724             );
725         }
726     }
727     
728     /**
729      * solidity hates stack limits.  this lets us avoid that hate 
730      */
731     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
732         private
733         view
734         returns(uint256)
735     {
736         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
737     }
738     
739     /**
740      * @dev returns all current round info needed for front end
741      * -functionhash- 0x747dff42
742      * @return eth invested during ICO phase
743      * @return round id 
744      * @return total keys for round 
745      * @return time round ends
746      * @return time round started
747      * @return current pot 
748      * @return current team ID & player ID in lead 
749      * @return current player in leads address 
750      * @return current player in leads name
751      * @return whales eth in for round
752      * @return bears eth in for round
753      * @return sneks eth in for round
754      * @return bulls eth in for round
755      * @return airdrop tracker # & airdrop pot
756      */
757     function getCurrentRoundInfo()
758         public
759         view
760         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
761     {
762         // setup local rID
763         uint256 _rID = rID_;
764         
765         return
766         (
767             round_[_rID].ico,               //0
768             _rID,                           //1
769             round_[_rID].keys,              //2
770             round_[_rID].end,               //3
771             round_[_rID].strt,              //4
772             round_[_rID].pot,               //5
773             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
774             plyr_[round_[_rID].plyr].addr,  //7
775             plyr_[round_[_rID].plyr].name,  //8
776             rndTmEth_[_rID][0],             //9
777             rndTmEth_[_rID][1],             //10
778             rndTmEth_[_rID][2],             //11
779             rndTmEth_[_rID][3],             //12
780             airDropTracker_ + (airDropPot_ * 1000)              //13
781         );
782     }
783 
784     /**
785      * @dev returns player info based on address.  if no address is given, it will 
786      * use msg.sender 
787      * -functionhash- 0xee0b5d8b
788      * @param _addr address of the player you want to lookup 
789      * @return player ID 
790      * @return player name
791      * @return keys owned (current round)
792      * @return winnings vault
793      * @return general vault 
794      * @return affiliate vault 
795      * @return player round eth
796      */
797     function getPlayerInfoByAddress(address _addr)
798         public 
799         view 
800         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
801     {
802         // setup local rID
803         uint256 _rID = rID_;
804         
805         if (_addr == address(0))
806         {
807             _addr == msg.sender;
808         }
809         uint256 _pID = pIDxAddr_[_addr];
810         
811         return
812         (
813             _pID,                               //0
814             plyr_[_pID].name,                   //1
815             plyrRnds_[_pID][_rID].keys,         //2
816             plyr_[_pID].win,                    //3
817             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
818             plyr_[_pID].aff,                    //5
819             plyrRnds_[_pID][_rID].eth           //6
820         );
821     }
822 
823 
824     /**
825      * @dev logic runs whenever a buy order is executed.  determines how to handle 
826      * incoming eth depending on if we are in an active round or not
827      */
828     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, MC2datasets.EventReturns memory _eventData_)
829         private
830     {
831         // setup local rID
832         uint256 _rID = rID_;
833         
834         // grab time
835         uint256 _now = now;
836         
837         // if round is active
838         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
839         {
840             // call core 
841             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
842         
843         // if round is not active     
844         } else {
845             // check to see if end round needs to be ran
846             if (_now > round_[_rID].end && round_[_rID].ended == false) 
847             {
848                 // end the round (distributes pot) & start new round
849                 round_[_rID].ended = true;
850                 _eventData_ = endRound(_eventData_);
851                 
852                 // build event data
853                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
854                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
855                 
856                 // fire buy and distribute event 
857                 emit MC2events.onBuyAndDistribute
858                 (
859                     msg.sender, 
860                     plyr_[_pID].name, 
861                     msg.value, 
862                     _eventData_.compressedData, 
863                     _eventData_.compressedIDs, 
864                     _eventData_.winnerAddr, 
865                     _eventData_.winnerName, 
866                     _eventData_.amountWon, 
867                     _eventData_.newPot, 
868                     _eventData_.UPAmount,
869                     _eventData_.genAmount
870                 );
871             }
872             
873             // put eth in players vault 
874             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
875         }
876     }
877     
878     /**
879      * @dev logic runs whenever a reload order is executed.  determines how to handle 
880      * incoming eth depending on if we are in an active round or not 
881      */
882     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, MC2datasets.EventReturns memory _eventData_)
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
894             // get earnings from all vaults and return unused to gen vault
895             // because we use a custom safemath library.  this will throw if player 
896             // tried to spend more eth than they have.
897             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
898             
899             // call core 
900             core(_rID, _pID, _eth, _affID, _team, _eventData_);
901         
902         // if round is not active and end round needs to be ran   
903         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
904             // end the round (distributes pot) & start new round
905             round_[_rID].ended = true;
906             _eventData_ = endRound(_eventData_);
907                 
908             // build event data
909             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
910             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
911                 
912             // fire buy and distribute event 
913             emit MC2events.onReLoadAndDistribute
914             (
915                 msg.sender, 
916                 plyr_[_pID].name, 
917                 _eventData_.compressedData, 
918                 _eventData_.compressedIDs, 
919                 _eventData_.winnerAddr, 
920                 _eventData_.winnerName, 
921                 _eventData_.amountWon, 
922                 _eventData_.newPot, 
923                 _eventData_.UPAmount,
924                 _eventData_.genAmount
925             );
926         }
927     }
928     
929     /**
930      * @dev this is the core logic for any buy/reload that happens while a round 
931      * is live.
932      */
933     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, MC2datasets.EventReturns memory _eventData_)
934         private
935     {
936         // if player is new to round
937         if (plyrRnds_[_pID][_rID].keys == 0)
938             _eventData_ = managePlayer(_pID, _eventData_);
939         
940         // early round eth limiter 
941         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
942         {
943             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
944             uint256 _refund = _eth.sub(_availableLimit);
945             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
946             _eth = _availableLimit;
947         }
948         
949         // if eth left is greater than min eth allowed (sorry no pocket lint)
950         if (_eth > 1000000000) 
951         {
952             
953             // mint the new keys
954             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
955             
956             // if they bought at least 1 whole key
957             if (_keys >= 1000000000000000000)
958             {
959             updateTimer(_keys, _rID);
960 
961             // set new leaders
962             if (round_[_rID].plyr != _pID)
963                 round_[_rID].plyr = _pID;  
964             if (round_[_rID].team != _team)
965                 round_[_rID].team = _team; 
966             
967             // set the new leader bool to true
968             _eventData_.compressedData = _eventData_.compressedData + 100;
969         }
970             
971             // manage airdrops
972             if (_eth >= 100000000000000000)
973             {
974             airDropTracker_++;
975             if (airdrop() == true)
976             {
977                 // gib muni
978                 uint256 _prize;
979                 if (_eth >= 10000000000000000000)
980                 {
981                     // calculate prize and give it to winner
982                     _prize = ((airDropPot_).mul(75)) / 100;
983                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
984                     
985                     // adjust airDropPot 
986                     airDropPot_ = (airDropPot_).sub(_prize);
987                     
988                     // let event know a tier 3 prize was won 
989                     _eventData_.compressedData += 300000000000000000000000000000000;
990                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
991                     // calculate prize and give it to winner
992                     _prize = ((airDropPot_).mul(50)) / 100;
993                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
994                     
995                     // adjust airDropPot 
996                     airDropPot_ = (airDropPot_).sub(_prize);
997                     
998                     // let event know a tier 2 prize was won 
999                     _eventData_.compressedData += 200000000000000000000000000000000;
1000                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1001                     // calculate prize and give it to winner
1002                     _prize = ((airDropPot_).mul(25)) / 100;
1003                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1004                     
1005                     // adjust airDropPot 
1006                     airDropPot_ = (airDropPot_).sub(_prize);
1007                     
1008                     // let event know a tier 3 prize was won 
1009                     _eventData_.compressedData += 300000000000000000000000000000000;
1010                 }
1011                 // set airdrop happened bool to true
1012                 _eventData_.compressedData += 10000000000000000000000000000000;
1013                 // let event know how much was won 
1014                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1015                 
1016                 // reset air drop tracker
1017                 airDropTracker_ = 0;
1018             }
1019         }
1020     
1021             // store the air drop tracker number (number of buys since last airdrop)
1022             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1023             
1024             // update player 
1025             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1026             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1027             
1028             // update round
1029             round_[_rID].keys = _keys.add(round_[_rID].keys);
1030             round_[_rID].eth = _eth.add(round_[_rID].eth);
1031             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1032     
1033             // distribute eth
1034             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1035             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1036             
1037             // call end tx function to fire end tx event.
1038             endTx(_pID, _team, _eth, _keys, _eventData_);
1039         }
1040     }
1041 
1042     /**
1043      * @dev calculates unmasked earnings (just calculates, does not update mask)
1044      * @return earnings in wei format
1045      */
1046     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1047         private
1048         view
1049         returns(uint256)
1050     {
1051         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1052     }
1053     
1054     /** 
1055      * @dev returns the amount of keys you would get given an amount of eth. 
1056      * -functionhash- 0xce89c80c
1057      * @param _rID round ID you want price for
1058      * @param _eth amount of eth sent in 
1059      * @return keys received 
1060      */
1061     function calcKeysReceived(uint256 _rID, uint256 _eth)
1062         public
1063         view
1064         returns(uint256)
1065     {
1066         // grab time
1067         uint256 _now = now;
1068         
1069         // are we in a round?
1070         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1071             return ( (round_[_rID].eth).keysRec(_eth) );
1072         else // rounds over.  need keys for new round
1073             return ( (_eth).keys() );
1074     }
1075     
1076     /** 
1077      * @dev returns current eth price for X keys.  
1078      * -functionhash- 0xcf808000
1079      * @param _keys number of keys desired (in 18 decimal format)
1080      * @return amount of eth needed to send
1081      */
1082     function iWantXKeys(uint256 _keys)
1083         public
1084         view
1085         returns(uint256)
1086     {
1087         // setup local rID
1088         uint256 _rID = rID_;
1089         
1090         // grab time
1091         uint256 _now = now;
1092         
1093         // are we in a round?
1094         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1095             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1096         else // rounds over.  need price for new round
1097             return ( (_keys).eth() );
1098     }
1099 
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
1136     function determinePID(MC2datasets.EventReturns memory _eventData_)
1137         private
1138         returns (MC2datasets.EventReturns)
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
1188     function managePlayer(uint256 _pID, MC2datasets.EventReturns memory _eventData_)
1189         private
1190         returns (MC2datasets.EventReturns)
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
1209     function endRound(MC2datasets.EventReturns memory _eventData_)
1210         private
1211         returns (MC2datasets.EventReturns)
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
1223         // calculate our winner share, community rewards, gen share, 
1224         // up share, and amount reserved for next pot
1225         uint256 _win = (_pot.mul(48)) / 100;
1226         uint256 _com = (_pot / 50);
1227         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1228         uint256 _up = (_pot.mul(potSplit_[_winTID].up)) / 100;
1229         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_up);
1230         
1231         // calculate ppt for round mask
1232         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1233         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1234         if (_dust > 0)
1235         {
1236             _gen = _gen.sub(_dust);
1237             _res = _res.add(_dust);
1238         }
1239         
1240         // pay our winner
1241         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1242         
1243         // community rewards
1244         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1245         {
1246             // This ensures Team Just cannot influence the outcome of MC2 with
1247             // bank migrations by breaking outgoing transactions.
1248             // Something we would never do. But that's not the point.
1249             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1250             // highest belief that everything we create should be trustless.
1251             // Team JUST, The name you shouldn't have to trust.
1252             _up = _up.add(_com);
1253             _com = 0;
1254         }
1255         
1256         // distribute gen portion to key holders
1257         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1258         
1259         // send share for up to divies
1260         if (_up > 0)
1261             Divies.deposit.value(_up)();
1262             
1263         // prepare event data
1264         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1265         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1266         _eventData_.winnerAddr = plyr_[_winPID].addr;
1267         _eventData_.winnerName = plyr_[_winPID].name;
1268         _eventData_.amountWon = _win;
1269         _eventData_.genAmount = _gen;
1270         _eventData_.UPAmount = _up;
1271         _eventData_.newPot = _res;
1272         
1273         // start next round
1274         rID_++;
1275         _rID++;
1276         round_[_rID].strt = now;
1277         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1278         round_[_rID].pot = _res;
1279         
1280         return(_eventData_);
1281     }
1282     
1283     /**
1284      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1285      */
1286     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1287         private 
1288     {
1289         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1290         if (_earnings > 0)
1291         {
1292             // put in gen vault
1293             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1294             // zero out their earnings by updating mask
1295             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1296         }
1297     }
1298     
1299     /**
1300      * @dev updates round timer based on number of whole keys bought.
1301      */
1302     function updateTimer(uint256 _keys, uint256 _rID)
1303         private
1304     {
1305         // grab time
1306         uint256 _now = now;
1307         
1308         // calculate time based on number of keys bought
1309         uint256 _newTime;
1310         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1311             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1312         else
1313             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1314         
1315         // compare to max and set new end time
1316         if (_newTime < (rndMax_).add(_now))
1317             round_[_rID].end = _newTime;
1318         else
1319             round_[_rID].end = rndMax_.add(_now);
1320     }
1321     
1322     /**
1323      * @dev generates a random number between 0-99 and checks to see if thats
1324      * resulted in an airdrop win
1325      * @return do we have a winner?
1326      */
1327     function airdrop()
1328         private 
1329         view 
1330         returns(bool)
1331     {
1332         uint256 seed = uint256(keccak256(abi.encodePacked(
1333             
1334             (block.timestamp).add
1335             (block.difficulty).add
1336             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1337             (block.gaslimit).add
1338             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1339             (block.number)
1340             
1341         )));
1342         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1343             return(true);
1344         else
1345             return(false);
1346     }
1347 
1348     /**
1349      * @dev distributes eth based on fees to com, aff, and up
1350      */
1351     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, MC2datasets.EventReturns memory _eventData_)
1352         private
1353         returns(MC2datasets.EventReturns)
1354     {
1355         // pay 2% out to community rewards
1356         uint256 _com = _eth / 50;
1357         uint256 _up;
1358         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1359         {
1360             // This ensures Team Just cannot influence the outcome of MC2 with
1361             // bank migrations by breaking outgoing transactions.
1362             // Something we would never do. But that's not the point.
1363             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1364             // highest belief that everything we create should be trustless.
1365             // Team JUST, The name you shouldn't have to trust.
1366             _up = _com;
1367             _com = 0;
1368         }
1369         
1370         // pay 1% out to MC2 short
1371         uint256 _long = _eth / 100;
1372         otherMC2_.potSwap.value(_long)();
1373         
1374         // distribute share to affiliate
1375         uint256 _aff = _eth / 10;
1376         
1377         // decide what to do with affiliate share of fees
1378         // affiliate must not be self, and must have a name registered
1379         if (_affID != _pID && plyr_[_affID].name != '') {
1380             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1381             emit MC2events.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1382         } else {
1383             _up = _aff;
1384         }
1385         
1386         // pay out up
1387         _up = _up.add((_eth.mul(fees_[_team].up)) / (100));
1388         if (_up > 0)
1389         {
1390             // deposit to divies contract
1391             Divies.deposit.value(_up)();
1392             
1393             // set up event data
1394             _eventData_.UPAmount = _up.add(_eventData_.UPAmount);
1395         }
1396         
1397         return(_eventData_);
1398     }
1399     
1400     function potSwap()
1401         external
1402         payable
1403     {
1404         // setup local rID
1405         uint256 _rID = rID_ + 1;
1406         
1407         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1408         emit MC2events.onPotSwapDeposit(_rID, msg.value);
1409     }
1410     
1411     /**
1412      * @dev distributes eth based on fees to gen and pot
1413      */
1414     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, MC2datasets.EventReturns memory _eventData_)
1415         private
1416         returns(MC2datasets.EventReturns)
1417     {
1418         // calculate gen share
1419         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1420         
1421         // toss 1% into airdrop pot 
1422         uint256 _air = (_eth / 100);
1423         airDropPot_ = airDropPot_.add(_air);
1424         
1425         // update eth balance (eth = eth - (com share + pot swap share + aff share + up share + airdrop pot share))
1426         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].up)) / 100));
1427         
1428         // calculate pot 
1429         uint256 _pot = _eth.sub(_gen);
1430         
1431         // distribute gen share (thats what updateMasks() does) and adjust
1432         // balances for dust.
1433         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1434         if (_dust > 0)
1435             _gen = _gen.sub(_dust);
1436         
1437         // add eth to pot
1438         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1439         
1440         // set up event data
1441         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1442         _eventData_.potAmount = _pot;
1443         
1444         return(_eventData_);
1445     }
1446 
1447     /**
1448      * @dev updates masks for round and player when keys are bought
1449      * @return dust left over 
1450      */
1451     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1452         private
1453         returns(uint256)
1454     {
1455         /* MASKING NOTES
1456             earnings masks are a tricky thing for people to wrap their minds around.
1457             the basic thing to understand here.  is were going to have a global
1458             tracker based on profit per share for each round, that increases in
1459             relevant proportion to the increase in share supply.
1460             
1461             the player will have an additional mask that basically says "based
1462             on the rounds mask, my shares, and how much i've already withdrawn,
1463             how much is still owed to me?"
1464         */
1465         
1466         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1467         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1468         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1469             
1470         // calculate player earning from their own buy (only based on the keys
1471         // they just bought).  & update player earnings mask
1472         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1473         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1474         
1475         // calculate & return dust
1476         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1477     }
1478     
1479     /**
1480      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1481      * @return earnings in wei format
1482      */
1483     function withdrawEarnings(uint256 _pID)
1484         private
1485         returns(uint256)
1486     {
1487         // update gen vault
1488         updateGenVault(_pID, plyr_[_pID].lrnd);
1489         
1490         // from vaults 
1491         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1492         if (_earnings > 0)
1493         {
1494             plyr_[_pID].win = 0;
1495             plyr_[_pID].gen = 0;
1496             plyr_[_pID].aff = 0;
1497         }
1498 
1499         return(_earnings);
1500     }
1501     
1502     /**
1503      * @dev prepares compression data and fires event for buy or reload tx's
1504      */
1505     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, MC2datasets.EventReturns memory _eventData_)
1506         private
1507     {
1508         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1509         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1510         
1511         emit MC2events.onEndTx
1512         (
1513             _eventData_.compressedData,
1514             _eventData_.compressedIDs,
1515             plyr_[_pID].name,
1516             msg.sender,
1517             _eth,
1518             _keys,
1519             _eventData_.winnerAddr,
1520             _eventData_.winnerName,
1521             _eventData_.amountWon,
1522             _eventData_.newPot,
1523             _eventData_.UPAmount,
1524             _eventData_.genAmount,
1525             _eventData_.potAmount,
1526             airDropPot_
1527         );
1528     }
1529 
1530     /** upon contract deploy, it will be deactivated.  this is a one time
1531      * use function that will activate the contract.  we do this so devs 
1532      * have time to set things up on the web end                            **/
1533     bool public activated_ = false;
1534     function activate()
1535         public
1536     {
1537         // only team just can activate 
1538         require(
1539             msg.sender == 0x1d85A7C26952d4a7D940573eaE73f44D0D6Fa76D ||
1540             msg.sender == 0x5724fc4Abb369C6F2339F784E5b42189f3d30180 ||
1541             msg.sender == 0x6Be04d4ef139eE9fd08A32FdBFb7A532Fe9eD53F ||
1542             msg.sender == 0x53E3E6444C416e2A981644706A8E5E9C13511cf7 ||
1543             msg.sender == 0xEeF4f752D105fEaCB288bB7071F619A2E90a34aC,
1544             "only team just can activate"
1545         );
1546 
1547         // make sure that its been linked.
1548         require(address(otherMC2_) != address(0), "must link to other MC2 first");
1549         
1550         // can only be ran once
1551         require(activated_ == false, "fomo3d already activated");
1552         
1553         // activate the contract 
1554         activated_ = true;
1555         
1556         // lets start first round
1557         rID_ = 1;
1558         round_[1].strt = now + rndExtra_ - rndGap_;
1559         round_[1].end = now + rndInit_ + rndExtra_;
1560     }
1561     function setOtherFomo(address _otherMC2)
1562         public
1563     {
1564         // only team just can activate 
1565         require(
1566             msg.sender == 0x1d85A7C26952d4a7D940573eaE73f44D0D6Fa76D ||
1567             msg.sender == 0x5724fc4Abb369C6F2339F784E5b42189f3d30180 ||
1568             msg.sender == 0x6Be04d4ef139eE9fd08A32FdBFb7A532Fe9eD53F ||
1569             msg.sender == 0x53E3E6444C416e2A981644706A8E5E9C13511cf7 ||
1570             msg.sender == 0xEeF4f752D105fEaCB288bB7071F619A2E90a34aC,
1571             "only team just can activate"
1572         );
1573 
1574         // make sure that it HASNT yet been linked.
1575         require(address(otherMC2_) == address(0), "silly dev, you already did that");
1576         
1577         // set up other fomo3d (fast or long) for pot swap
1578         otherMC2_ = otherMC2(_otherMC2);
1579     }
1580 }
1581 
1582 
1583 library MC2datasets {
1584     //compressedData key
1585     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1586         // 0 - new player (bool)
1587         // 1 - joined round (bool)
1588         // 2 - new  leader (bool)
1589         // 3-5 - air drop tracker (uint 0-999)
1590         // 6-16 - round end time
1591         // 17 - winnerTeam
1592         // 18 - 28 timestamp 
1593         // 29 - team
1594         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1595         // 31 - airdrop happened bool
1596         // 32 - airdrop tier 
1597         // 33 - airdrop amount won
1598     //compressedIDs key
1599     // [77-52][51-26][25-0]
1600         // 0-25 - pID 
1601         // 26-51 - winPID
1602         // 52-77 - rID
1603     struct EventReturns {
1604         uint256 compressedData;
1605         uint256 compressedIDs;
1606         address winnerAddr;         // winner address
1607         bytes32 winnerName;         // winner name
1608         uint256 amountWon;          // amount won
1609         uint256 newPot;             // amount in new pot
1610         uint256 UPAmount;          // amount distributed to up
1611         uint256 genAmount;          // amount distributed to gen
1612         uint256 potAmount;          // amount added to pot
1613     }
1614     struct Player {
1615         address addr;   // player address
1616         bytes32 name;   // player name
1617         uint256 win;    // winnings vault
1618         uint256 gen;    // general vault
1619         uint256 aff;    // affiliate vault
1620         uint256 lrnd;   // last round played
1621         uint256 laff;   // last affiliate id used
1622     }
1623     struct PlayerRounds {
1624         uint256 eth;    // eth player has added to round (used for eth limiter)
1625         uint256 keys;   // keys
1626         uint256 mask;   // player mask 
1627         uint256 ico;    // ICO phase investment
1628     }
1629     struct Round {
1630         uint256 plyr;   // pID of player in lead
1631         uint256 team;   // tID of team in lead
1632         uint256 end;    // time ends/ended
1633         bool ended;     // has round end function been ran
1634         uint256 strt;   // time round started
1635         uint256 keys;   // keys
1636         uint256 eth;    // total eth in
1637         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1638         uint256 mask;   // global mask
1639         uint256 ico;    // total eth sent in during ICO phase
1640         uint256 icoGen; // total eth for gen during ICO phase
1641         uint256 icoAvg; // average key price for ICO phase
1642     }
1643     struct TeamFee {
1644         uint256 gen;    // % of buy in thats paid to key holders of current round
1645         uint256 up;    // % of buy in thats paid to up holders
1646     }
1647     struct PotSplit {
1648         uint256 gen;    // % of pot thats paid to key holders of current round
1649         uint256 up;    // % of pot thats paid to up holders
1650     }
1651 }
1652 
1653 //==============================================================================
1654 //  |  _      _ _ | _  .
1655 //  |<(/_\/  (_(_||(_  .
1656 //=======/======================================================================
1657 library MC2KeysCalcLong {
1658     using SafeMath for *;
1659     /**
1660      * @dev calculates number of keys received given X eth 
1661      * @param _curEth current amount of eth in contract 
1662      * @param _newEth eth being spent
1663      * @return amount of ticket purchased
1664      */
1665     function keysRec(uint256 _curEth, uint256 _newEth)
1666         internal
1667         pure
1668         returns (uint256)
1669     {
1670         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1671     }
1672     
1673     /**
1674      * @dev calculates amount of eth received if you sold X keys 
1675      * @param _curKeys current amount of keys that exist 
1676      * @param _sellKeys amount of keys you wish to sell
1677      * @return amount of eth received
1678      */
1679     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1680         internal
1681         pure
1682         returns (uint256)
1683     {
1684         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1685     }
1686 
1687     /**
1688      * @dev calculates how many keys would exist with given an amount of eth
1689      * @param _eth eth "in contract"
1690      * @return number of keys that would exist
1691      */
1692     function keys(uint256 _eth) 
1693         internal
1694         pure
1695         returns(uint256)
1696     {
1697         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1698     }
1699     
1700     /**
1701      * @dev calculates how much eth would be in contract given a number of keys
1702      * @param _keys number of keys "in contract" 
1703      * @return eth that would exists
1704      */
1705     function eth(uint256 _keys) 
1706         internal
1707         pure
1708         returns(uint256)  
1709     {
1710         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1711     }
1712 }
1713 
1714 
1715 interface otherMC2 {
1716     function potSwap() external payable;
1717 }
1718 
1719 interface MC2SettingInterface {
1720     function getFastGap() external returns(uint256);
1721     function getLongGap() external returns(uint256);
1722     function getFastExtra() external returns(uint256);
1723     function getLongExtra() external returns(uint256);
1724 }
1725 
1726 interface DiviesInterface {
1727     function deposit() external payable;
1728 }
1729 
1730 interface JIincForwarderInterface {
1731     function deposit() external payable returns(bool);
1732     function status() external view returns(address, address, bool);
1733     function startMigration(address _newCorpBank) external returns(bool);
1734     function cancelMigration() external returns(bool);
1735     function finishMigration() external returns(bool);
1736     function setup(address _firstCorpBank) external;
1737 }
1738 
1739 interface PlayerBookInterface {
1740     function getPlayerID(address _addr) external returns (uint256);
1741     function getPlayerName(uint256 _pID) external view returns (bytes32);
1742     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1743     function getPlayerAddr(uint256 _pID) external view returns (address);
1744     function getNameFee() external view returns (uint256);
1745     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1746     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1747     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1748 }
1749 
1750 
1751 
1752 library NameFilter {
1753     /**
1754      * @dev filters name strings
1755      * -converts uppercase to lower case.  
1756      * -makes sure it does not start/end with a space
1757      * -makes sure it does not contain multiple spaces in a row
1758      * -cannot be only numbers
1759      * -cannot start with 0x 
1760      * -restricts characters to A-Z, a-z, 0-9, and space.
1761      * @return reprocessed string in bytes32 format
1762      */
1763     function nameFilter(string _input)
1764         internal
1765         pure
1766         returns(bytes32)
1767     {
1768         bytes memory _temp = bytes(_input);
1769         uint256 _length = _temp.length;
1770         
1771         //sorry limited to 32 characters
1772         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1773         // make sure it doesnt start with or end with space
1774         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1775         // make sure first two characters are not 0x
1776         if (_temp[0] == 0x30)
1777         {
1778             require(_temp[1] != 0x78, "string cannot start with 0x");
1779             require(_temp[1] != 0x58, "string cannot start with 0X");
1780         }
1781         
1782         // create a bool to track if we have a non number character
1783         bool _hasNonNumber;
1784         
1785         // convert & check
1786         for (uint256 i = 0; i < _length; i++)
1787         {
1788             // if its uppercase A-Z
1789             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1790             {
1791                 // convert to lower case a-z
1792                 _temp[i] = byte(uint(_temp[i]) + 32);
1793                 
1794                 // we have a non number
1795                 if (_hasNonNumber == false)
1796                     _hasNonNumber = true;
1797             } else {
1798                 require
1799                 (
1800                     // require character is a space
1801                     _temp[i] == 0x20 || 
1802                     // OR lowercase a-z
1803                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1804                     // or 0-9
1805                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1806                     "string contains invalid characters"
1807                 );
1808                 // make sure theres not 2x spaces in a row
1809                 if (_temp[i] == 0x20)
1810                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1811                 
1812                 // see if we have a character other than a number
1813                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1814                     _hasNonNumber = true;    
1815             }
1816         }
1817         
1818         require(_hasNonNumber == true, "string cannot be only numbers");
1819         
1820         bytes32 _ret;
1821         assembly {
1822             _ret := mload(add(_temp, 32))
1823         }
1824         return (_ret);
1825     }
1826 }
1827 
1828 /**
1829  * @title SafeMath v0.1.9
1830  * @dev Math operations with safety checks that throw on error
1831  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1832  * - added sqrt
1833  * - added sq
1834  * - added pwr 
1835  * - changed asserts to requires with error log outputs
1836  * - removed div, its useless
1837  */
1838 library SafeMath {
1839     
1840     /**
1841     * @dev Multiplies two numbers, throws on overflow.
1842     */
1843     function mul(uint256 a, uint256 b) 
1844         internal 
1845         pure 
1846         returns (uint256 c) 
1847     {
1848         if (a == 0) {
1849             return 0;
1850         }
1851         c = a * b;
1852         require(c / a == b, "SafeMath mul failed");
1853         return c;
1854     }
1855 
1856     /**
1857     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1858     */
1859     function sub(uint256 a, uint256 b)
1860         internal
1861         pure
1862         returns (uint256) 
1863     {
1864         require(b <= a, "SafeMath sub failed");
1865         return a - b;
1866     }
1867 
1868     /**
1869     * @dev Adds two numbers, throws on overflow.
1870     */
1871     function add(uint256 a, uint256 b)
1872         internal
1873         pure
1874         returns (uint256 c) 
1875     {
1876         c = a + b;
1877         require(c >= a, "SafeMath add failed");
1878         return c;
1879     }
1880     
1881     /**
1882      * @dev gives square root of given x.
1883      */
1884     function sqrt(uint256 x)
1885         internal
1886         pure
1887         returns (uint256 y) 
1888     {
1889         uint256 z = ((add(x,1)) / 2);
1890         y = x;
1891         while (z < y) 
1892         {
1893             y = z;
1894             z = ((add((x / z),z)) / 2);
1895         }
1896     }
1897     
1898     /**
1899      * @dev gives square. multiplies x by x
1900      */
1901     function sq(uint256 x)
1902         internal
1903         pure
1904         returns (uint256)
1905     {
1906         return (mul(x,x));
1907     }
1908     
1909     /**
1910      * @dev x to the power of y 
1911      */
1912     function pwr(uint256 x, uint256 y)
1913         internal 
1914         pure 
1915         returns (uint256)
1916     {
1917         if (x==0)
1918             return (0);
1919         else if (y==0)
1920             return (1);
1921         else 
1922         {
1923             uint256 z = x;
1924             for (uint256 i=1; i < y; i++)
1925                 z = mul(z,x);
1926             return (z);
1927         }
1928     }
1929 }