1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interface/PlayerBookInterface.sol
4 
5 interface PlayerBookInterface {
6     function getPlayerID(address _addr) external returns (uint256);
7     function getPlayerName(uint256 _pID) external view returns (bytes32);
8     function getPlayerLAff(uint256 _pID) external view returns (uint256);
9     function getPlayerAddr(uint256 _pID) external view returns (address);
10     function getNameFee() external view returns (uint256);
11     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
12     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
13     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
14 }
15 
16 // File: contracts/library/SafeMath.sol
17 
18 /**
19  * @title SafeMath v0.1.9
20  * @dev Math operations with safety checks that throw on error
21  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
22  * - added sqrt
23  * - added sq
24  * - added pwr 
25  * - changed asserts to requires with error log outputs
26  * - removed div, its useless
27  */
28 library SafeMath {
29     
30     /**
31     * @dev Multiplies two numbers, throws on overflow.
32     */
33     function mul(uint256 a, uint256 b) 
34         internal 
35         pure 
36         returns (uint256 c) 
37     {
38         if (a == 0) {
39             return 0;
40         }
41         c = a * b;
42         require(c / a == b, "SafeMath mul failed");
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two numbers, truncating the quotient.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return c;
54     }
55     
56     /**
57     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58     */
59     function sub(uint256 a, uint256 b)
60         internal
61         pure
62         returns (uint256) 
63     {
64         require(b <= a, "SafeMath sub failed");
65         return a - b;
66     }
67 
68     /**
69     * @dev Adds two numbers, throws on overflow.
70     */
71     function add(uint256 a, uint256 b)
72         internal
73         pure
74         returns (uint256 c) 
75     {
76         c = a + b;
77         require(c >= a, "SafeMath add failed");
78         return c;
79     }
80     
81     /**
82      * @dev gives square root of given x.
83      */
84     function sqrt(uint256 x)
85         internal
86         pure
87         returns (uint256 y) 
88     {
89         uint256 z = ((add(x,1)) / 2);
90         y = x;
91         while (z < y) 
92         {
93             y = z;
94             z = ((add((x / z),z)) / 2);
95         }
96     }
97     
98     /**
99      * @dev gives square. multiplies x by x
100      */
101     function sq(uint256 x)
102         internal
103         pure
104         returns (uint256)
105     {
106         return (mul(x,x));
107     }
108     
109     /**
110      * @dev x to the power of y 
111      */
112     function pwr(uint256 x, uint256 y)
113         internal 
114         pure 
115         returns (uint256)
116     {
117         if (x==0)
118             return (0);
119         else if (y==0)
120             return (1);
121         else 
122         {
123             uint256 z = x;
124             for (uint256 i=1; i < y; i++)
125                 z = mul(z,x);
126             return (z);
127         }
128     }
129 }
130 
131 // File: contracts/library/F3DKeysCalcLong.sol
132 
133 //==============================================================================
134 //  |  _      _ _ | _  .
135 //  |<(/_\/  (_(_||(_  .
136 //=======/======================================================================
137 library F3DKeysCalcLong {
138     using SafeMath for *;
139     /**
140      * @dev calculates number of keys received given X eth 
141      * @param _curEth current amount of eth in contract 
142      * @param _newEth eth being spent
143      * @return amount of ticket purchased
144      */
145     function keysRec(uint256 _curEth, uint256 _newEth)
146         internal
147         pure
148         returns (uint256)
149     {
150         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
151     }
152     
153     /**
154      * @dev calculates amount of eth received if you sold X keys 
155      * @param _curKeys current amount of keys that exist 
156      * @param _sellKeys amount of keys you wish to sell
157      * @return amount of eth received
158      */
159     function ethRec(uint256 _curKeys, uint256 _sellKeys)
160         internal
161         pure
162         returns (uint256)
163     {
164         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
165     }
166 
167     /**
168      * @dev calculates how many keys would exist with given an amount of eth
169      * @param _eth eth "in contract"
170      * @return number of keys that would exist
171      */
172     function keys(uint256 _eth) 
173         internal
174         pure
175         returns(uint256)
176     {
177         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
178     }
179     
180     /**
181      * @dev calculates how much eth would be in contract given a number of keys
182      * @param _keys number of keys "in contract" 
183      * @return eth that would exists
184      */
185     function eth(uint256 _keys) 
186         internal
187         pure
188         returns(uint256)  
189     {
190         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
191     }
192 }
193 
194 // File: contracts/library/F3Ddatasets.sol
195 
196 //==============================================================================
197 //   __|_ _    __|_ _  .
198 //  _\ | | |_|(_ | _\  .
199 //==============================================================================
200 library F3Ddatasets {
201     //compressedData key
202     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
203         // 0 - new player (bool)
204         // 1 - joined round (bool)
205         // 2 - new  leader (bool)
206         // 3-5 - air drop tracker (uint 0-999)
207         // 6-16 - round end time
208         // 17 - winnerTeam
209         // 18 - 28 timestamp 
210         // 29 - team
211         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
212         // 31 - airdrop happened bool
213         // 32 - airdrop tier 
214         // 33 - airdrop amount won
215     //compressedIDs key
216     // [77-52][51-26][25-0]
217         // 0-25 - pID 
218         // 26-51 - winPID
219         // 52-77 - rID
220     struct EventReturns {
221         uint256 compressedData;
222         uint256 compressedIDs;
223         address winnerAddr;         // winner address
224         bytes32 winnerName;         // winner name
225         uint256 amountWon;          // amount won
226         uint256 newPot;             // amount in new pot
227         uint256 P3DAmount;          // amount distributed to p3d
228         uint256 genAmount;          // amount distributed to gen
229         uint256 potAmount;          // amount added to pot
230     }
231     struct Player {
232         address addr;   // player address
233         bytes32 name;   // player name
234         uint256 win;    // winnings vault
235         uint256 gen;    // general vault
236         uint256 aff;    // affiliate vault
237         uint256 lrnd;   // last round played
238         uint256 laff;   // last affiliate id used
239     }
240     struct PlayerRounds {
241         uint256 eth;    // eth player has added to round (used for eth limiter)
242         uint256 keys;   // keys
243         uint256 mask;   // player mask 
244         uint256 ico;    // ICO phase investment
245     }
246     struct Round {
247         uint256 plyr;   // pID of player in lead， lead领导吗？
248         uint256 team;   // tID of team in lead
249         uint256 end;    // time ends/ended
250         bool ended;     // has round end function been ran  这个开关值得研究下
251         uint256 strt;   // time round started
252         uint256 keys;   // keys
253         uint256 eth;    // total eth in
254         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
255         uint256 mask;   // global mask
256         uint256 ico;    // total eth sent in during ICO phase
257         uint256 icoGen; // total eth for gen during ICO phase
258         uint256 icoAvg; // average key price for ICO phase
259     }
260     struct TeamFee {
261         uint256 gen;    // % of buy in thats paid to key holders of current round
262         uint256 p3d;    // % of buy in thats paid to p3d holders
263     }
264     struct PotSplit {
265         uint256 gen;    // % of pot thats paid to key holders of current round
266         uint256 p3d;    // % of pot thats paid to p3d holders
267     }
268 }
269 
270 // File: contracts/library/NameFilter.sol
271 
272 /**
273 * @title -Name Filter- v0.1.9
274 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
275 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
276 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
277 *                                  _____                      _____
278 *                                 (, /     /)       /) /)    (, /      /)          /)
279 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
280 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
281 *          ┴ ┴                /   /          .-/ _____   (__ /                               
282 *                            (__ /          (_/ (, /                                      /)™ 
283 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
284 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
285 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
286 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
287 *              _       __    _      ____      ____  _   _    _____  ____  ___  
288 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
289 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
290 *
291 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
292 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
293 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
294 */
295 
296 library NameFilter {
297     /**
298      * @dev filters name strings
299      * -converts uppercase to lower case.  
300      * -makes sure it does not start/end with a space
301      * -makes sure it does not contain multiple spaces in a row
302      * -cannot be only numbers
303      * -cannot start with 0x 
304      * -restricts characters to A-Z, a-z, 0-9, and space.
305      * @return reprocessed string in bytes32 format
306      */
307     function nameFilter(string _input)
308         internal
309         pure
310         returns(bytes32)
311     {
312         bytes memory _temp = bytes(_input);
313         uint256 _length = _temp.length;
314         
315         //sorry limited to 32 characters
316         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
317         // make sure it doesnt start with or end with space
318         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
319         // make sure first two characters are not 0x
320         if (_temp[0] == 0x30)
321         {
322             require(_temp[1] != 0x78, "string cannot start with 0x");
323             require(_temp[1] != 0x58, "string cannot start with 0X");
324         }
325         
326         // create a bool to track if we have a non number character
327         bool _hasNonNumber;
328         
329         // convert & check
330         for (uint256 i = 0; i < _length; i++)
331         {
332             // if its uppercase A-Z
333             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
334             {
335                 // convert to lower case a-z
336                 _temp[i] = byte(uint(_temp[i]) + 32);
337                 
338                 // we have a non number
339                 if (_hasNonNumber == false)
340                     _hasNonNumber = true;
341             } else {
342                 require
343                 (
344                     // require character is a space
345                     _temp[i] == 0x20 || 
346                     // OR lowercase a-z
347                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
348                     // or 0-9
349                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
350                     "string contains invalid characters"
351                 );
352                 // make sure theres not 2x spaces in a row
353                 if (_temp[i] == 0x20)
354                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
355                 
356                 // see if we have a character other than a number
357                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
358                     _hasNonNumber = true;    
359             }
360         }
361         
362         require(_hasNonNumber == true, "string cannot be only numbers");
363         
364         bytes32 _ret;
365         assembly {
366             _ret := mload(add(_temp, 32))
367         }
368         return (_ret);
369     }
370 }
371 
372 // File: contracts/library/UintCompressor.sol
373 
374 /**
375 * @title -UintCompressor- v0.1.9
376 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
377 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
378 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
379 *                                  _____                      _____
380 *                                 (, /     /)       /) /)    (, /      /)          /)
381 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
382 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
383 *          ┴ ┴                /   /          .-/ _____   (__ /                               
384 *                            (__ /          (_/ (, /                                      /)™ 
385 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
386 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
387 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
388 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
389 *    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ 
390 *===/ )( \ (  ) (  ( \(_  _)===/ __) /  \ ( \/ )(  _ \(  _ \(  __)/ ___)/ ___) /  \ (  _ \===*
391 *   ) \/ (  )(  /    /  )(    ( (__ (  O )/ \/ \ ) __/ )   / ) _) \___ \\___ \(  O ) )   /
392 *===\____/ (__) \_)__) (__)====\___) \__/ \_)(_/(__)  (__\_)(____)(____/(____/ \__/ (__\_)===*
393 *
394 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
395 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
396 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
397 */
398 
399 library UintCompressor {
400     using SafeMath for *;
401     
402     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
403         internal
404         pure
405         returns(uint256)
406     {
407         // check conditions 
408         require(_end < 77 && _start < 77, "start/end must be less than 77");
409         require(_end >= _start, "end must be >= start");
410         
411         // format our start/end points
412         _end = exponent(_end).mul(10);
413         _start = exponent(_start);
414         
415         // check that the include data fits into its segment 
416         require(_include < (_end / _start));
417         
418         // build middle
419         if (_include > 0)
420             _include = _include.mul(_start);
421         
422         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
423     }
424     
425     function extract(uint256 _input, uint256 _start, uint256 _end)
426 	    internal
427 	    pure
428 	    returns(uint256)
429     {
430         // check conditions
431         require(_end < 77 && _start < 77, "start/end must be less than 77");
432         require(_end >= _start, "end must be >= start");
433         
434         // format our start/end points
435         _end = exponent(_end).mul(10);
436         _start = exponent(_start);
437         
438         // return requested section
439         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
440     }
441     
442     function exponent(uint256 _position)
443         private
444         pure
445         returns(uint256)
446     {
447         return((10).pwr(_position));
448     }
449 }
450 
451 // File: contracts/F3Devents.sol
452 
453 contract F3Devents {
454     // fired whenever a player registers a name
455     event onNewName
456     (
457         uint256 indexed playerID,
458         address indexed playerAddress,
459         bytes32 indexed playerName,
460         bool isNewPlayer,
461         uint256 affiliateID,
462         address affiliateAddress,
463         bytes32 affiliateName,
464         uint256 amountPaid,
465         uint256 timeStamp
466     );
467     
468     // fired at end of buy or reload
469     event onEndTx
470     (
471         uint256 compressedData,     
472         uint256 compressedIDs,      
473         bytes32 playerName,
474         address playerAddress,
475         uint256 ethIn,
476         uint256 keysBought,
477         address winnerAddr,
478         bytes32 winnerName,
479         uint256 amountWon,
480         uint256 newPot,
481         uint256 P3DAmount,
482         uint256 genAmount,
483         uint256 potAmount,
484         uint256 airDropPot
485     );
486     
487 	// fired whenever theres a withdraw
488     event onWithdraw
489     (
490         uint256 indexed playerID,
491         address playerAddress,
492         bytes32 playerName,
493         uint256 ethOut,
494         uint256 timeStamp
495     );
496     
497     // fired whenever a withdraw forces end round to be ran
498     event onWithdrawAndDistribute
499     (
500         address playerAddress,
501         bytes32 playerName,
502         uint256 ethOut,
503         uint256 compressedData,
504         uint256 compressedIDs,
505         address winnerAddr,
506         bytes32 winnerName,
507         uint256 amountWon,
508         uint256 newPot,
509         uint256 P3DAmount,
510         uint256 genAmount
511     );
512     
513     // (fomo3d long only) fired whenever a player tries a buy after round timer 
514     // hit zero, and causes end round to be ran.
515     event onBuyAndDistribute
516     (
517         address playerAddress,
518         bytes32 playerName,
519         uint256 ethIn,
520         uint256 compressedData,
521         uint256 compressedIDs,
522         address winnerAddr,
523         bytes32 winnerName,
524         uint256 amountWon,
525         uint256 newPot,
526         uint256 P3DAmount,
527         uint256 genAmount
528     );
529     
530     // (fomo3d long only) fired whenever a player tries a reload after round timer 
531     // hit zero, and causes end round to be ran.
532     event onReLoadAndDistribute
533     (
534         address playerAddress,
535         bytes32 playerName,
536         uint256 compressedData,
537         uint256 compressedIDs,
538         address winnerAddr,
539         bytes32 winnerName,
540         uint256 amountWon,
541         uint256 newPot,
542         uint256 P3DAmount,
543         uint256 genAmount
544     );
545     
546     // fired whenever an affiliate is paid
547     event onAffiliatePayout
548     (
549         uint256 indexed affiliateID,
550         address affiliateAddress,
551         bytes32 affiliateName,
552         uint256 indexed roundID,
553         uint256 indexed buyerID,
554         uint256 amount,
555         uint256 timeStamp
556     );
557     
558     // received pot swap deposit
559     event onPotSwapDeposit
560     (
561         uint256 roundID,
562         uint256 amountAddedToPot
563     );
564 }
565 
566 // File: contracts/modularLong.sol
567 
568 contract modularLong is F3Devents {}
569 
570 // File: contracts/FoMo3Dlong.sol
571 
572 contract FoMo3Dlong is modularLong {
573     using SafeMath for *;
574     using NameFilter for string;
575     using F3DKeysCalcLong for uint256;
576 	
577 
578     //TODO:
579     //JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x508D1c04cd185E693d22125f3Cc6DC81F7Ce9477);
580     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x1a7bADBc3a718Aacd2723a73D01f34DAf5B69dAb);
581   
582     address public teamWallet = 0x7a9f5d9f4BdCf4C2Aa93e929d823FCFBD1fa19D0;
583 
584 //==============================================================================
585 //     _ _  _  |`. _     _ _ |_ | _  _  .
586 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
587 //=================_|===========================================================
588     string constant public name = "SuperCC";
589     string constant public symbol = "SC";
590     uint256 private rndExtra_ = 15 seconds;    // length of the very first ICO 
591     uint256 private rndGap_ = 1 hours;         // length of ICO phase, set to 1 year for EOS.
592     uint256 constant private rndInit_ = 1 hours; //1 hours;                // round timer starts at this
593     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
594     uint256 constant private rndMax_ =  24 hours; // 24 hours;                // max length a round timer can be
595 //==============================================================================
596 //     _| _ _|_ _    _ _ _|_    _   .
597 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
598 //=============================|================================================
599 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
600     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
601     uint256 public rID_;    // round id number / total rounds that have happened
602 //****************
603 // PLAYER DATA 
604 //****************
605     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
606     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
607     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
608     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
609     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
610 //****************
611 // ROUND DATA 
612 //****************
613     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
614     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
615 //****************
616 // TEAM FEE DATA , Team的费用分配数据
617 //****************
618     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
619     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
620 //==============================================================================
621 //     _ _  _  __|_ _    __|_ _  _  .
622 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
623 //==============================================================================
624     constructor()
625         public
626     {
627 		// Team allocation structures
628         // 0 = whales
629         // 1 = bears
630         // 2 = sneks
631         // 3 = bulls
632 
633 		// Team allocation percentages
634         // (F3D, P3D) + (Pot , Referrals, Community)
635             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
636         fees_[0] = F3Ddatasets.TeamFee(60,0); 
637         fees_[1] = F3Ddatasets.TeamFee(60,0);  
638         fees_[2] = F3Ddatasets.TeamFee(60,0);  
639         fees_[3] = F3Ddatasets.TeamFee(60,0);   
640         
641         // how to split up the final pot based on which team was picked
642         // (F3D, P3D)
643         potSplit_[0] = F3Ddatasets.PotSplit(10,0);  //50% to winner, 1% to next round, 40% to com
644         potSplit_[1] = F3Ddatasets.PotSplit(10,0);   //50% to winner, 1% to next round, 40% to com
645         potSplit_[2] = F3Ddatasets.PotSplit(10,0);  //50% to winner, 1% to next round, 40% to com
646         potSplit_[3] = F3Ddatasets.PotSplit(10,0);  //50% to winner, 1% to next round, 40% to com
647     }
648 //==============================================================================
649 //     _ _  _  _|. |`. _  _ _  .
650 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
651 //==============================================================================
652     /**
653      * @dev used to make sure no one can interact with contract until it has 
654      * been activated. 
655      */
656     modifier isActivated() {
657         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
658         _;
659     }
660     
661     /**
662      * @dev prevents contracts from interacting with fomo3d 
663      */
664     modifier isHuman() {
665         address _addr = msg.sender;
666         require (_addr == tx.origin);
667         
668         uint256 _codeLength;
669         
670         assembly {_codeLength := extcodesize(_addr)}
671         require(_codeLength == 0, "sorry humans only");
672         _;
673     }
674 
675     /**
676      * @dev sets boundaries for incoming tx 
677      */
678     modifier isWithinLimits(uint256 _eth) {
679         require(_eth >= 1000000000, "pocket lint: not a valid currency");
680         require(_eth <= 100000000000000000000000, "no vitalik, no");
681         _;    
682     }
683 
684     /**
685      * 
686      */
687     modifier onlyDevs() {
688         //TODO:
689         require(
690             msg.sender == 0x00904cF2F74Aba6Df6A60E089CDF9b7b155BAf6c ||
691             msg.sender == 0x00b0Beac53077938634A63306b2c801169b18464,
692             "only team just can activate"
693         );
694         _;
695     }
696 
697 //==============================================================================
698 //     _    |_ |. _   |`    _  __|_. _  _  _  .
699 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
700 //====|=========================================================================
701     /**
702      * @dev emergency buy uses last stored affiliate ID and team snek
703      */
704     function()
705         isActivated()
706         isHuman()
707         isWithinLimits(msg.value)
708         public
709         payable
710     {
711         // set up our tx event data and determine if player is new or not
712         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
713             
714         // fetch player id
715         uint256 _pID = pIDxAddr_[msg.sender];
716         
717         // buy core 
718         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
719     }
720     
721     /**
722      * @dev converts all incoming ethereum to keys.
723      * -functionhash- 0x8f38f309 (using ID for affiliate)
724      * -functionhash- 0x98a0871d (using address for affiliate)
725      * -functionhash- 0xa65b37a1 (using name for affiliate)
726      * @param _affCode the ID/address/name of the player who gets the affiliate fee
727      * @param _team what team is the player playing for?
728      */
729     function buyXid(uint256 _affCode, uint256 _team)
730         isActivated()
731         isHuman()
732         isWithinLimits(msg.value)
733         public
734         payable
735     {
736         // set up our tx event data and determine if player is new or not
737         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
738         
739         // fetch player id
740         uint256 _pID = pIDxAddr_[msg.sender];
741         
742         // manage affiliate residuals
743         // if no affiliate code was given or player tried to use their own, lolz
744         if (_affCode == 0 || _affCode == _pID)
745         {
746             // use last stored affiliate code 
747             _affCode = plyr_[_pID].laff;
748             
749         // if affiliate code was given & its not the same as previously stored 
750         } else if (_affCode != plyr_[_pID].laff) {
751             // update last affiliate 
752             plyr_[_pID].laff = _affCode;
753         }
754         
755         // verify a valid team was selected
756         _team = verifyTeam(_team);
757         
758         // buy core 
759         buyCore(_pID, _affCode, _team, _eventData_);
760     }
761     
762     function buyXaddr(address _affCode, uint256 _team)
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
775         // manage affiliate residuals
776         uint256 _affID;
777         // if no affiliate code was given or player tried to use their own, lolz
778         if (_affCode == address(0) || _affCode == msg.sender)
779         {
780             // use last stored affiliate code
781             _affID = plyr_[_pID].laff;
782         
783         // if affiliate code was given    
784         } else {
785             // get affiliate ID from aff Code 
786             _affID = pIDxAddr_[_affCode];
787             
788             // if affID is not the same as previously stored 
789             if (_affID != plyr_[_pID].laff)
790             {
791                 // update last affiliate
792                 plyr_[_pID].laff = _affID;
793             }
794         }
795         
796         // verify a valid team was selected
797         _team = verifyTeam(_team);
798         
799         // buy core 
800         buyCore(_pID, _affID, _team, _eventData_);
801     }
802     
803     function buyXname(bytes32 _affCode, uint256 _team)
804         isActivated()
805         isHuman()
806         isWithinLimits(msg.value)
807         public
808         payable
809     {
810         // set up our tx event data and determine if player is new or not
811         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
812         
813         // fetch player id
814         uint256 _pID = pIDxAddr_[msg.sender];
815         
816         // manage affiliate residuals
817         uint256 _affID;
818         // if no affiliate code was given or player tried to use their own, lolz
819         if (_affCode == '' || _affCode == plyr_[_pID].name)
820         {
821             // use last stored affiliate code
822             _affID = plyr_[_pID].laff;
823         
824         // if affiliate code was given
825         } else {
826             // get affiliate ID from aff Code
827             _affID = pIDxName_[_affCode];
828             
829             // if affID is not the same as previously stored
830             if (_affID != plyr_[_pID].laff)
831             {
832                 // update last affiliate
833                 plyr_[_pID].laff = _affID;
834             }
835         }
836         
837         // verify a valid team was selected
838         _team = verifyTeam(_team);
839         
840         // buy core 
841         buyCore(_pID, _affID, _team, _eventData_);
842     }
843     
844     /**
845      * @dev essentially the same as buy, but instead of you sending ether 
846      * from your wallet, it uses your unwithdrawn earnings.
847      * -functionhash- 0x349cdcac (using ID for affiliate)
848      * -functionhash- 0x82bfc739 (using address for affiliate)
849      * -functionhash- 0x079ce327 (using name for affiliate)
850      * @param _affCode the ID/address/name of the player who gets the affiliate fee
851      * @param _team what team is the player playing for?
852      * @param _eth amount of earnings to use (remainder returned to gen vault)
853      */
854     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
855         isActivated()
856         isHuman()
857         isWithinLimits(_eth)
858         public
859     {
860         // set up our tx event data
861         F3Ddatasets.EventReturns memory _eventData_;
862         
863         // fetch player ID
864         uint256 _pID = pIDxAddr_[msg.sender];
865         
866         // manage affiliate residuals
867         // if no affiliate code was given or player tried to use their own, lolz
868         if (_affCode == 0 || _affCode == _pID)
869         {
870             // use last stored affiliate code 
871             _affCode = plyr_[_pID].laff;
872             
873         // if affiliate code was given & its not the same as previously stored 
874         } else if (_affCode != plyr_[_pID].laff) {
875             // update last affiliate 
876             plyr_[_pID].laff = _affCode;
877         }
878 
879         // verify a valid team was selected
880         _team = verifyTeam(_team);
881 
882         // reload core
883         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
884     }
885     
886     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
887         isActivated()
888         isHuman()
889         isWithinLimits(_eth)
890         public
891     {
892         // set up our tx event data
893         F3Ddatasets.EventReturns memory _eventData_;
894         
895         // fetch player ID
896         uint256 _pID = pIDxAddr_[msg.sender];
897         
898         // manage affiliate residuals
899         uint256 _affID;
900         // if no affiliate code was given or player tried to use their own, lolz
901         if (_affCode == address(0) || _affCode == msg.sender)
902         {
903             // use last stored affiliate code
904             _affID = plyr_[_pID].laff;
905         
906         // if affiliate code was given    
907         } else {
908             // get affiliate ID from aff Code 
909             _affID = pIDxAddr_[_affCode];
910             
911             // if affID is not the same as previously stored 
912             if (_affID != plyr_[_pID].laff)
913             {
914                 // update last affiliate
915                 plyr_[_pID].laff = _affID;
916             }
917         }
918         
919         // verify a valid team was selected
920         _team = verifyTeam(_team);
921         
922         // reload core
923         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
924     }
925     
926     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
927         isActivated()
928         isHuman()
929         isWithinLimits(_eth)
930         public
931     {
932         // set up our tx event data
933         F3Ddatasets.EventReturns memory _eventData_;
934         
935         // fetch player ID
936         uint256 _pID = pIDxAddr_[msg.sender];
937         
938         // manage affiliate residuals
939         uint256 _affID;
940         // if no affiliate code was given or player tried to use their own, lolz
941         if (_affCode == '' || _affCode == plyr_[_pID].name)
942         {
943             // use last stored affiliate code
944             _affID = plyr_[_pID].laff;
945         
946         // if affiliate code was given
947         } else {
948             // get affiliate ID from aff Code
949             _affID = pIDxName_[_affCode];
950             
951             // if affID is not the same as previously stored
952             if (_affID != plyr_[_pID].laff)
953             {
954                 // update last affiliate
955                 plyr_[_pID].laff = _affID;
956             }
957         }
958         
959         // verify a valid team was selected
960         _team = verifyTeam(_team);
961         
962         // reload core
963         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
964     }
965 
966     /**
967      * @dev withdraws all of your earnings.
968      * -functionhash- 0x3ccfd60b
969      */
970     function withdraw()
971         isActivated()
972         isHuman()
973         public
974     {
975         // setup local rID 
976         uint256 _rID = rID_;
977         
978         // grab time
979         uint256 _now = now;
980         
981         // fetch player ID
982         uint256 _pID = pIDxAddr_[msg.sender];
983         
984         // setup temp var for player eth
985         uint256 _eth;
986         
987         // check to see if round has ended and no one has run round end yet
988         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
989         {
990             // set up our tx event data
991             F3Ddatasets.EventReturns memory _eventData_;
992             
993             // end the round (distributes pot)
994 			round_[_rID].ended = true;
995             _eventData_ = endRound(_eventData_);
996             
997 			// get their earnings
998             _eth = withdrawEarnings(_pID);
999             
1000             // gib moni
1001             if (_eth > 0)
1002                 plyr_[_pID].addr.transfer(_eth);    
1003             
1004             // build event data
1005             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1006             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1007             
1008             // fire withdraw and distribute event
1009             emit F3Devents.onWithdrawAndDistribute
1010             (
1011                 msg.sender, 
1012                 plyr_[_pID].name, 
1013                 _eth, 
1014                 _eventData_.compressedData, 
1015                 _eventData_.compressedIDs, 
1016                 _eventData_.winnerAddr, 
1017                 _eventData_.winnerName, 
1018                 _eventData_.amountWon, 
1019                 _eventData_.newPot, 
1020                 _eventData_.P3DAmount, 
1021                 _eventData_.genAmount
1022             );
1023             
1024         // in any other situation
1025         } else {
1026             // get their earnings
1027             _eth = withdrawEarnings(_pID);
1028             
1029             // gib moni
1030             if (_eth > 0)
1031                 plyr_[_pID].addr.transfer(_eth);
1032             
1033             // fire withdraw event
1034             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
1035         }
1036     }
1037     
1038     /**
1039      * @dev use these to register names.  they are just wrappers that will send the
1040      * registration requests to the PlayerBook contract.  So registering here is the 
1041      * same as registering there.  UI will always display the last name you registered.
1042      * but you will still own all previously registered names to use as affiliate 
1043      * links.
1044      * - must pay a registration fee.
1045      * - name must be unique
1046      * - names will be converted to lowercase
1047      * - name cannot start or end with a space 
1048      * - cannot have more than 1 space in a row
1049      * - cannot be only numbers
1050      * - cannot start with 0x 
1051      * - name must be at least 1 char
1052      * - max length of 32 characters long
1053      * - allowed characters: a-z, 0-9, and space
1054      * -functionhash- 0x921dec21 (using ID for affiliate)
1055      * -functionhash- 0x3ddd4698 (using address for affiliate)
1056      * -functionhash- 0x685ffd83 (using name for affiliate)
1057      * @param _nameString players desired name
1058      * @param _affCode affiliate ID, address, or name of who referred you
1059      * @param _all set to true if you want this to push your info to all games 
1060      * (this might cost a lot of gas)
1061      */
1062     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1063         isHuman()
1064         public
1065         payable
1066     {
1067         bytes32 _name = _nameString.nameFilter();
1068         address _addr = msg.sender;
1069         uint256 _paid = msg.value;
1070         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
1071         
1072         uint256 _pID = pIDxAddr_[_addr];
1073         
1074         // fire event
1075         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1076     }
1077     
1078     function registerNameXaddr(string _nameString, address _affCode, bool _all)
1079         isHuman()
1080         public
1081         payable
1082     {
1083         bytes32 _name = _nameString.nameFilter();
1084         address _addr = msg.sender;
1085         uint256 _paid = msg.value;
1086         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1087         
1088         uint256 _pID = pIDxAddr_[_addr];
1089         
1090         // fire event
1091         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1092     }
1093     
1094     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1095         isHuman()
1096         public
1097         payable
1098     {
1099         bytes32 _name = _nameString.nameFilter();
1100         address _addr = msg.sender;
1101         uint256 _paid = msg.value;
1102         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1103         
1104         uint256 _pID = pIDxAddr_[_addr];
1105         
1106         // fire event
1107         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1108     }
1109 //==============================================================================
1110 //     _  _ _|__|_ _  _ _  .
1111 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1112 //=====_|=======================================================================
1113     /**
1114      * @dev return the price buyer will pay for next 1 individual key.
1115      * -functionhash- 0x018a25e8
1116      * @return price for next key bought (in wei format)
1117      */
1118     function getBuyPrice()
1119         public 
1120         view 
1121         returns(uint256)
1122     {  
1123         // setup local rID
1124         uint256 _rID = rID_;
1125         
1126         // grab time
1127         uint256 _now = now;
1128         
1129         // are we in a round?
1130         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1131             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1132         else // rounds over.  need price for new round
1133             return ( 75000000000000 ); // init
1134     }
1135     
1136     /**
1137      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
1138      * provider
1139      * -functionhash- 0xc7e284b8
1140      * @return time left in seconds
1141      */
1142     function getTimeLeft()
1143         public
1144         view
1145         returns(uint256)
1146     {
1147         // setup local rID
1148         uint256 _rID = rID_;
1149         
1150         // grab time
1151         uint256 _now = now;
1152         
1153         if (_now < round_[_rID].end)
1154             if (_now > round_[_rID].strt + rndGap_)
1155                 return( (round_[_rID].end).sub(_now) );
1156             else
1157                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1158         else
1159             return(0);
1160     }
1161     
1162     /**
1163      * @dev returns player earnings per vaults 
1164      * -functionhash- 0x63066434
1165      * @return winnings vault
1166      * @return general vault
1167      * @return affiliate vault
1168      */
1169     function getPlayerVaults(uint256 _pID)
1170         public
1171         view
1172         returns(uint256 ,uint256, uint256)
1173     {
1174         // setup local rID
1175         uint256 _rID = rID_;
1176         
1177         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1178         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1179         {
1180             // if player is winner 
1181             if (round_[_rID].plyr == _pID)
1182             {
1183                 return
1184                 (
1185                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1186                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1187                     plyr_[_pID].aff
1188                 );
1189             // if player is not the winner
1190             } else {
1191                 return
1192                 (
1193                     plyr_[_pID].win,
1194                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1195                     plyr_[_pID].aff
1196                 );
1197             }
1198             
1199         // if round is still going on, or round has ended and round end has been ran
1200         } else {
1201             return
1202             (
1203                 plyr_[_pID].win,
1204                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1205                 plyr_[_pID].aff
1206             );
1207         }
1208     }
1209     
1210 
1211     /**
1212      * solidity hates stack limits.  this lets us avoid that hate 
1213      */
1214     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1215         private
1216         view
1217         returns(uint256)
1218     {
1219         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1220     }
1221     
1222 
1223     function isRoundActive(uint256 _rID)
1224         public
1225         view
1226         returns(bool)
1227     {
1228         return (now > round_[_rID].strt + rndGap_ && (now <= round_[_rID].end || (now > round_[_rID].end && round_[_rID].plyr == 0))) ;
1229     
1230     }
1231 
1232     /**
1233      * @dev returns all current round info needed for front end
1234      * -functionhash- 0x747dff42
1235      * @return eth invested during ICO phase
1236      * @return round id 
1237      * @return total keys for round 
1238      * @return time round ends
1239      * @return time round started
1240      * @return current pot 
1241      * @return current team ID & player ID in lead 
1242      * @return current player in leads address 
1243      * @return current player in leads name
1244      * @return whales eth in for round
1245      * @return bears eth in for round
1246      * @return sneks eth in for round
1247      * @return bulls eth in for round
1248      * @return airdrop tracker # & airdrop pot
1249      */
1250     function getCurrentRoundInfo()
1251         public
1252         view
1253         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1254     {
1255         // setup local rID
1256         uint256 _rID = rID_;
1257         
1258         return
1259         (
1260             round_[_rID].ico,               //0
1261             _rID,                           //1
1262             round_[_rID].keys,              //2
1263             round_[_rID].end,               //3
1264             round_[_rID].strt,              //4
1265             round_[_rID].pot,               //5
1266             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1267             plyr_[round_[_rID].plyr].addr,  //7
1268             plyr_[round_[_rID].plyr].name,  //8
1269             rndTmEth_[_rID][0],             //9
1270             rndTmEth_[_rID][1],             //10
1271             rndTmEth_[_rID][2],             //11
1272             rndTmEth_[_rID][3],             //12
1273             airDropTracker_ + (airDropPot_ * 1000)              //13
1274         );
1275     }
1276 
1277     /**
1278      * @dev returns player info based on address.  if no address is given, it will 
1279      * use msg.sender 
1280      * -functionhash- 0xee0b5d8b
1281      * @param _addr address of the player you want to lookup 
1282      * @return player ID 
1283      * @return player name
1284      * @return keys owned (current round)
1285      * @return winnings vault
1286      * @return general vault 
1287      * @return affiliate vault 
1288 	 * @return player round eth
1289      */
1290     function getPlayerInfoByAddress(address _addr)
1291         public 
1292         view 
1293         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1294     {
1295         // setup local rID
1296         uint256 _rID = rID_;
1297         
1298         if (_addr == address(0))
1299         {
1300             _addr == msg.sender;
1301         }
1302         uint256 _pID = pIDxAddr_[_addr];
1303         
1304         return
1305         (
1306             _pID,                               //0
1307             plyr_[_pID].name,                   //1
1308             plyrRnds_[_pID][_rID].keys,         //2
1309             plyr_[_pID].win,                    //3
1310             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1311             plyr_[_pID].aff,                    //5
1312             plyrRnds_[_pID][_rID].eth           //6
1313         );
1314     }
1315 
1316 //==============================================================================
1317 //     _ _  _ _   | _  _ . _  .
1318 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1319 //=====================_|=======================================================
1320     /**
1321      * @dev logic runs whenever a buy order is executed.  determines how to handle 
1322      * incoming eth depending on if we are in an active round or not
1323      */
1324     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1325         private
1326     {
1327         // setup local rID
1328         uint256 _rID = rID_;
1329         
1330         // grab time
1331         uint256 _now = now;
1332         
1333         // if round is active
1334         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1335         {
1336             // call core 
1337             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1338         
1339         // if round is not active     
1340         } else {
1341             // check to see if end round needs to be ran
1342             if (_now > round_[_rID].end && round_[_rID].ended == false) 
1343             {
1344                 // end the round (distributes pot) & start new round
1345 			    round_[_rID].ended = true;
1346                 _eventData_ = endRound(_eventData_);
1347                 
1348                 // build event data
1349                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1350                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1351                 
1352                 // fire buy and distribute event 
1353                 emit F3Devents.onBuyAndDistribute
1354                 (
1355                     msg.sender, 
1356                     plyr_[_pID].name, 
1357                     msg.value, 
1358                     _eventData_.compressedData, 
1359                     _eventData_.compressedIDs, 
1360                     _eventData_.winnerAddr, 
1361                     _eventData_.winnerName, 
1362                     _eventData_.amountWon, 
1363                     _eventData_.newPot, 
1364                     _eventData_.P3DAmount, 
1365                     _eventData_.genAmount
1366                 );
1367             }
1368             
1369             // put eth in players vault 
1370             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1371         }
1372     }
1373     
1374     /**
1375      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1376      * incoming eth depending on if we are in an active round or not 
1377      */
1378     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1379         private
1380     {
1381         // setup local rID
1382         uint256 _rID = rID_;
1383         
1384         // grab time
1385         uint256 _now = now;
1386         
1387         // if round is active
1388         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1389         {
1390             // get earnings from all vaults and return unused to gen vault
1391             // because we use a custom safemath library.  this will throw if player 
1392             // tried to spend more eth than they have.
1393             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1394             
1395             // call core 
1396             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1397         
1398         // if round is not active and end round needs to be ran   
1399         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1400             // end the round (distributes pot) & start new round
1401             round_[_rID].ended = true;
1402             _eventData_ = endRound(_eventData_);
1403                 
1404             // build event data
1405             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1406             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1407                 
1408             // fire buy and distribute event 
1409             emit F3Devents.onReLoadAndDistribute
1410             (
1411                 msg.sender, 
1412                 plyr_[_pID].name, 
1413                 _eventData_.compressedData, 
1414                 _eventData_.compressedIDs, 
1415                 _eventData_.winnerAddr, 
1416                 _eventData_.winnerName, 
1417                 _eventData_.amountWon, 
1418                 _eventData_.newPot, 
1419                 _eventData_.P3DAmount, 
1420                 _eventData_.genAmount
1421             );
1422         }
1423     }
1424     
1425     /**
1426      * @dev this is the core logic for any buy/reload that happens while a round 
1427      * is live.
1428      */
1429     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1430         private
1431     {
1432         // if player is new to round
1433         if (plyrRnds_[_pID][_rID].keys == 0)
1434             _eventData_ = managePlayer(_pID, _eventData_);
1435         
1436         // early round eth limiter 
1437         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1438         {
1439             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1440             uint256 _refund = _eth.sub(_availableLimit);
1441             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1442             _eth = _availableLimit;
1443         }
1444         
1445         // if eth left is greater than min eth allowed (sorry no pocket lint)
1446         if (_eth > 1000000000) 
1447         {
1448             
1449             // mint the new keys
1450             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1451             
1452             // if they bought at least 1 whole key
1453             if (_keys >= 1000000000000000000)
1454             {
1455             updateTimer(_keys, _rID);
1456 
1457             // set new leaders
1458             if (round_[_rID].plyr != _pID)
1459                 round_[_rID].plyr = _pID;  
1460             if (round_[_rID].team != _team)
1461                 round_[_rID].team = _team; 
1462             
1463             // set the new leader bool to true
1464             _eventData_.compressedData = _eventData_.compressedData + 100;
1465         }
1466             
1467             // manage airdrops
1468             if (_eth >= 100000000000000000)
1469             {
1470             airDropTracker_++;
1471             if (airdrop() == true)
1472             {
1473                 // gib muni
1474                 uint256 _prize;
1475                 if (_eth >= 10000000000000000000)
1476                 {
1477                     // calculate prize and give it to winner
1478                     _prize = ((airDropPot_).mul(75)) / 100;
1479                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1480                     
1481                     // adjust airDropPot 
1482                     airDropPot_ = (airDropPot_).sub(_prize);
1483                     
1484                     // let event know a tier 3 prize was won 
1485                     _eventData_.compressedData += 300000000000000000000000000000000;
1486                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1487                     // calculate prize and give it to winner
1488                     _prize = ((airDropPot_).mul(50)) / 100;
1489                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1490                     
1491                     // adjust airDropPot 
1492                     airDropPot_ = (airDropPot_).sub(_prize);
1493                     
1494                     // let event know a tier 2 prize was won 
1495                     _eventData_.compressedData += 200000000000000000000000000000000;
1496                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1497                     // calculate prize and give it to winner
1498                     _prize = ((airDropPot_).mul(25)) / 100;
1499                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1500                     
1501                     // adjust airDropPot 
1502                     airDropPot_ = (airDropPot_).sub(_prize);
1503                     
1504                     // let event know a tier 3 prize was won 
1505                     _eventData_.compressedData += 300000000000000000000000000000000;
1506                 }
1507                 // set airdrop happened bool to true
1508                 _eventData_.compressedData += 10000000000000000000000000000000;
1509                 // let event know how much was won 
1510                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1511                 
1512                 // reset air drop tracker
1513                 airDropTracker_ = 0;
1514             }
1515         }
1516     
1517             // store the air drop tracker number (number of buys since last airdrop)
1518             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1519             
1520             // update player 
1521             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1522             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1523             
1524             // update round
1525             round_[_rID].keys = _keys.add(round_[_rID].keys);
1526             round_[_rID].eth = _eth.add(round_[_rID].eth);
1527             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1528     
1529             // distribute eth
1530             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1531             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1532             
1533             // call end tx function to fire end tx event.
1534 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1535         }
1536     }
1537 //==============================================================================
1538 //     _ _ | _   | _ _|_ _  _ _  .
1539 //    (_(_||(_|_||(_| | (_)| _\  .
1540 //==============================================================================
1541     /**
1542      * @dev calculates unmasked earnings (just calculates, does not update mask)
1543      * @return earnings in wei format
1544      */
1545     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1546         private
1547         view
1548         returns(uint256)
1549     {
1550         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1551     }
1552     
1553     /** 
1554      * @dev returns the amount of keys you would get given an amount of eth. 
1555      * -functionhash- 0xce89c80c
1556      * @param _rID round ID you want price for
1557      * @param _eth amount of eth sent in 
1558      * @return keys received 
1559      */
1560     function calcKeysReceived(uint256 _rID, uint256 _eth)
1561         public
1562         view
1563         returns(uint256)
1564     {
1565         // grab time
1566         uint256 _now = now;
1567         
1568         // are we in a round?
1569         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1570             return ( (round_[_rID].eth).keysRec(_eth) );
1571         else // rounds over.  need keys for new round
1572             return ( (_eth).keys() );
1573     }
1574     
1575     /** 
1576      * @dev returns current eth price for X keys.  
1577      * -functionhash- 0xcf808000
1578      * @param _keys number of keys desired (in 18 decimal format)
1579      * @return amount of eth needed to send
1580      */
1581     function iWantXKeys(uint256 _keys)
1582         public
1583         view
1584         returns(uint256)
1585     {
1586         // setup local rID
1587         uint256 _rID = rID_;
1588         
1589         // grab time
1590         uint256 _now = now;
1591         
1592         // are we in a round?
1593         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1594             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1595         else // rounds over.  need price for new round
1596             return ( (_keys).eth() );
1597     }
1598 //==============================================================================
1599 //    _|_ _  _ | _  .
1600 //     | (_)(_)|_\  .
1601 //==============================================================================
1602     /**
1603 	 * @dev receives name/player info from names contract 
1604      */
1605     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1606         external
1607     {
1608         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1609         if (pIDxAddr_[_addr] != _pID)
1610             pIDxAddr_[_addr] = _pID;
1611         if (pIDxName_[_name] != _pID)
1612             pIDxName_[_name] = _pID;
1613         if (plyr_[_pID].addr != _addr)
1614             plyr_[_pID].addr = _addr;
1615         if (plyr_[_pID].name != _name)
1616             plyr_[_pID].name = _name;
1617         if (plyr_[_pID].laff != _laff)
1618             plyr_[_pID].laff = _laff;
1619         if (plyrNames_[_pID][_name] == false)
1620             plyrNames_[_pID][_name] = true;
1621     }
1622     
1623     /**
1624      * @dev receives entire player name list 
1625      */
1626     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1627         external
1628     {
1629         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1630         if(plyrNames_[_pID][_name] == false)
1631             plyrNames_[_pID][_name] = true;
1632     }   
1633         
1634     /**
1635      * @dev gets existing or registers new pID.  use this when a player may be new
1636      * @return pID 
1637      */
1638     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1639         private
1640         returns (F3Ddatasets.EventReturns)
1641     {
1642         uint256 _pID = pIDxAddr_[msg.sender];
1643         // if player is new to this version of fomo3d
1644         if (_pID == 0)
1645         {
1646             // grab their player ID, name and last aff ID, from player names contract 
1647             _pID = PlayerBook.getPlayerID(msg.sender);
1648             bytes32 _name = PlayerBook.getPlayerName(_pID);
1649             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1650             
1651             // set up player account 
1652             pIDxAddr_[msg.sender] = _pID;
1653             plyr_[_pID].addr = msg.sender;
1654             
1655             if (_name != "")
1656             {
1657                 pIDxName_[_name] = _pID;
1658                 plyr_[_pID].name = _name;
1659                 plyrNames_[_pID][_name] = true;
1660             }
1661             
1662             if (_laff != 0 && _laff != _pID)
1663                 plyr_[_pID].laff = _laff;
1664             
1665             // set the new player bool to true
1666             _eventData_.compressedData = _eventData_.compressedData + 1;
1667         } 
1668         return (_eventData_);
1669     }
1670     
1671     /**
1672      * @dev checks to make sure user picked a valid team.  if not sets team 
1673      * to default (sneks)
1674      */
1675     function verifyTeam(uint256 _team)
1676         private
1677         pure
1678         returns (uint256)
1679     {
1680         if (_team < 0 || _team > 3)
1681             return(2);
1682         else
1683             return(_team);
1684     }
1685     
1686     /**
1687      * @dev decides if round end needs to be run & new round started.  and if 
1688      * player unmasked earnings from previously played rounds need to be moved.
1689      */
1690     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1691         private
1692         returns (F3Ddatasets.EventReturns)
1693     {
1694         // if player has played a previous round, move their unmasked earnings
1695         // from that round to gen vault.
1696         if (plyr_[_pID].lrnd != 0)
1697             updateGenVault(_pID, plyr_[_pID].lrnd);
1698             
1699         // update player's last round played
1700         plyr_[_pID].lrnd = rID_;
1701             
1702         // set the joined round bool to true
1703         _eventData_.compressedData = _eventData_.compressedData + 10;
1704         
1705         return(_eventData_);
1706     }
1707     
1708     /**
1709      * @dev ends the round. manages paying out winner/splitting up pot
1710      */
1711     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1712         private
1713         returns (F3Ddatasets.EventReturns)
1714     {
1715         // setup local rID
1716         uint256 _rID = rID_;
1717         
1718         // grab our winning player and team id's
1719         uint256 _winPID = round_[_rID].plyr;
1720         uint256 _winTID = round_[_rID].team;
1721         
1722         // grab our pot amount
1723         uint256 _pot = round_[_rID].pot;
1724         
1725         // calculate our winner share, community rewards, gen share, 
1726         // p3d share, and amount reserved for next pot 
1727         uint256 _win = (_pot.mul(50)) / 100;
1728         uint256 _com = (_pot.mul(40) / 100);
1729         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1730         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1731         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1732         
1733         // calculate ppt for round mask
1734         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1735         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1736         if (_dust > 0)
1737         {
1738             _gen = _gen.sub(_dust);
1739             _res = _res.add(_dust);
1740         }
1741         
1742         // pay our winner
1743         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1744         
1745         // community rewards
1746         
1747         teamWallet.transfer(_com);
1748         
1749         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1750         // {
1751         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1752         //     // bank migrations by breaking outgoing transactions.
1753         //     // Something we would never do. But that's not the point.
1754         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1755         //     // highest belief that everything we create should be trustless.
1756         //     // Team JUST, The name you shouldn't have to trust.
1757         //     _p3d = _p3d.add(_com);
1758         //     _com = 0;
1759         // }
1760         
1761         // distribute gen portion to key holders
1762         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1763         
1764         // send share for p3d to divies
1765         // if (_p3d > 0)
1766         //     Divies.deposit.value(_p3d)();
1767             
1768         // prepare event data
1769         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1770         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1771         _eventData_.winnerAddr = plyr_[_winPID].addr;
1772         _eventData_.winnerName = plyr_[_winPID].name;
1773         _eventData_.amountWon = _win;
1774         _eventData_.genAmount = _gen;
1775         _eventData_.P3DAmount = _p3d;
1776         _eventData_.newPot = _res;
1777         
1778         // start next round
1779         rID_++;
1780         _rID++;
1781         round_[_rID].strt = now;
1782         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1783         round_[_rID].pot = _res;
1784         
1785         return(_eventData_);
1786     }
1787     
1788     /**
1789      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1790      */
1791     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1792         private 
1793     {
1794         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1795         if (_earnings > 0)
1796         {
1797             // put in gen vault
1798             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1799             // zero out their earnings by updating mask
1800             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1801         }
1802     }
1803     
1804     /**
1805      * @dev updates round timer based on number of whole keys bought.
1806      */
1807     function updateTimer(uint256 _keys, uint256 _rID)
1808         private
1809     {
1810         // grab time
1811         uint256 _now = now;
1812         
1813         // calculate time based on number of keys bought
1814         uint256 _newTime;
1815         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1816             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1817         else
1818             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1819         
1820         // compare to max and set new end time
1821         if (_newTime < (rndMax_).add(_now))
1822             round_[_rID].end = _newTime;
1823         else
1824             round_[_rID].end = rndMax_.add(_now);
1825     }
1826     
1827     /**
1828      * @dev generates a random number between 0-99 and checks to see if thats
1829      * resulted in an airdrop win
1830      * @return do we have a winner?
1831      */
1832     function airdrop()
1833         private 
1834         view 
1835         returns(bool)
1836     {
1837         uint256 seed = uint256(keccak256(abi.encodePacked(
1838             
1839             (block.timestamp).add
1840             (block.difficulty).add
1841             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1842             (block.gaslimit).add
1843             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1844             (block.number)
1845             
1846         )));
1847         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1848             return(true);
1849         else
1850             return(false);
1851     }
1852 
1853     /**
1854      * @dev distributes eth based on fees to com, aff, and p3d
1855      */
1856     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1857         private
1858         returns(F3Ddatasets.EventReturns)
1859     {
1860         // pay 10% out to community rewards
1861         uint256 _com = _eth.mul(9) / 100;
1862 
1863         teamWallet.transfer(_com);
1864         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1865         // {
1866         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1867         //     // bank migrations by breaking outgoing transactions.
1868         //     // Something we would never do. But that's not the point.
1869         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1870         //     // highest belief that everything we create should be trustless.
1871         //     // Team JUST, The name you shouldn't have to trust.
1872         //     _p3d = _com;
1873         //     _com = 0;
1874         // }
1875         
1876         // pay 1% out to FoMo3D short
1877         //uint256 _other = 0;
1878         //otherF3D_.potSwap.value(_long)();
1879         
1880         // distribute share to affiliate
1881         uint256 _aff = _eth / 4;
1882         
1883         // decide what to do with affiliate share of fees
1884         // affiliate must not be self, and must have a name registered
1885         if (_affID != _pID && plyr_[_affID].name != '') {
1886             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1887             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1888         } else {
1889             teamWallet.transfer(_aff);
1890         }
1891 
1892         // pay out p3d
1893         // _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1894         // if (_p3d > 0)
1895         // {
1896         //     // deposit to divies contract
1897         //     Divies.deposit.value(_p3d)();
1898             
1899         //     // set up event data
1900         //     _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1901         // }
1902         
1903         return(_eventData_);
1904     }
1905     
1906     function potSwap()
1907         external
1908         payable
1909     {
1910         // setup local rID
1911         uint256 _rID = rID_ + 1;
1912         
1913         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1914         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1915     }
1916     
1917     /**
1918      * @dev distributes eth based on fees to gen and pot
1919      */
1920     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1921         private
1922         returns(F3Ddatasets.EventReturns)
1923     {
1924         // calculate gen share
1925         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1926         
1927         // toss 1% into airdrop pot 
1928         uint256 _air = (_eth / 100);
1929         airDropPot_ = airDropPot_.add(_air);
1930         
1931         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1932         _eth = _eth.sub(((_eth.mul(31)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1933         
1934         // calculate pot 
1935         uint256 _pot = _eth.sub(_gen);
1936         
1937         // distribute gen share (thats what updateMasks() does) and adjust
1938         // balances for dust.
1939         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1940         if (_dust > 0)
1941             _gen = _gen.sub(_dust);
1942         
1943         // add eth to pot
1944         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1945         
1946         // set up event data
1947         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1948         _eventData_.potAmount = _pot;
1949         
1950         return(_eventData_);
1951     }
1952 
1953     /**
1954      * @dev updates masks for round and player when keys are bought
1955      * @return dust left over 
1956      */
1957     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1958         private
1959         returns(uint256)
1960     {
1961         /* MASKING NOTES
1962             earnings masks are a tricky thing for people to wrap their minds around.
1963             the basic thing to understand here.  is were going to have a global
1964             tracker based on profit per share for each round, that increases in
1965             relevant proportion to the increase in share supply.
1966             
1967             the player will have an additional mask that basically says "based
1968             on the rounds mask, my shares, and how much i've already withdrawn,
1969             how much is still owed to me?"
1970         */
1971         
1972         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1973         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1974         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1975             
1976         // calculate player earning from their own buy (only based on the keys
1977         // they just bought).  & update player earnings mask
1978         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1979         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1980         
1981         // calculate & return dust
1982         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1983     }
1984     
1985     /**
1986      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1987      * @return earnings in wei format
1988      */
1989     function withdrawEarnings(uint256 _pID)
1990         private
1991         returns(uint256)
1992     {
1993         // update gen vault
1994         updateGenVault(_pID, plyr_[_pID].lrnd);
1995         
1996         // from vaults 
1997         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1998         if (_earnings > 0)
1999         {
2000             plyr_[_pID].win = 0;
2001             plyr_[_pID].gen = 0;
2002             plyr_[_pID].aff = 0;
2003         }
2004 
2005         return(_earnings);
2006     }
2007     
2008     /**
2009      * @dev prepares compression data and fires event for buy or reload tx's
2010      */
2011     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2012         private
2013     {
2014         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2015         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2016         
2017         emit F3Devents.onEndTx
2018         (
2019             _eventData_.compressedData,
2020             _eventData_.compressedIDs,
2021             plyr_[_pID].name,
2022             msg.sender,
2023             _eth,
2024             _keys,
2025             _eventData_.winnerAddr,
2026             _eventData_.winnerName,
2027             _eventData_.amountWon,
2028             _eventData_.newPot,
2029             _eventData_.P3DAmount,
2030             _eventData_.genAmount,
2031             _eventData_.potAmount,
2032             airDropPot_
2033         );
2034     }
2035 //==============================================================================
2036 //    (~ _  _    _._|_    .
2037 //    _)(/_(_|_|| | | \/  .
2038 //====================/=========================================================
2039     /** upon contract deploy, it will be deactivated.  this is a one time
2040      * use function that will activate the contract.  we do this so devs 
2041      * have time to set things up on the web end                            **/
2042     bool public activated_ = false;
2043     function activate()
2044         onlyDevs()
2045         public
2046     {
2047 		// make sure that its been linked.
2048         // can only be ran once
2049         require(activated_ == false, "already activated");
2050         
2051         // activate the contract 
2052         activated_ = true;
2053         
2054         // lets start first round
2055 		rID_ = 1;
2056         round_[1].strt = now + rndExtra_;
2057         round_[1].end = now + rndInit_*12;
2058     }
2059 }