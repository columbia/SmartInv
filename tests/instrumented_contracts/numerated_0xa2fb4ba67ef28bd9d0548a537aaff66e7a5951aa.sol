1 /*
2 "Crypto Casino 333" (c) v.1.0
3 Copyright (c) 2019 by -= 333ETH Team =-
4 
5 
6 * Web - https://333eth.io
7 * Telegram_channel - https://t.me/Ethereum333
8 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
9 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
10 * Support:
11 *     Telegram_chat: https://t.me/cc333support
12 *     Email:         support(at sign)333eth.io
13 
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
46 pragma solidity 0.5.2;
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
69 library BytesLib {
70   function index(bytes memory b, bytes memory subb, uint start) internal pure returns(int) {
71     uint lensubb = subb.length;
72     
73     uint hashsubb;
74     uint ptrb;
75     assembly {
76       hashsubb := keccak256(add(subb, 0x20), lensubb)
77       ptrb := add(b, 0x20)
78     }
79     
80     for (uint lenb = b.length; start < lenb; start++) {
81       if (start+lensubb > lenb) {
82         return -1;
83       }
84       bool found;
85       assembly {
86         found := eq(keccak256(add(ptrb, start), lensubb), hashsubb)
87       }
88       if (found) {
89         return int(start);
90       }
91     }
92     return -1;
93   }  
94   
95   function index(bytes memory b, bytes memory sub) internal pure returns(int) {
96     return index(b, sub, 0);
97   }
98 
99   function index(bytes memory b, byte sub, uint start) internal pure returns(int) {
100     for (uint len = b.length; start < len; start++) {
101       if (b[start] == sub) {
102         return int(start);
103       }
104     }
105     return -1;
106   }
107 
108   function index(bytes memory b, byte sub) internal pure returns(int) {
109     return index(b, sub, 0);
110   }
111 
112   function count(bytes memory b, bytes memory sub) internal pure returns(uint times) {
113     int i = index(b, sub, 0);
114     while (i != -1) {
115       times++;
116       i = index(b, sub, uint(i)+sub.length);
117     }
118   }
119   
120   function equals(bytes memory b, bytes memory a) internal pure returns(bool equal) {
121     if (b.length != a.length) {
122       return false;
123     }
124     
125     uint len = b.length;
126     
127     assembly {
128       equal := eq(keccak256(add(b, 0x20), len), keccak256(add(a, 0x20), len))
129     }  
130   }
131   
132   function copy(bytes memory b) internal pure returns(bytes memory) {
133     return abi.encodePacked(b);
134   }
135   
136   function slice(bytes memory b, uint start, uint end) internal pure returns(bytes memory r) {
137     if (start > end) {
138       return r;
139     }
140     if (end > b.length-1) {
141       end = b.length-1;
142     }
143     r = new bytes(end-start+1);
144     
145     uint j;
146     uint i = start;
147     for (; i <= end; (i++, j++)) {
148       r[j] = b[i];
149     }
150   }
151   
152   function append(bytes memory b, bytes memory a) internal pure returns(bytes memory r) {
153     return abi.encodePacked(b, a);
154   }
155   
156   
157   function replace(bytes memory b, bytes memory oldb, bytes memory newb) internal pure returns(bytes memory r) {
158     if (equals(oldb, newb)) {
159       return copy(b);
160     }
161     
162     uint n = count(b, oldb);
163     if (n == 0) {
164       return copy(b);
165     }
166     
167     uint start;
168     for (uint i; i < n; i++) {
169       uint j = start;
170       j += uint(index(slice(b, start, b.length-1), oldb));  
171       if (j!=0) {
172         r = append(r, slice(b, start, j-1));
173       }
174       
175       r = append(r, newb);
176       start = j + oldb.length;
177     }
178     if (r.length != b.length+n*(newb.length-oldb.length)) {
179       r = append(r, slice(b, start, b.length-1));
180     }
181   }
182 
183   function fillPattern(bytes memory b, bytes memory pattern, byte newb) internal pure returns (uint n) {
184     uint start;
185     while (true) {
186       int i = index(b, pattern, start);
187       if (i < 0) {
188         return n;
189       }
190       uint len = pattern.length;
191       for (uint k = 0; k < len; k++) {
192         b[uint(i)+k] = newb;
193       }
194       start = uint(i)+len;
195       n++;
196     }
197   }
198 }
199 
200 
201 library NumberLib {
202   struct Number {
203     uint num;
204     uint den;
205   }
206 
207   function muluint(Number memory a, uint b) internal pure returns (uint) {
208     return b * a.num / a.den;
209   }
210 
211   function mmul(Number memory a, uint b) internal pure returns(Number memory) {
212     a.num = a.num * b;
213     return a;
214   }
215 
216   function maddm(Number memory a, Number memory b) internal pure returns(Number memory) {
217     a.num = a.num * b.den + b.num * a.den;
218     a.den = a.den * b.den;
219     return a;
220   }
221 
222   function madds(Number memory a, Number storage b) internal view returns(Number memory) {
223     a.num = a.num * b.den + b.num * a.den;
224     a.den = a.den * b.den;
225     return a;
226   }
227 }
228 
229 
230 library Rnd {
231   byte internal constant NONCE_SEP = "\x3a"; // ':'
232 
233   function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n) internal pure returns(uint) {
234     return uint(keccak256(abi.encodePacked(hostSeed, clientSeed))) % n;
235   }
236 
237   function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n, bytes memory nonce) internal pure returns(uint) {
238     return uint(keccak256(abi.encodePacked(hostSeed, clientSeed, NONCE_SEP, nonce))) % n;
239   }
240 }
241 
242 
243 library ProtLib {
244   function checkBlockHash(uint blockNumber, bytes32 blockHash) internal view {
245     require(block.number > blockNumber, "protection lib: current block must be great then block number");
246     require(blockhash(blockNumber) != bytes32(0), "protection lib: blockhash can't be queried by EVM");
247     require(blockhash(blockNumber) == blockHash, "protection lib: invalid block hash");
248   }
249 
250   function checkSigner(address signer, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal pure {
251     require(signer == ecrecover(message, v, r, s), "protection lib: ECDSA signature is not valid");
252   }
253 
254   function checkSigner(address signer, uint expirationBlock, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal view {
255     require(block.number <= expirationBlock, "protection lib: signature has expired");
256     checkSigner(signer, keccak256(abi.encodePacked(message, expirationBlock)), v, r, s);
257   }
258 }
259 
260 
261 /**
262  * @title SafeMath
263  * @dev Unsigned math operations with safety checks that revert on error
264  */
265 library SafeMath {
266      
267   /**
268    * @dev Multiplies two unsigned integers, reverts on overflow.
269    */
270   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272     // benefit is lost if 'b' is also tested.
273     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
274     if (a == 0) {
275       return 0;
276     }
277     uint256 c = a * b;
278     require(c / a == b);
279     return c;
280   }
281 
282   /**
283    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
284    */
285   function div(uint256 a, uint256 b) internal pure returns (uint256) {
286     // Solidity only automatically asserts when dividing by 0
287     require(b > 0);
288     uint256 c = a / b;
289     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290     return c;
291   }
292 
293   /**
294    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
295    */
296   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297     require(b <= a);
298     uint256 c = a - b;
299     return c;
300   }
301 
302   /**
303    * @dev Adds two unsigned integers, reverts on overflow.
304    */
305   function add(uint256 a, uint256 b) internal pure returns (uint256) {
306     uint256 c = a + b;
307     require(c >= a);
308     return c;
309   }
310 
311   /**
312    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
313    * reverts when dividing by zero.
314    */
315   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316     require(b != 0);
317     return a % b;
318   }
319 }
320 
321 
322 library ProofLib {
323   function chainHash(bytes memory chainProof, bytes memory uncleHeader) internal pure returns(bytes32 hash) {
324     uint proofLen = chainProof.length;
325     require(proofLen >= 4, "proof lib: chain proof length too low");
326     bytes memory slotData = uncleHeader;
327     uint slotDataPtr;  assembly { slotDataPtr := add(slotData, 32) }
328     
329     for (uint offset; ;) {
330       // uncles blob
331       (uint blobPtr, uint blobLen, uint blobShift) = blobPtrLenShift(chainProof, offset, slotData.length);
332       offset += 4;
333       // put uncle header to uncles slot.
334       uint slotPtr; assembly { slotPtr := add(blobPtr, blobShift) }
335       memcpy(slotDataPtr, slotPtr, slotData.length);
336       // calc uncles hash
337       assembly { hash := keccak256(blobPtr, blobLen) }
338       offset += blobLen;
339       
340       
341       // header blob
342       (blobPtr, blobLen, blobShift) = blobPtrLenShift(chainProof, offset, 32);
343       offset += 4;
344       uint hashSlot; assembly { hashSlot := mload(add(blobPtr, blobShift)) }
345       require(hashSlot == 0, "proof lib: non-empty uncles hash slot");
346       assembly { 
347         mstore(add(blobPtr, blobShift), hash)  // put uncles hash to uncles hash slot.
348         hash := keccak256(blobPtr, blobLen) // calc header hash
349       }
350       offset += blobLen;
351       
352       // return if has not next blob
353       if (offset+4 >= proofLen) {
354         return hash;
355       }
356       
357       // copy header blob to slotData for using in next blob
358       slotData = new bytes(blobLen); assembly { slotDataPtr := add(slotData, 32) }
359       memcpy(blobPtr, slotDataPtr, blobLen);
360     }
361   }
362   
363   function uncleHeader(bytes memory proof, bytes32 hostSeedHash) internal pure returns(bytes32 headerHash, bytes memory header) {
364     uint proofLen = proof.length;
365     require(proofLen >= 4, "proof lib: uncle proof length too low");
366     uint blobPtr; uint blobLen; 
367     bytes32 blobHash = hostSeedHash;
368     for (uint offset; offset+4 < proofLen; offset += blobLen) {
369       uint blobShift;
370       (blobPtr, blobLen, blobShift) = blobPtrLenShift(proof, offset, 32);
371       offset += 4;
372       uint hashSlot; assembly { hashSlot := mload(add(blobPtr, blobShift)) }
373       require(hashSlot == 0, "proof lib: non-empty hash slot");
374       assembly { 
375         mstore(add(blobPtr, blobShift), blobHash) 
376         blobHash := keccak256(blobPtr, blobLen)
377       }
378     }
379     
380     header = new bytes(blobLen);
381     uint headerPtr; assembly { headerPtr := add(header, 32) }
382     memcpy(blobPtr, headerPtr, blobLen); 
383     return (blobHash, header);
384   }
385 
386   function receiptAddr(bytes memory proof) internal pure returns(address addr) {
387     uint b;
388     uint offset; assembly { offset := add(add(proof, 32), 4) }
389     
390     // leaf header
391     assembly { b := byte(0, mload(offset)) }
392     require(b >= 0xf7, "proof lib: receipt leaf longer than 55 bytes");
393     offset += b - 0xf6;
394 
395     // path header
396     assembly { b := byte(0, mload(offset)) }
397     if (b <= 0x7f) {
398       offset += 1;
399     } else {
400       require(b >= 0x80 && b <= 0xb7, "proof lib: path is an RLP string");
401       offset += b - 0x7f;
402     }
403 
404     // receipt string header
405     assembly { b := byte(0, mload(offset)) }
406     require(b == 0xb9, "proof lib: Rrceipt str is always at least 256 bytes long, but less than 64k");
407     offset += 3;
408 
409     // receipt header
410     assembly { b := byte(0, mload(offset)) }
411     require(b == 0xf9, "proof lib: receipt is always at least 256 bytes long, but less than 64k");
412     offset += 3;
413 
414     // status
415     assembly { b := byte(0, mload(offset)) }
416     require(b == 0x1, "proof lib: status should be success");
417     offset += 1;
418 
419     // cum gas header
420     assembly { b := byte(0, mload(offset)) }
421     if (b <= 0x7f) {
422       offset += 1;
423     } else {
424       require(b >= 0x80 && b <= 0xb7, "proof lib: cumulative gas is an RLP string");
425       offset += b - 0x7f;
426     }
427 
428     // bloom header
429     assembly { b := byte(0, mload(offset)) }
430     require(b == 0xb9, "proof lib: bloom filter is always 256 bytes long");
431     offset += 256 + 3;
432 
433     // logs list header
434     assembly { b := byte(0, mload(offset)) }
435     require(b == 0xf8, "proof lib: logs list is less than 256 bytes long");
436     offset += 2;
437 
438     // log entry header
439     assembly { b := byte(0, mload(offset)) }
440     require(b == 0xf8, "proof lib: log entry is less than 256 bytes long");
441     offset += 2;
442 
443     // address header
444     assembly { b := byte(0, mload(offset)) }
445     require(b == 0x94, "proof lib: address is 20 bytes long");
446     
447     offset -= 11;
448     assembly { addr := and(mload(offset), 0xffffffffffffffffffffffffffffffffffffffff) }
449   }
450 
451   function blobPtrLenShift(bytes memory proof, uint offset, uint slotDataLen) internal pure returns(uint ptr, uint len, uint shift) {
452     assembly { 
453       ptr := add(add(proof, 32), offset) 
454       len := and(mload(sub(ptr, 30)), 0xffff)
455     }
456     require(proof.length >= len+offset+4, "proof lib: blob length out of range proof");
457     assembly { shift := and(mload(sub(ptr, 28)), 0xffff) }
458     require(shift + slotDataLen <= len, "proof lib: blob shift bounds check");
459     ptr += 4;
460   }
461 
462   // Copy 'len' bytes from memory address 'src', to address 'dest'.
463   // This function does not check the or destination, it only copies
464   // the bytes.
465   function memcpy(uint src, uint dest, uint len) internal pure {
466     // Copy word-length chunks while possible
467     for (; len >= 32; len -= 32) {
468       assembly {
469         mstore(dest, mload(src))
470       }
471       dest += 32;
472       src += 32;
473     }
474 
475     // Copy remaining bytes
476     uint mask = 256 ** (32 - len) - 1;
477     assembly {
478       let srcpart := and(mload(src), not(mask))
479       let destpart := and(mload(dest), mask)
480       mstore(dest, or(destpart, srcpart))
481     }
482   }   
483 }
484 
485 
486 library SlotGameLib {
487   using BytesLib for bytes;
488   using SafeMath for uint;
489   using SafeMath for uint128;
490   using NumberLib for NumberLib.Number;
491 
492   struct Bet {
493     uint amount; 
494     uint40 blockNumber; // 40
495     address payable gambler; // 160
496     bool exist; // 1
497   }
498 
499   function remove(Bet storage bet) internal {
500     delete bet.amount;
501     delete bet.blockNumber;
502     delete bet.gambler;
503   }
504 
505   struct Combination {
506     bytes symbols;
507     NumberLib.Number multiplier;
508   }
509 
510   struct SpecialCombination {
511     byte symbol;
512     NumberLib.Number multiplier;
513     uint[] indexes; // not uint8, optimize hasIn
514   }
515 
516   function hasIn(SpecialCombination storage sc, bytes memory symbols) internal view returns (bool) {
517     uint len = sc.indexes.length;
518     byte symbol = sc.symbol;
519     for (uint i = 0; i < len; i++) {
520       if (symbols[sc.indexes[i]] != symbol) {
521         return false;
522       }
523     }
524     return true;
525   }
526 
527   // the symbol that don't use in reels
528   byte private constant UNUSED_SYMBOL = "\xff"; // 255
529   uint internal constant REELS_LEN = 9;
530   uint private constant BIG_COMBINATION_MIN_LEN = 8;
531   bytes32 private constant PAYMENT_LOG_MSG = "slot";
532   bytes32 private constant REFUND_LOG_MSG = "slot.refund";
533   uint private constant HANDLE_BET_COST = 0.001 ether;
534   uint private constant HOUSE_EDGE_PERCENT = 1;
535   uint private constant JACKPOT_PERCENT = 1;
536   uint private constant MIN_WIN_PERCENT = 30;
537   uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100 / MIN_WIN_PERCENT * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
538   
539   function MinBetAmount() internal pure returns(uint) {
540     return MIN_BET_AMOUNT;
541   }
542 
543   
544   struct Game {
545     address secretSigner;
546     uint128 lockedInBets;
547     uint128 jackpot;
548     uint maxBetAmount;
549     uint minBetAmount;
550     bytes[REELS_LEN] reels;
551     // pay table array with prioritet for 0-elem to N-elem, where 0 - MAX prior and N - LOW prior
552     Combination[] payTable;
553     SpecialCombination[] specialPayTable;
554     mapping(bytes32 => Bet) bets;
555   }
556 
557   event LogSlotNewBet(
558     bytes32 indexed hostSeedHash,
559     address indexed gambler,
560     uint amount,
561     address indexed referrer
562   );
563 
564   event LogSlotHandleBet(
565     bytes32 indexed hostSeedHash,
566     address indexed gambler,
567     bytes32 hostSeed,
568     bytes32 clientSeed,
569     bytes symbols,
570     uint multiplierNum,
571     uint multiplierDen,
572     uint amount,
573     uint winnings
574   );
575 
576   event LogSlotRefundBet(
577     bytes32 indexed hostSeedHash,
578     address indexed gambler, 
579     uint amount
580   );
581 
582   function setReel(Game storage game, uint n, bytes memory symbols) internal {
583     require(REELS_LEN > n, "slot game: invalid reel number");
584     require(symbols.length > 0, "slot game: invalid reel`s symbols length");
585     require(symbols.index(UNUSED_SYMBOL) == -1, "slot game: reel`s symbols contains invalid symbol");
586     game.reels[n] = symbols;
587   }
588 
589   function setPayLine(Game storage game, uint n, Combination memory comb) internal {
590     require(n <= game.payTable.length, "slot game: invalid pay line number");
591     require(comb.symbols.index(UNUSED_SYMBOL) == -1, "slot game: combination symbols contains invalid symbol");
592 
593     if (n == game.payTable.length && comb.symbols.length > 0) {
594       game.payTable.push(comb);
595       return;
596     } 
597     
598     if (n == game.payTable.length-1 && comb.symbols.length == 0) {
599       game.payTable.pop();
600       return;
601     }
602 
603     require(
604       0 < comb.symbols.length && comb.symbols.length <= REELS_LEN, 
605       "slot game: invalid combination`s symbols length"
606     );
607     game.payTable[n] = comb;
608   }
609 
610   function setSpecialPayLine(Game storage game, uint n, SpecialCombination memory scomb) internal {
611     require(game.specialPayTable.length >= n, "slot game: invalid pay line number");
612     require(scomb.symbol != UNUSED_SYMBOL, "slot game: invalid special combination`s symbol");
613 
614     if (n == game.specialPayTable.length && scomb.indexes.length > 0) {
615       game.specialPayTable.push(scomb);
616       return;
617     } 
618     
619     if (n == game.specialPayTable.length-1 && scomb.indexes.length == 0) {
620       game.specialPayTable.pop();
621       return;
622     }
623 
624     require(
625       0 < scomb.indexes.length && scomb.indexes.length <= REELS_LEN, 
626       "slot game: invalid special combination`s indexes length"
627     );
628     game.specialPayTable[n] = scomb;
629   }
630 
631   function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
632     require(minBetAmount >= MIN_BET_AMOUNT, "slot game: invalid min of bet amount");
633     require(minBetAmount <= maxBetAmount, "slot game: invalid [min, max] range of bet amount");
634     game.minBetAmount = minBetAmount;
635     game.maxBetAmount = maxBetAmount;
636   }
637 
638   function placeBet(
639     Game storage game,
640     address referrer,
641     uint sigExpirationBlock,
642     bytes32 hostSeedHash,
643     uint8 v, 
644     bytes32 r, 
645     bytes32 s
646   ) 
647     internal
648   {
649     ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
650 
651     Bet storage bet = game.bets[hostSeedHash];
652     require(!bet.exist, "slot game: bet already exist");
653     require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "slot game: invalid bet amount");
654     
655     bet.amount = msg.value;
656     bet.blockNumber = uint40(block.number);
657     bet.gambler = msg.sender;
658     bet.exist = true;
659     
660     game.lockedInBets += uint128(msg.value);
661     game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
662 
663     emit LogSlotNewBet(
664       hostSeedHash, 
665       msg.sender, 
666       msg.value,
667       referrer
668     );
669   }
670 
671   function handleBetPrepare(
672     Game storage game,
673     bytes32 hostSeed
674   ) 
675     internal view
676     returns(
677       Bet storage bet,
678       bytes32 hostSeedHash, // return it for optimization
679       uint betAmount // return it for optimization
680     ) 
681   {
682     hostSeedHash = keccak256(abi.encodePacked(hostSeed));
683     bet = game.bets[hostSeedHash];
684     betAmount = bet.amount;
685     require(bet.exist, "slot game: bet does not exist");
686     require(betAmount > 0, "slot game: bet already handled");
687   }
688 
689   function handleBetCommon(
690     Game storage game,
691     Bet storage bet,
692     bytes32 hostSeed,
693     bytes32 hostSeedHash,
694     bytes32 clientSeed,
695     uint betAmount
696   ) 
697     internal 
698     returns(
699       PaymentLib.Payment memory p
700     ) 
701   {
702     game.lockedInBets -= uint128(betAmount);
703     Combination memory c = spin(game, hostSeed, clientSeed);
704     uint winnings = c.multiplier.muluint(betAmount);
705 
706     if (winnings > 0) {
707       winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
708       winnings = winnings.sub(HANDLE_BET_COST);
709     } else {
710       winnings = 1;
711     }
712     p.beneficiary = bet.gambler; 
713     p.amount = winnings; 
714     p.message = PAYMENT_LOG_MSG; 
715 
716     emit LogSlotHandleBet(
717       hostSeedHash,
718       p.beneficiary, 
719       hostSeed, 
720       clientSeed, 
721       c.symbols, 
722       c.multiplier.num, 
723       c.multiplier.den,
724       betAmount,
725       winnings
726     );
727     remove(bet);
728   }
729   
730   function handleBet(
731     Game storage game,
732     bytes32 hostSeed,
733     bytes32 clientSeed
734   ) 
735     internal 
736     returns(
737       PaymentLib.Payment memory
738     ) 
739   {
740     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
741     ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
742     return handleBetCommon(game, bet, hostSeed, hostSeedHash, clientSeed, betAmount);
743   }
744 
745   function handleBetWithProof(
746     Game storage game,
747     bytes32 hostSeed,
748     uint canonicalBlockNumber,
749     bytes memory uncleProof,
750     bytes memory chainProof
751   ) 
752     internal 
753     returns(
754       PaymentLib.Payment memory,
755       bytes32 // clientSeed
756     ) 
757   {
758     require(address(this) == ProofLib.receiptAddr(uncleProof), "slot game: invalid receipt address");
759     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
760     (bytes32 uncleHeaderHash, bytes memory uncleHeader) = ProofLib.uncleHeader(uncleProof, hostSeedHash);
761     bytes32 canonicalBlockHash = ProofLib.chainHash(chainProof, uncleHeader);
762     ProtLib.checkBlockHash(canonicalBlockNumber, canonicalBlockHash);
763     return (handleBetCommon(game, bet, hostSeed, hostSeedHash, uncleHeaderHash, betAmount), uncleHeaderHash); 
764   }
765 
766   function spin(
767     Game storage game,
768     bytes32 hostSeed,
769     bytes32 clientSeed
770   ) 
771     internal 
772     view 
773     returns (
774       Combination memory combination
775     ) 
776   {
777     bytes memory symbolsTmp = new bytes(REELS_LEN);
778     for (uint i; i < REELS_LEN; i++) {
779       bytes memory nonce = abi.encodePacked(uint8(i));
780       symbolsTmp[i] = game.reels[i][Rnd.uintn(hostSeed, clientSeed, game.reels[i].length, nonce)];
781     }
782     combination.symbols = symbolsTmp.copy();
783     combination.multiplier = NumberLib.Number(0, 1); // 0/1 == 0.0
784     
785     for ((uint i, uint length) = (0, game.payTable.length); i < length; i++) {
786       bytes memory tmp = game.payTable[i].symbols;
787       uint times = symbolsTmp.fillPattern(tmp, UNUSED_SYMBOL);
788       if (times > 0) {
789         combination.multiplier.maddm(game.payTable[i].multiplier.mmul(times));
790         if (tmp.length >= BIG_COMBINATION_MIN_LEN) {
791           return combination; 
792 			  }
793       }
794     }
795     
796     for ((uint i, uint length) = (0, game.specialPayTable.length); i < length; i++) {
797       if (hasIn(game.specialPayTable[i], combination.symbols)) {
798         combination.multiplier.madds(game.specialPayTable[i].multiplier);
799       }
800     }
801   }
802 
803   function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
804     Bet storage bet = game.bets[hostSeedHash];
805     uint betAmount = bet.amount;
806     require(bet.exist, "slot game: bet does not exist");
807     require(betAmount > 0, "slot game: bet already handled");
808     require(blockhash(bet.blockNumber) == bytes32(0), "slot game: can`t refund bet");
809    
810     game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
811     game.lockedInBets -= uint128(betAmount);
812     p.beneficiary = bet.gambler; 
813     p.amount = betAmount; 
814     p.message = REFUND_LOG_MSG; 
815 
816     emit LogSlotRefundBet(hostSeedHash, p.beneficiary, p.amount);
817     remove(bet);
818   }
819 }
820 
821 
822 library BitsLib {
823 
824   // popcnt returns the number of one bits ("population count") in x.
825   // https://en.wikipedia.org/wiki/Hamming_weight 
826   function popcnt(uint16 x) internal pure returns(uint) {
827     x -= (x >> 1) & 0x5555;
828     x = (x & 0x3333) + ((x >> 2) & 0x3333);
829     x = (x + (x >> 4)) & 0x0f0f;
830     return (x * 0x0101) >> 8;
831   }
832 }
833 
834 
835 library RollGameLib {
836   using NumberLib for NumberLib.Number;
837   using SafeMath for uint;
838   using SafeMath for uint128;
839 
840   enum Type {Coin, Square3x3, Roll}
841   uint private constant COIN_MOD = 2;
842   uint private constant SQUARE_3X3_MOD = 9;
843   uint private constant ROLL_MOD = 100;
844   bytes32 private constant COIN_PAYMENT_LOG_MSG = "roll.coin";
845   bytes32 private constant SQUARE_3X3_PAYMENT_LOG_MSG = "roll.square_3x3";
846   bytes32 private constant ROLL_PAYMENT_LOG_MSG = "roll.roll";
847   bytes32 private constant REFUND_LOG_MSG = "roll.refund";
848   uint private constant HOUSE_EDGE_PERCENT = 1;
849   uint private constant JACKPOT_PERCENT = 1;
850   uint private constant HANDLE_BET_COST = 0.0005 ether;
851   uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
852 
853   function MinBetAmount() internal pure returns(uint) {
854     return MIN_BET_AMOUNT;
855   }
856 
857   function module(Type t) internal pure returns(uint) {
858     if (t == Type.Coin) { return COIN_MOD; } 
859     else if (t == Type.Square3x3) { return SQUARE_3X3_MOD; } 
860     else { return ROLL_MOD; }
861   }
862 
863   function logMsg(Type t) internal pure returns(bytes32) {
864     if (t == Type.Coin) { return COIN_PAYMENT_LOG_MSG; } 
865     else if (t == Type.Square3x3) { return SQUARE_3X3_PAYMENT_LOG_MSG; }
866     else { return ROLL_PAYMENT_LOG_MSG; }
867   }
868 
869   function maskRange(Type t) internal pure returns(uint, uint) {
870     if (t == Type.Coin) { return (1, 2 ** COIN_MOD - 2); } 
871     else if (t == Type.Square3x3) { return (1, 2 ** SQUARE_3X3_MOD - 2); }
872   }
873 
874   function rollUnderRange(Type t) internal pure returns(uint, uint) {
875     if (t == Type.Roll) { return (1, ROLL_MOD - 1); } // 0..99
876   }
877 
878 
879   struct Bet {
880     uint amount;
881     Type t; // 8
882     uint8 rollUnder; // 8
883     uint16 mask;  // 16
884     uint40 blockNumber; // 40
885     address payable gambler; // 160
886     bool exist; // 1
887   }
888 
889   function roll(
890     Bet storage bet,
891     bytes32 hostSeed,
892     bytes32 clientSeed
893   ) 
894     internal 
895     view 
896     returns (
897       uint rnd,
898       NumberLib.Number memory multiplier
899     ) 
900   {
901     uint m = module(bet.t);
902     rnd = Rnd.uintn(hostSeed, clientSeed, m);
903     multiplier.den = 1; // prevent divide to zero
904     
905     uint mask = bet.mask;
906     if (mask != 0) {
907       if (((2 ** rnd) & mask) != 0) {
908         multiplier.den = BitsLib.popcnt(uint16(mask));
909         multiplier.num = m;
910       }
911     } else {
912       uint rollUnder = bet.rollUnder;
913       if (rollUnder > rnd) {
914         multiplier.den = rollUnder;
915         multiplier.num = m;
916       }
917     }
918   }
919 
920   function remove(Bet storage bet) internal {
921     delete bet.amount;
922     delete bet.t;
923     delete bet.mask;
924     delete bet.rollUnder;
925     delete bet.blockNumber;
926     delete bet.gambler;
927   }
928 
929 
930   struct Game {
931     address secretSigner;
932     uint128 lockedInBets;
933     uint128 jackpot;
934     uint maxBetAmount;
935     uint minBetAmount;
936     mapping(bytes32 => Bet) bets;
937   }
938 
939   event LogRollNewBet(
940     bytes32 indexed hostSeedHash, 
941     uint8 t,
942     address indexed gambler, 
943     uint amount,
944     uint mask, 
945     uint rollUnder,
946     address indexed referrer
947   );
948 
949   event LogRollRefundBet(
950     bytes32 indexed hostSeedHash, 
951     uint8 t,
952     address indexed gambler, 
953     uint amount
954   );
955 
956   event LogRollHandleBet(
957     bytes32 indexed hostSeedHash, 
958     uint8 t,
959     address indexed gambler, 
960     bytes32 hostSeed, 
961     bytes32 clientSeed, 
962     uint roll, 
963     uint multiplierNum, 
964     uint multiplierDen,
965     uint amount,
966     uint winnings
967   );
968 
969   function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
970     require(minBetAmount >= MIN_BET_AMOUNT, "roll game: invalid min of bet amount");
971     require(minBetAmount <= maxBetAmount, "roll game: invalid [min, max] range of bet amount");
972     game.minBetAmount = minBetAmount;
973     game.maxBetAmount = maxBetAmount;
974   }
975 
976   function placeBet(
977     Game storage game, 
978     Type t, 
979     uint16 mask, 
980     uint8 rollUnder,
981     address referrer,
982     uint sigExpirationBlock,
983     bytes32 hostSeedHash, 
984     uint8 v, 
985     bytes32 r, 
986     bytes32 s
987   ) 
988     internal 
989   {
990     ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
991     Bet storage bet = game.bets[hostSeedHash];
992     require(!bet.exist, "roll game: bet already exist");
993     require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "roll game: invalid bet amount");
994 
995     {
996       // prevent stack to deep
997       (uint minMask, uint maxMask) = maskRange(t);
998       require(minMask <= mask && mask <= maxMask, "roll game: invalid bet mask");
999       (uint minRollUnder, uint maxRollUnder) = rollUnderRange(t);
1000       require(minRollUnder <= rollUnder && rollUnder <= maxRollUnder, "roll game: invalid bet roll under");
1001     }
1002 
1003     // * do not touch it! this order is the best for optimization
1004     bet.amount = msg.value;
1005     bet.blockNumber = uint40(block.number);
1006     bet.gambler = msg.sender;
1007     bet.exist = true;
1008     bet.mask = mask;
1009     bet.rollUnder = rollUnder;
1010     bet.t = t;
1011     // *
1012 
1013     game.lockedInBets += uint128(msg.value);
1014     game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
1015 
1016     emit LogRollNewBet(
1017       hostSeedHash,
1018       uint8(t),
1019       msg.sender,
1020       msg.value,
1021       mask,
1022       rollUnder,
1023       referrer
1024     );
1025   }
1026 
1027   function handleBetPrepare(
1028     Game storage game,
1029     bytes32 hostSeed
1030   ) 
1031     internal view
1032     returns(
1033       Bet storage bet,
1034       bytes32 hostSeedHash, // return it for optimization
1035       uint betAmount // return it for optimization
1036     ) 
1037   {
1038     hostSeedHash = keccak256(abi.encodePacked(hostSeed));
1039     bet = game.bets[hostSeedHash];
1040     betAmount = bet.amount;
1041     require(bet.exist, "slot game: bet does not exist");
1042     require(betAmount > 0, "slot game: bet already handled");
1043   }
1044 
1045   function handleBetCommon(
1046     Game storage game,
1047     Bet storage bet,
1048     bytes32 hostSeed,
1049     bytes32 hostSeedHash,
1050     bytes32 clientSeed,
1051     uint betAmount
1052   ) 
1053     internal 
1054     returns(
1055       PaymentLib.Payment memory p
1056     ) 
1057   {
1058     game.lockedInBets -= uint128(betAmount);
1059     (uint rnd, NumberLib.Number memory multiplier) = roll(bet, hostSeed, clientSeed);
1060     uint winnings = multiplier.muluint(betAmount);
1061   
1062     if (winnings > 0) {
1063       winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
1064       winnings = winnings.sub(HANDLE_BET_COST);
1065     } else {
1066       winnings = 1;
1067     }
1068     p.beneficiary = bet.gambler; 
1069     p.amount = winnings; 
1070     p.message = logMsg(bet.t); 
1071 
1072     emit LogRollHandleBet(
1073       hostSeedHash,
1074       uint8(bet.t),
1075       p.beneficiary,
1076       hostSeed,
1077       clientSeed,
1078       rnd,
1079       multiplier.num,
1080       multiplier.den,
1081       betAmount,
1082       winnings
1083     );
1084     remove(bet);
1085   }
1086 
1087   function handleBet(
1088     Game storage game,
1089     bytes32 hostSeed,
1090     bytes32 clientSeed
1091   ) 
1092     internal 
1093     returns(
1094       PaymentLib.Payment memory
1095     ) 
1096   {
1097     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
1098     ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
1099     return handleBetCommon(game, bet, hostSeed, hostSeedHash, clientSeed, betAmount);
1100   }
1101 
1102   function handleBetWithProof(
1103     Game storage game,
1104     bytes32 hostSeed,
1105     uint canonicalBlockNumber,
1106     bytes memory uncleProof,
1107     bytes memory chainProof
1108   ) 
1109     internal 
1110     returns(
1111       PaymentLib.Payment memory,
1112       bytes32 // clientSeed
1113     ) 
1114   {
1115     require(address(this) == ProofLib.receiptAddr(uncleProof), "roll game: invalid receipt address");
1116     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
1117     (bytes32 uncleHeaderHash, bytes memory uncleHeader) = ProofLib.uncleHeader(uncleProof, hostSeedHash);
1118     bytes32 canonicalBlockHash = ProofLib.chainHash(chainProof, uncleHeader);
1119     ProtLib.checkBlockHash(canonicalBlockNumber, canonicalBlockHash);
1120     return (handleBetCommon(game, bet, hostSeed, hostSeedHash, uncleHeaderHash, betAmount), uncleHeaderHash); 
1121   }
1122 
1123   function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
1124     Bet storage bet = game.bets[hostSeedHash];
1125     uint betAmount = bet.amount;
1126     require(bet.exist, "roll game: bet does not exist");
1127     require(betAmount > 0, "roll game: bet already handled");
1128     require(blockhash(bet.blockNumber) == bytes32(0), "roll game: can`t refund bet");
1129    
1130     game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
1131     game.lockedInBets -= uint128(betAmount);
1132     p.beneficiary = bet.gambler; 
1133     p.amount = betAmount; 
1134     p.message = REFUND_LOG_MSG; 
1135 
1136     emit LogRollRefundBet(hostSeedHash, uint8(bet.t), p.beneficiary, p.amount);
1137     remove(bet);
1138   }
1139 }
1140 
1141 
1142 contract Accessibility {
1143   enum AccessRank { None, Croupier, Games, Withdraw, Full }
1144   mapping(address => AccessRank) public admins;
1145   modifier onlyAdmin(AccessRank  r) {
1146     require(
1147       admins[msg.sender] == r || admins[msg.sender] == AccessRank.Full,
1148       "accessibility: access denied"
1149     );
1150     _;
1151   }
1152   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
1153 
1154   constructor() public {
1155     admins[msg.sender] = AccessRank.Full;
1156     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
1157   }
1158   
1159   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
1160     require(admins[addr] != AccessRank.Full, "accessibility: can`t change full access rank");
1161     if (admins[addr] != rank) {
1162       admins[addr] = rank;
1163       emit LogProvideAccess(addr, now, rank);
1164     }
1165   }
1166 }
1167 
1168 
1169 contract Casino is Accessibility {
1170   using PaymentLib for PaymentLib.Payment;
1171   using RollGameLib for RollGameLib.Game;
1172   using SlotGameLib for SlotGameLib.Game;
1173 
1174   bytes32 private constant JACKPOT_LOG_MSG = "casino.jackpot";
1175   bytes32 private constant WITHDRAW_LOG_MSG = "casino.withdraw";
1176   bytes private constant JACKPOT_NONCE = "jackpot";
1177   uint private constant MIN_JACKPOT_MAGIC = 3333;
1178   uint private constant MAX_JACKPOT_MAGIC = 333333333;
1179   
1180   SlotGameLib.Game public slot;
1181   RollGameLib.Game public roll;
1182   enum Game {Slot, Roll}
1183 
1184   uint public extraJackpot;
1185   uint public jackpotMagic;
1186 
1187   modifier slotBetsWasHandled() {
1188     require(slot.lockedInBets == 0, "casino.slot: all bets should be handled");
1189     _;
1190   }
1191 
1192   event LogIncreaseJackpot(address indexed addr, uint amount);
1193   event LogJackpotMagicChanged(address indexed addr, uint newJackpotMagic);
1194   event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
1195   event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
1196 
1197   event LogJactpot(
1198     address indexed beneficiary, 
1199     uint amount, 
1200     bytes32 hostSeed,
1201     bytes32 clientSeed,
1202     uint jackpotMagic
1203   );
1204 
1205   event LogSlotNewBet(
1206     bytes32 indexed hostSeedHash,
1207     address indexed gambler,
1208     uint amount,
1209     address indexed referrer
1210   );
1211 
1212   event LogSlotHandleBet(
1213     bytes32 indexed hostSeedHash,
1214     address indexed gambler,
1215     bytes32 hostSeed,
1216     bytes32 clientSeed,
1217     bytes symbols,
1218     uint multiplierNum,
1219     uint multiplierDen,
1220     uint amount,
1221     uint winnings
1222   );
1223 
1224   event LogSlotRefundBet(
1225     bytes32 indexed hostSeedHash,
1226     address indexed gambler, 
1227     uint amount
1228   );
1229 
1230   event LogRollNewBet(
1231     bytes32 indexed hostSeedHash, 
1232     uint8 t,
1233     address indexed gambler, 
1234     uint amount,
1235     uint mask, 
1236     uint rollUnder,
1237     address indexed referrer
1238   );
1239 
1240   event LogRollRefundBet(
1241     bytes32 indexed hostSeedHash, 
1242     uint8 t,
1243     address indexed gambler, 
1244     uint amount
1245   );
1246 
1247   event LogRollHandleBet(
1248     bytes32 indexed hostSeedHash, 
1249     uint8 t,
1250     address indexed gambler, 
1251     bytes32 hostSeed, 
1252     bytes32 clientSeed, 
1253     uint roll, 
1254     uint multiplierNum, 
1255     uint multiplierDen,
1256     uint amount,
1257     uint winnings
1258   );
1259 
1260   constructor() public {
1261     jackpotMagic = MIN_JACKPOT_MAGIC;
1262     slot.minBetAmount = SlotGameLib.MinBetAmount();
1263     slot.maxBetAmount = SlotGameLib.MinBetAmount();
1264     roll.minBetAmount = RollGameLib.MinBetAmount();
1265     roll.maxBetAmount = RollGameLib.MinBetAmount();
1266   }
1267 
1268   function() external payable {}
1269   
1270   function rollPlaceBet(
1271     RollGameLib.Type t, 
1272     uint16 mask, 
1273     uint8 rollUnder, 
1274     address referrer,
1275     uint sigExpirationBlock, 
1276     bytes32 hostSeedHash, 
1277     uint8 v, 
1278     bytes32 r, 
1279     bytes32 s
1280   ) 
1281     external payable
1282   {
1283     roll.placeBet(t, mask, rollUnder, referrer, sigExpirationBlock, hostSeedHash, v, r, s);
1284   }
1285 
1286   function rollBet(bytes32 hostSeedHash) 
1287     external 
1288     view 
1289     returns (
1290       RollGameLib.Type t,
1291       uint amount,
1292       uint mask,
1293       uint rollUnder,
1294       uint blockNumber,
1295       address payable gambler,
1296       bool exist
1297     ) 
1298   {
1299     RollGameLib.Bet storage b = roll.bets[hostSeedHash];
1300     t = b.t;
1301     amount = b.amount;
1302     mask = b.mask;
1303     rollUnder = b.rollUnder;
1304     blockNumber = b.blockNumber;
1305     gambler = b.gambler;
1306     exist = b.exist;  
1307   }
1308 
1309   function slotPlaceBet(
1310     address referrer,
1311     uint sigExpirationBlock,
1312     bytes32 hostSeedHash,
1313     uint8 v,
1314     bytes32 r,
1315     bytes32 s
1316   ) 
1317     external payable
1318   {
1319     slot.placeBet(referrer, sigExpirationBlock, hostSeedHash, v, r, s);
1320   }
1321 
1322   function slotBet(bytes32 hostSeedHash) 
1323     external 
1324     view 
1325     returns (
1326       uint amount,
1327       uint blockNumber,
1328       address payable gambler,
1329       bool exist
1330     ) 
1331   {
1332     SlotGameLib.Bet storage b = slot.bets[hostSeedHash];
1333     amount = b.amount;
1334     blockNumber = b.blockNumber;
1335     gambler = b.gambler;
1336     exist = b.exist;  
1337   }
1338 
1339   function slotSetReels(uint n, bytes calldata symbols) 
1340     external 
1341     onlyAdmin(AccessRank.Games) 
1342     slotBetsWasHandled 
1343   {
1344     slot.setReel(n, symbols);
1345   }
1346 
1347   function slotReels(uint n) external view returns (bytes memory) {
1348     return slot.reels[n];
1349   }
1350 
1351   function slotPayLine(uint n) external view returns (bytes memory symbols, uint num, uint den) {
1352     symbols = new bytes(slot.payTable[n].symbols.length);
1353     symbols = slot.payTable[n].symbols;
1354     num = slot.payTable[n].multiplier.num;
1355     den = slot.payTable[n].multiplier.den;
1356   }
1357 
1358   function slotSetPayLine(uint n, bytes calldata symbols, uint num, uint den) 
1359     external 
1360     onlyAdmin(AccessRank.Games) 
1361     slotBetsWasHandled 
1362   {
1363     slot.setPayLine(n, SlotGameLib.Combination(symbols, NumberLib.Number(num, den)));
1364   }
1365 
1366   function slotSpecialPayLine(uint n) external view returns (byte symbol, uint num, uint den, uint[] memory indexes) {
1367     indexes = new uint[](slot.specialPayTable[n].indexes.length);
1368     indexes = slot.specialPayTable[n].indexes;
1369     num = slot.specialPayTable[n].multiplier.num;
1370     den = slot.specialPayTable[n].multiplier.den;
1371     symbol = slot.specialPayTable[n].symbol;
1372   }
1373 
1374   function slotSetSpecialPayLine(
1375     uint n,
1376     byte symbol,
1377     uint num, 
1378     uint den, 
1379     uint[] calldata indexes
1380   ) 
1381     external 
1382     onlyAdmin(AccessRank.Games) 
1383     slotBetsWasHandled
1384   {
1385     SlotGameLib.SpecialCombination memory scomb = SlotGameLib.SpecialCombination(symbol, NumberLib.Number(num, den), indexes);
1386     slot.setSpecialPayLine(n, scomb);
1387   }
1388 
1389   function refundBet(Game game, bytes32 hostSeedHash) external {
1390     PaymentLib.Payment memory p; 
1391     p = game == Game.Slot ? slot.refundBet(hostSeedHash) : roll.refundBet(hostSeedHash);
1392     handlePayment(p);
1393   }
1394 
1395   function setSecretSigner(Game game, address secretSigner) external onlyAdmin(AccessRank.Games) {
1396     address otherSigner = game == Game.Roll ? slot.secretSigner : roll.secretSigner;
1397     require(secretSigner != otherSigner, "casino: slot and roll secret signers must be not equal");
1398     game == Game.Roll ? roll.secretSigner = secretSigner : slot.secretSigner = secretSigner;
1399   }
1400 
1401   function setMinMaxBetAmount(Game game, uint min, uint max) external onlyAdmin(AccessRank.Games) {
1402     game == Game.Roll ? roll.setMinMaxBetAmount(min, max) : slot.setMinMaxBetAmount(min, max);
1403   }
1404 
1405   function kill(address payable beneficiary) 
1406     external 
1407     onlyAdmin(AccessRank.Full) 
1408   {
1409     require(lockedInBets() == 0, "casino: all bets should be handled");
1410     selfdestruct(beneficiary);
1411   }
1412 
1413   function increaseJackpot(uint amount) external onlyAdmin(AccessRank.Games) {
1414     checkEnoughFundsForPay(amount);
1415     extraJackpot += amount;
1416     emit LogIncreaseJackpot(msg.sender, amount);
1417   }
1418 
1419   function setJackpotMagic(uint magic) external onlyAdmin(AccessRank.Games) {
1420     require(MIN_JACKPOT_MAGIC <= magic && magic <= MAX_JACKPOT_MAGIC, "casino: invalid jackpot magic");
1421     jackpotMagic = magic;
1422     emit LogJackpotMagicChanged(msg.sender, magic);
1423   }
1424 
1425   function withdraw(address payable beneficiary, uint amount) external onlyAdmin(AccessRank.Withdraw) {
1426     handlePayment(PaymentLib.Payment(beneficiary, amount, WITHDRAW_LOG_MSG));
1427   }
1428 
1429   function handleBet(Game game, bytes32 hostSeed, bytes32 clientSeed) external onlyAdmin(AccessRank.Croupier) {
1430     PaymentLib.Payment memory p; 
1431     p = game == Game.Slot ? slot.handleBet(hostSeed, clientSeed) : roll.handleBet(hostSeed, clientSeed);
1432     handlePayment(p);
1433     rollJackpot(p.beneficiary, hostSeed, clientSeed);
1434   }
1435 
1436   function handleBetWithProof(
1437     Game game,
1438     bytes32 hostSeed,
1439     uint canonicalBlockNumber,
1440     bytes memory uncleProof,
1441     bytes memory chainProof
1442   )
1443     public onlyAdmin(AccessRank.Croupier)
1444   {
1445     PaymentLib.Payment memory p;
1446     bytes32 clientSeed; 
1447     if (game == Game.Slot) {
1448       (p, clientSeed) = slot.handleBetWithProof(hostSeed, canonicalBlockNumber, uncleProof, chainProof);
1449     } else {
1450       (p, clientSeed) = roll.handleBetWithProof(hostSeed, canonicalBlockNumber, uncleProof, chainProof);
1451     }
1452     handlePayment(p);
1453     rollJackpot(p.beneficiary, hostSeed, clientSeed);
1454   }
1455 
1456   function lockedInBets() public view returns(uint) {
1457     return slot.lockedInBets + roll.lockedInBets;
1458   }
1459 
1460   function jackpot() public view returns(uint) {
1461     return slot.jackpot + roll.jackpot + extraJackpot;
1462   }
1463 
1464   function freeFunds() public view returns(uint) {
1465     if (lockedInBets() + jackpot() >= address(this).balance ) {
1466       return 0;
1467     }
1468     return address(this).balance - lockedInBets() - jackpot();
1469   }
1470 
1471   function rollJackpot(
1472     address payable beneficiary,
1473     bytes32 hostSeed,
1474     bytes32 clientSeed
1475   ) 
1476     private 
1477   {
1478     if (Rnd.uintn(hostSeed, clientSeed, jackpotMagic, JACKPOT_NONCE) != 0) {
1479       return;
1480     }
1481     PaymentLib.Payment memory p = PaymentLib.Payment(beneficiary, jackpot(), JACKPOT_LOG_MSG);
1482     handlePayment(p);
1483 
1484     delete slot.jackpot;
1485     delete roll.jackpot;
1486     delete extraJackpot;
1487     emit LogJactpot(p.beneficiary, p.amount, hostSeed, clientSeed, jackpotMagic);
1488   }
1489 
1490   function checkEnoughFundsForPay(uint amount) private view {
1491     require(freeFunds() >= amount, "casino: not enough funds");
1492   }
1493 
1494   function handlePayment(PaymentLib.Payment memory p) private {
1495     checkEnoughFundsForPay(p.amount);
1496     p.send();
1497   }
1498 }