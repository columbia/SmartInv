1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address private _owner;
78 
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() internal {
89     _owner = msg.sender;
90     emit OwnershipTransferred(address(0), _owner);
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner());
105     _;
106   }
107 
108   /**
109    * @return true if `msg.sender` is the owner of the contract.
110    */
111   function isOwner() public view returns(bool) {
112     return msg.sender == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipTransferred(_owner, address(0));
123     _owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     _transferOwnership(newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address newOwner) internal {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(_owner, newOwner);
141     _owner = newOwner;
142   }
143 }
144 
145 // File: solidity-rlp/contracts/RLPReader.sol
146 
147 /*
148 * @author Hamdi Allam hamdi.allam97@gmail.com
149 * Please reach out with any questions or concerns
150 */
151 pragma solidity ^0.4.24;
152 
153 library RLPReader {
154     uint8 constant STRING_SHORT_START = 0x80;
155     uint8 constant STRING_LONG_START  = 0xb8;
156     uint8 constant LIST_SHORT_START   = 0xc0;
157     uint8 constant LIST_LONG_START    = 0xf8;
158 
159     uint8 constant WORD_SIZE = 32;
160 
161     struct RLPItem {
162         uint len;
163         uint memPtr;
164     }
165 
166     /*
167     * @param item RLP encoded bytes
168     */
169     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
170         if (item.length == 0) 
171             return RLPItem(0, 0);
172 
173         uint memPtr;
174         assembly {
175             memPtr := add(item, 0x20)
176         }
177 
178         return RLPItem(item.length, memPtr);
179     }
180 
181     /*
182     * @param item RLP encoded list in bytes
183     */
184     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory result) {
185         require(isList(item));
186 
187         uint items = numItems(item);
188         result = new RLPItem[](items);
189 
190         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
191         uint dataLen;
192         for (uint i = 0; i < items; i++) {
193             dataLen = _itemLength(memPtr);
194             result[i] = RLPItem(dataLen, memPtr); 
195             memPtr = memPtr + dataLen;
196         }
197     }
198 
199     /*
200     * Helpers
201     */
202 
203     // @return indicator whether encoded payload is a list. negate this function call for isData.
204     function isList(RLPItem memory item) internal pure returns (bool) {
205         uint8 byte0;
206         uint memPtr = item.memPtr;
207         assembly {
208             byte0 := byte(0, mload(memPtr))
209         }
210 
211         if (byte0 < LIST_SHORT_START)
212             return false;
213         return true;
214     }
215 
216     // @return number of payload items inside an encoded list.
217     function numItems(RLPItem memory item) internal pure returns (uint) {
218         uint count = 0;
219         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
220         uint endPtr = item.memPtr + item.len;
221         while (currPtr < endPtr) {
222            currPtr = currPtr + _itemLength(currPtr); // skip over an item
223            count++;
224         }
225 
226         return count;
227     }
228 
229     // @return entire rlp item byte length
230     function _itemLength(uint memPtr) internal pure returns (uint len) {
231         uint byte0;
232         assembly {
233             byte0 := byte(0, mload(memPtr))
234         }
235 
236         if (byte0 < STRING_SHORT_START)
237             return 1;
238         
239         else if (byte0 < STRING_LONG_START)
240             return byte0 - STRING_SHORT_START + 1;
241 
242         else if (byte0 < LIST_SHORT_START) {
243             assembly {
244                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
245                 memPtr := add(memPtr, 1) // skip over the first byte
246                 
247                 /* 32 byte word size */
248                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
249                 len := add(dataLen, add(byteLen, 1))
250             }
251         }
252 
253         else if (byte0 < LIST_LONG_START) {
254             return byte0 - LIST_SHORT_START + 1;
255         } 
256 
257         else {
258             assembly {
259                 let byteLen := sub(byte0, 0xf7)
260                 memPtr := add(memPtr, 1)
261 
262                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
263                 len := add(dataLen, add(byteLen, 1))
264             }
265         }
266     }
267 
268     // @return number of bytes until the data
269     function _payloadOffset(uint memPtr) internal pure returns (uint) {
270         uint byte0;
271         assembly {
272             byte0 := byte(0, mload(memPtr))
273         }
274 
275         if (byte0 < STRING_SHORT_START) 
276             return 0;
277         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
278             return 1;
279         else if (byte0 < LIST_SHORT_START)  // being explicit
280             return byte0 - (STRING_LONG_START - 1) + 1;
281         else
282             return byte0 - (LIST_LONG_START - 1) + 1;
283     }
284 
285     /** RLPItem conversions into data types **/
286 
287     // @returns raw rlp encoding in bytes
288     function toRlpBytes(RLPItem memory item) internal pure returns (bytes) {
289         bytes memory result = new bytes(item.len);
290         
291         uint ptr;
292         assembly {
293             ptr := add(0x20, result)
294         }
295 
296         copy(item.memPtr, ptr, item.len);
297         return result;
298     }
299 
300     function toBoolean(RLPItem memory item) internal pure returns (bool) {
301         require(item.len == 1, "Invalid RLPItem. Booleans are encoded in 1 byte");
302         uint result;
303         uint memPtr = item.memPtr;
304         assembly {
305             result := byte(0, mload(memPtr))
306         }
307 
308         return result == 0 ? false : true;
309     }
310 
311     function toAddress(RLPItem memory item) internal pure returns (address) {
312         // 1 byte for the length prefix according to RLP spec
313         require(item.len <= 21, "Invalid RLPItem. Addresses are encoded in 20 bytes or less");
314 
315         return address(toUint(item));
316     }
317 
318     function toUint(RLPItem memory item) internal pure returns (uint) {
319         uint offset = _payloadOffset(item.memPtr);
320         uint len = item.len - offset;
321         uint memPtr = item.memPtr + offset;
322 
323         uint result;
324         assembly {
325             result := div(mload(memPtr), exp(256, sub(32, len))) // shift to the correct location
326         }
327 
328         return result;
329     }
330 
331     function toBytes(RLPItem memory item) internal pure returns (bytes) {
332         uint offset = _payloadOffset(item.memPtr);
333         uint len = item.len - offset; // data length
334         bytes memory result = new bytes(len);
335 
336         uint destPtr;
337         assembly {
338             destPtr := add(0x20, result)
339         }
340 
341         copy(item.memPtr + offset, destPtr, len);
342         return result;
343     }
344 
345 
346     /*
347     * @param src Pointer to source
348     * @param dest Pointer to destination
349     * @param len Amount of memory to copy from the source
350     */
351     function copy(uint src, uint dest, uint len) internal pure {
352         // copy as many word sizes as possible
353         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
354             assembly {
355                 mstore(dest, mload(src))
356             }
357 
358             src += WORD_SIZE;
359             dest += WORD_SIZE;
360         }
361 
362         // left over bytes. Mask is used to remove unwanted bytes from the word
363         uint mask = 256 ** (WORD_SIZE - len) - 1;
364         assembly {
365             let srcpart := and(mload(src), not(mask)) // zero out src
366             let destpart := and(mload(dest), mask) // retrieve the bytes
367             mstore(dest, or(destpart, srcpart))
368         }
369     }
370 }
371 
372 // File: contracts/BetStorage.sol
373 
374 /**
375  * @title ClashHash
376  * This product is protected under license.  Any unauthorized copy, modification, or use without
377  * express written consent from the creators is prohibited.
378  */
379 
380 
381 
382 
383 contract BetStorage is Ownable {
384     using SafeMath for uint256;
385 
386     mapping(address => mapping(address => uint256)) public bets;
387     mapping(address => uint256) public betsSumByOption;
388     address public wonOption;
389 
390     event BetAdded(address indexed user, address indexed option, uint256 value);
391     event Finalized(address indexed option);
392     event RewardClaimed(address indexed user, uint256 reward);
393 
394     function addBet(address user, address option) public payable onlyOwner {
395         require(msg.value > 0, "Empty bet is not allowed");
396         require(option != address(0), "Option should not be zero");
397 
398         bets[user][option] = bets[user][option].add(msg.value);
399         betsSumByOption[option] = betsSumByOption[option].add(msg.value);
400         emit BetAdded(user, option, msg.value);
401     }
402 
403     function finalize(address option, address admin) public onlyOwner {
404         require(wonOption == address(0), "Finalization could be called only once");
405         require(option != address(0), "Won option should not be zero");
406 
407         wonOption = option;
408         emit Finalized(option);
409 
410         if (betsSumByOption[option] == 0) {		
411             selfdestruct(admin);		
412         }		
413     }
414 
415     function rewardFor(address user) public view returns(uint256 reward) {
416         if (bets[user][wonOption] > 0) {
417             reward = address(this).balance
418                 .mul(bets[user][wonOption])
419                 .div(betsSumByOption[wonOption]);
420         }
421     }
422 
423     function rewards(
424         address user,
425         address referrer,
426         uint256 referrerFee,
427         uint256 adminFee
428     )
429         public
430         view
431         returns(uint256 userReward, uint256 referrerReward, uint256 adminReward)
432     {
433         userReward = rewardFor(user);
434         adminReward = userReward.sub(bets[user][wonOption]).mul(adminFee).div(100);
435 
436         if (referrer != address(0)) {
437             referrerReward = adminReward.mul(referrerFee).div(100);
438             adminReward = adminReward.sub(referrerReward);
439         }
440 
441         userReward = userReward.sub(adminReward).sub(referrerReward);
442     }
443 
444     function claimReward(
445         address user,
446         address admin,
447         uint256 adminFee,
448         address referrer,
449         uint256 referrerFee
450     )
451         public
452         onlyOwner
453     {
454         require(wonOption != address(0), "Round not yet finalized");
455 
456         (uint256 userReward, uint256 referrerReward, uint256 adminReward) = rewards(
457             user,
458             referrer,
459             referrerFee,
460             adminFee
461         );
462         require(userReward > 0, "Reward was claimed previously or never existed");
463         
464         betsSumByOption[wonOption] = betsSumByOption[wonOption].sub(bets[user][wonOption]);
465         bets[user][wonOption] = 0;
466 
467         if (referrerReward > 0) {
468             referrer.send(referrerReward);
469         }
470 
471         if (adminReward > 0) {
472             admin.send(adminReward);
473         }
474 
475         user.transfer(userReward);
476         emit RewardClaimed(user, userReward);
477 
478         if (betsSumByOption[wonOption] == 0) {
479             selfdestruct(admin);
480         }
481     }
482 }
483 
484 // File: contracts/BlockHash.sol
485 
486 contract BlockHash {
487     using SafeMath for uint256;
488     using RLPReader for RLPReader.RLPItem;
489 
490     mapping (uint256 => bytes32) private _hashes;
491 
492     function blockhashes(
493         uint256 blockNumber
494     )
495         public
496         view
497         returns(bytes32)
498     {
499         if (blockNumber >= block.number.sub(256)) {
500             return blockhash(blockNumber);
501         }
502 
503         return _hashes[blockNumber];
504     }
505 
506     function addBlocks(
507         uint256 blockNumber,
508         bytes blocksData,
509         uint256[] starts
510     )
511         public
512     {
513         require(starts.length > 0 && starts[starts.length - 1] == blocksData.length, "Wrong starts argument");
514 
515         bytes32 expectedHash = blockhashes(blockNumber);
516         for (uint i = 0; i < starts.length - 1; i++) {
517             uint256 offset = starts[i];
518             uint256 length = starts[i + 1].sub(starts[i]);
519             bytes32 result;
520             uint256 ptr;
521             assembly {
522                 ptr := add(add(blocksData, 0x20), offset)
523                 result := keccak256(ptr, length)
524             }
525 
526             require(result == expectedHash, "Blockhash didn't match");
527             expectedHash = bytes32(RLPReader.RLPItem({len: length, memPtr: ptr}).toList()[0].toUint());
528         }
529         
530         uint256 index = blockNumber.add(1).sub(starts.length);
531         if (_hashes[index] == 0) {
532             _hashes[index] = expectedHash;
533         }
534     }
535 }
536 
537 // File: contracts/ClashHash.sol
538 
539 /**
540  * @title ClashHash
541  * This product is protected under license.  Any unauthorized copy, modification, or use without
542  * express written consent from the creators is prohibited.
543  */
544 
545 contract ClashHash is Ownable {
546     using SafeMath for uint256;
547     using RLPReader for bytes;
548     using RLPReader for RLPReader.RLPItem;
549 
550     struct Round {
551         BetStorage records;
552         uint256 betsCount;
553         uint256 totalReward;
554         address winner;
555     }
556 
557     uint256 public minBet = 0.001 ether;
558     uint256 constant public MIN_BLOCKS_BEFORE_ROUND = 10;
559     uint256 constant public MIN_BLOCKS_AFTER_ROUND = 10;
560     uint256 constant public MAX_BLOCKS_AFTER_ROUND = 256;
561 
562     uint256 public adminFee = 5;
563     uint256 public referrerFee = 50;
564 
565     mapping(address => address) public referrers;
566     mapping(uint256 => Round) public rounds;
567     BlockHash public _blockStorage;
568 
569     //
570 
571     event RoundCreated(uint256 indexed blockNumber, address contractAddress);
572     event RoundBetAdded(uint256 indexed blockNumber, address indexed user, address indexed option, uint256 value);
573     event RoundFinalized(uint256 indexed blockNumber, address indexed option);
574     event RewardClaimed(uint256 indexed blockNumber, address indexed user, address indexed winner, uint256 reward);
575 
576     event NewReferral(address indexed user, address indexed referrer);
577     event ReferralReward(address indexed user, address indexed referrer, uint256 value);
578 
579     event AdminFeeUpdate(uint256 oldFee, uint256 newFee);
580     event ReferrerFeeUpdate(uint256 oldFee, uint256 newFee);
581     event MinBetUpdate(uint256 oldMinBet, uint256 newMinBet);
582 
583     //
584 
585     constructor (BlockHash blockStorage) public {
586         _blockStorage = blockStorage;
587     }
588 
589     //
590 
591     function setReferrerFee(uint256 newFee) public onlyOwner {
592         emit ReferrerFeeUpdate(referrerFee, newFee);
593         referrerFee = newFee;
594     }
595 
596     function setAdminFee(uint256 newFee) public onlyOwner {
597         emit AdminFeeUpdate(adminFee, newFee);
598         adminFee = newFee;
599     }
600 
601     function setMinBet(uint256 newMinBet) public onlyOwner {
602         emit MinBetUpdate(minBet, newMinBet);
603         minBet = newMinBet;
604     }
605 
606     /**
607      * @param referrer Who has invited the user.
608      */
609     function addReferral(address referrer) public {
610         require(referrer != address(0), "Invalid referrer address");
611         require(referrer != msg.sender, "Different addresses required");
612         require(referrers[msg.sender] == address(0), "User has referrer already");
613 
614         referrers[msg.sender] = referrer;
615         emit NewReferral(msg.sender, referrer);
616     }
617 
618     function addBet(uint256 blockNumber, address option) public payable {
619         require(msg.value >= minBet, "Bet amount is too low");
620         require(block.number <= blockNumber.sub(MIN_BLOCKS_BEFORE_ROUND), "It's too late");
621 
622         Round storage round = rounds[blockNumber];
623         if (round.records == address(0)) {
624             round.records = new BetStorage();
625             emit RoundCreated(blockNumber, round.records);
626         }
627 
628         round.betsCount += 1;
629         round.totalReward = round.totalReward.add(msg.value);
630         round.records.addBet.value(msg.value)(msg.sender, option);
631 
632         emit RoundBetAdded(
633             blockNumber,
634             msg.sender,
635             option,
636             msg.value
637         );
638     }
639 
640     function addBetWithReferrer(
641         uint256 blockNumber,
642         address option,
643         address referrer
644     )
645         public
646         payable
647     {
648         addReferral(referrer);
649         addBet(blockNumber, option);
650     }
651 
652     function claimRewardWithBlockData(uint256 blockNumber, bytes blockData) public {
653         if (blockData.length > 0 && rounds[blockNumber].winner == address(0)) {
654             addBlockData(blockNumber, blockData);
655         }
656 
657         claimRewardForUser(blockNumber, msg.sender);
658     }
659 
660     function claimRewardForUser(uint256 blockNumber, address user) public {
661         Round storage round = rounds[blockNumber];
662         require(round.winner != address(0), "Round not yet finished");
663         require(address(round.records).balance > 0, "Round prizes are already distributed");
664 
665         (uint256 userReward, uint256 referrerReward,) = round.records.rewards(
666             user,
667             referrers[user],
668             referrerFee,
669             adminFee
670         );
671         round.records.claimReward(user, owner(), adminFee, referrers[user], referrerFee);
672 
673         emit RewardClaimed(blockNumber, user, round.winner, userReward);
674 
675         if (referrerReward > 0) {
676             emit ReferralReward(user, referrers[user], referrerReward);
677         }
678     }
679 
680     function addBlockData(uint256 blockNumber, bytes blockData) public {
681         Round storage round = rounds[blockNumber];
682 
683         require(round.winner == address(0), "Winner was already submitted");
684         require(block.number <= blockNumber.add(MAX_BLOCKS_AFTER_ROUND), "It's too late, 256 blocks gone");
685         require(block.number >= blockNumber.add(MIN_BLOCKS_AFTER_ROUND), "Wait at least 10 blocks");
686 
687         address blockBeneficiary = _readBlockBeneficiary(blockNumber, blockData);
688 
689         round.winner = blockBeneficiary;
690         round.records.finalize(blockBeneficiary, owner());
691         emit RoundFinalized(blockNumber, blockBeneficiary);
692     }
693 
694     function _readBlockBeneficiary(
695         uint256 blockNumber,
696         bytes blockData
697     )
698         internal
699         view
700         returns(address)
701     {
702         require(keccak256(blockData) == _blockStorage.blockhashes(blockNumber), "Block data isn't valid");
703         RLPReader.RLPItem[] memory items = blockData.toRlpItem().toList();
704         return items[2].toAddress();
705     }
706 }