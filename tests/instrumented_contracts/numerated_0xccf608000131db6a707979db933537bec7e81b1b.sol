1 //SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.16;
5 
6 //import "@nomiclabs/buidler/console.sol";
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     // Empty internal constructor, to prevent people from mistakenly deploying
20     // an instance of this contract, which should be used via inheritance.
21     constructor() {}
22 
23     function _msgSender() internal view returns (address payable) {
24         return payable(msg.sender);
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), 'Ownable: new owner is the zero address');
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, 'SafeMath: addition overflow');
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, 'SafeMath: subtraction overflow');
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(
160         uint256 a,
161         uint256 b,
162         string memory errorMessage
163     ) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, 'SafeMath: multiplication overflow');
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, 'SafeMath: division by zero');
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, 'SafeMath: modulo by zero');
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 
271     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
272         z = x < y ? x : y;
273     }
274 
275     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
276     function sqrt(uint256 y) internal pure returns (uint256 z) {
277         if (y > 3) {
278             z = y;
279             uint256 x = y / 2 + 1;
280             while (x < z) {
281                 z = x;
282                 x = (y / x + x) / 2;
283             }
284         } else if (y != 0) {
285             z = 1;
286         }
287     }
288 }
289 
290 interface IBEP20 {
291     /**
292      * @dev Returns the amount of tokens in existence.
293      */
294     function totalSupply() external view returns (uint256);
295 
296     /**
297      * @dev Returns the token decimals.
298      */
299     function decimals() external view returns (uint8);
300 
301     /**
302      * @dev Returns the token symbol.
303      */
304     function symbol() external view returns (string memory);
305 
306     /**
307      * @dev Returns the token name.
308      */
309     function name() external view returns (string memory);
310 
311     /**
312      * @dev Returns the bep token owner.
313      */
314     function getOwner() external view returns (address);
315 
316     /**
317      * @dev Returns the amount of tokens owned by `account`.
318      */
319     function balanceOf(address account) external view returns (uint256);
320 
321     /**
322      * @dev Moves `amount` tokens from the caller's account to `recipient`.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * Emits a {Transfer} event.
327      */
328     function transfer(address recipient, uint256 amount) external returns (bool);
329 
330     /**
331      * @dev Returns the remaining number of tokens that `spender` will be
332      * allowed to spend on behalf of `owner` through {transferFrom}. This is
333      * zero by default.
334      *
335      * This value changes when {approve} or {transferFrom} are called.
336      */
337     function allowance(address _owner, address spender) external view returns (uint256);
338 
339     /**
340      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * IMPORTANT: Beware that changing an allowance with this method brings the risk
345      * that someone may use both the old and the new allowance by unfortunate
346      * transaction ordering. One possible solution to mitigate this race
347      * condition is to first reduce the spender's allowance to 0 and set the
348      * desired value afterwards:
349      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
350      *
351      * Emits an {Approval} event.
352      */
353     function approve(address spender, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Moves `amount` tokens from `sender` to `recipient` using the
357      * allowance mechanism. `amount` is then deducted from the caller's
358      * allowance.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transferFrom(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) external returns (bool);
369 
370     /**
371      * @dev Emitted when `value` tokens are moved from one account (`from`) to
372      * another (`to`).
373      *
374      * Note that `value` may be zero.
375      */
376     event Transfer(address indexed from, address indexed to, uint256 value);
377 
378     /**
379      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
380      * a call to {approve}. `value` is the new allowance.
381      */
382     event Approval(address indexed owner, address indexed spender, uint256 value);
383 }
384 
385 /**
386  * @title SafeBEP20
387  * @dev Wrappers around BEP20 operations that throw on failure (when the token
388  * contract returns false). Tokens that return no value (and instead revert or
389  * throw on failure) are also supported, non-reverting calls are assumed to be
390  * successful.
391  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
392  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
393  */
394 library SafeBEP20 {
395     using SafeMath for uint256;
396     using Address for address;
397 
398     function safeTransfer(
399         IBEP20 token,
400         address to,
401         uint256 value
402     ) internal {
403         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
404     }
405 
406     function safeTransferFrom(
407         IBEP20 token,
408         address from,
409         address to,
410         uint256 value
411     ) internal {
412         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
413     }
414 
415     /**
416      * @dev Deprecated. This function has issues similar to the ones found in
417      * {IBEP20-approve}, and its usage is discouraged.
418      *
419      * Whenever possible, use {safeIncreaseAllowance} and
420      * {safeDecreaseAllowance} instead.
421      */
422     function safeApprove(
423         IBEP20 token,
424         address spender,
425         uint256 value
426     ) internal {
427         // safeApprove should only be called when setting an initial allowance,
428         // or when resetting it to zero. To increase and decrease it, use
429         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
430         // solhint-disable-next-line max-line-length
431         require(
432             (value == 0) || (token.allowance(address(this), spender) == 0),
433             'SafeBEP20: approve from non-zero to non-zero allowance'
434         );
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
436     }
437 
438     function safeIncreaseAllowance(
439         IBEP20 token,
440         address spender,
441         uint256 value
442     ) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).add(value);
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(
448         IBEP20 token,
449         address spender,
450         uint256 value
451     ) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).sub(
453             value,
454             'SafeBEP20: decreased allowance below zero'
455         );
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
457     }
458 
459     /**
460      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
461      * on the return value: the return value is optional (but if data is returned, it must not be false).
462      * @param token The token targeted by the call.
463      * @param data The call data (encoded using abi.encode or one of its variants).
464      */
465     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
466         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
467         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
468         // the target address contains contract code and also asserts for success in the low-level call.
469 
470         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
471         if (returndata.length > 0) {
472             // Return data is optional
473             // solhint-disable-next-line max-line-length
474             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
475         }
476     }
477 }
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      */
500     function isContract(address account) internal view returns (bool) {
501         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
502         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
503         // for accounts without code, i.e. `keccak256('')`
504         bytes32 codehash;
505         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
506         // solhint-disable-next-line no-inline-assembly
507         assembly {
508             codehash := extcodehash(account)
509         }
510         return (codehash != accountHash && codehash != 0x0);
511     }
512 
513     /**
514      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
515      * `recipient`, forwarding all available gas and reverting on errors.
516      *
517      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
518      * of certain opcodes, possibly making contracts go over the 2300 gas limit
519      * imposed by `transfer`, making them unable to receive funds via
520      * `transfer`. {sendValue} removes this limitation.
521      *
522      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
523      *
524      * IMPORTANT: because control is transferred to `recipient`, care must be
525      * taken to not create reentrancy vulnerabilities. Consider using
526      * {ReentrancyGuard} or the
527      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
528      */
529     function sendValue(address payable recipient, uint256 amount) internal {
530         require(address(this).balance >= amount, 'Address: insufficient balance');
531 
532         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
533         (bool success, ) = recipient.call{value: amount}('');
534         require(success, 'Address: unable to send value, recipient may have reverted');
535     }
536 
537     /**
538      * @dev Performs a Solidity function call using a low level `call`. A
539      * plain`call` is an unsafe replacement for a function call: use this
540      * function instead.
541      *
542      * If `target` reverts with a revert reason, it is bubbled up by this
543      * function (like regular Solidity function calls).
544      *
545      * Returns the raw returned data. To convert to the expected return value,
546      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
547      *
548      * Requirements:
549      *
550      * - `target` must be a contract.
551      * - calling `target` with `data` must not revert.
552      *
553      * _Available since v3.1._
554      */
555     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
556         return functionCall(target, data, 'Address: low-level call failed');
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
561      * `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         return _functionCallWithValue(target, data, 0, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but also transferring `value` wei to `target`.
576      *
577      * Requirements:
578      *
579      * - the calling contract must have an ETH balance of at least `value`.
580      * - the called Solidity function must be `payable`.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(
585         address target,
586         bytes memory data,
587         uint256 value
588     ) internal returns (bytes memory) {
589         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
594      * with `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(
599         address target,
600         bytes memory data,
601         uint256 value,
602         string memory errorMessage
603     ) internal returns (bytes memory) {
604         require(address(this).balance >= value, 'Address: insufficient balance for call');
605         return _functionCallWithValue(target, data, value, errorMessage);
606     }
607 
608     function _functionCallWithValue(
609         address target,
610         bytes memory data,
611         uint256 weiValue,
612         string memory errorMessage
613     ) private returns (bytes memory) {
614         require(isContract(target), 'Address: call to non-contract');
615 
616         // solhint-disable-next-line avoid-low-level-calls
617         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
618         if (success) {
619             return returndata;
620         } else {
621             // Look for revert reason and bubble it up if present
622             if (returndata.length > 0) {
623                 // The easiest way to bubble the revert reason is using memory via assembly
624 
625                 // solhint-disable-next-line no-inline-assembly
626                 assembly {
627                     let returndata_size := mload(returndata)
628                     revert(add(32, returndata), returndata_size)
629                 }
630             } else {
631                 revert(errorMessage);
632             }
633         }
634     }
635 }
636 
637 abstract contract ReentrancyGuard {
638     // Booleans are more expensive than uint256 or any type that takes up a full
639     // word because each write operation emits an extra SLOAD to first read the
640     // slot's contents, replace the bits taken up by the boolean, and then write
641     // back. This is the compiler's defense against contract upgrades and
642     // pointer aliasing, and it cannot be disabled.
643 
644     // The values being non-zero value makes deployment a bit more expensive,
645     // but in exchange the refund on every call to nonReentrant will be lower in
646     // amount. Since refunds are capped to a percentage of the total
647     // transaction's gas, it is best to keep them low in cases like this one, to
648     // increase the likelihood of the full refund coming into effect.
649     uint256 private constant _NOT_ENTERED = 1;
650     uint256 private constant _ENTERED = 2;
651 
652     uint256 private _status;
653 
654     constructor() {
655         _status = _NOT_ENTERED;
656     }
657 
658     /**
659      * @dev Prevents a contract from calling itself, directly or indirectly.
660      * Calling a `nonReentrant` function from another `nonReentrant`
661      * function is not supported. It is possible to prevent this from happening
662      * by making the `nonReentrant` function external, and making it call a
663      * `private` function that does the actual work.
664      */
665     modifier nonReentrant() {
666         // On the first call to nonReentrant, _notEntered will be true
667         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
668 
669         // Any calls to nonReentrant after this point will fail
670         _status = _ENTERED;
671 
672         _;
673 
674         // By storing the original value once again, a refund is triggered (see
675         // https://eips.ethereum.org/EIPS/eip-2200)
676         _status = _NOT_ENTERED;
677     }
678 }
679 
680 contract FixedAPRSoloStakingWithBoosts is Ownable, ReentrancyGuard {
681     using SafeMath for uint256;
682     using SafeBEP20 for IBEP20;
683 
684     // Info of each user.
685     struct UserInfo {
686         uint256 amount;     // How many LP tokens the user has provided.
687         uint256 boostedAmount;
688         uint256 boosts;
689         uint256 rewardDebt; // Reward debt. See explanation below.
690         uint256 pendingPayout; // track any previously pending payouts from boosts
691     }
692 
693     // Info of each pool.
694     struct PoolInfo {
695         IBEP20 lpToken;           // Address of LP token contract.
696         uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
697         uint256 lastRewardTimestamp;  // Last block number that Tokens distribution occurs.
698         uint256 accTokensPerShare; // Accumulated Tokens per share, times 1e12. See below.
699     }
700 
701     IBEP20 public immutable stakingToken;
702     IBEP20 public immutable rewardToken;
703     mapping (address => uint256) public holderUnlockTime;
704 
705     mapping (address => bool) public _isAuthorized;
706 
707     uint256 public totalStaked;
708     uint256 public totalBoostedStaked;
709     uint256 public apr;
710     uint256 public lockDuration;
711     uint256 public exitPenaltyPerc;
712 
713     uint256 public amountPerBoost;
714     uint256 public maxBoostAmount;
715     mapping ( address => uint256) public lastWalletBoostTs;
716     
717     bool public canCompoundOrStakeMore;
718 
719     // Info of each pool.
720     PoolInfo[] public poolInfo;
721     // Info of each user that stakes LP tokens.
722     mapping (address => UserInfo) public userInfo;
723     // Total allocation points. Must be the sum of all allocation points in all pools.
724     uint256 private totalAllocPoint;
725 
726     event Deposit(address indexed user, uint256 amount);
727     event Withdraw(address indexed user, uint256 amount);
728     event Compound(address indexed user);
729     event EmergencyWithdraw(address indexed user, uint256 amount);
730 
731     constructor(address _tokenAddress, uint256 _apr, uint256 _lockDurationInDays, uint256 _exitPenaltyPerc, bool _canCompoundOrStakeMore) {
732         stakingToken = IBEP20(_tokenAddress);
733         rewardToken = IBEP20(_tokenAddress);
734         canCompoundOrStakeMore = _canCompoundOrStakeMore;
735         _isAuthorized[msg.sender] = true;
736 
737         apr = _apr;
738         lockDuration = _lockDurationInDays * 1 days;
739         exitPenaltyPerc = _exitPenaltyPerc;
740 
741         amountPerBoost = 50; // 25% boost per booster
742         maxBoostAmount = 6; // 6 boosts allowed
743 
744         // staking pool
745         poolInfo.push(PoolInfo({
746             lpToken: stakingToken,
747             allocPoint: 1000,
748             lastRewardTimestamp: 99999999999,
749             accTokensPerShare: 0
750         }));
751 
752         totalAllocPoint = 1000;
753 
754     }
755 
756     modifier onlyAuthorized() {
757         require(_isAuthorized[msg.sender], "Not Authorized");
758         _;
759     }
760 
761     function setAuthorization(address account, bool authorized) external onlyOwner {
762         _isAuthorized[account] = authorized;
763     }
764 
765     function stopReward() external onlyOwner {
766         updatePool(0);
767         apr = 0;
768     }
769 
770     function startReward() external onlyOwner {
771         require(poolInfo[0].lastRewardTimestamp == 99999999999, "Can only start rewards once");
772         poolInfo[0].lastRewardTimestamp = block.timestamp;
773     }
774 
775     // View function to see pending Reward on frontend.
776     function pendingReward(address _user) external view returns (uint256) {
777         PoolInfo storage pool = poolInfo[0];
778         UserInfo storage user = userInfo[_user];
779         if(pool.lastRewardTimestamp == 99999999999){
780             return 0;
781         }
782         uint256 accTokensPerShare = pool.accTokensPerShare;
783         uint256 lpSupply = totalBoostedStaked;
784         if (block.timestamp > pool.lastRewardTimestamp && lpSupply != 0) {
785             uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
786             accTokensPerShare = accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
787         }
788         return user.boostedAmount.mul(accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
789     }
790 
791     // Update reward variables of the given pool to be up-to-date.
792     function updatePool(uint256 _pid) internal {
793         PoolInfo storage pool = poolInfo[_pid];
794         if (block.timestamp <= pool.lastRewardTimestamp) {
795             return;
796         }
797         uint256 lpSupply = totalBoostedStaked;
798         if (lpSupply == 0) {
799             pool.lastRewardTimestamp = block.timestamp;
800             return;
801         }
802         uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
803         pool.accTokensPerShare = pool.accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
804         pool.lastRewardTimestamp = block.timestamp;
805     }
806 
807     // Update reward variables for all pools. Be careful of gas spending!
808     function massUpdatePools() public onlyOwner {
809         uint256 length = poolInfo.length;
810         for (uint256 pid = 0; pid < length; ++pid) {
811             updatePool(pid);
812         }
813     }
814 
815     // Stake primary tokens
816     function deposit(uint256 _amount) external nonReentrant {
817         if(holderUnlockTime[msg.sender] == 0){
818             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
819         }
820         PoolInfo storage pool = poolInfo[0];
821         UserInfo storage user = userInfo[msg.sender];
822 
823         if(!canCompoundOrStakeMore && _amount > 0){
824             require(user.boostedAmount == 0, "Cannot stake more");
825         }
826 
827         updatePool(0);
828         if (user.boostedAmount > 0) {
829             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
830             user.pendingPayout = 0;
831             if(pending > 0) {
832                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
833                 rewardToken.safeTransfer(address(msg.sender), pending);
834             }
835         }
836         uint256 amountTransferred = 0;
837         if(_amount > 0) {
838             totalBoostedStaked -= getWalletBoostedAmount(msg.sender);
839             uint256 initialBalance = pool.lpToken.balanceOf(address(this));
840             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
841             amountTransferred = pool.lpToken.balanceOf(address(this)) - initialBalance;
842             user.amount = user.amount.add(amountTransferred);
843             totalStaked += amountTransferred;
844             totalBoostedStaked += getWalletBoostedAmount(msg.sender);
845             user.boostedAmount = getWalletBoostedAmount(msg.sender);
846         }
847         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
848 
849         emit Deposit(msg.sender, _amount);
850     }
851 
852     function compound() external nonReentrant {
853         require(canCompoundOrStakeMore, "Cannot compound");
854         PoolInfo storage pool = poolInfo[0];
855         UserInfo storage user = userInfo[msg.sender];
856 
857         updatePool(0);
858         if (user.boostedAmount > 0) {
859             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
860             user.pendingPayout = 0;
861             if(pending > 0) {
862                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
863                 totalBoostedStaked -= getWalletBoostedAmount(msg.sender);
864                 user.amount += pending;
865                 totalStaked += pending;
866                 totalBoostedStaked += getWalletBoostedAmount(msg.sender);
867                 user.boostedAmount = getWalletBoostedAmount(msg.sender);
868             }
869         }
870 
871         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
872         emit Compound(msg.sender);
873     }
874 
875     // Withdraw primary tokens from STAKING.
876 
877     function withdraw() external nonReentrant {
878 
879         require(holderUnlockTime[msg.sender] <= block.timestamp, "May not do normal withdraw early");
880         
881         PoolInfo storage pool = poolInfo[0];
882         UserInfo storage user = userInfo[msg.sender];
883 
884         uint256 _amount = user.amount;
885         updatePool(0);
886         uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
887         user.pendingPayout = 0;
888         if(pending > 0){
889             require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
890             rewardToken.safeTransfer(address(msg.sender), pending);
891         }
892 
893         if(_amount > 0) {
894             totalBoostedStaked -= user.boostedAmount;
895             user.boostedAmount = 0;
896             user.boosts = 0;
897             user.amount = 0;
898             totalStaked -= _amount;
899             pool.lpToken.safeTransfer(address(msg.sender), _amount);
900         }
901 
902         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
903         
904         if(user.amount > 0){
905             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
906         } else {
907             holderUnlockTime[msg.sender] = 0;
908         }
909 
910         emit Withdraw(msg.sender, _amount);
911     }
912 
913     // Withdraw without caring about rewards. EMERGENCY ONLY.
914     function emergencyWithdraw() external nonReentrant {
915         PoolInfo storage pool = poolInfo[0];
916         UserInfo storage user = userInfo[msg.sender];
917         uint256 _amount = user.amount;
918         totalBoostedStaked -= user.boostedAmount;
919         totalStaked -= _amount;
920         // exit penalty for early unstakers, penalty held on contract as rewards.
921         if(holderUnlockTime[msg.sender] >= block.timestamp){
922             _amount -= _amount * exitPenaltyPerc / 100;
923         }
924         holderUnlockTime[msg.sender] = 0;
925         pool.lpToken.safeTransfer(address(msg.sender), _amount);
926         user.amount = 0;
927         user.boostedAmount = 0;
928         user.boosts = 0;
929         user.rewardDebt = 0;
930         user.pendingPayout = 0;
931         emit EmergencyWithdraw(msg.sender, _amount);
932     }
933 
934     // Withdraw reward. EMERGENCY ONLY. This allows the owner to migrate rewards to a new staking pool since we are not minting new tokens.
935     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
936         require(_amount <= rewardToken.balanceOf(address(this)) - totalStaked, 'not enough tokens to take out');
937         rewardToken.safeTransfer(address(msg.sender), _amount);
938     }
939 
940     function calculateNewRewards() public view returns (uint256) {
941         PoolInfo storage pool = poolInfo[0];
942         if(pool.lastRewardTimestamp > block.timestamp){
943             return 0;
944         }
945         return (((block.timestamp - pool.lastRewardTimestamp) * totalBoostedStaked) * apr / 100 / 365 days);
946     }
947 
948     function rewardsRemaining() public view returns (uint256){
949         return rewardToken.balanceOf(address(this)) - totalStaked;
950     }
951 
952     function updateApr(uint256 newApr) external onlyOwner {
953         require(newApr <= 1000, "APR must be below 1000%");
954         updatePool(0);
955         apr = newApr;
956     }
957 
958     // only applies for new stakers
959     function updateLockDuration(uint256 daysForLock) external onlyOwner {
960         require(daysForLock <= 365, "Lock must be 365 days or less.");
961         lockDuration = daysForLock * 1 days;
962     }
963 
964     function updateExitPenalty(uint256 newPenaltyPerc) external onlyOwner {
965         require(newPenaltyPerc <= 20, "May not set higher than 20%");
966         exitPenaltyPerc = newPenaltyPerc;
967     }
968 
969     function updateCanCompoundOrStakeMore(bool compoundEnabled) external onlyOwner {
970         canCompoundOrStakeMore = compoundEnabled;
971     }
972 
973     function getWalletBoostedAmount(address wallet) public view returns (uint256){
974         UserInfo storage user = userInfo[wallet];
975         return user.amount * (100+(user.boosts*amountPerBoost)) / 100;
976     }
977 
978     function getWalletAPR(address wallet) public view returns (uint256){
979         UserInfo storage user = userInfo[wallet];
980         return apr * (100+(user.boosts*amountPerBoost)) / 100;
981     }
982 
983     function addBoost(address wallet) external onlyAuthorized {
984         
985         PoolInfo storage pool = poolInfo[0];
986         UserInfo storage user = userInfo[wallet];
987         if(user.boosts < maxBoostAmount){
988             updatePool(0);
989             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
990             user.pendingPayout = pending;
991             totalBoostedStaked -= user.boostedAmount;
992             user.boosts += 1;
993             user.boostedAmount = getWalletBoostedAmount(wallet);
994             totalBoostedStaked += user.boostedAmount;
995             user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
996             lastWalletBoostTs[wallet] = block.timestamp;
997         }
998     }
999 
1000     function removeBoost(address wallet) external onlyAuthorized {
1001         
1002         PoolInfo storage pool = poolInfo[0];
1003         UserInfo storage user = userInfo[wallet];
1004         if(user.boosts > 0){
1005             updatePool(0);
1006             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1007             user.pendingPayout = pending;
1008             totalBoostedStaked -= user.boostedAmount;
1009             user.boosts -= 1;
1010             user.boostedAmount = getWalletBoostedAmount(wallet);
1011             totalBoostedStaked += user.boostedAmount;
1012             user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1013         }
1014         
1015     }
1016 
1017     function updateBoosters(uint256 newMaxBoostAmount, uint256 newAmountPerBoost) external onlyOwner {
1018         require(newAmountPerBoost <= 100, "amount per boost too high");
1019         maxBoostAmount = newMaxBoostAmount;
1020         amountPerBoost = newAmountPerBoost;
1021     }
1022 }