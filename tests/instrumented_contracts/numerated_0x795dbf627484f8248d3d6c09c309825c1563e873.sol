1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
82 
83 
84 pragma solidity ^0.6.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
243 
244 
245 
246 pragma solidity ^0.6.2;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies in extcodesize, which returns 0 for contracts in
271         // construction, since the code is only stored at the end of the
272         // constructor execution.
273 
274         uint256 size;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { size := extcodesize(account) }
277         return size > 0;
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
387 
388 
389 
390 pragma solidity ^0.6.0;
391 
392 
393 
394 
395 /**
396  * @title SafeERC20
397  * @dev Wrappers around ERC20 operations that throw on failure (when the token
398  * contract returns false). Tokens that return no value (and instead revert or
399  * throw on failure) are also supported, non-reverting calls are assumed to be
400  * successful.
401  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
402  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
403  */
404 library SafeERC20 {
405     using SafeMath for uint256;
406     using Address for address;
407 
408     function safeTransfer(IERC20 token, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
410     }
411 
412     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
414     }
415 
416     /**
417      * @dev Deprecated. This function has issues similar to the ones found in
418      * {IERC20-approve}, and its usage is discouraged.
419      *
420      * Whenever possible, use {safeIncreaseAllowance} and
421      * {safeDecreaseAllowance} instead.
422      */
423     function safeApprove(IERC20 token, address spender, uint256 value) internal {
424         // safeApprove should only be called when setting an initial allowance,
425         // or when resetting it to zero. To increase and decrease it, use
426         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
427         // solhint-disable-next-line max-line-length
428         require((value == 0) || (token.allowance(address(this), spender) == 0),
429             "SafeERC20: approve from non-zero to non-zero allowance"
430         );
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
432     }
433 
434     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).add(value);
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     /**
445      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
446      * on the return value: the return value is optional (but if data is returned, it must not be false).
447      * @param token The token targeted by the call.
448      * @param data The call data (encoded using abi.encode or one of its variants).
449      */
450     function _callOptionalReturn(IERC20 token, bytes memory data) private {
451         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
452         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
453         // the target address contains contract code and also asserts for success in the low-level call.
454 
455         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
456         if (returndata.length > 0) { // Return data is optional
457             // solhint-disable-next-line max-line-length
458             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
459         }
460     }
461 }
462 
463 // File: @openzeppelin\contracts\math\SafeMath.sol
464 
465 
466 
467 
468 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
469 
470 
471 pragma solidity ^0.6.0;
472 
473 /*
474  * @dev Provides information about the current execution context, including the
475  * sender of the transaction and its data. While these are generally available
476  * via msg.sender and msg.data, they should not be accessed in such a direct
477  * manner, since when dealing with GSN meta-transactions the account sending and
478  * paying for execution may not be the actual sender (as far as an application
479  * is concerned).
480  *
481  * This contract is only required for intermediate, library-like contracts.
482  */
483 abstract contract Context {
484     function _msgSender() internal view virtual returns (address payable) {
485         return msg.sender;
486     }
487 
488     function _msgData() internal view virtual returns (bytes memory) {
489         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
490         return msg.data;
491     }
492 }
493 
494 // File: @openzeppelin\contracts\access\Ownable.sol
495 
496 
497 pragma solidity ^0.6.0;
498 
499 /**
500  * @dev Contract module which provides a basic access control mechanism, where
501  * there is an account (an owner) that can be granted exclusive access to
502  * specific functions.
503  *
504  * By default, the owner account will be the one that deploys the contract. This
505  * can later be changed with {transferOwnership}.
506  *
507  * This module is used through inheritance. It will make available the modifier
508  * `onlyOwner`, which can be applied to your functions to restrict their use to
509  * the owner.
510  */
511 contract Ownable is Context {
512     address private _owner;
513 
514     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
515 
516     /**
517      * @dev Initializes the contract setting the deployer as the initial owner.
518      */
519     constructor () internal {
520         address msgSender = _msgSender();
521         _owner = msgSender;
522         emit OwnershipTransferred(address(0), msgSender);
523     }
524 
525     /**
526      * @dev Returns the address of the current owner.
527      */
528     function owner() public view returns (address) {
529         return _owner;
530     }
531 
532     /**
533      * @dev Throws if called by any account other than the owner.
534      */
535     modifier onlyOwner() {
536         require(_owner == _msgSender(), "Ownable: caller is not the owner");
537         _;
538     }
539 
540     /**
541      * @dev Leaves the contract without owner. It will not be possible to call
542      * `onlyOwner` functions anymore. Can only be called by the current owner.
543      *
544      * NOTE: Renouncing ownership will leave the contract without an owner,
545      * thereby removing any functionality that is only available to the owner.
546      */
547     function renounceOwnership() public virtual onlyOwner {
548         emit OwnershipTransferred(_owner, address(0));
549         _owner = address(0);
550     }
551 
552     /**
553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
554      * Can only be called by the current owner.
555      */
556     function transferOwnership(address newOwner) public virtual onlyOwner {
557         require(newOwner != address(0), "Ownable: new owner is the zero address");
558         emit OwnershipTransferred(_owner, newOwner);
559         _owner = newOwner;
560     }
561 }
562 
563 // File: @openzeppelin\contracts\utils\Pausable.sol
564 
565 
566 pragma solidity ^0.6.0;
567 
568 
569 /**
570  * @dev Contract module which allows children to implement an emergency stop
571  * mechanism that can be triggered by an authorized account.
572  *
573  * This module is used through inheritance. It will make available the
574  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
575  * the functions of your contract. Note that they will not be pausable by
576  * simply including this module, only once the modifiers are put in place.
577  */
578 contract Pausable is Context {
579     /**
580      * @dev Emitted when the pause is triggered by `account`.
581      */
582     event Paused(address account);
583 
584     /**
585      * @dev Emitted when the pause is lifted by `account`.
586      */
587     event Unpaused(address account);
588 
589     bool private _paused;
590 
591     /**
592      * @dev Initializes the contract in unpaused state.
593      */
594     constructor () internal {
595         _paused = false;
596     }
597 
598     /**
599      * @dev Returns true if the contract is paused, and false otherwise.
600      */
601     function paused() public view returns (bool) {
602         return _paused;
603     }
604 
605     /**
606      * @dev Modifier to make a function callable only when the contract is not paused.
607      *
608      * Requirements:
609      *
610      * - The contract must not be paused.
611      */
612     modifier whenNotPaused() {
613         require(!_paused, "Pausable: paused");
614         _;
615     }
616 
617     /**
618      * @dev Modifier to make a function callable only when the contract is paused.
619      *
620      * Requirements:
621      *
622      * - The contract must be paused.
623      */
624     modifier whenPaused() {
625         require(_paused, "Pausable: not paused");
626         _;
627     }
628 
629     /**
630      * @dev Triggers stopped state.
631      *
632      * Requirements:
633      *
634      * - The contract must not be paused.
635      */
636     function _pause() internal virtual whenNotPaused {
637         _paused = true;
638         emit Paused(_msgSender());
639     }
640 
641     /**
642      * @dev Returns to normal state.
643      *
644      * Requirements:
645      *
646      * - The contract must be paused.
647      */
648     function _unpause() internal virtual whenPaused {
649         _paused = false;
650         emit Unpaused(_msgSender());
651     }
652 }
653 
654 
655 
656 // File: contracts\interfaces\ISnpToken.sol
657 
658 
659 pragma solidity 0.6.12;
660 
661 
662 /**
663  * @dev Interface of the Snp erc20 token.
664  */
665 
666 interface ISnpToken is IERC20 {
667     function mint(address account, uint256 amount) external returns (uint256);
668 
669     function burn(uint256 amount) external returns (bool);
670 
671     function increaseAllowance(address spender, uint256 addedValue)
672         external
673         returns (bool);
674 
675     function decreaseAllowance(address spender, uint256 subtractedValue)
676         external
677         returns (bool);
678 }
679 
680 // File: contracts\SnpToken.sol
681 
682 
683 pragma solidity 0.6.12;
684 
685 
686 
687 
688 
689 
690 
691 contract SnpToken is ISnpToken, Ownable, Pausable {
692     using SafeMath for uint256;
693     using Address for address;
694     using SafeERC20 for IERC20;
695 
696     mapping(address => uint256) private _balances;
697 
698     mapping(address => mapping(address => uint256)) private _allowances;
699 
700     mapping(address => bool) public minters;
701 
702     uint256 private _totalSupply;
703 
704     string private _name = "SNP Token";
705     string private _symbol = "SNP";
706     uint8 private _decimals = 18;
707     uint256 public TOTAL_SUPPLY = 3000000 ether;
708 
709     constructor() public {
710         _totalSupply = 0;
711     }
712 
713     function name() external view returns (string memory) {
714         return _name;
715     }
716 
717     function symbol() external view returns (string memory) {
718         return _symbol;
719     }
720 
721     function decimals() external view returns (uint8) {
722         return _decimals;
723     }
724 
725     function totalSupply() public override view returns (uint256) {
726         return _totalSupply;
727     }
728 
729     function balanceOf(address account) public override view returns (uint256) {
730         return _balances[account];
731     }
732 
733     function addMinter(address _minter) external onlyOwner {
734         minters[_minter] = true;
735     }
736 
737     function removeMinter(address _minter) external onlyOwner {
738         minters[_minter] = false;
739     }
740 
741     function mint(address account, uint256 amount)
742         public
743         virtual
744         override
745         whenNotPaused
746         returns (uint256)
747     {
748         require(minters[msg.sender], "SnpToken: You are not the minter");
749         uint256 supply = _totalSupply.add(amount);
750         if (supply > TOTAL_SUPPLY) {
751             supply = TOTAL_SUPPLY;
752         }
753         amount = supply.sub(_totalSupply);
754         _mint(account, amount);
755         return amount;
756     }
757 
758     function transfer(address recipient, uint256 amount)
759         public
760         virtual
761         override
762         whenNotPaused
763         returns (bool)
764     {
765         _transfer(msg.sender, recipient, amount);
766         return true;
767     }
768 
769     function transferFrom(
770         address sender,
771         address recipient,
772         uint256 amount
773     ) public virtual override whenNotPaused returns (bool) {
774         _transfer(sender, recipient, amount);
775         _approve(
776             sender,
777             msg.sender,
778             _allowances[sender][msg.sender].sub(
779                 amount,
780                 "SnpToken: TRANSFER_AMOUNT_EXCEEDS_ALLOWANCE"
781             )
782         );
783         return true;
784     }
785 
786     function allowance(address owner, address spender)
787         public
788         virtual
789         override
790         view
791         returns (uint256)
792     {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount)
797         public
798         virtual
799         override
800         whenNotPaused
801         returns (bool)
802     {
803         _approve(msg.sender, spender, amount);
804         return true;
805     }
806 
807     function increaseAllowance(address spender, uint256 addedValue)
808         public
809         virtual
810         override
811         whenNotPaused
812         returns (bool)
813     {
814         _approve(
815             msg.sender,
816             spender,
817             _allowances[msg.sender][spender].add(addedValue)
818         );
819         return true;
820     }
821 
822     function decreaseAllowance(address spender, uint256 subtractedValue)
823         public
824         virtual
825         override
826         whenNotPaused
827         returns (bool)
828     {
829         _approve(
830             msg.sender,
831             spender,
832             _allowances[msg.sender][spender].sub(
833                 subtractedValue,
834                 "SnpToken: DECREASED_ALLOWANCE_BELOW_ZERO"
835             )
836         );
837         return true;
838     }
839 
840     function burn(uint256 amount)
841         public
842         virtual
843         override
844         whenNotPaused
845         returns (bool)
846     {
847         _burn(msg.sender, amount);
848         return true;
849     }
850 
851     function withdraw(address token, uint256 amount) public onlyOwner {
852         IERC20(token).safeTransfer(msg.sender, amount);
853     }
854 
855     function _transfer(
856         address sender,
857         address recipient,
858         uint256 amount
859     ) internal virtual {
860         require(
861             sender != address(0),
862             "SnpToken: TRANSFER_FROM_THE_ZERO_ADDRESS"
863         );
864         require(
865             recipient != address(0),
866             "SnpToken: TRANSFER_TO_THE_ZERO_ADDRESS"
867         );
868 
869         _balances[sender] = _balances[sender].sub(
870             amount,
871             "SnpToken: TRANSFER_AMOUNT_EXCEEDS_BALANCE"
872         );
873         _balances[recipient] = _balances[recipient].add(amount);
874         emit Transfer(sender, recipient, amount);
875     }
876 
877     function _approve(
878         address owner,
879         address spender,
880         uint256 amount
881     ) internal virtual {
882         require(owner != address(0), "SnpToken: APPROVE_FROM_THE_ZERO_ADDRESS");
883         require(spender != address(0), "SnpToken: APPROVE_TO_THE_ZERO_ADDRESS");
884 
885         _allowances[owner][spender] = amount;
886         emit Approval(owner, spender, amount);
887     }
888 
889     function _mint(address account, uint256 amount) internal {
890         require(account != address(0), "SnpToken: mint to the zero address");
891         _totalSupply = _totalSupply.add(amount);
892         _balances[account] = _balances[account].add(amount);
893         emit Transfer(address(0), account, amount);
894     }
895 
896     function _burn(address account, uint256 amount) internal virtual {
897         require(account != address(0), "SnpToken: BURN_FROM_THE_ZERO_ADDRESS");
898         _balances[account] = _balances[account].sub(
899             amount,
900             "SnpToken: BURN_AMOUNT_EXCEEDS_BALANCE"
901         );
902         _totalSupply = _totalSupply.sub(amount);
903         emit Transfer(account, address(0), amount);
904     }
905 }