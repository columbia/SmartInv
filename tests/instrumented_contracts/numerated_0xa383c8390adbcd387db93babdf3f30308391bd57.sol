1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.1;
3 
4 // File: contracts/staking/StakingInterface.sol
5 
6 interface StakingInterface {
7     function stake(address token, uint128 amount) external;
8 
9     function withdraw(address token, uint128 amount) external;
10 
11     function receiveReward(address token) external returns (uint256 rewards);
12 
13     function changeStakeTarget(
14         address oldTarget,
15         address newTarget,
16         uint128 amount
17     ) external;
18 
19     function getStakingTokenAddress() external view returns (address);
20 
21     function getTokenInfo(address token)
22         external
23         view
24         returns (
25             uint256 currentTerm,
26             uint256 latestTerm,
27             uint256 totalRemainingRewards,
28             uint256 currentReward,
29             uint256 nextTermRewards,
30             uint128 currentStaking,
31             uint128 nextTermStaking
32         );
33 
34     function getConfigs() external view returns (uint256 startTimestamp, uint256 termInterval);
35 
36     function getStakingDestinations(address account) external view returns (address[] memory);
37 
38     function getTermInfo(address token, uint256 term)
39         external
40         view
41         returns (
42             uint128 stakeAdd,
43             uint128 stakeSum,
44             uint256 rewardSum
45         );
46 
47     function getAccountInfo(address token, address account)
48         external
49         view
50         returns (
51             uint256 userTerm,
52             uint256 stakeAmount,
53             uint128 nextAddedStakeAmount,
54             uint256 currentReward,
55             uint256 nextLatestTermUserRewards,
56             uint128 depositAmount,
57             uint128 withdrawableStakingAmount
58         );
59 }
60 
61 // File: @openzeppelin/contracts/math/SafeMath.sol
62 
63 /**
64  * @dev Wrappers over Solidity's arithmetic operations with added overflow
65  * checks.
66  *
67  * Arithmetic operations in Solidity wrap on overflow. This can easily result
68  * in bugs, because programmers usually assume that an overflow raises an
69  * error, which is the standard behavior in high level programming languages.
70  * `SafeMath` restores this intuition by reverting the transaction when an
71  * operation overflows.
72  *
73  * Using this library instead of the unchecked operations eliminates an entire
74  * class of bugs, so it's recommended to use it always.
75  */
76 library SafeMath {
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the subtraction of two unsigned integers, reverting on
96      * overflow (when the result is negative).
97      *
98      * Counterpart to Solidity's `-` operator.
99      *
100      * Requirements:
101      *
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b <= a, errorMessage);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * Reverts when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return mod(a, b, "SafeMath: modulo by zero");
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts with custom message when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b != 0, errorMessage);
215         return a % b;
216     }
217 }
218 
219 // File: contracts/staking/StakingVote.sol
220 
221 
222 contract StakingVote {
223     using SafeMath for uint256;
224 
225     /* ========== STATE VARIABLES ========== */
226 
227     address internal _governanceAddress;
228     mapping(address => uint256) internal _voteNum;
229 
230     /* ========== EVENTS ========== */
231 
232     event LogUpdateGovernanceAddress(address newAddress);
233 
234     /* ========== CONSTRUCTOR ========== */
235 
236     constructor(address governanceAddress) {
237         _governanceAddress = governanceAddress;
238     }
239 
240     /* ========== MODIFIERS ========== */
241 
242     modifier isGovernance(address account) {
243         require(account == _governanceAddress, "sender must be governance address");
244         _;
245     }
246 
247     /* ========== MUTATIVE FUNCTIONS ========== */
248 
249     /**
250      * @notice `_governanceAddress` can be updated by the current governance address.
251      * @dev Executed only once when initially set the governance address
252      * as the governance contract does not have the function to call this function.
253      */
254     function updateGovernanceAddress(address newGovernanceAddress)
255         external
256         isGovernance(msg.sender)
257     {
258         _governanceAddress = newGovernanceAddress;
259 
260         emit LogUpdateGovernanceAddress(newGovernanceAddress);
261     }
262 
263     function voteDeposit(address account, uint256 amount) external isGovernance(msg.sender) {
264         _updVoteSub(account, amount);
265     }
266 
267     function voteWithdraw(address account, uint256 amount) external isGovernance(msg.sender) {
268         _updVoteAdd(account, amount);
269     }
270 
271     /* ========== INTERNAL FUNCTIONS ========== */
272 
273     function _updVoteAdd(address account, uint256 amount) internal {
274         require(_voteNum[account] + amount >= amount, "overflow the amount of votes");
275         _voteNum[account] += amount;
276     }
277 
278     function _updVoteSub(address account, uint256 amount) internal {
279         require(_voteNum[account] >= amount, "underflow the amount of votes");
280         _voteNum[account] -= amount;
281     }
282 
283     /* ========== CALL FUNCTIONS ========== */
284 
285     function getGovernanceAddress() external view returns (address) {
286         return _governanceAddress;
287     }
288 
289     function getVoteNum(address account) external view returns (uint256) {
290         return _voteNum[account];
291     }
292 }
293 
294 // File: contracts/util/AddressList.sol
295 
296 library AddressList {
297     /**
298      * @dev Inserts token address in addressList except for zero address.
299      */
300     function insert(address[] storage addressList, address token) internal {
301         if (token == address(0)) {
302             return;
303         }
304 
305         for (uint256 i = 0; i < addressList.length; i++) {
306             if (addressList[i] == address(0)) {
307                 addressList[i] = token;
308                 return;
309             }
310         }
311 
312         addressList.push(token);
313     }
314 
315     /**
316      * @dev Removes token address from addressList except for zero address.
317      */
318     function remove(address[] storage addressList, address token) internal returns (bool success) {
319         if (token == address(0)) {
320             return true;
321         }
322 
323         for (uint256 i = 0; i < addressList.length; i++) {
324             if (addressList[i] == token) {
325                 delete addressList[i];
326                 return true;
327             }
328         }
329     }
330 
331     /**
332      * @dev Returns the addresses included in addressList except for zero address.
333      */
334     function get(address[] storage addressList)
335         internal
336         view
337         returns (address[] memory denseAddressList)
338     {
339         uint256 numOfElements = 0;
340         for (uint256 i = 0; i < addressList.length; i++) {
341             if (addressList[i] != address(0)) {
342                 numOfElements++;
343             }
344         }
345 
346         denseAddressList = new address[](numOfElements);
347         uint256 j = 0;
348         for (uint256 i = 0; i < addressList.length; i++) {
349             if (addressList[i] != address(0)) {
350                 denseAddressList[j] = addressList[i];
351                 j++;
352             }
353         }
354     }
355 }
356 
357 // File: contracts/staking/StakingDestinations.sol
358 
359 
360 contract StakingDestinations {
361     using AddressList for address[];
362 
363     /* ========== STATE VARIABLES ========== */
364 
365     /**
366      * @dev mapping from user address to staking token addresses
367      */
368     mapping(address => address[]) internal _stakingDestinations;
369 
370     /* ========== INTERNAL FUNCTIONS ========== */
371 
372     /**
373      * @dev Inserts token address in _stakingDestinations[account] except for ETH (= address(0)).
374      */
375     function _addDestinations(address account, address token) internal {
376         return _stakingDestinations[account].insert(token);
377     }
378 
379     /**
380      * @dev Removes token address from _stakingDestinations[account] except for ETH (= address(0)).
381      */
382     function _removeDestinations(address account, address token) internal returns (bool success) {
383         return _stakingDestinations[account].remove(token);
384     }
385 
386     /**
387      * @dev Returns the addresses included in _stakingDestinations[account] except for zero address.
388      */
389     function _getStakingDestinations(address account) internal view returns (address[] memory) {
390         return _stakingDestinations[account].get();
391     }
392 }
393 
394 // File: contracts/util/TransferETH.sol
395 
396 contract TransferETH {
397     receive() external payable {}
398 
399     /**
400      * @notice transfer `amount` ETH to the `recipient` account with emitting log
401      */
402     function _transferETH(
403         address payable recipient,
404         uint256 amount,
405         string memory errorMessage
406     ) internal {
407         (bool success, ) = recipient.call{value: amount}("");
408         require(success, errorMessage);
409     }
410 
411     function _transferETH(address payable recipient, uint256 amount) internal {
412         _transferETH(recipient, amount, "Transfer amount exceeds balance");
413     }
414 }
415 
416 // File: @openzeppelin/contracts/utils/SafeCast.sol
417 
418 
419 /**
420  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
421  * checks.
422  *
423  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
424  * easily result in undesired exploitation or bugs, since developers usually
425  * assume that overflows raise errors. `SafeCast` restores this intuition by
426  * reverting the transaction when such an operation overflows.
427  *
428  * Using this library instead of the unchecked operations eliminates an entire
429  * class of bugs, so it's recommended to use it always.
430  *
431  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
432  * all math on `uint256` and `int256` and then downcasting.
433  */
434 library SafeCast {
435 
436     /**
437      * @dev Returns the downcasted uint128 from uint256, reverting on
438      * overflow (when the input is greater than largest uint128).
439      *
440      * Counterpart to Solidity's `uint128` operator.
441      *
442      * Requirements:
443      *
444      * - input must fit into 128 bits
445      */
446     function toUint128(uint256 value) internal pure returns (uint128) {
447         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
448         return uint128(value);
449     }
450 
451     /**
452      * @dev Returns the downcasted uint64 from uint256, reverting on
453      * overflow (when the input is greater than largest uint64).
454      *
455      * Counterpart to Solidity's `uint64` operator.
456      *
457      * Requirements:
458      *
459      * - input must fit into 64 bits
460      */
461     function toUint64(uint256 value) internal pure returns (uint64) {
462         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
463         return uint64(value);
464     }
465 
466     /**
467      * @dev Returns the downcasted uint32 from uint256, reverting on
468      * overflow (when the input is greater than largest uint32).
469      *
470      * Counterpart to Solidity's `uint32` operator.
471      *
472      * Requirements:
473      *
474      * - input must fit into 32 bits
475      */
476     function toUint32(uint256 value) internal pure returns (uint32) {
477         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
478         return uint32(value);
479     }
480 
481     /**
482      * @dev Returns the downcasted uint16 from uint256, reverting on
483      * overflow (when the input is greater than largest uint16).
484      *
485      * Counterpart to Solidity's `uint16` operator.
486      *
487      * Requirements:
488      *
489      * - input must fit into 16 bits
490      */
491     function toUint16(uint256 value) internal pure returns (uint16) {
492         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
493         return uint16(value);
494     }
495 
496     /**
497      * @dev Returns the downcasted uint8 from uint256, reverting on
498      * overflow (when the input is greater than largest uint8).
499      *
500      * Counterpart to Solidity's `uint8` operator.
501      *
502      * Requirements:
503      *
504      * - input must fit into 8 bits.
505      */
506     function toUint8(uint256 value) internal pure returns (uint8) {
507         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
508         return uint8(value);
509     }
510 
511     /**
512      * @dev Converts a signed int256 into an unsigned uint256.
513      *
514      * Requirements:
515      *
516      * - input must be greater than or equal to 0.
517      */
518     function toUint256(int256 value) internal pure returns (uint256) {
519         require(value >= 0, "SafeCast: value must be positive");
520         return uint256(value);
521     }
522 
523     /**
524      * @dev Returns the downcasted int128 from int256, reverting on
525      * overflow (when the input is less than smallest int128 or
526      * greater than largest int128).
527      *
528      * Counterpart to Solidity's `int128` operator.
529      *
530      * Requirements:
531      *
532      * - input must fit into 128 bits
533      *
534      * _Available since v3.1._
535      */
536     function toInt128(int256 value) internal pure returns (int128) {
537         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
538         return int128(value);
539     }
540 
541     /**
542      * @dev Returns the downcasted int64 from int256, reverting on
543      * overflow (when the input is less than smallest int64 or
544      * greater than largest int64).
545      *
546      * Counterpart to Solidity's `int64` operator.
547      *
548      * Requirements:
549      *
550      * - input must fit into 64 bits
551      *
552      * _Available since v3.1._
553      */
554     function toInt64(int256 value) internal pure returns (int64) {
555         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
556         return int64(value);
557     }
558 
559     /**
560      * @dev Returns the downcasted int32 from int256, reverting on
561      * overflow (when the input is less than smallest int32 or
562      * greater than largest int32).
563      *
564      * Counterpart to Solidity's `int32` operator.
565      *
566      * Requirements:
567      *
568      * - input must fit into 32 bits
569      *
570      * _Available since v3.1._
571      */
572     function toInt32(int256 value) internal pure returns (int32) {
573         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
574         return int32(value);
575     }
576 
577     /**
578      * @dev Returns the downcasted int16 from int256, reverting on
579      * overflow (when the input is less than smallest int16 or
580      * greater than largest int16).
581      *
582      * Counterpart to Solidity's `int16` operator.
583      *
584      * Requirements:
585      *
586      * - input must fit into 16 bits
587      *
588      * _Available since v3.1._
589      */
590     function toInt16(int256 value) internal pure returns (int16) {
591         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
592         return int16(value);
593     }
594 
595     /**
596      * @dev Returns the downcasted int8 from int256, reverting on
597      * overflow (when the input is less than smallest int8 or
598      * greater than largest int8).
599      *
600      * Counterpart to Solidity's `int8` operator.
601      *
602      * Requirements:
603      *
604      * - input must fit into 8 bits.
605      *
606      * _Available since v3.1._
607      */
608     function toInt8(int256 value) internal pure returns (int8) {
609         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
610         return int8(value);
611     }
612 
613     /**
614      * @dev Converts an unsigned uint256 into a signed int256.
615      *
616      * Requirements:
617      *
618      * - input must be less than or equal to maxInt256.
619      */
620     function toInt256(uint256 value) internal pure returns (int256) {
621         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
622         return int256(value);
623     }
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
627 
628 /**
629  * @dev Interface of the ERC20 standard as defined in the EIP.
630  */
631 interface IERC20 {
632     /**
633      * @dev Returns the amount of tokens in existence.
634      */
635     function totalSupply() external view returns (uint256);
636 
637     /**
638      * @dev Returns the amount of tokens owned by `account`.
639      */
640     function balanceOf(address account) external view returns (uint256);
641 
642     /**
643      * @dev Moves `amount` tokens from the caller's account to `recipient`.
644      *
645      * Returns a boolean value indicating whether the operation succeeded.
646      *
647      * Emits a {Transfer} event.
648      */
649     function transfer(address recipient, uint256 amount) external returns (bool);
650 
651     /**
652      * @dev Returns the remaining number of tokens that `spender` will be
653      * allowed to spend on behalf of `owner` through {transferFrom}. This is
654      * zero by default.
655      *
656      * This value changes when {approve} or {transferFrom} are called.
657      */
658     function allowance(address owner, address spender) external view returns (uint256);
659 
660     /**
661      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
662      *
663      * Returns a boolean value indicating whether the operation succeeded.
664      *
665      * IMPORTANT: Beware that changing an allowance with this method brings the risk
666      * that someone may use both the old and the new allowance by unfortunate
667      * transaction ordering. One possible solution to mitigate this race
668      * condition is to first reduce the spender's allowance to 0 and set the
669      * desired value afterwards:
670      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
671      *
672      * Emits an {Approval} event.
673      */
674     function approve(address spender, uint256 amount) external returns (bool);
675 
676     /**
677      * @dev Moves `amount` tokens from `sender` to `recipient` using the
678      * allowance mechanism. `amount` is then deducted from the caller's
679      * allowance.
680      *
681      * Returns a boolean value indicating whether the operation succeeded.
682      *
683      * Emits a {Transfer} event.
684      */
685     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
686 
687     /**
688      * @dev Emitted when `value` tokens are moved from one account (`from`) to
689      * another (`to`).
690      *
691      * Note that `value` may be zero.
692      */
693     event Transfer(address indexed from, address indexed to, uint256 value);
694 
695     /**
696      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
697      * a call to {approve}. `value` is the new allowance.
698      */
699     event Approval(address indexed owner, address indexed spender, uint256 value);
700 }
701 
702 // File: @openzeppelin/contracts/utils/Address.sol
703 
704 /**
705  * @dev Collection of functions related to the address type
706  */
707 library Address {
708     /**
709      * @dev Returns true if `account` is a contract.
710      *
711      * [IMPORTANT]
712      * ====
713      * It is unsafe to assume that an address for which this function returns
714      * false is an externally-owned account (EOA) and not a contract.
715      *
716      * Among others, `isContract` will return false for the following
717      * types of addresses:
718      *
719      *  - an externally-owned account
720      *  - a contract in construction
721      *  - an address where a contract will be created
722      *  - an address where a contract lived, but was destroyed
723      * ====
724      */
725     function isContract(address account) internal view returns (bool) {
726         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
727         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
728         // for accounts without code, i.e. `keccak256('')`
729         bytes32 codehash;
730         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
731         // solhint-disable-next-line no-inline-assembly
732         assembly { codehash := extcodehash(account) }
733         return (codehash != accountHash && codehash != 0x0);
734     }
735 
736     /**
737      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
738      * `recipient`, forwarding all available gas and reverting on errors.
739      *
740      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
741      * of certain opcodes, possibly making contracts go over the 2300 gas limit
742      * imposed by `transfer`, making them unable to receive funds via
743      * `transfer`. {sendValue} removes this limitation.
744      *
745      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
746      *
747      * IMPORTANT: because control is transferred to `recipient`, care must be
748      * taken to not create reentrancy vulnerabilities. Consider using
749      * {ReentrancyGuard} or the
750      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
751      */
752     function sendValue(address payable recipient, uint256 amount) internal {
753         require(address(this).balance >= amount, "Address: insufficient balance");
754 
755         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
756         (bool success, ) = recipient.call{ value: amount }("");
757         require(success, "Address: unable to send value, recipient may have reverted");
758     }
759 
760     /**
761      * @dev Performs a Solidity function call using a low level `call`. A
762      * plain`call` is an unsafe replacement for a function call: use this
763      * function instead.
764      *
765      * If `target` reverts with a revert reason, it is bubbled up by this
766      * function (like regular Solidity function calls).
767      *
768      * Returns the raw returned data. To convert to the expected return value,
769      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
770      *
771      * Requirements:
772      *
773      * - `target` must be a contract.
774      * - calling `target` with `data` must not revert.
775      *
776      * _Available since v3.1._
777      */
778     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
779       return functionCall(target, data, "Address: low-level call failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
784      * `errorMessage` as a fallback revert reason when `target` reverts.
785      *
786      * _Available since v3.1._
787      */
788     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
789         return _functionCallWithValue(target, data, 0, errorMessage);
790     }
791 
792     /**
793      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
794      * but also transferring `value` wei to `target`.
795      *
796      * Requirements:
797      *
798      * - the calling contract must have an ETH balance of at least `value`.
799      * - the called Solidity function must be `payable`.
800      *
801      * _Available since v3.1._
802      */
803     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
804         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
809      * with `errorMessage` as a fallback revert reason when `target` reverts.
810      *
811      * _Available since v3.1._
812      */
813     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
814         require(address(this).balance >= value, "Address: insufficient balance for call");
815         return _functionCallWithValue(target, data, value, errorMessage);
816     }
817 
818     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
819         require(isContract(target), "Address: call to non-contract");
820 
821         // solhint-disable-next-line avoid-low-level-calls
822         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
823         if (success) {
824             return returndata;
825         } else {
826             // Look for revert reason and bubble it up if present
827             if (returndata.length > 0) {
828                 // The easiest way to bubble the revert reason is using memory via assembly
829 
830                 // solhint-disable-next-line no-inline-assembly
831                 assembly {
832                     let returndata_size := mload(returndata)
833                     revert(add(32, returndata), returndata_size)
834                 }
835             } else {
836                 revert(errorMessage);
837             }
838         }
839     }
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
843 
844 
845 
846 
847 /**
848  * @title SafeERC20
849  * @dev Wrappers around ERC20 operations that throw on failure (when the token
850  * contract returns false). Tokens that return no value (and instead revert or
851  * throw on failure) are also supported, non-reverting calls are assumed to be
852  * successful.
853  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
854  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
855  */
856 library SafeERC20 {
857     using SafeMath for uint256;
858     using Address for address;
859 
860     function safeTransfer(IERC20 token, address to, uint256 value) internal {
861         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
862     }
863 
864     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
865         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
866     }
867 
868     /**
869      * @dev Deprecated. This function has issues similar to the ones found in
870      * {IERC20-approve}, and its usage is discouraged.
871      *
872      * Whenever possible, use {safeIncreaseAllowance} and
873      * {safeDecreaseAllowance} instead.
874      */
875     function safeApprove(IERC20 token, address spender, uint256 value) internal {
876         // safeApprove should only be called when setting an initial allowance,
877         // or when resetting it to zero. To increase and decrease it, use
878         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
879         // solhint-disable-next-line max-line-length
880         require((value == 0) || (token.allowance(address(this), spender) == 0),
881             "SafeERC20: approve from non-zero to non-zero allowance"
882         );
883         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
884     }
885 
886     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
887         uint256 newAllowance = token.allowance(address(this), spender).add(value);
888         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
889     }
890 
891     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
892         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
893         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
894     }
895 
896     /**
897      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
898      * on the return value: the return value is optional (but if data is returned, it must not be false).
899      * @param token The token targeted by the call.
900      * @param data The call data (encoded using abi.encode or one of its variants).
901      */
902     function _callOptionalReturn(IERC20 token, bytes memory data) private {
903         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
904         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
905         // the target address contains contract code and also asserts for success in the low-level call.
906 
907         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
908         if (returndata.length > 0) { // Return data is optional
909             // solhint-disable-next-line max-line-length
910             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
911         }
912     }
913 }
914 
915 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
916 
917 /**
918  * @dev Contract module that helps prevent reentrant calls to a function.
919  *
920  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
921  * available, which can be applied to functions to make sure there are no nested
922  * (reentrant) calls to them.
923  *
924  * Note that because there is a single `nonReentrant` guard, functions marked as
925  * `nonReentrant` may not call one another. This can be worked around by making
926  * those functions `private`, and then adding `external` `nonReentrant` entry
927  * points to them.
928  *
929  * TIP: If you would like to learn more about reentrancy and alternative ways
930  * to protect against it, check out our blog post
931  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
932  */
933 abstract contract ReentrancyGuard {
934     // Booleans are more expensive than uint256 or any type that takes up a full
935     // word because each write operation emits an extra SLOAD to first read the
936     // slot's contents, replace the bits taken up by the boolean, and then write
937     // back. This is the compiler's defense against contract upgrades and
938     // pointer aliasing, and it cannot be disabled.
939 
940     // The values being non-zero value makes deployment a bit more expensive,
941     // but in exchange the refund on every call to nonReentrant will be lower in
942     // amount. Since refunds are capped to a percentage of the total
943     // transaction's gas, it is best to keep them low in cases like this one, to
944     // increase the likelihood of the full refund coming into effect.
945     uint256 private constant _NOT_ENTERED = 1;
946     uint256 private constant _ENTERED = 2;
947 
948     uint256 private _status;
949 
950     constructor () {
951         _status = _NOT_ENTERED;
952     }
953 
954     /**
955      * @dev Prevents a contract from calling itself, directly or indirectly.
956      * Calling a `nonReentrant` function from another `nonReentrant`
957      * function is not supported. It is possible to prevent this from happening
958      * by making the `nonReentrant` function external, and make it call a
959      * `private` function that does the actual work.
960      */
961     modifier nonReentrant() {
962         // On the first call to nonReentrant, _notEntered will be true
963         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
964 
965         // Any calls to nonReentrant after this point will fail
966         _status = _ENTERED;
967 
968         _;
969 
970         // By storing the original value once again, a refund is triggered (see
971         // https://eips.ethereum.org/EIPS/eip-2200)
972         _status = _NOT_ENTERED;
973     }
974 }
975 
976 // File: contracts/staking/Staking.sol
977 
978 
979 
980 
981 
982 
983 
984 
985 
986 contract Staking is
987     StakingInterface,
988     ReentrancyGuard,
989     StakingVote,
990     StakingDestinations,
991     TransferETH
992 {
993     using SafeMath for uint256;
994     using SafeMath for uint128;
995     using SafeCast for uint256;
996     using SafeERC20 for IERC20;
997 
998     /* ========== CONSTANT VARIABLES ========== */
999 
1000     address internal constant ETH_ADDRESS = address(0);
1001     uint256 internal constant MAX_TERM = 1000;
1002 
1003     IERC20 internal immutable _stakingToken;
1004     uint256 internal immutable _startTimestamp; // timestamp of the term 0
1005     uint256 internal immutable _termInterval; // time interval between terms in second
1006 
1007     /* ========== STATE VARIABLES ========== */
1008 
1009     struct AccountInfo {
1010         uint128 stakeAmount; // active stake amount of the user at userTerm
1011         uint128 added; // the added amount of stake which will be merged to stakeAmount at the term+1.
1012         uint256 userTerm; // the term when the user executed any function last time (all the terms before the term has been already settled)
1013         uint256 rewards; // the total amount of rewards until userTerm
1014     }
1015 
1016     /**
1017      * @dev token => account => data
1018      */
1019     mapping(address => mapping(address => AccountInfo)) internal _accountInfo;
1020 
1021     struct TermInfo {
1022         uint128 stakeAdd; // the total added amount of stake which will be merged to stakeSum at the term+1
1023         uint128 stakeSum; // the total staking amount at the term
1024         uint256 rewardSum; // the total amount of rewards at the term
1025     }
1026 
1027     /**
1028      * @dev token => term => data
1029      */
1030     mapping(address => mapping(uint256 => TermInfo)) internal _termInfo;
1031 
1032     mapping(address => uint256) internal _currentTerm; // (token => term); the current term (all the info prior to this term is fixed)
1033     mapping(address => uint256) internal _totalRemainingRewards; // (token => amount); total unsettled amount of rewards
1034 
1035     /* ========== EVENTS ========== */
1036 
1037     event RewardAdded(address indexed token, uint256 reward);
1038     event Staked(address indexed token, address indexed account, uint128 amount);
1039     event Withdrawn(address indexed token, address indexed account, uint128 amount);
1040     event RewardPaid(address indexed token, address indexed account, uint256 reward);
1041 
1042     /* ========== CONSTRUCTOR ========== */
1043 
1044     constructor(
1045         address stakingTokenAddress,
1046         address governance,
1047         uint256 startTimestamp,
1048         uint256 termInterval
1049     ) StakingVote(governance) {
1050         require(startTimestamp <= block.timestamp, "startTimestamp should be past time");
1051         _stakingToken = IERC20(stakingTokenAddress);
1052         _startTimestamp = startTimestamp;
1053         _termInterval = termInterval;
1054     }
1055 
1056     /* ========== MODIFIERS ========== */
1057 
1058     /**
1059      * @dev Calc total rewards of the account until the current term.
1060      */
1061     modifier updateReward(address token, address account) {
1062         AccountInfo memory accountInfo = _accountInfo[token][account];
1063         uint256 startTerm = accountInfo.userTerm;
1064         // When the loop count exceeds MAX_TERM, stop processing in order not to reach to the block gas limit
1065         for (
1066             uint256 term = accountInfo.userTerm;
1067             term < _currentTerm[token] && term < startTerm + MAX_TERM;
1068             term++
1069         ) {
1070             TermInfo memory termInfo = _termInfo[token][term];
1071             if (termInfo.stakeSum != 0) {
1072                 accountInfo.rewards = accountInfo.rewards.add(
1073                     accountInfo.stakeAmount.mul(termInfo.rewardSum).div(termInfo.stakeSum)
1074                 ); // `(your stake amount) / (total stake amount) * total rewards` in each term
1075             }
1076             accountInfo.stakeAmount = accountInfo.stakeAmount.add(accountInfo.added).toUint128();
1077             accountInfo.added = 0;
1078             accountInfo.userTerm = term + 1; // calculated until this term
1079             if (accountInfo.stakeAmount == 0) {
1080                 accountInfo.userTerm = _currentTerm[token];
1081                 break; // skip unnecessary term
1082             }
1083         }
1084         _accountInfo[token][account] = accountInfo;
1085         _;
1086     }
1087 
1088     /**
1089      * @dev Update the info up to the current term.
1090      */
1091     modifier updateTerm(address token) {
1092         if (_currentTerm[token] < _getLatestTerm()) {
1093             uint256 currentBalance = (token == ETH_ADDRESS)
1094                 ? address(this).balance
1095                 : IERC20(token).balanceOf(address(this));
1096             uint256 nextRewardSum = currentBalance.sub(_totalRemainingRewards[token]);
1097 
1098             TermInfo memory currentTermInfo = _termInfo[token][_currentTerm[token]];
1099             uint128 nextStakeSum = currentTermInfo
1100                 .stakeSum
1101                 .add(currentTermInfo.stakeAdd)
1102                 .toUint128();
1103             uint256 carriedReward = currentTermInfo.stakeSum == 0 ? currentTermInfo.rewardSum : 0; // if stakeSum is 0, carried forward until someone stakes
1104             uint256 nextTerm = nextStakeSum == 0 ? _getLatestTerm() : _currentTerm[token] + 1; // if next stakeSum is 0, skip to latest term
1105             _termInfo[token][nextTerm] = TermInfo({
1106                 stakeAdd: 0,
1107                 stakeSum: nextStakeSum,
1108                 rewardSum: nextRewardSum.add(carriedReward)
1109             });
1110 
1111             // write total stake amount since (nextTerm + 1) until _getLatestTerm()
1112             if (nextTerm < _getLatestTerm()) {
1113                 // assert(_termInfo[token][nextTerm].stakeSum != 0 && _termInfo[token][nextTerm].stakeAdd == 0);
1114                 _termInfo[token][_getLatestTerm()] = TermInfo({
1115                     stakeAdd: 0,
1116                     stakeSum: nextStakeSum,
1117                     rewardSum: 0
1118                 });
1119             }
1120 
1121             _totalRemainingRewards[token] = currentBalance; // total amount of unpaid reward
1122             _currentTerm[token] = _getLatestTerm();
1123         }
1124         _;
1125     }
1126 
1127     /* ========== MUTATIVE FUNCTIONS ========== */
1128 
1129     /**
1130      * @notice Stake the staking token for the token to be paid as reward.
1131      */
1132     function stake(address token, uint128 amount)
1133         external
1134         override
1135         nonReentrant
1136         updateTerm(token)
1137         updateReward(token, msg.sender)
1138     {
1139         if (_accountInfo[token][msg.sender].userTerm < _currentTerm[token]) {
1140             return;
1141         }
1142 
1143         require(amount != 0, "staking amount should be positive number");
1144 
1145         _updVoteAdd(msg.sender, amount);
1146         _stake(msg.sender, token, amount);
1147         _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1148     }
1149 
1150     /**
1151      * @notice Withdraw the staking token for the token to be paid as reward.
1152      */
1153     function withdraw(address token, uint128 amount)
1154         external
1155         override
1156         nonReentrant
1157         updateTerm(token)
1158         updateReward(token, msg.sender)
1159     {
1160         if (_accountInfo[token][msg.sender].userTerm < _currentTerm[token]) {
1161             return;
1162         }
1163 
1164         require(amount != 0, "withdrawing amount should be positive number");
1165 
1166         _updVoteSub(msg.sender, amount);
1167         _withdraw(msg.sender, token, amount);
1168         _stakingToken.safeTransfer(msg.sender, amount);
1169     }
1170 
1171     /**
1172      * @notice Receive the reward for your staking in the token.
1173      */
1174     function receiveReward(address token)
1175         external
1176         override
1177         nonReentrant
1178         updateTerm(token)
1179         updateReward(token, msg.sender)
1180         returns (uint256 rewards)
1181     {
1182         rewards = _accountInfo[token][msg.sender].rewards;
1183         if (rewards != 0) {
1184             _totalRemainingRewards[token] = _totalRemainingRewards[token].sub(rewards); // subtract the total unpaid reward
1185             _accountInfo[token][msg.sender].rewards = 0;
1186             if (token == ETH_ADDRESS) {
1187                 _transferETH(msg.sender, rewards);
1188             } else {
1189                 IERC20(token).safeTransfer(msg.sender, rewards);
1190             }
1191             emit RewardPaid(token, msg.sender, rewards);
1192         }
1193     }
1194 
1195     function changeStakeTarget(
1196         address oldTarget,
1197         address newTarget,
1198         uint128 amount
1199     )
1200         external
1201         override
1202         nonReentrant
1203         updateTerm(oldTarget)
1204         updateReward(oldTarget, msg.sender)
1205         updateTerm(newTarget)
1206         updateReward(newTarget, msg.sender)
1207     {
1208         if (
1209             _accountInfo[oldTarget][msg.sender].userTerm < _currentTerm[oldTarget] ||
1210             _accountInfo[newTarget][msg.sender].userTerm < _currentTerm[newTarget]
1211         ) {
1212             return;
1213         }
1214 
1215         require(amount != 0, "transfering amount should be positive number");
1216 
1217         _withdraw(msg.sender, oldTarget, amount);
1218         _stake(msg.sender, newTarget, amount);
1219     }
1220 
1221     /* ========== INTERNAL FUNCTIONS ========== */
1222 
1223     function _stake(
1224         address account,
1225         address token,
1226         uint128 amount
1227     ) internal {
1228         AccountInfo memory accountInfo = _accountInfo[token][account];
1229         if (accountInfo.stakeAmount == 0 && accountInfo.added == 0) {
1230             _addDestinations(account, token);
1231         }
1232 
1233         _accountInfo[token][account].added = accountInfo.added.add(amount).toUint128(); // added when the term is shifted (the user)
1234 
1235         uint256 term = _currentTerm[token];
1236         _termInfo[token][term].stakeAdd = _termInfo[token][term].stakeAdd.add(amount).toUint128(); // added when the term is shifted (global)
1237 
1238         emit Staked(token, account, amount);
1239     }
1240 
1241     function _withdraw(
1242         address account,
1243         address token,
1244         uint128 amount
1245     ) internal {
1246         AccountInfo memory accountInfo = _accountInfo[token][account];
1247         require(
1248             accountInfo.stakeAmount.add(accountInfo.added) >= amount,
1249             "exceed withdrawable amount"
1250         );
1251 
1252         if (accountInfo.stakeAmount + accountInfo.added == amount) {
1253             _removeDestinations(account, token);
1254         }
1255 
1256         uint256 currentTerm = _currentTerm[token];
1257         TermInfo memory termInfo = _termInfo[token][currentTerm];
1258         if (accountInfo.added > amount) {
1259             accountInfo.added -= amount;
1260             termInfo.stakeAdd -= amount;
1261         } else {
1262             termInfo.stakeSum = termInfo.stakeSum.sub(amount - accountInfo.added).toUint128();
1263             termInfo.stakeAdd = termInfo.stakeAdd.sub(accountInfo.added).toUint128();
1264             accountInfo.stakeAmount = accountInfo
1265                 .stakeAmount
1266                 .sub(amount - accountInfo.added)
1267                 .toUint128();
1268             accountInfo.added = 0;
1269         }
1270 
1271         _accountInfo[token][account] = accountInfo;
1272         _termInfo[token][currentTerm] = termInfo;
1273 
1274         emit Withdrawn(token, account, amount);
1275     }
1276 
1277     function _getNextTermReward(address token) internal view returns (uint256 rewards) {
1278         // as the term at current+1 has not been settled
1279         uint256 currentBalance = (token == ETH_ADDRESS)
1280             ? address(this).balance
1281             : IERC20(token).balanceOf(address(this));
1282         return
1283             (currentBalance > _totalRemainingRewards[token])
1284                 ? currentBalance - _totalRemainingRewards[token]
1285                 : 0;
1286     }
1287 
1288     function _getLatestTerm() internal view returns (uint256) {
1289         return (block.timestamp - _startTimestamp) / _termInterval;
1290     }
1291 
1292     /* ========== CALL FUNCTIONS ========== */
1293 
1294     /**
1295      * @return stakingTokenAddress is the token locked for staking
1296      */
1297     function getStakingTokenAddress() external view override returns (address stakingTokenAddress) {
1298         return address(_stakingToken);
1299     }
1300 
1301     /**
1302      * @return startTimestamp is the time when this contract was deployed
1303      * @return termInterval is the duration of a term
1304      */
1305     function getConfigs()
1306         external
1307         view
1308         override
1309         returns (uint256 startTimestamp, uint256 termInterval)
1310     {
1311         startTimestamp = _startTimestamp;
1312         termInterval = _termInterval;
1313     }
1314 
1315     /**
1316      * @return the ERC20 token addresses in staking
1317      */
1318     function getStakingDestinations(address account)
1319         external
1320         view
1321         override
1322         returns (address[] memory)
1323     {
1324         return _getStakingDestinations(account);
1325     }
1326 
1327     /**
1328      * @param token is the token address to stake for
1329      * @return currentTerm is the current latest term
1330      * @return latestTerm is the potential latest term
1331      * @return totalRemainingRewards is the as-of remaining rewards
1332      * @return currentReward is the total rewards at the current term
1333      * @return nextTermRewards is the as-of total rewards to be paid at the next term
1334      * @return currentStaking is the total active staking amount
1335      * @return nextTermStaking is the total staking amount
1336      */
1337     function getTokenInfo(address token)
1338         external
1339         view
1340         override
1341         returns (
1342             uint256 currentTerm,
1343             uint256 latestTerm,
1344             uint256 totalRemainingRewards,
1345             uint256 currentReward,
1346             uint256 nextTermRewards,
1347             uint128 currentStaking,
1348             uint128 nextTermStaking
1349         )
1350     {
1351         currentTerm = _currentTerm[token];
1352         latestTerm = _getLatestTerm();
1353         totalRemainingRewards = _totalRemainingRewards[token];
1354         currentReward = _termInfo[token][currentTerm].rewardSum;
1355         nextTermRewards = _getNextTermReward(token);
1356         TermInfo memory termInfo = _termInfo[token][_currentTerm[token]];
1357         currentStaking = termInfo.stakeSum;
1358         nextTermStaking = termInfo.stakeSum.add(termInfo.stakeAdd).toUint128();
1359     }
1360 
1361     /**
1362      * @notice Returns _termInfo[token][term].
1363      */
1364     function getTermInfo(address token, uint256 term)
1365         external
1366         view
1367         override
1368         returns (
1369             uint128 stakeAdd,
1370             uint128 stakeSum,
1371             uint256 rewardSum
1372         )
1373     {
1374         TermInfo memory termInfo = _termInfo[token][term];
1375         stakeAdd = termInfo.stakeAdd;
1376         stakeSum = termInfo.stakeSum;
1377         if (term == _currentTerm[token] + 1) {
1378             rewardSum = _getNextTermReward(token);
1379         } else {
1380             rewardSum = termInfo.rewardSum;
1381         }
1382     }
1383 
1384     /**
1385      * @return userTerm is the latest term the user has updated to
1386      * @return stakeAmount is the latest amount of staking from the user has updated to
1387      * @return nextAddedStakeAmount is the next amount of adding to stake from the user has updated to
1388      * @return currentReward is the latest reward getting by the user has updated to
1389      * @return nextLatestTermUserRewards is the as-of user rewards to be paid at the next term
1390      * @return depositAmount is the staking amount
1391      * @return withdrawableStakingAmount is the withdrawable staking amount
1392      */
1393     function getAccountInfo(address token, address account)
1394         external
1395         view
1396         override
1397         returns (
1398             uint256 userTerm,
1399             uint256 stakeAmount,
1400             uint128 nextAddedStakeAmount,
1401             uint256 currentReward,
1402             uint256 nextLatestTermUserRewards,
1403             uint128 depositAmount,
1404             uint128 withdrawableStakingAmount
1405         )
1406     {
1407         AccountInfo memory accountInfo = _accountInfo[token][account];
1408         userTerm = accountInfo.userTerm;
1409         stakeAmount = accountInfo.stakeAmount;
1410         nextAddedStakeAmount = accountInfo.added;
1411         currentReward = accountInfo.rewards;
1412         uint256 currentTerm = _currentTerm[token];
1413         TermInfo memory termInfo = _termInfo[token][currentTerm];
1414         uint256 nextLatestTermRewards = _getNextTermReward(token);
1415         nextLatestTermUserRewards = termInfo.stakeSum.add(termInfo.stakeAdd) == 0
1416             ? 0
1417             : nextLatestTermRewards.mul(accountInfo.stakeAmount.add(accountInfo.added)) /
1418                 (termInfo.stakeSum + termInfo.stakeAdd);
1419         depositAmount = accountInfo.stakeAmount.add(accountInfo.added).toUint128();
1420         uint128 availableForVoting = _voteNum[account].toUint128();
1421         withdrawableStakingAmount = depositAmount < availableForVoting
1422             ? depositAmount
1423             : availableForVoting;
1424     }
1425 }