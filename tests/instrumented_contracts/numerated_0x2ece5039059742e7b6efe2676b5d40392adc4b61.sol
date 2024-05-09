1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library F3Ddatasets {
6     //compressedData key
7     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
8         // 0 - new player (bool)
9         // 1 - joined round (bool)
10         // 2 - new  leader (bool)
11         // 3-5 - air drop tracker (uint 0-999)
12         // 6-16 - round end time
13         // 17 - winnerTeam
14         // 18 - 28 timestamp 
15         // 29 - team
16         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
17         // 31 - airdrop happened bool
18         // 32 - airdrop tier 
19         // 33 - airdrop amount won
20     //compressedIDs key
21     // [77-52][51-26][25-0]
22         // 0-25 - pID 
23         // 26-51 - winPID
24         // 52-77 - rID
25     struct EventReturns {
26         uint256 compressedData;
27         uint256 compressedIDs;
28         address winnerAddr;         // winner address
29         bytes32 winnerName;         // winner name
30         uint256 amountWon;          // amount won
31         uint256 newPot;             // amount in new pot
32         uint256 P3DAmount;          // amount distributed to p3d
33         uint256 genAmount;          // amount distributed to gen
34         uint256 potAmount;          // amount added to pot
35     }
36     struct Player {
37         address addr;   // player address
38         bytes32 name;   // player name
39         uint256 win;    // winnings vault
40         uint256 gen;    // general vault
41         uint256 aff;    // affiliate vault
42         uint256 lrnd;   // last round played
43         uint256 laff;   // last affiliate id used
44     }
45     struct PlayerRounds {
46         uint256 eth;    // eth player has added to round (used for eth limiter)
47         uint256 keys;   // keys
48         uint256 mask;   // player mask 
49         uint256 ico;    // ICO phase investment
50     }
51     struct Round {
52         uint256 plyr;   // pID of player in lead
53         uint256 team;   // tID of team in lead
54         uint256 end;    // time ends/ended
55         bool ended;     // has round end function been ran
56         uint256 strt;   // time round started
57         uint256 keys;   // keys
58         uint256 eth;    // total eth in
59         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
60         uint256 mask;   // global mask
61         uint256 ico;    // total eth sent in during ICO phase
62         uint256 icoGen; // total eth for gen during ICO phase
63         uint256 icoAvg; // average key price for ICO phase
64     }
65     struct TeamFee {
66         uint256 gen;    // % of buy in thats paid to key holders of current round
67         uint256 p3d;    // % of buy in thats paid to p3d holders
68     }
69     struct PotSplit {
70         uint256 gen;    // % of pot thats paid to key holders of current round
71         uint256 p3d;    // % of pot thats paid to p3d holders
72     }
73 }
74 contract F3Devents {
75     // fired whenever a player registers a name
76     event onNewName
77     (
78         uint256 indexed playerID,
79         address indexed playerAddress,
80         bytes32 indexed playerName,
81         bool isNewPlayer,
82         uint256 affiliateID,
83         address affiliateAddress,
84         bytes32 affiliateName,
85         uint256 amountPaid,
86         uint256 timeStamp
87     );
88     
89     // fired at end of buy or reload
90     event onEndTx
91     (
92         uint256 compressedData,     
93         uint256 compressedIDs,      
94         bytes32 playerName,
95         address playerAddress,
96         uint256 ethIn,
97         uint256 keysBought,
98         address winnerAddr,
99         bytes32 winnerName,
100         uint256 amountWon,
101         uint256 newPot,
102         uint256 P3DAmount,
103         uint256 genAmount,
104         uint256 potAmount,
105         uint256 airDropPot
106     );
107     
108 	// fired whenever theres a withdraw
109     event onWithdraw
110     (
111         uint256 indexed playerID,
112         address playerAddress,
113         bytes32 playerName,
114         uint256 ethOut,
115         uint256 timeStamp
116     );
117     
118     // fired whenever a withdraw forces end round to be ran
119     event onWithdrawAndDistribute
120     (
121         address playerAddress,
122         bytes32 playerName,
123         uint256 ethOut,
124         uint256 compressedData,
125         uint256 compressedIDs,
126         address winnerAddr,
127         bytes32 winnerName,
128         uint256 amountWon,
129         uint256 newPot,
130         uint256 P3DAmount,
131         uint256 genAmount
132     );
133     
134     // (fomo3d long only) fired whenever a player tries a buy after round timer 
135     // hit zero, and causes end round to be ran.
136     event onBuyAndDistribute
137     (
138         address playerAddress,
139         bytes32 playerName,
140         uint256 ethIn,
141         uint256 compressedData,
142         uint256 compressedIDs,
143         address winnerAddr,
144         bytes32 winnerName,
145         uint256 amountWon,
146         uint256 newPot,
147         uint256 P3DAmount,
148         uint256 genAmount
149     );
150     
151     // (fomo3d long only) fired whenever a player tries a reload after round timer 
152     // hit zero, and causes end round to be ran.
153     event onReLoadAndDistribute
154     (
155         address playerAddress,
156         bytes32 playerName,
157         uint256 compressedData,
158         uint256 compressedIDs,
159         address winnerAddr,
160         bytes32 winnerName,
161         uint256 amountWon,
162         uint256 newPot,
163         uint256 P3DAmount,
164         uint256 genAmount
165     );
166     
167     // fired whenever an affiliate is paid
168     event onAffiliatePayout
169     (
170         uint256 indexed affiliateID,
171         address affiliateAddress,
172         bytes32 affiliateName,
173         uint256 indexed roundID,
174         uint256 indexed buyerID,
175         uint256 amount,
176         uint256 timeStamp
177     );
178     
179     // received pot swap deposit
180     event onPotSwapDeposit
181     (
182         uint256 roundID,
183         uint256 amountAddedToPot
184     );
185 }
186 interface PlayerBookInterface {
187     function getPlayerID(address _addr) external returns (uint256);
188     function getPlayerName(uint256 _pID) external view returns (bytes32);
189     function getPlayerLAff(uint256 _pID) external view returns (uint256);
190     function getPlayerAddr(uint256 _pID) external view returns (address);
191     function getNameFee() external view returns (uint256);
192     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
193     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
194     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
195     function isDev(address _who) external view returns(bool);
196 }
197 library SafeMath {
198     
199     /**
200     * @dev Multiplies two numbers, throws on overflow.
201     */
202     function mul(uint256 a, uint256 b) 
203         internal 
204         pure 
205         returns (uint256 c) 
206     {
207         if (a == 0) {
208             return 0;
209         }
210         c = a * b;
211         require(c / a == b, "SafeMath mul failed");
212         return c;
213     }
214 
215     /**
216     * @dev Integer division of two numbers, truncating the quotient.
217     */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         // assert(b > 0); // Solidity automatically throws when dividing by 0
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222         return c;
223     }
224     
225     /**
226     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
227     */
228     function sub(uint256 a, uint256 b)
229         internal
230         pure
231         returns (uint256) 
232     {
233         require(b <= a, "SafeMath sub failed");
234         return a - b;
235     }
236 
237     /**
238     * @dev Adds two numbers, throws on overflow.
239     */
240     function add(uint256 a, uint256 b)
241         internal
242         pure
243         returns (uint256 c) 
244     {
245         c = a + b;
246         require(c >= a, "SafeMath add failed");
247         return c;
248     }
249     
250     /**
251      * @dev gives square root of given x.
252      */
253     function sqrt(uint256 x)
254         internal
255         pure
256         returns (uint256 y) 
257     {
258         uint256 z = ((add(x,1)) / 2);
259         y = x;
260         while (z < y) 
261         {
262             y = z;
263             z = ((add((x / z),z)) / 2);
264         }
265     }
266     
267     /**
268      * @dev gives square. multiplies x by x
269      */
270     function sq(uint256 x)
271         internal
272         pure
273         returns (uint256)
274     {
275         return (mul(x,x));
276     }
277     
278     /**
279      * @dev x to the power of y 
280      */
281     function pwr(uint256 x, uint256 y)
282         internal 
283         pure 
284         returns (uint256)
285     {
286         if (x==0)
287             return (0);
288         else if (y==0)
289             return (1);
290         else 
291         {
292             uint256 z = x;
293             for (uint256 i=1; i < y; i++)
294                 z = mul(z,x);
295             return (z);
296         }
297     }
298 }
299 library NameFilter {
300     /**
301      * @dev filters name strings
302      * -converts uppercase to lower case.  
303      * -makes sure it does not start/end with a space
304      * -makes sure it does not contain multiple spaces in a row
305      * -cannot be only numbers
306      * -cannot start with 0x 
307      * -restricts characters to A-Z, a-z, 0-9, and space.
308      * @return reprocessed string in bytes32 format
309      */
310     function nameFilter(string _input)
311         internal
312         pure
313         returns(bytes32)
314     {
315         bytes memory _temp = bytes(_input);
316         uint256 _length = _temp.length;
317         
318         //sorry limited to 32 characters
319         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
320         // make sure it doesnt start with or end with space
321         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
322         // make sure first two characters are not 0x
323         if (_temp[0] == 0x30)
324         {
325             require(_temp[1] != 0x78, "string cannot start with 0x");
326             require(_temp[1] != 0x58, "string cannot start with 0X");
327         }
328         
329         // create a bool to track if we have a non number character
330         bool _hasNonNumber;
331         
332         // convert & check
333         for (uint256 i = 0; i < _length; i++)
334         {
335             // if its uppercase A-Z
336             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
337             {
338                 // convert to lower case a-z
339                 _temp[i] = byte(uint(_temp[i]) + 32);
340                 
341                 // we have a non number
342                 if (_hasNonNumber == false)
343                     _hasNonNumber = true;
344             } else {
345                 require
346                 (
347                     // require character is a space
348                     _temp[i] == 0x20 || 
349                     // OR lowercase a-z
350                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
351                     // or 0-9
352                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
353                     "string contains invalid characters"
354                 );
355                 // make sure theres not 2x spaces in a row
356                 if (_temp[i] == 0x20)
357                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
358                 
359                 // see if we have a character other than a number
360                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
361                     _hasNonNumber = true;    
362             }
363         }
364         
365         require(_hasNonNumber == true, "string cannot be only numbers");
366         
367         bytes32 _ret;
368         assembly {
369             _ret := mload(add(_temp, 32))
370         }
371         return (_ret);
372     }
373 }
374 library F3DKeysCalcLong {
375     using SafeMath for *;
376     /**
377      * @dev calculates number of keys received given X eth 
378      * @param _curEth current amount of eth in contract 
379      * @param _newEth eth being spent
380      * @return amount of ticket purchased
381      */
382     function keysRec(uint256 _curEth, uint256 _newEth)
383         internal
384         pure
385         returns (uint256)
386     {
387         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
388     }
389     
390     /**
391      * @dev calculates amount of eth received if you sold X keys 
392      * @param _curKeys current amount of keys that exist 
393      * @param _sellKeys amount of keys you wish to sell
394      * @return amount of eth received
395      */
396     function ethRec(uint256 _curKeys, uint256 _sellKeys)
397         internal
398         pure
399         returns (uint256)
400     {
401         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
402     }
403 
404     /**
405      * @dev calculates how many keys would exist with given an amount of eth
406      * @param _eth eth "in contract"
407      * @return number of keys that would exist
408      */
409     function keys(uint256 _eth) 
410         internal
411         pure
412         returns(uint256)
413     {
414         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
415     }
416     
417     /**
418      * @dev calculates how much eth would be in contract given a number of keys
419      * @param _keys number of keys "in contract" 
420      * @return eth that would exists
421      */
422     function eth(uint256 _keys) 
423         internal
424         pure
425         returns(uint256)  
426     {
427         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
428     }
429 }
430 contract FoMo3Dlong is F3Devents {
431     using SafeMath for *;
432     using NameFilter for string;
433     using F3DKeysCalcLong for uint256;
434 
435     address public otherF3D_;
436     address  public Divies;
437     address  public Jekyll_Island_Inc;
438     address public playerBook;// =PlayerBookInterface(0x0dcd2f752394c41875e259e00bb44fd505297caf);//new PlayerBook();//
439     //    TeamJustInterface constant private teamJust = TeamJustInterface(0x3a5f8140b9213a0f733a6a639857c9df43ee3f5a);// new TeamJust();//
440 
441     //==============================================================================
442     //     _ _  _  |`. _     _ _ |_ | _  _  .
443     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
444     //=================_|===========================================================
445     string constant public name = "FoMo3D Long Official";
446     string constant public symbol = "F3D";
447     uint256 private rndExtra_ = 30;//extSettings.getLongExtra();     // length of the very first ICO
448     uint256 private rndGap_ = 30; //extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
449     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
450     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
451     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
452     //==============================================================================
453     //     _| _ _|_ _    _ _ _|_    _   .
454     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
455     //=============================|================================================
456     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
457     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
458     uint256 public rID_;    // round id number / total rounds that have happened
459     //****************
460     // PLAYER DATA
461     //****************
462     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
463     mapping(bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
464     mapping(uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
465     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
466     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
467     //****************
468     // ROUND DATA
469     //****************
470     mapping(uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
471     mapping(uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
472     //****************
473     // TEAM FEE DATA
474     //****************
475     mapping(uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
476     mapping(uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
477 
478     function setPlayerBook(address _playerBook) external {
479         require(msg.sender == owner, 'only dev!');
480         require(address(playerBook) == address(0), 'already set!');
481         playerBook = _playerBook;
482     }
483 
484     address public owner;
485 
486     //==============================================================================
487     //     _ _  _  __|_ _    __|_ _  _  .
488     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
489     //==============================================================================
490     constructor()
491     public
492     {
493         owner = msg.sender;
494         // Team allocation structures
495         // 0 = whales
496         // 1 = bears
497         // 2 = sneks
498         // 3 = bulls
499 
500         // Team allocation percentages
501         // (F3D, P3D) + (Pot , Referrals, Community)
502         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
503         fees_[0] = F3Ddatasets.TeamFee(30, 6);
504         //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
505         fees_[1] = F3Ddatasets.TeamFee(43, 0);
506         //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
507         fees_[2] = F3Ddatasets.TeamFee(56, 10);
508         //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
509         fees_[3] = F3Ddatasets.TeamFee(43, 8);
510         //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
511 
512         // how to split up the final pot based on which team was picked
513         // (F3D, P3D)
514         potSplit_[0] = F3Ddatasets.PotSplit(15, 10);
515         //48% to winner, 25% to next round, 2% to com
516         potSplit_[1] = F3Ddatasets.PotSplit(25, 0);
517         //48% to winner, 25% to next round, 2% to com
518         potSplit_[2] = F3Ddatasets.PotSplit(20, 20);
519         //48% to winner, 10% to next round, 2% to com
520         potSplit_[3] = F3Ddatasets.PotSplit(30, 10);
521         //48% to winner, 10% to next round, 2% to com
522     }
523     //==============================================================================
524     //     _ _  _  _|. |`. _  _ _  .
525     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
526     //==============================================================================
527     /**
528      * @dev used to make sure no one can interact with contract until it has 
529      * been activated. 
530      */
531     modifier isActivated() {
532         require(activated_ == true, "its not ready yet.  check ?eta in discord");
533         _;
534     }
535 
536     /**
537      * @dev prevents contracts from interacting with fomo3d 
538      */
539     modifier isHuman() {
540         address _addr = msg.sender;
541         uint256 _codeLength;
542 
543         assembly {_codeLength := extcodesize(_addr)}
544         require(_codeLength == 0, "sorry humans only");
545         _;
546     }
547 
548     modifier onlyDevs()
549     {
550         require(PlayerBookInterface(playerBook).isDev(msg.sender) == true, "msg sender is not a dev");
551         _;
552     }
553 
554     /**
555      * @dev sets boundaries for incoming tx 
556      */
557     modifier isWithinLimits(uint256 _eth) {
558         require(_eth >= 1000000000, "pocket lint: not a valid currency");
559         require(_eth <= 100000000000000000000000, "no vitalik, no");
560         _;
561     }
562 
563     //==============================================================================
564     //     _    |_ |. _   |`    _  __|_. _  _  _  .
565     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
566     //====|=========================================================================
567     /**
568      * @dev emergency buy uses last stored affiliate ID and team snek
569      */
570     function()
571     isActivated()
572     isHuman()
573     isWithinLimits(msg.value)
574     public
575     payable
576     {
577         // set up our tx event data and determine if player is new or not
578         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
579 
580         // fetch player id
581         uint256 _pID = pIDxAddr_[msg.sender];
582 
583         // buy core 
584         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
585     }
586 
587     /**
588      * @dev converts all incoming ethereum to keys.
589      * -functionhash- 0x8f38f309 (using ID for affiliate)
590      * -functionhash- 0x98a0871d (using address for affiliate)
591      * -functionhash- 0xa65b37a1 (using name for affiliate)
592      * @param _affCode the ID/address/name of the player who gets the affiliate fee
593      * @param _team what team is the player playing for?
594      */
595     function buyXid(uint256 _affCode, uint256 _team)
596     isActivated()
597     isHuman()
598     isWithinLimits(msg.value)
599     public
600     payable
601     {
602         // set up our tx event data and determine if player is new or not
603         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
604 
605         // fetch player id
606         uint256 _pID = pIDxAddr_[msg.sender];
607 
608         // manage affiliate residuals
609         // if no affiliate code was given or player tried to use their own, lolz
610         if (_affCode == 0 || _affCode == _pID)
611         {
612             // use last stored affiliate code 
613             _affCode = plyr_[_pID].laff;
614 
615             // if affiliate code was given & its not the same as previously stored
616         } else if (_affCode != plyr_[_pID].laff) {
617             // update last affiliate 
618             plyr_[_pID].laff = _affCode;
619         }
620 
621         // verify a valid team was selected
622         _team = verifyTeam(_team);
623 
624         // buy core 
625         buyCore(_pID, _affCode, _team, _eventData_);
626     }
627 
628     function buyXaddr(address _affCode, uint256 _team)
629     isActivated()
630     isHuman()
631     isWithinLimits(msg.value)
632     public
633     payable
634     {
635         // set up our tx event data and determine if player is new or not
636         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
637 
638         // fetch player id
639         uint256 _pID = pIDxAddr_[msg.sender];
640 
641         // manage affiliate residuals
642         uint256 _affID;
643         // if no affiliate code was given or player tried to use their own, lolz
644         if (_affCode == address(0) || _affCode == msg.sender)
645         {
646             // use last stored affiliate code
647             _affID = plyr_[_pID].laff;
648 
649             // if affiliate code was given
650         } else {
651             // get affiliate ID from aff Code 
652             _affID = pIDxAddr_[_affCode];
653 
654             // if affID is not the same as previously stored 
655             if (_affID != plyr_[_pID].laff)
656             {
657                 // update last affiliate
658                 plyr_[_pID].laff = _affID;
659             }
660         }
661 
662         // verify a valid team was selected
663         _team = verifyTeam(_team);
664 
665         // buy core 
666         buyCore(_pID, _affID, _team, _eventData_);
667     }
668 
669     function buyXname(bytes32 _affCode, uint256 _team)
670     isActivated()
671     isHuman()
672     isWithinLimits(msg.value)
673     public
674     payable
675     {
676         // set up our tx event data and determine if player is new or not
677         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
678 
679         // fetch player id
680         uint256 _pID = pIDxAddr_[msg.sender];
681 
682         // manage affiliate residuals
683         uint256 _affID;
684         // if no affiliate code was given or player tried to use their own, lolz
685         if (_affCode == '' || _affCode == plyr_[_pID].name)
686         {
687             // use last stored affiliate code
688             _affID = plyr_[_pID].laff;
689 
690             // if affiliate code was given
691         } else {
692             // get affiliate ID from aff Code
693             _affID = pIDxName_[_affCode];
694 
695             // if affID is not the same as previously stored
696             if (_affID != plyr_[_pID].laff)
697             {
698                 // update last affiliate
699                 plyr_[_pID].laff = _affID;
700             }
701         }
702 
703         // verify a valid team was selected
704         _team = verifyTeam(_team);
705 
706         // buy core 
707         buyCore(_pID, _affID, _team, _eventData_);
708     }
709 
710     /**
711      * @dev essentially the same as buy, but instead of you sending ether 
712      * from your wallet, it uses your unwithdrawn earnings.
713      * -functionhash- 0x349cdcac (using ID for affiliate)
714      * -functionhash- 0x82bfc739 (using address for affiliate)
715      * -functionhash- 0x079ce327 (using name for affiliate)
716      * @param _affCode the ID/address/name of the player who gets the affiliate fee
717      * @param _team what team is the player playing for?
718      * @param _eth amount of earnings to use (remainder returned to gen vault)
719      */
720     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
721     isActivated()
722     isHuman()
723     isWithinLimits(_eth)
724     public
725     {
726         // set up our tx event data
727         F3Ddatasets.EventReturns memory _eventData_;
728 
729         // fetch player ID
730         uint256 _pID = pIDxAddr_[msg.sender];
731 
732         // manage affiliate residuals
733         // if no affiliate code was given or player tried to use their own, lolz
734         if (_affCode == 0 || _affCode == _pID)
735         {
736             // use last stored affiliate code 
737             _affCode = plyr_[_pID].laff;
738 
739             // if affiliate code was given & its not the same as previously stored
740         } else if (_affCode != plyr_[_pID].laff) {
741             // update last affiliate 
742             plyr_[_pID].laff = _affCode;
743         }
744 
745         // verify a valid team was selected
746         _team = verifyTeam(_team);
747 
748         // reload core
749         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
750     }
751 
752     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
753     isActivated()
754     isHuman()
755     isWithinLimits(_eth)
756     public
757     {
758         // set up our tx event data
759         F3Ddatasets.EventReturns memory _eventData_;
760 
761         // fetch player ID
762         uint256 _pID = pIDxAddr_[msg.sender];
763 
764         // manage affiliate residuals
765         uint256 _affID;
766         // if no affiliate code was given or player tried to use their own, lolz
767         if (_affCode == address(0) || _affCode == msg.sender)
768         {
769             // use last stored affiliate code
770             _affID = plyr_[_pID].laff;
771 
772             // if affiliate code was given
773         } else {
774             // get affiliate ID from aff Code 
775             _affID = pIDxAddr_[_affCode];
776 
777             // if affID is not the same as previously stored 
778             if (_affID != plyr_[_pID].laff)
779             {
780                 // update last affiliate
781                 plyr_[_pID].laff = _affID;
782             }
783         }
784 
785         // verify a valid team was selected
786         _team = verifyTeam(_team);
787 
788         // reload core
789         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
790     }
791 
792     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
793     isActivated()
794     isHuman()
795     isWithinLimits(_eth)
796     public
797     {
798         // set up our tx event data
799         F3Ddatasets.EventReturns memory _eventData_;
800 
801         // fetch player ID
802         uint256 _pID = pIDxAddr_[msg.sender];
803 
804         // manage affiliate residuals
805         uint256 _affID;
806         // if no affiliate code was given or player tried to use their own, lolz
807         if (_affCode == '' || _affCode == plyr_[_pID].name)
808         {
809             // use last stored affiliate code
810             _affID = plyr_[_pID].laff;
811 
812             // if affiliate code was given
813         } else {
814             // get affiliate ID from aff Code
815             _affID = pIDxName_[_affCode];
816 
817             // if affID is not the same as previously stored
818             if (_affID != plyr_[_pID].laff)
819             {
820                 // update last affiliate
821                 plyr_[_pID].laff = _affID;
822             }
823         }
824 
825         // verify a valid team was selected
826         _team = verifyTeam(_team);
827 
828         // reload core
829         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
830     }
831 
832     /**
833      * @dev withdraws all of your earnings.
834      * -functionhash- 0x3ccfd60b
835      */
836     function withdraw()
837     isActivated()
838     isHuman()
839     public
840     {
841         // setup local rID 
842         uint256 _rID = rID_;
843 
844         // grab time
845         uint256 _now = now;
846 
847         // fetch player ID
848         uint256 _pID = pIDxAddr_[msg.sender];
849 
850         // setup temp var for player eth
851         uint256 _eth;
852 
853         // check to see if round has ended and no one has run round end yet
854         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
855         {
856             // set up our tx event data
857             F3Ddatasets.EventReturns memory _eventData_;
858 
859             // end the round (distributes pot)
860             round_[_rID].ended = true;
861             _eventData_ = endRound(_eventData_);
862 
863             // get their earnings
864             _eth = withdrawEarnings(_pID);
865 
866             // gib moni
867             if (_eth > 0)
868                 plyr_[_pID].addr.transfer(_eth);
869 
870             // build event data
871             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
872             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
873 
874             // fire withdraw and distribute event
875             emit F3Devents.onWithdrawAndDistribute
876             (
877                 msg.sender,
878                 plyr_[_pID].name,
879                 _eth,
880                 _eventData_.compressedData,
881                 _eventData_.compressedIDs,
882                 _eventData_.winnerAddr,
883                 _eventData_.winnerName,
884                 _eventData_.amountWon,
885                 _eventData_.newPot,
886                 _eventData_.P3DAmount,
887                 _eventData_.genAmount
888             );
889 
890             // in any other situation
891         } else {
892             // get their earnings
893             _eth = withdrawEarnings(_pID);
894 
895             // gib moni
896             if (_eth > 0)
897                 plyr_[_pID].addr.transfer(_eth);
898 
899             // fire withdraw event
900             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
901         }
902     }
903 
904     /**
905      * @dev use these to register names.  they are just wrappers that will send the
906      * registration requests to the PlayerBook contract.  So registering here is the 
907      * same as registering there.  UI will always display the last name you registered.
908      * but you will still own all previously registered names to use as affiliate 
909      * links.
910      * - must pay a registration fee.
911      * - name must be unique
912      * - names will be converted to lowercase
913      * - name cannot start or end with a space 
914      * - cannot have more than 1 space in a row
915      * - cannot be only numbers
916      * - cannot start with 0x 
917      * - name must be at least 1 char
918      * - max length of 32 characters long
919      * - allowed characters: a-z, 0-9, and space
920      * -functionhash- 0x921dec21 (using ID for affiliate)
921      * -functionhash- 0x3ddd4698 (using address for affiliate)
922      * -functionhash- 0x685ffd83 (using name for affiliate)
923      * @param _nameString players desired name
924      * @param _affCode affiliate ID, address, or name of who referred you
925      * @param _all set to true if you want this to push your info to all games 
926      * (this might cost a lot of gas)
927      */
928     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
929     isHuman()
930     public
931     payable
932     {
933         bytes32 _name = _nameString.nameFilter();
934         address _addr = msg.sender;
935         uint256 _paid = msg.value;
936         (bool _isNewPlayer, uint256 _affID) = PlayerBookInterface(playerBook).registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
937 
938         uint256 _pID = pIDxAddr_[_addr];
939 
940         // fire event
941         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
942     }
943 
944     function registerNameXaddr(string _nameString, address _affCode, bool _all)
945     isHuman()
946     public
947     payable
948     {
949         bytes32 _name = _nameString.nameFilter();
950         address _addr = msg.sender;
951         uint256 _paid = msg.value;
952         (bool _isNewPlayer, uint256 _affID) = PlayerBookInterface(playerBook).registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
953 
954         uint256 _pID = pIDxAddr_[_addr];
955 
956         // fire event
957         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
958     }
959 
960     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
961     isHuman()
962     public
963     payable
964     {
965         bytes32 _name = _nameString.nameFilter();
966         address _addr = msg.sender;
967         uint256 _paid = msg.value;
968         (bool _isNewPlayer, uint256 _affID) = PlayerBookInterface(playerBook).registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
969 
970         uint256 _pID = pIDxAddr_[_addr];
971 
972         // fire event
973         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
974     }
975     //==============================================================================
976     //     _  _ _|__|_ _  _ _  .
977     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
978     //=====_|=======================================================================
979     /**
980      * @dev return the price buyer will pay for next 1 individual key.
981      * -functionhash- 0x018a25e8
982      * @return price for next key bought (in wei format)
983      */
984     function getBuyPrice()
985     public
986     view
987     returns (uint256)
988     {
989         // setup local rID
990         uint256 _rID = rID_;
991 
992         // grab time
993         uint256 _now = now;
994 
995         // are we in a round?
996         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
997             return ((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000));
998         else // rounds over.  need price for new round
999             return (75000000000000);
1000         // init
1001     }
1002 
1003     /**
1004      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
1005      * provider
1006      * -functionhash- 0xc7e284b8
1007      * @return time left in seconds
1008      */
1009     function getTimeLeft()
1010     public
1011     view
1012     returns (uint256)
1013     {
1014         // setup local rID
1015         uint256 _rID = rID_;
1016 
1017         // grab time
1018         uint256 _now = now;
1019 
1020         if (_now < round_[_rID].end)
1021             if (_now > round_[_rID].strt + rndGap_)
1022                 return ((round_[_rID].end).sub(_now));
1023             else
1024                 return ((round_[_rID].strt + rndGap_).sub(_now));
1025         else
1026             return (0);
1027     }
1028 
1029     /**
1030      * @dev returns player earnings per vaults 
1031      * -functionhash- 0x63066434
1032      * @return winnings vault
1033      * @return general vault
1034      * @return affiliate vault
1035      */
1036     function getPlayerVaults(uint256 _pID)
1037     public
1038     view
1039     returns (uint256, uint256, uint256)
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
1052                 (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
1053                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1054                 plyr_[_pID].aff
1055                 );
1056                 // if player is not the winner
1057             } else {
1058                 return
1059                 (
1060                 plyr_[_pID].win,
1061                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1062                 plyr_[_pID].aff
1063                 );
1064             }
1065 
1066             // if round is still going on, or round has ended and round end has been ran
1067         } else {
1068             return
1069             (
1070             plyr_[_pID].win,
1071             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1072             plyr_[_pID].aff
1073             );
1074         }
1075     }
1076 
1077     /**
1078      * solidity hates stack limits.  this lets us avoid that hate 
1079      */
1080     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1081     private
1082     view
1083     returns (uint256)
1084     {
1085         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
1086     }
1087 
1088     /**
1089      * @dev returns all current round info needed for front end
1090      * -functionhash- 0x747dff42
1091      * @return eth invested during ICO phase
1092      * @return round id 
1093      * @return total keys for round 
1094      * @return time round ends
1095      * @return time round started
1096      * @return current pot 
1097      * @return current team ID & player ID in lead 
1098      * @return current player in leads address 
1099      * @return current player in leads name
1100      * @return whales eth in for round
1101      * @return bears eth in for round
1102      * @return sneks eth in for round
1103      * @return bulls eth in for round
1104      * @return airdrop tracker # & airdrop pot
1105      */
1106     function getCurrentRoundInfo()
1107     public
1108     view
1109     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1110     {
1111         // setup local rID
1112         uint256 _rID = rID_;
1113 
1114         return
1115         (
1116         round_[_rID].ico, //0
1117         _rID, //1
1118         round_[_rID].keys, //2
1119         round_[_rID].end, //3
1120         round_[_rID].strt, //4
1121         round_[_rID].pot, //5
1122         (round_[_rID].team + (round_[_rID].plyr * 10)), //6
1123         plyr_[round_[_rID].plyr].addr, //7
1124         plyr_[round_[_rID].plyr].name, //8
1125         rndTmEth_[_rID][0], //9
1126         rndTmEth_[_rID][1], //10
1127         rndTmEth_[_rID][2], //11
1128         rndTmEth_[_rID][3], //12
1129         airDropTracker_ + (airDropPot_ * 1000)              //13
1130         );
1131     }
1132 
1133     /**
1134      * @dev returns player info based on address.  if no address is given, it will 
1135      * use msg.sender 
1136      * -functionhash- 0xee0b5d8b
1137      * @param _addr address of the player you want to lookup 
1138      * @return player ID 
1139      * @return player name
1140      * @return keys owned (current round)
1141      * @return winnings vault
1142      * @return general vault 
1143      * @return affiliate vault 
1144 	 * @return player round eth
1145      */
1146     function getPlayerInfoByAddress(address _addr)
1147     public
1148     view
1149     returns (uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
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
1162         _pID, //0
1163         plyr_[_pID].name, //1
1164         plyrRnds_[_pID][_rID].keys, //2
1165         plyr_[_pID].win, //3
1166         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), //4
1167         plyr_[_pID].aff, //5
1168         plyrRnds_[_pID][_rID].eth           //6
1169         );
1170     }
1171 
1172     //==============================================================================
1173     //     _ _  _ _   | _  _ . _  .
1174     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1175     //=====================_|=======================================================
1176     /**
1177      * @dev logic runs whenever a buy order is executed.  determines how to handle 
1178      * incoming eth depending on if we are in an active round or not
1179      */
1180     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1181     private
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
1193             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1194 
1195             // if round is not active
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
1231      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1232      * incoming eth depending on if we are in an active round or not 
1233      */
1234     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1235     private
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
1246             // get earnings from all vaults and return unused to gen vault
1247             // because we use a custom safemath library.  this will throw if player 
1248             // tried to spend more eth than they have.
1249             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1250 
1251             // call core 
1252             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1253 
1254             // if round is not active and end round needs to be ran
1255         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1256             // end the round (distributes pot) & start new round
1257             round_[_rID].ended = true;
1258             _eventData_ = endRound(_eventData_);
1259 
1260             // build event data
1261             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1262             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1263 
1264             // fire buy and distribute event 
1265             emit F3Devents.onReLoadAndDistribute
1266             (
1267                 msg.sender,
1268                 plyr_[_pID].name,
1269                 _eventData_.compressedData,
1270                 _eventData_.compressedIDs,
1271                 _eventData_.winnerAddr,
1272                 _eventData_.winnerName,
1273                 _eventData_.amountWon,
1274                 _eventData_.newPot,
1275                 _eventData_.P3DAmount,
1276                 _eventData_.genAmount
1277             );
1278         }
1279     }
1280 
1281     /**
1282      * @dev this is the core logic for any buy/reload that happens while a round 
1283      * is live.
1284      */
1285     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1286     private
1287     {
1288         // if player is new to round
1289         if (plyrRnds_[_pID][_rID].keys == 0)
1290             _eventData_ = managePlayer(_pID, _eventData_);
1291 
1292         // early round eth limiter 
1293         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1294         {
1295             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1296             uint256 _refund = _eth.sub(_availableLimit);
1297             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1298             _eth = _availableLimit;
1299         }
1300 
1301         // if eth left is greater than min eth allowed (sorry no pocket lint)
1302         if (_eth > 1000000000)
1303         {
1304 
1305             // mint the new keys
1306             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1307 
1308             // if they bought at least 1 whole key
1309             if (_keys >= 1000000000000000000)
1310             {
1311                 updateTimer(_keys, _rID);
1312 
1313                 // set new leaders
1314                 if (round_[_rID].plyr != _pID)
1315                     round_[_rID].plyr = _pID;
1316                 if (round_[_rID].team != _team)
1317                     round_[_rID].team = _team;
1318 
1319                 // set the new leader bool to true
1320                 _eventData_.compressedData = _eventData_.compressedData + 100;
1321             }
1322 
1323             // manage airdrops
1324             if (_eth >= 100000000000000000)
1325             {
1326                 airDropTracker_++;
1327                 if (airdrop() == true)
1328                 {
1329                     // gib muni
1330                     uint256 _prize;
1331                     if (_eth >= 10000000000000000000)
1332                     {
1333                         // calculate prize and give it to winner
1334                         _prize = ((airDropPot_).mul(75)) / 100;
1335                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1336 
1337                         // adjust airDropPot
1338                         airDropPot_ = (airDropPot_).sub(_prize);
1339 
1340                         // let event know a tier 3 prize was won
1341                         _eventData_.compressedData += 300000000000000000000000000000000;
1342                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1343                         // calculate prize and give it to winner
1344                         _prize = ((airDropPot_).mul(50)) / 100;
1345                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1346 
1347                         // adjust airDropPot
1348                         airDropPot_ = (airDropPot_).sub(_prize);
1349 
1350                         // let event know a tier 2 prize was won
1351                         _eventData_.compressedData += 200000000000000000000000000000000;
1352                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1353                         // calculate prize and give it to winner
1354                         _prize = ((airDropPot_).mul(25)) / 100;
1355                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1356 
1357                         // adjust airDropPot
1358                         airDropPot_ = (airDropPot_).sub(_prize);
1359 
1360                         // let event know a tier 3 prize was won
1361                         _eventData_.compressedData += 300000000000000000000000000000000;
1362                     }
1363                     // set airdrop happened bool to true
1364                     _eventData_.compressedData += 10000000000000000000000000000000;
1365                     // let event know how much was won
1366                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1367 
1368                     // reset air drop tracker
1369                     airDropTracker_ = 0;
1370                 }
1371             }
1372 
1373             // store the air drop tracker number (number of buys since last airdrop)
1374             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1375 
1376             // update player 
1377             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1378             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1379 
1380             // update round
1381             round_[_rID].keys = _keys.add(round_[_rID].keys);
1382             round_[_rID].eth = _eth.add(round_[_rID].eth);
1383             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1384 
1385             // distribute eth
1386             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1387             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1388 
1389             // call end tx function to fire end tx event.
1390             endTx(_pID, _team, _eth, _keys, _eventData_);
1391         }
1392     }
1393     //==============================================================================
1394     //     _ _ | _   | _ _|_ _  _ _  .
1395     //    (_(_||(_|_||(_| | (_)| _\  .
1396     //==============================================================================
1397     /**
1398      * @dev calculates unmasked earnings (just calculates, does not update mask)
1399      * @return earnings in wei format
1400      */
1401     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1402     private
1403     view
1404     returns (uint256)
1405     {
1406         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
1407     }
1408 
1409     /** 
1410      * @dev returns the amount of keys you would get given an amount of eth. 
1411      * -functionhash- 0xce89c80c
1412      * @param _rID round ID you want price for
1413      * @param _eth amount of eth sent in 
1414      * @return keys received 
1415      */
1416     function calcKeysReceived(uint256 _rID, uint256 _eth)
1417     public
1418     view
1419     returns (uint256)
1420     {
1421         // grab time
1422         uint256 _now = now;
1423 
1424         // are we in a round?
1425         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1426             return ((round_[_rID].eth).keysRec(_eth));
1427         else // rounds over.  need keys for new round
1428             return ((_eth).keys());
1429     }
1430 
1431     /** 
1432      * @dev returns current eth price for X keys.  
1433      * -functionhash- 0xcf808000
1434      * @param _keys number of keys desired (in 18 decimal format)
1435      * @return amount of eth needed to send
1436      */
1437     function iWantXKeys(uint256 _keys)
1438     public
1439     view
1440     returns (uint256)
1441     {
1442         // setup local rID
1443         uint256 _rID = rID_;
1444 
1445         // grab time
1446         uint256 _now = now;
1447 
1448         // are we in a round?
1449         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1450             return ((round_[_rID].keys.add(_keys)).ethRec(_keys));
1451         else // rounds over.  need price for new round
1452             return ((_keys).eth());
1453     }
1454     //==============================================================================
1455     //    _|_ _  _ | _  .
1456     //     | (_)(_)|_\  .
1457     //==============================================================================
1458     /**
1459 	 * @dev receives name/player info from names contract 
1460      */
1461     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1462     external
1463     {
1464         require(msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
1465         if (pIDxAddr_[_addr] != _pID)
1466             pIDxAddr_[_addr] = _pID;
1467         if (pIDxName_[_name] != _pID)
1468             pIDxName_[_name] = _pID;
1469         if (plyr_[_pID].addr != _addr)
1470             plyr_[_pID].addr = _addr;
1471         if (plyr_[_pID].name != _name)
1472             plyr_[_pID].name = _name;
1473         if (plyr_[_pID].laff != _laff)
1474             plyr_[_pID].laff = _laff;
1475         if (plyrNames_[_pID][_name] == false)
1476             plyrNames_[_pID][_name] = true;
1477     }
1478 
1479     /**
1480      * @dev receives entire player name list 
1481      */
1482     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1483     external
1484     {
1485         require(msg.sender == address(playerBook), "your not playerNames contract... hmmm..");
1486         if (plyrNames_[_pID][_name] == false)
1487             plyrNames_[_pID][_name] = true;
1488     }
1489 
1490     /**
1491      * @dev gets existing or registers new pID.  use this when a player may be new
1492      * @return pID 
1493      */
1494     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1495     private
1496     returns (F3Ddatasets.EventReturns)
1497     {
1498         uint256 _pID = pIDxAddr_[msg.sender];
1499         // if player is new to this version of fomo3d
1500         if (_pID == 0)
1501         {
1502             // grab their player ID, name and last aff ID, from player names contract 
1503             _pID = PlayerBookInterface(playerBook).getPlayerID(msg.sender);
1504             bytes32 _name = PlayerBookInterface(playerBook).getPlayerName(_pID);
1505             uint256 _laff = PlayerBookInterface(playerBook).getPlayerLAff(_pID);
1506 
1507             // set up player account 
1508             pIDxAddr_[msg.sender] = _pID;
1509             plyr_[_pID].addr = msg.sender;
1510 
1511             if (_name != "")
1512             {
1513                 pIDxName_[_name] = _pID;
1514                 plyr_[_pID].name = _name;
1515                 plyrNames_[_pID][_name] = true;
1516             }
1517 
1518             if (_laff != 0 && _laff != _pID)
1519                 plyr_[_pID].laff = _laff;
1520 
1521             // set the new player bool to true
1522             _eventData_.compressedData = _eventData_.compressedData + 1;
1523         }
1524         return (_eventData_);
1525     }
1526 
1527     /**
1528      * @dev checks to make sure user picked a valid team.  if not sets team 
1529      * to default (sneks)
1530      */
1531     function verifyTeam(uint256 _team)
1532     private
1533     pure
1534     returns (uint256)
1535     {
1536         if (_team < 0 || _team > 3)
1537             return (2);
1538         else
1539             return (_team);
1540     }
1541 
1542     /**
1543      * @dev decides if round end needs to be run & new round started.  and if 
1544      * player unmasked earnings from previously played rounds need to be moved.
1545      */
1546     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1547     private
1548     returns (F3Ddatasets.EventReturns)
1549     {
1550         // if player has played a previous round, move their unmasked earnings
1551         // from that round to gen vault.
1552         if (plyr_[_pID].lrnd != 0)
1553             updateGenVault(_pID, plyr_[_pID].lrnd);
1554 
1555         // update player's last round played
1556         plyr_[_pID].lrnd = rID_;
1557 
1558         // set the joined round bool to true
1559         _eventData_.compressedData = _eventData_.compressedData + 10;
1560 
1561         return (_eventData_);
1562     }
1563 
1564     /**
1565      * @dev ends the round. manages paying out winner/splitting up pot
1566      */
1567     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1568     private
1569     returns (F3Ddatasets.EventReturns)
1570     {
1571         // setup local rID
1572         uint256 _rID = rID_;
1573 
1574         // grab our winning player and team id's
1575         uint256 _winPID = round_[_rID].plyr;
1576         uint256 _winTID = round_[_rID].team;
1577 
1578         // grab our pot amount
1579         uint256 _pot = round_[_rID].pot;
1580 
1581         // calculate our winner share, community rewards, gen share, 
1582         // p3d share, and amount reserved for next pot 
1583         uint256 _win = (_pot.mul(48)) / 100;
1584         uint256 _com = (_pot / 50);
1585         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1586         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1587         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1588 
1589         // calculate ppt for round mask
1590         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1591         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1592         if (_dust > 0)
1593         {
1594             _gen = _gen.sub(_dust);
1595             _res = _res.add(_dust);
1596         }
1597 
1598         // pay our winner
1599         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1600 
1601         // community rewards
1602         if (!address(Jekyll_Island_Inc).send(_com))
1603         {
1604             // This ensures Team Just cannot influence the outcome of FoMo3D with
1605             // bank migrations by breaking outgoing transactions.
1606             // Something we would never do. But that's not the point.
1607             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1608             // highest belief that everything we create should be trustless.
1609             // Team JUST, The name you shouldn't have to trust.
1610             _p3d = _p3d.add(_com);
1611             _com = 0;
1612         }
1613 
1614         // distribute gen portion to key holders
1615         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1616 
1617         // send share for p3d to divies
1618         if (_p3d > 0)
1619             Divies.transfer(_p3d);
1620 
1621         // prepare event data
1622         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1623         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1624         _eventData_.winnerAddr = plyr_[_winPID].addr;
1625         _eventData_.winnerName = plyr_[_winPID].name;
1626         _eventData_.amountWon = _win;
1627         _eventData_.genAmount = _gen;
1628         _eventData_.P3DAmount = _p3d;
1629         _eventData_.newPot = _res;
1630 
1631         // start next round
1632         rID_++;
1633         _rID++;
1634         round_[_rID].strt = now;
1635         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1636         round_[_rID].pot = _res;
1637 
1638         return (_eventData_);
1639     }
1640 
1641     /**
1642      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1643      */
1644     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1645     private
1646     {
1647         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1648         if (_earnings > 0)
1649         {
1650             // put in gen vault
1651             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1652             // zero out their earnings by updating mask
1653             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1654         }
1655     }
1656 
1657     /**
1658      * @dev updates round timer based on number of whole keys bought.
1659      */
1660     function updateTimer(uint256 _keys, uint256 _rID)
1661     private
1662     {
1663         // grab time
1664         uint256 _now = now;
1665 
1666         // calculate time based on number of keys bought
1667         uint256 _newTime;
1668         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1669             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1670         else
1671             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1672 
1673         // compare to max and set new end time
1674         if (_newTime < (rndMax_).add(_now))
1675             round_[_rID].end = _newTime;
1676         else
1677             round_[_rID].end = rndMax_.add(_now);
1678     }
1679 
1680     /**
1681      * @dev generates a random number between 0-99 and checks to see if thats
1682      * resulted in an airdrop win
1683      * @return do we have a winner?
1684      */
1685     function airdrop()
1686     private
1687     view
1688     returns (bool)
1689     {
1690         uint256 seed = uint256(keccak256(abi.encodePacked(
1691 
1692                 (block.timestamp).add
1693                 (block.difficulty).add
1694                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1695                 (block.gaslimit).add
1696                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1697                 (block.number)
1698 
1699             )));
1700         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1701             return (true);
1702         else
1703             return (false);
1704     }
1705 
1706     /**
1707      * @dev distributes eth based on fees to com, aff, and p3d
1708      */
1709     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1710     private
1711     returns (F3Ddatasets.EventReturns)
1712     {
1713         // pay 2% out to community rewards
1714         uint256 _com = _eth / 50;
1715         uint256 _p3d;
1716         if (!address(Jekyll_Island_Inc).send(_com))
1717         {
1718             // This ensures Team Just cannot influence the outcome of FoMo3D with
1719             // bank migrations by breaking outgoing transactions.
1720             // Something we would never do. But that's not the point.
1721             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1722             // highest belief that everything we create should be trustless.
1723             // Team JUST, The name you shouldn't have to trust.
1724             _p3d = _com;
1725             _com = 0;
1726         }
1727 
1728         // pay 1% out to FoMo3D short
1729         uint256 _long = _eth / 100;
1730         otherF3D_.transfer(_long);
1731 
1732         // distribute share to affiliate
1733         uint256 _aff = _eth / 10;
1734 
1735         // decide what to do with affiliate share of fees
1736         // affiliate must not be self, and must have a name registered
1737         if (_affID != _pID && plyr_[_affID].name != '') {
1738             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1739             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1740         } else {
1741             _p3d = _aff;
1742         }
1743 
1744         // pay out p3d
1745         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1746         if (_p3d > 0)
1747         {
1748             // deposit to divies contract
1749             Divies.transfer(_p3d);
1750 
1751             // set up event data
1752             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1753         }
1754 
1755         return (_eventData_);
1756     }
1757 
1758     function potSwap()
1759     external
1760     payable
1761     {
1762         // setup local rID
1763         uint256 _rID = rID_ + 1;
1764 
1765         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1766         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1767     }
1768 
1769     /**
1770      * @dev distributes eth based on fees to gen and pot
1771      */
1772     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1773     private
1774     returns (F3Ddatasets.EventReturns)
1775     {
1776         // calculate gen share
1777         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1778 
1779         // toss 1% into airdrop pot 
1780         uint256 _air = (_eth / 100);
1781         airDropPot_ = airDropPot_.add(_air);
1782 
1783         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1784         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1785 
1786         // calculate pot 
1787         uint256 _pot = _eth.sub(_gen);
1788 
1789         // distribute gen share (thats what updateMasks() does) and adjust
1790         // balances for dust.
1791         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1792         if (_dust > 0)
1793             _gen = _gen.sub(_dust);
1794 
1795         // add eth to pot
1796         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1797 
1798         // set up event data
1799         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1800         _eventData_.potAmount = _pot;
1801 
1802         return (_eventData_);
1803     }
1804 
1805     /**
1806      * @dev updates masks for round and player when keys are bought
1807      * @return dust left over 
1808      */
1809     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1810     private
1811     returns (uint256)
1812     {
1813         /* MASKING NOTES
1814             earnings masks are a tricky thing for people to wrap their minds around.
1815             the basic thing to understand here.  is were going to have a global
1816             tracker based on profit per share for each round, that increases in
1817             relevant proportion to the increase in share supply.
1818             
1819             the player will have an additional mask that basically says "based
1820             on the rounds mask, my shares, and how much i've already withdrawn,
1821             how much is still owed to me?"
1822         */
1823 
1824         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1825         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1826         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1827 
1828         // calculate player earning from their own buy (only based on the keys
1829         // they just bought).  & update player earnings mask
1830         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1831         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1832 
1833         // calculate & return dust
1834         return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1835     }
1836 
1837     /**
1838      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1839      * @return earnings in wei format
1840      */
1841     function withdrawEarnings(uint256 _pID)
1842     private
1843     returns (uint256)
1844     {
1845         // update gen vault
1846         updateGenVault(_pID, plyr_[_pID].lrnd);
1847 
1848         // from vaults 
1849         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1850         if (_earnings > 0)
1851         {
1852             plyr_[_pID].win = 0;
1853             plyr_[_pID].gen = 0;
1854             plyr_[_pID].aff = 0;
1855         }
1856 
1857         return (_earnings);
1858     }
1859 
1860     /**
1861      * @dev prepares compression data and fires event for buy or reload tx's
1862      */
1863     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1864     private
1865     {
1866         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1867         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1868 
1869         emit F3Devents.onEndTx
1870         (
1871             _eventData_.compressedData,
1872             _eventData_.compressedIDs,
1873             plyr_[_pID].name,
1874             msg.sender,
1875             _eth,
1876             _keys,
1877             _eventData_.winnerAddr,
1878             _eventData_.winnerName,
1879             _eventData_.amountWon,
1880             _eventData_.newPot,
1881             _eventData_.P3DAmount,
1882             _eventData_.genAmount,
1883             _eventData_.potAmount,
1884             airDropPot_
1885         );
1886     }
1887     //==============================================================================
1888     //    (~ _  _    _._|_    .
1889     //    _)(/_(_|_|| | | \/  .
1890     //====================/=========================================================
1891     /** upon contract deploy, it will be deactivated.  this is a one time
1892      * use function that will activate the contract.  we do this so devs 
1893      * have time to set things up on the web end                            **/
1894     bool public activated_ = false;
1895 
1896     function activate()
1897     public
1898     {
1899 
1900         // can only be ran once
1901         require(msg.sender == owner, 'only dev!');
1902         require(activated_ == false, "fomo3d already activated");
1903 
1904         // activate the contract 
1905         activated_ = true;
1906 
1907         otherF3D_ = msg.sender;
1908         Divies = msg.sender;
1909         Jekyll_Island_Inc = msg.sender;
1910 
1911         // lets start first round
1912         rID_ = 1;
1913         round_[1].strt = now + rndExtra_ - rndGap_;
1914         round_[1].end = now + rndInit_ + rndExtra_;
1915     }
1916 
1917 
1918 }