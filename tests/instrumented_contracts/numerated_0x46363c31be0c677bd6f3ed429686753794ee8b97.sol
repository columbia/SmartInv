1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 //import "@nomiclabs/buidler/console.sol";
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor() {}
21 
22     function _msgSender() internal view returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public onlyOwner {
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      */
96     function _transferOwnership(address newOwner) internal {
97         require(newOwner != address(0), 'Ownable: new owner is the zero address');
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, 'SafeMath: addition overflow');
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, 'SafeMath: subtraction overflow');
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, 'SafeMath: multiplication overflow');
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, 'SafeMath: division by zero');
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, 'SafeMath: modulo by zero');
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(
262         uint256 a,
263         uint256 b,
264         string memory errorMessage
265     ) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 
270     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
271         z = x < y ? x : y;
272     }
273 
274     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
275     function sqrt(uint256 y) internal pure returns (uint256 z) {
276         if (y > 3) {
277             z = y;
278             uint256 x = y / 2 + 1;
279             while (x < z) {
280                 z = x;
281                 x = (y / x + x) / 2;
282             }
283         } else if (y != 0) {
284             z = 1;
285         }
286     }
287 }
288 
289 interface IBEP20 {
290     /**
291      * @dev Returns the amount of tokens in existence.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     /**
296      * @dev Returns the token decimals.
297      */
298     function decimals() external view returns (uint8);
299 
300     /**
301      * @dev Returns the token symbol.
302      */
303     function symbol() external view returns (string memory);
304 
305     /**
306      * @dev Returns the token name.
307      */
308     function name() external view returns (string memory);
309 
310     /**
311      * @dev Returns the bep token owner.
312      */
313     function getOwner() external view returns (address);
314 
315     /**
316      * @dev Returns the amount of tokens owned by `account`.
317      */
318     function balanceOf(address account) external view returns (uint256);
319 
320     /**
321      * @dev Moves `amount` tokens from the caller's account to `recipient`.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transfer(address recipient, uint256 amount) external returns (bool);
328 
329     /**
330      * @dev Returns the remaining number of tokens that `spender` will be
331      * allowed to spend on behalf of `owner` through {transferFrom}. This is
332      * zero by default.
333      *
334      * This value changes when {approve} or {transferFrom} are called.
335      */
336     function allowance(address _owner, address spender) external view returns (uint256);
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * IMPORTANT: Beware that changing an allowance with this method brings the risk
344      * that someone may use both the old and the new allowance by unfortunate
345      * transaction ordering. One possible solution to mitigate this race
346      * condition is to first reduce the spender's allowance to 0 and set the
347      * desired value afterwards:
348      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349      *
350      * Emits an {Approval} event.
351      */
352     function approve(address spender, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Moves `amount` tokens from `sender` to `recipient` using the
356      * allowance mechanism. `amount` is then deducted from the caller's
357      * allowance.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * Emits a {Transfer} event.
362      */
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 /**
385  * @title SafeBEP20
386  * @dev Wrappers around BEP20 operations that throw on failure (when the token
387  * contract returns false). Tokens that return no value (and instead revert or
388  * throw on failure) are also supported, non-reverting calls are assumed to be
389  * successful.
390  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
391  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
392  */
393 library SafeBEP20 {
394     using SafeMath for uint256;
395     using Address for address;
396 
397     function safeTransfer(
398         IBEP20 token,
399         address to,
400         uint256 value
401     ) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
403     }
404 
405     function safeTransferFrom(
406         IBEP20 token,
407         address from,
408         address to,
409         uint256 value
410     ) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
412     }
413 
414     /**
415      * @dev Deprecated. This function has issues similar to the ones found in
416      * {IBEP20-approve}, and its usage is discouraged.
417      *
418      * Whenever possible, use {safeIncreaseAllowance} and
419      * {safeDecreaseAllowance} instead.
420      */
421     function safeApprove(
422         IBEP20 token,
423         address spender,
424         uint256 value
425     ) internal {
426         // safeApprove should only be called when setting an initial allowance,
427         // or when resetting it to zero. To increase and decrease it, use
428         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
429         // solhint-disable-next-line max-line-length
430         require(
431             (value == 0) || (token.allowance(address(this), spender) == 0),
432             'SafeBEP20: approve from non-zero to non-zero allowance'
433         );
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
435     }
436 
437     function safeIncreaseAllowance(
438         IBEP20 token,
439         address spender,
440         uint256 value
441     ) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).add(value);
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     function safeDecreaseAllowance(
447         IBEP20 token,
448         address spender,
449         uint256 value
450     ) internal {
451         uint256 newAllowance = token.allowance(address(this), spender).sub(
452             value,
453             'SafeBEP20: decreased allowance below zero'
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     /**
459      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
460      * on the return value: the return value is optional (but if data is returned, it must not be false).
461      * @param token The token targeted by the call.
462      * @param data The call data (encoded using abi.encode or one of its variants).
463      */
464     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
465         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
466         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
467         // the target address contains contract code and also asserts for success in the low-level call.
468 
469         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
470         if (returndata.length > 0) {
471             // Return data is optional
472             // solhint-disable-next-line max-line-length
473             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
474         }
475     }
476 }
477 
478 /**
479  * @dev Collection of functions related to the address type
480  */
481 library Address {
482     /**
483      * @dev Returns true if `account` is a contract.
484      *
485      * [IMPORTANT]
486      * ====
487      * It is unsafe to assume that an address for which this function returns
488      * false is an externally-owned account (EOA) and not a contract.
489      *
490      * Among others, `isContract` will return false for the following
491      * types of addresses:
492      *
493      *  - an externally-owned account
494      *  - a contract in construction
495      *  - an address where a contract will be created
496      *  - an address where a contract lived, but was destroyed
497      * ====
498      */
499     function isContract(address account) internal view returns (bool) {
500         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
501         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
502         // for accounts without code, i.e. `keccak256('')`
503         bytes32 codehash;
504         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
505         // solhint-disable-next-line no-inline-assembly
506         assembly {
507             codehash := extcodehash(account)
508         }
509         return (codehash != accountHash && codehash != 0x0);
510     }
511 
512     /**
513      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
514      * `recipient`, forwarding all available gas and reverting on errors.
515      *
516      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
517      * of certain opcodes, possibly making contracts go over the 2300 gas limit
518      * imposed by `transfer`, making them unable to receive funds via
519      * `transfer`. {sendValue} removes this limitation.
520      *
521      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
522      *
523      * IMPORTANT: because control is transferred to `recipient`, care must be
524      * taken to not create reentrancy vulnerabilities. Consider using
525      * {ReentrancyGuard} or the
526      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
527      */
528     function sendValue(address payable recipient, uint256 amount) internal {
529         require(address(this).balance >= amount, 'Address: insufficient balance');
530 
531         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
532         (bool success, ) = recipient.call{value: amount}('');
533         require(success, 'Address: unable to send value, recipient may have reverted');
534     }
535 
536     /**
537      * @dev Performs a Solidity function call using a low level `call`. A
538      * plain`call` is an unsafe replacement for a function call: use this
539      * function instead.
540      *
541      * If `target` reverts with a revert reason, it is bubbled up by this
542      * function (like regular Solidity function calls).
543      *
544      * Returns the raw returned data. To convert to the expected return value,
545      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
546      *
547      * Requirements:
548      *
549      * - `target` must be a contract.
550      * - calling `target` with `data` must not revert.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
555         return functionCall(target, data, 'Address: low-level call failed');
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
560      * `errorMessage` as a fallback revert reason when `target` reverts.
561      *
562      * _Available since v3.1._
563      */
564     function functionCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         return _functionCallWithValue(target, data, 0, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but also transferring `value` wei to `target`.
575      *
576      * Requirements:
577      *
578      * - the calling contract must have an ETH balance of at least `value`.
579      * - the called Solidity function must be `payable`.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(
584         address target,
585         bytes memory data,
586         uint256 value
587     ) internal returns (bytes memory) {
588         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
593      * with `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(
598         address target,
599         bytes memory data,
600         uint256 value,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(address(this).balance >= value, 'Address: insufficient balance for call');
604         return _functionCallWithValue(target, data, value, errorMessage);
605     }
606 
607     function _functionCallWithValue(
608         address target,
609         bytes memory data,
610         uint256 weiValue,
611         string memory errorMessage
612     ) private returns (bytes memory) {
613         require(isContract(target), 'Address: call to non-contract');
614 
615         // solhint-disable-next-line avoid-low-level-calls
616         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 // solhint-disable-next-line no-inline-assembly
625                 assembly {
626                     let returndata_size := mload(returndata)
627                     revert(add(32, returndata), returndata_size)
628                 }
629             } else {
630                 revert(errorMessage);
631             }
632         }
633     }
634 }
635 
636 abstract contract ReentrancyGuard {
637     // Booleans are more expensive than uint256 or any type that takes up a full
638     // word because each write operation emits an extra SLOAD to first read the
639     // slot's contents, replace the bits taken up by the boolean, and then write
640     // back. This is the compiler's defense against contract upgrades and
641     // pointer aliasing, and it cannot be disabled.
642 
643     // The values being non-zero value makes deployment a bit more expensive,
644     // but in exchange the refund on every call to nonReentrant will be lower in
645     // amount. Since refunds are capped to a percentage of the total
646     // transaction's gas, it is best to keep them low in cases like this one, to
647     // increase the likelihood of the full refund coming into effect.
648     uint256 private constant _NOT_ENTERED = 1;
649     uint256 private constant _ENTERED = 2;
650 
651     uint256 private _status;
652 
653     constructor() {
654         _status = _NOT_ENTERED;
655     }
656 
657     /**
658      * @dev Prevents a contract from calling itself, directly or indirectly.
659      * Calling a `nonReentrant` function from another `nonReentrant`
660      * function is not supported. It is possible to prevent this from happening
661      * by making the `nonReentrant` function external, and making it call a
662      * `private` function that does the actual work.
663      */
664     modifier nonReentrant() {
665         // On the first call to nonReentrant, _notEntered will be true
666         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
667 
668         // Any calls to nonReentrant after this point will fail
669         _status = _ENTERED;
670 
671         _;
672 
673         // By storing the original value once again, a refund is triggered (see
674         // https://eips.ethereum.org/EIPS/eip-2200)
675         _status = _NOT_ENTERED;
676     }
677 }
678 
679 contract BITROCKSTAKE is Ownable, ReentrancyGuard {
680     using SafeMath for uint256;
681     using SafeBEP20 for IBEP20;
682 
683     // Info of each user.
684     struct UserInfo {
685         uint256 amount;     // How many LP tokens the user has provided.
686         uint256 rewardDebt; // Reward debt. See explanation below.
687     }
688 
689     // Info of each pool.
690     struct PoolInfo {
691         IBEP20 lpToken;           // Address of LP token contract.
692         uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
693         uint256 lastRewardTimestamp;  // Last block number that Tokens distribution occurs.
694         uint256 accTokensPerShare; // Accumulated Tokens per share, times 1e12. See below.
695     }
696 
697     IBEP20 public immutable stakingToken;
698     IBEP20 public immutable rewardToken;
699     mapping (address => uint256) public holderUnlockTime;
700 
701     uint256 public totalStaked;
702     uint256 public apy;
703     uint256 public lockDuration;
704     uint256 public exitPenaltyPerc;
705 
706     // Info of each pool.
707     PoolInfo[] public poolInfo;
708     // Info of each user that stakes LP tokens.
709     mapping (address => UserInfo) public userInfo;
710     // Total allocation points. Must be the sum of all allocation points in all pools.
711     uint256 private totalAllocPoint = 0;
712 
713     event Deposit(address indexed user, uint256 amount);
714     event Withdraw(address indexed user, uint256 amount);
715     event EmergencyWithdraw(address indexed user, uint256 amount);
716 
717     constructor(
718     ) {
719 
720         stakingToken = IBEP20(0xde67d97b8770dC98C746A3FC0093c538666eB493);
721         rewardToken = stakingToken;
722 
723         apy = 90;
724 
725         lockDuration = 5 days;
726         exitPenaltyPerc = 25;
727 
728         // staking pool
729         poolInfo.push(PoolInfo({
730             lpToken: stakingToken,
731             allocPoint: 1000,
732             lastRewardTimestamp: 2199615,
733             accTokensPerShare: 0
734         }));
735 
736         totalAllocPoint = 1000;
737 
738     }
739 
740     function stopReward() external onlyOwner {
741         updatePool(0);
742         apy = 0;
743     }
744 
745     function startReward() external onlyOwner {
746         require(poolInfo[0].lastRewardTimestamp == 21799615, "Can only start rewards once");
747         poolInfo[0].lastRewardTimestamp = block.timestamp;
748     }
749 
750     // View function to see pending Reward on frontend.
751     function pendingReward(address _user) external view returns (uint256) {
752         PoolInfo storage pool = poolInfo[0];
753         UserInfo storage user = userInfo[_user];
754         if(pool.lastRewardTimestamp == 21799615){
755             return 0;
756         }
757         uint256 accTokensPerShare = pool.accTokensPerShare;
758         uint256 lpSupply = totalStaked;
759         if (block.timestamp > pool.lastRewardTimestamp && lpSupply != 0) {
760             uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
761             accTokensPerShare = accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
762         }
763         return user.amount.mul(accTokensPerShare).div(1e12).sub(user.rewardDebt);
764     }
765 
766     // Update reward variables of the given pool to be up-to-date.
767     function updatePool(uint256 _pid) internal {
768         PoolInfo storage pool = poolInfo[_pid];
769         if (block.timestamp <= pool.lastRewardTimestamp) {
770             return;
771         }
772         uint256 lpSupply = totalStaked;
773         if (lpSupply == 0) {
774             pool.lastRewardTimestamp = block.timestamp;
775             return;
776         }
777         uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
778         pool.accTokensPerShare = pool.accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
779         pool.lastRewardTimestamp = block.timestamp;
780     }
781 
782     // Update reward variables for all pools. Be careful of gas spending!
783     function massUpdatePools() public onlyOwner {
784         uint256 length = poolInfo.length;
785         for (uint256 pid = 0; pid < length; ++pid) {
786             updatePool(pid);
787         }
788     }
789 
790     // Stake primary tokens
791     function deposit(uint256 _amount) public nonReentrant {
792         if(holderUnlockTime[msg.sender] == 0){
793             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
794         }
795         PoolInfo storage pool = poolInfo[0];
796         UserInfo storage user = userInfo[msg.sender];
797 
798         updatePool(0);
799         if (user.amount > 0) {
800             uint256 pending = user.amount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt);
801             if(pending > 0) {
802                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
803                 rewardToken.safeTransfer(address(msg.sender), pending);
804             }
805         }
806         uint256 amountTransferred = 0;
807         if(_amount > 0) {
808             uint256 initialBalance = pool.lpToken.balanceOf(address(this));
809             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
810             amountTransferred = pool.lpToken.balanceOf(address(this)) - initialBalance;
811             user.amount = user.amount.add(amountTransferred);
812             totalStaked += amountTransferred;
813         }
814         user.rewardDebt = user.amount.mul(pool.accTokensPerShare).div(1e12);
815 
816         emit Deposit(msg.sender, _amount);
817     }
818 
819     // Withdraw primary tokens from STAKING.
820 
821     function withdraw() public nonReentrant {
822 
823         require(holderUnlockTime[msg.sender] <= block.timestamp, "May not do normal withdraw early");
824         
825         PoolInfo storage pool = poolInfo[0];
826         UserInfo storage user = userInfo[msg.sender];
827 
828         uint256 _amount = user.amount;
829         updatePool(0);
830         uint256 pending = user.amount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt);
831         if(pending > 0) {
832             require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
833             rewardToken.safeTransfer(address(msg.sender), pending);
834         }
835 
836         if(_amount > 0) {
837             user.amount = 0;
838             totalStaked -= _amount;
839             pool.lpToken.safeTransfer(address(msg.sender), _amount);
840         }
841 
842         user.rewardDebt = user.amount.mul(pool.accTokensPerShare).div(1e12);
843         
844         if(user.amount > 0){
845             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
846         } else {
847             holderUnlockTime[msg.sender] = 0;
848         }
849 
850         emit Withdraw(msg.sender, _amount);
851     }
852 
853     // Withdraw without caring about rewards. EMERGENCY ONLY.
854     function emergencyWithdraw() external nonReentrant {
855         PoolInfo storage pool = poolInfo[0];
856         UserInfo storage user = userInfo[msg.sender];
857         uint256 _amount = user.amount;
858         totalStaked -= _amount;
859         // exit penalty for early unstakers, penalty held on contract as rewards.
860         if(holderUnlockTime[msg.sender] >= block.timestamp){
861             _amount -= _amount * exitPenaltyPerc / 100;
862         }
863         holderUnlockTime[msg.sender] = 0;
864         pool.lpToken.safeTransfer(address(msg.sender), _amount);
865         user.amount = 0;
866         user.rewardDebt = 0;
867         emit EmergencyWithdraw(msg.sender, _amount);
868     }
869 
870     // Withdraw reward. EMERGENCY ONLY. This allows the owner to migrate rewards to a new staking pool since we are not minting new tokens.
871     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
872         require(_amount <= rewardToken.balanceOf(address(this)) - totalStaked, 'not enough tokens to take out');
873         rewardToken.safeTransfer(address(msg.sender), _amount);
874     }
875     
876 
877     function calculateNewRewards() public view returns (uint256) {
878         PoolInfo storage pool = poolInfo[0];
879         if(pool.lastRewardTimestamp > block.timestamp){
880             return 0;
881         }
882         return (((block.timestamp - pool.lastRewardTimestamp) * totalStaked) * apy / 100 / 365 days);
883     }
884 
885     function rewardsRemaining() public view returns (uint256){
886         return rewardToken.balanceOf(address(this)) - totalStaked;
887     }
888 
889     function updateApy(uint256 newApy) external onlyOwner {
890         require(newApy <= 10000, "APY must be below 10000%");
891         updatePool(0);
892         apy = newApy;
893     }
894 
895     function updatelockduration(uint256 newlockDuration) external onlyOwner {
896         require(newlockDuration <= 2419200, "Duration must be below 2 weeks");
897         lockDuration = newlockDuration;
898 
899     }
900 
901     function updateExitPenalty(uint256 newPenaltyPerc) external onlyOwner {
902         require(newPenaltyPerc <= 20, "May not set higher than 20%");
903         exitPenaltyPerc = newPenaltyPerc;
904     }
905 }