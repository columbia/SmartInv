1 pragma solidity ^0.4.24;
2 
3 library NameFilter {
4     /**
5      * @dev filters name strings
6      * -converts uppercase to lower case.
7      * -makes sure it does not start/end with a space
8      * -makes sure it does not contain multiple spaces in a row
9      * -cannot be only numbers
10      * -cannot start with 0x
11      * -restricts characters to A-Z, a-z, 0-9, and space.
12      * @return reprocessed string in bytes32 format
13      */
14     function nameFilter(string _input)
15         internal
16         pure
17         returns(bytes32)
18     {
19         bytes memory _temp = bytes(_input);
20         uint256 _length = _temp.length;
21 
22         //sorry limited to 32 characters
23         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
24         // make sure it doesnt start with or end with space
25         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
26         // make sure first two characters are not 0x
27         if (_temp[0] == 0x30)
28         {
29             require(_temp[1] != 0x78, "string cannot start with 0x");
30             require(_temp[1] != 0x58, "string cannot start with 0X");
31         }
32 
33         // create a bool to track if we have a non number character
34         bool _hasNonNumber;
35 
36         // convert & check
37         for (uint256 i = 0; i < _length; i++)
38         {
39             // if its uppercase A-Z
40             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
41             {
42                 // convert to lower case a-z
43                 _temp[i] = byte(uint(_temp[i]) + 32);
44 
45                 // we have a non number
46                 if (_hasNonNumber == false)
47                     _hasNonNumber = true;
48             } else {
49                 require
50                 (
51                     // require character is a space
52                     _temp[i] == 0x20 ||
53                     // OR lowercase a-z
54                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
55                     // or 0-9
56                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
57                     "string contains invalid characters"
58                 );
59                 // make sure theres not 2x spaces in a row
60                 if (_temp[i] == 0x20)
61                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
62 
63                 // see if we have a character other than a number
64                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
65                     _hasNonNumber = true;
66             }
67         }
68 
69         require(_hasNonNumber == true, "string cannot be only numbers");
70 
71         bytes32 _ret;
72         assembly {
73             _ret := mload(add(_temp, 32))
74         }
75         return (_ret);
76     }
77 }
78 
79 /**
80  * @title SafeMath v0.1.9
81  * @dev Math operations with safety checks that throw on error
82  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
83  * - added sqrt
84  * - added sq
85  * - added pwr
86  * - changed asserts to requires with error log outputs
87  * - removed div, its useless
88  */
89 library SafeMath {
90 
91     /**
92     * @dev Multiplies two numbers, throws on overflow.
93     */
94     function mul(uint256 a, uint256 b)
95         internal
96         pure
97         returns (uint256 c)
98     {
99         if (a == 0) {
100             return 0;
101         }
102         c = a * b;
103         require(c / a == b, "SafeMath mul failed");
104         return c;
105     }
106 
107     /**
108     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109     */
110     function sub(uint256 a, uint256 b)
111         internal
112         pure
113         returns (uint256)
114     {
115         require(b <= a, "SafeMath sub failed");
116         return a - b;
117     }
118 
119     /**
120     * @dev Adds two numbers, throws on overflow.
121     */
122     function add(uint256 a, uint256 b)
123         internal
124         pure
125         returns (uint256 c)
126     {
127         c = a + b;
128         require(c >= a, "SafeMath add failed");
129         return c;
130     }
131 
132     /**
133      * @dev gives square root of given x.
134      */
135     function sqrt(uint256 x)
136         internal
137         pure
138         returns (uint256 y)
139     {
140         uint256 z = ((add(x,1)) / 2);
141         y = x;
142         while (z < y)
143         {
144             y = z;
145             z = ((add((x / z),z)) / 2);
146         }
147     }
148 
149     /**
150      * @dev gives square. multiplies x by x
151      */
152     function sq(uint256 x)
153         internal
154         pure
155         returns (uint256)
156     {
157         return (mul(x,x));
158     }
159 
160     /**
161      * @dev x to the power of y
162      */
163     function pwr(uint256 x, uint256 y)
164         internal
165         pure
166         returns (uint256)
167     {
168         if (x==0)
169             return (0);
170         else if (y==0)
171             return (1);
172         else
173         {
174             uint256 z = x;
175             for (uint256 i=1; i < y; i++)
176                 z = mul(z,x);
177             return (z);
178         }
179     }
180 }
181 
182 
183 
184 //==============================================================================
185 //   __|_ _    __|_ _  .
186 //  _\ | | |_|(_ | _\  .
187 //==============================================================================
188 library F3Ddatasets {
189     //compressedData key
190     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
191         // 0 - new player (bool)
192         // 1 - joined round (bool)
193         // 2 - new  leader (bool)
194         // 3-5 - air drop tracker (uint 0-999)
195         // 6-16 - round end time
196         // 17 - winnerTeam
197         // 18 - 28 timestamp
198         // 29 - team
199         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
200         // 31 - airdrop happened bool
201         // 32 - airdrop tier
202         // 33 - airdrop amount won
203         
204     //compressedIDs key
205     // [77-52][51-26][25-0]
206         // 0-25 - pID
207         // 26-51 - winPID
208         // 52-77 - rID
209     struct EventReturns {
210         uint256 compressedData;
211         uint256 compressedIDs;
212         address winnerAddr;         // winner address
213         bytes32 winnerName;         // winner name
214         uint256 amountWon;          // amount won
215         uint256 newPot;             // amount in new pot
216         uint256 P3DAmount;          // amount distributed to p3d
217         uint256 genAmount;          // amount distributed to gen
218         uint256 potAmount;          // amount added to pot
219     }
220     struct Player {
221         address addr;   // player address
222         bytes32 name;   // player name
223         uint256 win;    // winnings vault
224         uint256 gen;    // general vault
225         uint256 aff;    // affiliate vault
226         uint256 lrnd;   // last round played
227         uint256 laff;   // last affiliate id used
228     }
229     struct PlayerRounds {
230         uint256 eth;    // eth player has added to round (used for eth limiter)
231         uint256 keys;   // keys
232         uint256 mask;   // player mask
233         uint256 ico;    // ICO phase investment
234     }
235     struct Round {
236         uint256 plyr;   // pID of player in lead
237         uint256 team;   // tID of team in lead
238         uint256 end;    // time ends/ended
239         bool ended;     // has round end function been ran
240         uint256 strt;   // time round started
241         uint256 keys;   // keys
242         uint256 eth;    // total eth in
243         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
244         uint256 mask;   // global mask
245         uint256 ico;    // total eth sent in during ICO phase
246         uint256 icoGen; // total eth for gen during ICO phase
247         uint256 icoAvg; // average key price for ICO phase
248     }
249     struct TeamFee {
250         uint256 gen;    // % of buy in thats paid to key holders of current round
251         uint256 p3d;    // % of buy in thats paid to p3d holders
252     }
253     struct PotSplit {
254         uint256 gen;    // % of pot thats paid to key holders of current round
255         uint256 p3d;    // % of pot thats paid to p3d holders
256     }
257 }
258 
259 //==============================================================================
260 //  |  _      _ _ | _  .
261 //  |<(/_\/  (_(_||(_  .
262 //=======/======================================================================
263 library F3DKeysCalcShort {
264     using SafeMath for *;
265     /**
266      * @dev calculates number of keys received given X eth
267      * @param _curEth current amount of eth in contract
268      * @param _newEth eth being spent
269      * @return amount of ticket purchased
270      */
271     function keysRec(uint256 _curEth, uint256 _newEth)
272         internal
273         pure
274         returns (uint256)
275     {
276         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
277     }
278 
279     /**
280      * @dev calculates amount of eth received if you sold X keys
281      * @param _curKeys current amount of keys that exist
282      * @param _sellKeys amount of keys you wish to sell
283      * @return amount of eth received
284      */
285     function ethRec(uint256 _curKeys, uint256 _sellKeys)
286         internal
287         pure
288         returns (uint256)
289     {
290         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
291     }
292 
293     /**
294      * @dev calculates how many keys would exist with given an amount of eth
295      * @param _eth eth "in contract"
296      * @return number of keys that would exist
297      */
298     function keys(uint256 _eth)
299         internal
300         pure
301         returns(uint256)
302     {
303         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
304     }
305 
306     /**
307      * @dev calculates how much eth would be in contract given a number of keys
308      * @param _keys number of keys "in contract"
309      * @return eth that would exists
310      */
311     function eth(uint256 _keys)
312         internal
313         pure
314         returns(uint256)
315     {
316         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
317     }
318 }
319 
320 //==============================================================================
321 //  . _ _|_ _  _ |` _  _ _  _  .
322 //  || | | (/_| ~|~(_|(_(/__\  .
323 //==============================================================================
324 
325 
326 contract F3Devents {
327     // fired whenever a player registers a name
328     event onNewName
329     (
330         uint256 indexed playerID,
331         address indexed playerAddress,
332         bytes32 indexed playerName,
333         bool isNewPlayer,
334         uint256 affiliateID,
335         address affiliateAddress,
336         bytes32 affiliateName,
337         uint256 amountPaid,
338         uint256 timeStamp
339     );
340 
341     // fired at end of buy or reload
342     event onEndTx
343     (
344         uint256 compressedData,
345         uint256 compressedIDs,
346         bytes32 playerName,
347         address playerAddress,
348         uint256 ethIn,
349         uint256 keysBought,
350         address winnerAddr,
351         bytes32 winnerName,
352         uint256 amountWon,
353         uint256 newPot,
354         uint256 P3DAmount,
355         uint256 genAmount,
356         uint256 potAmount,
357         uint256 airDropPot
358     );
359 
360 	// fired whenever theres a withdraw
361     event onWithdraw
362     (
363         uint256 indexed playerID,
364         address playerAddress,
365         bytes32 playerName,
366         uint256 ethOut,
367         uint256 timeStamp
368     );
369 
370     // fired whenever a withdraw forces end round to be ran
371     event onWithdrawAndDistribute
372     (
373         address playerAddress,
374         bytes32 playerName,
375         uint256 ethOut,
376         uint256 compressedData,
377         uint256 compressedIDs,
378         address winnerAddr,
379         bytes32 winnerName,
380         uint256 amountWon,
381         uint256 newPot,
382         uint256 P3DAmount,
383         uint256 genAmount
384     );
385 
386     // (fomo3d short only) fired whenever a player tries a buy after round timer
387     // hit zero, and causes end round to be ran.
388     event onBuyAndDistribute
389     (
390         address playerAddress,
391         bytes32 playerName,
392         uint256 ethIn,
393         uint256 compressedData,
394         uint256 compressedIDs,
395         address winnerAddr,
396         bytes32 winnerName,
397         uint256 amountWon,
398         uint256 newPot,
399         uint256 P3DAmount,
400         uint256 genAmount
401     );
402 
403     // (fomo3d short only) fired whenever a player tries a reload after round timer
404     // hit zero, and causes end round to be ran.
405     event onReLoadAndDistribute
406     (
407         address playerAddress,
408         bytes32 playerName,
409         uint256 compressedData,
410         uint256 compressedIDs,
411         address winnerAddr,
412         bytes32 winnerName,
413         uint256 amountWon,
414         uint256 newPot,
415         uint256 P3DAmount,
416         uint256 genAmount
417     );
418 
419     // fired whenever an affiliate is paid
420     event onAffiliatePayout
421     (
422         uint256 indexed affiliateID,
423         address affiliateAddress,
424         bytes32 affiliateName,
425         uint256 indexed roundID,
426         uint256 indexed buyerID,
427         uint256 amount,
428         uint256 timeStamp
429     );
430 
431     // received pot swap deposit
432     event onPotSwapDeposit
433     (
434         uint256 roundID,
435         uint256 amountAddedToPot
436     );
437 }
438 
439 interface PlayerBookInterface {
440     function getPlayerID(address _addr) external returns (uint256);
441     function getPlayerName(uint256 _pID) external view returns (bytes32);
442     function getPlayerLAff(uint256 _pID) external view returns (uint256);
443     function getPlayerAddr(uint256 _pID) external view returns (address);
444     function getNameFee() external view returns (uint256);
445     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
446     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
447     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
448 }
449 
450 contract modularFast is F3Devents {}
451 
452 
453 contract FoMo3DFast is modularFast {
454     using SafeMath for *;
455     using NameFilter for string;
456     using F3DKeysCalcShort for uint256;
457 
458     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x6A374bC780d5490253256c62178494870416b14A);
459 
460     address private admin = msg.sender;
461     string constant public name = "OTION";
462     string constant public symbol = "OTION";
463     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
464     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
465     uint256 constant private rndInit_ = 88 minutes;                // round timer starts at this
466     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
467     uint256 constant private rndMax_ = 888 minutes;                // max length a round timer can be
468     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
469     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
470     uint256 public rID_;    // round id number / total rounds that have happened
471     //****************
472     // PLAYER DATA
473     //****************
474     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
475     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
476     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
477     // (pID => rID => data) player round data by player id & round id
478     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
479     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
480     //****************
481     // ROUND DATA
482     //****************
483     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
484     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
485     //****************
486     // TEAM FEE DATA
487     //****************
488     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
489     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
490 
491     constructor()
492         public
493     {
494     // Team allocation structures
495         // 0 = the only team
496         
497 
498     // Team allocation percentages
499         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
500             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
501         fees_[0] = F3Ddatasets.TeamFee(80,0);   //10% to pot, 8% to aff, 2% to com
502 
503         // how to split up the final pot based on which team was picked
504         // (F3D, P3D)
505         potSplit_[0] = F3Ddatasets.PotSplit(0,0);  //100% to winner
506     }
507     //==============================================================================
508     //     _ _  _  _|. |`. _  _ _  .
509     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
510     //==============================================================================
511     /**
512     * @dev used to make sure no one can interact with contract until it has
513     * been activated.
514     */
515     modifier isActivated() {
516         require(activated_ == true, "its not ready yet.  check ?eta in discord");
517         _;
518     }
519 
520     /**
521     * @dev prevents contracts from interacting with fomo3d
522     */
523     modifier isHuman() {
524         address _addr = msg.sender;
525         uint256 _codeLength;
526 
527         assembly {_codeLength := extcodesize(_addr)}
528         require(_codeLength == 0, "sorry humans only");
529         _;
530     }
531 
532     /**
533     * @dev sets boundaries for incoming tx
534     */
535     modifier isWithinLimits(uint256 _eth) {
536         require(_eth >= 1000000000, "pocket lint: not a valid currency");
537         _;
538     }
539 
540     //==============================================================================
541     //     _    |_ |. _   |`    _  __|_. _  _  _  .
542     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
543     //====|=========================================================================
544     /**
545     * @dev emergency buy uses last stored affiliate ID and team snek
546     */
547     function()
548         isActivated()
549         isHuman()
550         isWithinLimits(msg.value)
551         public
552         payable
553     {
554         // set up our tx event data and determine if player is new or not
555         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
556 
557         // fetch player id
558         uint256 _pID = pIDxAddr_[msg.sender];
559 
560         // buy core
561         buyCore(_pID, plyr_[1].laff, 0, _eventData_);
562     }
563 
564       /**
565        * @dev converts all incoming ethereum to keys.
566        * -functionhash- 0x8f38f309 (using ID for affiliate)
567        * -functionhash- 0x98a0871d (using address for affiliate)
568        * -functionhash- 0xa65b37a1 (using name for affiliate)
569        * @param _affCode the ID/address/name of the player who gets the affiliate fee
570        * @param _team what team is the player playing for?
571        */
572       function buyXid(uint256 _affCode, uint256 _team)
573           isActivated()
574           isHuman()
575           isWithinLimits(msg.value)
576           public
577           payable
578       {
579           // set up our tx event data and determine if player is new or not
580           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
581 
582           // fetch player id
583           uint256 _pID = pIDxAddr_[msg.sender];
584 
585           // manage affiliate residuals
586           // if no affiliate code was given or player tried to use their own, lolz
587           if (_affCode == 0 || _affCode == _pID)
588           {
589               // use last stored affiliate code
590               _affCode = plyr_[_pID].laff;
591 
592           // if affiliate code was given & its not the same as previously stored
593           } else if (_affCode != plyr_[_pID].laff) {
594               // update last affiliate
595               plyr_[_pID].laff = _affCode;
596           }
597 
598           // verify a valid team was selected
599           _team = verifyTeam(_team);
600 
601           // buy core
602           buyCore(_pID, _affCode, _team, _eventData_);
603       }
604 
605       function buyXaddr(address _affCode, uint256 _team)
606           isActivated()
607           isWithinLimits(msg.value)
608           public
609           payable
610       {
611           // set up our tx event data and determine if player is new or not
612           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
613 
614           // fetch player id
615           uint256 _pID = pIDxAddr_[msg.sender];
616 
617           // manage affiliate residuals
618           uint256 _affID;
619           // if no affiliate code was given or player tried to use their own, lolz
620           if (_affCode == address(0) || _affCode == msg.sender)
621           {
622               // use last stored affiliate code
623               _affID = plyr_[_pID].laff;
624 
625           // if affiliate code was given
626           } else {
627               // get affiliate ID from aff Code
628               _affID = pIDxAddr_[_affCode];
629 
630               // if affID is not the same as previously stored
631               if (_affID != plyr_[_pID].laff)
632               {
633                   // update last affiliate
634                   plyr_[_pID].laff = _affID;
635               }
636           }
637 
638           // verify a valid team was selected
639           _team = verifyTeam(_team);
640 
641           // buy core
642           buyCore(_pID, _affID, _team, _eventData_);
643       }
644 
645       function buyXname(bytes32 _affCode, uint256 _team)
646           isActivated()
647           isHuman()
648           isWithinLimits(msg.value)
649           public
650           payable
651       {
652           // set up our tx event data and determine if player is new or not
653           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
654 
655           // fetch player id
656           uint256 _pID = pIDxAddr_[msg.sender];
657 
658           // manage affiliate residuals
659           uint256 _affID;
660           // if no affiliate code was given or player tried to use their own, lolz
661           if (_affCode == '' || _affCode == plyr_[_pID].name)
662           {
663               // use last stored affiliate code
664               _affID = plyr_[_pID].laff;
665 
666           // if affiliate code was given
667           } else {
668               // get affiliate ID from aff Code
669               _affID = pIDxName_[_affCode];
670 
671               // if affID is not the same as previously stored
672               if (_affID != plyr_[_pID].laff)
673               {
674                   // update last affiliate
675                   plyr_[_pID].laff = _affID;
676               }
677           }
678 
679           // verify a valid team was selected
680           _team = verifyTeam(_team);
681 
682           // buy core
683           buyCore(_pID, _affID, _team, _eventData_);
684       }
685 
686 
687     function buyXnameQR(address _realSender)
688         isActivated()
689         isWithinLimits(msg.value)
690         public
691         payable
692     {
693         // set up our tx event data and determine if player is new or not
694         F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
695 
696         // fetch player id
697         uint256 _pID = pIDxAddr_[_realSender];
698 
699         // manage affiliate residuals
700         uint256 _affID = 1;
701         
702         // verify a valid team was selected
703         uint256 _team = 0;
704 
705         // buy core
706         buyCoreQR(_realSender, _pID, _affID, _team, _eventData_);
707     }
708 
709       /**
710        * @dev essentially the same as buy, but instead of you sending ether
711        * from your wallet, it uses your unwithdrawn earnings.
712        * -functionhash- 0x349cdcac (using ID for affiliate)
713        * -functionhash- 0x82bfc739 (using address for affiliate)
714        * -functionhash- 0x079ce327 (using name for affiliate)
715        * @param _affCode the ID/address/name of the player who gets the affiliate fee
716        * @param _team what team is the player playing for?
717        * @param _eth amount of earnings to use (remainder returned to gen vault)
718        */
719       function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
720           isActivated()
721           isHuman()
722           isWithinLimits(_eth)
723           public
724       {
725           // set up our tx event data
726           F3Ddatasets.EventReturns memory _eventData_;
727 
728           // fetch player ID
729           uint256 _pID = pIDxAddr_[msg.sender];
730 
731           // manage affiliate residuals
732           // if no affiliate code was given or player tried to use their own, lolz
733           if (_affCode == 0 || _affCode == _pID)
734           {
735               // use last stored affiliate code
736               _affCode = plyr_[_pID].laff;
737 
738           // if affiliate code was given & its not the same as previously stored
739           } else if (_affCode != plyr_[_pID].laff) {
740               // update last affiliate
741               plyr_[_pID].laff = _affCode;
742           }
743 
744           // verify a valid team was selected
745           _team = verifyTeam(_team);
746 
747           // reload core
748           reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
749       }
750 
751       function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
752           isActivated()
753           isHuman()
754           isWithinLimits(_eth)
755           public
756       {
757           // set up our tx event data
758           F3Ddatasets.EventReturns memory _eventData_;
759 
760           // fetch player ID
761           uint256 _pID = pIDxAddr_[msg.sender];
762 
763           // manage affiliate residuals
764           uint256 _affID;
765           // if no affiliate code was given or player tried to use their own, lolz
766           if (_affCode == address(0) || _affCode == msg.sender)
767           {
768               // use last stored affiliate code
769               _affID = plyr_[_pID].laff;
770 
771           // if affiliate code was given
772           } else {
773               // get affiliate ID from aff Code
774               _affID = pIDxAddr_[_affCode];
775 
776               // if affID is not the same as previously stored
777               if (_affID != plyr_[_pID].laff)
778               {
779                   // update last affiliate
780                   plyr_[_pID].laff = _affID;
781               }
782           }
783 
784           // verify a valid team was selected
785           _team = verifyTeam(_team);
786 
787           // reload core
788           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
789       }
790 
791       function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
792           isActivated()
793           isHuman()
794           isWithinLimits(_eth)
795           public
796       {
797           // set up our tx event data
798           F3Ddatasets.EventReturns memory _eventData_;
799 
800           // fetch player ID
801           uint256 _pID = pIDxAddr_[msg.sender];
802 
803           // manage affiliate residuals
804           uint256 _affID;
805           // if no affiliate code was given or player tried to use their own, lolz
806           if (_affCode == '' || _affCode == plyr_[_pID].name)
807           {
808               // use last stored affiliate code
809               _affID = plyr_[_pID].laff;
810 
811           // if affiliate code was given
812           } else {
813               // get affiliate ID from aff Code
814               _affID = pIDxName_[_affCode];
815 
816               // if affID is not the same as previously stored
817               if (_affID != plyr_[_pID].laff)
818               {
819                   // update last affiliate
820                   plyr_[_pID].laff = _affID;
821               }
822           }
823 
824           // verify a valid team was selected
825           _team = verifyTeam(_team);
826 
827           // reload core
828           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
829       }
830 
831       /**
832        * @dev withdraws all of your earnings.
833        * -functionhash- 0x3ccfd60b
834        */
835       function withdraw()
836           isActivated()
837           isHuman()
838           public
839       {
840           // setup local rID
841           uint256 _rID = rID_;
842 
843           // grab time
844           uint256 _now = now;
845 
846           // fetch player ID
847           uint256 _pID = pIDxAddr_[msg.sender];
848 
849           // setup temp var for player eth
850           uint256 _eth;
851 
852           // check to see if round has ended and no one has run round end yet
853           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
854           {
855               // set up our tx event data
856               F3Ddatasets.EventReturns memory _eventData_;
857 
858               // end the round (distributes pot)
859   			round_[_rID].ended = true;
860               _eventData_ = endRound(_eventData_);
861 
862   			// get their earnings
863               _eth = withdrawEarnings(_pID);
864 
865               // gib moni
866               if (_eth > 0)
867                   plyr_[_pID].addr.transfer(_eth);
868 
869               // build event data
870               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
871               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
872 
873               // fire withdraw and distribute event
874               emit F3Devents.onWithdrawAndDistribute
875               (
876                   msg.sender,
877                   plyr_[_pID].name,
878                   _eth,
879                   _eventData_.compressedData,
880                   _eventData_.compressedIDs,
881                   _eventData_.winnerAddr,
882                   _eventData_.winnerName,
883                   _eventData_.amountWon,
884                   _eventData_.newPot,
885                   _eventData_.P3DAmount,
886                   _eventData_.genAmount
887               );
888 
889           // in any other situation
890           } else {
891               // get their earnings
892               _eth = withdrawEarnings(_pID);
893 
894               // gib moni
895               if (_eth > 0)
896                   plyr_[_pID].addr.transfer(_eth);
897 
898               // fire withdraw event
899               emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
900           }
901       }
902 
903     /**
904     * @dev withdraws all of your earnings.
905     * -functionhash- 0x3ccfd60b
906     */
907     function withdrawQR(address _realSender)
908         isActivated()
909         payable
910         public
911     {
912         // setup local rID
913         uint256 _rID = rID_;
914 
915         // grab time
916         uint256 _now = now;
917 
918         // fetch player ID
919         uint256 _pID = pIDxAddr_[_realSender];
920 
921         // setup temp var for player eth
922         uint256 _eth;
923 
924         // check to see if round has ended and no one has run round end yet
925         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
926         {
927             // set up our tx event data
928             F3Ddatasets.EventReturns memory _eventData_;
929 
930             // end the round (distributes pot)
931             round_[_rID].ended = true;
932             _eventData_ = endRound(_eventData_);
933 
934             // get their earnings
935             _eth = withdrawEarnings(_pID);
936 
937             // gib moni
938             if (_eth > 0)
939                 plyr_[_pID].addr.transfer(_eth);
940 
941             // build event data
942             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
943             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
944 
945             // fire withdraw and distribute event
946             emit F3Devents.onWithdrawAndDistribute
947             (
948                 _realSender,
949                 plyr_[_pID].name,
950                 _eth,
951                 _eventData_.compressedData,
952                 _eventData_.compressedIDs,
953                 _eventData_.winnerAddr,
954                 _eventData_.winnerName,
955                 _eventData_.amountWon,
956                 _eventData_.newPot,
957                 _eventData_.P3DAmount,
958                 _eventData_.genAmount
959             );
960 
961         // in any other situation
962         } else {
963             // get their earnings
964             _eth = withdrawEarnings(_pID);
965 
966             // gib moni
967             if (_eth > 0)
968                 plyr_[_pID].addr.transfer(_eth);
969 
970             // fire withdraw event
971             emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
972         }
973     }
974 
975 
976     //==============================================================================
977     //     _  _ _|__|_ _  _ _  .
978     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
979     //=====_|=======================================================================
980     /**
981     * @dev return the price buyer will pay for next 1 individual key.
982     * -functionhash- 0x018a25e8
983     * @return price for next key bought (in wei format)
984     */
985     function getBuyPrice()
986         public
987         view
988         returns(uint256)
989     {
990         // setup local rID
991         uint256 _rID = rID_;
992 
993         // grab time
994         uint256 _now = now;
995 
996         // are we in a round?
997         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
998             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
999         else // rounds over.  need price for new round
1000             return ( 75000000000000 ); // init
1001     }
1002 
1003     /**
1004     * @dev returns time left.  dont spam this, you'll ddos yourself from your node
1005     * provider
1006     * -functionhash- 0xc7e284b8
1007     * @return time left in seconds
1008     */
1009     function getTimeLeft()
1010         public
1011         view
1012         returns(uint256)
1013     {
1014         // setup local rID
1015         uint256 _rID = rID_;
1016 
1017         // grab time
1018         uint256 _now = now;
1019 
1020         if (_now < round_[_rID].end)
1021             if (_now > round_[_rID].strt + rndGap_)
1022                 return( (round_[_rID].end).sub(_now) );
1023             else
1024                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1025         else
1026             return(0);
1027     }
1028 
1029     /**
1030     * @dev returns player earnings per vaults
1031     * -functionhash- 0x63066434
1032     * @return winnings vault
1033     * @return general vault
1034     * @return affiliate vault
1035     */
1036     function getPlayerVaults(uint256 _pID)
1037         public
1038         view
1039         returns(uint256 ,uint256, uint256)
1040     {
1041         // setup local rID
1042         uint256 _rID = rID_;
1043 
1044         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1045         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1046         {
1047             // if player is winner
1048             if (round_[_rID].plyr == _pID)
1049             {
1050                 return
1051                 (
1052                     (plyr_[_pID].win).add(((round_[_rID].pot))),
1053                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1054                     plyr_[_pID].aff
1055                 );
1056             // if player is not the winner
1057             } else {
1058                 return
1059                 (
1060                     plyr_[_pID].win,
1061                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1062                     plyr_[_pID].aff
1063                 );
1064             }
1065 
1066         // if round is still going on, or round has ended and round end has been ran
1067         } else {
1068             return
1069             (
1070                 plyr_[_pID].win,
1071                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1072                 plyr_[_pID].aff
1073             );
1074         }
1075     }
1076 
1077     /**
1078     * solidity hates stack limits.  this lets us avoid that hate
1079     */
1080     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1081         private
1082         view
1083         returns(uint256)
1084     {
1085         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1086     }
1087 
1088     /**
1089     * @dev returns all current round info needed for front end
1090     * -functionhash- 0x747dff42
1091     * @return eth invested during ICO phase
1092     * @return round id
1093     * @return total keys for round
1094     * @return time round ends
1095     * @return time round started
1096     * @return current pot
1097     * @return current team ID & player ID in lead
1098     * @return current player in leads address
1099     * @return current player in leads name
1100     * @return whales eth in for round
1101     * @return bears eth in for round
1102     * @return sneks eth in for round
1103     * @return bulls eth in for round
1104     * @return airdrop tracker # & airdrop pot
1105     */
1106     function getCurrentRoundInfo()
1107         public
1108         view
1109         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1110     {
1111         // setup local rID
1112         uint256 _rID = rID_;
1113 
1114         return
1115         (
1116             round_[_rID].ico,               //0
1117             _rID,                           //1
1118             round_[_rID].keys,              //2
1119             round_[_rID].end,               //3
1120             round_[_rID].strt,              //4
1121             round_[_rID].pot,               //5
1122             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1123             plyr_[round_[_rID].plyr].addr,  //7
1124             plyr_[round_[_rID].plyr].name,  //8
1125             rndTmEth_[_rID][0],             //9
1126             rndTmEth_[_rID][1],             //10
1127             rndTmEth_[_rID][2],             //11
1128             rndTmEth_[_rID][3],             //12
1129             airDropTracker_ + (airDropPot_ * 1000)              //13
1130         );
1131     }
1132 
1133     /**
1134     * @dev returns player info based on address.  if no address is given, it will
1135     * use msg.sender
1136     * -functionhash- 0xee0b5d8b
1137     * @param _addr address of the player you want to lookup
1138     * @return player ID
1139     * @return player name
1140     * @return keys owned (current round)
1141     * @return winnings vault
1142     * @return general vault
1143     * @return affiliate vault
1144     * @return player round eth
1145     */
1146     function getPlayerInfoByAddress(address _addr)
1147         public
1148         view
1149         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1150     {
1151         // setup local rID
1152         uint256 _rID = rID_;
1153 
1154         if (_addr == address(0))
1155         {
1156             _addr == msg.sender;
1157         }
1158         uint256 _pID = pIDxAddr_[_addr];
1159 
1160         return
1161         (
1162             _pID,                               //0
1163             plyr_[_pID].name,                   //1
1164             plyrRnds_[_pID][_rID].keys,         //2
1165             plyr_[_pID].win,                    //3
1166             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1167             plyr_[_pID].aff,                    //5
1168             plyrRnds_[_pID][_rID].eth           //6
1169         );
1170     }
1171 
1172     //==============================================================================
1173     //     _ _  _ _   | _  _ . _  .
1174     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1175     //=====================_|=======================================================
1176     /**
1177     * @dev logic runs whenever a buy order is executed.  determines how to handle
1178     * incoming eth depending on if we are in an active round or not
1179     */
1180     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1181         private
1182     {
1183         // setup local rID
1184         uint256 _rID = rID_;
1185 
1186         // grab time
1187         uint256 _now = now;
1188 
1189         // if round is active
1190         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1191         {
1192             // call core
1193             core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
1194 
1195         // if round is not active
1196         } else {
1197             // check to see if end round needs to be ran
1198             if (_now > round_[_rID].end && round_[_rID].ended == false)
1199             {
1200                 // end the round (distributes pot) & start new round
1201                 round_[_rID].ended = true;
1202                 _eventData_ = endRound(_eventData_);
1203 
1204                 // build event data
1205                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1206                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1207 
1208                 // fire buy and distribute event
1209                 emit F3Devents.onBuyAndDistribute
1210                 (
1211                     msg.sender,
1212                     plyr_[_pID].name,
1213                     msg.value,
1214                     _eventData_.compressedData,
1215                     _eventData_.compressedIDs,
1216                     _eventData_.winnerAddr,
1217                     _eventData_.winnerName,
1218                     _eventData_.amountWon,
1219                     _eventData_.newPot,
1220                     _eventData_.P3DAmount,
1221                     _eventData_.genAmount
1222                 );
1223             }
1224 
1225             // put eth in players vault
1226             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1227         }
1228     }
1229 
1230     /**
1231     * @dev logic runs whenever a buy order is executed.  determines how to handle
1232     * incoming eth depending on if we are in an active round or not
1233     */
1234     function buyCoreQR(address _realSender,uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1235         private
1236     {
1237         // setup local rID
1238         uint256 _rID = rID_;
1239 
1240         // grab time
1241         uint256 _now = now;
1242 
1243         // if round is active
1244         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1245         {
1246             // call core
1247             core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1248 
1249         // if round is not active
1250         } else {
1251             // check to see if end round needs to be ran
1252             if (_now > round_[_rID].end && round_[_rID].ended == false)
1253             {
1254                 // end the round (distributes pot) & start new round
1255                 round_[_rID].ended = true;
1256                 _eventData_ = endRound(_eventData_);
1257 
1258                 // build event data
1259                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1260                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1261 
1262                 // fire buy and distribute event
1263                 emit F3Devents.onBuyAndDistribute
1264                 (
1265                     _realSender,
1266                     plyr_[_pID].name,
1267                     msg.value,
1268                     _eventData_.compressedData,
1269                     _eventData_.compressedIDs,
1270                     _eventData_.winnerAddr,
1271                     _eventData_.winnerName,
1272                     _eventData_.amountWon,
1273                     _eventData_.newPot,
1274                     _eventData_.P3DAmount,
1275                     _eventData_.genAmount
1276                 );
1277             }
1278 
1279             // put eth in players vault
1280             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1281         }
1282     }
1283 
1284       /**
1285        * @dev logic runs whenever a reload order is executed.  determines how to handle
1286        * incoming eth depending on if we are in an active round or not
1287        */
1288       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1289           private
1290       {
1291           // setup local rID
1292           uint256 _rID = rID_;
1293 
1294           // grab time
1295           uint256 _now = now;
1296 
1297           // if round is active
1298           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1299           {
1300               // get earnings from all vaults and return unused to gen vault
1301               // because we use a custom safemath library.  this will throw if player
1302               // tried to spend more eth than they have.
1303               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1304 
1305               // call core
1306               core(address(0), _rID, _pID, _eth, _affID, _team, _eventData_);
1307 
1308           // if round is not active and end round needs to be ran
1309           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1310               // end the round (distributes pot) & start new round
1311               round_[_rID].ended = true;
1312               _eventData_ = endRound(_eventData_);
1313 
1314               // build event data
1315               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1316               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1317 
1318               // fire buy and distribute event
1319               emit F3Devents.onReLoadAndDistribute
1320               (
1321                   msg.sender,
1322                   plyr_[_pID].name,
1323                   _eventData_.compressedData,
1324                   _eventData_.compressedIDs,
1325                   _eventData_.winnerAddr,
1326                   _eventData_.winnerName,
1327                   _eventData_.amountWon,
1328                   _eventData_.newPot,
1329                   _eventData_.P3DAmount,
1330                   _eventData_.genAmount
1331               );
1332           }
1333       }
1334 
1335     /**
1336     * @dev this is the core logic for any buy/reload that happens while a round
1337     * is live.
1338     */
1339     function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1340         private
1341     {
1342         // if player is new to round
1343         if (plyrRnds_[_pID][_rID].keys == 0)
1344             _eventData_ = managePlayer(_pID, _eventData_);
1345 
1346         // early round eth limiter
1347         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1348         {
1349             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1350             uint256 _refund = _eth.sub(_availableLimit);
1351             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1352             _eth = _availableLimit;
1353         }
1354 
1355         // if eth left is greater than min eth allowed (sorry no pocket lint)
1356         if (_eth > 1000000000)
1357         {
1358 
1359             // mint the new keys
1360             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1361 
1362             // if they bought at least 1 whole key
1363             if (_keys >= 1000000000000000000)
1364             {
1365                 updateTimer(_keys, _rID);
1366 
1367                 // set new leaders
1368                 if (round_[_rID].plyr != _pID)
1369                     round_[_rID].plyr = _pID;
1370                 if (round_[_rID].team != _team)
1371                     round_[_rID].team = _team;
1372 
1373                 // set the new leader bool to true
1374                 _eventData_.compressedData = _eventData_.compressedData + 100;
1375             }
1376 
1377             // update player
1378             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1379             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1380 
1381             // update round
1382             round_[_rID].keys = _keys.add(round_[_rID].keys);
1383             round_[_rID].eth = _eth.add(round_[_rID].eth);
1384             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1385 
1386             // distribute eth
1387             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1388             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1389 
1390             // call end tx function to fire end tx event.
1391             endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1392         }
1393     }
1394 
1395 
1396   //==============================================================================
1397   //     _ _ | _   | _ _|_ _  _ _  .
1398   //    (_(_||(_|_||(_| | (_)| _\  .
1399   //==============================================================================
1400       /**
1401        * @dev calculates unmasked earnings (just calculates, does not update mask)
1402        * @return earnings in wei format
1403        */
1404       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1405           private
1406           view
1407           returns(uint256)
1408       {
1409           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1410       }
1411 
1412       /**
1413        * @dev returns the amount of keys you would get given an amount of eth.
1414        * -functionhash- 0xce89c80c
1415        * @param _rID round ID you want price for
1416        * @param _eth amount of eth sent in
1417        * @return keys received
1418        */
1419       function calcKeysReceived(uint256 _rID, uint256 _eth)
1420           public
1421           view
1422           returns(uint256)
1423       {
1424           // grab time
1425           uint256 _now = now;
1426 
1427           // are we in a round?
1428           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1429               return ( (round_[_rID].eth).keysRec(_eth) );
1430           else // rounds over.  need keys for new round
1431               return ( (_eth).keys() );
1432       }
1433 
1434       /**
1435        * @dev returns current eth price for X keys.
1436        * -functionhash- 0xcf808000
1437        * @param _keys number of keys desired (in 18 decimal format)
1438        * @return amount of eth needed to send
1439        */
1440       function iWantXKeys(uint256 _keys)
1441           public
1442           view
1443           returns(uint256)
1444       {
1445           // setup local rID
1446           uint256 _rID = rID_;
1447 
1448           // grab time
1449           uint256 _now = now;
1450 
1451           // are we in a round?
1452           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1453               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1454           else // rounds over.  need price for new round
1455               return ( (_keys).eth() );
1456       }
1457   //==============================================================================
1458   //    _|_ _  _ | _  .
1459   //     | (_)(_)|_\  .
1460   //==============================================================================
1461       /**
1462   	 * @dev receives name/player info from names contract
1463        */
1464       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1465           external
1466       {
1467           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1468           if (pIDxAddr_[_addr] != _pID)
1469               pIDxAddr_[_addr] = _pID;
1470           if (pIDxName_[_name] != _pID)
1471               pIDxName_[_name] = _pID;
1472           if (plyr_[_pID].addr != _addr)
1473               plyr_[_pID].addr = _addr;
1474           if (plyr_[_pID].name != _name)
1475               plyr_[_pID].name = _name;
1476           if (plyr_[_pID].laff != _laff)
1477               plyr_[_pID].laff = _laff;
1478           if (plyrNames_[_pID][_name] == false)
1479               plyrNames_[_pID][_name] = true;
1480       }
1481 
1482       /**
1483        * @dev receives entire player name list
1484        */
1485       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1486           external
1487       {
1488           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1489           if(plyrNames_[_pID][_name] == false)
1490               plyrNames_[_pID][_name] = true;
1491       }
1492 
1493       /**
1494        * @dev gets existing or registers new pID.  use this when a player may be new
1495        * @return pID
1496        */
1497       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1498           private
1499           returns (F3Ddatasets.EventReturns)
1500       {
1501           uint256 _pID = pIDxAddr_[msg.sender];
1502           // if player is new to this version of fomo3d
1503           if (_pID == 0)
1504           {
1505               // grab their player ID, name and last aff ID, from player names contract
1506               _pID = PlayerBook.getPlayerID(msg.sender);
1507               bytes32 _name = PlayerBook.getPlayerName(_pID);
1508               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1509 
1510               // set up player account
1511               pIDxAddr_[msg.sender] = _pID;
1512               plyr_[_pID].addr = msg.sender;
1513 
1514               if (_name != "")
1515               {
1516                   pIDxName_[_name] = _pID;
1517                   plyr_[_pID].name = _name;
1518                   plyrNames_[_pID][_name] = true;
1519               }
1520 
1521               if (_laff != 0 && _laff != _pID)
1522                   plyr_[_pID].laff = _laff;
1523 
1524               // set the new player bool to true
1525               _eventData_.compressedData = _eventData_.compressedData + 1;
1526           }
1527           return (_eventData_);
1528       }
1529 
1530 
1531     /**
1532     * @dev gets existing or registers new pID.  use this when a player may be new
1533     * @return pID
1534     */
1535     function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1536         private
1537         returns (F3Ddatasets.EventReturns)
1538     {
1539         uint256 _pID = pIDxAddr_[_realSender];
1540         // if player is new to this version of fomo3d
1541         if (_pID == 0)
1542         {
1543             // grab their player ID, name and last aff ID, from player names contract
1544             _pID = PlayerBook.getPlayerID(_realSender);
1545             bytes32 _name = PlayerBook.getPlayerName(_pID);
1546             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1547 
1548             // set up player account
1549             pIDxAddr_[_realSender] = _pID;
1550             plyr_[_pID].addr = _realSender;
1551 
1552             if (_name != "")
1553             {
1554                 pIDxName_[_name] = _pID;
1555                 plyr_[_pID].name = _name;
1556                 plyrNames_[_pID][_name] = true;
1557             }
1558 
1559             if (_laff != 0 && _laff != _pID)
1560                 plyr_[_pID].laff = _laff;
1561 
1562             // set the new player bool to true
1563             _eventData_.compressedData = _eventData_.compressedData + 1;
1564         }
1565         return (_eventData_);
1566     }
1567 
1568       /**
1569        * @dev checks to make sure user picked a valid team.  if not sets team
1570        * to default (sneks)
1571        */
1572       function verifyTeam(uint256 _team)
1573           private
1574           pure
1575           returns (uint256)
1576       {
1577           if (_team < 0 || _team > 3)
1578               return(2);
1579           else
1580               return(_team);
1581       }
1582 
1583       /**
1584        * @dev decides if round end needs to be run & new round started.  and if
1585        * player unmasked earnings from previously played rounds need to be moved.
1586        */
1587       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1588           private
1589           returns (F3Ddatasets.EventReturns)
1590       {
1591           // if player has played a previous round, move their unmasked earnings
1592           // from that round to gen vault.
1593           if (plyr_[_pID].lrnd != 0)
1594               updateGenVault(_pID, plyr_[_pID].lrnd);
1595 
1596           // update player's last round played
1597           plyr_[_pID].lrnd = rID_;
1598 
1599           // set the joined round bool to true
1600           _eventData_.compressedData = _eventData_.compressedData + 10;
1601 
1602           return(_eventData_);
1603       }
1604 
1605     /**
1606     * @dev ends the round. manages paying out winner/splitting up pot
1607     */
1608     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1609         private
1610         returns (F3Ddatasets.EventReturns)
1611     {
1612         // setup local rID
1613         uint256 _rID = rID_;
1614 
1615         // grab our winning player and team id's
1616         uint256 _winPID = round_[_rID].plyr;
1617         uint256 _winTID = round_[_rID].team;
1618 
1619         // grab our pot amount
1620         uint256 _pot = round_[_rID].pot;
1621 
1622         // calculate our winner share, community rewards, gen share,
1623         // p3d share, and amount reserved for next pot
1624         uint256 _win = _pot;
1625         uint256 _com = 0;
1626         uint256 _gen = 0;
1627         uint256 _p3d = 0;
1628         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d); // actually 0 eth to the next round
1629 
1630         // calculate ppt for round mask
1631         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1632 
1633         // pay our winner
1634         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1635 
1636         // distribute gen portion to key holders
1637         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1638 
1639         // prepare event data
1640         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1641         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1642         _eventData_.winnerAddr = plyr_[_winPID].addr;
1643         _eventData_.winnerName = plyr_[_winPID].name;
1644         _eventData_.amountWon = _win;
1645         _eventData_.genAmount = _gen;
1646         _eventData_.P3DAmount = _p3d;
1647         _eventData_.newPot = _res;
1648 
1649         // start next round
1650         rID_++;
1651         _rID++;
1652         round_[_rID].strt = now;
1653         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1654         round_[_rID].pot = _res;
1655 
1656         return(_eventData_);
1657     }
1658 
1659     /**
1660     * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1661     */
1662     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1663         private
1664     {
1665         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1666         if (_earnings > 0)
1667         {
1668             // put in gen vault
1669             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1670             // zero out their earnings by updating mask
1671             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1672         }
1673     }
1674 
1675     /**
1676     * @dev updates round timer based on number of whole keys bought.
1677     */
1678     function updateTimer(uint256 _keys, uint256 _rID)
1679         private
1680     {
1681         // grab time
1682         uint256 _now = now;
1683 
1684         // calculate time based on number of keys bought
1685         uint256 _newTime;
1686         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1687             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1688         else
1689             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1690 
1691         // compare to max and set new end time
1692         if (_newTime < (rndMax_).add(_now))
1693             round_[_rID].end = _newTime;
1694         else
1695             round_[_rID].end = rndMax_.add(_now);
1696     }
1697 
1698       /**
1699        * @dev generates a random number between 0-99 and checks to see if thats
1700        * resulted in an airdrop win
1701        * @return do we have a winner?
1702        */
1703       function airdrop()
1704           private
1705           view
1706           returns(bool)
1707       {
1708           uint256 seed = uint256(keccak256(abi.encodePacked(
1709 
1710               (block.timestamp).add
1711               (block.difficulty).add
1712               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1713               (block.gaslimit).add
1714               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1715               (block.number)
1716 
1717           )));
1718           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1719               return(true);
1720           else
1721               return(false);
1722       }
1723 
1724     /**
1725     * @dev distributes eth based on fees to com, aff, and p3d
1726     */
1727     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1728         private
1729         returns(F3Ddatasets.EventReturns)
1730     {
1731         // pay 2% out to developers rewards
1732         uint256 _p3d = _eth / 50;
1733 
1734         // distribute share to running team
1735         uint256 _aff = _eth.mul(8) / 100;
1736 
1737         // distribute 10% to pot
1738         uint256 _potAmount = _eth / 10;
1739 
1740         // decide what to do with affiliate share of fees
1741         // affiliate must not be self, and must have a name registered
1742         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1743         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1744 
1745         // pay out p3d
1746         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1747         if (_p3d > 0)
1748         {
1749             // deposit to divies contract
1750             admin.transfer(_p3d);
1751             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1752             // set up event data
1753             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1754         }
1755         return(_eventData_);
1756     }
1757 
1758     function potSwap()
1759         external
1760         payable
1761     {
1762         // setup local rID
1763         uint256 _rID = rID_ + 1;
1764 
1765         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1766         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1767     }
1768 
1769     /**
1770     * @dev distributes eth based on fees to gen and pot
1771     */
1772     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1773         private
1774         returns(F3Ddatasets.EventReturns)
1775     {
1776         // calculate gen share
1777         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1778 
1779         // calculate pot 10%
1780         uint256 _pot = _eth/10;
1781 
1782         // distribute gen share (thats what updateMasks() does) and adjust
1783         // balances for dust.
1784         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1785         if (_dust > 0)
1786             _gen = _gen.sub(_dust);
1787 
1788         // add eth to pot
1789         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1790 
1791         // set up event data
1792         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1793         _eventData_.potAmount = _pot;
1794 
1795         return(_eventData_);
1796     }
1797 
1798 
1799       /**
1800        * @dev updates masks for round and player when keys are bought
1801        * @return dust left over
1802        */
1803       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1804           private
1805           returns(uint256)
1806       {
1807           /* MASKING NOTES
1808               earnings masks are a tricky thing for people to wrap their minds around.
1809               the basic thing to understand here.  is were going to have a global
1810               tracker based on profit per share for each round, that increases in
1811               relevant proportion to the increase in share supply.
1812 
1813               the player will have an additional mask that basically says "based
1814               on the rounds mask, my shares, and how much i've already withdrawn,
1815               how much is still owed to me?"
1816           */
1817 
1818           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1819           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1820           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1821 
1822           // calculate player earning from their own buy (only based on the keys
1823           // they just bought).  & update player earnings mask
1824           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1825           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1826 
1827           // calculate & return dust
1828           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1829       }
1830 
1831     /**
1832     * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1833     * @return earnings in wei format
1834     */
1835     function withdrawEarnings(uint256 _pID)
1836         private
1837         returns(uint256)
1838     {
1839         // update gen vault
1840         updateGenVault(_pID, plyr_[_pID].lrnd);
1841 
1842         // from vaults
1843         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1844         if (_earnings > 0)
1845         {
1846             plyr_[_pID].win = 0;
1847             plyr_[_pID].gen = 0;
1848             plyr_[_pID].aff = 0;
1849         }
1850 
1851         return(_earnings);
1852     }
1853 
1854     /**
1855     * @dev prepares compression data and fires event for buy or reload tx's
1856     */
1857     function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1858         private
1859     {
1860         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1861         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1862 
1863         emit F3Devents.onEndTx
1864         (
1865             _eventData_.compressedData,
1866             _eventData_.compressedIDs,
1867             plyr_[_pID].name,
1868             _realSender,
1869             _eth,
1870             _keys,
1871             _eventData_.winnerAddr,
1872             _eventData_.winnerName,
1873             _eventData_.amountWon,
1874             _eventData_.newPot,
1875             _eventData_.P3DAmount,
1876             _eventData_.genAmount,
1877             _eventData_.potAmount,
1878             airDropPot_
1879         );
1880     }
1881 
1882   //==============================================================================
1883   //    (~ _  _    _._|_    .
1884   //    _)(/_(_|_|| | | \/  .
1885   //====================/=========================================================
1886       /** upon contract deploy, it will be deactivated.  this is a one time
1887        * use function that will activate the contract.  we do this so devs
1888        * have time to set things up on the web end                            **/
1889       bool public activated_ = false;
1890       function activate()
1891           public
1892       {
1893           // only team just can activate
1894           require(msg.sender == admin, "only admin can activate");
1895 
1896 
1897           // can only be ran once
1898           require(activated_ == false, "FOMO Short already activated");
1899 
1900           // activate the contract
1901           activated_ = true;
1902 
1903           // lets start first round
1904           rID_ = 1;
1905               round_[1].strt = now + rndExtra_ - rndGap_;
1906               round_[1].end = now + rndInit_ + rndExtra_;
1907       }
1908   }