1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
4 
5 
6 // 
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
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 //
29 
30 // 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // 
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
121      * @dev Returns the addition of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         uint256 c = a + b;
127         if (c < a) return (false, 0);
128         return (true, c);
129     }
130 
131     /**
132      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         if (b > a) return (false, 0);
138         return (true, a - b);
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) return (true, 0);
151         uint256 c = a * b;
152         if (c / a != b) return (false, 0);
153         return (true, c);
154     }
155 
156     /**
157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         if (b == 0) return (false, 0);
163         return (true, a / b);
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         if (b == 0) return (false, 0);
173         return (true, a % b);
174     }
175 
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      *
184      * - Addition cannot overflow.
185      */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b <= a, "SafeMath: subtraction overflow");
204         return a - b;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      *
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         if (a == 0) return 0;
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers, reverting on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         require(b > 0, "SafeMath: division by zero");
238         return a / b;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * reverting when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         require(b > 0, "SafeMath: modulo by zero");
255         return a % b;
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260      * overflow (when the result is negative).
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {trySub}.
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         return a - b;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
278      * division by zero. The result is rounded towards zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryDiv}.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         return a / b;
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * reverting with custom message when dividing by zero.
299      *
300      * CAUTION: This function is deprecated because it requires allocating memory for the error
301      * message unnecessarily. For custom revert reasons use {tryMod}.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         require(b > 0, errorMessage);
313         return a % b;
314     }
315 }
316 
317 // 
318 /**
319  * @dev Collection of functions related to the address type
320  */
321 library Address {
322     /**
323      * @dev Returns true if `account` is a contract.
324      *
325      * [IMPORTANT]
326      * ====
327      * It is unsafe to assume that an address for which this function returns
328      * false is an externally-owned account (EOA) and not a contract.
329      *
330      * Among others, `isContract` will return false for the following
331      * types of addresses:
332      *
333      *  - an externally-owned account
334      *  - a contract in construction
335      *  - an address where a contract will be created
336      *  - an address where a contract lived, but was destroyed
337      * ====
338      */
339     function isContract(address account) internal view returns (bool) {
340         // This method relies on extcodesize, which returns 0 for contracts in
341         // construction, since the code is only stored at the end of the
342         // constructor execution.
343 
344         uint256 size;
345         // solhint-disable-next-line no-inline-assembly
346         assembly { size := extcodesize(account) }
347         return size > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(address(this).balance >= amount, "Address: insufficient balance");
368 
369         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
370         (bool success, ) = recipient.call{ value: amount }("");
371         require(success, "Address: unable to send value, recipient may have reverted");
372     }
373 
374     /**
375      * @dev Performs a Solidity function call using a low level `call`. A
376      * plain`call` is an unsafe replacement for a function call: use this
377      * function instead.
378      *
379      * If `target` reverts with a revert reason, it is bubbled up by this
380      * function (like regular Solidity function calls).
381      *
382      * Returns the raw returned data. To convert to the expected return value,
383      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
384      *
385      * Requirements:
386      *
387      * - `target` must be a contract.
388      * - calling `target` with `data` must not revert.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
393       return functionCall(target, data, "Address: low-level call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
398      * `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
428         require(address(this).balance >= value, "Address: insufficient balance for call");
429         require(isContract(target), "Address: call to non-contract");
430 
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success, bytes memory returndata) = target.call{ value: value }(data);
433         return _verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
443         return functionStaticCall(target, data, "Address: low-level static call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
453         require(isContract(target), "Address: static call to non-contract");
454 
455         // solhint-disable-next-line avoid-low-level-calls
456         (bool success, bytes memory returndata) = target.staticcall(data);
457         return _verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
467         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
477         require(isContract(target), "Address: delegate call to non-contract");
478 
479         // solhint-disable-next-line avoid-low-level-calls
480         (bool success, bytes memory returndata) = target.delegatecall(data);
481         return _verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
485         if (success) {
486             return returndata;
487         } else {
488             // Look for revert reason and bubble it up if present
489             if (returndata.length > 0) {
490                 // The easiest way to bubble the revert reason is using memory via assembly
491 
492                 // solhint-disable-next-line no-inline-assembly
493                 assembly {
494                     let returndata_size := mload(returndata)
495                     revert(add(32, returndata), returndata_size)
496                 }
497             } else {
498                 revert(errorMessage);
499             }
500         }
501     }
502 }
503 
504 // 
505 /**
506  * @dev Contract module which provides a basic access control mechanism, where
507  * there is an account (an owner) that can be granted exclusive access to
508  * specific functions.
509  *
510  * By default, the owner account will be the one that deploys the contract. This
511  * can later be changed with {transferOwnership}.
512  *
513  * This module is used through inheritance. It will make available the modifier
514  * `onlyOwner`, which can be applied to your functions to restrict their use to
515  * the owner.
516  */
517 abstract contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     /**
523      * @dev Initializes the contract setting the deployer as the initial owner.
524      */
525     constructor () internal {
526         address msgSender = _msgSender();
527         _owner = msgSender;
528         emit OwnershipTransferred(address(0), msgSender);
529     }
530 
531     /**
532      * @dev Returns the address of the current owner.
533      */
534     function owner() public view virtual returns (address) {
535         return _owner;
536     }
537 
538     /**
539      * @dev Throws if called by any account other than the owner.
540      */
541     modifier onlyOwner() {
542         require(owner() == _msgSender(), "Ownable: caller is not the owner");
543         _;
544     }
545 
546     /**
547      * @dev Leaves the contract without owner. It will not be possible to call
548      * `onlyOwner` functions anymore. Can only be called by the current owner.
549      *
550      * NOTE: Renouncing ownership will leave the contract without an owner,
551      * thereby removing any functionality that is only available to the owner.
552      */
553     function renounceOwnership() public virtual onlyOwner {
554         emit OwnershipTransferred(_owner, address(0));
555         _owner = address(0);
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Can only be called by the current owner.
561      */
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         emit OwnershipTransferred(_owner, newOwner);
565         _owner = newOwner;
566     }
567 }
568 
569 // 
570 /**
571  * @title SafeERC20
572  * @dev Wrappers around ERC20 operations that throw on failure (when the token
573  * contract returns false). Tokens that return no value (and instead revert or
574  * throw on failure) are also supported, non-reverting calls are assumed to be
575  * successful.
576  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
577  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
578  */
579 library SafeERC20 {
580     using SafeMath for uint256;
581     using Address for address;
582 
583     function safeTransfer(IERC20 token, address to, uint256 value) internal {
584         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
585     }
586 
587     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
588         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
589     }
590 
591     /**
592      * @dev Deprecated. This function has issues similar to the ones found in
593      * {IERC20-approve}, and its usage is discouraged.
594      *
595      * Whenever possible, use {safeIncreaseAllowance} and
596      * {safeDecreaseAllowance} instead.
597      */
598     function safeApprove(IERC20 token, address spender, uint256 value) internal {
599         // safeApprove should only be called when setting an initial allowance,
600         // or when resetting it to zero. To increase and decrease it, use
601         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
602         // solhint-disable-next-line max-line-length
603         require((value == 0) || (token.allowance(address(this), spender) == 0),
604             "SafeERC20: approve from non-zero to non-zero allowance"
605         );
606         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
607     }
608 
609     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
610         uint256 newAllowance = token.allowance(address(this), spender).add(value);
611         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
612     }
613 
614     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
615         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
616         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
617     }
618 
619     /**
620      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
621      * on the return value: the return value is optional (but if data is returned, it must not be false).
622      * @param token The token targeted by the call.
623      * @param data The call data (encoded using abi.encode or one of its variants).
624      */
625     function _callOptionalReturn(IERC20 token, bytes memory data) private {
626         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
627         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
628         // the target address contains contract code and also asserts for success in the low-level call.
629 
630         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
631         if (returndata.length > 0) { // Return data is optional
632             // solhint-disable-next-line max-line-length
633             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
634         }
635     }
636 }
637 
638 // MasterChef is the master of VEMP. He can make VEMP and he is a fair guy.
639 //
640 // Note that it's ownable and the owner wields tremendous power. The ownership
641 // will be transferred to a governance smart contract once VEMP is sufficiently
642 // distributed and the community can show to govern itself.
643 //
644 // Have fun reading it. Hopefully it's bug-free. God bless.
645 contract MasterChefETH is Ownable {
646     using SafeMath for uint256;
647     using SafeERC20 for IERC20;
648 
649     // Info of each user.
650     struct UserInfo {
651         uint256 amount;     // How many LP tokens the user has provided.
652         uint256 rewardDebt; // Reward debt. See explanation below.
653         uint256 rewardETHDebt; // Reward debt in ETH.
654         //
655         // We do some fancy math here. Basically, any point in time, the amount of VEMPs
656         // entitled to a user but is pending to be distributed is:
657         //
658         //   pending reward = (user.amount * pool.accVEMPPerShare) - user.rewardDebt
659         //
660         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
661         //   1. The pool's `accVEMPPerShare` (and `lastRewardBlock`) gets updated.
662         //   2. User receives the pending reward sent to his/her address.
663         //   3. User's `amount` gets updated.
664         //   4. User's `rewardDebt` gets updated.
665     }
666 
667     // Info of each pool.
668     struct PoolInfo {
669         uint256 allocPoint;       // How many allocation points assigned to this pool. VEMPs to distribute per block.
670         uint256 lastRewardBlock;  // Last block number that VEMPs distribution occurs.
671         uint256 accVEMPPerShare; // Accumulated VEMPs per share, times 1e12. See below.
672         uint256 accETHPerShare; // Accumulated ETHs per share, times 1e12. See below.
673         uint256 lastTotalETHReward; // last total rewards
674         uint256 lastETHRewardBalance; // last ETH rewards tokens
675         uint256 totalETHReward; // total ETH rewards tokens
676     }
677 
678     // The VEMP TOKEN!
679     IERC20 public VEMP;
680     // admin address.
681     address public adminaddr;
682     // VEMP tokens created per block.
683     uint256 public VEMPPerBlock;
684     // Bonus muliplier for early VEMP makers.
685     uint256 public constant BONUS_MULTIPLIER = 1;
686 
687     // Info of each pool.
688     PoolInfo public poolInfo;
689     // Info of each user that stakes LP tokens.
690     mapping (address => UserInfo) public userInfo;
691     // Total allocation poitns. Must be the sum of all allocation points in all pools.
692     uint256 public totalAllocPoint = 0;
693     // The block number when VEMP mining starts.
694     uint256 public startBlock;
695     // total ETH staked
696     uint256 public totalETHStaked;
697     // total ETH used for purchase land
698     uint256 public totalETHUsedForPurchase = 0;
699 
700     event Deposit(address indexed user, uint256 amount);
701 
702     constructor(
703         IERC20 _VEMP,
704         address _adminaddr,
705         uint256 _VEMPPerBlock,
706         uint256 _startBlock
707     ) public {
708         VEMP = _VEMP;
709         adminaddr = _adminaddr;
710         VEMPPerBlock = _VEMPPerBlock;
711         startBlock = _startBlock;
712         
713         updatePool(0);
714         
715         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
716         totalAllocPoint = totalAllocPoint.add(100);
717         poolInfo.allocPoint = 100;
718         poolInfo.lastRewardBlock = lastRewardBlock;
719         poolInfo.accVEMPPerShare = 0;
720         poolInfo.accETHPerShare = 0;
721         poolInfo.lastTotalETHReward = 0;
722         poolInfo.lastETHRewardBalance = 0;
723         poolInfo.totalETHReward = 0;
724     }
725     
726     //to recieve ETH from admin
727     receive() external payable {}
728 
729     // Update the given pool's VEMP allocation point. Can only be called by the owner.
730     function set( uint256 _allocPoint, bool _withUpdate) public onlyOwner {
731         if (_withUpdate) {
732             updatePool(0);
733         }
734         totalAllocPoint = totalAllocPoint.sub(poolInfo.allocPoint).add(_allocPoint);
735         poolInfo.allocPoint = _allocPoint;
736     }
737     
738     // Return reward multiplier over the given _from to _to block.
739     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
740         if (_to >= _from) {
741             return _to.sub(_from).mul(BONUS_MULTIPLIER);
742         } else {
743             return _from.sub(_to);
744         }
745     }
746 
747     // View function to see pending VEMPs on frontend.
748     function pendingVEMP(address _user) external view returns (uint256) {
749         PoolInfo storage pool = poolInfo;
750         UserInfo storage user = userInfo[_user];
751         uint256 accVEMPPerShare = pool.accVEMPPerShare;
752         uint256 lpSupply = totalETHStaked;
753         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
754             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
755             uint256 VEMPReward = multiplier.mul(VEMPPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
756             accVEMPPerShare = accVEMPPerShare.add(VEMPReward.mul(1e12).div(lpSupply));
757         }
758         return user.amount.mul(accVEMPPerShare).div(1e12).sub(user.rewardDebt);
759     }
760     
761     // View function to see pending ETHs on frontend.
762     function pendingETH(address _user) external view returns (uint256) {
763         PoolInfo storage pool = poolInfo;
764         UserInfo storage user = userInfo[_user];
765         uint256 accETHPerShare = pool.accETHPerShare;
766         uint256 lpSupply = totalETHStaked;
767         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
768             uint256 rewardBalance = address(this).balance.sub(totalETHStaked.sub(totalETHUsedForPurchase));
769             uint256 _totalReward = rewardBalance.sub(pool.lastETHRewardBalance);
770             accETHPerShare = accETHPerShare.add(_totalReward.mul(1e12).div(lpSupply));
771         }
772         return user.amount.mul(accETHPerShare).div(1e12).sub(user.rewardETHDebt);
773     }
774 
775     // Update reward variables of the given pool to be up-to-date.
776     function updatePool(uint256 _amount) internal {
777         PoolInfo storage pool = poolInfo;
778         UserInfo storage user = userInfo[msg.sender];
779         
780         if (block.number <= pool.lastRewardBlock) {
781             return;
782         }
783         uint256 rewardBalance = address(this).balance.sub(_amount).sub(totalETHStaked.sub(totalETHUsedForPurchase));
784         uint256 _totalReward = pool.totalETHReward.add(rewardBalance.sub(pool.lastETHRewardBalance));
785         pool.lastETHRewardBalance = rewardBalance;
786         pool.totalETHReward = _totalReward;
787         
788         uint256 lpSupply = totalETHStaked;
789         if (lpSupply == 0) {
790             pool.lastRewardBlock = block.number;
791             pool.accETHPerShare = 0;
792             pool.lastTotalETHReward = 0;
793             user.rewardETHDebt = 0;
794             pool.lastETHRewardBalance = 0;
795             pool.totalETHReward = 0;
796             return;
797         }
798         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
799         uint256 VEMPReward = multiplier.mul(VEMPPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
800         pool.accVEMPPerShare = pool.accVEMPPerShare.add(VEMPReward.mul(1e12).div(lpSupply));
801         pool.lastRewardBlock = block.number;
802         
803         uint256 reward = _totalReward.sub(pool.lastTotalETHReward);
804         pool.accETHPerShare = pool.accETHPerShare.add(reward.mul(1e12).div(lpSupply));
805         pool.lastTotalETHReward = _totalReward;
806     }
807 
808     // Deposit LP tokens to MasterChef for VEMP allocation.
809     function deposit(uint256 _amount) public payable {
810         require(msg.value == _amount, "Eth must be equal to staked amount");
811         PoolInfo storage pool = poolInfo;
812         UserInfo storage user = userInfo[msg.sender];
813         updatePool(msg.value);
814         if (user.amount > 0) {
815             uint256 pending = user.amount.mul(pool.accVEMPPerShare).div(1e12).sub(user.rewardDebt);
816             safeVEMPTransfer(msg.sender, pending);
817             
818             uint256 ETHReward = user.amount.mul(pool.accETHPerShare).div(1e12).sub(user.rewardETHDebt);
819             msg.sender.transfer(ETHReward);
820             pool.lastETHRewardBalance = address(this).balance.sub(msg.value).sub(totalETHStaked.sub(totalETHUsedForPurchase));
821         }
822         totalETHStaked = totalETHStaked.add(msg.value);
823         user.amount = user.amount.add(msg.value);
824         user.rewardDebt = user.amount.mul(pool.accVEMPPerShare).div(1e12);
825         user.rewardETHDebt = user.amount.mul(pool.accETHPerShare).div(1e12);
826         emit Deposit(msg.sender, msg.value);
827     }
828     
829     // Safe VEMP transfer function, just in case if rounding error causes pool to not have enough VEMPs.
830     function safeVEMPTransfer(address _to, uint256 _amount) internal {
831         uint256 VEMPBal = VEMP.balanceOf(address(this));
832         if (_amount > VEMPBal) {
833             VEMP.transfer(_to, VEMPBal);
834         } else {
835             VEMP.transfer(_to, _amount);
836         }
837     }
838     
839     // Earn ETH tokens to MasterChef.
840     function claimETH() public {
841         PoolInfo storage pool = poolInfo;
842         UserInfo storage user = userInfo[msg.sender];
843         updatePool(0);
844         
845         uint256 ETHReward = user.amount.mul(pool.accETHPerShare).div(1e12).sub(user.rewardETHDebt);
846         msg.sender.transfer(ETHReward);
847         pool.lastETHRewardBalance = address(this).balance.sub(totalETHStaked.sub(totalETHUsedForPurchase));
848         
849         user.rewardETHDebt = user.amount.mul(pool.accETHPerShare).div(1e12);
850     }
851     
852     // Safe ETH transfer function to admin.
853     function accessETHTokens(address payable _to, uint256 _amount) public {
854         require(msg.sender == adminaddr, "sender must be admin address");
855         require(totalETHStaked.sub(totalETHUsedForPurchase) >= _amount, "Amount must be less than staked ETH amount");
856         uint256 ETHBal = address(this).balance;
857         if (_amount > ETHBal) {
858             _to.transfer(ETHBal);
859             totalETHUsedForPurchase = totalETHUsedForPurchase.add(ETHBal);
860         } else {
861             _to.transfer(_amount);
862             totalETHUsedForPurchase = totalETHUsedForPurchase.add(_amount);
863         }
864     }
865     
866     // Update Reward per block
867     function updateRewardPerBlock(uint256 _newRewardPerBlock) public onlyOwner {
868         updatePool(0);
869         VEMPPerBlock = _newRewardPerBlock;
870     }
871 
872     // Update admin address by the previous admin.
873     function admin(address _adminaddr) public {
874         require(msg.sender == adminaddr, "admin: wut?");
875         adminaddr = _adminaddr;
876     }
877 }