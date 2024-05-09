1 pragma solidity 0.5.2;
2 
3 
4 /*
5 "Crypto Casino 333" (c) v.1.0
6 Copyright (c) 2019 by -= 333ETH Team =-
7 
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
48 library PaymentLib {
49   struct Payment {
50     address payable beneficiary;
51     uint amount;
52     bytes32 message;
53   }
54 
55   event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
56   event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
57 
58   function send(Payment memory p) internal {
59     if (p.beneficiary.send(p.amount)) {
60       emit LogPayment(p.beneficiary, p.amount, p.message);
61     } else {
62       emit LogFailedPayment(p.beneficiary, p.amount, p.message);
63     }
64   }
65 }
66 
67 
68 
69 library BytesLib {
70 
71 
72   // index returns the index of the first instance of sub in s, or -1 if sub is not present in s. 
73   function index(bytes memory b, bytes memory subb, uint start) internal pure returns(int) {
74     uint lensubb = subb.length;
75     
76     uint hashsubb;
77     uint ptrb;
78     assembly {
79       hashsubb := keccak256(add(subb, 0x20), lensubb)
80       ptrb := add(b, 0x20)
81     }
82     
83     for (uint lenb = b.length; start < lenb; start++) {
84       if (start+lensubb > lenb) {
85         return -1;
86       }
87       bool found;
88       assembly {
89         found := eq(keccak256(add(ptrb, start), lensubb), hashsubb)
90       }
91       if (found) {
92         return int(start);
93       }
94     }
95     return -1;
96   }  
97   
98   // index returns the index of the first instance of sub in s, or -1 if sub is not present in s. 
99   function index(bytes memory b, bytes memory sub) internal pure returns(int) {
100     return index(b, sub, 0);
101   }
102 
103   function index(bytes memory b, byte sub, uint start) internal pure returns(int) {
104     for (uint len = b.length; start < len; start++) {
105       if (b[start] == sub) {
106         return int(start);
107       }
108     }
109     return -1;
110   }
111 
112   function index(bytes memory b, byte sub) internal pure returns(int) {
113     return index(b, sub, 0);
114   }
115 
116   function count(bytes memory b, bytes memory sub) internal pure returns(uint times) {
117     int i = index(b, sub, 0);
118     while (i != -1) {
119       times++;
120       i = index(b, sub, uint(i)+sub.length);
121     }
122   }
123   
124   function equals(bytes memory b, bytes memory a) internal pure returns(bool equal) {
125     if (b.length != a.length) {
126       return false;
127     }
128     
129     uint len = b.length;
130     
131     assembly {
132       equal := eq(keccak256(add(b, 0x20), len), keccak256(add(a, 0x20), len))
133     }  
134   }
135   
136   function copy(bytes memory b) internal pure returns(bytes memory) {
137     return abi.encodePacked(b);
138   }
139   
140   function slice(bytes memory b, uint start, uint end) internal pure returns(bytes memory r) {
141     if (start > end) {
142       return r;
143     }
144     if (end > b.length-1) {
145       end = b.length-1;
146     }
147     r = new bytes(end-start+1);
148     
149     uint j;
150     uint i = start;
151     for (; i <= end; (i++, j++)) {
152       r[j] = b[i];
153     }
154   }
155   
156   function append(bytes memory b, bytes memory a) internal pure returns(bytes memory r) {
157     return abi.encodePacked(b, a);
158   }
159   
160   
161   function replace(bytes memory b, bytes memory oldb, bytes memory newb) internal pure returns(bytes memory r) {
162     if (equals(oldb, newb)) {
163       return copy(b);
164     }
165     
166     uint n = count(b, oldb);
167     if (n == 0) {
168       return copy(b);
169     }
170     
171     uint start;
172     for (uint i; i < n; i++) {
173       uint j = start;
174       j += uint(index(slice(b, start, b.length-1), oldb));  
175       if (j!=0) {
176         r = append(r, slice(b, start, j-1));
177       }
178       
179       r = append(r, newb);
180       start = j + oldb.length;
181     }
182     if (r.length != b.length+n*(newb.length-oldb.length)) {
183       r = append(r, slice(b, start, b.length-1));
184     }
185   }
186 
187   function fillPattern(bytes memory b, bytes memory pattern, byte newb) internal pure returns (uint n) {
188     uint start;
189     while (true) {
190       int i = index(b, pattern, start);
191       if (i < 0) {
192         return n;
193       }
194       uint len = pattern.length;
195       for (uint k = 0; k < len; k++) {
196         b[uint(i)+k] = newb;
197       }
198       start = uint(i)+len;
199       n++;
200     }
201   }
202 }
203 
204 
205 
206 library NumberLib {
207   struct Number {
208     uint num;
209     uint den;
210   }
211 
212   function muluint(Number memory a, uint b) internal pure returns (uint) {
213     return b * a.num / a.den;
214   }
215 
216   function mmul(Number memory a, uint b) internal pure returns(Number memory) {
217     a.num = a.num * b;
218     return a;
219   }
220 
221   function maddm(Number memory a, Number memory b) internal pure returns(Number memory) {
222     a.num = a.num * b.den + b.num * a.den;
223     a.den = a.den * b.den;
224     return a;
225   }
226 
227   function madds(Number memory a, Number storage b) internal view returns(Number memory) {
228     a.num = a.num * b.den + b.num * a.den;
229     a.den = a.den * b.den;
230     return a;
231   }
232 }
233 
234 library Rnd {
235   byte internal constant NONCE_SEP = "\x3a"; // ':'
236 
237   function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n) internal pure returns(uint) {
238     return uint(keccak256(abi.encodePacked(hostSeed, clientSeed))) % n;
239   }
240 
241   function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n, bytes memory nonce) internal pure returns(uint) {
242     return uint(keccak256(abi.encodePacked(hostSeed, clientSeed, NONCE_SEP, nonce))) % n;
243   }
244 }
245 
246 
247 library ProtLib {
248   function checkBlockHash(uint blockNumber, bytes32 blockHash) internal view {
249     require(block.number > blockNumber, "protection lib: current block must be great then block number");
250     require(blockhash(blockNumber) != bytes32(0), "protection lib: blockhash can't be queried by EVM");
251     require(blockhash(blockNumber) == blockHash, "protection lib: invalid block hash");
252   }
253 
254   function checkSigner(address signer, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal pure {
255     require(signer == ecrecover(message, v, r, s), "protection lib: ECDSA signature is not valid");
256   }
257 
258   function checkSigner(address signer, uint expirationBlock, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal view {
259     require(block.number <= expirationBlock, "protection lib: signature has expired");
260     checkSigner(signer, keccak256(abi.encodePacked(message, expirationBlock)), v, r, s);
261   }
262 }
263 
264 
265 
266 /**
267  * @title SafeMath
268  * @dev Unsigned math operations with safety checks that revert on error
269  */
270 library SafeMath {
271     /**
272      * @dev Multiplies two unsigned integers, reverts on overflow.
273      */
274     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
275         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
276         // benefit is lost if 'b' is also tested.
277         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
278         if (a == 0) {
279             return 0;
280         }
281 
282         uint256 c = a * b;
283         require(c / a == b);
284 
285         return c;
286     }
287 
288     /**
289      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
290      */
291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
292         // Solidity only automatically asserts when dividing by 0
293         require(b > 0);
294         uint256 c = a / b;
295         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
296 
297         return c;
298     }
299 
300     /**
301      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
302      */
303     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
304         require(b <= a);
305         uint256 c = a - b;
306 
307         return c;
308     }
309 
310     /**
311      * @dev Adds two unsigned integers, reverts on overflow.
312      */
313     function add(uint256 a, uint256 b) internal pure returns (uint256) {
314         uint256 c = a + b;
315         require(c >= a);
316 
317         return c;
318     }
319 
320     /**
321      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
322      * reverts when dividing by zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         require(b != 0);
326         return a % b;
327     }
328 }
329 
330 
331 
332 library ProofLib {
333   function chainHash(bytes memory chainProof, bytes memory uncleHeader) internal pure returns(bytes32 hash) {
334     uint proofLen = chainProof.length;
335     require(proofLen >= 4, "proof lib: chain proof length too low");
336     bytes memory slotData = uncleHeader;
337     uint slotDataPtr;  assembly { slotDataPtr := add(slotData, 32) }
338     
339     for (uint offset; ;) {
340       // uncles blob
341       (uint blobPtr, uint blobLen, uint blobShift) = blobPtrLenShift(chainProof, offset, slotData.length);
342       offset += 4;
343       // put uncle header to uncles slot.
344       uint slotPtr; assembly { slotPtr := add(blobPtr, blobShift) }
345       memcpy(slotDataPtr, slotPtr, slotData.length);
346       // calc uncles hash
347       assembly { hash := keccak256(blobPtr, blobLen) }
348       offset += blobLen;
349       
350       
351       // header blob
352       (blobPtr, blobLen, blobShift) = blobPtrLenShift(chainProof, offset, 32);
353       offset += 4;
354       uint hashSlot; assembly { hashSlot := mload(add(blobPtr, blobShift)) }
355       require(hashSlot == 0, "proof lib: non-empty uncles hash slot");
356       assembly { 
357         mstore(add(blobPtr, blobShift), hash)  // put uncles hash to uncles hash slot.
358         hash := keccak256(blobPtr, blobLen) // calc header hash
359       }
360       offset += blobLen;
361       
362       // return if has not next blob
363       if (offset+4 >= proofLen) {
364         return hash;
365       }
366       
367       // copy header blob to slotData for using in next blob
368       slotData = new bytes(blobLen); assembly { slotDataPtr := add(slotData, 32) }
369       memcpy(blobPtr, slotDataPtr, blobLen);
370     }
371   }
372   
373   function uncleHeader(bytes memory proof, bytes32 hostSeedHash) internal pure returns(bytes32 headerHash, bytes memory header) {
374     uint proofLen = proof.length;
375     require(proofLen >= 4, "proof lib: uncle proof length too low");
376     uint blobPtr; uint blobLen; 
377     bytes32 blobHash = hostSeedHash;
378     for (uint offset; offset+4 < proofLen; offset += blobLen) {
379       uint blobShift;
380       (blobPtr, blobLen, blobShift) = blobPtrLenShift(proof, offset, 32);
381       offset += 4;
382       uint hashSlot; assembly { hashSlot := mload(add(blobPtr, blobShift)) }
383       require(hashSlot == 0, "proof lib: non-empty hash slot");
384       assembly { 
385         mstore(add(blobPtr, blobShift), blobHash) 
386         blobHash := keccak256(blobPtr, blobLen)
387       }
388     }
389     
390     header = new bytes(blobLen);
391     uint headerPtr; assembly { headerPtr := add(header, 32) }
392     memcpy(blobPtr, headerPtr, blobLen); 
393     return (blobHash, header);
394   }
395 
396   function receiptAddr(bytes memory proof) internal pure returns(address addr) {
397     uint b;
398     uint offset; assembly { offset := add(add(proof, 32), 4) }
399     
400     // leaf header
401     assembly { b := byte(0, mload(offset)) }
402     require(b >= 0xf7, "proof lib: receipt leaf longer than 55 bytes");
403     offset += b - 0xf6;
404 
405     // path header
406     assembly { b := byte(0, mload(offset)) }
407     if (b <= 0x7f) {
408       offset += 1;
409     } else {
410       require(b >= 0x80 && b <= 0xb7, "proof lib: path is an RLP string");
411       offset += b - 0x7f;
412     }
413 
414     // receipt string header
415     assembly { b := byte(0, mload(offset)) }
416     require(b == 0xb9, "proof lib: Rrceipt str is always at least 256 bytes long, but less than 64k");
417     offset += 3;
418 
419     // receipt header
420     assembly { b := byte(0, mload(offset)) }
421     require(b == 0xf9, "proof lib: receipt is always at least 256 bytes long, but less than 64k");
422     offset += 3;
423 
424     // status
425     assembly { b := byte(0, mload(offset)) }
426     require(b == 0x1, "proof lib: status should be success");
427     offset += 1;
428 
429     // cum gas header
430     assembly { b := byte(0, mload(offset)) }
431     if (b <= 0x7f) {
432       offset += 1;
433     } else {
434       require(b >= 0x80 && b <= 0xb7, "proof lib: cumulative gas is an RLP string");
435       offset += b - 0x7f;
436     }
437 
438     // bloom header
439     assembly { b := byte(0, mload(offset)) }
440     require(b == 0xb9, "proof lib: bloom filter is always 256 bytes long");
441     offset += 256 + 3;
442 
443     // logs list header
444     assembly { b := byte(0, mload(offset)) }
445     require(b == 0xf8, "proof lib: logs list is less than 256 bytes long");
446     offset += 2;
447 
448     // log entry header
449     assembly { b := byte(0, mload(offset)) }
450     require(b == 0xf8, "proof lib: log entry is less than 256 bytes long");
451     offset += 2;
452 
453     // address header
454     assembly { b := byte(0, mload(offset)) }
455     require(b == 0x94, "proof lib: address is 20 bytes long");
456     
457     offset -= 11;
458     assembly { addr := and(mload(offset), 0xffffffffffffffffffffffffffffffffffffffff) }
459   }
460 
461 
462   function blobPtrLenShift(bytes memory proof, uint offset, uint slotDataLen) internal pure returns(uint ptr, uint len, uint shift) {
463     assembly { 
464       ptr := add(add(proof, 32), offset) 
465       len := and(mload(sub(ptr, 30)), 0xffff)
466     }
467     require(proof.length >= len+offset+4, "proof lib: blob length out of range proof");
468     assembly { shift := and(mload(sub(ptr, 28)), 0xffff) }
469     require(shift + slotDataLen <= len, "proof lib: blob shift bounds check");
470     ptr += 4;
471   }
472 
473   // Copy 'len' bytes from memory address 'src', to address 'dest'.
474   // This function does not check the or destination, it only copies
475   // the bytes.
476   function memcpy(uint src, uint dest, uint len) internal pure {
477     // Copy word-length chunks while possible
478     for (; len >= 32; len -= 32) {
479       assembly {
480         mstore(dest, mload(src))
481       }
482       dest += 32;
483       src += 32;
484     }
485 
486     // Copy remaining bytes
487     uint mask = 256 ** (32 - len) - 1;
488     assembly {
489       let srcpart := and(mload(src), not(mask))
490       let destpart := and(mload(dest), mask)
491       mstore(dest, or(destpart, srcpart))
492     }
493   }   
494 }
495 
496 
497 
498 
499 library SlotGameLib {
500   using BytesLib for bytes;
501   using SafeMath for uint;
502   using SafeMath for uint128;
503   using NumberLib for NumberLib.Number;
504 
505   struct Bet {
506     uint amount; 
507     uint40 blockNumber; // 40
508     address payable gambler; // 160
509     bool exist; // 1
510   }
511 
512   function remove(Bet storage bet) internal {
513     delete bet.amount;
514     delete bet.blockNumber;
515     delete bet.gambler;
516   }
517 
518   struct Combination {
519     bytes symbols;
520     NumberLib.Number multiplier;
521   }
522 
523   struct SpecialCombination {
524     byte symbol;
525     NumberLib.Number multiplier;
526     uint[] indexes; // not uint8, optimize hasIn
527   }
528 
529   function hasIn(SpecialCombination storage sc, bytes memory symbols) internal view returns (bool) {
530     uint len = sc.indexes.length;
531     byte symbol = sc.symbol;
532     for (uint i = 0; i < len; i++) {
533       if (symbols[sc.indexes[i]] != symbol) {
534         return false;
535       }
536     }
537     return true;
538   }
539 
540   // the symbol that don't use in reels
541   byte private constant UNUSED_SYMBOL = "\xff"; // 255
542   uint internal constant REELS_LEN = 9;
543   uint private constant BIG_COMBINATION_MIN_LEN = 8;
544   bytes32 private constant PAYMENT_LOG_MSG = "slot";
545   bytes32 private constant REFUND_LOG_MSG = "slot.refund";
546   uint private constant HANDLE_BET_COST = 0.001 ether;
547   uint private constant HOUSE_EDGE_PERCENT = 1;
548   uint private constant JACKPOT_PERCENT = 1;
549   uint private constant MIN_WIN_PERCENT = 30;
550   uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100 / MIN_WIN_PERCENT * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
551   
552   function MinBetAmount() internal pure returns(uint) {
553     return MIN_BET_AMOUNT;
554   }
555 
556   
557   struct Game {
558     address secretSigner;
559     uint128 lockedInBets;
560     uint128 jackpot;
561     uint maxBetAmount;
562     uint minBetAmount;
563 
564     bytes[REELS_LEN] reels;
565     // pay table array with prioritet for 0-elem to N-elem, where 0 - MAX prior and N - LOW prior
566     Combination[] payTable;
567     SpecialCombination[] specialPayTable;
568 
569     mapping(bytes32 => Bet) bets;
570   }
571 
572   event LogSlotNewBet(
573     bytes32 indexed hostSeedHash,
574     address indexed gambler,
575     uint amount,
576     address indexed referrer
577   );
578 
579   event LogSlotHandleBet(
580     bytes32 indexed hostSeedHash,
581     address indexed gambler,
582     bytes32 hostSeed,
583     bytes32 clientSeed,
584     bytes symbols,
585     uint multiplierNum,
586     uint multiplierDen,
587     uint amount,
588     uint winnings
589   );
590 
591   event LogSlotRefundBet(
592     bytes32 indexed hostSeedHash,
593     address indexed gambler, 
594     uint amount
595   );
596 
597   function setReel(Game storage game, uint n, bytes memory symbols) internal {
598     require(REELS_LEN > n, "slot game: invalid reel number");
599     require(symbols.length > 0, "slot game: invalid reel`s symbols length");
600     require(symbols.index(UNUSED_SYMBOL) == -1, "slot game: reel`s symbols contains invalid symbol");
601     game.reels[n] = symbols;
602   }
603 
604   function setPayLine(Game storage game, uint n, Combination memory comb) internal {
605     require(n <= game.payTable.length, "slot game: invalid pay line number");
606     require(comb.symbols.index(UNUSED_SYMBOL) == -1, "slot game: combination symbols contains invalid symbol");
607 
608     if (n == game.payTable.length && comb.symbols.length > 0) {
609       game.payTable.push(comb);
610       return;
611     } 
612     
613     if (n == game.payTable.length-1 && comb.symbols.length == 0) {
614       game.payTable.pop();
615       return;
616     }
617 
618     require(
619       0 < comb.symbols.length && comb.symbols.length <= REELS_LEN, 
620       "slot game: invalid combination`s symbols length"
621     );
622     game.payTable[n] = comb;
623   }
624 
625   function setSpecialPayLine(Game storage game, uint n, SpecialCombination memory scomb) internal {
626     require(game.specialPayTable.length >= n, "slot game: invalid pay line number");
627     require(scomb.symbol != UNUSED_SYMBOL, "slot game: invalid special combination`s symbol");
628 
629     if (n == game.specialPayTable.length && scomb.indexes.length > 0) {
630       game.specialPayTable.push(scomb);
631       return;
632     } 
633     
634     if (n == game.specialPayTable.length-1 && scomb.indexes.length == 0) {
635       game.specialPayTable.pop();
636       return;
637     }
638 
639     require(
640       0 < scomb.indexes.length && scomb.indexes.length <= REELS_LEN, 
641       "slot game: invalid special combination`s indexes length"
642     );
643     game.specialPayTable[n] = scomb;
644   }
645 
646   function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
647     require(minBetAmount >= MIN_BET_AMOUNT, "slot game: invalid min of bet amount");
648     require(minBetAmount <= maxBetAmount, "slot game: invalid [min, max] range of bet amount");
649     game.minBetAmount = minBetAmount;
650     game.maxBetAmount = maxBetAmount;
651   }
652 
653   function placeBet(
654     Game storage game,
655     address referrer,
656     uint sigExpirationBlock,
657     bytes32 hostSeedHash,
658     uint8 v, 
659     bytes32 r, 
660     bytes32 s
661   ) 
662     internal
663   {
664     ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
665 
666     Bet storage bet = game.bets[hostSeedHash];
667     require(!bet.exist, "slot game: bet already exist");
668     require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "slot game: invalid bet amount");
669     
670     bet.amount = msg.value;
671     bet.blockNumber = uint40(block.number);
672     bet.gambler = msg.sender;
673     bet.exist = true;
674     
675     game.lockedInBets += uint128(msg.value);
676     game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
677 
678     emit LogSlotNewBet(
679       hostSeedHash, 
680       msg.sender, 
681       msg.value,
682       referrer
683     );
684   }
685 
686   function handleBetPrepare(
687     Game storage game,
688     bytes32 hostSeed
689   ) 
690     internal view
691     returns(
692       Bet storage bet,
693       bytes32 hostSeedHash, // return it for optimization
694       uint betAmount // return it for optimization
695     ) 
696   {
697     hostSeedHash = keccak256(abi.encodePacked(hostSeed));
698     bet = game.bets[hostSeedHash];
699     betAmount = bet.amount;
700     require(bet.exist, "slot game: bet does not exist");
701     require(betAmount > 0, "slot game: bet already handled");
702   }
703 
704   function handleBetCommon(
705     Game storage game,
706     Bet storage bet,
707     bytes32 hostSeed,
708     bytes32 hostSeedHash,
709     bytes32 clientSeed,
710     uint betAmount
711   ) 
712     internal 
713     returns(
714       PaymentLib.Payment memory p
715     ) 
716   {
717     game.lockedInBets -= uint128(betAmount);
718     Combination memory c = spin(game, hostSeed, clientSeed);
719     uint winnings = c.multiplier.muluint(betAmount);
720 
721     if (winnings > 0) {
722       winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
723       winnings = winnings.sub(HANDLE_BET_COST);
724     } else {
725       winnings = 1;
726     }
727     p.beneficiary = bet.gambler; 
728     p.amount = winnings; 
729     p.message = PAYMENT_LOG_MSG; 
730 
731     emit LogSlotHandleBet(
732       hostSeedHash,
733       p.beneficiary, 
734       hostSeed, 
735       clientSeed, 
736       c.symbols, 
737       c.multiplier.num, 
738       c.multiplier.den,
739       betAmount,
740       winnings
741     );
742     remove(bet);
743   }
744   
745   function handleBet(
746     Game storage game,
747     bytes32 hostSeed,
748     bytes32 clientSeed
749   ) 
750     internal 
751     returns(
752       PaymentLib.Payment memory
753     ) 
754   {
755     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
756     ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
757     return handleBetCommon(game, bet, hostSeed, hostSeedHash, clientSeed, betAmount);
758   }
759 
760   function handleBetWithProof(
761     Game storage game,
762     bytes32 hostSeed,
763     uint canonicalBlockNumber,
764     bytes memory uncleProof,
765     bytes memory chainProof
766   ) 
767     internal 
768     returns(
769       PaymentLib.Payment memory,
770       bytes32 // clientSeed
771     ) 
772   {
773     require(address(this) == ProofLib.receiptAddr(uncleProof), "slot game: invalid receipt address");
774     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
775     (bytes32 uncleHeaderHash, bytes memory uncleHeader) = ProofLib.uncleHeader(uncleProof, hostSeedHash);
776     bytes32 canonicalBlockHash = ProofLib.chainHash(chainProof, uncleHeader);
777     ProtLib.checkBlockHash(canonicalBlockNumber, canonicalBlockHash);
778     return (handleBetCommon(game, bet, hostSeed, hostSeedHash, uncleHeaderHash, betAmount), uncleHeaderHash); 
779   }
780 
781   function spin(
782     Game storage game,
783     bytes32 hostSeed,
784     bytes32 clientSeed
785   ) 
786     internal 
787     view 
788     returns (
789       Combination memory combination
790     ) 
791   {
792     bytes memory symbolsTmp = new bytes(REELS_LEN);
793     for (uint i; i < REELS_LEN; i++) {
794       bytes memory nonce = abi.encodePacked(uint8(i));
795       symbolsTmp[i] = game.reels[i][Rnd.uintn(hostSeed, clientSeed, game.reels[i].length, nonce)];
796     }
797     combination.symbols = symbolsTmp.copy();
798     combination.multiplier = NumberLib.Number(0, 1); // 0/1 == 0.0
799     
800     for ((uint i, uint length) = (0, game.payTable.length); i < length; i++) {
801       bytes memory tmp = game.payTable[i].symbols;
802       uint times = symbolsTmp.fillPattern(tmp, UNUSED_SYMBOL);
803       if (times > 0) {
804         combination.multiplier.maddm(game.payTable[i].multiplier.mmul(times));
805         if (tmp.length >= BIG_COMBINATION_MIN_LEN) {
806           return combination; 
807 			  }
808       }
809     }
810     
811     for ((uint i, uint length) = (0, game.specialPayTable.length); i < length; i++) {
812       if (hasIn(game.specialPayTable[i], combination.symbols)) {
813         combination.multiplier.madds(game.specialPayTable[i].multiplier);
814       }
815     }
816   }
817 
818   function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
819     Bet storage bet = game.bets[hostSeedHash];
820     uint betAmount = bet.amount;
821     require(bet.exist, "slot game: bet does not exist");
822     require(betAmount > 0, "slot game: bet already handled");
823     require(blockhash(bet.blockNumber) == bytes32(0), "slot game: cannot refund bet");
824    
825     game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
826     game.lockedInBets -= uint128(betAmount);
827     p.beneficiary = bet.gambler; 
828     p.amount = betAmount; 
829     p.message = REFUND_LOG_MSG; 
830 
831     emit LogSlotRefundBet(hostSeedHash, p.beneficiary, p.amount);
832     remove(bet);
833   }
834 }
835 
836 
837 library BitsLib {
838 
839   // popcnt returns the number of one bits ("population count") in x.
840   // https://en.wikipedia.org/wiki/Hamming_weight 
841   function popcnt(uint16 x) internal pure returns(uint) {
842     x -= (x >> 1) & 0x5555;
843     x = (x & 0x3333) + ((x >> 2) & 0x3333);
844     x = (x + (x >> 4)) & 0x0f0f;
845     return (x * 0x0101) >> 8;
846   }
847 }
848 
849 
850 library RollGameLib {
851   using NumberLib for NumberLib.Number;
852   using SafeMath for uint;
853   using SafeMath for uint128;
854 
855   // Types
856   enum Type {Coin, Square3x3, Roll}
857   uint private constant COIN_MOD = 2;
858   uint private constant SQUARE_3X3_MOD = 9;
859   uint private constant ROLL_MOD = 100;
860   bytes32 private constant COIN_PAYMENT_LOG_MSG = "roll.coin";
861   bytes32 private constant SQUARE_3X3_PAYMENT_LOG_MSG = "roll.square_3x3";
862   bytes32 private constant ROLL_PAYMENT_LOG_MSG = "roll.roll";
863   bytes32 private constant REFUND_LOG_MSG = "roll.refund";
864   uint private constant HOUSE_EDGE_PERCENT = 1;
865   uint private constant JACKPOT_PERCENT = 1;
866   uint private constant HANDLE_BET_COST = 0.0005 ether;
867   uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
868 
869   function MinBetAmount() internal pure returns(uint) {
870     return MIN_BET_AMOUNT;
871   }
872 
873   // solium-disable lbrace, whitespace
874   function module(Type t) internal pure returns(uint) {
875     if (t == Type.Coin) { return COIN_MOD; } 
876     else if (t == Type.Square3x3) { return SQUARE_3X3_MOD; } 
877     else { return ROLL_MOD; }
878   }
879 
880   function logMsg(Type t) internal pure returns(bytes32) {
881     if (t == Type.Coin) { return COIN_PAYMENT_LOG_MSG; } 
882     else if (t == Type.Square3x3) { return SQUARE_3X3_PAYMENT_LOG_MSG; }
883     else { return ROLL_PAYMENT_LOG_MSG; }
884   }
885 
886   function maskRange(Type t) internal pure returns(uint, uint) {
887     if (t == Type.Coin) { return (1, 2 ** COIN_MOD - 2); } 
888     else if (t == Type.Square3x3) { return (1, 2 ** SQUARE_3X3_MOD - 2); }
889   }
890 
891   function rollUnderRange(Type t) internal pure returns(uint, uint) {
892     if (t == Type.Roll) { return (1, ROLL_MOD - 1); } // 0..99
893   }
894   // solium-enable lbrace, whitespace
895 
896 
897 
898   struct Bet {
899     uint amount;
900     Type t; // 8
901     uint8 rollUnder; // 8
902     uint16 mask;  // 16
903     uint40 blockNumber; // 40
904     address payable gambler; // 160
905     bool exist; // 1
906   }
907 
908   function roll(
909     Bet storage bet,
910     bytes32 hostSeed,
911     bytes32 clientSeed
912   ) 
913     internal 
914     view 
915     returns (
916       uint rnd,
917       NumberLib.Number memory multiplier
918     ) 
919   {
920     uint m = module(bet.t);
921     rnd = Rnd.uintn(hostSeed, clientSeed, m);
922     multiplier.den = 1; // prevent divide to zero
923     
924     uint mask = bet.mask;
925     if (mask != 0) {
926       if (((2 ** rnd) & mask) != 0) {
927         multiplier.den = BitsLib.popcnt(uint16(mask));
928         multiplier.num = m;
929       }
930     } else {
931       uint rollUnder = bet.rollUnder;
932       if (rollUnder > rnd) {
933         multiplier.den = rollUnder;
934         multiplier.num = m;
935       }
936     }
937   }
938 
939   function remove(Bet storage bet) internal {
940     delete bet.amount;
941     delete bet.t;
942     delete bet.mask;
943     delete bet.rollUnder;
944     delete bet.blockNumber;
945     delete bet.gambler;
946   }
947 
948 
949 
950   struct Game {
951     address secretSigner;
952     uint128 lockedInBets;
953     uint128 jackpot;
954     uint maxBetAmount;
955     uint minBetAmount;
956     
957     mapping(bytes32 => Bet) bets;
958   }
959 
960   event LogRollNewBet(
961     bytes32 indexed hostSeedHash, 
962     uint8 t,
963     address indexed gambler, 
964     uint amount,
965     uint mask, 
966     uint rollUnder,
967     address indexed referrer
968   );
969 
970   event LogRollRefundBet(
971     bytes32 indexed hostSeedHash, 
972     uint8 t,
973     address indexed gambler, 
974     uint amount
975   );
976 
977   event LogRollHandleBet(
978     bytes32 indexed hostSeedHash, 
979     uint8 t,
980     address indexed gambler, 
981     bytes32 hostSeed, 
982     bytes32 clientSeed, 
983     uint roll, 
984     uint multiplierNum, 
985     uint multiplierDen,
986     uint amount,
987     uint winnings
988   );
989 
990   function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
991     require(minBetAmount >= MIN_BET_AMOUNT, "roll game: invalid min of bet amount");
992     require(minBetAmount <= maxBetAmount, "roll game: invalid [min, max] range of bet amount");
993     game.minBetAmount = minBetAmount;
994     game.maxBetAmount = maxBetAmount;
995   }
996 
997   function placeBet(
998     Game storage game, 
999     Type t, 
1000     uint16 mask, 
1001     uint8 rollUnder,
1002     address referrer,
1003     uint sigExpirationBlock,
1004     bytes32 hostSeedHash, 
1005     uint8 v, 
1006     bytes32 r, 
1007     bytes32 s
1008   ) 
1009     internal 
1010   {
1011     ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
1012     Bet storage bet = game.bets[hostSeedHash];
1013     require(!bet.exist, "roll game: bet already exist");
1014     require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "roll game: invalid bet amount");
1015 
1016     {  // solium-disable indentation
1017       // prevent stack to deep
1018       (uint minMask, uint maxMask) = maskRange(t);
1019       require(minMask <= mask && mask <= maxMask, "roll game: invalid bet mask");
1020       (uint minRollUnder, uint maxRollUnder) = rollUnderRange(t);
1021       require(minRollUnder <= rollUnder && rollUnder <= maxRollUnder, "roll game: invalid bet roll under");
1022     }  // solium-enable indentation
1023 
1024     // * do not touch it! this order is the best for optimization
1025     bet.amount = msg.value;
1026     bet.blockNumber = uint40(block.number);
1027     bet.gambler = msg.sender;
1028     bet.exist = true;
1029     bet.mask = mask;
1030     bet.rollUnder = rollUnder;
1031     bet.t = t;
1032     // *
1033 
1034     game.lockedInBets += uint128(msg.value);
1035     game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);
1036 
1037     emit LogRollNewBet(
1038       hostSeedHash,
1039       uint8(t),
1040       msg.sender,
1041       msg.value,
1042       mask,
1043       rollUnder,
1044       referrer
1045     );
1046   }
1047 
1048 
1049   function handleBetPrepare(
1050     Game storage game,
1051     bytes32 hostSeed
1052   ) 
1053     internal view
1054     returns(
1055       Bet storage bet,
1056       bytes32 hostSeedHash, // return it for optimization
1057       uint betAmount // return it for optimization
1058     ) 
1059   {
1060     hostSeedHash = keccak256(abi.encodePacked(hostSeed));
1061     bet = game.bets[hostSeedHash];
1062     betAmount = bet.amount;
1063     require(bet.exist, "slot game: bet does not exist");
1064     require(betAmount > 0, "slot game: bet already handled");
1065   }
1066 
1067 
1068   function handleBetCommon(
1069     Game storage game,
1070     Bet storage bet,
1071     bytes32 hostSeed,
1072     bytes32 hostSeedHash,
1073     bytes32 clientSeed,
1074     uint betAmount
1075   ) 
1076     internal 
1077     returns(
1078       PaymentLib.Payment memory p
1079     ) 
1080   {
1081     game.lockedInBets -= uint128(betAmount);
1082     (uint rnd, NumberLib.Number memory multiplier) = roll(bet, hostSeed, clientSeed);
1083     uint winnings = multiplier.muluint(betAmount);
1084   
1085     if (winnings > 0) {
1086       winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
1087       winnings = winnings.sub(HANDLE_BET_COST);
1088     } else {
1089       winnings = 1;
1090     }
1091     p.beneficiary = bet.gambler; 
1092     p.amount = winnings; 
1093     p.message = logMsg(bet.t); 
1094 
1095     emit LogRollHandleBet(
1096       hostSeedHash,
1097       uint8(bet.t),
1098       p.beneficiary,
1099       hostSeed,
1100       clientSeed,
1101       rnd,
1102       multiplier.num,
1103       multiplier.den,
1104       betAmount,
1105       winnings
1106     );
1107     remove(bet);
1108   }
1109 
1110   function handleBet(
1111     Game storage game,
1112     bytes32 hostSeed,
1113     bytes32 clientSeed
1114   ) 
1115     internal 
1116     returns(
1117       PaymentLib.Payment memory
1118     ) 
1119   {
1120     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
1121     ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
1122     return handleBetCommon(game, bet, hostSeed, hostSeedHash, clientSeed, betAmount);
1123   }
1124 
1125   function handleBetWithProof(
1126     Game storage game,
1127     bytes32 hostSeed,
1128     uint canonicalBlockNumber,
1129     bytes memory uncleProof,
1130     bytes memory chainProof
1131   ) 
1132     internal 
1133     returns(
1134       PaymentLib.Payment memory,
1135       bytes32 // clientSeed
1136     ) 
1137   {
1138     require(address(this) == ProofLib.receiptAddr(uncleProof), "roll game: invalid receipt address");
1139     (Bet storage bet, bytes32 hostSeedHash, uint betAmount) = handleBetPrepare(game, hostSeed);
1140     (bytes32 uncleHeaderHash, bytes memory uncleHeader) = ProofLib.uncleHeader(uncleProof, hostSeedHash);
1141     bytes32 canonicalBlockHash = ProofLib.chainHash(chainProof, uncleHeader);
1142     ProtLib.checkBlockHash(canonicalBlockNumber, canonicalBlockHash);
1143     return (handleBetCommon(game, bet, hostSeed, hostSeedHash, uncleHeaderHash, betAmount), uncleHeaderHash); 
1144   }
1145 
1146   function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
1147     Bet storage bet = game.bets[hostSeedHash];
1148     uint betAmount = bet.amount;
1149     require(bet.exist, "roll game: bet does not exist");
1150     require(betAmount > 0, "roll game: bet already handled");
1151     require(blockhash(bet.blockNumber) == bytes32(0), "roll game: cannot refund bet");
1152    
1153     game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
1154     game.lockedInBets -= uint128(betAmount);
1155     p.beneficiary = bet.gambler; 
1156     p.amount = betAmount; 
1157     p.message = REFUND_LOG_MSG; 
1158 
1159     emit LogRollRefundBet(hostSeedHash, uint8(bet.t), p.beneficiary, p.amount);
1160     remove(bet);
1161   }
1162 }
1163 
1164 contract Accessibility {
1165   enum AccessRank { None, Croupier, Games, Withdraw, Full }
1166   mapping(address => AccessRank) public admins;
1167   modifier onlyAdmin(AccessRank  r) {
1168     require(
1169       admins[msg.sender] == r || admins[msg.sender] == AccessRank.Full,
1170       "accessibility: access denied"
1171     );
1172     _;
1173   }
1174   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
1175 
1176   constructor() public {
1177     admins[msg.sender] = AccessRank.Full;
1178     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
1179   }
1180   
1181   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
1182     require(admins[addr] != AccessRank.Full, "accessibility: cannot change full access rank");
1183     if (admins[addr] != rank) {
1184       admins[addr] = rank;
1185       emit LogProvideAccess(addr, now, rank);
1186     }
1187   }
1188 }
1189 
1190 
1191 contract Casino is Accessibility {
1192   using PaymentLib for PaymentLib.Payment;
1193   using RollGameLib for RollGameLib.Game;
1194   using SlotGameLib for SlotGameLib.Game;
1195 
1196   bytes32 private constant JACKPOT_LOG_MSG = "casino.jackpot";
1197   bytes32 private constant WITHDRAW_LOG_MSG = "casino.withdraw";
1198   bytes private constant JACKPOT_NONCE = "jackpot";
1199   uint private constant MIN_JACKPOT_MAGIC = 3333;
1200   uint private constant MAX_JACKPOT_MAGIC = 333333333;
1201   
1202   SlotGameLib.Game public slot;
1203   RollGameLib.Game public roll;
1204   enum Game {Slot, Roll}
1205 
1206   uint public extraJackpot;
1207   uint public jackpotMagic;
1208 
1209   modifier slotBetsWasHandled() {
1210     require(slot.lockedInBets == 0, "casino.slot: all bets should be handled");
1211     _;
1212   }
1213 
1214   event LogIncreaseJackpot(address indexed addr, uint amount);
1215   event LogJackpotMagicChanged(address indexed addr, uint newJackpotMagic);
1216   event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
1217   event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
1218 
1219   event LogJactpot(
1220     address indexed beneficiary, 
1221     uint amount, 
1222     bytes32 hostSeed,
1223     bytes32 clientSeed,
1224     uint jackpotMagic
1225   );
1226 
1227   event LogSlotNewBet(
1228     bytes32 indexed hostSeedHash,
1229     address indexed gambler,
1230     uint amount,
1231     address indexed referrer
1232   );
1233 
1234   event LogSlotHandleBet(
1235     bytes32 indexed hostSeedHash,
1236     address indexed gambler,
1237     bytes32 hostSeed,
1238     bytes32 clientSeed,
1239     bytes symbols,
1240     uint multiplierNum,
1241     uint multiplierDen,
1242     uint amount,
1243     uint winnings
1244   );
1245 
1246   event LogSlotRefundBet(
1247     bytes32 indexed hostSeedHash,
1248     address indexed gambler, 
1249     uint amount
1250   );
1251 
1252   event LogRollNewBet(
1253     bytes32 indexed hostSeedHash, 
1254     uint8 t,
1255     address indexed gambler, 
1256     uint amount,
1257     uint mask, 
1258     uint rollUnder,
1259     address indexed referrer
1260   );
1261 
1262   event LogRollRefundBet(
1263     bytes32 indexed hostSeedHash, 
1264     uint8 t,
1265     address indexed gambler, 
1266     uint amount
1267   );
1268 
1269   event LogRollHandleBet(
1270     bytes32 indexed hostSeedHash, 
1271     uint8 t,
1272     address indexed gambler, 
1273     bytes32 hostSeed, 
1274     bytes32 clientSeed, 
1275     uint roll, 
1276     uint multiplierNum, 
1277     uint multiplierDen,
1278     uint amount,
1279     uint winnings
1280   );
1281 
1282   constructor() public {
1283     jackpotMagic = MIN_JACKPOT_MAGIC;
1284     slot.minBetAmount = SlotGameLib.MinBetAmount();
1285     slot.maxBetAmount = SlotGameLib.MinBetAmount();
1286     roll.minBetAmount = RollGameLib.MinBetAmount();
1287     roll.maxBetAmount = RollGameLib.MinBetAmount();
1288   }
1289 
1290   function() external payable {}
1291   
1292   function rollPlaceBet(
1293     RollGameLib.Type t, 
1294     uint16 mask, 
1295     uint8 rollUnder, 
1296     address referrer,
1297     uint sigExpirationBlock, 
1298     bytes32 hostSeedHash, 
1299     uint8 v, 
1300     bytes32 r, 
1301     bytes32 s
1302   ) 
1303     external payable
1304   {
1305     roll.placeBet(t, mask, rollUnder, referrer, sigExpirationBlock, hostSeedHash, v, r, s);
1306   }
1307 
1308   function rollBet(bytes32 hostSeedHash) 
1309     external 
1310     view 
1311     returns (
1312       RollGameLib.Type t,
1313       uint amount,
1314       uint mask,
1315       uint rollUnder,
1316       uint blockNumber,
1317       address payable gambler,
1318       bool exist
1319     ) 
1320   {
1321     RollGameLib.Bet storage b = roll.bets[hostSeedHash];
1322     t = b.t;
1323     amount = b.amount;
1324     mask = b.mask;
1325     rollUnder = b.rollUnder;
1326     blockNumber = b.blockNumber;
1327     gambler = b.gambler;
1328     exist = b.exist;  
1329   }
1330 
1331   function slotPlaceBet(
1332     address referrer,
1333     uint sigExpirationBlock,
1334     bytes32 hostSeedHash,
1335     uint8 v,
1336     bytes32 r,
1337     bytes32 s
1338   ) 
1339     external payable
1340   {
1341     slot.placeBet(referrer, sigExpirationBlock, hostSeedHash, v, r, s);
1342   }
1343 
1344   function slotBet(bytes32 hostSeedHash) 
1345     external 
1346     view 
1347     returns (
1348       uint amount,
1349       uint blockNumber,
1350       address payable gambler,
1351       bool exist
1352     ) 
1353   {
1354     SlotGameLib.Bet storage b = slot.bets[hostSeedHash];
1355     amount = b.amount;
1356     blockNumber = b.blockNumber;
1357     gambler = b.gambler;
1358     exist = b.exist;  
1359   }
1360 
1361   function slotSetReels(uint n, bytes calldata symbols) 
1362     external 
1363     onlyAdmin(AccessRank.Games) 
1364     slotBetsWasHandled 
1365   {
1366     slot.setReel(n, symbols);
1367   }
1368 
1369   function slotReels(uint n) external view returns (bytes memory) {
1370     return slot.reels[n];
1371   }
1372 
1373   function slotPayLine(uint n) external view returns (bytes memory symbols, uint num, uint den) {
1374     symbols = new bytes(slot.payTable[n].symbols.length);
1375     symbols = slot.payTable[n].symbols;
1376     num = slot.payTable[n].multiplier.num;
1377     den = slot.payTable[n].multiplier.den;
1378   }
1379 
1380   function slotSetPayLine(uint n, bytes calldata symbols, uint num, uint den) 
1381     external 
1382     onlyAdmin(AccessRank.Games) 
1383     slotBetsWasHandled 
1384   {
1385     slot.setPayLine(n, SlotGameLib.Combination(symbols, NumberLib.Number(num, den)));
1386   }
1387 
1388   function slotSpecialPayLine(uint n) external view returns (byte symbol, uint num, uint den, uint[] memory indexes) {
1389     indexes = new uint[](slot.specialPayTable[n].indexes.length);
1390     indexes = slot.specialPayTable[n].indexes;
1391     num = slot.specialPayTable[n].multiplier.num;
1392     den = slot.specialPayTable[n].multiplier.den;
1393     symbol = slot.specialPayTable[n].symbol;
1394   }
1395 
1396   function slotSetSpecialPayLine(
1397     uint n,
1398     byte symbol,
1399     uint num, 
1400     uint den, 
1401     uint[] calldata indexes
1402   ) 
1403     external 
1404     onlyAdmin(AccessRank.Games) 
1405     slotBetsWasHandled
1406   {
1407     SlotGameLib.SpecialCombination memory scomb = SlotGameLib.SpecialCombination(symbol, NumberLib.Number(num, den), indexes);
1408     slot.setSpecialPayLine(n, scomb);
1409   }
1410 
1411   function refundBet(Game game, bytes32 hostSeedHash) external {
1412     PaymentLib.Payment memory p; 
1413     p = game == Game.Slot ? slot.refundBet(hostSeedHash) : roll.refundBet(hostSeedHash);
1414     handlePayment(p);
1415   }
1416 
1417   function setSecretSigner(Game game, address secretSigner) external onlyAdmin(AccessRank.Games) {
1418     address otherSigner = game == Game.Roll ? slot.secretSigner : roll.secretSigner;
1419     require(secretSigner != otherSigner, "casino: slot and roll secret signers must be not equal");
1420     game == Game.Roll ? roll.secretSigner = secretSigner : slot.secretSigner = secretSigner;
1421   }
1422 
1423   function setMinMaxBetAmount(Game game, uint min, uint max) external onlyAdmin(AccessRank.Games) {
1424     game == Game.Roll ? roll.setMinMaxBetAmount(min, max) : slot.setMinMaxBetAmount(min, max);
1425   }
1426 
1427   function kill(address payable beneficiary) 
1428     external 
1429     onlyAdmin(AccessRank.Full) 
1430   {
1431     require(lockedInBets() == 0, "casino: all bets should be handled");
1432     selfdestruct(beneficiary);
1433   }
1434 
1435   function increaseJackpot(uint amount) external onlyAdmin(AccessRank.Games) {
1436     checkEnoughFundsForPay(amount);
1437     extraJackpot += amount;
1438     emit LogIncreaseJackpot(msg.sender, amount);
1439   }
1440 
1441   function setJackpotMagic(uint magic) external onlyAdmin(AccessRank.Games) {
1442     require(MIN_JACKPOT_MAGIC <= magic && magic <= MAX_JACKPOT_MAGIC, "casino: invalid jackpot magic");
1443     jackpotMagic = magic;
1444     emit LogJackpotMagicChanged(msg.sender, magic);
1445   }
1446 
1447   function withdraw(address payable beneficiary, uint amount) external onlyAdmin(AccessRank.Withdraw) {
1448     handlePayment(PaymentLib.Payment(beneficiary, amount, WITHDRAW_LOG_MSG));
1449   }
1450 
1451   function handleBet(Game game, bytes32 hostSeed, bytes32 clientSeed) external onlyAdmin(AccessRank.Croupier) {
1452     PaymentLib.Payment memory p; 
1453     p = game == Game.Slot ? slot.handleBet(hostSeed, clientSeed) : roll.handleBet(hostSeed, clientSeed);
1454     handlePayment(p);
1455     rollJackpot(p.beneficiary, hostSeed, clientSeed);
1456   }
1457 
1458   function handleBetWithProof(
1459     Game game,
1460     bytes32 hostSeed,
1461     uint canonicalBlockNumber,
1462     bytes memory uncleProof,
1463     bytes memory chainProof
1464   )
1465     public onlyAdmin(AccessRank.Croupier)
1466   {
1467     PaymentLib.Payment memory p;
1468     bytes32 clientSeed; 
1469     if (game == Game.Slot) {
1470       (p, clientSeed) = slot.handleBetWithProof(hostSeed, canonicalBlockNumber, uncleProof, chainProof);
1471     } else {
1472       (p, clientSeed) = roll.handleBetWithProof(hostSeed, canonicalBlockNumber, uncleProof, chainProof);
1473     }
1474     handlePayment(p);
1475     rollJackpot(p.beneficiary, hostSeed, clientSeed);
1476   }
1477 
1478   function lockedInBets() public view returns(uint) {
1479     return slot.lockedInBets + roll.lockedInBets;
1480   }
1481 
1482   function jackpot() public view returns(uint) {
1483     return slot.jackpot + roll.jackpot + extraJackpot;
1484   }
1485 
1486   function freeFunds() public view returns(uint) {
1487     if (lockedInBets() + jackpot() >= address(this).balance ) {
1488       return 0;
1489     }
1490     return address(this).balance - lockedInBets() - jackpot();
1491   }
1492 
1493   function rollJackpot(
1494     address payable beneficiary,
1495     bytes32 hostSeed,
1496     bytes32 clientSeed
1497   ) 
1498     private 
1499   {
1500     if (Rnd.uintn(hostSeed, clientSeed, jackpotMagic, JACKPOT_NONCE) != 0) {
1501       return;
1502     }
1503     PaymentLib.Payment memory p = PaymentLib.Payment(beneficiary, jackpot(), JACKPOT_LOG_MSG);
1504     handlePayment(p);
1505 
1506     delete slot.jackpot;
1507     delete roll.jackpot;
1508     delete extraJackpot;
1509     emit LogJactpot(p.beneficiary, p.amount, hostSeed, clientSeed, jackpotMagic);
1510   }
1511 
1512   function checkEnoughFundsForPay(uint amount) private view {
1513     require(freeFunds() >= amount, "casino: not enough funds");
1514   }
1515 
1516   function handlePayment(PaymentLib.Payment memory p) private {
1517     checkEnoughFundsForPay(p.amount);
1518     p.send();
1519   }
1520 }