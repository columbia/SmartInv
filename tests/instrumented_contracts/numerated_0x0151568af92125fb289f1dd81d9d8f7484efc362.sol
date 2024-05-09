1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         uint256 c = a + b;
27         if (c < a) return (false, 0);
28         return (true, c);
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         if (b > a) return (false, 0);
38         return (true, a - b);
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50         if (a == 0) return (true, 0);
51         uint256 c = a * b;
52         if (c / a != b) return (false, 0);
53         return (true, c);
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         if (b == 0) return (false, 0);
63         return (true, a / b);
64     }
65 
66     /**
67      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         if (b == 0) return (false, 0);
73         return (true, a % b);
74     }
75 
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      *
84      * - Addition cannot overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a, "SafeMath: subtraction overflow");
104         return a - b;
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      *
115      * - Multiplication cannot overflow.
116      */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) return 0;
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121         return c;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b > 0, "SafeMath: division by zero");
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b > 0, "SafeMath: modulo by zero");
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         return a - b;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * CAUTION: This function is deprecated because it requires allocating memory for the error
181      * message unnecessarily. For custom revert reasons use {tryDiv}.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         return a / b;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         return a % b;
214     }
215 }
216 
217 // File: contracts/AdminControlled.sol
218 
219 pragma solidity ^0.6;
220 
221 contract AdminControlled {
222     address public admin;
223     uint public paused;
224 
225     constructor(address _admin, uint flags) public {
226         admin = _admin;
227         paused = flags;
228     }
229 
230     modifier onlyAdmin {
231         require(msg.sender == admin);
232         _;
233     }
234 
235     modifier pausable(uint flag) {
236         require((paused & flag) == 0 || msg.sender == admin);
237         _;
238     }
239 
240     function adminPause(uint flags) public onlyAdmin {
241         paused = flags;
242     }
243 
244     function adminSstore(uint key, uint value) public onlyAdmin {
245         assembly {
246             sstore(key, value)
247         }
248     }
249 
250     function adminSstoreWithMask(
251         uint key,
252         uint value,
253         uint mask
254     ) public onlyAdmin {
255         assembly {
256             let oldval := sload(key)
257             sstore(key, xor(and(xor(value, oldval), mask), oldval))
258         }
259     }
260 
261     function adminSendEth(address payable destination, uint amount) public onlyAdmin {
262         destination.transfer(amount);
263     }
264 
265     function adminReceiveEth() public payable onlyAdmin {}
266 
267     function adminDelegatecall(address target, bytes memory data) public payable onlyAdmin returns (bytes memory) {
268         (bool success, bytes memory rdata) = target.delegatecall(data);
269         require(success);
270         return rdata;
271     }
272 }
273 
274 // File: contracts/INearBridge.sol
275 
276 pragma solidity ^0.6;
277 
278 interface INearBridge {
279     event BlockHashAdded(uint64 indexed height, bytes32 blockHash);
280 
281     event BlockHashReverted(uint64 indexed height, bytes32 blockHash);
282 
283     function blockHashes(uint64 blockNumber) external view returns (bytes32);
284 
285     function blockMerkleRoots(uint64 blockNumber) external view returns (bytes32);
286 
287     function balanceOf(address wallet) external view returns (uint256);
288 
289     function deposit() external payable;
290 
291     function withdraw() external;
292 
293     function initWithValidators(bytes calldata initialValidators) external;
294 
295     function initWithBlock(bytes calldata data) external;
296 
297     function addLightClientBlock(bytes calldata data) external;
298 
299     function challenge(address payable receiver, uint256 signatureIndex) external;
300 
301     function checkBlockProducerSignatureInHead(uint256 signatureIndex) external view returns (bool);
302 }
303 
304 // File: contracts/Utils.sol
305 
306 pragma solidity ^0.6;
307 
308 library Utils {
309     function swapBytes2(uint16 v) internal pure returns (uint16) {
310         return (v << 8) | (v >> 8);
311     }
312 
313     function swapBytes4(uint32 v) internal pure returns (uint32) {
314         v = ((v & 0x00ff00ff) << 8) | ((v & 0xff00ff00) >> 8);
315         return (v << 16) | (v >> 16);
316     }
317 
318     function swapBytes8(uint64 v) internal pure returns (uint64) {
319         v = ((v & 0x00ff00ff00ff00ff) << 8) | ((v & 0xff00ff00ff00ff00) >> 8);
320         v = ((v & 0x0000ffff0000ffff) << 16) | ((v & 0xffff0000ffff0000) >> 16);
321         return (v << 32) | (v >> 32);
322     }
323 
324     function swapBytes16(uint128 v) internal pure returns (uint128) {
325         v = ((v & 0x00ff00ff00ff00ff00ff00ff00ff00ff) << 8) | ((v & 0xff00ff00ff00ff00ff00ff00ff00ff00) >> 8);
326         v = ((v & 0x0000ffff0000ffff0000ffff0000ffff) << 16) | ((v & 0xffff0000ffff0000ffff0000ffff0000) >> 16);
327         v = ((v & 0x00000000ffffffff00000000ffffffff) << 32) | ((v & 0xffffffff00000000ffffffff00000000) >> 32);
328         return (v << 64) | (v >> 64);
329     }
330 
331     function swapBytes32(uint256 v) internal pure returns (uint256) {
332         v =
333             ((v & 0x00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff) << 8) |
334             ((v & 0xff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00) >> 8);
335         v =
336             ((v & 0x0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff) << 16) |
337             ((v & 0xffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000) >> 16);
338         v =
339             ((v & 0x00000000ffffffff00000000ffffffff00000000ffffffff00000000ffffffff) << 32) |
340             ((v & 0xffffffff00000000ffffffff00000000ffffffff00000000ffffffff00000000) >> 32);
341         v =
342             ((v & 0x0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff) << 64) |
343             ((v & 0xffffffffffffffff0000000000000000ffffffffffffffff0000000000000000) >> 64);
344         return (v << 128) | (v >> 128);
345     }
346 
347     function readMemory(uint ptr) internal pure returns (uint res) {
348         assembly {
349             res := mload(ptr)
350         }
351     }
352 
353     function writeMemory(uint ptr, uint value) internal pure {
354         assembly {
355             mstore(ptr, value)
356         }
357     }
358 
359     function memoryToBytes(uint ptr, uint length) internal pure returns (bytes memory res) {
360         if (length != 0) {
361             assembly {
362                 // 0x40 is the address of free memory pointer.
363                 res := mload(0x40)
364                 let end := add(
365                     res,
366                     and(add(length, 63), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0)
367                 )
368                 // end = res + 32 + 32 * ceil(length / 32).
369                 mstore(0x40, end)
370                 mstore(res, length)
371                 let destPtr := add(res, 32)
372                 // prettier-ignore
373                 for { } 1 { } {
374                     mstore(destPtr, mload(ptr))
375                     destPtr := add(destPtr, 32)
376                     if eq(destPtr, end) {
377                         break
378                     }
379                     ptr := add(ptr, 32)
380                 }
381             }
382         }
383     }
384 
385     function keccak256Raw(uint ptr, uint length) internal pure returns (bytes32 res) {
386         assembly {
387             res := keccak256(ptr, length)
388         }
389     }
390 
391     function sha256Raw(uint ptr, uint length) internal view returns (bytes32 res) {
392         assembly {
393             // 2 is the address of SHA256 precompiled contract.
394             // First 64 bytes of memory can be used as scratch space.
395             let ret := staticcall(gas(), 2, ptr, length, 0, 32)
396             // If the call to SHA256 precompile ran out of gas, burn any gas that remains.
397             // prettier-ignore
398             for { } iszero(ret) { } { }
399             res := mload(0)
400         }
401     }
402 }
403 
404 // File: contracts/Borsh.sol
405 
406 pragma solidity ^0.6;
407 
408 
409 library Borsh {
410     using Borsh for Data;
411 
412     struct Data {
413         uint ptr;
414         uint end;
415     }
416 
417     function from(bytes memory data) internal pure returns (Data memory res) {
418         uint ptr;
419         assembly {
420             ptr := data
421         }
422         res.ptr = ptr + 32;
423         res.end = res.ptr + Utils.readMemory(ptr);
424     }
425 
426     // This function assumes that length is reasonably small, so that data.ptr + length will not overflow. In the current code, length is always less than 2^32.
427     function requireSpace(Data memory data, uint length) internal pure {
428         require(data.ptr + length <= data.end, "Parse error: unexpected EOI");
429     }
430 
431     function read(Data memory data, uint length) internal pure returns (bytes32 res) {
432         data.requireSpace(length);
433         res = bytes32(Utils.readMemory(data.ptr));
434         data.ptr += length;
435         return res;
436     }
437 
438     function done(Data memory data) internal pure {
439         require(data.ptr == data.end, "Parse error: EOI expected");
440     }
441 
442     // Same considerations as for requireSpace.
443     function peekKeccak256(Data memory data, uint length) internal pure returns (bytes32) {
444         data.requireSpace(length);
445         return Utils.keccak256Raw(data.ptr, length);
446     }
447 
448     // Same considerations as for requireSpace.
449     function peekSha256(Data memory data, uint length) internal view returns (bytes32) {
450         data.requireSpace(length);
451         return Utils.sha256Raw(data.ptr, length);
452     }
453 
454     function decodeU8(Data memory data) internal pure returns (uint8) {
455         return uint8(bytes1(data.read(1)));
456     }
457 
458     function decodeU16(Data memory data) internal pure returns (uint16) {
459         return Utils.swapBytes2(uint16(bytes2(data.read(2))));
460     }
461 
462     function decodeU32(Data memory data) internal pure returns (uint32) {
463         return Utils.swapBytes4(uint32(bytes4(data.read(4))));
464     }
465 
466     function decodeU64(Data memory data) internal pure returns (uint64) {
467         return Utils.swapBytes8(uint64(bytes8(data.read(8))));
468     }
469 
470     function decodeU128(Data memory data) internal pure returns (uint128) {
471         return Utils.swapBytes16(uint128(bytes16(data.read(16))));
472     }
473 
474     function decodeU256(Data memory data) internal pure returns (uint256) {
475         return Utils.swapBytes32(uint256(data.read(32)));
476     }
477 
478     function decodeBytes20(Data memory data) internal pure returns (bytes20) {
479         return bytes20(data.read(20));
480     }
481 
482     function decodeBytes32(Data memory data) internal pure returns (bytes32) {
483         return data.read(32);
484     }
485 
486     function decodeBool(Data memory data) internal pure returns (bool) {
487         uint8 res = data.decodeU8();
488         require(res <= 1, "Parse error: invalid bool");
489         return res != 0;
490     }
491 
492     function skipBytes(Data memory data) internal pure {
493         uint length = data.decodeU32();
494         data.requireSpace(length);
495         data.ptr += length;
496     }
497 
498     function decodeBytes(Data memory data) internal pure returns (bytes memory res) {
499         uint length = data.decodeU32();
500         data.requireSpace(length);
501         res = Utils.memoryToBytes(data.ptr, length);
502         data.ptr += length;
503     }
504 }
505 
506 // File: contracts/NearDecoder.sol
507 
508 pragma solidity ^0.6;
509 
510 
511 library NearDecoder {
512     using Borsh for Borsh.Data;
513     using NearDecoder for Borsh.Data;
514 
515     struct PublicKey {
516         bytes32 k;
517     }
518 
519     function decodePublicKey(Borsh.Data memory data) internal pure returns (PublicKey memory res) {
520         require(data.decodeU8() == 0, "Parse error: invalid key type");
521         res.k = data.decodeBytes32();
522     }
523 
524     struct Signature {
525         bytes32 r;
526         bytes32 s;
527     }
528 
529     function decodeSignature(Borsh.Data memory data) internal pure returns (Signature memory res) {
530         require(data.decodeU8() == 0, "Parse error: invalid signature type");
531         res.r = data.decodeBytes32();
532         res.s = data.decodeBytes32();
533     }
534 
535     struct BlockProducer {
536         PublicKey publicKey;
537         uint128 stake;
538     }
539 
540     function decodeBlockProducer(Borsh.Data memory data) internal pure returns (BlockProducer memory res) {
541         data.skipBytes();
542         res.publicKey = data.decodePublicKey();
543         res.stake = data.decodeU128();
544     }
545 
546     function decodeBlockProducers(Borsh.Data memory data) internal pure returns (BlockProducer[] memory res) {
547         uint length = data.decodeU32();
548         res = new BlockProducer[](length);
549         for (uint i = 0; i < length; i++) {
550             res[i] = data.decodeBlockProducer();
551         }
552     }
553 
554     struct OptionalBlockProducers {
555         bool some;
556         BlockProducer[] blockProducers;
557         bytes32 hash; // Additional computable element
558     }
559 
560     function decodeOptionalBlockProducers(Borsh.Data memory data)
561         internal
562         view
563         returns (OptionalBlockProducers memory res)
564     {
565         res.some = data.decodeBool();
566         if (res.some) {
567             uint start = data.ptr;
568             res.blockProducers = data.decodeBlockProducers();
569             res.hash = Utils.sha256Raw(start, data.ptr - start);
570         }
571     }
572 
573     struct OptionalSignature {
574         bool some;
575         Signature signature;
576     }
577 
578     function decodeOptionalSignature(Borsh.Data memory data) internal pure returns (OptionalSignature memory res) {
579         res.some = data.decodeBool();
580         if (res.some) {
581             res.signature = data.decodeSignature();
582         }
583     }
584 
585     struct BlockHeaderInnerLite {
586         uint64 height; // Height of this block since the genesis block (height 0).
587         bytes32 epoch_id; // Epoch start hash of this block's epoch. Used for retrieving validator information
588         bytes32 next_epoch_id;
589         bytes32 prev_state_root; // Root hash of the state at the previous block.
590         bytes32 outcome_root; // Root of the outcomes of transactions and receipts.
591         uint64 timestamp; // Timestamp at which the block was built.
592         bytes32 next_bp_hash; // Hash of the next epoch block producers set
593         bytes32 block_merkle_root;
594         bytes32 hash; // Additional computable element
595     }
596 
597     function decodeBlockHeaderInnerLite(Borsh.Data memory data)
598         internal
599         view
600         returns (BlockHeaderInnerLite memory res)
601     {
602         res.hash = data.peekSha256(208);
603         res.height = data.decodeU64();
604         res.epoch_id = data.decodeBytes32();
605         res.next_epoch_id = data.decodeBytes32();
606         res.prev_state_root = data.decodeBytes32();
607         res.outcome_root = data.decodeBytes32();
608         res.timestamp = data.decodeU64();
609         res.next_bp_hash = data.decodeBytes32();
610         res.block_merkle_root = data.decodeBytes32();
611     }
612 
613     struct LightClientBlock {
614         bytes32 prev_block_hash;
615         bytes32 next_block_inner_hash;
616         BlockHeaderInnerLite inner_lite;
617         bytes32 inner_rest_hash;
618         OptionalBlockProducers next_bps;
619         OptionalSignature[] approvals_after_next;
620         bytes32 hash;
621         bytes32 next_hash;
622     }
623 
624     function decodeLightClientBlock(Borsh.Data memory data) internal view returns (LightClientBlock memory res) {
625         res.prev_block_hash = data.decodeBytes32();
626         res.next_block_inner_hash = data.decodeBytes32();
627         res.inner_lite = data.decodeBlockHeaderInnerLite();
628         res.inner_rest_hash = data.decodeBytes32();
629         res.next_bps = data.decodeOptionalBlockProducers();
630 
631         uint length = data.decodeU32();
632         res.approvals_after_next = new OptionalSignature[](length);
633         for (uint i = 0; i < length; i++) {
634             res.approvals_after_next[i] = data.decodeOptionalSignature();
635         }
636 
637         res.hash = sha256(
638             abi.encodePacked(sha256(abi.encodePacked(res.inner_lite.hash, res.inner_rest_hash)), res.prev_block_hash)
639         );
640 
641         res.next_hash = sha256(abi.encodePacked(res.next_block_inner_hash, res.hash));
642     }
643 }
644 
645 // File: contracts/Ed25519.sol
646 
647 pragma solidity ^0.6;
648 
649 contract Ed25519 {
650     // Computes (v^(2^250-1), v^11) mod p
651     function pow22501(uint256 v) private pure returns (uint256 p22501, uint256 p11) {
652         p11 = mulmod(v, v, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
653         p22501 = mulmod(p11, p11, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
654         p22501 = mulmod(
655             mulmod(p22501, p22501, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
656             v,
657             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
658         );
659         p11 = mulmod(p22501, p11, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
660         p22501 = mulmod(
661             mulmod(p11, p11, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
662             p22501,
663             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
664         );
665         uint256 a = mulmod(p22501, p22501, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
666         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
667         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
668         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
669         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
670         p22501 = mulmod(p22501, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
671         a = mulmod(p22501, p22501, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
672         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
673         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
674         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
675         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
676         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
677         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
678         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
679         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
680         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
681         a = mulmod(p22501, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
682         uint256 b = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
683         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
684         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
685         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
686         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
687         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
688         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
689         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
690         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
691         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
692         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
693         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
694         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
695         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
696         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
697         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
698         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
699         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
700         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
701         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
702         a = mulmod(a, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
703         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
704         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
705         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
706         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
707         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
708         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
709         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
710         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
711         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
712         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
713         p22501 = mulmod(p22501, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
714         a = mulmod(p22501, p22501, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
715         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
716         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
717         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
718         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
719         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
720         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
721         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
722         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
723         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
724         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
725         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
726         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
727         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
728         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
729         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
730         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
731         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
732         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
733         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
734         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
735         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
736         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
737         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
738         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
739         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
740         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
741         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
742         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
743         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
744         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
745         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
746         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
747         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
748         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
749         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
750         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
751         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
752         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
753         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
754         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
755         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
756         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
757         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
758         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
759         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
760         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
761         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
762         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
763         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
764         a = mulmod(p22501, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
765         b = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
766         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
767         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
768         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
769         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
770         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
771         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
772         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
773         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
774         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
775         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
776         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
777         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
778         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
779         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
780         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
781         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
782         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
783         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
784         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
785         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
786         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
787         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
788         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
789         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
790         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
791         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
792         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
793         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
794         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
795         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
796         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
797         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
798         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
799         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
800         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
801         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
802         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
803         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
804         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
805         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
806         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
807         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
808         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
809         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
810         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
811         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
812         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
813         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
814         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
815         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
816         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
817         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
818         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
819         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
820         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
821         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
822         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
823         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
824         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
825         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
826         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
827         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
828         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
829         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
830         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
831         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
832         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
833         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
834         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
835         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
836         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
837         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
838         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
839         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
840         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
841         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
842         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
843         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
844         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
845         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
846         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
847         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
848         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
849         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
850         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
851         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
852         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
853         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
854         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
855         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
856         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
857         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
858         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
859         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
860         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
861         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
862         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
863         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
864         b = mulmod(b, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
865         a = mulmod(a, b, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
866         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
867         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
868         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
869         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
870         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
871         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
872         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
873         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
874         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
875         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
876         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
877         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
878         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
879         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
880         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
881         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
882         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
883         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
884         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
885         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
886         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
887         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
888         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
889         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
890         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
891         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
892         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
893         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
894         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
895         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
896         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
897         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
898         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
899         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
900         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
901         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
902         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
903         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
904         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
905         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
906         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
907         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
908         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
909         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
910         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
911         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
912         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
913         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
914         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
915         a = mulmod(a, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
916         p22501 = mulmod(p22501, a, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
917     }
918 
919     function check(
920         bytes32 k,
921         bytes32 r,
922         bytes32 s,
923         bytes32 m1,
924         bytes9 m2
925     ) public pure returns (bool) {
926         uint256 hh;
927         // Step 1: compute SHA-512(R, A, M)
928         {
929             uint256[5][16] memory kk =
930                 [
931                     [
932                         uint256(0x428a2f98_d728ae22),
933                         uint256(0xe49b69c1_9ef14ad2),
934                         uint256(0x27b70a85_46d22ffc),
935                         uint256(0x19a4c116_b8d2d0c8),
936                         uint256(0xca273ece_ea26619c)
937                     ],
938                     [
939                         uint256(0x71374491_23ef65cd),
940                         uint256(0xefbe4786_384f25e3),
941                         uint256(0x2e1b2138_5c26c926),
942                         uint256(0x1e376c08_5141ab53),
943                         uint256(0xd186b8c7_21c0c207)
944                     ],
945                     [
946                         uint256(0xb5c0fbcf_ec4d3b2f),
947                         uint256(0xfc19dc6_8b8cd5b5),
948                         uint256(0x4d2c6dfc_5ac42aed),
949                         uint256(0x2748774c_df8eeb99),
950                         uint256(0xeada7dd6_cde0eb1e)
951                     ],
952                     [
953                         uint256(0xe9b5dba5_8189dbbc),
954                         uint256(0x240ca1cc_77ac9c65),
955                         uint256(0x53380d13_9d95b3df),
956                         uint256(0x34b0bcb5_e19b48a8),
957                         uint256(0xf57d4f7f_ee6ed178)
958                     ],
959                     [
960                         uint256(0x3956c25b_f348b538),
961                         uint256(0x2de92c6f_592b0275),
962                         uint256(0x650a7354_8baf63de),
963                         uint256(0x391c0cb3_c5c95a63),
964                         uint256(0x6f067aa_72176fba)
965                     ],
966                     [
967                         uint256(0x59f111f1_b605d019),
968                         uint256(0x4a7484aa_6ea6e483),
969                         uint256(0x766a0abb_3c77b2a8),
970                         uint256(0x4ed8aa4a_e3418acb),
971                         uint256(0xa637dc5_a2c898a6)
972                     ],
973                     [
974                         uint256(0x923f82a4_af194f9b),
975                         uint256(0x5cb0a9dc_bd41fbd4),
976                         uint256(0x81c2c92e_47edaee6),
977                         uint256(0x5b9cca4f_7763e373),
978                         uint256(0x113f9804_bef90dae)
979                     ],
980                     [
981                         uint256(0xab1c5ed5_da6d8118),
982                         uint256(0x76f988da_831153b5),
983                         uint256(0x92722c85_1482353b),
984                         uint256(0x682e6ff3_d6b2b8a3),
985                         uint256(0x1b710b35_131c471b)
986                     ],
987                     [
988                         uint256(0xd807aa98_a3030242),
989                         uint256(0x983e5152_ee66dfab),
990                         uint256(0xa2bfe8a1_4cf10364),
991                         uint256(0x748f82ee_5defb2fc),
992                         uint256(0x28db77f5_23047d84)
993                     ],
994                     [
995                         uint256(0x12835b01_45706fbe),
996                         uint256(0xa831c66d_2db43210),
997                         uint256(0xa81a664b_bc423001),
998                         uint256(0x78a5636f_43172f60),
999                         uint256(0x32caab7b_40c72493)
1000                     ],
1001                     [
1002                         uint256(0x243185be_4ee4b28c),
1003                         uint256(0xb00327c8_98fb213f),
1004                         uint256(0xc24b8b70_d0f89791),
1005                         uint256(0x84c87814_a1f0ab72),
1006                         uint256(0x3c9ebe0a_15c9bebc)
1007                     ],
1008                     [
1009                         uint256(0x550c7dc3_d5ffb4e2),
1010                         uint256(0xbf597fc7_beef0ee4),
1011                         uint256(0xc76c51a3_0654be30),
1012                         uint256(0x8cc70208_1a6439ec),
1013                         uint256(0x431d67c4_9c100d4c)
1014                     ],
1015                     [
1016                         uint256(0x72be5d74_f27b896f),
1017                         uint256(0xc6e00bf3_3da88fc2),
1018                         uint256(0xd192e819_d6ef5218),
1019                         uint256(0x90befffa_23631e28),
1020                         uint256(0x4cc5d4be_cb3e42b6)
1021                     ],
1022                     [
1023                         uint256(0x80deb1fe_3b1696b1),
1024                         uint256(0xd5a79147_930aa725),
1025                         uint256(0xd6990624_5565a910),
1026                         uint256(0xa4506ceb_de82bde9),
1027                         uint256(0x597f299c_fc657e2a)
1028                     ],
1029                     [
1030                         uint256(0x9bdc06a7_25c71235),
1031                         uint256(0x6ca6351_e003826f),
1032                         uint256(0xf40e3585_5771202a),
1033                         uint256(0xbef9a3f7_b2c67915),
1034                         uint256(0x5fcb6fab_3ad6faec)
1035                     ],
1036                     [
1037                         uint256(0xc19bf174_cf692694),
1038                         uint256(0x14292967_0a0e6e70),
1039                         uint256(0x106aa070_32bbd1b8),
1040                         uint256(0xc67178f2_e372532b),
1041                         uint256(0x6c44198c_4a475817)
1042                     ]
1043                 ];
1044             uint256 w0 =
1045                 (uint256(r) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000_ffffffff_ffffffff) |
1046                     ((uint256(r) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64) |
1047                     ((uint256(r) & 0xffffffff_ffffffff_00000000_00000000) << 64);
1048             uint256 w1 =
1049                 (uint256(k) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000_ffffffff_ffffffff) |
1050                     ((uint256(k) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64) |
1051                     ((uint256(k) & 0xffffffff_ffffffff_00000000_00000000) << 64);
1052             uint256 w2 =
1053                 (uint256(m1) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000_ffffffff_ffffffff) |
1054                     ((uint256(m1) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64) |
1055                     ((uint256(m1) & 0xffffffff_ffffffff_00000000_00000000) << 64);
1056             uint256 w3 =
1057                 (uint256(bytes32(m2)) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000_00000000_00000000) |
1058                     ((uint256(bytes32(m2)) & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64) |
1059                     0x800000_00000000_00000000_00000348;
1060             uint256 a = 0x6a09e667_f3bcc908;
1061             uint256 b = 0xbb67ae85_84caa73b;
1062             uint256 c = 0x3c6ef372_fe94f82b;
1063             uint256 d = 0xa54ff53a_5f1d36f1;
1064             uint256 e = 0x510e527f_ade682d1;
1065             uint256 f = 0x9b05688c_2b3e6c1f;
1066             uint256 g = 0x1f83d9ab_fb41bd6b;
1067             uint256 h = 0x5be0cd19_137e2179;
1068             for (uint256 i = 0; ; i++) {
1069                 // Round 16 * i
1070                 {
1071                     uint256 temp1;
1072                     uint256 temp2;
1073                     e &= 0xffffffff_ffffffff;
1074                     {
1075                         uint256 ss = e | (e << 64);
1076                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1077                         uint256 ch = (e & (f ^ g)) ^ g;
1078                         temp1 = h + s1 + ch;
1079                     }
1080                     temp1 += kk[0][i];
1081                     temp1 += w0 >> 192;
1082                     a &= 0xffffffff_ffffffff;
1083                     {
1084                         uint256 ss = a | (a << 64);
1085                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1086                         uint256 maj = (a & (b | c)) | (b & c);
1087                         temp2 = s0 + maj;
1088                     }
1089                     h = g;
1090                     g = f;
1091                     f = e;
1092                     e = d + temp1;
1093                     d = c;
1094                     c = b;
1095                     b = a;
1096                     a = temp1 + temp2;
1097                 }
1098                 // Round 16 * i + 1
1099                 {
1100                     uint256 temp1;
1101                     uint256 temp2;
1102                     e &= 0xffffffff_ffffffff;
1103                     {
1104                         uint256 ss = e | (e << 64);
1105                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1106                         uint256 ch = (e & (f ^ g)) ^ g;
1107                         temp1 = h + s1 + ch;
1108                     }
1109                     temp1 += kk[1][i];
1110                     temp1 += w0 >> 64;
1111                     a &= 0xffffffff_ffffffff;
1112                     {
1113                         uint256 ss = a | (a << 64);
1114                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1115                         uint256 maj = (a & (b | c)) | (b & c);
1116                         temp2 = s0 + maj;
1117                     }
1118                     h = g;
1119                     g = f;
1120                     f = e;
1121                     e = d + temp1;
1122                     d = c;
1123                     c = b;
1124                     b = a;
1125                     a = temp1 + temp2;
1126                 }
1127                 // Round 16 * i + 2
1128                 {
1129                     uint256 temp1;
1130                     uint256 temp2;
1131                     e &= 0xffffffff_ffffffff;
1132                     {
1133                         uint256 ss = e | (e << 64);
1134                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1135                         uint256 ch = (e & (f ^ g)) ^ g;
1136                         temp1 = h + s1 + ch;
1137                     }
1138                     temp1 += kk[2][i];
1139                     temp1 += w0 >> 128;
1140                     a &= 0xffffffff_ffffffff;
1141                     {
1142                         uint256 ss = a | (a << 64);
1143                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1144                         uint256 maj = (a & (b | c)) | (b & c);
1145                         temp2 = s0 + maj;
1146                     }
1147                     h = g;
1148                     g = f;
1149                     f = e;
1150                     e = d + temp1;
1151                     d = c;
1152                     c = b;
1153                     b = a;
1154                     a = temp1 + temp2;
1155                 }
1156                 // Round 16 * i + 3
1157                 {
1158                     uint256 temp1;
1159                     uint256 temp2;
1160                     e &= 0xffffffff_ffffffff;
1161                     {
1162                         uint256 ss = e | (e << 64);
1163                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1164                         uint256 ch = (e & (f ^ g)) ^ g;
1165                         temp1 = h + s1 + ch;
1166                     }
1167                     temp1 += kk[3][i];
1168                     temp1 += w0;
1169                     a &= 0xffffffff_ffffffff;
1170                     {
1171                         uint256 ss = a | (a << 64);
1172                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1173                         uint256 maj = (a & (b | c)) | (b & c);
1174                         temp2 = s0 + maj;
1175                     }
1176                     h = g;
1177                     g = f;
1178                     f = e;
1179                     e = d + temp1;
1180                     d = c;
1181                     c = b;
1182                     b = a;
1183                     a = temp1 + temp2;
1184                 }
1185                 // Round 16 * i + 4
1186                 {
1187                     uint256 temp1;
1188                     uint256 temp2;
1189                     e &= 0xffffffff_ffffffff;
1190                     {
1191                         uint256 ss = e | (e << 64);
1192                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1193                         uint256 ch = (e & (f ^ g)) ^ g;
1194                         temp1 = h + s1 + ch;
1195                     }
1196                     temp1 += kk[4][i];
1197                     temp1 += w1 >> 192;
1198                     a &= 0xffffffff_ffffffff;
1199                     {
1200                         uint256 ss = a | (a << 64);
1201                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1202                         uint256 maj = (a & (b | c)) | (b & c);
1203                         temp2 = s0 + maj;
1204                     }
1205                     h = g;
1206                     g = f;
1207                     f = e;
1208                     e = d + temp1;
1209                     d = c;
1210                     c = b;
1211                     b = a;
1212                     a = temp1 + temp2;
1213                 }
1214                 // Round 16 * i + 5
1215                 {
1216                     uint256 temp1;
1217                     uint256 temp2;
1218                     e &= 0xffffffff_ffffffff;
1219                     {
1220                         uint256 ss = e | (e << 64);
1221                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1222                         uint256 ch = (e & (f ^ g)) ^ g;
1223                         temp1 = h + s1 + ch;
1224                     }
1225                     temp1 += kk[5][i];
1226                     temp1 += w1 >> 64;
1227                     a &= 0xffffffff_ffffffff;
1228                     {
1229                         uint256 ss = a | (a << 64);
1230                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1231                         uint256 maj = (a & (b | c)) | (b & c);
1232                         temp2 = s0 + maj;
1233                     }
1234                     h = g;
1235                     g = f;
1236                     f = e;
1237                     e = d + temp1;
1238                     d = c;
1239                     c = b;
1240                     b = a;
1241                     a = temp1 + temp2;
1242                 }
1243                 // Round 16 * i + 6
1244                 {
1245                     uint256 temp1;
1246                     uint256 temp2;
1247                     e &= 0xffffffff_ffffffff;
1248                     {
1249                         uint256 ss = e | (e << 64);
1250                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1251                         uint256 ch = (e & (f ^ g)) ^ g;
1252                         temp1 = h + s1 + ch;
1253                     }
1254                     temp1 += kk[6][i];
1255                     temp1 += w1 >> 128;
1256                     a &= 0xffffffff_ffffffff;
1257                     {
1258                         uint256 ss = a | (a << 64);
1259                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1260                         uint256 maj = (a & (b | c)) | (b & c);
1261                         temp2 = s0 + maj;
1262                     }
1263                     h = g;
1264                     g = f;
1265                     f = e;
1266                     e = d + temp1;
1267                     d = c;
1268                     c = b;
1269                     b = a;
1270                     a = temp1 + temp2;
1271                 }
1272                 // Round 16 * i + 7
1273                 {
1274                     uint256 temp1;
1275                     uint256 temp2;
1276                     e &= 0xffffffff_ffffffff;
1277                     {
1278                         uint256 ss = e | (e << 64);
1279                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1280                         uint256 ch = (e & (f ^ g)) ^ g;
1281                         temp1 = h + s1 + ch;
1282                     }
1283                     temp1 += kk[7][i];
1284                     temp1 += w1;
1285                     a &= 0xffffffff_ffffffff;
1286                     {
1287                         uint256 ss = a | (a << 64);
1288                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1289                         uint256 maj = (a & (b | c)) | (b & c);
1290                         temp2 = s0 + maj;
1291                     }
1292                     h = g;
1293                     g = f;
1294                     f = e;
1295                     e = d + temp1;
1296                     d = c;
1297                     c = b;
1298                     b = a;
1299                     a = temp1 + temp2;
1300                 }
1301                 // Round 16 * i + 8
1302                 {
1303                     uint256 temp1;
1304                     uint256 temp2;
1305                     e &= 0xffffffff_ffffffff;
1306                     {
1307                         uint256 ss = e | (e << 64);
1308                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1309                         uint256 ch = (e & (f ^ g)) ^ g;
1310                         temp1 = h + s1 + ch;
1311                     }
1312                     temp1 += kk[8][i];
1313                     temp1 += w2 >> 192;
1314                     a &= 0xffffffff_ffffffff;
1315                     {
1316                         uint256 ss = a | (a << 64);
1317                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1318                         uint256 maj = (a & (b | c)) | (b & c);
1319                         temp2 = s0 + maj;
1320                     }
1321                     h = g;
1322                     g = f;
1323                     f = e;
1324                     e = d + temp1;
1325                     d = c;
1326                     c = b;
1327                     b = a;
1328                     a = temp1 + temp2;
1329                 }
1330                 // Round 16 * i + 9
1331                 {
1332                     uint256 temp1;
1333                     uint256 temp2;
1334                     e &= 0xffffffff_ffffffff;
1335                     {
1336                         uint256 ss = e | (e << 64);
1337                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1338                         uint256 ch = (e & (f ^ g)) ^ g;
1339                         temp1 = h + s1 + ch;
1340                     }
1341                     temp1 += kk[9][i];
1342                     temp1 += w2 >> 64;
1343                     a &= 0xffffffff_ffffffff;
1344                     {
1345                         uint256 ss = a | (a << 64);
1346                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1347                         uint256 maj = (a & (b | c)) | (b & c);
1348                         temp2 = s0 + maj;
1349                     }
1350                     h = g;
1351                     g = f;
1352                     f = e;
1353                     e = d + temp1;
1354                     d = c;
1355                     c = b;
1356                     b = a;
1357                     a = temp1 + temp2;
1358                 }
1359                 // Round 16 * i + 10
1360                 {
1361                     uint256 temp1;
1362                     uint256 temp2;
1363                     e &= 0xffffffff_ffffffff;
1364                     {
1365                         uint256 ss = e | (e << 64);
1366                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1367                         uint256 ch = (e & (f ^ g)) ^ g;
1368                         temp1 = h + s1 + ch;
1369                     }
1370                     temp1 += kk[10][i];
1371                     temp1 += w2 >> 128;
1372                     a &= 0xffffffff_ffffffff;
1373                     {
1374                         uint256 ss = a | (a << 64);
1375                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1376                         uint256 maj = (a & (b | c)) | (b & c);
1377                         temp2 = s0 + maj;
1378                     }
1379                     h = g;
1380                     g = f;
1381                     f = e;
1382                     e = d + temp1;
1383                     d = c;
1384                     c = b;
1385                     b = a;
1386                     a = temp1 + temp2;
1387                 }
1388                 // Round 16 * i + 11
1389                 {
1390                     uint256 temp1;
1391                     uint256 temp2;
1392                     e &= 0xffffffff_ffffffff;
1393                     {
1394                         uint256 ss = e | (e << 64);
1395                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1396                         uint256 ch = (e & (f ^ g)) ^ g;
1397                         temp1 = h + s1 + ch;
1398                     }
1399                     temp1 += kk[11][i];
1400                     temp1 += w2;
1401                     a &= 0xffffffff_ffffffff;
1402                     {
1403                         uint256 ss = a | (a << 64);
1404                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1405                         uint256 maj = (a & (b | c)) | (b & c);
1406                         temp2 = s0 + maj;
1407                     }
1408                     h = g;
1409                     g = f;
1410                     f = e;
1411                     e = d + temp1;
1412                     d = c;
1413                     c = b;
1414                     b = a;
1415                     a = temp1 + temp2;
1416                 }
1417                 // Round 16 * i + 12
1418                 {
1419                     uint256 temp1;
1420                     uint256 temp2;
1421                     e &= 0xffffffff_ffffffff;
1422                     {
1423                         uint256 ss = e | (e << 64);
1424                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1425                         uint256 ch = (e & (f ^ g)) ^ g;
1426                         temp1 = h + s1 + ch;
1427                     }
1428                     temp1 += kk[12][i];
1429                     temp1 += w3 >> 192;
1430                     a &= 0xffffffff_ffffffff;
1431                     {
1432                         uint256 ss = a | (a << 64);
1433                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1434                         uint256 maj = (a & (b | c)) | (b & c);
1435                         temp2 = s0 + maj;
1436                     }
1437                     h = g;
1438                     g = f;
1439                     f = e;
1440                     e = d + temp1;
1441                     d = c;
1442                     c = b;
1443                     b = a;
1444                     a = temp1 + temp2;
1445                 }
1446                 // Round 16 * i + 13
1447                 {
1448                     uint256 temp1;
1449                     uint256 temp2;
1450                     e &= 0xffffffff_ffffffff;
1451                     {
1452                         uint256 ss = e | (e << 64);
1453                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1454                         uint256 ch = (e & (f ^ g)) ^ g;
1455                         temp1 = h + s1 + ch;
1456                     }
1457                     temp1 += kk[13][i];
1458                     temp1 += w3 >> 64;
1459                     a &= 0xffffffff_ffffffff;
1460                     {
1461                         uint256 ss = a | (a << 64);
1462                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1463                         uint256 maj = (a & (b | c)) | (b & c);
1464                         temp2 = s0 + maj;
1465                     }
1466                     h = g;
1467                     g = f;
1468                     f = e;
1469                     e = d + temp1;
1470                     d = c;
1471                     c = b;
1472                     b = a;
1473                     a = temp1 + temp2;
1474                 }
1475                 // Round 16 * i + 14
1476                 {
1477                     uint256 temp1;
1478                     uint256 temp2;
1479                     e &= 0xffffffff_ffffffff;
1480                     {
1481                         uint256 ss = e | (e << 64);
1482                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1483                         uint256 ch = (e & (f ^ g)) ^ g;
1484                         temp1 = h + s1 + ch;
1485                     }
1486                     temp1 += kk[14][i];
1487                     temp1 += w3 >> 128;
1488                     a &= 0xffffffff_ffffffff;
1489                     {
1490                         uint256 ss = a | (a << 64);
1491                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1492                         uint256 maj = (a & (b | c)) | (b & c);
1493                         temp2 = s0 + maj;
1494                     }
1495                     h = g;
1496                     g = f;
1497                     f = e;
1498                     e = d + temp1;
1499                     d = c;
1500                     c = b;
1501                     b = a;
1502                     a = temp1 + temp2;
1503                 }
1504                 // Round 16 * i + 15
1505                 {
1506                     uint256 temp1;
1507                     uint256 temp2;
1508                     e &= 0xffffffff_ffffffff;
1509                     {
1510                         uint256 ss = e | (e << 64);
1511                         uint256 s1 = (ss >> 14) ^ (ss >> 18) ^ (ss >> 41);
1512                         uint256 ch = (e & (f ^ g)) ^ g;
1513                         temp1 = h + s1 + ch;
1514                     }
1515                     temp1 += kk[15][i];
1516                     temp1 += w3;
1517                     a &= 0xffffffff_ffffffff;
1518                     {
1519                         uint256 ss = a | (a << 64);
1520                         uint256 s0 = (ss >> 28) ^ (ss >> 34) ^ (ss >> 39);
1521                         uint256 maj = (a & (b | c)) | (b & c);
1522                         temp2 = s0 + maj;
1523                     }
1524                     h = g;
1525                     g = f;
1526                     f = e;
1527                     e = d + temp1;
1528                     d = c;
1529                     c = b;
1530                     b = a;
1531                     a = temp1 + temp2;
1532                 }
1533                 if (i == 4) {
1534                     break;
1535                 }
1536                 // Message expansion
1537                 uint256 t0 = w0;
1538                 uint256 t1 = w1;
1539                 {
1540                     uint256 t2 = w2;
1541                     uint256 t3 = w3;
1542                     {
1543                         uint256 n1 = t0 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1544                         n1 +=
1545                             ((t2 & 0xffffffff_ffffffff_00000000_00000000) << 128) |
1546                             ((t2 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64);
1547                         {
1548                             uint256 u1 =
1549                                 ((t0 & 0xffffffff_ffffffff_00000000_00000000) << 64) |
1550                                     ((t0 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 128);
1551                             uint256 uu1 = u1 | (u1 << 64);
1552                             n1 +=
1553                                 ((uu1 << 63) ^ (uu1 << 56) ^ (u1 << 57)) &
1554                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1555                         }
1556                         {
1557                             uint256 v1 = t3 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1558                             uint256 vv1 = v1 | (v1 << 64);
1559                             n1 +=
1560                                 ((vv1 << 45) ^ (vv1 << 3) ^ (v1 << 58)) &
1561                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1562                         }
1563                         n1 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1564                         uint256 n2 = t0 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1565                         n2 += ((t2 & 0xffffffff_ffffffff) << 128) | (t3 >> 192);
1566                         {
1567                             uint256 u2 = ((t0 & 0xffffffff_ffffffff) << 128) | (t1 >> 192);
1568                             uint256 uu2 = u2 | (u2 << 64);
1569                             n2 +=
1570                                 ((uu2 >> 1) ^ (uu2 >> 8) ^ (u2 >> 7)) &
1571                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1572                         }
1573                         {
1574                             uint256 vv2 = n1 | (n1 >> 64);
1575                             n2 +=
1576                                 ((vv2 >> 19) ^ (vv2 >> 61) ^ (n1 >> 70)) &
1577                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1578                         }
1579                         n2 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1580                         t0 = n1 | n2;
1581                     }
1582                     {
1583                         uint256 n1 = t1 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1584                         n1 +=
1585                             ((t3 & 0xffffffff_ffffffff_00000000_00000000) << 128) |
1586                             ((t3 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64);
1587                         {
1588                             uint256 u1 =
1589                                 ((t1 & 0xffffffff_ffffffff_00000000_00000000) << 64) |
1590                                     ((t1 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 128);
1591                             uint256 uu1 = u1 | (u1 << 64);
1592                             n1 +=
1593                                 ((uu1 << 63) ^ (uu1 << 56) ^ (u1 << 57)) &
1594                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1595                         }
1596                         {
1597                             uint256 v1 = t0 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1598                             uint256 vv1 = v1 | (v1 << 64);
1599                             n1 +=
1600                                 ((vv1 << 45) ^ (vv1 << 3) ^ (v1 << 58)) &
1601                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1602                         }
1603                         n1 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1604                         uint256 n2 = t1 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1605                         n2 += ((t3 & 0xffffffff_ffffffff) << 128) | (t0 >> 192);
1606                         {
1607                             uint256 u2 = ((t1 & 0xffffffff_ffffffff) << 128) | (t2 >> 192);
1608                             uint256 uu2 = u2 | (u2 << 64);
1609                             n2 +=
1610                                 ((uu2 >> 1) ^ (uu2 >> 8) ^ (u2 >> 7)) &
1611                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1612                         }
1613                         {
1614                             uint256 vv2 = n1 | (n1 >> 64);
1615                             n2 +=
1616                                 ((vv2 >> 19) ^ (vv2 >> 61) ^ (n1 >> 70)) &
1617                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1618                         }
1619                         n2 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1620                         t1 = n1 | n2;
1621                     }
1622                     {
1623                         uint256 n1 = t2 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1624                         n1 +=
1625                             ((t0 & 0xffffffff_ffffffff_00000000_00000000) << 128) |
1626                             ((t0 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64);
1627                         {
1628                             uint256 u1 =
1629                                 ((t2 & 0xffffffff_ffffffff_00000000_00000000) << 64) |
1630                                     ((t2 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 128);
1631                             uint256 uu1 = u1 | (u1 << 64);
1632                             n1 +=
1633                                 ((uu1 << 63) ^ (uu1 << 56) ^ (u1 << 57)) &
1634                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1635                         }
1636                         {
1637                             uint256 v1 = t1 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1638                             uint256 vv1 = v1 | (v1 << 64);
1639                             n1 +=
1640                                 ((vv1 << 45) ^ (vv1 << 3) ^ (v1 << 58)) &
1641                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1642                         }
1643                         n1 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1644                         uint256 n2 = t2 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1645                         n2 += ((t0 & 0xffffffff_ffffffff) << 128) | (t1 >> 192);
1646                         {
1647                             uint256 u2 = ((t2 & 0xffffffff_ffffffff) << 128) | (t3 >> 192);
1648                             uint256 uu2 = u2 | (u2 << 64);
1649                             n2 +=
1650                                 ((uu2 >> 1) ^ (uu2 >> 8) ^ (u2 >> 7)) &
1651                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1652                         }
1653                         {
1654                             uint256 vv2 = n1 | (n1 >> 64);
1655                             n2 +=
1656                                 ((vv2 >> 19) ^ (vv2 >> 61) ^ (n1 >> 70)) &
1657                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1658                         }
1659                         n2 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1660                         t2 = n1 | n2;
1661                     }
1662                     {
1663                         uint256 n1 = t3 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1664                         n1 +=
1665                             ((t1 & 0xffffffff_ffffffff_00000000_00000000) << 128) |
1666                             ((t1 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 64);
1667                         {
1668                             uint256 u1 =
1669                                 ((t3 & 0xffffffff_ffffffff_00000000_00000000) << 64) |
1670                                     ((t3 & 0xffffffff_ffffffff_00000000_00000000_00000000_00000000) >> 128);
1671                             uint256 uu1 = u1 | (u1 << 64);
1672                             n1 +=
1673                                 ((uu1 << 63) ^ (uu1 << 56) ^ (u1 << 57)) &
1674                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1675                         }
1676                         {
1677                             uint256 v1 = t2 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1678                             uint256 vv1 = v1 | (v1 << 64);
1679                             n1 +=
1680                                 ((vv1 << 45) ^ (vv1 << 3) ^ (v1 << 58)) &
1681                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1682                         }
1683                         n1 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000;
1684                         uint256 n2 = t3 & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1685                         n2 += ((t1 & 0xffffffff_ffffffff) << 128) | (t2 >> 192);
1686                         {
1687                             uint256 u2 = ((t3 & 0xffffffff_ffffffff) << 128) | (t0 >> 192);
1688                             uint256 uu2 = u2 | (u2 << 64);
1689                             n2 +=
1690                                 ((uu2 >> 1) ^ (uu2 >> 8) ^ (u2 >> 7)) &
1691                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1692                         }
1693                         {
1694                             uint256 vv2 = n1 | (n1 >> 64);
1695                             n2 +=
1696                                 ((vv2 >> 19) ^ (vv2 >> 61) ^ (n1 >> 70)) &
1697                                 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1698                         }
1699                         n2 &= 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff;
1700                         t3 = n1 | n2;
1701                     }
1702                     w3 = t3;
1703                     w2 = t2;
1704                 }
1705                 w1 = t1;
1706                 w0 = t0;
1707             }
1708             uint256 h0 =
1709                 ((a + 0x6a09e667_f3bcc908) & 0xffffffff_ffffffff) |
1710                     (((b + 0xbb67ae85_84caa73b) & 0xffffffff_ffffffff) << 64) |
1711                     (((c + 0x3c6ef372_fe94f82b) & 0xffffffff_ffffffff) << 128) |
1712                     ((d + 0xa54ff53a_5f1d36f1) << 192);
1713             h0 =
1714                 ((h0 & 0xff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff) << 8) |
1715                 ((h0 & 0xff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00) >> 8);
1716             h0 =
1717                 ((h0 & 0xffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff) << 16) |
1718                 ((h0 & 0xffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000) >> 16);
1719             h0 =
1720                 ((h0 & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff) << 32) |
1721                 ((h0 & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff_00000000) >> 32);
1722             uint256 h1 =
1723                 ((e + 0x510e527f_ade682d1) & 0xffffffff_ffffffff) |
1724                     (((f + 0x9b05688c_2b3e6c1f) & 0xffffffff_ffffffff) << 64) |
1725                     (((g + 0x1f83d9ab_fb41bd6b) & 0xffffffff_ffffffff) << 128) |
1726                     ((h + 0x5be0cd19_137e2179) << 192);
1727             h1 =
1728                 ((h1 & 0xff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff) << 8) |
1729                 ((h1 & 0xff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00) >> 8);
1730             h1 =
1731                 ((h1 & 0xffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff) << 16) |
1732                 ((h1 & 0xffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000) >> 16);
1733             h1 =
1734                 ((h1 & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff) << 32) |
1735                 ((h1 & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff_00000000) >> 32);
1736             hh = addmod(
1737                 h0,
1738                 mulmod(
1739                     h1,
1740                     0xfffffff_ffffffff_ffffffff_fffffffe_c6ef5bf4_737dcf70_d6ec3174_8d98951d,
1741                     0x10000000_00000000_00000000_00000000_14def9de_a2f79cd6_5812631a_5cf5d3ed
1742                 ),
1743                 0x10000000_00000000_00000000_00000000_14def9de_a2f79cd6_5812631a_5cf5d3ed
1744             );
1745         }
1746         // Step 2: unpack k
1747         k = bytes32(
1748             ((uint256(k) & 0xff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff) << 8) |
1749                 ((uint256(k) & 0xff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00) >> 8)
1750         );
1751         k = bytes32(
1752             ((uint256(k) & 0xffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff) << 16) |
1753                 ((uint256(k) & 0xffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000) >> 16)
1754         );
1755         k = bytes32(
1756             ((uint256(k) & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff) << 32) |
1757                 ((uint256(k) & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff_00000000) >> 32)
1758         );
1759         k = bytes32(
1760             ((uint256(k) & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff) << 64) |
1761                 ((uint256(k) & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000) >> 64)
1762         );
1763         k = bytes32((uint256(k) << 128) | (uint256(k) >> 128));
1764         uint256 ky = uint256(k) & 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff;
1765         uint256 kx;
1766         {
1767             uint256 ky2 = mulmod(ky, ky, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1768             uint256 u =
1769                 addmod(
1770                     ky2,
1771                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffec,
1772                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1773                 );
1774             uint256 v =
1775                 mulmod(
1776                     ky2,
1777                     0x52036cee_2b6ffe73_8cc74079_7779e898_00700a4d_4141d8ab_75eb4dca_135978a3,
1778                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1779                 ) + 1;
1780             uint256 t = mulmod(u, v, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1781             (kx, ) = pow22501(t);
1782             kx = mulmod(kx, kx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1783             kx = mulmod(
1784                 u,
1785                 mulmod(
1786                     mulmod(kx, kx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
1787                     t,
1788                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1789                 ),
1790                 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1791             );
1792             t = mulmod(
1793                 mulmod(kx, kx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
1794                 v,
1795                 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1796             );
1797             if (t != u) {
1798                 if (t != 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed - u) {
1799                     return false;
1800                 }
1801                 kx = mulmod(
1802                     kx,
1803                     0x2b832480_4fc1df0b_2b4d0099_3dfbd7a7_2f431806_ad2fe478_c4ee1b27_4a0ea0b0,
1804                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1805                 );
1806             }
1807         }
1808         if ((kx & 1) != uint256(k) >> 255) {
1809             kx = 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed - kx;
1810         }
1811         // Verify s
1812         s = bytes32(
1813             ((uint256(s) & 0xff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff) << 8) |
1814                 ((uint256(s) & 0xff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00) >> 8)
1815         );
1816         s = bytes32(
1817             ((uint256(s) & 0xffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff) << 16) |
1818                 ((uint256(s) & 0xffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000) >> 16)
1819         );
1820         s = bytes32(
1821             ((uint256(s) & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff) << 32) |
1822                 ((uint256(s) & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff_00000000) >> 32)
1823         );
1824         s = bytes32(
1825             ((uint256(s) & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff) << 64) |
1826                 ((uint256(s) & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000) >> 64)
1827         );
1828         s = bytes32((uint256(s) << 128) | (uint256(s) >> 128));
1829         if (uint256(s) >= 0x10000000_00000000_00000000_00000000_14def9de_a2f79cd6_5812631a_5cf5d3ed) {
1830             return false;
1831         }
1832         uint256 vx;
1833         uint256 vu;
1834         uint256 vy;
1835         uint256 vv;
1836         // Step 3: compute multiples of k
1837         uint256[8][3][2] memory tables;
1838         {
1839             uint256 ks = ky + kx;
1840             uint256 kd = ky + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed - kx;
1841             uint256 k2dt =
1842                 mulmod(
1843                     mulmod(kx, ky, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
1844                     0x2406d9dc_56dffce7_198e80f2_eef3d130_00e0149a_8283b156_ebd69b94_26b2f159,
1845                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1846                 );
1847             uint256 kky = ky;
1848             uint256 kkx = kx;
1849             uint256 kku = 1;
1850             uint256 kkv = 1;
1851             {
1852                 uint256 xx =
1853                     mulmod(kkx, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1854                 uint256 yy =
1855                     mulmod(kky, kku, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1856                 uint256 zz =
1857                     mulmod(kku, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1858                 uint256 xx2 = mulmod(xx, xx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1859                 uint256 yy2 = mulmod(yy, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1860                 uint256 xxyy =
1861                     mulmod(xx, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1862                 uint256 zz2 = mulmod(zz, zz, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1863                 kkx = xxyy + xxyy;
1864                 kku = yy2 - xx2 + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
1865                 kky = xx2 + yy2;
1866                 kkv = addmod(
1867                     zz2 + zz2,
1868                     0xffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffda - kku,
1869                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1870                 );
1871             }
1872             {
1873                 uint256 xx =
1874                     mulmod(kkx, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1875                 uint256 yy =
1876                     mulmod(kky, kku, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1877                 uint256 zz =
1878                     mulmod(kku, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1879                 uint256 xx2 = mulmod(xx, xx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1880                 uint256 yy2 = mulmod(yy, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1881                 uint256 xxyy =
1882                     mulmod(xx, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1883                 uint256 zz2 = mulmod(zz, zz, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1884                 kkx = xxyy + xxyy;
1885                 kku = yy2 - xx2 + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
1886                 kky = xx2 + yy2;
1887                 kkv = addmod(
1888                     zz2 + zz2,
1889                     0xffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffda - kku,
1890                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1891                 );
1892             }
1893             {
1894                 uint256 xx =
1895                     mulmod(kkx, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1896                 uint256 yy =
1897                     mulmod(kky, kku, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1898                 uint256 zz =
1899                     mulmod(kku, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1900                 uint256 xx2 = mulmod(xx, xx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1901                 uint256 yy2 = mulmod(yy, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1902                 uint256 xxyy =
1903                     mulmod(xx, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1904                 uint256 zz2 = mulmod(zz, zz, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1905                 kkx = xxyy + xxyy;
1906                 kku = yy2 - xx2 + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
1907                 kky = xx2 + yy2;
1908                 kkv = addmod(
1909                     zz2 + zz2,
1910                     0xffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffda - kku,
1911                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1912                 );
1913             }
1914             uint256 cprod = 1;
1915             uint256[8][3][2] memory tables_ = tables;
1916             for (uint256 i = 0; ; i++) {
1917                 uint256 cs;
1918                 uint256 cd;
1919                 uint256 ct;
1920                 uint256 c2z;
1921                 {
1922                     uint256 cx =
1923                         mulmod(kkx, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1924                     uint256 cy =
1925                         mulmod(kky, kku, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1926                     uint256 cz =
1927                         mulmod(kku, kkv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1928                     ct = mulmod(kkx, kky, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1929                     cs = cy + cx;
1930                     cd = cy - cx + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
1931                     c2z = cz + cz;
1932                 }
1933                 tables_[1][0][i] = cs;
1934                 tables_[1][1][i] = cd;
1935                 tables_[1][2][i] = mulmod(
1936                     ct,
1937                     0x2406d9dc_56dffce7_198e80f2_eef3d130_00e0149a_8283b156_ebd69b94_26b2f159,
1938                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1939                 );
1940                 tables_[0][0][i] = c2z;
1941                 tables_[0][1][i] = cprod;
1942                 cprod = mulmod(cprod, c2z, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1943                 if (i == 7) {
1944                     break;
1945                 }
1946                 uint256 ab = mulmod(cs, ks, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1947                 uint256 aa = mulmod(cd, kd, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1948                 uint256 ac =
1949                     mulmod(ct, k2dt, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1950                 kkx = ab - aa + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
1951                 kku = addmod(c2z, ac, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1952                 kky = ab + aa;
1953                 kkv = addmod(
1954                     c2z,
1955                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed - ac,
1956                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1957                 );
1958             }
1959             uint256 t;
1960             (cprod, t) = pow22501(cprod);
1961             cprod = mulmod(cprod, cprod, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1962             cprod = mulmod(cprod, cprod, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1963             cprod = mulmod(cprod, cprod, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1964             cprod = mulmod(cprod, cprod, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1965             cprod = mulmod(cprod, cprod, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1966             cprod = mulmod(cprod, t, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
1967             for (uint256 i = 7; ; i--) {
1968                 uint256 cinv =
1969                     mulmod(
1970                         cprod,
1971                         tables_[0][1][i],
1972                         0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1973                     );
1974                 tables_[1][0][i] = mulmod(
1975                     tables_[1][0][i],
1976                     cinv,
1977                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1978                 );
1979                 tables_[1][1][i] = mulmod(
1980                     tables_[1][1][i],
1981                     cinv,
1982                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1983                 );
1984                 tables_[1][2][i] = mulmod(
1985                     tables_[1][2][i],
1986                     cinv,
1987                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1988                 );
1989                 if (i == 0) {
1990                     break;
1991                 }
1992                 cprod = mulmod(
1993                     cprod,
1994                     tables_[0][0][i],
1995                     0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
1996                 );
1997             }
1998             tables_[0] = [
1999                 [
2000                     0x43e7ce9d_19ea5d32_9385a44c_321ea161_67c996e3_7dc6070c_97de49e3_7ac61db9,
2001                     0x40cff344_25d8ec30_a3bb74ba_58cd5854_fa1e3818_6ad0d31e_bc8ae251_ceb2c97e,
2002                     0x459bd270_46e8dd45_aea7008d_b87a5a8f_79067792_53d64523_58951859_9fdfbf4b,
2003                     0x69fdd1e2_8c23cc38_94d0c8ff_90e76f6d_5b6e4c2e_620136d0_4dd83c4a_51581ab9,
2004                     0x54dceb34_13ce5cfa_11196dfc_960b6eda_f4b380c6_d4d23784_19cc0279_ba49c5f3,
2005                     0x4e24184d_d71a3d77_eef3729f_7f8cf7c1_7224cf40_aa7b9548_b9942f3c_5084ceed,
2006                     0x5a0e5aab_20262674_ae117576_1cbf5e88_9b52a55f_d7ac5027_c228cebd_c8d2360a,
2007                     0x26239334_073e9b38_c6285955_6d451c3d_cc8d30e8_4b361174_f488eadd_e2cf17d9
2008                 ],
2009                 [
2010                     0x227e97c9_4c7c0933_d2e0c21a_3447c504_fe9ccf82_e8a05f59_ce881c82_eba0489f,
2011                     0x226a3e0e_cc4afec6_fd0d2884_13014a9d_bddecf06_c1a2f0bb_702ba77c_613d8209,
2012                     0x34d7efc8_51d45c5e_71efeb0f_235b7946_91de6228_877569b3_a8d52bf0_58b8a4a0,
2013                     0x3c1f5fb3_ca7166fc_e1471c9b_752b6d28_c56301ad_7b65e845_1b2c8c55_26726e12,
2014                     0x6102416c_f02f02ff_5be75275_f55f28db_89b2a9d2_456b860c_e22fc0e5_031f7cc5,
2015                     0x40adf677_f1bfdae0_57f0fd17_9c126179_18ddaa28_91a6530f_b1a4294f_a8665490,
2016                     0x61936f3c_41560904_6187b8ba_a978cbc9_b4789336_3ae5a3cc_7d909f36_35ae7f48,
2017                     0x562a9662_b6ec47f9_e979d473_c02b51e4_42336823_8c58ddb5_2f0e5c6a_180e6410
2018                 ],
2019                 [
2020                     0x3788bdb4_4f8632d4_2d0dbee5_eea1acc6_136cf411_e655624f_55e48902_c3bd5534,
2021                     0x6190cf2c_2a7b5ad7_69d594a8_2844f23b_4167fa7c_8ac30e51_aa6cfbeb_dcd4b945,
2022                     0x65f77870_96be9204_123a71f3_ac88a87b_e1513217_737d6a1e_2f3a13a4_3d7e3a9a,
2023                     0x23af32d_bfa67975_536479a7_a7ce74a0_2142147f_ac048018_7f1f1334_9cda1f2d,
2024                     0x64fc44b7_fc6841bd_db0ced8b_8b0fe675_9137ef87_ee966512_15fc1dbc_d25c64dc,
2025                     0x1434aa37_48b701d5_b69df3d7_d340c1fe_3f6b9c1e_fc617484_caadb47e_382f4475,
2026                     0x457a6da8_c962ef35_f2b21742_3e5844e9_d2353452_7e8ea429_0d24e3dd_f21720c6,
2027                     0x63b9540c_eb60ccb5_1e4d989d_956e053c_f2511837_efb79089_d2ff4028_4202c53d
2028                 ]
2029             ];
2030         }
2031         // Step 4: compute s*G - h*A
2032         {
2033             uint256 ss = uint256(s) << 3;
2034             uint256 hhh = hh + 0x80000000_00000000_00000000_00000000_a6f7cef5_17bce6b2_c09318d2_e7ae9f60;
2035             uint256 vvx = 0;
2036             uint256 vvu = 1;
2037             uint256 vvy = 1;
2038             uint256 vvv = 1;
2039             for (uint256 i = 252; ; i--) {
2040                 uint256 bit = 8 << i;
2041                 if ((ss & bit) != 0) {
2042                     uint256 ws;
2043                     uint256 wd;
2044                     uint256 wz;
2045                     uint256 wt;
2046                     {
2047                         uint256 wx =
2048                             mulmod(vvx, vvv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2049                         uint256 wy =
2050                             mulmod(vvy, vvu, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2051                         ws = wy + wx;
2052                         wd = wy - wx + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2053                         wz = mulmod(
2054                             vvu,
2055                             vvv,
2056                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2057                         );
2058                         wt = mulmod(
2059                             vvx,
2060                             vvy,
2061                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2062                         );
2063                     }
2064                     uint256 j = (ss >> i) & 7;
2065                     ss &= ~(7 << i);
2066                     uint256[8][3][2] memory tables_ = tables;
2067                     uint256 aa =
2068                         mulmod(
2069                             wd,
2070                             tables_[0][1][j],
2071                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2072                         );
2073                     uint256 ab =
2074                         mulmod(
2075                             ws,
2076                             tables_[0][0][j],
2077                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2078                         );
2079                     uint256 ac =
2080                         mulmod(
2081                             wt,
2082                             tables_[0][2][j],
2083                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2084                         );
2085                     vvx = ab - aa + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2086                     vvu = wz + ac;
2087                     vvy = ab + aa;
2088                     vvv = wz - ac + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2089                 }
2090                 if ((hhh & bit) != 0) {
2091                     uint256 ws;
2092                     uint256 wd;
2093                     uint256 wz;
2094                     uint256 wt;
2095                     {
2096                         uint256 wx =
2097                             mulmod(vvx, vvv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2098                         uint256 wy =
2099                             mulmod(vvy, vvu, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2100                         ws = wy + wx;
2101                         wd = wy - wx + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2102                         wz = mulmod(
2103                             vvu,
2104                             vvv,
2105                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2106                         );
2107                         wt = mulmod(
2108                             vvx,
2109                             vvy,
2110                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2111                         );
2112                     }
2113                     uint256 j = (hhh >> i) & 7;
2114                     hhh &= ~(7 << i);
2115                     uint256[8][3][2] memory tables_ = tables;
2116                     uint256 aa =
2117                         mulmod(
2118                             wd,
2119                             tables_[1][0][j],
2120                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2121                         );
2122                     uint256 ab =
2123                         mulmod(
2124                             ws,
2125                             tables_[1][1][j],
2126                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2127                         );
2128                     uint256 ac =
2129                         mulmod(
2130                             wt,
2131                             tables_[1][2][j],
2132                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2133                         );
2134                     vvx = ab - aa + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2135                     vvu = wz - ac + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2136                     vvy = ab + aa;
2137                     vvv = wz + ac;
2138                 }
2139                 if (i == 0) {
2140                     uint256 ws;
2141                     uint256 wd;
2142                     uint256 wz;
2143                     uint256 wt;
2144                     {
2145                         uint256 wx =
2146                             mulmod(vvx, vvv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2147                         uint256 wy =
2148                             mulmod(vvy, vvu, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2149                         ws = wy + wx;
2150                         wd = wy - wx + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2151                         wz = mulmod(
2152                             vvu,
2153                             vvv,
2154                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2155                         );
2156                         wt = mulmod(
2157                             vvx,
2158                             vvy,
2159                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2160                         );
2161                     }
2162                     uint256 j = hhh & 7;
2163                     uint256[8][3][2] memory tables_ = tables;
2164                     uint256 aa =
2165                         mulmod(
2166                             wd,
2167                             tables_[1][0][j],
2168                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2169                         );
2170                     uint256 ab =
2171                         mulmod(
2172                             ws,
2173                             tables_[1][1][j],
2174                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2175                         );
2176                     uint256 ac =
2177                         mulmod(
2178                             wt,
2179                             tables_[1][2][j],
2180                             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2181                         );
2182                     vvx = ab - aa + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2183                     vvu = wz - ac + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2184                     vvy = ab + aa;
2185                     vvv = wz + ac;
2186                     break;
2187                 }
2188                 {
2189                     uint256 xx =
2190                         mulmod(vvx, vvv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2191                     uint256 yy =
2192                         mulmod(vvy, vvu, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2193                     uint256 zz =
2194                         mulmod(vvu, vvv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2195                     uint256 xx2 =
2196                         mulmod(xx, xx, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2197                     uint256 yy2 =
2198                         mulmod(yy, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2199                     uint256 xxyy =
2200                         mulmod(xx, yy, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2201                     uint256 zz2 =
2202                         mulmod(zz, zz, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2203                     vvx = xxyy + xxyy;
2204                     vvu = yy2 - xx2 + 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed;
2205                     vvy = xx2 + yy2;
2206                     vvv = addmod(
2207                         zz2 + zz2,
2208                         0xffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffda - vvu,
2209                         0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2210                     );
2211                 }
2212             }
2213             vx = vvx;
2214             vu = vvu;
2215             vy = vvy;
2216             vv = vvv;
2217         }
2218         // Step 5: compare the points
2219         (uint256 vi, uint256 vj) =
2220             pow22501(mulmod(vu, vv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed));
2221         vi = mulmod(vi, vi, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2222         vi = mulmod(vi, vi, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2223         vi = mulmod(vi, vi, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2224         vi = mulmod(vi, vi, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2225         vi = mulmod(vi, vi, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2226         vi = mulmod(vi, vj, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed);
2227         vx = mulmod(
2228             vx,
2229             mulmod(vi, vv, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
2230             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2231         );
2232         vy = mulmod(
2233             vy,
2234             mulmod(vi, vu, 0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed),
2235             0x7fffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffed
2236         );
2237         bytes32 v = bytes32(vy | (vx << 255));
2238         v = bytes32(
2239             ((uint256(v) & 0xff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff_00ff00ff) << 8) |
2240                 ((uint256(v) & 0xff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00_ff00ff00) >> 8)
2241         );
2242         v = bytes32(
2243             ((uint256(v) & 0xffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff_0000ffff) << 16) |
2244                 ((uint256(v) & 0xffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000_ffff0000) >> 16)
2245         );
2246         v = bytes32(
2247             ((uint256(v) & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff) << 32) |
2248                 ((uint256(v) & 0xffffffff_00000000_ffffffff_00000000_ffffffff_00000000_ffffffff_00000000) >> 32)
2249         );
2250         v = bytes32(
2251             ((uint256(v) & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff) << 64) |
2252                 ((uint256(v) & 0xffffffff_ffffffff_00000000_00000000_ffffffff_ffffffff_00000000_00000000) >> 64)
2253         );
2254         v = bytes32((uint256(v) << 128) | (uint256(v) >> 128));
2255         return v == r;
2256     }
2257 }
2258 
2259 // File: contracts/NearBridge.sol
2260 
2261 pragma solidity ^0.6;
2262 pragma experimental ABIEncoderV2;
2263 
2264 
2265 
2266 
2267 
2268 
2269 contract NearBridge is INearBridge, AdminControlled {
2270     using SafeMath for uint256;
2271     using Borsh for Borsh.Data;
2272     using NearDecoder for Borsh.Data;
2273 
2274     // Assumed to be even and to not exceed 256.
2275     uint constant MAX_BLOCK_PRODUCERS = 100;
2276 
2277     struct Epoch {
2278         bytes32 epochId;
2279         uint numBPs;
2280         bytes32[MAX_BLOCK_PRODUCERS] keys;
2281         bytes32[MAX_BLOCK_PRODUCERS / 2] packedStakes;
2282         uint256 stakeThreshold;
2283     }
2284 
2285     // Whether the contract was initialized.
2286     bool public initialized;
2287     uint256 public lockEthAmount;
2288     uint256 public lockDuration;
2289     // replaceDuration is in nanoseconds, because it is a difference between NEAR timestamps.
2290     uint256 public replaceDuration;
2291     Ed25519 immutable edwards;
2292 
2293     Epoch[3] epochs;
2294     uint curEpoch;
2295     uint64 curHeight;
2296 
2297     // The most recently added block. May still be in its challenge period, so should not be trusted.
2298     uint64 untrustedHeight;
2299     uint256 untrustedTimestamp;
2300     bool untrustedNextEpoch;
2301     bytes32 untrustedHash;
2302     bytes32 untrustedMerkleRoot;
2303     bytes32 untrustedNextHash;
2304     uint256 untrustedSignatureSet;
2305     NearDecoder.Signature[MAX_BLOCK_PRODUCERS] untrustedSignatures;
2306 
2307     // Address of the account which submitted the last block.
2308     address lastSubmitter;
2309     // End of challenge period. If zero, untrusted* fields and lastSubmitter are not meaningful.
2310     uint public lastValidAt;
2311 
2312     mapping(uint64 => bytes32) blockHashes_;
2313     mapping(uint64 => bytes32) blockMerkleRoots_;
2314     mapping(address => uint256) public override balanceOf;
2315 
2316     constructor(
2317         Ed25519 ed,
2318         uint256 lockEthAmount_,
2319         uint256 lockDuration_,
2320         uint256 replaceDuration_,
2321         address admin_,
2322         uint256 pausedFlags_
2323     ) public AdminControlled(admin_, pausedFlags_) {
2324         require(replaceDuration_ > lockDuration_.mul(1000000000));
2325         edwards = ed;
2326         lockEthAmount = lockEthAmount_;
2327         lockDuration = lockDuration_;
2328         replaceDuration = replaceDuration_;
2329     }
2330 
2331     uint constant UNPAUSE_ALL = 0;
2332     uint constant PAUSED_DEPOSIT = 1;
2333     uint constant PAUSED_WITHDRAW = 2;
2334     uint constant PAUSED_ADD_BLOCK = 4;
2335     uint constant PAUSED_CHALLENGE = 8;
2336     uint constant PAUSED_VERIFY = 16;
2337 
2338     function deposit() public payable override pausable(PAUSED_DEPOSIT) {
2339         require(msg.value == lockEthAmount && balanceOf[msg.sender] == 0);
2340         balanceOf[msg.sender] = msg.value;
2341     }
2342 
2343     function withdraw() public override pausable(PAUSED_WITHDRAW) {
2344         require(msg.sender != lastSubmitter || block.timestamp >= lastValidAt);
2345         uint amount = balanceOf[msg.sender];
2346         require(amount != 0);
2347         balanceOf[msg.sender] = 0;
2348         msg.sender.transfer(amount);
2349     }
2350 
2351     function challenge(address payable receiver, uint signatureIndex) public override pausable(PAUSED_CHALLENGE) {
2352         require(block.timestamp < lastValidAt, "No block can be challenged at this time");
2353         require(!checkBlockProducerSignatureInHead(signatureIndex), "Can't challenge valid signature");
2354 
2355         balanceOf[lastSubmitter] = balanceOf[lastSubmitter].sub(lockEthAmount);
2356         receiver.transfer(lockEthAmount / 2);
2357         lastValidAt = 0;
2358     }
2359 
2360     function checkBlockProducerSignatureInHead(uint signatureIndex) public view override returns (bool) {
2361         // Shifting by a number >= 256 returns zero.
2362         require((untrustedSignatureSet & (1 << signatureIndex)) != 0, "No such signature");
2363         Epoch storage untrustedEpoch = epochs[untrustedNextEpoch ? (curEpoch + 1) % 3 : curEpoch];
2364         NearDecoder.Signature storage signature = untrustedSignatures[signatureIndex];
2365         bytes memory message =
2366             abi.encodePacked(uint8(0), untrustedNextHash, Utils.swapBytes8(untrustedHeight + 2), bytes23(0));
2367         (bytes32 arg1, bytes9 arg2) = abi.decode(message, (bytes32, bytes9));
2368         return edwards.check(untrustedEpoch.keys[signatureIndex], signature.r, signature.s, arg1, arg2);
2369     }
2370 
2371     // The first part of initialization -- setting the validators of the current epoch.
2372     function initWithValidators(bytes memory data) public override onlyAdmin {
2373         require(!initialized && epochs[0].numBPs == 0, "Wrong initialization stage");
2374 
2375         Borsh.Data memory borsh = Borsh.from(data);
2376         NearDecoder.BlockProducer[] memory initialValidators = borsh.decodeBlockProducers();
2377         borsh.done();
2378 
2379         setBlockProducers(initialValidators, epochs[0]);
2380     }
2381 
2382     // The second part of the initialization -- setting the current head.
2383     function initWithBlock(bytes memory data) public override onlyAdmin {
2384         require(!initialized && epochs[0].numBPs != 0, "Wrong initialization stage");
2385         initialized = true;
2386 
2387         Borsh.Data memory borsh = Borsh.from(data);
2388         NearDecoder.LightClientBlock memory nearBlock = borsh.decodeLightClientBlock();
2389         borsh.done();
2390 
2391         require(nearBlock.next_bps.some, "Initialization block must contain next_bps");
2392 
2393         curHeight = nearBlock.inner_lite.height;
2394         epochs[0].epochId = nearBlock.inner_lite.epoch_id;
2395         epochs[1].epochId = nearBlock.inner_lite.next_epoch_id;
2396         blockHashes_[nearBlock.inner_lite.height] = nearBlock.hash;
2397         blockMerkleRoots_[nearBlock.inner_lite.height] = nearBlock.inner_lite.block_merkle_root;
2398         setBlockProducers(nearBlock.next_bps.blockProducers, epochs[1]);
2399     }
2400 
2401     struct BridgeState {
2402         uint currentHeight; // Height of the current confirmed block
2403         // If there is currently no unconfirmed block, the last three fields are zero.
2404         uint nextTimestamp; // Timestamp of the current unconfirmed block
2405         uint nextValidAt; // Timestamp when the current unconfirmed block will be confirmed
2406         uint numBlockProducers; // Number of block producers for the current unconfirmed block
2407     }
2408 
2409     function bridgeState() public view returns (BridgeState memory res) {
2410         if (block.timestamp < lastValidAt) {
2411             res.currentHeight = curHeight;
2412             res.nextTimestamp = untrustedTimestamp;
2413             res.nextValidAt = lastValidAt;
2414             res.numBlockProducers = epochs[untrustedNextEpoch ? (curEpoch + 1) % 3 : curEpoch].numBPs;
2415         } else {
2416             res.currentHeight = lastValidAt == 0 ? curHeight : untrustedHeight;
2417         }
2418     }
2419 
2420     function addLightClientBlock(bytes memory data) public override pausable(PAUSED_ADD_BLOCK) {
2421         require(initialized, "Contract is not initialized");
2422         require(balanceOf[msg.sender] >= lockEthAmount, "Balance is not enough");
2423 
2424         Borsh.Data memory borsh = Borsh.from(data);
2425         NearDecoder.LightClientBlock memory nearBlock = borsh.decodeLightClientBlock();
2426         borsh.done();
2427 
2428         // Commit the previous block, or make sure that it is OK to replace it.
2429         if (block.timestamp < lastValidAt) {
2430             require(
2431                 nearBlock.inner_lite.timestamp >= untrustedTimestamp.add(replaceDuration),
2432                 "Can only replace with a sufficiently newer block"
2433             );
2434         } else if (lastValidAt != 0) {
2435             curHeight = untrustedHeight;
2436             if (untrustedNextEpoch) {
2437                 curEpoch = (curEpoch + 1) % 3;
2438             }
2439             lastValidAt = 0;
2440 
2441             blockHashes_[curHeight] = untrustedHash;
2442             blockMerkleRoots_[curHeight] = untrustedMerkleRoot;
2443         }
2444 
2445         // Check that the new block's height is greater than the current one's.
2446         require(nearBlock.inner_lite.height > curHeight, "New block must have higher height");
2447 
2448         // Check that the new block is from the same epoch as the current one, or from the next one.
2449         bool fromNextEpoch;
2450         if (nearBlock.inner_lite.epoch_id == epochs[curEpoch].epochId) {
2451             fromNextEpoch = false;
2452         } else if (nearBlock.inner_lite.epoch_id == epochs[(curEpoch + 1) % 3].epochId) {
2453             fromNextEpoch = true;
2454         } else {
2455             revert("Epoch id of the block is not valid");
2456         }
2457 
2458         // Check that the new block is signed by more than 2/3 of the validators.
2459         Epoch storage thisEpoch = epochs[fromNextEpoch ? (curEpoch + 1) % 3 : curEpoch];
2460         // Last block in the epoch might contain extra approvals that light client can ignore.
2461         require(nearBlock.approvals_after_next.length >= thisEpoch.numBPs, "Approval list is too short");
2462         // The sum of uint128 values cannot overflow.
2463         uint256 votedFor = 0;
2464         for ((uint i, uint cnt) = (0, thisEpoch.numBPs); i != cnt; ++i) {
2465             bytes32 stakes = thisEpoch.packedStakes[i >> 1];
2466             if (nearBlock.approvals_after_next[i].some) {
2467                 votedFor += uint128(bytes16(stakes));
2468             }
2469             if (++i == cnt) {
2470                 break;
2471             }
2472             if (nearBlock.approvals_after_next[i].some) {
2473                 votedFor += uint128(uint256(stakes));
2474             }
2475         }
2476         require(votedFor > thisEpoch.stakeThreshold, "Too few approvals");
2477 
2478         // If the block is from the next epoch, make sure that next_bps is supplied and has a correct hash.
2479         if (fromNextEpoch) {
2480             require(nearBlock.next_bps.some, "Next next_bps should not be None");
2481             require(
2482                 nearBlock.next_bps.hash == nearBlock.inner_lite.next_bp_hash,
2483                 "Hash of block producers does not match"
2484             );
2485         }
2486 
2487         untrustedHeight = nearBlock.inner_lite.height;
2488         untrustedTimestamp = nearBlock.inner_lite.timestamp;
2489         untrustedHash = nearBlock.hash;
2490         untrustedMerkleRoot = nearBlock.inner_lite.block_merkle_root;
2491         untrustedNextHash = nearBlock.next_hash;
2492 
2493         uint256 signatureSet = 0;
2494         for ((uint i, uint cnt) = (0, thisEpoch.numBPs); i < cnt; i++) {
2495             NearDecoder.OptionalSignature memory approval = nearBlock.approvals_after_next[i];
2496             if (approval.some) {
2497                 signatureSet |= 1 << i;
2498                 untrustedSignatures[i] = approval.signature;
2499             }
2500         }
2501         untrustedSignatureSet = signatureSet;
2502         untrustedNextEpoch = fromNextEpoch;
2503         if (fromNextEpoch) {
2504             Epoch storage nextEpoch = epochs[(curEpoch + 2) % 3];
2505             nextEpoch.epochId = nearBlock.inner_lite.next_epoch_id;
2506             setBlockProducers(nearBlock.next_bps.blockProducers, nextEpoch);
2507         }
2508         lastSubmitter = msg.sender;
2509         lastValidAt = block.timestamp.add(lockDuration);
2510     }
2511 
2512     function setBlockProducers(NearDecoder.BlockProducer[] memory src, Epoch storage epoch) internal {
2513         uint cnt = src.length;
2514         require(cnt <= MAX_BLOCK_PRODUCERS);
2515         epoch.numBPs = cnt;
2516         for (uint i = 0; i < cnt; i++) {
2517             epoch.keys[i] = src[i].publicKey.k;
2518         }
2519         uint256 totalStake = 0; // Sum of uint128, can't be too big.
2520         for (uint i = 0; i != cnt; ++i) {
2521             uint128 stake1 = src[i].stake;
2522             totalStake += stake1;
2523             if (++i == cnt) {
2524                 epoch.packedStakes[i >> 1] = bytes32(bytes16(stake1));
2525                 break;
2526             }
2527             uint128 stake2 = src[i].stake;
2528             totalStake += stake2;
2529             epoch.packedStakes[i >> 1] = bytes32(uint256(bytes32(bytes16(stake1))) + stake2);
2530         }
2531         epoch.stakeThreshold = (totalStake * 2) / 3;
2532     }
2533 
2534     function blockHashes(uint64 height) public view override pausable(PAUSED_VERIFY) returns (bytes32 res) {
2535         res = blockHashes_[height];
2536         if (res == 0 && block.timestamp >= lastValidAt && lastValidAt != 0 && height == untrustedHeight) {
2537             res = untrustedHash;
2538         }
2539     }
2540 
2541     function blockMerkleRoots(uint64 height) public view override pausable(PAUSED_VERIFY) returns (bytes32 res) {
2542         res = blockMerkleRoots_[height];
2543         if (res == 0 && block.timestamp >= lastValidAt && lastValidAt != 0 && height == untrustedHeight) {
2544             res = untrustedMerkleRoot;
2545         }
2546     }
2547 }