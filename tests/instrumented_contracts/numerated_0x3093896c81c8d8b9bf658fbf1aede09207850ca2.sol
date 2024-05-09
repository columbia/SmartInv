1 // File: SafeMath.sol
2 
3 
4 pragma solidity >=0.4.0;
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
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, 'SafeMath: addition overflow');
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, 'SafeMath: subtraction overflow');
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(
62         uint256 a,
63         uint256 b,
64         string memory errorMessage
65     ) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, 'SafeMath: multiplication overflow');
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, 'SafeMath: division by zero');
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(
125         uint256 a,
126         uint256 b,
127         string memory errorMessage
128     ) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return mod(a, b, 'SafeMath: modulo by zero');
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts with custom message when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      *
162      * - The divisor cannot be zero.
163      */
164     function mod(
165         uint256 a,
166         uint256 b,
167         string memory errorMessage
168     ) internal pure returns (uint256) {
169         require(b != 0, errorMessage);
170         return a % b;
171     }
172 
173     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
174         z = x < y ? x : y;
175     }
176 
177     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
178     function sqrt(uint256 y) internal pure returns (uint256 z) {
179         if (y > 3) {
180             z = y;
181             uint256 x = y / 2 + 1;
182             while (x < z) {
183                 z = x;
184                 x = (y / x + x) / 2;
185             }
186         } else if (y != 0) {
187             z = 1;
188         }
189     }
190 }
191 
192 // File: IBEP20.sol
193 
194 
195 pragma solidity >=0.4.0;
196 
197 interface IBEP20 {
198     /**
199      * @dev Returns the amount of tokens in existence.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     /**
204      * @dev Returns the token decimals.
205      */
206     function decimals() external view returns (uint8);
207 
208     /**
209      * @dev Returns the token symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the token name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the bep token owner.
220      */
221     function getOwner() external view returns (address);
222 
223     /**
224      * @dev Returns the amount of tokens owned by `account`.
225      */
226     function balanceOf(address account) external view returns (uint256);
227 
228     /**
229      * @dev Moves `amount` tokens from the caller's account to `recipient`.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transfer(address recipient, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Returns the remaining number of tokens that `spender` will be
239      * allowed to spend on behalf of `owner` through {transferFrom}. This is
240      * zero by default.
241      *
242      * This value changes when {approve} or {transferFrom} are called.
243      */
244     function allowance(address _owner, address spender) external view returns (uint256);
245 
246     /**
247      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * IMPORTANT: Beware that changing an allowance with this method brings the risk
252      * that someone may use both the old and the new allowance by unfortunate
253      * transaction ordering. One possible solution to mitigate this race
254      * condition is to first reduce the spender's allowance to 0 and set the
255      * desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      *
258      * Emits an {Approval} event.
259      */
260     function approve(address spender, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Moves `amount` tokens from `sender` to `recipient` using the
264      * allowance mechanism. `amount` is then deducted from the caller's
265      * allowance.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) external returns (bool);
276 
277     /**
278      * @dev Emitted when `value` tokens are moved from one account (`from`) to
279      * another (`to`).
280      *
281      * Note that `value` may be zero.
282      */
283     event Transfer(address indexed from, address indexed to, uint256 value);
284 
285     /**
286      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
287      * a call to {approve}. `value` is the new allowance.
288      */
289     event Approval(address indexed owner, address indexed spender, uint256 value);
290 }
291 
292 // File: Address.sol
293 
294 
295 pragma solidity ^0.6.2;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly {
326             codehash := extcodehash(account)
327         }
328         return (codehash != accountHash && codehash != 0x0);
329     }
330 
331     /**
332      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333      * `recipient`, forwarding all available gas and reverting on errors.
334      *
335      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336      * of certain opcodes, possibly making contracts go over the 2300 gas limit
337      * imposed by `transfer`, making them unable to receive funds via
338      * `transfer`. {sendValue} removes this limitation.
339      *
340      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341      *
342      * IMPORTANT: because control is transferred to `recipient`, care must be
343      * taken to not create reentrancy vulnerabilities. Consider using
344      * {ReentrancyGuard} or the
345      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346      */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(address(this).balance >= amount, 'Address: insufficient balance');
349 
350         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
351         (bool success, ) = recipient.call{value: amount}('');
352         require(success, 'Address: unable to send value, recipient may have reverted');
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain`call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionCall(target, data, 'Address: low-level call failed');
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         return _functionCallWithValue(target, data, 0, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but also transferring `value` wei to `target`.
394      *
395      * Requirements:
396      *
397      * - the calling contract must have an ETH balance of at least `value`.
398      * - the called Solidity function must be `payable`.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(address(this).balance >= value, 'Address: insufficient balance for call');
423         return _functionCallWithValue(target, data, value, errorMessage);
424     }
425 
426     function _functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 weiValue,
430         string memory errorMessage
431     ) private returns (bytes memory) {
432         require(isContract(target), 'Address: call to non-contract');
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 // solhint-disable-next-line no-inline-assembly
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454 
455 // File: SafeBEP20.sol
456 
457 
458 pragma solidity ^0.6.0;
459 
460 
461 
462 
463 /**
464  * @title SafeBEP20
465  * @dev Wrappers around BEP20 operations that throw on failure (when the token
466  * contract returns false). Tokens that return no value (and instead revert or
467  * throw on failure) are also supported, non-reverting calls are assumed to be
468  * successful.
469  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
470  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
471  */
472 library SafeBEP20 {
473     using SafeMath for uint256;
474     using Address for address;
475 
476     function safeTransfer(
477         IBEP20 token,
478         address to,
479         uint256 value
480     ) internal {
481         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
482     }
483 
484     function safeTransferFrom(
485         IBEP20 token,
486         address from,
487         address to,
488         uint256 value
489     ) internal {
490         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
491     }
492 
493     /**
494      * @dev Deprecated. This function has issues similar to the ones found in
495      * {IBEP20-approve}, and its usage is discouraged.
496      *
497      * Whenever possible, use {safeIncreaseAllowance} and
498      * {safeDecreaseAllowance} instead.
499      */
500     function safeApprove(
501         IBEP20 token,
502         address spender,
503         uint256 value
504     ) internal {
505         // safeApprove should only be called when setting an initial allowance,
506         // or when resetting it to zero. To increase and decrease it, use
507         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
508         // solhint-disable-next-line max-line-length
509         require(
510             (value == 0) || (token.allowance(address(this), spender) == 0),
511             'SafeBEP20: approve from non-zero to non-zero allowance'
512         );
513         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
514     }
515 
516     function safeIncreaseAllowance(
517         IBEP20 token,
518         address spender,
519         uint256 value
520     ) internal {
521         uint256 newAllowance = token.allowance(address(this), spender).add(value);
522         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
523     }
524 
525     function safeDecreaseAllowance(
526         IBEP20 token,
527         address spender,
528         uint256 value
529     ) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).sub(
531             value,
532             'SafeBEP20: decreased allowance below zero'
533         );
534         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     /**
538      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
539      * on the return value: the return value is optional (but if data is returned, it must not be false).
540      * @param token The token targeted by the call.
541      * @param data The call data (encoded using abi.encode or one of its variants).
542      */
543     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
544         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
545         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
546         // the target address contains contract code and also asserts for success in the low-level call.
547 
548         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
549         if (returndata.length > 0) {
550             // Return data is optional
551             // solhint-disable-next-line max-line-length
552             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
553         }
554     }
555 }
556 
557 // File: Context.sol
558 
559 
560 pragma solidity >=0.4.0;
561 
562 /*
563  * @dev Provides information about the current execution context, including the
564  * sender of the transaction and its data. While these are generally available
565  * via msg.sender and msg.data, they should not be accessed in such a direct
566  * manner, since when dealing with GSN meta-transactions the account sending and
567  * paying for execution may not be the actual sender (as far as an application
568  * is concerned).
569  *
570  * This contract is only required for intermediate, library-like contracts.
571  */
572 contract Context {
573     // Empty internal constructor, to prevent people from mistakenly deploying
574     // an instance of this contract, which should be used via inheritance.
575     constructor() internal {}
576 
577     function _msgSender() internal view returns (address payable) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view returns (bytes memory) {
582         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
583         return msg.data;
584     }
585 }
586 
587 // File: Ownable.sol
588 
589 
590 pragma solidity >=0.4.0;
591 
592 
593 /**
594  * @dev Contract module which provides a basic access control mechanism, where
595  * there is an account (an owner) that can be granted exclusive access to
596  * specific functions.
597  *
598  * By default, the owner account will be the one that deploys the contract. This
599  * can later be changed with {transferOwnership}.
600  *
601  * This module is used through inheritance. It will make available the modifier
602  * `onlyOwner`, which can be applied to your functions to restrict their use to
603  * the owner.
604  */
605 contract Ownable is Context {
606     address private _owner;
607 
608     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
609 
610     /**
611      * @dev Initializes the contract setting the deployer as the initial owner.
612      */
613     constructor() internal {
614         address msgSender = _msgSender();
615         _owner = msgSender;
616         emit OwnershipTransferred(address(0), msgSender);
617     }
618 
619     /**
620      * @dev Returns the address of the current owner.
621      */
622     function owner() public view returns (address) {
623         return _owner;
624     }
625 
626     /**
627      * @dev Throws if called by any account other than the owner.
628      */
629     modifier onlyOwner() {
630         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
631         _;
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public onlyOwner {
642         emit OwnershipTransferred(_owner, address(0));
643         _owner = address(0);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public onlyOwner {
651         _transferOwnership(newOwner);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      */
657     function _transferOwnership(address newOwner) internal {
658         require(newOwner != address(0), 'Ownable: new owner is the zero address');
659         emit OwnershipTransferred(_owner, newOwner);
660         _owner = newOwner;
661     }
662 }
663 
664 // File: contracts/StakingPool.sol
665 
666 pragma solidity 0.6.12;
667 
668 
669 
670 
671 
672 // import "@nomiclabs/buidler/console.sol";
673 
674 
675 contract StakingPool is Ownable {
676     using SafeMath for uint256;
677     using SafeBEP20 for IBEP20;
678 
679     // Info of each user.
680     struct UserInfo {
681         uint256 amount;     // How many LP tokens the user has provided.
682         uint256 rewardDebt; // Reward debt. See explanation below.
683     }
684 
685     // Info of each pool.
686     struct PoolInfo {
687         IBEP20 lpToken;           // Address of LP token contract.
688         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
689         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
690         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
691     }
692 
693     // The CAKE TOKEN!
694     IBEP20 public syrup;
695     IBEP20 public rewardToken;
696 
697     // uint256 public maxStaking;
698 
699     // CAKE tokens created per block.
700     uint256 public rewardPerBlock;
701 
702     // Info of each pool.
703     PoolInfo[] public poolInfo;
704     // Info of each user that stakes LP tokens.
705     mapping (address => UserInfo) public userInfo;
706     // Total allocation poitns. Must be the sum of all allocation points in all pools.
707     uint256 private totalAllocPoint = 0;
708     // The block number when CAKE mining starts.
709     uint256 public startBlock;
710     // The block number when CAKE mining ends.
711     uint256 public bonusEndBlock;
712 
713     //Total lpTokens staked
714     uint256 public totalStaked = 0;
715 
716     event Deposit(address indexed user, uint256 amount);
717     event Withdraw(address indexed user, uint256 amount);
718     event EmergencyWithdraw(address indexed user, uint256 amount);
719 
720     constructor(
721         IBEP20 _syrup,
722         IBEP20 _rewardToken,
723         uint256 _rewardPerBlock,
724         uint256 _startBlock,
725         uint256 _bonusEndBlock
726     ) public {
727         syrup = _syrup;
728         rewardToken = _rewardToken;
729         rewardPerBlock = _rewardPerBlock;
730         startBlock = _startBlock;
731         bonusEndBlock = _bonusEndBlock;
732 
733         // staking pool
734         poolInfo.push(PoolInfo({
735             lpToken: _syrup,
736             allocPoint: 1000,
737             lastRewardBlock: startBlock,
738             accCakePerShare: 0
739         }));
740 
741         totalAllocPoint = 1000;
742         // maxStaking = 50000000000000000000;
743 
744     }
745 
746     function stopReward() public onlyOwner {
747         bonusEndBlock = block.number;
748     }
749 
750 
751     // Return reward multiplier over the given _from to _to block.
752     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
753         if (_to <= bonusEndBlock) {
754             return _to.sub(_from);
755         } else if (_from >= bonusEndBlock) {
756             return 0;
757         } else {
758             return bonusEndBlock.sub(_from);
759         }
760     }
761 
762     // View function to see pending Reward on frontend.
763     function pendingReward(address _user) external view returns (uint256) {
764         PoolInfo storage pool = poolInfo[0];
765         UserInfo storage user = userInfo[_user];
766         uint256 accCakePerShare = pool.accCakePerShare;
767         uint256 lpSupply = totalStaked;
768         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
769             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
770             uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
771             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
772         }
773         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
774     }
775 
776     // Update reward variables of the given pool to be up-to-date.
777     function updatePool(uint256 _pid) public {
778         PoolInfo storage pool = poolInfo[_pid];
779         if (block.number <= pool.lastRewardBlock) {
780             return;
781         }
782         uint256 lpSupply = totalStaked;
783         if (lpSupply == 0) {
784             pool.lastRewardBlock = block.number;
785             return;
786         }
787         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
788         uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
789         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
790         pool.lastRewardBlock = block.number;
791     }
792 
793     // Update reward variables for all pools. Be careful of gas spending!
794     function massUpdatePools() public {
795         uint256 length = poolInfo.length;
796         for (uint256 pid = 0; pid < length; ++pid) {
797             updatePool(pid);
798         }
799     }
800 
801 
802     // Stake SYRUP tokens to StakingPool
803     function deposit(uint256 _amount) public {
804         PoolInfo storage pool = poolInfo[0];
805         UserInfo storage user = userInfo[msg.sender];
806 
807         // require (_amount.add(user.amount) <= maxStaking, 'exceed max stake');
808 
809         updatePool(0);
810         if (user.amount > 0) {
811             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
812             if(pending > 0) {
813                 rewardToken.safeTransfer(address(msg.sender), pending);
814             }
815         }
816         if(_amount > 0) {
817             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
818             user.amount = user.amount.add(_amount);
819             totalStaked = totalStaked.add(_amount);
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
839             totalStaked = totalStaked.sub(_amount);
840         }
841         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
842 
843         emit Withdraw(msg.sender, _amount);
844     }
845 
846     // Withdraw without caring about rewards. EMERGENCY ONLY.
847     function emergencyWithdraw() public {
848         PoolInfo storage pool = poolInfo[0];
849         UserInfo storage user = userInfo[msg.sender];
850         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
851         totalStaked = totalStaked.sub(user.amount);
852         user.amount = 0;
853         user.rewardDebt = 0;
854         emit EmergencyWithdraw(msg.sender, user.amount);
855     }
856 
857     // Withdraw reward. EMERGENCY ONLY.
858     function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
859         uint256 totalBalance = rewardToken.balanceOf(address(this));
860         uint256 availableRewards = totalBalance.sub(totalStaked);
861          
862         require(_amount < availableRewards, 'not enough rewards');
863         rewardToken.safeTransfer(address(msg.sender), _amount);
864     }
865 
866 }