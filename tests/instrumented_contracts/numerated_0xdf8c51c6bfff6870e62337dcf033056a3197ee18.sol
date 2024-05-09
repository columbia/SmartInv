1 pragma solidity ^0.4.24;
2 
3 interface PlayerBookInterface {
4     function getPlayerID(address _addr) external returns (uint256);
5     function getPlayerName(uint256 _pID) external view returns (bytes32);
6     function getPlayerLAff(uint256 _pID) external view returns (uint256);
7     function getPlayerAddr(uint256 _pID) external view returns (address);
8     function getNameFee() external view returns (uint256);
9     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
10     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
11     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
12 }
13 
14 contract F3Devents {
15     // fired whenever a player registers a name
16     event onNewName
17     (
18         uint256 indexed playerID,
19         address indexed playerAddress,
20         bytes32 indexed playerName,
21         bool isNewPlayer,
22         uint256 affiliateID,
23         address affiliateAddress,
24         bytes32 affiliateName,
25         uint256 amountPaid,
26         uint256 timeStamp
27     );
28 
29     // fired at end of buy or reload
30     event onEndTx
31     (
32         uint256 compressedData,
33         uint256 compressedIDs,
34         bytes32 playerName,
35         address playerAddress,
36         uint256 ethIn,
37         uint256 keysBought,
38         address winnerAddr,
39         bytes32 winnerName,
40         uint256 amountWon,
41         uint256 newPot,
42         uint256 P3DAmount,
43         uint256 genAmount,
44         uint256 potAmount,
45         uint256 airDropPot
46     );
47 
48 	// fired whenever theres a withdraw
49     event onWithdraw
50     (
51         uint256 indexed playerID,
52         address playerAddress,
53         bytes32 playerName,
54         uint256 ethOut,
55         uint256 timeStamp
56     );
57 
58     // fired whenever a withdraw forces end round to be ran
59     event onWithdrawAndDistribute
60     (
61         address playerAddress,
62         bytes32 playerName,
63         uint256 ethOut,
64         uint256 compressedData,
65         uint256 compressedIDs,
66         address winnerAddr,
67         bytes32 winnerName,
68         uint256 amountWon,
69         uint256 newPot,
70         uint256 P3DAmount,
71         uint256 genAmount
72     );
73 
74     // (fomo3d short only) fired whenever a player tries a buy after round timer
75     // hit zero, and causes end round to be ran.
76     event onBuyAndDistribute
77     (
78         address playerAddress,
79         bytes32 playerName,
80         uint256 ethIn,
81         uint256 compressedData,
82         uint256 compressedIDs,
83         address winnerAddr,
84         bytes32 winnerName,
85         uint256 amountWon,
86         uint256 newPot,
87         uint256 P3DAmount,
88         uint256 genAmount
89     );
90 
91     // (fomo3d short only) fired whenever a player tries a reload after round timer
92     // hit zero, and causes end round to be ran.
93     event onReLoadAndDistribute
94     (
95         address playerAddress,
96         bytes32 playerName,
97         uint256 compressedData,
98         uint256 compressedIDs,
99         address winnerAddr,
100         bytes32 winnerName,
101         uint256 amountWon,
102         uint256 newPot,
103         uint256 P3DAmount,
104         uint256 genAmount
105     );
106 
107     // fired whenever an affiliate is paid
108     event onAffiliatePayout
109     (
110         uint256 indexed affiliateID,
111         address affiliateAddress,
112         bytes32 affiliateName,
113         uint256 indexed roundID,
114         uint256 indexed buyerID,
115         uint256 amount,
116         uint256 timeStamp
117     );
118 
119     // received pot swap deposit
120     event onPotSwapDeposit
121     (
122         uint256 roundID,
123         uint256 amountAddedToPot
124     );
125 }
126 
127 library NameFilter {
128     /**
129      * @dev filters name strings
130      * -converts uppercase to lower case.
131      * -makes sure it does not start/end with a space
132      * -makes sure it does not contain multiple spaces in a row
133      * -cannot be only numbers
134      * -cannot start with 0x
135      * -restricts characters to A-Z, a-z, 0-9, and space.
136      * @return reprocessed string in bytes32 format
137      */
138     function nameFilter(string _input)
139         internal
140         pure
141         returns(bytes32)
142     {
143         bytes memory _temp = bytes(_input);
144         uint256 _length = _temp.length;
145 
146         //sorry limited to 32 characters
147         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
148         // make sure it doesnt start with or end with space
149         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
150         // make sure first two characters are not 0x
151         if (_temp[0] == 0x30)
152         {
153             require(_temp[1] != 0x78, "string cannot start with 0x");
154             require(_temp[1] != 0x58, "string cannot start with 0X");
155         }
156 
157         // create a bool to track if we have a non number character
158         bool _hasNonNumber;
159 
160         // convert & check
161         for (uint256 i = 0; i < _length; i++)
162         {
163             // if its uppercase A-Z
164             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
165             {
166                 // convert to lower case a-z
167                 _temp[i] = byte(uint(_temp[i]) + 32);
168 
169                 // we have a non number
170                 if (_hasNonNumber == false)
171                     _hasNonNumber = true;
172             } else {
173                 require
174                 (
175                     // require character is a space
176                     _temp[i] == 0x20 ||
177                     // OR lowercase a-z
178                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
179                     // or 0-9
180                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
181                     "string contains invalid characters"
182                 );
183                 // make sure theres not 2x spaces in a row
184                 if (_temp[i] == 0x20)
185                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
186 
187                 // see if we have a character other than a number
188                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
189                     _hasNonNumber = true;
190             }
191         }
192 
193         require(_hasNonNumber == true, "string cannot be only numbers");
194 
195         bytes32 _ret;
196         assembly {
197             _ret := mload(add(_temp, 32))
198         }
199         return (_ret);
200     }
201 }
202 
203 /**
204  * @title SafeMath v0.1.9
205  * @dev Math operations with safety checks that throw on error
206  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
207  * - added sqrt
208  * - added sq
209  * - added pwr
210  * - changed asserts to requires with error log outputs
211  * - removed div, its useless
212  */
213 library SafeMath {
214 
215     /**
216     * @dev Multiplies two numbers, throws on overflow.
217     */
218     function mul(uint256 a, uint256 b)
219         internal
220         pure
221         returns (uint256 c)
222     {
223         if (a == 0) {
224             return 0;
225         }
226         c = a * b;
227         require(c / a == b, "SafeMath mul failed");
228         return c;
229     }
230 
231     /**
232     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
233     */
234     function sub(uint256 a, uint256 b)
235         internal
236         pure
237         returns (uint256)
238     {
239         require(b <= a, "SafeMath sub failed");
240         return a - b;
241     }
242 
243     /**
244     * @dev Adds two numbers, throws on overflow.
245     */
246     function add(uint256 a, uint256 b)
247         internal
248         pure
249         returns (uint256 c)
250     {
251         c = a + b;
252         require(c >= a, "SafeMath add failed");
253         return c;
254     }
255 
256     /**
257      * @dev gives square root of given x.
258      */
259     function sqrt(uint256 x)
260         internal
261         pure
262         returns (uint256 y)
263     {
264         uint256 z = ((add(x,1)) / 2);
265         y = x;
266         while (z < y)
267         {
268             y = z;
269             z = ((add((x / z),z)) / 2);
270         }
271     }
272 
273     /**
274      * @dev gives square. multiplies x by x
275      */
276     function sq(uint256 x)
277         internal
278         pure
279         returns (uint256)
280     {
281         return (mul(x,x));
282     }
283 
284     /**
285      * @dev x to the power of y
286      */
287     function pwr(uint256 x, uint256 y)
288         internal
289         pure
290         returns (uint256)
291     {
292         if (x==0)
293             return (0);
294         else if (y==0)
295             return (1);
296         else
297         {
298             uint256 z = x;
299             for (uint256 i=1; i < y; i++)
300                 z = mul(z,x);
301             return (z);
302         }
303     }
304 }
305 
306 
307 
308 //==============================================================================
309 //   __|_ _    __|_ _  .
310 //  _\ | | |_|(_ | _\  .
311 //==============================================================================
312 library F3Ddatasets {
313     //compressedData key
314     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
315         // 0 - new player (bool)
316         // 1 - joined round (bool)
317         // 2 - new  leader (bool)
318         // 3-5 - air drop tracker (uint 0-999)
319         // 6-16 - round end time
320         // 17 - winnerTeam
321         // 18 - 28 timestamp
322         // 29 - team
323         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
324         // 31 - airdrop happened bool
325         // 32 - airdrop tier
326         // 33 - airdrop amount won
327     //compressedIDs key
328     // [77-52][51-26][25-0]
329         // 0-25 - pID
330         // 26-51 - winPID
331         // 52-77 - rID
332     struct EventReturns {
333         uint256 compressedData;
334         uint256 compressedIDs;
335         address winnerAddr;         // winner address
336         bytes32 winnerName;         // winner name
337         uint256 amountWon;          // amount won
338         uint256 newPot;             // amount in new pot
339         uint256 P3DAmount;          // amount distributed to p3d
340         uint256 genAmount;          // amount distributed to gen
341         uint256 potAmount;          // amount added to pot
342     }
343     struct Player {
344         address addr;   // player address
345         bytes32 name;   // player name
346         uint256 win;    // winnings vault
347         uint256 gen;    // general vault
348         uint256 aff;    // affiliate vault
349         uint256 lrnd;   // last round played
350         uint256 laff;   // last affiliate id used
351     }
352     struct PlayerRounds {
353         uint256 eth;    // eth player has added to round (used for eth limiter)
354         uint256 keys;   // keys
355         uint256 mask;   // player mask
356         uint256 ico;    // ICO phase investment
357     }
358     struct Round {
359         uint256 plyr;   // pID of player in lead
360         uint256 team;   // tID of team in lead
361         uint256 end;    // time ends/ended
362         bool ended;     // has round end function been ran
363         uint256 strt;   // time round started
364         uint256 keys;   // keys
365         uint256 eth;    // total eth in
366         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
367         uint256 mask;   // global mask
368         uint256 ico;    // total eth sent in during ICO phase
369         uint256 icoGen; // total eth for gen during ICO phase
370         uint256 icoAvg; // average key price for ICO phase
371     }
372     struct TeamFee {
373         uint256 gen;    // % of buy in thats paid to key holders of current round
374         uint256 p3d;    // % of buy in thats paid to p3d holders
375     }
376     struct PotSplit {
377         uint256 gen;    // % of pot thats paid to key holders of current round
378         uint256 p3d;    // % of pot thats paid to p3d holders
379     }
380 }
381 
382 //==============================================================================
383 //  |  _      _ _ | _  .
384 //  |<(/_\/  (_(_||(_  .
385 //=======/======================================================================
386 library F3DKeysCalcShort {
387     using SafeMath for *;
388     /**
389      * @dev calculates number of keys received given X eth
390      * @param _curEth current amount of eth in contract
391      * @param _newEth eth being spent
392      * @return amount of ticket purchased
393      */
394     function keysRec(uint256 _curEth, uint256 _newEth)
395         internal
396         pure
397         returns (uint256)
398     {
399         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
400     }
401 
402     /**
403      * @dev calculates amount of eth received if you sold X keys
404      * @param _curKeys current amount of keys that exist
405      * @param _sellKeys amount of keys you wish to sell
406      * @return amount of eth received
407      */
408     function ethRec(uint256 _curKeys, uint256 _sellKeys)
409         internal
410         pure
411         returns (uint256)
412     {
413         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
414     }
415 
416     /**
417      * @dev calculates how many keys would exist with given an amount of eth
418      * @param _eth eth "in contract"
419      * @return number of keys that would exist
420      */
421     function keys(uint256 _eth)
422         internal
423         pure
424         returns(uint256)
425     {
426         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
427     }
428 
429     /**
430      * @dev calculates how much eth would be in contract given a number of keys
431      * @param _keys number of keys "in contract"
432      * @return eth that would exists
433      */
434     function eth(uint256 _keys)
435         internal
436         pure
437         returns(uint256)
438     {
439         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
440     }
441 }
442 
443 //==============================================================================
444 //  . _ _|_ _  _ |` _  _ _  _  .
445 //  || | | (/_| ~|~(_|(_(/__\  .
446 //==============================================================================
447 
448 
449 
450 contract modularFast is F3Devents {}
451 
452 
453 contract FoMo3DFast is modularFast {
454       using SafeMath for *;
455       using NameFilter for string;
456       using F3DKeysCalcShort for uint256;
457 
458       PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x8c8c0CE93311e5E5FF5b609c693D1b83d523f00E);
459 
460       address private admin = msg.sender;
461       string constant public name = "FOMO Test";
462       string constant public symbol = "Test";
463       uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
464       uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
465       uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
466       uint256 constant private rndInc_ = 20 seconds;              // every full key purchased adds this much to the timer
467       uint256 constant private rndMax_ = 8 hours;                // max length a round timer can be
468       uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
469       uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
470       uint256 public rID_;    // round id number / total rounds that have happened
471   //****************
472   // PLAYER DATA
473   //****************
474       mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
475       mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
476       mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
477       mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
478       mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
479   //****************
480   // ROUND DATA
481   //****************
482       mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
483       mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
484   //****************
485   // TEAM FEE DATA
486   //****************
487       mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
488       mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
489 
490       constructor()
491           public
492       {
493   		// Team allocation structures
494           // 0 = whales
495           // 1 = bears
496           // 2 = sneks
497           // 3 = bulls
498 
499   		// Team allocation percentages
500           // (F3D, P3D) + (Pot , Referrals, Community)  
501               // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
502           fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
503           fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
504           fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
505           fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
506 
507           // how to split up the final pot based on which team was picked
508           // (F3D, P3D)
509           potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
510           potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
511           potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
512           potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
513   	}
514   //==============================================================================
515   //     _ _  _  _|. |`. _  _ _  .
516   //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
517   //==============================================================================
518       /**
519        * @dev used to make sure no one can interact with contract until it has
520        * been activated.
521        */
522       modifier isActivated() {
523           require(activated_ == true, "its not ready yet.  check ?eta in discord");
524           _;
525       }
526 
527       /**
528        * @dev prevents contracts from interacting with fomo3d
529        */
530       modifier isHuman() {
531           address _addr = msg.sender;
532           uint256 _codeLength;
533 
534           assembly {_codeLength := extcodesize(_addr)}
535           require(_codeLength == 0, "sorry humans only");
536           _;
537       }
538 
539       /**
540        * @dev sets boundaries for incoming tx
541        */
542       modifier isWithinLimits(uint256 _eth) {
543           require(_eth >= 1000000000, "pocket lint: not a valid currency");
544           require(_eth <= 100000000000000000000000, "no vitalik, no");
545           _;
546       }
547 
548   //==============================================================================
549   //     _    |_ |. _   |`    _  __|_. _  _  _  .
550   //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
551   //====|=========================================================================
552       /**
553        * @dev emergency buy uses last stored affiliate ID and team snek
554        */
555       function()
556           isActivated()
557           isHuman()
558           isWithinLimits(msg.value)
559           public
560           payable
561       {
562           // set up our tx event data and determine if player is new or not
563           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
564 
565           // fetch player id
566           uint256 _pID = pIDxAddr_[msg.sender];
567 
568           // buy core
569           buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
570       }
571 
572       /**
573        * @dev converts all incoming ethereum to keys.
574        * -functionhash- 0x8f38f309 (using ID for affiliate)
575        * -functionhash- 0x98a0871d (using address for affiliate)
576        * -functionhash- 0xa65b37a1 (using name for affiliate)
577        * @param _affCode the ID/address/name of the player who gets the affiliate fee
578        * @param _team what team is the player playing for?
579        */
580       function buyXid(uint256 _affCode, uint256 _team)
581           isActivated()
582           isHuman()
583           isWithinLimits(msg.value)
584           public
585           payable
586       {
587           // set up our tx event data and determine if player is new or not
588           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
589 
590           // fetch player id
591           uint256 _pID = pIDxAddr_[msg.sender];
592 
593           // manage affiliate residuals
594           // if no affiliate code was given or player tried to use their own, lolz
595           if (_affCode == 0 || _affCode == _pID)
596           {
597               // use last stored affiliate code
598               _affCode = plyr_[_pID].laff;
599 
600           // if affiliate code was given & its not the same as previously stored
601           } else if (_affCode != plyr_[_pID].laff) {
602               // update last affiliate
603               plyr_[_pID].laff = _affCode;
604           }
605 
606           // verify a valid team was selected
607           _team = verifyTeam(_team);
608 
609           // buy core
610           buyCore(_pID, _affCode, _team, _eventData_);
611       }
612 
613       function buyXaddr(address _affCode, uint256 _team)
614           isActivated()
615           isHuman()
616           isWithinLimits(msg.value)
617           public
618           payable
619       {
620           // set up our tx event data and determine if player is new or not
621           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
622 
623           // fetch player id
624           uint256 _pID = pIDxAddr_[msg.sender];
625 
626           // manage affiliate residuals
627           uint256 _affID;
628           // if no affiliate code was given or player tried to use their own, lolz
629           if (_affCode == address(0) || _affCode == msg.sender)
630           {
631               // use last stored affiliate code
632               _affID = plyr_[_pID].laff;
633 
634           // if affiliate code was given
635           } else {
636               // get affiliate ID from aff Code
637               _affID = pIDxAddr_[_affCode];
638 
639               // if affID is not the same as previously stored
640               if (_affID != plyr_[_pID].laff)
641               {
642                   // update last affiliate
643                   plyr_[_pID].laff = _affID;
644               }
645           }
646 
647           // verify a valid team was selected
648           _team = verifyTeam(_team);
649 
650           // buy core
651           buyCore(_pID, _affID, _team, _eventData_);
652       }
653 
654       function buyXname(bytes32 _affCode, uint256 _team)
655           isActivated()
656           isHuman()
657           isWithinLimits(msg.value)
658           public
659           payable
660       {
661           // set up our tx event data and determine if player is new or not
662           F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
663 
664           // fetch player id
665           uint256 _pID = pIDxAddr_[msg.sender];
666 
667           // manage affiliate residuals
668           uint256 _affID;
669           // if no affiliate code was given or player tried to use their own, lolz
670           if (_affCode == '' || _affCode == plyr_[_pID].name)
671           {
672               // use last stored affiliate code
673               _affID = plyr_[_pID].laff;
674 
675           // if affiliate code was given
676           } else {
677               // get affiliate ID from aff Code
678               _affID = pIDxName_[_affCode];
679 
680               // if affID is not the same as previously stored
681               if (_affID != plyr_[_pID].laff)
682               {
683                   // update last affiliate
684                   plyr_[_pID].laff = _affID;
685               }
686           }
687 
688           // verify a valid team was selected
689           _team = verifyTeam(_team);
690 
691           // buy core
692           buyCore(_pID, _affID, _team, _eventData_);
693       }
694 
695       /**
696        * @dev essentially the same as buy, but instead of you sending ether
697        * from your wallet, it uses your unwithdrawn earnings.
698        * -functionhash- 0x349cdcac (using ID for affiliate)
699        * -functionhash- 0x82bfc739 (using address for affiliate)
700        * -functionhash- 0x079ce327 (using name for affiliate)
701        * @param _affCode the ID/address/name of the player who gets the affiliate fee
702        * @param _team what team is the player playing for?
703        * @param _eth amount of earnings to use (remainder returned to gen vault)
704        */
705       function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
706           isActivated()
707           isHuman()
708           isWithinLimits(_eth)
709           public
710       {
711           // set up our tx event data
712           F3Ddatasets.EventReturns memory _eventData_;
713 
714           // fetch player ID
715           uint256 _pID = pIDxAddr_[msg.sender];
716 
717           // manage affiliate residuals
718           // if no affiliate code was given or player tried to use their own, lolz
719           if (_affCode == 0 || _affCode == _pID)
720           {
721               // use last stored affiliate code
722               _affCode = plyr_[_pID].laff;
723 
724           // if affiliate code was given & its not the same as previously stored
725           } else if (_affCode != plyr_[_pID].laff) {
726               // update last affiliate
727               plyr_[_pID].laff = _affCode;
728           }
729 
730           // verify a valid team was selected
731           _team = verifyTeam(_team);
732 
733           // reload core
734           reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
735       }
736 
737       function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
738           isActivated()
739           isHuman()
740           isWithinLimits(_eth)
741           public
742       {
743           // set up our tx event data
744           F3Ddatasets.EventReturns memory _eventData_;
745 
746           // fetch player ID
747           uint256 _pID = pIDxAddr_[msg.sender];
748 
749           // manage affiliate residuals
750           uint256 _affID;
751           // if no affiliate code was given or player tried to use their own, lolz
752           if (_affCode == address(0) || _affCode == msg.sender)
753           {
754               // use last stored affiliate code
755               _affID = plyr_[_pID].laff;
756 
757           // if affiliate code was given
758           } else {
759               // get affiliate ID from aff Code
760               _affID = pIDxAddr_[_affCode];
761 
762               // if affID is not the same as previously stored
763               if (_affID != plyr_[_pID].laff)
764               {
765                   // update last affiliate
766                   plyr_[_pID].laff = _affID;
767               }
768           }
769 
770           // verify a valid team was selected
771           _team = verifyTeam(_team);
772 
773           // reload core
774           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
775       }
776 
777       function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
778           isActivated()
779           isHuman()
780           isWithinLimits(_eth)
781           public
782       {
783           // set up our tx event data
784           F3Ddatasets.EventReturns memory _eventData_;
785 
786           // fetch player ID
787           uint256 _pID = pIDxAddr_[msg.sender];
788 
789           // manage affiliate residuals
790           uint256 _affID;
791           // if no affiliate code was given or player tried to use their own, lolz
792           if (_affCode == '' || _affCode == plyr_[_pID].name)
793           {
794               // use last stored affiliate code
795               _affID = plyr_[_pID].laff;
796 
797           // if affiliate code was given
798           } else {
799               // get affiliate ID from aff Code
800               _affID = pIDxName_[_affCode];
801 
802               // if affID is not the same as previously stored
803               if (_affID != plyr_[_pID].laff)
804               {
805                   // update last affiliate
806                   plyr_[_pID].laff = _affID;
807               }
808           }
809 
810           // verify a valid team was selected
811           _team = verifyTeam(_team);
812 
813           // reload core
814           reLoadCore(_pID, _affID, _team, _eth, _eventData_);
815       }
816 
817       /**
818        * @dev withdraws all of your earnings.
819        * -functionhash- 0x3ccfd60b
820        */
821       function withdraw()
822           isActivated()
823           isHuman()
824           public
825       {
826           // setup local rID
827           uint256 _rID = rID_;
828 
829           // grab time
830           uint256 _now = now;
831 
832           // fetch player ID
833           uint256 _pID = pIDxAddr_[msg.sender];
834 
835           // setup temp var for player eth
836           uint256 _eth;
837 
838           // check to see if round has ended and no one has run round end yet
839           if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
840           {
841               // set up our tx event data
842               F3Ddatasets.EventReturns memory _eventData_;
843 
844               // end the round (distributes pot)
845   			round_[_rID].ended = true;
846               _eventData_ = endRound(_eventData_);
847 
848   			// get their earnings
849               _eth = withdrawEarnings(_pID);
850 
851               // gib moni
852               if (_eth > 0)
853                   plyr_[_pID].addr.transfer(_eth);
854 
855               // build event data
856               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
857               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
858 
859               // fire withdraw and distribute event
860               emit F3Devents.onWithdrawAndDistribute
861               (
862                   msg.sender,
863                   plyr_[_pID].name,
864                   _eth,
865                   _eventData_.compressedData,
866                   _eventData_.compressedIDs,
867                   _eventData_.winnerAddr,
868                   _eventData_.winnerName,
869                   _eventData_.amountWon,
870                   _eventData_.newPot,
871                   _eventData_.P3DAmount,
872                   _eventData_.genAmount
873               );
874 
875           // in any other situation
876           } else {
877               // get their earnings
878               _eth = withdrawEarnings(_pID);
879 
880               // gib moni
881               if (_eth > 0)
882                   plyr_[_pID].addr.transfer(_eth);
883 
884               // fire withdraw event
885               emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
886           }
887       }
888 
889       /**
890        * @dev use these to register names.  they are just wrappers that will send the
891        * registration requests to the PlayerBook contract.  So registering here is the
892        * same as registering there.  UI will always display the last name you registered.
893        * but you will still own all previously registered names to use as affiliate
894        * links.
895        * - must pay a registration fee.
896        * - name must be unique
897        * - names will be converted to lowercase
898        * - name cannot start or end with a space
899        * - cannot have more than 1 space in a row
900        * - cannot be only numbers
901        * - cannot start with 0x
902        * - name must be at least 1 char
903        * - max length of 32 characters long
904        * - allowed characters: a-z, 0-9, and space
905        * -functionhash- 0x921dec21 (using ID for affiliate)
906        * -functionhash- 0x3ddd4698 (using address for affiliate)
907        * -functionhash- 0x685ffd83 (using name for affiliate)
908        * @param _nameString players desired name
909        * @param _affCode affiliate ID, address, or name of who referred you
910        * @param _all set to true if you want this to push your info to all games
911        * (this might cost a lot of gas)
912        */
913 
914       function registerNameXID(string _nameString, uint256 _affCode, bool _all)
915           isHuman()
916           public
917           payable
918       {
919           bytes32 _name = _nameString.nameFilter();
920           address _addr = msg.sender;
921           uint256 _paid = msg.value;
922           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
923 
924           uint256 _pID = pIDxAddr_[_addr];
925 
926           // fire event
927           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
928       }
929 
930       function registerNameXaddr(string _nameString, address _affCode, bool _all)
931           isHuman()
932           public
933           payable
934       {
935           bytes32 _name = _nameString.nameFilter();
936           address _addr = msg.sender;
937           uint256 _paid = msg.value;
938           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
939 
940           uint256 _pID = pIDxAddr_[_addr];
941 
942           // fire event
943           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
944       }
945 
946       function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
947           isHuman()
948           public
949           payable
950       {
951           bytes32 _name = _nameString.nameFilter();
952           address _addr = msg.sender;
953           uint256 _paid = msg.value;
954           (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
955 
956           uint256 _pID = pIDxAddr_[_addr];
957 
958           // fire event
959           emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
960       }
961   //==============================================================================
962   //     _  _ _|__|_ _  _ _  .
963   //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
964   //=====_|=======================================================================
965       /**
966        * @dev return the price buyer will pay for next 1 individual key.
967        * -functionhash- 0x018a25e8
968        * @return price for next key bought (in wei format)
969        */
970       function getBuyPrice()
971           public
972           view
973           returns(uint256)
974       {
975           // setup local rID
976           uint256 _rID = rID_;
977 
978           // grab time
979           uint256 _now = now;
980 
981           // are we in a round?
982           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
983               return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
984           else // rounds over.  need price for new round
985               return ( 75000000000000 ); // init
986       }
987 
988       /**
989        * @dev returns time left.  dont spam this, you'll ddos yourself from your node
990        * provider
991        * -functionhash- 0xc7e284b8
992        * @return time left in seconds
993        */
994       function getTimeLeft()
995           public
996           view
997           returns(uint256)
998       {
999           // setup local rID
1000           uint256 _rID = rID_;
1001 
1002           // grab time
1003           uint256 _now = now;
1004 
1005           if (_now < round_[_rID].end)
1006               if (_now > round_[_rID].strt + rndGap_)
1007                   return( (round_[_rID].end).sub(_now) );
1008               else
1009                   return( (round_[_rID].strt + rndGap_).sub(_now) );
1010           else
1011               return(0);
1012       }
1013 
1014       /**
1015        * @dev returns player earnings per vaults
1016        * -functionhash- 0x63066434
1017        * @return winnings vault
1018        * @return general vault
1019        * @return affiliate vault
1020        */
1021       function getPlayerVaults(uint256 _pID)
1022           public
1023           view
1024           returns(uint256 ,uint256, uint256)
1025       {
1026           // setup local rID
1027           uint256 _rID = rID_;
1028 
1029           // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1030           if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1031           {
1032               // if player is winner
1033               if (round_[_rID].plyr == _pID)
1034               {
1035                   return
1036                   (
1037                       (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1038                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1039                       plyr_[_pID].aff
1040                   );
1041               // if player is not the winner
1042               } else {
1043                   return
1044                   (
1045                       plyr_[_pID].win,
1046                       (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1047                       plyr_[_pID].aff
1048                   );
1049               }
1050 
1051           // if round is still going on, or round has ended and round end has been ran
1052           } else {
1053               return
1054               (
1055                   plyr_[_pID].win,
1056                   (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1057                   plyr_[_pID].aff
1058               );
1059           }
1060       }
1061 
1062       /**
1063        * solidity hates stack limits.  this lets us avoid that hate
1064        */
1065       function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1066           private
1067           view
1068           returns(uint256)
1069       {
1070           return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1071       }
1072 
1073       /**
1074        * @dev returns all current round info needed for front end
1075        * -functionhash- 0x747dff42
1076        * @return eth invested during ICO phase
1077        * @return round id
1078        * @return total keys for round
1079        * @return time round ends
1080        * @return time round started
1081        * @return current pot
1082        * @return current team ID & player ID in lead
1083        * @return current player in leads address
1084        * @return current player in leads name
1085        * @return whales eth in for round
1086        * @return bears eth in for round
1087        * @return sneks eth in for round
1088        * @return bulls eth in for round
1089        * @return airdrop tracker # & airdrop pot
1090        */
1091       function getCurrentRoundInfo()
1092           public
1093           view
1094           returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1095       {
1096           // setup local rID
1097           uint256 _rID = rID_;
1098 
1099           return
1100           (
1101               round_[_rID].ico,               //0
1102               _rID,                           //1
1103               round_[_rID].keys,              //2
1104               round_[_rID].end,               //3
1105               round_[_rID].strt,              //4
1106               round_[_rID].pot,               //5
1107               (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1108               plyr_[round_[_rID].plyr].addr,  //7
1109               plyr_[round_[_rID].plyr].name,  //8
1110               rndTmEth_[_rID][0],             //9
1111               rndTmEth_[_rID][1],             //10
1112               rndTmEth_[_rID][2],             //11
1113               rndTmEth_[_rID][3],             //12
1114               airDropTracker_ + (airDropPot_ * 1000)              //13
1115           );
1116       }
1117 
1118       /**
1119        * @dev returns player info based on address.  if no address is given, it will
1120        * use msg.sender
1121        * -functionhash- 0xee0b5d8b
1122        * @param _addr address of the player you want to lookup
1123        * @return player ID
1124        * @return player name
1125        * @return keys owned (current round)
1126        * @return winnings vault
1127        * @return general vault
1128        * @return affiliate vault
1129   	 * @return player round eth
1130        */
1131       function getPlayerInfoByAddress(address _addr)
1132           public
1133           view
1134           returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1135       {
1136           // setup local rID
1137           uint256 _rID = rID_;
1138 
1139           if (_addr == address(0))
1140           {
1141               _addr == msg.sender;
1142           }
1143           uint256 _pID = pIDxAddr_[_addr];
1144 
1145           return
1146           (
1147               _pID,                               //0
1148               plyr_[_pID].name,                   //1
1149               plyrRnds_[_pID][_rID].keys,         //2
1150               plyr_[_pID].win,                    //3
1151               (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1152               plyr_[_pID].aff,                    //5
1153               plyrRnds_[_pID][_rID].eth           //6
1154           );
1155       }
1156 
1157   //==============================================================================
1158   //     _ _  _ _   | _  _ . _  .
1159   //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1160   //=====================_|=======================================================
1161       /**
1162        * @dev logic runs whenever a buy order is executed.  determines how to handle
1163        * incoming eth depending on if we are in an active round or not
1164        */
1165       function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1166           private
1167       {
1168           // setup local rID
1169           uint256 _rID = rID_;
1170 
1171           // grab time
1172           uint256 _now = now;
1173 
1174           // if round is active
1175           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1176           {
1177               // call core
1178               core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1179 
1180           // if round is not active
1181           } else {
1182               // check to see if end round needs to be ran
1183               if (_now > round_[_rID].end && round_[_rID].ended == false)
1184               {
1185                   // end the round (distributes pot) & start new round
1186   			    round_[_rID].ended = true;
1187                   _eventData_ = endRound(_eventData_);
1188 
1189                   // build event data
1190                   _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1191                   _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1192 
1193                   // fire buy and distribute event
1194                   emit F3Devents.onBuyAndDistribute
1195                   (
1196                       msg.sender,
1197                       plyr_[_pID].name,
1198                       msg.value,
1199                       _eventData_.compressedData,
1200                       _eventData_.compressedIDs,
1201                       _eventData_.winnerAddr,
1202                       _eventData_.winnerName,
1203                       _eventData_.amountWon,
1204                       _eventData_.newPot,
1205                       _eventData_.P3DAmount,
1206                       _eventData_.genAmount
1207                   );
1208               }
1209 
1210               // put eth in players vault
1211               plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1212           }
1213       }
1214 
1215       /**
1216        * @dev logic runs whenever a reload order is executed.  determines how to handle
1217        * incoming eth depending on if we are in an active round or not
1218        */
1219       function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1220           private
1221       {
1222           // setup local rID
1223           uint256 _rID = rID_;
1224 
1225           // grab time
1226           uint256 _now = now;
1227 
1228           // if round is active
1229           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1230           {
1231               // get earnings from all vaults and return unused to gen vault
1232               // because we use a custom safemath library.  this will throw if player
1233               // tried to spend more eth than they have.
1234               plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1235 
1236               // call core
1237               core(_rID, _pID, _eth, _affID, _team, _eventData_);
1238 
1239           // if round is not active and end round needs to be ran
1240           } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1241               // end the round (distributes pot) & start new round
1242               round_[_rID].ended = true;
1243               _eventData_ = endRound(_eventData_);
1244 
1245               // build event data
1246               _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1247               _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1248 
1249               // fire buy and distribute event
1250               emit F3Devents.onReLoadAndDistribute
1251               (
1252                   msg.sender,
1253                   plyr_[_pID].name,
1254                   _eventData_.compressedData,
1255                   _eventData_.compressedIDs,
1256                   _eventData_.winnerAddr,
1257                   _eventData_.winnerName,
1258                   _eventData_.amountWon,
1259                   _eventData_.newPot,
1260                   _eventData_.P3DAmount,
1261                   _eventData_.genAmount
1262               );
1263           }
1264       }
1265 
1266       /**
1267        * @dev this is the core logic for any buy/reload that happens while a round
1268        * is live.
1269        */
1270       function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1271           private
1272       {
1273           // if player is new to round
1274           if (plyrRnds_[_pID][_rID].keys == 0)
1275               _eventData_ = managePlayer(_pID, _eventData_);
1276 
1277           // early round eth limiter
1278           if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1279           {
1280               uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1281               uint256 _refund = _eth.sub(_availableLimit);
1282               plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1283               _eth = _availableLimit;
1284           }
1285 
1286           // if eth left is greater than min eth allowed (sorry no pocket lint)
1287           if (_eth > 1000000000)
1288           {
1289 
1290               // mint the new keys
1291               uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1292 
1293               // if they bought at least 1 whole key
1294               if (_keys >= 1000000000000000000)
1295               {
1296               updateTimer(_keys, _rID);
1297 
1298               // set new leaders
1299               if (round_[_rID].plyr != _pID)
1300                   round_[_rID].plyr = _pID;
1301               if (round_[_rID].team != _team)
1302                   round_[_rID].team = _team;
1303 
1304               // set the new leader bool to true
1305               _eventData_.compressedData = _eventData_.compressedData + 100;
1306           }
1307 
1308               // manage airdrops
1309               if (_eth >= 100000000000000000)
1310               {
1311               airDropTracker_++;
1312               if (airdrop() == true)
1313               {
1314                   // gib muni
1315                   uint256 _prize;
1316                   if (_eth >= 10000000000000000000)
1317                   {
1318                       // calculate prize and give it to winner
1319                       _prize = ((airDropPot_).mul(75)) / 100;
1320                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1321 
1322                       // adjust airDropPot
1323                       airDropPot_ = (airDropPot_).sub(_prize);
1324 
1325                       // let event know a tier 3 prize was won
1326                       _eventData_.compressedData += 300000000000000000000000000000000;
1327                   } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1328                       // calculate prize and give it to winner
1329                       _prize = ((airDropPot_).mul(50)) / 100;
1330                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1331 
1332                       // adjust airDropPot
1333                       airDropPot_ = (airDropPot_).sub(_prize);
1334 
1335                       // let event know a tier 2 prize was won
1336                       _eventData_.compressedData += 200000000000000000000000000000000;
1337                   } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1338                       // calculate prize and give it to winner
1339                       _prize = ((airDropPot_).mul(25)) / 100;
1340                       plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1341 
1342                       // adjust airDropPot
1343                       airDropPot_ = (airDropPot_).sub(_prize);
1344 
1345                       // let event know a tier 3 prize was won
1346                       _eventData_.compressedData += 300000000000000000000000000000000;
1347                   }
1348                   // set airdrop happened bool to true
1349                   _eventData_.compressedData += 10000000000000000000000000000000;
1350                   // let event know how much was won
1351                   _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1352 
1353                   // reset air drop tracker
1354                   airDropTracker_ = 0;
1355               }
1356           }
1357 
1358               // store the air drop tracker number (number of buys since last airdrop)
1359               _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1360 
1361               // update player
1362               plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1363               plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1364 
1365               // update round
1366               round_[_rID].keys = _keys.add(round_[_rID].keys);
1367               round_[_rID].eth = _eth.add(round_[_rID].eth);
1368               rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1369 
1370               // distribute eth
1371               _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1372               _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1373 
1374               // call end tx function to fire end tx event.
1375   		    endTx(_pID, _team, _eth, _keys, _eventData_);
1376           }
1377       }
1378   //==============================================================================
1379   //     _ _ | _   | _ _|_ _  _ _  .
1380   //    (_(_||(_|_||(_| | (_)| _\  .
1381   //==============================================================================
1382       /**
1383        * @dev calculates unmasked earnings (just calculates, does not update mask)
1384        * @return earnings in wei format
1385        */
1386       function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1387           private
1388           view
1389           returns(uint256)
1390       {
1391           return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1392       }
1393 
1394       /**
1395        * @dev returns the amount of keys you would get given an amount of eth.
1396        * -functionhash- 0xce89c80c
1397        * @param _rID round ID you want price for
1398        * @param _eth amount of eth sent in
1399        * @return keys received
1400        */
1401       function calcKeysReceived(uint256 _rID, uint256 _eth)
1402           public
1403           view
1404           returns(uint256)
1405       {
1406           // grab time
1407           uint256 _now = now;
1408 
1409           // are we in a round?
1410           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1411               return ( (round_[_rID].eth).keysRec(_eth) );
1412           else // rounds over.  need keys for new round
1413               return ( (_eth).keys() );
1414       }
1415 
1416       /**
1417        * @dev returns current eth price for X keys.
1418        * -functionhash- 0xcf808000
1419        * @param _keys number of keys desired (in 18 decimal format)
1420        * @return amount of eth needed to send
1421        */
1422       function iWantXKeys(uint256 _keys)
1423           public
1424           view
1425           returns(uint256)
1426       {
1427           // setup local rID
1428           uint256 _rID = rID_;
1429 
1430           // grab time
1431           uint256 _now = now;
1432 
1433           // are we in a round?
1434           if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1435               return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1436           else // rounds over.  need price for new round
1437               return ( (_keys).eth() );
1438       }
1439   //==============================================================================
1440   //    _|_ _  _ | _  .
1441   //     | (_)(_)|_\  .
1442   //==============================================================================
1443       /**
1444   	 * @dev receives name/player info from names contract
1445        */
1446       function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1447           external
1448       {
1449           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1450           if (pIDxAddr_[_addr] != _pID)
1451               pIDxAddr_[_addr] = _pID;
1452           if (pIDxName_[_name] != _pID)
1453               pIDxName_[_name] = _pID;
1454           if (plyr_[_pID].addr != _addr)
1455               plyr_[_pID].addr = _addr;
1456           if (plyr_[_pID].name != _name)
1457               plyr_[_pID].name = _name;
1458           if (plyr_[_pID].laff != _laff)
1459               plyr_[_pID].laff = _laff;
1460           if (plyrNames_[_pID][_name] == false)
1461               plyrNames_[_pID][_name] = true;
1462       }
1463 
1464       /**
1465        * @dev receives entire player name list
1466        */
1467       function receivePlayerNameList(uint256 _pID, bytes32 _name)
1468           external
1469       {
1470           require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1471           if(plyrNames_[_pID][_name] == false)
1472               plyrNames_[_pID][_name] = true;
1473       }
1474 
1475       /**
1476        * @dev gets existing or registers new pID.  use this when a player may be new
1477        * @return pID
1478        */
1479       function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1480           private
1481           returns (F3Ddatasets.EventReturns)
1482       {
1483           uint256 _pID = pIDxAddr_[msg.sender];
1484           // if player is new to this version of fomo3d
1485           if (_pID == 0)
1486           {
1487               // grab their player ID, name and last aff ID, from player names contract
1488               _pID = PlayerBook.getPlayerID(msg.sender);
1489               bytes32 _name = PlayerBook.getPlayerName(_pID);
1490               uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1491 
1492               // set up player account
1493               pIDxAddr_[msg.sender] = _pID;
1494               plyr_[_pID].addr = msg.sender;
1495 
1496               if (_name != "")
1497               {
1498                   pIDxName_[_name] = _pID;
1499                   plyr_[_pID].name = _name;
1500                   plyrNames_[_pID][_name] = true;
1501               }
1502 
1503               if (_laff != 0 && _laff != _pID)
1504                   plyr_[_pID].laff = _laff;
1505 
1506               // set the new player bool to true
1507               _eventData_.compressedData = _eventData_.compressedData + 1;
1508           }
1509           return (_eventData_);
1510       }
1511 
1512       /**
1513        * @dev checks to make sure user picked a valid team.  if not sets team
1514        * to default (sneks)
1515        */
1516       function verifyTeam(uint256 _team)
1517           private
1518           pure
1519           returns (uint256)
1520       {
1521           if (_team < 0 || _team > 3)
1522               return(2);
1523           else
1524               return(_team);
1525       }
1526 
1527       /**
1528        * @dev decides if round end needs to be run & new round started.  and if
1529        * player unmasked earnings from previously played rounds need to be moved.
1530        */
1531       function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1532           private
1533           returns (F3Ddatasets.EventReturns)
1534       {
1535           // if player has played a previous round, move their unmasked earnings
1536           // from that round to gen vault.
1537           if (plyr_[_pID].lrnd != 0)
1538               updateGenVault(_pID, plyr_[_pID].lrnd);
1539 
1540           // update player's last round played
1541           plyr_[_pID].lrnd = rID_;
1542 
1543           // set the joined round bool to true
1544           _eventData_.compressedData = _eventData_.compressedData + 10;
1545 
1546           return(_eventData_);
1547       }
1548 
1549       /**
1550        * @dev ends the round. manages paying out winner/splitting up pot
1551        */
1552       function endRound(F3Ddatasets.EventReturns memory _eventData_)
1553           private
1554           returns (F3Ddatasets.EventReturns)
1555       {
1556           // setup local rID
1557           uint256 _rID = rID_;
1558 
1559           // grab our winning player and team id's
1560           uint256 _winPID = round_[_rID].plyr;
1561           uint256 _winTID = round_[_rID].team;
1562 
1563           // grab our pot amount
1564           uint256 _pot = round_[_rID].pot;
1565 
1566           // calculate our winner share, community rewards, gen share,
1567           // p3d share, and amount reserved for next pot
1568           uint256 _win = (_pot.mul(48)) / 100;
1569           uint256 _com = (_pot / 50);
1570           uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1571           uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1572           uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1573 
1574           // calculate ppt for round mask
1575           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1576           uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1577           if (_dust > 0)
1578           {
1579               _gen = _gen.sub(_dust);
1580               _res = _res.add(_dust);
1581           }
1582 
1583           // pay our winner
1584           plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1585 
1586           // community rewards
1587 
1588           admin.transfer(_com);
1589 
1590           admin.transfer(_p3d.sub(_p3d / 2));
1591 
1592           round_[_rID].pot = _pot.add(_p3d / 2);
1593 
1594           // distribute gen portion to key holders
1595           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1596 
1597           // prepare event data
1598           _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1599           _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1600           _eventData_.winnerAddr = plyr_[_winPID].addr;
1601           _eventData_.winnerName = plyr_[_winPID].name;
1602           _eventData_.amountWon = _win;
1603           _eventData_.genAmount = _gen;
1604           _eventData_.P3DAmount = _p3d;
1605           _eventData_.newPot = _res;
1606 
1607           // start next round
1608           rID_++;
1609           _rID++;
1610           round_[_rID].strt = now;
1611           round_[_rID].end = now.add(rndInit_).add(rndGap_);
1612           round_[_rID].pot = _res;
1613 
1614           return(_eventData_);
1615       }
1616 
1617       /**
1618        * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1619        */
1620       function updateGenVault(uint256 _pID, uint256 _rIDlast)
1621           private
1622       {
1623           uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1624           if (_earnings > 0)
1625           {
1626               // put in gen vault
1627               plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1628               // zero out their earnings by updating mask
1629               plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1630           }
1631       }
1632 
1633       /**
1634        * @dev updates round timer based on number of whole keys bought.
1635        */
1636       function updateTimer(uint256 _keys, uint256 _rID)
1637           private
1638       {
1639           // grab time
1640           uint256 _now = now;
1641 
1642           // calculate time based on number of keys bought
1643           uint256 _newTime;
1644           if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1645               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1646           else
1647               _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1648 
1649           // compare to max and set new end time
1650           if (_newTime < (rndMax_).add(_now))
1651               round_[_rID].end = _newTime;
1652           else
1653               round_[_rID].end = rndMax_.add(_now);
1654       }
1655 
1656       /**
1657        * @dev generates a random number between 0-99 and checks to see if thats
1658        * resulted in an airdrop win
1659        * @return do we have a winner?
1660        */
1661       function airdrop()
1662           private
1663           view
1664           returns(bool)
1665       {
1666           uint256 seed = uint256(keccak256(abi.encodePacked(
1667 
1668               (block.timestamp).add
1669               (block.difficulty).add
1670               ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1671               (block.gaslimit).add
1672               ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1673               (block.number)
1674 
1675           )));
1676           if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1677               return(true);
1678           else
1679               return(false);
1680       }
1681 
1682       /**
1683        * @dev distributes eth based on fees to com, aff, and p3d
1684        */
1685       function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1686           private
1687           returns(F3Ddatasets.EventReturns)
1688       {
1689           // pay 3% out to community rewards
1690           uint256 _p1 = _eth / 100;
1691           uint256 _com = _eth / 50;
1692           _com = _com.add(_p1);
1693 
1694           uint256 _p3d;
1695           if (!address(admin).call.value(_com)())
1696           {
1697               // This ensures Team Just cannot influence the outcome of FoMo3D with
1698               // bank migrations by breaking outgoing transactions.
1699               // Something we would never do. But that's not the point.
1700               // We spent 2000$ in eth re-deploying just to patch this, we hold the
1701               // highest belief that everything we create should be trustless.
1702               // Team JUST, The name you shouldn't have to trust.
1703               _p3d = _com;
1704               _com = 0;
1705           }
1706 
1707 
1708           // distribute share to affiliate
1709           uint256 _aff = _eth / 10;
1710 
1711           // decide what to do with affiliate share of fees
1712           // affiliate must not be self, and must have a name registered
1713           if (_affID != _pID && plyr_[_affID].name != '') {
1714               plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1715               emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1716           } else {
1717               _p3d = _aff;
1718           }
1719 
1720           // pay out p3d
1721           _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1722           if (_p3d > 0)
1723           {
1724               // deposit to divies contract
1725               uint256 _potAmount = _p3d / 2;
1726 
1727               admin.transfer(_p3d.sub(_potAmount));
1728 
1729               round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1730 
1731               // set up event data
1732               _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1733           }
1734 
1735           return(_eventData_);
1736       }
1737 
1738       function potSwap()
1739           external
1740           payable
1741       {
1742           // setup local rID
1743           uint256 _rID = rID_ + 1;
1744 
1745           round_[_rID].pot = round_[_rID].pot.add(msg.value);
1746           emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1747       }
1748 
1749       /**
1750        * @dev distributes eth based on fees to gen and pot
1751        */
1752       function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1753           private
1754           returns(F3Ddatasets.EventReturns)
1755       {
1756           // calculate gen share
1757           uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1758 
1759           // toss 1% into airdrop pot
1760           uint256 _air = (_eth / 100);
1761           airDropPot_ = airDropPot_.add(_air);
1762 
1763           // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1764           _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1765 
1766           // calculate pot
1767           uint256 _pot = _eth.sub(_gen);
1768 
1769           // distribute gen share (thats what updateMasks() does) and adjust
1770           // balances for dust.
1771           uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1772           if (_dust > 0)
1773               _gen = _gen.sub(_dust);
1774 
1775           // add eth to pot
1776           round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1777 
1778           // set up event data
1779           _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1780           _eventData_.potAmount = _pot;
1781 
1782           return(_eventData_);
1783       }
1784 
1785       /**
1786        * @dev updates masks for round and player when keys are bought
1787        * @return dust left over
1788        */
1789       function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1790           private
1791           returns(uint256)
1792       {
1793           /* MASKING NOTES
1794               earnings masks are a tricky thing for people to wrap their minds around.
1795               the basic thing to understand here.  is were going to have a global
1796               tracker based on profit per share for each round, that increases in
1797               relevant proportion to the increase in share supply.
1798 
1799               the player will have an additional mask that basically says "based
1800               on the rounds mask, my shares, and how much i've already withdrawn,
1801               how much is still owed to me?"
1802           */
1803 
1804           // calc profit per key & round mask based on this buy:  (dust goes to pot)
1805           uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1806           round_[_rID].mask = _ppt.add(round_[_rID].mask);
1807 
1808           // calculate player earning from their own buy (only based on the keys
1809           // they just bought).  & update player earnings mask
1810           uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1811           plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1812 
1813           // calculate & return dust
1814           return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1815       }
1816 
1817       /**
1818        * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1819        * @return earnings in wei format
1820        */
1821       function withdrawEarnings(uint256 _pID)
1822           private
1823           returns(uint256)
1824       {
1825           // update gen vault
1826           updateGenVault(_pID, plyr_[_pID].lrnd);
1827 
1828           // from vaults
1829           uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1830           if (_earnings > 0)
1831           {
1832               plyr_[_pID].win = 0;
1833               plyr_[_pID].gen = 0;
1834               plyr_[_pID].aff = 0;
1835           }
1836 
1837           return(_earnings);
1838       }
1839 
1840       /**
1841        * @dev prepares compression data and fires event for buy or reload tx's
1842        */
1843       function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1844           private
1845       {
1846           _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1847           _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1848 
1849           emit F3Devents.onEndTx
1850           (
1851               _eventData_.compressedData,
1852               _eventData_.compressedIDs,
1853               plyr_[_pID].name,
1854               msg.sender,
1855               _eth,
1856               _keys,
1857               _eventData_.winnerAddr,
1858               _eventData_.winnerName,
1859               _eventData_.amountWon,
1860               _eventData_.newPot,
1861               _eventData_.P3DAmount,
1862               _eventData_.genAmount,
1863               _eventData_.potAmount,
1864               airDropPot_
1865           );
1866       }
1867   //==============================================================================
1868   //    (~ _  _    _._|_    .
1869   //    _)(/_(_|_|| | | \/  .
1870   //====================/=========================================================
1871       /** upon contract deploy, it will be deactivated.  this is a one time
1872        * use function that will activate the contract.  we do this so devs
1873        * have time to set things up on the web end                            **/
1874       bool public activated_ = false;
1875       function activate()
1876           public
1877       {
1878           // only team just can activate
1879           require(msg.sender == admin, "only admin can activate");
1880 
1881 
1882           // can only be ran once
1883           require(activated_ == false, "FOMO Short already activated");
1884 
1885           // activate the contract
1886           activated_ = true;
1887 
1888           // lets start first round
1889           rID_ = 1;
1890               round_[1].strt = now + rndExtra_ - rndGap_;
1891               round_[1].end = now + rndInit_ + rndExtra_;
1892       }
1893   }