1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-17
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-06-24
7 */
8 
9 //SPDX-License-Identifier: UNLICENSED
10 
11 
12 pragma solidity 0.6.12;
13 
14 //import "@nomiclabs/buidler/console.sol";
15 
16 
17 
18 
19 
20 pragma solidity >=0.4.0;
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with GSN meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 contract Context {
33     // Empty internal constructor, to prevent people from mistakenly deploying
34     // an instance of this contract, which should be used via inheritance.
35     constructor() internal {}
36 
37     function _msgSender() internal view returns (address payable) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view returns (bytes memory) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 
48 
49 pragma solidity >=0.4.0;
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() internal {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
89         _;
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public onlyOwner {
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      */
115     function _transferOwnership(address newOwner) internal {
116         require(newOwner != address(0), 'Ownable: new owner is the zero address');
117         emit OwnershipTransferred(_owner, newOwner);
118         _owner = newOwner;
119     }
120 }
121 
122 
123 pragma solidity >=0.4.0;
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, 'SafeMath: addition overflow');
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, 'SafeMath: subtraction overflow');
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b, 'SafeMath: multiplication overflow');
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, 'SafeMath: division by zero');
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         require(b > 0, errorMessage);
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         return mod(a, b, 'SafeMath: modulo by zero');
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts with custom message when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 
292     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
293         z = x < y ? x : y;
294     }
295 
296     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
297     function sqrt(uint256 y) internal pure returns (uint256 z) {
298         if (y > 3) {
299             z = y;
300             uint256 x = y / 2 + 1;
301             while (x < z) {
302                 z = x;
303                 x = (y / x + x) / 2;
304             }
305         } else if (y != 0) {
306             z = 1;
307         }
308     }
309 }
310 
311 
312 pragma solidity >=0.4.0;
313 
314 interface IBEP20 {
315     /**
316      * @dev Returns the amount of tokens in existence.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns the token decimals.
322      */
323     function decimals() external view returns (uint8);
324 
325     /**
326      * @dev Returns the token symbol.
327      */
328     function symbol() external view returns (string memory);
329 
330     /**
331      * @dev Returns the token name.
332      */
333     function name() external view returns (string memory);
334 
335     /**
336      * @dev Returns the bep token owner.
337      */
338     function getOwner() external view returns (address);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `recipient`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address _owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `sender` to `recipient` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) external returns (bool);
393 
394     /**
395      * @dev Emitted when `value` tokens are moved from one account (`from`) to
396      * another (`to`).
397      *
398      * Note that `value` may be zero.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     /**
403      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
404      * a call to {approve}. `value` is the new allowance.
405      */
406     event Approval(address indexed owner, address indexed spender, uint256 value);
407 }
408 
409 
410 
411 
412 pragma solidity ^0.6.0;
413 
414 /**
415  * @title SafeBEP20
416  * @dev Wrappers around BEP20 operations that throw on failure (when the token
417  * contract returns false). Tokens that return no value (and instead revert or
418  * throw on failure) are also supported, non-reverting calls are assumed to be
419  * successful.
420  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
421  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
422  */
423 library SafeBEP20 {
424     using SafeMath for uint256;
425     using Address for address;
426 
427     function safeTransfer(
428         IBEP20 token,
429         address to,
430         uint256 value
431     ) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
433     }
434 
435     function safeTransferFrom(
436         IBEP20 token,
437         address from,
438         address to,
439         uint256 value
440     ) internal {
441         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
442     }
443 
444     /**
445      * @dev Deprecated. This function has issues similar to the ones found in
446      * {IBEP20-approve}, and its usage is discouraged.
447      *
448      * Whenever possible, use {safeIncreaseAllowance} and
449      * {safeDecreaseAllowance} instead.
450      */
451     function safeApprove(
452         IBEP20 token,
453         address spender,
454         uint256 value
455     ) internal {
456         // safeApprove should only be called when setting an initial allowance,
457         // or when resetting it to zero. To increase and decrease it, use
458         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
459         // solhint-disable-next-line max-line-length
460         require(
461             (value == 0) || (token.allowance(address(this), spender) == 0),
462             'SafeBEP20: approve from non-zero to non-zero allowance'
463         );
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
465     }
466 
467     function safeIncreaseAllowance(
468         IBEP20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).add(value);
473         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474     }
475 
476     function safeDecreaseAllowance(
477         IBEP20 token,
478         address spender,
479         uint256 value
480     ) internal {
481         uint256 newAllowance = token.allowance(address(this), spender).sub(
482             value,
483             'SafeBEP20: decreased allowance below zero'
484         );
485         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
486     }
487 
488     /**
489      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
490      * on the return value: the return value is optional (but if data is returned, it must not be false).
491      * @param token The token targeted by the call.
492      * @param data The call data (encoded using abi.encode or one of its variants).
493      */
494     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
495         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
496         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
497         // the target address contains contract code and also asserts for success in the low-level call.
498 
499         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
500         if (returndata.length > 0) {
501             // Return data is optional
502             // solhint-disable-next-line max-line-length
503             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
504         }
505     }
506 }
507 
508 
509 pragma solidity ^0.6.2;
510 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      */
532     function isContract(address account) internal view returns (bool) {
533         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
534         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
535         // for accounts without code, i.e. `keccak256('')`
536         bytes32 codehash;
537         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
538         // solhint-disable-next-line no-inline-assembly
539         assembly {
540             codehash := extcodehash(account)
541         }
542         return (codehash != accountHash && codehash != 0x0);
543     }
544 
545     /**
546      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
547      * `recipient`, forwarding all available gas and reverting on errors.
548      *
549      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
550      * of certain opcodes, possibly making contracts go over the 2300 gas limit
551      * imposed by `transfer`, making them unable to receive funds via
552      * `transfer`. {sendValue} removes this limitation.
553      *
554      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
555      *
556      * IMPORTANT: because control is transferred to `recipient`, care must be
557      * taken to not create reentrancy vulnerabilities. Consider using
558      * {ReentrancyGuard} or the
559      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
560      */
561     function sendValue(address payable recipient, uint256 amount) internal {
562         require(address(this).balance >= amount, 'Address: insufficient balance');
563 
564         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
565         (bool success, ) = recipient.call{value: amount}('');
566         require(success, 'Address: unable to send value, recipient may have reverted');
567     }
568 
569     /**
570      * @dev Performs a Solidity function call using a low level `call`. A
571      * plain`call` is an unsafe replacement for a function call: use this
572      * function instead.
573      *
574      * If `target` reverts with a revert reason, it is bubbled up by this
575      * function (like regular Solidity function calls).
576      *
577      * Returns the raw returned data. To convert to the expected return value,
578      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
579      *
580      * Requirements:
581      *
582      * - `target` must be a contract.
583      * - calling `target` with `data` must not revert.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionCall(target, data, 'Address: low-level call failed');
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
593      * `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         return _functionCallWithValue(target, data, 0, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but also transferring `value` wei to `target`.
608      *
609      * Requirements:
610      *
611      * - the calling contract must have an ETH balance of at least `value`.
612      * - the called Solidity function must be `payable`.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(
617         address target,
618         bytes memory data,
619         uint256 value
620     ) internal returns (bytes memory) {
621         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
626      * with `errorMessage` as a fallback revert reason when `target` reverts.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(
631         address target,
632         bytes memory data,
633         uint256 value,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         require(address(this).balance >= value, 'Address: insufficient balance for call');
637         return _functionCallWithValue(target, data, value, errorMessage);
638     }
639 
640     function _functionCallWithValue(
641         address target,
642         bytes memory data,
643         uint256 weiValue,
644         string memory errorMessage
645     ) private returns (bytes memory) {
646         require(isContract(target), 'Address: call to non-contract');
647 
648         // solhint-disable-next-line avoid-low-level-calls
649         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
650         if (success) {
651             return returndata;
652         } else {
653             // Look for revert reason and bubble it up if present
654             if (returndata.length > 0) {
655                 // The easiest way to bubble the revert reason is using memory via assembly
656 
657                 // solhint-disable-next-line no-inline-assembly
658                 assembly {
659                     let returndata_size := mload(returndata)
660                     revert(add(32, returndata), returndata_size)
661                 }
662             } else {
663                 revert(errorMessage);
664             }
665         }
666     }
667 }
668 
669 contract SmartChef is Ownable {
670     using SafeMath for uint256;
671     using SafeBEP20 for IBEP20;
672 
673     // Info of each user.
674     struct UserInfo {
675         uint256 amount;     // How many LP tokens the user has provided.
676         uint256 rewardDebt; // Reward debt. See explanation below.
677     }
678 
679     // Info of each pool.
680     struct PoolInfo {
681         IBEP20 lpToken;           // Address of LP token contract.
682         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
683         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
684         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
685     }
686 
687     // The CAKE TOKEN!
688     IBEP20 public syrup;
689     IBEP20 public rewardToken;
690 
691     // uint256 public maxStaking;
692 
693     // CAKE tokens created per block.
694     uint256 public rewardPerBlock;
695     uint256 public depositFee; 
696     address public feeReceiver; 
697     // Info of each pool.
698     PoolInfo[] public poolInfo;
699     // Info of each user that stakes LP tokens.
700     mapping (address => UserInfo) public userInfo;
701     // Total allocation poitns. Must be the sum of all allocation points in all pools.
702     uint256 private totalAllocPoint = 0;
703     // The block number when CAKE mining starts.
704     uint256 public startBlock;
705     // The block number when CAKE mining ends.
706     uint256 public bonusEndBlock;
707 
708     event Deposit(address indexed user, uint256 amount);
709     event Withdraw(address indexed user, uint256 amount);
710     event EmergencyWithdraw(address indexed user, uint256 amount);
711 
712     constructor(
713         IBEP20 _syrup,
714         IBEP20 _rewardToken,
715         uint256 _rewardPerBlock,
716         uint256 _startBlock,
717         uint256 _bonusEndBlock,
718         uint256 _depositfee,
719         address _feereceiver
720     ) public {
721         syrup = _syrup;
722         rewardToken = _rewardToken;
723         rewardPerBlock = _rewardPerBlock;
724         startBlock = _startBlock;
725         bonusEndBlock = _bonusEndBlock;
726         depositFee = _depositfee;
727         feeReceiver = _feereceiver;
728 
729         // staking pool
730         poolInfo.push(PoolInfo({
731             lpToken: _syrup,
732             allocPoint: 1000,
733             lastRewardBlock: startBlock,
734             accCakePerShare: 0
735         }));
736         totalAllocPoint = 1000;
737 
738     }
739 
740     function stopReward() public onlyOwner {
741         bonusEndBlock = block.number;
742     }
743     
744     function changeRewardTime(uint256 _startBlock, uint256 _endBlock, uint256 _reward) public onlyOwner {
745         startBlock = _startBlock;
746         bonusEndBlock = _endBlock;
747         rewardPerBlock = _reward;
748         poolInfo[0].lastRewardBlock = startBlock;
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
819             uint256 localDepositFee = 0;
820             if(depositFee > 0){
821                 localDepositFee = _amount.mul(depositFee).div(10000);
822                 pool.lpToken.safeTransfer(feeReceiver, localDepositFee);
823             }
824             user.amount = user.amount.add(_amount).sub(localDepositFee);
825         }
826         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
827 
828         emit Deposit(msg.sender, _amount);
829     }
830 
831     // Withdraw SYRUP tokens from STAKING.
832     function withdraw(uint256 _amount) public {
833         PoolInfo storage pool = poolInfo[0];
834         UserInfo storage user = userInfo[msg.sender];
835         require(user.amount >= _amount, "withdraw: not good");
836         updatePool(0);
837         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
838         if(pending > 0) {
839             rewardToken.safeTransfer(address(msg.sender), pending);
840         }
841         if(_amount > 0) {
842             user.amount = user.amount.sub(_amount);
843             pool.lpToken.safeTransfer(address(msg.sender), _amount);
844         }
845         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
846 
847         emit Withdraw(msg.sender, _amount);
848     }
849 
850     // Withdraw without caring about rewards. EMERGENCY ONLY.
851     function emergencyWithdraw() public {
852         PoolInfo storage pool = poolInfo[0];
853         UserInfo storage user = userInfo[msg.sender];
854         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
855         user.amount = 0;
856         user.rewardDebt = 0;
857         emit EmergencyWithdraw(msg.sender, user.amount);
858     }
859     
860     
861     function changeDepositFee(uint256 _depositFee) public onlyOwner{
862         depositFee = _depositFee;
863     }
864     
865 
866     // Withdraw reward. EMERGENCY ONLY.
867     function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
868         require(_amount < rewardToken.balanceOf(address(this)), 'not enough token');
869         rewardToken.safeTransfer(address(msg.sender), _amount);
870     }
871     
872     function changeFeeReceiver(address new_receiver) public {
873         require(msg.sender == feeReceiver, "cant do that");
874         feeReceiver = new_receiver;
875     }
876 
877 }