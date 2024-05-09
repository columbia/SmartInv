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
439 
440 interface PlayerBookInterface {
441     function getPlayerID(address _addr) external returns (uint256);
442     function getPlayerName(uint256 _pID) external view returns (bytes32);
443     function getPlayerLAff(uint256 _pID) external view returns (uint256);
444     function getPlayerAddr(uint256 _pID) external view returns (address);
445     function getNameFee() external view returns (uint256);
446     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
447     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
448     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
449 }
450 
451 
452 
453 contract modularFast is F3Devents {}
454 
455 
456 contract FoMo3DFast is modularFast {
457     using SafeMath for *;
458     using NameFilter for string;
459     using F3DKeysCalcShort for uint256;
460 
461     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x83fe7cBb33c1927D5B8201f829562ee435819039);
462 
463     address private admin = msg.sender;
464     string constant public name = "OTION";
465     string constant public symbol = "OTION";
466     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
467     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
468     uint256 constant private rndInit_ = 88 minutes;                // round timer starts at this
469     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
470     uint256 constant private rndMax_ = 888 minutes;                // max length a round timer can be
471     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
472     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
473     uint256 public rID_;    // round id number / total rounds that have happened
474     //****************
475     // PLAYER DATA
476     //****************
477     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
478     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
479     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
480     // (pID => rID => data) player round data by player id & round id
481     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
482     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
483     //****************
484     // ROUND DATA
485     //****************
486     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
487     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
488     //****************
489     // TEAM FEE DATA
490     //****************
491     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
492     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
493 
494     constructor()
495         public
496     {
497     // Team allocation structures
498         // 0 = the only team
499         
500     // Team allocation percentages
501         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
502             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
503         fees_[0] = F3Ddatasets.TeamFee(80,0);   //10% to pot, 8% to aff, 2% to com
504 
505         // how to split up the final pot based on which team was picked
506         // (F3D, P3D)
507         potSplit_[0] = F3Ddatasets.PotSplit(0,0);  //100% to winner
508     }
509     //==============================================================================
510     //     _ _  _  _|. |`. _  _ _  .
511     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
512     //==============================================================================
513     /**
514     * @dev used to make sure no one can interact with contract until it has
515     * been activated.
516     */
517     modifier isActivated() {
518         require(activated_ == true, "its not ready yet.  check ?eta in discord");
519         _;
520     }
521 
522     /**
523     * @dev prevents contracts from interacting with fomo3d
524     */
525     modifier isHuman() {
526         address _addr = msg.sender;
527         uint256 _codeLength;
528 
529         assembly {_codeLength := extcodesize(_addr)}
530         require(_codeLength == 0, "sorry humans only");
531         _;
532     }
533 
534     /**
535     * @dev sets boundaries for incoming tx
536     */
537     modifier isWithinLimits(uint256 _eth) {
538         require(_eth >= 1000000000, "pocket lint: not a valid currency");
539         _;
540     }
541 
542     //==============================================================================
543     //     _    |_ |. _   |`    _  __|_. _  _  _  .
544     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
545     //====|=========================================================================
546     /**
547     * @dev emergency buy uses last stored affiliate ID and team snek
548     */
549     function()
550         isActivated()
551         isHuman()
552         isWithinLimits(msg.value)
553         public
554         payable
555     {
556         // set up our tx event data and determine if player is new or not
557         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
558 
559         // fetch player id
560         uint256 _pID = pIDxAddr_[msg.sender];
561 
562         // buy core
563         buyCore(_pID, plyr_[1].laff, 0, _eventData_);
564     }
565 
566       /**
567        * @dev converts all incoming ethereum to keys.
568        * -functionhash- 0x8f38f309 (using ID for affiliate)
569        * -functionhash- 0x98a0871d (using address for affiliate)
570        * -functionhash- 0xa65b37a1 (using name for affiliate)
571        * @param _affCode the ID/address/name of the player who gets the affiliate fee
572        * @param _team what team is the player playing for?
573        */
574       function buyXid(uint256 _affCode, uint256 _team)
575           isActivated()
576           isHuman()
577           isWithinLimits(msg.value)
578           public
579           payable
580       {
581           // set up our tx event data and determine if player is new or not
582           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
583 
584           // fetch player id
585           uint256 _pID = pIDxAddr_[msg.sender];
586 
587           // manage affiliate residuals
588           // if no affiliate code was given or player tried to use their own, lolz
589           if (_affCode == 0 || _affCode == _pID)
590           {
591               // use last stored affiliate code
592               _affCode = plyr_[_pID].laff;
593 
594           // if affiliate code was given & its not the same as previously stored
595           } else if (_affCode != plyr_[_pID].laff) {
596               // update last affiliate
597               plyr_[_pID].laff = _affCode;
598           }
599 
600           // verify a valid team was selected
601           _team = verifyTeam(_team);
602 
603           // buy core
604           buyCore(_pID, _affCode, _team, _eventData_);
605       }
606 
607       function buyXaddr(address _affCode, uint256 _team)
608           isActivated()
609           isWithinLimits(msg.value)
610           public
611           payable
612       {
613           // set up our tx event data and determine if player is new or not
614           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
615 
616           // fetch player id
617           uint256 _pID = pIDxAddr_[msg.sender];
618 
619           // manage affiliate residuals
620           uint256 _affID;
621           // if no affiliate code was given or player tried to use their own, lolz
622           if (_affCode == address(0) || _affCode == msg.sender)
623           {
624               // use last stored affiliate code
625               _affID = plyr_[_pID].laff;
626 
627           // if affiliate code was given
628           } else {
629               // get affiliate ID from aff Code
630               _affID = pIDxAddr_[_affCode];
631 
632               // if affID is not the same as previously stored
633               if (_affID != plyr_[_pID].laff)
634               {
635                   // update last affiliate
636                   plyr_[_pID].laff = _affID;
637               }
638           }
639 
640           // verify a valid team was selected
641           _team = verifyTeam(_team);
642 
643           // buy core
644           buyCore(_pID, _affID, _team, _eventData_);
645       }
646 
647       function buyXname(bytes32 _affCode, uint256 _team)
648           isActivated()
649           isHuman()
650           isWithinLimits(msg.value)
651           public
652           payable
653       {
654           // set up our tx event data and determine if player is new or not
655           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
656 
657           // fetch player id
658           uint256 _pID = pIDxAddr_[msg.sender];
659 
660           // manage affiliate residuals
661           uint256 _affID;
662           // if no affiliate code was given or player tried to use their own, lolz
663           if (_affCode == '' || _affCode == plyr_[_pID].name)
664           {
665               // use last stored affiliate code
666               _affID = plyr_[_pID].laff;
667 
668           // if affiliate code was given
669           } else {
670               // get affiliate ID from aff Code
671               _affID = pIDxName_[_affCode];
672 
673               // if affID is not the same as previously stored
674               if (_affID != plyr_[_pID].laff)
675               {
676                   // update last affiliate
677                   plyr_[_pID].laff = _affID;
678               }
679           }
680 
681           // verify a valid team was selected
682           _team = verifyTeam(_team);
683 
684           // buy core
685           buyCore(_pID, _affID, _team, _eventData_);
686       }
687 
688 
689     function buyXnameQR(address _realSender, uint256 _team)
690         isActivated()
691         isWithinLimits(msg.value)
692         public
693         payable
694     {
695         // set up our tx event data and determine if player is new or not
696         F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
697 
698         // fetch player id
699         uint256 _pID = pIDxAddr_[_realSender];
700 
701         // manage affiliate residuals
702         uint256 _affID = 1;
703         
704         // verify a valid team was selected
705         _team = 0;
706 
707         // buy core
708         buyCoreQR(_realSender, _pID, _affID, _team, _eventData_);
709     }
710 
711       /**
712        * @dev essentially the same as buy, but instead of you sending ether
713        * from your wallet, it uses your unwithdrawn earnings.
714        * -functionhash- 0x349cdcac (using ID for affiliate)
715        * -functionhash- 0x82bfc739 (using address for affiliate)
716        * -functionhash- 0x079ce327 (using name for affiliate)
717        * @param _affCode the ID/address/name of the player who gets the affiliate fee
718        * @param _team what team is the player playing for?
719        * @param _eth amount of earnings to use (remainder returned to gen vault)
720        */
721       function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
722           isActivated()
723           isHuman()
724           isWithinLimits(_eth)
725           public
726       {
727           // set up our tx event data
728           F3Ddatasets.EventReturns memory _eventData_;
729 
730           // fetch player ID
731           uint256 _pID = pIDxAddr_[msg.sender];
732 
733           // manage affiliate residuals
734           // if no affiliate code was given or player tried to use their own, lolz
735           if (_affCode == 0 || _affCode == _pID)
736           {
737               // use last stored affiliate code
738               _affCode = plyr_[_pID].laff;
739 
740           // if affiliate code was given & its not the same as previously stored
741           } else if (_affCode != plyr_[_pID].laff) {
742               // update last affiliate
743               plyr_[_pID].laff = _affCode;
744           }
745 
746           // verify a valid team was selected
747           _team = verifyTeam(_team);
748 
749           // reload core
750           reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
751       }
752 
753       function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
754           isActivated()
755           isHuman()
756           isWithinLimits(_eth)
757           public
758       {
759           // set up our tx event data
760           F3Ddatasets.EventReturns memory _eventData_;
761 
762           // fetch player ID
763           uint256 _pID = pIDxAddr_[msg.sender];
764 
765           // manage affiliate residuals
766           uint256 _affID;
767           // if no affiliate code was given or player tried to use their own, lolz
768           if (_affCode == address(0) || _affCode == msg.sender)
769           {
770               // use last stored affiliate code
771               _affID = plyr_[_pID].laff;
772 
773           // if affiliate code was given
774           } else {
775               // get affiliate ID from aff Code
776               _affID = pIDxAddr_[_affCode];
777 
778               // if affID is not the same as previously stored
779               if (_affID != plyr_[_pID].laff)
780               {
781                   // update last affiliate
782                   plyr_[_pID].laff = _affID;
783               }
784           }
785 
786           // verify a valid team was selected
787           _team = verifyTeam(_team);
788 
789           // reload core
790           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
791       }
792 
793       function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
794           isActivated()
795           isHuman()
796           isWithinLimits(_eth)
797           public
798       {
799           // set up our tx event data
800           F3Ddatasets.EventReturns memory _eventData_;
801 
802           // fetch player ID
803           uint256 _pID = pIDxAddr_[msg.sender];
804 
805           // manage affiliate residuals
806           uint256 _affID;
807           // if no affiliate code was given or player tried to use their own, lolz
808           if (_affCode == '' || _affCode == plyr_[_pID].name)
809           {
810               // use last stored affiliate code
811               _affID = plyr_[_pID].laff;
812 
813           // if affiliate code was given
814           } else {
815               // get affiliate ID from aff Code
816               _affID = pIDxName_[_affCode];
817 
818               // if affID is not the same as previously stored
819               if (_affID != plyr_[_pID].laff)
820               {
821                   // update last affiliate
822                   plyr_[_pID].laff = _affID;
823               }
824           }
825 
826           // verify a valid team was selected
827           _team = verifyTeam(_team);
828 
829           // reload core
830           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
831       }
832 
833       /**
834        * @dev withdraws all of your earnings.
835        * -functionhash- 0x3ccfd60b
836        */
837       function withdraw()
838           isActivated()
839           isHuman()
840           public
841       {
842           // setup local rID
843           uint256 _rID = rID_;
844 
845           // grab time
846           uint256 _now = now;
847 
848           // fetch player ID
849           uint256 _pID = pIDxAddr_[msg.sender];
850 
851           // setup temp var for player eth
852           uint256 _eth;
853 
854           // check to see if round has ended and no one has run round end yet
855           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
856           {
857               // set up our tx event data
858               F3Ddatasets.EventReturns memory _eventData_;
859 
860               // end the round (distributes pot)
861   			round_[_rID].ended = true;
862               _eventData_ = endRound(_eventData_);
863 
864   			// get their earnings
865               _eth = withdrawEarnings(_pID);
866 
867               // gib moni
868               if (_eth > 0)
869                   plyr_[_pID].addr.transfer(_eth);
870 
871               // build event data
872               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
873               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
874 
875               // fire withdraw and distribute event
876               emit F3Devents.onWithdrawAndDistribute
877               (
878                   msg.sender,
879                   plyr_[_pID].name,
880                   _eth,
881                   _eventData_.compressedData,
882                   _eventData_.compressedIDs,
883                   _eventData_.winnerAddr,
884                   _eventData_.winnerName,
885                   _eventData_.amountWon,
886                   _eventData_.newPot,
887                   _eventData_.P3DAmount,
888                   _eventData_.genAmount
889               );
890 
891           // in any other situation
892           } else {
893               // get their earnings
894               _eth = withdrawEarnings(_pID);
895 
896               // gib moni
897               if (_eth > 0)
898                   plyr_[_pID].addr.transfer(_eth);
899 
900               // fire withdraw event
901               emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
902           }
903       }
904 
905     /**
906     * @dev withdraws all of your earnings.
907     * -functionhash- 0x3ccfd60b
908     */
909     function withdrawQR(address _realSender)
910         isActivated()
911         payable
912         public
913     {
914         // setup local rID
915         uint256 _rID = rID_;
916 
917         // grab time
918         uint256 _now = now;
919 
920         // fetch player ID
921         uint256 _pID = pIDxAddr_[_realSender];
922 
923         // setup temp var for player eth
924         uint256 _eth;
925 
926         // check to see if round has ended and no one has run round end yet
927         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
928         {
929             // set up our tx event data
930             F3Ddatasets.EventReturns memory _eventData_;
931 
932             // end the round (distributes pot)
933             round_[_rID].ended = true;
934             _eventData_ = endRound(_eventData_);
935 
936             // get their earnings
937             _eth = withdrawEarnings(_pID);
938 
939             // gib moni
940             if (_eth > 0)
941                 plyr_[_pID].addr.transfer(_eth);
942 
943             // build event data
944             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
945             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
946 
947             // fire withdraw and distribute event
948             emit F3Devents.onWithdrawAndDistribute
949             (
950                 _realSender,
951                 plyr_[_pID].name,
952                 _eth,
953                 _eventData_.compressedData,
954                 _eventData_.compressedIDs,
955                 _eventData_.winnerAddr,
956                 _eventData_.winnerName,
957                 _eventData_.amountWon,
958                 _eventData_.newPot,
959                 _eventData_.P3DAmount,
960                 _eventData_.genAmount
961             );
962 
963         // in any other situation
964         } else {
965             // get their earnings
966             _eth = withdrawEarnings(_pID);
967 
968             // gib moni
969             if (_eth > 0)
970                 plyr_[_pID].addr.transfer(_eth);
971 
972             // fire withdraw event
973             emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
974         }
975     }
976 
977 
978     //==============================================================================
979     //     _  _ _|__|_ _  _ _  .
980     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
981     //=====_|=======================================================================
982     /**
983     * @dev return the price buyer will pay for next 1 individual key.
984     * -functionhash- 0x018a25e8
985     * @return price for next key bought (in wei format)
986     */
987     function getBuyPrice()
988         public
989         view
990         returns(uint256)
991     {
992         // setup local rID
993         uint256 _rID = rID_;
994 
995         // grab time
996         uint256 _now = now;
997 
998         // are we in a round?
999         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1000             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1001         else // rounds over.  need price for new round
1002             return ( 75000000000000 ); // init
1003     }
1004 
1005     /**
1006     * @dev returns time left.  dont spam this, you'll ddos yourself from your node
1007     * provider
1008     * -functionhash- 0xc7e284b8
1009     * @return time left in seconds
1010     */
1011     function getTimeLeft()
1012         public
1013         view
1014         returns(uint256)
1015     {
1016         // setup local rID
1017         uint256 _rID = rID_;
1018 
1019         // grab time
1020         uint256 _now = now;
1021 
1022         if (_now < round_[_rID].end)
1023             if (_now > round_[_rID].strt + rndGap_)
1024                 return( (round_[_rID].end).sub(_now) );
1025             else
1026                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1027         else
1028             return(0);
1029     }
1030 
1031     /**
1032     * @dev returns player earnings per vaults
1033     * -functionhash- 0x63066434
1034     * @return winnings vault
1035     * @return general vault
1036     * @return affiliate vault
1037     */
1038     function getPlayerVaults(uint256 _pID)
1039         public
1040         view
1041         returns(uint256 ,uint256, uint256)
1042     {
1043         // setup local rID
1044         uint256 _rID = rID_;
1045 
1046         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1047         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1048         {
1049             // if player is winner
1050             if (round_[_rID].plyr == _pID)
1051             {
1052                 return
1053                 (
1054                     (plyr_[_pID].win).add(((round_[_rID].pot))),
1055                     (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1056                     plyr_[_pID].aff
1057                 );
1058             // if player is not the winner
1059             } else {
1060                 return
1061                 (
1062                     plyr_[_pID].win,
1063                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1064                     plyr_[_pID].aff
1065                 );
1066             }
1067 
1068         // if round is still going on, or round has ended and round end has been ran
1069         } else {
1070             return
1071             (
1072                 plyr_[_pID].win,
1073                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1074                 plyr_[_pID].aff
1075             );
1076         }
1077     }
1078 
1079     /**
1080     * solidity hates stack limits.  this lets us avoid that hate
1081     */
1082     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1083         private
1084         view
1085         returns(uint256)
1086     {
1087         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1088     }
1089 
1090     /**
1091     * @dev returns all current round info needed for front end
1092     * -functionhash- 0x747dff42
1093     * @return eth invested during ICO phase
1094     * @return round id
1095     * @return total keys for round
1096     * @return time round ends
1097     * @return time round started
1098     * @return current pot
1099     * @return current team ID & player ID in lead
1100     * @return current player in leads address
1101     * @return current player in leads name
1102     * @return whales eth in for round
1103     * @return bears eth in for round
1104     * @return sneks eth in for round
1105     * @return bulls eth in for round
1106     * @return airdrop tracker # & airdrop pot
1107     */
1108     function getCurrentRoundInfo()
1109         public
1110         view
1111         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1112     {
1113         // setup local rID
1114         uint256 _rID = rID_;
1115 
1116         return
1117         (
1118             round_[_rID].ico,               //0
1119             _rID,                           //1
1120             round_[_rID].keys,              //2
1121             round_[_rID].end,               //3
1122             round_[_rID].strt,              //4
1123             round_[_rID].pot,               //5
1124             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1125             plyr_[round_[_rID].plyr].addr,  //7
1126             plyr_[round_[_rID].plyr].name,  //8
1127             rndTmEth_[_rID][0],             //9
1128             rndTmEth_[_rID][1],             //10
1129             rndTmEth_[_rID][2],             //11
1130             rndTmEth_[_rID][3],             //12
1131             airDropTracker_ + (airDropPot_ * 1000)              //13
1132         );
1133     }
1134 
1135     /**
1136     * @dev returns player info based on address.  if no address is given, it will
1137     * use msg.sender
1138     * -functionhash- 0xee0b5d8b
1139     * @param _addr address of the player you want to lookup
1140     * @return player ID
1141     * @return player name
1142     * @return keys owned (current round)
1143     * @return winnings vault
1144     * @return general vault
1145     * @return affiliate vault
1146     * @return player round eth
1147     */
1148     function getPlayerInfoByAddress(address _addr)
1149         public
1150         view
1151         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1152     {
1153         // setup local rID
1154         uint256 _rID = rID_;
1155 
1156         if (_addr == address(0))
1157         {
1158             _addr == msg.sender;
1159         }
1160         uint256 _pID = pIDxAddr_[_addr];
1161 
1162         return
1163         (
1164             _pID,                               //0
1165             plyr_[_pID].name,                   //1
1166             plyrRnds_[_pID][_rID].keys,         //2
1167             plyr_[_pID].win,                    //3
1168             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1169             plyr_[_pID].aff,                    //5
1170             plyrRnds_[_pID][_rID].eth           //6
1171         );
1172     }
1173 
1174     //==============================================================================
1175     //     _ _  _ _   | _  _ . _  .
1176     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1177     //=====================_|=======================================================
1178     /**
1179     * @dev logic runs whenever a buy order is executed.  determines how to handle
1180     * incoming eth depending on if we are in an active round or not
1181     */
1182     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1183         private
1184     {
1185         // setup local rID
1186         uint256 _rID = rID_;
1187 
1188         // grab time
1189         uint256 _now = now;
1190 
1191         // if round is active
1192         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1193         {
1194             // call core
1195             core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
1196 
1197         // if round is not active
1198         } else {
1199             // check to see if end round needs to be ran
1200             if (_now > round_[_rID].end && round_[_rID].ended == false)
1201             {
1202                 // end the round (distributes pot) & start new round
1203                 round_[_rID].ended = true;
1204                 _eventData_ = endRound(_eventData_);
1205 
1206                 // build event data
1207                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1208                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1209 
1210                 // fire buy and distribute event
1211                 emit F3Devents.onBuyAndDistribute
1212                 (
1213                     msg.sender,
1214                     plyr_[_pID].name,
1215                     msg.value,
1216                     _eventData_.compressedData,
1217                     _eventData_.compressedIDs,
1218                     _eventData_.winnerAddr,
1219                     _eventData_.winnerName,
1220                     _eventData_.amountWon,
1221                     _eventData_.newPot,
1222                     _eventData_.P3DAmount,
1223                     _eventData_.genAmount
1224                 );
1225             }
1226 
1227             // put eth in players vault
1228             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1229         }
1230     }
1231 
1232     /**
1233     * @dev logic runs whenever a buy order is executed.  determines how to handle
1234     * incoming eth depending on if we are in an active round or not
1235     */
1236     function buyCoreQR(address _realSender,uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1237         private
1238     {
1239         // setup local rID
1240         uint256 _rID = rID_;
1241 
1242         // grab time
1243         uint256 _now = now;
1244 
1245         // if round is active
1246         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1247         {
1248             // call core
1249             core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1250 
1251         // if round is not active
1252         } else {
1253             // check to see if end round needs to be ran
1254             if (_now > round_[_rID].end && round_[_rID].ended == false)
1255             {
1256                 // end the round (distributes pot) & start new round
1257                 round_[_rID].ended = true;
1258                 _eventData_ = endRound(_eventData_);
1259 
1260                 // build event data
1261                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1262                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1263 
1264                 // fire buy and distribute event
1265                 emit F3Devents.onBuyAndDistribute
1266                 (
1267                     _realSender,
1268                     plyr_[_pID].name,
1269                     msg.value,
1270                     _eventData_.compressedData,
1271                     _eventData_.compressedIDs,
1272                     _eventData_.winnerAddr,
1273                     _eventData_.winnerName,
1274                     _eventData_.amountWon,
1275                     _eventData_.newPot,
1276                     _eventData_.P3DAmount,
1277                     _eventData_.genAmount
1278                 );
1279             }
1280 
1281             // put eth in players vault
1282             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1283         }
1284     }
1285 
1286       /**
1287        * @dev logic runs whenever a reload order is executed.  determines how to handle
1288        * incoming eth depending on if we are in an active round or not
1289        */
1290       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1291           private
1292       {
1293           // setup local rID
1294           uint256 _rID = rID_;
1295 
1296           // grab time
1297           uint256 _now = now;
1298 
1299           // if round is active
1300           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1301           {
1302               // get earnings from all vaults and return unused to gen vault
1303               // because we use a custom safemath library.  this will throw if player
1304               // tried to spend more eth than they have.
1305               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1306 
1307               // call core
1308               core(address(0), _rID, _pID, _eth, _affID, _team, _eventData_);
1309 
1310           // if round is not active and end round needs to be ran
1311           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1312               // end the round (distributes pot) & start new round
1313               round_[_rID].ended = true;
1314               _eventData_ = endRound(_eventData_);
1315 
1316               // build event data
1317               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1318               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1319 
1320               // fire buy and distribute event
1321               emit F3Devents.onReLoadAndDistribute
1322               (
1323                   msg.sender,
1324                   plyr_[_pID].name,
1325                   _eventData_.compressedData,
1326                   _eventData_.compressedIDs,
1327                   _eventData_.winnerAddr,
1328                   _eventData_.winnerName,
1329                   _eventData_.amountWon,
1330                   _eventData_.newPot,
1331                   _eventData_.P3DAmount,
1332                   _eventData_.genAmount
1333               );
1334           }
1335       }
1336 
1337     /**
1338     * @dev this is the core logic for any buy/reload that happens while a round
1339     * is live.
1340     */
1341     function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1342         private
1343     {
1344         // if player is new to round
1345         if (plyrRnds_[_pID][_rID].keys == 0)
1346             _eventData_ = managePlayer(_pID, _eventData_);
1347 
1348         // early round eth limiter
1349         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1350         {
1351             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1352             uint256 _refund = _eth.sub(_availableLimit);
1353             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1354             _eth = _availableLimit;
1355         }
1356 
1357         // if eth left is greater than min eth allowed (sorry no pocket lint)
1358         if (_eth > 1000000000)
1359         {
1360 
1361             // mint the new keys
1362             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1363 
1364             // if they bought at least 1 whole key
1365             if (_keys >= 1000000000000000000)
1366             {
1367                 updateTimer(_keys, _rID);
1368 
1369                 // set new leaders
1370                 if (round_[_rID].plyr != _pID)
1371                     round_[_rID].plyr = _pID;
1372                 if (round_[_rID].team != _team)
1373                     round_[_rID].team = _team;
1374 
1375                 // set the new leader bool to true
1376                 _eventData_.compressedData = _eventData_.compressedData + 100;
1377             }
1378 
1379             // update player
1380             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1381             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1382 
1383             // update round
1384             round_[_rID].keys = _keys.add(round_[_rID].keys);
1385             round_[_rID].eth = _eth.add(round_[_rID].eth);
1386             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1387 
1388             // distribute eth
1389             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1390             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1391 
1392             // call end tx function to fire end tx event.
1393             endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1394         }
1395     }
1396 
1397 
1398   //==============================================================================
1399   //     _ _ | _   | _ _|_ _  _ _  .
1400   //    (_(_||(_|_||(_| | (_)| _\  .
1401   //==============================================================================
1402       /**
1403        * @dev calculates unmasked earnings (just calculates, does not update mask)
1404        * @return earnings in wei format
1405        */
1406       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1407           private
1408           view
1409           returns(uint256)
1410       {
1411           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1412       }
1413 
1414       /**
1415        * @dev returns the amount of keys you would get given an amount of eth.
1416        * -functionhash- 0xce89c80c
1417        * @param _rID round ID you want price for
1418        * @param _eth amount of eth sent in
1419        * @return keys received
1420        */
1421       function calcKeysReceived(uint256 _rID, uint256 _eth)
1422           public
1423           view
1424           returns(uint256)
1425       {
1426           // grab time
1427           uint256 _now = now;
1428 
1429           // are we in a round?
1430           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1431               return ( (round_[_rID].eth).keysRec(_eth) );
1432           else // rounds over.  need keys for new round
1433               return ( (_eth).keys() );
1434       }
1435 
1436       /**
1437        * @dev returns current eth price for X keys.
1438        * -functionhash- 0xcf808000
1439        * @param _keys number of keys desired (in 18 decimal format)
1440        * @return amount of eth needed to send
1441        */
1442       function iWantXKeys(uint256 _keys)
1443           public
1444           view
1445           returns(uint256)
1446       {
1447           // setup local rID
1448           uint256 _rID = rID_;
1449 
1450           // grab time
1451           uint256 _now = now;
1452 
1453           // are we in a round?
1454           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1455               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1456           else // rounds over.  need price for new round
1457               return ( (_keys).eth() );
1458       }
1459   //==============================================================================
1460   //    _|_ _  _ | _  .
1461   //     | (_)(_)|_\  .
1462   //==============================================================================
1463       /**
1464   	 * @dev receives name/player info from names contract
1465        */
1466       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1467           external
1468       {
1469           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1470           if (pIDxAddr_[_addr] != _pID)
1471               pIDxAddr_[_addr] = _pID;
1472           if (pIDxName_[_name] != _pID)
1473               pIDxName_[_name] = _pID;
1474           if (plyr_[_pID].addr != _addr)
1475               plyr_[_pID].addr = _addr;
1476           if (plyr_[_pID].name != _name)
1477               plyr_[_pID].name = _name;
1478           if (plyr_[_pID].laff != _laff)
1479               plyr_[_pID].laff = _laff;
1480           if (plyrNames_[_pID][_name] == false)
1481               plyrNames_[_pID][_name] = true;
1482       }
1483 
1484       /**
1485        * @dev receives entire player name list
1486        */
1487       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1488           external
1489       {
1490           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1491           if(plyrNames_[_pID][_name] == false)
1492               plyrNames_[_pID][_name] = true;
1493       }
1494 
1495       /**
1496        * @dev gets existing or registers new pID.  use this when a player may be new
1497        * @return pID
1498        */
1499       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1500           private
1501           returns (F3Ddatasets.EventReturns)
1502       {
1503           uint256 _pID = pIDxAddr_[msg.sender];
1504           // if player is new to this version of fomo3d
1505           if (_pID == 0)
1506           {
1507               // grab their player ID, name and last aff ID, from player names contract
1508               _pID = PlayerBook.getPlayerID(msg.sender);
1509               bytes32 _name = PlayerBook.getPlayerName(_pID);
1510               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1511 
1512               // set up player account
1513               pIDxAddr_[msg.sender] = _pID;
1514               plyr_[_pID].addr = msg.sender;
1515 
1516               if (_name != "")
1517               {
1518                   pIDxName_[_name] = _pID;
1519                   plyr_[_pID].name = _name;
1520                   plyrNames_[_pID][_name] = true;
1521               }
1522 
1523               if (_laff != 0 && _laff != _pID)
1524                   plyr_[_pID].laff = _laff;
1525 
1526               // set the new player bool to true
1527               _eventData_.compressedData = _eventData_.compressedData + 1;
1528           }
1529           return (_eventData_);
1530       }
1531 
1532 
1533     /**
1534     * @dev gets existing or registers new pID.  use this when a player may be new
1535     * @return pID
1536     */
1537     function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1538         private
1539         returns (F3Ddatasets.EventReturns)
1540     {
1541         uint256 _pID = pIDxAddr_[_realSender];
1542         // if player is new to this version of fomo3d
1543         if (_pID == 0)
1544         {
1545             // grab their player ID, name and last aff ID, from player names contract
1546             _pID = PlayerBook.getPlayerID(_realSender);
1547             bytes32 _name = PlayerBook.getPlayerName(_pID);
1548             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1549 
1550             // set up player account
1551             pIDxAddr_[_realSender] = _pID;
1552             plyr_[_pID].addr = _realSender;
1553 
1554             if (_name != "")
1555             {
1556                 pIDxName_[_name] = _pID;
1557                 plyr_[_pID].name = _name;
1558                 plyrNames_[_pID][_name] = true;
1559             }
1560 
1561             if (_laff != 0 && _laff != _pID)
1562                 plyr_[_pID].laff = _laff;
1563 
1564             // set the new player bool to true
1565             _eventData_.compressedData = _eventData_.compressedData + 1;
1566         }
1567         return (_eventData_);
1568     }
1569 
1570       /**
1571        * @dev checks to make sure user picked a valid team.  if not sets team
1572        * to default (sneks)
1573        */
1574       function verifyTeam(uint256 _team)
1575           private
1576           pure
1577           returns (uint256)
1578       {
1579           if (_team < 0 || _team > 3)
1580               return(2);
1581           else
1582               return(_team);
1583       }
1584 
1585       /**
1586        * @dev decides if round end needs to be run & new round started.  and if
1587        * player unmasked earnings from previously played rounds need to be moved.
1588        */
1589       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1590           private
1591           returns (F3Ddatasets.EventReturns)
1592       {
1593           // if player has played a previous round, move their unmasked earnings
1594           // from that round to gen vault.
1595           if (plyr_[_pID].lrnd != 0)
1596               updateGenVault(_pID, plyr_[_pID].lrnd);
1597 
1598           // update player's last round played
1599           plyr_[_pID].lrnd = rID_;
1600 
1601           // set the joined round bool to true
1602           _eventData_.compressedData = _eventData_.compressedData + 10;
1603 
1604           return(_eventData_);
1605       }
1606 
1607     /**
1608     * @dev ends the round. manages paying out winner/splitting up pot
1609     */
1610     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1611         private
1612         returns (F3Ddatasets.EventReturns)
1613     {
1614         // setup local rID
1615         uint256 _rID = rID_;
1616 
1617         // grab our winning player and team id's
1618         uint256 _winPID = round_[_rID].plyr;
1619         uint256 _winTID = round_[_rID].team;
1620 
1621         // grab our pot amount
1622         uint256 _pot = round_[_rID].pot;
1623 
1624         // calculate our winner share, community rewards, gen share,
1625         // p3d share, and amount reserved for next pot
1626         uint256 _win = _pot;
1627         uint256 _com = 0;
1628         uint256 _gen = 0;
1629         uint256 _p3d = 0;
1630         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d); // actually 0 eth to the next round
1631 
1632         // calculate ppt for round mask
1633         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1634 
1635         // pay our winner
1636         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1637 
1638         // distribute gen portion to key holders
1639         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1640 
1641         // prepare event data
1642         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1643         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1644         _eventData_.winnerAddr = plyr_[_winPID].addr;
1645         _eventData_.winnerName = plyr_[_winPID].name;
1646         _eventData_.amountWon = _win;
1647         _eventData_.genAmount = _gen;
1648         _eventData_.P3DAmount = _p3d;
1649         _eventData_.newPot = _res;
1650 
1651         // start next round
1652         rID_++;
1653         _rID++;
1654         round_[_rID].strt = now;
1655         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1656         round_[_rID].pot = _res;
1657 
1658         return(_eventData_);
1659     }
1660 
1661     /**
1662     * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1663     */
1664     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1665         private
1666     {
1667         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1668         if (_earnings > 0)
1669         {
1670             // put in gen vault
1671             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1672             // zero out their earnings by updating mask
1673             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1674         }
1675     }
1676 
1677     /**
1678     * @dev updates round timer based on number of whole keys bought.
1679     */
1680     function updateTimer(uint256 _keys, uint256 _rID)
1681         private
1682     {
1683         // grab time
1684         uint256 _now = now;
1685 
1686         // calculate time based on number of keys bought
1687         uint256 _newTime;
1688         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1689             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1690         else
1691             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1692 
1693         // compare to max and set new end time
1694         if (_newTime < (rndMax_).add(_now))
1695             round_[_rID].end = _newTime;
1696         else
1697             round_[_rID].end = rndMax_.add(_now);
1698     }
1699 
1700       /**
1701        * @dev generates a random number between 0-99 and checks to see if thats
1702        * resulted in an airdrop win
1703        * @return do we have a winner?
1704        */
1705       function airdrop()
1706           private
1707           view
1708           returns(bool)
1709       {
1710           uint256 seed = uint256(keccak256(abi.encodePacked(
1711 
1712               (block.timestamp).add
1713               (block.difficulty).add
1714               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1715               (block.gaslimit).add
1716               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1717               (block.number)
1718 
1719           )));
1720           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1721               return(true);
1722           else
1723               return(false);
1724       }
1725 
1726     /**
1727     * @dev distributes eth based on fees to com, aff, and p3d
1728     */
1729     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1730         private
1731         returns(F3Ddatasets.EventReturns)
1732     {
1733         // pay 2% out to developers rewards
1734         uint256 _p3d = _eth / 50;
1735 
1736         // distribute share to running team
1737         uint256 _aff = _eth.mul(8) / 100;
1738 
1739         // distribute 10% to pot
1740         uint256 _potAmount = _eth / 10;
1741 
1742         // decide what to do with affiliate share of fees
1743         // affiliate must not be self, and must have a name registered
1744         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1745         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1746 
1747         // pay out p3d
1748         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1749         if (_p3d > 0)
1750         {
1751             // deposit to divies contract
1752             admin.transfer(_p3d);
1753             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1754             // set up event data
1755             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1756         }
1757         return(_eventData_);
1758     }
1759 
1760     function potSwap()
1761         external
1762         payable
1763     {
1764         // setup local rID
1765         uint256 _rID = rID_ + 1;
1766 
1767         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1768         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1769     }
1770 
1771     /**
1772     * @dev distributes eth based on fees to gen and pot
1773     */
1774     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1775         private
1776         returns(F3Ddatasets.EventReturns)
1777     {
1778         // calculate gen share
1779         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1780 
1781         // calculate pot 10%
1782         uint256 _pot = _eth/10;
1783 
1784         // distribute gen share (thats what updateMasks() does) and adjust
1785         // balances for dust.
1786         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1787         if (_dust > 0)
1788             _gen = _gen.sub(_dust);
1789 
1790         // add eth to pot
1791         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1792 
1793         // set up event data
1794         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1795         _eventData_.potAmount = _pot;
1796 
1797         return(_eventData_);
1798     }
1799 
1800 
1801       /**
1802        * @dev updates masks for round and player when keys are bought
1803        * @return dust left over
1804        */
1805       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1806           private
1807           returns(uint256)
1808       {
1809           /* MASKING NOTES
1810               earnings masks are a tricky thing for people to wrap their minds around.
1811               the basic thing to understand here.  is were going to have a global
1812               tracker based on profit per share for each round, that increases in
1813               relevant proportion to the increase in share supply.
1814 
1815               the player will have an additional mask that basically says "based
1816               on the rounds mask, my shares, and how much i've already withdrawn,
1817               how much is still owed to me?"
1818           */
1819 
1820           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1821           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1822           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1823 
1824           // calculate player earning from their own buy (only based on the keys
1825           // they just bought).  & update player earnings mask
1826           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1827           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1828 
1829           // calculate & return dust
1830           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1831       }
1832 
1833     /**
1834     * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1835     * @return earnings in wei format
1836     */
1837     function withdrawEarnings(uint256 _pID)
1838         private
1839         returns(uint256)
1840     {
1841         // update gen vault
1842         updateGenVault(_pID, plyr_[_pID].lrnd);
1843 
1844         // from vaults
1845         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1846         if (_earnings > 0)
1847         {
1848             plyr_[_pID].win = 0;
1849             plyr_[_pID].gen = 0;
1850             plyr_[_pID].aff = 0;
1851         }
1852 
1853         return(_earnings);
1854     }
1855 
1856     /**
1857     * @dev prepares compression data and fires event for buy or reload tx's
1858     */
1859     function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1860         private
1861     {
1862         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1863         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1864 
1865         emit F3Devents.onEndTx
1866         (
1867             _eventData_.compressedData,
1868             _eventData_.compressedIDs,
1869             plyr_[_pID].name,
1870             _realSender,
1871             _eth,
1872             _keys,
1873             _eventData_.winnerAddr,
1874             _eventData_.winnerName,
1875             _eventData_.amountWon,
1876             _eventData_.newPot,
1877             _eventData_.P3DAmount,
1878             _eventData_.genAmount,
1879             _eventData_.potAmount,
1880             airDropPot_
1881         );
1882     }
1883 
1884   //==============================================================================
1885   //    (~ _  _    _._|_    .
1886   //    _)(/_(_|_|| | | \/  .
1887   //====================/=========================================================
1888       /** upon contract deploy, it will be deactivated.  this is a one time
1889        * use function that will activate the contract.  we do this so devs
1890        * have time to set things up on the web end                            **/
1891       bool public activated_ = false;
1892       function activate()
1893           public
1894       {
1895           // only team just can activate
1896           require(msg.sender == admin, "only admin can activate");
1897 
1898 
1899           // can only be ran once
1900           require(activated_ == false, "FOMO Short already activated");
1901 
1902           // activate the contract
1903           activated_ = true;
1904 
1905           // lets start first round
1906           rID_ = 1;
1907               round_[1].strt = now + rndExtra_ - rndGap_;
1908               round_[1].end = now + rndInit_ + rndExtra_;
1909       }
1910   }