1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin\contracts\math\SafeMath.sol
3 
4 pragma solidity >=0.6.0 <0.8.0;
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
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         uint256 c = a + b;
27         if (c < a) return (false, 0);
28         return (true, c);
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         if (b > a) return (false, 0);
38         return (true, a - b);
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50         if (a == 0) return (true, 0);
51         uint256 c = a * b;
52         if (c / a != b) return (false, 0);
53         return (true, c);
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         if (b == 0) return (false, 0);
63         return (true, a / b);
64     }
65 
66     /**
67      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         if (b == 0) return (false, 0);
73         return (true, a % b);
74     }
75 
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      *
84      * - Addition cannot overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a, "SafeMath: subtraction overflow");
104         return a - b;
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      *
115      * - Multiplication cannot overflow.
116      */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) return 0;
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121         return c;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b > 0, "SafeMath: division by zero");
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b > 0, "SafeMath: modulo by zero");
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         return a - b;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * CAUTION: This function is deprecated because it requires allocating memory for the error
181      * message unnecessarily. For custom revert reasons use {tryDiv}.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         return a / b;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         return a % b;
214     }
215 }
216 
217 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
218 
219 pragma solidity >=0.6.0 <0.8.0;
220 
221 /**
222  * @dev Interface of the ERC20 standard as defined in the EIP.
223  */
224 interface IERC20 {
225     /**
226      * @dev Returns the amount of tokens in existence.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     /**
231      * @dev Returns the amount of tokens owned by `account`.
232      */
233     function balanceOf(address account) external view returns (uint256);
234 
235     /**
236      * @dev Moves `amount` tokens from the caller's account to `recipient`.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transfer(address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Returns the remaining number of tokens that `spender` will be
246      * allowed to spend on behalf of `owner` through {transferFrom}. This is
247      * zero by default.
248      *
249      * This value changes when {approve} or {transferFrom} are called.
250      */
251     function allowance(address owner, address spender) external view returns (uint256);
252 
253     /**
254      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * IMPORTANT: Beware that changing an allowance with this method brings the risk
259      * that someone may use both the old and the new allowance by unfortunate
260      * transaction ordering. One possible solution to mitigate this race
261      * condition is to first reduce the spender's allowance to 0 and set the
262      * desired value afterwards:
263      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264      *
265      * Emits an {Approval} event.
266      */
267     function approve(address spender, uint256 amount) external returns (bool);
268 
269     /**
270      * @dev Moves `amount` tokens from `sender` to `recipient` using the
271      * allowance mechanism. `amount` is then deducted from the caller's
272      * allowance.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * Emits a {Transfer} event.
277      */
278     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Emitted when `value` tokens are moved from one account (`from`) to
282      * another (`to`).
283      *
284      * Note that `value` may be zero.
285      */
286     event Transfer(address indexed from, address indexed to, uint256 value);
287 
288     /**
289      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
290      * a call to {approve}. `value` is the new allowance.
291      */
292     event Approval(address indexed owner, address indexed spender, uint256 value);
293 }
294 
295 
296 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
297 pragma solidity >=0.6.2 <0.8.0;
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304      * @dev Returns true if `account` is a contract.
305      *
306      * [IMPORTANT]
307      * ====
308      * It is unsafe to assume that an address for which this function returns
309      * false is an externally-owned account (EOA) and not a contract.
310      *
311      * Among others, `isContract` will return false for the following
312      * types of addresses:
313      *
314      *  - an externally-owned account
315      *  - a contract in construction
316      *  - an address where a contract will be created
317      *  - an address where a contract lived, but was destroyed
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         // solhint-disable-next-line no-inline-assembly
327         assembly { size := extcodesize(account) }
328         return size > 0;
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
348         require(address(this).balance >= amount, "Address: insufficient balance");
349 
350         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
351         (bool success, ) = recipient.call{ value: amount }("");
352         require(success, "Address: unable to send value, recipient may have reverted");
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
374       return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
409         require(address(this).balance >= value, "Address: insufficient balance for call");
410         require(isContract(target), "Address: call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = target.call{ value: value }(data);
414         return _verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
424         return functionStaticCall(target, data, "Address: low-level static call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
434         require(isContract(target), "Address: static call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.staticcall(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
448         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
486 
487 pragma solidity >=0.6.0 <0.8.0;
488 
489 /**
490  * @title SafeERC20
491  * @dev Wrappers around ERC20 operations that throw on failure (when the token
492  * contract returns false). Tokens that return no value (and instead revert or
493  * throw on failure) are also supported, non-reverting calls are assumed to be
494  * successful.
495  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
496  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
497  */
498 library SafeERC20 {
499     using SafeMath for uint256;
500     using Address for address;
501 
502     function safeTransfer(IERC20 token, address to, uint256 value) internal {
503         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
504     }
505 
506     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
507         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
508     }
509 
510     /**
511      * @dev Deprecated. This function has issues similar to the ones found in
512      * {IERC20-approve}, and its usage is discouraged.
513      *
514      * Whenever possible, use {safeIncreaseAllowance} and
515      * {safeDecreaseAllowance} instead.
516      */
517     function safeApprove(IERC20 token, address spender, uint256 value) internal {
518         // safeApprove should only be called when setting an initial allowance,
519         // or when resetting it to zero. To increase and decrease it, use
520         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
521         // solhint-disable-next-line max-line-length
522         require((value == 0) || (token.allowance(address(this), spender) == 0),
523             "SafeERC20: approve from non-zero to non-zero allowance"
524         );
525         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
526     }
527 
528     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).add(value);
530         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function _callOptionalReturn(IERC20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
547         // the target address contains contract code and also asserts for success in the low-level call.
548 
549         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
550         if (returndata.length > 0) { // Return data is optional
551             // solhint-disable-next-line max-line-length
552             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
553         }
554     }
555 }
556 
557 // File: @openzeppelin\contracts\utils\Context.sol
558 
559 pragma solidity >=0.6.0 <0.8.0;
560 
561 /*
562  * @dev Provides information about the current execution context, including the
563  * sender of the transaction and its data. While these are generally available
564  * via msg.sender and msg.data, they should not be accessed in such a direct
565  * manner, since when dealing with GSN meta-transactions the account sending and
566  * paying for execution may not be the actual sender (as far as an application
567  * is concerned).
568  *
569  * This contract is only required for intermediate, library-like contracts.
570  */
571 abstract contract Context {
572     function _msgSender() internal view virtual returns (address payable) {
573         return msg.sender;
574     }
575 
576     function _msgData() internal view virtual returns (bytes memory) {
577         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
578         return msg.data;
579     }
580 }
581 
582 // File: contracts\interfaces\IRewarder.sol
583 
584 pragma solidity 0.6.12;
585 
586 interface IRewarder {
587     using SafeERC20 for IERC20;
588     function onReward(uint256 pid, address user, address recipient, uint256 sushiAmount, uint256 newLpAmount) external;
589     function pendingTokens(uint256 pid, address user, uint256 sushiAmount) external view returns (IERC20[] memory, uint256[] memory);
590 }
591 
592 // File: contracts\ConvexMasterChef.sol
593 
594 pragma solidity 0.6.12;
595 
596 contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(
600         address indexed previousOwner,
601         address indexed newOwner
602     );
603 
604     /**
605      * @dev Initializes the contract setting the deployer as the initial owner.
606      */
607     constructor() internal {
608         address msgSender = _msgSender();
609         _owner = msgSender;
610         emit OwnershipTransferred(address(0), msgSender);
611     }
612 
613     /**
614      * @dev Returns the address of the current owner.
615      */
616     function owner() public view returns (address) {
617         return _owner;
618     }
619 
620     /**
621      * @dev Throws if called by any account other than the owner.
622      */
623     modifier onlyOwner() {
624         require(_owner == _msgSender(), "Ownable: caller is not the owner");
625         _;
626     }
627 
628     /**
629      * @dev Leaves the contract without owner. It will not be possible to call
630      * `onlyOwner` functions anymore. Can only be called by the current owner.
631      *
632      * NOTE: Renouncing ownership will leave the contract without an owner,
633      * thereby removing any functionality that is only available to the owner.
634      */
635     function renounceOwnership() public virtual onlyOwner {
636         emit OwnershipTransferred(_owner, address(0));
637         _owner = address(0);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Can only be called by the current owner.
643      */
644     function transferOwnership(address newOwner) public virtual onlyOwner {
645         require(
646             newOwner != address(0),
647             "Ownable: new owner is the zero address"
648         );
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653 
654 contract ConvexMasterChef is Ownable {
655     using SafeMath for uint256;
656     using SafeERC20 for IERC20;
657 
658     // Info of each user.
659     struct UserInfo {
660         uint256 amount; // How many LP tokens the user has provided.
661         uint256 rewardDebt; // Reward debt. See explanation below.
662         //
663         // We do some fancy math here. Basically, any point in time, the amount of CVXs
664         // entitled to a user but is pending to be distributed is:
665         //
666         //   pending reward = (user.amount * pool.accCvxPerShare) - user.rewardDebt
667         //
668         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
669         //   1. The pool's `accCvxPerShare` (and `lastRewardBlock`) gets updated.
670         //   2. User receives the pending reward sent to his/her address.
671         //   3. User's `amount` gets updated.
672         //   4. User's `rewardDebt` gets updated.
673     }
674 
675     // Info of each pool.
676     struct PoolInfo {
677         IERC20 lpToken; // Address of LP token contract.
678         uint256 allocPoint; // How many allocation points assigned to this pool. CVX to distribute per block.
679         uint256 lastRewardBlock; // Last block number that CVXs distribution occurs.
680         uint256 accCvxPerShare; // Accumulated CVXs per share, times 1e12. See below.
681         IRewarder rewarder;
682     }
683 
684     //cvx
685     IERC20 public cvx;
686     // Block number when bonus CVX period ends.
687     uint256 public bonusEndBlock;
688     // CVX tokens created per block.
689     uint256 public rewardPerBlock;
690     // Bonus muliplier for early cvx makers.
691     uint256 public constant BONUS_MULTIPLIER = 2;
692 
693     // Info of each pool.
694     PoolInfo[] public poolInfo;
695     // Info of each user that stakes LP tokens.
696     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
697     // Total allocation points. Must be the sum of all allocation points in all pools.
698     uint256 public totalAllocPoint = 0;
699     // The block number when CVX mining starts.
700     uint256 public startBlock;
701 
702     // Events
703     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
704     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
705     event RewardPaid(address indexed user,  uint256 indexed pid, uint256 amount);
706     event EmergencyWithdraw(
707         address indexed user,
708         uint256 indexed pid,
709         uint256 amount
710     );
711 
712     constructor(
713         IERC20 _cvx,
714         uint256 _rewardPerBlock,
715         uint256 _startBlock,
716         uint256 _bonusEndBlock
717     ) public {
718         cvx = _cvx;
719         rewardPerBlock = _rewardPerBlock;
720         bonusEndBlock = _bonusEndBlock;
721         startBlock = _startBlock;
722     }
723 
724     function poolLength() external view returns (uint256) {
725         return poolInfo.length;
726     }
727 
728     // Add a new lp to the pool. Can only be called by the owner.
729     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
730     function add(
731         uint256 _allocPoint,
732         IERC20 _lpToken,
733         IRewarder _rewarder,
734         bool _withUpdate
735     ) public onlyOwner {
736         if (_withUpdate) {
737             massUpdatePools();
738         }
739         uint256 lastRewardBlock = block.number > startBlock
740             ? block.number
741             : startBlock;
742         totalAllocPoint = totalAllocPoint.add(_allocPoint);
743         poolInfo.push(
744             PoolInfo({
745                 lpToken: _lpToken,
746                 allocPoint: _allocPoint,
747                 lastRewardBlock: lastRewardBlock,
748                 accCvxPerShare: 0,
749                 rewarder: _rewarder
750             })
751         );
752     }
753 
754     // Update the given pool's CVX allocation point. Can only be called by the owner.
755     function set(
756         uint256 _pid,
757         uint256 _allocPoint,
758         IRewarder _rewarder,
759         bool _withUpdate,
760         bool _updateRewarder
761     ) public onlyOwner {
762         if (_withUpdate) {
763             massUpdatePools();
764         }
765         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
766             _allocPoint
767         );
768         poolInfo[_pid].allocPoint = _allocPoint;
769         if(_updateRewarder){
770             poolInfo[_pid].rewarder = _rewarder;
771         }
772     }
773 
774     // Return reward multiplier over the given _from to _to block.
775     function getMultiplier(uint256 _from, uint256 _to)
776         public
777         view
778         returns (uint256)
779     {
780         if (_to <= bonusEndBlock) {
781             return _to.sub(_from).mul(BONUS_MULTIPLIER);
782         } else if (_from >= bonusEndBlock) {
783             return _to.sub(_from);
784         } else {
785             return
786                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
787                     _to.sub(bonusEndBlock)
788                 );
789         }
790     }
791 
792     // View function to see pending CVXs on frontend.
793     function pendingCvx(uint256 _pid, address _user)
794         external
795         view
796         returns (uint256)
797     {
798         PoolInfo storage pool = poolInfo[_pid];
799         UserInfo storage user = userInfo[_pid][_user];
800         uint256 accCvxPerShare = pool.accCvxPerShare;
801         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
802         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
803             uint256 multiplier = getMultiplier(
804                 pool.lastRewardBlock,
805                 block.number
806             );
807             uint256 cvxReward = multiplier
808                 .mul(rewardPerBlock)
809                 .mul(pool.allocPoint)
810                 .div(totalAllocPoint);
811             accCvxPerShare = accCvxPerShare.add(
812                 cvxReward.mul(1e12).div(lpSupply)
813             );
814         }
815         return user.amount.mul(accCvxPerShare).div(1e12).sub(user.rewardDebt);
816     }
817 
818     // Update reward vairables for all pools. Be careful of gas spending!
819     function massUpdatePools() public {
820         uint256 length = poolInfo.length;
821         for (uint256 pid = 0; pid < length; ++pid) {
822             updatePool(pid);
823         }
824     }
825 
826     // Update reward variables of the given pool to be up-to-date.
827     function updatePool(uint256 _pid) public {
828         PoolInfo storage pool = poolInfo[_pid];
829         if (block.number <= pool.lastRewardBlock) {
830             return;
831         }
832         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
833         if (lpSupply == 0) {
834             pool.lastRewardBlock = block.number;
835             return;
836         }
837         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
838         uint256 cvxReward = multiplier
839             .mul(rewardPerBlock)
840             .mul(pool.allocPoint)
841             .div(totalAllocPoint);
842         //cvx.mint(address(this), cvxReward);
843         pool.accCvxPerShare = pool.accCvxPerShare.add(
844             cvxReward.mul(1e12).div(lpSupply)
845         );
846         pool.lastRewardBlock = block.number;
847     }
848 
849     // Deposit LP tokens to MasterChef for CVX allocation.
850     function deposit(uint256 _pid, uint256 _amount) public {
851         PoolInfo storage pool = poolInfo[_pid];
852         UserInfo storage user = userInfo[_pid][msg.sender];
853         updatePool(_pid);
854         if (user.amount > 0) {
855             uint256 pending = user
856                 .amount
857                 .mul(pool.accCvxPerShare)
858                 .div(1e12)
859                 .sub(user.rewardDebt);
860             safeRewardTransfer(msg.sender, pending);
861         }
862         pool.lpToken.safeTransferFrom(
863             address(msg.sender),
864             address(this),
865             _amount
866         );
867         user.amount = user.amount.add(_amount);
868         user.rewardDebt = user.amount.mul(pool.accCvxPerShare).div(1e12);
869 
870         //extra rewards
871         IRewarder _rewarder = pool.rewarder;
872         if (address(_rewarder) != address(0)) {
873             _rewarder.onReward(_pid, msg.sender, msg.sender, 0, user.amount);
874         }
875 
876         emit Deposit(msg.sender, _pid, _amount);
877     }
878 
879     // Withdraw LP tokens from MasterChef.
880     function withdraw(uint256 _pid, uint256 _amount) public {
881         PoolInfo storage pool = poolInfo[_pid];
882         UserInfo storage user = userInfo[_pid][msg.sender];
883         require(user.amount >= _amount, "withdraw: not good");
884         updatePool(_pid);
885         uint256 pending = user.amount.mul(pool.accCvxPerShare).div(1e12).sub(
886             user.rewardDebt
887         );
888         safeRewardTransfer(msg.sender, pending);
889         user.amount = user.amount.sub(_amount);
890         user.rewardDebt = user.amount.mul(pool.accCvxPerShare).div(1e12);
891         pool.lpToken.safeTransfer(address(msg.sender), _amount);
892 
893         //extra rewards
894         IRewarder _rewarder = pool.rewarder;
895         if (address(_rewarder) != address(0)) {
896             _rewarder.onReward(_pid, msg.sender, msg.sender, pending, user.amount);
897         }
898 
899         emit RewardPaid(msg.sender, _pid, pending);
900         emit Withdraw(msg.sender, _pid, _amount);
901     }
902 
903     function claim(uint256 _pid, address _account) external{
904         PoolInfo storage pool = poolInfo[_pid];
905         UserInfo storage user = userInfo[_pid][_account];
906 
907         updatePool(_pid);
908         uint256 pending = user.amount.mul(pool.accCvxPerShare).div(1e12).sub(
909             user.rewardDebt
910         );
911         safeRewardTransfer(_account, pending);
912         user.rewardDebt = user.amount.mul(pool.accCvxPerShare).div(1e12);
913 
914         //extra rewards
915         IRewarder _rewarder = pool.rewarder;
916         if (address(_rewarder) != address(0)) {
917             _rewarder.onReward(_pid, _account, _account, pending, user.amount);
918         }
919 
920         emit RewardPaid(_account, _pid, pending);
921     }
922 
923     // Withdraw without caring about rewards. EMERGENCY ONLY.
924     function emergencyWithdraw(uint256 _pid) public {
925         PoolInfo storage pool = poolInfo[_pid];
926         UserInfo storage user = userInfo[_pid][msg.sender];
927         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
928         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
929         user.amount = 0;
930         user.rewardDebt = 0;
931 
932         //extra rewards
933         IRewarder _rewarder = pool.rewarder;
934         if (address(_rewarder) != address(0)) {
935             _rewarder.onReward(_pid, msg.sender, msg.sender, 0, 0);
936         }
937     }
938 
939     // Safe cvx transfer function, just in case if rounding error causes pool to not have enough CVXs.
940     function safeRewardTransfer(address _to, uint256 _amount) internal {
941         uint256 cvxBal = cvx.balanceOf(address(this));
942         if (_amount > cvxBal) {
943             cvx.safeTransfer(_to, cvxBal);
944         } else {
945             cvx.safeTransfer(_to, _amount);
946         }
947     }
948 
949 }