1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Interface of the ERC165 standard, as defined in the
91  * https://eips.ethereum.org/EIPS/eip-165[EIP].
92  *
93  * Implementers can declare support of contract interfaces, which can then be
94  * queried by others ({ERC165Checker}).
95  *
96  * For an implementation, see {ERC165}.
97  */
98 interface IERC165 {
99     /**
100      * @dev Returns true if this contract implements the interface defined by
101      * `interfaceId`. See the corresponding
102      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
103      * to learn more about how these ids are created.
104      *
105      * This function call must use less than 30 000 gas.
106      */
107     function supportsInterface(bytes4 interfaceId) external view returns (bool);
108 }
109 
110 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Required interface of an ERC721 compliant contract.
116  */
117 interface IERC721 is IERC165 {
118     /**
119      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122 
123     /**
124      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
125      */
126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
130      */
131     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
132 
133     /**
134      * @dev Returns the number of tokens in ``owner``'s account.
135      */
136     function balanceOf(address owner) external view returns (uint256 balance);
137 
138     /**
139      * @dev Returns the owner of the `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function ownerOf(uint256 tokenId) external view returns (address owner);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
149      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Transfers `tokenId` token from `from` to `to`.
169      *
170      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
189      * The approval is cleared when the token is transferred.
190      *
191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
192      *
193      * Requirements:
194      *
195      * - The caller must own the token or be an approved operator.
196      * - `tokenId` must exist.
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address to, uint256 tokenId) external;
201 
202     /**
203      * @dev Returns the account approved for `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function getApproved(uint256 tokenId) external view returns (address operator);
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
225      *
226      * See {setApprovalForAll}
227      */
228     function isApprovedForAll(address owner, address operator) external view returns (bool);
229 
230     /**
231      * @dev Safely transfers `tokenId` token from `from` to `to`.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must exist and be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
240      *
241      * Emits a {Transfer} event.
242      */
243     function safeTransferFrom(
244         address from,
245         address to,
246         uint256 tokenId,
247         bytes calldata data
248     ) external;
249 }
250 
251 // File @openzeppelin/contracts/utils/math/Math.sol@v4.2.0
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Standard math utilities missing in the Solidity language.
257  */
258 library Math {
259     /**
260      * @dev Returns the largest of two numbers.
261      */
262     function max(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a >= b ? a : b;
264     }
265 
266     /**
267      * @dev Returns the smallest of two numbers.
268      */
269     function min(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a < b ? a : b;
271     }
272 
273     /**
274      * @dev Returns the average of two numbers. The result is rounded towards
275      * zero.
276      */
277     function average(uint256 a, uint256 b) internal pure returns (uint256) {
278         // (a + b) / 2 can overflow, so we distribute.
279         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
280     }
281 
282     /**
283      * @dev Returns the ceiling of the division of two numbers.
284      *
285      * This differs from standard division with `/` in that it rounds up instead
286      * of rounding down.
287      */
288     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
289         // (a + b - 1) / b can overflow on addition, so we distribute.
290         return a / b + (a % b == 0 ? 0 : 1);
291     }
292 }
293 
294 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.2.0
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
300  * checks.
301  *
302  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
303  * easily result in undesired exploitation or bugs, since developers usually
304  * assume that overflows raise errors. `SafeCast` restores this intuition by
305  * reverting the transaction when such an operation overflows.
306  *
307  * Using this library instead of the unchecked operations eliminates an entire
308  * class of bugs, so it's recommended to use it always.
309  *
310  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
311  * all math on `uint256` and `int256` and then downcasting.
312  */
313 library SafeCast {
314     /**
315      * @dev Returns the downcasted uint224 from uint256, reverting on
316      * overflow (when the input is greater than largest uint224).
317      *
318      * Counterpart to Solidity's `uint224` operator.
319      *
320      * Requirements:
321      *
322      * - input must fit into 224 bits
323      */
324     function toUint224(uint256 value) internal pure returns (uint224) {
325         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
326         return uint224(value);
327     }
328 
329     /**
330      * @dev Returns the downcasted uint128 from uint256, reverting on
331      * overflow (when the input is greater than largest uint128).
332      *
333      * Counterpart to Solidity's `uint128` operator.
334      *
335      * Requirements:
336      *
337      * - input must fit into 128 bits
338      */
339     function toUint128(uint256 value) internal pure returns (uint128) {
340         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
341         return uint128(value);
342     }
343 
344     /**
345      * @dev Returns the downcasted uint96 from uint256, reverting on
346      * overflow (when the input is greater than largest uint96).
347      *
348      * Counterpart to Solidity's `uint96` operator.
349      *
350      * Requirements:
351      *
352      * - input must fit into 96 bits
353      */
354     function toUint96(uint256 value) internal pure returns (uint96) {
355         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
356         return uint96(value);
357     }
358 
359     /**
360      * @dev Returns the downcasted uint64 from uint256, reverting on
361      * overflow (when the input is greater than largest uint64).
362      *
363      * Counterpart to Solidity's `uint64` operator.
364      *
365      * Requirements:
366      *
367      * - input must fit into 64 bits
368      */
369     function toUint64(uint256 value) internal pure returns (uint64) {
370         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
371         return uint64(value);
372     }
373 
374     /**
375      * @dev Returns the downcasted uint32 from uint256, reverting on
376      * overflow (when the input is greater than largest uint32).
377      *
378      * Counterpart to Solidity's `uint32` operator.
379      *
380      * Requirements:
381      *
382      * - input must fit into 32 bits
383      */
384     function toUint32(uint256 value) internal pure returns (uint32) {
385         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
386         return uint32(value);
387     }
388 
389     /**
390      * @dev Returns the downcasted uint16 from uint256, reverting on
391      * overflow (when the input is greater than largest uint16).
392      *
393      * Counterpart to Solidity's `uint16` operator.
394      *
395      * Requirements:
396      *
397      * - input must fit into 16 bits
398      */
399     function toUint16(uint256 value) internal pure returns (uint16) {
400         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
401         return uint16(value);
402     }
403 
404     /**
405      * @dev Returns the downcasted uint8 from uint256, reverting on
406      * overflow (when the input is greater than largest uint8).
407      *
408      * Counterpart to Solidity's `uint8` operator.
409      *
410      * Requirements:
411      *
412      * - input must fit into 8 bits.
413      */
414     function toUint8(uint256 value) internal pure returns (uint8) {
415         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
416         return uint8(value);
417     }
418 
419     /**
420      * @dev Converts a signed int256 into an unsigned uint256.
421      *
422      * Requirements:
423      *
424      * - input must be greater than or equal to 0.
425      */
426     function toUint256(int256 value) internal pure returns (uint256) {
427         require(value >= 0, "SafeCast: value must be positive");
428         return uint256(value);
429     }
430 
431     /**
432      * @dev Returns the downcasted int128 from int256, reverting on
433      * overflow (when the input is less than smallest int128 or
434      * greater than largest int128).
435      *
436      * Counterpart to Solidity's `int128` operator.
437      *
438      * Requirements:
439      *
440      * - input must fit into 128 bits
441      *
442      * _Available since v3.1._
443      */
444     function toInt128(int256 value) internal pure returns (int128) {
445         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
446         return int128(value);
447     }
448 
449     /**
450      * @dev Returns the downcasted int64 from int256, reverting on
451      * overflow (when the input is less than smallest int64 or
452      * greater than largest int64).
453      *
454      * Counterpart to Solidity's `int64` operator.
455      *
456      * Requirements:
457      *
458      * - input must fit into 64 bits
459      *
460      * _Available since v3.1._
461      */
462     function toInt64(int256 value) internal pure returns (int64) {
463         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
464         return int64(value);
465     }
466 
467     /**
468      * @dev Returns the downcasted int32 from int256, reverting on
469      * overflow (when the input is less than smallest int32 or
470      * greater than largest int32).
471      *
472      * Counterpart to Solidity's `int32` operator.
473      *
474      * Requirements:
475      *
476      * - input must fit into 32 bits
477      *
478      * _Available since v3.1._
479      */
480     function toInt32(int256 value) internal pure returns (int32) {
481         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
482         return int32(value);
483     }
484 
485     /**
486      * @dev Returns the downcasted int16 from int256, reverting on
487      * overflow (when the input is less than smallest int16 or
488      * greater than largest int16).
489      *
490      * Counterpart to Solidity's `int16` operator.
491      *
492      * Requirements:
493      *
494      * - input must fit into 16 bits
495      *
496      * _Available since v3.1._
497      */
498     function toInt16(int256 value) internal pure returns (int16) {
499         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
500         return int16(value);
501     }
502 
503     /**
504      * @dev Returns the downcasted int8 from int256, reverting on
505      * overflow (when the input is less than smallest int8 or
506      * greater than largest int8).
507      *
508      * Counterpart to Solidity's `int8` operator.
509      *
510      * Requirements:
511      *
512      * - input must fit into 8 bits.
513      *
514      * _Available since v3.1._
515      */
516     function toInt8(int256 value) internal pure returns (int8) {
517         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
518         return int8(value);
519     }
520 
521     /**
522      * @dev Converts an unsigned uint256 into a signed int256.
523      *
524      * Requirements:
525      *
526      * - input must be less than or equal to maxInt256.
527      */
528     function toInt256(uint256 value) internal pure returns (int256) {
529         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
530         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
531         return int256(value);
532     }
533 }
534 
535 // File contracts/TheSevensDojo.sol
536 
537 pragma solidity =0.8.7;
538 
539 contract TheSevensDojo {
540     using SafeCast for uint256;
541 
542     event Initialized(
543         address sevensToken,
544         address zeniToken,
545         address zeniTokenHolder,
546         uint256 rewardPerTokenPerSecond,
547         uint256 startTime,
548         uint256 endTime
549     );
550     event Staked(address indexed staker, uint256 indexed tokenId, uint256 indexed timestamp);
551     event Unstaked(address indexed staker, uint256 indexed tokenId, uint256 indexed timestamp);
552     event ClaimedReward(address indexed staker, uint256 indexed amount, uint256 indexed timestamp);
553 
554     struct StakerInfo {
555         uint32 lastActionTime;
556         uint32 stakedCount;
557         uint128 accumulatedReward;
558     }
559 
560     IERC721 public sevensToken;
561     IERC20 public zeniToken;
562     address public zeniTokenHolder;
563     uint256 public rewardPerTokenPerSecond;
564     uint256 public startTime;
565     uint256 public endTime;
566 
567     mapping(address => StakerInfo) public stakerInfos;
568     mapping(uint256 => address) public tokenOwners;
569 
570     modifier onlyStarted() {
571         require(block.timestamp >= startTime, "TheSevensDojo: not started");
572         _;
573     }
574 
575     modifier onlyNotEnded() {
576         require(block.timestamp < endTime, "TheSevensDojo: already ended");
577         _;
578     }
579 
580     function getReward(address staker) external view returns (uint256) {
581         StakerInfo memory stakerInfo = stakerInfos[staker];
582         return
583             uint256(stakerInfo.accumulatedReward) +
584             calculateEffectiveTimeElapsed(stakerInfo.lastActionTime) *
585             uint256(stakerInfo.stakedCount) *
586             rewardPerTokenPerSecond;
587     }
588 
589     constructor(
590         IERC721 _sevensToken,
591         IERC20 _zeniToken,
592         address _zeniTokenHolder,
593         uint256 _rewardPerTokenPerSecond,
594         uint256 _startTime,
595         uint256 _endTime
596     ) {
597         require(address(_sevensToken) != address(0), "TheSevensDojo: zero address");
598         require(address(_zeniToken) != address(0), "TheSevensDojo: zero address");
599         require(address(_zeniTokenHolder) != address(0), "TheSevensDojo: zero address");
600         require(_rewardPerTokenPerSecond > 0, "TheSevensDojo: reward per second cannot be zero");
601         require(_startTime > block.timestamp && _endTime > _startTime, "TheSevensDojo: invalid time range");
602 
603         sevensToken = _sevensToken;
604         zeniToken = _zeniToken;
605         zeniTokenHolder = _zeniTokenHolder;
606         rewardPerTokenPerSecond = _rewardPerTokenPerSecond;
607         startTime = _startTime;
608         endTime = _endTime;
609 
610         emit Initialized(
611             address(sevensToken),
612             address(zeniToken),
613             zeniTokenHolder,
614             rewardPerTokenPerSecond,
615             startTime,
616             endTime
617         );
618     }
619 
620     function stake(uint256[] calldata tokenIds) external onlyStarted onlyNotEnded {
621         for (uint256 ind = 0; ind < tokenIds.length; ind++) {
622             doStake(msg.sender, tokenIds[ind]);
623         }
624     }
625 
626     function unstake(uint256[] calldata tokenIds) external onlyStarted {
627         for (uint256 ind = 0; ind < tokenIds.length; ind++) {
628             doUnstake(msg.sender, tokenIds[ind]);
629         }
630     }
631 
632     function claimRewards() external {
633         doClaimRewards(msg.sender);
634     }
635 
636     function doStake(address staker, uint256 tokenId) private {
637         settleRewards(staker);
638 
639         stakerInfos[staker].stakedCount += 1;
640         tokenOwners[tokenId] = staker;
641 
642         sevensToken.transferFrom(staker, address(this), tokenId);
643 
644         emit Staked(staker, tokenId, block.timestamp);
645     }
646 
647     function doUnstake(address staker, uint256 tokenId) private {
648         settleRewards(staker);
649 
650         require(tokenOwners[tokenId] == staker, "TheSevensDojo: not token owner");
651 
652         stakerInfos[staker].stakedCount -= 1;
653         delete tokenOwners[tokenId];
654 
655         sevensToken.transferFrom(address(this), staker, tokenId);
656 
657         emit Unstaked(staker, tokenId, block.timestamp);
658     }
659 
660     function doClaimRewards(address staker) private {
661         settleRewards(staker);
662 
663         uint256 accumulatedRewards = uint256(stakerInfos[staker].accumulatedReward);
664         require(accumulatedRewards > 0, "TheSevensDojo: no reward to claim");
665 
666         stakerInfos[staker].accumulatedReward = 0;
667 
668         zeniToken.transferFrom(zeniTokenHolder, staker, accumulatedRewards);
669 
670         emit ClaimedReward(staker, accumulatedRewards, block.timestamp);
671     }
672 
673     function settleRewards(address staker) private {
674         uint32 blockTimestamp = block.timestamp.toUint32();
675         StakerInfo memory stakerInfo = stakerInfos[staker];
676 
677         // No need to update anything if no time has elapsed since last time
678         if (stakerInfo.lastActionTime != blockTimestamp) {
679             stakerInfos[staker].lastActionTime = block.timestamp.toUint32();
680 
681             // Only update rewards if anything was staked
682             if (stakerInfo.stakedCount > 0) {
683                 stakerInfos[staker].accumulatedReward =
684                     stakerInfo.accumulatedReward +
685                     calculateEffectiveTimeElapsed(stakerInfo.lastActionTime).toUint128() *
686                     uint128(stakerInfo.stakedCount) *
687                     rewardPerTokenPerSecond.toUint128();
688             }
689         }
690     }
691 
692     function calculateEffectiveTimeElapsed(uint32 lastActionTime) private view returns (uint256) {
693         uint256 effectiveTimestamp = Math.min(block.timestamp, endTime);
694         return effectiveTimestamp > lastActionTime ? effectiveTimestamp - lastActionTime : 0;
695     }
696 }