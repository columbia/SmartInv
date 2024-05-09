1 pragma solidity 0.5.15;
2 
3 // YAM v2 to YAM v3 migrator contract
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies in extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { size := extcodesize(account) }
263         return size > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286         (bool success, ) = recipient.call.value(amount)("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain`call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309       return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319         return _functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339      * with `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         return _functionCallWithValue(target, data, value, errorMessage);
346     }
347 
348     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
349         require(isContract(target), "Address: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.call.value(weiValue)(data);
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359 
360                 // solhint-disable-next-line no-inline-assembly
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 /**
372  * @title SafeERC20
373  * @dev Wrappers around ERC20 operations that throw on failure (when the token
374  * contract returns false). Tokens that return no value (and instead revert or
375  * throw on failure) are also supported, non-reverting calls are assumed to be
376  * successful.
377  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
378  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
379  */
380 library SafeERC20 {
381     using SafeMath for uint256;
382     using Address for address;
383 
384     function safeTransfer(IERC20 token, address to, uint256 value) internal {
385         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
386     }
387 
388     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
389         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
390     }
391 
392     /**
393      * @dev Deprecated. This function has issues similar to the ones found in
394      * {IERC20-approve}, and its usage is discouraged.
395      *
396      * Whenever possible, use {safeIncreaseAllowance} and
397      * {safeDecreaseAllowance} instead.
398      */
399     function safeApprove(IERC20 token, address spender, uint256 value) internal {
400         // safeApprove should only be called when setting an initial allowance,
401         // or when resetting it to zero. To increase and decrease it, use
402         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
403         // solhint-disable-next-line max-line-length
404         require((value == 0) || (token.allowance(address(this), spender) == 0),
405             "SafeERC20: approve from non-zero to non-zero allowance"
406         );
407         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
408     }
409 
410     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
411         uint256 newAllowance = token.allowance(address(this), spender).add(value);
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
413     }
414 
415     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     /**
421      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
422      * on the return value: the return value is optional (but if data is returned, it must not be false).
423      * @param token The token targeted by the call.
424      * @param data The call data (encoded using abi.encode or one of its variants).
425      */
426     function _callOptionalReturn(IERC20 token, bytes memory data) private {
427         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
428         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
429         // the target address contains contract code and also asserts for success in the low-level call.
430 
431         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
432         if (returndata.length > 0) { // Return data is optional
433             // solhint-disable-next-line max-line-length
434             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
435         }
436     }
437 }
438 
439 /*
440  * @dev Provides information about the current execution context, including the
441  * sender of the transaction and its data. While these are generally available
442  * via msg.sender and msg.data, they should not be accessed in such a direct
443  * manner, since when dealing with GSN meta-transactions the account sending and
444  * paying for execution may not be the actual sender (as far as an application
445  * is concerned).
446  *
447  * This contract is only required for intermediate, library-like contracts.
448  */
449 contract Context {
450     // Empty internal constructor, to prevent people from mistakenly deploying
451     // an instance of this contract, which should be used via inheritance.
452     constructor () internal { }
453 
454     function _msgSender() internal view returns (address payable) {
455         return msg.sender;
456     }
457 
458     function _msgData() internal view returns (bytes memory) {
459         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
460         return msg.data;
461     }
462 }
463 
464 /**
465  * @dev Contract module which provides a basic access control mechanism, where
466  * there is an account (an owner) that can be granted exclusive access to
467  * specific functions.
468  *
469  * By default, the owner account will be the one that deploys the contract. This
470  * can later be changed with {transferOwnership}.
471  *
472  * This module is used through inheritance. It will make available the modifier
473  * `onlyOwner`, which can be applied to your functions to restrict their use to
474  * the owner.
475  */
476 contract Ownable is Context {
477     address private _owner;
478 
479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
480 
481     /**
482      * @dev Initializes the contract setting the deployer as the initial owner.
483      */
484     constructor () internal {
485         address msgSender = _msgSender();
486         _owner = msgSender;
487         emit OwnershipTransferred(address(0), msgSender);
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(_owner == _msgSender(), "Ownable: caller is not the owner");
502         _;
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public onlyOwner {
513         emit OwnershipTransferred(_owner, address(0));
514         _owner = address(0);
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public onlyOwner {
522         require(newOwner != address(0), "Ownable: new owner is the zero address");
523         emit OwnershipTransferred(_owner, newOwner);
524         _owner = newOwner;
525     }
526 }
527 
528 
529 interface YAMv2 {
530   function balanceOf(address owner) external view returns (uint256);
531 }
532 
533 interface YAMv3 {
534   function mint(address owner, uint256 amount) external;
535 }
536 
537 
538 /**
539  * @title YAMv2 to V3 Token Migrator
540  * @dev YAMv3 Mintable Token with migration from legacy contract.
541  */
542 contract Migrator is Context, Ownable {
543 
544     using SafeMath for uint256;
545 
546     address public constant yamV2 = address(0xAba8cAc6866B83Ae4eec97DD07ED254282f6aD8A);
547 
548     address public yamV3;
549 
550     bool public token_initialized;
551 
552     bool public delegatorRewardsSet;
553 
554     uint256 public constant vestingDuration = 30 days;
555 
556     uint256 public constant delegatorVestingDuration = 90 days;
557 
558     uint256 public constant startTime = 1600444800; // Friday, September 18, 2020 4:00:00 PM
559 
560     uint256 public constant BASE = 10**18;
561 
562     mapping(address => uint256) public delegator_vesting;
563 
564     mapping(address => uint256) public delegator_claimed;
565 
566     mapping(address => uint256) public vesting;
567 
568     mapping(address => uint256) public claimed;
569 
570     constructor () public {
571     }
572 
573 
574 
575     /**
576      * @dev Sets yamV3 token address
577      *
578      */
579     function setV3Address(address yamV3_) public onlyOwner {
580         require(!token_initialized, "already set");
581         token_initialized = true;
582         yamV3 = yamV3_;
583     }
584 
585     // Tells contract delegator rewards setting is done
586     function delegatorRewardsDone() public onlyOwner {
587         delegatorRewardsSet = true;
588     }
589 
590 
591     function vested(address who) public view returns (uint256) {
592       // completion percentage of vesting
593       uint256 vestedPerc = now.sub(startTime).mul(BASE).div(vestingDuration);
594 
595       uint256 delegatorVestedPerc = now.sub(startTime).mul(BASE).div(delegatorVestingDuration);
596 
597       if (vestedPerc > BASE) {
598           vestedPerc = BASE;
599       }
600       if (delegatorVestedPerc > BASE) {
601           delegatorVestedPerc = BASE;
602       }
603 
604       // add to total vesting
605       uint256 totalVesting = vesting[who];
606 
607       // get redeemable total vested by checking how much time has passed
608       uint256 totalVestingRedeemable = totalVesting.mul(vestedPerc).div(BASE);
609 
610       uint256 totalVestingDelegator = delegator_vesting[who].mul(delegatorVestedPerc).div(BASE);
611 
612       // get already claimed vested rewards
613       uint256 alreadyClaimed = claimed[who].add(delegator_claimed[who]);
614 
615       // get current redeemable
616       return totalVestingRedeemable.add(totalVestingDelegator).sub(alreadyClaimed);
617     }
618 
619 
620     modifier started() {
621         require(block.timestamp >= startTime, "!started");
622         require(token_initialized, "!initialized");
623         require(delegatorRewardsSet, "!delegatorRewards");
624         _;
625     }
626 
627     /**
628      * @dev Migrate a users' entire balance
629      *
630      * One way function. YAMv2 tokens are BURNED. 1/2 YAMv3 tokens are minted instantly, other half vests over 1 month.
631      */
632     function migrate()
633         external
634         started
635     {
636         // completion percentage of vesting
637         uint256 vestedPerc = now.sub(startTime).mul(BASE).div(vestingDuration);
638 
639         // completion percentage of delegator vesting
640         uint256 delegatorVestedPerc = now.sub(startTime).mul(BASE).div(delegatorVestingDuration);
641 
642         if (vestedPerc > BASE) {
643             vestedPerc = BASE;
644         }
645         if (delegatorVestedPerc > BASE) {
646             delegatorVestedPerc = BASE;
647         }
648 
649         // gets the yamValue for a user.
650         uint256 yamValue = YAMv2(yamV2).balanceOf(_msgSender());
651 
652         // half is instant redeemable
653         uint256 halfRedeemable = yamValue / 2;
654 
655         uint256 mintAmount;
656 
657         // scope
658         {
659             // add to total vesting
660             uint256 totalVesting = vesting[_msgSender()].add(halfRedeemable);
661 
662             // update vesting
663             vesting[_msgSender()] = totalVesting;
664 
665             // get redeemable total vested by checking how much time has passed
666             uint256 totalVestingRedeemable = totalVesting.mul(vestedPerc).div(BASE);
667 
668             uint256 totalVestingDelegator = delegator_vesting[_msgSender()].mul(delegatorVestedPerc).div(BASE);
669 
670             // get already claimed
671             uint256 alreadyClaimed = claimed[_msgSender()];
672 
673             // get already claimed delegator
674             uint256 alreadyClaimedDelegator = delegator_claimed[_msgSender()];
675 
676             // get current redeemable
677             uint256 currVested = totalVestingRedeemable.sub(alreadyClaimed);
678 
679             // get current redeemable delegator
680             uint256 currVestedDelegator = totalVestingDelegator.sub(alreadyClaimedDelegator);
681 
682             // add instant redeemable to current redeemable to get mintAmount
683             mintAmount = halfRedeemable.add(currVested).add(currVestedDelegator);
684 
685             // update claimed
686             claimed[_msgSender()] = claimed[_msgSender()].add(currVested);
687 
688             // update delegator rewards claimed
689             delegator_claimed[_msgSender()] = delegator_claimed[_msgSender()].add(currVestedDelegator);
690         }
691 
692 
693         // BURN YAMv2 - UNRECOVERABLE.
694         SafeERC20.safeTransferFrom(
695             IERC20(yamV2),
696             _msgSender(),
697             address(0x000000000000000000000000000000000000dEaD),
698             yamValue
699         );
700 
701         // mint, this is in raw internalDecimals. Handled by updated _mint function
702         YAMv3(yamV3).mint(_msgSender(), mintAmount);
703     }
704 
705 
706     function claimVested()
707         external
708         started
709     {
710         // completion percentage of vesting
711         uint256 vestedPerc = now.sub(startTime).mul(BASE).div(vestingDuration);
712 
713         // completion percentage of delegator vesting
714         uint256 delegatorVestedPerc = now.sub(startTime).mul(BASE).div(delegatorVestingDuration);
715 
716         if (vestedPerc > BASE) {
717             vestedPerc = BASE;
718         }
719         if (delegatorVestedPerc > BASE) {
720           delegatorVestedPerc = BASE;
721         }
722 
723         // add to total vesting
724         uint256 totalVesting = vesting[_msgSender()];
725 
726         // get redeemable total vested by checking how much time has passed
727         uint256 totalVestingRedeemable = totalVesting.mul(vestedPerc).div(BASE);
728 
729         uint256 totalVestingDelegator = delegator_vesting[_msgSender()].mul(delegatorVestedPerc).div(BASE);
730 
731         // get already claimed vested rewards
732         uint256 alreadyClaimed = claimed[_msgSender()];
733 
734         // get already claimed delegator
735         uint256 alreadyClaimedDelegator = delegator_claimed[_msgSender()];
736 
737         // get current redeemable
738         uint256 currVested = totalVestingRedeemable.sub(alreadyClaimed);
739 
740         // get current redeemable delegator
741         uint256 currVestedDelegator = totalVestingDelegator.sub(alreadyClaimedDelegator);
742 
743         // update claimed
744         claimed[_msgSender()] = claimed[_msgSender()].add(currVested);
745 
746         // update delegator rewards claimed
747         delegator_claimed[_msgSender()] = delegator_claimed[_msgSender()].add(currVestedDelegator);
748 
749         // mint, this is in raw internalDecimals. Handled by updated _mint function
750         YAMv3(yamV3).mint(_msgSender(), currVested.add(currVestedDelegator));
751     }
752 
753 
754     // this is a gas intensive airdrop of sorts
755     function addDelegatorReward(
756         address[] calldata delegators,
757         uint256[] calldata amounts,
758         bool under27 // indicates this batch is for those who delegated under 27 yams
759     )
760         external
761         onlyOwner
762     {
763         require(!delegatorRewardsSet, "set");
764         require(delegators.length == amounts.length, "!len");
765         if (!under27) {
766             for (uint256 i = 0; i < delegators.length; i++) {
767                 delegator_vesting[delegators[i]] = amounts[i]; // must be on order of 1e24;
768             }
769         } else {
770             for (uint256 i = 0; i < delegators.length; i++) {
771                 delegator_vesting[delegators[i]] = 27 * 10**24; // flat distribution;
772             }
773         }
774     }
775 
776     // if people are dumb and send tokens here, give governance ability to save them.
777     function rescueTokens(
778         address token,
779         address to,
780         uint256 amount
781     )
782         external
783         onlyOwner
784     {
785         // transfer to
786         SafeERC20.safeTransfer(IERC20(token), to, amount);
787     }
788 }