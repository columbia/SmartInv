1 pragma solidity ^0.5.0;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 
6 library RLPReader {
7     uint8 constant STRING_SHORT_START = 0x80;
8     uint8 constant STRING_LONG_START  = 0xb8;
9     uint8 constant LIST_SHORT_START   = 0xc0;
10     uint8 constant LIST_LONG_START    = 0xf8;
11     
12     uint8 constant WORD_SIZE = 32;
13     
14     struct RLPItem {
15         uint len;
16         uint memPtr;
17     }
18     
19     /*
20     * @param item RLP encoded bytes
21     */
22     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
23         uint memPtr;
24         assembly {
25             memPtr := add(item, 0x20)
26         }
27         
28         return RLPItem(item.length, memPtr);
29     }
30     
31     /*
32     * @param item RLP encoded bytes
33     */
34     function rlpLen(RLPItem memory item) internal pure returns (uint) {
35         return item.len;
36     }
37     
38     /*
39     * @param item RLP encoded bytes
40     */
41     function payloadLen(RLPItem memory item) internal pure returns (uint) {
42         return item.len - _payloadOffset(item.memPtr);
43     }
44     
45     /*
46     * @param item RLP encoded list in bytes
47     */
48     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory result) {
49         require(isList(item));
50         
51         uint items = numItems(item);
52         result = new RLPItem[](items);
53         
54         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
55         uint dataLen;
56         for (uint i = 0; i < items; i++) {
57             dataLen = _itemLength(memPtr);
58             result[i] = RLPItem(dataLen, memPtr);
59             memPtr = memPtr + dataLen;
60         }
61     }
62     
63     // @return indicator whether encoded payload is a list. negate this function call for isData.
64     function isList(RLPItem memory item) internal pure returns (bool) {
65         if (item.len == 0) return false;
66         
67         uint8 byte0;
68         uint memPtr = item.memPtr;
69         assembly {
70             byte0 := byte(0, mload(memPtr))
71         }
72         
73         if (byte0 < LIST_SHORT_START)
74             return false;
75         return true;
76     }
77     
78     /** RLPItem conversions into data types **/
79     
80     // @returns raw rlp encoding in bytes
81     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
82         bytes memory result = new bytes(item.len);
83         if (result.length == 0) return result;
84         
85         uint ptr;
86         assembly {
87             ptr := add(0x20, result)
88         }
89         
90         copy(item.memPtr, ptr, item.len);
91         return result;
92     }
93     
94     // any non-zero byte is considered true
95     function toBoolean(RLPItem memory item) internal pure returns (bool) {
96         require(item.len == 1);
97         uint result;
98         uint memPtr = item.memPtr;
99         assembly {
100             result := byte(0, mload(memPtr))
101         }
102         
103         return result == 0 ? false : true;
104     }
105     
106     function toAddress(RLPItem memory item) internal pure returns (address) {
107         // 1 byte for the length prefix
108         require(item.len == 21);
109         
110         return address(toUint(item));
111     }
112     
113     function toUint(RLPItem memory item) internal pure returns (uint) {
114         require(item.len > 0 && item.len <= 33);
115         
116         uint offset = _payloadOffset(item.memPtr);
117         uint len = item.len - offset;
118         
119         uint result;
120         uint memPtr = item.memPtr + offset;
121         assembly {
122             result := mload(memPtr)
123         
124         // shfit to the correct location if neccesary
125             if lt(len, 32) {
126                 result := div(result, exp(256, sub(32, len)))
127             }
128         }
129         
130         return result;
131     }
132     
133     // enforces 32 byte length
134     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
135         // one byte prefix
136         require(item.len == 33);
137         
138         uint result;
139         uint memPtr = item.memPtr + 1;
140         assembly {
141             result := mload(memPtr)
142         }
143         
144         return result;
145     }
146     
147     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
148         require(item.len > 0);
149         
150         uint offset = _payloadOffset(item.memPtr);
151         uint len = item.len - offset; // data length
152         bytes memory result = new bytes(len);
153         
154         uint destPtr;
155         assembly {
156             destPtr := add(0x20, result)
157         }
158         
159         copy(item.memPtr + offset, destPtr, len);
160         return result;
161     }
162     
163     /*
164     * Private Helpers
165     */
166     
167     // @return number of payload items inside an encoded list.
168     function numItems(RLPItem memory item) private pure returns (uint) {
169         if (item.len == 0) return 0;
170         
171         uint count = 0;
172         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
173         uint endPtr = item.memPtr + item.len;
174         while (currPtr < endPtr) {
175             currPtr = currPtr + _itemLength(currPtr); // skip over an item
176             count++;
177         }
178         
179         return count;
180     }
181     
182     // @return entire rlp item byte length
183     function _itemLength(uint memPtr) private pure returns (uint len) {
184         uint byte0;
185         assembly {
186             byte0 := byte(0, mload(memPtr))
187         }
188         
189         if (byte0 < STRING_SHORT_START)
190             return 1;
191         
192         else if (byte0 < STRING_LONG_START)
193             return byte0 - STRING_SHORT_START + 1;
194         
195         else if (byte0 < LIST_SHORT_START) {
196             assembly {
197                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
198                 memPtr := add(memPtr, 1) // skip over the first byte
199             
200             /* 32 byte word size */
201                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
202                 len := add(dataLen, add(byteLen, 1))
203             }
204         }
205         
206         else if (byte0 < LIST_LONG_START) {
207             return byte0 - LIST_SHORT_START + 1;
208         }
209         
210         else {
211             assembly {
212                 let byteLen := sub(byte0, 0xf7)
213                 memPtr := add(memPtr, 1)
214                 
215                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
216                 len := add(dataLen, add(byteLen, 1))
217             }
218         }
219     }
220     
221     // @return number of bytes until the data
222     function _payloadOffset(uint memPtr) private pure returns (uint) {
223         uint byte0;
224         assembly {
225             byte0 := byte(0, mload(memPtr))
226         }
227         
228         if (byte0 < STRING_SHORT_START)
229             return 0;
230         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
231             return 1;
232         else if (byte0 < LIST_SHORT_START)  // being explicit
233             return byte0 - (STRING_LONG_START - 1) + 1;
234         else
235             return byte0 - (LIST_LONG_START - 1) + 1;
236     }
237     
238     /*
239     * @param src Pointer to source
240     * @param dest Pointer to destination
241     * @param len Amount of memory to copy from the source
242     */
243     function copy(uint src, uint dest, uint len) private pure {
244         if (len == 0) return;
245         
246         // copy as many word sizes as possible
247         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
248             assembly {
249                 mstore(dest, mload(src))
250             }
251             
252             src += WORD_SIZE;
253             dest += WORD_SIZE;
254         }
255         
256         // left over bytes. Mask is used to remove unwanted bytes from the word
257         uint mask = 256 ** (WORD_SIZE - len) - 1;
258         assembly {
259             let srcpart := and(mload(src), not(mask)) // zero out src
260             let destpart := and(mload(dest), mask) // retrieve the bytes
261             mstore(dest, or(destpart, srcpart))
262         }
263     }
264 }
265 
266 library BytesUtil {
267     uint8 constant WORD_SIZE = 32;
268 
269     // @param _bytes raw bytes that needs to be slices
270     // @param start  start of the slice relative to `_bytes`
271     // @param len    length of the sliced byte array
272     function slice(bytes memory _bytes, uint start, uint len)
273         internal
274         pure
275         returns (bytes memory)
276     {
277         require(_bytes.length - start >= len);
278 
279         if (_bytes.length == len)
280             return _bytes;
281 
282         bytes memory result;
283         uint src;
284         uint dest;
285         assembly {
286             // memory & free memory pointer
287             result := mload(0x40)
288             mstore(result, len) // store the size in the prefix
289             mstore(0x40, add(result, and(add(add(0x20, len), 0x1f), not(0x1f)))) // padding
290 
291             // pointers
292             src := add(start, add(0x20, _bytes))
293             dest := add(0x20, result)
294         }
295 
296         // copy as many word sizes as possible
297         for(; len >= WORD_SIZE; len -= WORD_SIZE) {
298             assembly {
299                 mstore(dest, mload(src))
300             }
301 
302             src += WORD_SIZE;
303             dest += WORD_SIZE;
304         }
305 
306         // copy remaining bytes
307         uint mask = 256 ** (WORD_SIZE - len) - 1;
308         assembly {
309             let srcpart := and(mload(src), not(mask)) // zero out src
310             let destpart := and(mload(dest), mask) // retrieve the bytes
311             mstore(dest, or(destpart, srcpart))
312         }
313 
314         return result;
315     }
316 }
317 
318 library SafeMath {
319     /**
320     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
321     */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         require(b <= a);
324         uint256 c = a - b;
325 
326         return c;
327     }
328 
329     /**
330     * @dev Adds two signed integers, reverts on overflow.
331     */
332     function add(uint256 a, uint256 b) internal pure returns (uint256) {
333         uint256 c = a + b;
334         require((b >= 0 && c >= a) || (b < 0 && c < a));
335 
336         return c;
337     }
338 
339     /**
340     * @dev Multiplies two unsigned integers, reverts on overflow.
341     */
342     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
343         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
344         // benefit is lost if 'b' is also tested.
345         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
346         if (a == 0) {
347             return 0;
348         }
349 
350         uint256 c = a * b;
351         require(c / a == b);
352 
353         return c;
354     }
355 
356     /**
357     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
358     */
359     function div(uint256 a, uint256 b) internal pure returns (uint256) {
360         // Solidity only automatically asserts when dividing by 0
361         require(b > 0);
362         uint256 c = a / b;
363         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
364 
365         return c;
366     }
367 
368     function max(uint256 a, uint256 b)
369         internal
370         pure
371         returns (uint256)
372     {
373         return a >= b ? a : b;
374     }
375 }
376 
377 library ECDSA {
378      /**
379      * @dev Recover signer address from a message by using their signature
380      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
381      * @param signature bytes signature, the signature is generated using web3.eth.sign()
382      */
383     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
384         bytes32 r;
385         bytes32 s;
386         uint8 v;
387 
388         // prefix the hash with an ethereum signed message
389         hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
390 
391         // Check the signature length
392         if (signature.length != 65) {
393             return (address(0));
394         }
395 
396         // Divide the signature in r, s and v variables
397         // ecrecover takes the signature parameters, and the only way to get them
398         // currently is to use assembly.
399         // solium-disable-next-line security/no-inline-assembly
400         assembly {
401             r := mload(add(signature, 0x20))
402             s := mload(add(signature, 0x40))
403             v := byte(0, mload(add(signature, 0x60)))
404         }
405 
406         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
407         if (v < 27) {
408             v += 27;
409         }
410 
411         // If the version is correct return the signer address
412         if (v != 27 && v != 28) {
413             return (address(0));
414         } else {
415             // solium-disable-next-line arg-overflow
416             return ecrecover(hash, v, r, s);
417         }
418     }
419 }
420 
421 library TMSimpleMerkleTree {
422     using BytesUtil for bytes;
423 
424     // @param leaf     a leaf of the tree
425     // @param index    position of this leaf in the tree that is zero indexed
426     // @param rootHash block header of the merkle tree
427     // @param proof    sequence of 32-byte hashes from the leaf up to, but excluding, the root
428     // @paramt total   total # of leafs in the tree
429     function checkMembership(bytes32 leaf, uint256 index, bytes32 rootHash, bytes memory proof, uint256 total)
430         internal
431         pure
432         returns (bool)
433     {
434         // variable size Merkle tree, but proof must consist of 32-byte hashes
435         require(proof.length % 32 == 0); // incorrect proof length
436 
437         bytes32 computedHash = computeHashFromAunts(index, total, leaf, proof);
438         return computedHash == rootHash;
439     }
440 
441     // helper function as described in the tendermint docs
442     function computeHashFromAunts(uint256 index, uint256 total, bytes32 leaf, bytes memory innerHashes)
443         private
444         pure
445         returns (bytes32)
446     {
447         require(index < total); // index must be within bound of the # of leave
448         require(total > 0); // must have one leaf node
449 
450         if (total == 1) {
451             require(innerHashes.length == 0); // 1 txn has no proof
452             return leaf;
453         }
454         require(innerHashes.length != 0); // >1 txns should have a proof
455 
456         uint256 numLeft = (total + 1) / 2;
457         bytes32 proofElement;
458 
459         // prepend 0x20 byte literal to hashes
460         // tendermint prefixes intermediate hashes with 0x20 bytes literals
461         // before hashing them.
462         bytes memory b = new bytes(1);
463         assembly {
464             let memPtr := add(b, 0x20)
465             mstore8(memPtr, 0x20)
466         }
467 
468         uint innerHashesMemOffset = innerHashes.length - 32;
469         if (index < numLeft) {
470             bytes32 leftHash = computeHashFromAunts(index, numLeft, leaf, innerHashes.slice(0, innerHashes.length - 32));
471             assembly {
472                 // get the last 32-byte hash from innerHashes array
473                 proofElement := mload(add(add(innerHashes, 0x20), innerHashesMemOffset))
474             }
475 
476             return sha256(abi.encodePacked(b, leftHash, b, proofElement));
477         } else {
478             bytes32 rightHash = computeHashFromAunts(index-numLeft, total-numLeft, leaf, innerHashes.slice(0, innerHashes.length - 32));
479             assembly {
480                     // get the last 32-byte hash from innerHashes array
481                     proofElement := mload(add(add(innerHashes, 0x20), innerHashesMemOffset))
482             }
483             return sha256(abi.encodePacked(b, proofElement, b, rightHash));
484         }
485     }
486 }
487 
488 library MinPriorityQueue {
489     using SafeMath for uint256;
490 
491     function insert(uint256[] storage heapList, uint256 k)
492         internal
493     {
494         heapList.push(k);
495         if (heapList.length > 1)
496             percUp(heapList, heapList.length.sub(1));
497     }
498 
499     function delMin(uint256[] storage heapList)
500         internal
501         returns (uint256)
502     {
503         require(heapList.length > 0);
504 
505         uint256 min = heapList[0];
506 
507         // move the last element to the front
508         heapList[0] = heapList[heapList.length.sub(1)];
509         delete heapList[heapList.length.sub(1)];
510         heapList.length = heapList.length.sub(1);
511 
512         if (heapList.length > 1) {
513             percDown(heapList, 0);
514         }
515 
516         return min;
517     }
518 
519     function minChild(uint256[] storage heapList, uint256 i)
520         private
521         view
522         returns (uint256)
523     {
524         uint lChild = i.mul(2).add(1);
525         uint rChild = i.mul(2).add(2);
526 
527         if (rChild > heapList.length.sub(1) || heapList[lChild] < heapList[rChild])
528             return lChild;
529         else
530             return rChild;
531     }
532 
533     function percUp(uint256[] storage heapList, uint256 i)
534         private
535     {
536         uint256 position = i;
537         uint256 value = heapList[i];
538 
539         // continue to percolate up while smaller than the parent
540         while (i != 0 && value < heapList[i.sub(1).div(2)]) {
541             heapList[i] = heapList[i.sub(1).div(2)];
542             i = i.sub(1).div(2);
543         }
544 
545         // place the value in the correct parent
546         if (position != i) heapList[i] = value;
547     }
548 
549     function percDown(uint256[] storage heapList, uint256 i)
550         private
551     {
552         uint position = i;
553         uint value = heapList[i];
554 
555         // continue to percolate down while larger than the child
556         uint child = minChild(heapList, i);
557         while(child < heapList.length && value > heapList[child]) {
558             heapList[i] = heapList[child];
559             i = child;
560             child = minChild(heapList, i);
561         }
562 
563         // place value in the correct child
564         if (position != i) heapList[i] = value;
565     }
566 }
567 
568 contract PlasmaMVP {
569     using MinPriorityQueue for uint256[];
570     using BytesUtil for bytes;
571     using RLPReader for bytes;
572     using RLPReader for RLPReader.RLPItem;
573     using SafeMath for uint256;
574     using TMSimpleMerkleTree for bytes32;
575     using ECDSA for bytes32;
576 
577     /*
578      * Events
579      */
580 
581     event ChangedOperator(address oldOperator, address newOperator);
582 
583     event AddedToBalances(address owner, uint256 amount);
584     event BlockSubmitted(bytes32 header, uint256 blockNumber, uint256 numTxns, uint256 feeAmount);
585     event Deposit(address depositor, uint256 amount, uint256 depositNonce, uint256 ethBlockNum);
586 
587     event StartedTransactionExit(uint256[3] position, address owner, uint256 amount, bytes confirmSignatures, uint256 committedFee);
588     event StartedDepositExit(uint256 nonce, address owner, uint256 amount, uint256 committedFee);
589 
590     event ChallengedExit(uint256[4] position, address owner, uint256 amount);
591     event FinalizedExit(uint256[4] position, address owner, uint256 amount);
592 
593     /*
594      *  Storage
595      */
596 
597     address public operator;
598 
599     uint256 public lastCommittedBlock;
600     uint256 public depositNonce;
601     mapping(uint256 => plasmaBlock) public plasmaChain;
602     mapping(uint256 => depositStruct) public deposits;
603     struct plasmaBlock{
604         bytes32 header;
605         uint256 numTxns;
606         uint256 feeAmount;
607         uint256 createdAt;
608     }
609     struct depositStruct {
610         address owner;
611         uint256 amount;
612         uint256 createdAt;
613         uint256 ethBlockNum;
614     }
615 
616     // exits
617     uint256 public minExitBond;
618     uint256[] public txExitQueue;
619     uint256[] public depositExitQueue;
620     mapping(uint256 => exit) public txExits;
621     mapping(uint256 => exit) public depositExits;
622     enum ExitState { NonExistent, Pending, Challenged, Finalized }
623     struct exit {
624         uint256 amount;
625         uint256 committedFee;
626         uint256 createdAt;
627         address owner;
628         uint256[4] position; // (blkNum, txIndex, outputIndex, depositNonce)
629         ExitState state; // default value is `NonExistent`
630     }
631 
632     // funds
633     mapping(address => uint256) public balances;
634     uint256 public totalWithdrawBalance;
635 
636     // constants
637     uint256 constant txIndexFactor = 10;
638     uint256 constant blockIndexFactor = 1000000;
639     uint256 constant lastBlockNum = 2**109;
640     uint256 constant feeIndex = 2**16-1;
641 
642     /** Modifiers **/
643     modifier isBonded()
644     {
645         require(msg.value >= minExitBond);
646         if (msg.value > minExitBond) {
647             uint256 excess = msg.value.sub(minExitBond);
648             balances[msg.sender] = balances[msg.sender].add(excess);
649             totalWithdrawBalance = totalWithdrawBalance.add(excess);
650         }
651 
652         _;
653     }
654 
655     modifier onlyOperator()
656     {
657         require(msg.sender == operator);
658         _;
659     }
660 
661     function changeOperator(address newOperator)
662         public
663         onlyOperator
664     {
665         require(newOperator != address(0));
666 
667         emit ChangedOperator(operator, newOperator);
668         operator = newOperator;
669     }
670 
671     constructor() public
672     {
673         operator = msg.sender;
674 
675         lastCommittedBlock = 0;
676         depositNonce = 1;
677         minExitBond = 200000;
678     }
679 
680     // @param blocks       32 byte merkle headers appended in ascending order
681     // @param txnsPerBlock number of transactions per block
682     // @param feesPerBlock amount of fees the validator has collected per block
683     // @param blockNum     the block number of the first header
684     // @notice each block is capped at 2**16-1 transactions
685     function submitBlock(bytes32[] memory headers, uint256[] memory txnsPerBlock, uint256[] memory feePerBlock, uint256 blockNum)
686         public
687         onlyOperator
688     {
689         require(blockNum == lastCommittedBlock.add(1));
690         require(headers.length == txnsPerBlock.length && txnsPerBlock.length == feePerBlock.length);
691 
692         for (uint i = 0; i < headers.length && lastCommittedBlock <= lastBlockNum; i++) {
693             require(headers[i] != bytes32(0) && txnsPerBlock[i] > 0 && txnsPerBlock[i] < feeIndex);
694 
695             lastCommittedBlock = lastCommittedBlock.add(1);
696             plasmaChain[lastCommittedBlock] = plasmaBlock({
697                 header: headers[i],
698                 numTxns: txnsPerBlock[i],
699                 feeAmount: feePerBlock[i],
700                 createdAt: block.timestamp
701             });
702 
703             emit BlockSubmitted(headers[i], lastCommittedBlock, txnsPerBlock[i], feePerBlock[i]);
704         }
705    }
706 
707     // @param owner owner of this deposit
708     function deposit(address owner)
709         public
710         payable
711     {
712         deposits[depositNonce] = depositStruct(owner, msg.value, block.timestamp, block.number);
713         emit Deposit(owner, msg.value, depositNonce, block.number);
714 
715         depositNonce = depositNonce.add(uint256(1));
716     }
717 
718     // @param depositNonce the nonce of the specific deposit
719     function startDepositExit(uint256 nonce, uint256 committedFee)
720         public
721         payable
722         isBonded
723     {
724         require(deposits[nonce].owner == msg.sender);
725         require(deposits[nonce].amount > committedFee);
726         require(depositExits[nonce].state == ExitState.NonExistent);
727 
728         address owner = deposits[nonce].owner;
729         uint256 amount = deposits[nonce].amount;
730         uint256 priority = block.timestamp << 128 | nonce;
731         depositExitQueue.insert(priority);
732         depositExits[nonce] = exit({
733             owner: owner,
734             amount: amount,
735             committedFee: committedFee,
736             createdAt: block.timestamp,
737             position: [0,0,0,nonce],
738             state: ExitState.Pending
739         });
740 
741         emit StartedDepositExit(nonce, owner, amount, committedFee);
742     }
743 
744     // Transaction encoding:
745     // [[Blknum1, TxIndex1, Oindex1, DepositNonce1, Input1ConfirmSig,
746     //   Blknum2, TxIndex2, Oindex2, DepositNonce2, Input2ConfirmSig,
747     //   NewOwner, Denom1, NewOwner, Denom2, Fee],
748     //  [Signature1, Signature2]]
749     //
750     // All integers are padded to 32 bytes. Input's confirm signatures are 130 bytes for each input.
751     // Zero bytes if unapplicable (deposit/fee inputs) Signatures are 65 bytes in length
752     //
753     // @param txBytes rlp encoded transaction
754     // @notice this function will revert if the txBytes are malformed
755     function decodeTransaction(bytes memory txBytes)
756         internal
757         pure
758         returns (RLPReader.RLPItem[] memory txList, RLPReader.RLPItem[] memory sigList, bytes32 txHash)
759     {
760         // entire byte length of the rlp encoded transaction.
761         require(txBytes.length == 811);
762 
763         RLPReader.RLPItem[] memory spendMsg = txBytes.toRlpItem().toList();
764         require(spendMsg.length == 2);
765 
766         txList = spendMsg[0].toList();
767         require(txList.length == 15);
768 
769         sigList = spendMsg[1].toList();
770         require(sigList.length == 2);
771 
772         // bytes the signatures are over
773         txHash = keccak256(spendMsg[0].toRlpBytes());
774     }
775 
776 
777     // @param txPos             location of the transaction [blkNum, txIndex, outputIndex]
778     // @param txBytes           transaction bytes containing the exiting output
779     // @param proof             merkle proof of inclusion in the plasma chain
780     // @param confSig0          confirm signatures sent by the owners of the first input acknowledging the spend.
781     // @param confSig1          confirm signatures sent by the owners of the second input acknowledging the spend (if applicable).
782     // @notice `confirmSignatures` and `ConfirmSig0`/`ConfirmSig1` are unrelated to each other.
783     // @notice `confirmSignatures` is either 65 or 130 bytes in length dependent on if a second input is present
784     // @notice `confirmSignatures` should be empty if the output trying to be exited is a fee output
785     function startTransactionExit(uint256[3] memory txPos, bytes memory txBytes, bytes memory proof, bytes memory confirmSignatures, uint256 committedFee)
786         public
787         payable
788         isBonded
789     {
790         require(txPos[1] < feeIndex);
791         uint256 position = calcPosition(txPos);
792         require(txExits[position].state == ExitState.NonExistent);
793 
794         uint256 amount = startTransactionExitHelper(txPos, txBytes, proof, confirmSignatures);
795         require(amount > committedFee);
796 
797         // calculate the priority of the transaction taking into account the withdrawal delay attack
798         // withdrawal delay attack: https://github.com/FourthState/plasma-mvp-rootchain/issues/42
799         uint256 createdAt = plasmaChain[txPos[0]].createdAt;
800         txExitQueue.insert(SafeMath.max(createdAt.add(1 weeks), block.timestamp) << 128 | position);
801 
802         // write exit to storage
803         txExits[position] = exit({
804             owner: msg.sender,
805             amount: amount,
806             committedFee: committedFee,
807             createdAt: block.timestamp,
808             position: [txPos[0], txPos[1], txPos[2], 0],
809             state: ExitState.Pending
810         });
811 
812         emit StartedTransactionExit(txPos, msg.sender, amount, confirmSignatures, committedFee);
813     }
814 
815     // @returns amount of the exiting transaction
816     // @notice the purpose of this helper was to work around the capped evm stack frame
817     function startTransactionExitHelper(uint256[3] memory txPos, bytes memory txBytes, bytes memory proof, bytes memory confirmSignatures)
818         private
819         view
820         returns (uint256)
821     {
822         bytes32 txHash;
823         RLPReader.RLPItem[] memory txList;
824         RLPReader.RLPItem[] memory sigList;
825         (txList, sigList, txHash) = decodeTransaction(txBytes);
826 
827         uint base = txPos[2].mul(2);
828         require(msg.sender == txList[base.add(10)].toAddress());
829 
830         plasmaBlock memory blk = plasmaChain[txPos[0]];
831 
832         // Validation
833 
834         bytes32 merkleHash = sha256(txBytes);
835         require(merkleHash.checkMembership(txPos[1], blk.header, proof, blk.numTxns));
836 
837         address recoveredAddress;
838         bytes32 confirmationHash = sha256(abi.encodePacked(merkleHash, blk.header));
839 
840         bytes memory sig = sigList[0].toBytes();
841         require(sig.length == 65 && confirmSignatures.length % 65 == 0 && confirmSignatures.length > 0 && confirmSignatures.length <= 130);
842         recoveredAddress = confirmationHash.recover(confirmSignatures.slice(0, 65));
843         require(recoveredAddress != address(0) && recoveredAddress == txHash.recover(sig));
844         if (txList[5].toUintStrict() > 0 || txList[8].toUintStrict() > 0) { // existence of a second input
845             sig = sigList[1].toBytes();
846             require(sig.length == 65 && confirmSignatures.length == 130);
847             recoveredAddress = confirmationHash.recover(confirmSignatures.slice(65, 65));
848             require(recoveredAddress != address(0) && recoveredAddress == txHash.recover(sig));
849         }
850 
851         // check that the UTXO's two direct inputs have not been previously exited
852         require(validateTransactionExitInputs(txList));
853 
854         return txList[base.add(11)].toUintStrict();
855     }
856 
857     // For any attempted exit of an UTXO, validate that the UTXO's two inputs have not
858     // been previously exited or are currently pending an exit.
859     function validateTransactionExitInputs(RLPReader.RLPItem[] memory txList)
860         private
861         view
862         returns (bool)
863     {
864         for (uint256 i = 0; i < 2; i++) {
865             ExitState state;
866             uint256 base = uint256(5).mul(i);
867             uint depositNonce_ = txList[base.add(3)].toUintStrict();
868             if (depositNonce_ == 0) {
869                 uint256 blkNum = txList[base].toUintStrict();
870                 uint256 txIndex = txList[base.add(1)].toUintStrict();
871                 uint256 outputIndex = txList[base.add(2)].toUintStrict();
872                 uint256 position = calcPosition([blkNum, txIndex, outputIndex]);
873                 state = txExits[position].state;
874             } else
875                 state = depositExits[depositNonce_].state;
876 
877             if (state != ExitState.NonExistent && state != ExitState.Challenged)
878                 return false;
879         }
880 
881         return true;
882     }
883 
884     // Validator of any block can call this function to exit the fees collected
885     // for that particular block. The fee exit is added to exit queue with the lowest priority for that block.
886     // In case of the fee UTXO already spent, anyone can challenge the fee exit by providing
887     // the spend of the fee UTXO.
888     // @param blockNumber the block for which the validator wants to exit fees
889     function startFeeExit(uint256 blockNumber, uint256 committedFee)
890         public
891         payable
892         onlyOperator
893         isBonded
894     {
895         plasmaBlock memory blk = plasmaChain[blockNumber];
896         require(blk.header != bytes32(0));
897 
898         uint256 feeAmount = blk.feeAmount;
899 
900         // nonzero fee and prevent and greater than the committed fee if spent.
901         // default value for a fee amount is zero. Will revert if a block for
902         // this number has not been committed
903         require(feeAmount > committedFee);
904 
905         // a fee UTXO has explicitly defined position [blockNumber, 2**16 - 1, 0]
906         uint256 position = calcPosition([blockNumber, feeIndex, 0]);
907         require(txExits[position].state == ExitState.NonExistent);
908 
909         txExitQueue.insert(SafeMath.max(blk.createdAt.add(1 weeks), block.timestamp) << 128 | position);
910 
911         txExits[position] = exit({
912             owner: msg.sender,
913             amount: feeAmount,
914             committedFee: committedFee,
915             createdAt: block.timestamp,
916             position: [blockNumber, feeIndex, 0, 0],
917             state: ExitState.Pending
918         });
919 
920         // pass in empty bytes for confirmSignatures for StartedTransactionExit event.
921         emit StartedTransactionExit([blockNumber, feeIndex, 0], operator, feeAmount, "", 0);
922 }
923 
924     // @param exitingTxPos     position of the invalid exiting transaction [blkNum, txIndex, outputIndex]
925     // @param challengingTxPos position of the challenging transaction [blkNum, txIndex]
926     // @param txBytes          raw transaction bytes of the challenging transaction
927     // @param proof            proof of inclusion for this merkle hash
928     // @param confirmSignature signature used to invalidate the invalid exit. Signature is over (merkleHash, block header)
929     // @notice The operator can challenge an exit which commits an invalid fee by simply passing in empty bytes for confirm signature as they are not needed.
930     //         The committed fee is checked againt the challenging tx bytes
931     function challengeExit(uint256[4] memory exitingTxPos, uint256[2] memory challengingTxPos, bytes memory txBytes, bytes memory proof, bytes memory confirmSignature)
932         public
933     {
934         bytes32 txHash;
935         RLPReader.RLPItem[] memory txList;
936         RLPReader.RLPItem[] memory sigList;
937         (txList, sigList, txHash) = decodeTransaction(txBytes);
938 
939         // `challengingTxPos` is sequentially after `exitingTxPos`
940         require(exitingTxPos[0] < challengingTxPos[0] || (exitingTxPos[0] == challengingTxPos[0] && exitingTxPos[1] < challengingTxPos[1]));
941 
942         // must be a direct spend
943         bool firstInput = exitingTxPos[0] == txList[0].toUintStrict() && exitingTxPos[1] == txList[1].toUintStrict() && exitingTxPos[2] == txList[2].toUintStrict() && exitingTxPos[3] == txList[3].toUintStrict();
944         require(firstInput || exitingTxPos[0] == txList[5].toUintStrict() && exitingTxPos[1] == txList[6].toUintStrict() && exitingTxPos[2] == txList[7].toUintStrict() && exitingTxPos[3] == txList[8].toUintStrict());
945 
946         // transaction to be challenged should have a pending exit
947         exit storage exit_ = exitingTxPos[3] == 0 ? 
948             txExits[calcPosition([exitingTxPos[0], exitingTxPos[1], exitingTxPos[2]])] : depositExits[exitingTxPos[3]];
949         require(exit_.state == ExitState.Pending);
950 
951         plasmaBlock memory blk = plasmaChain[challengingTxPos[0]];
952 
953         bytes32 merkleHash = sha256(txBytes);
954         require(blk.header != bytes32(0) && merkleHash.checkMembership(challengingTxPos[1], blk.header, proof, blk.numTxns));
955 
956         address recoveredAddress;
957         // we check for confirm signatures if:
958         // The exiting tx is a first input and commits the correct fee
959         // OR
960         // The exiting tx is the second input in the challenging transaction
961         //
962         // If this challenge was a fee mismatch, then we check the first transaction signature
963         // to prevent the operator from forging invalid inclusions
964         //
965         // For a fee mismatch, the state becomes `NonExistent` so that the exit can be reopened.
966         // Otherwise, `Challenged` so that the exit can never be opened.
967         if (firstInput && exit_.committedFee != txList[14].toUintStrict()) {
968             bytes memory sig = sigList[0].toBytes();
969             recoveredAddress = txHash.recover(sig);
970             require(sig.length == 65 && recoveredAddress != address(0) && exit_.owner == recoveredAddress);
971 
972             exit_.state = ExitState.NonExistent;
973         } else {
974             bytes32 confirmationHash = sha256(abi.encodePacked(merkleHash, blk.header));
975             recoveredAddress = confirmationHash.recover(confirmSignature);
976             require(confirmSignature.length == 65 && recoveredAddress != address(0) && exit_.owner == recoveredAddress);
977 
978             exit_.state = ExitState.Challenged;
979         }
980 
981         // exit successfully challenged. Award the sender with the bond
982         balances[msg.sender] = balances[msg.sender].add(minExitBond);
983         totalWithdrawBalance = totalWithdrawBalance.add(minExitBond);
984         emit AddedToBalances(msg.sender, minExitBond);
985 
986         emit ChallengedExit(exit_.position, exit_.owner, exit_.amount - exit_.committedFee);
987     }
988 
989     function finalizeDepositExits() public { finalize(depositExitQueue, true); }
990     function finalizeTransactionExits() public { finalize(txExitQueue, false); }
991 
992     // Finalizes exits by iterating through either the depositExitQueue or txExitQueue.
993     // Users can determine the number of exits they're willing to process by varying
994     // the amount of gas allow finalize*Exits() to process.
995     // Each transaction takes < 80000 gas to process.
996     function finalize(uint256[] storage queue, bool isDeposits)
997         private
998     {
999         if (queue.length == 0) return;
1000 
1001         // retrieve the lowest priority and the appropriate exit struct
1002         uint256 priority = queue[0];
1003         exit memory currentExit;
1004         uint256 position;
1005         // retrieve the right 128 bits from the priority to obtain the position
1006         assembly {
1007    	        position := and(priority, div(not(0x0), exp(256, 16)))
1008 		}
1009 
1010         currentExit = isDeposits ? depositExits[position] : txExits[position];
1011 
1012         /*
1013         * Conditions:
1014         *   1. Exits exist
1015         *   2. Exits must be a week old
1016         *   3. Funds must exist for the exit to withdraw
1017         */
1018         uint256 amountToAdd;
1019         uint256 challengePeriod = isDeposits ? 5 days : 1 weeks;
1020         while (block.timestamp.sub(currentExit.createdAt) > challengePeriod &&
1021                plasmaChainBalance() > 0 &&
1022                gasleft() > 80000) {
1023 
1024             // skip currentExit if it is not in 'started/pending' state.
1025             if (currentExit.state != ExitState.Pending) {
1026                 queue.delMin();
1027             } else {
1028                 // reimburse the bond but remove fee allocated for the operator
1029                 amountToAdd = currentExit.amount.add(minExitBond).sub(currentExit.committedFee);
1030                 
1031                 balances[currentExit.owner] = balances[currentExit.owner].add(amountToAdd);
1032                 totalWithdrawBalance = totalWithdrawBalance.add(amountToAdd);
1033 
1034                 if (isDeposits)
1035                     depositExits[position].state = ExitState.Finalized;
1036                 else
1037                     txExits[position].state = ExitState.Finalized;
1038 
1039                 emit FinalizedExit(currentExit.position, currentExit.owner, amountToAdd);
1040                 emit AddedToBalances(currentExit.owner, amountToAdd);
1041 
1042                 // move onto the next oldest exit
1043                 queue.delMin();
1044             }
1045 
1046             if (queue.length == 0) {
1047                 return;
1048             }
1049 
1050             // move onto the next oldest exit
1051             priority = queue[0];
1052             
1053             // retrieve the right 128 bits from the priority to obtain the position
1054             assembly {
1055    			    position := and(priority, div(not(0x0), exp(256, 16)))
1056 		    }
1057              
1058             currentExit = isDeposits ? depositExits[position] : txExits[position];
1059         }
1060     }
1061 
1062     // @notice will revert if the output index is out of bounds
1063     function calcPosition(uint256[3] memory txPos)
1064         private
1065         view
1066         returns (uint256)
1067     {
1068         require(validatePostion([txPos[0], txPos[1], txPos[2], 0]));
1069 
1070         uint256 position = txPos[0].mul(blockIndexFactor).add(txPos[1].mul(txIndexFactor)).add(txPos[2]);
1071         require(position <= 2**128-1); // check for an overflow
1072 
1073         return position;
1074     }
1075 
1076     function validatePostion(uint256[4] memory position)
1077         private
1078         view
1079         returns (bool)
1080     {
1081         uint256 blkNum = position[0];
1082         uint256 txIndex = position[1];
1083         uint256 oIndex = position[2];
1084         uint256 depNonce = position[3];
1085 
1086         if (blkNum > 0) { // utxo input
1087             // uncommitted block
1088             if (blkNum > lastCommittedBlock)
1089                 return false;
1090             // txIndex out of bounds for the block
1091             if (txIndex >= plasmaChain[blkNum].numTxns && txIndex != feeIndex)
1092                 return false;
1093             // fee input must have a zero output index
1094             if (txIndex == feeIndex && oIndex > 0)
1095                 return false;
1096             // deposit nonce must be zero
1097             if (depNonce > 0)
1098                 return false;
1099             // only two outputs
1100             if (oIndex > 1)
1101                 return false;
1102         } else { // deposit or fee input
1103             // deposit input must be zero'd output position
1104             // `blkNum` is not checked as it will fail above
1105             if (depNonce > 0 && (txIndex > 0 || oIndex > 0))
1106                 return false;
1107         }
1108 
1109         return true;
1110     }
1111 
1112     function withdraw()
1113         public
1114         returns (uint256)
1115     {
1116         if (balances[msg.sender] == 0) {
1117             return 0;
1118         }
1119 
1120         uint256 transferAmount = balances[msg.sender];
1121         delete balances[msg.sender];
1122         totalWithdrawBalance = totalWithdrawBalance.sub(transferAmount);
1123 
1124         // will revert the above deletion if it fails
1125         msg.sender.transfer(transferAmount);
1126         return transferAmount;
1127     }
1128 
1129     /*
1130     * Getters
1131     */
1132 
1133     function plasmaChainBalance()
1134         public
1135         view
1136         returns (uint)
1137     {
1138         // takes into accounts the failed withdrawals
1139         return address(this).balance - totalWithdrawBalance;
1140     }
1141 
1142     function balanceOf(address _address)
1143         public
1144         view
1145         returns (uint256)
1146     {
1147         return balances[_address];
1148     }
1149 
1150     function txQueueLength()
1151         public
1152         view
1153         returns (uint)
1154     {
1155         return txExitQueue.length;
1156     }
1157 
1158     function depositQueueLength()
1159         public 
1160         view
1161         returns (uint)
1162     {   
1163         return depositExitQueue.length;
1164     }
1165 }