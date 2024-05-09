1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interface/DiviesInterface.sol
4 
5 interface DiviesInterface {
6     function deposit() external payable;
7 }
8 
9 // File: contracts/interface/F3DexternalSettingsInterface.sol
10 
11 interface F3DexternalSettingsInterface {
12     function getFastGap() external returns(uint256);
13     function getLongGap() external returns(uint256);
14     function getFastExtra() external returns(uint256);
15     function getLongExtra() external returns(uint256);
16 }
17 
18 // File: contracts/interface/HourglassInterface.sol
19 
20 interface HourglassInterface {
21     function() payable external;
22     function buy(address _playerAddress) payable external returns(uint256);
23     function sell(uint256 _amountOfTokens) external;
24     function reinvest() external;
25     function withdraw() external;
26     function exit() external;
27     function dividendsOf(address _playerAddress) external view returns(uint256);
28     function balanceOf(address _playerAddress) external view returns(uint256);
29     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
30     function stakingRequirement() external view returns(uint256);
31 }
32 
33 // File: contracts/interface/JIincForwarderInterface.sol
34 
35 interface JIincForwarderInterface {
36     function deposit() external payable returns(bool);
37     function status() external view returns(address, address, bool);
38     function startMigration(address _newCorpBank) external returns(bool);
39     function cancelMigration() external returns(bool);
40     function finishMigration() external returns(bool);
41     function setup(address _firstCorpBank) external;
42 }
43 
44 // File: contracts/interface/PlayerBookInterface.sol
45 
46 interface PlayerBookInterface {
47     function getPlayerID(address _addr) external returns (uint256);
48     function getPlayerName(uint256 _pID) external view returns (bytes32);
49     function getPlayerLAff(uint256 _pID) external view returns (uint256);
50     function getPlayerAddr(uint256 _pID) external view returns (address);
51     function getNameFee() external view returns (uint256);
52     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
53     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
54     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
55 }
56 
57 // File: contracts/interface/otherFoMo3D.sol
58 
59 interface otherFoMo3D {
60     function potSwap() external payable;
61 }
62 
63 // File: contracts/library/SafeMath.sol
64 
65 /**
66  * @title SafeMath v0.1.9
67  * @dev Math operations with safety checks that throw on error
68  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
69  * - added sqrt
70  * - added sq
71  * - added pwr 
72  * - changed asserts to requires with error log outputs
73  * - removed div, its useless
74  */
75 library SafeMath {
76     
77     /**
78     * @dev Multiplies two numbers, throws on overflow.
79     */
80     function mul(uint256 a, uint256 b) 
81         internal 
82         pure 
83         returns (uint256 c) 
84     {
85         if (a == 0) {
86             return 0;
87         }
88         c = a * b;
89         require(c / a == b, "SafeMath mul failed");
90         return c;
91     }
92 
93     /**
94     * @dev Integer division of two numbers, truncating the quotient.
95     */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         // assert(b > 0); // Solidity automatically throws when dividing by 0
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100         return c;
101     }
102     
103     /**
104     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
105     */
106     function sub(uint256 a, uint256 b)
107         internal
108         pure
109         returns (uint256) 
110     {
111         require(b <= a, "SafeMath sub failed");
112         return a - b;
113     }
114 
115     /**
116     * @dev Adds two numbers, throws on overflow.
117     */
118     function add(uint256 a, uint256 b)
119         internal
120         pure
121         returns (uint256 c) 
122     {
123         c = a + b;
124         require(c >= a, "SafeMath add failed");
125         return c;
126     }
127     
128     /**
129      * @dev gives square root of given x.
130      */
131     function sqrt(uint256 x)
132         internal
133         pure
134         returns (uint256 y) 
135     {
136         uint256 z = ((add(x,1)) / 2);
137         y = x;
138         while (z < y) 
139         {
140             y = z;
141             z = ((add((x / z),z)) / 2);
142         }
143     }
144     
145     /**
146      * @dev gives square. multiplies x by x
147      */
148     function sq(uint256 x)
149         internal
150         pure
151         returns (uint256)
152     {
153         return (mul(x,x));
154     }
155     
156     /**
157      * @dev x to the power of y 
158      */
159     function pwr(uint256 x, uint256 y)
160         internal 
161         pure 
162         returns (uint256)
163     {
164         if (x==0)
165             return (0);
166         else if (y==0)
167             return (1);
168         else 
169         {
170             uint256 z = x;
171             for (uint256 i=1; i < y; i++)
172                 z = mul(z,x);
173             return (z);
174         }
175     }
176 }
177 
178 // File: contracts/library/F3DKeysCalcLong.sol
179 
180 //==============================================================================
181 //  |  _      _ _ | _  .
182 //  |<(/_\/  (_(_||(_  .
183 //=======/======================================================================
184 library F3DKeysCalcLong {
185     using SafeMath for *;
186     /**
187      * @dev calculates number of keys received given X eth 
188      * @param _curEth current amount of eth in contract 
189      * @param _newEth eth being spent
190      * @return amount of ticket purchased
191      */
192     function keysRec(uint256 _curEth, uint256 _newEth)
193         internal
194         pure
195         returns (uint256)
196     {
197         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
198     }
199     
200     /**
201      * @dev calculates amount of eth received if you sold X keys 
202      * @param _curKeys current amount of keys that exist 
203      * @param _sellKeys amount of keys you wish to sell
204      * @return amount of eth received
205      */
206     function ethRec(uint256 _curKeys, uint256 _sellKeys)
207         internal
208         pure
209         returns (uint256)
210     {
211         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
212     }
213 
214     /**
215      * @dev calculates how many keys would exist with given an amount of eth
216      * @param _eth eth "in contract"
217      * @return number of keys that would exist
218      */
219     function keys(uint256 _eth) 
220         internal
221         pure
222         returns(uint256)
223     {
224         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
225     }
226     
227     /**
228      * @dev calculates how much eth would be in contract given a number of keys
229      * @param _keys number of keys "in contract" 
230      * @return eth that would exists
231      */
232     function eth(uint256 _keys) 
233         internal
234         pure
235         returns(uint256)  
236     {
237         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
238     }
239 }
240 
241 // File: contracts/library/F3Ddatasets.sol
242 
243 //==============================================================================
244 //   __|_ _    __|_ _  .
245 //  _\ | | |_|(_ | _\  .
246 //==============================================================================
247 library F3Ddatasets {
248     //compressedData key
249     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
250         // 0 - new player (bool)
251         // 1 - joined round (bool)
252         // 2 - new  leader (bool)
253         // 3-5 - air drop tracker (uint 0-999)
254         // 6-16 - round end time
255         // 17 - winnerTeam
256         // 18 - 28 timestamp 
257         // 29 - team
258         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
259         // 31 - airdrop happened bool
260         // 32 - airdrop tier 
261         // 33 - airdrop amount won
262     //compressedIDs key
263     // [77-52][51-26][25-0]
264         // 0-25 - pID 
265         // 26-51 - winPID
266         // 52-77 - rID
267     struct EventReturns {
268         uint256 compressedData;
269         uint256 compressedIDs;
270         address winnerAddr;         // winner address
271         bytes32 winnerName;         // winner name
272         uint256 amountWon;          // amount won
273         uint256 newPot;             // amount in new pot
274         uint256 P3DAmount;          // amount distributed to p3d
275         uint256 genAmount;          // amount distributed to gen
276         uint256 potAmount;          // amount added to pot
277     }
278     struct Player {
279         address addr;   // player address
280         bytes32 name;   // player name
281         uint256 win;    // winnings vault
282         uint256 gen;    // general vault
283         uint256 aff;    // affiliate vault
284         uint256 lrnd;   // last round played
285         uint256 laff;   // last affiliate id used
286     }
287     struct PlayerRounds {
288         uint256 eth;    // eth player has added to round (used for eth limiter)
289         uint256 keys;   // keys 小羊
290         uint256 mask;   // player mask 
291         uint256 ico;    // ICO phase investment
292     }
293     struct Round {
294         uint256 plyr;   // pID of player in lead， lead领导吗？
295         uint256 team;   // tID of team in lead
296         uint256 end;    // time ends/ended
297         bool ended;     // has round end function been ran  这个开关值得研究下
298         uint256 strt;   // time round started
299         uint256 keys;   // keys
300         uint256 eth;    // total eth in
301         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
302         uint256 mask;   // global mask
303         uint256 ico;    // total eth sent in during ICO phase
304         uint256 icoGen; // total eth for gen during ICO phase
305         uint256 icoAvg; // average key price for ICO phase
306     }
307     struct TeamFee {
308         uint256 gen;    // % of buy in thats paid to key holders of current round
309         uint256 p3d;    // % of buy in thats paid to p3d holders
310     }
311     struct PotSplit {
312         uint256 gen;    // % of pot thats paid to key holders of current round
313         uint256 p3d;    // % of pot thats paid to p3d holders
314     }
315 }
316 
317 // File: contracts/library/NameFilter.sol
318 
319 /**
320 * @title -Name Filter- v0.1.9
321 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
322 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
323 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
324 *                                  _____                      _____
325 *                                 (, /     /)       /) /)    (, /      /)          /)
326 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
327 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
328 *          ┴ ┴                /   /          .-/ _____   (__ /                               
329 *                            (__ /          (_/ (, /                                      /)™ 
330 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
331 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
332 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
333 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
334 *              _       __    _      ____      ____  _   _    _____  ____  ___  
335 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
336 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
337 *
338 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
339 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
340 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
341 */
342 
343 library NameFilter {
344     /**
345      * @dev filters name strings
346      * -converts uppercase to lower case.  
347      * -makes sure it does not start/end with a space
348      * -makes sure it does not contain multiple spaces in a row
349      * -cannot be only numbers
350      * -cannot start with 0x 
351      * -restricts characters to A-Z, a-z, 0-9, and space.
352      * @return reprocessed string in bytes32 format
353      */
354     function nameFilter(string _input)
355         internal
356         pure
357         returns(bytes32)
358     {
359         bytes memory _temp = bytes(_input);
360         uint256 _length = _temp.length;
361         
362         //sorry limited to 32 characters
363         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
364         // make sure it doesnt start with or end with space
365         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
366         // make sure first two characters are not 0x
367         if (_temp[0] == 0x30)
368         {
369             require(_temp[1] != 0x78, "string cannot start with 0x");
370             require(_temp[1] != 0x58, "string cannot start with 0X");
371         }
372         
373         // create a bool to track if we have a non number character
374         bool _hasNonNumber;
375         
376         // convert & check
377         for (uint256 i = 0; i < _length; i++)
378         {
379             // if its uppercase A-Z
380             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
381             {
382                 // convert to lower case a-z
383                 _temp[i] = byte(uint(_temp[i]) + 32);
384                 
385                 // we have a non number
386                 if (_hasNonNumber == false)
387                     _hasNonNumber = true;
388             } else {
389                 require
390                 (
391                     // require character is a space
392                     _temp[i] == 0x20 || 
393                     // OR lowercase a-z
394                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
395                     // or 0-9
396                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
397                     "string contains invalid characters"
398                 );
399                 // make sure theres not 2x spaces in a row
400                 if (_temp[i] == 0x20)
401                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
402                 
403                 // see if we have a character other than a number
404                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
405                     _hasNonNumber = true;    
406             }
407         }
408         
409         require(_hasNonNumber == true, "string cannot be only numbers");
410         
411         bytes32 _ret;
412         assembly {
413             _ret := mload(add(_temp, 32))
414         }
415         return (_ret);
416     }
417 }
418 
419 // File: contracts/library/UintCompressor.sol
420 
421 /**
422 * @title -UintCompressor- v0.1.9
423 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
424 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
425 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
426 *                                  _____                      _____
427 *                                 (, /     /)       /) /)    (, /      /)          /)
428 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
429 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
430 *          ┴ ┴                /   /          .-/ _____   (__ /                               
431 *                            (__ /          (_/ (, /                                      /)™ 
432 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
433 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
434 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
435 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
436 *    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ 
437 *===/ )( \ (  ) (  ( \(_  _)===/ __) /  \ ( \/ )(  _ \(  _ \(  __)/ ___)/ ___) /  \ (  _ \===*
438 *   ) \/ (  )(  /    /  )(    ( (__ (  O )/ \/ \ ) __/ )   / ) _) \___ \\___ \(  O ) )   /
439 *===\____/ (__) \_)__) (__)====\___) \__/ \_)(_/(__)  (__\_)(____)(____/(____/ \__/ (__\_)===*
440 *
441 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
442 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
443 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
444 */
445 
446 library UintCompressor {
447     using SafeMath for *;
448     
449     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
450         internal
451         pure
452         returns(uint256)
453     {
454         // check conditions 
455         require(_end < 77 && _start < 77, "start/end must be less than 77");
456         require(_end >= _start, "end must be >= start");
457         
458         // format our start/end points
459         _end = exponent(_end).mul(10);
460         _start = exponent(_start);
461         
462         // check that the include data fits into its segment 
463         require(_include < (_end / _start));
464         
465         // build middle
466         if (_include > 0)
467             _include = _include.mul(_start);
468         
469         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
470     }
471     
472     function extract(uint256 _input, uint256 _start, uint256 _end)
473         internal
474         pure
475         returns(uint256)
476     {
477         // check conditions
478         require(_end < 77 && _start < 77, "start/end must be less than 77");
479         require(_end >= _start, "end must be >= start");
480         
481         // format our start/end points
482         _end = exponent(_end).mul(10);
483         _start = exponent(_start);
484         
485         // return requested section
486         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
487     }
488     
489     function exponent(uint256 _position)
490         private
491         pure
492         returns(uint256)
493     {
494         return((10).pwr(_position));
495     }
496 }
497 
498 // File: contracts/F3Devents.sol
499 
500 contract F3Devents {
501     // fired whenever a player registers a name
502     event onNewName
503     (
504         uint256 indexed playerID,
505         address indexed playerAddress,
506         bytes32 indexed playerName,
507         bool isNewPlayer,
508         uint256 affiliateID,
509         address affiliateAddress,
510         bytes32 affiliateName,
511         uint256 amountPaid,
512         uint256 timeStamp
513     );
514     
515     // fired at end of buy or reload
516     event onEndTx
517     (
518         uint256 compressedData,     
519         uint256 compressedIDs,      
520         bytes32 playerName,
521         address playerAddress,
522         uint256 ethIn,
523         uint256 keysBought,
524         address winnerAddr,
525         bytes32 winnerName,
526         uint256 amountWon,
527         uint256 newPot,
528         uint256 P3DAmount,
529         uint256 genAmount,
530         uint256 potAmount,
531         uint256 airDropPot
532     );
533     
534     // fired whenever theres a withdraw
535     event onWithdraw
536     (
537         uint256 indexed playerID,
538         address playerAddress,
539         bytes32 playerName,
540         uint256 ethOut,
541         uint256 timeStamp
542     );
543     
544     // fired whenever a withdraw forces end round to be ran
545     event onWithdrawAndDistribute
546     (
547         address playerAddress,
548         bytes32 playerName,
549         uint256 ethOut,
550         uint256 compressedData,
551         uint256 compressedIDs,
552         address winnerAddr,
553         bytes32 winnerName,
554         uint256 amountWon,
555         uint256 newPot,
556         uint256 P3DAmount,
557         uint256 genAmount
558     );
559     
560     // (fomo3d long only) fired whenever a player tries a buy after round timer 
561     // hit zero, and causes end round to be ran.
562     event onBuyAndDistribute
563     (
564         address playerAddress,
565         bytes32 playerName,
566         uint256 ethIn,
567         uint256 compressedData,
568         uint256 compressedIDs,
569         address winnerAddr,
570         bytes32 winnerName,
571         uint256 amountWon,
572         uint256 newPot,
573         uint256 P3DAmount,
574         uint256 genAmount
575     );
576     
577     // (fomo3d long only) fired whenever a player tries a reload after round timer 
578     // hit zero, and causes end round to be ran.
579     event onReLoadAndDistribute
580     (
581         address playerAddress,
582         bytes32 playerName,
583         uint256 compressedData,
584         uint256 compressedIDs,
585         address winnerAddr,
586         bytes32 winnerName,
587         uint256 amountWon,
588         uint256 newPot,
589         uint256 P3DAmount,
590         uint256 genAmount
591     );
592     
593     // fired whenever an affiliate is paid
594     event onAffiliatePayout
595     (
596         uint256 indexed affiliateID,
597         address affiliateAddress,
598         bytes32 affiliateName,
599         uint256 indexed roundID,
600         uint256 indexed buyerID,
601         uint256 amount,
602         uint256 timeStamp
603     );
604     
605     // received pot swap deposit
606     event onPotSwapDeposit
607     (
608         uint256 roundID,
609         uint256 amountAddedToPot
610     );
611 }
612 
613 // File: contracts/modularLong.sol
614 
615 contract modularLong is F3Devents {}
616 
617 // File: contracts/FoMo3Dlong.sol
618 
619 contract FoMo3Dlong is modularLong {
620     using SafeMath for *;
621     using NameFilter for string;
622     using F3DKeysCalcLong for uint256;
623     
624     otherFoMo3D private otherF3D_;
625 
626     //TODO:
627     DiviesInterface constant private Divies = DiviesInterface(0x6e6d9770e44f57db3bb94d18e3e7cc5ba7855f6d);
628     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xca255f23ba3fd322fb634d3783db90659a7a48ba);
629     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x8727455a941d4f95e20a4c76ec3aef019fe73811);
630     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x35d3f1c98d9fd8087e312e953f32233ace1996b6);
631 //==============================================================================
632 //     _ _  _  |`. _     _ _ |_ | _  _  .
633 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
634 //=================_|===========================================================
635     string constant public name = "FoMoKiller long";
636     string constant public symbol = "FoMoKiller";
637     uint256 private rndExtra_ = 15 seconds;     // length of the very first ICO 
638     uint256 private rndGap_ = 1 hours;         // length of ICO phase, set to 1 year for EOS.
639     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
640     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
641     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
642 //==============================================================================
643 //     _| _ _|_ _    _ _ _|_    _   .
644 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
645 //=============================|================================================
646     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
647     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
648     uint256 public rID_;    // round id number / total rounds that have happened
649 //****************
650 // PLAYER DATA 
651 //****************
652     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
653     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
654     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
655     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
656     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
657 //****************
658 // ROUND DATA 
659 //****************
660     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
661     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
662 //****************
663 // TEAM FEE DATA , Team的费用分配数据
664 //****************
665     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
666     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
667 
668     address public ourTEAM = 0xf1E32a3EaA5D6c360AF6AA2c45a97e377Be183BD;
669     mapping (address => bool) public myFounder_;
670     mapping (address => uint256) public myFounder_PID;
671 //==============================================================================
672 //     _ _  _  __|_ _    __|_ _  _  .
673 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
674 //==============================================================================
675     constructor()
676         public
677     {
678         // Team allocation structures
679         // 0 = 预言家
680         // 1 = 守卫
681         // 2 = 丘比特
682         // 3 = 长老
683 
684         // Team allocation percentages
685         // (F3D, P3D) + (Pot , Referrals, Community)
686             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
687         fees_[0] = F3Ddatasets.TeamFee(70,0);
688         fees_[1] = F3Ddatasets.TeamFee(60,0);
689         fees_[2] = F3Ddatasets.TeamFee(50,0);
690         fees_[3] = F3Ddatasets.TeamFee(40,0);
691         
692         // how to split up the final pot based on which team was picked
693         // (F3D, P3D)
694         potSplit_[0] = F3Ddatasets.PotSplit(20,0);
695         potSplit_[1] = F3Ddatasets.PotSplit(30,0);
696         potSplit_[2] = F3Ddatasets.PotSplit(40,0);
697         potSplit_[3] = F3Ddatasets.PotSplit(50,0);
698 
699         myFounder_[0xa78cd12e5f2daf88023f0bfe119eac8b3f3dbc93] = true; 
700         myFounder_[0xfB31eb7B96e413BEbEe61F5E3880938b937c2Ef0] = true; 
701         myFounder_[0xEa8A4f09C45967DFCFda180fA80ad44eefAb52bE] = true; 
702         myFounder_[0xf1E32a3EaA5D6c360AF6AA2c45a97e377Be183BD] = true; 
703     }
704 //==============================================================================
705 //     _ _  _  _|. |`. _  _ _  .
706 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
707 //==============================================================================
708     /**
709      * @dev used to make sure no one can interact with contract until it has 
710      * been activated. 
711      */
712     modifier isActivated() {
713         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
714         _;
715     }
716     
717     /**
718      * @dev prevents contracts from interacting with fomo3d 
719      */
720     modifier isHuman() {
721         address _addr = msg.sender;
722         // require (_addr == tx.origin);
723         
724         uint256 _codeLength;
725         
726         assembly {_codeLength := extcodesize(_addr)}
727         require(_codeLength == 0, "sorry humans only");
728         _;
729     }
730 
731     /**
732      * @dev sets boundaries for incoming tx 
733      */
734     modifier isWithinLimits(uint256 _eth) {
735         require(_eth >= 1000000000, "pocket lint: not a valid currency");
736         require(_eth <= 100000000000000000000000, "no vitalik, no");
737         _;    
738     }
739 
740     /**
741      * 
742      */
743     modifier onlyDevs() {
744         //TODO:
745         require(
746             msg.sender == 0xa78cd12e5f2daf88023f0bfe119eac8b3f3dbc93 ||
747             msg.sender == 0xfB31eb7B96e413BEbEe61F5E3880938b937c2Ef0 ||
748             msg.sender == 0xEa8A4f09C45967DFCFda180fA80ad44eefAb52bE ||
749             msg.sender == 0xf1E32a3EaA5D6c360AF6AA2c45a97e377Be183BD,
750             "only team just can activate"
751         );
752         _;
753     }
754     
755 //==============================================================================
756 //     _    |_ |. _   |`    _  __|_. _  _  _  .
757 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
758 //====|=========================================================================
759     /**
760      * @dev emergency buy uses last stored affiliate ID and team snek
761      */
762     function()
763         isActivated()
764         isHuman()
765         isWithinLimits(msg.value)
766         public
767         payable
768     {
769         // set up our tx event data and determine if player is new or not
770         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
771             
772         // fetch player id
773         uint256 _pID = pIDxAddr_[msg.sender];
774         
775         // buy core 
776         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
777     }
778     
779     /**
780      * @dev converts all incoming ethereum to keys.
781      * -functionhash- 0x8f38f309 (using ID for affiliate)
782      * -functionhash- 0x98a0871d (using address for affiliate)
783      * -functionhash- 0xa65b37a1 (using name for affiliate)
784      * @param _affCode the ID/address/name of the player who gets the affiliate fee
785      * @param _team what team is the player playing for?
786      */
787     function buyXid(uint256 _affCode, uint256 _team)
788         isActivated()
789         isHuman()
790         isWithinLimits(msg.value)
791         public
792         payable
793     {
794         // set up our tx event data and determine if player is new or not
795         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
796         
797         // fetch player id
798         uint256 _pID = pIDxAddr_[msg.sender];
799         
800         // manage affiliate residuals
801         // if no affiliate code was given or player tried to use their own, lolz
802         if (_affCode == 0 || _affCode == _pID)
803         {
804             // use last stored affiliate code 
805             _affCode = plyr_[_pID].laff;
806             
807         // if affiliate code was given & its not the same as previously stored 
808         } else if (_affCode != plyr_[_pID].laff) {
809             // update last affiliate 
810             plyr_[_pID].laff = _affCode;
811         }
812         
813         // verify a valid team was selected
814         _team = verifyTeam(_team);
815         
816         // buy core 
817         buyCore(_pID, _affCode, _team, _eventData_);
818     }
819     
820     function buyXaddr(address _affCode, uint256 _team)
821         isActivated()
822         isHuman()
823         isWithinLimits(msg.value)
824         public
825         payable
826     {
827         // set up our tx event data and determine if player is new or not
828         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
829         
830         // fetch player id
831         uint256 _pID = pIDxAddr_[msg.sender];
832         
833         // manage affiliate residuals
834         uint256 _affID;
835         // if no affiliate code was given or player tried to use their own, lolz
836         if (_affCode == address(0) || _affCode == msg.sender)
837         {
838             // use last stored affiliate code
839             _affID = plyr_[_pID].laff;
840         
841         // if affiliate code was given    
842         } else {
843             // get affiliate ID from aff Code 
844             _affID = pIDxAddr_[_affCode];
845             
846             // if affID is not the same as previously stored 
847             if (_affID != plyr_[_pID].laff)
848             {
849                 // update last affiliate
850                 plyr_[_pID].laff = _affID;
851             }
852         }
853         
854         // verify a valid team was selected
855         _team = verifyTeam(_team);
856         
857         // buy core 
858         buyCore(_pID, _affID, _team, _eventData_);
859     }
860     
861     function buyXname(bytes32 _affCode, uint256 _team)
862         isActivated()
863         isHuman()
864         isWithinLimits(msg.value)
865         public
866         payable
867     {
868         // set up our tx event data and determine if player is new or not
869         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
870         
871         // fetch player id
872         uint256 _pID = pIDxAddr_[msg.sender];
873         
874         // manage affiliate residuals
875         uint256 _affID;
876         // if no affiliate code was given or player tried to use their own, lolz
877         if (_affCode == '' || _affCode == plyr_[_pID].name)
878         {
879             // use last stored affiliate code
880             _affID = plyr_[_pID].laff;
881         
882         // if affiliate code was given
883         } else {
884             // get affiliate ID from aff Code
885             _affID = pIDxName_[_affCode];
886             
887             // if affID is not the same as previously stored
888             if (_affID != plyr_[_pID].laff)
889             {
890                 // update last affiliate
891                 plyr_[_pID].laff = _affID;
892             }
893         }
894         
895         // verify a valid team was selected
896         _team = verifyTeam(_team);
897         
898         // buy core 
899         buyCore(_pID, _affID, _team, _eventData_);
900     }
901     
902     /**
903      * @dev essentially the same as buy, but instead of you sending ether 
904      * from your wallet, it uses your unwithdrawn earnings.
905      * -functionhash- 0x349cdcac (using ID for affiliate)
906      * -functionhash- 0x82bfc739 (using address for affiliate)
907      * -functionhash- 0x079ce327 (using name for affiliate)
908      * @param _affCode the ID/address/name of the player who gets the affiliate fee
909      * @param _team what team is the player playing for?
910      * @param _eth amount of earnings to use (remainder returned to gen vault)
911      */
912     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
913         isActivated()
914         isHuman()
915         isWithinLimits(_eth)
916         public
917     {
918         // set up our tx event data
919         F3Ddatasets.EventReturns memory _eventData_;
920         
921         // fetch player ID
922         uint256 _pID = pIDxAddr_[msg.sender];
923         
924         // manage affiliate residuals
925         // if no affiliate code was given or player tried to use their own, lolz
926         if (_affCode == 0 || _affCode == _pID)
927         {
928             // use last stored affiliate code 
929             _affCode = plyr_[_pID].laff;
930             
931         // if affiliate code was given & its not the same as previously stored 
932         } else if (_affCode != plyr_[_pID].laff) {
933             // update last affiliate 
934             plyr_[_pID].laff = _affCode;
935         }
936 
937         // verify a valid team was selected
938         _team = verifyTeam(_team);
939 
940         // reload core
941         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
942     }
943     
944     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
945         isActivated()
946         isHuman()
947         isWithinLimits(_eth)
948         public
949     {
950         // set up our tx event data
951         F3Ddatasets.EventReturns memory _eventData_;
952         
953         // fetch player ID
954         uint256 _pID = pIDxAddr_[msg.sender];
955         
956         // manage affiliate residuals
957         uint256 _affID;
958         // if no affiliate code was given or player tried to use their own, lolz
959         if (_affCode == address(0) || _affCode == msg.sender)
960         {
961             // use last stored affiliate code
962             _affID = plyr_[_pID].laff;
963         
964         // if affiliate code was given    
965         } else {
966             // get affiliate ID from aff Code 
967             _affID = pIDxAddr_[_affCode];
968             
969             // if affID is not the same as previously stored 
970             if (_affID != plyr_[_pID].laff)
971             {
972                 // update last affiliate
973                 plyr_[_pID].laff = _affID;
974             }
975         }
976         
977         // verify a valid team was selected
978         _team = verifyTeam(_team);
979         
980         // reload core
981         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
982     }
983     
984     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
985         isActivated()
986         isHuman()
987         isWithinLimits(_eth)
988         public
989     {
990         // set up our tx event data
991         F3Ddatasets.EventReturns memory _eventData_;
992         
993         // fetch player ID
994         uint256 _pID = pIDxAddr_[msg.sender];
995         
996         // manage affiliate residuals
997         uint256 _affID;
998         // if no affiliate code was given or player tried to use their own, lolz
999         if (_affCode == '' || _affCode == plyr_[_pID].name)
1000         {
1001             // use last stored affiliate code
1002             _affID = plyr_[_pID].laff;
1003         
1004         // if affiliate code was given
1005         } else {
1006             // get affiliate ID from aff Code
1007             _affID = pIDxName_[_affCode];
1008             
1009             // if affID is not the same as previously stored
1010             if (_affID != plyr_[_pID].laff)
1011             {
1012                 // update last affiliate
1013                 plyr_[_pID].laff = _affID;
1014             }
1015         }
1016         
1017         // verify a valid team was selected
1018         _team = verifyTeam(_team);
1019         
1020         // reload core
1021         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
1022     }
1023 
1024     /**
1025      * @dev withdraws all of your earnings.
1026      * -functionhash- 0x3ccfd60b
1027      */
1028     function withdraw()
1029         isActivated()
1030         isHuman()
1031         public
1032     {
1033         // setup local rID 
1034         uint256 _rID = rID_;
1035         
1036         // grab time
1037         uint256 _now = now;
1038         
1039         // fetch player ID
1040         uint256 _pID = pIDxAddr_[msg.sender];
1041         
1042         // setup temp var for player eth
1043         uint256 _eth;
1044         
1045         // check to see if round has ended and no one has run round end yet
1046         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1047         {
1048             // set up our tx event data
1049             F3Ddatasets.EventReturns memory _eventData_;
1050             
1051             // end the round (distributes pot)
1052             round_[_rID].ended = true;
1053             _eventData_ = endRound(_eventData_);
1054             
1055             // get their earnings
1056             _eth = withdrawEarnings(_pID);
1057             
1058             // gib moni
1059             if (_eth > 0)
1060                 plyr_[_pID].addr.transfer(_eth);    
1061             
1062             // build event data
1063             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1064             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1065             
1066             // fire withdraw and distribute event
1067             emit F3Devents.onWithdrawAndDistribute
1068             (
1069                 msg.sender, 
1070                 plyr_[_pID].name, 
1071                 _eth, 
1072                 _eventData_.compressedData, 
1073                 _eventData_.compressedIDs, 
1074                 _eventData_.winnerAddr, 
1075                 _eventData_.winnerName, 
1076                 _eventData_.amountWon, 
1077                 _eventData_.newPot, 
1078                 _eventData_.P3DAmount, 
1079                 _eventData_.genAmount
1080             );
1081             
1082         // in any other situation
1083         } else {
1084             // get their earnings
1085             _eth = withdrawEarnings(_pID);
1086             
1087             // gib moni
1088             if (_eth > 0)
1089                 plyr_[_pID].addr.transfer(_eth);
1090             
1091             // fire withdraw event
1092             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
1093         }
1094     }
1095     
1096     /**
1097      * @dev use these to register names.  they are just wrappers that will send the
1098      * registration requests to the PlayerBook contract.  So registering here is the 
1099      * same as registering there.  UI will always display the last name you registered.
1100      * but you will still own all previously registered names to use as affiliate 
1101      * links.
1102      * - must pay a registration fee.
1103      * - name must be unique
1104      * - names will be converted to lowercase
1105      * - name cannot start or end with a space 
1106      * - cannot have more than 1 space in a row
1107      * - cannot be only numbers
1108      * - cannot start with 0x 
1109      * - name must be at least 1 char
1110      * - max length of 32 characters long
1111      * - allowed characters: a-z, 0-9, and space
1112      * -functionhash- 0x921dec21 (using ID for affiliate)
1113      * -functionhash- 0x3ddd4698 (using address for affiliate)
1114      * -functionhash- 0x685ffd83 (using name for affiliate)
1115      * @param _nameString players desired name
1116      * @param _affCode affiliate ID, address, or name of who referred you
1117      * @param _all set to true if you want this to push your info to all games 
1118      * (this might cost a lot of gas)
1119      */
1120     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1121         isHuman()
1122         public
1123         payable
1124     {
1125         bytes32 _name = _nameString.nameFilter();
1126         address _addr = msg.sender;
1127         uint256 _paid = msg.value;
1128         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
1129         
1130         uint256 _pID = pIDxAddr_[_addr];
1131         
1132         // fire event
1133         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1134     }
1135     
1136     function registerNameXaddr(string _nameString, address _affCode, bool _all)
1137         isHuman()
1138         public
1139         payable
1140     {
1141         bytes32 _name = _nameString.nameFilter();
1142         address _addr = msg.sender;
1143         uint256 _paid = msg.value;
1144         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1145         
1146         uint256 _pID = pIDxAddr_[_addr];
1147         
1148         // fire event
1149         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1150     }
1151     
1152     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1153         isHuman()
1154         public
1155         payable
1156     {
1157         bytes32 _name = _nameString.nameFilter();
1158         address _addr = msg.sender;
1159         uint256 _paid = msg.value;
1160         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1161         
1162         uint256 _pID = pIDxAddr_[_addr];
1163         
1164         // fire event
1165         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1166     }
1167 //==============================================================================
1168 //     _  _ _|__|_ _  _ _  .
1169 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1170 //=====_|=======================================================================
1171     /**
1172      * @dev return the price buyer will pay for next 1 individual key.
1173      * -functionhash- 0x018a25e8
1174      * @return price for next key bought (in wei format)
1175      */
1176     function getBuyPrice()
1177         public 
1178         view 
1179         returns(uint256)
1180     {  
1181         // setup local rID
1182         uint256 _rID = rID_;
1183         
1184         // grab time
1185         uint256 _now = now;
1186         
1187         // are we in a round?
1188         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1189             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1190         else // rounds over.  need price for new round
1191             return ( 75000000000000 ); // init
1192     }
1193     
1194     /**
1195      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
1196      * provider
1197      * -functionhash- 0xc7e284b8
1198      * @return time left in seconds
1199      */
1200     function getTimeLeft()
1201         public
1202         view
1203         returns(uint256)
1204     {
1205         // setup local rID
1206         uint256 _rID = rID_;
1207         
1208         // grab time
1209         uint256 _now = now;
1210         
1211         if (_now < round_[_rID].end)
1212             if (_now > round_[_rID].strt + rndGap_)
1213                 return( (round_[_rID].end).sub(_now) );
1214             else
1215                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1216         else
1217             return(0);
1218     }
1219     
1220     /**
1221      * @dev returns player earnings per vaults 
1222      * -functionhash- 0x63066434
1223      * @return winnings vault
1224      * @return general vault
1225      * @return affiliate vault
1226      */
1227     function getPlayerVaults(uint256 _pID)
1228         public
1229         view
1230         returns(uint256 ,uint256, uint256)
1231     {
1232         // setup local rID
1233         uint256 _rID = rID_;
1234         
1235         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1236         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1237         {
1238             // if player is winner 
1239             if (round_[_rID].plyr == _pID)
1240             {
1241                 return
1242                 (
1243                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(40)) / 100 ),
1244                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1245                     plyr_[_pID].aff
1246                 );
1247             // if player is not the winner
1248             } else {
1249                 return
1250                 (
1251                     plyr_[_pID].win,
1252                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1253                     plyr_[_pID].aff
1254                 );
1255             }
1256             
1257         // if round is still going on, or round has ended and round end has been ran
1258         } else {
1259             return
1260             (
1261                 plyr_[_pID].win,
1262                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1263                 plyr_[_pID].aff
1264             );
1265         }
1266     }
1267     
1268     /**
1269      * solidity hates stack limits.  this lets us avoid that hate 
1270      */
1271     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1272         private
1273         view
1274         returns(uint256)
1275     {
1276         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1277     }
1278     
1279     /**
1280      * @dev returns all current round info needed for front end
1281      * -functionhash- 0x747dff42
1282      * @return eth invested during ICO phase
1283      * @return round id 
1284      * @return total keys for round 
1285      * @return time round ends
1286      * @return time round started
1287      * @return current pot 
1288      * @return current team ID & player ID in lead 
1289      * @return current player in leads address 
1290      * @return current player in leads name
1291      * @return whales eth in for round
1292      * @return bears eth in for round
1293      * @return sneks eth in for round
1294      * @return bulls eth in for round
1295      * @return airdrop tracker # & airdrop pot
1296      */
1297     function getCurrentRoundInfo()
1298         public
1299         view
1300         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1301     {
1302         // setup local rID
1303         uint256 _rID = rID_;
1304         
1305         return
1306         (
1307             round_[_rID].ico,               //0
1308             _rID,                           //1
1309             round_[_rID].keys,              //2
1310             round_[_rID].end,               //3
1311             round_[_rID].strt,              //4
1312             round_[_rID].pot,               //5
1313             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1314             plyr_[round_[_rID].plyr].addr,  //7
1315             plyr_[round_[_rID].plyr].name,  //8
1316             rndTmEth_[_rID][0],             //9
1317             rndTmEth_[_rID][1],             //10
1318             rndTmEth_[_rID][2],             //11
1319             rndTmEth_[_rID][3],             //12
1320             airDropTracker_ + (airDropPot_ * 1000)              //13
1321         );
1322     }
1323 
1324     /**
1325      * @dev returns player info based on address.  if no address is given, it will 
1326      * use msg.sender 
1327      * -functionhash- 0xee0b5d8b
1328      * @param _addr address of the player you want to lookup 
1329      * @return player ID 
1330      * @return player name
1331      * @return keys owned (current round)
1332      * @return winnings vault
1333      * @return general vault 
1334      * @return affiliate vault 
1335      * @return player round eth
1336      */
1337     function getPlayerInfoByAddress(address _addr)
1338         public 
1339         view 
1340         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1341     {
1342         // setup local rID
1343         uint256 _rID = rID_;
1344         
1345         if (_addr == address(0))
1346         {
1347             _addr == msg.sender;
1348         }
1349         uint256 _pID = pIDxAddr_[_addr];
1350         
1351         return
1352         (
1353             _pID,                               //0
1354             plyr_[_pID].name,                   //1
1355             plyrRnds_[_pID][_rID].keys,         //2
1356             plyr_[_pID].win,                    //3
1357             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1358             plyr_[_pID].aff,                    //5
1359             plyrRnds_[_pID][_rID].eth           //6
1360         );
1361     }
1362 
1363 //==============================================================================
1364 //     _ _  _ _   | _  _ . _  .
1365 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1366 //=====================_|=======================================================
1367     /**
1368      * @dev logic runs whenever a buy order is executed.  determines how to handle 
1369      * incoming eth depending on if we are in an active round or not
1370      */
1371     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1372         private
1373     {
1374         // setup local rID
1375         uint256 _rID = rID_;
1376         
1377         // grab time
1378         uint256 _now = now;
1379         
1380         // if round is active
1381         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1382         {
1383             // call core 
1384             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1385         
1386         // if round is not active     
1387         } else {
1388             // check to see if end round needs to be ran
1389             if (_now > round_[_rID].end && round_[_rID].ended == false) 
1390             {
1391                 // end the round (distributes pot) & start new round
1392                 round_[_rID].ended = true;
1393                 _eventData_ = endRound(_eventData_);
1394                 
1395                 // build event data
1396                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1397                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1398                 
1399                 // fire buy and distribute event 
1400                 emit F3Devents.onBuyAndDistribute
1401                 (
1402                     msg.sender, 
1403                     plyr_[_pID].name, 
1404                     msg.value, 
1405                     _eventData_.compressedData, 
1406                     _eventData_.compressedIDs, 
1407                     _eventData_.winnerAddr, 
1408                     _eventData_.winnerName, 
1409                     _eventData_.amountWon, 
1410                     _eventData_.newPot, 
1411                     _eventData_.P3DAmount, 
1412                     _eventData_.genAmount
1413                 );
1414             }
1415             
1416             // put eth in players vault 
1417             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1418         }
1419     }
1420     
1421     /**
1422      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1423      * incoming eth depending on if we are in an active round or not 
1424      */
1425     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1426         private
1427     {
1428         // setup local rID
1429         uint256 _rID = rID_;
1430         
1431         // grab time
1432         uint256 _now = now;
1433         
1434         // if round is active
1435         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1436         {
1437             // get earnings from all vaults and return unused to gen vault
1438             // because we use a custom safemath library.  this will throw if player 
1439             // tried to spend more eth than they have.
1440             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1441             
1442             // call core 
1443             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1444         
1445         // if round is not active and end round needs to be ran   
1446         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1447             // end the round (distributes pot) & start new round
1448             round_[_rID].ended = true;
1449             _eventData_ = endRound(_eventData_);
1450                 
1451             // build event data
1452             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1453             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1454                 
1455             // fire buy and distribute event 
1456             emit F3Devents.onReLoadAndDistribute
1457             (
1458                 msg.sender, 
1459                 plyr_[_pID].name, 
1460                 _eventData_.compressedData, 
1461                 _eventData_.compressedIDs, 
1462                 _eventData_.winnerAddr, 
1463                 _eventData_.winnerName, 
1464                 _eventData_.amountWon, 
1465                 _eventData_.newPot, 
1466                 _eventData_.P3DAmount, 
1467                 _eventData_.genAmount
1468             );
1469         }
1470     }
1471     
1472     /**
1473      * @dev this is the core logic for any buy/reload that happens while a round 
1474      * is live.
1475      */
1476     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1477         private
1478     {
1479         // if player is new to round
1480         if (plyrRnds_[_pID][_rID].keys == 0)
1481             _eventData_ = managePlayer(_pID, _eventData_);
1482         
1483         // early round eth limiter 
1484         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1485         {
1486             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1487             uint256 _refund = _eth.sub(_availableLimit);
1488             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1489             _eth = _availableLimit;
1490         }
1491         
1492         // if eth left is greater than min eth allowed (sorry no pocket lint)
1493         if (_eth > 1000000000) 
1494         {
1495             
1496             // mint the new keys
1497             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1498             
1499             // if they bought at least 1 whole key
1500             if (_keys >= 1000000000000000000)
1501             {
1502             updateTimer(_keys, _rID);
1503 
1504             // set new leaders
1505             if (round_[_rID].plyr != _pID)
1506                 round_[_rID].plyr = _pID;  
1507             if (round_[_rID].team != _team)
1508                 round_[_rID].team = _team; 
1509             
1510             // set the new leader bool to true
1511             _eventData_.compressedData = _eventData_.compressedData + 100;
1512         }
1513             
1514             // manage airdrops
1515             if (_eth >= 100000000000000000)
1516             {
1517             airDropTracker_++;
1518             if (airdrop() == true)
1519             {
1520                 // gib muni
1521                 uint256 _prize;
1522                 if (_eth >= 10000000000000000000)
1523                 {
1524                     // calculate prize and give it to winner
1525                     _prize = ((airDropPot_).mul(75)) / 100;
1526                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1527                     
1528                     // adjust airDropPot 
1529                     airDropPot_ = (airDropPot_).sub(_prize);
1530                     
1531                     // let event know a tier 3 prize was won 
1532                     _eventData_.compressedData += 300000000000000000000000000000000;
1533                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1534                     // calculate prize and give it to winner
1535                     _prize = ((airDropPot_).mul(50)) / 100;
1536                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1537                     
1538                     // adjust airDropPot 
1539                     airDropPot_ = (airDropPot_).sub(_prize);
1540                     
1541                     // let event know a tier 2 prize was won 
1542                     _eventData_.compressedData += 200000000000000000000000000000000;
1543                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1544                     // calculate prize and give it to winner
1545                     _prize = ((airDropPot_).mul(25)) / 100;
1546                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1547                     
1548                     // adjust airDropPot 
1549                     airDropPot_ = (airDropPot_).sub(_prize);
1550                     
1551                     // let event know a tier 3 prize was won 
1552                     _eventData_.compressedData += 300000000000000000000000000000000;
1553                 }
1554                 // set airdrop happened bool to true
1555                 _eventData_.compressedData += 10000000000000000000000000000000;
1556                 // let event know how much was won 
1557                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1558                 
1559                 // reset air drop tracker
1560                 // 不在这里reset，一轮游戏结束的时候再reset
1561                 // airDropTracker_ = 0;
1562             }
1563         }
1564     
1565             // store the air drop tracker number (number of buys since last airdrop)
1566             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1567             
1568             if (myFounder_PID[plyr_[_pID].addr] > 0) {
1569                 plyrRnds_[_pID][_rID].keys = myFounder_PID[plyr_[_pID].addr].add(plyrRnds_[_pID][_rID].keys);
1570                 round_[_rID].keys = myFounder_PID[plyr_[_pID].addr].add(round_[_rID].keys);
1571                 myFounder_PID[plyr_[_pID].addr] = 0;
1572             }
1573 
1574             // update player 
1575             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1576             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1577             
1578             // update round
1579             round_[_rID].keys = _keys.add(round_[_rID].keys);
1580             round_[_rID].eth = _eth.add(round_[_rID].eth);
1581             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1582     
1583             // distribute eth  分钱
1584             _eth = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1585             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1586             
1587             // call end tx function to fire end tx event.
1588             endTx(_pID, _team, _eth, _keys, _eventData_);
1589         }
1590     }
1591 //==============================================================================
1592 //     _ _ | _   | _ _|_ _  _ _  .
1593 //    (_(_||(_|_||(_| | (_)| _\  .
1594 //==============================================================================
1595     /**
1596      * @dev calculates unmasked earnings (just calculates, does not update mask)
1597      * @return earnings in wei format
1598      */
1599     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1600         private
1601         view
1602         returns(uint256)
1603     {
1604         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1605     }
1606     
1607     /** 
1608      * @dev returns the amount of keys you would get given an amount of eth. 
1609      * -functionhash- 0xce89c80c
1610      * @param _rID round ID you want price for
1611      * @param _eth amount of eth sent in 
1612      * @return keys received 
1613      */
1614     function calcKeysReceived(uint256 _rID, uint256 _eth)
1615         public
1616         view
1617         returns(uint256)
1618     {
1619         // grab time
1620         uint256 _now = now;
1621         
1622         // are we in a round?
1623         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1624             return ( (round_[_rID].eth).keysRec(_eth) );
1625         else // rounds over.  need keys for new round
1626             return ( (_eth).keys() );
1627     }
1628     
1629     /** 
1630      * @dev returns current eth price for X keys.  
1631      * -functionhash- 0xcf808000
1632      * @param _keys number of keys desired (in 18 decimal format)
1633      * @return amount of eth needed to send
1634      */
1635     function iWantXKeys(uint256 _keys)
1636         public
1637         view
1638         returns(uint256)
1639     {
1640         // setup local rID
1641         uint256 _rID = rID_;
1642         
1643         // grab time
1644         uint256 _now = now;
1645         
1646         // are we in a round?
1647         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1648             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1649         else // rounds over.  need price for new round
1650             return ( (_keys).eth() );
1651     }
1652 //==============================================================================
1653 //    _|_ _  _ | _  .
1654 //     | (_)(_)|_\  .
1655 //==============================================================================
1656     /**
1657      * @dev receives name/player info from names contract 
1658      */
1659     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1660         external
1661     {
1662         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1663         if (pIDxAddr_[_addr] != _pID)
1664             pIDxAddr_[_addr] = _pID;
1665         if (pIDxName_[_name] != _pID)
1666             pIDxName_[_name] = _pID;
1667         if (plyr_[_pID].addr != _addr)
1668             plyr_[_pID].addr = _addr;
1669         if (plyr_[_pID].name != _name)
1670             plyr_[_pID].name = _name;
1671         if (plyr_[_pID].laff != _laff)
1672             plyr_[_pID].laff = _laff;
1673         if (plyrNames_[_pID][_name] == false)
1674             plyrNames_[_pID][_name] = true;
1675     }
1676     
1677     /**
1678      * @dev receives entire player name list 
1679      */
1680     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1681         external
1682     {
1683         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1684         if(plyrNames_[_pID][_name] == false)
1685             plyrNames_[_pID][_name] = true;
1686     }   
1687         
1688     /**
1689      * @dev gets existing or registers new pID.  use this when a player may be new
1690      * @return pID 
1691      */
1692     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1693         private
1694         returns (F3Ddatasets.EventReturns)
1695     {
1696         uint256 _pID = pIDxAddr_[msg.sender];
1697         // if player is new to this version of fomo3d
1698         if (_pID == 0)
1699         {
1700             // grab their player ID, name and last aff ID, from player names contract 
1701             _pID = PlayerBook.getPlayerID(msg.sender);
1702             bytes32 _name = PlayerBook.getPlayerName(_pID);
1703             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1704             
1705             // set up player account 
1706             pIDxAddr_[msg.sender] = _pID;
1707             plyr_[_pID].addr = msg.sender;
1708             
1709             if (_name != "")
1710             {
1711                 pIDxName_[_name] = _pID;
1712                 plyr_[_pID].name = _name;
1713                 plyrNames_[_pID][_name] = true;
1714             }
1715             
1716             if (_laff != 0 && _laff != _pID)
1717                 plyr_[_pID].laff = _laff;
1718             
1719             // set the new player bool to true
1720             _eventData_.compressedData = _eventData_.compressedData + 1;
1721         } 
1722         return (_eventData_);
1723     }
1724     
1725     /**
1726      * @dev checks to make sure user picked a valid team.  if not sets team 
1727      * to default (sneks)
1728      */
1729     function verifyTeam(uint256 _team)
1730         private
1731         pure
1732         returns (uint256)
1733     {
1734         if (_team < 0 || _team > 3)
1735             return(2);
1736         else
1737             return(_team);
1738     }
1739     
1740     /**
1741      * @dev decides if round end needs to be run & new round started.  and if 
1742      * player unmasked earnings from previously played rounds need to be moved.
1743      */
1744     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1745         private
1746         returns (F3Ddatasets.EventReturns)
1747     {
1748         // if player has played a previous round, move their unmasked earnings
1749         // from that round to gen vault.
1750         if (plyr_[_pID].lrnd != 0)
1751             updateGenVault(_pID, plyr_[_pID].lrnd);
1752             
1753         // update player's last round played
1754         plyr_[_pID].lrnd = rID_;
1755             
1756         // set the joined round bool to true
1757         _eventData_.compressedData = _eventData_.compressedData + 10;
1758         
1759         return(_eventData_);
1760     }
1761     
1762     /**
1763      * @dev ends the round. manages paying out winner/splitting up pot
1764      */
1765     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1766         private
1767         returns (F3Ddatasets.EventReturns)
1768     {
1769         // setup local rID
1770         uint256 _rID = rID_;
1771         // grab our winning player and team id's
1772         uint256 _winPID = round_[_rID].plyr;
1773         uint256 _winTID = round_[_rID].team;
1774         // grab our pot amount
1775         uint256 _pot = round_[_rID].pot;
1776         // calculate our winner share, community rewards, gen share, 
1777         // p3d share, and amount reserved for next pot 
1778         uint256 _win = (_pot.mul(40)) / 100;    //赢得奖金池里40%的奖金
1779         uint256 _com = (_pot / 10);             // _com获得10%的收益
1780         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; //20%、30%、40%、50%
1781         uint256 _p3d = 0;
1782         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1783         //结算收益 
1784         ourTEAM.transfer(_com);
1785         // calculate ppt for round mask
1786         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1787         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1788         if (_dust > 0)
1789         {
1790             _gen = _gen.sub(_dust);
1791             _res = _res.add(_dust);
1792         }
1793         // pay our winner
1794         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1795         
1796         // // community rewards
1797         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1798         // {
1799         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1800         //     // bank migrations by breaking outgoing transactions.
1801         //     // Something we would never do. But that's not the point.
1802         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1803         //     // highest belief that everything we create should be trustless.
1804         //     // Team JUST, The name you shouldn't have to trust.
1805         //     _p3d = _p3d.add(_com);
1806         //     _com = 0;
1807         // }
1808         
1809         // distribute gen portion to key holders
1810         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1811         
1812         // prepare event data
1813         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1814         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1815         _eventData_.winnerAddr = plyr_[_winPID].addr;
1816         _eventData_.winnerName = plyr_[_winPID].name;
1817         _eventData_.amountWon = _win;
1818         _eventData_.genAmount = _gen;
1819         _eventData_.P3DAmount = _p3d;
1820         _eventData_.newPot = _res;
1821         
1822         // start next round
1823         rID_++;
1824         _rID++;
1825         round_[_rID].strt = now;
1826         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1827         round_[_rID].pot = _res;
1828         airDropTracker_ = 0; //下一轮，空投数从0计数
1829         
1830         return(_eventData_);
1831     }
1832     
1833     /**
1834      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1835      */
1836     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1837         private 
1838     {
1839         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1840         if (_earnings > 0)
1841         {
1842             // put in gen vault
1843             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1844             // zero out their earnings by updating mask
1845             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1846         }
1847     }
1848     
1849     /**
1850      * @dev updates round timer based on number of whole keys bought.
1851      */
1852     function updateTimer(uint256 _keys, uint256 _rID)
1853         private
1854     {
1855         // grab time
1856         uint256 _now = now;
1857         
1858         // calculate time based on number of keys bought
1859         uint256 _newTime;
1860         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1861             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1862         else
1863             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1864         
1865         // compare to max and set new end time
1866         if (_newTime < (rndMax_).add(_now))
1867             round_[_rID].end = _newTime;
1868         else
1869             round_[_rID].end = rndMax_.add(_now);
1870     }
1871     
1872     /**
1873      * @dev generates a random number between 0-99 and checks to see if thats
1874      * resulted in an airdrop win
1875      * @return do we have a winner?
1876      */
1877     function airdrop()
1878         private 
1879         view 
1880         returns(bool)
1881     {
1882         //购买第1w、10w、100w、1000w、10000w只小羊的时候有奖励
1883         if(airDropTracker_ == 10000 || airDropTracker_ == 100000 || airDropTracker_ == 1000000 || airDropTracker_ == 10000000 || airDropTracker_ == 100000000  || airDropTracker_ == 1000000000  )
1884             return(true);
1885         else
1886             return(false);
1887     }
1888 
1889     /**
1890      * @dev distributes eth based on fees to com, aff, and p3d  mark by 33
1891      */
1892     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1893         private
1894         returns(uint256)
1895     {
1896         // pay 3% out to community rewards
1897         uint256 _com = (_eth.mul(3) / 100);
1898         ourTEAM.transfer(_com);
1899         uint256 _aff = _eth / 10;
1900         if (_affID != _pID && plyr_[_affID].name != '') {
1901             //修改分红比例，创世农民分红比例为20%
1902             if(myFounder_[plyr_[_affID].addr]) {
1903                 _aff = _eth / 5;
1904             }
1905             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1906             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1907         } 
1908         return (_eth.sub(_com)).sub(_aff);
1909     }
1910     
1911     function potSwap()
1912         external
1913         payable
1914     {
1915         // setup local rID
1916         uint256 _rID = rID_ + 1;
1917         
1918         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1919         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1920     }
1921     
1922     /**
1923      * @dev distributes eth based on fees to gen and pot
1924      */
1925     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1926         private
1927         returns(F3Ddatasets.EventReturns)
1928     {
1929         // calculate gen share
1930         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100; //70%、60%、50%、40%
1931         // toss 1% into airdrop pot 
1932         uint256 _air = (_eth / 100);
1933         airDropPot_ = airDropPot_.add(_air);
1934         uint256 _pot = _eth.sub(_gen).sub(_air);
1935         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1936         if (_dust > 0)
1937             _gen = _gen.sub(_dust);
1938         
1939         // add eth to pot
1940         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1941         
1942         // set up event data
1943         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1944         _eventData_.potAmount = _pot;
1945         
1946         return(_eventData_);
1947     }
1948 
1949     /**
1950      * @dev updates masks for round and player when keys are bought
1951      * @return dust left over 
1952      */
1953     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1954         private
1955         returns(uint256)
1956     {
1957         /* MASKING NOTES
1958             earnings masks are a tricky thing for people to wrap their minds around.
1959             the basic thing to understand here.  is were going to have a global
1960             tracker based on profit per share for each round, that increases in
1961             relevant proportion to the increase in share supply.
1962             
1963             the player will have an additional mask that basically says "based
1964             on the rounds mask, my shares, and how much i've already withdrawn,
1965             how much is still owed to me?"
1966         */
1967         
1968         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1969         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1970         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1971             
1972         // calculate player earning from their own buy (only based on the keys
1973         // they just bought).  & update player earnings mask
1974         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1975         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1976         
1977         // calculate & return dust
1978         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1979     }
1980     
1981     /**
1982      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1983      * @return earnings in wei format
1984      */
1985     function withdrawEarnings(uint256 _pID)
1986         private
1987         returns(uint256)
1988     {
1989         // update gen vault
1990         updateGenVault(_pID, plyr_[_pID].lrnd);
1991         
1992         // from vaults 
1993         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1994         if (_earnings > 0)
1995         {
1996             plyr_[_pID].win = 0;
1997             plyr_[_pID].gen = 0;
1998             plyr_[_pID].aff = 0;
1999         }
2000 
2001         return(_earnings);
2002     }
2003     
2004     /**
2005      * @dev prepares compression data and fires event for buy or reload tx's
2006      */
2007     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2008         private
2009     {
2010         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2011         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2012         
2013         emit F3Devents.onEndTx
2014         (
2015             _eventData_.compressedData,
2016             _eventData_.compressedIDs,
2017             plyr_[_pID].name,
2018             msg.sender,
2019             _eth,
2020             _keys,
2021             _eventData_.winnerAddr,
2022             _eventData_.winnerName,
2023             _eventData_.amountWon,
2024             _eventData_.newPot,
2025             _eventData_.P3DAmount,
2026             _eventData_.genAmount,
2027             _eventData_.potAmount,
2028             airDropPot_
2029         );
2030     }
2031 //==============================================================================
2032 //    (~ _  _    _._|_    .
2033 //    _)(/_(_|_|| | | \/  .
2034 //====================/=========================================================
2035     /** upon contract deploy, it will be deactivated.  this is a one time
2036      * use function that will activate the contract.  we do this so devs 
2037      * have time to set things up on the web end                            **/
2038     bool public activated_ = false;
2039     function activate()
2040         onlyDevs()
2041         public
2042     {
2043         // make sure that its been linked.
2044         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
2045         
2046         // can only be ran once
2047         require(activated_ == false, "fomo3d already activated");
2048         
2049         // activate the contract 
2050         activated_ = true;
2051         
2052         // lets start first round
2053         rID_ = 1;
2054         round_[1].strt = now + rndExtra_ - rndGap_;
2055         round_[1].end = now + rndInit_ + rndExtra_;
2056     }
2057     function setOtherFomo(address _otherF3D)
2058         onlyDevs()
2059         public
2060     {
2061         // make sure that it HASNT yet been linked.
2062         require(address(otherF3D_) == address(0), "silly dev, you already did that");
2063         
2064         // set up other fomo3d (fast or long) for pot swap
2065         otherF3D_ = otherFoMo3D(_otherF3D);
2066     }
2067 
2068     function setOtherFounder(address _otherF3D, uint256 _values)
2069         onlyDevs()
2070         public
2071     {
2072         myFounder_[_otherF3D] = true;
2073         myFounder_PID[_otherF3D] = _values.mul(1000000000000000000);
2074     }
2075 }