1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 library NameFilter {
7     /**
8      * @dev filters name strings
9      * -converts uppercase to lower case.
10      * -makes sure it does not start/end with a space
11      * -makes sure it does not contain multiple spaces in a row
12      * -cannot be only numbers
13      * -cannot start with 0x
14      * -restricts characters to A-Z, a-z, 0-9, and space.
15      * @return reprocessed string in bytes32 format
16      */
17     function nameFilter(string _input)
18         internal
19         pure
20         returns(bytes32)
21     {
22         bytes memory _temp = bytes(_input);
23         uint256 _length = _temp.length;
24 
25         //sorry limited to 32 characters
26         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
27         // make sure it doesnt start with or end with space
28         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
29         // make sure first two characters are not 0x
30         if (_temp[0] == 0x30)
31         {
32             require(_temp[1] != 0x78, "string cannot start with 0x");
33             require(_temp[1] != 0x58, "string cannot start with 0X");
34         }
35 
36         // create a bool to track if we have a non number character
37         bool _hasNonNumber;
38 
39         // convert & check
40         for (uint256 i = 0; i < _length; i++)
41         {
42             // if its uppercase A-Z
43             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
44             {
45                 // convert to lower case a-z
46                 _temp[i] = byte(uint(_temp[i]) + 32);
47 
48                 // we have a non number
49                 if (_hasNonNumber == false)
50                     _hasNonNumber = true;
51             } else {
52                 require
53                 (
54                     // require character is a space
55                     _temp[i] == 0x20 ||
56                     // OR lowercase a-z
57                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
58                     // or 0-9
59                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
60                     "string contains invalid characters"
61                 );
62                 // make sure theres not 2x spaces in a row
63                 if (_temp[i] == 0x20)
64                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
65 
66                 // see if we have a character other than a number
67                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
68                     _hasNonNumber = true;
69             }
70         }
71 
72         require(_hasNonNumber == true, "string cannot be only numbers");
73 
74         bytes32 _ret;
75         assembly {
76             _ret := mload(add(_temp, 32))
77         }
78         return (_ret);
79     }
80 }
81 
82 /**
83  * @title SafeMath v0.1.9
84  * @dev Math operations with safety checks that throw on error
85  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
86  * - added sqrt
87  * - added sq
88  * - added pwr
89  * - changed asserts to requires with error log outputs
90  * - removed div, its useless
91  */
92 library SafeMath {
93 
94     /**
95     * @dev Multiplies two numbers, throws on overflow.
96     */
97     function mul(uint256 a, uint256 b)
98         internal
99         pure
100         returns (uint256 c)
101     {
102         if (a == 0) {
103             return 0;
104         }
105         c = a * b;
106         require(c / a == b, "SafeMath mul failed");
107         return c;
108     }
109 
110     /**
111     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112     */
113     function sub(uint256 a, uint256 b)
114         internal
115         pure
116         returns (uint256)
117     {
118         require(b <= a, "SafeMath sub failed");
119         return a - b;
120     }
121 
122     /**
123     * @dev Adds two numbers, throws on overflow.
124     */
125     function add(uint256 a, uint256 b)
126         internal
127         pure
128         returns (uint256 c)
129     {
130         c = a + b;
131         require(c >= a, "SafeMath add failed");
132         return c;
133     }
134 
135     /**
136      * @dev gives square root of given x.
137      */
138     function sqrt(uint256 x)
139         internal
140         pure
141         returns (uint256 y)
142     {
143         uint256 z = ((add(x,1)) / 2);
144         y = x;
145         while (z < y)
146         {
147             y = z;
148             z = ((add((x / z),z)) / 2);
149         }
150     }
151 
152     /**
153      * @dev gives square. multiplies x by x
154      */
155     function sq(uint256 x)
156         internal
157         pure
158         returns (uint256)
159     {
160         return (mul(x,x));
161     }
162 
163     /**
164      * @dev x to the power of y
165      */
166     function pwr(uint256 x, uint256 y)
167         internal
168         pure
169         returns (uint256)
170     {
171         if (x==0)
172             return (0);
173         else if (y==0)
174             return (1);
175         else
176         {
177             uint256 z = x;
178             for (uint256 i=1; i < y; i++)
179                 z = mul(z,x);
180             return (z);
181         }
182     }
183 }
184 
185 
186 
187 //==============================================================================
188 //   __|_ _    __|_ _  .
189 //  _\ | | |_|(_ | _\  .
190 //==============================================================================
191 library F3Ddatasets {
192     //compressedData key
193     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
194         // 0 - new player (bool)
195         // 1 - joined round (bool)
196         // 2 - new  leader (bool)
197         // 3-5 - air drop tracker (uint 0-999)
198         // 6-16 - round end time
199         // 17 - winnerTeam
200         // 18 - 28 timestamp
201         // 29 - team
202         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
203         // 31 - airdrop happened bool
204         // 32 - airdrop tier
205         // 33 - airdrop amount won
206     //compressedIDs key
207     // [77-52][51-26][25-0]
208         // 0-25 - pID
209         // 26-51 - winPID
210         // 52-77 - rID
211     struct EventReturns {
212         uint256 compressedData;
213         uint256 compressedIDs;
214         address winnerAddr;         // winner address
215         bytes32 winnerName;         // winner name
216         uint256 amountWon;          // amount won
217         uint256 newPot;             // amount in new pot
218         uint256 P3DAmount;          // amount distributed to p3d
219         uint256 genAmount;          // amount distributed to gen
220         uint256 potAmount;          // amount added to pot
221     }
222     struct Player {
223         address addr;   // player address
224         bytes32 name;   // player name
225         uint256 win;    // winnings vault
226         uint256 gen;    // general vault
227         uint256 aff;    // affiliate vault
228         uint256 lrnd;   // last round played
229         uint256 laff;   // last affiliate id used
230     }
231     struct PlayerRounds {
232         uint256 eth;    // eth player has added to round (used for eth limiter)
233         uint256 keys;   // keys
234         uint256 mask;   // player mask
235         uint256 ico;    // ICO phase investment
236     }
237     struct Round {
238         uint256 plyr;   // pID of player in lead
239         uint256 team;   // tID of team in lead
240         uint256 end;    // time ends/ended
241         bool ended;     // has round end function been ran
242         uint256 strt;   // time round started
243         uint256 keys;   // keys
244         uint256 eth;    // total eth in
245         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
246         uint256 mask;   // global mask
247         uint256 ico;    // total eth sent in during ICO phase
248         uint256 icoGen; // total eth for gen during ICO phase
249         uint256 icoAvg; // average key price for ICO phase
250     }
251     struct TeamFee {
252         uint256 gen;    // % of buy in thats paid to key holders of current round
253         uint256 p3d;    // % of buy in thats paid to p3d holders
254     }
255     struct PotSplit {
256         uint256 gen;    // % of pot thats paid to key holders of current round
257         uint256 p3d;    // % of pot thats paid to p3d holders
258     }
259 }
260 
261 //==============================================================================
262 //  |  _      _ _ | _  .
263 //  |<(/_\/  (_(_||(_  .
264 //=======/======================================================================
265 library F3DKeysCalcShort {
266     using SafeMath for *;
267     /**
268      * @dev calculates number of keys received given X eth
269      * @param _curEth current amount of eth in contract
270      * @param _newEth eth being spent
271      * @return amount of ticket purchased
272      */
273     function keysRec(uint256 _curEth, uint256 _newEth)
274         internal
275         pure
276         returns (uint256)
277     {
278         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
279     }
280 
281     /**
282      * @dev calculates amount of eth received if you sold X keys
283      * @param _curKeys current amount of keys that exist
284      * @param _sellKeys amount of keys you wish to sell
285      * @return amount of eth received
286      */
287     function ethRec(uint256 _curKeys, uint256 _sellKeys)
288         internal
289         pure
290         returns (uint256)
291     {
292         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
293     }
294 
295     /**
296      * @dev calculates how many keys would exist with given an amount of eth
297      * @param _eth eth "in contract"
298      * @return number of keys that would exist
299      */
300     function keys(uint256 _eth)
301         internal
302         pure
303         returns(uint256)
304     {
305         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
306     }
307 
308     /**
309      * @dev calculates how much eth would be in contract given a number of keys
310      * @param _keys number of keys "in contract"
311      * @return eth that would exists
312      */
313     function eth(uint256 _keys)
314         internal
315         pure
316         returns(uint256)
317     {
318         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
319     }
320 }
321 
322 //==============================================================================
323 //  . _ _|_ _  _ |` _  _ _  _  .
324 //  || | | (/_| ~|~(_|(_(/__\  .
325 //==============================================================================
326 
327 
328 contract F3Devents {
329     // fired whenever a player registers a name
330     event onNewName
331     (
332         uint256 indexed playerID,
333         address indexed playerAddress,
334         bytes32 indexed playerName,
335         bool isNewPlayer,
336         uint256 affiliateID,
337         address affiliateAddress,
338         bytes32 affiliateName,
339         uint256 amountPaid,
340         uint256 timeStamp
341     );
342 
343     // fired at end of buy or reload
344     event onEndTx
345     (
346         uint256 compressedData,
347         uint256 compressedIDs,
348         bytes32 playerName,
349         address playerAddress,
350         uint256 ethIn,
351         uint256 keysBought,
352         address winnerAddr,
353         bytes32 winnerName,
354         uint256 amountWon,
355         uint256 newPot,
356         uint256 P3DAmount,
357         uint256 genAmount,
358         uint256 potAmount,
359         uint256 airDropPot
360     );
361 
362 	// fired whenever theres a withdraw
363     event onWithdraw
364     (
365         uint256 indexed playerID,
366         address playerAddress,
367         bytes32 playerName,
368         uint256 ethOut,
369         uint256 timeStamp
370     );
371 
372     // fired whenever a withdraw forces end round to be ran
373     event onWithdrawAndDistribute
374     (
375         address playerAddress,
376         bytes32 playerName,
377         uint256 ethOut,
378         uint256 compressedData,
379         uint256 compressedIDs,
380         address winnerAddr,
381         bytes32 winnerName,
382         uint256 amountWon,
383         uint256 newPot,
384         uint256 P3DAmount,
385         uint256 genAmount
386     );
387 
388     // (fomo3d short only) fired whenever a player tries a buy after round timer
389     // hit zero, and causes end round to be ran.
390     event onBuyAndDistribute
391     (
392         address playerAddress,
393         bytes32 playerName,
394         uint256 ethIn,
395         uint256 compressedData,
396         uint256 compressedIDs,
397         address winnerAddr,
398         bytes32 winnerName,
399         uint256 amountWon,
400         uint256 newPot,
401         uint256 P3DAmount,
402         uint256 genAmount
403     );
404 
405     // (fomo3d short only) fired whenever a player tries a reload after round timer
406     // hit zero, and causes end round to be ran.
407     event onReLoadAndDistribute
408     (
409         address playerAddress,
410         bytes32 playerName,
411         uint256 compressedData,
412         uint256 compressedIDs,
413         address winnerAddr,
414         bytes32 winnerName,
415         uint256 amountWon,
416         uint256 newPot,
417         uint256 P3DAmount,
418         uint256 genAmount
419     );
420 
421     // fired whenever an affiliate is paid
422     event onAffiliatePayout
423     (
424         uint256 indexed affiliateID,
425         address affiliateAddress,
426         bytes32 affiliateName,
427         uint256 indexed roundID,
428         uint256 indexed buyerID,
429         uint256 amount,
430         uint256 timeStamp
431     );
432 
433     // received pot swap deposit
434     event onPotSwapDeposit
435     (
436         uint256 roundID,
437         uint256 amountAddedToPot
438     );
439 }
440 
441 
442 interface PlayerBookInterface {
443     function getPlayerID(address _addr) external returns (uint256);
444     function getPlayerName(uint256 _pID) external view returns (bytes32);
445     function getPlayerLAff(uint256 _pID) external view returns (uint256);
446     function getPlayerAddr(uint256 _pID) external view returns (address);
447     function getNameFee() external view returns (uint256);
448     //function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
449     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
450     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
451 }
452 
453 
454 contract modularFast is F3Devents {}
455 
456 
457 contract FoMo3DFast is modularFast {
458       using SafeMath for *;
459       using NameFilter for string;
460       using F3DKeysCalcShort for uint256;
461 
462       PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xf36E1c00Dd9c253DBD9e1914739F99F76b8b4A6E);
463 
464       address private admin = msg.sender;
465       string constant public name = "FOMO Fast";
466       string constant public symbol = "FAST";
467       uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
468       uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
469       uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
470       uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
471       uint256 constant private rndMax_ = 8 hours;                // max length a round timer can be
472       uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
473       uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
474       uint256 public rID_;    // round id number / total rounds that have happened
475   //****************
476   // PLAYER DATA
477   //****************
478       mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
479       mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
480       mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
481       mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
482       mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
483   //****************
484   // ROUND DATA
485   //****************
486       mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
487       mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
488   //****************
489   // TEAM FEE DATA
490   //****************
491       mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
492       mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
493       
494       constructor()
495           public
496       {
497   		// Team allocation structures
498           // 0 = whales
499           // 1 = bears
500           // 2 = sneks
501           // 3 = bulls
502 
503   		// Team allocation percentages
504           // (F3D, P3D) + (Pot , Referrals, Community)
505               // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
506           fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
507           fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
508           fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
509           fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
510 
511           // how to split up the final pot based on which team was picked
512           // (F3D, P3D)
513           potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
514           potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
515           potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
516           potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
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
619           isHuman()
620           isWithinLimits(msg.value)
621           public
622           payable
623       {
624           // set up our tx event data and determine if player is new or not
625           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
626 
627           // fetch player id
628           uint256 _pID = pIDxAddr_[msg.sender];
629 
630           // manage affiliate residuals
631           uint256 _affID;
632           // if no affiliate code was given or player tried to use their own, lolz
633           if (_affCode == address(0) || _affCode == msg.sender)
634           {
635               // use last stored affiliate code
636               _affID = plyr_[_pID].laff;
637 
638           // if affiliate code was given
639           } else {
640               // get affiliate ID from aff Code
641               _affID = pIDxAddr_[_affCode];
642 
643               // if affID is not the same as previously stored
644               if (_affID != plyr_[_pID].laff)
645               {
646                   // update last affiliate
647                   plyr_[_pID].laff = _affID;
648               }
649           }
650 
651           // verify a valid team was selected
652           _team = verifyTeam(_team);
653 
654           // buy core
655           buyCore(_pID, _affID, _team, _eventData_);
656       }
657 
658       function buyXname(bytes32 _affCode, uint256 _team)
659           isActivated()
660           isHuman()
661           isWithinLimits(msg.value)
662           public
663           payable
664       {
665           // set up our tx event data and determine if player is new or not
666           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
667 
668           // fetch player id
669           uint256 _pID = pIDxAddr_[msg.sender];
670 
671           // manage affiliate residuals
672           uint256 _affID;
673           // if no affiliate code was given or player tried to use their own, lolz
674           if (_affCode == '' || _affCode == plyr_[_pID].name)
675           {
676               // use last stored affiliate code
677               _affID = plyr_[_pID].laff;
678 
679           // if affiliate code was given
680           } else {
681               // get affiliate ID from aff Code
682               _affID = pIDxName_[_affCode];
683 
684               // if affID is not the same as previously stored
685               if (_affID != plyr_[_pID].laff)
686               {
687                   // update last affiliate
688                   plyr_[_pID].laff = _affID;
689               }
690           }
691 
692           // verify a valid team was selected
693           _team = verifyTeam(_team);
694 
695           // buy core
696           buyCore(_pID, _affID, _team, _eventData_);
697       }
698 
699       /**
700        * @dev essentially the same as buy, but instead of you sending ether
701        * from your wallet, it uses your unwithdrawn earnings.
702        * -functionhash- 0x349cdcac (using ID for affiliate)
703        * -functionhash- 0x82bfc739 (using address for affiliate)
704        * -functionhash- 0x079ce327 (using name for affiliate)
705        * @param _affCode the ID/address/name of the player who gets the affiliate fee
706        * @param _team what team is the player playing for?
707        * @param _eth amount of earnings to use (remainder returned to gen vault)
708        */
709       function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
710           isActivated()
711           isHuman()
712           isWithinLimits(_eth)
713           public
714       {
715           // set up our tx event data
716           F3Ddatasets.EventReturns memory _eventData_;
717 
718           // fetch player ID
719           uint256 _pID = pIDxAddr_[msg.sender];
720 
721           // manage affiliate residuals
722           // if no affiliate code was given or player tried to use their own, lolz
723           if (_affCode == 0 || _affCode == _pID)
724           {
725               // use last stored affiliate code
726               _affCode = plyr_[_pID].laff;
727 
728           // if affiliate code was given & its not the same as previously stored
729           } else if (_affCode != plyr_[_pID].laff) {
730               // update last affiliate
731               plyr_[_pID].laff = _affCode;
732           }
733 
734           // verify a valid team was selected
735           _team = verifyTeam(_team);
736 
737           // reload core
738           reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
739       }
740 
741       function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
742           isActivated()
743           isHuman()
744           isWithinLimits(_eth)
745           public
746       {
747           // set up our tx event data
748           F3Ddatasets.EventReturns memory _eventData_;
749 
750           // fetch player ID
751           uint256 _pID = pIDxAddr_[msg.sender];
752 
753           // manage affiliate residuals
754           uint256 _affID;
755           // if no affiliate code was given or player tried to use their own, lolz
756           if (_affCode == address(0) || _affCode == msg.sender)
757           {
758               // use last stored affiliate code
759               _affID = plyr_[_pID].laff;
760 
761           // if affiliate code was given
762           } else {
763               // get affiliate ID from aff Code
764               _affID = pIDxAddr_[_affCode];
765 
766               // if affID is not the same as previously stored
767               if (_affID != plyr_[_pID].laff)
768               {
769                   // update last affiliate
770                   plyr_[_pID].laff = _affID;
771               }
772           }
773 
774           // verify a valid team was selected
775           _team = verifyTeam(_team);
776 
777           // reload core
778           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
779       }
780 
781       function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
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
796           if (_affCode == '' || _affCode == plyr_[_pID].name)
797           {
798               // use last stored affiliate code
799               _affID = plyr_[_pID].laff;
800 
801           // if affiliate code was given
802           } else {
803               // get affiliate ID from aff Code
804               _affID = pIDxName_[_affCode];
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
821       /**
822        * @dev withdraws all of your earnings.
823        * -functionhash- 0x3ccfd60b
824        */
825       function withdraw()
826           isActivated()
827           isHuman()
828           public
829       {
830           // setup local rID
831           uint256 _rID = rID_;
832 
833           // grab time
834           uint256 _now = now;
835 
836           // fetch player ID
837           uint256 _pID = pIDxAddr_[msg.sender];
838 
839           // setup temp var for player eth
840           uint256 _eth;
841 
842           // check to see if round has ended and no one has run round end yet
843           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
844           {
845               // set up our tx event data
846               F3Ddatasets.EventReturns memory _eventData_;
847 
848               // end the round (distributes pot)
849   			round_[_rID].ended = true;
850               _eventData_ = endRound(_eventData_);
851 
852   			// get their earnings
853               _eth = withdrawEarnings(_pID);
854 
855               // gib moni
856               if (_eth > 0)
857                   plyr_[_pID].addr.transfer(_eth);
858 
859               // build event data
860               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
861               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
862 
863               // fire withdraw and distribute event
864               emit F3Devents.onWithdrawAndDistribute
865               (
866                   msg.sender,
867                   plyr_[_pID].name,
868                   _eth,
869                   _eventData_.compressedData,
870                   _eventData_.compressedIDs,
871                   _eventData_.winnerAddr,
872                   _eventData_.winnerName,
873                   _eventData_.amountWon,
874                   _eventData_.newPot,
875                   _eventData_.P3DAmount,
876                   _eventData_.genAmount
877               );
878 
879           // in any other situation
880           } else {
881               // get their earnings
882               _eth = withdrawEarnings(_pID);
883 
884               // gib moni
885               if (_eth > 0)
886                   plyr_[_pID].addr.transfer(_eth);
887 
888               // fire withdraw event
889               emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
890           }
891       }
892 
893       /**
894        * @dev use these to register names.  they are just wrappers that will send the
895        * registration requests to the PlayerBook contract.  So registering here is the
896        * same as registering there.  UI will always display the last name you registered.
897        * but you will still own all previously registered names to use as affiliate
898        * links.
899        * - must pay a registration fee.
900        * - name must be unique
901        * - names will be converted to lowercase
902        * - name cannot start or end with a space
903        * - cannot have more than 1 space in a row
904        * - cannot be only numbers
905        * - cannot start with 0x
906        * - name must be at least 1 char
907        * - max length of 32 characters long
908        * - allowed characters: a-z, 0-9, and space
909        * -functionhash- 0x921dec21 (using ID for affiliate)
910        * -functionhash- 0x3ddd4698 (using address for affiliate)
911        * -functionhash- 0x685ffd83 (using name for affiliate)
912        * @param _nameString players desired name
913        * @param _affCode affiliate ID, address, or name of who referred you
914        * @param _all set to true if you want this to push your info to all games
915        * (this might cost a lot of gas)
916        */
917        
918       /* function registerNameXID(string _nameString, uint256 _affCode, bool _all)
919           isHuman()
920           public
921           payable
922       {
923           bytes32 _name = _nameString.nameFilter();
924           address _addr = msg.sender;
925           uint256 _paid = msg.value;
926           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
927 
928           uint256 _pID = pIDxAddr_[_addr];
929 
930           // fire event
931           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
932       } */
933 
934       function registerNameXaddr(string _nameString, address _affCode, bool _all)
935           isHuman()
936           public
937           payable
938       {
939           bytes32 _name = _nameString.nameFilter();
940           address _addr = msg.sender;
941           uint256 _paid = msg.value;
942           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
943 
944           uint256 _pID = pIDxAddr_[_addr];
945 
946           // fire event
947           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
948       }
949 
950       function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
951           isHuman()
952           public
953           payable
954       {
955           bytes32 _name = _nameString.nameFilter();
956           address _addr = msg.sender;
957           uint256 _paid = msg.value;
958           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
959 
960           uint256 _pID = pIDxAddr_[_addr];
961 
962           // fire event
963           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
964       }
965   //==============================================================================
966   //     _  _ _|__|_ _  _ _  .
967   //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
968   //=====_|=======================================================================
969       /**
970        * @dev return the price buyer will pay for next 1 individual key.
971        * -functionhash- 0x018a25e8
972        * @return price for next key bought (in wei format)
973        */
974       function getBuyPrice()
975           public
976           view
977           returns(uint256)
978       {
979           // setup local rID
980           uint256 _rID = rID_;
981 
982           // grab time
983           uint256 _now = now;
984 
985           // are we in a round?
986           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
987               return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
988           else // rounds over.  need price for new round
989               return ( 75000000000000 ); // init
990       }
991 
992       /**
993        * @dev returns time left.  dont spam this, you'll ddos yourself from your node
994        * provider
995        * -functionhash- 0xc7e284b8
996        * @return time left in seconds
997        */
998       function getTimeLeft()
999           public
1000           view
1001           returns(uint256)
1002       {
1003           // setup local rID
1004           uint256 _rID = rID_;
1005 
1006           // grab time
1007           uint256 _now = now;
1008 
1009           if (_now < round_[_rID].end)
1010               if (_now > round_[_rID].strt + rndGap_)
1011                   return( (round_[_rID].end).sub(_now) );
1012               else
1013                   return( (round_[_rID].strt + rndGap_).sub(_now) );
1014           else
1015               return(0);
1016       }
1017 
1018       /**
1019        * @dev returns player earnings per vaults
1020        * -functionhash- 0x63066434
1021        * @return winnings vault
1022        * @return general vault
1023        * @return affiliate vault
1024        */
1025       function getPlayerVaults(uint256 _pID)
1026           public
1027           view
1028           returns(uint256 ,uint256, uint256)
1029       {
1030           // setup local rID
1031           uint256 _rID = rID_;
1032 
1033           // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1034           if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1035           {
1036               // if player is winner
1037               if (round_[_rID].plyr == _pID)
1038               {
1039                   return
1040                   (
1041                       (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1042                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1043                       plyr_[_pID].aff
1044                   );
1045               // if player is not the winner
1046               } else {
1047                   return
1048                   (
1049                       plyr_[_pID].win,
1050                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1051                       plyr_[_pID].aff
1052                   );
1053               }
1054 
1055           // if round is still going on, or round has ended and round end has been ran
1056           } else {
1057               return
1058               (
1059                   plyr_[_pID].win,
1060                   (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1061                   plyr_[_pID].aff
1062               );
1063           }
1064       }
1065 
1066       /**
1067        * solidity hates stack limits.  this lets us avoid that hate
1068        */
1069       function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1070           private
1071           view
1072           returns(uint256)
1073       {
1074           return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1075       }
1076 
1077       /**
1078        * @dev returns all current round info needed for front end
1079        * -functionhash- 0x747dff42
1080        * @return eth invested during ICO phase
1081        * @return round id
1082        * @return total keys for round
1083        * @return time round ends
1084        * @return time round started
1085        * @return current pot
1086        * @return current team ID & player ID in lead
1087        * @return current player in leads address
1088        * @return current player in leads name
1089        * @return whales eth in for round
1090        * @return bears eth in for round
1091        * @return sneks eth in for round
1092        * @return bulls eth in for round
1093        * @return airdrop tracker # & airdrop pot
1094        */
1095       function getCurrentRoundInfo()
1096           public
1097           view
1098           returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1099       {
1100           // setup local rID
1101           uint256 _rID = rID_;
1102 
1103           return
1104           (
1105               round_[_rID].ico,               //0
1106               _rID,                           //1
1107               round_[_rID].keys,              //2
1108               round_[_rID].end,               //3
1109               round_[_rID].strt,              //4
1110               round_[_rID].pot,               //5
1111               (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1112               plyr_[round_[_rID].plyr].addr,  //7
1113               plyr_[round_[_rID].plyr].name,  //8
1114               rndTmEth_[_rID][0],             //9
1115               rndTmEth_[_rID][1],             //10
1116               rndTmEth_[_rID][2],             //11
1117               rndTmEth_[_rID][3],             //12
1118               airDropTracker_ + (airDropPot_ * 1000)              //13
1119           );
1120       }
1121 
1122       /**
1123        * @dev returns player info based on address.  if no address is given, it will
1124        * use msg.sender
1125        * -functionhash- 0xee0b5d8b
1126        * @param _addr address of the player you want to lookup
1127        * @return player ID
1128        * @return player name
1129        * @return keys owned (current round)
1130        * @return winnings vault
1131        * @return general vault
1132        * @return affiliate vault
1133   	 * @return player round eth
1134        */
1135       function getPlayerInfoByAddress(address _addr)
1136           public
1137           view
1138           returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1139       {
1140           // setup local rID
1141           uint256 _rID = rID_;
1142 
1143           if (_addr == address(0))
1144           {
1145               _addr == msg.sender;
1146           }
1147           uint256 _pID = pIDxAddr_[_addr];
1148 
1149           return
1150           (
1151               _pID,                               //0
1152               plyr_[_pID].name,                   //1
1153               plyrRnds_[_pID][_rID].keys,         //2
1154               plyr_[_pID].win,                    //3
1155               (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1156               plyr_[_pID].aff,                    //5
1157               plyrRnds_[_pID][_rID].eth           //6
1158           );
1159       }
1160 
1161   //==============================================================================
1162   //     _ _  _ _   | _  _ . _  .
1163   //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1164   //=====================_|=======================================================
1165       /**
1166        * @dev logic runs whenever a buy order is executed.  determines how to handle
1167        * incoming eth depending on if we are in an active round or not
1168        */
1169       function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1170           private
1171       {
1172           // setup local rID
1173           uint256 _rID = rID_;
1174 
1175           // grab time
1176           uint256 _now = now;
1177 
1178           // if round is active
1179           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1180           {
1181               // call core
1182               core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1183 
1184           // if round is not active
1185           } else {
1186               // check to see if end round needs to be ran
1187               if (_now > round_[_rID].end && round_[_rID].ended == false)
1188               {
1189                   // end the round (distributes pot) & start new round
1190   			    round_[_rID].ended = true;
1191                   _eventData_ = endRound(_eventData_);
1192 
1193                   // build event data
1194                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1195                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1196 
1197                   // fire buy and distribute event
1198                   emit F3Devents.onBuyAndDistribute
1199                   (
1200                       msg.sender,
1201                       plyr_[_pID].name,
1202                       msg.value,
1203                       _eventData_.compressedData,
1204                       _eventData_.compressedIDs,
1205                       _eventData_.winnerAddr,
1206                       _eventData_.winnerName,
1207                       _eventData_.amountWon,
1208                       _eventData_.newPot,
1209                       _eventData_.P3DAmount,
1210                       _eventData_.genAmount
1211                   );
1212               }
1213 
1214               // put eth in players vault
1215               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1216           }
1217       }
1218 
1219       /**
1220        * @dev logic runs whenever a reload order is executed.  determines how to handle
1221        * incoming eth depending on if we are in an active round or not
1222        */
1223       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1224           private
1225       {
1226           // setup local rID
1227           uint256 _rID = rID_;
1228 
1229           // grab time
1230           uint256 _now = now;
1231 
1232           // if round is active
1233           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1234           {
1235               // get earnings from all vaults and return unused to gen vault
1236               // because we use a custom safemath library.  this will throw if player
1237               // tried to spend more eth than they have.
1238               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1239 
1240               // call core
1241               core(_rID, _pID, _eth, _affID, _team, _eventData_);
1242 
1243           // if round is not active and end round needs to be ran
1244           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1245               // end the round (distributes pot) & start new round
1246               round_[_rID].ended = true;
1247               _eventData_ = endRound(_eventData_);
1248 
1249               // build event data
1250               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1251               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1252 
1253               // fire buy and distribute event
1254               emit F3Devents.onReLoadAndDistribute
1255               (
1256                   msg.sender,
1257                   plyr_[_pID].name,
1258                   _eventData_.compressedData,
1259                   _eventData_.compressedIDs,
1260                   _eventData_.winnerAddr,
1261                   _eventData_.winnerName,
1262                   _eventData_.amountWon,
1263                   _eventData_.newPot,
1264                   _eventData_.P3DAmount,
1265                   _eventData_.genAmount
1266               );
1267           }
1268       }
1269 
1270       /**
1271        * @dev this is the core logic for any buy/reload that happens while a round
1272        * is live.
1273        */
1274       function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1275           private
1276       {
1277           // if player is new to round
1278           if (plyrRnds_[_pID][_rID].keys == 0)
1279               _eventData_ = managePlayer(_pID, _eventData_);
1280 
1281           // early round eth limiter
1282           if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1283           {
1284               uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1285               uint256 _refund = _eth.sub(_availableLimit);
1286               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1287               _eth = _availableLimit;
1288           }
1289 
1290           // if eth left is greater than min eth allowed (sorry no pocket lint)
1291           if (_eth > 1000000000)
1292           {
1293 
1294               // mint the new keys
1295               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1296 
1297               // if they bought at least 1 whole key
1298               if (_keys >= 1000000000000000000)
1299               {
1300               updateTimer(_keys, _rID);
1301 
1302               // set new leaders
1303               if (round_[_rID].plyr != _pID)
1304                   round_[_rID].plyr = _pID;
1305               if (round_[_rID].team != _team)
1306                   round_[_rID].team = _team;
1307 
1308               // set the new leader bool to true
1309               _eventData_.compressedData = _eventData_.compressedData + 100;
1310           }
1311 
1312               // manage airdrops
1313               if (_eth >= 100000000000000000)
1314               {
1315               airDropTracker_++;
1316               if (airdrop() == true)
1317               {
1318                   // gib muni
1319                   uint256 _prize;
1320                   if (_eth >= 10000000000000000000)
1321                   {
1322                       // calculate prize and give it to winner
1323                       _prize = ((airDropPot_).mul(75)) / 100;
1324                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1325 
1326                       // adjust airDropPot
1327                       airDropPot_ = (airDropPot_).sub(_prize);
1328 
1329                       // let event know a tier 3 prize was won
1330                       _eventData_.compressedData += 300000000000000000000000000000000;
1331                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1332                       // calculate prize and give it to winner
1333                       _prize = ((airDropPot_).mul(50)) / 100;
1334                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1335 
1336                       // adjust airDropPot
1337                       airDropPot_ = (airDropPot_).sub(_prize);
1338 
1339                       // let event know a tier 2 prize was won
1340                       _eventData_.compressedData += 200000000000000000000000000000000;
1341                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1342                       // calculate prize and give it to winner
1343                       _prize = ((airDropPot_).mul(25)) / 100;
1344                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1345 
1346                       // adjust airDropPot
1347                       airDropPot_ = (airDropPot_).sub(_prize);
1348 
1349                       // let event know a tier 3 prize was won
1350                       _eventData_.compressedData += 300000000000000000000000000000000;
1351                   }
1352                   // set airdrop happened bool to true
1353                   _eventData_.compressedData += 10000000000000000000000000000000;
1354                   // let event know how much was won
1355                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1356 
1357                   // reset air drop tracker
1358                   airDropTracker_ = 0;
1359               }
1360           }
1361 
1362               // store the air drop tracker number (number of buys since last airdrop)
1363               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1364 
1365               // update player
1366               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1367               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1368 
1369               // update round
1370               round_[_rID].keys = _keys.add(round_[_rID].keys);
1371               round_[_rID].eth = _eth.add(round_[_rID].eth);
1372               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1373 
1374               // distribute eth
1375               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1376               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1377 
1378               // call end tx function to fire end tx event.
1379   		    endTx(_pID, _team, _eth, _keys, _eventData_);
1380           }
1381       }
1382   //==============================================================================
1383   //     _ _ | _   | _ _|_ _  _ _  .
1384   //    (_(_||(_|_||(_| | (_)| _\  .
1385   //==============================================================================
1386       /**
1387        * @dev calculates unmasked earnings (just calculates, does not update mask)
1388        * @return earnings in wei format
1389        */
1390       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1391           private
1392           view
1393           returns(uint256)
1394       {
1395           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1396       }
1397 
1398       /**
1399        * @dev returns the amount of keys you would get given an amount of eth.
1400        * -functionhash- 0xce89c80c
1401        * @param _rID round ID you want price for
1402        * @param _eth amount of eth sent in
1403        * @return keys received
1404        */
1405       function calcKeysReceived(uint256 _rID, uint256 _eth)
1406           public
1407           view
1408           returns(uint256)
1409       {
1410           // grab time
1411           uint256 _now = now;
1412 
1413           // are we in a round?
1414           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1415               return ( (round_[_rID].eth).keysRec(_eth) );
1416           else // rounds over.  need keys for new round
1417               return ( (_eth).keys() );
1418       }
1419 
1420       /**
1421        * @dev returns current eth price for X keys.
1422        * -functionhash- 0xcf808000
1423        * @param _keys number of keys desired (in 18 decimal format)
1424        * @return amount of eth needed to send
1425        */
1426       function iWantXKeys(uint256 _keys)
1427           public
1428           view
1429           returns(uint256)
1430       {
1431           // setup local rID
1432           uint256 _rID = rID_;
1433 
1434           // grab time
1435           uint256 _now = now;
1436 
1437           // are we in a round?
1438           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1439               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1440           else // rounds over.  need price for new round
1441               return ( (_keys).eth() );
1442       }
1443   //==============================================================================
1444   //    _|_ _  _ | _  .
1445   //     | (_)(_)|_\  .
1446   //==============================================================================
1447       /**
1448   	 * @dev receives name/player info from names contract
1449        */
1450       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1451           external
1452       {
1453           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1454           if (pIDxAddr_[_addr] != _pID)
1455               pIDxAddr_[_addr] = _pID;
1456           if (pIDxName_[_name] != _pID)
1457               pIDxName_[_name] = _pID;
1458           if (plyr_[_pID].addr != _addr)
1459               plyr_[_pID].addr = _addr;
1460           if (plyr_[_pID].name != _name)
1461               plyr_[_pID].name = _name;
1462           if (plyr_[_pID].laff != _laff)
1463               plyr_[_pID].laff = _laff;
1464           if (plyrNames_[_pID][_name] == false)
1465               plyrNames_[_pID][_name] = true;
1466       }
1467 
1468       /**
1469        * @dev receives entire player name list
1470        */
1471       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1472           external
1473       {
1474           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1475           if(plyrNames_[_pID][_name] == false)
1476               plyrNames_[_pID][_name] = true;
1477       }
1478 
1479       /**
1480        * @dev gets existing or registers new pID.  use this when a player may be new
1481        * @return pID
1482        */
1483       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1484           private
1485           returns (F3Ddatasets.EventReturns)
1486       {
1487           uint256 _pID = pIDxAddr_[msg.sender];
1488           // if player is new to this version of fomo3d
1489           if (_pID == 0)
1490           {
1491               // grab their player ID, name and last aff ID, from player names contract
1492               _pID = PlayerBook.getPlayerID(msg.sender);
1493               bytes32 _name = PlayerBook.getPlayerName(_pID);
1494               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1495 
1496               // set up player account
1497               pIDxAddr_[msg.sender] = _pID;
1498               plyr_[_pID].addr = msg.sender;
1499 
1500               if (_name != "")
1501               {
1502                   pIDxName_[_name] = _pID;
1503                   plyr_[_pID].name = _name;
1504                   plyrNames_[_pID][_name] = true;
1505               }
1506 
1507               if (_laff != 0 && _laff != _pID)
1508                   plyr_[_pID].laff = _laff;
1509 
1510               // set the new player bool to true
1511               _eventData_.compressedData = _eventData_.compressedData + 1;
1512           }
1513           return (_eventData_);
1514       }
1515 
1516       /**
1517        * @dev checks to make sure user picked a valid team.  if not sets team
1518        * to default (sneks)
1519        */
1520       function verifyTeam(uint256 _team)
1521           private
1522           pure
1523           returns (uint256)
1524       {
1525           if (_team < 0 || _team > 3)
1526               return(2);
1527           else
1528               return(_team);
1529       }
1530 
1531       /**
1532        * @dev decides if round end needs to be run & new round started.  and if
1533        * player unmasked earnings from previously played rounds need to be moved.
1534        */
1535       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1536           private
1537           returns (F3Ddatasets.EventReturns)
1538       {
1539           // if player has played a previous round, move their unmasked earnings
1540           // from that round to gen vault.
1541           if (plyr_[_pID].lrnd != 0)
1542               updateGenVault(_pID, plyr_[_pID].lrnd);
1543 
1544           // update player's last round played
1545           plyr_[_pID].lrnd = rID_;
1546 
1547           // set the joined round bool to true
1548           _eventData_.compressedData = _eventData_.compressedData + 10;
1549 
1550           return(_eventData_);
1551       }
1552 
1553       /**
1554        * @dev ends the round. manages paying out winner/splitting up pot
1555        */
1556       function endRound(F3Ddatasets.EventReturns memory _eventData_)
1557           private
1558           returns (F3Ddatasets.EventReturns)
1559       {
1560           // setup local rID
1561           uint256 _rID = rID_;
1562 
1563           // grab our winning player and team id's
1564           uint256 _winPID = round_[_rID].plyr;
1565           uint256 _winTID = round_[_rID].team;
1566 
1567           // grab our pot amount
1568           uint256 _pot = round_[_rID].pot;
1569 
1570           // calculate our winner share, community rewards, gen share,
1571           // p3d share, and amount reserved for next pot
1572           uint256 _win = (_pot.mul(48)) / 100;
1573           uint256 _com = (_pot / 50);
1574           uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1575           uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1576           uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1577 
1578           // calculate ppt for round mask
1579           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1580           uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1581           if (_dust > 0)
1582           {
1583               _gen = _gen.sub(_dust);
1584               _res = _res.add(_dust);
1585           }
1586 
1587           // pay our winner
1588           plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1589 
1590           // community rewards
1591 
1592           admin.transfer(_com);
1593 
1594           admin.transfer(_p3d.sub(_p3d / 2));
1595 
1596           round_[_rID].pot = _pot.add(_p3d / 2);
1597 
1598           // distribute gen portion to key holders
1599           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1600 
1601           // prepare event data
1602           _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1603           _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1604           _eventData_.winnerAddr = plyr_[_winPID].addr;
1605           _eventData_.winnerName = plyr_[_winPID].name;
1606           _eventData_.amountWon = _win;
1607           _eventData_.genAmount = _gen;
1608           _eventData_.P3DAmount = _p3d;
1609           _eventData_.newPot = _res;
1610 
1611           // start next round
1612           rID_++;
1613           _rID++;
1614           round_[_rID].strt = now;
1615           round_[_rID].end = now.add(rndInit_).add(rndGap_);
1616           round_[_rID].pot = _res;
1617 
1618           return(_eventData_);
1619       }
1620 
1621       /**
1622        * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1623        */
1624       function updateGenVault(uint256 _pID, uint256 _rIDlast)
1625           private
1626       {
1627           uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1628           if (_earnings > 0)
1629           {
1630               // put in gen vault
1631               plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1632               // zero out their earnings by updating mask
1633               plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1634           }
1635       }
1636 
1637       /**
1638        * @dev updates round timer based on number of whole keys bought.
1639        */
1640       function updateTimer(uint256 _keys, uint256 _rID)
1641           private
1642       {
1643           // grab time
1644           uint256 _now = now;
1645 
1646           // calculate time based on number of keys bought
1647           uint256 _newTime;
1648           if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1649               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1650           else
1651               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1652 
1653           // compare to max and set new end time
1654           if (_newTime < (rndMax_).add(_now))
1655               round_[_rID].end = _newTime;
1656           else
1657               round_[_rID].end = rndMax_.add(_now);
1658       }
1659 
1660       /**
1661        * @dev generates a random number between 0-99 and checks to see if thats
1662        * resulted in an airdrop win
1663        * @return do we have a winner?
1664        */
1665       function airdrop()
1666           private
1667           view
1668           returns(bool)
1669       {
1670           uint256 seed = uint256(keccak256(abi.encodePacked(
1671 
1672               (block.timestamp).add
1673               (block.difficulty).add
1674               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1675               (block.gaslimit).add
1676               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1677               (block.number)
1678 
1679           )));
1680           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1681               return(true);
1682           else
1683               return(false);
1684       }
1685 
1686       /**
1687        * @dev distributes eth based on fees to com, aff, and p3d
1688        */
1689       function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1690           private
1691           returns(F3Ddatasets.EventReturns)
1692       {
1693           // pay 3% out to community rewards
1694           uint256 _p1 = _eth / 100;
1695           uint256 _com = _eth / 50;
1696           _com = _com.add(_p1);
1697 
1698           uint256 _p3d;
1699           if (!address(admin).call.value(_com)())
1700           {
1701               // This ensures Team Just cannot influence the outcome of FoMo3D with
1702               // bank migrations by breaking outgoing transactions.
1703               // Something we would never do. But that's not the point.
1704               // We spent 2000$ in eth re-deploying just to patch this, we hold the
1705               // highest belief that everything we create should be trustless.
1706               // Team JUST, The name you shouldn't have to trust.
1707               _p3d = _com;
1708               _com = 0;
1709           }
1710 
1711 
1712           // distribute share to affiliate
1713           uint256 _aff = _eth / 10;
1714 
1715           // decide what to do with affiliate share of fees
1716           // affiliate must not be self, and must have a name registered
1717           if (_affID != _pID && plyr_[_affID].name != '') {
1718               plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1719               emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1720           } else {
1721               _p3d = _aff;
1722           }
1723 
1724           // pay out p3d
1725           _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1726           if (_p3d > 0)
1727           {
1728               // deposit to divies contract
1729               uint256 _potAmount = _p3d / 2;
1730 
1731               admin.transfer(_p3d.sub(_potAmount));
1732 
1733               round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1734 
1735               // set up event data
1736               _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1737           }
1738 
1739           return(_eventData_);
1740       }
1741 
1742       function potSwap()
1743           external
1744           payable
1745       {
1746           // setup local rID
1747           uint256 _rID = rID_ + 1;
1748 
1749           round_[_rID].pot = round_[_rID].pot.add(msg.value);
1750           emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1751       }
1752 
1753       /**
1754        * @dev distributes eth based on fees to gen and pot
1755        */
1756       function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1757           private
1758           returns(F3Ddatasets.EventReturns)
1759       {
1760           // calculate gen share
1761           uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1762 
1763           // toss 1% into airdrop pot
1764           uint256 _air = (_eth / 100);
1765           airDropPot_ = airDropPot_.add(_air);
1766 
1767           // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1768           _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1769 
1770           // calculate pot
1771           uint256 _pot = _eth.sub(_gen);
1772 
1773           // distribute gen share (thats what updateMasks() does) and adjust
1774           // balances for dust.
1775           uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1776           if (_dust > 0)
1777               _gen = _gen.sub(_dust);
1778 
1779           // add eth to pot
1780           round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1781 
1782           // set up event data
1783           _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1784           _eventData_.potAmount = _pot;
1785 
1786           return(_eventData_);
1787       }
1788 
1789       /**
1790        * @dev updates masks for round and player when keys are bought
1791        * @return dust left over
1792        */
1793       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1794           private
1795           returns(uint256)
1796       {
1797           /* MASKING NOTES
1798               earnings masks are a tricky thing for people to wrap their minds around.
1799               the basic thing to understand here.  is were going to have a global
1800               tracker based on profit per share for each round, that increases in
1801               relevant proportion to the increase in share supply.
1802 
1803               the player will have an additional mask that basically says "based
1804               on the rounds mask, my shares, and how much i've already withdrawn,
1805               how much is still owed to me?"
1806           */
1807 
1808           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1809           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1810           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1811 
1812           // calculate player earning from their own buy (only based on the keys
1813           // they just bought).  & update player earnings mask
1814           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1815           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1816 
1817           // calculate & return dust
1818           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1819       }
1820 
1821       /**
1822        * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1823        * @return earnings in wei format
1824        */
1825       function withdrawEarnings(uint256 _pID)
1826           private
1827           returns(uint256)
1828       {
1829           // update gen vault
1830           updateGenVault(_pID, plyr_[_pID].lrnd);
1831 
1832           // from vaults
1833           uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1834           if (_earnings > 0)
1835           {
1836               plyr_[_pID].win = 0;
1837               plyr_[_pID].gen = 0;
1838               plyr_[_pID].aff = 0;
1839           }
1840 
1841           return(_earnings);
1842       }
1843 
1844       /**
1845        * @dev prepares compression data and fires event for buy or reload tx's
1846        */
1847       function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1848           private
1849       {
1850           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1851           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1852 
1853           emit F3Devents.onEndTx
1854           (
1855               _eventData_.compressedData,
1856               _eventData_.compressedIDs,
1857               plyr_[_pID].name,
1858               msg.sender,
1859               _eth,
1860               _keys,
1861               _eventData_.winnerAddr,
1862               _eventData_.winnerName,
1863               _eventData_.amountWon,
1864               _eventData_.newPot,
1865               _eventData_.P3DAmount,
1866               _eventData_.genAmount,
1867               _eventData_.potAmount,
1868               airDropPot_
1869           );
1870       }
1871   //==============================================================================
1872   //    (~ _  _    _._|_    .
1873   //    _)(/_(_|_|| | | \/  .
1874   //====================/=========================================================
1875       /** upon contract deploy, it will be deactivated.  this is a one time
1876        * use function that will activate the contract.  we do this so devs
1877        * have time to set things up on the web end                            **/
1878       bool public activated_ = false;
1879       function activate()
1880           public
1881       {
1882           // only team just can activate
1883           require(msg.sender == admin, "only admin can activate");
1884 
1885 
1886           // can only be ran once
1887           require(activated_ == false, "FOMO Short already activated");
1888 
1889           // activate the contract
1890           activated_ = true;
1891 
1892           // lets start first round
1893           rID_ = 1;
1894               round_[1].strt = now + rndExtra_ - rndGap_;
1895               round_[1].end = now + rndInit_ + rndExtra_;
1896       }
1897   }