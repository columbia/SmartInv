1 // SPDX-License-Identifier: MIT
2 
3 // File: SafeMath.sol
4 
5 pragma solidity >=0.4.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, 'SafeMath: addition overflow');
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, 'SafeMath: subtraction overflow');
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(
63         uint256 a,
64         uint256 b,
65         string memory errorMessage
66     ) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `*` operator.
78      *
79      * Requirements:
80      *
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, 'SafeMath: multiplication overflow');
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      *
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, 'SafeMath: division by zero');
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, 'SafeMath: modulo by zero');
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(
166         uint256 a,
167         uint256 b,
168         string memory errorMessage
169     ) internal pure returns (uint256) {
170         require(b != 0, errorMessage);
171         return a % b;
172     }
173 
174     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
175         z = x < y ? x : y;
176     }
177 
178     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
179     function sqrt(uint256 y) internal pure returns (uint256 z) {
180         if (y > 3) {
181             z = y;
182             uint256 x = y / 2 + 1;
183             while (x < z) {
184                 z = x;
185                 x = (y / x + x) / 2;
186             }
187         } else if (y != 0) {
188             z = 1;
189         }
190     }
191 }
192 
193 // File: IBEP20.sol
194 
195 
196 pragma solidity >=0.4.0;
197 
198 interface IBEP20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the token decimals.
206      */
207     function decimals() external view returns (uint8);
208 
209     /**
210      * @dev Returns the token symbol.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the bep token owner.
221      */
222     function getOwner() external view returns (address);
223 
224     /**
225      * @dev Returns the amount of tokens owned by `account`.
226      */
227     function balanceOf(address account) external view returns (uint256);
228 
229     /**
230      * @dev Moves `amount` tokens from the caller's account to `recipient`.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transfer(address recipient, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Returns the remaining number of tokens that `spender` will be
240      * allowed to spend on behalf of `owner` through {transferFrom}. This is
241      * zero by default.
242      *
243      * This value changes when {approve} or {transferFrom} are called.
244      */
245     function allowance(address _owner, address spender) external view returns (uint256);
246 
247     /**
248      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * IMPORTANT: Beware that changing an allowance with this method brings the risk
253      * that someone may use both the old and the new allowance by unfortunate
254      * transaction ordering. One possible solution to mitigate this race
255      * condition is to first reduce the spender's allowance to 0 and set the
256      * desired value afterwards:
257      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address spender, uint256 amount) external returns (bool);
262 
263     /**
264      * @dev Moves `amount` tokens from `sender` to `recipient` using the
265      * allowance mechanism. `amount` is then deducted from the caller's
266      * allowance.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) external returns (bool);
277 
278     /**
279      * @dev Emitted when `value` tokens are moved from one account (`from`) to
280      * another (`to`).
281      *
282      * Note that `value` may be zero.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 value);
285 
286     /**
287      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
288      * a call to {approve}. `value` is the new allowance.
289      */
290     event Approval(address indexed owner, address indexed spender, uint256 value);
291 }
292 
293 // File: Address.sol
294 
295 
296 pragma solidity ^0.6.2;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
321         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
322         // for accounts without code, i.e. `keccak256('')`
323         bytes32 codehash;
324         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
325         // solhint-disable-next-line no-inline-assembly
326         assembly {
327             codehash := extcodehash(account)
328         }
329         return (codehash != accountHash && codehash != 0x0);
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, 'Address: insufficient balance');
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{value: amount}('');
353         require(success, 'Address: unable to send value, recipient may have reverted');
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionCall(target, data, 'Address: low-level call failed');
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         return _functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(address(this).balance >= value, 'Address: insufficient balance for call');
424         return _functionCallWithValue(target, data, value, errorMessage);
425     }
426 
427     function _functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 weiValue,
431         string memory errorMessage
432     ) private returns (bytes memory) {
433         require(isContract(target), 'Address: call to non-contract');
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443 
444                 // solhint-disable-next-line no-inline-assembly
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: SafeBEP20.sol
457 
458 
459 pragma solidity ^0.6.0;
460 
461 
462 
463 
464 /**
465  * @title SafeBEP20
466  * @dev Wrappers around BEP20 operations that throw on failure (when the token
467  * contract returns false). Tokens that return no value (and instead revert or
468  * throw on failure) are also supported, non-reverting calls are assumed to be
469  * successful.
470  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
471  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
472  */
473 library SafeBEP20 {
474     using SafeMath for uint256;
475     using Address for address;
476 
477     function safeTransfer(
478         IBEP20 token,
479         address to,
480         uint256 value
481     ) internal {
482         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
483     }
484 
485     function safeTransferFrom(
486         IBEP20 token,
487         address from,
488         address to,
489         uint256 value
490     ) internal {
491         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
492     }
493 
494     /**
495      * @dev Deprecated. This function has issues similar to the ones found in
496      * {IBEP20-approve}, and its usage is discouraged.
497      *
498      * Whenever possible, use {safeIncreaseAllowance} and
499      * {safeDecreaseAllowance} instead.
500      */
501     function safeApprove(
502         IBEP20 token,
503         address spender,
504         uint256 value
505     ) internal {
506         // safeApprove should only be called when setting an initial allowance,
507         // or when resetting it to zero. To increase and decrease it, use
508         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
509         // solhint-disable-next-line max-line-length
510         require(
511             (value == 0) || (token.allowance(address(this), spender) == 0),
512             'SafeBEP20: approve from non-zero to non-zero allowance'
513         );
514         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
515     }
516 
517     function safeIncreaseAllowance(
518         IBEP20 token,
519         address spender,
520         uint256 value
521     ) internal {
522         uint256 newAllowance = token.allowance(address(this), spender).add(value);
523         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524     }
525 
526     function safeDecreaseAllowance(
527         IBEP20 token,
528         address spender,
529         uint256 value
530     ) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).sub(
532             value,
533             'SafeBEP20: decreased allowance below zero'
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
547         // the target address contains contract code and also asserts for success in the low-level call.
548 
549         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
550         if (returndata.length > 0) {
551             // Return data is optional
552             // solhint-disable-next-line max-line-length
553             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
554         }
555     }
556 }
557 
558 // File: Context.sol
559 
560 
561 pragma solidity >=0.4.0;
562 
563 /*
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with GSN meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 contract Context {
574     // Empty internal constructor, to prevent people from mistakenly deploying
575     // an instance of this contract, which should be used via inheritance.
576     constructor() internal {}
577 
578     function _msgSender() internal view returns (address payable) {
579         return msg.sender;
580     }
581 
582     function _msgData() internal view returns (bytes memory) {
583         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
584         return msg.data;
585     }
586 }
587 
588 // File: Ownable.sol
589 
590 
591 pragma solidity >=0.4.0;
592 
593 
594 /**
595  * @dev Contract module which provides a basic access control mechanism, where
596  * there is an account (an owner) that can be granted exclusive access to
597  * specific functions.
598  *
599  * By default, the owner account will be the one that deploys the contract. This
600  * can later be changed with {transferOwnership}.
601  *
602  * This module is used through inheritance. It will make available the modifier
603  * `onlyOwner`, which can be applied to your functions to restrict their use to
604  * the owner.
605  */
606 contract Ownable is Context {
607     address private _owner;
608 
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610 
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor() internal {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
632         _;
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646 
647     /**
648      * @dev Transfers ownership of the contract to a new account (`newOwner`).
649      * Can only be called by the current owner.
650      */
651     function transferOwnership(address newOwner) public onlyOwner {
652         _transferOwnership(newOwner);
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      */
658     function _transferOwnership(address newOwner) internal {
659         require(newOwner != address(0), 'Ownable: new owner is the zero address');
660         emit OwnershipTransferred(_owner, newOwner);
661         _owner = newOwner;
662     }
663 }
664 
665 // File: contracts/StakingPool.sol
666 
667 pragma solidity 0.6.12;
668 
669 
670 
671 
672 
673 // import "@nomiclabs/buidler/console.sol";
674 
675 
676 contract StakingPool is Ownable {
677     using SafeMath for uint256;
678     using SafeBEP20 for IBEP20;
679 
680     // Info of each user.
681     struct UserInfo {
682         uint256 amount;     // How many LP tokens the user has provided.
683         uint256 rewardDebt; // Reward debt. See explanation below.
684     }
685 
686     // Info of each pool.
687     struct PoolInfo {
688         IBEP20 lpToken;           // Address of LP token contract.
689         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
690         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
691         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
692     }
693 
694     // The CAKE TOKEN!
695     IBEP20 public syrup;
696     IBEP20 public rewardToken;
697 
698     // uint256 public maxStaking;
699 
700     // CAKE tokens created per block.
701     uint256 public rewardPerBlock;
702 
703     // Info of each pool.
704     PoolInfo[] public poolInfo;
705     // Info of each user that stakes LP tokens.
706     mapping (address => UserInfo) public userInfo;
707     // Total allocation poitns. Must be the sum of all allocation points in all pools.
708     uint256 private totalAllocPoint = 0;
709     // The block number when CAKE mining starts.
710     uint256 public startBlock;
711     // The block number when CAKE mining ends.
712     uint256 public bonusEndBlock;
713 
714     //Total lpTokens staked
715     uint256 public totalStaked = 0;
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
751     function changeStartBlock(uint256 _startBlock) public onlyOwner {
752         startBlock = _startBlock;
753     }
754     
755     function changeEndBlock(uint256 _bonusEndBlock) public onlyOwner {
756         bonusEndBlock = _bonusEndBlock;
757     }
758     
759     function changeRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {
760         rewardPerBlock = _rewardPerBlock;
761     }
762 
763 
764     // Return reward multiplier over the given _from to _to block.
765     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
766         if (_to <= bonusEndBlock) {
767             return _to.sub(_from);
768         } else if (_from >= bonusEndBlock) {
769             return 0;
770         } else {
771             return bonusEndBlock.sub(_from);
772         }
773     }
774 
775     // View function to see pending Reward on frontend.
776     function pendingReward(address _user) external view returns (uint256) {
777         PoolInfo storage pool = poolInfo[0];
778         UserInfo storage user = userInfo[_user];
779         uint256 accCakePerShare = pool.accCakePerShare;
780         uint256 lpSupply = totalStaked;
781         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
782             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
783             uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
784             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
785         }
786         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
787     }
788 
789     // Update reward variables of the given pool to be up-to-date.
790     function updatePool(uint256 _pid) public {
791         PoolInfo storage pool = poolInfo[_pid];
792         if (block.number <= pool.lastRewardBlock) {
793             return;
794         }
795         uint256 lpSupply = totalStaked;
796         if (lpSupply == 0) {
797             pool.lastRewardBlock = block.number;
798             return;
799         }
800         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
801         uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
802         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
803         pool.lastRewardBlock = block.number;
804     }
805 
806     // Update reward variables for all pools. Be careful of gas spending!
807     function massUpdatePools() public {
808         uint256 length = poolInfo.length;
809         for (uint256 pid = 0; pid < length; ++pid) {
810             updatePool(pid);
811         }
812     }
813 
814 
815     // Stake SYRUP tokens to StakingPool
816     function deposit(uint256 _amount) public {
817         PoolInfo storage pool = poolInfo[0];
818         UserInfo storage user = userInfo[msg.sender];
819 
820         // require (_amount.add(user.amount) <= maxStaking, 'exceed max stake');
821 
822         updatePool(0);
823         if (user.amount > 0) {
824             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
825             if(pending > 0) {
826                 rewardToken.safeTransfer(address(msg.sender), pending);
827             }
828         }
829         if(_amount > 0) {
830             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
831             user.amount = user.amount.add(_amount);
832             totalStaked = totalStaked.add(_amount);
833         }
834         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
835 
836         emit Deposit(msg.sender, _amount);
837     }
838 
839     // Withdraw SYRUP tokens from STAKING.
840     function withdraw(uint256 _amount) public {
841         PoolInfo storage pool = poolInfo[0];
842         UserInfo storage user = userInfo[msg.sender];
843         require(user.amount >= _amount, "withdraw: not good");
844         updatePool(0);
845         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
846         if(pending > 0) {
847             rewardToken.safeTransfer(address(msg.sender), pending);
848         }
849         if(_amount > 0) {
850             user.amount = user.amount.sub(_amount);
851             pool.lpToken.safeTransfer(address(msg.sender), _amount);
852             totalStaked = totalStaked.sub(_amount);
853         }
854         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
855 
856         emit Withdraw(msg.sender, _amount);
857     }
858 
859     // Withdraw without caring about rewards. EMERGENCY ONLY.
860     function emergencyWithdraw() public {
861         PoolInfo storage pool = poolInfo[0];
862         UserInfo storage user = userInfo[msg.sender];
863         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
864         totalStaked = totalStaked.sub(user.amount);
865         user.amount = 0;
866         user.rewardDebt = 0;
867         emit EmergencyWithdraw(msg.sender, user.amount);
868     }
869 
870     // Withdraw reward. EMERGENCY ONLY.
871     function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
872         uint256 totalBalance = rewardToken.balanceOf(address(this));
873         uint256 availableRewards = totalBalance.sub(totalStaked);
874          
875         require(_amount < availableRewards, 'not enough rewards');
876         rewardToken.safeTransfer(address(msg.sender), _amount);
877     }
878     
879     function saveMe(address tokenAddress) public onlyOwner {
880         IBEP20 token = IBEP20(tokenAddress);
881         token.transfer(address(msg.sender), token.balanceOf(address(this)));
882     }
883 
884 }