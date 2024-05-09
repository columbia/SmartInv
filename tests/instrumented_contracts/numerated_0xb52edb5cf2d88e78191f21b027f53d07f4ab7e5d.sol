1 // File: DogPadStake.sol
2 
3 //SPDX-License-Identifier: MIT
4 
5 
6 pragma solidity 0.8.16;
7 
8 //import "@nomiclabs/buidler/console.sol";
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 contract Context {
21     // Empty internal constructor, to prevent people from mistakenly deploying
22     // an instance of this contract, which should be used via inheritance.
23     constructor() {}
24 
25     function _msgSender() internal view returns (address payable) {
26         return payable(msg.sender);
27     }
28 
29     function _msgData() internal view returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0), 'Ownable: new owner is the zero address');
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, 'SafeMath: addition overflow');
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, 'SafeMath: subtraction overflow');
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(
162         uint256 a,
163         uint256 b,
164         string memory errorMessage
165     ) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, 'SafeMath: multiplication overflow');
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, 'SafeMath: division by zero');
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(
225         uint256 a,
226         uint256 b,
227         string memory errorMessage
228     ) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, 'SafeMath: modulo by zero');
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(
265         uint256 a,
266         uint256 b,
267         string memory errorMessage
268     ) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 
273     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
274         z = x < y ? x : y;
275     }
276 
277     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
278     function sqrt(uint256 y) internal pure returns (uint256 z) {
279         if (y > 3) {
280             z = y;
281             uint256 x = y / 2 + 1;
282             while (x < z) {
283                 z = x;
284                 x = (y / x + x) / 2;
285             }
286         } else if (y != 0) {
287             z = 1;
288         }
289     }
290 }
291 
292 interface IBEP20 {
293     /**
294      * @dev Returns the amount of tokens in existence.
295      */
296     function totalSupply() external view returns (uint256);
297 
298     /**
299      * @dev Returns the token decimals.
300      */
301     function decimals() external view returns (uint8);
302 
303     /**
304      * @dev Returns the token symbol.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the token name.
310      */
311     function name() external view returns (string memory);
312 
313     /**
314      * @dev Returns the bep token owner.
315      */
316     function getOwner() external view returns (address);
317 
318     /**
319      * @dev Returns the amount of tokens owned by `account`.
320      */
321     function balanceOf(address account) external view returns (uint256);
322 
323     /**
324      * @dev Moves `amount` tokens from the caller's account to `recipient`.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transfer(address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Returns the remaining number of tokens that `spender` will be
334      * allowed to spend on behalf of `owner` through {transferFrom}. This is
335      * zero by default.
336      *
337      * This value changes when {approve} or {transferFrom} are called.
338      */
339     function allowance(address _owner, address spender) external view returns (uint256);
340 
341     /**
342      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * IMPORTANT: Beware that changing an allowance with this method brings the risk
347      * that someone may use both the old and the new allowance by unfortunate
348      * transaction ordering. One possible solution to mitigate this race
349      * condition is to first reduce the spender's allowance to 0 and set the
350      * desired value afterwards:
351      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352      *
353      * Emits an {Approval} event.
354      */
355     function approve(address spender, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Moves `amount` tokens from `sender` to `recipient` using the
359      * allowance mechanism. `amount` is then deducted from the caller's
360      * allowance.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transferFrom(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) external returns (bool);
371 
372     /**
373      * @dev Emitted when `value` tokens are moved from one account (`from`) to
374      * another (`to`).
375      *
376      * Note that `value` may be zero.
377      */
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     /**
381      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
382      * a call to {approve}. `value` is the new allowance.
383      */
384     event Approval(address indexed owner, address indexed spender, uint256 value);
385 }
386 
387 /**
388  * @title SafeBEP20
389  * @dev Wrappers around BEP20 operations that throw on failure (when the token
390  * contract returns false). Tokens that return no value (and instead revert or
391  * throw on failure) are also supported, non-reverting calls are assumed to be
392  * successful.
393  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeBEP20 {
397     using SafeMath for uint256;
398     using Address for address;
399 
400     function safeTransfer(
401         IBEP20 token,
402         address to,
403         uint256 value
404     ) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
406     }
407 
408     function safeTransferFrom(
409         IBEP20 token,
410         address from,
411         address to,
412         uint256 value
413     ) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IBEP20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(
425         IBEP20 token,
426         address spender,
427         uint256 value
428     ) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require(
434             (value == 0) || (token.allowance(address(this), spender) == 0),
435             'SafeBEP20: approve from non-zero to non-zero allowance'
436         );
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
438     }
439 
440     function safeIncreaseAllowance(
441         IBEP20 token,
442         address spender,
443         uint256 value
444     ) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).add(value);
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     function safeDecreaseAllowance(
450         IBEP20 token,
451         address spender,
452         uint256 value
453     ) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).sub(
455             value,
456             'SafeBEP20: decreased allowance below zero'
457         );
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     /**
462      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
463      * on the return value: the return value is optional (but if data is returned, it must not be false).
464      * @param token The token targeted by the call.
465      * @param data The call data (encoded using abi.encode or one of its variants).
466      */
467     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
468         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
469         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
470         // the target address contains contract code and also asserts for success in the low-level call.
471 
472         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
473         if (returndata.length > 0) {
474             // Return data is optional
475             // solhint-disable-next-line max-line-length
476             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
477         }
478     }
479 }
480 
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      */
502     function isContract(address account) internal view returns (bool) {
503         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
504         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
505         // for accounts without code, i.e. `keccak256('')`
506         bytes32 codehash;
507         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
508         // solhint-disable-next-line no-inline-assembly
509         assembly {
510             codehash := extcodehash(account)
511         }
512         return (codehash != accountHash && codehash != 0x0);
513     }
514 
515     /**
516      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
517      * `recipient`, forwarding all available gas and reverting on errors.
518      *
519      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
520      * of certain opcodes, possibly making contracts go over the 2300 gas limit
521      * imposed by `transfer`, making them unable to receive funds via
522      * `transfer`. {sendValue} removes this limitation.
523      *
524      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
525      *
526      * IMPORTANT: because control is transferred to `recipient`, care must be
527      * taken to not create reentrancy vulnerabilities. Consider using
528      * {ReentrancyGuard} or the
529      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
530      */
531     function sendValue(address payable recipient, uint256 amount) internal {
532         require(address(this).balance >= amount, 'Address: insufficient balance');
533 
534         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
535         (bool success, ) = recipient.call{value: amount}('');
536         require(success, 'Address: unable to send value, recipient may have reverted');
537     }
538 
539     /**
540      * @dev Performs a Solidity function call using a low level `call`. A
541      * plain`call` is an unsafe replacement for a function call: use this
542      * function instead.
543      *
544      * If `target` reverts with a revert reason, it is bubbled up by this
545      * function (like regular Solidity function calls).
546      *
547      * Returns the raw returned data. To convert to the expected return value,
548      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
549      *
550      * Requirements:
551      *
552      * - `target` must be a contract.
553      * - calling `target` with `data` must not revert.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
558         return functionCall(target, data, 'Address: low-level call failed');
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
563      * `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         return _functionCallWithValue(target, data, 0, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but also transferring `value` wei to `target`.
578      *
579      * Requirements:
580      *
581      * - the calling contract must have an ETH balance of at least `value`.
582      * - the called Solidity function must be `payable`.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value
590     ) internal returns (bytes memory) {
591         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
596      * with `errorMessage` as a fallback revert reason when `target` reverts.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         require(address(this).balance >= value, 'Address: insufficient balance for call');
607         return _functionCallWithValue(target, data, value, errorMessage);
608     }
609 
610     function _functionCallWithValue(
611         address target,
612         bytes memory data,
613         uint256 weiValue,
614         string memory errorMessage
615     ) private returns (bytes memory) {
616         require(isContract(target), 'Address: call to non-contract');
617 
618         // solhint-disable-next-line avoid-low-level-calls
619         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
620         if (success) {
621             return returndata;
622         } else {
623             // Look for revert reason and bubble it up if present
624             if (returndata.length > 0) {
625                 // The easiest way to bubble the revert reason is using memory via assembly
626 
627                 // solhint-disable-next-line no-inline-assembly
628                 assembly {
629                     let returndata_size := mload(returndata)
630                     revert(add(32, returndata), returndata_size)
631                 }
632             } else {
633                 revert(errorMessage);
634             }
635         }
636     }
637 }
638 
639 abstract contract ReentrancyGuard {
640     // Booleans are more expensive than uint256 or any type that takes up a full
641     // word because each write operation emits an extra SLOAD to first read the
642     // slot's contents, replace the bits taken up by the boolean, and then write
643     // back. This is the compiler's defense against contract upgrades and
644     // pointer aliasing, and it cannot be disabled.
645 
646     // The values being non-zero value makes deployment a bit more expensive,
647     // but in exchange the refund on every call to nonReentrant will be lower in
648     // amount. Since refunds are capped to a percentage of the total
649     // transaction's gas, it is best to keep them low in cases like this one, to
650     // increase the likelihood of the full refund coming into effect.
651     uint256 private constant _NOT_ENTERED = 1;
652     uint256 private constant _ENTERED = 2;
653 
654     uint256 private _status;
655 
656     constructor() {
657         _status = _NOT_ENTERED;
658     }
659 
660     /**
661      * @dev Prevents a contract from calling itself, directly or indirectly.
662      * Calling a `nonReentrant` function from another `nonReentrant`
663      * function is not supported. It is possible to prevent this from happening
664      * by making the `nonReentrant` function external, and making it call a
665      * `private` function that does the actual work.
666      */
667     modifier nonReentrant() {
668         // On the first call to nonReentrant, _notEntered will be true
669         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
670 
671         // Any calls to nonReentrant after this point will fail
672         _status = _ENTERED;
673 
674         _;
675 
676         // By storing the original value once again, a refund is triggered (see
677         // https://eips.ethereum.org/EIPS/eip-2200)
678         _status = _NOT_ENTERED;
679     }
680 }
681 
682 contract DogPadStake is Ownable, ReentrancyGuard {
683     using SafeMath for uint256;
684     using SafeBEP20 for IBEP20;
685 
686     // Info of each user.
687     struct UserInfo {
688         uint256 amount;     // How many LP tokens the user has provided.
689         uint256 boostedAmount;
690         uint256 boosts;
691         uint256 rewardDebt; // Reward debt. See explanation below.
692         uint256 pendingPayout; // track any previously pending payouts from boosts
693     }
694 
695     // Info of each pool.
696     struct PoolInfo {
697         IBEP20 lpToken;           // Address of LP token contract.
698         uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
699         uint256 lastRewardTimestamp;  // Last block number that Tokens distribution occurs.
700         uint256 accTokensPerShare; // Accumulated Tokens per share, times 1e12. See below.
701     }
702 
703     IBEP20 public immutable stakingToken;
704     IBEP20 public immutable rewardToken;
705     mapping (address => uint256) public holderUnlockTime;
706 
707     mapping (address => bool) public _isAuthorized;
708 
709     uint256 public totalStaked;
710     uint256 public totalBoostedStaked;
711     uint256 public apr;
712     uint256 public lockDuration;
713     uint256 public exitPenaltyPerc;
714 
715     uint256 public amountPerBoost;
716     uint256 public maxBoostAmount;
717     mapping ( address => uint256) public lastWalletBoostTs;
718     
719     bool public canCompoundOrStakeMore;
720 
721     // Info of each pool.
722     PoolInfo[] public poolInfo;
723     // Info of each user that stakes LP tokens.
724     mapping (address => UserInfo) public userInfo;
725     // Total allocation points. Must be the sum of all allocation points in all pools.
726     uint256 private totalAllocPoint;
727 
728     event Deposit(address indexed user, uint256 amount);
729     event Withdraw(address indexed user, uint256 amount);
730     event Compound(address indexed user);
731     event EmergencyWithdraw(address indexed user, uint256 amount);
732 
733     constructor(address _tokenAddress, uint256 _apr, uint256 _lockDurationInDays, uint256 _exitPenaltyPerc, bool _canCompoundOrStakeMore) {
734         stakingToken = IBEP20(_tokenAddress);
735         rewardToken = IBEP20(_tokenAddress);
736         canCompoundOrStakeMore = _canCompoundOrStakeMore;
737         _isAuthorized[msg.sender] = true;
738 
739         apr = _apr;
740         lockDuration = _lockDurationInDays * 1 days;
741         exitPenaltyPerc = _exitPenaltyPerc;
742 
743         amountPerBoost = 50; // 25% boost per booster
744         maxBoostAmount = 6; // 6 boosts allowed
745 
746         // staking pool
747         poolInfo.push(PoolInfo({
748             lpToken: stakingToken,
749             allocPoint: 1000,
750             lastRewardTimestamp: 99999999999,
751             accTokensPerShare: 0
752         }));
753 
754         totalAllocPoint = 1000;
755 
756     }
757 
758     modifier onlyAuthorized() {
759         require(_isAuthorized[msg.sender], "Not Authorized");
760         _;
761     }
762 
763     function setAuthorization(address account, bool authorized) external onlyOwner {
764         _isAuthorized[account] = authorized;
765     }
766 
767     function stopReward() external onlyOwner {
768         updatePool(0);
769         apr = 0;
770     }
771 
772     function startReward() external onlyOwner {
773         require(poolInfo[0].lastRewardTimestamp == 99999999999, "Can only start rewards once");
774         poolInfo[0].lastRewardTimestamp = block.timestamp;
775     }
776 
777     // View function to see pending Reward on frontend.
778     function pendingReward(address _user) external view returns (uint256) {
779         PoolInfo storage pool = poolInfo[0];
780         UserInfo storage user = userInfo[_user];
781         if(pool.lastRewardTimestamp == 99999999999){
782             return 0;
783         }
784         uint256 accTokensPerShare = pool.accTokensPerShare;
785         uint256 lpSupply = totalBoostedStaked;
786         if (block.timestamp > pool.lastRewardTimestamp && lpSupply != 0) {
787             uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
788             accTokensPerShare = accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
789         }
790         return user.boostedAmount.mul(accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
791     }
792 
793     // Update reward variables of the given pool to be up-to-date.
794     function updatePool(uint256 _pid) internal {
795         PoolInfo storage pool = poolInfo[_pid];
796         if (block.timestamp <= pool.lastRewardTimestamp) {
797             return;
798         }
799         uint256 lpSupply = totalBoostedStaked;
800         if (lpSupply == 0) {
801             pool.lastRewardTimestamp = block.timestamp;
802             return;
803         }
804         uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
805         pool.accTokensPerShare = pool.accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
806         pool.lastRewardTimestamp = block.timestamp;
807     }
808 
809     // Update reward variables for all pools. Be careful of gas spending!
810     function massUpdatePools() public onlyOwner {
811         uint256 length = poolInfo.length;
812         for (uint256 pid = 0; pid < length; ++pid) {
813             updatePool(pid);
814         }
815     }
816 
817     // Stake primary tokens
818     function deposit(uint256 _amount) external nonReentrant {
819         if(holderUnlockTime[msg.sender] == 0){
820             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
821         }
822         PoolInfo storage pool = poolInfo[0];
823         UserInfo storage user = userInfo[msg.sender];
824 
825         if(!canCompoundOrStakeMore && _amount > 0){
826             require(user.boostedAmount == 0, "Cannot stake more");
827         }
828 
829         updatePool(0);
830         if (user.boostedAmount > 0) {
831             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
832             user.pendingPayout = 0;
833             if(pending > 0) {
834                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
835                 rewardToken.safeTransfer(address(msg.sender), pending);
836             }
837         }
838         uint256 amountTransferred = 0;
839         if(_amount > 0) {
840             totalBoostedStaked -= getWalletBoostedAmount(msg.sender);
841             uint256 initialBalance = pool.lpToken.balanceOf(address(this));
842             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
843             amountTransferred = pool.lpToken.balanceOf(address(this)) - initialBalance;
844             user.amount = user.amount.add(amountTransferred);
845             totalStaked += amountTransferred;
846             totalBoostedStaked += getWalletBoostedAmount(msg.sender);
847             user.boostedAmount = getWalletBoostedAmount(msg.sender);
848         }
849         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
850 
851         emit Deposit(msg.sender, _amount);
852     }
853 
854     function compound() external nonReentrant {
855         require(canCompoundOrStakeMore, "Cannot compound");
856         PoolInfo storage pool = poolInfo[0];
857         UserInfo storage user = userInfo[msg.sender];
858 
859         updatePool(0);
860         if (user.boostedAmount > 0) {
861             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
862             user.pendingPayout = 0;
863             if(pending > 0) {
864                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
865                 totalBoostedStaked -= getWalletBoostedAmount(msg.sender);
866                 user.amount += pending;
867                 totalStaked += pending;
868                 totalBoostedStaked += getWalletBoostedAmount(msg.sender);
869                 user.boostedAmount = getWalletBoostedAmount(msg.sender);
870             }
871         }
872 
873         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
874         emit Compound(msg.sender);
875     }
876 
877     // Withdraw primary tokens from STAKING.
878 
879     function withdraw() external nonReentrant {
880 
881         require(holderUnlockTime[msg.sender] <= block.timestamp, "May not do normal withdraw early");
882         
883         PoolInfo storage pool = poolInfo[0];
884         UserInfo storage user = userInfo[msg.sender];
885 
886         uint256 _amount = user.amount;
887         updatePool(0);
888         uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
889         user.pendingPayout = 0;
890         if(pending > 0){
891             require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
892             rewardToken.safeTransfer(address(msg.sender), pending);
893         }
894 
895         if(_amount > 0) {
896             totalBoostedStaked -= user.boostedAmount;
897             user.boostedAmount = 0;
898             user.boosts = 0;
899             user.amount = 0;
900             totalStaked -= _amount;
901             pool.lpToken.safeTransfer(address(msg.sender), _amount);
902         }
903 
904         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
905         
906         if(user.amount > 0){
907             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
908         } else {
909             holderUnlockTime[msg.sender] = 0;
910         }
911 
912         emit Withdraw(msg.sender, _amount);
913     }
914 
915     // Withdraw without caring about rewards. EMERGENCY ONLY.
916     function emergencyWithdraw() external nonReentrant {
917         PoolInfo storage pool = poolInfo[0];
918         UserInfo storage user = userInfo[msg.sender];
919         uint256 _amount = user.amount;
920         totalBoostedStaked -= user.boostedAmount;
921         totalStaked -= _amount;
922         // exit penalty for early unstakers, penalty held on contract as rewards.
923         if(holderUnlockTime[msg.sender] >= block.timestamp){
924             _amount -= _amount * exitPenaltyPerc / 100;
925         }
926         holderUnlockTime[msg.sender] = 0;
927         pool.lpToken.safeTransfer(address(msg.sender), _amount);
928         user.amount = 0;
929         user.boostedAmount = 0;
930         user.boosts = 0;
931         user.rewardDebt = 0;
932         user.pendingPayout = 0;
933         emit EmergencyWithdraw(msg.sender, _amount);
934     }
935 
936     // Withdraw reward. EMERGENCY ONLY. This allows the owner to migrate rewards to a new staking pool since we are not minting new tokens.
937     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
938         require(_amount <= rewardToken.balanceOf(address(this)) - totalStaked, 'not enough tokens to take out');
939         rewardToken.safeTransfer(address(msg.sender), _amount);
940     }
941 
942     function calculateNewRewards() public view returns (uint256) {
943         PoolInfo storage pool = poolInfo[0];
944         if(pool.lastRewardTimestamp > block.timestamp){
945             return 0;
946         }
947         return (((block.timestamp - pool.lastRewardTimestamp) * totalBoostedStaked) * apr / 100 / 365 days);
948     }
949 
950     function rewardsRemaining() public view returns (uint256){
951         return rewardToken.balanceOf(address(this)) - totalStaked;
952     }
953 
954     function updateApr(uint256 newApr) external onlyOwner {
955         require(newApr <= 1000, "APR must be below 1000%");
956         updatePool(0);
957         apr = newApr;
958     }
959 
960     // only applies for new stakers
961     function updateLockDuration(uint256 daysForLock) external onlyOwner {
962         require(daysForLock <= 365, "Lock must be 365 days or less.");
963         lockDuration = daysForLock * 1 days;
964     }
965 
966     function updateExitPenalty(uint256 newPenaltyPerc) external onlyOwner {
967         require(newPenaltyPerc <= 20, "May not set higher than 20%");
968         exitPenaltyPerc = newPenaltyPerc;
969     }
970 
971     function updateCanCompoundOrStakeMore(bool compoundEnabled) external onlyOwner {
972         canCompoundOrStakeMore = compoundEnabled;
973     }
974 
975     function getWalletBoostedAmount(address wallet) public view returns (uint256){
976         UserInfo storage user = userInfo[wallet];
977         return user.amount * (100+(user.boosts*amountPerBoost)) / 100;
978     }
979 
980     function getWalletAPR(address wallet) public view returns (uint256){
981         UserInfo storage user = userInfo[wallet];
982         return apr * (100+(user.boosts*amountPerBoost)) / 100;
983     }
984 
985     function addBoost(address wallet) external onlyAuthorized {
986         
987         PoolInfo storage pool = poolInfo[0];
988         UserInfo storage user = userInfo[wallet];
989         if(user.boosts < maxBoostAmount){
990             updatePool(0);
991             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
992             user.pendingPayout = pending;
993             totalBoostedStaked -= user.boostedAmount;
994             user.boosts += 1;
995             user.boostedAmount = getWalletBoostedAmount(wallet);
996             totalBoostedStaked += user.boostedAmount;
997             user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
998             lastWalletBoostTs[wallet] = block.timestamp;
999         }
1000     }
1001 
1002     function removeBoost(address wallet) external onlyAuthorized {
1003         
1004         PoolInfo storage pool = poolInfo[0];
1005         UserInfo storage user = userInfo[wallet];
1006         if(user.boosts > 0){
1007             updatePool(0);
1008             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1009             user.pendingPayout = pending;
1010             totalBoostedStaked -= user.boostedAmount;
1011             user.boosts -= 1;
1012             user.boostedAmount = getWalletBoostedAmount(wallet);
1013             totalBoostedStaked += user.boostedAmount;
1014             user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1015         }
1016         
1017     }
1018 
1019     function updateBoosters(uint256 newMaxBoostAmount, uint256 newAmountPerBoost) external onlyOwner {
1020         require(newAmountPerBoost <= 100, "amount per boost too high");
1021         maxBoostAmount = newMaxBoostAmount;
1022         amountPerBoost = newAmountPerBoost;
1023     }
1024 }