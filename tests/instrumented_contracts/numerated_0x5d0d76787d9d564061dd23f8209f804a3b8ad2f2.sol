1 pragma solidity ^0.4.24;
2 
3 // File: contracts\interface\PlayerBookInterface.sol
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
16 // File: contracts\library\SafeMath.sol
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
131 // File: contracts\library\UintCompressor.sol
132 
133 /**
134 * @title -UintCompressor- v0.1.9
135 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
136 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
137 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
138 *                                  _____                      _____
139 *                                 (, /     /)       /) /)    (, /      /)          /)
140 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
141 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
142 *          ┴ ┴                /   /          .-/ _____   (__ /                               
143 *                            (__ /          (_/ (, /                                      /)™ 
144 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
145 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
146 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
147 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
148 *    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ 
149 *===/ )( \ (  ) (  ( \(_  _)===/ __) /  \ ( \/ )(  _ \(  _ \(  __)/ ___)/ ___) /  \ (  _ \===*
150 *   ) \/ (  )(  /    /  )(    ( (__ (  O )/ \/ \ ) __/ )   / ) _) \___ \\___ \(  O ) )   /
151 *===\____/ (__) \_)__) (__)====\___) \__/ \_)(_/(__)  (__\_)(____)(____/(____/ \__/ (__\_)===*
152 *
153 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
154 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
155 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
156 */
157 
158 library UintCompressor {
159     using SafeMath for *;
160     
161     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
162         internal
163         pure
164         returns(uint256)
165     {
166         // check conditions 
167         require(_end < 77 && _start < 77, "start/end must be less than 77");
168         require(_end >= _start, "end must be >= start");
169         
170         // format our start/end points
171         _end = exponent(_end).mul(10);
172         _start = exponent(_start);
173         
174         // check that the include data fits into its segment 
175         require(_include < (_end / _start));
176         
177         // build middle
178         if (_include > 0)
179             _include = _include.mul(_start);
180         
181         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
182     }
183     
184     function extract(uint256 _input, uint256 _start, uint256 _end)
185 	    internal
186 	    pure
187 	    returns(uint256)
188     {
189         // check conditions
190         require(_end < 77 && _start < 77, "start/end must be less than 77");
191         require(_end >= _start, "end must be >= start");
192         
193         // format our start/end points
194         _end = exponent(_end).mul(10);
195         _start = exponent(_start);
196         
197         // return requested section
198         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
199     }
200     
201     function exponent(uint256 _position)
202         private
203         pure
204         returns(uint256)
205     {
206         return((10).pwr(_position));
207     }
208 }
209 
210 // File: contracts\library\NameFilter.sol
211 
212 /**
213 * @title -Name Filter- v0.1.9
214 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
215 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
216 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
217 *                                  _____                      _____
218 *                                 (, /     /)       /) /)    (, /      /)          /)
219 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
220 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
221 *          ┴ ┴                /   /          .-/ _____   (__ /                               
222 *                            (__ /          (_/ (, /                                      /)™ 
223 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
224 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
225 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
226 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
227 *              _       __    _      ____      ____  _   _    _____  ____  ___  
228 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
229 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
230 *
231 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
232 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
233 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
234 */
235 
236 library NameFilter {
237     /**
238      * @dev filters name strings
239      * -converts uppercase to lower case.  
240      * -makes sure it does not start/end with a space
241      * -makes sure it does not contain multiple spaces in a row
242      * -cannot be only numbers
243      * -cannot start with 0x 
244      * -restricts characters to A-Z, a-z, 0-9, and space.
245      * @return reprocessed string in bytes32 format
246      */
247     function nameFilter(string _input)
248         internal
249         pure
250         returns(bytes32)
251     {
252         bytes memory _temp = bytes(_input);
253         uint256 _length = _temp.length;
254         
255         //sorry limited to 32 characters
256         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
257         // make sure it doesnt start with or end with space
258         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
259         // make sure first two characters are not 0x
260         if (_temp[0] == 0x30)
261         {
262             require(_temp[1] != 0x78, "string cannot start with 0x");
263             require(_temp[1] != 0x58, "string cannot start with 0X");
264         }
265         
266         // create a bool to track if we have a non number character
267         bool _hasNonNumber;
268         
269         // convert & check
270         for (uint256 i = 0; i < _length; i++)
271         {
272             // if its uppercase A-Z
273             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
274             {
275                 // convert to lower case a-z
276                 _temp[i] = byte(uint(_temp[i]) + 32);
277                 
278                 // we have a non number
279                 if (_hasNonNumber == false)
280                     _hasNonNumber = true;
281             } else {
282                 require
283                 (
284                     // require character is a space
285                     _temp[i] == 0x20 || 
286                     // OR lowercase a-z
287                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
288                     // or 0-9
289                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
290                     "string contains invalid characters"
291                 );
292                 // make sure theres not 2x spaces in a row
293                 if (_temp[i] == 0x20)
294                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
295                 
296                 // see if we have a character other than a number
297                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
298                     _hasNonNumber = true;    
299             }
300         }
301         
302         require(_hasNonNumber == true, "string cannot be only numbers");
303         
304         bytes32 _ret;
305         assembly {
306             _ret := mload(add(_temp, 32))
307         }
308         return (_ret);
309     }
310 }
311 
312 // File: contracts\library\F3DKeysCalcLong.sol
313 
314 //==============================================================================
315 //  |  _      _ _ | _  .
316 //  |<(/_\/  (_(_||(_  .
317 //=======/======================================================================
318 library F3DKeysCalcLong {
319     using SafeMath for *;
320     /**
321      * @dev calculates number of keys received given X eth 
322      * @param _curEth current amount of eth in contract 
323      * @param _newEth eth being spent
324      * @return amount of ticket purchased
325      */
326     function keysRec(uint256 _curEth, uint256 _newEth)
327         internal
328         pure
329         returns (uint256)
330     {
331         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
332     }
333     
334     /**
335      * @dev calculates amount of eth received if you sold X keys 
336      * @param _curKeys current amount of keys that exist 
337      * @param _sellKeys amount of keys you wish to sell
338      * @return amount of eth received
339      */
340     function ethRec(uint256 _curKeys, uint256 _sellKeys)
341         internal
342         pure
343         returns (uint256)
344     {
345         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
346     }
347 
348     /**
349      * @dev calculates how many keys would exist with given an amount of eth
350      * @param _eth eth "in contract"
351      * @return number of keys that would exist
352      */
353     function keys(uint256 _eth) 
354         internal
355         pure
356         returns(uint256)
357     {
358         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
359     }
360     
361     /**
362      * @dev calculates how much eth would be in contract given a number of keys
363      * @param _keys number of keys "in contract" 
364      * @return eth that would exists
365      */
366     function eth(uint256 _keys) 
367         internal
368         pure
369         returns(uint256)  
370     {
371         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
372     }
373 }
374 
375 // File: contracts\library\F3Ddatasets.sol
376 
377 //==============================================================================
378 //   __|_ _    __|_ _  .
379 //  _\ | | |_|(_ | _\  .
380 //==============================================================================
381 library F3Ddatasets {
382     //compressedData key
383     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
384         // 0 - new player (bool)
385         // 1 - joined round (bool)
386         // 2 - new  leader (bool)
387         // 3-5 - air drop tracker (uint 0-999)
388         // 6-16 - round end time
389         // 17 - winnerTeam
390         // 18 - 28 timestamp 
391         // 29 - team
392         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
393         // 31 - airdrop happened bool
394         // 32 - airdrop tier 
395         // 33 - airdrop amount won
396     //compressedIDs key
397     // [77-52][51-26][25-0]
398         // 0-25 - pID 
399         // 26-51 - winPID
400         // 52-77 - rID
401     struct EventReturns {
402         uint256 compressedData;
403         uint256 compressedIDs;
404         address winnerAddr;         // winner address
405         bytes32 winnerName;         // winner name
406         uint256 amountWon;          // amount won
407         uint256 newPot;             // amount in new pot
408         uint256 P3DAmount;          // amount distributed to p3d
409         uint256 genAmount;          // amount distributed to gen
410         uint256 potAmount;          // amount added to pot
411     }
412     struct Player {
413         address addr;   // player address
414         bytes32 name;   // player name
415         uint256 win;    // winnings vault
416         uint256 gen;    // general vault
417         uint256 aff;    // affiliate vault
418         uint256 lrnd;   // last round played
419         uint256 laff;   // last affiliate id used
420     }
421     struct PlayerRounds {
422         uint256 eth;    // eth player has added to round (used for eth limiter)
423         uint256 keys;   // keys
424         uint256 mask;   // player mask 
425         uint256 ico;    // ICO phase investment
426     }
427     struct Round {
428         uint256 plyr;   // pID of player in lead， lead领导吗？
429         uint256 team;   // tID of team in lead
430         uint256 end;    // time ends/ended
431         bool ended;     // has round end function been ran  这个开关值得研究下
432         uint256 strt;   // time round started
433         uint256 keys;   // keys
434         uint256 eth;    // total eth in
435         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
436         uint256 mask;   // global mask
437         uint256 ico;    // total eth sent in during ICO phase
438         uint256 icoGen; // total eth for gen during ICO phase
439         uint256 icoAvg; // average key price for ICO phase
440     }
441     struct TeamFee {
442         uint256 gen;    // % of buy in thats paid to key holders of current round
443         uint256 p3d;    // % of buy in thats paid to p3d holders
444     }
445     struct PotSplit {
446         uint256 gen;    // % of pot thats paid to key holders of current round
447         uint256 p3d;    // % of pot thats paid to p3d holders
448     }
449 }
450 
451 // File: contracts\F3Devents.sol
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
566 // File: contracts\modularLong.sol
567 
568 contract modularLong is F3Devents {}
569 
570 // File: contracts\FoMo3Dlong.sol
571 
572 contract FoMo3Dlong is modularLong {
573     using SafeMath for *;
574     using NameFilter for string;
575     using F3DKeysCalcLong for uint256;
576 	
577 
578     //TODO:
579     //JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x508D1c04cd185E693d22125f3Cc6DC81F7Ce9477);
580     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x19dB4339c0ad1BE41FE497795FF2c5263962a573);
581   
582     address public teamWallet = 0xE9675cdAf47bab3Eef5B1f1c2b7f8d41cDcf9b29;
583     address[] public leaderWallets;
584 //==============================================================================
585 //     _ _  _  |`. _     _ _ |_ | _  _  .
586 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
587 //=================_|===========================================================
588     string constant public name = "Peach Will";
589     string constant public symbol = "PW";
590     uint256 private rndExtra_ = 1 hours; //24 hours;     // length of the very first ICO 
591     uint256 private rndGap_ = 15 seconds;         // length of ICO phase, set to 1 year for EOS.
592     uint256 constant private rndInit_ = 10 hours; //1 hours;                // round timer starts at this
593     uint256 constant private rndInc_ = 88 seconds;              // every full key purchased adds this much to the timer
594     uint256 constant private rndMax_ =  10 hours; // 24 hours;                // max length a round timer can be
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
636         fees_[0] = F3Ddatasets.TeamFee(54,0);   //20% to pot, 10% to aff, 10% to com, 5% to leader swap, 1% to air drop pot
637         fees_[1] = F3Ddatasets.TeamFee(41,0);   //33% to pot, 10% to aff, 10% to com, 5% to leader swap, 1% to air drop pot
638         fees_[2] = F3Ddatasets.TeamFee(30,0);  //44% to pot, 10% to aff, 10% to com, 5% to leader swap, 1% to air drop pot
639         fees_[3] = F3Ddatasets.TeamFee(40,0);   //34% to pot, 10% to aff, 10% to com, 5% to leader swap, 1% to air drop pot
640         
641         // how to split up the final pot based on which team was picked
642         // (F3D, P3D)
643         potSplit_[0] = F3Ddatasets.PotSplit(37,0);  //48% to winner, 10% to next round, 5% to com
644         potSplit_[1] = F3Ddatasets.PotSplit(34,0);   //48% to winner, 13% to next round, 5% to com
645         potSplit_[2] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 22% to next round, 5% to com
646         potSplit_[3] = F3Ddatasets.PotSplit(32,0);  //48% to winner, 15% to next round, 5% to com
647 
648         leaderWallets.length = 4;
649         leaderWallets[0]= 0x326d8d593195a3153f6d55d7791c10af9bcef597;
650         leaderWallets[1]= 0x15B474F7DE7157FA0dB9FaaA8b82761E78E804B9;
651         leaderWallets[2]= 0x0c2d482FBc1da4DaCf3CD05b6A5955De1A296fa8;
652         leaderWallets[3]= 0xD3d96E74aFAE57B5191DC44Bdb08b037355523Ba;
653 
654     }
655 //==============================================================================
656 //     _ _  _  _|. |`. _  _ _  .
657 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
658 //==============================================================================
659     /**
660      * @dev used to make sure no one can interact with contract until it has 
661      * been activated. 
662      */
663     modifier isActivated() {
664         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
665         _;
666     }
667     
668     /**
669      * @dev prevents contracts from interacting with fomo3d 
670      */
671     modifier isHuman() {
672         address _addr = msg.sender;
673         require (_addr == tx.origin);
674         
675         uint256 _codeLength;
676         
677         assembly {_codeLength := extcodesize(_addr)}
678         require(_codeLength == 0, "sorry humans only");
679         _;
680     }
681 
682     /**
683      * @dev sets boundaries for incoming tx 
684      */
685     modifier isWithinLimits(uint256 _eth) {
686         require(_eth >= 1000000000, "pocket lint: not a valid currency");
687         require(_eth <= 100000000000000000000000, "no vitalik, no");
688         _;    
689     }
690 
691     /**
692      * 
693      */
694     modifier onlyDevs() {
695         //TODO:
696         require(
697             msg.sender == 0xE9675cdAf47bab3Eef5B1f1c2b7f8d41cDcf9b29 ||
698             msg.sender == 0x0020116131498D968DeBCF75E5A11F77e7e1CadE,
699             "only team just can activate"
700         );
701         _;
702     }
703     
704 //==============================================================================
705 //     _    |_ |. _   |`    _  __|_. _  _  _  .
706 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
707 //====|=========================================================================
708     /**
709      * @dev emergency buy uses last stored affiliate ID and team snek
710      */
711     function()
712         isActivated()
713         isHuman()
714         isWithinLimits(msg.value)
715         public
716         payable
717     {
718         // set up our tx event data and determine if player is new or not
719         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
720             
721         // fetch player id
722         uint256 _pID = pIDxAddr_[msg.sender];
723         
724         // buy core 
725         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
726     }
727     
728     /**
729      * @dev converts all incoming ethereum to keys.
730      * -functionhash- 0x8f38f309 (using ID for affiliate)
731      * -functionhash- 0x98a0871d (using address for affiliate)
732      * -functionhash- 0xa65b37a1 (using name for affiliate)
733      * @param _affCode the ID/address/name of the player who gets the affiliate fee
734      * @param _team what team is the player playing for?
735      */
736     function buyXid(uint256 _affCode, uint256 _team)
737         isActivated()
738         isHuman()
739         isWithinLimits(msg.value)
740         public
741         payable
742     {
743         // set up our tx event data and determine if player is new or not
744         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
745         
746         // fetch player id
747         uint256 _pID = pIDxAddr_[msg.sender];
748         
749         // manage affiliate residuals
750         // if no affiliate code was given or player tried to use their own, lolz
751         if (_affCode == 0 || _affCode == _pID)
752         {
753             // use last stored affiliate code 
754             _affCode = plyr_[_pID].laff;
755             
756         // if affiliate code was given & its not the same as previously stored 
757         } else if (_affCode != plyr_[_pID].laff) {
758             // update last affiliate 
759             plyr_[_pID].laff = _affCode;
760         }
761         
762         // verify a valid team was selected
763         _team = verifyTeam(_team);
764         
765         // buy core 
766         buyCore(_pID, _affCode, _team, _eventData_);
767     }
768     
769     function buyXaddr(address _affCode, uint256 _team)
770         isActivated()
771         isHuman()
772         isWithinLimits(msg.value)
773         public
774         payable
775     {
776         // set up our tx event data and determine if player is new or not
777         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
778         
779         // fetch player id
780         uint256 _pID = pIDxAddr_[msg.sender];
781         
782         // manage affiliate residuals
783         uint256 _affID;
784         // if no affiliate code was given or player tried to use their own, lolz
785         if (_affCode == address(0) || _affCode == msg.sender)
786         {
787             // use last stored affiliate code
788             _affID = plyr_[_pID].laff;
789         
790         // if affiliate code was given    
791         } else {
792             // get affiliate ID from aff Code 
793             _affID = pIDxAddr_[_affCode];
794             
795             // if affID is not the same as previously stored 
796             if (_affID != plyr_[_pID].laff)
797             {
798                 // update last affiliate
799                 plyr_[_pID].laff = _affID;
800             }
801         }
802         
803         // verify a valid team was selected
804         _team = verifyTeam(_team);
805         
806         // buy core 
807         buyCore(_pID, _affID, _team, _eventData_);
808     }
809     
810     function buyXname(bytes32 _affCode, uint256 _team)
811         isActivated()
812         isHuman()
813         isWithinLimits(msg.value)
814         public
815         payable
816     {
817         // set up our tx event data and determine if player is new or not
818         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
819         
820         // fetch player id
821         uint256 _pID = pIDxAddr_[msg.sender];
822         
823         // manage affiliate residuals
824         uint256 _affID;
825         // if no affiliate code was given or player tried to use their own, lolz
826         if (_affCode == '' || _affCode == plyr_[_pID].name)
827         {
828             // use last stored affiliate code
829             _affID = plyr_[_pID].laff;
830         
831         // if affiliate code was given
832         } else {
833             // get affiliate ID from aff Code
834             _affID = pIDxName_[_affCode];
835             
836             // if affID is not the same as previously stored
837             if (_affID != plyr_[_pID].laff)
838             {
839                 // update last affiliate
840                 plyr_[_pID].laff = _affID;
841             }
842         }
843         
844         // verify a valid team was selected
845         _team = verifyTeam(_team);
846         
847         // buy core 
848         buyCore(_pID, _affID, _team, _eventData_);
849     }
850     
851     /**
852      * @dev essentially the same as buy, but instead of you sending ether 
853      * from your wallet, it uses your unwithdrawn earnings.
854      * -functionhash- 0x349cdcac (using ID for affiliate)
855      * -functionhash- 0x82bfc739 (using address for affiliate)
856      * -functionhash- 0x079ce327 (using name for affiliate)
857      * @param _affCode the ID/address/name of the player who gets the affiliate fee
858      * @param _team what team is the player playing for?
859      * @param _eth amount of earnings to use (remainder returned to gen vault)
860      */
861     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
862         isActivated()
863         isHuman()
864         isWithinLimits(_eth)
865         public
866     {
867         // set up our tx event data
868         F3Ddatasets.EventReturns memory _eventData_;
869         
870         // fetch player ID
871         uint256 _pID = pIDxAddr_[msg.sender];
872         
873         // manage affiliate residuals
874         // if no affiliate code was given or player tried to use their own, lolz
875         if (_affCode == 0 || _affCode == _pID)
876         {
877             // use last stored affiliate code 
878             _affCode = plyr_[_pID].laff;
879             
880         // if affiliate code was given & its not the same as previously stored 
881         } else if (_affCode != plyr_[_pID].laff) {
882             // update last affiliate 
883             plyr_[_pID].laff = _affCode;
884         }
885 
886         // verify a valid team was selected
887         _team = verifyTeam(_team);
888 
889         // reload core
890         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
891     }
892     
893     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
894         isActivated()
895         isHuman()
896         isWithinLimits(_eth)
897         public
898     {
899         // set up our tx event data
900         F3Ddatasets.EventReturns memory _eventData_;
901         
902         // fetch player ID
903         uint256 _pID = pIDxAddr_[msg.sender];
904         
905         // manage affiliate residuals
906         uint256 _affID;
907         // if no affiliate code was given or player tried to use their own, lolz
908         if (_affCode == address(0) || _affCode == msg.sender)
909         {
910             // use last stored affiliate code
911             _affID = plyr_[_pID].laff;
912         
913         // if affiliate code was given    
914         } else {
915             // get affiliate ID from aff Code 
916             _affID = pIDxAddr_[_affCode];
917             
918             // if affID is not the same as previously stored 
919             if (_affID != plyr_[_pID].laff)
920             {
921                 // update last affiliate
922                 plyr_[_pID].laff = _affID;
923             }
924         }
925         
926         // verify a valid team was selected
927         _team = verifyTeam(_team);
928         
929         // reload core
930         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
931     }
932     
933     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
934         isActivated()
935         isHuman()
936         isWithinLimits(_eth)
937         public
938     {
939         // set up our tx event data
940         F3Ddatasets.EventReturns memory _eventData_;
941         
942         // fetch player ID
943         uint256 _pID = pIDxAddr_[msg.sender];
944         
945         // manage affiliate residuals
946         uint256 _affID;
947         // if no affiliate code was given or player tried to use their own, lolz
948         if (_affCode == '' || _affCode == plyr_[_pID].name)
949         {
950             // use last stored affiliate code
951             _affID = plyr_[_pID].laff;
952         
953         // if affiliate code was given
954         } else {
955             // get affiliate ID from aff Code
956             _affID = pIDxName_[_affCode];
957             
958             // if affID is not the same as previously stored
959             if (_affID != plyr_[_pID].laff)
960             {
961                 // update last affiliate
962                 plyr_[_pID].laff = _affID;
963             }
964         }
965         
966         // verify a valid team was selected
967         _team = verifyTeam(_team);
968         
969         // reload core
970         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
971     }
972 
973     /**
974      * @dev withdraws all of your earnings.
975      * -functionhash- 0x3ccfd60b
976      */
977     function withdraw()
978         isActivated()
979         isHuman()
980         public
981     {
982         // setup local rID 
983         uint256 _rID = rID_;
984         
985         // grab time
986         uint256 _now = now;
987         
988         // fetch player ID
989         uint256 _pID = pIDxAddr_[msg.sender];
990         
991         // setup temp var for player eth
992         uint256 _eth;
993         
994         // check to see if round has ended and no one has run round end yet
995         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
996         {
997             // set up our tx event data
998             F3Ddatasets.EventReturns memory _eventData_;
999             
1000             // end the round (distributes pot)
1001 			round_[_rID].ended = true;
1002             _eventData_ = endRound(_eventData_);
1003             
1004 			// get their earnings
1005             _eth = withdrawEarnings(_pID);
1006             
1007             // gib moni
1008             if (_eth > 0)
1009                 plyr_[_pID].addr.transfer(_eth);    
1010             
1011             // build event data
1012             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1013             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1014             
1015             // fire withdraw and distribute event
1016             emit F3Devents.onWithdrawAndDistribute
1017             (
1018                 msg.sender, 
1019                 plyr_[_pID].name, 
1020                 _eth, 
1021                 _eventData_.compressedData, 
1022                 _eventData_.compressedIDs, 
1023                 _eventData_.winnerAddr, 
1024                 _eventData_.winnerName, 
1025                 _eventData_.amountWon, 
1026                 _eventData_.newPot, 
1027                 _eventData_.P3DAmount, 
1028                 _eventData_.genAmount
1029             );
1030             
1031         // in any other situation
1032         } else {
1033             // get their earnings
1034             _eth = withdrawEarnings(_pID);
1035             
1036             // gib moni
1037             if (_eth > 0)
1038                 plyr_[_pID].addr.transfer(_eth);
1039             
1040             // fire withdraw event
1041             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
1042         }
1043     }
1044     
1045     /**
1046      * @dev use these to register names.  they are just wrappers that will send the
1047      * registration requests to the PlayerBook contract.  So registering here is the 
1048      * same as registering there.  UI will always display the last name you registered.
1049      * but you will still own all previously registered names to use as affiliate 
1050      * links.
1051      * - must pay a registration fee.
1052      * - name must be unique
1053      * - names will be converted to lowercase
1054      * - name cannot start or end with a space 
1055      * - cannot have more than 1 space in a row
1056      * - cannot be only numbers
1057      * - cannot start with 0x 
1058      * - name must be at least 1 char
1059      * - max length of 32 characters long
1060      * - allowed characters: a-z, 0-9, and space
1061      * -functionhash- 0x921dec21 (using ID for affiliate)
1062      * -functionhash- 0x3ddd4698 (using address for affiliate)
1063      * -functionhash- 0x685ffd83 (using name for affiliate)
1064      * @param _nameString players desired name
1065      * @param _affCode affiliate ID, address, or name of who referred you
1066      * @param _all set to true if you want this to push your info to all games 
1067      * (this might cost a lot of gas)
1068      */
1069     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1070         isHuman()
1071         public
1072         payable
1073     {
1074         bytes32 _name = _nameString.nameFilter();
1075         address _addr = msg.sender;
1076         uint256 _paid = msg.value;
1077         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
1078         
1079         uint256 _pID = pIDxAddr_[_addr];
1080         
1081         // fire event
1082         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1083     }
1084     
1085     function registerNameXaddr(string _nameString, address _affCode, bool _all)
1086         isHuman()
1087         public
1088         payable
1089     {
1090         bytes32 _name = _nameString.nameFilter();
1091         address _addr = msg.sender;
1092         uint256 _paid = msg.value;
1093         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1094         
1095         uint256 _pID = pIDxAddr_[_addr];
1096         
1097         // fire event
1098         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1099     }
1100     
1101     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1102         isHuman()
1103         public
1104         payable
1105     {
1106         bytes32 _name = _nameString.nameFilter();
1107         address _addr = msg.sender;
1108         uint256 _paid = msg.value;
1109         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
1110         
1111         uint256 _pID = pIDxAddr_[_addr];
1112         
1113         // fire event
1114         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
1115     }
1116 //==============================================================================
1117 //     _  _ _|__|_ _  _ _  .
1118 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1119 //=====_|=======================================================================
1120     /**
1121      * @dev return the price buyer will pay for next 1 individual key.
1122      * -functionhash- 0x018a25e8
1123      * @return price for next key bought (in wei format)
1124      */
1125     function getBuyPrice()
1126         public 
1127         view 
1128         returns(uint256)
1129     {  
1130         // setup local rID
1131         uint256 _rID = rID_;
1132         
1133         // grab time
1134         uint256 _now = now;
1135         
1136         // are we in a round?
1137         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1138             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
1139         else // rounds over.  need price for new round
1140             return ( 75000000000000 ); // init
1141     }
1142     
1143     /**
1144      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
1145      * provider
1146      * -functionhash- 0xc7e284b8
1147      * @return time left in seconds
1148      */
1149     function getTimeLeft()
1150         public
1151         view
1152         returns(uint256)
1153     {
1154         // setup local rID
1155         uint256 _rID = rID_;
1156         
1157         // grab time
1158         uint256 _now = now;
1159         
1160         if (_now < round_[_rID].end)
1161             if (_now > round_[_rID].strt + rndGap_)
1162                 return( (round_[_rID].end).sub(_now) );
1163             else
1164                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1165         else
1166             return(0);
1167     }
1168     
1169     /**
1170      * @dev returns player earnings per vaults 
1171      * -functionhash- 0x63066434
1172      * @return winnings vault
1173      * @return general vault
1174      * @return affiliate vault
1175      */
1176     function getPlayerVaults(uint256 _pID)
1177         public
1178         view
1179         returns(uint256 ,uint256, uint256)
1180     {
1181         // setup local rID
1182         uint256 _rID = rID_;
1183         
1184         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
1185         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1186         {
1187             // if player is winner 
1188             if (round_[_rID].plyr == _pID)
1189             {
1190                 return
1191                 (
1192                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
1193                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
1194                     plyr_[_pID].aff
1195                 );
1196             // if player is not the winner
1197             } else {
1198                 return
1199                 (
1200                     plyr_[_pID].win,
1201                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
1202                     plyr_[_pID].aff
1203                 );
1204             }
1205             
1206         // if round is still going on, or round has ended and round end has been ran
1207         } else {
1208             return
1209             (
1210                 plyr_[_pID].win,
1211                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1212                 plyr_[_pID].aff
1213             );
1214         }
1215     }
1216     
1217     /**
1218      * solidity hates stack limits.  this lets us avoid that hate 
1219      */
1220     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1221         private
1222         view
1223         returns(uint256)
1224     {
1225         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
1226     }
1227     
1228     /**
1229      * @dev returns all current round info needed for front end
1230      * -functionhash- 0x747dff42
1231      * @return eth invested during ICO phase
1232      * @return round id 
1233      * @return total keys for round 
1234      * @return time round ends
1235      * @return time round started
1236      * @return current pot 
1237      * @return current team ID & player ID in lead 
1238      * @return current player in leads address 
1239      * @return current player in leads name
1240      * @return whales eth in for round
1241      * @return bears eth in for round
1242      * @return sneks eth in for round
1243      * @return bulls eth in for round
1244      * @return airdrop tracker # & airdrop pot
1245      */
1246     function getCurrentRoundInfo()
1247         public
1248         view
1249         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1250     {
1251         // setup local rID
1252         uint256 _rID = rID_;
1253         
1254         return
1255         (
1256             round_[_rID].ico,               //0
1257             _rID,                           //1
1258             round_[_rID].keys,              //2
1259             round_[_rID].end,               //3
1260             round_[_rID].strt,              //4
1261             round_[_rID].pot,               //5
1262             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
1263             plyr_[round_[_rID].plyr].addr,  //7
1264             plyr_[round_[_rID].plyr].name,  //8
1265             rndTmEth_[_rID][0],             //9
1266             rndTmEth_[_rID][1],             //10
1267             rndTmEth_[_rID][2],             //11
1268             rndTmEth_[_rID][3],             //12
1269             airDropTracker_ + (airDropPot_ * 1000)              //13
1270         );
1271     }
1272 
1273     /**
1274      * @dev returns player info based on address.  if no address is given, it will 
1275      * use msg.sender 
1276      * -functionhash- 0xee0b5d8b
1277      * @param _addr address of the player you want to lookup 
1278      * @return player ID 
1279      * @return player name
1280      * @return keys owned (current round)
1281      * @return winnings vault
1282      * @return general vault 
1283      * @return affiliate vault 
1284 	 * @return player round eth
1285      */
1286     function getPlayerInfoByAddress(address _addr)
1287         public 
1288         view 
1289         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1290     {
1291         // setup local rID
1292         uint256 _rID = rID_;
1293         
1294         if (_addr == address(0))
1295         {
1296             _addr == msg.sender;
1297         }
1298         uint256 _pID = pIDxAddr_[_addr];
1299         
1300         return
1301         (
1302             _pID,                               //0
1303             plyr_[_pID].name,                   //1
1304             plyrRnds_[_pID][_rID].keys,         //2
1305             plyr_[_pID].win,                    //3
1306             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
1307             plyr_[_pID].aff,                    //5
1308             plyrRnds_[_pID][_rID].eth           //6
1309         );
1310     }
1311 
1312 //==============================================================================
1313 //     _ _  _ _   | _  _ . _  .
1314 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1315 //=====================_|=======================================================
1316     /**
1317      * @dev logic runs whenever a buy order is executed.  determines how to handle 
1318      * incoming eth depending on if we are in an active round or not
1319      */
1320     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1321         private
1322     {
1323         // setup local rID
1324         uint256 _rID = rID_;
1325         
1326         // grab time
1327         uint256 _now = now;
1328         
1329         // if round is active
1330         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1331         {
1332             // call core 
1333             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1334         
1335         // if round is not active     
1336         } else {
1337             // check to see if end round needs to be ran
1338             if (_now > round_[_rID].end && round_[_rID].ended == false) 
1339             {
1340                 // end the round (distributes pot) & start new round
1341 			    round_[_rID].ended = true;
1342                 _eventData_ = endRound(_eventData_);
1343                 
1344                 // build event data
1345                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1346                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1347                 
1348                 // fire buy and distribute event 
1349                 emit F3Devents.onBuyAndDistribute
1350                 (
1351                     msg.sender, 
1352                     plyr_[_pID].name, 
1353                     msg.value, 
1354                     _eventData_.compressedData, 
1355                     _eventData_.compressedIDs, 
1356                     _eventData_.winnerAddr, 
1357                     _eventData_.winnerName, 
1358                     _eventData_.amountWon, 
1359                     _eventData_.newPot, 
1360                     _eventData_.P3DAmount, 
1361                     _eventData_.genAmount
1362                 );
1363             }
1364             
1365             // put eth in players vault 
1366             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1367         }
1368     }
1369     
1370     /**
1371      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1372      * incoming eth depending on if we are in an active round or not 
1373      */
1374     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1375         private
1376     {
1377         // setup local rID
1378         uint256 _rID = rID_;
1379         
1380         // grab time
1381         uint256 _now = now;
1382         
1383         // if round is active
1384         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1385         {
1386             // get earnings from all vaults and return unused to gen vault
1387             // because we use a custom safemath library.  this will throw if player 
1388             // tried to spend more eth than they have.
1389             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1390             
1391             // call core 
1392             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1393         
1394         // if round is not active and end round needs to be ran   
1395         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1396             // end the round (distributes pot) & start new round
1397             round_[_rID].ended = true;
1398             _eventData_ = endRound(_eventData_);
1399                 
1400             // build event data
1401             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1402             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1403                 
1404             // fire buy and distribute event 
1405             emit F3Devents.onReLoadAndDistribute
1406             (
1407                 msg.sender, 
1408                 plyr_[_pID].name, 
1409                 _eventData_.compressedData, 
1410                 _eventData_.compressedIDs, 
1411                 _eventData_.winnerAddr, 
1412                 _eventData_.winnerName, 
1413                 _eventData_.amountWon, 
1414                 _eventData_.newPot, 
1415                 _eventData_.P3DAmount, 
1416                 _eventData_.genAmount
1417             );
1418         }
1419     }
1420     
1421     /**
1422      * @dev this is the core logic for any buy/reload that happens while a round 
1423      * is live.
1424      */
1425     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1426         private
1427     {
1428         // if player is new to round
1429         if (plyrRnds_[_pID][_rID].keys == 0)
1430             _eventData_ = managePlayer(_pID, _eventData_);
1431         
1432         // early round eth limiter 
1433         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1434         {
1435             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1436             uint256 _refund = _eth.sub(_availableLimit);
1437             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1438             _eth = _availableLimit;
1439         }
1440         
1441         // if eth left is greater than min eth allowed (sorry no pocket lint)
1442         if (_eth > 1000000000) 
1443         {
1444             
1445             // mint the new keys
1446             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1447             
1448             // if they bought at least 1 whole key
1449             if (_keys >= 1000000000000000000)
1450             {
1451             updateTimer(_keys, _rID);
1452 
1453             // set new leaders
1454             if (round_[_rID].plyr != _pID)
1455                 round_[_rID].plyr = _pID;  
1456             if (round_[_rID].team != _team)
1457                 round_[_rID].team = _team; 
1458             
1459             // set the new leader bool to true
1460             _eventData_.compressedData = _eventData_.compressedData + 100;
1461         }
1462             
1463             // manage airdrops
1464             if (_eth >= 100000000000000000)
1465             {
1466             airDropTracker_++;
1467             if (airdrop() == true)
1468             {
1469                 // gib muni
1470                 uint256 _prize;
1471                 if (_eth >= 10000000000000000000)
1472                 {
1473                     // calculate prize and give it to winner
1474                     _prize = ((airDropPot_).mul(75)) / 100;
1475                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1476                     
1477                     // adjust airDropPot 
1478                     airDropPot_ = (airDropPot_).sub(_prize);
1479                     
1480                     // let event know a tier 3 prize was won 
1481                     _eventData_.compressedData += 300000000000000000000000000000000;
1482                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1483                     // calculate prize and give it to winner
1484                     _prize = ((airDropPot_).mul(50)) / 100;
1485                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1486                     
1487                     // adjust airDropPot 
1488                     airDropPot_ = (airDropPot_).sub(_prize);
1489                     
1490                     // let event know a tier 2 prize was won 
1491                     _eventData_.compressedData += 200000000000000000000000000000000;
1492                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1493                     // calculate prize and give it to winner
1494                     _prize = ((airDropPot_).mul(25)) / 100;
1495                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1496                     
1497                     // adjust airDropPot 
1498                     airDropPot_ = (airDropPot_).sub(_prize);
1499                     
1500                     // let event know a tier 3 prize was won 
1501                     _eventData_.compressedData += 300000000000000000000000000000000;
1502                 }
1503                 // set airdrop happened bool to true
1504                 _eventData_.compressedData += 10000000000000000000000000000000;
1505                 // let event know how much was won 
1506                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1507                 
1508                 // reset air drop tracker
1509                 airDropTracker_ = 0;
1510             }
1511         }
1512     
1513             // store the air drop tracker number (number of buys since last airdrop)
1514             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1515             
1516             // update player 
1517             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1518             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1519             
1520             // update round
1521             round_[_rID].keys = _keys.add(round_[_rID].keys);
1522             round_[_rID].eth = _eth.add(round_[_rID].eth);
1523             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1524     
1525             // distribute eth
1526             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1527             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1528             
1529             // call end tx function to fire end tx event.
1530 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1531         }
1532     }
1533 //==============================================================================
1534 //     _ _ | _   | _ _|_ _  _ _  .
1535 //    (_(_||(_|_||(_| | (_)| _\  .
1536 //==============================================================================
1537     /**
1538      * @dev calculates unmasked earnings (just calculates, does not update mask)
1539      * @return earnings in wei format
1540      */
1541     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1542         private
1543         view
1544         returns(uint256)
1545     {
1546         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1547     }
1548     
1549     /** 
1550      * @dev returns the amount of keys you would get given an amount of eth. 
1551      * -functionhash- 0xce89c80c
1552      * @param _rID round ID you want price for
1553      * @param _eth amount of eth sent in 
1554      * @return keys received 
1555      */
1556     function calcKeysReceived(uint256 _rID, uint256 _eth)
1557         public
1558         view
1559         returns(uint256)
1560     {
1561         // grab time
1562         uint256 _now = now;
1563         
1564         // are we in a round?
1565         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1566             return ( (round_[_rID].eth).keysRec(_eth) );
1567         else // rounds over.  need keys for new round
1568             return ( (_eth).keys() );
1569     }
1570     
1571     /** 
1572      * @dev returns current eth price for X keys.  
1573      * -functionhash- 0xcf808000
1574      * @param _keys number of keys desired (in 18 decimal format)
1575      * @return amount of eth needed to send
1576      */
1577     function iWantXKeys(uint256 _keys)
1578         public
1579         view
1580         returns(uint256)
1581     {
1582         // setup local rID
1583         uint256 _rID = rID_;
1584         
1585         // grab time
1586         uint256 _now = now;
1587         
1588         // are we in a round?
1589         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1590             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1591         else // rounds over.  need price for new round
1592             return ( (_keys).eth() );
1593     }
1594 //==============================================================================
1595 //    _|_ _  _ | _  .
1596 //     | (_)(_)|_\  .
1597 //==============================================================================
1598     /**
1599 	 * @dev receives name/player info from names contract 
1600      */
1601     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1602         external
1603     {
1604         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1605         if (pIDxAddr_[_addr] != _pID)
1606             pIDxAddr_[_addr] = _pID;
1607         if (pIDxName_[_name] != _pID)
1608             pIDxName_[_name] = _pID;
1609         if (plyr_[_pID].addr != _addr)
1610             plyr_[_pID].addr = _addr;
1611         if (plyr_[_pID].name != _name)
1612             plyr_[_pID].name = _name;
1613         if (plyr_[_pID].laff != _laff)
1614             plyr_[_pID].laff = _laff;
1615         if (plyrNames_[_pID][_name] == false)
1616             plyrNames_[_pID][_name] = true;
1617     }
1618     
1619     /**
1620      * @dev receives entire player name list 
1621      */
1622     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1623         external
1624     {
1625         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1626         if(plyrNames_[_pID][_name] == false)
1627             plyrNames_[_pID][_name] = true;
1628     }   
1629         
1630     /**
1631      * @dev gets existing or registers new pID.  use this when a player may be new
1632      * @return pID 
1633      */
1634     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1635         private
1636         returns (F3Ddatasets.EventReturns)
1637     {
1638         uint256 _pID = pIDxAddr_[msg.sender];
1639         // if player is new to this version of fomo3d
1640         if (_pID == 0)
1641         {
1642             // grab their player ID, name and last aff ID, from player names contract 
1643             _pID = PlayerBook.getPlayerID(msg.sender);
1644             bytes32 _name = PlayerBook.getPlayerName(_pID);
1645             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1646             
1647             // set up player account 
1648             pIDxAddr_[msg.sender] = _pID;
1649             plyr_[_pID].addr = msg.sender;
1650             
1651             if (_name != "")
1652             {
1653                 pIDxName_[_name] = _pID;
1654                 plyr_[_pID].name = _name;
1655                 plyrNames_[_pID][_name] = true;
1656             }
1657             
1658             if (_laff != 0 && _laff != _pID)
1659                 plyr_[_pID].laff = _laff;
1660             
1661             // set the new player bool to true
1662             _eventData_.compressedData = _eventData_.compressedData + 1;
1663         } 
1664         return (_eventData_);
1665     }
1666     
1667     /**
1668      * @dev checks to make sure user picked a valid team.  if not sets team 
1669      * to default (sneks)
1670      */
1671     function verifyTeam(uint256 _team)
1672         private
1673         pure
1674         returns (uint256)
1675     {
1676         if (_team < 0 || _team > 3)
1677             return(2);
1678         else
1679             return(_team);
1680     }
1681     
1682     /**
1683      * @dev decides if round end needs to be run & new round started.  and if 
1684      * player unmasked earnings from previously played rounds need to be moved.
1685      */
1686     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1687         private
1688         returns (F3Ddatasets.EventReturns)
1689     {
1690         // if player has played a previous round, move their unmasked earnings
1691         // from that round to gen vault.
1692         if (plyr_[_pID].lrnd != 0)
1693             updateGenVault(_pID, plyr_[_pID].lrnd);
1694             
1695         // update player's last round played
1696         plyr_[_pID].lrnd = rID_;
1697             
1698         // set the joined round bool to true
1699         _eventData_.compressedData = _eventData_.compressedData + 10;
1700         
1701         return(_eventData_);
1702     }
1703     
1704     /**
1705      * @dev ends the round. manages paying out winner/splitting up pot
1706      */
1707     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1708         private
1709         returns (F3Ddatasets.EventReturns)
1710     {
1711         // setup local rID
1712         uint256 _rID = rID_;
1713         
1714         // grab our winning player and team id's
1715         uint256 _winPID = round_[_rID].plyr;
1716         uint256 _winTID = round_[_rID].team;
1717         
1718         // grab our pot amount
1719         uint256 _pot = round_[_rID].pot;
1720         
1721         // calculate our winner share, community rewards, gen share, 
1722         // p3d share, and amount reserved for next pot 
1723         uint256 _win = (_pot.mul(48)) / 100;
1724         uint256 _com = (_pot / 20);
1725         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1726         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1727         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1728         
1729         // calculate ppt for round mask
1730         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1731         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1732         if (_dust > 0)
1733         {
1734             _gen = _gen.sub(_dust);
1735             _res = _res.add(_dust);
1736         }
1737         
1738         // pay our winner
1739         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1740         
1741         // community rewards
1742         
1743         teamWallet.transfer(_com);
1744         
1745         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1746         // {
1747         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1748         //     // bank migrations by breaking outgoing transactions.
1749         //     // Something we would never do. But that's not the point.
1750         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1751         //     // highest belief that everything we create should be trustless.
1752         //     // Team JUST, The name you shouldn't have to trust.
1753         //     _p3d = _p3d.add(_com);
1754         //     _com = 0;
1755         // }
1756         
1757         // distribute gen portion to key holders
1758         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1759         
1760         // send share for p3d to divies
1761         // if (_p3d > 0)
1762         //     Divies.deposit.value(_p3d)();
1763             
1764         // prepare event data
1765         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1766         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1767         _eventData_.winnerAddr = plyr_[_winPID].addr;
1768         _eventData_.winnerName = plyr_[_winPID].name;
1769         _eventData_.amountWon = _win;
1770         _eventData_.genAmount = _gen;
1771         _eventData_.P3DAmount = _p3d;
1772         _eventData_.newPot = _res;
1773         
1774         // start next round
1775         rID_++;
1776         _rID++;
1777         round_[_rID].strt = now;
1778         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1779         round_[_rID].pot = _res;
1780         
1781         return(_eventData_);
1782     }
1783     
1784     /**
1785      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1786      */
1787     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1788         private 
1789     {
1790         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1791         if (_earnings > 0)
1792         {
1793             // put in gen vault
1794             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1795             // zero out their earnings by updating mask
1796             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1797         }
1798     }
1799     
1800     /**
1801      * @dev updates round timer based on number of whole keys bought.
1802      */
1803     function updateTimer(uint256 _keys, uint256 _rID)
1804         private
1805     {
1806         // grab time
1807         uint256 _now = now;
1808         
1809         // calculate time based on number of keys bought
1810         uint256 _newTime;
1811         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1812             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1813         else
1814             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1815         
1816         // compare to max and set new end time
1817         if (_newTime < (rndMax_).add(_now))
1818             round_[_rID].end = _newTime;
1819         else
1820             round_[_rID].end = rndMax_.add(_now);
1821     }
1822     
1823     /**
1824      * @dev generates a random number between 0-99 and checks to see if thats
1825      * resulted in an airdrop win
1826      * @return do we have a winner?
1827      */
1828     function airdrop()
1829         private 
1830         view 
1831         returns(bool)
1832     {
1833         uint256 seed = uint256(keccak256(abi.encodePacked(
1834             
1835             (block.timestamp).add
1836             (block.difficulty).add
1837             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1838             (block.gaslimit).add
1839             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1840             (block.number)
1841             
1842         )));
1843         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1844             return(true);
1845         else
1846             return(false);
1847     }
1848 
1849     /**
1850      * @dev distributes eth based on fees to com, aff, and p3d
1851      */
1852     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1853         private
1854         returns(F3Ddatasets.EventReturns)
1855     {
1856         // pay 10% out to community rewards
1857         uint256 _com = _eth / 10;
1858         //uint256 _p3d;
1859 
1860         teamWallet.transfer(_com);
1861         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1862         // {
1863         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1864         //     // bank migrations by breaking outgoing transactions.
1865         //     // Something we would never do. But that's not the point.
1866         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1867         //     // highest belief that everything we create should be trustless.
1868         //     // Team JUST, The name you shouldn't have to trust.
1869         //     _p3d = _com;
1870         //     _com = 0;
1871         // }
1872         
1873         // pay 1% out to FoMo3D short
1874         uint256 _leader = _eth / 20;
1875         //otherF3D_.potSwap.value(_long)();
1876         
1877         // distribute share to affiliate
1878         uint256 _aff = _eth / 10;
1879         
1880         // decide what to do with affiliate share of fees
1881         // affiliate must not be self, and must have a name registered
1882         if (_affID != _pID && plyr_[_affID].name != '') {
1883             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1884             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1885         } else {
1886             _leader =_leader.add(_aff);
1887         }
1888         
1889         leaderWallets[_team].transfer(_leader);
1890 
1891         // pay out p3d
1892         // _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1893         // if (_p3d > 0)
1894         // {
1895         //     // deposit to divies contract
1896         //     Divies.deposit.value(_p3d)();
1897             
1898         //     // set up event data
1899         //     _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1900         // }
1901         
1902         return(_eventData_);
1903     }
1904     
1905     function potSwap()
1906         external
1907         payable
1908     {
1909         // setup local rID
1910         uint256 _rID = rID_ + 1;
1911         
1912         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1913         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1914     }
1915     
1916     /**
1917      * @dev distributes eth based on fees to gen and pot
1918      */
1919     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1920         private
1921         returns(F3Ddatasets.EventReturns)
1922     {
1923         // calculate gen share
1924         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1925         
1926         // toss 1% into airdrop pot 
1927         uint256 _air = (_eth / 100);
1928         airDropPot_ = airDropPot_.add(_air);
1929         
1930         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1931         _eth = _eth.sub(((_eth.mul(26)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1932         
1933         // calculate pot 
1934         uint256 _pot = _eth.sub(_gen);
1935         
1936         // distribute gen share (thats what updateMasks() does) and adjust
1937         // balances for dust.
1938         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1939         if (_dust > 0)
1940             _gen = _gen.sub(_dust);
1941         
1942         // add eth to pot
1943         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1944         
1945         // set up event data
1946         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1947         _eventData_.potAmount = _pot;
1948         
1949         return(_eventData_);
1950     }
1951 
1952     /**
1953      * @dev updates masks for round and player when keys are bought
1954      * @return dust left over 
1955      */
1956     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1957         private
1958         returns(uint256)
1959     {
1960         /* MASKING NOTES
1961             earnings masks are a tricky thing for people to wrap their minds around.
1962             the basic thing to understand here.  is were going to have a global
1963             tracker based on profit per share for each round, that increases in
1964             relevant proportion to the increase in share supply.
1965             
1966             the player will have an additional mask that basically says "based
1967             on the rounds mask, my shares, and how much i've already withdrawn,
1968             how much is still owed to me?"
1969         */
1970         
1971         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1972         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1973         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1974             
1975         // calculate player earning from their own buy (only based on the keys
1976         // they just bought).  & update player earnings mask
1977         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1978         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1979         
1980         // calculate & return dust
1981         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1982     }
1983     
1984     /**
1985      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1986      * @return earnings in wei format
1987      */
1988     function withdrawEarnings(uint256 _pID)
1989         private
1990         returns(uint256)
1991     {
1992         // update gen vault
1993         updateGenVault(_pID, plyr_[_pID].lrnd);
1994         
1995         // from vaults 
1996         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1997         if (_earnings > 0)
1998         {
1999             plyr_[_pID].win = 0;
2000             plyr_[_pID].gen = 0;
2001             plyr_[_pID].aff = 0;
2002         }
2003 
2004         return(_earnings);
2005     }
2006     
2007     /**
2008      * @dev prepares compression data and fires event for buy or reload tx's
2009      */
2010     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
2011         private
2012     {
2013         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
2014         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
2015         
2016         emit F3Devents.onEndTx
2017         (
2018             _eventData_.compressedData,
2019             _eventData_.compressedIDs,
2020             plyr_[_pID].name,
2021             msg.sender,
2022             _eth,
2023             _keys,
2024             _eventData_.winnerAddr,
2025             _eventData_.winnerName,
2026             _eventData_.amountWon,
2027             _eventData_.newPot,
2028             _eventData_.P3DAmount,
2029             _eventData_.genAmount,
2030             _eventData_.potAmount,
2031             airDropPot_
2032         );
2033     }
2034 //==============================================================================
2035 //    (~ _  _    _._|_    .
2036 //    _)(/_(_|_|| | | \/  .
2037 //====================/=========================================================
2038     /** upon contract deploy, it will be deactivated.  this is a one time
2039      * use function that will activate the contract.  we do this so devs 
2040      * have time to set things up on the web end                            **/
2041     bool public activated_ = false;
2042     function activate()
2043         onlyDevs()
2044         public
2045     {
2046 		// make sure that its been linked.
2047         // can only be ran once
2048         require(activated_ == false, "fomo3d already activated");
2049         
2050         // activate the contract 
2051         activated_ = true;
2052         
2053         // lets start first round
2054 		rID_ = 1;
2055         round_[1].strt = now + rndExtra_ - rndGap_;
2056         round_[1].end = now + rndInit_ + rndExtra_;
2057     }
2058 }