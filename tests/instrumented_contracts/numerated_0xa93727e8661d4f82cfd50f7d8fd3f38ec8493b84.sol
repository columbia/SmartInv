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
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies in extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
386 
387 
388 pragma solidity ^0.6.0;
389 
390 
391 
392 
393 /**
394  * @title SafeERC20
395  * @dev Wrappers around ERC20 operations that throw on failure (when the token
396  * contract returns false). Tokens that return no value (and instead revert or
397  * throw on failure) are also supported, non-reverting calls are assumed to be
398  * successful.
399  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
400  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
401  */
402 library SafeERC20 {
403     using SafeMath for uint256;
404     using Address for address;
405 
406     function safeTransfer(IERC20 token, address to, uint256 value) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
408     }
409 
410     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
412     }
413 
414     /**
415      * @dev Deprecated. This function has issues similar to the ones found in
416      * {IERC20-approve}, and its usage is discouraged.
417      *
418      * Whenever possible, use {safeIncreaseAllowance} and
419      * {safeDecreaseAllowance} instead.
420      */
421     function safeApprove(IERC20 token, address spender, uint256 value) internal {
422         // safeApprove should only be called when setting an initial allowance,
423         // or when resetting it to zero. To increase and decrease it, use
424         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
425         // solhint-disable-next-line max-line-length
426         require((value == 0) || (token.allowance(address(this), spender) == 0),
427             "SafeERC20: approve from non-zero to non-zero allowance"
428         );
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
430     }
431 
432     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).add(value);
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     /**
443      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
444      * on the return value: the return value is optional (but if data is returned, it must not be false).
445      * @param token The token targeted by the call.
446      * @param data The call data (encoded using abi.encode or one of its variants).
447      */
448     function _callOptionalReturn(IERC20 token, bytes memory data) private {
449         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
450         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
451         // the target address contains contract code and also asserts for success in the low-level call.
452 
453         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
454         if (returndata.length > 0) { // Return data is optional
455             // solhint-disable-next-line max-line-length
456             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/GSN/Context.sol
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
487 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
488 
489 
490 pragma solidity ^0.6.0;
491 
492 
493 
494 
495 
496 /**
497  * @dev Implementation of the {IERC20} interface.
498  *
499  * This implementation is agnostic to the way tokens are created. This means
500  * that a supply mechanism has to be added in a derived contract using {_mint}.
501  * For a generic mechanism see {ERC20PresetMinterPauser}.
502  *
503  * TIP: For a detailed writeup see our guide
504  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
505  * to implement supply mechanisms].
506  *
507  * We have followed general OpenZeppelin guidelines: functions revert instead
508  * of returning `false` on failure. This behavior is nonetheless conventional
509  * and does not conflict with the expectations of ERC20 applications.
510  *
511  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
512  * This allows applications to reconstruct the allowance for all accounts just
513  * by listening to said events. Other implementations of the EIP may not emit
514  * these events, as it isn't required by the specification.
515  *
516  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
517  * functions have been added to mitigate the well-known issues around setting
518  * allowances. See {IERC20-approve}.
519  */
520 contract ERC20 is Context, IERC20 {
521     using SafeMath for uint256;
522     using Address for address;
523 
524     mapping (address => uint256) private _balances;
525 
526     mapping (address => mapping (address => uint256)) private _allowances;
527 
528     uint256 private _totalSupply;
529 
530     string private _name;
531     string private _symbol;
532     uint8 private _decimals;
533 
534     /**
535      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
536      * a default value of 18.
537      *
538      * To select a different value for {decimals}, use {_setupDecimals}.
539      *
540      * All three of these values are immutable: they can only be set once during
541      * construction.
542      */
543     constructor (string memory name, string memory symbol) public {
544         _name = name;
545         _symbol = symbol;
546         _decimals = 18;
547     }
548 
549     /**
550      * @dev Returns the name of the token.
551      */
552     function name() public view returns (string memory) {
553         return _name;
554     }
555 
556     /**
557      * @dev Returns the symbol of the token, usually a shorter version of the
558      * name.
559      */
560     function symbol() public view returns (string memory) {
561         return _symbol;
562     }
563 
564     /**
565      * @dev Returns the number of decimals used to get its user representation.
566      * For example, if `decimals` equals `2`, a balance of `505` tokens should
567      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
568      *
569      * Tokens usually opt for a value of 18, imitating the relationship between
570      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
571      * called.
572      *
573      * NOTE: This information is only used for _display_ purposes: it in
574      * no way affects any of the arithmetic of the contract, including
575      * {IERC20-balanceOf} and {IERC20-transfer}.
576      */
577     function decimals() public view returns (uint8) {
578         return _decimals;
579     }
580 
581     /**
582      * @dev See {IERC20-totalSupply}.
583      */
584     function totalSupply() public view override returns (uint256) {
585         return _totalSupply;
586     }
587 
588     /**
589      * @dev See {IERC20-balanceOf}.
590      */
591     function balanceOf(address account) public view override returns (uint256) {
592         return _balances[account];
593     }
594 
595     /**
596      * @dev See {IERC20-transfer}.
597      *
598      * Requirements:
599      *
600      * - `recipient` cannot be the zero address.
601      * - the caller must have a balance of at least `amount`.
602      */
603     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
604         _transfer(_msgSender(), recipient, amount);
605         return true;
606     }
607 
608     /**
609      * @dev See {IERC20-allowance}.
610      */
611     function allowance(address owner, address spender) public view virtual override returns (uint256) {
612         return _allowances[owner][spender];
613     }
614 
615     /**
616      * @dev See {IERC20-approve}.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      */
622     function approve(address spender, uint256 amount) public virtual override returns (bool) {
623         _approve(_msgSender(), spender, amount);
624         return true;
625     }
626 
627     /**
628      * @dev See {IERC20-transferFrom}.
629      *
630      * Emits an {Approval} event indicating the updated allowance. This is not
631      * required by the EIP. See the note at the beginning of {ERC20};
632      *
633      * Requirements:
634      * - `sender` and `recipient` cannot be the zero address.
635      * - `sender` must have a balance of at least `amount`.
636      * - the caller must have allowance for ``sender``'s tokens of at least
637      * `amount`.
638      */
639     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
640         _transfer(sender, recipient, amount);
641         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
642         return true;
643     }
644 
645     /**
646      * @dev Atomically increases the allowance granted to `spender` by the caller.
647      *
648      * This is an alternative to {approve} that can be used as a mitigation for
649      * problems described in {IERC20-approve}.
650      *
651      * Emits an {Approval} event indicating the updated allowance.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      */
657     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
658         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
659         return true;
660     }
661 
662     /**
663      * @dev Atomically decreases the allowance granted to `spender` by the caller.
664      *
665      * This is an alternative to {approve} that can be used as a mitigation for
666      * problems described in {IERC20-approve}.
667      *
668      * Emits an {Approval} event indicating the updated allowance.
669      *
670      * Requirements:
671      *
672      * - `spender` cannot be the zero address.
673      * - `spender` must have allowance for the caller of at least
674      * `subtractedValue`.
675      */
676     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
677         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
678         return true;
679     }
680 
681     /**
682      * @dev Moves tokens `amount` from `sender` to `recipient`.
683      *
684      * This is internal function is equivalent to {transfer}, and can be used to
685      * e.g. implement automatic token fees, slashing mechanisms, etc.
686      *
687      * Emits a {Transfer} event.
688      *
689      * Requirements:
690      *
691      * - `sender` cannot be the zero address.
692      * - `recipient` cannot be the zero address.
693      * - `sender` must have a balance of at least `amount`.
694      */
695     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
696         require(sender != address(0), "ERC20: transfer from the zero address");
697         require(recipient != address(0), "ERC20: transfer to the zero address");
698 
699         _beforeTokenTransfer(sender, recipient, amount);
700 
701         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
702         _balances[recipient] = _balances[recipient].add(amount);
703         emit Transfer(sender, recipient, amount);
704     }
705 
706     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
707      * the total supply.
708      *
709      * Emits a {Transfer} event with `from` set to the zero address.
710      *
711      * Requirements
712      *
713      * - `to` cannot be the zero address.
714      */
715     function _mint(address account, uint256 amount) internal virtual {
716         require(account != address(0), "ERC20: mint to the zero address");
717 
718         _beforeTokenTransfer(address(0), account, amount);
719 
720         _totalSupply = _totalSupply.add(amount);
721         _balances[account] = _balances[account].add(amount);
722         emit Transfer(address(0), account, amount);
723     }
724 
725     /**
726      * @dev Destroys `amount` tokens from `account`, reducing the
727      * total supply.
728      *
729      * Emits a {Transfer} event with `to` set to the zero address.
730      *
731      * Requirements
732      *
733      * - `account` cannot be the zero address.
734      * - `account` must have at least `amount` tokens.
735      */
736     function _burn(address account, uint256 amount) internal virtual {
737         require(account != address(0), "ERC20: burn from the zero address");
738 
739         _beforeTokenTransfer(account, address(0), amount);
740 
741         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
742         _totalSupply = _totalSupply.sub(amount);
743         emit Transfer(account, address(0), amount);
744     }
745 
746     /**
747      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
748      *
749      * This internal function is equivalent to `approve`, and can be used to
750      * e.g. set automatic allowances for certain subsystems, etc.
751      *
752      * Emits an {Approval} event.
753      *
754      * Requirements:
755      *
756      * - `owner` cannot be the zero address.
757      * - `spender` cannot be the zero address.
758      */
759     function _approve(address owner, address spender, uint256 amount) internal virtual {
760         require(owner != address(0), "ERC20: approve from the zero address");
761         require(spender != address(0), "ERC20: approve to the zero address");
762 
763         _allowances[owner][spender] = amount;
764         emit Approval(owner, spender, amount);
765     }
766 
767     /**
768      * @dev Sets {decimals} to a value other than the default one of 18.
769      *
770      * WARNING: This function should only be called from the constructor. Most
771      * applications that interact with token contracts will not expect
772      * {decimals} to ever change, and may work incorrectly if it does.
773      */
774     function _setupDecimals(uint8 decimals_) internal {
775         _decimals = decimals_;
776     }
777 
778     /**
779      * @dev Hook that is called before any transfer of tokens. This includes
780      * minting and burning.
781      *
782      * Calling conditions:
783      *
784      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
785      * will be to transferred to `to`.
786      * - when `from` is zero, `amount` tokens will be minted for `to`.
787      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
788      * - `from` and `to` are never both zero.
789      *
790      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
791      */
792     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
793 }
794 
795 // File: contracts/interfaces/flamincome/Strategy.sol
796 
797 pragma solidity ^0.6.2;
798 
799 interface Strategy {
800     function want() external view returns (address);
801     function deposit() external;
802     function withdraw(address) external;
803     function withdraw(uint) external;
804     function withdraw(address, uint) external;
805     function withdrawAll() external returns (uint);
806     function balanceOf() external view returns (uint);
807     function balanceOfY() external view returns (uint);
808 }
809 
810 // File: contracts/implementations/vault/VaultX.sol
811 
812 pragma solidity ^0.6.2;
813 
814 
815 
816 
817 
818 
819 
820 
821 contract VaultX is ERC20 {
822     using SafeERC20 for IERC20;
823     using Address for address;
824     using SafeMath for uint256;
825 
826     IERC20 public token;
827 
828     address public governance;
829     address public strategy;
830 
831     constructor (address _token, address _strategy) public ERC20(
832         string(abi.encodePacked("CROSS FLAMINCOME ", ERC20(_token).name())),
833         string(abi.encodePacked("X", ERC20(_token).symbol()))
834     ) {
835         _setupDecimals(ERC20(_token).decimals());
836         token = IERC20(_token);
837         governance = msg.sender;
838         strategy = _strategy;
839     }
840 
841     function setGovernance(address _governance) public {
842         require(msg.sender == governance, "!governance");
843         governance = _governance;
844     }
845 
846     function setStrategy(address _strategy) public {
847         require(msg.sender == governance || msg.sender == strategy, "!governance");
848         strategy = _strategy;
849     }
850 
851     function depositAll() public {
852         deposit(token.balanceOf(msg.sender));
853     }
854 
855     function deposit(uint _amount) public {
856         token.safeTransferFrom(msg.sender, address(this), _amount);
857         _mint(msg.sender, _amount);
858         token.safeTransfer(strategy, token.balanceOf(address(this))); // earn
859     }
860 
861     function withdrawAll() public {
862         withdraw(balanceOf(msg.sender));
863     }
864 
865     function withdraw(uint _shares) public {
866         _burn(msg.sender, _shares);
867         Strategy(strategy).withdraw(msg.sender, _shares);
868     }
869 
870     function pika(address _token, uint _amount) public {
871         require(msg.sender == governance, "!governance");
872         IERC20(_token).safeTransfer(governance, _amount);
873     }
874 }
875 
876 // File: contracts/instances/VaultXUSDT.sol
877 
878 pragma solidity ^0.6.2;
879 
880 
881 contract VaultXUSDT is VaultX {
882     constructor(address _strategy)
883         public
884         VaultX(
885             address(0xdAC17F958D2ee523a2206206994597C13D831ec7), // https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7
886             _strategy
887         )
888     {}
889 }