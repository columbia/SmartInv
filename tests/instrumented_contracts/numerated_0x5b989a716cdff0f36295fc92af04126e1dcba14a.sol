1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 // SPDX-License-Identifier: MIT
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 // SPDX-License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/GSN/Context.sol
465 
466 // SPDX-License-Identifier: MIT
467 
468 pragma solidity ^0.6.0;
469 
470 /*
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with GSN meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address payable) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes memory) {
486         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
487         return msg.data;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/access/Ownable.sol
492 
493 // SPDX-License-Identifier: MIT
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
561 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
562 
563 // SPDX-License-Identifier: MIT
564 
565 pragma solidity ^0.6.0;
566 
567 
568 
569 
570 
571 /**
572  * @dev Implementation of the {IERC20} interface.
573  *
574  * This implementation is agnostic to the way tokens are created. This means
575  * that a supply mechanism has to be added in a derived contract using {_mint}.
576  * For a generic mechanism see {ERC20PresetMinterPauser}.
577  *
578  * TIP: For a detailed writeup see our guide
579  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
580  * to implement supply mechanisms].
581  *
582  * We have followed general OpenZeppelin guidelines: functions revert instead
583  * of returning `false` on failure. This behavior is nonetheless conventional
584  * and does not conflict with the expectations of ERC20 applications.
585  *
586  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
587  * This allows applications to reconstruct the allowance for all accounts just
588  * by listening to said events. Other implementations of the EIP may not emit
589  * these events, as it isn't required by the specification.
590  *
591  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
592  * functions have been added to mitigate the well-known issues around setting
593  * allowances. See {IERC20-approve}.
594  */
595 contract ERC20 is Context, IERC20 {
596     using SafeMath for uint256;
597     using Address for address;
598 
599     mapping (address => uint256) private _balances;
600 
601     mapping (address => mapping (address => uint256)) private _allowances;
602 
603     uint256 private _totalSupply;
604 
605     string private _name;
606     string private _symbol;
607     uint8 private _decimals;
608 
609     /**
610      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
611      * a default value of 18.
612      *
613      * To select a different value for {decimals}, use {_setupDecimals}.
614      *
615      * All three of these values are immutable: they can only be set once during
616      * construction.
617      */
618     constructor (string memory name, string memory symbol) public {
619         _name = name;
620         _symbol = symbol;
621         _decimals = 18;
622     }
623 
624     /**
625      * @dev Returns the name of the token.
626      */
627     function name() public view returns (string memory) {
628         return _name;
629     }
630 
631     /**
632      * @dev Returns the symbol of the token, usually a shorter version of the
633      * name.
634      */
635     function symbol() public view returns (string memory) {
636         return _symbol;
637     }
638 
639     /**
640      * @dev Returns the number of decimals used to get its user representation.
641      * For example, if `decimals` equals `2`, a balance of `505` tokens should
642      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
643      *
644      * Tokens usually opt for a value of 18, imitating the relationship between
645      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
646      * called.
647      *
648      * NOTE: This information is only used for _display_ purposes: it in
649      * no way affects any of the arithmetic of the contract, including
650      * {IERC20-balanceOf} and {IERC20-transfer}.
651      */
652     function decimals() public view returns (uint8) {
653         return _decimals;
654     }
655 
656     /**
657      * @dev See {IERC20-totalSupply}.
658      */
659     function totalSupply() public view override returns (uint256) {
660         return _totalSupply;
661     }
662 
663     /**
664      * @dev See {IERC20-balanceOf}.
665      */
666     function balanceOf(address account) public view override returns (uint256) {
667         return _balances[account];
668     }
669 
670     /**
671      * @dev See {IERC20-transfer}.
672      *
673      * Requirements:
674      *
675      * - `recipient` cannot be the zero address.
676      * - the caller must have a balance of at least `amount`.
677      */
678     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
679         _transfer(_msgSender(), recipient, amount);
680         return true;
681     }
682 
683     /**
684      * @dev See {IERC20-allowance}.
685      */
686     function allowance(address owner, address spender) public view virtual override returns (uint256) {
687         return _allowances[owner][spender];
688     }
689 
690     /**
691      * @dev See {IERC20-approve}.
692      *
693      * Requirements:
694      *
695      * - `spender` cannot be the zero address.
696      */
697     function approve(address spender, uint256 amount) public virtual override returns (bool) {
698         _approve(_msgSender(), spender, amount);
699         return true;
700     }
701 
702     /**
703      * @dev See {IERC20-transferFrom}.
704      *
705      * Emits an {Approval} event indicating the updated allowance. This is not
706      * required by the EIP. See the note at the beginning of {ERC20};
707      *
708      * Requirements:
709      * - `sender` and `recipient` cannot be the zero address.
710      * - `sender` must have a balance of at least `amount`.
711      * - the caller must have allowance for ``sender``'s tokens of at least
712      * `amount`.
713      */
714     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
715         _transfer(sender, recipient, amount);
716         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
717         return true;
718     }
719 
720     /**
721      * @dev Atomically increases the allowance granted to `spender` by the caller.
722      *
723      * This is an alternative to {approve} that can be used as a mitigation for
724      * problems described in {IERC20-approve}.
725      *
726      * Emits an {Approval} event indicating the updated allowance.
727      *
728      * Requirements:
729      *
730      * - `spender` cannot be the zero address.
731      */
732     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
733         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
734         return true;
735     }
736 
737     /**
738      * @dev Atomically decreases the allowance granted to `spender` by the caller.
739      *
740      * This is an alternative to {approve} that can be used as a mitigation for
741      * problems described in {IERC20-approve}.
742      *
743      * Emits an {Approval} event indicating the updated allowance.
744      *
745      * Requirements:
746      *
747      * - `spender` cannot be the zero address.
748      * - `spender` must have allowance for the caller of at least
749      * `subtractedValue`.
750      */
751     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
752         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
753         return true;
754     }
755 
756     /**
757      * @dev Moves tokens `amount` from `sender` to `recipient`.
758      *
759      * This is internal function is equivalent to {transfer}, and can be used to
760      * e.g. implement automatic token fees, slashing mechanisms, etc.
761      *
762      * Emits a {Transfer} event.
763      *
764      * Requirements:
765      *
766      * - `sender` cannot be the zero address.
767      * - `recipient` cannot be the zero address.
768      * - `sender` must have a balance of at least `amount`.
769      */
770     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
771         require(sender != address(0), "ERC20: transfer from the zero address");
772         require(recipient != address(0), "ERC20: transfer to the zero address");
773 
774         _beforeTokenTransfer(sender, recipient, amount);
775 
776         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
777         _balances[recipient] = _balances[recipient].add(amount);
778         emit Transfer(sender, recipient, amount);
779     }
780 
781     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
782      * the total supply.
783      *
784      * Emits a {Transfer} event with `from` set to the zero address.
785      *
786      * Requirements
787      *
788      * - `to` cannot be the zero address.
789      */
790     function _mint(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: mint to the zero address");
792 
793         _beforeTokenTransfer(address(0), account, amount);
794 
795         _totalSupply = _totalSupply.add(amount);
796         _balances[account] = _balances[account].add(amount);
797         emit Transfer(address(0), account, amount);
798     }
799 
800     /**
801      * @dev Destroys `amount` tokens from `account`, reducing the
802      * total supply.
803      *
804      * Emits a {Transfer} event with `to` set to the zero address.
805      *
806      * Requirements
807      *
808      * - `account` cannot be the zero address.
809      * - `account` must have at least `amount` tokens.
810      */
811     function _burn(address account, uint256 amount) internal virtual {
812         require(account != address(0), "ERC20: burn from the zero address");
813 
814         _beforeTokenTransfer(account, address(0), amount);
815 
816         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
817         _totalSupply = _totalSupply.sub(amount);
818         emit Transfer(account, address(0), amount);
819     }
820 
821     /**
822      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
823      *
824      * This internal function is equivalent to `approve`, and can be used to
825      * e.g. set automatic allowances for certain subsystems, etc.
826      *
827      * Emits an {Approval} event.
828      *
829      * Requirements:
830      *
831      * - `owner` cannot be the zero address.
832      * - `spender` cannot be the zero address.
833      */
834     function _approve(address owner, address spender, uint256 amount) internal virtual {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842     /**
843      * @dev Sets {decimals} to a value other than the default one of 18.
844      *
845      * WARNING: This function should only be called from the constructor. Most
846      * applications that interact with token contracts will not expect
847      * {decimals} to ever change, and may work incorrectly if it does.
848      */
849     function _setupDecimals(uint8 decimals_) internal {
850         _decimals = decimals_;
851     }
852 
853     /**
854      * @dev Hook that is called before any transfer of tokens. This includes
855      * minting and burning.
856      *
857      * Calling conditions:
858      *
859      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
860      * will be to transferred to `to`.
861      * - when `from` is zero, `amount` tokens will be minted for `to`.
862      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
863      * - `from` and `to` are never both zero.
864      *
865      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
866      */
867     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
868 }
869 
870 // File: contracts/SovietToken.sol
871 
872 pragma solidity 0.6.2;
873 
874 
875 
876 
877 contract SovietToken is ERC20("Soviet Token", "SOV"), Ownable {
878     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
879     function mint(address _to, uint256 _amount) public onlyOwner {
880         _mint(_to, _amount);
881     }
882 }
883 
884 // File: contracts/Soviet.sol
885 
886 pragma solidity 0.6.2;
887 
888 
889 
890 
891 
892 interface IReferral {
893     function getReferrals(address _addr) external view returns (address[] memory);
894 
895     function getInvitees(address _addr) external view returns (address[] memory);
896 }
897 
898 // Note that it's ownable and the owner wields tremendous power. The ownership
899 // will be transferred to a governance smart contract once SOV is sufficiently
900 // distributed and the community can show to govern itself.
901 contract Soviet is Ownable {
902     using SafeMath for uint256;
903     using SafeERC20 for IERC20;
904 
905     // Info of each user.
906     struct UserInfo {
907         uint256 amount;     // How many LP tokens the user has provided.
908         uint256 rewardDebt; // Reward debt. See explanation below.
909         uint256 refReward;
910         uint256 harvested;
911     }
912 
913     // Info of each pool.
914     struct PoolInfo {
915         IERC20 lpToken;             // Address of LP token contract.
916         uint256 allocPoint;         // How many allocation points assigned to this pool. SOVs to distribute per block.
917         uint256 lastRewardBlock;    // Last block number that SOVs distribution occurs.
918         uint256 accRewardPerShare;  // Accumulated SOVs per share, times 1e18. See below.
919         bool enableRefReward;
920         uint256 totalAmount;
921         uint256 refLimit;
922     }
923 
924     // Assistance of each user.
925     struct AssistanceInfo {
926         bool isFinished;
927         uint256 finishBlock;
928         uint256 counter;
929         mapping(address => bool) users;
930     }
931 
932     // The SOV TOKEN!
933     SovietToken public SOV;
934     IReferral public iRef;
935     // Dev address.
936     address public devaddr;
937     // BadgePool address.
938     address public badgePoolAddr;
939     // Block number when bonus SOV period ends.
940     uint256 public bonusEndBlock;
941     // SOV tokens created per block.
942     uint256 public rewardPerBlock;
943     uint256 public refRewards;
944 
945     // Info of each pool.
946     PoolInfo[] public poolInfo;
947     // Info of each user that stakes LP tokens.
948     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
949     // Total allocation poitns. Must be the sum of all allocation points in all pools.
950     uint256 public totalAllocPoint;
951     // The block number when SOV mining starts.
952     uint256 public startBlock;
953     // Reduction
954     uint256 public reductionBlockCount;
955     uint256 public maxReductionCount;
956     uint256 public nextReductionBlock;
957     uint256 public reductionCounter;
958     uint256 public reductionPercent;
959     uint256 public TEN = 10;
960     uint256 public HUNDRED = 100;
961 
962     mapping(address => AssistanceInfo) public assistanceInfo;
963 
964     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
965     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
966     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
967 
968     constructor(
969         SovietToken _SOV,
970         address _devaddr,
971         address _badgePoolAddr,
972         uint256 _startBlock,
973         IReferral _iReferral
974     ) public {
975         SOV = _SOV;
976         devaddr = _devaddr;
977         badgePoolAddr = _badgePoolAddr;
978         startBlock = _startBlock;
979         rewardPerBlock = TEN.mul(TEN ** uint256(_SOV.decimals()));
980         reductionBlockCount = 49000;
981         maxReductionCount = 7;
982         reductionPercent = 80;
983         bonusEndBlock = _startBlock.add(reductionBlockCount.mul(maxReductionCount));
984         nextReductionBlock = _startBlock.add(reductionBlockCount);
985         iRef = _iReferral;
986     }
987 
988     function poolLength() external view returns (uint256) {
989         return poolInfo.length;
990     }
991 
992     // Add a new lp to the pool. Can only be called by the owner.
993     // XXX DO NOT add the same LP/BPT token more than once. Rewards will be messed up if you do.
994     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, bool _enableRefReward, uint256 _refLimit) public onlyOwner {
995         if (_withUpdate) {
996             massUpdatePools();
997         }
998         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
999         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1000         poolInfo.push(PoolInfo({
1001         lpToken : _lpToken,
1002         allocPoint : _allocPoint,
1003         lastRewardBlock : lastRewardBlock,
1004         accRewardPerShare : 0,
1005         enableRefReward : _enableRefReward,
1006         refLimit : _refLimit,
1007         totalAmount : 0
1008         }));
1009     }
1010 
1011     // Update the given pool's SOV allocation point. Can only be called by the owner.
1012     function set(uint256 _pid, uint256 _allocPoint, bool _enableRefReward, uint256 _refLimit, bool _withUpdate) public onlyOwner {
1013         if (_withUpdate) {
1014             massUpdatePools();
1015         }
1016         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1017         poolInfo[_pid].allocPoint = _allocPoint;
1018         poolInfo[_pid].enableRefReward = _enableRefReward;
1019         poolInfo[_pid].refLimit = _refLimit;
1020     }
1021 
1022     // Return reward multiplier over the given _from to _to block.
1023     function getBlocksReward(uint256 _from, uint256 _to) public view returns (uint256) {
1024         if (_from >= bonusEndBlock) {
1025             return 0;
1026         }
1027         uint256 prevReductionBlock = nextReductionBlock.sub(reductionBlockCount);
1028         _to = (_to > bonusEndBlock ? bonusEndBlock : _to);
1029         if (_from >= prevReductionBlock && _to <= nextReductionBlock)
1030         {
1031             return getBlockReward(_to.sub(_from), rewardPerBlock, reductionCounter);
1032         }
1033         else if (_from < prevReductionBlock && _to < nextReductionBlock)
1034         {
1035             uint256 part1 = getBlockReward(_to.sub(prevReductionBlock), rewardPerBlock, reductionCounter);
1036             uint256 part2 = getBlockReward(prevReductionBlock.sub(_from), rewardPerBlock, reductionCounter.sub(1));
1037             return part1.add(part2);
1038         }
1039         else
1040         {
1041             uint256 part1 = getBlockReward(_to.sub(nextReductionBlock), rewardPerBlock, reductionCounter.add(1));
1042             uint256 part2 = getBlockReward(nextReductionBlock.sub(_from), rewardPerBlock, reductionCounter);
1043             return part1.add(part2);
1044         }
1045     }
1046 
1047     // Return reward per block
1048     function getBlockReward(uint256 _blockCount, uint256 _rewardPerBlock, uint256 _reductionCounter) internal view returns (uint256) {
1049         uint256 _reward = _blockCount.mul(_rewardPerBlock);
1050         if (_reductionCounter == 0) {
1051             return _reward;
1052         }
1053         return _reward.mul(reductionPercent ** _reductionCounter).div(HUNDRED ** _reductionCounter);
1054     }
1055 
1056     // View function to see pending SOVs on frontend.
1057     function pendingReward(uint256 _pid, address _user) external view returns (uint256, uint256, uint256) {
1058         PoolInfo storage pool = poolInfo[_pid];
1059         UserInfo storage user = userInfo[_pid][_user];
1060         uint256 accRewardPerShare = pool.accRewardPerShare;
1061         uint256 lpSupply = pool.totalAmount;
1062         uint256 blockReward;
1063         uint256 poolReward;
1064         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1065             blockReward = getBlocksReward(pool.lastRewardBlock, block.number);
1066             poolReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
1067             accRewardPerShare = accRewardPerShare.add(poolReward.mul(1e18).div(lpSupply));
1068         }
1069         return (user.amount.mul(accRewardPerShare).div(1e18).add(user.refReward).sub(user.rewardDebt), user.harvested, user.refReward);
1070     }
1071 
1072     // View function to see my army balance on frontend.
1073     function armyBalance(uint256 _pid, address _addr) external view returns (uint256, uint256) {
1074         return selectInvitees(_pid, _addr);
1075     }
1076     
1077     function selectInvitees(uint256 _pid, address _addr) internal view returns (uint256, uint256) {
1078         address[] memory _invitees = iRef.getInvitees(_addr);
1079         uint256 _total_count;
1080         uint256 _total_amount;
1081         for (uint256 idx; idx < _invitees.length; idx ++) {
1082             address u = _invitees[idx];
1083             _total_count = _total_count.add(1);
1084             _total_amount = _total_amount.add(poolInfo[_pid].lpToken.balanceOf(u));
1085             if (iRef.getInvitees(_addr).length > 0) {
1086                 (uint256 _count, uint256 _amount) = selectInvitees(_pid, u);
1087                 _total_count = _total_count.add(_count);
1088                 _total_amount = _total_amount.add(_amount);
1089             }
1090         }
1091         return (_total_count, _total_amount);
1092     }
1093 
1094     // Update reward variables for all pools. Be careful of gas spending!
1095     function massUpdatePools() public {
1096         uint256 length = poolInfo.length;
1097         for (uint256 pid = 0; pid < length; ++pid) {
1098             updatePool(pid);
1099         }
1100     }
1101 
1102     // Update reward variables of the given pool to be up-to-date.
1103     function updatePool(uint256 _pid) public {
1104         PoolInfo storage pool = poolInfo[_pid];
1105         if (block.number <= pool.lastRewardBlock) {
1106             return;
1107         }
1108         if (block.number > nextReductionBlock) {
1109             nextReductionBlock = nextReductionBlock.add(reductionBlockCount);
1110             reductionCounter = reductionCounter.add(1);
1111         }
1112         uint256 lpSupply = pool.totalAmount;
1113         if (lpSupply == 0) {
1114             pool.lastRewardBlock = block.number;
1115             return;
1116         }
1117         uint256 blockReward = getBlocksReward(pool.lastRewardBlock, block.number);
1118         uint256 poolReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
1119         SOV.mint(devaddr, poolReward.div(TEN));
1120         SOV.mint(address(this), poolReward);
1121         pool.accRewardPerShare = pool.accRewardPerShare.add(poolReward.mul(1e18).div(lpSupply));
1122         pool.lastRewardBlock = block.number;
1123     }
1124 
1125     // Update referral reward when pool.enableRefWard is true
1126     function setRefReward(address _addr, uint256 _reward, uint256 _pid) internal {
1127         PoolInfo storage pool = poolInfo[_pid];
1128         if (!pool.enableRefReward) {
1129             return;
1130         }
1131 
1132         address[] memory refs = iRef.getReferrals(_addr);
1133         if (refs.length == 0 || (refs.length == 1 && userInfo[_pid][refs[0]].amount < pool.refLimit)) {
1134             SOV.mint(badgePoolAddr, _reward.div(TEN));
1135             return;
1136         }
1137 
1138         uint256 _badgePoolReward;
1139         uint256 _thisReward;
1140         uint256 ref0Reward = _reward.div(20);
1141 
1142         if (userInfo[_pid][refs[0]].amount >= pool.refLimit) {
1143             _thisReward = _thisReward.add(ref0Reward);
1144             userInfo[_pid][refs[0]].refReward = userInfo[_pid][refs[0]].refReward.add(ref0Reward);
1145         } else {
1146             _badgePoolReward = _badgePoolReward.add(ref0Reward);
1147         }
1148 
1149         if (refs.length == 1) {
1150             _badgePoolReward = _badgePoolReward.add(ref0Reward);
1151         } else {
1152             uint256 refnReward = ref0Reward.div(refs.length.sub(1));
1153             for (uint256 idx = 1; idx < refs.length; idx ++) {
1154                 if (userInfo[_pid][refs[idx]].amount >= pool.refLimit) {
1155                     _thisReward = _thisReward.add(refnReward);
1156                     userInfo[_pid][refs[idx]].refReward = userInfo[_pid][refs[idx]].refReward.add(refnReward);
1157                 } else {
1158                     _badgePoolReward = _badgePoolReward.add(refnReward);
1159                 }
1160             }
1161         }
1162 
1163         if (_thisReward > 0) {
1164             SOV.mint(address(this), _thisReward);
1165         }
1166         if (_badgePoolReward > 0) {
1167             SOV.mint(badgePoolAddr, _badgePoolReward);
1168         }
1169     }
1170 
1171     // Claim reward & set referral reward
1172     function harvest(address _addr, uint256 _pending, uint256 _pid) internal {
1173         // Base reward
1174         safeTokenTransfer(_addr, _pending);
1175         userInfo[_pid][_addr].harvested = userInfo[_pid][_addr].harvested.add(_pending);
1176 
1177         // Set referral reward
1178         setRefReward(_addr, _pending.sub(userInfo[_pid][_addr].refReward), _pid);
1179     }
1180 
1181     // Deposit BPT/LP tokens to Soviet for SOV allocation.
1182     function deposit(uint256 _pid, uint256 _amount) public {
1183         PoolInfo storage pool = poolInfo[_pid];
1184         UserInfo storage user = userInfo[_pid][msg.sender];
1185         updatePool(_pid);
1186         if (user.amount > 0 || user.refReward > 0) {
1187             uint256 pending = totalReward(pool, user).sub(user.rewardDebt);
1188             if (pending > 0) {
1189                 harvest(msg.sender, pending, _pid);
1190             }
1191         }
1192         if (_amount > 0) {
1193             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1194             user.amount = user.amount.add(_amount);
1195             pool.totalAmount = pool.totalAmount.add(_amount);
1196         }
1197         user.rewardDebt = totalReward(pool, user);
1198         emit Deposit(msg.sender, _pid, _amount);
1199     }
1200 
1201     // Withdraw BPT/LP tokens from Soviet.
1202     function withdraw(uint256 _pid, uint256 _amount) public {
1203         PoolInfo storage pool = poolInfo[_pid];
1204         UserInfo storage user = userInfo[_pid][msg.sender];
1205         require(user.amount >= _amount, "withdraw: not good");
1206         updatePool(_pid);
1207         uint256 pending = totalReward(pool, user).sub(user.rewardDebt);
1208         if (pending > 0) {
1209             harvest(msg.sender, pending, _pid);
1210         }
1211         if (_amount > 0) {
1212             user.amount = user.amount.sub(_amount);
1213             pool.totalAmount = pool.totalAmount.sub(_amount);
1214             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1215         }
1216         user.rewardDebt = totalReward(pool, user);
1217         emit Withdraw(msg.sender, _pid, _amount);
1218     }
1219 
1220     // User total reward
1221     function totalReward(PoolInfo storage _pool, UserInfo storage _user) internal view returns (uint256){
1222         return _user.amount.mul(_pool.accRewardPerShare).div(1e18).add(_user.refReward);
1223     }
1224 
1225     // Withdraw without caring about rewards. EMERGENCY ONLY.
1226     function emergencyWithdraw(uint256 _pid) public {
1227         PoolInfo storage pool = poolInfo[_pid];
1228         UserInfo storage user = userInfo[_pid][msg.sender];
1229         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1230         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1231         user.amount = 0;
1232         user.rewardDebt = 0;
1233         user.refReward = 0;
1234         user.harvested = 0;
1235     }
1236 
1237     // Safe SOV transfer function, just in case if rounding error causes pool to not have enough SOVs.
1238     function safeTokenTransfer(address _to, uint256 _amount) internal {
1239         uint256 bal = SOV.balanceOf(address(this));
1240         if (_amount > bal) {
1241             SOV.transfer(_to, bal);
1242         } else {
1243             SOV.transfer(_to, _amount);
1244         }
1245     }
1246 
1247     // Update dev address by the previous dev.
1248     function dev(address _devaddr) public {
1249         require(msg.sender == devaddr, "dev: wut?");
1250         devaddr = _devaddr;
1251     }
1252 
1253     // Update badgePool address by the previous badgePool address.
1254     function updateBadgePoolAddr(address _addr) public {
1255         require(msg.sender == badgePoolAddr, "badgePool: Permission denied!");
1256         badgePoolAddr = _addr;
1257     }
1258 }
