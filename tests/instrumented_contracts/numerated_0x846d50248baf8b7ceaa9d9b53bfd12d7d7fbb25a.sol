1 /**
2  *Submitted for verification at BscScan.com on 2021-03-08
3 */
4 
5 // File: @pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol
6 
7 
8 pragma solidity >=0.4.0;
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      *
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, 'SafeMath: addition overflow');
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      *
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, 'SafeMath: subtraction overflow');
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(
66         uint256 a,
67         uint256 b,
68         string memory errorMessage
69     ) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `*` operator.
81      *
82      * Requirements:
83      *
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, 'SafeMath: multiplication overflow');
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      *
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, 'SafeMath: division by zero');
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      *
126      * - The divisor cannot be zero.
127      */
128     function div(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return mod(a, b, 'SafeMath: modulo by zero');
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts with custom message when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function mod(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         require(b != 0, errorMessage);
174         return a % b;
175     }
176 
177     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
178         z = x < y ? x : y;
179     }
180 
181     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
182     function sqrt(uint256 y) internal pure returns (uint256 z) {
183         if (y > 3) {
184             z = y;
185             uint256 x = y / 2 + 1;
186             while (x < z) {
187                 z = x;
188                 x = (y / x + x) / 2;
189             }
190         } else if (y != 0) {
191             z = 1;
192         }
193     }
194 }
195 
196 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol
197 
198 
199 pragma solidity >=0.4.0;
200 
201 interface IBEP20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the token decimals.
209      */
210     function decimals() external view returns (uint8);
211 
212     /**
213      * @dev Returns the token symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the token name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the bep token owner.
224      */
225     function getOwner() external view returns (address);
226 
227     /**
228      * @dev Returns the amount of tokens owned by `account`.
229      */
230     function balanceOf(address account) external view returns (uint256);
231 
232     /**
233      * @dev Moves `amount` tokens from the caller's account to `recipient`.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transfer(address recipient, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Returns the remaining number of tokens that `spender` will be
243      * allowed to spend on behalf of `owner` through {transferFrom}. This is
244      * zero by default.
245      *
246      * This value changes when {approve} or {transferFrom} are called.
247      */
248     function allowance(address _owner, address spender) external view returns (uint256);
249 
250     /**
251      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * IMPORTANT: Beware that changing an allowance with this method brings the risk
256      * that someone may use both the old and the new allowance by unfortunate
257      * transaction ordering. One possible solution to mitigate this race
258      * condition is to first reduce the spender's allowance to 0 and set the
259      * desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      *
262      * Emits an {Approval} event.
263      */
264     function approve(address spender, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Moves `amount` tokens from `sender` to `recipient` using the
268      * allowance mechanism. `amount` is then deducted from the caller's
269      * allowance.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) external returns (bool);
280 
281     /**
282      * @dev Emitted when `value` tokens are moved from one account (`from`) to
283      * another (`to`).
284      *
285      * Note that `value` may be zero.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     /**
290      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
291      * a call to {approve}. `value` is the new allowance.
292      */
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 // File: @pancakeswap/pancake-swap-lib/contracts/utils/Address.sol
297 
298 
299 pragma solidity ^0.6.2;
300 
301 /**
302  * @dev Collection of functions related to the address type
303  */
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
324         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
325         // for accounts without code, i.e. `keccak256('')`
326         bytes32 codehash;
327         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
328         // solhint-disable-next-line no-inline-assembly
329         assembly {
330             codehash := extcodehash(account)
331         }
332         return (codehash != accountHash && codehash != 0x0);
333     }
334 
335     /**
336      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
337      * `recipient`, forwarding all available gas and reverting on errors.
338      *
339      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
340      * of certain opcodes, possibly making contracts go over the 2300 gas limit
341      * imposed by `transfer`, making them unable to receive funds via
342      * `transfer`. {sendValue} removes this limitation.
343      *
344      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
345      *
346      * IMPORTANT: because control is transferred to `recipient`, care must be
347      * taken to not create reentrancy vulnerabilities. Consider using
348      * {ReentrancyGuard} or the
349      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
350      */
351     function sendValue(address payable recipient, uint256 amount) internal {
352         require(address(this).balance >= amount, 'Address: insufficient balance');
353 
354         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
355         (bool success, ) = recipient.call{value: amount}('');
356         require(success, 'Address: unable to send value, recipient may have reverted');
357     }
358 
359     /**
360      * @dev Performs a Solidity function call using a low level `call`. A
361      * plain`call` is an unsafe replacement for a function call: use this
362      * function instead.
363      *
364      * If `target` reverts with a revert reason, it is bubbled up by this
365      * function (like regular Solidity function calls).
366      *
367      * Returns the raw returned data. To convert to the expected return value,
368      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
369      *
370      * Requirements:
371      *
372      * - `target` must be a contract.
373      * - calling `target` with `data` must not revert.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionCall(target, data, 'Address: low-level call failed');
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
383      * `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         return _functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(address(this).balance >= value, 'Address: insufficient balance for call');
427         return _functionCallWithValue(target, data, value, errorMessage);
428     }
429 
430     function _functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 weiValue,
434         string memory errorMessage
435     ) private returns (bytes memory) {
436         require(isContract(target), 'Address: call to non-contract');
437 
438         // solhint-disable-next-line avoid-low-level-calls
439         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 // solhint-disable-next-line no-inline-assembly
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol
460 
461 
462 pragma solidity ^0.6.0;
463 
464 
465 
466 
467 /**
468  * @title SafeBEP20
469  * @dev Wrappers around BEP20 operations that throw on failure (when the token
470  * contract returns false). Tokens that return no value (and instead revert or
471  * throw on failure) are also supported, non-reverting calls are assumed to be
472  * successful.
473  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
474  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
475  */
476 library SafeBEP20 {
477     using SafeMath for uint256;
478     using Address for address;
479 
480     function safeTransfer(
481         IBEP20 token,
482         address to,
483         uint256 value
484     ) internal {
485         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
486     }
487 
488     function safeTransferFrom(
489         IBEP20 token,
490         address from,
491         address to,
492         uint256 value
493     ) internal {
494         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
495     }
496 
497     /**
498      * @dev Deprecated. This function has issues similar to the ones found in
499      * {IBEP20-approve}, and its usage is discouraged.
500      *
501      * Whenever possible, use {safeIncreaseAllowance} and
502      * {safeDecreaseAllowance} instead.
503      */
504     function safeApprove(
505         IBEP20 token,
506         address spender,
507         uint256 value
508     ) internal {
509         // safeApprove should only be called when setting an initial allowance,
510         // or when resetting it to zero. To increase and decrease it, use
511         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
512         // solhint-disable-next-line max-line-length
513         require(
514             (value == 0) || (token.allowance(address(this), spender) == 0),
515             'SafeBEP20: approve from non-zero to non-zero allowance'
516         );
517         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
518     }
519 
520     function safeIncreaseAllowance(
521         IBEP20 token,
522         address spender,
523         uint256 value
524     ) internal {
525         uint256 newAllowance = token.allowance(address(this), spender).add(value);
526         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
527     }
528 
529     function safeDecreaseAllowance(
530         IBEP20 token,
531         address spender,
532         uint256 value
533     ) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).sub(
535             value,
536             'SafeBEP20: decreased allowance below zero'
537         );
538         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
539     }
540 
541     /**
542      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
543      * on the return value: the return value is optional (but if data is returned, it must not be false).
544      * @param token The token targeted by the call.
545      * @param data The call data (encoded using abi.encode or one of its variants).
546      */
547     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
548         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
549         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
550         // the target address contains contract code and also asserts for success in the low-level call.
551 
552         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
553         if (returndata.length > 0) {
554             // Return data is optional
555             // solhint-disable-next-line max-line-length
556             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
557         }
558     }
559 }
560 
561 // File: @pancakeswap/pancake-swap-lib/contracts/GSN/Context.sol
562 
563 
564 pragma solidity >=0.4.0;
565 
566 /*
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with GSN meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 contract Context {
577     // Empty internal constructor, to prevent people from mistakenly deploying
578     // an instance of this contract, which should be used via inheritance.
579     constructor() internal {}
580 
581     function _msgSender() internal view returns (address payable) {
582         return msg.sender;
583     }
584 
585     function _msgData() internal view returns (bytes memory) {
586         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
587         return msg.data;
588     }
589 }
590 
591 // File: @pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol
592 
593 
594 pragma solidity >=0.4.0;
595 
596 
597 /**
598  * @dev Contract module which provides a basic access control mechanism, where
599  * there is an account (an owner) that can be granted exclusive access to
600  * specific functions.
601  *
602  * By default, the owner account will be the one that deploys the contract. This
603  * can later be changed with {transferOwnership}.
604  *
605  * This module is used through inheritance. It will make available the modifier
606  * `onlyOwner`, which can be applied to your functions to restrict their use to
607  * the owner.
608  */
609 contract Ownable is Context {
610     address private _owner;
611 
612     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
613 
614     /**
615      * @dev Initializes the contract setting the deployer as the initial owner.
616      */
617     constructor() internal {
618         address msgSender = _msgSender();
619         _owner = msgSender;
620         emit OwnershipTransferred(address(0), msgSender);
621     }
622 
623     /**
624      * @dev Returns the address of the current owner.
625      */
626     function owner() public view returns (address) {
627         return _owner;
628     }
629 
630     /**
631      * @dev Throws if called by any account other than the owner.
632      */
633     modifier onlyOwner() {
634         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
635         _;
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions anymore. Can only be called by the current owner.
641      *
642      * NOTE: Renouncing ownership will leave the contract without an owner,
643      * thereby removing any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public onlyOwner {
646         emit OwnershipTransferred(_owner, address(0));
647         _owner = address(0);
648     }
649 
650     /**
651      * @dev Transfers ownership of the contract to a new account (`newOwner`).
652      * Can only be called by the current owner.
653      */
654     function transferOwnership(address newOwner) public onlyOwner {
655         _transferOwnership(newOwner);
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      */
661     function _transferOwnership(address newOwner) internal {
662         require(newOwner != address(0), 'Ownable: new owner is the zero address');
663         emit OwnershipTransferred(_owner, newOwner);
664         _owner = newOwner;
665     }
666 }
667 
668 // File: contracts/SmartChef.sol
669 
670 pragma solidity 0.6.12;
671 
672 
673 
674 
675 
676 // import "@nomiclabs/buidler/console.sol";
677 
678 
679 contract SmartChef is Ownable {
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
692         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
693         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
694         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
695     }
696 
697     // The CAKE TOKEN!
698     IBEP20 public syrup;
699     IBEP20 public rewardToken;
700 
701     // uint256 public maxStaking;
702 
703     // CAKE tokens created per block.
704     uint256 public rewardPerBlock;
705 
706     // Info of each pool.
707     PoolInfo[] public poolInfo;
708     // Info of each user that stakes LP tokens.
709     mapping (address => UserInfo) public userInfo;
710     // Total allocation poitns. Must be the sum of all allocation points in all pools.
711     uint256 private totalAllocPoint = 0;
712     // The block number when CAKE mining starts.
713     uint256 public startBlock;
714     // The block number when CAKE mining ends.
715     uint256 public bonusEndBlock;
716 
717     event Deposit(address indexed user, uint256 amount);
718     event Withdraw(address indexed user, uint256 amount);
719     event EmergencyWithdraw(address indexed user, uint256 amount);
720 
721     constructor(
722         IBEP20 _syrup,
723         IBEP20 _rewardToken,
724         uint256 _rewardPerBlock,
725         uint256 _startBlock,
726         uint256 _bonusEndBlock
727     ) public {
728         syrup = _syrup;
729         rewardToken = _rewardToken;
730         rewardPerBlock = _rewardPerBlock;
731         startBlock = _startBlock;
732         bonusEndBlock = _bonusEndBlock;
733 
734         // staking pool
735         poolInfo.push(PoolInfo({
736             lpToken: _syrup,
737             allocPoint: 1000,
738             lastRewardBlock: startBlock,
739             accCakePerShare: 0
740         }));
741 
742         totalAllocPoint = 1000;
743         // maxStaking = 50000000000000000000;
744 
745     }
746 
747     function stopReward() public onlyOwner {
748         bonusEndBlock = block.number;
749     }
750 
751 
752     // Return reward multiplier over the given _from to _to block.
753     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
754         if (_to <= bonusEndBlock) {
755             return _to.sub(_from);
756         } else if (_from >= bonusEndBlock) {
757             return 0;
758         } else {
759             return bonusEndBlock.sub(_from);
760         }
761     }
762 
763     // View function to see pending Reward on frontend.
764     function pendingReward(address _user) external view returns (uint256) {
765         PoolInfo storage pool = poolInfo[0];
766         UserInfo storage user = userInfo[_user];
767         uint256 accCakePerShare = pool.accCakePerShare;
768         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
769         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
770             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
771             uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
772             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
773         }
774         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
775     }
776 
777     // Update reward variables of the given pool to be up-to-date.
778     function updatePool(uint256 _pid) public {
779         PoolInfo storage pool = poolInfo[_pid];
780         if (block.number <= pool.lastRewardBlock) {
781             return;
782         }
783         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
784         if (lpSupply == 0) {
785             pool.lastRewardBlock = block.number;
786             return;
787         }
788         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
789         uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
790         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
791         pool.lastRewardBlock = block.number;
792     }
793 
794     // Update reward variables for all pools. Be careful of gas spending!
795     function massUpdatePools() public {
796         uint256 length = poolInfo.length;
797         for (uint256 pid = 0; pid < length; ++pid) {
798             updatePool(pid);
799         }
800     }
801 
802 
803     // Stake SYRUP tokens to SmartChef
804     function deposit(uint256 _amount) public {
805         PoolInfo storage pool = poolInfo[0];
806         UserInfo storage user = userInfo[msg.sender];
807 
808         // require (_amount.add(user.amount) <= maxStaking, 'exceed max stake');
809 
810         updatePool(0);
811         if (user.amount > 0) {
812             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
813             if(pending > 0) {
814                 rewardToken.safeTransfer(address(msg.sender), pending);
815             }
816         }
817         if(_amount > 0) {
818             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
819             user.amount = user.amount.add(_amount);
820         }
821         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
822 
823         emit Deposit(msg.sender, _amount);
824     }
825 
826     // Withdraw SYRUP tokens from STAKING.
827     function withdraw(uint256 _amount) public {
828         PoolInfo storage pool = poolInfo[0];
829         UserInfo storage user = userInfo[msg.sender];
830         require(user.amount >= _amount, "withdraw: not good");
831         updatePool(0);
832         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
833         if(pending > 0) {
834             rewardToken.safeTransfer(address(msg.sender), pending);
835         }
836         if(_amount > 0) {
837             user.amount = user.amount.sub(_amount);
838             pool.lpToken.safeTransfer(address(msg.sender), _amount);
839         }
840         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
841 
842         emit Withdraw(msg.sender, _amount);
843     }
844 
845     // Withdraw without caring about rewards. EMERGENCY ONLY.
846     function emergencyWithdraw() public {
847         PoolInfo storage pool = poolInfo[0];
848         UserInfo storage user = userInfo[msg.sender];
849         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
850         user.amount = 0;
851         user.rewardDebt = 0;
852         emit EmergencyWithdraw(msg.sender, user.amount);
853     }
854 
855     // Withdraw reward. EMERGENCY ONLY.
856     function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
857         require(_amount < rewardToken.balanceOf(address(this)), 'not enough token');
858         rewardToken.safeTransfer(address(msg.sender), _amount);
859     }
860 
861 }