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
203     //compressedIDs key
204     // [77-52][51-26][25-0]
205         // 0-25 - pID
206         // 26-51 - winPID
207         // 52-77 - rID
208     struct EventReturns {
209         uint256 compressedData;
210         uint256 compressedIDs;
211         address winnerAddr;         // winner address
212         bytes32 winnerName;         // winner name
213         uint256 amountWon;          // amount won
214         uint256 newPot;             // amount in new pot
215         uint256 P3DAmount;          // amount distributed to p3d
216         uint256 genAmount;          // amount distributed to gen
217         uint256 potAmount;          // amount added to pot
218     }
219     struct Player {
220         address addr;   // player address
221         bytes32 name;   // player name
222         uint256 win;    // winnings vault
223         uint256 gen;    // general vault
224         uint256 aff;    // affiliate vault
225         uint256 lrnd;   // last round played
226         uint256 laff;   // last affiliate id used
227     }
228     struct PlayerRounds {
229         uint256 eth;    // eth player has added to round (used for eth limiter)
230         uint256 keys;   // keys
231         uint256 mask;   // player mask
232         uint256 ico;    // ICO phase investment
233     }
234     struct Round {
235         uint256 plyr;   // pID of player in lead
236         uint256 team;   // tID of team in lead
237         uint256 end;    // time ends/ended
238         bool ended;     // has round end function been ran
239         uint256 strt;   // time round started
240         uint256 keys;   // keys
241         uint256 eth;    // total eth in
242         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
243         uint256 mask;   // global mask
244         uint256 ico;    // total eth sent in during ICO phase
245         uint256 icoGen; // total eth for gen during ICO phase
246         uint256 icoAvg; // average key price for ICO phase
247     }
248     struct TeamFee {
249         uint256 gen;    // % of buy in thats paid to key holders of current round
250         uint256 p3d;    // % of buy in thats paid to p3d holders
251     }
252     struct PotSplit {
253         uint256 gen;    // % of pot thats paid to key holders of current round
254         uint256 p3d;    // % of pot thats paid to p3d holders
255     }
256 }
257 
258 //==============================================================================
259 //  |  _      _ _ | _  .
260 //  |<(/_\/  (_(_||(_  .
261 //=======/======================================================================
262 library F3DKeysCalcShort {
263     using SafeMath for *;
264     /**
265      * @dev calculates number of keys received given X eth
266      * @param _curEth current amount of eth in contract
267      * @param _newEth eth being spent
268      * @return amount of ticket purchased
269      */
270     function keysRec(uint256 _curEth, uint256 _newEth)
271         internal
272         pure
273         returns (uint256)
274     {
275         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
276     }
277 
278     /**
279      * @dev calculates amount of eth received if you sold X keys
280      * @param _curKeys current amount of keys that exist
281      * @param _sellKeys amount of keys you wish to sell
282      * @return amount of eth received
283      */
284     function ethRec(uint256 _curKeys, uint256 _sellKeys)
285         internal
286         pure
287         returns (uint256)
288     {
289         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
290     }
291 
292     /**
293      * @dev calculates how many keys would exist with given an amount of eth
294      * @param _eth eth "in contract"
295      * @return number of keys that would exist
296      */
297     function keys(uint256 _eth)
298         internal
299         pure
300         returns(uint256)
301     {
302         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
303     }
304 
305     /**
306      * @dev calculates how much eth would be in contract given a number of keys
307      * @param _keys number of keys "in contract"
308      * @return eth that would exists
309      */
310     function eth(uint256 _keys)
311         internal
312         pure
313         returns(uint256)
314     {
315         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
316     }
317 }
318 
319 //==============================================================================
320 //  . _ _|_ _  _ |` _  _ _  _  .
321 //  || | | (/_| ~|~(_|(_(/__\  .
322 //==============================================================================
323 
324 
325 contract F3Devents {
326     // fired whenever a player registers a name
327     event onNewName
328     (
329         uint256 indexed playerID,
330         address indexed playerAddress,
331         bytes32 indexed playerName,
332         bool isNewPlayer,
333         uint256 affiliateID,
334         address affiliateAddress,
335         bytes32 affiliateName,
336         uint256 amountPaid,
337         uint256 timeStamp
338     );
339 
340     // fired at end of buy or reload
341     event onEndTx
342     (
343         uint256 compressedData,
344         uint256 compressedIDs,
345         bytes32 playerName,
346         address playerAddress,
347         uint256 ethIn,
348         uint256 keysBought,
349         address winnerAddr,
350         bytes32 winnerName,
351         uint256 amountWon,
352         uint256 newPot,
353         uint256 P3DAmount,
354         uint256 genAmount,
355         uint256 potAmount,
356         uint256 airDropPot
357     );
358 
359 	// fired whenever theres a withdraw
360     event onWithdraw
361     (
362         uint256 indexed playerID,
363         address playerAddress,
364         bytes32 playerName,
365         uint256 ethOut,
366         uint256 timeStamp
367     );
368 
369     // fired whenever a withdraw forces end round to be ran
370     event onWithdrawAndDistribute
371     (
372         address playerAddress,
373         bytes32 playerName,
374         uint256 ethOut,
375         uint256 compressedData,
376         uint256 compressedIDs,
377         address winnerAddr,
378         bytes32 winnerName,
379         uint256 amountWon,
380         uint256 newPot,
381         uint256 P3DAmount,
382         uint256 genAmount
383     );
384 
385     // (fomo3d short only) fired whenever a player tries a buy after round timer
386     // hit zero, and causes end round to be ran.
387     event onBuyAndDistribute
388     (
389         address playerAddress,
390         bytes32 playerName,
391         uint256 ethIn,
392         uint256 compressedData,
393         uint256 compressedIDs,
394         address winnerAddr,
395         bytes32 winnerName,
396         uint256 amountWon,
397         uint256 newPot,
398         uint256 P3DAmount,
399         uint256 genAmount
400     );
401 
402     // (fomo3d short only) fired whenever a player tries a reload after round timer
403     // hit zero, and causes end round to be ran.
404     event onReLoadAndDistribute
405     (
406         address playerAddress,
407         bytes32 playerName,
408         uint256 compressedData,
409         uint256 compressedIDs,
410         address winnerAddr,
411         bytes32 winnerName,
412         uint256 amountWon,
413         uint256 newPot,
414         uint256 P3DAmount,
415         uint256 genAmount
416     );
417 
418     // fired whenever an affiliate is paid
419     event onAffiliatePayout
420     (
421         uint256 indexed affiliateID,
422         address affiliateAddress,
423         bytes32 affiliateName,
424         uint256 indexed roundID,
425         uint256 indexed buyerID,
426         uint256 amount,
427         uint256 timeStamp
428     );
429 
430     // received pot swap deposit
431     event onPotSwapDeposit
432     (
433         uint256 roundID,
434         uint256 amountAddedToPot
435     );
436 }
437 
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
450 
451 
452 contract modularFast is F3Devents {}
453 
454 
455 contract FoMo3DFast is modularFast {
456     using SafeMath for *;
457     using NameFilter for string;
458     using F3DKeysCalcShort for uint256;
459 
460     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xea07723857747Ae8b92Df3bCA6A67Fb85e586c6d);
461 
462     address private admin = msg.sender;
463     string constant public name = "FOMO Fast";
464     string constant public symbol = "FAST";
465     uint256 private rndExtra_ = 3 minutes;     // length of the very first ICO
466     uint256 private rndGap_ = 3 minutes;         // length of ICO phase, set to 1 year for EOS.
467     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
468     uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
469     uint256 constant private rndMax_ = 8 hours;                // max length a round timer can be
470     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
471     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
472     uint256 public rID_;    // round id number / total rounds that have happened
473   //****************
474   // PLAYER DATA
475   //****************
476     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
477     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
478     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
479     // (pID => rID => data) player round data by player id & round id
480     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
481     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
482   //****************
483   // ROUND DATA
484   //****************
485     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
486     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
487   //****************
488   // TEAM FEE DATA
489   //****************
490     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
491     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
492 
493     constructor()
494         public
495     {
496     // Team allocation structures
497         // 0 = whales
498         // 1 = bears
499         // 2 = sneks
500         // 3 = bulls
501 
502     // Team allocation percentages
503         // (F3D, P3D) + (Pot , Referrals, Community)  解读:TeamFee, PotSplit 第一个参数都是分给现在key holder的比例, 第二个是给Pow3D的比例
504             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
505         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
506         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
507         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
508         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
509 
510         // how to split up the final pot based on which team was picked
511         // (F3D, P3D)
512         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
513         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
514         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
515         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
516   	}
517   //==============================================================================
518   //     _ _  _  _|. |`. _  _ _  .
519   //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
520   //==============================================================================
521       /**
522        * @dev used to make sure no one can interact with contract until it has
523        * been activated.
524        */
525       modifier isActivated() {
526           require(activated_ == true, "its not ready yet.  check ?eta in discord");
527           _;
528       }
529 
530       /**
531        * @dev prevents contracts from interacting with fomo3d
532        */
533       modifier isHuman() {
534           address _addr = msg.sender;
535           uint256 _codeLength;
536 
537           assembly {_codeLength := extcodesize(_addr)}
538           require(_codeLength == 0, "sorry humans only");
539           _;
540       }
541 
542       /**
543        * @dev sets boundaries for incoming tx
544        */
545       modifier isWithinLimits(uint256 _eth) {
546           require(_eth >= 1000000000, "pocket lint: not a valid currency");
547           require(_eth <= 100000000000000000000000, "no vitalik, no");
548           _;
549       }
550 
551   //==============================================================================
552   //     _    |_ |. _   |`    _  __|_. _  _  _  .
553   //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
554   //====|=========================================================================
555       /**
556        * @dev emergency buy uses last stored affiliate ID and team snek
557        */
558       function()
559           isActivated()
560           isHuman()
561           isWithinLimits(msg.value)
562           public
563           payable
564       {
565           // set up our tx event data and determine if player is new or not
566           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
567 
568           // fetch player id
569           uint256 _pID = pIDxAddr_[msg.sender];
570 
571           // buy core
572           buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
573       }
574 
575       /**
576        * @dev converts all incoming ethereum to keys.
577        * -functionhash- 0x8f38f309 (using ID for affiliate)
578        * -functionhash- 0x98a0871d (using address for affiliate)
579        * -functionhash- 0xa65b37a1 (using name for affiliate)
580        * @param _affCode the ID/address/name of the player who gets the affiliate fee
581        * @param _team what team is the player playing for?
582        */
583       function buyXid(uint256 _affCode, uint256 _team)
584           isActivated()
585           isHuman()
586           isWithinLimits(msg.value)
587           public
588           payable
589       {
590           // set up our tx event data and determine if player is new or not
591           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
592 
593           // fetch player id
594           uint256 _pID = pIDxAddr_[msg.sender];
595 
596           // manage affiliate residuals
597           // if no affiliate code was given or player tried to use their own, lolz
598           if (_affCode == 0 || _affCode == _pID)
599           {
600               // use last stored affiliate code
601               _affCode = plyr_[_pID].laff;
602 
603           // if affiliate code was given & its not the same as previously stored
604           } else if (_affCode != plyr_[_pID].laff) {
605               // update last affiliate
606               plyr_[_pID].laff = _affCode;
607           }
608 
609           // verify a valid team was selected
610           _team = verifyTeam(_team);
611 
612           // buy core
613           buyCore(_pID, _affCode, _team, _eventData_);
614       }
615 
616       function buyXaddr(address _affCode, uint256 _team)
617           isActivated()
618           isWithinLimits(msg.value)
619           public
620           payable
621       {
622           // set up our tx event data and determine if player is new or not
623           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
624 
625           // fetch player id
626           uint256 _pID = pIDxAddr_[msg.sender];
627 
628           // manage affiliate residuals
629           uint256 _affID;
630           // if no affiliate code was given or player tried to use their own, lolz
631           if (_affCode == address(0) || _affCode == msg.sender)
632           {
633               // use last stored affiliate code
634               _affID = plyr_[_pID].laff;
635 
636           // if affiliate code was given
637           } else {
638               // get affiliate ID from aff Code
639               _affID = pIDxAddr_[_affCode];
640 
641               // if affID is not the same as previously stored
642               if (_affID != plyr_[_pID].laff)
643               {
644                   // update last affiliate
645                   plyr_[_pID].laff = _affID;
646               }
647           }
648 
649           // verify a valid team was selected
650           _team = verifyTeam(_team);
651 
652           // buy core
653           buyCore(_pID, _affID, _team, _eventData_);
654       }
655 
656       function buyXname(bytes32 _affCode, uint256 _team)
657           isActivated()
658           isHuman()
659           isWithinLimits(msg.value)
660           public
661           payable
662       {
663           // set up our tx event data and determine if player is new or not
664           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
665 
666           // fetch player id
667           uint256 _pID = pIDxAddr_[msg.sender];
668 
669           // manage affiliate residuals
670           uint256 _affID;
671           // if no affiliate code was given or player tried to use their own, lolz
672           if (_affCode == '' || _affCode == plyr_[_pID].name)
673           {
674               // use last stored affiliate code
675               _affID = plyr_[_pID].laff;
676 
677           // if affiliate code was given
678           } else {
679               // get affiliate ID from aff Code
680               _affID = pIDxName_[_affCode];
681 
682               // if affID is not the same as previously stored
683               if (_affID != plyr_[_pID].laff)
684               {
685                   // update last affiliate
686                   plyr_[_pID].laff = _affID;
687               }
688           }
689 
690           // verify a valid team was selected
691           _team = verifyTeam(_team);
692 
693           // buy core
694           buyCore(_pID, _affID, _team, _eventData_);
695       }
696 
697 
698        function buyXnameQR(address _realSender,bytes32 _affCode, uint256 _team)
699           isActivated()
700           isWithinLimits(msg.value)
701           public
702           payable
703       {
704           // set up our tx event data and determine if player is new or not
705           F3Ddatasets.EventReturns memory _eventData_ = determinePIDQR(_realSender,_eventData_);
706 
707           // fetch player id
708           uint256 _pID = pIDxAddr_[_realSender];
709 
710           // manage affiliate residuals
711           uint256 _affID;
712           // if no affiliate code was given or player tried to use their own, lolz
713           if (_affCode == '' || _affCode == plyr_[_pID].name)
714           {
715               // use last stored affiliate code
716               _affID = plyr_[_pID].laff;
717 
718           // if affiliate code was given
719           } else {
720               // get affiliate ID from aff Code
721               _affID = pIDxName_[_affCode];
722 
723               // if affID is not the same as previously stored
724               if (_affID != plyr_[_pID].laff)
725               {
726                   // update last affiliate
727                   plyr_[_pID].laff = _affID;
728               }
729           }
730 
731           // verify a valid team was selected
732           _team = verifyTeam(_team);
733 
734           // buy core
735           buyCoreQR(_realSender, _pID, _affID, _team, _eventData_);
736       }
737 
738       /**
739        * @dev essentially the same as buy, but instead of you sending ether
740        * from your wallet, it uses your unwithdrawn earnings.
741        * -functionhash- 0x349cdcac (using ID for affiliate)
742        * -functionhash- 0x82bfc739 (using address for affiliate)
743        * -functionhash- 0x079ce327 (using name for affiliate)
744        * @param _affCode the ID/address/name of the player who gets the affiliate fee
745        * @param _team what team is the player playing for?
746        * @param _eth amount of earnings to use (remainder returned to gen vault)
747        */
748       function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
749           isActivated()
750           isHuman()
751           isWithinLimits(_eth)
752           public
753       {
754           // set up our tx event data
755           F3Ddatasets.EventReturns memory _eventData_;
756 
757           // fetch player ID
758           uint256 _pID = pIDxAddr_[msg.sender];
759 
760           // manage affiliate residuals
761           // if no affiliate code was given or player tried to use their own, lolz
762           if (_affCode == 0 || _affCode == _pID)
763           {
764               // use last stored affiliate code
765               _affCode = plyr_[_pID].laff;
766 
767           // if affiliate code was given & its not the same as previously stored
768           } else if (_affCode != plyr_[_pID].laff) {
769               // update last affiliate
770               plyr_[_pID].laff = _affCode;
771           }
772 
773           // verify a valid team was selected
774           _team = verifyTeam(_team);
775 
776           // reload core
777           reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
778       }
779 
780       function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
781           isActivated()
782           isHuman()
783           isWithinLimits(_eth)
784           public
785       {
786           // set up our tx event data
787           F3Ddatasets.EventReturns memory _eventData_;
788 
789           // fetch player ID
790           uint256 _pID = pIDxAddr_[msg.sender];
791 
792           // manage affiliate residuals
793           uint256 _affID;
794           // if no affiliate code was given or player tried to use their own, lolz
795           if (_affCode == address(0) || _affCode == msg.sender)
796           {
797               // use last stored affiliate code
798               _affID = plyr_[_pID].laff;
799 
800           // if affiliate code was given
801           } else {
802               // get affiliate ID from aff Code
803               _affID = pIDxAddr_[_affCode];
804 
805               // if affID is not the same as previously stored
806               if (_affID != plyr_[_pID].laff)
807               {
808                   // update last affiliate
809                   plyr_[_pID].laff = _affID;
810               }
811           }
812 
813           // verify a valid team was selected
814           _team = verifyTeam(_team);
815 
816           // reload core
817           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
818       }
819 
820       function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
821           isActivated()
822           isHuman()
823           isWithinLimits(_eth)
824           public
825       {
826           // set up our tx event data
827           F3Ddatasets.EventReturns memory _eventData_;
828 
829           // fetch player ID
830           uint256 _pID = pIDxAddr_[msg.sender];
831 
832           // manage affiliate residuals
833           uint256 _affID;
834           // if no affiliate code was given or player tried to use their own, lolz
835           if (_affCode == '' || _affCode == plyr_[_pID].name)
836           {
837               // use last stored affiliate code
838               _affID = plyr_[_pID].laff;
839 
840           // if affiliate code was given
841           } else {
842               // get affiliate ID from aff Code
843               _affID = pIDxName_[_affCode];
844 
845               // if affID is not the same as previously stored
846               if (_affID != plyr_[_pID].laff)
847               {
848                   // update last affiliate
849                   plyr_[_pID].laff = _affID;
850               }
851           }
852 
853           // verify a valid team was selected
854           _team = verifyTeam(_team);
855 
856           // reload core
857           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
858       }
859 
860       /**
861        * @dev withdraws all of your earnings.
862        * -functionhash- 0x3ccfd60b
863        */
864       function withdraw()
865           isActivated()
866           isHuman()
867           public
868       {
869           // setup local rID
870           uint256 _rID = rID_;
871 
872           // grab time
873           uint256 _now = now;
874 
875           // fetch player ID
876           uint256 _pID = pIDxAddr_[msg.sender];
877 
878           // setup temp var for player eth
879           uint256 _eth;
880 
881           // check to see if round has ended and no one has run round end yet
882           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
883           {
884               // set up our tx event data
885               F3Ddatasets.EventReturns memory _eventData_;
886 
887               // end the round (distributes pot)
888   			round_[_rID].ended = true;
889               _eventData_ = endRound(_eventData_);
890 
891   			// get their earnings
892               _eth = withdrawEarnings(_pID);
893 
894               // gib moni
895               if (_eth > 0)
896                   plyr_[_pID].addr.transfer(_eth);
897 
898               // build event data
899               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
900               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
901 
902               // fire withdraw and distribute event
903               emit F3Devents.onWithdrawAndDistribute
904               (
905                   msg.sender,
906                   plyr_[_pID].name,
907                   _eth,
908                   _eventData_.compressedData,
909                   _eventData_.compressedIDs,
910                   _eventData_.winnerAddr,
911                   _eventData_.winnerName,
912                   _eventData_.amountWon,
913                   _eventData_.newPot,
914                   _eventData_.P3DAmount,
915                   _eventData_.genAmount
916               );
917 
918           // in any other situation
919           } else {
920               // get their earnings
921               _eth = withdrawEarnings(_pID);
922 
923               // gib moni
924               if (_eth > 0)
925                   plyr_[_pID].addr.transfer(_eth);
926 
927               // fire withdraw event
928               emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
929           }
930       }
931 
932     /**
933        * @dev withdraws all of your earnings.
934        * -functionhash- 0x3ccfd60b
935        */
936       function withdrawQR(address _realSender)
937           isActivated()
938           payable
939           public
940       {
941           // setup local rID
942           uint256 _rID = rID_;
943 
944           // grab time
945           uint256 _now = now;
946 
947           // fetch player ID
948           uint256 _pID = pIDxAddr_[_realSender];
949 
950           // setup temp var for player eth
951           uint256 _eth;
952 
953           // check to see if round has ended and no one has run round end yet
954           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
955           {
956               // set up our tx event data
957               F3Ddatasets.EventReturns memory _eventData_;
958 
959               // end the round (distributes pot)
960   			round_[_rID].ended = true;
961               _eventData_ = endRound(_eventData_);
962 
963   			// get their earnings
964               _eth = withdrawEarnings(_pID);
965 
966               // gib moni
967               if (_eth > 0)
968                   plyr_[_pID].addr.transfer(_eth);
969 
970               // build event data
971               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
972               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
973 
974               // fire withdraw and distribute event
975               emit F3Devents.onWithdrawAndDistribute
976               (
977                   _realSender,
978                   plyr_[_pID].name,
979                   _eth,
980                   _eventData_.compressedData,
981                   _eventData_.compressedIDs,
982                   _eventData_.winnerAddr,
983                   _eventData_.winnerName,
984                   _eventData_.amountWon,
985                   _eventData_.newPot,
986                   _eventData_.P3DAmount,
987                   _eventData_.genAmount
988               );
989 
990           // in any other situation
991           } else {
992               // get their earnings
993               _eth = withdrawEarnings(_pID);
994 
995               // gib moni
996               if (_eth > 0)
997                   plyr_[_pID].addr.transfer(_eth);
998 
999               // fire withdraw event
1000               emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
1001           }
1002       }
1003 
1004       /**
1005        * @dev use these to register names.  they are just wrappers that will send the
1006        * registration requests to the PlayerBook contract.  So registering here is the
1007        * same as registering there.  UI will always display the last name you registered.
1008        * but you will still own all previously registered names to use as affiliate
1009        * links.
1010        * - must pay a registration fee.
1011        * - name must be unique
1012        * - names will be converted to lowercase
1013        * - name cannot start or end with a space
1014        * - cannot have more than 1 space in a row
1015        * - cannot be only numbers
1016        * - cannot start with 0x
1017        * - name must be at least 1 char
1018        * - max length of 32 characters long
1019        * - allowed characters: a-z, 0-9, and space
1020        * -functionhash- 0x921dec21 (using ID for affiliate)
1021        * -functionhash- 0x3ddd4698 (using address for affiliate)
1022        * -functionhash- 0x685ffd83 (using name for affiliate)
1023        * @param _nameString players desired name
1024        * @param _affCode affiliate ID, address, or name of who referred you
1025        * @param _all set to true if you want this to push your info to all games
1026        * (this might cost a lot of gas)
1027        */
1028 
1029       function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1030           isHuman()
1031           public
1032           payable
1033       {
1034           bytes32 _name = _nameString.nameFilter();
1035           address _addr = msg.sender;
1036           uint256 _paid = msg.value;
1037           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
1038 
1039           uint256 _pID = pIDxAddr_[_addr];
1040 
1041           // fire event
1042           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1043       }
1044 
1045       function registerNameXaddr(string _nameString, address _affCode, bool _all)
1046           isHuman()
1047           public
1048           payable
1049       {
1050           bytes32 _name = _nameString.nameFilter();
1051           address _addr = msg.sender;
1052           uint256 _paid = msg.value;
1053           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1054 
1055           uint256 _pID = pIDxAddr_[_addr];
1056 
1057           // fire event
1058           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1059       }
1060 
1061       function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1062           isHuman()
1063           public
1064           payable
1065       {
1066           bytes32 _name = _nameString.nameFilter();
1067           address _addr = msg.sender;
1068           uint256 _paid = msg.value;
1069           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1070 
1071           uint256 _pID = pIDxAddr_[_addr];
1072 
1073           // fire event
1074           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1075       }
1076 
1077 
1078   //==============================================================================
1079   //     _  _ _|__|_ _  _ _  .
1080   //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1081   //=====_|=======================================================================
1082       /**
1083        * @dev return the price buyer will pay for next 1 individual key.
1084        * -functionhash- 0x018a25e8
1085        * @return price for next key bought (in wei format)
1086        */
1087       function getBuyPrice()
1088           public
1089           view
1090           returns(uint256)
1091       {
1092           // setup local rID
1093           uint256 _rID = rID_;
1094 
1095           // grab time
1096           uint256 _now = now;
1097 
1098           // are we in a round?
1099           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1100               return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1101           else // rounds over.  need price for new round
1102               return ( 75000000000000 ); // init
1103       }
1104 
1105       /**
1106        * @dev returns time left.  dont spam this, you'll ddos yourself from your node
1107        * provider
1108        * -functionhash- 0xc7e284b8
1109        * @return time left in seconds
1110        */
1111       function getTimeLeft()
1112           public
1113           view
1114           returns(uint256)
1115       {
1116           // setup local rID
1117           uint256 _rID = rID_;
1118 
1119           // grab time
1120           uint256 _now = now;
1121 
1122           if (_now < round_[_rID].end)
1123               if (_now > round_[_rID].strt + rndGap_)
1124                   return( (round_[_rID].end).sub(_now) );
1125               else
1126                   return( (round_[_rID].strt + rndGap_).sub(_now) );
1127           else
1128               return(0);
1129       }
1130 
1131       /**
1132        * @dev returns player earnings per vaults
1133        * -functionhash- 0x63066434
1134        * @return winnings vault
1135        * @return general vault
1136        * @return affiliate vault
1137        */
1138       function getPlayerVaults(uint256 _pID)
1139           public
1140           view
1141           returns(uint256 ,uint256, uint256)
1142       {
1143           // setup local rID
1144           uint256 _rID = rID_;
1145 
1146           // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1147           if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1148           {
1149               // if player is winner
1150               if (round_[_rID].plyr == _pID)
1151               {
1152                   return
1153                   (
1154                       (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1155                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1156                       plyr_[_pID].aff
1157                   );
1158               // if player is not the winner
1159               } else {
1160                   return
1161                   (
1162                       plyr_[_pID].win,
1163                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1164                       plyr_[_pID].aff
1165                   );
1166               }
1167 
1168           // if round is still going on, or round has ended and round end has been ran
1169           } else {
1170               return
1171               (
1172                   plyr_[_pID].win,
1173                   (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1174                   plyr_[_pID].aff
1175               );
1176           }
1177       }
1178 
1179       /**
1180        * solidity hates stack limits.  this lets us avoid that hate
1181        */
1182       function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1183           private
1184           view
1185           returns(uint256)
1186       {
1187           return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1188       }
1189 
1190       /**
1191        * @dev returns all current round info needed for front end
1192        * -functionhash- 0x747dff42
1193        * @return eth invested during ICO phase
1194        * @return round id
1195        * @return total keys for round
1196        * @return time round ends
1197        * @return time round started
1198        * @return current pot
1199        * @return current team ID & player ID in lead
1200        * @return current player in leads address
1201        * @return current player in leads name
1202        * @return whales eth in for round
1203        * @return bears eth in for round
1204        * @return sneks eth in for round
1205        * @return bulls eth in for round
1206        * @return airdrop tracker # & airdrop pot
1207        */
1208       function getCurrentRoundInfo()
1209           public
1210           view
1211           returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1212       {
1213           // setup local rID
1214           uint256 _rID = rID_;
1215 
1216           return
1217           (
1218               round_[_rID].ico,               //0
1219               _rID,                           //1
1220               round_[_rID].keys,              //2
1221               round_[_rID].end,               //3
1222               round_[_rID].strt,              //4
1223               round_[_rID].pot,               //5
1224               (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1225               plyr_[round_[_rID].plyr].addr,  //7
1226               plyr_[round_[_rID].plyr].name,  //8
1227               rndTmEth_[_rID][0],             //9
1228               rndTmEth_[_rID][1],             //10
1229               rndTmEth_[_rID][2],             //11
1230               rndTmEth_[_rID][3],             //12
1231               airDropTracker_ + (airDropPot_ * 1000)              //13
1232           );
1233       }
1234 
1235       /**
1236        * @dev returns player info based on address.  if no address is given, it will
1237        * use msg.sender
1238        * -functionhash- 0xee0b5d8b
1239        * @param _addr address of the player you want to lookup
1240        * @return player ID
1241        * @return player name
1242        * @return keys owned (current round)
1243        * @return winnings vault
1244        * @return general vault
1245        * @return affiliate vault
1246   	 * @return player round eth
1247        */
1248       function getPlayerInfoByAddress(address _addr)
1249           public
1250           view
1251           returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1252       {
1253           // setup local rID
1254           uint256 _rID = rID_;
1255 
1256           if (_addr == address(0))
1257           {
1258               _addr == msg.sender;
1259           }
1260           uint256 _pID = pIDxAddr_[_addr];
1261 
1262           return
1263           (
1264               _pID,                               //0
1265               plyr_[_pID].name,                   //1
1266               plyrRnds_[_pID][_rID].keys,         //2
1267               plyr_[_pID].win,                    //3
1268               (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1269               plyr_[_pID].aff,                    //5
1270               plyrRnds_[_pID][_rID].eth           //6
1271           );
1272       }
1273 
1274   //==============================================================================
1275   //     _ _  _ _   | _  _ . _  .
1276   //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1277   //=====================_|=======================================================
1278       /**
1279        * @dev logic runs whenever a buy order is executed.  determines how to handle
1280        * incoming eth depending on if we are in an active round or not
1281        */
1282       function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1283           private
1284       {
1285           // setup local rID
1286           uint256 _rID = rID_;
1287 
1288           // grab time
1289           uint256 _now = now;
1290 
1291           // if round is active
1292           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1293           {
1294               // call core
1295               core(address(0), _rID, _pID, msg.value, _affID, _team, _eventData_);
1296 
1297           // if round is not active
1298           } else {
1299               // check to see if end round needs to be ran
1300               if (_now > round_[_rID].end && round_[_rID].ended == false)
1301               {
1302                   // end the round (distributes pot) & start new round
1303   			    round_[_rID].ended = true;
1304                   _eventData_ = endRound(_eventData_);
1305 
1306                   // build event data
1307                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1308                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1309 
1310                   // fire buy and distribute event
1311                   emit F3Devents.onBuyAndDistribute
1312                   (
1313                       msg.sender,
1314                       plyr_[_pID].name,
1315                       msg.value,
1316                       _eventData_.compressedData,
1317                       _eventData_.compressedIDs,
1318                       _eventData_.winnerAddr,
1319                       _eventData_.winnerName,
1320                       _eventData_.amountWon,
1321                       _eventData_.newPot,
1322                       _eventData_.P3DAmount,
1323                       _eventData_.genAmount
1324                   );
1325               }
1326 
1327               // put eth in players vault
1328               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1329           }
1330       }
1331 
1332        /**
1333        * @dev logic runs whenever a buy order is executed.  determines how to handle
1334        * incoming eth depending on if we are in an active round or not
1335        */
1336       function buyCoreQR(address _realSender,uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1337           private
1338       {
1339           // setup local rID
1340           uint256 _rID = rID_;
1341 
1342           // grab time
1343           uint256 _now = now;
1344 
1345           // if round is active
1346           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1347           {
1348               // call core
1349               core(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1350 
1351           // if round is not active
1352           } else {
1353               // check to see if end round needs to be ran
1354               if (_now > round_[_rID].end && round_[_rID].ended == false)
1355               {
1356                   // end the round (distributes pot) & start new round
1357   			    round_[_rID].ended = true;
1358                   _eventData_ = endRound(_eventData_);
1359 
1360                   // build event data
1361                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1362                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1363 
1364                   // fire buy and distribute event
1365                   emit F3Devents.onBuyAndDistribute
1366                   (
1367                       _realSender,
1368                       plyr_[_pID].name,
1369                       msg.value,
1370                       _eventData_.compressedData,
1371                       _eventData_.compressedIDs,
1372                       _eventData_.winnerAddr,
1373                       _eventData_.winnerName,
1374                       _eventData_.amountWon,
1375                       _eventData_.newPot,
1376                       _eventData_.P3DAmount,
1377                       _eventData_.genAmount
1378                   );
1379               }
1380 
1381               // put eth in players vault
1382               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1383           }
1384       }
1385 
1386       /**
1387        * @dev logic runs whenever a reload order is executed.  determines how to handle
1388        * incoming eth depending on if we are in an active round or not
1389        */
1390       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1391           private
1392       {
1393           // setup local rID
1394           uint256 _rID = rID_;
1395 
1396           // grab time
1397           uint256 _now = now;
1398 
1399           // if round is active
1400           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1401           {
1402               // get earnings from all vaults and return unused to gen vault
1403               // because we use a custom safemath library.  this will throw if player
1404               // tried to spend more eth than they have.
1405               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1406 
1407               // call core
1408               core(address(0), _rID, _pID, _eth, _affID, _team, _eventData_);
1409 
1410           // if round is not active and end round needs to be ran
1411           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1412               // end the round (distributes pot) & start new round
1413               round_[_rID].ended = true;
1414               _eventData_ = endRound(_eventData_);
1415 
1416               // build event data
1417               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1418               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1419 
1420               // fire buy and distribute event
1421               emit F3Devents.onReLoadAndDistribute
1422               (
1423                   msg.sender,
1424                   plyr_[_pID].name,
1425                   _eventData_.compressedData,
1426                   _eventData_.compressedIDs,
1427                   _eventData_.winnerAddr,
1428                   _eventData_.winnerName,
1429                   _eventData_.amountWon,
1430                   _eventData_.newPot,
1431                   _eventData_.P3DAmount,
1432                   _eventData_.genAmount
1433               );
1434           }
1435       }
1436 
1437       /**
1438        * @dev this is the core logic for any buy/reload that happens while a round
1439        * is live.
1440        */
1441       function core(address _realSender, uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1442           private
1443       {
1444           // if player is new to round
1445           if (plyrRnds_[_pID][_rID].keys == 0)
1446               _eventData_ = managePlayer(_pID, _eventData_);
1447 
1448           // early round eth limiter
1449           if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1450           {
1451               uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1452               uint256 _refund = _eth.sub(_availableLimit);
1453               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1454               _eth = _availableLimit;
1455           }
1456 
1457           // if eth left is greater than min eth allowed (sorry no pocket lint)
1458           if (_eth > 1000000000)
1459           {
1460 
1461               // mint the new keys
1462               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1463 
1464               // if they bought at least 1 whole key
1465               if (_keys >= 1000000000000000000)
1466               {
1467               updateTimer(_keys, _rID);
1468 
1469               // set new leaders
1470               if (round_[_rID].plyr != _pID)
1471                   round_[_rID].plyr = _pID;
1472               if (round_[_rID].team != _team)
1473                   round_[_rID].team = _team;
1474 
1475               // set the new leader bool to true
1476               _eventData_.compressedData = _eventData_.compressedData + 100;
1477           }
1478 
1479               // manage airdrops
1480               if (_eth >= 100000000000000000)
1481               {
1482               airDropTracker_++;
1483               if (airdrop() == true)
1484               {
1485                   // gib muni
1486                   uint256 _prize;
1487                   if (_eth >= 10000000000000000000)
1488                   {
1489                       // calculate prize and give it to winner
1490                       _prize = ((airDropPot_).mul(75)) / 100;
1491                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1492 
1493                       // adjust airDropPot
1494                       airDropPot_ = (airDropPot_).sub(_prize);
1495 
1496                       // let event know a tier 3 prize was won
1497                       _eventData_.compressedData += 300000000000000000000000000000000;
1498                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1499                       // calculate prize and give it to winner
1500                       _prize = ((airDropPot_).mul(50)) / 100;
1501                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1502 
1503                       // adjust airDropPot
1504                       airDropPot_ = (airDropPot_).sub(_prize);
1505 
1506                       // let event know a tier 2 prize was won
1507                       _eventData_.compressedData += 200000000000000000000000000000000;
1508                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1509                       // calculate prize and give it to winner
1510                       _prize = ((airDropPot_).mul(25)) / 100;
1511                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1512 
1513                       // adjust airDropPot
1514                       airDropPot_ = (airDropPot_).sub(_prize);
1515 
1516                       // let event know a tier 3 prize was won
1517                       _eventData_.compressedData += 300000000000000000000000000000000;
1518                   }
1519                   // set airdrop happened bool to true
1520                   _eventData_.compressedData += 10000000000000000000000000000000;
1521                   // let event know how much was won
1522                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1523 
1524                   // reset air drop tracker
1525                   airDropTracker_ = 0;
1526               }
1527           }
1528 
1529               // store the air drop tracker number (number of buys since last airdrop)
1530               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1531 
1532               // update player
1533               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1534               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1535 
1536               // update round
1537               round_[_rID].keys = _keys.add(round_[_rID].keys);
1538               round_[_rID].eth = _eth.add(round_[_rID].eth);
1539               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1540 
1541               // distribute eth
1542               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1543               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1544 
1545               // call end tx function to fire end tx event.
1546               if (_realSender==address(0)) {
1547 	              endTx(_pID, _team, _eth, _keys, _eventData_);
1548 	            } else {
1549 	              endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1550               }
1551           }
1552       }
1553 
1554 
1555 
1556             /**
1557        * @dev this is the core logic for any buy/reload that happens while a round
1558        * is live.
1559        */
1560       /* function coreQR(address _realSender,uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1561           private
1562       {
1563           // if player is new to round
1564           if (plyrRnds_[_pID][_rID].keys == 0)
1565               _eventData_ = managePlayer(_pID, _eventData_);
1566 
1567           // early round eth limiter
1568           if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1569           {
1570               uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1571               uint256 _refund = _eth.sub(_availableLimit);
1572               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1573               _eth = _availableLimit;
1574           }
1575 
1576           // if eth left is greater than min eth allowed (sorry no pocket lint)
1577           if (_eth > 1000000000)
1578           {
1579 
1580               // mint the new keys
1581               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1582 
1583               // if they bought at least 1 whole key
1584               if (_keys >= 1000000000000000000)
1585               {
1586               updateTimer(_keys, _rID);
1587 
1588               // set new leaders
1589               if (round_[_rID].plyr != _pID)
1590                   round_[_rID].plyr = _pID;
1591               if (round_[_rID].team != _team)
1592                   round_[_rID].team = _team;
1593 
1594               // set the new leader bool to true
1595               _eventData_.compressedData = _eventData_.compressedData + 100;
1596           }
1597 
1598               // manage airdrops
1599               if (_eth >= 100000000000000000)
1600               {
1601               airDropTracker_++;
1602               if (airdrop() == true)
1603               {
1604                   // gib muni
1605                   uint256 _prize;
1606                   if (_eth >= 10000000000000000000)
1607                   {
1608                       // calculate prize and give it to winner
1609                       _prize = ((airDropPot_).mul(75)) / 100;
1610                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1611 
1612                       // adjust airDropPot
1613                       airDropPot_ = (airDropPot_).sub(_prize);
1614 
1615                       // let event know a tier 3 prize was won
1616                       _eventData_.compressedData += 300000000000000000000000000000000;
1617                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1618                       // calculate prize and give it to winner
1619                       _prize = ((airDropPot_).mul(50)) / 100;
1620                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1621 
1622                       // adjust airDropPot
1623                       airDropPot_ = (airDropPot_).sub(_prize);
1624 
1625                       // let event know a tier 2 prize was won
1626                       _eventData_.compressedData += 200000000000000000000000000000000;
1627                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1628                       // calculate prize and give it to winner
1629                       _prize = ((airDropPot_).mul(25)) / 100;
1630                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1631 
1632                       // adjust airDropPot
1633                       airDropPot_ = (airDropPot_).sub(_prize);
1634 
1635                       // let event know a tier 3 prize was won
1636                       _eventData_.compressedData += 300000000000000000000000000000000;
1637                   }
1638                   // set airdrop happened bool to true
1639                   _eventData_.compressedData += 10000000000000000000000000000000;
1640                   // let event know how much was won
1641                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1642 
1643                   // reset air drop tracker
1644                   airDropTracker_ = 0;
1645               }
1646           }
1647 
1648               // store the air drop tracker number (number of buys since last airdrop)
1649               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1650 
1651               // update player
1652               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1653               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1654 
1655               // update round
1656               round_[_rID].keys = _keys.add(round_[_rID].keys);
1657               round_[_rID].eth = _eth.add(round_[_rID].eth);
1658               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1659 
1660               // distribute eth
1661               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1662               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1663 
1664               // call end tx function to fire end tx event.
1665   		    endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1666           }
1667       } */
1668   //==============================================================================
1669   //     _ _ | _   | _ _|_ _  _ _  .
1670   //    (_(_||(_|_||(_| | (_)| _\  .
1671   //==============================================================================
1672       /**
1673        * @dev calculates unmasked earnings (just calculates, does not update mask)
1674        * @return earnings in wei format
1675        */
1676       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1677           private
1678           view
1679           returns(uint256)
1680       {
1681           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1682       }
1683 
1684       /**
1685        * @dev returns the amount of keys you would get given an amount of eth.
1686        * -functionhash- 0xce89c80c
1687        * @param _rID round ID you want price for
1688        * @param _eth amount of eth sent in
1689        * @return keys received
1690        */
1691       function calcKeysReceived(uint256 _rID, uint256 _eth)
1692           public
1693           view
1694           returns(uint256)
1695       {
1696           // grab time
1697           uint256 _now = now;
1698 
1699           // are we in a round?
1700           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1701               return ( (round_[_rID].eth).keysRec(_eth) );
1702           else // rounds over.  need keys for new round
1703               return ( (_eth).keys() );
1704       }
1705 
1706       /**
1707        * @dev returns current eth price for X keys.
1708        * -functionhash- 0xcf808000
1709        * @param _keys number of keys desired (in 18 decimal format)
1710        * @return amount of eth needed to send
1711        */
1712       function iWantXKeys(uint256 _keys)
1713           public
1714           view
1715           returns(uint256)
1716       {
1717           // setup local rID
1718           uint256 _rID = rID_;
1719 
1720           // grab time
1721           uint256 _now = now;
1722 
1723           // are we in a round?
1724           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1725               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1726           else // rounds over.  need price for new round
1727               return ( (_keys).eth() );
1728       }
1729   //==============================================================================
1730   //    _|_ _  _ | _  .
1731   //     | (_)(_)|_\  .
1732   //==============================================================================
1733       /**
1734   	 * @dev receives name/player info from names contract
1735        */
1736       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1737           external
1738       {
1739           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1740           if (pIDxAddr_[_addr] != _pID)
1741               pIDxAddr_[_addr] = _pID;
1742           if (pIDxName_[_name] != _pID)
1743               pIDxName_[_name] = _pID;
1744           if (plyr_[_pID].addr != _addr)
1745               plyr_[_pID].addr = _addr;
1746           if (plyr_[_pID].name != _name)
1747               plyr_[_pID].name = _name;
1748           if (plyr_[_pID].laff != _laff)
1749               plyr_[_pID].laff = _laff;
1750           if (plyrNames_[_pID][_name] == false)
1751               plyrNames_[_pID][_name] = true;
1752       }
1753 
1754       /**
1755        * @dev receives entire player name list
1756        */
1757       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1758           external
1759       {
1760           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1761           if(plyrNames_[_pID][_name] == false)
1762               plyrNames_[_pID][_name] = true;
1763       }
1764 
1765       /**
1766        * @dev gets existing or registers new pID.  use this when a player may be new
1767        * @return pID
1768        */
1769       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1770           private
1771           returns (F3Ddatasets.EventReturns)
1772       {
1773           uint256 _pID = pIDxAddr_[msg.sender];
1774           // if player is new to this version of fomo3d
1775           if (_pID == 0)
1776           {
1777               // grab their player ID, name and last aff ID, from player names contract
1778               _pID = PlayerBook.getPlayerID(msg.sender);
1779               bytes32 _name = PlayerBook.getPlayerName(_pID);
1780               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1781 
1782               // set up player account
1783               pIDxAddr_[msg.sender] = _pID;
1784               plyr_[_pID].addr = msg.sender;
1785 
1786               if (_name != "")
1787               {
1788                   pIDxName_[_name] = _pID;
1789                   plyr_[_pID].name = _name;
1790                   plyrNames_[_pID][_name] = true;
1791               }
1792 
1793               if (_laff != 0 && _laff != _pID)
1794                   plyr_[_pID].laff = _laff;
1795 
1796               // set the new player bool to true
1797               _eventData_.compressedData = _eventData_.compressedData + 1;
1798           }
1799           return (_eventData_);
1800       }
1801 
1802 
1803             /**
1804        * @dev gets existing or registers new pID.  use this when a player may be new
1805        * @return pID
1806        */
1807       function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1808           private
1809           returns (F3Ddatasets.EventReturns)
1810       {
1811           uint256 _pID = pIDxAddr_[_realSender];
1812           // if player is new to this version of fomo3d
1813           if (_pID == 0)
1814           {
1815               // grab their player ID, name and last aff ID, from player names contract
1816               _pID = PlayerBook.getPlayerID(_realSender);
1817               bytes32 _name = PlayerBook.getPlayerName(_pID);
1818               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1819 
1820               // set up player account
1821               pIDxAddr_[_realSender] = _pID;
1822               plyr_[_pID].addr = _realSender;
1823 
1824               if (_name != "")
1825               {
1826                   pIDxName_[_name] = _pID;
1827                   plyr_[_pID].name = _name;
1828                   plyrNames_[_pID][_name] = true;
1829               }
1830 
1831               if (_laff != 0 && _laff != _pID)
1832                   plyr_[_pID].laff = _laff;
1833 
1834               // set the new player bool to true
1835               _eventData_.compressedData = _eventData_.compressedData + 1;
1836           }
1837           return (_eventData_);
1838       }
1839 
1840       /**
1841        * @dev checks to make sure user picked a valid team.  if not sets team
1842        * to default (sneks)
1843        */
1844       function verifyTeam(uint256 _team)
1845           private
1846           pure
1847           returns (uint256)
1848       {
1849           if (_team < 0 || _team > 3)
1850               return(2);
1851           else
1852               return(_team);
1853       }
1854 
1855       /**
1856        * @dev decides if round end needs to be run & new round started.  and if
1857        * player unmasked earnings from previously played rounds need to be moved.
1858        */
1859       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1860           private
1861           returns (F3Ddatasets.EventReturns)
1862       {
1863           // if player has played a previous round, move their unmasked earnings
1864           // from that round to gen vault.
1865           if (plyr_[_pID].lrnd != 0)
1866               updateGenVault(_pID, plyr_[_pID].lrnd);
1867 
1868           // update player's last round played
1869           plyr_[_pID].lrnd = rID_;
1870 
1871           // set the joined round bool to true
1872           _eventData_.compressedData = _eventData_.compressedData + 10;
1873 
1874           return(_eventData_);
1875       }
1876 
1877       /**
1878        * @dev ends the round. manages paying out winner/splitting up pot
1879        */
1880       function endRound(F3Ddatasets.EventReturns memory _eventData_)
1881           private
1882           returns (F3Ddatasets.EventReturns)
1883       {
1884           // setup local rID
1885           uint256 _rID = rID_;
1886 
1887           // grab our winning player and team id's
1888           uint256 _winPID = round_[_rID].plyr;
1889           uint256 _winTID = round_[_rID].team;
1890 
1891           // grab our pot amount
1892           uint256 _pot = round_[_rID].pot;
1893 
1894           // calculate our winner share, community rewards, gen share,
1895           // p3d share, and amount reserved for next pot
1896           uint256 _win = (_pot.mul(48)) / 100;
1897           uint256 _com = (_pot / 50);
1898           uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1899           uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1900           uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1901 
1902           // calculate ppt for round mask
1903           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1904           uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1905           if (_dust > 0)
1906           {
1907               _gen = _gen.sub(_dust);
1908               _res = _res.add(_dust);
1909           }
1910 
1911           // pay our winner
1912           plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1913 
1914           // community rewards
1915 
1916           admin.transfer(_com);
1917 
1918           admin.transfer(_p3d.sub(_p3d / 2));
1919 
1920           round_[_rID].pot = _pot.add(_p3d / 2);
1921 
1922           // distribute gen portion to key holders
1923           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1924 
1925           // prepare event data
1926           _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1927           _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1928           _eventData_.winnerAddr = plyr_[_winPID].addr;
1929           _eventData_.winnerName = plyr_[_winPID].name;
1930           _eventData_.amountWon = _win;
1931           _eventData_.genAmount = _gen;
1932           _eventData_.P3DAmount = _p3d;
1933           _eventData_.newPot = _res;
1934 
1935           // start next round
1936           rID_++;
1937           _rID++;
1938           round_[_rID].strt = now;
1939           round_[_rID].end = now.add(rndInit_).add(rndGap_);
1940           round_[_rID].pot = _res;
1941 
1942           return(_eventData_);
1943       }
1944 
1945       /**
1946        * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1947        */
1948       function updateGenVault(uint256 _pID, uint256 _rIDlast)
1949           private
1950       {
1951           uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1952           if (_earnings > 0)
1953           {
1954               // put in gen vault
1955               plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1956               // zero out their earnings by updating mask
1957               plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1958           }
1959       }
1960 
1961       /**
1962        * @dev updates round timer based on number of whole keys bought.
1963        */
1964       function updateTimer(uint256 _keys, uint256 _rID)
1965           private
1966       {
1967           // grab time
1968           uint256 _now = now;
1969 
1970           // calculate time based on number of keys bought
1971           uint256 _newTime;
1972           if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1973               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1974           else
1975               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1976 
1977           // compare to max and set new end time
1978           if (_newTime < (rndMax_).add(_now))
1979               round_[_rID].end = _newTime;
1980           else
1981               round_[_rID].end = rndMax_.add(_now);
1982       }
1983 
1984       /**
1985        * @dev generates a random number between 0-99 and checks to see if thats
1986        * resulted in an airdrop win
1987        * @return do we have a winner?
1988        */
1989       function airdrop()
1990           private
1991           view
1992           returns(bool)
1993       {
1994           uint256 seed = uint256(keccak256(abi.encodePacked(
1995 
1996               (block.timestamp).add
1997               (block.difficulty).add
1998               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1999               (block.gaslimit).add
2000               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
2001               (block.number)
2002 
2003           )));
2004           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
2005               return(true);
2006           else
2007               return(false);
2008       }
2009 
2010       /**
2011        * @dev distributes eth based on fees to com, aff, and p3d
2012        */
2013       function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
2014           private
2015           returns(F3Ddatasets.EventReturns)
2016       {
2017           // pay 3% out to community rewards
2018           uint256 _p1 = _eth / 100;
2019           uint256 _com = _eth / 50;
2020           _com = _com.add(_p1);
2021 
2022           uint256 _p3d;
2023           if (!address(admin).call.value(_com)())
2024           {
2025               // This ensures Team Just cannot influence the outcome of FoMo3D with
2026               // bank migrations by breaking outgoing transactions.
2027               // Something we would never do. But that's not the point.
2028               // We spent 2000$ in eth re-deploying just to patch this, we hold the
2029               // highest belief that everything we create should be trustless.
2030               // Team JUST, The name you shouldn't have to trust.
2031               _p3d = _com;
2032               _com = 0;
2033           }
2034 
2035 
2036           // distribute share to affiliate
2037           uint256 _aff = _eth / 10;
2038 
2039           // decide what to do with affiliate share of fees
2040           // affiliate must not be self, and must have a name registered
2041           if (_affID != _pID && plyr_[_affID].name != '') {
2042               plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
2043               emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
2044           } else {
2045               _p3d = _aff;
2046           }
2047 
2048           // pay out p3d
2049           _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
2050           if (_p3d > 0)
2051           {
2052               // deposit to divies contract
2053               uint256 _potAmount = _p3d / 2;
2054 
2055               admin.transfer(_p3d.sub(_potAmount));
2056 
2057               round_[_rID].pot = round_[_rID].pot.add(_potAmount);
2058 
2059               // set up event data
2060               _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
2061           }
2062 
2063           return(_eventData_);
2064       }
2065 
2066       function potSwap()
2067           external
2068           payable
2069       {
2070           // setup local rID
2071           uint256 _rID = rID_ + 1;
2072 
2073           round_[_rID].pot = round_[_rID].pot.add(msg.value);
2074           emit F3Devents.onPotSwapDeposit(_rID, msg.value);
2075       }
2076 
2077       /**
2078        * @dev distributes eth based on fees to gen and pot
2079        */
2080       function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2081           private
2082           returns(F3Ddatasets.EventReturns)
2083       {
2084           // calculate gen share
2085           uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
2086 
2087           // toss 1% into airdrop pot
2088           uint256 _air = (_eth / 100);
2089           airDropPot_ = airDropPot_.add(_air);
2090 
2091           // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
2092           _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
2093 
2094           // calculate pot
2095           uint256 _pot = _eth.sub(_gen);
2096 
2097           // distribute gen share (thats what updateMasks() does) and adjust
2098           // balances for dust.
2099           uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
2100           if (_dust > 0)
2101               _gen = _gen.sub(_dust);
2102 
2103           // add eth to pot
2104           round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
2105 
2106           // set up event data
2107           _eventData_.genAmount = _gen.add(_eventData_.genAmount);
2108           _eventData_.potAmount = _pot;
2109 
2110           return(_eventData_);
2111       }
2112 
2113       /**
2114        * @dev updates masks for round and player when keys are bought
2115        * @return dust left over
2116        */
2117       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
2118           private
2119           returns(uint256)
2120       {
2121           /* MASKING NOTES
2122               earnings masks are a tricky thing for people to wrap their minds around.
2123               the basic thing to understand here.  is were going to have a global
2124               tracker based on profit per share for each round, that increases in
2125               relevant proportion to the increase in share supply.
2126 
2127               the player will have an additional mask that basically says "based
2128               on the rounds mask, my shares, and how much i've already withdrawn,
2129               how much is still owed to me?"
2130           */
2131 
2132           // calc profit per key & round mask based on this buy:  (dust goes to pot)
2133           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
2134           round_[_rID].mask = _ppt.add(round_[_rID].mask);
2135 
2136           // calculate player earning from their own buy (only based on the keys
2137           // they just bought).  & update player earnings mask
2138           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
2139           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
2140 
2141           // calculate & return dust
2142           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
2143       }
2144 
2145       /**
2146        * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
2147        * @return earnings in wei format
2148        */
2149       function withdrawEarnings(uint256 _pID)
2150           private
2151           returns(uint256)
2152       {
2153           // update gen vault
2154           updateGenVault(_pID, plyr_[_pID].lrnd);
2155 
2156           // from vaults
2157           uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
2158           if (_earnings > 0)
2159           {
2160               plyr_[_pID].win = 0;
2161               plyr_[_pID].gen = 0;
2162               plyr_[_pID].aff = 0;
2163           }
2164 
2165           return(_earnings);
2166       }
2167 
2168       /**
2169        * @dev prepares compression data and fires event for buy or reload tx's
2170        */
2171       function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2172           private
2173       {
2174           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2175           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2176 
2177           emit F3Devents.onEndTx
2178           (
2179               _eventData_.compressedData,
2180               _eventData_.compressedIDs,
2181               plyr_[_pID].name,
2182               msg.sender,
2183               _eth,
2184               _keys,
2185               _eventData_.winnerAddr,
2186               _eventData_.winnerName,
2187               _eventData_.amountWon,
2188               _eventData_.newPot,
2189               _eventData_.P3DAmount,
2190               _eventData_.genAmount,
2191               _eventData_.potAmount,
2192               airDropPot_
2193           );
2194       }
2195 
2196             /**
2197        * @dev prepares compression data and fires event for buy or reload tx's
2198        */
2199       function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2200           private
2201       {
2202           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2203           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2204 
2205           emit F3Devents.onEndTx
2206           (
2207               _eventData_.compressedData,
2208               _eventData_.compressedIDs,
2209               plyr_[_pID].name,
2210               _realSender,
2211               _eth,
2212               _keys,
2213               _eventData_.winnerAddr,
2214               _eventData_.winnerName,
2215               _eventData_.amountWon,
2216               _eventData_.newPot,
2217               _eventData_.P3DAmount,
2218               _eventData_.genAmount,
2219               _eventData_.potAmount,
2220               airDropPot_
2221           );
2222       }
2223   //==============================================================================
2224   //    (~ _  _    _._|_    .
2225   //    _)(/_(_|_|| | | \/  .
2226   //====================/=========================================================
2227       /** upon contract deploy, it will be deactivated.  this is a one time
2228        * use function that will activate the contract.  we do this so devs
2229        * have time to set things up on the web end                            **/
2230       bool public activated_ = false;
2231       function activate()
2232           public
2233       {
2234           // only team just can activate
2235           require(msg.sender == admin, "only admin can activate");
2236 
2237 
2238           // can only be ran once
2239           require(activated_ == false, "FOMO Short already activated");
2240 
2241           // activate the contract
2242           activated_ = true;
2243 
2244           // lets start first round
2245           rID_ = 1;
2246               round_[1].strt = now + rndExtra_ - rndGap_;
2247               round_[1].end = now + rndInit_ + rndExtra_;
2248       }
2249   }