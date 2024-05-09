1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-17
7 */
8 
9 /**
10  *Submitted for verification at BscScan.com on 2021-06-24
11 */
12 
13 //SPDX-License-Identifier: UNLICENSED
14 
15 
16 pragma solidity 0.6.12;
17 
18 //import "@nomiclabs/buidler/console.sol";
19 
20 
21 
22 
23 
24 pragma solidity >=0.4.0;
25 
26 /*
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with GSN meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 contract Context {
37     // Empty internal constructor, to prevent people from mistakenly deploying
38     // an instance of this contract, which should be used via inheritance.
39     constructor() internal {}
40 
41     function _msgSender() internal view returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 
52 
53 pragma solidity >=0.4.0;
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() internal {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
93         _;
94     }
95 
96     /**
97      * @dev Leaves the contract without owner. It will not be possible to call
98      * `onlyOwner` functions anymore. Can only be called by the current owner.
99      *
100      * NOTE: Renouncing ownership will leave the contract without an owner,
101      * thereby removing any functionality that is only available to the owner.
102      */
103     function renounceOwnership() public onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Can only be called by the current owner.
111      */
112     function transferOwnership(address newOwner) public onlyOwner {
113         _transferOwnership(newOwner);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      */
119     function _transferOwnership(address newOwner) internal {
120         require(newOwner != address(0), 'Ownable: new owner is the zero address');
121         emit OwnershipTransferred(_owner, newOwner);
122         _owner = newOwner;
123     }
124 }
125 
126 
127 pragma solidity >=0.4.0;
128 
129 /**
130  * @dev Wrappers over Solidity's arithmetic operations with added overflow
131  * checks.
132  *
133  * Arithmetic operations in Solidity wrap on overflow. This can easily result
134  * in bugs, because programmers usually assume that an overflow raises an
135  * error, which is the standard behavior in high level programming languages.
136  * `SafeMath` restores this intuition by reverting the transaction when an
137  * operation overflows.
138  *
139  * Using this library instead of the unchecked operations eliminates an entire
140  * class of bugs, so it's recommended to use it always.
141  */
142 library SafeMath {
143     /**
144      * @dev Returns the addition of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `+` operator.
148      *
149      * Requirements:
150      *
151      * - Addition cannot overflow.
152      */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, 'SafeMath: addition overflow');
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         return sub(a, b, 'SafeMath: subtraction overflow');
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(
185         uint256 a,
186         uint256 b,
187         string memory errorMessage
188     ) internal pure returns (uint256) {
189         require(b <= a, errorMessage);
190         uint256 c = a - b;
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the multiplication of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      *
203      * - Multiplication cannot overflow.
204      */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
207         // benefit is lost if 'b' is also tested.
208         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
209         if (a == 0) {
210             return 0;
211         }
212 
213         uint256 c = a * b;
214         require(c / a == b, 'SafeMath: multiplication overflow');
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b) internal pure returns (uint256) {
232         return div(a, b, 'SafeMath: division by zero');
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         require(b > 0, errorMessage);
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
272         return mod(a, b, 'SafeMath: modulo by zero');
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * Reverts with custom message when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(
288         uint256 a,
289         uint256 b,
290         string memory errorMessage
291     ) internal pure returns (uint256) {
292         require(b != 0, errorMessage);
293         return a % b;
294     }
295 
296     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
297         z = x < y ? x : y;
298     }
299 
300     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
301     function sqrt(uint256 y) internal pure returns (uint256 z) {
302         if (y > 3) {
303             z = y;
304             uint256 x = y / 2 + 1;
305             while (x < z) {
306                 z = x;
307                 x = (y / x + x) / 2;
308             }
309         } else if (y != 0) {
310             z = 1;
311         }
312     }
313 }
314 
315 
316 pragma solidity >=0.4.0;
317 
318 interface IBEP20 {
319     /**
320      * @dev Returns the amount of tokens in existence.
321      */
322     function totalSupply() external view returns (uint256);
323 
324     /**
325      * @dev Returns the token decimals.
326      */
327     function decimals() external view returns (uint8);
328 
329     /**
330      * @dev Returns the token symbol.
331      */
332     function symbol() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token name.
336      */
337     function name() external view returns (string memory);
338 
339     /**
340      * @dev Returns the bep token owner.
341      */
342     function getOwner() external view returns (address);
343 
344     /**
345      * @dev Returns the amount of tokens owned by `account`.
346      */
347     function balanceOf(address account) external view returns (uint256);
348 
349     /**
350      * @dev Moves `amount` tokens from the caller's account to `recipient`.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transfer(address recipient, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Returns the remaining number of tokens that `spender` will be
360      * allowed to spend on behalf of `owner` through {transferFrom}. This is
361      * zero by default.
362      *
363      * This value changes when {approve} or {transferFrom} are called.
364      */
365     function allowance(address _owner, address spender) external view returns (uint256);
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * IMPORTANT: Beware that changing an allowance with this method brings the risk
373      * that someone may use both the old and the new allowance by unfortunate
374      * transaction ordering. One possible solution to mitigate this race
375      * condition is to first reduce the spender's allowance to 0 and set the
376      * desired value afterwards:
377      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address spender, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Moves `amount` tokens from `sender` to `recipient` using the
385      * allowance mechanism. `amount` is then deducted from the caller's
386      * allowance.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) external returns (bool);
397 
398     /**
399      * @dev Emitted when `value` tokens are moved from one account (`from`) to
400      * another (`to`).
401      *
402      * Note that `value` may be zero.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 value);
405 
406     /**
407      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
408      * a call to {approve}. `value` is the new allowance.
409      */
410     event Approval(address indexed owner, address indexed spender, uint256 value);
411 }
412 
413 
414 
415 
416 pragma solidity ^0.6.0;
417 
418 /**
419  * @title SafeBEP20
420  * @dev Wrappers around BEP20 operations that throw on failure (when the token
421  * contract returns false). Tokens that return no value (and instead revert or
422  * throw on failure) are also supported, non-reverting calls are assumed to be
423  * successful.
424  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
425  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
426  */
427 library SafeBEP20 {
428     using SafeMath for uint256;
429     using Address for address;
430 
431     function safeTransfer(
432         IBEP20 token,
433         address to,
434         uint256 value
435     ) internal {
436         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
437     }
438 
439     function safeTransferFrom(
440         IBEP20 token,
441         address from,
442         address to,
443         uint256 value
444     ) internal {
445         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
446     }
447 
448     /**
449      * @dev Deprecated. This function has issues similar to the ones found in
450      * {IBEP20-approve}, and its usage is discouraged.
451      *
452      * Whenever possible, use {safeIncreaseAllowance} and
453      * {safeDecreaseAllowance} instead.
454      */
455     function safeApprove(
456         IBEP20 token,
457         address spender,
458         uint256 value
459     ) internal {
460         // safeApprove should only be called when setting an initial allowance,
461         // or when resetting it to zero. To increase and decrease it, use
462         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
463         // solhint-disable-next-line max-line-length
464         require(
465             (value == 0) || (token.allowance(address(this), spender) == 0),
466             'SafeBEP20: approve from non-zero to non-zero allowance'
467         );
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
469     }
470 
471     function safeIncreaseAllowance(
472         IBEP20 token,
473         address spender,
474         uint256 value
475     ) internal {
476         uint256 newAllowance = token.allowance(address(this), spender).add(value);
477         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
478     }
479 
480     function safeDecreaseAllowance(
481         IBEP20 token,
482         address spender,
483         uint256 value
484     ) internal {
485         uint256 newAllowance = token.allowance(address(this), spender).sub(
486             value,
487             'SafeBEP20: decreased allowance below zero'
488         );
489         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
490     }
491 
492     /**
493      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
494      * on the return value: the return value is optional (but if data is returned, it must not be false).
495      * @param token The token targeted by the call.
496      * @param data The call data (encoded using abi.encode or one of its variants).
497      */
498     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
499         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
500         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
501         // the target address contains contract code and also asserts for success in the low-level call.
502 
503         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
504         if (returndata.length > 0) {
505             // Return data is optional
506             // solhint-disable-next-line max-line-length
507             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
508         }
509     }
510 }
511 
512 
513 pragma solidity ^0.6.2;
514 
515 /**
516  * @dev Collection of functions related to the address type
517  */
518 library Address {
519     /**
520      * @dev Returns true if `account` is a contract.
521      *
522      * [IMPORTANT]
523      * ====
524      * It is unsafe to assume that an address for which this function returns
525      * false is an externally-owned account (EOA) and not a contract.
526      *
527      * Among others, `isContract` will return false for the following
528      * types of addresses:
529      *
530      *  - an externally-owned account
531      *  - a contract in construction
532      *  - an address where a contract will be created
533      *  - an address where a contract lived, but was destroyed
534      * ====
535      */
536     function isContract(address account) internal view returns (bool) {
537         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
538         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
539         // for accounts without code, i.e. `keccak256('')`
540         bytes32 codehash;
541         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
542         // solhint-disable-next-line no-inline-assembly
543         assembly {
544             codehash := extcodehash(account)
545         }
546         return (codehash != accountHash && codehash != 0x0);
547     }
548 
549     /**
550      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
551      * `recipient`, forwarding all available gas and reverting on errors.
552      *
553      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
554      * of certain opcodes, possibly making contracts go over the 2300 gas limit
555      * imposed by `transfer`, making them unable to receive funds via
556      * `transfer`. {sendValue} removes this limitation.
557      *
558      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
559      *
560      * IMPORTANT: because control is transferred to `recipient`, care must be
561      * taken to not create reentrancy vulnerabilities. Consider using
562      * {ReentrancyGuard} or the
563      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
564      */
565     function sendValue(address payable recipient, uint256 amount) internal {
566         require(address(this).balance >= amount, 'Address: insufficient balance');
567 
568         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
569         (bool success, ) = recipient.call{value: amount}('');
570         require(success, 'Address: unable to send value, recipient may have reverted');
571     }
572 
573     /**
574      * @dev Performs a Solidity function call using a low level `call`. A
575      * plain`call` is an unsafe replacement for a function call: use this
576      * function instead.
577      *
578      * If `target` reverts with a revert reason, it is bubbled up by this
579      * function (like regular Solidity function calls).
580      *
581      * Returns the raw returned data. To convert to the expected return value,
582      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
583      *
584      * Requirements:
585      *
586      * - `target` must be a contract.
587      * - calling `target` with `data` must not revert.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
592         return functionCall(target, data, 'Address: low-level call failed');
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
597      * `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCall(
602         address target,
603         bytes memory data,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         return _functionCallWithValue(target, data, 0, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but also transferring `value` wei to `target`.
612      *
613      * Requirements:
614      *
615      * - the calling contract must have an ETH balance of at least `value`.
616      * - the called Solidity function must be `payable`.
617      *
618      * _Available since v3.1._
619      */
620     function functionCallWithValue(
621         address target,
622         bytes memory data,
623         uint256 value
624     ) internal returns (bytes memory) {
625         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
630      * with `errorMessage` as a fallback revert reason when `target` reverts.
631      *
632      * _Available since v3.1._
633      */
634     function functionCallWithValue(
635         address target,
636         bytes memory data,
637         uint256 value,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(address(this).balance >= value, 'Address: insufficient balance for call');
641         return _functionCallWithValue(target, data, value, errorMessage);
642     }
643 
644     function _functionCallWithValue(
645         address target,
646         bytes memory data,
647         uint256 weiValue,
648         string memory errorMessage
649     ) private returns (bytes memory) {
650         require(isContract(target), 'Address: call to non-contract');
651 
652         // solhint-disable-next-line avoid-low-level-calls
653         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
654         if (success) {
655             return returndata;
656         } else {
657             // Look for revert reason and bubble it up if present
658             if (returndata.length > 0) {
659                 // The easiest way to bubble the revert reason is using memory via assembly
660 
661                 // solhint-disable-next-line no-inline-assembly
662                 assembly {
663                     let returndata_size := mload(returndata)
664                     revert(add(32, returndata), returndata_size)
665                 }
666             } else {
667                 revert(errorMessage);
668             }
669         }
670     }
671 }
672 
673 contract SmartChef is Ownable {
674     using SafeMath for uint256;
675     using SafeBEP20 for IBEP20;
676 
677     // Info of each user.
678     struct UserInfo {
679         uint256 amount;     // How many LP tokens the user has provided.
680         uint256 rewardDebt; // Reward debt. See explanation below.
681     }
682 
683     // Info of each pool.
684     struct PoolInfo {
685         IBEP20 lpToken;           // Address of LP token contract.
686         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
687         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
688         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
689     }
690 
691     // The CAKE TOKEN!
692     IBEP20 public syrup;
693     IBEP20 public rewardToken;
694 
695     // uint256 public maxStaking;
696 
697     // CAKE tokens created per block.
698     uint256 public rewardPerBlock;
699     uint256 public depositFee; 
700     address public feeReceiver; 
701     // Info of each pool.
702     PoolInfo[] public poolInfo;
703     // Info of each user that stakes LP tokens.
704     mapping (address => UserInfo) public userInfo;
705     // Total allocation poitns. Must be the sum of all allocation points in all pools.
706     uint256 private totalAllocPoint = 0;
707     // The block number when CAKE mining starts.
708     uint256 public startBlock;
709     // The block number when CAKE mining ends.
710     uint256 public bonusEndBlock;
711 
712     event Deposit(address indexed user, uint256 amount);
713     event Withdraw(address indexed user, uint256 amount);
714     event EmergencyWithdraw(address indexed user, uint256 amount);
715 
716     constructor(
717         IBEP20 _syrup,
718         IBEP20 _rewardToken,
719         uint256 _rewardPerBlock,
720         uint256 _startBlock,
721         uint256 _bonusEndBlock,
722         uint256 _depositfee,
723         address _feereceiver
724     ) public {
725         syrup = _syrup;
726         rewardToken = _rewardToken;
727         rewardPerBlock = _rewardPerBlock;
728         startBlock = _startBlock;
729         bonusEndBlock = _bonusEndBlock;
730         depositFee = _depositfee;
731         feeReceiver = _feereceiver;
732 
733         // staking pool
734         poolInfo.push(PoolInfo({
735             lpToken: _syrup,
736             allocPoint: 1000,
737             lastRewardBlock: startBlock,
738             accCakePerShare: 0
739         }));
740         totalAllocPoint = 1000;
741         transferOwnership(0x12304B4258bd10c49C433980D98C28C4741f50C1);
742 
743     }
744 
745     function stopReward() public onlyOwner {
746         bonusEndBlock = block.number;
747     }
748     
749     function changeRewardTime(uint256 _startBlock, uint256 _endBlock, uint256 _reward) public onlyOwner {
750         startBlock = _startBlock;
751         bonusEndBlock = _endBlock;
752         rewardPerBlock = _reward;
753         poolInfo[0].lastRewardBlock = startBlock;
754     }
755 
756 
757     // Return reward multiplier over the given _from to _to block.
758     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
759         if (_to <= bonusEndBlock) {
760             return _to.sub(_from);
761         } else if (_from >= bonusEndBlock) {
762             return 0;
763         } else {
764             return bonusEndBlock.sub(_from);
765         }
766     }
767 
768     // View function to see pending Reward on frontend.
769     function pendingReward(address _user) external view returns (uint256) {
770         PoolInfo storage pool = poolInfo[0];
771         UserInfo storage user = userInfo[_user];
772         uint256 accCakePerShare = pool.accCakePerShare;
773         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
774         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
775             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
776             uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
777             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
778         }
779         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
780     }
781 
782     // Update reward variables of the given pool to be up-to-date.
783     function updatePool(uint256 _pid) public {
784         PoolInfo storage pool = poolInfo[_pid];
785         if (block.number <= pool.lastRewardBlock) {
786             return;
787         }
788         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
789         if (lpSupply == 0) {
790             pool.lastRewardBlock = block.number;
791             return;
792         }
793         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
794         uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
795         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
796         pool.lastRewardBlock = block.number;
797     }
798 
799     // Update reward variables for all pools. Be careful of gas spending!
800     function massUpdatePools() public {
801         uint256 length = poolInfo.length;
802         for (uint256 pid = 0; pid < length; ++pid) {
803             updatePool(pid);
804         }
805     }
806 
807 
808     // Stake SYRUP tokens to SmartChef
809     function deposit(uint256 _amount) public {
810         PoolInfo storage pool = poolInfo[0];
811         UserInfo storage user = userInfo[msg.sender];
812 
813         // require (_amount.add(user.amount) <= maxStaking, 'exceed max stake');
814 
815         updatePool(0);
816         if (user.amount > 0) {
817             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
818             if(pending > 0) {
819                 rewardToken.safeTransfer(address(msg.sender), pending);
820             }
821         }
822         if(_amount > 0) {
823             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
824             uint256 localDepositFee = 0;
825             if(depositFee > 0){
826                 localDepositFee = _amount.mul(depositFee).div(10000);
827                 pool.lpToken.safeTransfer(feeReceiver, localDepositFee);
828             }
829             user.amount = user.amount.add(_amount).sub(localDepositFee);
830         }
831         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
832 
833         emit Deposit(msg.sender, _amount);
834     }
835 
836     // Withdraw SYRUP tokens from STAKING.
837     function withdraw(uint256 _amount) public {
838         PoolInfo storage pool = poolInfo[0];
839         UserInfo storage user = userInfo[msg.sender];
840         require(user.amount >= _amount, "withdraw: not good");
841         updatePool(0);
842         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
843         if(pending > 0) {
844             rewardToken.safeTransfer(address(msg.sender), pending);
845         }
846         if(_amount > 0) {
847             user.amount = user.amount.sub(_amount);
848             pool.lpToken.safeTransfer(address(msg.sender), _amount);
849         }
850         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
851 
852         emit Withdraw(msg.sender, _amount);
853     }
854 
855     // Withdraw without caring about rewards. EMERGENCY ONLY.
856     function emergencyWithdraw() public {
857         PoolInfo storage pool = poolInfo[0];
858         UserInfo storage user = userInfo[msg.sender];
859         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
860         user.amount = 0;
861         user.rewardDebt = 0;
862         emit EmergencyWithdraw(msg.sender, user.amount);
863     }
864     
865     
866     function changeDepositFee(uint256 _depositFee) public onlyOwner{
867         depositFee = _depositFee;
868     }
869     
870 
871     // Withdraw reward. EMERGENCY ONLY.
872     function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
873         require(_amount < rewardToken.balanceOf(address(this)), 'not enough token');
874         rewardToken.safeTransfer(address(msg.sender), _amount);
875     }
876     
877     function changeFeeReceiver(address new_receiver) public {
878         require(msg.sender == feeReceiver, "cant do that");
879         feeReceiver = new_receiver;
880     }
881 
882 }