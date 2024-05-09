1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
9  * - added sqrt
10  * - added sq
11  * - added pwr
12  * - changed asserts to requires with error log outputs
13  * - removed div, its useless
14  */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b)
21         internal
22         pure
23         returns (uint256 c)
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256)
40     {
41         require(b <= a, "SafeMath sub failed");
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b)
49         internal
50         pure
51         returns (uint256 c)
52     {
53         c = a + b;
54         require(c >= a, "SafeMath add failed");
55         return c;
56     }
57 
58     /**
59      * @dev gives square root of given x.
60      */
61     function sqrt(uint256 x)
62         internal
63         pure
64         returns (uint256 y)
65     {
66         uint256 z = ((add(x,1)) / 2);
67         y = x;
68         while (z < y)
69         {
70             y = z;
71             z = ((add((x / z),z)) / 2);
72         }
73     }
74 
75     /**
76      * @dev gives square. multiplies x by x
77      */
78     function sq(uint256 x)
79         internal
80         pure
81         returns (uint256)
82     {
83         return (mul(x,x));
84     }
85 
86     /**
87      * @dev x to the power of y
88      */
89     function pwr(uint256 x, uint256 y)
90         internal
91         pure
92         returns (uint256)
93     {
94         if (x==0)
95             return (0);
96         else if (y==0)
97             return (1);
98         else
99         {
100             uint256 z = x;
101             for (uint256 i=1; i < y; i++)
102                 z = mul(z,x);
103             return (z);
104         }
105     }
106 }
107 
108 library NameFilter {
109     /**
110      * @dev filters name strings
111      * -converts uppercase to lower case.
112      * -makes sure it does not start/end with a space
113      * -makes sure it does not contain multiple spaces in a row
114      * -cannot be only numbers
115      * -cannot start with 0x
116      * -restricts characters to A-Z, a-z, 0-9, and space.
117      * @return reprocessed string in bytes32 format
118      */
119     function nameFilter(string _input)
120         internal
121         pure
122         returns(bytes32)
123     {
124         bytes memory _temp = bytes(_input);
125         uint256 _length = _temp.length;
126 
127         //sorry limited to 32 characters
128         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
129         // make sure it doesnt start with or end with space
130         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
131         // make sure first two characters are not 0x
132         if (_temp[0] == 0x30)
133         {
134             require(_temp[1] != 0x78, "string cannot start with 0x");
135             require(_temp[1] != 0x58, "string cannot start with 0X");
136         }
137 
138         // create a bool to track if we have a non number character
139         bool _hasNonNumber;
140 
141         // convert & check
142         for (uint256 i = 0; i < _length; i++)
143         {
144             // if its uppercase A-Z
145             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
146             {
147                 // convert to lower case a-z
148                 _temp[i] = byte(uint(_temp[i]) + 32);
149 
150                 // we have a non number
151                 if (_hasNonNumber == false)
152                     _hasNonNumber = true;
153             } else {
154                 require
155                 (
156                     // require character is a space
157                     _temp[i] == 0x20 ||
158                     // OR lowercase a-z
159                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
160                     // or 0-9
161                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
162                     "string contains invalid characters"
163                 );
164                 // make sure theres not 2x spaces in a row
165                 if (_temp[i] == 0x20)
166                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
167 
168                 // see if we have a character other than a number
169                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
170                     _hasNonNumber = true;
171             }
172         }
173 
174         require(_hasNonNumber == true, "string cannot be only numbers");
175 
176         bytes32 _ret;
177         assembly {
178             _ret := mload(add(_temp, 32))
179         }
180         return (_ret);
181     }
182 }
183 
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
448     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
449     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
450     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
451 }
452 
453 
454 contract modularFast is F3Devents {}
455 
456 contract FoMo3DFast is modularFast {
457       using SafeMath for *;
458       using NameFilter for string;
459       using F3DKeysCalcShort for uint256;
460 
461       PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x27D5C0C175C1Ba67986319ac297d2F4D3bC2b7b2);
462 
463       address private admin = msg.sender;
464       bool public activated_ = false;
465       string constant public name = "FOMO Test";
466       string constant public symbol = "Test";
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
699      function buyXnameQR(address _realSender,bytes32 _affCode, uint256 _team)
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
933       
934           /**
935        * @dev withdraws all of your earnings.
936        * -functionhash- 0x3ccfd60b
937        */
938       function withdrawQR(address _realSender)
939           isActivated()
940           payable
941           public
942       {
943           // setup local rID
944           uint256 _rID = rID_;
945 
946           // grab time
947           uint256 _now = now;
948 
949           // fetch player ID
950           uint256 _pID = pIDxAddr_[_realSender];
951 
952           // setup temp var for player eth
953           uint256 _eth;
954 
955           // check to see if round has ended and no one has run round end yet
956           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
957           {
958               // set up our tx event data
959               F3Ddatasets.EventReturns memory _eventData_;
960 
961               // end the round (distributes pot)
962   			round_[_rID].ended = true;
963               _eventData_ = endRound(_eventData_);
964 
965   			// get their earnings
966               _eth = withdrawEarnings(_pID);
967 
968               // gib moni
969               if (_eth > 0)
970                   plyr_[_pID].addr.transfer(_eth);
971 
972               // build event data
973               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
974               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
975 
976               // fire withdraw and distribute event
977               emit F3Devents.onWithdrawAndDistribute
978               (
979                   _realSender,
980                   plyr_[_pID].name,
981                   _eth,
982                   _eventData_.compressedData,
983                   _eventData_.compressedIDs,
984                   _eventData_.winnerAddr,
985                   _eventData_.winnerName,
986                   _eventData_.amountWon,
987                   _eventData_.newPot,
988                   _eventData_.P3DAmount,
989                   _eventData_.genAmount
990               );
991 
992           // in any other situation
993           } else {
994               // get their earnings
995               _eth = withdrawEarnings(_pID);
996 
997               // gib moni
998               if (_eth > 0)
999                   plyr_[_pID].addr.transfer(_eth);
1000 
1001               // fire withdraw event
1002               emit F3Devents.onWithdraw(_pID, _realSender, plyr_[_pID].name, _eth, _now);
1003           }
1004       }
1005       
1006 
1007       /**
1008        * @dev use these to register names.  they are just wrappers that will send the
1009        * registration requests to the PlayerBook contract.  So registering here is the
1010        * same as registering there.  UI will always display the last name you registered.
1011        * but you will still own all previously registered names to use as affiliate
1012        * links.
1013        * - must pay a registration fee.
1014        * - name must be unique
1015        * - names will be converted to lowercase
1016        * - name cannot start or end with a space
1017        * - cannot have more than 1 space in a row
1018        * - cannot be only numbers
1019        * - cannot start with 0x
1020        * - name must be at least 1 char
1021        * - max length of 32 characters long
1022        * - allowed characters: a-z, 0-9, and space
1023        * -functionhash- 0x921dec21 (using ID for affiliate)
1024        * -functionhash- 0x3ddd4698 (using address for affiliate)
1025        * -functionhash- 0x685ffd83 (using name for affiliate)
1026        * @param _nameString players desired name
1027        * @param _affCode affiliate ID, address, or name of who referred you
1028        * @param _all set to true if you want this to push your info to all games
1029        * (this might cost a lot of gas)
1030        */
1031 
1032     //   function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1033     //       isHuman()
1034     //       public
1035     //       payable
1036     //   {
1037     //       bytes32 _name = _nameString.nameFilter();
1038     //       address _addr = msg.sender;
1039     //       uint256 _paid = msg.value;
1040     //       (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
1041 
1042     //       uint256 _pID = pIDxAddr_[_addr];
1043 
1044     //       // fire event
1045     //       emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1046     //   }
1047 
1048     //   function registerNameXaddr(string _nameString, address _affCode, bool _all)
1049     //       isHuman()
1050     //       public
1051     //       payable
1052     //   {
1053     //       bytes32 _name = _nameString.nameFilter();
1054     //       address _addr = msg.sender;
1055     //       uint256 _paid = msg.value;
1056     //       (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1057 
1058     //       uint256 _pID = pIDxAddr_[_addr];
1059 
1060     //       // fire event
1061     //       emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1062     //   }
1063 
1064     //   function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1065     //       isHuman()
1066     //       public
1067     //       payable
1068     //   {
1069     //       bytes32 _name = _nameString.nameFilter();
1070     //       address _addr = msg.sender;
1071     //       uint256 _paid = msg.value;
1072     //       (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1073 
1074     //       uint256 _pID = pIDxAddr_[_addr];
1075 
1076     //       // fire event
1077     //       emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1078     //   }
1079       
1080       
1081   //==============================================================================
1082   //     _  _ _|__|_ _  _ _  .
1083   //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1084   //=====_|=======================================================================
1085       /**
1086        * @dev return the price buyer will pay for next 1 individual key.
1087        * -functionhash- 0x018a25e8
1088        * @return price for next key bought (in wei format)
1089        */
1090       function getBuyPrice()
1091           public
1092           view
1093           returns(uint256)
1094       {
1095           // setup local rID
1096           uint256 _rID = rID_;
1097 
1098           // grab time
1099           uint256 _now = now;
1100 
1101           // are we in a round?
1102           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1103               return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1104           else // rounds over.  need price for new round
1105               return ( 75000000000000 ); // init
1106       }
1107 
1108       /**
1109        * @dev returns time left.  dont spam this, you'll ddos yourself from your node
1110        * provider
1111        * -functionhash- 0xc7e284b8
1112        * @return time left in seconds
1113        */
1114       function getTimeLeft()
1115           public
1116           view
1117           returns(uint256)
1118       {
1119           // setup local rID
1120           uint256 _rID = rID_;
1121 
1122           // grab time
1123           uint256 _now = now;
1124 
1125           if (_now < round_[_rID].end)
1126               if (_now > round_[_rID].strt + rndGap_)
1127                   return( (round_[_rID].end).sub(_now) );
1128               else
1129                   return( (round_[_rID].strt + rndGap_).sub(_now) );
1130           else
1131               return(0);
1132       }
1133 
1134       /**
1135        * @dev returns player earnings per vaults
1136        * -functionhash- 0x63066434
1137        * @return winnings vault
1138        * @return general vault
1139        * @return affiliate vault
1140        */
1141       function getPlayerVaults(uint256 _pID)
1142           public
1143           view
1144           returns(uint256 ,uint256, uint256)
1145       {
1146           // setup local rID
1147           uint256 _rID = rID_;
1148 
1149           // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1150           if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1151           {
1152               // if player is winner
1153               if (round_[_rID].plyr == _pID)
1154               {
1155                   return
1156                   (
1157                       (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1158                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1159                       plyr_[_pID].aff
1160                   );
1161               // if player is not the winner
1162               } else {
1163                   return
1164                   (
1165                       plyr_[_pID].win,
1166                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1167                       plyr_[_pID].aff
1168                   );
1169               }
1170 
1171           // if round is still going on, or round has ended and round end has been ran
1172           } else {
1173               return
1174               (
1175                   plyr_[_pID].win,
1176                   (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1177                   plyr_[_pID].aff
1178               );
1179           }
1180       }
1181 
1182       /**
1183        * solidity hates stack limits.  this lets us avoid that hate
1184        */
1185       function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1186           private
1187           view
1188           returns(uint256)
1189       {
1190           return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1191       }
1192 
1193       /**
1194        * @dev returns all current round info needed for front end
1195        * -functionhash- 0x747dff42
1196        * @return eth invested during ICO phase
1197        * @return round id
1198        * @return total keys for round
1199        * @return time round ends
1200        * @return time round started
1201        * @return current pot
1202        * @return current team ID & player ID in lead
1203        * @return current player in leads address
1204        * @return current player in leads name
1205        * @return whales eth in for round
1206        * @return bears eth in for round
1207        * @return sneks eth in for round
1208        * @return bulls eth in for round
1209        * @return airdrop tracker # & airdrop pot
1210        */
1211       function getCurrentRoundInfo()
1212           public
1213           view
1214           returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1215       {
1216           // setup local rID
1217           uint256 _rID = rID_;
1218 
1219           return
1220           (
1221               round_[_rID].ico,               //0
1222               _rID,                           //1
1223               round_[_rID].keys,              //2
1224               round_[_rID].end,               //3
1225               round_[_rID].strt,              //4
1226               round_[_rID].pot,               //5
1227               (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1228               plyr_[round_[_rID].plyr].addr,  //7
1229               plyr_[round_[_rID].plyr].name,  //8
1230               rndTmEth_[_rID][0],             //9
1231               rndTmEth_[_rID][1],             //10
1232               rndTmEth_[_rID][2],             //11
1233               rndTmEth_[_rID][3],             //12
1234               airDropTracker_ + (airDropPot_ * 1000)              //13
1235           );
1236       }
1237 
1238       /**
1239        * @dev returns player info based on address.  if no address is given, it will
1240        * use msg.sender
1241        * -functionhash- 0xee0b5d8b
1242        * @param _addr address of the player you want to lookup
1243        * @return player ID
1244        * @return player name
1245        * @return keys owned (current round)
1246        * @return winnings vault
1247        * @return general vault
1248        * @return affiliate vault
1249   	 * @return player round eth
1250        */
1251       function getPlayerInfoByAddress(address _addr)
1252           public
1253           view
1254           returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1255       {
1256           // setup local rID
1257           uint256 _rID = rID_;
1258 
1259           if (_addr == address(0))
1260           {
1261               _addr == msg.sender;
1262           }
1263           uint256 _pID = pIDxAddr_[_addr];
1264 
1265           return
1266           (
1267               _pID,                               //0
1268               plyr_[_pID].name,                   //1
1269               plyrRnds_[_pID][_rID].keys,         //2
1270               plyr_[_pID].win,                    //3
1271               (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1272               plyr_[_pID].aff,                    //5
1273               plyrRnds_[_pID][_rID].eth           //6
1274           );
1275       }
1276 
1277   //==============================================================================
1278   //     _ _  _ _   | _  _ . _  .
1279   //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1280   //=====================_|=======================================================
1281       /**
1282        * @dev logic runs whenever a buy order is executed.  determines how to handle
1283        * incoming eth depending on if we are in an active round or not
1284        */
1285       function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1286           private
1287       {
1288           // setup local rID
1289           uint256 _rID = rID_;
1290 
1291           // grab time
1292           uint256 _now = now;
1293 
1294           // if round is active
1295           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1296           {
1297               // call core
1298               core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1299 
1300           // if round is not active
1301           } else {
1302               // check to see if end round needs to be ran
1303               if (_now > round_[_rID].end && round_[_rID].ended == false)
1304               {
1305                   // end the round (distributes pot) & start new round
1306   			    round_[_rID].ended = true;
1307                   _eventData_ = endRound(_eventData_);
1308 
1309                   // build event data
1310                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1311                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1312 
1313                   // fire buy and distribute event
1314                   emit F3Devents.onBuyAndDistribute
1315                   (
1316                       msg.sender,
1317                       plyr_[_pID].name,
1318                       msg.value,
1319                       _eventData_.compressedData,
1320                       _eventData_.compressedIDs,
1321                       _eventData_.winnerAddr,
1322                       _eventData_.winnerName,
1323                       _eventData_.amountWon,
1324                       _eventData_.newPot,
1325                       _eventData_.P3DAmount,
1326                       _eventData_.genAmount
1327                   );
1328               }
1329 
1330               // put eth in players vault
1331               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1332           }
1333       }
1334       
1335       
1336       /**
1337        * @dev logic runs whenever a buy order is executed.  determines how to handle
1338        * incoming eth depending on if we are in an active round or not
1339        */
1340       function buyCoreQR(address _realSender,uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1341           private
1342       {
1343           // setup local rID
1344           uint256 _rID = rID_;
1345 
1346           // grab time
1347           uint256 _now = now;
1348 
1349           // if round is active
1350           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1351           {
1352               // call core
1353               coreQR(_realSender,_rID, _pID, msg.value, _affID, _team, _eventData_);
1354 
1355           // if round is not active
1356           } else {
1357               // check to see if end round needs to be ran
1358               if (_now > round_[_rID].end && round_[_rID].ended == false)
1359               {
1360                   // end the round (distributes pot) & start new round
1361   			    round_[_rID].ended = true;
1362                   _eventData_ = endRound(_eventData_);
1363 
1364                   // build event data
1365                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1366                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1367 
1368                   // fire buy and distribute event
1369                   emit F3Devents.onBuyAndDistribute
1370                   (
1371                       _realSender,
1372                       plyr_[_pID].name,
1373                       msg.value,
1374                       _eventData_.compressedData,
1375                       _eventData_.compressedIDs,
1376                       _eventData_.winnerAddr,
1377                       _eventData_.winnerName,
1378                       _eventData_.amountWon,
1379                       _eventData_.newPot,
1380                       _eventData_.P3DAmount,
1381                       _eventData_.genAmount
1382                   );
1383               }
1384 
1385               // put eth in players vault
1386               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1387           }
1388       }
1389 
1390       /**
1391        * @dev logic runs whenever a reload order is executed.  determines how to handle
1392        * incoming eth depending on if we are in an active round or not
1393        */
1394       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1395           private
1396       {
1397           // setup local rID
1398           uint256 _rID = rID_;
1399 
1400           // grab time
1401           uint256 _now = now;
1402 
1403           // if round is active
1404           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1405           {
1406               // get earnings from all vaults and return unused to gen vault
1407               // because we use a custom safemath library.  this will throw if player
1408               // tried to spend more eth than they have.
1409               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1410 
1411               // call core
1412               core(_rID, _pID, _eth, _affID, _team, _eventData_);
1413 
1414           // if round is not active and end round needs to be ran
1415           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1416               // end the round (distributes pot) & start new round
1417               round_[_rID].ended = true;
1418               _eventData_ = endRound(_eventData_);
1419 
1420               // build event data
1421               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1422               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1423 
1424               // fire buy and distribute event
1425               emit F3Devents.onReLoadAndDistribute
1426               (
1427                   msg.sender,
1428                   plyr_[_pID].name,
1429                   _eventData_.compressedData,
1430                   _eventData_.compressedIDs,
1431                   _eventData_.winnerAddr,
1432                   _eventData_.winnerName,
1433                   _eventData_.amountWon,
1434                   _eventData_.newPot,
1435                   _eventData_.P3DAmount,
1436                   _eventData_.genAmount
1437               );
1438           }
1439       }
1440 
1441       /**
1442        * @dev this is the core logic for any buy/reload that happens while a round
1443        * is live.
1444        */
1445       function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1446           private
1447       {
1448           // if player is new to round
1449           if (plyrRnds_[_pID][_rID].keys == 0)
1450               _eventData_ = managePlayer(_pID, _eventData_);
1451 
1452           // early round eth limiter
1453           if (round_[_rID].eth < 400000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 4000000000000000000)
1454           {
1455               uint256 _availableLimit = (4000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1456               uint256 _refund = _eth.sub(_availableLimit);
1457               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1458               _eth = _availableLimit;
1459           }
1460 
1461           // if eth left is greater than min eth allowed (sorry no pocket lint)
1462           if (_eth > 1000000000)
1463           {
1464 
1465               // mint the new keys
1466               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1467 
1468               // if they bought at least 1 whole key
1469               if (_keys >= 1000000000000000000)
1470               {
1471               updateTimer(_keys, _rID);
1472 
1473               // set new leaders
1474               if (round_[_rID].plyr != _pID)
1475                   round_[_rID].plyr = _pID;
1476               if (round_[_rID].team != _team)
1477                   round_[_rID].team = _team;
1478 
1479               // set the new leader bool to true
1480               _eventData_.compressedData = _eventData_.compressedData + 100;
1481           }
1482 
1483               // manage airdrops
1484               if (_eth >= 100000000000000000)
1485               {
1486               airDropTracker_++;
1487               if (airdrop() == true)
1488               {
1489                   // gib muni
1490                   uint256 _prize;
1491                   if (_eth >= 10000000000000000000)
1492                   {
1493                       // calculate prize and give it to winner
1494                       _prize = ((airDropPot_).mul(75)) / 100;
1495                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1496 
1497                       // adjust airDropPot
1498                       airDropPot_ = (airDropPot_).sub(_prize);
1499 
1500                       // let event know a tier 3 prize was won
1501                       _eventData_.compressedData += 300000000000000000000000000000000;
1502                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1503                       // calculate prize and give it to winner
1504                       _prize = ((airDropPot_).mul(50)) / 100;
1505                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1506 
1507                       // adjust airDropPot
1508                       airDropPot_ = (airDropPot_).sub(_prize);
1509 
1510                       // let event know a tier 2 prize was won
1511                       _eventData_.compressedData += 200000000000000000000000000000000;
1512                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1513                       // calculate prize and give it to winner
1514                       _prize = ((airDropPot_).mul(25)) / 100;
1515                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1516 
1517                       // adjust airDropPot
1518                       airDropPot_ = (airDropPot_).sub(_prize);
1519 
1520                       // let event know a tier 3 prize was won
1521                       _eventData_.compressedData += 300000000000000000000000000000000;
1522                   }
1523                   // set airdrop happened bool to true
1524                   _eventData_.compressedData += 10000000000000000000000000000000;
1525                   // let event know how much was won
1526                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1527 
1528                   // reset air drop tracker
1529                   airDropTracker_ = 0;
1530               }
1531           }
1532 
1533               // store the air drop tracker number (number of buys since last airdrop)
1534               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1535 
1536               // update player
1537               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1538               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1539 
1540               // update round
1541               round_[_rID].keys = _keys.add(round_[_rID].keys);
1542               round_[_rID].eth = _eth.add(round_[_rID].eth);
1543               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1544 
1545               // distribute eth
1546               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1547               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1548 
1549               // call end tx function to fire end tx event.
1550   		    endTx(_pID, _team, _eth, _keys, _eventData_);
1551           }
1552       }
1553       
1554       /**
1555        * @dev this is the core logic for any buy/reload that happens while a round
1556        * is live.
1557        */
1558       function coreQR(address _realSender,uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1559           private
1560       {
1561           // if player is new to round
1562           if (plyrRnds_[_pID][_rID].keys == 0)
1563               _eventData_ = managePlayer(_pID, _eventData_);
1564 
1565           // early round eth limiter
1566           if (round_[_rID].eth < 400000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 4000000000000000000)
1567           {
1568               uint256 _availableLimit = (4000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1569               uint256 _refund = _eth.sub(_availableLimit);
1570               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1571               _eth = _availableLimit;
1572           }
1573 
1574           // if eth left is greater than min eth allowed (sorry no pocket lint)
1575           if (_eth > 1000000000)
1576           {
1577 
1578               // mint the new keys
1579               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1580 
1581               // if they bought at least 1 whole key
1582               if (_keys >= 1000000000000000000)
1583               {
1584               updateTimer(_keys, _rID);
1585 
1586               // set new leaders
1587               if (round_[_rID].plyr != _pID)
1588                   round_[_rID].plyr = _pID;
1589               if (round_[_rID].team != _team)
1590                   round_[_rID].team = _team;
1591 
1592               // set the new leader bool to true
1593               _eventData_.compressedData = _eventData_.compressedData + 100;
1594           }
1595 
1596               // manage airdrops
1597               if (_eth >= 100000000000000000)
1598               {
1599               airDropTracker_++;
1600               if (airdrop() == true)
1601               {
1602                   // gib muni
1603                   uint256 _prize;
1604                   if (_eth >= 10000000000000000000)
1605                   {
1606                       // calculate prize and give it to winner
1607                       _prize = ((airDropPot_).mul(75)) / 100;
1608                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1609 
1610                       // adjust airDropPot
1611                       airDropPot_ = (airDropPot_).sub(_prize);
1612 
1613                       // let event know a tier 3 prize was won
1614                       _eventData_.compressedData += 300000000000000000000000000000000;
1615                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1616                       // calculate prize and give it to winner
1617                       _prize = ((airDropPot_).mul(50)) / 100;
1618                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1619 
1620                       // adjust airDropPot
1621                       airDropPot_ = (airDropPot_).sub(_prize);
1622 
1623                       // let event know a tier 2 prize was won
1624                       _eventData_.compressedData += 200000000000000000000000000000000;
1625                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1626                       // calculate prize and give it to winner
1627                       _prize = ((airDropPot_).mul(25)) / 100;
1628                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1629 
1630                       // adjust airDropPot
1631                       airDropPot_ = (airDropPot_).sub(_prize);
1632 
1633                       // let event know a tier 3 prize was won
1634                       _eventData_.compressedData += 300000000000000000000000000000000;
1635                   }
1636                   // set airdrop happened bool to true
1637                   _eventData_.compressedData += 10000000000000000000000000000000;
1638                   // let event know how much was won
1639                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1640 
1641                   // reset air drop tracker
1642                   airDropTracker_ = 0;
1643               }
1644           }
1645 
1646               // store the air drop tracker number (number of buys since last airdrop)
1647               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1648 
1649               // update player
1650               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1651               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1652 
1653               // update round
1654               round_[_rID].keys = _keys.add(round_[_rID].keys);
1655               round_[_rID].eth = _eth.add(round_[_rID].eth);
1656               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1657 
1658               // distribute eth
1659               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1660               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1661 
1662               // call end tx function to fire end tx event.
1663   		    endTxQR(_realSender,_pID, _team, _eth, _keys, _eventData_);
1664           }
1665       }
1666       
1667   //==============================================================================
1668   //     _ _ | _   | _ _|_ _  _ _  .
1669   //    (_(_||(_|_||(_| | (_)| _\  .
1670   //==============================================================================
1671       /**
1672        * @dev calculates unmasked earnings (just calculates, does not update mask)
1673        * @return earnings in wei format
1674        */
1675       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1676           private
1677           view
1678           returns(uint256)
1679       {
1680           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1681       }
1682 
1683       /**
1684        * @dev returns the amount of keys you would get given an amount of eth.
1685        * -functionhash- 0xce89c80c
1686        * @param _rID round ID you want price for
1687        * @param _eth amount of eth sent in
1688        * @return keys received
1689        */
1690       function calcKeysReceived(uint256 _rID, uint256 _eth)
1691           public
1692           view
1693           returns(uint256)
1694       {
1695           // grab time
1696           uint256 _now = now;
1697 
1698           // are we in a round?
1699           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1700               return ( (round_[_rID].eth).keysRec(_eth) );
1701           else // rounds over.  need keys for new round
1702               return ( (_eth).keys() );
1703       }
1704 
1705       /**
1706        * @dev returns current eth price for X keys.
1707        * -functionhash- 0xcf808000
1708        * @param _keys number of keys desired (in 18 decimal format)
1709        * @return amount of eth needed to send
1710        */
1711       function iWantXKeys(uint256 _keys)
1712           public
1713           view
1714           returns(uint256)
1715       {
1716           // setup local rID
1717           uint256 _rID = rID_;
1718 
1719           // grab time
1720           uint256 _now = now;
1721 
1722           // are we in a round?
1723           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1724               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1725           else // rounds over.  need price for new round
1726               return ( (_keys).eth() );
1727       }
1728   //==============================================================================
1729   //    _|_ _  _ | _  .
1730   //     | (_)(_)|_\  .
1731   //==============================================================================
1732       /**
1733   	 * @dev receives name/player info from names contract
1734        */
1735       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1736           external
1737       {
1738           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1739           if (pIDxAddr_[_addr] != _pID)
1740               pIDxAddr_[_addr] = _pID;
1741           if (pIDxName_[_name] != _pID)
1742               pIDxName_[_name] = _pID;
1743           if (plyr_[_pID].addr != _addr)
1744               plyr_[_pID].addr = _addr;
1745           if (plyr_[_pID].name != _name)
1746               plyr_[_pID].name = _name;
1747           if (plyr_[_pID].laff != _laff)
1748               plyr_[_pID].laff = _laff;
1749           if (plyrNames_[_pID][_name] == false)
1750               plyrNames_[_pID][_name] = true;
1751       }
1752 
1753       /**
1754        * @dev receives entire player name list
1755        */
1756       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1757           external
1758       {
1759           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1760           if(plyrNames_[_pID][_name] == false)
1761               plyrNames_[_pID][_name] = true;
1762       }
1763 
1764       /**
1765        * @dev gets existing or registers new pID.  use this when a player may be new
1766        * @return pID
1767        */
1768       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1769           private
1770           returns (F3Ddatasets.EventReturns)
1771       {
1772           uint256 _pID = pIDxAddr_[msg.sender];
1773           // if player is new to this version of fomo3d
1774           if (_pID == 0)
1775           {
1776               // grab their player ID, name and last aff ID, from player names contract
1777               _pID = PlayerBook.getPlayerID(msg.sender);
1778               bytes32 _name = PlayerBook.getPlayerName(_pID);
1779               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1780 
1781               // set up player account
1782               pIDxAddr_[msg.sender] = _pID;
1783               plyr_[_pID].addr = msg.sender;
1784 
1785               if (_name != "")
1786               {
1787                   pIDxName_[_name] = _pID;
1788                   plyr_[_pID].name = _name;
1789                   plyrNames_[_pID][_name] = true;
1790               }
1791 
1792               if (_laff != 0 && _laff != _pID)
1793                   plyr_[_pID].laff = _laff;
1794 
1795               // set the new player bool to true
1796               _eventData_.compressedData = _eventData_.compressedData + 1;
1797           }
1798           return (_eventData_);
1799       }
1800       
1801       
1802       /**
1803        * @dev gets existing or registers new pID.  use this when a player may be new
1804        * @return pID
1805        */
1806       function determinePIDQR(address _realSender, F3Ddatasets.EventReturns memory _eventData_)
1807           private
1808           returns (F3Ddatasets.EventReturns)
1809       {
1810           uint256 _pID = pIDxAddr_[_realSender];
1811           // if player is new to this version of fomo3d
1812           if (_pID == 0)
1813           {
1814               // grab their player ID, name and last aff ID, from player names contract
1815               _pID = PlayerBook.getPlayerID(_realSender);
1816               bytes32 _name = PlayerBook.getPlayerName(_pID);
1817               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1818 
1819               // set up player account
1820               pIDxAddr_[_realSender] = _pID;
1821               plyr_[_pID].addr = _realSender;
1822 
1823               if (_name != "")
1824               {
1825                   pIDxName_[_name] = _pID;
1826                   plyr_[_pID].name = _name;
1827                   plyrNames_[_pID][_name] = true;
1828               }
1829 
1830               if (_laff != 0 && _laff != _pID)
1831                   plyr_[_pID].laff = _laff;
1832 
1833               // set the new player bool to true
1834               _eventData_.compressedData = _eventData_.compressedData + 1;
1835           }
1836           return (_eventData_);
1837       }
1838       
1839       
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
1919           admin.transfer(_p3d);
1920           //admin.transfer(_p3d.sub(_p3d / 2));
1921 
1922           //round_[_rID].pot = _pot.add(_p3d / 2);
1923 
1924           // distribute gen portion to key holders
1925           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1926 
1927           // prepare event data
1928           _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1929           _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1930           _eventData_.winnerAddr = plyr_[_winPID].addr;
1931           _eventData_.winnerName = plyr_[_winPID].name;
1932           _eventData_.amountWon = _win;
1933           _eventData_.genAmount = _gen;
1934           _eventData_.P3DAmount = _p3d;
1935           _eventData_.newPot = _res;
1936 
1937           // start next round
1938           rID_++;
1939           _rID++;
1940           round_[_rID].strt = now;
1941           round_[_rID].end = now.add(rndInit_).add(rndGap_);
1942           round_[_rID].pot = _res;
1943 
1944           return(_eventData_);
1945       }
1946 
1947       /**
1948        * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1949        */
1950       function updateGenVault(uint256 _pID, uint256 _rIDlast)
1951           private
1952       {
1953           uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1954           if (_earnings > 0)
1955           {
1956               // put in gen vault
1957               plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1958               // zero out their earnings by updating mask
1959               plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1960           }
1961       }
1962 
1963       /**
1964        * @dev updates round timer based on number of whole keys bought.
1965        */
1966       function updateTimer(uint256 _keys, uint256 _rID)
1967           private
1968       {
1969           // grab time
1970           uint256 _now = now;
1971 
1972           // calculate time based on number of keys bought
1973           uint256 _newTime;
1974           if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1975               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1976           else
1977               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1978 
1979           // compare to max and set new end time
1980           if (_newTime < (rndMax_).add(_now))
1981               round_[_rID].end = _newTime;
1982           else
1983               round_[_rID].end = rndMax_.add(_now);
1984       }
1985 
1986       /**
1987        * @dev generates a random number between 0-99 and checks to see if thats
1988        * resulted in an airdrop win
1989        * @return do we have a winner?
1990        */
1991       function airdrop()
1992           private
1993           view
1994           returns(bool)
1995       {
1996           uint256 seed = uint256(keccak256(abi.encodePacked(
1997 
1998               (block.timestamp).add
1999               (block.difficulty).add
2000               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
2001               (block.gaslimit).add
2002               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
2003               (block.number)
2004 
2005           )));
2006           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
2007               return(true);
2008           else
2009               return(false);
2010       }
2011 
2012       /**
2013        * @dev distributes eth based on fees to com, aff, and p3d
2014        */
2015       function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
2016           private
2017           returns(F3Ddatasets.EventReturns)
2018       {
2019           // pay 3% out to community rewards
2020           uint256 _p1 = _eth / 100;
2021           uint256 _com = _eth / 50;
2022           _com = _com.add(_p1);
2023 
2024           uint256 _p3d;
2025           if (!address(admin).call.value(_com)())
2026           {
2027               // This ensures Team Just cannot influence the outcome of FoMo3D with
2028               // bank migrations by breaking outgoing transactions.
2029               // Something we would never do. But that's not the point.
2030               // We spent 2000$ in eth re-deploying just to patch this, we hold the
2031               // highest belief that everything we create should be trustless.
2032               // Team JUST, The name you shouldn't have to trust.
2033               _p3d = _com;
2034               _com = 0;
2035           }
2036 
2037 
2038           // distribute share to affiliate
2039           uint256 _aff = _eth / 10;
2040 
2041           // decide what to do with affiliate share of fees
2042           // affiliate must not be self, and must have a name registered
2043           if (_affID != _pID && plyr_[_affID].name != '') {
2044               plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
2045               emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
2046           } else {
2047               _p3d = _aff;
2048           }
2049 
2050           // pay out p3d
2051           _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
2052           if (_p3d > 0)
2053           {
2054               // deposit to divies contract
2055               //uint256 _potAmount = _p3d / 2;
2056 
2057               admin.transfer(_p3d);
2058 
2059               //round_[_rID].pot = round_[_rID].pot.add(_potAmount);
2060 
2061               // set up event data
2062               _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
2063           }
2064 
2065           return(_eventData_);
2066       }
2067 
2068       function potSwap()
2069           external
2070           payable
2071       {
2072           // setup local rID
2073           uint256 _rID = rID_ + 1;
2074 
2075           round_[_rID].pot = round_[_rID].pot.add(msg.value);
2076           emit F3Devents.onPotSwapDeposit(_rID, msg.value);
2077       }
2078 
2079       /**
2080        * @dev distributes eth based on fees to gen and pot
2081        */
2082       function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2083           private
2084           returns(F3Ddatasets.EventReturns)
2085       {
2086           // calculate gen share
2087           uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
2088 
2089           // toss 1% into airdrop pot
2090           uint256 _air = (_eth / 100);
2091           airDropPot_ = airDropPot_.add(_air);
2092 
2093           // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
2094           _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
2095 
2096           // calculate pot
2097           uint256 _pot = _eth.sub(_gen);
2098 
2099           // distribute gen share (thats what updateMasks() does) and adjust
2100           // balances for dust.
2101           uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
2102           if (_dust > 0)
2103               _gen = _gen.sub(_dust);
2104 
2105           // add eth to pot
2106           round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
2107 
2108           // set up event data
2109           _eventData_.genAmount = _gen.add(_eventData_.genAmount);
2110           _eventData_.potAmount = _pot;
2111 
2112           return(_eventData_);
2113       }
2114 
2115       /**
2116        * @dev updates masks for round and player when keys are bought
2117        * @return dust left over
2118        */
2119       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
2120           private
2121           returns(uint256)
2122       {
2123           /* MASKING NOTES
2124               earnings masks are a tricky thing for people to wrap their minds around.
2125               the basic thing to understand here.  is were going to have a global
2126               tracker based on profit per share for each round, that increases in
2127               relevant proportion to the increase in share supply.
2128 
2129               the player will have an additional mask that basically says "based
2130               on the rounds mask, my shares, and how much i've already withdrawn,
2131               how much is still owed to me?"
2132           */
2133 
2134           // calc profit per key & round mask based on this buy:  (dust goes to pot)
2135           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
2136           round_[_rID].mask = _ppt.add(round_[_rID].mask);
2137 
2138           // calculate player earning from their own buy (only based on the keys
2139           // they just bought).  & update player earnings mask
2140           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
2141           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
2142 
2143           // calculate & return dust
2144           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
2145       }
2146 
2147       /**
2148        * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
2149        * @return earnings in wei format
2150        */
2151       function withdrawEarnings(uint256 _pID)
2152           private
2153           returns(uint256)
2154       {
2155           // update gen vault
2156           updateGenVault(_pID, plyr_[_pID].lrnd);
2157 
2158           // from vaults
2159           uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
2160           if (_earnings > 0)
2161           {
2162               plyr_[_pID].win = 0;
2163               plyr_[_pID].gen = 0;
2164               plyr_[_pID].aff = 0;
2165           }
2166 
2167           return(_earnings);
2168       }
2169 
2170       /**
2171        * @dev prepares compression data and fires event for buy or reload tx's
2172        */
2173       function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2174           private
2175       {
2176           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2177           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2178 
2179           emit F3Devents.onEndTx
2180           (
2181               _eventData_.compressedData,
2182               _eventData_.compressedIDs,
2183               plyr_[_pID].name,
2184               msg.sender,
2185               _eth,
2186               _keys,
2187               _eventData_.winnerAddr,
2188               _eventData_.winnerName,
2189               _eventData_.amountWon,
2190               _eventData_.newPot,
2191               _eventData_.P3DAmount,
2192               _eventData_.genAmount,
2193               _eventData_.potAmount,
2194               airDropPot_
2195           );
2196       }
2197       
2198        /**
2199        * @dev prepares compression data and fires event for buy or reload tx's
2200        */
2201       function endTxQR(address _realSender,uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2202           private
2203       {
2204           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2205           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2206 
2207           emit F3Devents.onEndTx
2208           (
2209               _eventData_.compressedData,
2210               _eventData_.compressedIDs,
2211               plyr_[_pID].name,
2212               _realSender,
2213               _eth,
2214               _keys,
2215               _eventData_.winnerAddr,
2216               _eventData_.winnerName,
2217               _eventData_.amountWon,
2218               _eventData_.newPot,
2219               _eventData_.P3DAmount,
2220               _eventData_.genAmount,
2221               _eventData_.potAmount,
2222               airDropPot_
2223           );
2224       }
2225   //==============================================================================
2226   //    (~ _  _    _._|_    .
2227   //    _)(/_(_|_|| | | \/  .
2228   //====================/=========================================================
2229       /** upon contract deploy, it will be deactivated.  this is a one time
2230        * use function that will activate the contract.  we do this so devs
2231        * have time to set things up on the web end                            **/
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