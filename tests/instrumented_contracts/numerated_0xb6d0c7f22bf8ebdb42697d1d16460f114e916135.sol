1 pragma solidity ^0.4.24;
2 
3 
4 library NameFilter {
5     /**
6      * @dev filters name strings
7      * -converts uppercase to lower case.
8      * -makes sure it does not start/end with a space
9      * -makes sure it does not contain multiple spaces in a row
10      * -cannot be only numbers
11      * -cannot start with 0x
12      * -restricts characters to A-Z, a-z, 0-9, and space.
13      * @return reprocessed string in bytes32 format
14      */
15     function nameFilter(string _input)
16         internal
17         pure
18         returns(bytes32)
19     {
20         bytes memory _temp = bytes(_input);
21         uint256 _length = _temp.length;
22 
23         //sorry limited to 32 characters
24         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
25         // make sure it doesnt start with or end with space
26         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
27         // make sure first two characters are not 0x
28         if (_temp[0] == 0x30)
29         {
30             require(_temp[1] != 0x78, "string cannot start with 0x");
31             require(_temp[1] != 0x58, "string cannot start with 0X");
32         }
33 
34         // create a bool to track if we have a non number character
35         bool _hasNonNumber;
36 
37         // convert & check
38         for (uint256 i = 0; i < _length; i++)
39         {
40             // if its uppercase A-Z
41             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
42             {
43                 // convert to lower case a-z
44                 _temp[i] = byte(uint(_temp[i]) + 32);
45 
46                 // we have a non number
47                 if (_hasNonNumber == false)
48                     _hasNonNumber = true;
49             } else {
50                 require
51                 (
52                     // require character is a space
53                     _temp[i] == 0x20 ||
54                     // OR lowercase a-z
55                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
56                     // or 0-9
57                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
58                     "string contains invalid characters"
59                 );
60                 // make sure theres not 2x spaces in a row
61                 if (_temp[i] == 0x20)
62                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
63 
64                 // see if we have a character other than a number
65                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
66                     _hasNonNumber = true;
67             }
68         }
69 
70         require(_hasNonNumber == true, "string cannot be only numbers");
71 
72         bytes32 _ret;
73         assembly {
74             _ret := mload(add(_temp, 32))
75         }
76         return (_ret);
77     }
78 }
79 
80 /**
81  * @title SafeMath v0.1.9
82  * @dev Math operations with safety checks that throw on error
83  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
84  * - added sqrt
85  * - added sq
86  * - added pwr
87  * - changed asserts to requires with error log outputs
88  * - removed div, its useless
89  */
90 library SafeMath {
91 
92     /**
93     * @dev Multiplies two numbers, throws on overflow.
94     */
95     function mul(uint256 a, uint256 b)
96         internal
97         pure
98         returns (uint256 c)
99     {
100         if (a == 0) {
101             return 0;
102         }
103         c = a * b;
104         require(c / a == b, "SafeMath mul failed");
105         return c;
106     }
107 
108     /**
109     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
110     */
111     function sub(uint256 a, uint256 b)
112         internal
113         pure
114         returns (uint256)
115     {
116         require(b <= a, "SafeMath sub failed");
117         return a - b;
118     }
119 
120     /**
121     * @dev Adds two numbers, throws on overflow.
122     */
123     function add(uint256 a, uint256 b)
124         internal
125         pure
126         returns (uint256 c)
127     {
128         c = a + b;
129         require(c >= a, "SafeMath add failed");
130         return c;
131     }
132 
133     /**
134      * @dev gives square root of given x.
135      */
136     function sqrt(uint256 x)
137         internal
138         pure
139         returns (uint256 y)
140     {
141         uint256 z = ((add(x,1)) / 2);
142         y = x;
143         while (z < y)
144         {
145             y = z;
146             z = ((add((x / z),z)) / 2);
147         }
148     }
149 
150     /**
151      * @dev gives square. multiplies x by x
152      */
153     function sq(uint256 x)
154         internal
155         pure
156         returns (uint256)
157     {
158         return (mul(x,x));
159     }
160 
161     /**
162      * @dev x to the power of y
163      */
164     function pwr(uint256 x, uint256 y)
165         internal
166         pure
167         returns (uint256)
168     {
169         if (x==0)
170             return (0);
171         else if (y==0)
172             return (1);
173         else
174         {
175             uint256 z = x;
176             for (uint256 i=1; i < y; i++)
177                 z = mul(z,x);
178             return (z);
179         }
180     }
181 }
182 
183 
184 
185 //==============================================================================
186 //   __|_ _    __|_ _  .
187 //  _\ | | |_|(_ | _\  .
188 //==============================================================================
189 library F3Ddatasets {
190     //compressedData key
191     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
192         // 0 - new player (bool)
193         // 1 - joined round (bool)
194         // 2 - new  leader (bool)
195         // 3-5 - air drop tracker (uint 0-999)
196         // 6-16 - round end time
197         // 17 - winnerTeam
198         // 18 - 28 timestamp
199         // 29 - team
200         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
201         // 31 - airdrop happened bool
202         // 32 - airdrop tier
203         // 33 - airdrop amount won
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
461     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x1c52efF9C47fE419E3b269f5759d98d2072cC91A);
462 
463     address private admin = msg.sender;
464     string constant public name = "FOMO Fast";
465     string constant public symbol = "FAST";
466     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
467     uint256 private rndGap_ = 2 minutes;         // length of ICO phase, set to 1 year for EOS.
468     uint256 constant private rndInit_ = 3 minutes;                // round timer starts at this
469     uint256 constant private rndInc_ = 10 seconds;              // every full key purchased adds this much to the timer
470     uint256 constant private rndMax_ = 5 minutes;                // max length a round timer can be
471     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
472     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
473     uint256 public rID_;    // round id number / total rounds that have happened
474   //****************
475   // PLAYER DATA
476   //****************
477     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
478     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
479     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
480     // (pID => rID => data) player round data by player id & round id
481     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
482     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
483   //****************
484   // ROUND DATA
485   //****************
486     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
487     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
488   //****************
489   // TEAM FEE DATA
490   //****************
491     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
492     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
493 
494     constructor()
495         public
496     {
497     // Team allocation structures
498         // 0 = whales
499         // 1 = bears
500         // 2 = sneks
501         // 3 = bulls
502 
503     // Team allocation percentages
504         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
505             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
506         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
507         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
508         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
509         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
510 
511         // how to split up the final pot based on which team was picked
512         // (F3D, P3D)
513         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
514         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
515         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
516         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
517   	}
518   //==============================================================================
519   //     _ _  _  _|. |`. _  _ _  .
520   //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
521   //==============================================================================
522       /**
523        * @dev used to make sure no one can interact with contract until it has
524        * been activated.
525        */
526       modifier isActivated() {
527           require(activated_ == true, "its not ready yet.  check ?eta in discord");
528           _;
529       }
530 
531       /**
532        * @dev prevents contracts from interacting with fomo3d
533        */
534       modifier isHuman() {
535           address _addr = msg.sender;
536           uint256 _codeLength;
537 
538           assembly {_codeLength := extcodesize(_addr)}
539           require(_codeLength == 0, "sorry humans only");
540           _;
541       }
542 
543       /**
544        * @dev sets boundaries for incoming tx
545        */
546       modifier isWithinLimits(uint256 _eth) {
547           require(_eth >= 1000000000, "pocket lint: not a valid currency");
548           require(_eth <= 100000000000000000000000, "no vitalik, no");
549           _;
550       }
551 
552   //==============================================================================
553   //     _    |_ |. _   |`    _  __|_. _  _  _  .
554   //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
555   //====|=========================================================================
556       /**
557        * @dev emergency buy uses last stored affiliate ID and team snek
558        */
559       function()
560           isActivated()
561           isHuman()
562           isWithinLimits(msg.value)
563           public
564           payable
565       {
566           // set up our tx event data and determine if player is new or not
567           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
568 
569           // fetch player id
570           uint256 _pID = pIDxAddr_[msg.sender];
571 
572           // buy core
573           buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
574       }
575 
576       /**
577        * @dev converts all incoming ethereum to keys.
578        * -functionhash- 0x8f38f309 (using ID for affiliate)
579        * -functionhash- 0x98a0871d (using address for affiliate)
580        * -functionhash- 0xa65b37a1 (using name for affiliate)
581        * @param _affCode the ID/address/name of the player who gets the affiliate fee
582        * @param _team what team is the player playing for?
583        */
584       function buyXid(uint256 _affCode, uint256 _team)
585           isActivated()
586           isHuman()
587           isWithinLimits(msg.value)
588           public
589           payable
590       {
591           // set up our tx event data and determine if player is new or not
592           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
593 
594           // fetch player id
595           uint256 _pID = pIDxAddr_[msg.sender];
596 
597           // manage affiliate residuals
598           // if no affiliate code was given or player tried to use their own, lolz
599           if (_affCode == 0 || _affCode == _pID)
600           {
601               // use last stored affiliate code
602               _affCode = plyr_[_pID].laff;
603 
604           // if affiliate code was given & its not the same as previously stored
605           } else if (_affCode != plyr_[_pID].laff) {
606               // update last affiliate
607               plyr_[_pID].laff = _affCode;
608           }
609 
610           // verify a valid team was selected
611           _team = verifyTeam(_team);
612 
613           // buy core
614           buyCore(_pID, _affCode, _team, _eventData_);
615       }
616 
617       function buyXaddr(address _affCode, uint256 _team)
618           isActivated()
619           isWithinLimits(msg.value)
620           public
621           payable
622       {
623           // set up our tx event data and determine if player is new or not
624           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
625 
626           // fetch player id
627           uint256 _pID = pIDxAddr_[msg.sender];
628 
629           // manage affiliate residuals
630           uint256 _affID;
631           // if no affiliate code was given or player tried to use their own, lolz
632           if (_affCode == address(0) || _affCode == msg.sender)
633           {
634               // use last stored affiliate code
635               _affID = plyr_[_pID].laff;
636 
637           // if affiliate code was given
638           } else {
639               // get affiliate ID from aff Code
640               _affID = pIDxAddr_[_affCode];
641 
642               // if affID is not the same as previously stored
643               if (_affID != plyr_[_pID].laff)
644               {
645                   // update last affiliate
646                   plyr_[_pID].laff = _affID;
647               }
648           }
649 
650           // verify a valid team was selected
651           _team = verifyTeam(_team);
652 
653           // buy core
654           buyCore(_pID, _affID, _team, _eventData_);
655       }
656 
657       function buyXname(bytes32 _affCode, uint256 _team)
658           isActivated()
659           isHuman()
660           isWithinLimits(msg.value)
661           public
662           payable
663       {
664           // set up our tx event data and determine if player is new or not
665           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
666 
667           // fetch player id
668           uint256 _pID = pIDxAddr_[msg.sender];
669 
670           // manage affiliate residuals
671           uint256 _affID;
672           // if no affiliate code was given or player tried to use their own, lolz
673           if (_affCode == '' || _affCode == plyr_[_pID].name)
674           {
675               // use last stored affiliate code
676               _affID = plyr_[_pID].laff;
677 
678           // if affiliate code was given
679           } else {
680               // get affiliate ID from aff Code
681               _affID = pIDxName_[_affCode];
682 
683               // if affID is not the same as previously stored
684               if (_affID != plyr_[_pID].laff)
685               {
686                   // update last affiliate
687                   plyr_[_pID].laff = _affID;
688               }
689           }
690 
691           // verify a valid team was selected
692           _team = verifyTeam(_team);
693 
694           // buy core
695           buyCore(_pID, _affID, _team, _eventData_);
696       }
697 
698 
699        function buyXnameQR(address _realSender,bytes32 _affCode, uint256 _team)
700           isActivated()
701           isWithinLimits(msg.value)
702           public
703           payable
704       {
705           // set up our tx event data and determine if player is new or not
706           F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
707 
708           // fetch player id
709           uint256 _pID = pIDxAddr_[_realSender];
710 
711           // manage affiliate residuals
712           uint256 _affID;
713           // if no affiliate code was given or player tried to use their own, lolz
714           if (_affCode == '' || _affCode == plyr_[_pID].name)
715           {
716               // use last stored affiliate code
717               _affID = plyr_[_pID].laff;
718 
719           // if affiliate code was given
720           } else {
721               // get affiliate ID from aff Code
722               _affID = pIDxName_[_affCode];
723 
724               // if affID is not the same as previously stored
725               if (_affID != plyr_[_pID].laff)
726               {
727                   // update last affiliate
728                   plyr_[_pID].laff = _affID;
729               }
730           }
731 
732           // verify a valid team was selected
733           _team = verifyTeam(_team);
734 
735           // buy core
736           buyCoreQR(_realSender, _pID, _affID, _team, _eventData_);
737       }
738 
739       /**
740        * @dev essentially the same as buy, but instead of you sending ether
741        * from your wallet, it uses your unwithdrawn earnings.
742        * -functionhash- 0x349cdcac (using ID for affiliate)
743        * -functionhash- 0x82bfc739 (using address for affiliate)
744        * -functionhash- 0x079ce327 (using name for affiliate)
745        * @param _affCode the ID/address/name of the player who gets the affiliate fee
746        * @param _team what team is the player playing for?
747        * @param _eth amount of earnings to use (remainder returned to gen vault)
748        */
749       function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
750           isActivated()
751           isHuman()
752           isWithinLimits(_eth)
753           public
754       {
755           // set up our tx event data
756           F3Ddatasets.EventReturns memory _eventData_;
757 
758           // fetch player ID
759           uint256 _pID = pIDxAddr_[msg.sender];
760 
761           // manage affiliate residuals
762           // if no affiliate code was given or player tried to use their own, lolz
763           if (_affCode == 0 || _affCode == _pID)
764           {
765               // use last stored affiliate code
766               _affCode = plyr_[_pID].laff;
767 
768           // if affiliate code was given & its not the same as previously stored
769           } else if (_affCode != plyr_[_pID].laff) {
770               // update last affiliate
771               plyr_[_pID].laff = _affCode;
772           }
773 
774           // verify a valid team was selected
775           _team = verifyTeam(_team);
776 
777           // reload core
778           reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
779       }
780 
781       function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
782           isActivated()
783           isHuman()
784           isWithinLimits(_eth)
785           public
786       {
787           // set up our tx event data
788           F3Ddatasets.EventReturns memory _eventData_;
789 
790           // fetch player ID
791           uint256 _pID = pIDxAddr_[msg.sender];
792 
793           // manage affiliate residuals
794           uint256 _affID;
795           // if no affiliate code was given or player tried to use their own, lolz
796           if (_affCode == address(0) || _affCode == msg.sender)
797           {
798               // use last stored affiliate code
799               _affID = plyr_[_pID].laff;
800 
801           // if affiliate code was given
802           } else {
803               // get affiliate ID from aff Code
804               _affID = pIDxAddr_[_affCode];
805 
806               // if affID is not the same as previously stored
807               if (_affID != plyr_[_pID].laff)
808               {
809                   // update last affiliate
810                   plyr_[_pID].laff = _affID;
811               }
812           }
813 
814           // verify a valid team was selected
815           _team = verifyTeam(_team);
816 
817           // reload core
818           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
819       }
820 
821       function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
822           isActivated()
823           isHuman()
824           isWithinLimits(_eth)
825           public
826       {
827           // set up our tx event data
828           F3Ddatasets.EventReturns memory _eventData_;
829 
830           // fetch player ID
831           uint256 _pID = pIDxAddr_[msg.sender];
832 
833           // manage affiliate residuals
834           uint256 _affID;
835           // if no affiliate code was given or player tried to use their own, lolz
836           if (_affCode == '' || _affCode == plyr_[_pID].name)
837           {
838               // use last stored affiliate code
839               _affID = plyr_[_pID].laff;
840 
841           // if affiliate code was given
842           } else {
843               // get affiliate ID from aff Code
844               _affID = pIDxName_[_affCode];
845 
846               // if affID is not the same as previously stored
847               if (_affID != plyr_[_pID].laff)
848               {
849                   // update last affiliate
850                   plyr_[_pID].laff = _affID;
851               }
852           }
853 
854           // verify a valid team was selected
855           _team = verifyTeam(_team);
856 
857           // reload core
858           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
859       }
860 
861       /**
862        * @dev withdraws all of your earnings.
863        * -functionhash- 0x3ccfd60b
864        */
865       function withdraw()
866           isActivated()
867           isHuman()
868           public
869       {
870           // setup local rID
871           uint256 _rID = rID_;
872 
873           // grab time
874           uint256 _now = now;
875 
876           // fetch player ID
877           uint256 _pID = pIDxAddr_[msg.sender];
878 
879           // setup temp var for player eth
880           uint256 _eth;
881 
882           // check to see if round has ended and no one has run round end yet
883           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
884           {
885               // set up our tx event data
886               F3Ddatasets.EventReturns memory _eventData_;
887 
888               // end the round (distributes pot)
889   			round_[_rID].ended = true;
890               _eventData_ = endRound(_eventData_);
891 
892   			// get their earnings
893               _eth = withdrawEarnings(_pID);
894 
895               // gib moni
896               if (_eth > 0)
897                   plyr_[_pID].addr.transfer(_eth);
898 
899               // build event data
900               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
901               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
902 
903               // fire withdraw and distribute event
904               emit F3Devents.onWithdrawAndDistribute
905               (
906                   msg.sender,
907                   plyr_[_pID].name,
908                   _eth,
909                   _eventData_.compressedData,
910                   _eventData_.compressedIDs,
911                   _eventData_.winnerAddr,
912                   _eventData_.winnerName,
913                   _eventData_.amountWon,
914                   _eventData_.newPot,
915                   _eventData_.P3DAmount,
916                   _eventData_.genAmount
917               );
918 
919           // in any other situation
920           } else {
921               // get their earnings
922               _eth = withdrawEarnings(_pID);
923 
924               // gib moni
925               if (_eth > 0)
926                   plyr_[_pID].addr.transfer(_eth);
927 
928               // fire withdraw event
929               emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
930           }
931       }
932 
933     /**
934        * @dev withdraws all of your earnings.
935        * -functionhash- 0x3ccfd60b
936        */
937       function withdrawQR(address _realSender)
938           isActivated()
939           payable
940           public
941       {
942           // setup local rID
943           uint256 _rID = rID_;
944 
945           // grab time
946           uint256 _now = now;
947 
948           // fetch player ID
949           uint256 _pID = pIDxAddr_[_realSender];
950 
951           // setup temp var for player eth
952           uint256 _eth;
953 
954           // check to see if round has ended and no one has run round end yet
955           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
956           {
957               // set up our tx event data
958               F3Ddatasets.EventReturns memory _eventData_;
959 
960               // end the round (distributes pot)
961   			round_[_rID].ended = true;
962               _eventData_ = endRound(_eventData_);
963 
964   			// get their earnings
965               _eth = withdrawEarnings(_pID);
966 
967               // gib moni
968               if (_eth > 0)
969                   plyr_[_pID].addr.transfer(_eth);
970 
971               // build event data
972               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
973               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
974 
975               // fire withdraw and distribute event
976               emit F3Devents.onWithdrawAndDistribute
977               (
978                   _realSender,
979                   plyr_[_pID].name,
980                   _eth,
981                   _eventData_.compressedData,
982                   _eventData_.compressedIDs,
983                   _eventData_.winnerAddr,
984                   _eventData_.winnerName,
985                   _eventData_.amountWon,
986                   _eventData_.newPot,
987                   _eventData_.P3DAmount,
988                   _eventData_.genAmount
989               );
990 
991           // in any other situation
992           } else {
993               // get their earnings
994               _eth = withdrawEarnings(_pID);
995 
996               // gib moni
997               if (_eth > 0)
998                   plyr_[_pID].addr.transfer(_eth);
999 
1000               // fire withdraw event
1001               emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
1002           }
1003       }
1004 
1005       /**
1006        * @dev use these to register names.  they are just wrappers that will send the
1007        * registration requests to the PlayerBook contract.  So registering here is the
1008        * same as registering there.  UI will always display the last name you registered.
1009        * but you will still own all previously registered names to use as affiliate
1010        * links.
1011        * - must pay a registration fee.
1012        * - name must be unique
1013        * - names will be converted to lowercase
1014        * - name cannot start or end with a space
1015        * - cannot have more than 1 space in a row
1016        * - cannot be only numbers
1017        * - cannot start with 0x
1018        * - name must be at least 1 char
1019        * - max length of 32 characters long
1020        * - allowed characters: a-z, 0-9, and space
1021        * -functionhash- 0x921dec21 (using ID for affiliate)
1022        * -functionhash- 0x3ddd4698 (using address for affiliate)
1023        * -functionhash- 0x685ffd83 (using name for affiliate)
1024        * @param _nameString players desired name
1025        * @param _affCode affiliate ID, address, or name of who referred you
1026        * @param _all set to true if you want this to push your info to all games
1027        * (this might cost a lot of gas)
1028        */
1029 
1030       function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1031           isHuman()
1032           public
1033           payable
1034       {
1035           bytes32 _name = _nameString.nameFilter();
1036           address _addr = msg.sender;
1037           uint256 _paid = msg.value;
1038           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
1039 
1040           uint256 _pID = pIDxAddr_[_addr];
1041 
1042           // fire event
1043           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1044       }
1045 
1046       function registerNameXaddr(string _nameString, address _affCode, bool _all)
1047           isHuman()
1048           public
1049           payable
1050       {
1051           bytes32 _name = _nameString.nameFilter();
1052           address _addr = msg.sender;
1053           uint256 _paid = msg.value;
1054           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1055 
1056           uint256 _pID = pIDxAddr_[_addr];
1057 
1058           // fire event
1059           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1060       }
1061 
1062       function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1063           isHuman()
1064           public
1065           payable
1066       {
1067           bytes32 _name = _nameString.nameFilter();
1068           address _addr = msg.sender;
1069           uint256 _paid = msg.value;
1070           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1071 
1072           uint256 _pID = pIDxAddr_[_addr];
1073 
1074           // fire event
1075           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1076       }
1077 
1078 
1079   //==============================================================================
1080   //     _  _ _|__|_ _  _ _  .
1081   //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1082   //=====_|=======================================================================
1083       /**
1084        * @dev return the price buyer will pay for next 1 individual key.
1085        * -functionhash- 0x018a25e8
1086        * @return price for next key bought (in wei format)
1087        */
1088       function getBuyPrice()
1089           public
1090           view
1091           returns(uint256)
1092       {
1093           // setup local rID
1094           uint256 _rID = rID_;
1095 
1096           // grab time
1097           uint256 _now = now;
1098 
1099           // are we in a round?
1100           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1101               return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1102           else // rounds over.  need price for new round
1103               return ( 75000000000000 ); // init
1104       }
1105 
1106       /**
1107        * @dev returns time left.  dont spam this, you'll ddos yourself from your node
1108        * provider
1109        * -functionhash- 0xc7e284b8
1110        * @return time left in seconds
1111        */
1112       function getTimeLeft()
1113           public
1114           view
1115           returns(uint256)
1116       {
1117           // setup local rID
1118           uint256 _rID = rID_;
1119 
1120           // grab time
1121           uint256 _now = now;
1122 
1123           if (_now < round_[_rID].end)
1124               if (_now > round_[_rID].strt + rndGap_)
1125                   return( (round_[_rID].end).sub(_now) );
1126               else
1127                   return( (round_[_rID].strt + rndGap_).sub(_now) );
1128           else
1129               return(0);
1130       }
1131 
1132       /**
1133        * @dev returns player earnings per vaults
1134        * -functionhash- 0x63066434
1135        * @return winnings vault
1136        * @return general vault
1137        * @return affiliate vault
1138        */
1139       function getPlayerVaults(uint256 _pID)
1140           public
1141           view
1142           returns(uint256 ,uint256, uint256)
1143       {
1144           // setup local rID
1145           uint256 _rID = rID_;
1146 
1147           // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1148           if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1149           {
1150               // if player is winner
1151               if (round_[_rID].plyr == _pID)
1152               {
1153                   return
1154                   (
1155                       (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1156                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1157                       plyr_[_pID].aff
1158                   );
1159               // if player is not the winner
1160               } else {
1161                   return
1162                   (
1163                       plyr_[_pID].win,
1164                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1165                       plyr_[_pID].aff
1166                   );
1167               }
1168 
1169           // if round is still going on, or round has ended and round end has been ran
1170           } else {
1171               return
1172               (
1173                   plyr_[_pID].win,
1174                   (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1175                   plyr_[_pID].aff
1176               );
1177           }
1178       }
1179 
1180       /**
1181        * solidity hates stack limits.  this lets us avoid that hate
1182        */
1183       function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1184           private
1185           view
1186           returns(uint256)
1187       {
1188           return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1189       }
1190 
1191       /**
1192        * @dev returns all current round info needed for front end
1193        * -functionhash- 0x747dff42
1194        * @return eth invested during ICO phase
1195        * @return round id
1196        * @return total keys for round
1197        * @return time round ends
1198        * @return time round started
1199        * @return current pot
1200        * @return current team ID & player ID in lead
1201        * @return current player in leads address
1202        * @return current player in leads name
1203        * @return whales eth in for round
1204        * @return bears eth in for round
1205        * @return sneks eth in for round
1206        * @return bulls eth in for round
1207        * @return airdrop tracker # & airdrop pot
1208        */
1209       function getCurrentRoundInfo()
1210           public
1211           view
1212           returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1213       {
1214           // setup local rID
1215           uint256 _rID = rID_;
1216 
1217           return
1218           (
1219               round_[_rID].ico,               //0
1220               _rID,                           //1
1221               round_[_rID].keys,              //2
1222               round_[_rID].end,               //3
1223               round_[_rID].strt,              //4
1224               round_[_rID].pot,               //5
1225               (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1226               plyr_[round_[_rID].plyr].addr,  //7
1227               plyr_[round_[_rID].plyr].name,  //8
1228               rndTmEth_[_rID][0],             //9
1229               rndTmEth_[_rID][1],             //10
1230               rndTmEth_[_rID][2],             //11
1231               rndTmEth_[_rID][3],             //12
1232               airDropTracker_ + (airDropPot_ * 1000)              //13
1233           );
1234       }
1235 
1236       /**
1237        * @dev returns player info based on address.  if no address is given, it will
1238        * use msg.sender
1239        * -functionhash- 0xee0b5d8b
1240        * @param _addr address of the player you want to lookup
1241        * @return player ID
1242        * @return player name
1243        * @return keys owned (current round)
1244        * @return winnings vault
1245        * @return general vault
1246        * @return affiliate vault
1247   	 * @return player round eth
1248        */
1249       function getPlayerInfoByAddress(address _addr)
1250           public
1251           view
1252           returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1253       {
1254           // setup local rID
1255           uint256 _rID = rID_;
1256 
1257           if (_addr == address(0))
1258           {
1259               _addr == msg.sender;
1260           }
1261           uint256 _pID = pIDxAddr_[_addr];
1262 
1263           return
1264           (
1265               _pID,                               //0
1266               plyr_[_pID].name,                   //1
1267               plyrRnds_[_pID][_rID].keys,         //2
1268               plyr_[_pID].win,                    //3
1269               (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1270               plyr_[_pID].aff,                    //5
1271               plyrRnds_[_pID][_rID].eth           //6
1272           );
1273       }
1274 
1275   //==============================================================================
1276   //     _ _  _ _   | _  _ . _  .
1277   //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1278   //=====================_|=======================================================
1279       /**
1280        * @dev logic runs whenever a buy order is executed.  determines how to handle
1281        * incoming eth depending on if we are in an active round or not
1282        */
1283       function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1284           private
1285       {
1286           // setup local rID
1287           uint256 _rID = rID_;
1288 
1289           // grab time
1290           uint256 _now = now;
1291 
1292           // if round is active
1293           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1294           {
1295               // call core
1296               core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
1297 
1298           // if round is not active
1299           } else {
1300               // check to see if end round needs to be ran
1301               if (_now > round_[_rID].end && round_[_rID].ended == false)
1302               {
1303                   // end the round (distributes pot) & start new round
1304   			    round_[_rID].ended = true;
1305                   _eventData_ = endRound(_eventData_);
1306 
1307                   // build event data
1308                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1309                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1310 
1311                   // fire buy and distribute event
1312                   emit F3Devents.onBuyAndDistribute
1313                   (
1314                       msg.sender,
1315                       plyr_[_pID].name,
1316                       msg.value,
1317                       _eventData_.compressedData,
1318                       _eventData_.compressedIDs,
1319                       _eventData_.winnerAddr,
1320                       _eventData_.winnerName,
1321                       _eventData_.amountWon,
1322                       _eventData_.newPot,
1323                       _eventData_.P3DAmount,
1324                       _eventData_.genAmount
1325                   );
1326               }
1327 
1328               // put eth in players vault
1329               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1330           }
1331       }
1332 
1333        /**
1334        * @dev logic runs whenever a buy order is executed.  determines how to handle
1335        * incoming eth depending on if we are in an active round or not
1336        */
1337       function buyCoreQR(address _realSender,uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1338           private
1339       {
1340           // setup local rID
1341           uint256 _rID = rID_;
1342 
1343           // grab time
1344           uint256 _now = now;
1345 
1346           // if round is active
1347           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1348           {
1349               // call core
1350               core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1351 
1352           // if round is not active
1353           } else {
1354               // check to see if end round needs to be ran
1355               if (_now > round_[_rID].end && round_[_rID].ended == false)
1356               {
1357                   // end the round (distributes pot) & start new round
1358   			    round_[_rID].ended = true;
1359                   _eventData_ = endRound(_eventData_);
1360 
1361                   // build event data
1362                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1363                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1364 
1365                   // fire buy and distribute event
1366                   emit F3Devents.onBuyAndDistribute
1367                   (
1368                       _realSender,
1369                       plyr_[_pID].name,
1370                       msg.value,
1371                       _eventData_.compressedData,
1372                       _eventData_.compressedIDs,
1373                       _eventData_.winnerAddr,
1374                       _eventData_.winnerName,
1375                       _eventData_.amountWon,
1376                       _eventData_.newPot,
1377                       _eventData_.P3DAmount,
1378                       _eventData_.genAmount
1379                   );
1380               }
1381 
1382               // put eth in players vault
1383               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1384           }
1385       }
1386 
1387       /**
1388        * @dev logic runs whenever a reload order is executed.  determines how to handle
1389        * incoming eth depending on if we are in an active round or not
1390        */
1391       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1392           private
1393       {
1394           // setup local rID
1395           uint256 _rID = rID_;
1396 
1397           // grab time
1398           uint256 _now = now;
1399 
1400           // if round is active
1401           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1402           {
1403               // get earnings from all vaults and return unused to gen vault
1404               // because we use a custom safemath library.  this will throw if player
1405               // tried to spend more eth than they have.
1406               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1407 
1408               // call core
1409               core(address(0), _rID, _pID, _eth, _affID, _team, _eventData_);
1410 
1411           // if round is not active and end round needs to be ran
1412           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1413               // end the round (distributes pot) & start new round
1414               round_[_rID].ended = true;
1415               _eventData_ = endRound(_eventData_);
1416 
1417               // build event data
1418               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1419               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1420 
1421               // fire buy and distribute event
1422               emit F3Devents.onReLoadAndDistribute
1423               (
1424                   msg.sender,
1425                   plyr_[_pID].name,
1426                   _eventData_.compressedData,
1427                   _eventData_.compressedIDs,
1428                   _eventData_.winnerAddr,
1429                   _eventData_.winnerName,
1430                   _eventData_.amountWon,
1431                   _eventData_.newPot,
1432                   _eventData_.P3DAmount,
1433                   _eventData_.genAmount
1434               );
1435           }
1436       }
1437 
1438       /**
1439        * @dev this is the core logic for any buy/reload that happens while a round
1440        * is live.
1441        */
1442       function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1443           private
1444       {
1445           // if player is new to round
1446           if (plyrRnds_[_pID][_rID].keys == 0)
1447               _eventData_ = managePlayer(_pID, _eventData_);
1448 
1449           // early round eth limiter
1450           if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1451           {
1452               uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1453               uint256 _refund = _eth.sub(_availableLimit);
1454               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1455               _eth = _availableLimit;
1456           }
1457 
1458           // if eth left is greater than min eth allowed (sorry no pocket lint)
1459           if (_eth > 1000000000)
1460           {
1461 
1462               // mint the new keys
1463               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1464 
1465               // if they bought at least 1 whole key
1466               if (_keys >= 1000000000000000000)
1467               {
1468               updateTimer(_keys, _rID);
1469 
1470               // set new leaders
1471               if (round_[_rID].plyr != _pID)
1472                   round_[_rID].plyr = _pID;
1473               if (round_[_rID].team != _team)
1474                   round_[_rID].team = _team;
1475 
1476               // set the new leader bool to true
1477               _eventData_.compressedData = _eventData_.compressedData + 100;
1478           }
1479 
1480               // manage airdrops
1481               if (_eth >= 100000000000000000)
1482               {
1483               airDropTracker_++;
1484               if (airdrop() == true)
1485               {
1486                   // gib muni
1487                   uint256 _prize;
1488                   if (_eth >= 10000000000000000000)
1489                   {
1490                       // calculate prize and give it to winner
1491                       _prize = ((airDropPot_).mul(75)) / 100;
1492                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1493 
1494                       // adjust airDropPot
1495                       airDropPot_ = (airDropPot_).sub(_prize);
1496 
1497                       // let event know a tier 3 prize was won
1498                       _eventData_.compressedData += 300000000000000000000000000000000;
1499                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1500                       // calculate prize and give it to winner
1501                       _prize = ((airDropPot_).mul(50)) / 100;
1502                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1503 
1504                       // adjust airDropPot
1505                       airDropPot_ = (airDropPot_).sub(_prize);
1506 
1507                       // let event know a tier 2 prize was won
1508                       _eventData_.compressedData += 200000000000000000000000000000000;
1509                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1510                       // calculate prize and give it to winner
1511                       _prize = ((airDropPot_).mul(25)) / 100;
1512                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1513 
1514                       // adjust airDropPot
1515                       airDropPot_ = (airDropPot_).sub(_prize);
1516 
1517                       // let event know a tier 3 prize was won
1518                       _eventData_.compressedData += 300000000000000000000000000000000;
1519                   }
1520                   // set airdrop happened bool to true
1521                   _eventData_.compressedData += 10000000000000000000000000000000;
1522                   // let event know how much was won
1523                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1524 
1525                   // reset air drop tracker
1526                   airDropTracker_ = 0;
1527               }
1528           }
1529 
1530               // store the air drop tracker number (number of buys since last airdrop)
1531               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1532 
1533               // update player
1534               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1535               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1536 
1537               // update round
1538               round_[_rID].keys = _keys.add(round_[_rID].keys);
1539               round_[_rID].eth = _eth.add(round_[_rID].eth);
1540               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1541 
1542               // distribute eth
1543               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1544               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1545 
1546               // call end tx function to fire end tx event.
1547               if (_realSender==address(0)) {
1548 	              endTx(_pID, _team, _eth, _keys, _eventData_);
1549 	            } else {
1550 	              endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1551               }
1552           }
1553       }
1554 
1555 
1556 
1557             /**
1558        * @dev this is the core logic for any buy/reload that happens while a round
1559        * is live.
1560        */
1561       /* function coreQR(address _realSender,uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1562           private
1563       {
1564           // if player is new to round
1565           if (plyrRnds_[_pID][_rID].keys == 0)
1566               _eventData_ = managePlayer(_pID, _eventData_);
1567 
1568           // early round eth limiter
1569           if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1570           {
1571               uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1572               uint256 _refund = _eth.sub(_availableLimit);
1573               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1574               _eth = _availableLimit;
1575           }
1576 
1577           // if eth left is greater than min eth allowed (sorry no pocket lint)
1578           if (_eth > 1000000000)
1579           {
1580 
1581               // mint the new keys
1582               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1583 
1584               // if they bought at least 1 whole key
1585               if (_keys >= 1000000000000000000)
1586               {
1587               updateTimer(_keys, _rID);
1588 
1589               // set new leaders
1590               if (round_[_rID].plyr != _pID)
1591                   round_[_rID].plyr = _pID;
1592               if (round_[_rID].team != _team)
1593                   round_[_rID].team = _team;
1594 
1595               // set the new leader bool to true
1596               _eventData_.compressedData = _eventData_.compressedData + 100;
1597           }
1598 
1599               // manage airdrops
1600               if (_eth >= 100000000000000000)
1601               {
1602               airDropTracker_++;
1603               if (airdrop() == true)
1604               {
1605                   // gib muni
1606                   uint256 _prize;
1607                   if (_eth >= 10000000000000000000)
1608                   {
1609                       // calculate prize and give it to winner
1610                       _prize = ((airDropPot_).mul(75)) / 100;
1611                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1612 
1613                       // adjust airDropPot
1614                       airDropPot_ = (airDropPot_).sub(_prize);
1615 
1616                       // let event know a tier 3 prize was won
1617                       _eventData_.compressedData += 300000000000000000000000000000000;
1618                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1619                       // calculate prize and give it to winner
1620                       _prize = ((airDropPot_).mul(50)) / 100;
1621                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1622 
1623                       // adjust airDropPot
1624                       airDropPot_ = (airDropPot_).sub(_prize);
1625 
1626                       // let event know a tier 2 prize was won
1627                       _eventData_.compressedData += 200000000000000000000000000000000;
1628                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1629                       // calculate prize and give it to winner
1630                       _prize = ((airDropPot_).mul(25)) / 100;
1631                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1632 
1633                       // adjust airDropPot
1634                       airDropPot_ = (airDropPot_).sub(_prize);
1635 
1636                       // let event know a tier 3 prize was won
1637                       _eventData_.compressedData += 300000000000000000000000000000000;
1638                   }
1639                   // set airdrop happened bool to true
1640                   _eventData_.compressedData += 10000000000000000000000000000000;
1641                   // let event know how much was won
1642                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1643 
1644                   // reset air drop tracker
1645                   airDropTracker_ = 0;
1646               }
1647           }
1648 
1649               // store the air drop tracker number (number of buys since last airdrop)
1650               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1651 
1652               // update player
1653               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1654               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1655 
1656               // update round
1657               round_[_rID].keys = _keys.add(round_[_rID].keys);
1658               round_[_rID].eth = _eth.add(round_[_rID].eth);
1659               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1660 
1661               // distribute eth
1662               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1663               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1664 
1665               // call end tx function to fire end tx event.
1666   		    endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1667           }
1668       } */
1669   //==============================================================================
1670   //     _ _ | _   | _ _|_ _  _ _  .
1671   //    (_(_||(_|_||(_| | (_)| _\  .
1672   //==============================================================================
1673       /**
1674        * @dev calculates unmasked earnings (just calculates, does not update mask)
1675        * @return earnings in wei format
1676        */
1677       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1678           private
1679           view
1680           returns(uint256)
1681       {
1682           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1683       }
1684 
1685       /**
1686        * @dev returns the amount of keys you would get given an amount of eth.
1687        * -functionhash- 0xce89c80c
1688        * @param _rID round ID you want price for
1689        * @param _eth amount of eth sent in
1690        * @return keys received
1691        */
1692       function calcKeysReceived(uint256 _rID, uint256 _eth)
1693           public
1694           view
1695           returns(uint256)
1696       {
1697           // grab time
1698           uint256 _now = now;
1699 
1700           // are we in a round?
1701           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1702               return ( (round_[_rID].eth).keysRec(_eth) );
1703           else // rounds over.  need keys for new round
1704               return ( (_eth).keys() );
1705       }
1706 
1707       /**
1708        * @dev returns current eth price for X keys.
1709        * -functionhash- 0xcf808000
1710        * @param _keys number of keys desired (in 18 decimal format)
1711        * @return amount of eth needed to send
1712        */
1713       function iWantXKeys(uint256 _keys)
1714           public
1715           view
1716           returns(uint256)
1717       {
1718           // setup local rID
1719           uint256 _rID = rID_;
1720 
1721           // grab time
1722           uint256 _now = now;
1723 
1724           // are we in a round?
1725           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1726               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1727           else // rounds over.  need price for new round
1728               return ( (_keys).eth() );
1729       }
1730   //==============================================================================
1731   //    _|_ _  _ | _  .
1732   //     | (_)(_)|_\  .
1733   //==============================================================================
1734       /**
1735   	 * @dev receives name/player info from names contract
1736        */
1737       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1738           external
1739       {
1740           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1741           if (pIDxAddr_[_addr] != _pID)
1742               pIDxAddr_[_addr] = _pID;
1743           if (pIDxName_[_name] != _pID)
1744               pIDxName_[_name] = _pID;
1745           if (plyr_[_pID].addr != _addr)
1746               plyr_[_pID].addr = _addr;
1747           if (plyr_[_pID].name != _name)
1748               plyr_[_pID].name = _name;
1749           if (plyr_[_pID].laff != _laff)
1750               plyr_[_pID].laff = _laff;
1751           if (plyrNames_[_pID][_name] == false)
1752               plyrNames_[_pID][_name] = true;
1753       }
1754 
1755       /**
1756        * @dev receives entire player name list
1757        */
1758       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1759           external
1760       {
1761           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1762           if(plyrNames_[_pID][_name] == false)
1763               plyrNames_[_pID][_name] = true;
1764       }
1765 
1766       /**
1767        * @dev gets existing or registers new pID.  use this when a player may be new
1768        * @return pID
1769        */
1770       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1771           private
1772           returns (F3Ddatasets.EventReturns)
1773       {
1774           uint256 _pID = pIDxAddr_[msg.sender];
1775           // if player is new to this version of fomo3d
1776           if (_pID == 0)
1777           {
1778               // grab their player ID, name and last aff ID, from player names contract
1779               _pID = PlayerBook.getPlayerID(msg.sender);
1780               bytes32 _name = PlayerBook.getPlayerName(_pID);
1781               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1782 
1783               // set up player account
1784               pIDxAddr_[msg.sender] = _pID;
1785               plyr_[_pID].addr = msg.sender;
1786 
1787               if (_name != "")
1788               {
1789                   pIDxName_[_name] = _pID;
1790                   plyr_[_pID].name = _name;
1791                   plyrNames_[_pID][_name] = true;
1792               }
1793 
1794               if (_laff != 0 && _laff != _pID)
1795                   plyr_[_pID].laff = _laff;
1796 
1797               // set the new player bool to true
1798               _eventData_.compressedData = _eventData_.compressedData + 1;
1799           }
1800           return (_eventData_);
1801       }
1802 
1803 
1804             /**
1805        * @dev gets existing or registers new pID.  use this when a player may be new
1806        * @return pID
1807        */
1808       function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1809           private
1810           returns (F3Ddatasets.EventReturns)
1811       {
1812           uint256 _pID = pIDxAddr_[_realSender];
1813           // if player is new to this version of fomo3d
1814           if (_pID == 0)
1815           {
1816               // grab their player ID, name and last aff ID, from player names contract
1817               _pID = PlayerBook.getPlayerID(_realSender);
1818               bytes32 _name = PlayerBook.getPlayerName(_pID);
1819               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1820 
1821               // set up player account
1822               pIDxAddr_[_realSender] = _pID;
1823               plyr_[_pID].addr = _realSender;
1824 
1825               if (_name != "")
1826               {
1827                   pIDxName_[_name] = _pID;
1828                   plyr_[_pID].name = _name;
1829                   plyrNames_[_pID][_name] = true;
1830               }
1831 
1832               if (_laff != 0 && _laff != _pID)
1833                   plyr_[_pID].laff = _laff;
1834 
1835               // set the new player bool to true
1836               _eventData_.compressedData = _eventData_.compressedData + 1;
1837           }
1838           return (_eventData_);
1839       }
1840 
1841       /**
1842        * @dev checks to make sure user picked a valid team.  if not sets team
1843        * to default (sneks)
1844        */
1845       function verifyTeam(uint256 _team)
1846           private
1847           pure
1848           returns (uint256)
1849       {
1850           if (_team < 0 || _team > 3)
1851               return(2);
1852           else
1853               return(_team);
1854       }
1855 
1856       /**
1857        * @dev decides if round end needs to be run & new round started.  and if
1858        * player unmasked earnings from previously played rounds need to be moved.
1859        */
1860       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1861           private
1862           returns (F3Ddatasets.EventReturns)
1863       {
1864           // if player has played a previous round, move their unmasked earnings
1865           // from that round to gen vault.
1866           if (plyr_[_pID].lrnd != 0)
1867               updateGenVault(_pID, plyr_[_pID].lrnd);
1868 
1869           // update player's last round played
1870           plyr_[_pID].lrnd = rID_;
1871 
1872           // set the joined round bool to true
1873           _eventData_.compressedData = _eventData_.compressedData + 10;
1874 
1875           return(_eventData_);
1876       }
1877 
1878       /**
1879        * @dev ends the round. manages paying out winner/splitting up pot
1880        */
1881       function endRound(F3Ddatasets.EventReturns memory _eventData_)
1882           private
1883           returns (F3Ddatasets.EventReturns)
1884       {
1885           // setup local rID
1886           uint256 _rID = rID_;
1887 
1888           // grab our winning player and team id's
1889           uint256 _winPID = round_[_rID].plyr;
1890           uint256 _winTID = round_[_rID].team;
1891 
1892           // grab our pot amount
1893           uint256 _pot = round_[_rID].pot;
1894 
1895           // calculate our winner share, community rewards, gen share,
1896           // p3d share, and amount reserved for next pot
1897           uint256 _win = (_pot.mul(48)) / 100;
1898           uint256 _com = (_pot / 50);
1899           uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1900           uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1901           uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1902 
1903           // calculate ppt for round mask
1904           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1905           uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1906           if (_dust > 0)
1907           {
1908               _gen = _gen.sub(_dust);
1909               _res = _res.add(_dust);
1910           }
1911 
1912           // pay our winner
1913           plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1914 
1915           // community rewards
1916 
1917           admin.transfer(_com);
1918 
1919           admin.transfer(_p3d.sub(_p3d / 2));
1920 
1921           round_[_rID].pot = _pot.add(_p3d / 2);
1922 
1923           // distribute gen portion to key holders
1924           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1925 
1926           // prepare event data
1927           _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1928           _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1929           _eventData_.winnerAddr = plyr_[_winPID].addr;
1930           _eventData_.winnerName = plyr_[_winPID].name;
1931           _eventData_.amountWon = _win;
1932           _eventData_.genAmount = _gen;
1933           _eventData_.P3DAmount = _p3d;
1934           _eventData_.newPot = _res;
1935 
1936           // start next round
1937           rID_++;
1938           _rID++;
1939           round_[_rID].strt = now;
1940           round_[_rID].end = now.add(rndInit_).add(rndGap_);
1941           round_[_rID].pot = _res;
1942 
1943           return(_eventData_);
1944       }
1945 
1946       /**
1947        * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1948        */
1949       function updateGenVault(uint256 _pID, uint256 _rIDlast)
1950           private
1951       {
1952           uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1953           if (_earnings > 0)
1954           {
1955               // put in gen vault
1956               plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1957               // zero out their earnings by updating mask
1958               plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1959           }
1960       }
1961 
1962       /**
1963        * @dev updates round timer based on number of whole keys bought.
1964        */
1965       function updateTimer(uint256 _keys, uint256 _rID)
1966           private
1967       {
1968           // grab time
1969           uint256 _now = now;
1970 
1971           // calculate time based on number of keys bought
1972           uint256 _newTime;
1973           if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1974               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1975           else
1976               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1977 
1978           // compare to max and set new end time
1979           if (_newTime < (rndMax_).add(_now))
1980               round_[_rID].end = _newTime;
1981           else
1982               round_[_rID].end = rndMax_.add(_now);
1983       }
1984 
1985       /**
1986        * @dev generates a random number between 0-99 and checks to see if thats
1987        * resulted in an airdrop win
1988        * @return do we have a winner?
1989        */
1990       function airdrop()
1991           private
1992           view
1993           returns(bool)
1994       {
1995           uint256 seed = uint256(keccak256(abi.encodePacked(
1996 
1997               (block.timestamp).add
1998               (block.difficulty).add
1999               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
2000               (block.gaslimit).add
2001               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
2002               (block.number)
2003 
2004           )));
2005           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
2006               return(true);
2007           else
2008               return(false);
2009       }
2010 
2011       /**
2012        * @dev distributes eth based on fees to com, aff, and p3d
2013        */
2014       function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
2015           private
2016           returns(F3Ddatasets.EventReturns)
2017       {
2018           // pay 3% out to community rewards
2019           uint256 _p1 = _eth / 100;
2020           uint256 _com = _eth / 50;
2021           _com = _com.add(_p1);
2022 
2023           uint256 _p3d;
2024           if (!address(admin).call.value(_com)())
2025           {
2026               // This ensures Team Just cannot influence the outcome of FoMo3D with
2027               // bank migrations by breaking outgoing transactions.
2028               // Something we would never do. But that's not the point.
2029               // We spent 2000$ in eth re-deploying just to patch this, we hold the
2030               // highest belief that everything we create should be trustless.
2031               // Team JUST, The name you shouldn't have to trust.
2032               _p3d = _com;
2033               _com = 0;
2034           }
2035 
2036 
2037           // distribute share to affiliate
2038           uint256 _aff = _eth / 10;
2039 
2040           // decide what to do with affiliate share of fees
2041           // affiliate must not be self, and must have a name registered
2042           if (_affID != _pID && plyr_[_affID].name != '') {
2043               plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
2044               emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
2045           } else {
2046               _p3d = _aff;
2047           }
2048 
2049           // pay out p3d
2050           _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
2051           if (_p3d > 0)
2052           {
2053               // deposit to divies contract
2054               uint256 _potAmount = _p3d / 2;
2055 
2056               admin.transfer(_p3d.sub(_potAmount));
2057 
2058               round_[_rID].pot = round_[_rID].pot.add(_potAmount);
2059 
2060               // set up event data
2061               _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
2062           }
2063 
2064           return(_eventData_);
2065       }
2066 
2067       function potSwap()
2068           external
2069           payable
2070       {
2071           // setup local rID
2072           uint256 _rID = rID_ + 1;
2073 
2074           round_[_rID].pot = round_[_rID].pot.add(msg.value);
2075           emit F3Devents.onPotSwapDeposit(_rID, msg.value);
2076       }
2077 
2078       /**
2079        * @dev distributes eth based on fees to gen and pot
2080        */
2081       function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2082           private
2083           returns(F3Ddatasets.EventReturns)
2084       {
2085           // calculate gen share
2086           uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
2087 
2088           // toss 1% into airdrop pot
2089           uint256 _air = (_eth / 100);
2090           airDropPot_ = airDropPot_.add(_air);
2091 
2092           // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
2093           _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
2094 
2095           // calculate pot
2096           uint256 _pot = _eth.sub(_gen);
2097 
2098           // distribute gen share (thats what updateMasks() does) and adjust
2099           // balances for dust.
2100           uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
2101           if (_dust > 0)
2102               _gen = _gen.sub(_dust);
2103 
2104           // add eth to pot
2105           round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
2106 
2107           // set up event data
2108           _eventData_.genAmount = _gen.add(_eventData_.genAmount);
2109           _eventData_.potAmount = _pot;
2110 
2111           return(_eventData_);
2112       }
2113 
2114       /**
2115        * @dev updates masks for round and player when keys are bought
2116        * @return dust left over
2117        */
2118       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
2119           private
2120           returns(uint256)
2121       {
2122           /* MASKING NOTES
2123               earnings masks are a tricky thing for people to wrap their minds around.
2124               the basic thing to understand here.  is were going to have a global
2125               tracker based on profit per share for each round, that increases in
2126               relevant proportion to the increase in share supply.
2127 
2128               the player will have an additional mask that basically says "based
2129               on the rounds mask, my shares, and how much i've already withdrawn,
2130               how much is still owed to me?"
2131           */
2132 
2133           // calc profit per key & round mask based on this buy:  (dust goes to pot)
2134           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
2135           round_[_rID].mask = _ppt.add(round_[_rID].mask);
2136 
2137           // calculate player earning from their own buy (only based on the keys
2138           // they just bought).  & update player earnings mask
2139           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
2140           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
2141 
2142           // calculate & return dust
2143           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
2144       }
2145 
2146       /**
2147        * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
2148        * @return earnings in wei format
2149        */
2150       function withdrawEarnings(uint256 _pID)
2151           private
2152           returns(uint256)
2153       {
2154           // update gen vault
2155           updateGenVault(_pID, plyr_[_pID].lrnd);
2156 
2157           // from vaults
2158           uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
2159           if (_earnings > 0)
2160           {
2161               plyr_[_pID].win = 0;
2162               plyr_[_pID].gen = 0;
2163               plyr_[_pID].aff = 0;
2164           }
2165 
2166           return(_earnings);
2167       }
2168 
2169       /**
2170        * @dev prepares compression data and fires event for buy or reload tx's
2171        */
2172       function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2173           private
2174       {
2175           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2176           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2177 
2178           emit F3Devents.onEndTx
2179           (
2180               _eventData_.compressedData,
2181               _eventData_.compressedIDs,
2182               plyr_[_pID].name,
2183               msg.sender,
2184               _eth,
2185               _keys,
2186               _eventData_.winnerAddr,
2187               _eventData_.winnerName,
2188               _eventData_.amountWon,
2189               _eventData_.newPot,
2190               _eventData_.P3DAmount,
2191               _eventData_.genAmount,
2192               _eventData_.potAmount,
2193               airDropPot_
2194           );
2195       }
2196 
2197             /**
2198        * @dev prepares compression data and fires event for buy or reload tx's
2199        */
2200       function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2201           private
2202       {
2203           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2204           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2205 
2206           emit F3Devents.onEndTx
2207           (
2208               _eventData_.compressedData,
2209               _eventData_.compressedIDs,
2210               plyr_[_pID].name,
2211               _realSender,
2212               _eth,
2213               _keys,
2214               _eventData_.winnerAddr,
2215               _eventData_.winnerName,
2216               _eventData_.amountWon,
2217               _eventData_.newPot,
2218               _eventData_.P3DAmount,
2219               _eventData_.genAmount,
2220               _eventData_.potAmount,
2221               airDropPot_
2222           );
2223       }
2224   //==============================================================================
2225   //    (~ _  _    _._|_    .
2226   //    _)(/_(_|_|| | | \/  .
2227   //====================/=========================================================
2228       /** upon contract deploy, it will be deactivated.  this is a one time
2229        * use function that will activate the contract.  we do this so devs
2230        * have time to set things up on the web end                            **/
2231       bool public activated_ = false;
2232       function activate()
2233           public
2234       {
2235           // only team just can activate
2236           require(msg.sender == admin, "only admin can activate");
2237 
2238 
2239           // can only be ran once
2240           require(activated_ == false, "FOMO Short already activated");
2241 
2242           // activate the contract
2243           activated_ = true;
2244 
2245           // lets start first round
2246           rID_ = 1;
2247               round_[1].strt = now + rndExtra_ - rndGap_;
2248               round_[1].end = now + rndInit_ + rndExtra_;
2249       }
2250   }