1 // File: @openzeppelin\contracts\math\SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
33         require(c >= a, "SafeMath: addition overflow");
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
49         return sub(a, b, "SafeMath: subtraction overflow");
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
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin\contracts\utils\Address.sol
164 
165 
166 pragma solidity ^0.6.2;
167 
168 /**
169  * @dev Collection of functions related to the address type
170  */
171 library Address {
172     /**
173      * @dev Returns true if `account` is a contract.
174      *
175      * [IMPORTANT]
176      * ====
177      * It is unsafe to assume that an address for which this function returns
178      * false is an externally-owned account (EOA) and not a contract.
179      *
180      * Among others, `isContract` will return false for the following
181      * types of addresses:
182      *
183      *  - an externally-owned account
184      *  - a contract in construction
185      *  - an address where a contract will be created
186      *  - an address where a contract lived, but was destroyed
187      * ====
188      */
189     function isContract(address account) internal view returns (bool) {
190         // This method relies in extcodesize, which returns 0 for contracts in
191         // construction, since the code is only stored at the end of the
192         // constructor execution.
193 
194         uint256 size;
195         // solhint-disable-next-line no-inline-assembly
196         assembly { size := extcodesize(account) }
197         return size > 0;
198     }
199 
200     /**
201      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
202      * `recipient`, forwarding all available gas and reverting on errors.
203      *
204      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
205      * of certain opcodes, possibly making contracts go over the 2300 gas limit
206      * imposed by `transfer`, making them unable to receive funds via
207      * `transfer`. {sendValue} removes this limitation.
208      *
209      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
210      *
211      * IMPORTANT: because control is transferred to `recipient`, care must be
212      * taken to not create reentrancy vulnerabilities. Consider using
213      * {ReentrancyGuard} or the
214      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
215      */
216     function sendValue(address payable recipient, uint256 amount) internal {
217         require(address(this).balance >= amount, "Address: insufficient balance");
218 
219         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
220         (bool success, ) = recipient.call{ value: amount }("");
221         require(success, "Address: unable to send value, recipient may have reverted");
222     }
223 
224     /**
225      * @dev Performs a Solidity function call using a low level `call`. A
226      * plain`call` is an unsafe replacement for a function call: use this
227      * function instead.
228      *
229      * If `target` reverts with a revert reason, it is bubbled up by this
230      * function (like regular Solidity function calls).
231      *
232      * Returns the raw returned data. To convert to the expected return value,
233      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
234      *
235      * Requirements:
236      *
237      * - `target` must be a contract.
238      * - calling `target` with `data` must not revert.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
243       return functionCall(target, data, "Address: low-level call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
248      * `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
253         return _functionCallWithValue(target, data, 0, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but also transferring `value` wei to `target`.
259      *
260      * Requirements:
261      *
262      * - the calling contract must have an ETH balance of at least `value`.
263      * - the called Solidity function must be `payable`.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
273      * with `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
278         require(address(this).balance >= value, "Address: insufficient balance for call");
279         return _functionCallWithValue(target, data, value, errorMessage);
280     }
281 
282     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
283         require(isContract(target), "Address: call to non-contract");
284 
285         // solhint-disable-next-line avoid-low-level-calls
286         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 // solhint-disable-next-line no-inline-assembly
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
307 
308 
309 pragma solidity ^0.6.0;
310 
311 /**
312  * @dev Interface of the ERC20 standard as defined in the EIP.
313  */
314 interface IERC20 {
315     /**
316      * @dev Returns the amount of tokens in existence.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns the amount of tokens owned by `account`.
322      */
323     function balanceOf(address account) external view returns (uint256);
324 
325     /**
326      * @dev Moves `amount` tokens from the caller's account to `recipient`.
327      *
328      * Returns a boolean value indicating whether the operation succeeded.
329      *
330      * Emits a {Transfer} event.
331      */
332     function transfer(address recipient, uint256 amount) external returns (bool);
333 
334     /**
335      * @dev Returns the remaining number of tokens that `spender` will be
336      * allowed to spend on behalf of `owner` through {transferFrom}. This is
337      * zero by default.
338      *
339      * This value changes when {approve} or {transferFrom} are called.
340      */
341     function allowance(address owner, address spender) external view returns (uint256);
342 
343     /**
344      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * IMPORTANT: Beware that changing an allowance with this method brings the risk
349      * that someone may use both the old and the new allowance by unfortunate
350      * transaction ordering. One possible solution to mitigate this race
351      * condition is to first reduce the spender's allowance to 0 and set the
352      * desired value afterwards:
353      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
354      *
355      * Emits an {Approval} event.
356      */
357     function approve(address spender, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Moves `amount` tokens from `sender` to `recipient` using the
361      * allowance mechanism. `amount` is then deducted from the caller's
362      * allowance.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
385 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
386 
387 
388 
389 
390 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
391 
392 
393 pragma solidity ^0.6.0;
394 
395 
396 
397 
398 /**
399  * @title SafeERC20
400  * @dev Wrappers around ERC20 operations that throw on failure (when the token
401  * contract returns false). Tokens that return no value (and instead revert or
402  * throw on failure) are also supported, non-reverting calls are assumed to be
403  * successful.
404  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
405  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
406  */
407 library SafeERC20 {
408     using SafeMath for uint256;
409     using Address for address;
410 
411     function safeTransfer(IERC20 token, address to, uint256 value) internal {
412         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
413     }
414 
415     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
417     }
418 
419     /**
420      * @dev Deprecated. This function has issues similar to the ones found in
421      * {IERC20-approve}, and its usage is discouraged.
422      *
423      * Whenever possible, use {safeIncreaseAllowance} and
424      * {safeDecreaseAllowance} instead.
425      */
426     function safeApprove(IERC20 token, address spender, uint256 value) internal {
427         // safeApprove should only be called when setting an initial allowance,
428         // or when resetting it to zero. To increase and decrease it, use
429         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
430         // solhint-disable-next-line max-line-length
431         require((value == 0) || (token.allowance(address(this), spender) == 0),
432             "SafeERC20: approve from non-zero to non-zero allowance"
433         );
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
435     }
436 
437     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).add(value);
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     /**
448      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
449      * on the return value: the return value is optional (but if data is returned, it must not be false).
450      * @param token The token targeted by the call.
451      * @param data The call data (encoded using abi.encode or one of its variants).
452      */
453     function _callOptionalReturn(IERC20 token, bytes memory data) private {
454         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
455         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
456         // the target address contains contract code and also asserts for success in the low-level call.
457 
458         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
459         if (returndata.length > 0) { // Return data is optional
460             // solhint-disable-next-line max-line-length
461             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
462         }
463     }
464 }
465 
466 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
467 
468 
469 pragma solidity ^0.6.0;
470 
471 /*
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with GSN meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address payable) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal view virtual returns (bytes memory) {
487         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
488         return msg.data;
489     }
490 }
491 
492 // File: @openzeppelin\contracts\access\Ownable.sol
493 
494 
495 pragma solidity ^0.6.0;
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor () internal {
518         address msgSender = _msgSender();
519         _owner = msgSender;
520         emit OwnershipTransferred(address(0), msgSender);
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(_owner == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     /**
551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
552      * Can only be called by the current owner.
553      */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         emit OwnershipTransferred(_owner, newOwner);
557         _owner = newOwner;
558     }
559 }
560 
561 // File: @openzeppelin\contracts\utils\Pausable.sol
562 
563 
564 pragma solidity ^0.6.0;
565 
566 
567 /**
568  * @dev Contract module which allows children to implement an emergency stop
569  * mechanism that can be triggered by an authorized account.
570  *
571  * This module is used through inheritance. It will make available the
572  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
573  * the functions of your contract. Note that they will not be pausable by
574  * simply including this module, only once the modifiers are put in place.
575  */
576 contract Pausable is Context {
577     /**
578      * @dev Emitted when the pause is triggered by `account`.
579      */
580     event Paused(address account);
581 
582     /**
583      * @dev Emitted when the pause is lifted by `account`.
584      */
585     event Unpaused(address account);
586 
587     bool private _paused;
588 
589     /**
590      * @dev Initializes the contract in unpaused state.
591      */
592     constructor () internal {
593         _paused = false;
594     }
595 
596     /**
597      * @dev Returns true if the contract is paused, and false otherwise.
598      */
599     function paused() public view returns (bool) {
600         return _paused;
601     }
602 
603     /**
604      * @dev Modifier to make a function callable only when the contract is not paused.
605      *
606      * Requirements:
607      *
608      * - The contract must not be paused.
609      */
610     modifier whenNotPaused() {
611         require(!_paused, "Pausable: paused");
612         _;
613     }
614 
615     /**
616      * @dev Modifier to make a function callable only when the contract is paused.
617      *
618      * Requirements:
619      *
620      * - The contract must be paused.
621      */
622     modifier whenPaused() {
623         require(_paused, "Pausable: not paused");
624         _;
625     }
626 
627     /**
628      * @dev Triggers stopped state.
629      *
630      * Requirements:
631      *
632      * - The contract must not be paused.
633      */
634     function _pause() internal virtual whenNotPaused {
635         _paused = true;
636         emit Paused(_msgSender());
637     }
638 
639     /**
640      * @dev Returns to normal state.
641      *
642      * Requirements:
643      *
644      * - The contract must be paused.
645      */
646     function _unpause() internal virtual whenPaused {
647         _paused = false;
648         emit Unpaused(_msgSender());
649     }
650 }
651 
652 // File: contracts\interfaces\ILPERC20.sol
653 
654 
655 pragma solidity 0.6.12;
656 
657 interface ILPERC20 {
658     function name() external view returns (string memory);
659 
660     function symbol() external view returns (string memory);
661 
662     function decimals() external view returns (uint8);
663 }
664 
665 
666 // File: contracts\interfaces\ISnpToken.sol
667 
668 pragma solidity 0.6.12;
669 
670 
671 /**
672  * @dev Interface of the Snp erc20 token.
673  */
674 
675 interface ISnpToken is IERC20 {
676     function mint(address account, uint256 amount) external returns (uint256);
677 
678     function burn(uint256 amount) external returns (bool);
679 
680     function increaseAllowance(address spender, uint256 addedValue)
681         external
682         returns (bool);
683 
684     function decreaseAllowance(address spender, uint256 subtractedValue)
685         external
686         returns (bool);
687 }
688 
689 // File: contracts\SnpToken.sol
690 
691 pragma solidity 0.6.12;
692 
693 
694 
695 
696 
697 
698 
699 contract SnpToken is ISnpToken, Ownable, Pausable {
700     using SafeMath for uint256;
701     using Address for address;
702     using SafeERC20 for IERC20;
703 
704     mapping(address => uint256) private _balances;
705 
706     mapping(address => mapping(address => uint256)) private _allowances;
707 
708     mapping(address => bool) public minters;
709 
710     uint256 private _totalSupply;
711 
712     string private _name = "SNP Token";
713     string private _symbol = "SNP";
714     uint8 private _decimals = 18;
715     uint256 public TOTAL_SUPPLY = 3000000 ether;
716 
717     constructor() public {
718         _totalSupply = 0;
719     }
720 
721     function name() external view returns (string memory) {
722         return _name;
723     }
724 
725     function symbol() external view returns (string memory) {
726         return _symbol;
727     }
728 
729     function decimals() external view returns (uint8) {
730         return _decimals;
731     }
732 
733     function totalSupply() public override view returns (uint256) {
734         return _totalSupply;
735     }
736 
737     function balanceOf(address account) public override view returns (uint256) {
738         return _balances[account];
739     }
740 
741     function addMinter(address _minter) external onlyOwner {
742         minters[_minter] = true;
743     }
744 
745     function removeMinter(address _minter) external onlyOwner {
746         minters[_minter] = false;
747     }
748 
749     function mint(address account, uint256 amount)
750         public
751         virtual
752         override
753         whenNotPaused
754         returns (uint256)
755     {
756         require(minters[msg.sender], "SnpToken: You are not the minter");
757         uint256 supply = _totalSupply.add(amount);
758         if (supply > TOTAL_SUPPLY) {
759             supply = TOTAL_SUPPLY;
760         }
761         amount = supply.sub(_totalSupply);
762         _mint(account, amount);
763         return amount;
764     }
765 
766     function transfer(address recipient, uint256 amount)
767         public
768         virtual
769         override
770         whenNotPaused
771         returns (bool)
772     {
773         _transfer(msg.sender, recipient, amount);
774         return true;
775     }
776 
777     function transferFrom(
778         address sender,
779         address recipient,
780         uint256 amount
781     ) public virtual override whenNotPaused returns (bool) {
782         _transfer(sender, recipient, amount);
783         _approve(
784             sender,
785             msg.sender,
786             _allowances[sender][msg.sender].sub(
787                 amount,
788                 "SnpToken: TRANSFER_AMOUNT_EXCEEDS_ALLOWANCE"
789             )
790         );
791         return true;
792     }
793 
794     function allowance(address owner, address spender)
795         public
796         virtual
797         override
798         view
799         returns (uint256)
800     {
801         return _allowances[owner][spender];
802     }
803 
804     function approve(address spender, uint256 amount)
805         public
806         virtual
807         override
808         whenNotPaused
809         returns (bool)
810     {
811         _approve(msg.sender, spender, amount);
812         return true;
813     }
814 
815     function increaseAllowance(address spender, uint256 addedValue)
816         public
817         virtual
818         override
819         whenNotPaused
820         returns (bool)
821     {
822         _approve(
823             msg.sender,
824             spender,
825             _allowances[msg.sender][spender].add(addedValue)
826         );
827         return true;
828     }
829 
830     function decreaseAllowance(address spender, uint256 subtractedValue)
831         public
832         virtual
833         override
834         whenNotPaused
835         returns (bool)
836     {
837         _approve(
838             msg.sender,
839             spender,
840             _allowances[msg.sender][spender].sub(
841                 subtractedValue,
842                 "SnpToken: DECREASED_ALLOWANCE_BELOW_ZERO"
843             )
844         );
845         return true;
846     }
847 
848     function burn(uint256 amount)
849         public
850         virtual
851         override
852         whenNotPaused
853         returns (bool)
854     {
855         _burn(msg.sender, amount);
856         return true;
857     }
858 
859     function withdraw(address token, uint256 amount) public onlyOwner {
860         IERC20(token).safeTransfer(msg.sender, amount);
861     }
862 
863     function _transfer(
864         address sender,
865         address recipient,
866         uint256 amount
867     ) internal virtual {
868         require(
869             sender != address(0),
870             "SnpToken: TRANSFER_FROM_THE_ZERO_ADDRESS"
871         );
872         require(
873             recipient != address(0),
874             "SnpToken: TRANSFER_TO_THE_ZERO_ADDRESS"
875         );
876 
877         _balances[sender] = _balances[sender].sub(
878             amount,
879             "SnpToken: TRANSFER_AMOUNT_EXCEEDS_BALANCE"
880         );
881         _balances[recipient] = _balances[recipient].add(amount);
882         emit Transfer(sender, recipient, amount);
883     }
884 
885     function _approve(
886         address owner,
887         address spender,
888         uint256 amount
889     ) internal virtual {
890         require(owner != address(0), "SnpToken: APPROVE_FROM_THE_ZERO_ADDRESS");
891         require(spender != address(0), "SnpToken: APPROVE_TO_THE_ZERO_ADDRESS");
892 
893         _allowances[owner][spender] = amount;
894         emit Approval(owner, spender, amount);
895     }
896 
897     function _mint(address account, uint256 amount) internal {
898         require(account != address(0), "SnpToken: mint to the zero address");
899         _totalSupply = _totalSupply.add(amount);
900         _balances[account] = _balances[account].add(amount);
901         emit Transfer(address(0), account, amount);
902     }
903 
904     function _burn(address account, uint256 amount) internal virtual {
905         require(account != address(0), "SnpToken: BURN_FROM_THE_ZERO_ADDRESS");
906         _balances[account] = _balances[account].sub(
907             amount,
908             "SnpToken: BURN_AMOUNT_EXCEEDS_BALANCE"
909         );
910         _totalSupply = _totalSupply.sub(amount);
911         emit Transfer(account, address(0), amount);
912     }
913 }
914 
915 // File: contracts\SnpMaster.sol
916 
917 pragma solidity 0.6.12;
918 
919 
920 
921 
922 
923 
924 
925 
926 contract SnpMaster is Ownable, Pausable {
927     using SafeMath for uint256;
928     using SafeERC20 for IERC20;
929     using Address for address;
930 
931     // Info of each user.
932     struct UserInfo {
933         uint256 amount; // How many LP tokens the user has provided.
934         uint256 rewardDebt; // Reward debt. See explanation below.
935         uint256 depositTime; // time of deposit LP token
936         string refAddress; //refer address
937     }
938 
939     struct PoolInfo {
940         IERC20 lpToken; // Address of LP token contract.
941         uint256 allocPoint; // How many allocation points assigned to this pool.
942         uint256 lpSupply; // lp supply of LP pool.
943         uint256 lastRewardBlock; // Last block number that SNP distribution occurs.
944         uint256 accSnpPerShare; // Accumulated SNPs per share, times 1e12. See below.
945         uint256 lockPeriod; // lock period of  LP pool
946         uint256 unlockPeriod; // unlock period of  LP pool
947         bool emergencyEnable; // pool withdraw emergency enable
948     }
949 
950     // governance address
951     address public governance;
952     // seele ecosystem address
953     address public seeleEcosystem;
954     // The SNP TOKEN!
955     SnpToken public snptoken;
956 
957     // SNP tokens created per block.
958     uint256 public snpPerBlock;
959     // Info of each pool.
960     PoolInfo[] public poolInfo;
961     // Info of each user that stakes LP tokens.
962     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
963     // Total allocation points. Must be the sum of all allocation points in all pools.
964     uint256 public totalAllocPoint = 0;
965     // The block number when snp mining starts.
966     uint256 public startBlock;
967     // The block number when snp mining ends.
968     uint256 public endBlock;
969     // mint end block num,about 5 years.
970     uint256 public constant MINTEND_BLOCKNUM = 11262857;
971 
972     // Total mint reward.
973     uint256 public totalMintReward = 0;
974     // Total lp supply with rate.
975     uint256 public totallpSupply = 0;
976 
977     uint256 public constant farmrate = 51;
978     uint256 public constant ecosystemrate = 49;
979 
980     event Deposit(
981         address indexed user,
982         uint256 indexed pid,
983         uint256 amount,
984         string indexed refAddress
985     );
986     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
987     event EmergencyWithdraw(
988         address indexed user,
989         uint256 indexed pid,
990         uint256 amount
991     );
992 
993     constructor(
994         SnpToken _snp,
995         uint256 _snpPerBlock,
996         uint256 _startBlock
997     ) public {
998         snptoken = _snp;
999         snpPerBlock = _snpPerBlock;
1000         startBlock = _startBlock;
1001         governance = msg.sender;
1002         seeleEcosystem = msg.sender;
1003         endBlock = _startBlock.add(MINTEND_BLOCKNUM);
1004     }
1005 
1006     function setGovernance(address _governance) public {
1007         require(msg.sender == governance, "snpmaster:!governance");
1008         governance = _governance;
1009     }
1010 
1011     function setSeeleEcosystem(address _seeleEcosystem) public {
1012         require(msg.sender == seeleEcosystem, "snpmaster:!seeleEcosystem");
1013         seeleEcosystem = _seeleEcosystem;
1014     }
1015 
1016     function poolLength() external view returns (uint256) {
1017         return poolInfo.length;
1018     }
1019 
1020     // Add a new lp to the pool. Can only be called by the owner.
1021     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1022     function add(
1023         uint256 _allocPoint,
1024         IERC20 _lpToken,
1025         bool _withUpdate
1026     ) public onlyOwner {
1027         if (_withUpdate) {
1028             massUpdatePools();
1029         }
1030         uint256 lastRewardBlock = block.number > startBlock
1031             ? block.number
1032             : startBlock;
1033         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1034         poolInfo.push(
1035             PoolInfo({
1036                 lpToken: _lpToken,
1037                 allocPoint: _allocPoint,
1038                 lastRewardBlock: lastRewardBlock,
1039                 lpSupply: 0,
1040                 accSnpPerShare: 0,
1041                 lockPeriod: 0,
1042                 unlockPeriod: 0,
1043                 emergencyEnable: false
1044             })
1045         );
1046     }
1047 
1048     // Update the given pool's lock period and unlock period.
1049     function setPoolLockTime(
1050         uint256 _pid,
1051         uint256 _lockPeriod,
1052         uint256 _unlockPeriod
1053     ) public onlyOwner {
1054         poolInfo[_pid].lockPeriod = _lockPeriod;
1055         poolInfo[_pid].unlockPeriod = _unlockPeriod;
1056     }
1057 
1058     // Update the given pool's withdraw emergency Enable.
1059     function setPoolEmergencyEnable(uint256 _pid, bool _emergencyEnable)
1060         public
1061         onlyOwner
1062     {
1063         poolInfo[_pid].emergencyEnable = _emergencyEnable;
1064     }
1065 
1066     // Update end mint block.
1067     function setEndMintBlock(uint256 _endBlock) public onlyOwner {
1068         endBlock = _endBlock;
1069     }
1070 
1071     // Update the given pool's SNP allocation point. Can only be called by the owner.
1072     function set(
1073         uint256 _pid,
1074         uint256 _allocPoint,
1075         bool _withUpdate
1076     ) public onlyOwner {
1077         if (_withUpdate) {
1078             massUpdatePools();
1079         }
1080         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1081             _allocPoint
1082         );
1083 
1084         PoolInfo storage pool = poolInfo[_pid];
1085         if (pool.lpSupply > 0) {
1086             uint256 lpDec = ILPERC20(address(pool.lpToken)).decimals();
1087             uint256 lpSupply = pool
1088                 .lpSupply
1089                 .mul(pool.allocPoint)
1090                 .mul(1e18)
1091                 .div(100)
1092                 .div(10**lpDec);
1093             totallpSupply = totallpSupply.sub(lpSupply);
1094 
1095             lpSupply = pool.lpSupply.mul(_allocPoint).mul(1e18).div(100).div(
1096                 10**lpDec
1097             );
1098             totallpSupply = totallpSupply.add(lpSupply);
1099         }
1100 
1101         poolInfo[_pid].allocPoint = _allocPoint;
1102     }
1103 
1104     // Update reward variables for all pools. Be careful of gas spending!
1105     function massUpdatePools() public {
1106         uint256 length = poolInfo.length;
1107         for (uint256 pid = 0; pid < length; ++pid) {
1108             updatePool(pid);
1109         }
1110     }
1111 
1112     // Update reward variables of the given pool to be up-to-date.
1113     function updatePool(uint256 _pid) public {
1114         PoolInfo storage pool = poolInfo[_pid];
1115         if (block.number <= pool.lastRewardBlock) {
1116             return;
1117         }
1118         uint256 lpSupply = pool.lpSupply;
1119         if (lpSupply == 0) {
1120             pool.lastRewardBlock = block.number;
1121             return;
1122         }
1123 
1124         uint256 lpDec = ILPERC20(address(pool.lpToken)).decimals();
1125         uint256 lpSupply1e18 = lpSupply.mul(1e18).div(10**lpDec);
1126 
1127         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1128         uint256 snpmint = multiplier
1129             .mul(snpPerBlock)
1130             .mul(pool.allocPoint)
1131             .mul(lpSupply1e18)
1132             .div(100)
1133             .div(totallpSupply);
1134 
1135         snptoken.mint(seeleEcosystem, snpmint.mul(ecosystemrate).div(100));
1136 
1137         uint256 snpReward = snpmint.mul(farmrate).div(100);
1138         snpReward = snptoken.mint(address(this), snpReward);
1139 
1140         totalMintReward = totalMintReward.add(snpReward);
1141 
1142         pool.accSnpPerShare = pool.accSnpPerShare.add(
1143             snpReward.mul(1e12).div(lpSupply)
1144         );
1145         pool.lastRewardBlock = block.number;
1146     }
1147 
1148     // Return reward multiplier over the given _from to _to block.
1149     function getMultiplier(uint256 _from, uint256 _to)
1150         public
1151         view
1152         returns (uint256)
1153     {
1154         uint256 toFinal = _to > endBlock ? endBlock : _to;
1155         if (_from >= endBlock) {
1156             return 0;
1157         }
1158         return toFinal.sub(_from);
1159     }
1160 
1161     // View function to see pending SNPs on frontend.
1162     function pendingSnp(uint256 _pid, address _user)
1163         external
1164         view
1165         returns (uint256)
1166     {
1167         PoolInfo storage pool = poolInfo[_pid];
1168         UserInfo storage user = userInfo[_pid][_user];
1169         uint256 accSnpPerShare = pool.accSnpPerShare;
1170         uint256 lpSupply = pool.lpSupply;
1171         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1172             uint256 lpDec = ILPERC20(address(pool.lpToken)).decimals();
1173             uint256 lpSupply1e18 = lpSupply.mul(1e18).div(10**lpDec);
1174 
1175             uint256 multiplier = getMultiplier(
1176                 pool.lastRewardBlock,
1177                 block.number
1178             );
1179             uint256 snpmint = multiplier
1180                 .mul(snpPerBlock)
1181                 .mul(pool.allocPoint)
1182                 .mul(lpSupply1e18)
1183                 .div(100)
1184                 .div(totallpSupply);
1185 
1186             uint256 snpReward = snpmint.mul(farmrate).div(100);
1187             accSnpPerShare = accSnpPerShare.add(
1188                 snpReward.mul(1e12).div(lpSupply)
1189             );
1190         }
1191         return user.amount.mul(accSnpPerShare).div(1e12).sub(user.rewardDebt);
1192     }
1193 
1194     // Deposit LP tokens to Master for SNP allocation.
1195     function deposit(
1196         uint256 _pid,
1197         uint256 _amount,
1198         string calldata _refuser
1199     ) public whenNotPaused {
1200         PoolInfo storage pool = poolInfo[_pid];
1201         UserInfo storage user = userInfo[_pid][msg.sender];
1202         updatePool(_pid);
1203         if (user.amount > 0) {
1204             uint256 pending = user
1205                 .amount
1206                 .mul(pool.accSnpPerShare)
1207                 .div(1e12)
1208                 .sub(user.rewardDebt);
1209             if (pending > 0) {
1210                 if (pool.lockPeriod == 0) {
1211                     uint256 _depositTime = now - user.depositTime;
1212                     if (_depositTime < 1 days) {
1213                         uint256 _actualReward = _depositTime
1214                             .mul(pending)
1215                             .mul(1e18)
1216                             .div(1 days)
1217                             .div(1e18);
1218                         uint256 _goverAomunt = pending.sub(_actualReward);
1219                         safeSnpTransfer(governance, _goverAomunt);
1220                         pending = _actualReward;
1221                     }
1222                 }
1223                 safeSnpTransfer(msg.sender, pending);
1224             }
1225         }
1226         if (_amount > 0) {
1227             pool.lpToken.safeTransferFrom(
1228                 address(msg.sender),
1229                 address(this),
1230                 _amount
1231             );
1232             user.amount = user.amount.add(_amount);
1233             pool.lpSupply = pool.lpSupply.add(_amount);
1234             user.depositTime = now;
1235             user.refAddress = _refuser;
1236             uint256 lpDec = ILPERC20(address(pool.lpToken)).decimals();
1237             uint256 lpSupply = _amount
1238                 .mul(pool.allocPoint)
1239                 .mul(1e18)
1240                 .div(100)
1241                 .div(10**lpDec);
1242             totallpSupply = totallpSupply.add(lpSupply);
1243         }
1244         user.rewardDebt = user.amount.mul(pool.accSnpPerShare).div(1e12);
1245         emit Deposit(msg.sender, _pid, _amount, user.refAddress);
1246     }
1247 
1248     // Withdraw LP tokens from Master.
1249     function withdraw(uint256 _pid, uint256 _amount) public {
1250         PoolInfo storage pool = poolInfo[_pid];
1251         UserInfo storage user = userInfo[_pid][msg.sender];
1252         require(user.amount >= _amount, "withdraw: not good amount");
1253         if (_amount > 0 && pool.lockPeriod > 0) {
1254             require(
1255                 now >= user.depositTime + pool.lockPeriod,
1256                 "withdraw: lock time not reach"
1257             );
1258             if (pool.unlockPeriod > 0) {
1259                 require(
1260                     (now - user.depositTime) % pool.lockPeriod <=
1261                         pool.unlockPeriod,
1262                     "withdraw: not in unlock time period"
1263                 );
1264             }
1265         }
1266 
1267         updatePool(_pid);
1268         uint256 pending = user.amount.mul(pool.accSnpPerShare).div(1e12).sub(
1269             user.rewardDebt
1270         );
1271         if (pending > 0) {
1272             uint256 _depositTime = now - user.depositTime;
1273             if (_depositTime < 1 days) {
1274                 if (pool.lockPeriod == 0) {
1275                     uint256 _actualReward = _depositTime
1276                         .mul(pending)
1277                         .mul(1e18)
1278                         .div(1 days)
1279                         .div(1e18);
1280                     uint256 _goverAomunt = pending.sub(_actualReward);
1281                     safeSnpTransfer(governance, _goverAomunt);
1282                     pending = _actualReward;
1283                 }
1284             }
1285             safeSnpTransfer(msg.sender, pending);
1286         }
1287         if (_amount > 0) {
1288             user.amount = user.amount.sub(_amount);
1289             pool.lpSupply = pool.lpSupply.sub(_amount);
1290             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1291 
1292             uint256 lpDec = ILPERC20(address(pool.lpToken)).decimals();
1293             uint256 lpSupply = _amount
1294                 .mul(pool.allocPoint)
1295                 .mul(1e18)
1296                 .div(100)
1297                 .div(10**lpDec);
1298             totallpSupply = totallpSupply.sub(lpSupply);
1299         }
1300         user.rewardDebt = user.amount.mul(pool.accSnpPerShare).div(1e12);
1301         emit Withdraw(msg.sender, _pid, _amount);
1302     }
1303 
1304     // Withdraw without caring about rewards. EMERGENCY ONLY.
1305     function emergencyWithdraw(uint256 _pid) public {
1306         PoolInfo storage pool = poolInfo[_pid];
1307         UserInfo storage user = userInfo[_pid][msg.sender];
1308         require(
1309             pool.lockPeriod == 0 || pool.emergencyEnable == true,
1310             "emergency withdraw: not good condition"
1311         );
1312         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1313 
1314         uint256 lpDec = ILPERC20(address(pool.lpToken)).decimals();
1315         uint256 lpSupply = user
1316             .amount
1317             .mul(pool.allocPoint)
1318             .mul(1e18)
1319             .div(100)
1320             .div(10**lpDec);
1321         totallpSupply = totallpSupply.sub(lpSupply);
1322 
1323         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1324 
1325         user.amount = 0;
1326         user.rewardDebt = 0;
1327     }
1328 
1329     // Safe snp transfer function, just in case if rounding error causes pool to not have enough SNPs.
1330     function safeSnpTransfer(address _to, uint256 _amount) internal {
1331         uint256 snpBal = snptoken.balanceOf(address(this));
1332         if (_amount > snpBal) {
1333             snptoken.transfer(_to, snpBal);
1334         } else {
1335             snptoken.transfer(_to, _amount);
1336         }
1337     }
1338 
1339     // set snps for every block.
1340     function setSnpPerBlock(uint256 _snpPerBlock) public onlyOwner {
1341         require(_snpPerBlock > 0, "!snpPerBlock-0");
1342 
1343         snpPerBlock = _snpPerBlock;
1344     }
1345 }