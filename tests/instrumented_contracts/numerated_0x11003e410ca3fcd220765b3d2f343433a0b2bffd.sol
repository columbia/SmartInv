1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
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
81 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
82 
83 
84 pragma solidity ^0.6.2;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies in extcodesize, which returns 0 for contracts in
109         // construction, since the code is only stored at the end of the
110         // constructor execution.
111 
112         uint256 size;
113         // solhint-disable-next-line no-inline-assembly
114         assembly { size := extcodesize(account) }
115         return size > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
138         (bool success, ) = recipient.call{ value: amount }("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain`call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161       return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
171         return _functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
196         require(address(this).balance >= value, "Address: insufficient balance for call");
197         return _functionCallWithValue(target, data, value, errorMessage);
198     }
199 
200     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
201         require(isContract(target), "Address: call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 // solhint-disable-next-line no-inline-assembly
213                 assembly {
214                     let returndata_size := mload(returndata)
215                     revert(add(32, returndata), returndata_size)
216                 }
217             } else {
218                 revert(errorMessage);
219             }
220         }
221     }
222 }
223 
224 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
225 
226 
227 pragma solidity ^0.6.0;
228 
229 
230 
231 
232 /**
233  * @title SafeERC20
234  * @dev Wrappers around ERC20 operations that throw on failure (when the token
235  * contract returns false). Tokens that return no value (and instead revert or
236  * throw on failure) are also supported, non-reverting calls are assumed to be
237  * successful.
238  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
239  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
240  */
241 library SafeERC20 {
242     using SafeMath for uint256;
243     using Address for address;
244 
245     function safeTransfer(IERC20 token, address to, uint256 value) internal {
246         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
247     }
248 
249     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
250         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
251     }
252 
253     /**
254      * @dev Deprecated. This function has issues similar to the ones found in
255      * {IERC20-approve}, and its usage is discouraged.
256      *
257      * Whenever possible, use {safeIncreaseAllowance} and
258      * {safeDecreaseAllowance} instead.
259      */
260     function safeApprove(IERC20 token, address spender, uint256 value) internal {
261         // safeApprove should only be called when setting an initial allowance,
262         // or when resetting it to zero. To increase and decrease it, use
263         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
264         // solhint-disable-next-line max-line-length
265         require((value == 0) || (token.allowance(address(this), spender) == 0),
266             "SafeERC20: approve from non-zero to non-zero allowance"
267         );
268         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
269     }
270 
271     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
272         uint256 newAllowance = token.allowance(address(this), spender).add(value);
273         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
274     }
275 
276     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
277         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
278         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
279     }
280 
281     /**
282      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
283      * on the return value: the return value is optional (but if data is returned, it must not be false).
284      * @param token The token targeted by the call.
285      * @param data The call data (encoded using abi.encode or one of its variants).
286      */
287     function _callOptionalReturn(IERC20 token, bytes memory data) private {
288         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
289         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
290         // the target address contains contract code and also asserts for success in the low-level call.
291 
292         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
293         if (returndata.length > 0) { // Return data is optional
294             // solhint-disable-next-line max-line-length
295             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
296         }
297     }
298 }
299 
300 // File: @openzeppelin\contracts\math\SafeMath.sol
301 
302 
303 pragma solidity ^0.6.0;
304 
305 /**
306  * @dev Wrappers over Solidity's arithmetic operations with added overflow
307  * checks.
308  *
309  * Arithmetic operations in Solidity wrap on overflow. This can easily result
310  * in bugs, because programmers usually assume that an overflow raises an
311  * error, which is the standard behavior in high level programming languages.
312  * `SafeMath` restores this intuition by reverting the transaction when an
313  * operation overflows.
314  *
315  * Using this library instead of the unchecked operations eliminates an entire
316  * class of bugs, so it's recommended to use it always.
317  */
318 library SafeMath {
319     /**
320      * @dev Returns the addition of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `+` operator.
324      *
325      * Requirements:
326      *
327      * - Addition cannot overflow.
328      */
329     function add(uint256 a, uint256 b) internal pure returns (uint256) {
330         uint256 c = a + b;
331         require(c >= a, "SafeMath: addition overflow");
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the subtraction of two unsigned integers, reverting on
338      * overflow (when the result is negative).
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      *
344      * - Subtraction cannot overflow.
345      */
346     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
347         return sub(a, b, "SafeMath: subtraction overflow");
348     }
349 
350     /**
351      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
352      * overflow (when the result is negative).
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b <= a, errorMessage);
362         uint256 c = a - b;
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the multiplication of two unsigned integers, reverting on
369      * overflow.
370      *
371      * Counterpart to Solidity's `*` operator.
372      *
373      * Requirements:
374      *
375      * - Multiplication cannot overflow.
376      */
377     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
378         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
379         // benefit is lost if 'b' is also tested.
380         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
381         if (a == 0) {
382             return 0;
383         }
384 
385         uint256 c = a * b;
386         require(c / a == b, "SafeMath: multiplication overflow");
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the integer division of two unsigned integers. Reverts on
393      * division by zero. The result is rounded towards zero.
394      *
395      * Counterpart to Solidity's `/` operator. Note: this function uses a
396      * `revert` opcode (which leaves remaining gas untouched) while Solidity
397      * uses an invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function div(uint256 a, uint256 b) internal pure returns (uint256) {
404         return div(a, b, "SafeMath: division by zero");
405     }
406 
407     /**
408      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
409      * division by zero. The result is rounded towards zero.
410      *
411      * Counterpart to Solidity's `/` operator. Note: this function uses a
412      * `revert` opcode (which leaves remaining gas untouched) while Solidity
413      * uses an invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b > 0, errorMessage);
421         uint256 c = a / b;
422         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * Reverts when dividing by zero.
430      *
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432      * opcode (which leaves remaining gas untouched) while Solidity uses an
433      * invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         return mod(a, b, "SafeMath: modulo by zero");
441     }
442 
443     /**
444      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
445      * Reverts with custom message when dividing by zero.
446      *
447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
448      * opcode (which leaves remaining gas untouched) while Solidity uses an
449      * invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
456         require(b != 0, errorMessage);
457         return a % b;
458     }
459 }
460 
461 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
462 
463 
464 pragma solidity ^0.6.0;
465 
466 /*
467  * @dev Provides information about the current execution context, including the
468  * sender of the transaction and its data. While these are generally available
469  * via msg.sender and msg.data, they should not be accessed in such a direct
470  * manner, since when dealing with GSN meta-transactions the account sending and
471  * paying for execution may not be the actual sender (as far as an application
472  * is concerned).
473  *
474  * This contract is only required for intermediate, library-like contracts.
475  */
476 abstract contract Context {
477     function _msgSender() internal view virtual returns (address payable) {
478         return msg.sender;
479     }
480 
481     function _msgData() internal view virtual returns (bytes memory) {
482         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
483         return msg.data;
484     }
485 }
486 
487 // File: @openzeppelin\contracts\access\Ownable.sol
488 
489 
490 pragma solidity ^0.6.0;
491 
492 /**
493  * @dev Contract module which provides a basic access control mechanism, where
494  * there is an account (an owner) that can be granted exclusive access to
495  * specific functions.
496  *
497  * By default, the owner account will be the one that deploys the contract. This
498  * can later be changed with {transferOwnership}.
499  *
500  * This module is used through inheritance. It will make available the modifier
501  * `onlyOwner`, which can be applied to your functions to restrict their use to
502  * the owner.
503  */
504 contract Ownable is Context {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev Initializes the contract setting the deployer as the initial owner.
511      */
512     constructor () internal {
513         address msgSender = _msgSender();
514         _owner = msgSender;
515         emit OwnershipTransferred(address(0), msgSender);
516     }
517 
518     /**
519      * @dev Returns the address of the current owner.
520      */
521     function owner() public view returns (address) {
522         return _owner;
523     }
524 
525     /**
526      * @dev Throws if called by any account other than the owner.
527      */
528     modifier onlyOwner() {
529         require(_owner == _msgSender(), "Ownable: caller is not the owner");
530         _;
531     }
532 
533     /**
534      * @dev Leaves the contract without owner. It will not be possible to call
535      * `onlyOwner` functions anymore. Can only be called by the current owner.
536      *
537      * NOTE: Renouncing ownership will leave the contract without an owner,
538      * thereby removing any functionality that is only available to the owner.
539      */
540     function renounceOwnership() public virtual onlyOwner {
541         emit OwnershipTransferred(_owner, address(0));
542         _owner = address(0);
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 }
555 
556 
557 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
558 
559 
560 pragma solidity ^0.6.0;
561 
562 
563 
564 /**
565  * @dev Implementation of the {IERC20} interface.
566  *
567  * This implementation is agnostic to the way tokens are created. This means
568  * that a supply mechanism has to be added in a derived contract using {_mint}.
569  * For a generic mechanism see {ERC20PresetMinterPauser}.
570  *
571  * TIP: For a detailed writeup see our guide
572  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
573  * to implement supply mechanisms].
574  *
575  * We have followed general OpenZeppelin guidelines: functions revert instead
576  * of returning `false` on failure. This behavior is nonetheless conventional
577  * and does not conflict with the expectations of ERC20 applications.
578  *
579  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
580  * This allows applications to reconstruct the allowance for all accounts just
581  * by listening to said events. Other implementations of the EIP may not emit
582  * these events, as it isn't required by the specification.
583  *
584  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
585  * functions have been added to mitigate the well-known issues around setting
586  * allowances. See {IERC20-approve}.
587  */
588 contract ERC20 is Context, IERC20 {
589     using SafeMath for uint256;
590     using Address for address;
591 
592     mapping (address => uint256) private _balances;
593 
594     mapping (address => mapping (address => uint256)) private _allowances;
595 
596     uint256 private _totalSupply;
597 
598     string private _name;
599     string private _symbol;
600     uint8 private _decimals;
601     
602     bool public ListingMode = true; // ListingMode is activated when the contract is initiated. It will prevent any buy/transfer except for the dev. It can only be deactivated.
603     bool public LimitMode = true;   // LimitMode is activated and limit to 1000 METH per buy. It will be shut down after few minutes. It can only be deactivated.
604 
605     address constant public devWallet = 0x1750B0fdF7fCaa9b9065467de324230159f6463a; 
606 
607     /**
608      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
609      * a default value of 18.
610      *
611      * To select a different value for {decimals}, use {_setupDecimals}.
612      *
613      * All three of these values are immutable: they can only be set once during
614      * construction.
615      */
616     constructor (string memory name, string memory symbol) public {
617         _name = name;
618         _symbol = symbol;
619         _decimals = 18;
620     }
621 
622     /**
623      * @dev Returns the name of the token.
624      */
625     function name() public view returns (string memory) {
626         return _name;
627     }
628 
629     /**
630      * @dev Returns the symbol of the token, usually a shorter version of the
631      * name.
632      */
633     function symbol() public view returns (string memory) {
634         return _symbol;
635     }
636 
637     /**
638      * @dev Returns the number of decimals used to get its user representation.
639      * For example, if `decimals` equals `2`, a balance of `505` tokens should
640      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
641      *
642      * Tokens usually opt for a value of 18, imitating the relationship between
643      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
644      * called.
645      *
646      * NOTE: This information is only used for _display_ purposes: it in
647      * no way affects any of the arithmetic of the contract, including
648      * {IERC20-balanceOf} and {IERC20-transfer}.
649      */
650     function decimals() public view returns (uint8) {
651         return _decimals;
652     }
653 
654     /**
655      * @dev See {IERC20-totalSupply}.
656      */
657     function totalSupply() public view override returns (uint256) {
658         return _totalSupply;
659     }
660 
661     /**
662      * @dev See {IERC20-balanceOf}.
663      */
664     function balanceOf(address account) public view override returns (uint256) {
665         return _balances[account];
666     }
667 
668     /**
669      * @dev See {IERC20-transfer}.
670      *
671      * Requirements:
672      *
673      * - `recipient` cannot be the zero address.
674      * - the caller must have a balance of at least `amount`.
675      */
676     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
677         _transfer(_msgSender(), recipient, amount);
678         return true;
679     }
680 
681     /**
682      * @dev See {IERC20-allowance}.
683      */
684     function allowance(address owner, address spender) public view virtual override returns (uint256) {
685         return _allowances[owner][spender];
686     }
687 
688     /**
689      * @dev See {IERC20-approve}.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function approve(address spender, uint256 amount) public virtual override returns (bool) {
696         _approve(_msgSender(), spender, amount);
697         return true;
698     }
699 
700     /**
701      * @dev See {IERC20-transferFrom}.
702      *
703      * Emits an {Approval} event indicating the updated allowance. This is not
704      * required by the EIP. See the note at the beginning of {ERC20};
705      *
706      * Requirements:
707      * - `sender` and `recipient` cannot be the zero address.
708      * - `sender` must have a balance of at least `amount`.
709      * - the caller must have allowance for ``sender``'s tokens of at least
710      * `amount`.
711      */
712     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
713         _transfer(sender, recipient, amount);
714         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
715         return true;
716     }
717 
718     /**
719      * @dev Atomically increases the allowance granted to `spender` by the caller.
720      *
721      * This is an alternative to {approve} that can be used as a mitigation for
722      * problems described in {IERC20-approve}.
723      *
724      * Emits an {Approval} event indicating the updated allowance.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      */
730     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
731         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
732         return true;
733     }
734 
735     /**
736      * @dev Atomically decreases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      * - `spender` must have allowance for the caller of at least
747      * `subtractedValue`.
748      */
749     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
751         return true;
752     }
753 
754     /**
755      * @dev Moves tokens `amount` from `sender` to `recipient`.
756      *
757      * This is internal function is equivalent to {transfer}, and can be used to
758      * e.g. implement automatic token fees, slashing mechanisms, etc.
759      *
760      * Emits a {Transfer} event.
761      *
762      * Requirements:
763      *
764      * - `sender` cannot be the zero address.
765      * - `recipient` cannot be the zero address.
766      * - `sender` must have a balance of at least `amount`.
767      */
768     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
769         require(sender != address(0), "ERC20: transfer from the zero address");
770         require(recipient != address(0), "ERC20: transfer to the zero address");
771     
772     // Make sure bots dont take over. ListingMode is disable after listing and cant be enabled again
773     // Only dev can buy / transfer
774         if (ListingMode) {
775             require(sender == devWallet, "Listing Mode on : no transfer or buy allowed");
776         }
777 
778     // Botbuster, we plan to limit the amount of token that one can buy to 2800 METH. 
779         if (LimitMode == true && sender != devWallet) {
780             require(amount <= uint(28e20), "Limit Mode on : max buy authorized is 2800 METH");
781         }
782 
783         _beforeTokenTransfer(sender, recipient, amount);
784 
785         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
786         _balances[recipient] = _balances[recipient].add(amount);
787         emit Transfer(sender, recipient, amount);
788     }
789 
790     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
791      * the total supply.
792      *
793      * Emits a {Transfer} event with `from` set to the zero address.
794      *
795      * Requirements
796      *
797      * - `to` cannot be the zero address.
798      */
799     function _mint(address account, uint256 amount) internal virtual {
800         require(account != address(0), "ERC20: mint to the zero address");
801 
802         _beforeTokenTransfer(address(0), account, amount);
803 
804         _totalSupply = _totalSupply.add(amount);
805         _balances[account] = _balances[account].add(amount);
806         emit Transfer(address(0), account, amount);
807     }
808 
809     /**
810      * @dev Destroys `amount` tokens from `account`, reducing the
811      * total supply.
812      *
813      * Emits a {Transfer} event with `to` set to the zero address.
814      *
815      * Requirements
816      *
817      * - `account` cannot be the zero address.
818      * - `account` must have at least `amount` tokens.
819      */
820     function _burn(address account, uint256 amount) internal virtual {
821         require(account != address(0), "ERC20: burn from the zero address");
822 
823         _beforeTokenTransfer(account, address(0), amount);
824 
825         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
826         _totalSupply = _totalSupply.sub(amount);
827         emit Transfer(account, address(0), amount);
828     }
829 
830     /**
831      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
832      *
833      * This internal function is equivalent to `approve`, and can be used to
834      * e.g. set automatic allowances for certain subsystems, etc.
835      *
836      * Emits an {Approval} event.
837      *
838      * Requirements:
839      *
840      * - `owner` cannot be the zero address.
841      * - `spender` cannot be the zero address.
842      */
843     function _approve(address owner, address spender, uint256 amount) internal virtual {
844         require(owner != address(0), "ERC20: approve from the zero address");
845         require(spender != address(0), "ERC20: approve to the zero address");
846 
847         _allowances[owner][spender] = amount;
848         emit Approval(owner, spender, amount);
849     }
850 
851     /**
852      * @dev Sets {decimals} to a value other than the default one of 18.
853      *
854      * WARNING: This function should only be called from the constructor. Most
855      * applications that interact with token contracts will not expect
856      * {decimals} to ever change, and may work incorrectly if it does.
857      */
858     function _setupDecimals(uint8 decimals_) internal {
859         _decimals = decimals_;
860     }
861 
862     /**
863      * @dev Hook that is called before any transfer of tokens. This includes
864      * minting and burning.
865      *
866      * Calling conditions:
867      *
868      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
869      * will be to transferred to `to`.
870      * - when `from` is zero, `amount` tokens will be minted for `to`.
871      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
872      * - `from` and `to` are never both zero.
873      *
874      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
875      */
876     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
877 }
878 
879 
880 
881 /*
882 
883 ___________                    .__                 ___.               .___
884 \_   _____/____ _______  _____ |__| ____    ____   \_ |__ _____     __| _/
885  |    __) \__  \\_  __ \/     \|  |/    \  / ___\   | __ \\__  \   / __ | 
886  |     \   / __ \|  | \/  Y Y  \  |   |  \/ /_/  >  | \_\ \/ __ \_/ /_/ | 
887  \___  /  (____  /__|  |__|_|  /__|___|  /\___  /   |___  (____  /\____ | 
888      \/        \/            \/        \//_____/        \/     \/      \/ 
889 
890 */
891 
892 
893 pragma solidity 0.6.12;
894 
895 
896 // METHToken
897 contract METHToken is ERC20("Farming Bad", "METH"), Ownable {
898     using SafeMath for uint256;
899 
900     // There will be a total max supply of 30,000,000 METH
901     uint256 public constant MAX_SUPPLY = 30000000 * 10**18;
902     
903     // Farming will end when max supply is reached
904     bool public maxSupplyHit = false;
905     
906     event Minted(address indexed minter, address indexed receiver, uint mintAmount);
907     
908     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
909     function mint(address _to, uint256 _amount) public onlyOwner {
910         require(maxSupplyHit != true, "max supply hit");    // Prevent any mint beyond the max supply 
911         uint256 supply = totalSupply();
912         if (supply.add(_amount) >= MAX_SUPPLY) {
913             _amount = MAX_SUPPLY.sub(supply);
914             maxSupplyHit = true;
915         }
916         
917         if (_amount > 0) {
918             _mint(_to, _amount);
919             emit Minted(owner(), _to, _amount);
920         }
921     }
922     
923     // Disable any buy while creating the LP and distributing to the WL
924     function disableListingMode() public onlyOwner {
925             ListingMode = false;
926         }
927   
928     // Disable only function. Botbuster to let everyone buy METH at fair price at listing
929     function disableLimitMode() public onlyOwner {
930             LimitMode = false;
931         }
932     
933     // Copied and modified from YAM code:
934     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
935     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
936     // Which is copied and modified from COMPOUND:
937     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
938 
939     /// @dev A record of each accounts delegate
940     mapping (address => address) internal _delegates;
941 
942     /// @notice A checkpoint for marking number of votes from a given block
943     struct Checkpoint {
944         uint32 fromBlock;
945         uint256 votes;
946     }
947 
948     /// @notice A record of votes checkpoints for each account, by index
949     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
950 
951     /// @notice The number of checkpoints for each account
952     mapping (address => uint32) public numCheckpoints;
953 
954     /// @notice The EIP-712 typehash for the contract's domain
955     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
956 
957     /// @notice The EIP-712 typehash for the delegation struct used by the contract
958     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
959 
960     /// @notice A record of states for signing / validating signatures
961     mapping (address => uint) public nonces;
962 
963       /// @notice An event thats emitted when an account changes its delegate
964     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
965 
966     /// @notice An event thats emitted when a delegate account's vote balance changes
967     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
968 
969     /**
970      * @notice Delegate votes from `msg.sender` to `delegatee`
971      * @param delegator The address to get delegatee for
972      */
973     function delegates(address delegator)
974         external
975         view
976         returns (address)
977     {
978         return _delegates[delegator];
979     }
980 
981    /**
982     * @notice Delegate votes from `msg.sender` to `delegatee`
983     * @param delegatee The address to delegate votes to
984     */
985     function delegate(address delegatee) external {
986         return _delegate(msg.sender, delegatee);
987     }
988 
989     /**
990      * @notice Delegates votes from signatory to `delegatee`
991      * @param delegatee The address to delegate votes to
992      * @param nonce The contract state required to match the signature
993      * @param expiry The time at which to expire the signature
994      * @param v The recovery byte of the signature
995      * @param r Half of the ECDSA signature pair
996      * @param s Half of the ECDSA signature pair
997      */
998     function delegateBySig(
999         address delegatee,
1000         uint nonce,
1001         uint expiry,
1002         uint8 v,
1003         bytes32 r,
1004         bytes32 s
1005     )
1006         external
1007     {
1008         bytes32 domainSeparator = keccak256(
1009             abi.encode(
1010                 DOMAIN_TYPEHASH,
1011                 keccak256(bytes(name())),
1012                 getChainId(),
1013                 address(this)
1014             )
1015         );
1016 
1017         bytes32 structHash = keccak256(
1018             abi.encode(
1019                 DELEGATION_TYPEHASH,
1020                 delegatee,
1021                 nonce,
1022                 expiry
1023             )
1024         );
1025 
1026         bytes32 digest = keccak256(
1027             abi.encodePacked(
1028                 "\x19\x01",
1029                 domainSeparator,
1030                 structHash
1031             )
1032         );
1033 
1034         address signatory = ecrecover(digest, v, r, s);
1035         require(signatory != address(0), "METH::delegateBySig: invalid signature");
1036         require(nonce == nonces[signatory]++, "METH::delegateBySig: invalid nonce");
1037         require(now <= expiry, "METH::delegateBySig: signature expired");
1038         return _delegate(signatory, delegatee);
1039     }
1040 
1041     /**
1042      * @notice Gets the current votes balance for `account`
1043      * @param account The address to get votes balance
1044      * @return The number of current votes for `account`
1045      */
1046     function getCurrentVotes(address account)
1047         external
1048         view
1049         returns (uint256)
1050     {
1051         uint32 nCheckpoints = numCheckpoints[account];
1052         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1053     }
1054 
1055     /**
1056      * @notice Determine the prior number of votes for an account as of a block number
1057      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1058      * @param account The address of the account to check
1059      * @param blockNumber The block number to get the vote balance at
1060      * @return The number of votes the account had as of the given block
1061      */
1062     function getPriorVotes(address account, uint blockNumber)
1063         external
1064         view
1065         returns (uint256)
1066     {
1067         require(blockNumber < block.number, "METH::getPriorVotes: not yet determined");
1068 
1069         uint32 nCheckpoints = numCheckpoints[account];
1070         if (nCheckpoints == 0) {
1071             return 0;
1072         }
1073 
1074         // First check most recent balance
1075         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1076             return checkpoints[account][nCheckpoints - 1].votes;
1077         }
1078 
1079         // Next check implicit zero balance
1080         if (checkpoints[account][0].fromBlock > blockNumber) {
1081             return 0;
1082         }
1083 
1084         uint32 lower = 0;
1085         uint32 upper = nCheckpoints - 1;
1086         while (upper > lower) {
1087             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1088             Checkpoint memory cp = checkpoints[account][center];
1089             if (cp.fromBlock == blockNumber) {
1090                 return cp.votes;
1091             } else if (cp.fromBlock < blockNumber) {
1092                 lower = center;
1093             } else {
1094                 upper = center - 1;
1095             }
1096         }
1097         return checkpoints[account][lower].votes;
1098     }
1099 
1100     function _delegate(address delegator, address delegatee)
1101         internal
1102     {
1103         address currentDelegate = _delegates[delegator];
1104         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying METHs (not scaled);
1105         _delegates[delegator] = delegatee;
1106 
1107         emit DelegateChanged(delegator, currentDelegate, delegatee);
1108 
1109         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1110     }
1111 
1112     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1113         if (srcRep != dstRep && amount > 0) {
1114             if (srcRep != address(0)) {
1115                 // decrease old representative
1116                 uint32 srcRepNum = numCheckpoints[srcRep];
1117                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1118                 uint256 srcRepNew = srcRepOld.sub(amount);
1119                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1120             }
1121 
1122             if (dstRep != address(0)) {
1123                 // increase new representative
1124                 uint32 dstRepNum = numCheckpoints[dstRep];
1125                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1126                 uint256 dstRepNew = dstRepOld.add(amount);
1127                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1128             }
1129         }
1130     }
1131 
1132     function _writeCheckpoint(
1133         address delegatee,
1134         uint32 nCheckpoints,
1135         uint256 oldVotes,
1136         uint256 newVotes
1137     )
1138         internal
1139     {
1140         uint32 blockNumber = safe32(block.number, "METH::_writeCheckpoint: block number exceeds 32 bits");
1141 
1142         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1143             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1144         } else {
1145             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1146             numCheckpoints[delegatee] = nCheckpoints + 1;
1147         }
1148 
1149         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1150     }
1151 
1152     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1153         require(n < 2**32, errorMessage);
1154         return uint32(n);
1155     }
1156 
1157     function getChainId() internal pure returns (uint) {
1158         uint256 chainId;
1159         assembly { chainId := chainid() }
1160         return chainId;
1161     }
1162 }
1163 
1164 
1165 /*
1166 
1167 ___________                    .__                 ___.               .___
1168 \_   _____/____ _______  _____ |__| ____    ____   \_ |__ _____     __| _/
1169  |    __) \__  \\_  __ \/     \|  |/    \  / ___\   | __ \\__  \   / __ | 
1170  |     \   / __ \|  | \/  Y Y  \  |   |  \/ /_/  >  | \_\ \/ __ \_/ /_/ | 
1171  \___  /  (____  /__|  |__|_|  /__|___|  /\___  /   |___  (____  /\____ | 
1172      \/        \/            \/        \//_____/        \/     \/      \/ 
1173 
1174 */
1175 
1176 pragma solidity 0.6.12;
1177 
1178 // FarmingBad is the master of METH. He can make METH and he is a fair guy.
1179 //
1180 // Note that it's ownable and the owner wields tremendous power. The ownership
1181 // will be transferred to a governance smart contract once METH is sufficiently
1182 // distributed and the community can show to govern itself.
1183 contract FarmingBad is Ownable {
1184     using SafeMath for uint256;
1185     using SafeERC20 for IERC20;
1186 
1187     // Info of each user.
1188     struct UserInfo {
1189         uint256 amount;     // How many LP tokens the user has provided.
1190         uint256 rewardDebt; // Reward debt. See explanation below.
1191         //
1192         // We do some fancy math here. Basically, any point in time, the amount of METHs
1193         // entitled to a user but is pending to be distributed is:
1194         //
1195         //   pending reward = (user.amount * pool.accMETHPerShare) - user.rewardDebt
1196         //
1197         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1198         //   1. The pool's `accMETHPerShare` (and `lastRewardBlock`) gets updated.
1199         //   2. User receives the pending reward sent to his/her address.
1200         //   3. User's `amount` gets updated.
1201         //   4. User's `rewardDebt` gets updated.
1202     }
1203 
1204     // Info of each pool.
1205     struct PoolInfo {
1206         IERC20 lpToken;           // Address of LP token contract.
1207         uint256 allocPoint;       // How many allocation points assigned to this pool. METHs to distribute per block.
1208         uint256 lastRewardBlock;  // Last block number that METHs distribution occurs.
1209         uint256 accMETHPerShare; // Accumulated METHs per share, times 1e12. See below.
1210     }
1211 
1212 
1213     METHToken public METH;    // The METH TOKEN!
1214     address public devaddr;    // Dev address.
1215 
1216     mapping(address => bool) public lpTokenExistsInPool;    // Track all added pools to prevent adding the same pool more then once.
1217     mapping (uint256 => mapping (address => UserInfo)) public userInfo;    // Info of each user that stakes LP tokens.
1218 
1219     uint256 public totalAllocPoint = 0;    // Total allocation points. Must be the sum of all allocation points in all pools.
1220 
1221     uint256 public constant startBlock = 11799070;    // The block number when METH mining starts.
1222     uint256 public bonusEndBlock = 11799070;
1223     
1224     uint256 public constant DEV_TAX = 5;
1225     uint256 public constant BONUS_MULTIPLIER = 1;
1226 
1227 	uint256 public methPerBlock = 46e18;
1228 	uint256 public berhaneValue = 35e12;
1229 	uint256 public lastBlockUpdate = 0; // the last block when RewardPerBlock was updated with the berhaneValue
1230 
1231     PoolInfo[] public poolInfo;    // Info of each pool.
1232 
1233     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1234     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1235     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1236 
1237     modifier onlyDev() {
1238         require(devaddr == _msgSender(), "not dev");
1239         _;
1240     }
1241 
1242     constructor(
1243         METHToken _METH,
1244         address _devaddr
1245     ) public {
1246         METH = _METH;
1247         devaddr = _devaddr;
1248     }
1249 
1250     function poolLength() external view returns (uint256) {
1251         return poolInfo.length;
1252     }
1253 
1254     // Add a new lp to the pool. Can only be called by the owner.
1255     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1256         require(!lpTokenExistsInPool[address(_lpToken)], "MasterChef: LP Token Address already exists in pool");
1257         if (_withUpdate) {
1258             massUpdatePools();
1259         }
1260         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1261         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1262         poolInfo.push(PoolInfo({
1263             lpToken: _lpToken,
1264             allocPoint: _allocPoint,
1265             lastRewardBlock: lastRewardBlock,
1266             accMETHPerShare: 0
1267         }));
1268 
1269         lpTokenExistsInPool[address(_lpToken)] = true;
1270     }
1271 
1272     function updateDevAddress(address _devAddress) public onlyDev {
1273         devaddr = _devAddress;
1274     }
1275 
1276     // Add a pool manually for pools that already exists, but were not auto added to the map by "add()".
1277     function updateLpTokenExists(address _lpTokenAddr, bool _isExists) external onlyOwner {
1278         lpTokenExistsInPool[_lpTokenAddr] = _isExists;
1279     }
1280 
1281     // Update the given pool's METH allocation point. Can only be called by the owner.
1282     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1283         if (_withUpdate) {
1284             massUpdatePools();
1285         }
1286         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1287         poolInfo[_pid].allocPoint = _allocPoint;
1288     }
1289 
1290     // Return reward multiplier over the given _from to _to block.
1291     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1292         if (_to <= bonusEndBlock) {
1293             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1294         } else if (_from >= bonusEndBlock) {
1295             return _to.sub(_from);
1296         } else {
1297             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1298                 _to.sub(bonusEndBlock)
1299             );
1300         }
1301     }
1302 
1303     // View function to see pending METHs on frontend.
1304     function pendingMETH(uint256 _pid, address _user) external view returns (uint256) {
1305         PoolInfo storage pool = poolInfo[_pid];
1306         UserInfo storage user = userInfo[_pid][_user];
1307         uint256 accMETHPerShare = pool.accMETHPerShare;
1308         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1309         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1310             uint256 blocksToReward = getMultiplier(pool.lastRewardBlock, block.number);
1311             uint256 methReward = blocksToReward.mul(methPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1312             accMETHPerShare = accMETHPerShare.add(methReward.mul(1e12).div(lpSupply));
1313         }
1314         return user.amount.mul(accMETHPerShare).div(1e12).sub(user.rewardDebt);
1315     }
1316 
1317     // Update reward variables for all pools. Be careful of gas spending!
1318     function massUpdatePools() public {
1319         uint256 length = poolInfo.length;
1320         for (uint256 pid = 0; pid < length; ++pid) {
1321             updatePool(pid);
1322         }
1323     }
1324 
1325     // Update reward variables of the given pool to be up-to-date.
1326     function updatePool(uint256 _pid) public {
1327         PoolInfo storage pool = poolInfo[_pid];
1328         if (block.number <= pool.lastRewardBlock) {
1329             return;
1330         }
1331         
1332         // Init the first block when berhaneValue has been updated
1333         if (lastBlockUpdate == 0) {
1334             lastBlockUpdate = block.number;
1335         }
1336 
1337         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1338         if (lpSupply == 0) {
1339             pool.lastRewardBlock = block.number;
1340             return;
1341         }
1342         
1343         // Get number of blocks since last update of methPerBlock
1344         uint256 BlocksToUpdate = block.number - lastBlockUpdate;
1345 
1346         // Adjust Berhane depending on number of blocks to update
1347         uint256 Berhane = (BlocksToUpdate).mul(berhaneValue);
1348         
1349         // Set the new number of methPerBlock with Berhane
1350         methPerBlock = methPerBlock.sub(Berhane);
1351         
1352         // Check how many blocks have to be rewarded since the last pool update
1353         uint256 blocksToReward = getMultiplier(pool.lastRewardBlock, block.number);
1354         
1355         uint256 CompensationSinceLastRewardUpdate = 0;
1356         if (BlocksToUpdate > 0)
1357         {
1358             CompensationSinceLastRewardUpdate = BlocksToUpdate.mul(Berhane);
1359         }
1360         uint256 methReward = blocksToReward.mul(methPerBlock.add(CompensationSinceLastRewardUpdate)).mul(pool.allocPoint).div(totalAllocPoint);
1361 
1362         METH.mint(address(this), methReward);
1363         pool.accMETHPerShare = pool.accMETHPerShare.add(methReward.mul(1e12).div(lpSupply));
1364         pool.lastRewardBlock = block.number;
1365         lastBlockUpdate = block.number;
1366     }
1367 
1368     // Deposit LP tokens to FarmingBad for METH allocation.
1369     function deposit(uint256 _pid, uint256 _amount) public {
1370         PoolInfo storage pool = poolInfo[_pid];
1371         UserInfo storage user = userInfo[_pid][msg.sender];
1372         updatePool(_pid);
1373         if (user.amount > 0) {
1374             uint256 pending = user.amount.mul(pool.accMETHPerShare).div(1e12).sub(user.rewardDebt);
1375             if(pending > 0) {
1376                 safeMethTransfer(msg.sender, pending);
1377             }
1378         }
1379         if(_amount > 0) {
1380             uint256 _taxAmount = _amount.mul(DEV_TAX).div(100);
1381             _amount = _amount.sub(_taxAmount);
1382             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1383             pool.lpToken.safeTransferFrom(address(msg.sender), address(devaddr), _taxAmount);
1384             user.amount = user.amount.add(_amount);
1385         }
1386         user.rewardDebt = user.amount.mul(pool.accMETHPerShare).div(1e12);
1387         emit Deposit(msg.sender, _pid, _amount);
1388     }
1389 
1390     // Withdraw LP tokens from FarmingBad.
1391     function withdraw(uint256 _pid, uint256 _amount) public {
1392         PoolInfo storage pool = poolInfo[_pid];
1393         UserInfo storage user = userInfo[_pid][msg.sender];
1394         require(user.amount >= _amount, "withdraw: not good");
1395         updatePool(_pid);
1396         uint256 pending = user.amount.mul(pool.accMETHPerShare).div(1e12).sub(user.rewardDebt);
1397         if(pending > 0) {
1398             safeMethTransfer(msg.sender, pending);
1399         }
1400         if(_amount > 0) {
1401             user.amount = user.amount.sub(_amount);
1402             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1403         }
1404         user.rewardDebt = user.amount.mul(pool.accMETHPerShare).div(1e12);
1405         emit Withdraw(msg.sender, _pid, _amount);
1406         
1407     }
1408 
1409     // Withdraw without caring about rewards. EMERGENCY ONLY.
1410     function emergencyWithdraw(uint256 _pid) public {
1411         PoolInfo storage pool = poolInfo[_pid];
1412         UserInfo storage user = userInfo[_pid][msg.sender];
1413         uint256 amount = user.amount;
1414         user.amount = 0;
1415         user.rewardDebt = 0;
1416         pool.lpToken.safeTransfer(address(msg.sender), amount);
1417         emit EmergencyWithdraw(msg.sender, _pid, amount);
1418     }
1419 
1420     // Safe METH transfer function, just in case if rounding error causes pool to not have enough METHs.
1421     function safeMethTransfer(address _to, uint256 _amount) internal {
1422         uint256 MethBal = METH.balanceOf(address(this));
1423         if (_amount > MethBal) {
1424             METH.transfer(_to, MethBal);
1425         } else {
1426             METH.transfer(_to, _amount);
1427         }
1428     }
1429 
1430     // Update dev address by the previous dev.
1431     function dev(address _devaddr) public {
1432         require(msg.sender == devaddr, "dev: wut?");
1433         devaddr = _devaddr;
1434     }
1435 }