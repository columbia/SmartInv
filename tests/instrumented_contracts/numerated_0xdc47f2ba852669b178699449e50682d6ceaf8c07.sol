1 // Sources flattened with buidler v1.3.8 https://buidler.dev
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.1.0
4 
5 // SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File contracts/6/engine/IERC20Mintable.sol
85 
86 /**
87  * @title Interface for mintable ERC20
88  * @author Validity Labs AG <info@validitylabs.org>
89  */
90 
91 
92 pragma solidity ^0.6.0;
93 
94 
95 interface IERC20Mintable is IERC20 {
96     /**
97      * @dev Create `amount` tokens for `to`, increasing the total supply.
98      *
99      * Emits a {Transfer} event.
100      */
101     function mint(address to, uint256 amount) external;
102 }
103 
104 
105 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
106 
107 
108 
109 pragma solidity ^0.6.0;
110 
111 /*
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with GSN meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address payable) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes memory) {
127         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
128         return msg.data;
129     }
130 }
131 
132 
133 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0
134 
135 
136 
137 pragma solidity ^0.6.0;
138 
139 /**
140  * @dev Contract module which provides a basic access control mechanism, where
141  * there is an account (an owner) that can be granted exclusive access to
142  * specific functions.
143  *
144  * By default, the owner account will be the one that deploys the contract. This
145  * can later be changed with {transferOwnership}.
146  *
147  * This module is used through inheritance. It will make available the modifier
148  * `onlyOwner`, which can be applied to your functions to restrict their use to
149  * the owner.
150  */
151 contract Ownable is Context {
152     address private _owner;
153 
154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156     /**
157      * @dev Initializes the contract setting the deployer as the initial owner.
158      */
159     constructor () internal {
160         address msgSender = _msgSender();
161         _owner = msgSender;
162         emit OwnershipTransferred(address(0), msgSender);
163     }
164 
165     /**
166      * @dev Returns the address of the current owner.
167      */
168     function owner() public view returns (address) {
169         return _owner;
170     }
171 
172     /**
173      * @dev Throws if called by any account other than the owner.
174      */
175     modifier onlyOwner() {
176         require(_owner == _msgSender(), "Ownable: caller is not the owner");
177         _;
178     }
179 
180     /**
181      * @dev Leaves the contract without owner. It will not be possible to call
182      * `onlyOwner` functions anymore. Can only be called by the current owner.
183      *
184      * NOTE: Renouncing ownership will leave the contract without an owner,
185      * thereby removing any functionality that is only available to the owner.
186      */
187     function renounceOwnership() public virtual onlyOwner {
188         emit OwnershipTransferred(_owner, address(0));
189         _owner = address(0);
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Can only be called by the current owner.
195      */
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         emit OwnershipTransferred(_owner, newOwner);
199         _owner = newOwner;
200     }
201 }
202 
203 
204 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
205 
206 
207 
208 pragma solidity ^0.6.0;
209 
210 /**
211  * @dev Wrappers over Solidity's arithmetic operations with added overflow
212  * checks.
213  *
214  * Arithmetic operations in Solidity wrap on overflow. This can easily result
215  * in bugs, because programmers usually assume that an overflow raises an
216  * error, which is the standard behavior in high level programming languages.
217  * `SafeMath` restores this intuition by reverting the transaction when an
218  * operation overflows.
219  *
220  * Using this library instead of the unchecked operations eliminates an entire
221  * class of bugs, so it's recommended to use it always.
222  */
223 library SafeMath {
224     /**
225      * @dev Returns the addition of two unsigned integers, reverting on
226      * overflow.
227      *
228      * Counterpart to Solidity's `+` operator.
229      *
230      * Requirements:
231      *
232      * - Addition cannot overflow.
233      */
234     function add(uint256 a, uint256 b) internal pure returns (uint256) {
235         uint256 c = a + b;
236         require(c >= a, "SafeMath: addition overflow");
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
252         return sub(a, b, "SafeMath: subtraction overflow");
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
257      * overflow (when the result is negative).
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `*` operator.
277      *
278      * Requirements:
279      *
280      * - Multiplication cannot overflow.
281      */
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
284         // benefit is lost if 'b' is also tested.
285         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
286         if (a == 0) {
287             return 0;
288         }
289 
290         uint256 c = a * b;
291         require(c / a == b, "SafeMath: multiplication overflow");
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers. Reverts on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return div(a, b, "SafeMath: division by zero");
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b > 0, errorMessage);
326         uint256 c = a / b;
327         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
345         return mod(a, b, "SafeMath: modulo by zero");
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
350      * Reverts with custom message when dividing by zero.
351      *
352      * Counterpart to Solidity's `%` operator. This function uses a `revert`
353      * opcode (which leaves remaining gas untouched) while Solidity uses an
354      * invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b != 0, errorMessage);
362         return a % b;
363     }
364 }
365 
366 
367 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0
368 
369 
370 
371 pragma solidity ^0.6.2;
372 
373 /**
374  * @dev Collection of functions related to the address type
375  */
376 library Address {
377     /**
378      * @dev Returns true if `account` is a contract.
379      *
380      * [IMPORTANT]
381      * ====
382      * It is unsafe to assume that an address for which this function returns
383      * false is an externally-owned account (EOA) and not a contract.
384      *
385      * Among others, `isContract` will return false for the following
386      * types of addresses:
387      *
388      *  - an externally-owned account
389      *  - a contract in construction
390      *  - an address where a contract will be created
391      *  - an address where a contract lived, but was destroyed
392      * ====
393      */
394     function isContract(address account) internal view returns (bool) {
395         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
396         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
397         // for accounts without code, i.e. `keccak256('')`
398         bytes32 codehash;
399         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
400         // solhint-disable-next-line no-inline-assembly
401         assembly { codehash := extcodehash(account) }
402         return (codehash != accountHash && codehash != 0x0);
403     }
404 
405     /**
406      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
407      * `recipient`, forwarding all available gas and reverting on errors.
408      *
409      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
410      * of certain opcodes, possibly making contracts go over the 2300 gas limit
411      * imposed by `transfer`, making them unable to receive funds via
412      * `transfer`. {sendValue} removes this limitation.
413      *
414      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
415      *
416      * IMPORTANT: because control is transferred to `recipient`, care must be
417      * taken to not create reentrancy vulnerabilities. Consider using
418      * {ReentrancyGuard} or the
419      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
420      */
421     function sendValue(address payable recipient, uint256 amount) internal {
422         require(address(this).balance >= amount, "Address: insufficient balance");
423 
424         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
425         (bool success, ) = recipient.call{ value: amount }("");
426         require(success, "Address: unable to send value, recipient may have reverted");
427     }
428 
429     /**
430      * @dev Performs a Solidity function call using a low level `call`. A
431      * plain`call` is an unsafe replacement for a function call: use this
432      * function instead.
433      *
434      * If `target` reverts with a revert reason, it is bubbled up by this
435      * function (like regular Solidity function calls).
436      *
437      * Returns the raw returned data. To convert to the expected return value,
438      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
439      *
440      * Requirements:
441      *
442      * - `target` must be a contract.
443      * - calling `target` with `data` must not revert.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
448       return functionCall(target, data, "Address: low-level call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
453      * `errorMessage` as a fallback revert reason when `target` reverts.
454      *
455      * _Available since v3.1._
456      */
457     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
458         return _functionCallWithValue(target, data, 0, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but also transferring `value` wei to `target`.
464      *
465      * Requirements:
466      *
467      * - the calling contract must have an ETH balance of at least `value`.
468      * - the called Solidity function must be `payable`.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
483         require(address(this).balance >= value, "Address: insufficient balance for call");
484         return _functionCallWithValue(target, data, value, errorMessage);
485     }
486 
487     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
488         require(isContract(target), "Address: call to non-contract");
489 
490         // solhint-disable-next-line avoid-low-level-calls
491         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 // solhint-disable-next-line no-inline-assembly
500                 assembly {
501                     let returndata_size := mload(returndata)
502                     revert(add(32, returndata), returndata_size)
503                 }
504             } else {
505                 revert(errorMessage);
506             }
507         }
508     }
509 }
510 
511 
512 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.1.0
513 
514 
515 
516 pragma solidity ^0.6.0;
517 
518 
519 
520 
521 /**
522  * @title SafeERC20
523  * @dev Wrappers around ERC20 operations that throw on failure (when the token
524  * contract returns false). Tokens that return no value (and instead revert or
525  * throw on failure) are also supported, non-reverting calls are assumed to be
526  * successful.
527  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
528  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
529  */
530 library SafeERC20 {
531     using SafeMath for uint256;
532     using Address for address;
533 
534     function safeTransfer(IERC20 token, address to, uint256 value) internal {
535         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
536     }
537 
538     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
539         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
540     }
541 
542     /**
543      * @dev Deprecated. This function has issues similar to the ones found in
544      * {IERC20-approve}, and its usage is discouraged.
545      *
546      * Whenever possible, use {safeIncreaseAllowance} and
547      * {safeDecreaseAllowance} instead.
548      */
549     function safeApprove(IERC20 token, address spender, uint256 value) internal {
550         // safeApprove should only be called when setting an initial allowance,
551         // or when resetting it to zero. To increase and decrease it, use
552         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
553         // solhint-disable-next-line max-line-length
554         require((value == 0) || (token.allowance(address(this), spender) == 0),
555             "SafeERC20: approve from non-zero to non-zero allowance"
556         );
557         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
558     }
559 
560     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
561         uint256 newAllowance = token.allowance(address(this), spender).add(value);
562         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
563     }
564 
565     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
566         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
567         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
568     }
569 
570     /**
571      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
572      * on the return value: the return value is optional (but if data is returned, it must not be false).
573      * @param token The token targeted by the call.
574      * @param data The call data (encoded using abi.encode or one of its variants).
575      */
576     function _callOptionalReturn(IERC20 token, bytes memory data) private {
577         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
578         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
579         // the target address contains contract code and also asserts for success in the low-level call.
580 
581         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
582         if (returndata.length > 0) { // Return data is optional
583             // solhint-disable-next-line max-line-length
584             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
585         }
586     }
587 }
588 
589 
590 // File contracts/6/property/Reclaimable.sol
591 
592 /**
593  * @title Reclaimable
594  * @dev This contract gives owner right to recover any ERC20 tokens accidentally sent to
595  * the token contract. The recovered token will be sent to the owner of token.
596  * @author Validity Labs AG <info@validitylabs.org>
597  */
598 
599 
600 pragma solidity ^0.6.0;
601 
602 
603 
604 
605 
606 contract Reclaimable is Ownable {
607     using SafeERC20 for IERC20;
608     using SafeMath for uint256;
609 
610     mapping (address => uint256) private _allowedBalances;
611 
612     /**
613      * @dev Emitted when the allowance of a `token` to be held by this contract.
614      */
615     event AllowedTokenBalance(address indexed token, uint256 value);
616 
617     /**
618      * @notice Let the owner to retrieve other tokens accidentally sent to this contract.
619      * @dev This function is suitable when no token of any kind shall be stored under
620      * the address of the inherited contract.
621      * @param tokenToBeRecovered address of the token to be recovered.
622      */
623     function reclaimToken(IERC20 tokenToBeRecovered) public onlyOwner {
624         uint256 balance = tokenToBeRecovered.balanceOf(address(this)).sub(_allowedBalances[address(tokenToBeRecovered)]);
625         tokenToBeRecovered.safeTransfer(owner(), balance);
626     }
627 
628     /**
629      * @dev Get the allowance of the `tokenToBeRecovered` token of this contract.
630      * @param tokenToBeRecovered address of the token to be recovered.
631      */
632     function getAllowedBalance(address tokenToBeRecovered) public view returns (uint256) {
633         return _allowedBalances[tokenToBeRecovered];
634     }
635 
636     /**
637      * @notice Atomically increases the allowance of token balance granted to `tokenToBeRecovered` by the caller.
638      * @dev Emits an {AllowedTokenBalance} event indicating the updated allowance.
639      * @param tokenToBeRecovered address of the token to be recovered.
640      * @param addedValue increase in the allowance.
641      */
642     function increaseAllowedBalance(address tokenToBeRecovered, uint256 addedValue) internal virtual returns (bool) {
643         _setAllowedBalance(tokenToBeRecovered, _allowedBalances[tokenToBeRecovered].add(addedValue));
644         return true;
645     }
646 
647     // /**
648     //  * @notice Atomically decreases the allowance of token balance granted to `tokenToBeRecovered` by the caller.
649     //  * @dev Emits an {AllowedTokenBalance} event indicating the updated allowance.
650     //  * @param tokenToBeRecovered address of the token to be recovered.
651     //  * @param subtractedValue decrease in the allowance.
652     //  */
653     // function decreaseAllowedBalance(address tokenToBeRecovered, uint256 subtractedValue) internal virtual returns (bool) {
654     //     _setAllowedBalance(tokenToBeRecovered, _allowedBalances[tokenToBeRecovered].sub(subtractedValue));
655     //     return true;
656     // }
657 
658     /**
659      * @notice Sets `amount` as the allowance of this contract over the `tokenToBeRecovered` tokens.
660      * @param tokenToBeRecovered address of the token to be recovered.
661      * @param amount allowance.
662      */
663     function _setAllowedBalance(address tokenToBeRecovered, uint256 amount) internal virtual {
664         _allowedBalances[tokenToBeRecovered] = amount;
665         emit AllowedTokenBalance(tokenToBeRecovered, amount);
666     }
667 }
668 
669 
670 // File contracts/6/engine/SwapEngine.sol
671 
672 /**
673  * @title Token upgrade swap engine
674  * @author Validity Labs AG <info@validitylabs.org>
675  */
676 
677 
678 pragma solidity ^0.6.0;
679 
680 
681 
682 
683 
684 
685 
686 
687 contract SwapEngine is Context, Ownable, Reclaimable {
688     using SafeERC20 for IERC20;
689     using SafeMath for uint256;
690 
691     IERC20 public oldToken;
692     IERC20Mintable public newToken;
693     uint256 public constant conversionRate = 10000000000; // 1 to 1 from 8 decimals to 18 decimals.
694     uint256 public totalConverted;
695     mapping(address=>uint256) public convertedBalanceOf;
696 
697     /**
698      * @dev Emitted when old tokens are swaapped for new ones.
699      */
700     event TokenSwapped(address indexed holder, address indexed caller, uint256 oldTokenAmount);
701 
702     /**
703      * @dev Create a token swap engine providing an ERC20 token and a new one.
704      * @notice The difference in decimal between the old one and the new one is 10.
705      * @param _newOwner address of the swap engine contract owner
706      * @param _oldToken address of the old token contract
707      * @param _newToken address of the new token contract
708      */
709     constructor(address _newOwner, address _oldToken, address _newToken) public {
710         transferOwnership(_newOwner);
711         oldToken = IERC20(_oldToken);
712         newToken = IERC20Mintable(_newToken);
713     }
714 
715     /**
716      * @dev Swap all the tokens of the given token holders in a batch.
717      * @notice This function is restricted for the engine owner. If a non=token holder
718      * It does not revert when balance is zero, so that the rest can proceed.
719      * @param tokenHolders array of wallet addresses of token holders
720     */
721     function swapAllTokenInBatch(address[] calldata tokenHolders) public onlyOwner {
722         for (uint256 i = 0; i < tokenHolders.length; i++) {
723             uint256 balance = oldToken.balanceOf(tokenHolders[i]);
724             _swap(tokenHolders[i], balance);
725         }
726     }
727 
728     /**
729      * @dev Swap all the tokens of a given token holder.
730      * @notice This function is restricted for the engine owner or by tokenholders for themselves.
731      * It reverts when balance is zero. No need to proceed with the swap.
732      * @param tokenHolder wallet addresse of the token holder
733     */
734     function swapAllToken(address tokenHolder) public {
735         require(owner() == _msgSender() || tokenHolder == _msgSender(), "Either the owner or a tokenholder can swapAllToken");
736         uint256 balance = oldToken.balanceOf(tokenHolder);
737         require(balance > 0, "No token to swap");
738         _swap(tokenHolder, balance);
739     }
740 
741     /**
742      * @dev Swap some tokens of the caller
743      * @notice This function can be called by any account, even account without old token.
744      * It reverts when balance is zero. No need to proceed with the swap.
745      * @param amount amount of old token to be swapped into new ones.
746     */
747     function swapToken(uint256 amount) public {
748         uint256 balance = oldToken.balanceOf(_msgSender());
749         require(balance > 0, "No token to swap");
750         require(amount <= balance, "Swap amount is bigger than the balance");
751         _swap(_msgSender(), amount);
752     }
753 
754     /**
755      * @dev Swap some old tokens owned by a wallet.
756      * @notice core logic for token swap.
757      * @param tokenHolder wallet addresse of the token holder
758      * @param amount amount of old token to be swapped into new ones.
759     */
760     function _swap(address tokenHolder, uint256 amount) internal {
761         if (amount == 0) {
762             return;
763         }
764 
765         uint256 allowance = oldToken.allowance(tokenHolder, address(this));
766         require(amount <= allowance, "Swap amount is bigger than the allowance");
767         convertedBalanceOf[tokenHolder] = convertedBalanceOf[tokenHolder].add(amount);
768         totalConverted = totalConverted.add(amount);
769         increaseAllowedBalance(address(oldToken), amount);
770         uint256 newTokenToMint = amount.mul(conversionRate);
771         // transfer old token to the contract.
772         oldToken.safeTransferFrom(tokenHolder, address(this), amount);
773         // mint new token to the holder
774         newToken.mint(tokenHolder, newTokenToMint);
775         emit TokenSwapped(tokenHolder, _msgSender(), amount);
776     }
777 
778     /**
779      * @dev OVERRIDE method to forbid the possibility of renouncing ownership
780      */
781     function renounceOwnership() public override(Ownable) {
782         revert("There must be an owner");
783     }
784 }
785 
786 
787 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.1.0
788 
789 
790 
791 pragma solidity ^0.6.0;
792 
793 /**
794  * @dev Library for managing
795  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
796  * types.
797  *
798  * Sets have the following properties:
799  *
800  * - Elements are added, removed, and checked for existence in constant time
801  * (O(1)).
802  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
803  *
804  * ```
805  * contract Example {
806  *     // Add the library methods
807  *     using EnumerableSet for EnumerableSet.AddressSet;
808  *
809  *     // Declare a set state variable
810  *     EnumerableSet.AddressSet private mySet;
811  * }
812  * ```
813  *
814  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
815  * (`UintSet`) are supported.
816  */
817 library EnumerableSet {
818     // To implement this library for multiple types with as little code
819     // repetition as possible, we write it in terms of a generic Set type with
820     // bytes32 values.
821     // The Set implementation uses private functions, and user-facing
822     // implementations (such as AddressSet) are just wrappers around the
823     // underlying Set.
824     // This means that we can only create new EnumerableSets for types that fit
825     // in bytes32.
826 
827     struct Set {
828         // Storage of set values
829         bytes32[] _values;
830 
831         // Position of the value in the `values` array, plus 1 because index 0
832         // means a value is not in the set.
833         mapping (bytes32 => uint256) _indexes;
834     }
835 
836     /**
837      * @dev Add a value to a set. O(1).
838      *
839      * Returns true if the value was added to the set, that is if it was not
840      * already present.
841      */
842     function _add(Set storage set, bytes32 value) private returns (bool) {
843         if (!_contains(set, value)) {
844             set._values.push(value);
845             // The value is stored at length-1, but we add 1 to all indexes
846             // and use 0 as a sentinel value
847             set._indexes[value] = set._values.length;
848             return true;
849         } else {
850             return false;
851         }
852     }
853 
854     /**
855      * @dev Removes a value from a set. O(1).
856      *
857      * Returns true if the value was removed from the set, that is if it was
858      * present.
859      */
860     function _remove(Set storage set, bytes32 value) private returns (bool) {
861         // We read and store the value's index to prevent multiple reads from the same storage slot
862         uint256 valueIndex = set._indexes[value];
863 
864         if (valueIndex != 0) { // Equivalent to contains(set, value)
865             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
866             // the array, and then remove the last element (sometimes called as 'swap and pop').
867             // This modifies the order of the array, as noted in {at}.
868 
869             uint256 toDeleteIndex = valueIndex - 1;
870             uint256 lastIndex = set._values.length - 1;
871 
872             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
873             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
874 
875             bytes32 lastvalue = set._values[lastIndex];
876 
877             // Move the last value to the index where the value to delete is
878             set._values[toDeleteIndex] = lastvalue;
879             // Update the index for the moved value
880             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
881 
882             // Delete the slot where the moved value was stored
883             set._values.pop();
884 
885             // Delete the index for the deleted slot
886             delete set._indexes[value];
887 
888             return true;
889         } else {
890             return false;
891         }
892     }
893 
894     /**
895      * @dev Returns true if the value is in the set. O(1).
896      */
897     function _contains(Set storage set, bytes32 value) private view returns (bool) {
898         return set._indexes[value] != 0;
899     }
900 
901     /**
902      * @dev Returns the number of values on the set. O(1).
903      */
904     function _length(Set storage set) private view returns (uint256) {
905         return set._values.length;
906     }
907 
908    /**
909     * @dev Returns the value stored at position `index` in the set. O(1).
910     *
911     * Note that there are no guarantees on the ordering of values inside the
912     * array, and it may change when more values are added or removed.
913     *
914     * Requirements:
915     *
916     * - `index` must be strictly less than {length}.
917     */
918     function _at(Set storage set, uint256 index) private view returns (bytes32) {
919         require(set._values.length > index, "EnumerableSet: index out of bounds");
920         return set._values[index];
921     }
922 
923     // AddressSet
924 
925     struct AddressSet {
926         Set _inner;
927     }
928 
929     /**
930      * @dev Add a value to a set. O(1).
931      *
932      * Returns true if the value was added to the set, that is if it was not
933      * already present.
934      */
935     function add(AddressSet storage set, address value) internal returns (bool) {
936         return _add(set._inner, bytes32(uint256(value)));
937     }
938 
939     /**
940      * @dev Removes a value from a set. O(1).
941      *
942      * Returns true if the value was removed from the set, that is if it was
943      * present.
944      */
945     function remove(AddressSet storage set, address value) internal returns (bool) {
946         return _remove(set._inner, bytes32(uint256(value)));
947     }
948 
949     /**
950      * @dev Returns true if the value is in the set. O(1).
951      */
952     function contains(AddressSet storage set, address value) internal view returns (bool) {
953         return _contains(set._inner, bytes32(uint256(value)));
954     }
955 
956     /**
957      * @dev Returns the number of values in the set. O(1).
958      */
959     function length(AddressSet storage set) internal view returns (uint256) {
960         return _length(set._inner);
961     }
962 
963    /**
964     * @dev Returns the value stored at position `index` in the set. O(1).
965     *
966     * Note that there are no guarantees on the ordering of values inside the
967     * array, and it may change when more values are added or removed.
968     *
969     * Requirements:
970     *
971     * - `index` must be strictly less than {length}.
972     */
973     function at(AddressSet storage set, uint256 index) internal view returns (address) {
974         return address(uint256(_at(set._inner, index)));
975     }
976 
977 
978     // UintSet
979 
980     struct UintSet {
981         Set _inner;
982     }
983 
984     /**
985      * @dev Add a value to a set. O(1).
986      *
987      * Returns true if the value was added to the set, that is if it was not
988      * already present.
989      */
990     function add(UintSet storage set, uint256 value) internal returns (bool) {
991         return _add(set._inner, bytes32(value));
992     }
993 
994     /**
995      * @dev Removes a value from a set. O(1).
996      *
997      * Returns true if the value was removed from the set, that is if it was
998      * present.
999      */
1000     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1001         return _remove(set._inner, bytes32(value));
1002     }
1003 
1004     /**
1005      * @dev Returns true if the value is in the set. O(1).
1006      */
1007     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1008         return _contains(set._inner, bytes32(value));
1009     }
1010 
1011     /**
1012      * @dev Returns the number of values on the set. O(1).
1013      */
1014     function length(UintSet storage set) internal view returns (uint256) {
1015         return _length(set._inner);
1016     }
1017 
1018    /**
1019     * @dev Returns the value stored at position `index` in the set. O(1).
1020     *
1021     * Note that there are no guarantees on the ordering of values inside the
1022     * array, and it may change when more values are added or removed.
1023     *
1024     * Requirements:
1025     *
1026     * - `index` must be strictly less than {length}.
1027     */
1028     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1029         return uint256(_at(set._inner, index));
1030     }
1031 }
1032 
1033 
1034 // File @openzeppelin/contracts/access/AccessControl.sol@v3.1.0
1035 
1036 
1037 
1038 pragma solidity ^0.6.0;
1039 
1040 
1041 
1042 
1043 /**
1044  * @dev Contract module that allows children to implement role-based access
1045  * control mechanisms.
1046  *
1047  * Roles are referred to by their `bytes32` identifier. These should be exposed
1048  * in the external API and be unique. The best way to achieve this is by
1049  * using `public constant` hash digests:
1050  *
1051  * ```
1052  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1053  * ```
1054  *
1055  * Roles can be used to represent a set of permissions. To restrict access to a
1056  * function call, use {hasRole}:
1057  *
1058  * ```
1059  * function foo() public {
1060  *     require(hasRole(MY_ROLE, msg.sender));
1061  *     ...
1062  * }
1063  * ```
1064  *
1065  * Roles can be granted and revoked dynamically via the {grantRole} and
1066  * {revokeRole} functions. Each role has an associated admin role, and only
1067  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1068  *
1069  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1070  * that only accounts with this role will be able to grant or revoke other
1071  * roles. More complex role relationships can be created by using
1072  * {_setRoleAdmin}.
1073  *
1074  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1075  * grant and revoke this role. Extra precautions should be taken to secure
1076  * accounts that have been granted it.
1077  */
1078 abstract contract AccessControl is Context {
1079     using EnumerableSet for EnumerableSet.AddressSet;
1080     using Address for address;
1081 
1082     struct RoleData {
1083         EnumerableSet.AddressSet members;
1084         bytes32 adminRole;
1085     }
1086 
1087     mapping (bytes32 => RoleData) private _roles;
1088 
1089     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1090 
1091     /**
1092      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1093      *
1094      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1095      * {RoleAdminChanged} not being emitted signaling this.
1096      *
1097      * _Available since v3.1._
1098      */
1099     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1100 
1101     /**
1102      * @dev Emitted when `account` is granted `role`.
1103      *
1104      * `sender` is the account that originated the contract call, an admin role
1105      * bearer except when using {_setupRole}.
1106      */
1107     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1108 
1109     /**
1110      * @dev Emitted when `account` is revoked `role`.
1111      *
1112      * `sender` is the account that originated the contract call:
1113      *   - if using `revokeRole`, it is the admin role bearer
1114      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1115      */
1116     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1117 
1118     /**
1119      * @dev Returns `true` if `account` has been granted `role`.
1120      */
1121     function hasRole(bytes32 role, address account) public view returns (bool) {
1122         return _roles[role].members.contains(account);
1123     }
1124 
1125     /**
1126      * @dev Returns the number of accounts that have `role`. Can be used
1127      * together with {getRoleMember} to enumerate all bearers of a role.
1128      */
1129     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1130         return _roles[role].members.length();
1131     }
1132 
1133     /**
1134      * @dev Returns one of the accounts that have `role`. `index` must be a
1135      * value between 0 and {getRoleMemberCount}, non-inclusive.
1136      *
1137      * Role bearers are not sorted in any particular way, and their ordering may
1138      * change at any point.
1139      *
1140      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1141      * you perform all queries on the same block. See the following
1142      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1143      * for more information.
1144      */
1145     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1146         return _roles[role].members.at(index);
1147     }
1148 
1149     /**
1150      * @dev Returns the admin role that controls `role`. See {grantRole} and
1151      * {revokeRole}.
1152      *
1153      * To change a role's admin, use {_setRoleAdmin}.
1154      */
1155     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1156         return _roles[role].adminRole;
1157     }
1158 
1159     /**
1160      * @dev Grants `role` to `account`.
1161      *
1162      * If `account` had not been already granted `role`, emits a {RoleGranted}
1163      * event.
1164      *
1165      * Requirements:
1166      *
1167      * - the caller must have ``role``'s admin role.
1168      */
1169     function grantRole(bytes32 role, address account) public virtual {
1170         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1171 
1172         _grantRole(role, account);
1173     }
1174 
1175     /**
1176      * @dev Revokes `role` from `account`.
1177      *
1178      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1179      *
1180      * Requirements:
1181      *
1182      * - the caller must have ``role``'s admin role.
1183      */
1184     function revokeRole(bytes32 role, address account) public virtual {
1185         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1186 
1187         _revokeRole(role, account);
1188     }
1189 
1190     /**
1191      * @dev Revokes `role` from the calling account.
1192      *
1193      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1194      * purpose is to provide a mechanism for accounts to lose their privileges
1195      * if they are compromised (such as when a trusted device is misplaced).
1196      *
1197      * If the calling account had been granted `role`, emits a {RoleRevoked}
1198      * event.
1199      *
1200      * Requirements:
1201      *
1202      * - the caller must be `account`.
1203      */
1204     function renounceRole(bytes32 role, address account) public virtual {
1205         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1206 
1207         _revokeRole(role, account);
1208     }
1209 
1210     /**
1211      * @dev Grants `role` to `account`.
1212      *
1213      * If `account` had not been already granted `role`, emits a {RoleGranted}
1214      * event. Note that unlike {grantRole}, this function doesn't perform any
1215      * checks on the calling account.
1216      *
1217      * [WARNING]
1218      * ====
1219      * This function should only be called from the constructor when setting
1220      * up the initial roles for the system.
1221      *
1222      * Using this function in any other way is effectively circumventing the admin
1223      * system imposed by {AccessControl}.
1224      * ====
1225      */
1226     function _setupRole(bytes32 role, address account) internal virtual {
1227         _grantRole(role, account);
1228     }
1229 
1230     /**
1231      * @dev Sets `adminRole` as ``role``'s admin role.
1232      *
1233      * Emits a {RoleAdminChanged} event.
1234      */
1235     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1236         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1237         _roles[role].adminRole = adminRole;
1238     }
1239 
1240     function _grantRole(bytes32 role, address account) private {
1241         if (_roles[role].members.add(account)) {
1242             emit RoleGranted(role, account, _msgSender());
1243         }
1244     }
1245 
1246     function _revokeRole(bytes32 role, address account) private {
1247         if (_roles[role].members.remove(account)) {
1248             emit RoleRevoked(role, account, _msgSender());
1249         }
1250     }
1251 }
1252 
1253 
1254 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.1.0
1255 
1256 
1257 
1258 pragma solidity ^0.6.0;
1259 
1260 
1261 
1262 
1263 
1264 /**
1265  * @dev Implementation of the {IERC20} interface.
1266  *
1267  * This implementation is agnostic to the way tokens are created. This means
1268  * that a supply mechanism has to be added in a derived contract using {_mint}.
1269  * For a generic mechanism see {ERC20PresetMinterPauser}.
1270  *
1271  * TIP: For a detailed writeup see our guide
1272  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1273  * to implement supply mechanisms].
1274  *
1275  * We have followed general OpenZeppelin guidelines: functions revert instead
1276  * of returning `false` on failure. This behavior is nonetheless conventional
1277  * and does not conflict with the expectations of ERC20 applications.
1278  *
1279  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1280  * This allows applications to reconstruct the allowance for all accounts just
1281  * by listening to said events. Other implementations of the EIP may not emit
1282  * these events, as it isn't required by the specification.
1283  *
1284  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1285  * functions have been added to mitigate the well-known issues around setting
1286  * allowances. See {IERC20-approve}.
1287  */
1288 contract ERC20 is Context, IERC20 {
1289     using SafeMath for uint256;
1290     using Address for address;
1291 
1292     mapping (address => uint256) private _balances;
1293 
1294     mapping (address => mapping (address => uint256)) private _allowances;
1295 
1296     uint256 private _totalSupply;
1297 
1298     string private _name;
1299     string private _symbol;
1300     uint8 private _decimals;
1301 
1302     /**
1303      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1304      * a default value of 18.
1305      *
1306      * To select a different value for {decimals}, use {_setupDecimals}.
1307      *
1308      * All three of these values are immutable: they can only be set once during
1309      * construction.
1310      */
1311     constructor (string memory name, string memory symbol) public {
1312         _name = name;
1313         _symbol = symbol;
1314         _decimals = 18;
1315     }
1316 
1317     /**
1318      * @dev Returns the name of the token.
1319      */
1320     function name() public view returns (string memory) {
1321         return _name;
1322     }
1323 
1324     /**
1325      * @dev Returns the symbol of the token, usually a shorter version of the
1326      * name.
1327      */
1328     function symbol() public view returns (string memory) {
1329         return _symbol;
1330     }
1331 
1332     /**
1333      * @dev Returns the number of decimals used to get its user representation.
1334      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1335      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1336      *
1337      * Tokens usually opt for a value of 18, imitating the relationship between
1338      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1339      * called.
1340      *
1341      * NOTE: This information is only used for _display_ purposes: it in
1342      * no way affects any of the arithmetic of the contract, including
1343      * {IERC20-balanceOf} and {IERC20-transfer}.
1344      */
1345     function decimals() public view returns (uint8) {
1346         return _decimals;
1347     }
1348 
1349     /**
1350      * @dev See {IERC20-totalSupply}.
1351      */
1352     function totalSupply() public view override returns (uint256) {
1353         return _totalSupply;
1354     }
1355 
1356     /**
1357      * @dev See {IERC20-balanceOf}.
1358      */
1359     function balanceOf(address account) public view override returns (uint256) {
1360         return _balances[account];
1361     }
1362 
1363     /**
1364      * @dev See {IERC20-transfer}.
1365      *
1366      * Requirements:
1367      *
1368      * - `recipient` cannot be the zero address.
1369      * - the caller must have a balance of at least `amount`.
1370      */
1371     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1372         _transfer(_msgSender(), recipient, amount);
1373         return true;
1374     }
1375 
1376     /**
1377      * @dev See {IERC20-allowance}.
1378      */
1379     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1380         return _allowances[owner][spender];
1381     }
1382 
1383     /**
1384      * @dev See {IERC20-approve}.
1385      *
1386      * Requirements:
1387      *
1388      * - `spender` cannot be the zero address.
1389      */
1390     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1391         _approve(_msgSender(), spender, amount);
1392         return true;
1393     }
1394 
1395     /**
1396      * @dev See {IERC20-transferFrom}.
1397      *
1398      * Emits an {Approval} event indicating the updated allowance. This is not
1399      * required by the EIP. See the note at the beginning of {ERC20};
1400      *
1401      * Requirements:
1402      * - `sender` and `recipient` cannot be the zero address.
1403      * - `sender` must have a balance of at least `amount`.
1404      * - the caller must have allowance for ``sender``'s tokens of at least
1405      * `amount`.
1406      */
1407     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1408         _transfer(sender, recipient, amount);
1409         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1410         return true;
1411     }
1412 
1413     /**
1414      * @dev Atomically increases the allowance granted to `spender` by the caller.
1415      *
1416      * This is an alternative to {approve} that can be used as a mitigation for
1417      * problems described in {IERC20-approve}.
1418      *
1419      * Emits an {Approval} event indicating the updated allowance.
1420      *
1421      * Requirements:
1422      *
1423      * - `spender` cannot be the zero address.
1424      */
1425     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1426         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1427         return true;
1428     }
1429 
1430     /**
1431      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1432      *
1433      * This is an alternative to {approve} that can be used as a mitigation for
1434      * problems described in {IERC20-approve}.
1435      *
1436      * Emits an {Approval} event indicating the updated allowance.
1437      *
1438      * Requirements:
1439      *
1440      * - `spender` cannot be the zero address.
1441      * - `spender` must have allowance for the caller of at least
1442      * `subtractedValue`.
1443      */
1444     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1446         return true;
1447     }
1448 
1449     /**
1450      * @dev Moves tokens `amount` from `sender` to `recipient`.
1451      *
1452      * This is internal function is equivalent to {transfer}, and can be used to
1453      * e.g. implement automatic token fees, slashing mechanisms, etc.
1454      *
1455      * Emits a {Transfer} event.
1456      *
1457      * Requirements:
1458      *
1459      * - `sender` cannot be the zero address.
1460      * - `recipient` cannot be the zero address.
1461      * - `sender` must have a balance of at least `amount`.
1462      */
1463     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1464         require(sender != address(0), "ERC20: transfer from the zero address");
1465         require(recipient != address(0), "ERC20: transfer to the zero address");
1466 
1467         _beforeTokenTransfer(sender, recipient, amount);
1468 
1469         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1470         _balances[recipient] = _balances[recipient].add(amount);
1471         emit Transfer(sender, recipient, amount);
1472     }
1473 
1474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1475      * the total supply.
1476      *
1477      * Emits a {Transfer} event with `from` set to the zero address.
1478      *
1479      * Requirements
1480      *
1481      * - `to` cannot be the zero address.
1482      */
1483     function _mint(address account, uint256 amount) internal virtual {
1484         require(account != address(0), "ERC20: mint to the zero address");
1485 
1486         _beforeTokenTransfer(address(0), account, amount);
1487 
1488         _totalSupply = _totalSupply.add(amount);
1489         _balances[account] = _balances[account].add(amount);
1490         emit Transfer(address(0), account, amount);
1491     }
1492 
1493     /**
1494      * @dev Destroys `amount` tokens from `account`, reducing the
1495      * total supply.
1496      *
1497      * Emits a {Transfer} event with `to` set to the zero address.
1498      *
1499      * Requirements
1500      *
1501      * - `account` cannot be the zero address.
1502      * - `account` must have at least `amount` tokens.
1503      */
1504     function _burn(address account, uint256 amount) internal virtual {
1505         require(account != address(0), "ERC20: burn from the zero address");
1506 
1507         _beforeTokenTransfer(account, address(0), amount);
1508 
1509         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1510         _totalSupply = _totalSupply.sub(amount);
1511         emit Transfer(account, address(0), amount);
1512     }
1513 
1514     /**
1515      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1516      *
1517      * This is internal function is equivalent to `approve`, and can be used to
1518      * e.g. set automatic allowances for certain subsystems, etc.
1519      *
1520      * Emits an {Approval} event.
1521      *
1522      * Requirements:
1523      *
1524      * - `owner` cannot be the zero address.
1525      * - `spender` cannot be the zero address.
1526      */
1527     function _approve(address owner, address spender, uint256 amount) internal virtual {
1528         require(owner != address(0), "ERC20: approve from the zero address");
1529         require(spender != address(0), "ERC20: approve to the zero address");
1530 
1531         _allowances[owner][spender] = amount;
1532         emit Approval(owner, spender, amount);
1533     }
1534 
1535     /**
1536      * @dev Sets {decimals} to a value other than the default one of 18.
1537      *
1538      * WARNING: This function should only be called from the constructor. Most
1539      * applications that interact with token contracts will not expect
1540      * {decimals} to ever change, and may work incorrectly if it does.
1541      */
1542     function _setupDecimals(uint8 decimals_) internal {
1543         _decimals = decimals_;
1544     }
1545 
1546     /**
1547      * @dev Hook that is called before any transfer of tokens. This includes
1548      * minting and burning.
1549      *
1550      * Calling conditions:
1551      *
1552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1553      * will be to transferred to `to`.
1554      * - when `from` is zero, `amount` tokens will be minted for `to`.
1555      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1556      * - `from` and `to` are never both zero.
1557      *
1558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1559      */
1560     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1561 }
1562 
1563 
1564 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.1.0
1565 
1566 
1567 
1568 pragma solidity ^0.6.0;
1569 
1570 
1571 
1572 /**
1573  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1574  * tokens and those that they have an allowance for, in a way that can be
1575  * recognized off-chain (via event analysis).
1576  */
1577 abstract contract ERC20Burnable is Context, ERC20 {
1578     /**
1579      * @dev Destroys `amount` tokens from the caller.
1580      *
1581      * See {ERC20-_burn}.
1582      */
1583     function burn(uint256 amount) public virtual {
1584         _burn(_msgSender(), amount);
1585     }
1586 
1587     /**
1588      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1589      * allowance.
1590      *
1591      * See {ERC20-_burn} and {ERC20-allowance}.
1592      *
1593      * Requirements:
1594      *
1595      * - the caller must have allowance for ``accounts``'s tokens of at least
1596      * `amount`.
1597      */
1598     function burnFrom(address account, uint256 amount) public virtual {
1599         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1600 
1601         _approve(account, _msgSender(), decreasedAllowance);
1602         _burn(account, amount);
1603     }
1604 }
1605 
1606 
1607 // File @openzeppelin/contracts/token/ERC20/ERC20Capped.sol@v3.1.0
1608 
1609 
1610 
1611 pragma solidity ^0.6.0;
1612 
1613 
1614 /**
1615  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1616  */
1617 abstract contract ERC20Capped is ERC20 {
1618     uint256 private _cap;
1619 
1620     /**
1621      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1622      * set once during construction.
1623      */
1624     constructor (uint256 cap) public {
1625         require(cap > 0, "ERC20Capped: cap is 0");
1626         _cap = cap;
1627     }
1628 
1629     /**
1630      * @dev Returns the cap on the token's total supply.
1631      */
1632     function cap() public view returns (uint256) {
1633         return _cap;
1634     }
1635 
1636     /**
1637      * @dev See {ERC20-_beforeTokenTransfer}.
1638      *
1639      * Requirements:
1640      *
1641      * - minted tokens must not cause the total supply to go over the cap.
1642      */
1643     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1644         super._beforeTokenTransfer(from, to, amount);
1645 
1646         if (from == address(0)) { // When minting tokens
1647             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1648         }
1649     }
1650 }
1651 
1652 
1653 // File contracts/6/v2/StonToken.sol
1654 
1655 /**
1656  * @title New STON token
1657  * @author Validity Labs AG <info@validitylabs.org>
1658  */
1659 
1660 
1661 pragma solidity ^0.6.0;
1662 
1663 
1664 
1665 
1666 
1667 
1668 contract StonToken is
1669     Ownable,
1670     Reclaimable,
1671     AccessControl,
1672     ERC20Burnable,
1673     ERC20Capped
1674 {
1675     bytes32 public constant WHITELIST_MANAGER_ROLE = keccak256(
1676         "WHITELIST_MANAGER_ROLE"
1677     );
1678     bytes32 public constant WHITELISTED_ROLE = keccak256("WHITELISTED_ROLE");
1679     address public upgradeEngine;
1680     bool public upgradeStarted;
1681 
1682     /**
1683      * @dev Emitted when the upgrade token swap engine is conected or disconnected to the token contract.
1684      * @param engineConnected the status of the upgrade engine when the connection status changes
1685      * @param upgradeEngine address of the engine contract.
1686      */
1687     event SwapEngineConnected(bool indexed engineConnected, address indexed upgradeEngine);
1688 
1689     /**
1690      * @dev Set a new owner and let it become the default admin and whiteliste manager.
1691      * @notice Capped at 370 million tokens. Set the role relation between WHITELISTED and WHITELIST_MANAGER
1692      * @param newOwner address of the token contract owner
1693      */
1694     constructor(address newOwner)
1695         public
1696         ERC20("STON", "STON")
1697         ERC20Capped(370000000 ether)
1698     {
1699         _setRoleAdmin(WHITELISTED_ROLE, WHITELIST_MANAGER_ROLE);
1700 
1701         transferOwnership(newOwner);
1702         emit SwapEngineConnected(false, upgradeEngine);
1703     }
1704 
1705     /**
1706      * @dev Connect the upgrade token swap engine so that this new Ston token can be minted for old Ston token holders.
1707      * @notice Only owner can set the engineAddress. This action is one-time only.
1708      * @param engineAddress address of the token upgrade token swap engine contract.
1709      */
1710     function connectUpgradeEngine(address engineAddress) public onlyOwner {
1711         require(
1712             !upgradeStarted,
1713             "Upgrade has started. Cannot set the engine address again!"
1714         );
1715         upgradeEngine = engineAddress;
1716         upgradeStarted = true;
1717         emit SwapEngineConnected(upgradeStarted, upgradeEngine);
1718     }
1719 
1720     /**
1721      * @dev Disconnect the upgrade token swap engine and mint the remaining Ston tokens to the liquidity pool.
1722      * @notice Only owner can disconnect the engine. This action is one-time only.
1723      * @param poolAddress address to receive the remaining token.
1724      */
1725     function removeUpgradeEngine(address poolAddress) public onlyOwner {
1726         require(
1727             upgradeStarted,
1728             "Upgrade has not started yet. Cannot reset the engine address!"
1729         );
1730         require(
1731             upgradeEngine != address(0),
1732             "Upgrade has already been reset!"
1733         );
1734         // mint the remaining tokens to the pool
1735         _mint(poolAddress, cap().sub(totalSupply()));
1736         // leave the minter to address zero.
1737         upgradeEngine = address(0);
1738         emit SwapEngineConnected(false, upgradeEngine);
1739     }
1740 
1741     /**
1742      * @dev Add a list of accounts to the whitelist
1743      * @notice This whitelist is not used to control token transfer. It is reserved for tracking the eligibility of voting.
1744      * @param accounts An array of accounts to tbe whitelisted
1745      */
1746     function addAccountsToWhitelist(address[] calldata accounts) public {
1747         require(hasRole(getRoleAdmin(WHITELISTED_ROLE), _msgSender()), "AccessControl: sender must be an admin to grant");
1748 
1749         for (uint256 i = 0; i < accounts.length; i++) {
1750             _setupRole(WHITELISTED_ROLE, accounts[i]);
1751         }
1752     }
1753 
1754     /**
1755      * @dev OVERRIDE Mint tokens, with a defined cap of 370 million tokens.
1756      * @notice It should only be done by the upgrade token swap engine or upon disconnecting of the said engine.
1757      * @param to recipient address.
1758      * @param amount amount of token to be transferred.
1759      */
1760     function mint(address to, uint256 amount) public {
1761         require(
1762             upgradeStarted && upgradeEngine == _msgSender(),
1763             "STON can only be minted by the upgrade swap engine."
1764         );
1765         _mint(to, amount);
1766     }
1767 
1768     /**
1769      * @dev OVERRIDE Burn tokens. It can only be called by the token owner.
1770      * @param amount amount of token to be burnt.
1771      */
1772     function burn(uint256 amount) public override(ERC20Burnable) onlyOwner {
1773         super.burn(amount);
1774     }
1775 
1776     /**
1777      * @dev OVERRIDE Burn tokens from an account. It can only be called by the token owner.
1778      * @notice A suffient allowance is needed.
1779      * @param account address of the token holder.
1780      * @param amount amount of token to be burnt.
1781      */
1782     function burnFrom(address account, uint256 amount)
1783         public
1784         override(ERC20Burnable)
1785         onlyOwner
1786     {
1787         super.burnFrom(account, amount);
1788     }
1789 
1790     /**
1791      * @dev OVERRIDE method to forbid the possibility of renouncing ownership
1792      */
1793     function renounceOwnership() public override(Ownable) {
1794         revert("There must be an owner");
1795     }
1796 
1797     /**
1798      * @dev OVERRIDE transfer the ownership of this token
1799      * @notice whitelist manager role and default admin (manages whitelist managers) are transfered at the same time.
1800      * @param newOwner address of the new owner.
1801      */
1802     function transferOwnership(address newOwner) public override(Ownable) {
1803         super.renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
1804         _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
1805         _setupRole(WHITELIST_MANAGER_ROLE, newOwner);
1806         //if (newOwner != _msgSender()) {
1807             
1808         //}
1809         super.transferOwnership(newOwner);
1810     }
1811 
1812     /**
1813      * @dev OVERRIDE renounce a role
1814      * @notice The default admin (manages whitelist managers) cannot be renounced.
1815      * @param role role to be renounced.
1816      * @param account address that is about to renounce its role.
1817      */
1818     function renounceRole(bytes32 role, address account) public override(AccessControl) {
1819         require(role != DEFAULT_ADMIN_ROLE, "Cannot renounce the admin role");
1820         super.renounceRole(role, account);
1821     }
1822 
1823     /**
1824      * @dev OVERRIDE checker before token transfer
1825      * @notice Inherit ERC20Capped
1826      * @param from token sender address
1827      * @param to token recipient address
1828      * @param amount amount of tokens to be transferred.
1829      */
1830     function _beforeTokenTransfer(
1831         address from,
1832         address to,
1833         uint256 amount
1834     ) internal virtual override(ERC20, ERC20Capped) {
1835         super._beforeTokenTransfer(from, to, amount);
1836     }
1837 }