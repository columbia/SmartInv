1 pragma solidity 0.5.2;
2 
3 /*
4 "Crypto Casino 333" (c) v.1.0
5 Copyright (c) 2019 by -= 333ETH Team =-
6 
7 THIS IS TEST CONTRACT!!! DO NOT PLACE BET!!!
8 
9 * Web - https://333eth.io
10 * Telegram_channel - https://t.me/Ethereum333
11 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
12 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
13 *
14 
15 ... Fortes fortuna juvat ...
16 
17 The innovative totally fair gambling platform -
18 A unique symbiosis of the classic online casino system and the revolutionary possibilities of the blockchain, using the power of the Ethereum smart contract for 100% transparency.
19 
20 "Crypto Casino 333" is the quintessence of fair winning opportunities for any participant on equal terms. The system and technologies are transparent due to the blockchain, which is really capable of meeting all your expectations.
21 
22 ... Alea jacta est ...
23 
24 We start  project without ICO & provide the following guarantees:
25 
26 - ABSOLUTE TRANSPARENCY -
27 The random number generator is based on an Ethereum Smart Contract which is completely public. This means that everyone can see everything that is occurring inside the servers of the casino.
28 
29 - NO HUMAN FACTOR -
30 All transactions are processed automatically according to the smart contract algorithms.
31 
32 - TOTAL PROTECTION & PRIVACY -
33 All transactions are processed anonymously inside smart contract.
34 
35 
36 - TOTALLY FINANCIAL PLEASURE -
37 Only 1% casino commission, 99% goes to payout wins. Instant automatic withdrawal of funds directly from the smart contract.
38 
39 Copyright (c) 2019 by -= 333ETH Team =-
40 "Games People are playing"
41 
42 
43 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
44 
45 */
46 
47 
48 
49 library PaymentLib {
50   struct Payment {
51     address payable beneficiary;
52     uint amount;
53     bytes32 message;
54   }
55 
56   event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
57   event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
58 
59   function send(Payment memory p) internal {
60     if (p.beneficiary.send(p.amount)) {
61       emit LogPayment(p.beneficiary, p.amount, p.message);
62     } else {
63       emit LogFailedPayment(p.beneficiary, p.amount, p.message);
64     }
65   }
66 }
67 
68 
69 
70 library BytesLib {
71 
72 
73   // index returns the index of the first instance of sub in s, or -1 if sub is not present in s. 
74   function index(bytes memory b, bytes memory subb, uint start) internal pure returns(int) {
75     uint lensubb = subb.length;
76     
77     uint hashsubb;
78     uint ptrb;
79     assembly {
80       hashsubb := keccak256(add(subb, 0x20), lensubb)
81       ptrb := add(b, 0x20)
82     }
83     
84     for (uint lenb = b.length; start < lenb; start++) {
85       if (start+lensubb > lenb) {
86         return -1;
87       }
88       bool found;
89       assembly {
90         found := eq(keccak256(add(ptrb, start), lensubb), hashsubb)
91       }
92       if (found) {
93         return int(start);
94       }
95     }
96     return -1;
97     
98     /* assembly
99     require(subb.length < 32,"unsuppotyed bytes len");
100     
101     bool found;
102     assembly {
103       let lenb := mload(b) 
104       let lensubb := mload(subb)  
105       let subbHash := keccak256(add(subb, 0x20), lensubb)
106       let ptrb := add(b, 0x20)
107       for 
108         {} 
109         and(and(lt(start, lenb), eq(found, 0)), lt(add(start, lensubb), add(lenb,1))) 
110         { start := add(start, 1) }
111       {
112         found := eq(keccak256(add(ptrb, start), lensubb), subbHash)
113       }
114 
115     }
116     if (found) {
117       return int(start)-1;
118     }
119     return -1;
120     */
121 
122     
123     // brute force solidity
124     // for ((uint i, bool found) = (start, true); i < b.length; (i++, found = true)) {
125     //   for (uint j = 0; j < sub.length; j++) {
126     //     if (i+j > b.length-1) {
127     //       found = false;
128     //       break;
129     //     }
130     //     if (b[i+j] != sub[j]) {
131     //       found = false;
132     //       break;
133     //     }
134     //   }
135     //   if (found) {
136     //     return int(i);
137     //   }
138     // }
139     // return -1;
140   }  
141   
142   // index returns the index of the first instance of sub in s, or -1 if sub is not present in s. 
143   function index(bytes memory b, bytes memory sub) internal pure returns(int) {
144     return index(b, sub, 0);
145   }
146 
147   function index(bytes memory b, byte sub, uint start) internal pure returns(int) {
148     for (uint len = b.length; start < len; start++) {
149       if (b[start] == sub) {
150         return int(start);
151       }
152     }
153     return -1;
154   }
155 
156   function index(bytes memory b, byte sub) internal pure returns(int) {
157     return index(b, sub, 0);
158   }
159 
160   function count(bytes memory b, bytes memory sub) internal pure returns(uint times) {
161     int i = index(b, sub, 0);
162     while (i != -1) {
163       times++;
164       i = index(b, sub, uint(i)+sub.length);
165     }
166   }
167   
168   function equals(bytes memory b, bytes memory a) internal pure returns(bool equal) {
169     if (b.length != a.length) {
170       return false;
171     }
172     
173     uint len = b.length;
174     
175     assembly {
176       equal := eq(keccak256(add(b, 0x20), len), keccak256(add(a, 0x20), len))
177     }  
178   }
179   
180   function copy(bytes memory b) internal pure returns(bytes memory) {
181     return abi.encodePacked(b);
182   }
183   
184   function slice(bytes memory b, uint start, uint end) internal pure returns(bytes memory r) {
185     if (start > end) {
186       return r;
187     }
188     if (end > b.length-1) {
189       end = b.length-1;
190     }
191     r = new bytes(end-start+1);
192     
193     uint j;
194     uint i = start;
195     for (; i <= end; (i++, j++)) {
196       r[j] = b[i];
197     }
198   }
199   
200   function append(bytes memory b, bytes memory a) internal pure returns(bytes memory r) {
201     return abi.encodePacked(b, a);
202   }
203   
204   
205   function replace(bytes memory b, bytes memory oldb, bytes memory newb) internal pure returns(bytes memory r) {
206     if (equals(oldb, newb)) {
207       return copy(b);
208     }
209     
210     uint n = count(b, oldb);
211     if (n == 0) {
212       return copy(b);
213     }
214     
215     uint start;
216     for (uint i; i < n; i++) {
217       uint j = start;
218       j += uint(index(slice(b, start, b.length-1), oldb));  
219       if (j!=0) {
220         r = append(r, slice(b, start, j-1));
221       }
222       
223       r = append(r, newb);
224       start = j + oldb.length;
225     }
226     if (r.length != b.length+n*(newb.length-oldb.length)) {
227       r = append(r, slice(b, start, b.length-1));
228     }
229   }
230 
231   function fillPattern(bytes memory b, bytes memory pattern, byte newb) internal pure returns (uint n) {
232     uint start;
233     while (true) {
234       int i = index(b, pattern, start);
235       if (i < 0) {
236         return n;
237       }
238       uint len = pattern.length;
239       for (uint k = 0; k < len; k++) {
240         b[uint(i)+k] = newb;
241       }
242       start = uint(i)+len;
243       n++;
244     }
245   }
246 }
247 
248 
249 
250 
251 
252 library NumberLib {
253   struct Number {
254     uint num;
255     uint den;
256   }
257 
258   function muluint(Number memory a, uint b) internal pure returns (uint) {
259     return b * a.num / a.den;
260   }
261 
262   function mmul(Number memory a, uint b) internal pure returns(Number memory) {
263     a.num = a.num * b;
264     return a;
265   }
266 
267   function maddm(Number memory a, Number memory b) internal pure returns(Number memory) {
268     a.num = a.num * b.den + b.num * a.den;
269     a.den = a.den * b.den;
270     return a;
271   }
272 
273   function madds(Number memory a, Number storage b) internal view returns(Number memory) {
274     a.num = a.num * b.den + b.num * a.den;
275     a.den = a.den * b.den;
276     return a;
277   }
278 
279   // function mul(Number memory a, uint b) internal pure returns (Number memory c) {
280   //   c.num = a.num * b;
281   //   c.den = a.den;
282   // }
283 
284   // function add(Number memory a, Number memory b) internal pure returns (Number memory c) {
285   //   c.num = a.num * b.den + b.num * a.den;
286   //   c.den = a.den * b.den;
287   // }
288 
289 //   function div(Number storage p, uint a) internal view returns (uint) {
290 //     return a/p.num*p.den;
291 //   }
292 
293 //   function sub(Number storage p, uint a) internal view returns (uint) {
294 //     uint b = mul(p, a);
295 //     if (b >= a) return 0;
296 //     return a - b;
297 //   }
298 }
299 
300 library Rnd {
301   byte internal constant NONCE_SEP = "\x3a"; // ':'
302 
303   function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n) internal pure returns(uint) {
304     return uint(keccak256(abi.encodePacked(hostSeed, clientSeed))) % n;
305   }
306 
307   function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n, bytes memory nonce) internal pure returns(uint) {
308     return uint(keccak256(abi.encodePacked(hostSeed, clientSeed, NONCE_SEP, nonce))) % n;
309   }
310 }
311 
312 
313 
314 library ProtLib {
315   function checkBlockHash(uint blockNumber, bytes32 blockHash) internal view {
316     require(block.number > blockNumber, "protection lib: current block must be great then block number");
317     require(blockhash(blockNumber) != bytes32(0), "protection lib: blockhash can't be queried by EVM");
318     require(blockhash(blockNumber) == blockHash, "protection lib: invalid block hash");
319   }
320 
321   function checkSigner(address signer, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal pure {
322     require(signer == ecrecover(message, v, r, s), "protection lib: ECDSA signature is not valid");
323   }
324 
325   function checkSigner(address signer, uint expirationBlock, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal view {
326     require(block.number <= expirationBlock, "protection lib: signature has expired");
327     checkSigner(signer, keccak256(abi.encodePacked(message, expirationBlock)), v, r, s);
328     // require(
329     //   signer == ecrecover(keccak256(abi.encodePacked(message, expirationBlock)), v, r, s), 
330     //   "protection lib: ECDSA signature is not valid"
331     // );
332   }
333 }
334 
335 
336 /**
337  * @title SafeMath
338  * @dev Unsigned math operations with safety checks that revert on error
339  */
340 library SafeMath {
341     /**
342      * @dev Multiplies two unsigned integers, reverts on overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
348         if (a == 0) {
349             return 0;
350         }
351 
352         uint256 c = a * b;
353         require(c / a == b);
354 
355         return c;
356     }
357 
358     /**
359      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
360      */
361     function div(uint256 a, uint256 b) internal pure returns (uint256) {
362         // Solidity only automatically asserts when dividing by 0
363         require(b > 0);
364         uint256 c = a / b;
365         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
366 
367         return c;
368     }
369 
370     /**
371      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
372      */
373     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
374         require(b <= a);
375         uint256 c = a - b;
376 
377         return c;
378     }
379 
380     /**
381      * @dev Adds two unsigned integers, reverts on overflow.
382      */
383     function add(uint256 a, uint256 b) internal pure returns (uint256) {
384         uint256 c = a + b;
385         require(c >= a);
386 
387         return c;
388     }
389 
390     /**
391      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
392      * reverts when dividing by zero.
393      */
394     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
395         require(b != 0);
396         return a % b;
397     }
398 }
399 
400 
401 
402 library SlotGameLib {
403   using BytesLib for bytes;
404   using SafeMath for uint;
405   using SafeMath for uint128;
406   using NumberLib for NumberLib.Number;
407 
408   struct Bet {
409     uint amount; 
410     uint40 blockNumber; // 40
411     address payable gambler; // 160
412     bool exist; // 1
413   }
414 
415   function remove(Bet storage bet) internal {
416     delete bet.amount;
417     delete bet.blockNumber;
418     delete bet.gambler;
419   }
420 
421   struct Combination {
422     bytes symbols;
423     NumberLib.Number multiplier;
424   }
425 
426   struct SpecialCombination {
427     byte symbol;
428     NumberLib.Number multiplier;
429     uint[] indexes; // not uint8, optimize spin and hasIn
430   }
431 
432   function hasIn(SpecialCombination storage sc, bytes memory symbols) internal view returns (bool) {
433     uint len = sc.indexes.length;
434     byte symbol = sc.symbol;
435     for (uint i = 0; i < len; i++) {
436       if (symbols[sc.indexes[i]] != symbol) {
437         return false;
438       }
439     }
440     return true;
441   }
442 
443   // the symbol that don't use in reels
444   byte private constant UNUSED_SYMBOL = "\xff"; // 255
445   uint internal constant REELS_LEN = 9;
446   uint private constant BIG_COMBINATION_MIN_LEN = 8;
447   bytes32 private constant PAYMENT_LOG_MSG = "slot";
448   bytes32 private constant REFUND_LOG_MSG = "slot.refund";
449   uint private constant HANDLE_BET_COST = 0.001 ether;
450   uint private constant HOUSE_EDGE_PERCENT = 1;
451   uint private constant JACKPOT_PERCENT = 1;
452   uint private constant MIN_WIN_PERCENT = 30;
453   uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100 / MIN_WIN_PERCENT * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
454   
455   function MinBetAmount() internal pure returns(uint) {
456     return MIN_BET_AMOUNT;
457   }
458 
459   
460   struct Game {
461     address secretSigner;
462     uint128 lockedInBets;
463     uint128 jackpot;
464     uint maxBetAmount;
465     uint minBetAmount;
466 
467     bytes[REELS_LEN] reels;
468     // pay table array with prioritet for 0-elem to N-elem, where 0 - MAX prior and N - LOW prior
469     Combination[] payTable;
470     SpecialCombination[] specialPayTable;
471 
472     mapping(bytes32 => Bet) bets;
473   }
474 
475   event LogSlotNewBet(
476     bytes32 indexed hostSeedHash,
477     address indexed gambler,
478     uint amount,
479     address indexed referrer
480   );
481 
482   event LogSlotHandleBet(
483     bytes32 indexed hostSeedHash,
484     address indexed gambler,
485     bytes32 hostSeed,
486     bytes32 clientSeed,
487     bytes symbols,
488     uint multiplierNum,
489     uint multiplierDen,
490     uint amount,
491     uint winnings
492   );
493 
494   event LogSlotRefundBet(
495     bytes32 indexed hostSeedHash,
496     address indexed gambler, 
497     uint amount
498   );
499 
500   function setReel(Game storage game, uint n, bytes memory symbols) internal {
501     require(REELS_LEN > n, "slot game: invalid reel number");
502     require(symbols.length > 0, "slot game: invalid reel`s symbols length");
503     require(symbols.index(UNUSED_SYMBOL) == -1, "slot game: reel`s symbols contains invalid symbol");
504     game.reels[n] = symbols;
505   }
506 
507   function setPayLine(Game storage game, uint n, Combination memory comb) internal {
508     require(n <= game.payTable.length, "slot game: invalid pay line number");
509     require(comb.symbols.index(UNUSED_SYMBOL) == -1, "slot game: combination symbols contains invalid symbol");
510 
511     if (n == game.payTable.length && comb.symbols.length > 0) {
512       game.payTable.push(comb);
513       return;
514     } 
515     
516     if (n == game.payTable.length-1 && comb.symbols.length == 0) {
517       game.payTable.pop();
518       return;
519     }
520 
521     require(
522       0 < comb.symbols.length && comb.symbols.length <= REELS_LEN, 
523       "slot game: invalid combination`s symbols length"
524     );
525     game.payTable[n] = comb;
526   }
527 
528   function setSpecialPayLine(Game storage game, uint n, SpecialCombination memory scomb) internal {
529     require(game.specialPayTable.length >= n, "slot game: invalid pay line number");
530     require(scomb.symbol != UNUSED_SYMBOL, "slot game: invalid special combination`s symbol");
531 
532     if (n == game.specialPayTable.length && scomb.indexes.length > 0) {
533       game.specialPayTable.push(scomb);
534       return;
535     } 
536     
537     if (n == game.specialPayTable.length-1 && scomb.indexes.length == 0) {
538       game.specialPayTable.pop();
539       return;
540     }
541 
542     require(
543       0 < scomb.indexes.length && scomb.indexes.length <= REELS_LEN, 
544       "slot game: invalid special combination`s indexes length"
545     );
546     game.specialPayTable[n] = scomb;
547   }
548 
549   function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
550     require(minBetAmount >= MIN_BET_AMOUNT, "slot game: invalid min of bet amount");
551     require(minBetAmount <= maxBetAmount, "slot game: invalid [min, max] range of bet amount");
552     game.minBetAmount = minBetAmount;
553     game.maxBetAmount = maxBetAmount;
554   }
555 
556   function placeBet(
557     Game storage game,
558     address referrer,
559     uint sigExpirationBlock,
560     bytes32 hostSeedHash,
561     uint8 v, 
562     bytes32 r, 
563     bytes32 s
564   ) 
565     internal
566   {
567     ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
568 
569     Bet storage bet = game.bets[hostSeedHash];
570     require(!bet.exist, "slot game: bet already exist");
571     require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "slot game: invalid bet amount");
572     
573     bet.amount = msg.value;
574     bet.blockNumber = uint40(block.number);
575     bet.gambler = msg.sender;
576     bet.exist = true;
577     
578     game.lockedInBets += uint128(msg.value);
579     game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
580 
581     emit LogSlotNewBet(
582       hostSeedHash, 
583       msg.sender, 
584       msg.value,
585       referrer
586     );
587   }
588 
589 
590   // function placeBet(
591   //   Game storage game,
592   //   address referrer,
593   //   bytes32 hostSeedHash,
594   //   uint8 v, 
595   //   bytes32 r, 
596   //   bytes32 s
597   // ) 
598   //   internal
599   // {
600   //   ProtLib.checkSigner(game.secretSigner, hostSeedHash, v, r, s);
601 
602   //   Bet storage bet = game.bets[hostSeedHash];
603   //   require(!bet.exist, "slot game: bet already exist");
604   //   require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "slot game: invalid bet amount");
605     
606   //   bet.amount = msg.value;
607   //   bet.blockNumber = uint40(block.number);
608   //   bet.gambler = msg.sender;
609   //   bet.exist = true;
610     
611   //   game.lockedInBets += uint128(msg.value);
612   //   game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
613 
614   //   emit LogSlotNewBet(
615   //     hostSeedHash, 
616   //     msg.sender, 
617   //     msg.value,
618   //     referrer
619   //   );
620   // }
621 
622   function handleBet(
623     Game storage game,
624     bytes32 hostSeed,
625     bytes32 clientSeed
626   ) 
627     internal 
628     returns(
629       PaymentLib.Payment memory p
630     ) 
631   {
632     bytes32 hostSeedHash = keccak256(abi.encodePacked(hostSeed));
633     Bet storage bet = game.bets[hostSeedHash];
634     uint betAmount = bet.amount;
635     require(bet.exist, "slot game: bet does not exist");
636     require(betAmount > 0, "slot game: bet already handled");
637     ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
638     game.lockedInBets -= uint128(betAmount);
639 
640     Combination memory c = spin(game, hostSeed, clientSeed);
641     uint winnings = c.multiplier.muluint(betAmount);
642 
643     if (winnings > 0) {
644       winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
645       winnings = winnings.sub(HANDLE_BET_COST);
646     }
647     p.beneficiary = bet.gambler; 
648     p.amount = winnings; 
649     p.message = PAYMENT_LOG_MSG; 
650 
651     emit LogSlotHandleBet(
652       hostSeedHash,
653       p.beneficiary, 
654       hostSeed, 
655       clientSeed, 
656       c.symbols, 
657       c.multiplier.num, 
658       c.multiplier.den,
659       betAmount,
660       winnings
661     );
662     remove(bet);
663   }
664   
665   function spin(
666     Game storage game,
667     bytes32 hostSeed,
668     bytes32 clientSeed
669   ) 
670     internal 
671     view 
672     returns (
673       Combination memory combination
674     ) 
675   {
676     bytes memory symbolsTmp = new bytes(REELS_LEN);
677     for (uint i; i < REELS_LEN; i++) {
678       bytes memory nonce = abi.encodePacked(uint8(i));
679       symbolsTmp[i] = game.reels[i][Rnd.uintn(hostSeed, clientSeed, game.reels[i].length, nonce)];
680     }
681     combination.symbols = symbolsTmp.copy();
682     combination.multiplier = NumberLib.Number(0, 1); // 0/1 == 0.0
683     
684     for ((uint i, uint length) = (0, game.payTable.length); i < length; i++) {
685       bytes memory tmp = game.payTable[i].symbols;
686       uint times = symbolsTmp.fillPattern(tmp, UNUSED_SYMBOL);
687       if (times > 0) {
688         combination.multiplier.maddm(game.payTable[i].multiplier.mmul(times));
689         if (tmp.length >= BIG_COMBINATION_MIN_LEN) {
690           return combination; 
691 			  }
692       }
693     }
694     
695     for ((uint i, uint length) = (0, game.specialPayTable.length); i < length; i++) {
696       if (hasIn(game.specialPayTable[i], combination.symbols)) {
697         combination.multiplier.madds(game.specialPayTable[i].multiplier);
698       }
699     }
700   }
701 
702   function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
703     Bet storage bet = game.bets[hostSeedHash];
704     uint betAmount = bet.amount;
705     require(bet.exist, "slot game: bet does not exist");
706     require(betAmount > 0, "slot game: bet already handled");
707     require(blockhash(bet.blockNumber) == bytes32(0), "slot game: cannot refund bet");
708    
709     game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
710     game.lockedInBets -= uint128(betAmount);
711     p.beneficiary = bet.gambler; 
712     p.amount = betAmount; 
713     p.message = REFUND_LOG_MSG; 
714 
715     emit LogSlotRefundBet(hostSeedHash, p.beneficiary, p.amount);
716     remove(bet);
717   }
718 }
719 
720 
721 
722 library BitsLib {
723 
724   // popcnt returns the number of one bits ("population count") in x.
725   // https://en.wikipedia.org/wiki/Hamming_weight 
726   function popcnt(uint16 x) internal pure returns(uint) {
727     x -= (x >> 1) & 0x5555;
728     x = (x & 0x3333) + ((x >> 2) & 0x3333);
729     x = (x + (x >> 4)) & 0x0f0f;
730     return (x * 0x0101) >> 8;
731   }
732 }
733 
734 
735 
736 
737 library RollGameLib {
738   using NumberLib for NumberLib.Number;
739   using SafeMath for uint;
740   using SafeMath for uint128;
741 
742   // Types
743   enum Type {Coin, Square3x3, Roll}
744   uint private constant COIN_MOD = 2;
745   uint private constant SQUARE_3X3_MOD = 9;
746   uint private constant ROLL_MOD = 100;
747   bytes32 private constant COIN_PAYMENT_LOG_MSG = "roll.coin";
748   bytes32 private constant SQUARE_3X3_PAYMENT_LOG_MSG = "roll.square_3x3";
749   bytes32 private constant ROLL_PAYMENT_LOG_MSG = "roll.roll";
750   bytes32 private constant REFUND_LOG_MSG = "roll.refund";
751   uint private constant HOUSE_EDGE_PERCENT = 1;
752   uint private constant JACKPOT_PERCENT = 1;
753   uint private constant HANDLE_BET_COST = 0.0005 ether;
754   uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
755 
756   function MinBetAmount() internal pure returns(uint) {
757     return MIN_BET_AMOUNT;
758   }
759 
760   // solium-disable lbrace, whitespace
761   function module(Type t) internal pure returns(uint) {
762     if (t == Type.Coin) { return COIN_MOD; } 
763     else if (t == Type.Square3x3) { return SQUARE_3X3_MOD; } 
764     else { return ROLL_MOD; }
765   }
766 
767   function logMsg(Type t) internal pure returns(bytes32) {
768     if (t == Type.Coin) { return COIN_PAYMENT_LOG_MSG; } 
769     else if (t == Type.Square3x3) { return SQUARE_3X3_PAYMENT_LOG_MSG; }
770     else { return ROLL_PAYMENT_LOG_MSG; }
771   }
772 
773   function maskRange(Type t) internal pure returns(uint, uint) {
774     if (t == Type.Coin) { return (1, 2 ** COIN_MOD - 2); } 
775     else if (t == Type.Square3x3) { return (1, 2 ** SQUARE_3X3_MOD - 2); }
776   }
777 
778   function rollUnderRange(Type t) internal pure returns(uint, uint) {
779     if (t == Type.Roll) { return (1, ROLL_MOD - 1); } // 0..99
780   }
781   // solium-enable lbrace, whitespace
782 
783 
784 
785   struct Bet {
786     uint amount;
787     Type t; // 8
788     uint8 rollUnder; // 8
789     uint16 mask;  // 16
790     uint40 blockNumber; // 40
791     address payable gambler; // 160
792     bool exist; // 1
793   }
794 
795   function roll(
796     Bet storage bet,
797     bytes32 hostSeed,
798     bytes32 clientSeed
799   ) 
800     internal 
801     view 
802     returns (
803       uint rnd,
804       NumberLib.Number memory multiplier
805     ) 
806   {
807     uint m = module(bet.t);
808     rnd = Rnd.uintn(hostSeed, clientSeed, m);
809     multiplier.den = 1; // prevent divide to zero
810     
811     uint mask = bet.mask;
812     if (mask != 0) {
813       if (((2 ** rnd) & mask) != 0) {
814         multiplier.den = BitsLib.popcnt(uint16(mask));
815         multiplier.num = m;
816       }
817     } else {
818       uint rollUnder = bet.rollUnder;
819       if (rollUnder > rnd) {
820         multiplier.den = rollUnder;
821         multiplier.num = m;
822       }
823     }
824   }
825 
826   function remove(Bet storage bet) internal {
827     delete bet.amount;
828     delete bet.t;
829     delete bet.mask;
830     delete bet.rollUnder;
831     delete bet.blockNumber;
832     delete bet.gambler;
833   }
834 
835 
836 
837   struct Game {
838     address secretSigner;
839     uint128 lockedInBets;
840     uint128 jackpot;
841     uint maxBetAmount;
842     uint minBetAmount;
843     
844     mapping(bytes32 => Bet) bets;
845   }
846 
847   event LogRollNewBet(
848     bytes32 indexed hostSeedHash, 
849     uint8 t,
850     address indexed gambler, 
851     uint amount,
852     uint mask, 
853     uint rollUnder,
854     address indexed referrer
855   );
856 
857   event LogRollRefundBet(
858     bytes32 indexed hostSeedHash, 
859     uint8 t,
860     address indexed gambler, 
861     uint amount
862   );
863 
864   event LogRollHandleBet(
865     bytes32 indexed hostSeedHash, 
866     uint8 t,
867     address indexed gambler, 
868     bytes32 hostSeed, 
869     bytes32 clientSeed, 
870     uint roll, 
871     uint multiplierNum, 
872     uint multiplierDen,
873     uint amount,
874     uint winnings
875   );
876 
877   function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
878     require(minBetAmount >= MIN_BET_AMOUNT, "roll game: invalid min of bet amount");
879     require(minBetAmount <= maxBetAmount, "roll game: invalid [min, max] range of bet amount");
880     game.minBetAmount = minBetAmount;
881     game.maxBetAmount = maxBetAmount;
882   }
883 
884   function placeBet(
885     Game storage game, 
886     Type t, 
887     uint16 mask, 
888     uint8 rollUnder,
889     address referrer,
890     uint sigExpirationBlock,
891     bytes32 hostSeedHash, 
892     uint8 v, 
893     bytes32 r, 
894     bytes32 s
895   ) 
896     internal 
897   {
898     ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
899     Bet storage bet = game.bets[hostSeedHash];
900     require(!bet.exist, "roll game: bet already exist");
901     require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "roll game: invalid bet amount");
902 
903     {  // solium-disable indentation
904       (uint minMask, uint maxMask) = maskRange(t);
905       require(minMask <= mask && mask <= maxMask, "roll game: invalid bet mask");
906       (uint minRollUnder, uint maxRollUnder) = rollUnderRange(t);
907       require(minRollUnder <= rollUnder && rollUnder <= maxRollUnder, "roll game: invalid bet roll under");
908     }  // solium-enable indentation
909 
910     // * do not touch it!
911     bet.amount = msg.value;
912     bet.blockNumber = uint40(block.number);
913     bet.gambler = msg.sender;
914     bet.exist = true;
915     bet.mask = mask;
916     bet.rollUnder = rollUnder;
917     bet.t = t;
918     // *
919 
920     game.lockedInBets += uint128(msg.value);
921     game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
922 
923     emit LogRollNewBet(
924       hostSeedHash,
925       uint8(t),
926       msg.sender,
927       msg.value,
928       mask,
929       rollUnder,
930       referrer
931     );
932   }
933 
934 
935   function handleBet(
936     Game storage game,
937     bytes32 hostSeed,
938     bytes32 clientSeed
939   ) 
940     internal 
941     returns(
942       PaymentLib.Payment memory p
943     ) 
944   {
945     bytes32 hostSeedHash = keccak256(abi.encodePacked(hostSeed));
946     Bet storage bet = game.bets[hostSeedHash];
947     uint betAmount = bet.amount;
948     require(bet.exist, "roll game: bet does not exist");
949     require(betAmount > 0, "roll game: bet already handled");
950     ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
951     game.lockedInBets -= uint128(betAmount);
952 
953     (uint rnd, NumberLib.Number memory multiplier) = roll(bet, hostSeed, clientSeed);
954     uint winnings = multiplier.muluint(betAmount);
955   
956     if (winnings > 0) {
957       winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
958       winnings = winnings.sub(HANDLE_BET_COST);
959     }
960     p.beneficiary = bet.gambler; 
961     p.amount = winnings; 
962     p.message = logMsg(bet.t); 
963 
964     emit LogRollHandleBet(
965       hostSeedHash,
966       uint8(bet.t),
967       p.beneficiary,
968       hostSeed,
969       clientSeed,
970       rnd,
971       multiplier.num,
972       multiplier.den,
973       betAmount,
974       winnings
975     );
976     remove(bet);
977   }
978 
979 
980   function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
981     Bet storage bet = game.bets[hostSeedHash];
982     uint betAmount = bet.amount;
983     require(bet.exist, "roll game: bet does not exist");
984     require(betAmount > 0, "roll game: bet already handled");
985     require(blockhash(bet.blockNumber) == bytes32(0), "roll game: cannot refund bet");
986    
987     game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
988     game.lockedInBets -= uint128(betAmount);
989     p.beneficiary = bet.gambler; 
990     p.amount = betAmount; 
991     p.message = REFUND_LOG_MSG; 
992 
993     emit LogRollRefundBet(hostSeedHash, uint8(bet.t), p.beneficiary, p.amount);
994     remove(bet);
995   }
996 }
997 
998 
999 
1000 contract Accessibility {
1001   enum AccessRank { None, Croupier, Games, Withdraw, Full }
1002   mapping(address => AccessRank) public admins;
1003   modifier onlyAdmin(AccessRank  r) {
1004     require(
1005       admins[msg.sender] == r || admins[msg.sender] == AccessRank.Full,
1006       "accessibility: access denied"
1007     );
1008     _;
1009   }
1010   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
1011 
1012   constructor() public {
1013     admins[msg.sender] = AccessRank.Full;
1014     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
1015   }
1016   
1017   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
1018     require(admins[addr] != AccessRank.Full, "accessibility: cannot change full access rank");
1019     if (admins[addr] != rank) {
1020       admins[addr] = rank;
1021       emit LogProvideAccess(addr, now, rank);
1022     }
1023   }
1024 }
1025 
1026 
1027 contract Casino is Accessibility {
1028   using PaymentLib for PaymentLib.Payment;
1029   using RollGameLib for RollGameLib.Game;
1030   using SlotGameLib for SlotGameLib.Game;
1031 
1032   bytes32 private constant JACKPOT_LOG_MSG = "casino.jackpot";
1033   bytes32 private constant WITHDRAW_LOG_MSG = "casino.withdraw";
1034   bytes private constant JACKPOT_NONCE = "jackpot";
1035   uint private constant MIN_JACKPOT_MAGIC = 3333;
1036   uint private constant MAX_JACKPOT_MAGIC = 333333333;
1037   
1038   SlotGameLib.Game public slot;
1039   RollGameLib.Game public roll;
1040   enum Game {Slot, Roll}
1041 
1042   uint public extraJackpot;
1043   uint public jackpotMagic;
1044 
1045   modifier slotBetsWasHandled() {
1046     require(slot.lockedInBets == 0, "casino.slot: all bets should be handled");
1047     _;
1048   }
1049 
1050   event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
1051   event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
1052 
1053   event LogJactpot(
1054     address indexed beneficiary, 
1055     uint amount, 
1056     bytes32 hostSeed,
1057     bytes32 clientSeed,
1058     uint jackpotMagic
1059   );
1060 
1061   event LogSlotNewBet(
1062     bytes32 indexed hostSeedHash,
1063     address indexed gambler,
1064     uint amount,
1065     address indexed referrer
1066   );
1067 
1068   event LogSlotHandleBet(
1069     bytes32 indexed hostSeedHash,
1070     address indexed gambler,
1071     bytes32 hostSeed,
1072     bytes32 clientSeed,
1073     bytes symbols,
1074     uint multiplierNum,
1075     uint multiplierDen,
1076     uint amount,
1077     uint winnings
1078   );
1079 
1080   event LogSlotRefundBet(
1081     bytes32 indexed hostSeedHash,
1082     address indexed gambler, 
1083     uint amount
1084   );
1085 
1086   event LogRollNewBet(
1087     bytes32 indexed hostSeedHash, 
1088     uint8 t,
1089     address indexed gambler, 
1090     uint amount,
1091     uint mask, 
1092     uint rollUnder,
1093     address indexed referrer
1094   );
1095 
1096   event LogRollRefundBet(
1097     bytes32 indexed hostSeedHash, 
1098     uint8 t,
1099     address indexed gambler, 
1100     uint amount
1101   );
1102 
1103   event LogRollHandleBet(
1104     bytes32 indexed hostSeedHash, 
1105     uint8 t,
1106     address indexed gambler, 
1107     bytes32 hostSeed, 
1108     bytes32 clientSeed, 
1109     uint roll, 
1110     uint multiplierNum, 
1111     uint multiplierDen,
1112     uint amount,
1113     uint winnings
1114   );
1115 
1116   constructor() public {
1117     jackpotMagic = MIN_JACKPOT_MAGIC;
1118     slot.minBetAmount = SlotGameLib.MinBetAmount();
1119     slot.maxBetAmount = SlotGameLib.MinBetAmount();
1120     roll.minBetAmount = RollGameLib.MinBetAmount();
1121     roll.maxBetAmount = RollGameLib.MinBetAmount();
1122   }
1123 
1124   function() external payable {}
1125   
1126   /**
1127   * @dev Place bet to roll game.
1128   * @param t The type of roll game.
1129   * @param mask Bitmask for special roll game`s type. User choice.
1130   * @param rollUnder Roll under for special roll game`s type. User choice.
1131   * @param referrer Address of the gambler`s referrer.
1132   * @param hostSeedHash keccak256(hostSeed). The roll game`s bet id.
1133   * @param v V of ECDSA signature from hostSeedHash.
1134   * @param r R of ECDSA signature from hostSeedHash.
1135   * @param s S of ECDSA signature from hostSeedHash.
1136   */
1137   function rollPlaceBet(
1138     RollGameLib.Type t, 
1139     uint16 mask, 
1140     uint8 rollUnder, 
1141     address referrer,
1142     uint sigExpirationBlock, 
1143     bytes32 hostSeedHash, 
1144     uint8 v, 
1145     bytes32 r, 
1146     bytes32 s
1147   ) 
1148     external payable
1149   {
1150     roll.placeBet(t, mask, rollUnder, referrer, sigExpirationBlock, hostSeedHash, v, r, s);
1151   }
1152 
1153   function rollBet(bytes32 hostSeedHash) 
1154     external 
1155     view 
1156     returns (
1157       RollGameLib.Type t,
1158       uint amount,
1159       uint mask,
1160       uint rollUnder,
1161       uint blockNumber,
1162       address payable gambler,
1163       bool exist
1164     ) 
1165   {
1166     RollGameLib.Bet storage b = roll.bets[hostSeedHash];
1167     t = b.t;
1168     amount = b.amount;
1169     mask = b.mask;
1170     rollUnder = b.rollUnder;
1171     blockNumber = b.blockNumber;
1172     gambler = b.gambler;
1173     exist = b.exist;  
1174   }
1175 
1176   function slotPlaceBet(
1177     address referrer,
1178     uint sigExpirationBlock,
1179     bytes32 hostSeedHash,
1180     uint8 v,
1181     bytes32 r,
1182     bytes32 s
1183   ) 
1184     external payable
1185   {
1186     slot.placeBet(referrer, sigExpirationBlock, hostSeedHash, v, r, s);
1187   }
1188 
1189   function slotBet(bytes32 hostSeedHash) 
1190     external 
1191     view 
1192     returns (
1193       uint amount,
1194       uint blockNumber,
1195       address payable gambler,
1196       bool exist
1197     ) 
1198   {
1199     SlotGameLib.Bet storage b = slot.bets[hostSeedHash];
1200     amount = b.amount;
1201     blockNumber = b.blockNumber;
1202     gambler = b.gambler;
1203     exist = b.exist;  
1204   }
1205 
1206   function slotSetReels(uint n, bytes calldata symbols) 
1207     external 
1208     onlyAdmin(AccessRank.Games) 
1209     slotBetsWasHandled 
1210   {
1211     slot.setReel(n, symbols);
1212   }
1213 
1214   function slotReels(uint n) external view returns (bytes memory) {
1215     return slot.reels[n];
1216   }
1217 
1218   function slotPayLine(uint n) external view returns (bytes memory symbols, uint num, uint den) {
1219     symbols = new bytes(slot.payTable[n].symbols.length);
1220     symbols = slot.payTable[n].symbols;
1221     num = slot.payTable[n].multiplier.num;
1222     den = slot.payTable[n].multiplier.den;
1223   }
1224 
1225   function slotSetPayLine(uint n, bytes calldata symbols, uint num, uint den) 
1226     external 
1227     onlyAdmin(AccessRank.Games) 
1228     slotBetsWasHandled 
1229   {
1230     slot.setPayLine(n, SlotGameLib.Combination(symbols, NumberLib.Number(num, den)));
1231   }
1232 
1233   function slotSpecialPayLine(uint n) external view returns (byte symbol, uint num, uint den, uint[] memory indexes) {
1234     indexes = new uint[](slot.specialPayTable[n].indexes.length);
1235     indexes = slot.specialPayTable[n].indexes;
1236     num = slot.specialPayTable[n].multiplier.num;
1237     den = slot.specialPayTable[n].multiplier.den;
1238     symbol = slot.specialPayTable[n].symbol;
1239   }
1240 
1241   function slotSetSpecialPayLine(
1242     uint n,
1243     byte symbol,
1244     uint num, 
1245     uint den, 
1246     uint[] calldata indexes
1247   ) 
1248     external 
1249     onlyAdmin(AccessRank.Games) 
1250     slotBetsWasHandled
1251   {
1252     SlotGameLib.SpecialCombination memory scomb = SlotGameLib.SpecialCombination(symbol, NumberLib.Number(num, den), indexes);
1253     slot.setSpecialPayLine(n, scomb);
1254   }
1255 
1256   function handleBet(Game game, bytes32 hostSeed, bytes32 clientSeed) external onlyAdmin(AccessRank.Croupier) {
1257     PaymentLib.Payment memory p; 
1258     p = game == Game.Slot ? slot.handleBet(hostSeed, clientSeed) : roll.handleBet(hostSeed, clientSeed);
1259     checkEnoughFundsForPay(p.amount);
1260     p.send();
1261 
1262     p = rollJackpot(p.beneficiary, hostSeed, clientSeed);
1263     if (p.amount == 0) {
1264       return;
1265     }
1266     checkEnoughFundsForPay(p.amount);
1267     p.send();
1268   }
1269 
1270   function refundBet(Game game, bytes32 hostSeedHash) external {
1271     PaymentLib.Payment memory p; 
1272     p = game == Game.Slot ? slot.refundBet(hostSeedHash) : roll.refundBet(hostSeedHash);
1273     checkEnoughFundsForPay(p.amount);
1274     p.send();
1275   }
1276 
1277   function setSecretSigner(Game game, address secretSigner) external onlyAdmin(AccessRank.Games) {
1278     address otherSigner = game == Game.Roll ? slot.secretSigner : roll.secretSigner;
1279     require(secretSigner != otherSigner, "casino: slot and roll secret signers must be not equal");
1280     game == Game.Roll ? roll.secretSigner = secretSigner : slot.secretSigner = secretSigner;
1281   }
1282 
1283   function setMinMaxBetAmount(Game game, uint min, uint max) external onlyAdmin(AccessRank.Games) {
1284     game == Game.Roll ? roll.setMinMaxBetAmount(min, max) : slot.setMinMaxBetAmount(min, max);
1285   }
1286 
1287   function kill(address payable beneficiary) 
1288     external 
1289     onlyAdmin(AccessRank.Full) 
1290   {
1291     require(lockedInBets() == 0, "casino: all bets should be handled");
1292     selfdestruct(beneficiary);
1293   }
1294 
1295   function rollJackpot(
1296     address payable beneficiary,
1297     bytes32 hostSeed,
1298     bytes32 clientSeed
1299   ) 
1300     private returns(PaymentLib.Payment memory p) 
1301   {
1302     if (Rnd.uintn(hostSeed, clientSeed, jackpotMagic, JACKPOT_NONCE) != 0) {
1303       return p;
1304     }
1305     p.beneficiary = beneficiary;
1306     p.amount = jackpot();
1307     p.message = JACKPOT_LOG_MSG;
1308 
1309     delete slot.jackpot;
1310     delete roll.jackpot;
1311     delete extraJackpot;
1312     emit LogJactpot(p.beneficiary, p.amount, hostSeed, clientSeed, jackpotMagic);
1313   }
1314 
1315   function increaseJackpot(uint amount) external onlyAdmin(AccessRank.Games) {
1316     checkEnoughFundsForPay(amount);
1317     extraJackpot += amount;
1318     // todo event?
1319   }
1320 
1321   function setJackpotMagic(uint magic) external onlyAdmin(AccessRank.Games) {
1322     require(MIN_JACKPOT_MAGIC <= magic && magic <= MAX_JACKPOT_MAGIC, "casino: invalid jackpot magic");
1323     jackpotMagic = magic;
1324     // todo event?
1325   }
1326 
1327   function withdraw(address payable beneficiary, uint amount) external onlyAdmin(AccessRank.Withdraw) {
1328     checkEnoughFundsForPay(amount);
1329     PaymentLib.Payment(beneficiary, amount, WITHDRAW_LOG_MSG).send();
1330   }
1331 
1332   function lockedInBets() public view returns(uint) {
1333     return slot.lockedInBets + roll.lockedInBets;
1334   }
1335 
1336   function jackpot() public view returns(uint) {
1337     return slot.jackpot + roll.jackpot + extraJackpot;
1338   }
1339 
1340   function freeFunds() public view returns(uint) {
1341     if (lockedInBets() + jackpot() >= address(this).balance ) {
1342       return 0;
1343     }
1344     return address(this).balance - lockedInBets() - jackpot();
1345   }
1346 
1347   function checkEnoughFundsForPay(uint amount) private view {
1348     require(freeFunds() >= amount, "casino: not enough funds");
1349   }
1350 }