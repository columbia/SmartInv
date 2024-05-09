1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interface/DiviesInterface.sol
4 
5 interface DiviesInterface {
6     function deposit() external payable;
7 }
8 
9 // File: contracts/interface/otherFoMo3D.sol
10 
11 interface otherFoMo3D {
12     function potSwap() external payable;
13 }
14 
15 // File: contracts/interface/PlayerBookInterface.sol
16 
17 interface PlayerBookInterface {
18     function getPlayerID(address _addr) external returns (uint256);
19     function getPlayerName(uint256 _pID) external view returns (bytes32);
20     function getPlayerLAff(uint256 _pID) external view returns (uint256);
21     function getPlayerAddr(uint256 _pID) external view returns (address);
22     function getPlayerLevel(uint256 _pID) external view returns (uint8);
23     function getNameFee() external view returns (uint256);
24     function deposit() external payable returns (bool);
25     function updateRankBoard( uint256 _pID, uint256 _cost ) external;
26     function resolveRankBoard() external;
27     function setPlayerAffID(uint256 _pID,uint256 _laff) external;
28     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all, uint8 _level) external payable returns(bool, uint256);
29     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all, uint8 _level) external payable returns(bool, uint256);
30     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all, uint8 _level) external payable returns(bool, uint256);
31 }
32 
33 // File: contracts/interface/HourglassInterface.sol
34 
35 interface HourglassInterface {
36     function() payable external;
37     function buy(address _playerAddress) payable external returns(uint256);
38     function sell(uint256 _amountOfTokens) external;
39     function reinvest() external;
40     function withdraw() external;
41     function exit() external;
42     function dividendsOf(address _playerAddress) external view returns(uint256);
43     function balanceOf(address _playerAddress) external view returns(uint256);
44     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
45     function stakingRequirement() external view returns(uint256);
46 }
47 
48 // File: contracts/library/SafeMath.sol
49 
50 /**
51  * @title SafeMath v0.1.9
52  * @dev Math operations with safety checks that throw on error
53  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
54  * - added sqrt
55  * - added sq
56  * - added pwr 
57  * - changed asserts to requires with error log outputs
58  * - removed div, its useless
59  */
60 library SafeMath {
61     
62     /**
63     * @dev Multiplies two numbers, throws on overflow.
64     */
65     function mul(uint256 a, uint256 b) 
66         internal 
67         pure 
68         returns (uint256 c) 
69     {
70         if (a == 0) {
71             return 0;
72         }
73         c = a * b;
74         require(c / a == b, "SafeMath mul failed");
75         return c;
76     }
77 
78     /**
79     * @dev Integer division of two numbers, truncating the quotient.
80     */
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         // assert(b > 0); // Solidity automatically throws when dividing by 0
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85         return c;
86     }
87     
88     /**
89     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90     */
91     function sub(uint256 a, uint256 b)
92         internal
93         pure
94         returns (uint256) 
95     {
96         require(b <= a, "SafeMath sub failed");
97         return a - b;
98     }
99 
100     /**
101     * @dev Adds two numbers, throws on overflow.
102     */
103     function add(uint256 a, uint256 b)
104         internal
105         pure
106         returns (uint256 c) 
107     {
108         c = a + b;
109         require(c >= a, "SafeMath add failed");
110         return c;
111     }
112     
113     /**
114      * @dev gives square root of given x.
115      */
116     function sqrt(uint256 x)
117         internal
118         pure
119         returns (uint256 y) 
120     {
121         uint256 z = ((add(x,1)) / 2);
122         y = x;
123         while (z < y) 
124         {
125             y = z;
126             z = ((add((x / z),z)) / 2);
127         }
128     }
129     
130     /**
131      * @dev gives square. multiplies x by x
132      */
133     function sq(uint256 x)
134         internal
135         pure
136         returns (uint256)
137     {
138         return (mul(x,x));
139     }
140     
141     /**
142      * @dev x to the power of y 
143      */
144     function pwr(uint256 x, uint256 y)
145         internal 
146         pure 
147         returns (uint256)
148     {
149         if (x==0)
150             return (0);
151         else if (y==0)
152             return (1);
153         else 
154         {
155             uint256 z = x;
156             for (uint256 i=1; i < y; i++)
157                 z = mul(z,x);
158             return (z);
159         }
160     }
161 }
162 
163 // File: contracts/library/UintCompressor.sol
164 
165 library UintCompressor {
166     using SafeMath for *;
167     
168     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
169         internal
170         pure
171         returns(uint256)
172     {
173         // check conditions 
174         require(_end < 77 && _start < 77, "start/end must be less than 77");
175         require(_end >= _start, "end must be >= start");
176         
177         // format our start/end points
178         _end = exponent(_end).mul(10);
179         _start = exponent(_start);
180         
181         // check that the include data fits into its segment 
182         require(_include < (_end / _start));
183         
184         // build middle
185         if (_include > 0)
186             _include = _include.mul(_start);
187         
188         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
189     }
190     
191     function extract(uint256 _input, uint256 _start, uint256 _end)
192 	    internal
193 	    pure
194 	    returns(uint256)
195     {
196         // check conditions
197         require(_end < 77 && _start < 77, "start/end must be less than 77");
198         require(_end >= _start, "end must be >= start");
199         
200         // format our start/end points
201         _end = exponent(_end).mul(10);
202         _start = exponent(_start);
203         
204         // return requested section
205         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
206     }
207     
208     function exponent(uint256 _position)
209         private
210         pure
211         returns(uint256)
212     {
213         return((10).pwr(_position));
214     }
215 }
216 
217 // File: contracts/library/NameFilter.sol
218 
219 library NameFilter {
220     /**
221      * @dev filters name strings
222      * -converts uppercase to lower case.  
223      * -makes sure it does not start/end with a space
224      * -makes sure it does not contain multiple spaces in a row
225      * -cannot be only numbers
226      * -cannot start with 0x 
227      * -restricts characters to A-Z, a-z, 0-9, and space.
228      * @return reprocessed string in bytes32 format
229      */
230     function nameFilter(string _input)
231         internal
232         pure
233         returns(bytes32)
234     {
235         bytes memory _temp = bytes(_input);
236         uint256 _length = _temp.length;
237         
238         //sorry limited to 32 characters
239         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
240         // make sure it doesnt start with or end with space
241         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
242         // make sure first two characters are not 0x
243         if (_temp[0] == 0x30)
244         {
245             require(_temp[1] != 0x78, "string cannot start with 0x");
246             require(_temp[1] != 0x58, "string cannot start with 0X");
247         }
248         
249         // create a bool to track if we have a non number character
250         bool _hasNonNumber;
251         
252         // convert & check
253         for (uint256 i = 0; i < _length; i++)
254         {
255             // if its uppercase A-Z
256             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
257             {
258                 // convert to lower case a-z
259                 _temp[i] = byte(uint(_temp[i]) + 32);
260                 
261                 // we have a non number
262                 if (_hasNonNumber == false)
263                     _hasNonNumber = true;
264             } else {
265                 require
266                 (
267                     // require character is a space
268                     _temp[i] == 0x20 || 
269                     // OR lowercase a-z
270                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
271                     // or 0-9
272                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
273                     "string contains invalid characters"
274                 );
275                 // make sure theres not 2x spaces in a row
276                 if (_temp[i] == 0x20)
277                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
278                 
279                 // see if we have a character other than a number
280                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
281                     _hasNonNumber = true;    
282             }
283         }
284         
285         require(_hasNonNumber == true, "string cannot be only numbers");
286         
287         bytes32 _ret;
288         assembly {
289             _ret := mload(add(_temp, 32))
290         }
291         return (_ret);
292     }
293 }
294 
295 // File: contracts/library/OPKKeysCalcLong.sol
296 
297 //==============================================================================
298 //  |  _      _ _ | _  .
299 //  |<(/_\/  (_(_||(_  .
300 //=======/======================================================================
301 library OPKKeysCalcLong {
302     using SafeMath for *;
303     /**
304      * @dev calculates number of keys received given X eth 
305      * @param _curEth current amount of eth in contract 
306      * @param _newEth eth being spent
307      * @return amount of ticket purchased
308      */
309     function keysRec(uint256 _curEth, uint256 _newEth)
310         internal
311         pure
312         returns (uint256)
313     {
314         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
315     }
316     
317     /**
318      * @dev calculates amount of eth received if you sold X keys 
319      * @param _curKeys current amount of keys that exist 
320      * @param _sellKeys amount of keys you wish to sell
321      * @return amount of eth received
322      */
323     function ethRec(uint256 _curKeys, uint256 _sellKeys)
324         internal
325         pure
326         returns (uint256)
327     {
328         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
329     }
330 
331     /**
332      * @dev calculates how many keys would exist with given an amount of eth
333      * @param _eth eth "in contract"
334      * @return number of keys that would exist
335      */
336     function keys(uint256 _eth) 
337         internal
338         pure
339         returns(uint256)
340     {
341         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
342     }
343     
344     /**
345      * @dev calculates how much eth would be in contract given a number of keys
346      * @param _keys number of keys "in contract" 
347      * @return eth that would exists
348      */
349     function eth(uint256 _keys) 
350         internal
351         pure
352         returns(uint256)  
353     {
354         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
355     }
356 }
357 
358 // File: contracts/library/OPKdatasets.sol
359 
360 //==============================================================================
361 //   __|_ _    __|_ _  .
362 //  _\ | | |_|(_ | _\  .
363 //==============================================================================
364 library OPKdatasets {
365     //compressedData key
366     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
367         // 0 - new player (bool)
368         // 1 - joined round (bool)
369         // 2 - new  leader (bool)
370         // 3-5 - air drop tracker (uint 0-999)
371         // 6-16 - round end time
372         // 17 - winnerTeam
373         // 18 - 28 timestamp 
374         // 29 - team
375         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
376         // 31 - airdrop happened bool
377         // 32 - airdrop tier 
378         // 33 - airdrop amount won
379     //compressedIDs key
380     // [77-52][51-26][25-0]
381         // 0-25 - pID 
382         // 26-51 - winPID
383         // 52-77 - rID
384     struct EventReturns {
385         uint256 compressedData;
386         uint256 compressedIDs;
387         address winnerAddr;         // winner address
388         bytes32 winnerName;         // winner name
389         uint256 amountWon;          // amount won
390         uint256 newPot;             // amount in new pot
391         uint256 OPKAmount;          // amount distributed to opk
392         uint256 genAmount;          // amount distributed to gen
393         uint256 potAmount;          // amount added to pot
394     }
395     struct Player {
396         address addr;       // player address
397         bytes32 name;       // player name
398         uint256 win;        // winnings vault
399         uint256 gen;        // general vault
400         uint256 aff;        // affiliate vault
401         uint256 lrnd;       // last round played
402         uint256 laff;       // last affiliate id used
403         uint8 level;
404     }
405     struct PlayerRounds {
406         uint256 eth;    // eth player has added to round (used for eth limiter)
407         uint256 keys;   // keys
408         uint256 mask;   // player mask 
409         uint256 ico;    // ICO phase investment
410     }
411     struct Round {
412         uint256 plyr;   // pID of player in lead， lead领导吗？
413         uint256 team;   // tID of team in lead
414         uint256 end;    // time ends/ended
415         bool ended;     // has round end function been ran  这个开关值得研究下
416         uint256 strt;   // time round started
417         uint256 keys;   // keys
418         uint256 eth;    // total eth in
419         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
420         uint256 mask;   // global mask
421         uint256 ico;    // total eth sent in during ICO phase
422         uint256 icoGen; // total eth for gen during ICO phase
423         uint256 icoAvg; // average key price for ICO phase
424     }
425     struct TeamFee {
426         uint256 gen;    // % of buy in thats paid to key holders of current round
427         uint256 opk;    // % of buy in thats paid to opk holders
428     }
429     struct PotSplit {
430         uint256 gen;    // % of pot thats paid to key holders of current round
431         uint256 opk;    // % of pot thats paid to opk holders
432     }
433 }
434 
435 // File: contracts/OPKevents.sol
436 
437 contract OPKevents {
438     // fired whenever a player registers a name
439     event onNewName
440     (
441         uint256 indexed playerID,
442         address indexed playerAddress,
443         bytes32 indexed playerName,
444         bool isNewPlayer,
445         uint256 affiliateID,
446         address affiliateAddress,
447         bytes32 affiliateName,
448         uint256 amountPaid,
449         uint256 timeStamp
450     );
451     
452     // fired at end of buy or reload
453     event onEndTx
454     (
455         uint256 compressedData,     
456         uint256 compressedIDs,      
457         bytes32 playerName,
458         address playerAddress,
459         uint256 ethIn,
460         uint256 keysBought,
461         address winnerAddr,
462         bytes32 winnerName,
463         uint256 amountWon,
464         uint256 newPot,
465         uint256 OPKAmount,
466         uint256 genAmount,
467         uint256 potAmount,
468         uint256 airDropPot
469     );
470     
471 	// fired whenever theres a withdraw
472     event onWithdraw
473     (
474         uint256 indexed playerID,
475         address playerAddress,
476         bytes32 playerName,
477         uint256 ethOut,
478         uint256 timeStamp
479     );
480     
481     // fired whenever a withdraw forces end round to be ran
482     event onWithdrawAndDistribute
483     (
484         address playerAddress,
485         bytes32 playerName,
486         uint256 ethOut,
487         uint256 compressedData,
488         uint256 compressedIDs,
489         address winnerAddr,
490         bytes32 winnerName,
491         uint256 amountWon,
492         uint256 newPot,
493         uint256 OPKAmount,
494         uint256 genAmount
495     );
496     
497     // (fomo3d long only) fired whenever a player tries a buy after round timer 
498     // hit zero, and causes end round to be ran.
499     event onBuyAndDistribute
500     (
501         address playerAddress,
502         bytes32 playerName,
503         uint256 ethIn,
504         uint256 compressedData,
505         uint256 compressedIDs,
506         address winnerAddr,
507         bytes32 winnerName,
508         uint256 amountWon,
509         uint256 newPot,
510         uint256 OPKAmount,
511         uint256 genAmount
512     );
513     
514     // (fomo3d long only) fired whenever a player tries a reload after round timer 
515     // hit zero, and causes end round to be ran.
516     event onReLoadAndDistribute
517     (
518         address playerAddress,
519         bytes32 playerName,
520         uint256 compressedData,
521         uint256 compressedIDs,
522         address winnerAddr,
523         bytes32 winnerName,
524         uint256 amountWon,
525         uint256 newPot,
526         uint256 OPKAmount,
527         uint256 genAmount
528     );
529     
530     // fired whenever an affiliate is paid
531     event onAffiliatePayout
532     (
533         uint256 indexed affiliateID,
534         address affiliateAddress,
535         bytes32 affiliateName,
536         uint256 indexed roundID,
537         uint256 indexed buyerID,
538         uint256 amount,
539         uint8 level,
540         uint256 timeStamp
541     );
542 
543     event onAffiliateDistribute
544     (
545         uint256 from,
546         address from_addr,
547         uint256 to,
548         address to_addr,
549         uint8 level,
550         uint256 fee,
551         uint256 timeStamp
552     );
553 
554     event onAffiliateDistributeLeft
555     (
556         uint256 pID,
557         uint256 leftfee
558     );
559     
560     // received pot swap deposit
561     event onPotSwapDeposit
562     (
563         uint256 roundID,
564         uint256 amountAddedToPot
565     );
566 
567     // distributeRegisterFee
568     event onDistributeRegisterFee
569     (
570         uint256 affiliateID,
571         bytes32 name,
572         uint8 level,
573         uint256 fee,
574         uint256 communityFee,
575         uint256 opkFee,
576         uint256 refererFee,
577         uint256 referPotFee
578     );
579 }
580 
581 // File: contracts/OkamiPKLong.sol
582 
583 /**
584  ▄▄▄▄▄▄▄▄▄▄▄  ▄    ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄       ▄▄▄▄▄▄▄▄▄▄▄  ▄    ▄
585 ▐░░░░░░░░░░░▌▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░▌  ▐░▌
586 ▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▐░▌ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌ ▀▀▀▀█░█▀▀▀▀      ▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▐░▌
587 ▐░▌       ▐░▌▐░▌▐░▌  ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌     ▐░▌          ▐░▌       ▐░▌▐░▌▐░▌
588 ▐░▌       ▐░▌▐░▌░▌   ▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▐░▌ ▐░▌     ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌░▌
589 ▐░▌       ▐░▌▐░░▌    ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌     ▐░▌          ▐░░░░░░░░░░░▌▐░░▌
590 ▐░▌       ▐░▌▐░▌░▌   ▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▀   ▐░▌     ▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌
591 ▐░▌       ▐░▌▐░▌▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌          ▐░▌          ▐░▌▐░▌
592 ▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▌ ▐░▌       ▐░▌▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌          ▐░▌ ▐░▌
593 ▐░░░░░░░░░░░▌▐░▌  ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌          ▐░▌  ▐░▌
594  ▀▀▀▀▀▀▀▀▀▀▀  ▀    ▀  ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀            ▀    ▀
595 
596  *   │    ┌────────────┐
597  *   └────┤long version
598  *        └────────────┘
599  */
600 
601 //==============================================================================
602 //     _    _  _ _|_ _  .
603 //    (/_\/(/_| | | _\  .
604 //==============================================================================
605 
606 
607 
608 
609 
610 
611 
612 
613 
614 
615 
616 
617 contract OkamiPKlong is OPKevents {
618     using SafeMath for *;
619     using NameFilter for string;
620     using OPKKeysCalcLong for uint256;
621 	
622     otherFoMo3D private otherOPK_;
623 
624     DiviesInterface constant private Divies = DiviesInterface(0xD2344f06ce022a7424619b2aF222e71b65824975);
625     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xC4665811782e94d0F496C715CA38D02dC687F982);
626 
627     address private Community_Wallet1 = 0x52da4d1771d1ae96a3e9771D45f65A6cd6f265Fe;
628     address private Community_Wallet2 = 0x00E7326BB568b7209843aE8Ee4F6b3268262df7d;
629 //==============================================================================
630 //     _ _  _  |`. _     _ _ |_ | _  _  .
631 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
632 //=================_|===========================================================
633     string constant public name = "Okami PK Long Official";
634     string constant public symbol = "Okami";
635     uint256 private rndExtra_ = 15 seconds;                     // length of the very first ICO 
636     uint256 private rndGap_ = 1 hours;                          // length of ICO phase, set to 1 year for EOS.
637     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
638     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
639     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
640 //==============================================================================
641 //     _| _ _|_ _    _ _ _|_    _   .
642 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
643 //=============================|================================================
644     uint256 public rID_;    // round id number / total rounds that have happened
645 //****************
646 // PLAYER DATA 
647 //****************
648     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
649     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
650     mapping (uint256 => OPKdatasets.Player) public plyr_;   // (pID => data) player data
651     mapping (uint256 => mapping (uint256 => OPKdatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
652     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
653 //****************
654 // ROUND DATA 
655 //****************
656     mapping (uint256 => OPKdatasets.Round) public round_;   // (rID => data) round data
657     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
658 //****************
659 // TEAM FEE DATA , Team的费用分配数据
660 //****************
661     mapping (uint256 => OPKdatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
662     mapping (uint256 => OPKdatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
663 //==============================================================================
664 //     _ _  _  __|_ _    __|_ _  _  .
665 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
666 //==============================================================================
667     // XXX
668     mapping (uint8 => uint256) public levelValue_;
669     mapping (uint8 => uint8) public levelRate_;
670 
671     mapping (uint8 => uint8) public levelRate2_;
672 
673     constructor()
674         public
675     {
676         // XXX
677         levelValue_[3] = 0.01 ether;
678         levelValue_[2] = 1 ether;
679         levelValue_[1] = 5 ether;
680 
681         levelRate_[3] = 5;
682         levelRate_[2] = 3;
683         levelRate_[1] = 2;
684 
685 		// Team allocation structures
686         // 0 = Ares
687         // 1 = cupid
688         // 2 = athena
689         // 3 = poseidon
690 
691 		// Team allocation percentages
692         // (long, opk) + (Pot , Referrals, Community)
693             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
694         fees_[0] = OPKdatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 3% to com, 1% to pot swap
695         fees_[1] = OPKdatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 3% to com, 1% to pot swap
696         fees_[2] = OPKdatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 3% to com, 1% to pot swap
697         fees_[3] = OPKdatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 3% to com, 1% to pot swap
698         
699         // how to split up the final pot based on which team was picked
700         // (long, opk)
701         potSplit_[0] = OPKdatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
702         potSplit_[1] = OPKdatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
703         potSplit_[2] = OPKdatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
704         potSplit_[3] = OPKdatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
705     }
706 //==============================================================================
707 //     _ _  _  _|. |`. _  _ _  .
708 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
709 //==============================================================================
710     /**
711      * @dev used to make sure no one can interact with contract until it has 
712      * been activated. 
713      */
714     modifier isActivated() {
715         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
716         _;
717     }
718     
719     /**
720      * @dev prevents contracts from interacting with fomo3d 
721      */
722     modifier isHuman() {
723         address _addr = msg.sender;
724         require (_addr == tx.origin);
725         
726         uint256 _codeLength;
727         
728         assembly {_codeLength := extcodesize(_addr)}
729         require(_codeLength == 0, "sorry humans only");
730         _;
731     }
732 
733     modifier isValidLevel(uint8 _level) {
734         require(_level >= 0 && _level <= 3, "invalid level");
735         require(msg.value >= levelValue_[_level], "sorry request price less than affiliate level");
736         _;
737     }
738 
739     /**
740      * @dev sets boundaries for incoming tx 
741      */
742     modifier isWithinLimits(uint256 _eth) {
743         require(_eth >= 1000000000, "pocket lint: not a valid currency");
744         require(_eth <= 100000000000000000000000, "no vitalik, no");
745         _;    
746     }
747 
748     /**
749      * 
750      */
751     //devs check    
752     modifier onlyDevs(){
753         require(
754             //msg.sender == 0x00D8E8CCb4A29625D299798036825f3fa349f2b4 || //test
755             msg.sender == 0x00A32C09c8962AEc444ABde1991469eD0a9ccAf7 ||
756             msg.sender == 0x00aBBff93b10Ece374B14abb70c4e588BA1F799F,
757             "only dev"
758         );
759         _;
760     }
761     
762 //==============================================================================
763 //     _    |_ |. _   |`    _  __|_. _  _  _  .
764 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
765 //====|=========================================================================
766     /**
767      * @dev emergency buy uses last stored affiliate ID and team snek
768      */
769     function()
770         isActivated()
771         isHuman()
772         isWithinLimits(msg.value)
773         public
774         payable
775     {
776         // set up our tx event data and determine if player is new or not
777         OPKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
778             
779         // fetch player id
780         uint256 _pID = pIDxAddr_[msg.sender];
781         
782         // buy core 
783         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
784     }
785     
786     /**
787      * @dev converts all incoming ethereum to keys.
788      * -functionhash- 0x8f38f309 (using ID for affiliate)
789      * -functionhash- 0x98a0871d (using address for affiliate)
790      * -functionhash- 0xa65b37a1 (using name for affiliate)
791      * @param _affCode the ID/address/name of the player who gets the affiliate fee
792      * @param _team what team is the player playing for?
793      */
794     
795     function buyXname(bytes32 _affCode, uint256 _team)
796         isActivated()
797         isHuman()
798         isWithinLimits(msg.value)
799         public
800         payable
801     {
802         // set up our tx event data and determine if player is new or not
803         OPKdatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
804         
805         // fetch player id
806         uint256 _pID = pIDxAddr_[msg.sender];
807         
808         // manage affiliate residuals
809         uint256 _affID;
810         // if no affiliate code was given or player tried to use their own, lolz
811         if (_affCode == '' || _affCode == plyr_[_pID].name)
812         {
813             // use last stored affiliate code
814             _affID = plyr_[_pID].laff;
815         
816         // if affiliate code was given
817         } else {
818             // get affiliate ID from aff Code
819             _affID = pIDxName_[_affCode];
820 
821             // if affID is existed , use original aff_id
822             // XXX
823             if (plyr_[_pID].laff == 0)
824             {
825                 // update last affiliate
826                 plyr_[_pID].laff = _affID;
827                 PlayerBook.setPlayerAffID(_pID, _affID);
828             }else {
829                 _affID = plyr_[_pID].laff;
830             }
831         }
832         
833         // verify a valid team was selected
834         _team = verifyTeam(_team);
835         
836         // buy core 
837         buyCore(_pID, _affID, _team, _eventData_);
838     }
839     
840     /**
841      * @dev essentially the same as buy, but instead of you sending ether 
842      * from your wallet, it uses your unwithdrawn earnings.
843      * -functionhash- 0x349cdcac (using ID for affiliate)
844      * -functionhash- 0x82bfc739 (using address for affiliate)
845      * -functionhash- 0x079ce327 (using name for affiliate)
846      * @param _affCode the ID/address/name of the player who gets the affiliate fee
847      * @param _team what team is the player playing for?
848      * @param _eth amount of earnings to use (remainder returned to gen vault)
849      */
850     
851     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
852         isActivated()
853         isHuman()
854         isWithinLimits(_eth)
855         public
856     {
857         // set up our tx event data
858         OPKdatasets.EventReturns memory _eventData_;
859         
860         // fetch player ID
861         uint256 _pID = pIDxAddr_[msg.sender];
862         
863         // manage affiliate residuals
864         uint256 _affID;
865         // if no affiliate code was given or player tried to use their own, lolz
866         if (_affCode == '' || _affCode == plyr_[_pID].name)
867         {
868             // use last stored affiliate code
869             _affID = plyr_[_pID].laff;
870         
871         // if affiliate code was given
872         } else {
873             // get affiliate ID from aff Code
874             _affID = pIDxName_[_affCode];
875             // XXX
876             if (plyr_[_pID].laff == 0)
877             {
878                 // update last affiliate
879                 plyr_[_pID].laff = _affID;
880             }else {
881                 _affID = plyr_[_pID].laff;
882             }
883         }
884         
885         // verify a valid team was selected
886         _team = verifyTeam(_team);
887         
888         // reload core
889         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
890     }
891 
892     /**
893      * @dev withdraws all of your earnings.
894      * -functionhash- 0x3ccfd60b
895      */
896     function withdraw()
897         isActivated()
898         isHuman()
899         public
900     {
901         // setup local rID 
902         uint256 _rID = rID_;
903         
904         // grab time
905         uint256 _now = now;
906         
907         // fetch player ID
908         uint256 _pID = pIDxAddr_[msg.sender];
909         
910         // setup temp var for player eth
911         uint256 _eth;
912         
913         // check to see if round has ended and no one has run round end yet
914         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
915         {
916             // set up our tx event data
917             OPKdatasets.EventReturns memory _eventData_;
918             
919             // end the round (distributes pot)
920 			round_[_rID].ended = true;
921             _eventData_ = endRound(_eventData_);
922             
923 			// get their earnings
924             _eth = withdrawEarnings(_pID);
925             
926             // gib moni
927             if (_eth > 0)
928                 plyr_[_pID].addr.transfer(_eth);    
929             
930             // build event data
931             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
932             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
933             
934             // fire withdraw and distribute event
935             emit OPKevents.onWithdrawAndDistribute
936             (
937                 msg.sender, 
938                 plyr_[_pID].name, 
939                 _eth, 
940                 _eventData_.compressedData, 
941                 _eventData_.compressedIDs, 
942                 _eventData_.winnerAddr, 
943                 _eventData_.winnerName, 
944                 _eventData_.amountWon, 
945                 _eventData_.newPot, 
946                 _eventData_.OPKAmount, 
947                 _eventData_.genAmount
948             );
949             
950         // in any other situation
951         } else {
952             // get their earnings
953             _eth = withdrawEarnings(_pID);
954             
955             // gib moni
956             if (_eth > 0)
957                 plyr_[_pID].addr.transfer(_eth);
958             
959             // fire withdraw event
960             emit OPKevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
961         }
962     }
963 
964     function distributeRegisterFee(uint256 _fee, uint256 _affID, bytes32 _name, uint8 _level)
965     private
966     {
967         // 30% of fee default to com
968         uint256 _com = _fee * 3 / 10;
969         // 30% of fee default to opk pot
970         uint256 _opk = _fee * 3 / 10;
971 
972         // if got aff then 30% to aff,else 30% to opk pot
973         uint256 _ref;
974         if (_affID > 0) {
975             _ref = _fee * 3 / 10;
976             plyr_[_affID].aff = _ref.add(plyr_[_affID].aff);
977         }else {
978             _opk += _fee * 3 / 10;
979         }
980 
981         // transfer opk pot
982         Divies.deposit.value(_opk)();
983 
984         // rest of fee goes to ref pot
985         uint256 _refPot = _fee - _com - _opk - _ref;
986         PlayerBook.deposit.value(_refPot)();
987 
988         emit OPKevents.onDistributeRegisterFee(_affID,_name,_level,_fee,_com, _opk,_ref,_refPot);
989         return;
990     }
991     
992     /**
993      * @dev use these to register names.  they are just wrappers that will send the
994      * registration requests to the PlayerBook contract.  So registering here is the 
995      * same as registering there.  UI will always display the last name you registered.
996      * but you will still own all previously registered names to use as affiliate 
997      * links.
998      * - must pay a registration fee.
999      * - name must be unique
1000      * - names will be converted to lowercase
1001      * - name cannot start or end with a space 
1002      * - cannot have more than 1 space in a row
1003      * - cannot be only numbers
1004      * - cannot start with 0x 
1005      * - name must be at least 1 char
1006      * - max length of 32 characters long
1007      * - allowed characters: a-z, 0-9, and space
1008      * -functionhash- 0x921dec21 (using ID for affiliate)
1009      * -functionhash- 0x3ddd4698 (using address for affiliate)
1010      * -functionhash- 0x685ffd83 (using name for affiliate)
1011      * @param _nameString players desired name
1012      * @param _affCode affiliate ID, address, or name of who referred you
1013      * @param _all set to true if you want this to push your info to all games 
1014      * (this might cost a lot of gas)
1015      */
1016     
1017     function registerNameXname(string _nameString, bytes32 _affCode, bool _all, uint8 _level)
1018         isHuman()
1019         isValidLevel(_level)
1020         public
1021         payable
1022     {
1023         bytes32 _name = _nameString.nameFilter();
1024         // XXX
1025         uint _fee = msg.value;
1026         uint _com = msg.value * 3 / 10;
1027         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(_com)(msg.sender, _name, _affCode, _all, _level);
1028         distributeRegisterFee(_fee,_affID,_name,_level);
1029         // fire event
1030         reloadPlayerInfo(msg.sender);
1031         emit OPKevents.onNewName(pIDxAddr_[msg.sender], msg.sender, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _com, now);
1032     }
1033 //==============================================================================
1034 //     _  _ _|__|_ _  _ _  .
1035 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1036 //=====_|=======================================================================
1037     /**
1038      * @dev return the price buyer will pay for next 1 individual key.
1039      * -functionhash- 0x018a25e8
1040      * @return price for next key bought (in wei format)
1041      */
1042     function getBuyPrice()
1043         public 
1044         view 
1045         returns(uint256)
1046     {  
1047         // setup local rID
1048         uint256 _rID = rID_;
1049         
1050         // grab time
1051         uint256 _now = now;
1052         
1053         // are we in a round?
1054         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1055             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1056         else // rounds over.  need price for new round
1057             return ( 75000000000000 ); // init
1058     }
1059     
1060     /**
1061      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
1062      * provider
1063      * -functionhash- 0xc7e284b8
1064      * @return time left in seconds
1065      */
1066     function getTimeLeft()
1067         public
1068         view
1069         returns(uint256)
1070     {
1071         // setup local rID
1072         uint256 _rID = rID_;
1073         
1074         // grab time
1075         uint256 _now = now;
1076         
1077         if (_now < round_[_rID].end)
1078             if (_now > round_[_rID].strt + rndGap_)
1079                 return( (round_[_rID].end).sub(_now) );
1080             else
1081                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1082         else
1083             return(0);
1084     }
1085     
1086     /**
1087      * @dev returns player earnings per vaults 
1088      * -functionhash- 0x63066434
1089      * @return winnings vault
1090      * @return general vault
1091      * @return affiliate vault
1092      */
1093     function getPlayerVaults(uint256 _pID)
1094         public
1095         view
1096         returns(uint256 ,uint256, uint256)
1097     {
1098         // setup local rID
1099         uint256 _rID = rID_;
1100         
1101         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1102         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1103         {
1104             // if player is winner 
1105             if (round_[_rID].plyr == _pID)
1106             {
1107                 return
1108                 (
1109                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1110                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1111                     plyr_[_pID].aff
1112                 );
1113             // if player is not the winner
1114             } else {
1115                 return
1116                 (
1117                     plyr_[_pID].win,
1118                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1119                     plyr_[_pID].aff
1120                 );
1121             }
1122             
1123         // if round is still going on, or round has ended and round end has been ran
1124         } else {
1125             return
1126             (
1127                 plyr_[_pID].win,
1128                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1129                 plyr_[_pID].aff
1130             );
1131         }
1132     }
1133     
1134     /**
1135      * solidity hates stack limits.  this lets us avoid that hate 
1136      */
1137     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1138         private
1139         view
1140         returns(uint256)
1141     {
1142         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1143     }
1144     
1145     function isRoundActive(uint256 _rID)
1146         public
1147         view
1148         returns(bool)
1149     {
1150         if( activated_ == false )
1151         {
1152             return false;
1153         }
1154         return (now > round_[_rID].strt + rndGap_ && (now <= round_[_rID].end || (now > round_[_rID].end && round_[_rID].plyr == 0))) ;
1155     
1156     }
1157 
1158 
1159     /**
1160      * @dev returns all current round info needed for front end
1161      * -functionhash- 0x747dff42
1162      * @return eth invested during ICO phase
1163      * @return round id 
1164      * @return total keys for round 
1165      * @return time round ends
1166      * @return time round started
1167      * @return current pot 
1168      * @return current team ID & player ID in lead 
1169      * @return current player in leads address 
1170      * @return current player in leads name
1171      * @return Ares eth in for round
1172      * @return cupid eth in for round
1173      * @return athena eth in for round
1174      * @return poseidon eth in for round
1175      * @return 0
1176      */
1177     function getCurrentRoundInfo()
1178         public
1179         view
1180         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1181     {
1182         // setup local rID
1183         uint256 _rID = rID_;
1184         
1185         return
1186         (
1187             round_[_rID].ico,               //0
1188             _rID,                           //1
1189             round_[_rID].keys,              //2
1190             round_[_rID].end,               //3
1191             round_[_rID].strt,              //4
1192             round_[_rID].pot,               //5
1193             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1194             plyr_[round_[_rID].plyr].addr,  //7
1195             plyr_[round_[_rID].plyr].name,  //8
1196             rndTmEth_[_rID][0],             //9
1197             rndTmEth_[_rID][1],             //10
1198             rndTmEth_[_rID][2],             //11
1199             rndTmEth_[_rID][3],             //12
1200             0              //13
1201         );
1202     }
1203 
1204     /**
1205      * @dev returns player info based on address.  if no address is given, it will 
1206      * use msg.sender 
1207      * -functionhash- 0xee0b5d8b
1208      * @param _addr address of the player you want to lookup 
1209      * @return player ID 
1210      * @return player name
1211      * @return keys owned (current round)
1212      * @return winnings vault
1213      * @return general vault 
1214      * @return affiliate vault 
1215 	 * @return player round eth
1216      */
1217     function getPlayerInfoByAddress(address _addr)
1218     public
1219     view
1220     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint8, uint256)
1221     {
1222         // setup local rID
1223         uint256 _rID = rID_;
1224 
1225         if (_addr == address(0))
1226         {
1227             _addr == msg.sender;
1228         }
1229         uint256 _pID = pIDxAddr_[_addr];
1230 
1231         return
1232         (
1233         _pID,                               //0
1234         plyr_[_pID].name,                   //1
1235         plyrRnds_[_pID][_rID].keys,         //2
1236         plyr_[_pID].win,                    //3
1237         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1238         plyr_[_pID].aff,                    //5
1239         plyrRnds_[_pID][_rID].eth,          //6
1240         plyr_[_pID].level,                  //7
1241         plyr_[_pID].laff                    //8
1242         );
1243     }
1244 
1245 //==============================================================================
1246 //     _ _  _ _   | _  _ . _  .
1247 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1248 //=====================_|=======================================================
1249     /**
1250      * @dev logic runs whenever a buy order is executed.  determines how to handle 
1251      * incoming eth depending on if we are in an active round or not
1252      */
1253     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, OPKdatasets.EventReturns memory _eventData_)
1254         private
1255     {
1256         // setup local rID
1257         uint256 _rID = rID_;
1258         
1259         // grab time
1260         uint256 _now = now;
1261         
1262         // if round is active
1263         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1264         {
1265             // call core 
1266             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1267         
1268         // if round is not active     
1269         } else {
1270             // check to see if end round needs to be ran
1271             if (_now > round_[_rID].end && round_[_rID].ended == false) 
1272             {
1273                 // end the round (distributes pot) & start new round
1274 			    round_[_rID].ended = true;
1275                 _eventData_ = endRound(_eventData_);
1276                 
1277                 // build event data
1278                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1279                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1280                 
1281                 // fire buy and distribute event 
1282                 emit OPKevents.onBuyAndDistribute
1283                 (
1284                     msg.sender, 
1285                     plyr_[_pID].name, 
1286                     msg.value, 
1287                     _eventData_.compressedData, 
1288                     _eventData_.compressedIDs, 
1289                     _eventData_.winnerAddr, 
1290                     _eventData_.winnerName, 
1291                     _eventData_.amountWon, 
1292                     _eventData_.newPot, 
1293                     _eventData_.OPKAmount, 
1294                     _eventData_.genAmount
1295                 );
1296             }
1297             
1298             // put eth in players vault 
1299             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1300         }
1301     }
1302     
1303     /**
1304      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1305      * incoming eth depending on if we are in an active round or not 
1306      */
1307     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, OPKdatasets.EventReturns memory _eventData_)
1308         private
1309     {
1310         // setup local rID
1311         uint256 _rID = rID_;
1312         
1313         // grab time
1314         uint256 _now = now;
1315         
1316         // if round is active
1317         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1318         {
1319             // get earnings from all vaults and return unused to gen vault
1320             // because we use a custom safemath library.  this will throw if player 
1321             // tried to spend more eth than they have.
1322             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1323             
1324             // call core 
1325             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1326         
1327         // if round is not active and end round needs to be ran   
1328         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1329             // end the round (distributes pot) & start new round
1330             round_[_rID].ended = true;
1331             _eventData_ = endRound(_eventData_);
1332                 
1333             // build event data
1334             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1335             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1336                 
1337             // fire buy and distribute event 
1338             emit OPKevents.onReLoadAndDistribute
1339             (
1340                 msg.sender, 
1341                 plyr_[_pID].name, 
1342                 _eventData_.compressedData, 
1343                 _eventData_.compressedIDs, 
1344                 _eventData_.winnerAddr, 
1345                 _eventData_.winnerName, 
1346                 _eventData_.amountWon, 
1347                 _eventData_.newPot, 
1348                 _eventData_.OPKAmount, 
1349                 _eventData_.genAmount
1350             );
1351         }
1352     }
1353     
1354     /**
1355      * @dev this is the core logic for any buy/reload that happens while a round 
1356      * is live.
1357      */
1358     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, OPKdatasets.EventReturns memory _eventData_)
1359         private
1360     {
1361         // if player is new to round
1362         if (plyrRnds_[_pID][_rID].keys == 0)
1363             _eventData_ = managePlayer(_pID, _eventData_);
1364         
1365         // early round eth limiter 
1366         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1367         {
1368             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1369             uint256 _refund = _eth.sub(_availableLimit);
1370             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1371             _eth = _availableLimit;
1372         }
1373         
1374         // if eth left is greater than min eth allowed (sorry no pocket lint)
1375         if (_eth > 1000000000) 
1376         {
1377             
1378             // mint the new keys
1379             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1380             
1381             // if they bought at least 1 whole key
1382             if (_keys >= 1000000000000000000)
1383             {
1384             updateTimer(_keys, _rID);
1385 
1386             // set new leaders
1387             if (round_[_rID].plyr != _pID)
1388                 round_[_rID].plyr = _pID;  
1389             if (round_[_rID].team != _team)
1390                 round_[_rID].team = _team; 
1391             
1392             // set the new leader bool to true
1393             _eventData_.compressedData = _eventData_.compressedData + 100;
1394         }
1395             
1396             // update player 
1397             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1398             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1399             
1400             // update round
1401             round_[_rID].keys = _keys.add(round_[_rID].keys);
1402             round_[_rID].eth = _eth.add(round_[_rID].eth);
1403             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1404     
1405             // distribute eth
1406             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1407             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1408             
1409             // for rank board 
1410             if(_pID != _affID){
1411                 PlayerBook.updateRankBoard(_pID,_eth);
1412             }
1413             PlayerBook.resolveRankBoard();
1414             
1415             // call end tx function to fire end tx event.
1416 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1417         }
1418     }
1419 //==============================================================================
1420 //     _ _ | _   | _ _|_ _  _ _  .
1421 //    (_(_||(_|_||(_| | (_)| _\  .
1422 //==============================================================================
1423     /**
1424      * @dev calculates unmasked earnings (just calculates, does not update mask)
1425      * @return earnings in wei format
1426      */
1427     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1428         private
1429         view
1430         returns(uint256)
1431     {
1432         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1433     }
1434     
1435     /** 
1436      * @dev returns the amount of keys you would get given an amount of eth. 
1437      * -functionhash- 0xce89c80c
1438      * @param _rID round ID you want price for
1439      * @param _eth amount of eth sent in 
1440      * @return keys received 
1441      */
1442     function calcKeysReceived(uint256 _rID, uint256 _eth)
1443         public
1444         view
1445         returns(uint256)
1446     {
1447         // grab time
1448         uint256 _now = now;
1449         
1450         // are we in a round?
1451         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1452             return ( (round_[_rID].eth).keysRec(_eth) );
1453         else // rounds over.  need keys for new round
1454             return ( (_eth).keys() );
1455     }
1456     
1457     /** 
1458      * @dev returns current eth price for X keys.  
1459      * -functionhash- 0xcf808000
1460      * @param _keys number of keys desired (in 18 decimal format)
1461      * @return amount of eth needed to send
1462      */
1463     function iWantXKeys(uint256 _keys)
1464         public
1465         view
1466         returns(uint256)
1467     {
1468         // setup local rID
1469         uint256 _rID = rID_;
1470         
1471         // grab time
1472         uint256 _now = now;
1473         
1474         // are we in a round?
1475         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1476             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1477         else // rounds over.  need price for new round
1478             return ( (_keys).eth() );
1479     }
1480 //==============================================================================
1481 //    _|_ _  _ | _  .
1482 //     | (_)(_)|_\  .
1483 //==============================================================================
1484     /**
1485 	 * @dev receives name/player info from names contract 
1486      */
1487     // XXX
1488     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff, uint8 _level)
1489         external
1490     {
1491         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1492         if (pIDxAddr_[_addr] != _pID)
1493             pIDxAddr_[_addr] = _pID;
1494         if (pIDxName_[_name] != _pID)
1495             pIDxName_[_name] = _pID;
1496         if (plyr_[_pID].addr != _addr)
1497             plyr_[_pID].addr = _addr;
1498         if (plyr_[_pID].name != _name)
1499             plyr_[_pID].name = _name;
1500         if (plyr_[_pID].laff != _laff)
1501             plyr_[_pID].laff = _laff;
1502         if (plyrNames_[_pID][_name] == false)
1503             plyrNames_[_pID][_name] = true;
1504         if (plyr_[_pID].level != _level){
1505             if (_level >= 0 && _level <= 3)
1506                 plyr_[_pID].level = _level;
1507         }
1508     }
1509 
1510     function getBytesName(string _fromName)
1511     public
1512     pure
1513     returns(bytes32)
1514     {
1515         return _fromName.nameFilter();
1516     }
1517 
1518     function validateName(string _fromName)
1519     public
1520     view
1521     returns(uint256)
1522     {
1523         bytes32 _bname = _fromName.nameFilter();
1524         return pIDxName_[_bname];
1525     }
1526     
1527     /**
1528      * @dev receives entire player name list 
1529      */
1530     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1531         external
1532     {
1533         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1534         if(plyrNames_[_pID][_name] == false)
1535             plyrNames_[_pID][_name] = true;
1536     }   
1537         
1538     /**
1539      * @dev gets existing or registers new pID.  use this when a player may be new
1540      * @return pID 
1541      */
1542     // XXX
1543 
1544     function reloadPlayerInfo(address addr)
1545     private
1546     {
1547         // grab their player ID, name and last aff ID, from player names contract
1548         uint256 _pID = PlayerBook.getPlayerID(addr);
1549         bytes32 _name = PlayerBook.getPlayerName(_pID);
1550         uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1551         uint8 _level = PlayerBook.getPlayerLevel(_pID);
1552         // set up player account
1553         pIDxAddr_[msg.sender] = _pID;
1554         plyr_[_pID].addr = msg.sender;
1555 
1556         if (_name != "")
1557         {
1558             pIDxName_[_name] = _pID;
1559             plyr_[_pID].name = _name;
1560             plyrNames_[_pID][_name] = true;
1561         }
1562 
1563         if (_laff != 0 && _laff != _pID)
1564             plyr_[_pID].laff = _laff;
1565 
1566         plyr_[_pID].level = _level;
1567     }
1568 
1569     function determinePID(OPKdatasets.EventReturns memory _eventData_)
1570         private
1571         returns (OPKdatasets.EventReturns)
1572     {
1573         uint256 _pID = pIDxAddr_[msg.sender];
1574         // if player is new to this version of fomo3d
1575         if (_pID == 0)
1576         {
1577             reloadPlayerInfo(msg.sender);
1578             _eventData_.compressedData = _eventData_.compressedData + 1;
1579         } 
1580         return (_eventData_);
1581     }
1582     
1583     /**
1584      * @dev checks to make sure user picked a valid team.  if not sets team 
1585      * to default (athena)
1586      */
1587     function verifyTeam(uint256 _team)
1588         private
1589         pure
1590         returns (uint256)
1591     {
1592         if (_team < 0 || _team > 3)
1593             return(2);
1594         else
1595             return(_team);
1596     }
1597     
1598     /**
1599      * @dev decides if round end needs to be run & new round started.  and if 
1600      * player unmasked earnings from previously played rounds need to be moved.
1601      */
1602     function managePlayer(uint256 _pID, OPKdatasets.EventReturns memory _eventData_)
1603         private
1604         returns (OPKdatasets.EventReturns)
1605     {
1606         // if player has played a previous round, move their unmasked earnings
1607         // from that round to gen vault.
1608         if (plyr_[_pID].lrnd != 0)
1609             updateGenVault(_pID, plyr_[_pID].lrnd);
1610             
1611         // update player's last round played
1612         plyr_[_pID].lrnd = rID_;
1613             
1614         // set the joined round bool to true
1615         _eventData_.compressedData = _eventData_.compressedData + 10;
1616         
1617         return(_eventData_);
1618     }
1619 
1620     function toCom(uint256 _com) private 
1621     {
1622         Community_Wallet1.transfer(_com / 2);
1623         Community_Wallet2.transfer(_com / 2);
1624     }
1625     
1626     /**
1627      * @dev ends the round. manages paying out winner/splitting up pot
1628      */
1629     function endRound(OPKdatasets.EventReturns memory _eventData_)
1630         private
1631         returns (OPKdatasets.EventReturns)
1632     {
1633         // setup local rID
1634         uint256 _rID = rID_;
1635         
1636         // grab our winning player and team id's
1637         uint256 _winPID = round_[_rID].plyr;
1638         uint256 _winTID = round_[_rID].team;
1639         
1640         // grab our pot amount
1641         uint256 _pot = round_[_rID].pot;
1642         
1643         // calculate our winner share, community rewards, gen share, 
1644         // opk share, and amount reserved for next pot 
1645         uint256 _win = (_pot.mul(48)) / 100;
1646         uint256 _com = (_pot / 50);
1647         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1648         uint256 _opk = (_pot.mul(potSplit_[_winTID].opk)) / 100;
1649         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_opk);
1650         
1651         // calculate ppt for round mask
1652         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1653         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1654         if (_dust > 0)
1655         {
1656             _gen = _gen.sub(_dust);
1657             _res = _res.add(_dust);
1658         }
1659         
1660         // pay our winner
1661         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1662 
1663         // support community
1664         toCom(_com);
1665         
1666         // distribute gen portion to key holders
1667         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1668 
1669         // send share for opk to divies
1670         if (_opk > 0)
1671             Divies.deposit.value(_opk)();
1672             
1673         // prepare event data
1674         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1675         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1676         _eventData_.winnerAddr = plyr_[_winPID].addr;
1677         _eventData_.winnerName = plyr_[_winPID].name;
1678         _eventData_.amountWon = _win;
1679         _eventData_.genAmount = _gen;
1680         _eventData_.OPKAmount = _opk;
1681         _eventData_.newPot = _res;
1682         
1683         // start next round
1684         rID_++;
1685         _rID++;
1686         round_[_rID].strt = now;
1687         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1688         round_[_rID].pot = _res;
1689         
1690         return(_eventData_);
1691     }
1692     
1693     /**
1694      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1695      */
1696     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1697         private 
1698     {
1699         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1700         if (_earnings > 0)
1701         {
1702             // put in gen vault
1703             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1704             // zero out their earnings by updating mask
1705             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1706         }
1707     }
1708     
1709     /**
1710      * @dev updates round timer based on number of whole keys bought.
1711      */
1712     function updateTimer(uint256 _keys, uint256 _rID)
1713         private
1714     {
1715         // grab time
1716         uint256 _now = now;
1717         
1718         // calculate time based on number of keys bought
1719         uint256 _newTime;
1720         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1721             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1722         else
1723             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1724         
1725         // compare to max and set new end time
1726         if (_newTime < (rndMax_).add(_now))
1727             round_[_rID].end = _newTime;
1728         else
1729             round_[_rID].end = rndMax_.add(_now);
1730     }
1731 
1732     // XXX
1733     // 计算三级推广员 收益
1734     function calculateAffiliate(uint256 _rID, uint256 _pID, uint256 _aff) private returns(uint256) {
1735         uint8 _alreadycal = 4;
1736         uint256 _oID = _pID;
1737         uint256 _used = 0;
1738         uint256 _fid = plyr_[_pID].laff;
1739 
1740         // 最多 10次 追溯 推广员
1741         for (uint8 i = 0; i <10; i++) {
1742             // 如果当前用户不是推广员 则结束循环
1743             if (plyr_[_fid].level == 0) {
1744                 break;
1745             }
1746 
1747             // 如果当前已经处理过1级推广员 则结束
1748             if (_alreadycal <= 1) {
1749                 break;
1750             }
1751 
1752             // 如果当前推广员等级 高于已处理等级 则处理;
1753             if (plyr_[_fid].level < _alreadycal) {
1754 
1755                 // 计算当前推广员所得收益 // 可能出现 数据溢出
1756                 uint256 _ai = _aff / 10 * levelRate_[plyr_[_fid].level];
1757                 // 为了计算跳级收益
1758                 if (_used == 0) {
1759                     _ai += (_aff / 10) * levelRate_[plyr_[_fid].level+1];
1760                 }
1761 
1762                 // 如果 当前推广员是1级 则 收益 = 总10% - 已使用 避免数据溢出 并设置已使用
1763                 if (plyr_[_fid].level == 1) {
1764                     _ai = _aff.sub(_used);
1765                     _used = _aff;
1766                 } else {
1767                     // 改变 aff 已使用数量
1768                     _used += _ai;
1769                 }
1770 
1771                 // 给当前推广员的资产加上本次收益
1772                 plyr_[_fid].aff = _ai.add(plyr_[_fid].aff);
1773 
1774 
1775                 // 发送简要收益时间
1776                 emit OPKevents.onAffiliateDistribute(_pID,plyr_[_pID].addr,_fid,plyr_[_fid].addr,plyr_[_fid].level,_ai,now);
1777                 // 发送origin收益事件
1778                 emit OPKevents.onAffiliatePayout(_fid, plyr_[_fid].addr, plyr_[_fid].name, _rID, _pID, _ai, plyr_[_fid].level, now);
1779 
1780                 // 设置已经处理过的等级
1781                 _alreadycal = plyr_[_fid].level;
1782                 _pID = _fid;
1783             }
1784 
1785             // 如果当前用户 没有推广员 或者 推广员是自己 则结束循环
1786             if (plyr_[_fid].laff == 0 || plyr_[_fid].laff == _pID) {
1787                 break;
1788             }
1789             // 设置当前用户为推广员
1790 
1791             _fid = plyr_[_fid].laff;
1792         }
1793 
1794         emit OPKevents.onAffiliateDistributeLeft(_oID,(_aff - _used));
1795         if ((_aff - _used) < 0) {
1796             return 0;
1797         }
1798         return (_aff - _used);
1799     }
1800 
1801     /**
1802      * @dev distributes eth based on fees to com, aff, and opk
1803      */
1804     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, OPKdatasets.EventReturns memory _eventData_)
1805         private
1806         returns(OPKdatasets.EventReturns)
1807     {
1808         // pay 3% out to community rewards
1809         uint256 _com = _eth / 100 * 3;
1810         uint256 _opk;
1811 
1812         // support to com
1813         toCom(_com);
1814         
1815         // pay 1% out to FoMo3D short
1816         uint256 _long = _eth / 100;
1817         otherOPK_.potSwap.value(_long)();
1818         
1819         // distribute share to affiliate
1820         uint256 _aff = _eth / 10;
1821 
1822         uint256 _aff_left;
1823         // decide what to do with affiliate share of fees
1824         // affiliate must not be self, and must have a name registered
1825         if (_affID != _pID && plyr_[_affID].name != '') {
1826             // XXX
1827             _aff_left = calculateAffiliate(_rID,_pID,_aff);
1828         }else {
1829             _opk = _aff;
1830         }
1831         
1832         // pay out opk
1833         _opk = _opk.add((_eth.mul(fees_[_team].opk)) / (100));
1834         if (_opk > 0)
1835         {
1836             // deposit to divies contract
1837             Divies.deposit.value(_opk)();
1838             
1839             // set up event data
1840             _eventData_.OPKAmount = _opk.add(_eventData_.OPKAmount);
1841         }
1842 
1843         // XXX 推广员奖池
1844         if (_aff_left > 0) {
1845             PlayerBook.deposit.value(_aff_left)();
1846         }
1847         
1848         return(_eventData_);
1849     }
1850     
1851     function potSwap()
1852         external
1853         payable
1854     {
1855         // setup local rID
1856         uint256 _rID = rID_ + 1;
1857         
1858         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1859         emit OPKevents.onPotSwapDeposit(_rID, msg.value);
1860     }
1861     
1862     /**
1863      * @dev distributes eth based on fees to gen and pot
1864      */
1865     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, OPKdatasets.EventReturns memory _eventData_)
1866         private
1867         returns(OPKdatasets.EventReturns)
1868     {
1869         // calculate gen share
1870         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1871         
1872         // update eth balance (eth = eth - (com share + pot swap share + aff share + opk share))
1873         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].opk)) / 100));
1874         
1875         // calculate pot 
1876         uint256 _pot = _eth.sub(_gen);
1877         
1878         // distribute gen share (thats what updateMasks() does) and adjust
1879         // balances for dust.
1880         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1881         if (_dust > 0)
1882             _gen = _gen.sub(_dust);
1883         
1884         // add eth to pot
1885         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1886         
1887         // set up event data
1888         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1889         _eventData_.potAmount = _pot;
1890         
1891         return(_eventData_);
1892     }
1893 
1894     /**
1895      * @dev updates masks for round and player when keys are bought
1896      * @return dust left over 
1897      */
1898     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1899         private
1900         returns(uint256)
1901     {
1902         /* MASKING NOTES
1903             earnings masks are a tricky thing for people to wrap their minds around.
1904             the basic thing to understand here.  is were going to have a global
1905             tracker based on profit per share for each round, that increases in
1906             relevant proportion to the increase in share supply.
1907             
1908             the player will have an additional mask that basically says "based
1909             on the rounds mask, my shares, and how much i've already withdrawn,
1910             how much is still owed to me?"
1911         */
1912         
1913         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1914         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1915         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1916             
1917         // calculate player earning from their own buy (only based on the keys
1918         // they just bought).  & update player earnings mask
1919         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1920         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1921         
1922         // calculate & return dust
1923         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1924     }
1925     
1926     /**
1927      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1928      * @return earnings in wei format
1929      */
1930     function withdrawEarnings(uint256 _pID)
1931         private
1932         returns(uint256)
1933     {
1934         // update gen vault
1935         updateGenVault(_pID, plyr_[_pID].lrnd);
1936         
1937         // from vaults 
1938         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1939         if (_earnings > 0)
1940         {
1941             plyr_[_pID].win = 0;
1942             plyr_[_pID].gen = 0;
1943             plyr_[_pID].aff = 0;
1944         }
1945 
1946         return(_earnings);
1947     }
1948     
1949     /**
1950      * @dev prepares compression data and fires event for buy or reload tx's
1951      */
1952     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, OPKdatasets.EventReturns memory _eventData_)
1953         private
1954     {
1955         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1956         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1957         
1958         emit OPKevents.onEndTx
1959         (
1960             _eventData_.compressedData,
1961             _eventData_.compressedIDs,
1962             plyr_[_pID].name,
1963             msg.sender,
1964             _eth,
1965             _keys,
1966             _eventData_.winnerAddr,
1967             _eventData_.winnerName,
1968             _eventData_.amountWon,
1969             _eventData_.newPot,
1970             _eventData_.OPKAmount,
1971             _eventData_.genAmount,
1972             _eventData_.potAmount,
1973             0
1974         );
1975     }
1976 //==============================================================================
1977 //    (~ _  _    _._|_    .
1978 //    _)(/_(_|_|| | | \/  .
1979 //====================/=========================================================
1980     /** upon contract deploy, it will be deactivated.  this is a one time
1981      * use function that will activate the contract.  we do this so devs 
1982      * have time to set things up on the web end                            **/
1983     bool public activated_ = false;
1984     function activate()
1985         onlyDevs()
1986         public
1987     {
1988 		// make sure that its been linked.
1989         require(address(otherOPK_) != address(0), "must link to other FoMo3D first");
1990         
1991         // can only be ran once
1992         require(activated_ == false, "fomo3d already activated");
1993         
1994         // activate the contract 
1995         activated_ = true;
1996         
1997         // lets start first round
1998 		rID_ = 1;
1999         round_[1].strt = now + rndExtra_ - rndGap_;
2000         round_[1].end = now + rndInit_ + rndExtra_;
2001     }
2002     function setOtherFomo(address _otherOPK)
2003         onlyDevs()
2004         public
2005     {
2006         // make sure that it HASNT yet been linked.
2007         //require(address(otherOPK_) == address(0), "silly dev, you already did that");
2008         
2009         // set up other fomo3d (fast or long) for pot swap
2010         otherOPK_ = otherFoMo3D(_otherOPK);
2011     }
2012 }